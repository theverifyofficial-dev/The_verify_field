import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/main.dart' show navigatorKey;

import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';
import 'models/target_progress.dart';
import 'models/agent_task.dart';
import 'services/target_service.dart';
import 'services/task_feed_service.dart';
import 'widgets/target_progress_card.dart';
import 'widgets/task_tile.dart';
import 'widgets/owner_call_card.dart';
import 'widgets/owner_call_outcome_chip.dart';
import 'owner_calls_detail.dart';

// ---------------------------------------------------------------------
// Every one of these is the SAME detail screen the original per-feed
// calendar card already opened for this exact task type — confirmed by
// reading the deleted `CalenderForFieldWorker.dart`'s own `Navigator.push`
// call for each `_build*Card` widget (recovered via `git show HEAD:...`
// since the file itself no longer exists on disk), then checking each
// destination screen's constructor. No new destinations were invented.
// ---------------------------------------------------------------------
import 'package:verify_feild_worker/Rent Agreement/All_detailpage.dart'; // agreement follow-up
import 'package:verify_feild_worker/Rent Agreement/details_agreement.dart'; // pending agreement
import 'package:verify_feild_worker/Rent Agreement/history_tab.dart'; // accepted agreement
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Future_property_details.dart'; // building follow-up
import 'package:verify_feild_worker/Demand_2/Demand_detail.dart'; // tenant demand + booked visit
// `Home_Screen_click/View_All_Details.dart` (View_Details) import removed
// 2026-09-21: it was only used by the `liveProperty` task case, which was
// removed from the task list entirely per explicit request -- see
// `task_feed_service.dart`'s `fetchTasksForDate` doc comment.
import 'package:verify_feild_worker/Upcoming/Upcoming_details.dart'; // upcoming flat

/// The merged "Targets & Tasks" section — the single screen an agent now
/// uses for quota progress, calendar date browsing, and the day's to-do
/// list together.
///
/// This screen REPLACES two screens that no longer exist in this codebase:
/// `Target_details/Monthly_target.dart` + `Target_details/Yearly_Target.dart`
/// ("Target Section") and the field-worker calendar screen that used to live
/// in `Calender/CalenderForFieldWorker.dart` ("To-Do Section") — both were
/// deleted once this screen covered everything they did, including the
/// calendar's own date-switching (Month/Week view + a month/year jump
/// picker), which is reproduced below using the same `table_calendar`
/// package and the same interaction the original screen used. See this
/// directory's README.md for the full list of what was deleted, what had
/// to be extracted first, and how every task type's navigation and the
/// calendar behavior were re-verified against the original code (via git
/// history, since the source file is gone) before being reproduced here.
///
/// Layout, top to bottom: quota progress cards (Monthly/Yearly toggle),
/// then a calendar strip for picking which date's tasks to view, then that
/// date's tasks grouped by urgency (Due now / Today / Upcoming — urgency is
/// always relative to *today*, regardless of which date is being browsed,
/// so "why is this overdue item shown while I'm looking at next Tuesday"
/// stays answerable at a glance).
class TargetAndTasksHome extends StatefulWidget {
  const TargetAndTasksHome({super.key});

  @override
  State<TargetAndTasksHome> createState() => _TargetAndTasksHomeState();
}

class _TargetAndTasksHomeState extends State<TargetAndTasksHome> with WidgetsBindingObserver {
  final _targetService = TargetService();
  final _taskService = TaskFeedService();

  String? _fieldWorkerNumber;
  String? _fieldWorkerName;

  TargetPeriod _period = TargetPeriod.today;
  bool _loadingTargets = true;
  List<TargetProgress> _targets = [];

  // ---- calendar state, carried over from the deleted
  // `CalenderForFieldWorker.dart` (`_focusedDay`/`_selectedDay`/
  // `_calendarFormat`/`_calendarView` were its exact field names) ----
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  String _calendarView = 'Week';
  int _pickerMonth = DateTime.now().month;
  int _pickerYear = DateTime.now().year;

  // Single source of truth for the calendar's valid year range, so the
  // TableCalendar widget below and the month/year jump picker's wheel can
  // never disagree. Previously: the picker allowed 2022-2031 but
  // TableCalendar's own `firstDay`/`lastDay` only allowed 2023-2030 —
  // picking 2022 or 2031 in the picker produced a date TableCalendar
  // itself considered out of range.
  static const int _firstPickerYear = 2023;
  static const int _lastPickerYear = 2030;
  static final List<int> _years =
      List.generate(_lastPickerYear - _firstPickerYear + 1, (i) => _firstPickerYear + i);
  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  String _monthName(int m) => _months[m - 1];

