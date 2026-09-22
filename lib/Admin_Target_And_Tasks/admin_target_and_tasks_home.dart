import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Target_And_Tasks/models/agent_task.dart';
import '../Target_And_Tasks/models/target_progress.dart';
import '../Target_And_Tasks/services/target_service.dart';
import '../Target_And_Tasks/services/task_feed_service.dart';
import '../Target_And_Tasks/widgets/target_progress_card.dart';
import '../Target_And_Tasks/widgets/task_tile.dart';
import '../Target_And_Tasks/owner_calls_detail.dart';
// Same per-task-type detail screens the field worker's own
// `target_and_tasks_home.dart`'s `_openTask` dispatch navigates to (see
// this file's own `_openTask`, added 2026-09-22 per explicit request to
// replace the old generic bottom sheet) -- no new destinations invented,
// just that same dispatch reused for admin.
import 'package:verify_feild_worker/Rent Agreement/All_detailpage.dart'; // agreement follow-up
import 'package:verify_feild_worker/Rent Agreement/details_agreement.dart'; // pending agreement
import 'package:verify_feild_worker/Rent Agreement/history_tab.dart'; // accepted agreement
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Future_property_details.dart'; // building follow-up
import 'package:verify_feild_worker/Demand_2/Demand_detail.dart'; // tenant demand + booked visit
import 'package:verify_feild_worker/Upcoming/Upcoming_details.dart'; // upcoming flat
import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart'; // add flat

/// Admin/sub-admin's own "Tasks & Targets" dashboard.
///
/// Rewritten 2026-09-21 per explicit follow-up ("not like that don't
/// combine them admin + fieldworker(wrong)"): the previous version of
/// this screen embedded the field worker's own `TargetAndTasksHome`
/// widget (via two now-removed optional constructor params on that
/// class) so admin and field worker were, in effect, looking at the same
/// screen implementation. The user rejected that as wrong. This version
/// is a genuinely separate, admin-only screen: its own `Scaffold`, its
/// own `AppBar`, its own layout, its own state -- `TargetAndTasksHome`
/// has no admin-facing hook into it any more (its constructor is back to
/// `const TargetAndTasksHome()`, exactly as it was before that change).
///
/// What IS still reused here, deliberately: `TargetService` and
/// `TaskFeedService` -- these are pure data-fetching classes (HTTP calls
/// + JSON parsing, no UI, no `SharedPreferences` reads of "the current
/// device's own session") that already take a field-worker number/name
/// as a parameter. Re-fetching this same data with a second, hand-rolled
/// set of HTTP calls here would risk silently drifting out of sync with
/// the real field-worker numbers/endpoints -- reusing the service
/// classes is reuse of a data layer, not "combining admin and field
/// worker screens" the way embedding the whole field-worker widget was.
/// Likewise `TargetProgressCard`/`TaskTile` are pure, stateless
/// presentational widgets (data + callback in, nothing else) -- reusing
/// them keeps this screen visually consistent with the rest of the app
/// without pulling in any field-worker-specific STATE (there is no
/// calendar widget, no "call the owner and log the outcome" flow, no
/// app-lifecycle resume handling here -- none of that makes sense for an
/// admin viewing someone else's day, so none of it was carried over).
///
/// Agent list + role/location filtering copied verbatim from
/// `Adminisstrator_Target_details/Targets.dart`'s own
/// `allUsers`/`_filterUsersByRole` (see that file, and project memory
/// `business_logic_targets_roles.md` on why these constants are
/// duplicated per screen rather than shared today).
///
/// **2026-09-22 follow-up**: owner-call tasks no longer render as
/// individual cards in the date-scoped task list below -- they get their
/// own "Building Owner Calls" section instead (the same single
/// full-width gradient button design the field worker's own screen
/// already uses, navigating to `OwnerCallsDetailScreen` for whichever
/// agent is currently selected here). Also added: staleness-request
/// guards on `_loadTargets`/`_loadTasks` (switching agent/period/date
/// quickly used to be able to let an older response overwrite a newer
/// one with the wrong agent's data), `AnimatedSwitcher` crossfades
/// instead of a hard flash between loading/loaded content, and a lazy
/// `ListView.builder` for the task list instead of building every card
/// up front -- together these are the "optimise it & make it smooth"
/// pass.
///
/// **2026-09-22 second follow-up**: the date picker (a plain button
/// opening `showDatePicker`) is replaced with the SAME calendar strip
/// the field worker's own screen uses (`table_calendar`, Month/Week
/// toggle, month/year jump picker -- see `_calendarCard` below); tapping
/// a task now navigates to that task's own detail screen the same way
/// the field worker's `_openTask` does (`_openTask` below), instead of
/// the generic read-only bottom sheet this screen showed before; and
/// `_loadAgents` now also shows Yash to a Sub Administrator regardless
/// of location (see that method's doc comment).
class AdminTargetAndTasksHome extends StatefulWidget {
  const AdminTargetAndTasksHome({super.key});

