import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;

//// ================== MODELS ==================
class WorkerId {
  final String name;
  final String number;
  const WorkerId({required this.name, required this.number});
}

class WorkerStats {
  // overview (new)

  int totalFlatsUnderBuilding = 0;
  int liveFlatsUnderBuilding = 0;
  int rentOutFlatsUnderBuilding = 0; // "Book"

  // monthly/live counts
  int liveRent = 0;
  int liveBuy = 0;
  int liveCommercial = 0;
  int agreements = 0; // live agreements snapshot
  int buildings = 0; // overall building count

  // monthly booked window
  String? mStartRaw;
  String? mEndExclRaw;
  int mBooked = 0;
  int mRentBooked = 0; // rent_count
  int mBuyBooked = 0; // buy_count

  // --- NEW: monthly building & monthly agreements
  int mBuildings = 0; // monthly building count (separate endpoint)
  int mAgreements = 0; // monthly agreements (if available)

  // yearly booked window
  String? yStartRaw;
  String? yEndExclRaw;
  int yBooked = 0;

  // yearly live windows & achievements
  String rentStart = '';
  String rentEnd = '';
  int rentYearAchieved = 0;

  String buyStart = '';
  String buyEnd = '';
  int buyYearAchieved = 0;

  String comStart = '';
  String comEnd = '';
  int comYearAchieved = 0;

  String agrStart = '';
  String agrEnd = '';
  int agrYearAchieved = 0;

  // --- NEW: yearly building
  int yBuildings = 0;

  int bookBuyYear = 0;
  int bookRentYear = 0;
}

//// ================ PAGE ======================
class AllFieldWorkersPage extends StatefulWidget {
  const AllFieldWorkersPage({super.key});

  @override
  State<AllFieldWorkersPage> createState() => _AllFieldWorkersPageState();
}

class _AllFieldWorkersPageState extends State<AllFieldWorkersPage> {
  // Workers
  bool _loadingWorkers = true;
  String? _workersErr;

  final List<WorkerId> _workers = const [
    WorkerId(name: 'sumit', number: '9711775300'),
    WorkerId(name: 'ravi', number: '9711275300'),
    WorkerId(name: 'faizan', number: '9971172204'),
  ];
  final Map<String, WorkerStats> _stats = {};

  // Targets (same as your app)
  static const int _tRentMonth = 15, _tRentYear = 100;
  static const int _tBuyMonth = 5, _tBuyYear = 60;
  static const int _tComMonth = 5, _tComYear = 60;
  static const int _tAgrMonth = 15, _tAgrYear = 180;
  static const int _tBldMonth = 17, _tBldYear = 204;
  static const int _tBookBuyYear = 5,_tBookRentYear = 60;
  // ---------- Helpers ----------
  Uri _u(String path, [Map<String, String>? q]) => Uri.https('verifyserve.social', path, q);

  /// Tries `/Target/` and `/target/` so minor case differences don’t 404.
  Future<Map<String, dynamic>> _getJsonSmart({
    required String filePathWithTarget, // '/Second PHP FILE/Target/xyz.php'
    Map<String, String>? query,
    List<String> alsoTryFiles = const [],
  }) async {
    final attempts = <Uri>[
      _u(filePathWithTarget, query),
      _u(filePathWithTarget.replaceFirst('/Target/', '/target/'), query),
      ...alsoTryFiles.map((p) => _u(p, query)),
    ];
    Object? lastErr;
    for (final uri in attempts) {
      try {
        final r = await http.get(uri);
        if (r.statusCode == 200) {
          final txt = r.body.isEmpty ? '{}' : r.body;
          return json.decode(txt) as Map<String, dynamic>;
        } else {
          lastErr = 'HTTP ${r.statusCode} on $uri';
        }
      } catch (e) {
        lastErr = 'ERROR on ${uri.toString()}: $e';
      }
    }
    throw Exception(lastErr ?? 'All attempts failed');
  }

  int _asInt(dynamic v) => v is num ? v.toInt() : int.tryParse(v?.toString() ?? '0') ?? 0;
  String _day(String? raw) => (raw ?? '').split(' ').first;

  @override
  void initState() {
    super.initState();
    setState(() {
      _refreshAll();

    });
  }

