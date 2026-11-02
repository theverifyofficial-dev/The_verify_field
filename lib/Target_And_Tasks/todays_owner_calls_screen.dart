import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/main.dart' show navigatorKey;
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Future_property_details.dart';

import 'models/owner_call_due.dart';
import 'services/owner_call_service.dart';
import 'services/target_service.dart';
import 'widgets/owner_call_outcome_chip.dart';

/// "Today's Owner Calls" -- 2026-10-30, new screen requested as a clone of
/// `OwnerCallsDetailScreen`'s due-calls list/card/call-logging flow, scoped
/// to one date at a time via the new `todays_calls.php` endpoint (rather
/// than `due_calls.php`'s undated full backlog). Defaults to today on open
/// (hence the screen's name), but a date picker (2026-10-31, follow-up
/// request) lets the field worker re-run the same API against any other
/// date -- see `_pickDate`.
///
/// Reached from `target_and_tasks_home.dart`'s Target & Tasks home screen
/// via a new standalone entry-point button, alongside (not replacing) the
/// existing "Owner Calls" gradient button that opens `OwnerCallsDetailScreen`.
///
/// Everything below -- `_callOwner`, `_logCall`, the
/// `didChangeAppLifecycleState` resume-and-auto-open-dialog handoff, and the
/// due-call card markup -- is deliberately kept as a close copy of
/// `OwnerCallsDetailScreen`'s own implementation (not the separate,
/// `AgentTask`-based `OwnerCallCard` widget, which is a different list on a
/// different screen) so this screen behaves identically to the one field
/// workers already know, per the explicit "clone the field-worker due-calls
/// card" instruction. The monthly-quota progress card that screen shows is
/// intentionally NOT duplicated here -- this screen is a day-scoped list,
/// not another place to track the same monthly target -- but logging a call
/// from here still increments the same `TargetService.monthlyOwnerCallsKey()`
/// counter that screen's quota reads, so the monthly count stays accurate
/// regardless of which screen was used to log the call.
class TodaysOwnerCallsScreen extends StatefulWidget {
  final String fieldWorkerNumber;
  final String fieldWorkerName;

  const TodaysOwnerCallsScreen({
    super.key,
    required this.fieldWorkerNumber,
    required this.fieldWorkerName,
  });

  @override
  State<TodaysOwnerCallsScreen> createState() => _TodaysOwnerCallsScreenState();
}

class _TodaysOwnerCallsScreenState extends State<TodaysOwnerCallsScreen> with WidgetsBindingObserver {
  final _service = OwnerCallService();
  bool _loading = true;
  List<OwnerCallDue> _calls = [];

  // Same stale-response guard as `OwnerCallsDetailScreen`/`target_and_tasks_home.dart`.
  int _requestId = 0;

  // Same "call, then auto-open the outcome dialog on return" handoff as
  // `OwnerCallsDetailScreen`'s `_pendingCall`/`didChangeAppLifecycleState`.
  OwnerCallDue? _pendingCall;

  // Same reentrancy guard as `OwnerCallsDetailScreen`'s `_logCallDialogOpen`.
  bool _logCallDialogOpen = false;