  @override
  State<AdminTargetAndTasksHome> createState() =>
      _AdminTargetAndTasksHomeState();
}

class _AdminTargetAndTasksHomeState extends State<AdminTargetAndTasksHome> {
  static const List<Map<String, String>> _allAgents = [
    {"name": "Ravi Kumar", "number": "9711275300", "location": "Sultanpur"},
    {"name": "Faizan Khan", "number": "9971172204", "location": "Sultanpur"},
    {"name": "Yash", "number": "9211335993", "location": "Sultanpur"},
    {"name": "Shivam", "number": "9711775300", "location": "Sultanpur"},
    {"name": "Aakash", "number": "92113 35994", "location": "Sultanpur"},
  ];

  final _targetService = TargetService();
  final _taskService = TaskFeedService();

  List<Map<String, String>> _agents = [];
  Map<String, String>? _selected;
  bool _loadingAgents = true;

  TargetPeriod _period = TargetPeriod.today;
  List<TargetProgress> _targets = [];
  bool _loadingTargets = false;
  int _targetsRequestId = 0;

  // ---- calendar state (2026-09-22) -- same field names/values as the
  // field worker's own `target_and_tasks_home.dart`, so its calendar
  // methods below could be reused unchanged rather than rewritten
  // against different state.
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  String _calendarView = 'Week';
  int _pickerMonth = DateTime.now().month;
  int _pickerYear = DateTime.now().year;
  static const int _firstPickerYear = 2023;
  static const int _lastPickerYear = 2030;
  static final List<int> _years = List.generate(
      _lastPickerYear - _firstPickerYear + 1, (i) => _firstPickerYear + i);
  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  String _monthName(int m) => _months[m - 1];

  /// Whichever date was tapped on the calendar, or today's focused
  /// month/page if none was tapped yet -- same fallback as the field
  /// worker's own `_activeDate`.
  DateTime get _activeDate => _selectedDay ?? _focusedDay;

  List<AgentTask> _tasks = [];
  bool _loadingTasks = false;
  int _tasksRequestId = 0;

  @override
  void initState() {
    super.initState();
    _loadAgents();
  }

  Future<void> _loadAgents() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('post');
    final location = (prefs.getString('location') ?? '').trim().toLowerCase();

    if (role == 'Administrator') {
      _agents = List.from(_allAgents);
    } else {
      // Sub Administrator: own-location agents, PLUS Yash specifically
      // (2026-09-22 per explicit request "add Yash for sub admin too")
      // -- Yash is in Rajpur Khurd, a different location from the other
      // two agents (Sultanpur), so the plain location filter below was
      // excluding him for a Sultanpur-based sub-admin. Deliberately
      // narrow: Yash by name, not "show every agent regardless of
      // location" -- broadening the location filter itself wasn't asked
      // for.
      _agents = _allAgents
          .where((a) =>
              (a['location'] ?? '').trim().toLowerCase() == location ||
              a['name'] == 'Yash')
          .toList();
    }

    if (!mounted) return;
    setState(() {
      _selected = _agents.isNotEmpty ? _agents.first : null;
      _loadingAgents = false;
    });

