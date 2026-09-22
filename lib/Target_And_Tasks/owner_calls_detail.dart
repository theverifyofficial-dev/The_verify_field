import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/main.dart' show navigatorKey;
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Future_property_details.dart';

import 'models/owner_call_due.dart';
import 'models/owner_call_history.dart';
import 'services/owner_call_service.dart';
import 'services/target_service.dart';
import 'widgets/owner_call_outcome_chip.dart';

/// Detail screen behind the Target section's "Owner Calls" quota card.
///
/// There is no dedicated "owner calls" screen in the original app to
/// reuse here — the old `building_calling_reminder.php` reminder only ever
/// showed up as a card inside the calendar/task list, never its own
/// screen — so this is new UI. Redesigned (2026-09-18) to match the
/// one-tap-call pattern `OwnerCallCard`/`target_and_tasks_home.dart` use
/// for the Tasks screen's own owner-calling section, rather than the
/// "Log call" button this screen originally had, which required manually
/// dialing the owner elsewhere first — the whole point of the redesign
/// was removing that extra step.
///
/// See `target_and_tasks_home.dart`'s "Owner calling" section and this
/// package's README for why the quota's "done" count is a local,
/// per-device `SharedPreferences` counter rather than a server count —
/// the redesign spec's API pair has no endpoint for that.
class OwnerCallsDetailScreen extends StatefulWidget {
  final String fieldWorkerNumber;
  final String fieldWorkerName;

  const OwnerCallsDetailScreen({
    super.key,
    required this.fieldWorkerNumber,
    required this.fieldWorkerName,
  });

  @override
  State<OwnerCallsDetailScreen> createState() => _OwnerCallsDetailScreenState();
}

class _OwnerCallsDetailScreenState extends State<OwnerCallsDetailScreen> with WidgetsBindingObserver {
  final _service = OwnerCallService();
  bool _loading = true;
  List<OwnerCallDue> _due = [];
  int _doneThisMonth = 0;

  // Bumped on every `_load()` call; a response is only applied if its
  // captured id still matches when the await resolves — same
  // stale-response guard as `target_and_tasks_home.dart`'s
  // `_loadTargets`/`_loadTasks`, needed here for the same reason (a
  // pull-to-refresh fired while an earlier load was still in flight could
  // otherwise let the older one win).
  int _requestId = 0;

  // Same "call, then auto-open the outcome dialog on return" handoff as
  // `target_and_tasks_home.dart`'s `_callOwner`/`didChangeAppLifecycleState`
  // — kept in sync with that screen's redesign rather than left as the
  // older "tap Log call, dial separately" flow.
  OwnerCallDue? _pendingCall;

  /// Guards `_logCall` against being opened a second time while it's
  /// already showing — same reasoning, and same fix for the same class
  /// of framework-level Overlay/InheritedElement race, as
  /// `target_and_tasks_home.dart`'s `_ownerCallSheetOpen`.
  bool _logCallDialogOpen = false;