  bool _loadingTasks = true;
  List<AgentTask> _tasks = [];

  // Bumped on every `_loadTargets()`/`_loadTasks()` call and captured
  // locally at call time; a response is only applied if its captured id
  // still matches the field when the await resolves. Without this, tapping
  // several calendar dates quickly (or toggling Monthly/Yearly quickly) can
  // let an OLDER request's response land after a NEWER one and silently
  // overwrite it with stale data — the request that started first isn't
  // guaranteed to finish first.
  int _targetsRequestId = 0;
  int _tasksRequestId = 0;

  // ---------------------------------------------------------------------
  // Owner calling — "tap the call icon, place the call, come back to the
  // app, the outcome sheet is already waiting for you" is the whole point
  // of this redesign. `_pendingCallTask` is how that "come back" half
  // gets detected: `_callOwner()` sets it right before opening the phone
  // dialer, and `didChangeAppLifecycleState` below opens the sheet for
  // whatever task is pending the moment the app resumes — no other signal
  // exists for "the field worker just returned from the dialer".
  // ---------------------------------------------------------------------
  AgentTask? _pendingCallTask;

  /// Whether the "Building Owner Calls" section's list is showing.
  /// Defaults to collapsed/hidden — the section still always shows its
  /// header (with the count badge) so the field worker knows calls are
  /// due without the list itself taking up space until they ask for it.

  /// Guards `_openOwnerCallSheet` against being opened a second time
  /// while it's already showing. The resume-after-call path below and a
  /// direct tap on a card's "Log call" both funnel through that one
  /// method; inserting two modal routes into the same `Overlay` in close
  /// succession is exactly the kind of thing that produced the
  /// framework-level "'_dependents.isEmpty': is not true" crash on
  /// `ThemeSwitcher` reported against this screen (a real Flutter
  /// Overlay/InheritedElement race, not something a try/catch can paper
  /// over) — so it's prevented from happening at all rather than handled
  /// after the fact.
  bool _ownerCallSheetOpen = false;

