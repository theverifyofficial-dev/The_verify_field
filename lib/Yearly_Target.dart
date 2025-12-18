import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';

class TargetYearlyResult {
  final DateTime periodStartUtc;
  final DateTime periodEndExclUtc;
  final int totalBooked;

  // raw strings from API (exactly what came over the wire)
  final String periodStartRaw;
  final String periodEndExclRaw;

  const TargetYearlyResult({
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

  factory TargetYearlyResult.fromRoot(Map<String, dynamic> root) {
    final d = (root['data'] as Map?) ?? const {};
    final startMap = d['period_start'] as Map<String, dynamic>?;
    final endMap   = (d['period_end_excl'] ?? d['period_end']) as Map<String, dynamic>?;

    final startRaw = startMap?['date']?.toString() ?? '';
    final endRaw   = endMap?['date']?.toString() ?? '';

    return TargetYearlyResult(
      periodStartUtc: _parseBackendDate(startMap),
      periodEndExclUtc: _parseBackendDate(endMap),
      totalBooked: int.tryParse((d['total_booked'] ?? d['achieved'] ?? '0').toString()) ?? 0,
      periodStartRaw: startRaw,
      periodEndExclRaw: endRaw,
    );
  }
}

class Target_Yearly extends StatefulWidget {
  const Target_Yearly({super.key}); // no external inputs anymore

  @override
  State<Target_Yearly> createState() => _Target_YearlyState();
}

class _Target_YearlyState extends State<Target_Yearly> {
  // API result
  int _liveCount = 0;

  // Targets
  static const int _overallTarget = 100;
  int _buyLiveCount = 0;
  String? _buyErr;

  // Loading & error
  bool _loadingLive = true;
  String? _liveErr;

// extra targets
  int _commercialLiveCount = 0;
  String? _commercialErr;
  static const int _commercialYearlyTarget = 60;
  static const int _agreementYearlyTarget = 180;
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

      _loadYearlyTarget(),
      _loadYearlyLiveRent(),
      _loadYearlyLiveBuy(),
      _loadYearlyCommercial(),
      _loadYearlyAgreements()
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
  static const int _moreMonthlyTarget = 5;

  static const int _moreYearlyTarget = _moreMonthlyTarget * 12; // 60

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

  Future<void> _loadYearlyTarget() async {
    setState(() { _ytLoading = true; _ytError = null; });
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_for_book_flat_yearly.php?field_workar_number=$_number',
      );
      final resp = await http.get(uri);
      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final root = json.decode(resp.body) as Map<String, dynamic>;
      if (root['success'] != true) {
        throw Exception('API returned success=false');
      }

      final d = (root['data'] as Map?) ?? const {};
      final start   = ((d['period_start'] as Map?)?['date'] ?? '').toString();
      final endExcl = ((d['period_end_excl'] as Map?)?['date'] ?? '').toString();
      final booked  = (d['total_booked'] as num?)?.toInt() ?? 0;

      if (!mounted) return;
      setState(() {
        _ytStartRaw   = start;
        _ytEndExclRaw = endExcl;
        _ytAchieved   = booked;
        _ytData       = Map<String, dynamic>.from(d); // keep full payload
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _ytError = e.toString(); });
    } finally {
      if (mounted) setState(() { _ytLoading = false; });
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


  Future<void> _fetchBuildingCount() async {
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_building.php?fieldworkarnumber=${_number}',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = jsonDecode(res.body);
      final data = body['data'];
      final count = (data is Map && data['logg'] != null)
          ? int.tryParse(data['logg'].toString()) ?? 0
          : 0;

      if (!mounted) return;
      setState(() {
        _buildingCount = count;  // e.g. 187
        _buildingErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _buildingCount = 0;
        _buildingErr = 'Failed to load building count';
      });
    }
  }

  Future<void> _fetchBuyLiveCount() async {
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_flat_for_buy_field.php?field_workar_number=$_number',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 8));

      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');

      final body = jsonDecode(res.body);
      final data = body['data'] ?? {};

      // Support all possible key names (backend changes randomly)
      int count = 0;

      if (data is Map) {
        count = (data['total_live_rent_flat'] ??
            data['total_live_buy_flat'] ??
            data['total_live'] ??
            data['logg'])
            ?.toInt() ??
            int.tryParse(data['total_live_rent_flat']?.toString() ?? '0') ??
            0;
      }

      if (!mounted) return;

      setState(() {
        _buyLiveCount = count;
        _buyErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _buyLiveCount = 0;
        _buyErr = 'Failed to load buy live count: $e';
      });
    }
  }

