import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Statistics/Progressbar.dart';
import 'utilities/bug_founder_fuction.dart';

class TargetMonthlyResult {
  final DateTime periodStartUtc;
  final DateTime periodEndExclUtc;
  final int totalBooked;

  // raw strings from API (exactly what came over the wire)
  final String periodStartRaw;
  final String periodEndExclRaw;

  const TargetMonthlyResult({
    required this.periodStartUtc,
    required this.periodEndExclUtc,
    required this.totalBooked,
    required this.periodStartRaw,
    required this.periodEndExclRaw,
  });

  static DateTime _parseBackendDate(Map<String, dynamic>? obj) {
    final raw = obj?['date']?.toString() ?? '';
    final dt = DateTime.tryParse(raw.replaceFirst(' ', 'T'))
        ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);
    return dt.isUtc ? dt : dt.toUtc();
  }

  factory TargetMonthlyResult.fromRoot(Map<String, dynamic> root) {
    final d = (root['data'] as Map?) ?? const {};
    final startMap = d['period_start'] as Map<String, dynamic>?;
    final endMap   = (d['period_end_excl'] ?? d['period_end']) as Map<String, dynamic>?;

    final startRaw = startMap?['date']?.toString() ?? '';
    final endRaw   = endMap?['date']?.toString() ?? '';

    return TargetMonthlyResult(
      periodStartUtc: _parseBackendDate(startMap),
      periodEndExclUtc: _parseBackendDate(endMap),
      totalBooked: int.tryParse((d['total_booked'] ?? d['achieved'] ?? '0').toString()) ?? 0,
      periodStartRaw: startRaw,
      periodEndExclRaw: endRaw,
    );
  }
}

class Target_Monthly extends StatefulWidget {
  const Target_Monthly({super.key}); // no external inputs anymore

  @override
  State<Target_Monthly> createState() => _Target_MonthlyState();
}

class _Target_MonthlyState extends State<Target_Monthly> {
  // API result
  int _liveCount = 0;

  // Targets
  static const int _overallTarget = 100;
  static const int _monthlyTarget = 15;
  int _buyLiveCount = 0;
  String? _buyErr;

  // Loading & error
  bool _loadingLive = true;
  String? _liveErr;

// extra targets
  static const int _moreMonthlyTarget = 5;
  static const int _moreYearlyTarget = _moreMonthlyTarget * 12; // 60
  int _commercialLiveCount = 0;
  String? _commercialErr;
  static const int _commercialMonthlyTarget = 5;
  static const int _agreementMonthlyTarget = 15;
  int _agreementCount = 0;
  String? _agreementErr;
  int _buildingCount = 0;
  String? _buildingErr;


  DateTime? _mtStartUtc, _mtEndExclUtc;
// in _Target_MainPageState
  String? _mtStartRaw, _mtEndExclRaw; // exactly as API returns
  int _mtAchieved = 0;                // from total_booked
  int _mtTarget = 5;
  bool _mtLoading = false;
  String? _mtError;
  bool _ytLoading = false;
  String? _ytError;

  String? _ytStartRaw, _ytEndExclRaw; // exact strings from API
  int _ytAchieved = 0;
  static const int _ytTarget = 5;
  static const int _ytTargetRent = 60;
  @override
  void initState() {
    super.initState();
    _bootstrap();
  }


  Future<void> _bootstrap() async {
    await _loaduserdata();
    debugPrint('FieldWorker number: $_number');

    await _fetchAll();
  }

  Future<void> _fetchAll() async {
    if (_number.isEmpty) {
      setState(() {
        _loadingLive = false;
        _liveErr = 'No user number found in SharedPreferences';
      });
      return;
    }

    setState(() {
      _loadingLive = true;
      _liveErr = null;
      _buyErr = null;
      _agreementErr = null;
      _commercialErr = null;
      _buildingErr = null;

    });

    await Future.wait([
      _fetchLiveCount(),
      _fetchBuyLiveCount(),
      _fetchCommercialLiveCount(),
      _fetchAgreementCount(),
      _fetchBuildingCount(),
      _loadMonthlyTarget(),
    ]);

    if (!mounted) return;
    setState(() {
      _loadingLive = false;
    });
  }

  String _number = '';
  String _SUbid = '';
  Map<String, dynamic>? _mtData;
  Map<String, dynamic>? _ytData;