  DateTime get _activeDate => _selectedDay ?? _focusedDay;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _selectedDay = _focusedDay;
    _bootstrap();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Fires on every app foreground/background transition, not just the
  /// one we care about — so it only acts when `_pendingCallTask` is
  /// actually set (i.e. `_callOwner()` really did just open the dialer),
  /// and it clears the flag immediately so returning to the app a second
  /// time for an unrelated reason doesn't re-open the sheet.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _pendingCallTask != null) {
      final task = _pendingCallTask!;
      _pendingCallTask = null;
      // A single post-frame callback still lands in the same window as
      // other resume-triggered top-level rebuilds — `main.dart` wraps the
      // whole app in a theme switcher and a network-connectivity
      // listener, both of which can rebuild/notify right as the app
      // comes back from the background (connectivity in particular
      // tends to blip exactly when a phone call ends). Opening a new
      // modal route into the `Overlay` while one of those is mid-rebuild
      // is what produced the framework-level
      // "'_dependents.isEmpty': is not true" crash on `ThemeSwitcher`.
      // The fix is to stop racing it: wait a frame, then wait a further
      // beat for things to settle, then open on the app's single root
      // Navigator context (`navigatorKey`, from `main.dart`) — the same
      // stable anchor every notification-triggered navigation in this
      // app already uses — rather than this screen's own `context`,
      // which may not even belong to the current route by the time the
      // field worker returns.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await Future.delayed(const Duration(milliseconds: 300));
        if (!mounted) return;
        final rootContext = navigatorKey.currentContext;
        if (rootContext == null || !rootContext.mounted) return;
        _openOwnerCallSheet(rootContext, task);
      });
    }
  }

  Future<void> _bootstrap() async {
    final prefs = await SharedPreferences.getInstance();
    _fieldWorkerNumber = prefs.getString('number');
    _fieldWorkerName = prefs.getString('name') ?? '';
    if (_fieldWorkerNumber == null || _fieldWorkerNumber!.isEmpty) {
      // No session identity on this device. `_loadTargets()`/`_loadTasks()`
      // both guard on this same condition below and now clear their own
      // loading flags when it's true — previously they returned before
      // ever touching `_loadingTargets`/`_loadingTasks`, so both spinners
      // spun forever with no way for the field worker to know why.
      if (!mounted) return;
      setState(() {
        _loadingTargets = false;
        _loadingTasks = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing field worker credentials — please log in again.')),
      );
      return;
    }
    await Future.wait([_loadTargets(), _loadTasks()]);
  }

  Future<void> _loadTargets() async {
    if (_fieldWorkerNumber == null || _fieldWorkerNumber!.isEmpty) {
      if (mounted) setState(() => _loadingTargets = false);
      return;
    }
    final requestId = ++_targetsRequestId;
    setState(() => _loadingTargets = true);
    final data = await _targetService.fetchProgress(
      fieldWorkerNumber: _fieldWorkerNumber!,
      fieldWorkerName: _fieldWorkerName ?? '',
      period: _period,
    );
    // A newer call to `_loadTargets()` (e.g. a second Monthly/Yearly tap
    // before this one finished) may have already landed — don't let this
    // older response overwrite it.
    if (!mounted || requestId != _targetsRequestId) return;
    setState(() {
      _targets = data;
      _loadingTargets = false;
    });
  }

  /// Re-fetches the task feed for `_activeDate`. This is the method the
  /// calendar strip's `onDaySelected`, its Month/Week format switch, and
  /// its month/year jump picker all call after moving the date — mirrors
  /// exactly how the deleted screen's `_fetchData(_selectedDay ??
  /// _focusedDay)` was called from each of those same three places.
  Future<void> _loadTasks() async {
    if (_fieldWorkerNumber == null || _fieldWorkerNumber!.isEmpty) {
      if (mounted) setState(() => _loadingTasks = false);
      return;
    }
    final requestId = ++_tasksRequestId;
    setState(() => _loadingTasks = true);
    final data = await _taskService.fetchTasksForDate(
      fieldWorkerNumber: _fieldWorkerNumber!,
      fieldWorkerName: _fieldWorkerName ?? '',
      date: _activeDate,
    );
    // Same staleness guard as `_loadTargets()` — a field worker tapping
    // several calendar dates quickly used to be able to have an older
    // date's response land after a newer one and silently overwrite the
    // correct tasks with the wrong date's data.
    if (!mounted || requestId != _tasksRequestId) return;
    setState(() {
      _tasks = data;
      _loadingTasks = false;
    });
  }

  /// Owner-call tasks get their OWN section (see build()) — deliberately
  /// distinct from the urgency-grouped list every other task type shares,
  /// per the redesign request to visually separate building calling from
  /// everything else. So they're excluded here rather than also showing
  /// up a second time inside "Due now"/"Today"/"Upcoming".
  List<AgentTask> get _ownerCallTasks =>
      _tasks.where((t) => t.type == AgentTaskType.ownerCall).toList();

  Map<TaskUrgency, List<AgentTask>> get _grouped {
    final now = DateTime.now();
    final map = <TaskUrgency, List<AgentTask>>{
      TaskUrgency.dueNow: [],
      TaskUrgency.today: [],
      TaskUrgency.upcoming: [],
    };
    for (final t in _tasks) {
      if (t.type == AgentTaskType.ownerCall) continue;
      map[t.urgencyRelativeTo(now)]!.add(t);
    }
    return map;
  }

  /// Opens the phone dialer via `tel:` for `ownerNumber` — passed in
  /// directly by the caller (see `_ownerCallsSection`'s `OwnerCallCard`)
  /// rather than re-read from `task.raw['_owner_number']` here, so this
  /// function isn't the one deciding where the number comes from; `task`
  /// is still needed separately to mark itself as "waiting for the field
  /// worker to come back" so `didChangeAppLifecycleState` can open the
  /// outcome sheet the moment they do. If there's no usable number, this
  /// says so instead of silently doing nothing.
  Future<void> _callOwner(AgentTask task, String ownerNumber) async {
    final number = ownerNumber.replaceAll(RegExp(r'[^0-9+]'), '');

    print(number);
    print(ownerNumber);

    if (number.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No phone number on file for this owner.')),
      );
      return;
    }
    _pendingCallTask = task;
    final launched = await launchUrl(Uri(scheme: 'tel', path: number));
    if (!launched) {
      // The dialer never actually opened (e.g. no telephony on this
      // device) — don't leave a stale pending task waiting for a resume
      // that isn't coming from a call at all.
      _pendingCallTask = null;
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Couldn't open the dialer.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grouped = _grouped;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0E1116) : const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text('Targets & Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => Future.wait([_loadTargets(), _loadTasks()]),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([_loadTargets(), _loadTasks()]),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
          children: [
            // The period toggle moved to its own row below the title
            // (2026-09-21, once it grew from 2 pills to 4 for Today/Week)
            // rather than living in `_sectionHeader`'s `trailing` slot -- a
            // `Row` gives an inflexible trailing child UNBOUNDED width, and
            // `_periodToggle`'s internal horizontal `SingleChildScrollView`
            // needs a BOUNDED width to lay out at all (an unbounded
            // horizontal viewport is a hard Flutter layout error, not just an
            // overflow warning) -- putting it on its own line under the full-
            // width `ListView` gives it one.
            _sectionHeader(context, 'Your targets'),
            const SizedBox(height: 10),
            _periodToggle(),
            const SizedBox(height: 10),
            _loadingTargets
                ? const _InlineLoading()
                : SizedBox(
                    height: 128,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _targets.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (_, i) {
                        final t = _targets[i];
                        return TargetProgressCard(
                          data: t,
                          // Refresh this row on return (2026-09-21) -- this is
                          // the root cause behind "I added a building but the
                          // Buildings count didn't update": `_loadTargets()`
                          // previously only ran on initial load, a period-tab
                          // tap, or a manual pull-to-refresh, never after
                          // coming back from a detail screen where a field
                          // worker could have just added/changed a record.
                          // Applies to every quota card, not just Buildings,
                          // since they all share this one navigation site.
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: t.detailBuilder),
                          ).then((_) {
                            if (mounted) _loadTargets();
                          }),
                        );
                      },
                    ),
                  ),
            const SizedBox(height: 24),
            _ownerCallsSection(context, isDark),
            const SizedBox(height: 28),
            _sectionHeader(context, 'Calendar', trailing: _calendarFormatToggle()),
            const SizedBox(height: 10),
            _calendarCard(isDark),
            const SizedBox(height: 20),
            _sectionHeader(context, _tasksHeadingFor(_activeDate)),
            const SizedBox(height: 10),
            if (_loadingTasks)
              const _InlineLoading()
            // Checks the three urgency groups directly rather than
            // `_tasks.isEmpty` — `_tasks` still includes owner-call tasks
            // (they're just excluded from `grouped`, see `_grouped`'s doc
            // comment), so a day with owner calls but nothing else would
            // otherwise show three empty "DUE NOW / TODAY / UPCOMING"
            // headers instead of the actual empty state.
            else if (grouped[TaskUrgency.dueNow]!.isEmpty &&
                grouped[TaskUrgency.today]!.isEmpty &&
                grouped[TaskUrgency.upcoming]!.isEmpty)
              _EmptyTasks(isDark: isDark)
            else ...[
              _taskGroup(context, 'Due now', grouped[TaskUrgency.dueNow]!, TaskUrgency.dueNow),
              _taskGroup(context, 'Today', grouped[TaskUrgency.today]!, TaskUrgency.today),
              _taskGroup(context, 'Upcoming', grouped[TaskUrgency.upcoming]!, TaskUrgency.upcoming),
            ],
          ],
        ),
      ),
    );
  }

  String _tasksHeadingFor(DateTime date) {
    final today = DateTime.now();
    final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
    if (isToday) return "Today's tasks";
    return 'Tasks for ${date.day} ${_monthName(date.month).substring(0, 3)} ${date.year}';
  }

  /// The redesigned "Building Owner Calls" section — deliberately its own
  /// block, between the targets row and the calendar, rather than sitting
  /// inside the date-scoped task list below. Two reasons: (1) due calls
  /// aren't date-scoped to begin with (see `TaskFeedService`'s comment on
  /// why `due_calls.php` is fetched once, not per selected day), so
  /// grouping it under whichever date happens to be browsed would be
  /// misleading; (2) this is the one task type with its own dedicated
  /// action (place the call) rather than just "navigate to a detail
  /// screen", so it earns its own visual identity instead of blending
  /// into the generic list.
  /// Header + button for the owner-calls section.
  ///
  /// Redesigned (2026-09-21) per explicit request: the due-calls list no
  /// longer renders inline on this screen at all (it used to, behind a
  /// show/hide arrow -- see git history for that version). This section
  /// is now just the header (title + red due-count badge) plus a single
  /// button that navigates to `OwnerCallsDetailScreen` -- the same detail
  /// screen the Target section's "Owner Calls" quota card already opens
  /// -- so there is one screen for owner-calling instead of two.
  Widget _ownerCallsSection(BuildContext context, bool isDark) {
    // Redesigned (2026-09-21) per explicit follow-up: a single full-width
    // gradient button, not a header line plus a separate plain button --
    // everything (title, due-count badge, chevron) now lives inside the
    // one gradient surface. Same gradient accent already used for the
    // "Owner Calls" icon avatar on `OwnerCallsDetailScreen`'s summary card
    // (`[Color(0xFF2F6FED), Color(0xFF5B8DEF)]`), reused here so the two
    // screens read as the same feature.
    final calls = _ownerCallTasks;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (_fieldWorkerNumber == null || _fieldWorkerNumber!.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Missing field worker credentials — please log in again.')),
            );
            return;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => OwnerCallsDetailScreen(
                fieldWorkerNumber: _fieldWorkerNumber!,
                fieldWorkerName: _fieldWorkerName ?? '',
              ),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF2F6FED), Color(0xFF5B8DEF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                child: const Icon(Icons.call_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Building Owner Calls',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      calls.isEmpty
                          ? 'No owner calls due right now.'
                          : "View and log this month's owner calls",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 11.5, color: Colors.white70),
                    ),
                  ],
                ),
              ),
              if (calls.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(left: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Text(
                    '${calls.length}',
                    style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              const SizedBox(width: 4),
              const Icon(Icons.chevron_right_rounded, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  /// Extended 2026-09-21 with Today/Week pills (per explicit request) --
  /// now 4 pills instead of 2, so this wraps the row in a horizontal
  /// scroll view rather than risk a `RenderFlex` overflow on a narrow
  /// screen once this sits as `_sectionHeader`'s trailing widget next to
  /// the "Your targets" title.
  Widget _periodToggle() {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.blueAccent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          _pill('Today', selected: _period == TargetPeriod.today, onTap: () {
            if (_period == TargetPeriod.today) return;
            setState(() => _period = TargetPeriod.today);
            _loadTargets();
          }),
          _pill('Monthly', selected: _period == TargetPeriod.monthly, onTap: () {
            if (_period == TargetPeriod.monthly) return;
            setState(() => _period = TargetPeriod.monthly);
            _loadTargets();
          }),
          _pill('Yearly', selected: _period == TargetPeriod.yearly, onTap: () {
            if (_period == TargetPeriod.yearly) return;
            setState(() => _period = TargetPeriod.yearly);
            _loadTargets();
          }),
        ]),
      ),
    );
  }

  /// Month View / Week View switch — the same two options and the same
  /// `PopupMenuButton` interaction the deleted screen's app-bar action used
  /// (that screen never offered a "Day" format; `table_calendar` itself
  /// only supports month/twoWeeks/week, so this doesn't invent a third).
  Widget _calendarFormatToggle() {
    return PopupMenuButton<String>(
      tooltip: 'Calendar view',
      onSelected: (value) {
        setState(() {
          _calendarView = value;
          _calendarFormat = value == 'Month' ? CalendarFormat.month : CalendarFormat.week;
        });
      },
      itemBuilder: (_) => const [
        PopupMenuItem(value: 'Month', child: Text('Month View')),
        PopupMenuItem(value: 'Week', child: Text('Week View')),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(_calendarView,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.blueAccent)),
          const Icon(Icons.arrow_drop_down, size: 18, color: Colors.blueAccent),
        ]),
      ),
    );
  }

  Widget _pill(String label, {required bool selected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : Colors.blueAccent,
            )),
      ),
    );
  }

  /// The calendar strip itself: a tappable "Month Year" title (opens the
  /// month/year jump picker below) plus the `TableCalendar` widget, wired
  /// exactly as the deleted screen wired it — `onDaySelected` sets the new
  /// date and reloads tasks for it; `onPageChanged` just tracks which
  /// month/year is on screen for the title and the jump picker's defaults.
  Widget _calendarCard(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171B22) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
      ),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showMonthYearPicker,
            child: Row(
              children: [
                Text(
                  '${_monthName(_focusedDay.month)} ${_focusedDay.year}',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down, size: 20),
                const Spacer(),
                if (_selectedDay != null)
                  Text(
                    'Selected: ${_selectedDay!.day} ${_monthName(_selectedDay!.month).substring(0, 3)} ${_selectedDay!.year}',
                    style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white38 : Colors.black45),
                  ),
              ],
            ),
          ),
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(_firstPickerYear),
            lastDay: DateTime(_lastPickerYear, 12, 31),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: _calendarFormat,
            headerVisible: false,
            daysOfWeekVisible: _calendarFormat == CalendarFormat.month,
            rowHeight: _calendarFormat == CalendarFormat.week ? 64 : 40,
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
              selectedDecoration: const BoxDecoration(color: Colors.blueAccent, shape: BoxShape.circle),
              outsideDaysVisible: false,
              weekendTextStyle: const TextStyle(color: Colors.redAccent),
            ),
            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
              _loadTasks();
            },
            onPageChanged: (focused) {
              setState(() => _focusedDay = focused);
            },
          ),
        ],
      ),
    );
  }

  /// Same bottom-sheet month/year jump picker as the deleted screen —
  /// `CupertinoPicker` for month and year, "Apply" moves `_focusedDay` /
  /// `_selectedDay` there and reloads that date's tasks.
  Future<void> _showMonthYearPicker() async {
    _pickerMonth = _focusedDay.month;
    _pickerYear = _focusedDay.year;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    // Created ONCE, before the sheet opens — deliberately NOT inside
    // `StatefulBuilder`'s `builder` callback below. That callback re-runs
    // on every `setModalState` call (i.e. every time either wheel moves a
    // single item), and a `FixedExtentScrollController` created there
    // would be rebuilt from scratch each time: the old one silently
    // discarded without disposal, and the new one reset to `initialItem`
    // — which is exactly the "picker jumping/resetting mid-scroll" bug.
    // One controller per wheel, created once, kept for the sheet's whole
    // lifetime, disposed together below once it closes.
    final monthController = FixedExtentScrollController(initialItem: _pickerMonth - 1);
    final yearController = FixedExtentScrollController(
        initialItem: _years.indexOf(_pickerYear).clamp(0, _years.length - 1));

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(color: bg.withOpacity(0.97), borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            height: 320,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text('Select month & year',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 10),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: monthController,
                          itemExtent: 38,
                          looping: true,
                          onSelectedItemChanged: (i) => setModalState(() => _pickerMonth = i + 1),
                          children: _months
                              .map((m) => Center(child: Text(m, style: TextStyle(color: textColor))))
                              .toList(),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController: yearController,
                          itemExtent: 38,
                          onSelectedItemChanged: (i) => setModalState(() => _pickerYear = _years[i]),
                          children: _years
                              .map((y) => Center(child: Text('$y', style: TextStyle(color: textColor))))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _focusedDay = DateTime(_pickerYear, _pickerMonth, 1);
                        _selectedDay = _focusedDay;
                      });
                      _loadTasks();
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
          );
        });
      },
    );
    monthController.dispose();
    yearController.dispose();
  }

  Widget _sectionHeader(BuildContext context, String title, {Widget? trailing}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: isDark ? Colors.white : Colors.black87),
        ),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _taskGroup(BuildContext context, String label, List<AgentTask> tasks, TaskUrgency urgency) {
    if (tasks.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 2),
            child: Text(
              '${label.toUpperCase()}  ·  ${tasks.length}',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: isDark ? Colors.white38 : Colors.black45,
              ),
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: tasks.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final task = tasks[i];
              return TaskTile(task: task, urgency: urgency, onTap: () => _openTask(context, task));
            },
          ),
        ],
      ),
    );
  }

  /// Routes a tapped task to the SAME screen the old per-feed calendar card
  /// already opened for it. One `switch` on `task.type` replaces the seven
  /// different `_build*Card`/`onTap` pairs that used to live scattered
  /// across the deleted `CalenderForFieldWorker.dart` — an agent (or an
  /// automated integration test) only needs to read this one method to know
  /// where every task type goes.
  void _openTask(BuildContext context, AgentTask task) {
    // Every case below is wrapped in its own `{ }` block. This isn't just
    // style: a `switch` in Dart shares ONE scope across every `case` that
    // isn't individually braced, so two cases each declaring `final id`
    // (as `liveProperty` and `upcomingFlat` used to, unbraced) collide —
    // "id is already defined in this scope". That was a live compile
    // error sitting in this file (never caught, because this project has
    // never had a Flutter/Dart SDK available to actually compile it).
    // Bracing every case fixes that and also gives each case its own
    // null-safe `id` extraction — see the comment above the switch's
    // fallthrough snackbar for why that matters too.
    switch (task.type) {
      case AgentTaskType.agreementFollowUp:
        {
          // Original: `_buildAgreementCard` -> AllDetailpage(agreementId: ...)
          final id = task.raw['id'];
          if (id == null) break;
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => AllDetailpage(agreementId: id.toString())));
          return;
        }
      case AgentTaskType.addFlat:
        {
          final propertyId = task.raw['P_id'];
          final subId = task.raw['subid'];

          if (propertyId == null || subId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Couldn't open this flat's details."),
              ),
            );
            return;
          }

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => underflat_futureproperty(
                id: propertyId.toString(),
                Subid: subId.toString(),
              ),
            ),
          );

          return;
        }

      case AgentTaskType.pendingAgreement:
        {
          // Original: `_buildPendingAgreementCard` -> AgreementDetailPage(agreementId: ...)
          // NOTE this is a DIFFERENT destination from the plain
          // `agreementFollowUp` case above even though both are "agreement"
          // tasks — confirmed by reading each card's own onTap in the
          // deleted screen rather than assuming they matched.
          final id = task.raw['id'];
          if (id == null) break;
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AgreementDetailPage(agreementId: id.toString())));
          return;
        }

      case AgentTaskType.agreementAccept:
        // Original: `_buildAcceptedAgreementCard` -> HistoryTab(defaultTabIndex: 1)
        // Takes no id — it's a fixed tab showing all accepted agreements,
        // not a single record's detail screen.
        Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryTab(defaultTabIndex: 1)));
        return;

      case AgentTaskType.buildingFollowUp:
        {
          // Original: `_buildFuturePropertyCard` -> Future_Property_details(idd: f.id)
          final id = task.raw['id'];
          if (id == null) break;
          // Refresh on return (2026-09-21, same root cause as the
          // Buildings quota card's fix above): this building-follow-up
          // task's own detail screen is exactly where a field worker
          // would add/update the building, so the task list needs to
          // reload after they come back, not just sit on what was
          // fetched when the date was first selected.
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => Future_Property_details(idd: id.toString())))
              .then((_) {
            if (mounted) _loadTasks();
          });
          return;
        }

      case AgentTaskType.ownerCall:
        // REPLACED per explicit user decision: owner-call tasks now come
        // from the new `Building_Calling/due_calls.php` feed, and tapping
        // one opens the call-log sheet (status + notes -> submit_call.php)
        // instead of navigating to a building detail screen the way the
        // old `building_calling_reminder.php` reminder card used to.
        _openOwnerCallSheet(context, task);
        return;

      case AgentTaskType.tenantDemand:
        {
          // Original: `_buildTenantDemandCard` -> DemandDetail(demandId: ...)
          final id = task.raw['id'];
          if (id == null) break;
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => DemandDetail(demandId: id.toString())));
          return;
        }

      case AgentTaskType.bookVisit:
        {
          // Original: `_buildBookedTenantVisitCard` -> DemandDetail(demandId: ...)
          // (same destination screen as tenantDemand, different feed).
          final id = task.raw['id'];
          if (id == null) break;
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => DemandDetail(demandId: id.toString())));
          return;
        }

      case AgentTaskType.upcomingFlat:
        {
          // Original: `_buildUpcomingFlatCard` -> UpcomingDetailsPage(id: f.propertyId)
          final id = int.tryParse(task.raw['P_id']?.toString() ?? '');
          if (id == null) break;
          Navigator.push(context, MaterialPageRoute(builder: (_) => UpcomingDetailsPage(id: id)));
          return;
        }

      case AgentTaskType.websiteVisit:
        {
          // Original: `_buildWebsiteVisitCard` doesn't navigate in-app at all —
          // it opens the public listing page in the browser. Kept identical
          // rather than "upgraded" to an in-app screen that doesn't exist.
          // `launchUrl`'s result is now checked (it wasn't before) — a
          // failed launch (no browser available, malformed link, etc.)
          // used to fail completely silently.
          final subid = task.raw['subid'];
          if (subid == null) break;
          launchUrl(Uri.parse('https://theverify.in/details.html?id=$subid'),
                  mode: LaunchMode.externalApplication)
              .then((launched) {
            if (!launched && context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Couldn't open that link.")));
            }
          });
          return;
        }
    }
    // Reached when a case's id/subid was null — a "null" string used to
    // get silently passed into a detail page's constructor instead
    // (`task.raw['id'].toString()` on a null value produces the literal
    // string "null", which a backend endpoint expecting a real id would
    // either 404 on or, worse, misinterpret). Telling the field worker
    // outright is better than a detail screen that fails confusingly.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Couldn't open this task's details.")),
    );
  }

  // ---------------------------------------------------------------------
  // Owner calling — the NEW `Building_Calling/due_calls.php` +
  // `submit_call.php` pair from the Agent Dashboard redesign spec. This
  // is genuinely new UI, not carried over from any deleted screen: the
  // old reminder card never let a field worker record anything, it was
  // purely informational.
  // ---------------------------------------------------------------------

  /// Bottom sheet: shows which owner/building this call is for, a status
  /// choice (Answered / Not Answered — the exact two values the spec's
  /// `submit_call.php` expects), and a notes field. On submit, posts via
  /// `TaskFeedService.submitOwnerCall`, then — only on a confirmed success,
  /// never optimistically — records it for the Target section's "Owner
  /// Calls" quota and reloads the task list so the call drops off the due
  /// list once the backend reflects it.
  ///
  /// Wrapped in `_ownerCallSheetOpen` (see its doc comment) and, inside,
  /// a `SingleChildScrollView` + a height-capped `ConstrainedBox` — the
  /// original version had neither, so a keyboard opening while the sheet
  /// was already near full-height overflowed its own `Column` (the
  /// reported `RenderFlex ... OVERFLOWING`); now the sheet can scroll
  /// instead of overflowing no matter the screen size or keyboard state.
  Future<void> _openOwnerCallSheet(BuildContext context, AgentTask task) async {
    if (_ownerCallSheetOpen) return;
    if (!context.mounted) return;
    _ownerCallSheetOpen = true;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    String status = 'Answered';
    final notesController = TextEditingController();
    bool submitting = false;

    // try/finally: if anything inside the builder throws, `_ownerCallSheetOpen`
    // must still reset and `notesController` must still be disposed —
    // otherwise a single failed build permanently blocks every future
    // owner-call sheet from opening at all.
    try {
      await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) {
        return StatefulBuilder(builder: (sheetContext, setSheetState) {
          // Blocks swipe-down/back dismissal while a submit is in
          // flight, so a slow network call can't silently lose the
          // outcome the field worker just entered.
          return WillPopScope(
            onWillPop: () async => !submitting,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(sheetContext).viewInsets.bottom),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(sheetContext).size.height * 0.9),
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 14),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF2F6FED), Color(0xFF5B8DEF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.call_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(task.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.bold,
                                          color: isDark ? Colors.white : Colors.black87)),
                                  if (task.subtitle.isNotEmpty)
                                    Text(task.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12.5,
                                            color: isDark ? Colors.white60 : Colors.black54)),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: submitting ? null : () => Navigator.of(sheetContext).pop(),
                              icon: Icon(Icons.close_rounded,
                                  color: isDark ? Colors.white38 : Colors.black38),
                              tooltip: 'Close',
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                                onTap: () => setSheetState(() => status = 'Answered'),
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
                                onTap: () => setSheetState(() => status = 'Not Answered'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
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
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2F6FED),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: submitting ? null : () async { setSheetState(() => submitting = true); final propertyId = task.raw['property_id']?.toString() ?? task.id.replaceFirst('ownercall_', ''); final ok = await _taskService.submitOwnerCall( propertyId: propertyId, fieldWorkerName: _fieldWorkerName ?? '', fieldWorkerNumber: _fieldWorkerNumber ?? '', status: status, notes: notesController.text.trim(), ); if (!sheetContext.mounted) return; if (ok) { Navigator.pop(sheetContext); await _recordOwnerCallDone(); if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar( const SnackBar(content: Text('Call logged successfully')), ); _loadTasks(); } else { setSheetState(() => submitting = false); ScaffoldMessenger.of(sheetContext).showSnackBar( const SnackBar(content: Text('Failed to log call')), ); } },
                            child: submitting
                                ? const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                            strokeWidth: 2, color: Colors.white),
                                      ),
                                      SizedBox(width: 10),
                                      Text('Submitting…'),
                                    ],
                                  )
                                : const Text('Submit', style: TextStyle(fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
      },
      );
    } finally {
      _ownerCallSheetOpen = false;
      // `notesController` is created fresh every time this sheet opens and
      // was never disposed before — a `TextEditingController` leak on every
      // owner call logged (or cancelled by dismissing the sheet).
      notesController.dispose();
    }
  }

  /// Persists "one more owner call logged this month" on-device via
  /// `SharedPreferences`, keyed by year+month so it naturally resets each
  /// month without any date-math elsewhere. This is a deliberate,
  /// documented workaround (see README's "Owner Calls target" section):
  /// the redesign spec's API pair has no "count of calls logged this
  /// month" endpoint, so there is nothing server-side for the Target
  /// card to read. This local counter is per-device, not synced across a
  /// field worker's devices or visible to Admin — flagged as a real
  /// limitation, not a hidden shortcut.
  /// Back to the single monthly counter (2026-09-21) -- Owner Calls
  /// briefly had day/week-scoped sibling keys for the Today/Week tabs,
  /// but both tabs later dropped Owner Calls entirely per explicit
  /// follow-up, so there's nothing left that reads a day-scoped count.
  /// Still goes through `TargetService.monthlyOwnerCallsKey()` rather
  /// than a hand-rolled key here, so this and `owner_calls_detail.dart`'s
  /// equivalent increment can never drift apart on the key format.
  Future<void> _recordOwnerCallDone() async {
    final prefs = await SharedPreferences.getInstance();
    final key = TargetService.monthlyOwnerCallsKey();
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + 1);
  }
}

class _InlineLoading extends StatelessWidget {
  const _InlineLoading();
  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator(strokeWidth: 2.4)),
      );
}

class _EmptyTasks extends StatelessWidget {
  final bool isDark;
  const _EmptyTasks({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(Icons.task_alt_rounded, size: 40, color: isDark ? Colors.white24 : Colors.black26),
          const SizedBox(height: 10),
          Text('Nothing due on this date',
              style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.black54)),
        ],
      ),
    );
  }
}