  Future<void> _refreshAll() async {
    setState(() {
      _loadingWorkers = true;
      _workersErr = null;
    });
    try {
      _stats.clear();
      for (final w in _workers) {
        await _loadStatsForWorker(w.number.trim());
        if (!mounted) return;
        setState(() {}); // progressive paint
      }
    } catch (e) {
      _workersErr = e.toString();
    } finally {
      _loadingWorkers = false;
      if (mounted) setState(() {});
    }
  }

  // -------------------- UPDATED: full loader with monthly agreement & building + yearly building ---------------
  Future<void> _loadStatsForWorker(String number) async {
    final s = WorkerStats();

    Future<dynamic> _getAsmxData(String path, Map<String, String> query) async {
      try {
        final url = _u(path, query);
        final res = await http.get(url).timeout(const Duration(seconds: 4));
        if (res.statusCode == 200) {
          final body = res.body;
          final match = RegExp(r'\[.*\]').firstMatch(body);
          if (match != null) {
            return jsonDecode(match.group(0)!);
          }
        }
      } catch (_) {}
      return [];
    }

    Future<Map<String, dynamic>> quick(String path, Map<String, String> query) async {
      try {
        return await _getJsonSmart(
          filePathWithTarget: path,
          query: query,
        ).timeout(const Duration(seconds: 4));
      } catch (_) {
        return {};
      }
    }

    try {
      // Run all APIs in parallel
      final results = await Future.wait([

        // 0️⃣  TOTAL FLATS UNDER BUILDING (All flats in all buildings)
        _getAsmxData(
          '/WebService4.asmx/GetTotalFlats_under_building',
          {'field_workar_number': number},
        ),

        // 1️⃣  LIVE + UNLIVE FLATS COUNT (filters inside code)
        _getAsmxData(
          '/WebService4.asmx/GetTotalFlats_Live_under_building',
          {'field_workar_number': number},
        ),

        // -------------------- MONTHLY + CURRENT LIVE ----------------------

        // 2️⃣ MONTHLY LIVE RENT FLATS (LIVE RENT only)
        quick(
          '/Second PHP FILE/Target/count_api_live_flat_for_field.php',
          {'field_workar_number': number},
        ),

        // 3️⃣ MONTHLY BOOK (TOTAL) + rent_count + buy_count
        quick(
          '/Second PHP FILE/Target/count_api_for_book_flat_for_month.php',
          {'field_workar_number': number},
        ),

        // 4️⃣ MONTHLY LIVE BUY FLATS
        quick(
          '/Second PHP FILE/Target/count_api_live_flat_for_buy_field.php',
          {'field_workar_number': number},
        ),

        // 5️⃣ MONTHLY LIVE COMMERCIAL FLATS
        quick(
          '/Second PHP FILE/Target/count_api_live_commercial_space.php',
          {'field_workar_number': number},
        ),

        // 6️⃣ MONTHLY AGREEMENTS (Version 1)
        quick(
          '/Second PHP FILE/Target/count_api_for_agreement.php',
          {'Fieldwarkarnumber': number},
        ),

        // 7️⃣ TOTAL AGREEMENTS (fallback)
        quick(
          '/Second PHP FILE/Target/show_tatal_agreement.php',
          {'Fieldwarkarnumber': number},
        ),

        // 8️⃣ MONTHLY BUILDING COUNT
        quick(
          '/Second PHP FILE/Target/count_api_for_building.php',
          {'fieldworkarnumber': number},
        ),

        // -------------------- YEARLY TARGET DATA ----------------------

        // 9️⃣ YEARLY BOOK FLATS (TOTAL + rent_count + buy_count)
        quick(
          '/Second PHP FILE/Target/count_for_book_flat_yearly.php',
          {'field_workar_number': number},
        ),

        // 🔟 YEARLY LIVE RENT FLATS
        quick(
          '/Second PHP FILE/Target/count_live_flat_rent_yearly.php',
          {'field_workar_number': number},
        ),

        // 1️⃣1️⃣ YEARLY LIVE BUY FLATS
        quick(
          '/Second PHP FILE/Target/count_api_for_buy_live_flat_yearly.php',
          {'field_workar_number': number},
        ),

        // 1️⃣2️⃣ YEARLY COMMERCIAL FLATS
        quick(
          '/Second PHP FILE/Target/commerical_count_yearly.php',
          {'field_workar_number': number},
        ),

        // 1️⃣3️⃣ YEARLY AGREEMENTS
        quick(
          '/Second PHP FILE/Target/count_api_agreement_yarly.php',
          {'Fieldwarkarnumber': number},
        ),

        // 1️⃣4️⃣ YEARLY BUILDING COUNT
        quick(
          '/Second PHP FILE/Target/count_api_for_building_yearly.php',
          {'fieldworkarnumber': number},
        ),
      ]);


      // Safety helper to get `data` map from results (returns null if missing)
      Map? _dataAt(int idx) {
        if (idx < 0 || idx >= results.length) return null;
        final r = results[idx];
        if (r is Map && r.containsKey('data')) return r['data'] as Map?;
        return null;
      }

      // ASMX Overview
      final totalList = results.isNotEmpty ? results[0] : null;
      if (totalList is List && totalList.isNotEmpty) {
        s.totalFlatsUnderBuilding = _asInt(totalList.first['subid']);
      }

      final liveList = results.length > 1 ? results[1] : null;
      if (liveList is List) {
        for (final i in liveList) {
          final status = '${i['live_unlive']}'.toLowerCase();
          final subid = _asInt(i['subid']);
          if (status.contains('live')) s.liveFlatsUnderBuilding = subid;
          if (status.contains('book')) s.rentOutFlatsUnderBuilding = subid;
        }
      }

      // -------- Monthly / Live --------
      final rentLive = _dataAt(2);
      final mt = _dataAt(3);
      final buy = _dataAt(4);
      final com = _dataAt(5);
      final agr = _dataAt(6);
      final agr2 = _dataAt(7);
      final bld = _dataAt(8);

      // Use _pickCount for resilient key selection where backend varies
      s.liveRent = _pickCount(rentLive, ['total_live_rent_flat', 'logg', 'total']);
      s.liveBuy = _pickCount(buy, ['total_live_buy_flat', 'total_live_rent_flat', 'logg']);
      s.liveCommercial = _pickCount(com, ['total_live_commercial', 'total_live_rent_flat', 'logg']);

      s.mStartRaw = ((mt?['period_start'] as Map?)?['date'] ?? '').toString();
      s.mEndExclRaw = ((mt?['period_end_excl'] as Map?)?['date'] ?? '').toString();

      s.mBooked = _pickCount(mt, ['total_booked']);
      s.mRentBooked = _pickCount(mt, ['rent_count']);
      s.mBuyBooked = _pickCount(mt, ['buy_count']);

      s.agreements = _pickCount(agr, ['total_agreements', 'agreements', 'logg']);
      if (s.agreements == 0) {
        s.agreements = _pickCount(agr2, ['logg']);
      }
      s.buildings = _pickCount(bld, ['logg', 'total_building']);

      // -------- Yearly --------
      final yt = _dataAt(9);
      final yrRent = _dataAt(10);
      final yrBuy = _dataAt(11);
      final yrCom = _dataAt(12);
      final yrAgr = _dataAt(13);
      final yrBld = _dataAt(14);

      s.yStartRaw = ((yt?['period_start'] as Map?)?['date'] ?? '').toString();
      s.yEndExclRaw = ((yt?['period_end_excl'] as Map?)?['date'] ?? '').toString();

      s.yBooked = _pickCount(yt, ['total_booked']);
      s.bookBuyYear = _pickCount(yt, ['buy_count']);
      s.bookRentYear = _pickCount(yt, ['rent_count']);

      s.rentYearAchieved = _pickCount(yrRent, ['total_live_rent_flat', 'total_live_rent']);
      s.buyYearAchieved = _pickCount(yrBuy, ['total_live_buy_flat', 'total_live_rent_flat']);
      s.comYearAchieved = _pickCount(yrCom, ['total_live_commercial', 'total_live_rent_flat']);
      s.agrYearAchieved = _pickCount(yrAgr, ['total_agreements', 'total_agreements']);
      s.yBuildings = _pickCount(yrBld, ['total_building', 'logg']);

      // Save
      _stats[number] = s;
    } catch (e) {
      // If any unexpected error happens, keep a safe empty stats and continue.
      debugPrint('⚠️ _loadStatsForWorker error for $number: $e');
      _stats[number] = s;
    }
  }

// Reusable resilient picker (kept in your class)
  int _pickCount(Map? d, List<String> keys) {
    if (d == null) return 0;
    for (final k in keys) {
      final v = d[k];
      if (v != null) return _asInt(v);
    }
    return 0;
  }