  // NOT `const`: indexing into a map with `[]` is a regular method
   // call, not a constant expression, even when the map itself is
   // `const` — `static const ...Map['key']` does not compile. `final` plus
   // a fallback default (in case this key is ever renamed/removed from
   // `TargetService.monthlyTargets`) is what actually works here.
  final int _monthlyTarget = TargetService.monthlyTargets['Owner Calls'] ?? 20;

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
      // Same fix as `target_and_tasks_home.dart`'s `didChangeAppLifecycleState`
      // (see its doc comment for the full explanation): a single
      // post-frame callback still lands in the same window as other
      // resume-triggered top-level rebuilds (`main.dart`'s theme switcher
      // / connectivity listener), and showing a new dialog while one of
      // those is mid-rebuild is what produces a framework-level
      // "'_dependents.isEmpty': is not true" crash on `ThemeSwitcher`.
      // Wait a frame, then a further beat, then open on the app's single
      // root Navigator context (`navigatorKey`, from `main.dart`) instead
      // of this screen's own `context`.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        final rootContext = navigatorKey.currentContext;
        if (rootContext == null || !rootContext.mounted) return;
        _logCall(rootContext, call);
      });
    }
  }

  // Uses `TargetService`'s shared key generators (added 2026-09-21
  // alongside the Tasks screen's new Today/Week tabs) rather than a
  // hand-rolled monthly-only key, so a call logged from this screen keeps
  // the daily/weekly counters in sync too -- see the increment site below
  // and `TargetService.monthlyOwnerCallsKey`'s doc comment.
  static String _monthKey() => TargetService.monthlyOwnerCallsKey();

  Future<void> _load() async {
    final requestId = ++_requestId;
    setState(() => _loading = true);
    final prefs = await SharedPreferences.getInstance();
    final due = await _service.fetchDueCallsResolved(fieldWorkerNumber: widget.fieldWorkerNumber);
    if (!mounted || requestId != _requestId) return;
    setState(() {
      _due = due;
      _doneThisMonth = prefs.getInt(_monthKey()) ?? 0;
      _loading = false;
    });
  }

  /// Opens the phone dialer for `ownerNumber` and marks `call` pending —
  /// mirrors `target_and_tasks_home.dart`'s `_callOwner` exactly, right
  /// down to taking the number as an explicit parameter from the caller
  /// (see the call site below) rather than re-reading `call.ownerNumber`
  /// itself, and the "no usable number" message, which is what field
  /// workers were actually hitting before `OwnerCallDue`'s key list and
  /// the building-details fallback lookup were fixed (see
  /// `OwnerCallService.fetchOwnerNumberFallback`'s doc comment).
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

  /// Dialog: shows which owner/building this call is for, an outcome
  /// choice (Answered / Not Answered), and a notes field. Mirrors
  /// `target_and_tasks_home.dart`'s `_openOwnerCallSheet` UI language
  /// (the shared `OwnerCallOutcomeChip`, disabled inputs while
  /// submitting, a "Submitting…" label next to the loader) and its
  /// crash fix (see `_logCallDialogOpen`'s doc comment and
  /// `didChangeAppLifecycleState` above) — kept as a dialog rather than
  /// converted to a bottom sheet, since that's the shape this screen's
  /// own list already uses and nothing asked for it to change.
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
            // Blocks the back gesture/button while a submit is in
            // flight, so a slow network call can't silently lose the
            // outcome the field worker just entered.
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
      // Was never disposed before this pass — a `TextEditingController`
      // leak on every dialog opened, whether submitted or just cancelled.
      notesController.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = _monthlyTarget <= 0 ? 0.0 : (_doneThisMonth / _monthlyTarget).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0E1116) : const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Owner Calls'),
        actions: [
          IconButton(
            tooltip: 'Call history',
            icon: const Icon(Icons.history_rounded),
            onPressed: () => _showCallHistory(context),
          ),
        ],
      ),      body: RefreshIndicator(
        onRefresh: _load,
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Progress summary card — same gradient family as
                  // `OwnerCallCard` so this screen reads as the same
                  // feature as the Tasks screen's owner-calling section,
                  // not a bolted-on separate tool.
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF162238), const Color(0xFF122032)]
                            : [const Color(0xFFEAF1FF), const Color(0xFFE7F6FB)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFF2F6FED).withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration:
                                  const BoxDecoration(color: Color(0x1F2F6FED), shape: BoxShape.circle),
                              child: const Icon(Icons.call_rounded, color: Color(0xFF2F6FED), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Text('Logged this month',
                                style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w600,
                                    color: isDark ? Colors.white70 : Colors.black87)),
                            const Spacer(),
                            Text('$_doneThisMonth',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2F6FED))),
                            Padding(
                              padding: const EdgeInsets.only(left: 4, top: 8),
                              child: Text('/ $_monthlyTarget',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: isDark ? Colors.white38 : Colors.black45)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: isDark ? Colors.white12 : Colors.black.withOpacity(0.06),
                            valueColor: const AlwaysStoppedAnimation(Color(0xFF2F6FED)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text('Due now (${_due.length})',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white70 : Colors.black87)),
                  const SizedBox(height: 10),
                  if (_due.isEmpty)
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
                          Text('No owner calls due right now.',
                              style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white54 : Colors.black45)),
                        ],
                      ),
                    )
                  else
                    ..._due.map((call) => Container(
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
                                    // Building photo, when `due_calls.php`
                                    // provided one for this record (see
                                    // `OwnerCallDue.buildingImage`'s doc
                                    // comment) -- added 2026-09-21 per
                                    // explicit request. This is the actual
                                    // due-calls card this screen shows (not
                                    // the separate, currently-unused
                                    // `OwnerCallCard` widget), so this is
                                    // where the photo belongs.
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

  Future<void> _showCallHistory(BuildContext context) async {
    bool loading = true;
    List<OwnerCallHistory> history = [];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            if (loading) {
              _service
                  .fetchCallHistory(
                fieldWorkerNumber: widget.fieldWorkerNumber,
              )
                  .then((data) {
                if (!sheetContext.mounted) return;

                setSheetState(() {
                  history = data;
                  loading = false;
                });
              });
            }

            return Container(
              height: MediaQuery.of(sheetContext).size.height * 0.82,
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF10141B)
                    : const Color(0xFFF4F6FA),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  // Handle
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white24
                          : Colors.black12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: Row(
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: const Color(0xFF2F6FED)
                                .withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.history_rounded,
                            color: Color(0xFF2F6FED),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Call History',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                  color: isDark
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                loading
                                    ? 'Loading...'
                                    : '${history.length} calls',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark
                                      ? Colors.white54
                                      : Colors.black45,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () =>
                              Navigator.pop(sheetContext),
                          icon: const Icon(Icons.close_rounded),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Expanded(
                    child: loading
                        ? const Center(
                      child: CircularProgressIndicator(),
                    )
                        : history.isEmpty
                        ? _callHistoryEmptyState(isDark)
                        : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        4,
                        16,
                        24,
                      ),
                      itemCount: history.length,
                      separatorBuilder: (_, __) =>
                      const SizedBox(height: 8),
                      itemBuilder: (_, index) {
                        return _callHistoryCard(
                          history[index],
                          isDark,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _callHistoryCard(
      OwnerCallHistory call,
      bool isDark,
      ) {
    final answered =
        call.status.toLowerCase() == 'answered';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF171B22)
            : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: isDark
              ? const Color(0xFF2A3040)
              : const Color(0xFFDDE3EC),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Building photo, when `call_history.php` provided one for this
          // record (see `OwnerCallHistory.buildingImage`'s doc comment) --
          // added 2026-09-21 per explicit request. Skipped entirely when
          // empty rather than showing a placeholder box, since most
          // historical records won't have this field until the backend
          // starts sending it consistently.
          if (call.buildingImage.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: call.buildingImage,
                height: 130,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 130,
                  alignment: Alignment.center,
                  color: isDark ? const Color(0xFF1B2029) : const Color(0xFFF1F4F9),
                  child: const SizedBox(
                    height: 26,
                    width: 26,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  height: 130,
                  alignment: Alignment.center,
                  color: isDark ? const Color(0xFF1B2029) : const Color(0xFFF1F4F9),
                  child: Icon(Icons.broken_image_outlined,
                      color: isDark ? Colors.white24 : Colors.black26, size: 28),
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
                  color: answered
                      ? const Color(0xFF2E9E5B)
                      .withOpacity(0.12)
                      : const Color(0xFFD9534F)
                      .withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  answered
                      ? Icons.check_circle_rounded
                      : Icons.call_missed_rounded,
                  color: answered
                      ? const Color(0xFF2E9E5B)
                      : const Color(0xFFD9534F),
                  size: 20,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property #${call.propertyId}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatCallDate(call.callDate),
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark
                            ? Colors.white54
                            : Colors.black45,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: answered
                      ? const Color(0xFF2E9E5B)
                      .withOpacity(0.12)
                      : const Color(0xFFD9534F)
                      .withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  call.status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: answered
                        ? const Color(0xFF2E9E5B)
                        : const Color(0xFFD9534F),
                  ),
                ),
              ),
            ],
          ),

          if (call.fieldWorkerName.isNotEmpty) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(
                  Icons.person_outline_rounded,
                  size: 15,
                  color: isDark
                      ? Colors.white38
                      : Colors.black38,
                ),
                const SizedBox(width: 5),
                Text(
                  '${call.fieldWorkerName} • ${call.fieldWorkerNumber}',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: isDark
                        ? Colors.white54
                        : Colors.black54,
                  ),
                ),
              ],
            ),
          ],

          if (call.notes.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.04)
                    : const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                call.notes,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.35,
                  color: isDark
                      ? Colors.white70
                      : Colors.black45,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _callHistoryEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 48,
              color: isDark
                  ? Colors.white24
                  : Colors.black26,
            ),
            const SizedBox(height: 12),
            Text(
              'No call history',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: isDark
                    ? Colors.white70
                    : Colors.black87,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Call records will appear here.',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? Colors.white38
                    : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatCallDate(DateTime? date) {
    if (date == null) return '';

    final local = date.toLocal();

    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year;

    final hour = local.hour % 12 == 0
        ? 12
        : local.hour % 12;

    final minute =
    local.minute.toString().padLeft(2, '0');

    final period = local.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year • $hour:$minute $period';
  }
}