  // 2026-10-31, new: which date `todays_calls.php` is queried for. Starts
  // on today (matching the screen's original "always today" behavior) but
  // is now changeable via `_pickDate`.
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingCall != null) {
      final call = _pendingCall!;
      _pendingCall = null;
      // Same fix, same reason, as `OwnerCallsDetailScreen`'s
      // `didChangeAppLifecycleState` (see its doc comment) -- wait a frame,
      // then a further beat, then open on the app's root Navigator context
      // instead of this screen's own `context`.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        final rootContext = navigatorKey.currentContext;
        if (rootContext == null || !rootContext.mounted) return;
        _logCall(rootContext, call);
      });
    }
  }

  // yyyy-MM-dd, matching the user-provided example (`date=2026-11-07`) --
  // no `intl` package is used elsewhere in this folder, so this is manual
  // zero-padded formatting rather than a new dependency. Shared by both
  // the API call and the on-screen date label.
  static String _formatDate(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  // dd/MM/yyyy -- a friendlier display format than the API's yyyy-MM-dd,
  // shown next to the date-picker button.
  static String _displayDate(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  Future<void> _load() async {
    final requestId = ++_requestId;
    setState(() => _loading = true);
    final calls = await _service.fetchTodaysCallsResolved(
      fieldWorkerNumber: widget.fieldWorkerNumber,
      date: _formatDate(_selectedDate),
    );
    if (!mounted || requestId != _requestId) return;
    setState(() {
      _calls = calls;
      _loading = false;
    });
  }

  /// 2026-10-31, new: lets the field worker re-run `todays_calls.php`
  /// against any date, not just today -- the screen still opens on
  /// today's date by default (`_selectedDate`'s initial value), this just
  /// adds a way to change it. Mirrors the date-picker pattern
  /// `Admin_Target_And_Tasks/admin_target_and_tasks_home.dart`'s
  /// `_pickDate` already uses elsewhere in this project (plain
  /// `showDatePicker`, no custom theming).
  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (picked == null || !mounted) return;
    setState(() => _selectedDate = picked);
    _load();
  }

  /// Mirrors `OwnerCallsDetailScreen._callOwner` exactly.
  Future<void> _callOwner(OwnerCallDue call, String ownerNumber) async {
    final number = ownerNumber.replaceAll(RegExp(r'[^0-9+]'), '');
    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number on file for this owner.')),
      );
      return;
    }
    _pendingCall = call;
    final launched = await launchUrl(Uri(scheme: 'tel', path: number));
    if (!launched) {
      _pendingCall = null;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the dialer.")),
      );
    }
  }

  /// Mirrors `OwnerCallsDetailScreen._logCall` exactly, including the
  /// monthly-quota counter increment on a successful submit (see this
  /// class's doc comment for why that counter is still kept in sync even
  /// though this screen doesn't display it).
  Future<void> _logCall(BuildContext context, OwnerCallDue call) async {
    if (_logCallDialogOpen) return;
    if (!context.mounted) return;
    _logCallDialogOpen = true;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String status = 'Answered';
    final notesController = TextEditingController();
    bool submitting = false;

    try {
      await showDialog(
        context: context,
        builder: (dialogContext) {
          return StatefulBuilder(builder: (dialogContext, setDialogState) {
            return WillPopScope(
              onWillPop: () async => !submitting,
              child: AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                title: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2F6FED), Color(0xFF5B8DEF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: const Icon(Icons.call_rounded, color: Colors.white, size: 17),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        call.ownerName.isNotEmpty ? call.ownerName : 'Call building owner',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
                content: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(dialogContext).size.height * 0.7),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (call.buildingAddress.isNotEmpty)
                          Text(call.buildingAddress,
                              style: TextStyle(
                                  color: isDark ? Colors.white60 : Colors.black54, fontSize: 13)),
                        const SizedBox(height: 14),
                        Text('Call outcome',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                                color: isDark ? Colors.white54 : Colors.black45)),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OwnerCallOutcomeChip(
                                label: 'Answered',
                                icon: Icons.check_circle_rounded,
                                color: const Color(0xFF2E9E5B),
                                selected: status == 'Answered',
                                enabled: !submitting,
                                isDark: isDark,
                                onTap: () => setDialogState(() => status = 'Answered'),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OwnerCallOutcomeChip(
                                label: 'Not Answered',
                                icon: Icons.cancel_rounded,
                                color: const Color(0xFFD9534F),
                                selected: status == 'Not Answered',
                                enabled: !submitting,
                                isDark: isDark,
                                onTap: () => setDialogState(() => status = 'Not Answered'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text('Notes',
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                                color: isDark ? Colors.white54 : Colors.black45)),
                        const SizedBox(height: 8),
                        TextField(
                          controller: notesController,
                          maxLines: 3,
                          enabled: !submitting,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            hintText: 'What did the owner say?',
                            isDense: true,
                            filled: true,
                            fillColor: isDark ? const Color(0xFF171B22) : const Color(0xFFF7F9FC),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: submitting ? null : () => Navigator.of(dialogContext).pop(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2F6FED),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: submitting
                        ? null
                        : () async {
                            setDialogState(() => submitting = true);
                            final ok = await _service.submitCall(
                              propertyId: call.propertyId,
                              fieldWorkerName: widget.fieldWorkerName,
                              fieldWorkerNumber: widget.fieldWorkerNumber,
                              status: status,
                              notes: notesController.text.trim(),
                            );
                            if (!dialogContext.mounted) return;
                            if (ok) {
                              final prefs = await SharedPreferences.getInstance();
                              final key = TargetService.monthlyOwnerCallsKey();
                              await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
                              Navigator.of(dialogContext).pop();
                              if (!mounted) return;
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(content: Text('Call logged.')));
                              _load();
                            } else {
                              setDialogState(() => submitting = false);
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                const SnackBar(content: Text("Couldn't log the call. Try again.")),
                              );
                            }
                          },
                    child: submitting
                        ? const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                              ),
                              SizedBox(width: 8),
                              Text('Submitting…'),
                            ],
                          )
                        : const Text('Submit'),
                  ),
                ],
              ),
            );
          });
        },
      );
    } finally {
      _logCallDialogOpen = false;
      notesController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0E1116) : const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Today's Owner Calls"),
        actions: [
          IconButton(
            tooltip: 'Pick a date',
            icon: const Icon(Icons.calendar_month_rounded),
            onPressed: _pickDate,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Calls for ${_displayDate(_selectedDate)} (${_calls.length})',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : Colors.black87)),
                      ),
                      TextButton.icon(
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_month_rounded, size: 16),
                        label: const Text('Change date', style: TextStyle(fontSize: 12.5)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  if (_calls.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 28),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF171B22) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.task_alt_rounded, size: 34, color: isDark ? Colors.white24 : Colors.black26),
                          const SizedBox(height: 8),
                          Text('No owner calls scheduled for this date.',
                              style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white54 : Colors.black45)),
                        ],
                      ),
                    )
                  else
                    ..._calls.map((call) => Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF171B22) : Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Future_Property_details(idd: call.propertyId.toString()),
                                  ),
                                );
                                if (mounted) _load();
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (call.buildingImage.isNotEmpty) ...[
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(11),
                                        child: CachedNetworkImage(
                                          imageUrl: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${call.buildingImage}",
                                          height: 120,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                          placeholder: (_, __) => Container(
                                            height: 120,
                                            alignment: Alignment.center,
                                            color: isDark ? const Color(0xFF1B2029) : const Color(0xFFF1F4F9),
                                            child: const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          ),
                                          errorWidget: (_, __, ___) => Container(
                                            height: 120,
                                            alignment: Alignment.center,
                                            color: isDark ? const Color(0xFF1B2029) : const Color(0xFFF1F4F9),
                                            child: Icon(Icons.broken_image_outlined,
                                                color: isDark ? Colors.white24 : Colors.black26, size: 26),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                    Row(
                                      children: [
                                        Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                              color: const Color(0xFF2F6FED).withOpacity(0.14),
                                              shape: BoxShape.circle),
                                          child: const Icon(Icons.apartment_rounded,
                                              color: Color(0xFF2F6FED), size: 19),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                call.ownerName.isNotEmpty ? call.ownerName : 'Building owner',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 13.5,
                                                    color: isDark ? Colors.white : Colors.black87),
                                              ),
                                              if (call.buildingAddress.isNotEmpty || call.reason != null) ...[
                                                const SizedBox(height: 2),
                                                Text(
                                                  call.buildingAddress.isNotEmpty
                                                      ? call.buildingAddress
                                                      : (call.reason ?? ''),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 11.5,
                                                      color: isDark ? Colors.white60 : Colors.black54),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Material(
                                          color: const Color(0xFF2F6FED),
                                          shape: const CircleBorder(),
                                          child: InkWell(
                                            customBorder: const CircleBorder(),
                                            onTap: () => _callOwner(call, call.ownerNumber),
                                            child: const Padding(
                                              padding: EdgeInsets.all(10),
                                              child: Icon(Icons.call_rounded, color: Colors.white, size: 19),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )),
                ],
              ),
      ),
    );
  }
}