  // ================== UI ==================
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.deepPurple[700],
          elevation: 2,
          title: Text(
            'All Field Workers',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              letterSpacing: 0.5,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.deepPurple[600],
              ),
              child: IconButton(
                icon: const Icon(
                  PhosphorIcons.arrow_clockwise,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: _refreshAll,
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
              child: const TabBar(
                dividerColor: Colors.transparent,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorColor: Colors.deepPurple,
                indicatorWeight: 3.0,
                labelColor: Colors.deepPurple,
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(iconMargin: EdgeInsets.zero, text: 'Overview'),
                  Tab(iconMargin: EdgeInsets.zero, text: 'Monthly'),
                  Tab(iconMargin: EdgeInsets.zero, text: 'Yearly'),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            _TabPane(child: _listOverview()),
            _TabPane(child: _listMonthly()),
            _TabPane(child: _listYearly()),
          ],
        ),
      ),
    );
  }

  // ---------- OVERVIEW TAB (per worker) ----------
  Widget _listOverview() {
    if (_loadingWorkers) return const _LoadingPane();
    if (_workersErr != null) return _ErrorPane(_workersErr!);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _workers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final w = _workers[i];
        final s = _stats[w.number.trim()];
        return _overviewCard(context, w, s);
      },
    );
  }

  Widget _overviewCard(BuildContext context, WorkerId w, WorkerStats? s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = {
      'sumit': Colors.teal,
      'ravi': Colors.deepPurple,
      'faizan': Colors.orange,
    }[w.name.toLowerCase()] ?? Colors.indigo;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [Colors.black, Colors.black54]
              : [Colors.white, Colors.grey.shade200],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? accent : accent,
          width: 1.2,
        ),
        // boxShadow: [
        //   BoxShadow(
        //     color: accent.withOpacity(0.25),
        //     blurRadius: 12,
        //     offset: const Offset(0, 6),
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _workerHeader(w, accent),
            const SizedBox(height: 12),

            if (s == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: CircularProgressIndicator(),
                ),
              )
            else
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  // 👇 Existing stats
                  _chipStat('Total Flats', s.totalFlatsUnderBuilding, Colors.blue),
                  _chipStat('Live Flats', s.liveFlatsUnderBuilding, Colors.green),
                  _chipStat('Unlive Flat', s.rentOutFlatsUnderBuilding, Colors.orange),

                  // 👇 New API-based values
                  _chipStat('Buildings', s.agreements, Colors.red),
                  _chipStat('Agreements', s.buildings, Colors.teal),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _chipStat(String label, int val, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(.7), color]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color)],
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text('$label: ', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        Text('$val', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
      ]),
    );
  }

  // ---------- MONTHLY TAB ----------
  Widget _listMonthly() {
    if (_loadingWorkers) return const _LoadingPane();
    if (_workersErr != null) return _ErrorPane(_workersErr!);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _workers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final w = _workers[i];
        final s = _stats[w.number.trim()];
        return _workerMonthlyCard(context, w, s);
      },
    );
  }

  // ---------- YEARLY TAB ----------
  Widget _listYearly() {
    if (_loadingWorkers) return const _LoadingPane();
    if (_workersErr != null) return _ErrorPane(_workersErr!);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _workers.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final w = _workers[i];
        final s = _stats[w.number.trim()];
        return _workerYearlyCard(context, w, s);
      },
    );
  }

  // Monthly-focused card
  Widget _workerMonthlyCard(BuildContext context, WorkerId w, WorkerStats? s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Color accent = {
      'sumit': Colors.teal,
      'ravi': Colors.deepPurple,
      'faizan': Colors.orange,
    }[w.name.toLowerCase()] ?? Colors.green;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: isDark ? [Colors.black, Colors.black54] : [Colors.white, const Color(0xFFEFFBF2)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent, width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _workerHeader(w, accent),
          const SizedBox(height: 12),
          if (s == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
              ),
            )
          else ...[
            Row(children: [
              Expanded(child: _smallKpi('Booked Rent (M)', s.mRentBooked, _tRentMonth, Colors.blueAccent)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _smallKpi('Live Rent', s.liveRent, _tRentMonth, Colors.cyan)),
              const SizedBox(width: 8),
              Expanded(child: _smallKpi('Live Buy', s.liveBuy, _tBuyMonth, Colors.redAccent)),
            ]),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(child: _smallKpi('Commercial (M)', s.liveCommercial, _tComMonth, Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _smallKpi('Agreements (M)', s.mAgreements, _tAgrMonth, Colors.lime),),
            ]),
            const SizedBox(height: 10),
            // monthly agreements KPI
            const SizedBox(height: 8),
            Text(
              (s.mStartRaw != null && s.mEndExclRaw != null)
                  ? "Cycle: ${_day(s.mStartRaw)} → ${_day(s.mEndExclRaw)}"
                  : "Cycle: —",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade800, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ]),
      ),
    );
  }

  // Yearly-focused card
  Widget _workerYearlyCard(BuildContext context, WorkerId w, WorkerStats? s) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = {
      'sumit': Colors.teal,
      'ravi': Colors.deepPurple,
      'faizan': Colors.orange,
    }[w.name.toLowerCase()] ?? Colors.green;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: isDark ? [Colors.black, Colors.black54] : [Colors.white, const Color(0xFFFFFAEC)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: accent.withOpacity(0.35), width: 1.2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _workerHeader(w, accent),
          const SizedBox(height: 12),
          if (s == null)
            const Center(child: Padding(padding: EdgeInsets.symmetric(vertical: 10), child: CircularProgressIndicator()))
          else ...[
            Row(children: [
              Expanded(child: _smallKpi('Book Rent (Y)', s.bookRentYear, _tBookRentYear, Colors.green)),
              const SizedBox(width: 8),
              Expanded(child: _smallKpi('Book Buy (Y)', s.bookBuyYear, _tBookBuyYear, Colors.blueGrey)),
            ]),

            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _smallKpi('Live Rent (Y)', s.rentYearAchieved, _tRentYear, Colors.blue)),
              const SizedBox(width: 8),
              Expanded(child: _smallKpi('Live Buy (Y)', s.buyYearAchieved, _tBuyYear, Colors.deepPurple)),
            ]),


            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: _smallKpi('Commercial (Y)', s.comYearAchieved, _tComYear, Colors.orange)),
              const SizedBox(width: 8),
              Expanded(child: _smallKpi('Agreements (Y)', s.agrYearAchieved, _tAgrYear, Colors.redAccent)),
            ]),
            const SizedBox(height: 8),
            // Row(children: [
            //   Expanded(child: _smallKpi('Building (Y)', s.yBuildings, _tBldYear, Colors.teal)),
            // ]),
            const SizedBox(height: 8),
            Text(
              (s.yStartRaw?.isNotEmpty == true && s.yEndExclRaw?.isNotEmpty == true)
                  ? "Cycle: ${_day(s.yStartRaw)} → ${_day(s.yEndExclRaw)}"
                  : "Cycle: —",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade800, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ]),
      ),
    );
  }

  Widget _workerHeader(WorkerId w, Color accent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        CircleAvatar(backgroundColor: accent.withOpacity(0.9), radius: 20, child: const Icon(Icons.person, color: Colors.white)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(w.name.toUpperCase(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: isDark ? Colors.white : Colors.black)),
          Text(w.number, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isDark ? Colors.white70 : Colors.grey.shade700)),
        ])),
        Icon(Icons.trending_up_rounded, color: accent),
      ],
    );
  }

  Widget _smallKpi(String title, int live, int target, Color color) {
    final fixedLive = live < 0 ? 0 : live;
    final remain = (target - fixedLive).clamp(0, target);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [color.withOpacity(.65), color]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: target == 0 ? 0 : (live / target).clamp(0.0, 1.0),
                  minHeight: 10,
                  backgroundColor: Colors.white24,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('$live/$target', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 6),
        Text('Remaining: $remain', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
      ]),
    );
  }
}

//// ---------- Wrappers / utils for layout ----------
class _TabPane extends StatelessWidget {
  final Widget child;
  const _TabPane({required this.child});
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(padding: const EdgeInsets.all(14), child: child);
  }
}

class _LoadingPane extends StatelessWidget {
  const _LoadingPane();
  @override
  Widget build(BuildContext context) => const Center(child: Padding(
    padding: EdgeInsets.symmetric(vertical: 24),
    child: CircularProgressIndicator(),
  ));
}

class _ErrorPane extends StatelessWidget {
  final String msg;
  const _ErrorPane(this.msg);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(.25)),
      ),
      child: Text(msg, style: TextStyle(color: Colors.red.shade700)),
    );
  }
}
