import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

import '../Target_And_Tasks/models/owner_call_history.dart';
import '../Target_And_Tasks/services/owner_call_service.dart';

/// Admin-side "Building Owner Calls" view — one section per field worker,
/// each fetched with its own number-scoped `call_history.php` call, i.e.
/// `GET call_history.php?fieldworkarnumber=<that worker's number>` for
/// every worker in `allUsers`, exactly like the example URL
/// (`...call_history.php?fieldworkarnumber=11`) this was built against.
///
/// This is entirely NEW screen code; nothing on the field-worker side was
/// touched to build it — `OwnerCallService.fetchCallHistory()` and the
/// `OwnerCallHistory` model are the exact same already-working pieces
/// `owner_calls_detail.dart`'s own "Call history" sheet uses for one
/// worker at a time; this screen just calls that same method once per
/// worker instead of once unscoped.
///
/// `allUsers` here is a deliberate copy of `Targets.dart`'s own
/// `allUsers` roster (name/number/location), not a shared reference to
/// it — that field is a private instance field of `_TargetState`, so
/// duplicating the literal list is the only way to use it here without
/// modifying `Targets.dart` beyond the single AppBar entry point. If that
/// roster ever changes, this list needs updating too — same standing
/// "hardcoded roster, not fetched from anywhere" limitation already
/// flagged elsewhere in this codebase (see project memory:
/// `business_logic_targets_roles.md`).
///
/// The one change to existing code, anywhere, is the single "Building
/// Owner Calls" icon button added to `Targets.dart`'s AppBar `actions` to
/// open this screen — nothing else in `Targets.dart` was touched.
class OwnerCallsHistoryScreen extends StatefulWidget {
  const OwnerCallsHistoryScreen({super.key});

  @override
  State<OwnerCallsHistoryScreen> createState() => _OwnerCallsHistoryScreenState();
}

class _OwnerCallsHistoryScreenState extends State<OwnerCallsHistoryScreen> {
  final _service = OwnerCallService();

  /// Copied from `Targets.dart`'s own `allUsers` — see this class's doc
  /// comment for why it's a copy rather than a shared reference.
  final List<Map<String, String>> allUsers = [
    {"name": "Ravi Kumar", "number": "9711275300", "location": "Sultanpur"},
    {"name": "Faizan Khan", "number": "9971172204", "location": "Sultanpur"},
    {"name": "Yash", "number": "9211335993", "location": "Sultanpur"},
    {"name": "Pawan", "number": "11", "location": "Sultanpur"},
  ];

  bool _loading = true;

  /// One field worker's number -> their fetched call history. Populated
  /// by firing `call_history.php?fieldworkarnumber=<number>` once per
  /// entry in `allUsers` (in parallel, via `Future.wait`) rather than one
  /// unscoped request — mirrors `Targets.dart`'s own `_loadAll()`
  /// pattern of one API call per field worker per metric.
  Map<String, List<OwnerCallHistory>> _historyByNumber = {};

  /// Which field workers' sections currently show their call list —
  /// every section starts collapsed (this set starts empty) and only
  /// its header (name/number + count badge + toggle arrow) is shown
  /// until admin taps the arrow; the header itself never disappears, so
  /// admin always sees every worker in `allUsers` at a glance without
  /// their lists taking up space until asked for.
  final Set<String> _expandedNumbers = {};

  final _searchController = TextEditingController();
  String _query = '';

  // Bumped on every `_load()` call; a response is only applied if its
  // captured id still matches when the batch resolves — same
  // stale-response guard used throughout this project's Target/Task
  // screens (a pull-to-refresh fired while an earlier load was still in
  // flight could otherwise let the older one win).
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

  Future<void> _load() async {
    final requestId = ++_requestId;
    setState(() => _loading = true);

    final results = <String, List<OwnerCallHistory>>{};

    // One `call_history.php?fieldworkarnumber=<number>` request per
    // field worker, run together — if one worker's request fails, the
    // others still complete and that worker's section just shows empty,
    // same "one API failing doesn't take down the rest" resilience
    // `Targets.dart`'s own `_safeCall` wrapper gives its per-worker
    // metric fetches.
    await Future.wait(allUsers.map((u) async {
      final number = u["number"]!;
      try {
        results[number] = await _service.fetchCallHistory(fieldWorkerNumber: number);
      } catch (_) {
        results[number] = const [];
      }
    }));

    if (!mounted || requestId != _requestId) return;
    setState(() {
      _historyByNumber = results;
      _loading = false;
    });
  }

  DateTime? _sortKey(OwnerCallHistory c) => c.callDate ?? c.createdAt;

