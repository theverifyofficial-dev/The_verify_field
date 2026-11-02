import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

import '../Target_And_Tasks/models/owner_call_due.dart';
import '../Target_And_Tasks/services/owner_call_service.dart';
import '../Field_Workers/field_worker_directory.dart';

/// Admin-side "Today's Owner Calls" view -- 2026-10-31, new screen, built
/// per explicit follow-up request ("also show it to admin") after the
/// field-worker-facing `TodaysOwnerCallsScreen` (date-scoped via the new
/// `todays_calls.php` endpoint, with its own date picker) was built.
///
/// A close structural clone of the existing `OwnerCallsHistoryScreen`
/// (one section per field worker, collapsed by default, a show/hide
/// toggle arrow, a summary row, a search box) -- same admin visual
/// language, same `FieldWorkerDirectory`-backed roster, same
/// one-API-call-per-worker-via-`Future.wait` loading pattern -- but:
///   - fetches `OwnerCallService.fetchTodaysCallsResolved(fieldWorkerNumber:,
///     date:)` per worker instead of `fetchCallHistory`, so this shows
///     calls DUE for one specific date, not all-time logged history.
///   - has its own date picker (per explicit request: "same date picker
///     as field worker"), defaulting to today, mirroring
///     `TodaysOwnerCallsScreen._pickDate`'s plain `showDatePicker` usage.
///   - is READ-ONLY, same as `OwnerCallsHistoryScreen` -- no call button,
///     no log-outcome dialog. This is an admin visibility screen, not an
///     action screen; the field worker still does the actual calling and
///     logging on their own device.
///   - uses `OwnerCallDue`'s new `currentStatus`/`daysOverdue` getters
///     (added this same pass) since `todays_calls.php`'s real, confirmed
///     response already carries `current_status`/`days_overdue` per
///     record -- unlike `due_calls.php`, whose shape was never confirmed
///     live, so those fields are used here with a plain "no status yet"
///     fallback rather than assumed always-present.
///
/// Reached via a second new icon button on `Targets.dart`'s AppBar,
/// alongside the existing "Building Owner Calls" (history) button --
/// `Targets.dart` itself is otherwise untouched.
class TodaysOwnerCallsAdminScreen extends StatefulWidget {
  const TodaysOwnerCallsAdminScreen({super.key});

  @override
  State<TodaysOwnerCallsAdminScreen> createState() => _TodaysOwnerCallsAdminScreenState();
}

class _TodaysOwnerCallsAdminScreenState extends State<TodaysOwnerCallsAdminScreen> {
  final _service = OwnerCallService();

  /// Loaded from `FieldWorkerDirectory` in `_load()` below -- same live
  /// roster source `OwnerCallsHistoryScreen` already uses, not a
  /// hardcoded/copy-pasted list.
  List<Map<String, String>> allUsers = [];

  bool _loading = true;

  /// One field worker's number -> their fetched today's-calls list for
  /// `_selectedDate`. Populated by firing
  /// `todays_calls.php?fieldworkarnumber=<number>&date=<date>` once per
  /// entry in `allUsers` (in parallel, via `Future.wait`) -- same
  /// resilience pattern as `OwnerCallsHistoryScreen._load`: one worker's
  /// failure doesn't blank the others.
  Map<String, List<OwnerCallDue>> _callsByNumber = {};

  /// Which field workers' sections currently show their call list --
  /// same collapsed-by-default pattern as `OwnerCallsHistoryScreen`.
  final Set<String> _expandedNumbers = {};

  final _searchController = TextEditingController();
  String _query = '';

  // 2026-10-31, new: which date `todays_calls.php` is queried for, same
  // concept as `TodaysOwnerCallsScreen._selectedDate`. Starts on today.
  DateTime _selectedDate = DateTime.now();