  Future<void> _fetchLiveCount() async {
    setState(() {
      _loadingLive = true;
      _liveErr = null;
    });

    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_flat_for_field.php?field_workar_number=$_number',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final root = jsonDecode(res.body);

      final data = root['data'] as Map?;

      // 👈 correct key from this API
      final count = (data?['total_live_rent_flat'] as num?)?.toInt() ?? 0;

      if (!mounted) return;

      setState(() {
        _liveCount = count;
        _loadingLive = false;
        _liveErr = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _liveCount = 0;
        _loadingLive = false;
        _liveErr = 'Failed to load live count: $e';
      });
    }
  }

  Future<void> _fetchCommercialLiveCount() async {
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_commercial_space.php?field_workar_number=$_number',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = jsonDecode(res.body);
      final data = body['data'] ?? {};

      int count = 0;

      if (data is Map) {
        // Try all possible backend keys
        count = (data['total_live_commercial'] ??
            data['total_live_rent_flat'] ??   // NEW API sending this
            data['total_live'] ??
            data['logg'])
            ?.toInt() ??
            int.tryParse(data['total_live_commercial']?.toString() ?? '0') ??
            int.tryParse(data['total_live_rent_flat']?.toString() ?? '0') ??
            0;
      }

      if (!mounted) return;

      setState(() {
        _commercialLiveCount = count;
        _commercialErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _commercialLiveCount = 0;
        _commercialErr = 'Failed to load commercial live count: $e';
      });
    }
  }

  Future<void> _fetchAgreementCount() async {
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_agreement.php?Fieldwarkarnumber=$_number',
      );

      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      if (res.statusCode != 200) {
        throw Exception('HTTP ${res.statusCode}');
      }

      final body = jsonDecode(res.body);
      final data = body['data'] ?? {};

      int count = 0;

      if (data is Map) {
        count = (data['total_agreements'] ??     // NEW API key
            data['agreements'] ??            // fallback 1
            data['logg'] ??                  // old API
            data['total_agreement'] ??       // fallback 2
            data['total']                    // fallback 3
        ) is int
            ? (data['total_agreements'] ??
            data['agreements'] ??
            data['logg'] ??
            data['total_agreement'] ??
            data['total'])
            : int.tryParse(
            (data['total_agreements'] ??
                data['agreements'] ??
                data['logg'] ??
                data['total_agreement'] ??
                data['total'])
                ?.toString() ??
                '0') ??
            0;
      }

      if (!mounted) return;

      setState(() {
        _agreementCount = count;
        _agreementErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _agreementCount = 0;
        _agreementErr = 'Failed to load agreement count: $e';
      });
    }
  }

  Future<void> _loadYearlyLiveRent() async {
    setState(() { _yrRentLoading = true; _yrRentError = null; });
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_live_flat_rent_yearly.php?field_workar_number=$_number',
      );

      final resp = await http.get(uri);
      if (resp.statusCode != 200) {
        throw Exception('HTTP ${resp.statusCode}');
      }

      final root = json.decode(resp.body) as Map<String, dynamic>;
      if (root['success'] != true) {
        throw Exception('API returned success=false');
      }

      final d = (root['data'] as Map?) ?? const {};
      final start   = ((d['period_start'] as Map?)?['date'] ?? '').toString();
      final endExcl = ((d['period_end_excl'] as Map?)?['date'] ?? '').toString();

      // note: API key is total_live_rent_flat
      final achieved = (d['total_live_rent_flat'] as num?)?.toInt() ?? 0;

      if (!mounted) return;
      setState(() {
        _yrRentStartRaw   = start;
        _yrRentEndExclRaw = endExcl;
        _yrRentAchieved   = achieved;
        _yrRentData       = Map<String, dynamic>.from(d);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _yrRentError = e.toString(); });
    } finally {
      if (mounted) setState(() { _yrRentLoading = false; });
    }
  }

  Future<void> _loadYearlyLiveBuy() async {
    setState(() { _yrBuyLoading = true; _yrBuyError = null; });
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_buy_live_flat_yearly.php?field_workar_number=$_number',
      );
      final resp = await http.get(uri);
      if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');

      final root = json.decode(resp.body) as Map<String, dynamic>;
      if (root['success'] != true) throw Exception('API returned success=false');

      final d = (root['data'] as Map?) ?? const {};
      final start   = ((d['period_start'] as Map?)?['date'] ?? '').toString();
      final endExcl = ((d['period_end_excl'] as Map?)?['date'] ?? '').toString();

      // note: response key is 'total_live_rent_flat' even for BUY API; using as-is
      final achieved = (d['total_live_rent_flat'] as num?)?.toInt() ?? 0;

      if (!mounted) return;
      setState(() {
        _yrBuyStartRaw   = start;
        _yrBuyEndExclRaw = endExcl;
        _yrBuyAchieved   = achieved;
        _yrBuyData       = Map<String, dynamic>.from(d);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _yrBuyError = e.toString(); });
    } finally {
      if (mounted) setState(() { _yrBuyLoading = false; });
    }
  }

  Future<void> _loadYearlyCommercial() async {
    setState(() { _yrComLoading = true; _yrComError = null; });
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/commerical_count_yearly.php?field_workar_number=$_number',
      );
      final resp = await http.get(uri);
      if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');

      final root = json.decode(resp.body) as Map<String, dynamic>;
      if (root['success'] != true) throw Exception('API returned success=false');

      final d = (root['data'] as Map?) ?? const {};

      final startMap = d['period_start'] as Map?;
      final endMap   = d['period_end_excl'] as Map?;

      final start   = startMap?['date']?.toString() ?? '';
      final endExcl = endMap?['date']?.toString() ?? '';

      // Try multiple key names because the backend is “creative”
      num? _pick(dynamic v) => (v is num) ? v : num.tryParse(v?.toString() ?? '');
      final achieved =
          _pick(d['total_live_commercial']) ??
              _pick(d['total_commercial']) ??
              _pick(d['total_live_rent_flat']) ??  // seen on the BUY yearly API
              _pick(d['logg']) ??
              _pick(d['achieved']) ??
              _pick(d['total_booked']) ??
              0;

      if (!mounted) return;
      setState(() {
        _yrComStartRaw   = start;
        _yrComEndExclRaw = endExcl;
        _yrComAchieved   = achieved.toInt();
        _yrComData       = Map<String, dynamic>.from(d);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _yrComError = e.toString(); });
    } finally {
      if (mounted) setState(() { _yrComLoading = false; });
    }
  }

  Future<void> _loadYearlyAgreements() async {
    setState(() { _yrAgrLoading = true; _yrAgrError = null; });
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_agreement_yarly.php?Fieldwarkarnumber=$_number',
      );
      final resp = await http.get(uri);
      if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
      final root = json.decode(resp.body) as Map<String, dynamic>;
      if (root['success'] != true) throw Exception('API returned success=false');

      final d = (root['data'] as Map?) ?? const {};
      final start   = ((d['period_start'] as Map?)?['date'] ?? '').toString();
      final endExcl = ((d['period_end_excl'] as Map?)?['date'] ?? '').toString();
      final achieved = (d['total_agreements'] as num?)?.toInt() ?? 0;

      if (!mounted) return;
      setState(() {
        _yrAgrStartRaw   = start;
        _yrAgrEndExclRaw = endExcl;
        _yrAgrAchieved   = achieved;
        _yrAgrData       = Map<String, dynamic>.from(d);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _yrAgrError = e.toString(); });
    } finally {
      if (mounted) setState(() { _yrAgrLoading = false; });
    }
  }


  int get _mtBuy  => (_mtData?['buy_count']  as num?)?.toInt() ?? 0;
  int get _mtRent => (_mtData?['rent_count'] as num?)?.toInt() ?? 0;

  @override
  Widget build(BuildContext context) {
    final overallPct = (_liveCount / _overallTarget).clamp(0.0, 1.0);
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

              if (_ytLoading)
                const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))
              else if (_ytError != null)
                ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const Text('Yearly Target 60'),
                  subtitle: Text(_ytError!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: _loadYearlyTarget),
                )
              else ...[
                  if ((_ytStartRaw ?? '').isNotEmpty && (_ytEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        // exact API dates, end is exclusive; we print them exactly as provided
                        'Cycle: ${_apiDay(_ytStartRaw)} → ${_apiDay(_ytEndExclRaw)}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  _PieKpiCard(
                    title: 'Yearly Target 60',
                    liveCount: _mtRent,
                    target: _ytTargetRent,
                    colorLive: Colors.yellow.shade700,
                    colorRemain: Colors.grey.shade700,
                  ),
                ],
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
              // ===================== Flat Booked For Buy =====================

              const SizedBox(height: 16),

              const _HighlightBar(color: Color(0xff006466), label: "Flat Booked For Buy"),

              const SizedBox(height: 8),

              if (_ytLoading)
                const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))
              else if (_ytError != null)
                ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const Text('Yearly Target 5'),
                  subtitle: Text(_ytError!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: _loadYearlyTarget),
                )
              else ...[
                  if ((_ytStartRaw ?? '').isNotEmpty && (_ytEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        // exact API dates, end is exclusive; we print them exactly as provided
                        'Cycle: ${_apiDay(_ytStartRaw)} → ${_apiDay(_ytEndExclRaw)}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  _PieKpiCard(
                    title: 'Yearly Target 5',
                    liveCount: _mtBuy,
                    target: _ytTarget,
                    colorLive: Color(0xff006466),
                    colorRemain: Colors.grey.shade700,
                  ),
                ],
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
                          const Icon(Icons.shopping_bag_outlined, size: 18),
                          const SizedBox(width: 8),
                          const Text('Buy',style: TextStyle(fontWeight: FontWeight.w600),),
                          const Spacer(),
                          Text(
                            '${(_ytData?['buy_count'] as num?)?.toInt() ?? 0}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // const SizedBox(width: 8),
                  // Expanded(
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  //     decoration: BoxDecoration(
                  //       color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.25),
                  //       borderRadius: BorderRadius.circular(10),
                  //       border: Border.all(
                  //         color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.3),
                  //       ),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         const Icon(Icons.key_outlined, size: 18),
                  //         const SizedBox(width: 8),
                  //         const Text('Rent'),
                  //         const Spacer(),
                  //         Text(
                  //           '${(_ytData?['rent_count'] as num?)?.toInt() ?? 0}',
                  //           style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),



              // ===================== RENT SECTION =====================
              const SizedBox(height: 16),

              const _HighlightBar(color: Colors.blue, label: "Live Flats (Rent)"),
              // const SizedBox(height: 8),

              if (_yrRentLoading)
                const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))
              else if (_yrRentError != null)
                ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const Text('Yearly Target 100'),
                  subtitle: Text(_yrRentError!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: _loadYearlyLiveRent),
                )
              else ...[
                  if ((_yrRentStartRaw ?? '').isNotEmpty && (_yrRentEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        'Cycle: ${_yrRentStartRaw!.split(' ').first} → ${_yrRentEndExclRaw!.split(' ').first}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  _PieKpiCard(
                    title: 'Yearly Target 100',
                    liveCount: _yrRentAchieved,    // <— from new API: total_live_rent_flat
                    target: _overallTarget,
                    colorLive: Colors.blue,
                    colorRemain: Colors.grey.shade700,
                  ),
                ],

              // _sectionDivider(),
              const SizedBox(height: 16),

              // ===================== BUY SECTION =====================
              const _HighlightBar(color: Colors.deepPurple, label: "Live Flats (Buy)"),

              // const SizedBox(height: 8),

// Yearly (BUY) from new API
              if (_yrBuyLoading)
                const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))
              else if (_yrBuyError != null)
                ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const Text('Yearly Target 60'),
                  subtitle: Text(_yrBuyError!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: _loadYearlyLiveBuy),
                )
              else ...[
                  if ((_yrBuyStartRaw ?? '').isNotEmpty && (_yrBuyEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        'Cycle: ${(_yrBuyStartRaw ?? '').split(' ').first} → ${(_yrBuyEndExclRaw ?? '').split(' ').first}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  _PieKpiCard(
                    title: 'Yearly Target 60',
                    liveCount: _yrBuyAchieved,     // <-- from new BUY yearly API
                    target: _moreYearlyTarget,
                    colorLive: Colors.deepPurple,
                    colorRemain: Colors.grey.shade700,
                  ),
                ],



              // ===================== BUY SECTION =====================
              const SizedBox(height: 16),

              const _HighlightBar(color: Colors.cyan, label: "Commercial"),



// Commercial Monthly 5

              if (_yrComLoading)
                const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))
              else if (_yrComError != null)
                ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const Text('Yearly Target 60'),
                  subtitle: Text(_yrComError!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: _loadYearlyCommercial),
                )
              else ...[
                  if ((_yrComStartRaw ?? '').isNotEmpty && (_yrComEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        'Cycle: ${(_yrComStartRaw ?? '').split(' ').first} → ${(_yrComEndExclRaw ?? '').split(' ').first}',
                        style: TextStyle(fontWeight: FontWeight.w600),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  _PieKpiCard(
                    title: 'Yearly Target 60',
                    liveCount: _yrComAchieved,                 // from the new Commercial yearly API
                    target: _commercialYearlyTarget,           // you already defined 60
                    colorLive: Colors.cyan.shade400,
                    colorRemain: Colors.grey.shade700,
                  ),
                ],

              // ===================== Agreements =====================
              const SizedBox(height: 16),

              const _HighlightBar(color: Colors.redAccent, label: "Agreements"),

// Agreements — Yearly (from API)
              if (_yrAgrLoading)
                const SizedBox(height: 140, child: Center(child: CircularProgressIndicator()))
              else if (_yrAgrError != null)
                ListTile(
                  leading: const Icon(Icons.error_outline),
                  title: const Text('Yearly Target 180'),
                  subtitle: Text(_yrAgrError!, maxLines: 2, overflow: TextOverflow.ellipsis),
                  trailing: IconButton(icon: const Icon(Icons.refresh), onPressed: _loadYearlyAgreements),
                )
              else ...[
                  if ((_yrAgrStartRaw ?? '').isNotEmpty && (_yrAgrEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6, left: 4),
                      child: Text(
                        'Cycle: ${(_yrAgrStartRaw ?? '').split(' ').first} → ${(_yrAgrEndExclRaw ?? '').split(' ').first}',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  _PieKpiCard(
                    title: 'Yearly Target 180',
                    liveCount: _yrAgrAchieved,
                    target: _agreementYearlyTarget,
                    colorLive: Colors.redAccent,
                    colorRemain: Colors.grey.shade700,
                  ),
                ],

              // ===================== Buildings =====================
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