  /// This worker's calls, newest first, filtered by the search box (by
  /// property #, status, or notes — the worker themselves is already
  /// picked by which section this is, so name/number aren't filtered on
  /// here).
  List<OwnerCallHistory> _callsFor(String number) {
    final list = [...(_historyByNumber[number] ?? const <OwnerCallHistory>[])]
      ..sort((a, b) {
        final ad = _sortKey(a);
        final bd = _sortKey(b);
        if (ad == null && bd == null) return 0;
        if (ad == null) return 1;
        if (bd == null) return -1;
        return bd.compareTo(ad);
      });
    if (_query.isEmpty) return list;
    return list
        .where((c) =>
            c.propertyId.toString().contains(_query) ||
            c.status.toLowerCase().contains(_query) ||
            c.notes.toLowerCase().contains(_query))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Summary reflects what's actually on screen right now (i.e. after
    // the search filter), so the numbers at the top always match what's
    // visible below.
    final visible = allUsers.expand((u) => _callsFor(u["number"]!)).toList();
    final total = visible.length;
    final answered = visible.where((c) => c.status.toLowerCase() == 'answered').length;
    final notAnswered = total - answered;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
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
                  // One section per field worker, always — every entry
                  // in `allUsers` gets its own section even if that
                  // worker has zero calls (or zero matches for the
                  // current search), so admin always sees every worker,
                  // not just the ones with data.
                  ...allUsers.map((u) => _workerSection(u, isDark)),
                ],
              ),
      ),
    );
  }

  Widget _screenHeading(bool isDark) {
    return Text(
      'Building Owner Calls',
      style: TextStyle(
        fontSize: 20,
        fontFamily: 'PoppinsBold',
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _summaryRow(bool isDark, int total, int answered, int notAnswered) {
    return Row(
      children: [
        Expanded(child: _statTile(isDark, 'Total calls', total, const Color(0xFF135BEC))),
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
        hintText: 'Search by property #, status, or notes',
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

  /// One field worker's own section: name/number header with a count
  /// badge and a show/hide toggle arrow, then — only when expanded —
  /// either their calls or an empty state. Modeled on `Targets.dart`'s
  /// own `_userSection` (name + number header per worker) so this reads
  /// as belonging to the same admin screen. Collapsed by default (see
  /// `_expandedNumbers`'s doc comment): the header always shows, the
  /// list only shows once admin taps the arrow.
  Widget _workerSection(Map<String, String> user, bool isDark) {
    final number = user["number"]!;
    final calls = _callsFor(number);
    final hasAnyBeforeFilter = (_historyByNumber[number] ?? const []).isNotEmpty;
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
                    child: _callHistoryCard(c, isDark),
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
        searching ? 'No calls match your search.' : 'No owner calls logged yet.',
        style: TextStyle(fontSize: 12.5, color: isDark ? Colors.white54 : Colors.black45),
      ),
    );
  }

  Widget _callHistoryCard(OwnerCallHistory call, bool isDark) {
    final answered = call.status.toLowerCase() == 'answered';

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
          // Building photo, when `call_history.php` provided one for this
          // record -- see `OwnerCallHistory.buildingImage`'s doc comment.
          // Mirrors the same addition made to `owner_calls_detail.dart`'s
          // own `_callHistoryCard` the same day, for a consistent look.
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
                  color: answered ? const Color(0xFF2E9E5B).withOpacity(0.12) : const Color(0xFFD9534F).withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  answered ? Icons.check_circle_rounded : Icons.call_missed_rounded,
                  color: answered ? const Color(0xFF2E9E5B) : const Color(0xFFD9534F),
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property #${call.propertyId}',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontFamily: 'PoppinsBold',
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _formatCallDate(call.callDate ?? call.createdAt),
                      style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: answered ? const Color(0xFF2E9E5B).withOpacity(0.12) : const Color(0xFFD9534F).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  call.status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: answered ? const Color(0xFF2E9E5B) : const Color(0xFFD9534F),
                  ),
                ),
              ),
            ],
          ),
          if (call.notes.trim().isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.04) : const Color(0xFFF7F9FC),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                call.notes,
                style: TextStyle(fontSize: 12, height: 1.35, color: isDark ? Colors.white70 : Colors.black54),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatCallDate(DateTime? date) {
    if (date == null) return '';
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final year = local.year;
    final hour = local.hour % 12 == 0 ? 12 : local.hour % 12;
    final minute = local.minute.toString().padLeft(2, '0');
    final period = local.hour >= 12 ? 'PM' : 'AM';
    return '$day/$month/$year • $hour:$minute $period';
  }
}