  // Same stale-response guard as `OwnerCallsHistoryScreen`/every other
  // screen in this project's Target/Task family.
  int _requestId = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // yyyy-MM-dd, same manual zero-padded formatting as
  // `TodaysOwnerCallsScreen._formatDate`/`_displayDate` (no `intl`
  // package in this codebase).
  static String _formatDate(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  static String _displayDate(DateTime d) {
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

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

  Future<void> _load() async {
    final requestId = ++_requestId;
    setState(() => _loading = true);

    await FieldWorkerDirectory.instance.load();
    allUsers = FieldWorkerDirectory.instance.asMaps;

    final date = _formatDate(_selectedDate);
    final results = <String, List<OwnerCallDue>>{};

    await Future.wait(allUsers.map((u) async {
      final number = u["number"]!;
      try {
        results[number] = await _service.fetchTodaysCallsResolved(
          fieldWorkerNumber: number,
          date: date,
        );
      } catch (_) {
        results[number] = const [];
      }
    }));

    if (!mounted || requestId != _requestId) return;
    setState(() {
      _callsByNumber = results;
      _loading = false;
    });
  }

  /// This worker's calls for `_selectedDate`, filtered by the search box
  /// (by property #, owner name, or address).
  List<OwnerCallDue> _callsFor(String number) {
    final list = _callsByNumber[number] ?? const <OwnerCallDue>[];
    if (_query.isEmpty) return list;
    return list
        .where((c) =>
            c.propertyId.toLowerCase().contains(_query) ||
            c.ownerName.toLowerCase().contains(_query) ||
            c.buildingAddress.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final visible = allUsers.expand((u) => _callsFor(u["number"]!)).toList();
    final total = visible.length;
    final answered = visible.where((c) => c.currentStatus.toLowerCase() == 'answered').length;
    final notAnswered =
        visible.where((c) => c.currentStatus.toLowerCase() == 'not answered').length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
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
            ? Center(child: Image.asset(AppImages.loader, height: 80))
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _screenHeading(isDark),
                  const SizedBox(height: 14),
                  _summaryRow(isDark, total, answered, notAnswered),
                  const SizedBox(height: 14),
                  _searchField(isDark),
                  const SizedBox(height: 18),
                  ...allUsers.map((u) => _workerSection(u, isDark)),
                ],
              ),
      ),
    );
  }

  Widget _screenHeading(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Today's Owner Calls",
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'PoppinsBold',
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        TextButton.icon(
          onPressed: _pickDate,
          icon: const Icon(Icons.calendar_month_rounded, size: 16),
          label: Text(_displayDate(_selectedDate), style: const TextStyle(fontSize: 12.5)),
        ),
      ],
    );
  }

  Widget _summaryRow(bool isDark, int total, int answered, int notAnswered) {
    return Row(
      children: [
        Expanded(child: _statTile(isDark, 'Total due', total, const Color(0xFF135BEC))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(isDark, 'Answered', answered, const Color(0xFF2E9E5B))),
        const SizedBox(width: 10),
        Expanded(child: _statTile(isDark, 'Not answered', notAnswered, const Color(0xFFD9534F))),
      ],
    );
  }

  Widget _statTile(bool isDark, String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(fontSize: 20, fontFamily: 'PoppinsBold', fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'PoppinsMedium',
              color: isDark ? Colors.white54 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField(bool isDark) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search by property #, owner name, or address',
        hintStyle: TextStyle(fontSize: 12.5, color: isDark ? Colors.white38 : Colors.black38),
        prefixIcon: Icon(Icons.search_rounded, color: isDark ? Colors.white38 : Colors.black38),
        suffixIcon: _query.isEmpty
            ? null
            : IconButton(
                icon: Icon(Icons.close_rounded, size: 18, color: isDark ? Colors.white38 : Colors.black38),
                onPressed: () => _searchController.clear(),
              ),
        filled: true,
        fillColor: isDark ? const Color(0xFF171B22) : Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
        ),
      ),
    );
  }

  Widget _workerSection(Map<String, String> user, bool isDark) {
    final number = user["number"]!;
    final calls = _callsFor(number);
    final hasAnyBeforeFilter = (_callsByNumber[number] ?? const []).isNotEmpty;
    final expanded = _expandedNumbers.contains(number);

    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Color(0x1F135BEC), shape: BoxShape.circle),
                child: const Icon(Icons.person_rounded, color: Color(0xFF135BEC), size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user["name"] ?? number,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.5,
                        fontFamily: 'PoppinsBold',
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    Text(
                      number,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'PoppinsMedium',
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF135BEC),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${calls.length}',
                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => setState(() {
                  if (expanded) {
                    _expandedNumbers.remove(number);
                  } else {
                    _expandedNumbers.add(number);
                  }
                }),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: AnimatedRotation(
                    turns: expanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (expanded) ...[
            const SizedBox(height: 10),
            if (calls.isEmpty)
              _sectionEmptyState(isDark, searching: _query.isNotEmpty && hasAnyBeforeFilter)
            else
              ...calls.map((c) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _dueCallCard(c, isDark),
                  )),
          ],
        ],
      ),
    );
  }

  Widget _sectionEmptyState(bool isDark, {required bool searching}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
      ),
      child: Text(
        searching ? 'No calls match your search.' : 'No owner calls due on this date.',
        style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white54 : Colors.black45),
      ),
    );
  }

  Widget _dueCallCard(OwnerCallDue call, bool isDark) {
    final statusLower = call.currentStatus.toLowerCase();
    final answered = statusLower == 'answered';
    final notAnswered = statusLower == 'not answered';
    final hasStatus = answered || notAnswered;
    final statusColor =
        answered ? const Color(0xFF2E9E5B) : (notAnswered ? const Color(0xFFD9534F) : const Color(0xFF8A94A6));

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171B22) : Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (call.buildingImage.isNotEmpty) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: call.buildingImage,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  height: 120,
                  alignment: Alignment.center,
                  color: isDark ? const Color(0xFF1B2029) : const Color(0xFFF1F4F9),
                  child: const SizedBox(
                    height: 24,
                    width: 24,
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
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  answered
                      ? Icons.check_circle_rounded
                      : (notAnswered ? Icons.call_missed_rounded : Icons.call_rounded),
                  color: statusColor,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      call.ownerName.isNotEmpty ? call.ownerName : 'Property #${call.propertyId}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontFamily: 'PoppinsBold',
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    if (call.buildingAddress.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        call.buildingAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  hasStatus ? call.currentStatus : 'Not called yet',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (call.daysOverdue.isNotEmpty && call.daysOverdue != '0') ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 13, color: isDark ? Colors.white38 : Colors.black38),
                const SizedBox(width: 5),
                Text(
                  '${call.daysOverdue} day(s) overdue',
                  style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