  bool _yrRentLoading = false;
  String? _yrRentError;
  String? _yrRentStartRaw, _yrRentEndExclRaw;
  int _yrRentAchieved = 0;
  Map<String, dynamic>? _yrRentData;


  bool _yrBuyLoading = false;
  String? _yrBuyError;
  String? _yrBuyStartRaw, _yrBuyEndExclRaw;
  int _yrBuyAchieved = 0;
  Map<String, dynamic>? _yrBuyData;


  bool _yrComLoading = false;
  String? _yrComError;
  String? _yrComStartRaw, _yrComEndExclRaw;
  int _yrComAchieved = 0;
  Map<String, dynamic>? _yrComData;


  bool _yrAgrLoading = false;
  String? _yrAgrError;
  String? _yrAgrStartRaw, _yrAgrEndExclRaw;
  int _yrAgrAchieved = 0;
  Map<String, dynamic>? _yrAgrData;


  Future<void> _loadMonthlyTarget() async {
    setState(() {
      _mtLoading = true;
      _mtError = null;
    });

    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_book_flat_for_month.php'
          '?field_workar_number=$_number',
    );

    try {
      final resp = await http.get(uri);

      // 🔴 HTTP ERROR
      if (resp.statusCode != 200) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: resp.body.toString(),
          statusCode: resp.statusCode,
        );
        throw Exception('HTTP ${resp.statusCode}');
      }

      final root = json.decode(resp.body) as Map<String, dynamic>;

      // 🔴 API LOGIC ERROR
      if (root['success'] != true) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: resp.body.toString(),
          statusCode: 200,
        );
        throw Exception('API returned success=false');
      }

      final d = (root['data'] as Map?) ?? const {};
      final start   = ((d['period_start'] as Map?)?['date'] ?? '').toString();
      final endExcl = ((d['period_end_excl'] as Map?)?['date'] ?? '').toString();
      final booked  = (d['total_booked'] as num?)?.toInt() ?? 0;

      if (!mounted) return;
      setState(() {
        _mtStartRaw   = start;
        _mtEndExclRaw = endExcl;
        _mtAchieved   = booked;
        _mtData       = Map<String, dynamic>.from(d);
      });
    } catch (e, stack) {
      // 🔴 RUNTIME / PARSE ERROR
      await BugLogger.log(
        apiLink: uri.toString(),
        error: '$e\n$stack',
        statusCode: 0,
      );

      if (!mounted) return;
      setState(() {
        _mtError = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _mtLoading = false;
        });
      }
    }
  }


  Future<void> _loaduserdata() async {
    final prefs = await SharedPreferences.getInstance();
    final n = prefs.getString('number') ?? '';
    final s = prefs.getString('id_future') ?? '';
    setState(() {
      _number = n;
      _SUbid = s;
    });
  }

  Future<TargetMonthlyResult> fetchMonthlyTargetForAgent({
    required int fieldWorkerNumber,
  }) async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Target/'
          'count_api_for_book_flat_for_month.php?field_workar_number=$fieldWorkerNumber',
    );

    try {
      final resp = await http.get(uri);

      // 🔴 HTTP ERROR
      if (resp.statusCode != 200) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: resp.body.toString(),
          statusCode: resp.statusCode,
        );
        throw Exception('HTTP ${resp.statusCode}');
      }

      final root = json.decode(resp.body) as Map<String, dynamic>;

      // 🔴 API LOGIC ERROR
      if (root['success'] != true) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: resp.body.toString(),
          statusCode: 200,
        );
        throw Exception('API returned success=false');
      }

      // ✅ SUCCESS → NO BUGLOGGER
      return TargetMonthlyResult.fromRoot(root);
    } catch (e, stack) {
      // 🔴 NETWORK / PARSE ERROR
      await BugLogger.log(
        apiLink: uri.toString(),
        error: '$e\n$stack',
        statusCode: 0,
      );
      rethrow;
    }
  }



  Future<void> _fetchBuildingCount() async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Target/'
          'count_api_for_building.php?fieldworkarnumber=$_number',
    );

    try {
      final res = await http.get(uri).timeout(const Duration(seconds: 8));

      // 🔴 HTTP ERROR → LOG FIRST
      if (res.statusCode != 200) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: res.statusCode,
        );
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = jsonDecode(res.body);

      // 🔴 API FAILURE WITH 200 STATUS
      if (body is Map && body['success'] == false) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: 200,
        );
        throw Exception('API returned success=false');
      }

      final data = body['data'];
      final count = (data is Map && data['logg'] != null)
          ? int.tryParse(data['logg'].toString()) ?? 0
          : 0;

      if (!mounted) return;

      setState(() {
        _buildingCount = count;
        _buildingErr = null;
      });
    } catch (e, stack) {
      // 🔴 NETWORK / TIMEOUT / PARSE ERROR
      await BugLogger.log(
        apiLink: uri.toString(),
        error: '$e\n$stack',
        statusCode: 0,
      );

      if (!mounted) return;
      setState(() {
        _buildingCount = 0;
        _buildingErr = 'Failed to load building count';
      });
    }
  }


  Future<void> _fetchBuyLiveCount() async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_flat_for_buy_field.php?field_workar_number=$_number',
    );

    try {
      final res = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      // 🔴 HTTP ERROR → LOG FIRST
      if (res.statusCode != 200) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: res.statusCode,
        );
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = jsonDecode(res.body);

      // 🔴 API FAILURE WITH 200 STATUS
      if (body is Map && body['success'] == false) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: 200,
        );
        throw Exception('API returned success=false');
      }

      final data = body['data'] ?? {};

      int count = 0;
      if (data is Map) {
        count =
            (data['total_live_buy_flat'] ??
                data['total_live_rent_flat'] ??
                data['total_live'] ??
                data['logg'])
                ?.toInt() ??
                int.tryParse(
                  data['total_live_buy_flat']?.toString() ??
                      data['total_live_rent_flat']?.toString() ??
                      data['total_live']?.toString() ??
                      data['logg']?.toString() ??
                      '0',
                ) ??
                0;
      }

      if (!mounted) return;
      setState(() {
        _buyLiveCount = count;
        _buyErr = null;
      });
    } catch (e, stack) {
      // 🔴 NETWORK / TIMEOUT / PARSE ERROR
      await BugLogger.log(
        apiLink: uri.toString(),
        error: '$e\n$stack',
        statusCode: 0,
      );

      if (!mounted) return;
      setState(() {
        _buyLiveCount = 0;
        _buyErr = 'Failed to load buy live count';
      });
    }
  }


  Future<void> _fetchLiveCount() async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_flat_for_field.php?field_workar_number=$_number',
    );

    setState(() {
      _loadingLive = true;
      _liveErr = null;
    });

    try {
      final res = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      // 🔴 HTTP ERROR → LOG FIRST
      if (res.statusCode != 200) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: res.statusCode,
        );
        throw Exception('HTTP ${res.statusCode}');
      }

      final root = jsonDecode(res.body);

      // 🔴 API LOGIC ERROR (200 but success=false)
      if (root is Map && root['success'] == false) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: 200,
        );
        throw Exception('API returned success=false');
      }

      final data = root['data'] as Map?;
      final count =
          (data?['total_live_rent_flat'] as num?)?.toInt() ?? 0;

      if (!mounted) return;

      setState(() {
        _liveCount = count;
        _liveErr = null;
      });
    } catch (e, stack) {
      // 🔴 NETWORK / TIMEOUT / PARSE ERROR
      await BugLogger.log(
        apiLink: uri.toString(),
        error: '$e\n$stack',
        statusCode: 0,
      );

      if (!mounted) return;
      setState(() {
        _liveCount = 0;
        _liveErr = 'Failed to load live count';
      });
    } finally {
      if (mounted) {
        setState(() {
          _loadingLive = false;
        });
      }
    }
  }


  Future<void> _fetchCommercialLiveCount() async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_commercial_space.php?field_workar_number=$_number',
    );

    try {
      final res = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      // 🔴 HTTP ERROR → LOG FIRST
      if (res.statusCode != 200) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: res.statusCode,
        );
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = jsonDecode(res.body);

      // 🔴 API LOGIC ERROR (200 but success=false)
      if (body is Map && body['success'] == false) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: 200,
        );
        throw Exception('API returned success=false');
      }

      final data = body['data'] ?? {};
      int count = 0;

      if (data is Map) {
        count =
            (data['total_live_commercial'] ??
                data['total_live_rent_flat'] ??
                data['total_live'] ??
                data['logg'])
                ?.toInt() ??
                int.tryParse(
                  data['total_live_commercial']?.toString() ??
                      data['total_live_rent_flat']?.toString() ??
                      data['total_live']?.toString() ??
                      data['logg']?.toString() ??
                      '0',
                ) ??
                0;
      }

      if (!mounted) return;
      setState(() {
        _commercialLiveCount = count;
        _commercialErr = null;
      });
    } catch (e, stack) {
      // 🔴 NETWORK / TIMEOUT / PARSE ERROR
      await BugLogger.log(
        apiLink: uri.toString(),
        error: '$e\n$stack',
        statusCode: 0,
      );

      if (!mounted) return;
      setState(() {
        _commercialLiveCount = 0;
        _commercialErr = 'Failed to load commercial live count';
      });
    }
  }


  Future<void> _fetchAgreementCount() async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_agreement.php?Fieldwarkarnumber=$_number',
    );

    try {
      final res = await http
          .get(uri)
          .timeout(const Duration(seconds: 8));

      // 🔴 HTTP ERROR → LOG FIRST
      if (res.statusCode != 200) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: res.statusCode,
        );
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = jsonDecode(res.body);

      // 🔴 API LOGIC ERROR (200 but success=false)
      if (body is Map && body['success'] == false) {
        await BugLogger.log(
          apiLink: uri.toString(),
          error: res.body.toString(),
          statusCode: 200,
        );
        throw Exception('API returned success=false');
      }

      final data = body['data'] ?? {};
      int count = 0;

      if (data is Map) {
        final raw =
            data['total_agreements'] ??
                data['agreements'] ??
                data['logg'] ??
                data['total_agreement'] ??
                data['total'];

        count = raw is int
            ? raw
            : int.tryParse(raw?.toString() ?? '0') ?? 0;
      }

      if (!mounted) return;

      setState(() {
        _agreementCount = count;
        _agreementErr = null;
      });
    } catch (e, stack) {
      // 🔴 NETWORK / TIMEOUT / PARSE ERROR
      await BugLogger.log(
        apiLink: uri.toString(),
        error: '$e\n$stack',
        statusCode: 0,
      );

      if (!mounted) return;
      setState(() {
        _agreementCount = 0;
        _agreementErr = 'Failed to load agreement count';
      });
    }
  }


  int get _mtBuy  => (_mtData?['buy_count']  as num?)?.toInt() ?? 0;
  int get _mtRent => (_mtData?['rent_count'] as num?)?.toInt() ?? 0;


  @override
  Widget build(BuildContext context) {
    final overallPct = (_liveCount / _overallTarget).clamp(0.0, 1.0);
    final monthlyPct = (_liveCount / _monthlyTarget).clamp(0.0, 1.0);
    String _apiDay(String? raw) => (raw ?? '').split(' ').first; // "2025-11-10"

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
                PhosphorIcons.arrow_clockwise, color: Colors.white),
            onPressed: _fetchAll,
            tooltip: 'Refresh',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loadingLive
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const _HighlightBar(color: Colors.yellow, label: "Flat Booked For Rent"),

              const SizedBox(height: 8),