    if (_selected != null) {
      await Future.wait([_loadTargets(), _loadTasks()]);
    }
  }

  Future<void> _loadTargets() async {
    if (_selected == null) return;
    // Staleness guard (2026-09-22), mirroring the field worker's own
    // `target_and_tasks_home.dart` -- added here because admin switches
    // agent/period far more often than a field worker switches period:
    // tapping a second agent or period before the first response lands
    // used to let an older, slower response overwrite the newer
    // selection with the wrong agent's numbers.
    final requestId = ++_targetsRequestId;
    setState(() => _loadingTargets = true);
    final data = await _targetService.fetchProgress(
      fieldWorkerNumber: _selected!['number']!,
      fieldWorkerName: _selected!['name']!,
      period: _period,
    );
    if (!mounted || requestId != _targetsRequestId) return;
    setState(() {
      _targets = data;
      _loadingTargets = false;
    });
  }

  Future<void> _loadTasks() async {
    if (_selected == null) return;
    // Same staleness guard as `_loadTargets()` -- switching agent or
    // picking a new date quickly could otherwise let an older agent's/
    // date's response land after a newer one and overwrite it.
    final requestId = ++_tasksRequestId;
    setState(() => _loadingTasks = true);
    final data = await _taskService.fetchTasksForDate(
      fieldWorkerNumber: _selected!['number']!,
      fieldWorkerName: _selected!['name']!,
      date: _activeDate,
    );
    if (!mounted || requestId != _tasksRequestId) return;
    setState(() {
      _tasks = data;
      _loadingTasks = false;
    });
  }

  /// Tasks shown in the generic date-scoped list below the owner-calls
  /// button. Owner-call tasks are excluded here -- they get their own
  /// dedicated section instead (`_ownerCallsSection`), the same single
  /// full-width gradient button design the field worker's own screen
  /// uses, rather than showing up a second time as individual task cards
  /// in this list. Added 2026-09-22 per explicit request: "Don't show
  /// building owner calling in task list instead of it just give the
  /// same UI card to navigate to the Ownercalling detail page."
  List<AgentTask> get _visibleTasks =>
      _tasks.where((t) => t.type != AgentTaskType.ownerCall).toList();

  List<AgentTask> get _ownerCallTasks =>
      _tasks.where((t) => t.type == AgentTaskType.ownerCall).toList();

  void _onAgentChanged(String? number) {
    if (number == null) return;
    setState(() => _selected = _agents.firstWhere((a) => a['number'] == number));
    Future.wait([_loadTargets(), _loadTasks()]);
  }

  void _onPeriodChanged(TargetPeriod period) {
    if (period == _period) return;
    setState(() => _period = period);
    _loadTargets();
  }

  /// Routes a tapped task to the SAME detail screen the field worker's
  /// own `target_and_tasks_home.dart` opens for it (that file's
  /// `_openTask`) -- replacing this screen's original generic read-only
  /// bottom sheet. Added 2026-09-22 per explicit request ("click of task
  /// don't show the same thing in bottomsheet instead of navigate to
  /// their related detailpage with id"). Every destination below is
  /// viewable the same way for an admin as for the field worker who owns
  /// the record -- none of these are action-only flows restricted to the
  /// field worker's own session -- so reusing the exact same navigation
  /// is safe, unlike the field worker's separate owner-call LOGGING
  /// sheet (`ownerCall` tasks are filtered out of this screen's task
  /// list entirely before they'd ever reach here -- see `_visibleTasks`
  /// -- so that case below is unreachable in practice; it's kept only so
  /// this switch stays exhaustive over `AgentTaskType`).
  void _openTask(AgentTask task) {
    switch (task.type) {
      case AgentTaskType.agreementFollowUp:
        {
          final id = task.raw['id'];
          if (id == null) break;
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AllDetailpage(agreementId: id.toString())));
          return;
        }

      case AgentTaskType.addFlat:
        {
          final propertyId = task.raw['P_id'];
          final subId = task.raw['subid'];
          if (propertyId == null || subId == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Couldn't open this flat's details.")),
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
          final id = task.raw['id'];
          if (id == null) break;
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => AgreementDetailPage(agreementId: id.toString())));
          return;
        }

      case AgentTaskType.agreementAccept:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const HistoryTab(defaultTabIndex: 1)));
        return;

      case AgentTaskType.buildingFollowUp:
        {
          final id = task.raw['id'];
          if (id == null) break;
          // Refresh on return, same as the field worker's own screen --
          // this is exactly where a building record could be added or
          // changed.
          Navigator.push(context,
                  MaterialPageRoute(builder: (_) => Future_Property_details(idd: id.toString())))
              .then((_) {
            if (mounted) _loadTasks();
          });
          return;
        }

      case AgentTaskType.ownerCall:
        return;

      case AgentTaskType.tenantDemand:
        {
          final id = task.raw['id'];
          if (id == null) break;
          // `isReadOnly: true` -- DemandDetail's own flag for exactly
          // this case (default is "= fieldworker", i.e. editable); admin
          // is viewing, not performing, this task.
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DemandDetail(demandId: id.toString(), isReadOnly: true)));
          return;
        }

      case AgentTaskType.bookVisit:
        {
          final id = task.raw['id'];
          if (id == null) break;
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DemandDetail(demandId: id.toString(), isReadOnly: true)));
          return;
        }

      case AgentTaskType.upcomingFlat:
        {
          final id = int.tryParse(task.raw['P_id']?.toString() ?? '');
          if (id == null) break;
          Navigator.push(context, MaterialPageRoute(builder: (_) => UpcomingDetailsPage(id: id)));
          return;
        }

      case AgentTaskType.websiteVisit:
        {
          // Per explicit request ("on web query launch the url"): opens
          // the public listing page in the browser -- same as the field
          // worker's own screen, and the same as this task type has
          // always worked; it never had an in-app detail screen.
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Couldn't open this task's details.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_loadingAgents) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_agents.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tasks & Targets')),
        body: const Center(child: Text('No agents found for your location.')),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tasks & Targets'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.wait([_loadTargets(), _loadTasks()]),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _agentPicker(isDark),
            const SizedBox(height: 14),
            _periodTabs(isDark),
            const SizedBox(height: 12),
            _targetsSection(isDark),
            const SizedBox(height: 22),
            _ownerCallsSection(isDark),
            const SizedBox(height: 22),
            _sectionHeader(context, 'Calendar', trailing: _calendarFormatToggle()),
            const SizedBox(height: 10),
            _calendarCard(isDark),
            const SizedBox(height: 20),
            _sectionHeader(context, _tasksHeadingFor(_activeDate)),
            const SizedBox(height: 10),
            _tasksSection(isDark),
          ],
        ),
      ),
    );
  }

  Widget _agentPicker(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF171B22) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF2A3040) : const Color(0xFFDDE3EC)),
      ),
      child: Row(
        children: [
          Icon(Icons.person_search_rounded, size: 20, color: isDark ? Colors.white70 : Colors.black54),
          const SizedBox(width: 8),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selected!['number'],
                items: _agents
                    .map((a) => DropdownMenuItem<String>(
                          value: a['number'],
                          child: Text(
                            '${a['name']} — ${a['location']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13.5,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: _onAgentChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _periodTabs(bool isDark) {
    Widget chip(String label, TargetPeriod period) {
      final active = _period == period;
      return Expanded(
        child: GestureDetector(
          onTap: () => _onPeriodChanged(period),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF135BEC) : (isDark ? const Color(0xFF171B22) : Colors.grey.shade200),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: active ? Colors.white : (isDark ? Colors.white60 : Colors.black54),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        chip('Today', TargetPeriod.today),
        chip('Monthly', TargetPeriod.monthly),
        chip('Yearly', TargetPeriod.yearly),
      ],
    );
  }

  Widget _targetsSection(bool isDark) {
    // `AnimatedSwitcher` (2026-09-22) -- crossfades between the loading
    // spinner, the empty state, and the loaded cards instead of an
    // instant hard swap, so switching agent/period doesn't flash. Each
    // branch gets its own `ValueKey` (including the agent number + period
    // in the loaded branch's key) so the switcher can tell loaded content
    // for a DIFFERENT agent/period apart from the previous agent/period's
    // content, not just "loading vs loaded".
    Widget child;
    if (_loadingTargets) {
      child = const Padding(
        key: ValueKey('targets-loading'),
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (_targets.isEmpty) {
      child = Padding(
        key: const ValueKey('targets-empty'),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'No target data for this agent.',
          style: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
        ),
      );
    } else {
      child = SizedBox(
        key: ValueKey('targets-${_selected?['number']}-$_period'),
        height: 168,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _targets.length,
          separatorBuilder: (_, __) => const SizedBox(width: 12),
          itemBuilder: (_, i) {
            final t = _targets[i];
            return TargetProgressCard(
              data: t,
              // Refresh this row on return (2026-09-22) -- matches the
              // field worker's own screen; previously this admin card
              // never refreshed after visiting a detail screen, so a
              // change made there wouldn't show up here without a manual
              // pull-to-refresh or an agent/period switch.
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: t.detailBuilder),
              ).then((_) {
                if (mounted) _loadTargets();
              }),
            );
          },
        ),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: child,
    );
  }

  /// The "Building Owner Calls" section for the currently SELECTED
  /// agent -- same single full-width gradient button design as the field
  /// worker's own screen (`target_and_tasks_home.dart`'s
  /// `_ownerCallsSection`), reused here independently (this project
  /// already duplicates small screen-specific widgets like this rather
  /// than sharing them -- see `Targets.dart`'s own agent list) so admin
  /// gets the same "Building Owner Calls" entry point instead of a pile
  /// of individual "Call owner — X" task cards mixed into the generic
  /// list below. Added 2026-09-22 per explicit request. Navigates to the
  /// SELECTED agent's `OwnerCallsDetailScreen` -- not admin's own, since
  /// admin has no owner-calling identity of its own.
  Widget _ownerCallsSection(bool isDark) {
    final calls = _ownerCallTasks;
    final agent = _selected!;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OwnerCallsDetailScreen(
              fieldWorkerNumber: agent['number']!,
              fieldWorkerName: agent['name'] ?? '',
            ),
          ),
        ),
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
                          : "View and log ${agent['name'] ?? 'this agent'}'s owner calls",
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

  /// Same Month/Week `PopupMenuButton` as the field worker's own screen
  /// (`table_calendar` only supports month/twoWeeks/week -- this doesn't
  /// invent a third).
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

  /// The calendar strip itself -- same widget, same wiring, as the field
  /// worker's own `_calendarCard`: a tappable "Month Year" title (opens
  /// the month/year jump picker) plus `TableCalendar`. Defaults to Week
  /// format, which reads as a single-row horizontal date slider -- the
  /// "same slider date selector" asked for (2026-09-22), replacing the
  /// old plain date-picker button.
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

  /// Same bottom-sheet month/year jump picker as the field worker's own
  /// screen -- `CupertinoPicker` for month and year, "Apply" moves
  /// `_focusedDay`/`_selectedDay` there and reloads that date's tasks.
  Future<void> _showMonthYearPicker() async {
    _pickerMonth = _focusedDay.month;
    _pickerYear = _focusedDay.year;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    // Created ONCE, before the sheet opens (not inside `StatefulBuilder`'s
    // `builder`, which re-runs on every `setModalState` call) -- same fix
    // as the field worker's own picker, for the same "jumping/resetting
    // mid-scroll" bug a per-rebuild controller would otherwise cause.
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

  String _tasksHeadingFor(DateTime date) {
    final today = DateTime.now();
    final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
    if (isToday) return "Today's tasks";
    return 'Tasks for ${date.day} ${_monthName(date.month).substring(0, 3)} ${date.year}';
  }

  Widget _tasksSection(bool isDark) {
    // Owner-call tasks are excluded (`_visibleTasks`, not `_tasks`) --
    // they now live only in `_ownerCallsSection` above, see that
    // method's doc comment. `AnimatedSwitcher` crossfades between
    // loading/empty/loaded instead of a hard flash, same as
    // `_targetsSection`. The loaded branch is a lazy `ListView.builder`
    // (2026-09-22) instead of eagerly mapping every task into a `Column`
    // up front -- a smoother scroll on agents with a long task list,
    // since off-screen `TaskTile`s are no longer built (or their images
    // decoded) until they're about to come on screen. `shrinkWrap` +
    // `NeverScrollableScrollPhysics` because this list sits inside the
    // outer page `ListView`, same nested-list pattern already used
    // elsewhere in this app.
    final visible = _visibleTasks;
    Widget child;
    if (_loadingTasks) {
      child = const Padding(
        key: ValueKey('tasks-loading'),
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    } else if (visible.isEmpty) {
      child = Padding(
        key: const ValueKey('tasks-empty'),
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'No tasks for this agent on the selected date.',
          style: TextStyle(color: isDark ? Colors.white54 : Colors.black45),
        ),
      );
    } else {
      final today = DateTime.now();
      child = ListView.builder(
        key: ValueKey(
          'tasks-${_selected?['number']}-${_activeDate.toIso8601String()}',
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: visible.length,
        itemBuilder: (_, i) {
          final task = visible[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: RepaintBoundary(
              child: TaskTile(
                task: task,
                urgency: task.urgencyRelativeTo(today),
                onTap: () => _openTask(task),
              ),
            ),
          );
        },
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 220),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: child,
    );
  }
}