// Rent monthly pie
              _PieKpiCard(
                title: 'Monthly Rent',
                liveCount: _mtRent,
                target: _mtTarget,                 // same target number
                colorLive: Colors.green,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _mtRent,
              ),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.key_outlined, size: 18),
                          const SizedBox(width: 8),
                          const Text('Rent',style: TextStyle(fontWeight: FontWeight.w600),),
                          const Spacer(),
                          Text(
                            '${(_ytData?['rent_count'] as num?)?.toInt() ?? 0}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // ===================== RENT SECTION =====================
              const SizedBox(height: 16),

              const _HighlightBar(color: Colors.blue, label: "Live Flats (Rent)"),
              // const SizedBox(height: 8),
              _PieKpiCard(
                title: 'Monthly Target 15',
                liveCount: _liveCount,
                target: _monthlyTarget,
                colorLive: Colors.green,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _liveCount,
              ),
              const SizedBox(height: 8),

              // ===================== BUY SECTION =====================
              const _HighlightBar(color: Colors.deepPurple, label: "Live Flats (Buy)"),

              // const SizedBox(height: 8),

              _PieKpiCard(
                title: 'Monthly Target 5',
                liveCount: _buyLiveCount,
                target: _moreMonthlyTarget,
                colorLive: Colors.teal,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _buyLiveCount,
              ),
              const SizedBox(height: 8),

              // ===================== BUY SECTION =====================

              const _HighlightBar(color: Colors.cyan, label: "Commercial"),

// Commercial Monthly 5
              _PieKpiCard(
                title: 'Monthly Target 5',
                liveCount: _commercialLiveCount,
                target: _commercialMonthlyTarget,
                colorLive: Colors.orange.shade400,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _commercialLiveCount,
              ),
              const SizedBox(height: 8),

              // ===================== Agreements =====================

              const _HighlightBar(color: Colors.redAccent, label: "Agreements"),

// Agreements (Monthly 15)

              _PieKpiCard(
                title: 'Monthly Target 15',
                liveCount: _agreementCount,
                target: _agreementMonthlyTarget,
                colorLive: Colors.lime,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _agreementCount,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

}
class _HighlightBar extends StatelessWidget {
  final Color color;
  final Color? textcolor; // optional
  final String label;

  const _HighlightBar({
    required this.color,
    this.textcolor,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final resolvedTextColor = textcolor ??
        (isDark
            ?  Colors.white.withOpacity(0.95)
            : Colors.black.withOpacity(0.85));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [color.withOpacity(0.50), color.withOpacity(0.14)]
              : [color.withOpacity(0.40), color.withOpacity(0.04)],
        ),

        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(isDark ? 0.7 : 0.45),
          width: isDark?1:1.5,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: resolvedTextColor,
          letterSpacing: 0.6,
        ),
      ),
    );
  }
}

class _PieKpiCard extends StatelessWidget {
  final String title;
  final int liveCount;
  final int target;
  final Color colorLive;
  final Color colorRemain;
  final int? totalThisMonth;

  const _PieKpiCard({
    required this.title,
    required this.liveCount,
    required this.target,
    required this.colorLive,
    required this.colorRemain,
    this.totalThisMonth,
  });

  @override
  Widget build(BuildContext context) {
    final live = liveCount.clamp(0, target);
    final remain = (target - live).clamp(0, target);
    final pct = target == 0 ? 0.0 : live / target;

    return Card(
      color: Theme.of(context).brightness==Brightness.dark?Colors.white12:Colors.grey.shade200,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Pie chart
            SizedBox(
              width: 120,
              height: 120,
              child: TweenAnimationBuilder<double>(
                  key: ValueKey('$liveCount-$target'), // new data => new tween
                  duration: const Duration(milliseconds: 700),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: 0, end: liveCount.toDouble()),
                  builder: (_, anim, __) {
                    final sliceLive   = anim.clamp(0, target.toDouble());
                    final sliceRemain = (target - sliceLive).clamp(0, target.toDouble());
                    final pct         = target == 0 ? 0.0 : sliceLive / target;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          key: ValueKey('pie-$liveCount-$target'),
                          PieChartData(
                            startDegreeOffset: -90,
                            centerSpaceRadius: 34,
                            sectionsSpace: 2,
                            sections: [
                              PieChartSectionData(
                                value: live.toDouble(),
                                color: colorLive,       // <-- live color (blue overall, green monthly)
                                radius: 18,
                                showTitle: false,
                              ),
                              PieChartSectionData(
                                value: remain.toDouble(),
                                color: colorRemain,     // <-- remaining color
                                radius: 18,
                                showTitle: false,
                              ),
                            ],
                          ),
                          swapAnimationDuration: const Duration(milliseconds: 500),
                          swapAnimationCurve: Curves.easeOutCubic,
                        ),
                        // Center labels
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '$live/$target',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              '${(pct * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
              ),
            ),
            const SizedBox(width: 16),

            // Title and legend
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      )),
                  const SizedBox(height: 8),

                  // Legend uses dynamic colors
                  Row(
                    children: [
                      _LegendDot(color: colorLive),
                      const SizedBox(width: 6),
                      const Text('Live', style: TextStyle(fontFamily: "Poppins")),
                      const SizedBox(width: 16),
                      _LegendDot(color: colorRemain),
                      const SizedBox(width: 6),
                      const Text('Remaining', style: TextStyle(fontFamily: "Poppins")),
                    ],
                  ),

                  const SizedBox(height: 8),

                  if (totalThisMonth != null)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'This month live: ',
                                  style: TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black87, fontSize: 12,
                                      fontFamily: "Poppins",fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: '${totalThisMonth!}',
                                  style:  TextStyle(
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.amberAccent:Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

