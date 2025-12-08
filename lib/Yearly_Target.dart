import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Statistics/Progressbar.dart';

class Target_Yearly extends StatefulWidget {
  const Target_Yearly({super.key}); // no external inputs anymore

  @override
  State<Target_Yearly> createState() => _Target_YearlyState();
}

class _Target_YearlyState extends State<Target_Yearly> {
  // Targets
  static const int _overallTarget = 100;
  static const int _monthlyTarget = 15;
  static const int _moreMonthlyTarget = 5;
  static const int _moreYearlyTarget = _moreMonthlyTarget * 12; // 60
  static const int _commercialMonthlyTarget = 5;
  static const int _commercialYearlyTarget = 60;
  static const int _agreementMonthlyTarget = 15;
  static const int _agreementYearlyTarget = 180;
  static const int _buildingMonthlyTarget = 17;
  static const int _buildingYearlyTarget  = 204;
  int _buildingCount = 0;
  String? _buildingErr;

  bool _ytLoading = false;
  String? _ytError;

  String? _ytStartRaw, _ytEndExclRaw; // exact strings from API
  int _ytAchieved = 0;
  static const int _ytTarget = 5;
  static const int _ytTargetRent = 60;
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

  // Loading
  bool _loadingLive = true;
  String? _liveErr;

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
      _buildingErr = null;
    });

    await Future.wait([
      _loadYearlyTarget(),
      _loadYearlyLiveRent(),
      _loadYearlyLiveBuy(),
      _loadYearlyCommercial(),
      _loadYearlyAgreements(),
      _fetchBuildingCount()
    ]);

    if (!mounted) return;
    setState(() {
      _loadingLive = false;
    });
  }

  String _number = '';
  String _SUbid = '';

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


  int get _ytBuy  => (_ytData?['buy_count']  as num?)?.toInt() ?? 0;
  int get _ytRent => (_ytData?['rent_count'] as num?)?.toInt() ?? 0;

  @override
  Widget build(BuildContext context) {
    String _apiDay(String? raw) => (raw ?? '').split(' ').first; // "2025-11-10"

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardElevation = isDark ? 0.0 : 2.0;
    final cardColor = isDark ? Colors.grey.shade900.withOpacity(0.3) : Colors.white;
    final surfaceColor = isDark ? Colors.grey.shade800.withOpacity(0.2) : Colors.grey.shade50;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black.withOpacity(0.2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return RealEstateAnalyticsPage();
              }));
            },
            child: Text(
              "Type",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(PhosphorIcons.arrow_clockwise, color: Colors.white),
            onPressed: _fetchAll,
            tooltip: 'Refresh',
            style: IconButton.styleFrom(
              backgroundColor: Colors.black.withOpacity(0.2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _loadingLive
          ? Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          strokeWidth: 3,
        ),
      )
          : RefreshIndicator(
        onRefresh: _fetchAll,
        color: Colors.black,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================== Flat Booked For Rent =====================
              _ModernSectionHeader(
                color: Colors.amber.shade600,
                label: "Flat Booked For Rent Yearly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_ytLoading)
                _LoadingPlaceholder(height: 160)
              else if (_ytError != null)
                _ErrorTile(
                  title: 'Yearly Target 60',
                  error: _ytError!,
                  onRetry: _loadYearlyTarget,
                )
              else ...[
                  if ((_ytStartRaw ?? '').isNotEmpty && (_ytEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_ytStartRaw)} → ${_apiDay(_ytEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Yearly Target 60',
                    liveCount: _ytRent,
                    target: _ytTargetRent,
                    colorLive: Colors.amber.shade600,
                    colorRemain: Colors.grey.shade400,
                    elevation: cardElevation,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _MetricChip(
                    icon: Icons.key_outlined,
                    label: 'Rent',
                    value: '${_ytRent}',
                    color: Colors.amber.shade100,
                    textColor: Colors.amber.shade800,
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== Flat Booked For Buy =====================
              _ModernSectionHeader(
                color: const Color(0xff006466),
                label: "Flat Booked For Buy Yearly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_ytLoading)
                _LoadingPlaceholder(height: 160)
              else if (_ytError != null)
                _ErrorTile(
                  title: 'Yearly Target 5',
                  error: _ytError!,
                  onRetry: _loadYearlyTarget,
                )
              else ...[
                  if ((_ytStartRaw ?? '').isNotEmpty && (_ytEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_ytStartRaw)} → ${_apiDay(_ytEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Yearly Target 5',
                    liveCount: _ytBuy,
                    target: _ytTarget,
                    colorLive: const Color(0xff006466),
                    colorRemain: Colors.grey.shade400,
                    elevation: cardElevation,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _MetricChip(
                    icon: Icons.shopping_bag_outlined,
                    label: 'Buy',
                    value: '${_ytBuy}',
                    color: const Color(0xff006466).withOpacity(0.1),
                    textColor: const Color(0xff006466),
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== RENT SECTION =====================
              _ModernSectionHeader(
                color: Colors.blue.shade600,
                label: "Live Flats (Rent) Yearly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_yrRentLoading)
                _LoadingPlaceholder(height: 160)
              else if (_yrRentError != null)
                _ErrorTile(
                  title: 'Yearly Target 100',
                  error: _yrRentError!,
                  onRetry: _loadYearlyLiveRent,
                )
              else ...[
                  if ((_yrRentStartRaw ?? '').isNotEmpty && (_yrRentEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_yrRentStartRaw)} → ${_apiDay(_yrRentEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Yearly Target 100',
                    liveCount: _yrRentAchieved,
                    target: _overallTarget,
                    colorLive: Colors.blue.shade600,
                    colorRemain: Colors.grey.shade400,
                    elevation: cardElevation,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== BUY SECTION =====================
              _ModernSectionHeader(
                color: Colors.deepPurple.shade600,
                label: "Live Flats (Buy) Yearly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_yrBuyLoading)
                _LoadingPlaceholder(height: 160)
              else if (_yrBuyError != null)
                _ErrorTile(
                  title: 'Yearly Target 60',
                  error: _yrBuyError!,
                  onRetry: _loadYearlyLiveBuy,
                )
              else ...[
                  if ((_yrBuyStartRaw ?? '').isNotEmpty && (_yrBuyEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_yrBuyStartRaw)} → ${_apiDay(_yrBuyEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Yearly Target 60',
                    liveCount: _yrBuyAchieved,
                    target: _moreYearlyTarget,
                    colorLive: Colors.deepPurple.shade600,
                    colorRemain: Colors.grey.shade400,
                    elevation: cardElevation,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== COMMERCIAL SECTION =====================
              _ModernSectionHeader(
                color: Colors.cyan.shade600,
                label: "Live Flats (Commercial) Yearly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_yrComLoading)
                _LoadingPlaceholder(height: 160)
              else if (_yrComError != null)
                _ErrorTile(
                  title: 'Yearly Target 60',
                  error: _yrComError!,
                  onRetry: _loadYearlyCommercial,
                )
              else ...[
                  if ((_yrComStartRaw ?? '').isNotEmpty && (_yrComEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_yrComStartRaw)} → ${_apiDay(_yrComEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Yearly Target 60',
                    liveCount: _yrComAchieved,
                    target: _commercialYearlyTarget,
                    colorLive: Colors.cyan.shade600,
                    colorRemain: Colors.grey.shade400,
                    elevation: cardElevation,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== Agreements =====================
              _ModernSectionHeader(
                color: Colors.red.shade600,
                label: "Agreements Yearly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_yrAgrLoading)
                _LoadingPlaceholder(height: 160)
              else if (_yrAgrError != null)
                _ErrorTile(
                  title: 'Yearly Target 180',
                  error: _yrAgrError!,
                  onRetry: _loadYearlyAgreements,
                )
              else ...[
                  if ((_yrAgrStartRaw ?? '').isNotEmpty && (_yrAgrEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_yrAgrStartRaw)} → ${_apiDay(_yrAgrEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Yearly Target 180',
                    liveCount: _yrAgrAchieved,
                    target: _agreementYearlyTarget,
                    colorLive: Colors.red.shade600,
                    colorRemain: Colors.grey.shade400,
                    elevation: cardElevation,
                    cardColor: cardColor,
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== Buildings =====================
              _ModernSectionHeader(
                color: Colors.pink.shade600,
                label: "Buildings Yearly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _ModernPieKpiCard(
                title: 'Yearly Target 204',
                liveCount: _buildingCount,
                target: _buildingYearlyTarget,
                colorLive: Colors.pink.shade600,
                colorRemain: Colors.grey.shade400,
                elevation: cardElevation,
                cardColor: cardColor,
                isDark: isDark,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// Modern Section Header with gradient and subtle shadow
class _ModernSectionHeader extends StatelessWidget {
  final Color color;
  final String label;
  final bool isDark;

  const _ModernSectionHeader({
    required this.color,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(isDark ? 0.6 : 0.5),
            color.withOpacity(isDark ? 0.2 : 0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : Colors.black87,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// Modern Pie KPI Card with enhanced styling
class _ModernPieKpiCard extends StatelessWidget {
  final String title;
  final int liveCount;
  final int target;
  final Color colorLive;
  final Color colorRemain;
  final double elevation;
  final Color cardColor;
  final bool isDark;
  final int? totalThisMonth;

  const _ModernPieKpiCard({
    required this.title,
    required this.liveCount,
    required this.target,
    required this.colorLive,
    required this.colorRemain,
    required this.elevation,
    required this.cardColor,
    required this.isDark,
    this.totalThisMonth,
  });

  @override
  Widget build(BuildContext context) {
    final live = liveCount.clamp(0, target);
    final remain = (target - live).clamp(0, target);
    final pct = target == 0 ? 0.0 : live / target;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          elevation: elevation,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                // Enhanced Pie chart with larger size and better animation
                // File: `lib/Yearly_Target.dart`
// Replace the TweenAnimationBuilder builder body with this corrected version.

                SizedBox(
                  width: 140,
                  height: 140,
                  child: TweenAnimationBuilder<double>(
                    key: ValueKey('$liveCount-$target'),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeOutBack,
                    tween: Tween<double>(begin: 0, end: liveCount.toDouble()),
                    builder: (_, anim, __) {
                      final double sliceLive = (anim.clamp(0.0, target.toDouble())).toDouble();
                      final double sliceRemain = ((target.toDouble() - sliceLive).clamp(0.0, target.toDouble())).toDouble();
                      final pctAnim = target == 0 ? 0.0 : sliceLive / target;
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            key: ValueKey('pie-$liveCount-$target'),
                            PieChartData(
                              startDegreeOffset: -90,
                              centerSpaceRadius: 40,
                              sectionsSpace: 3,
                              sections: [
                                PieChartSectionData(
                                  value: sliceLive,
                                  color: colorLive,
                                  radius: 22,
                                  showTitle: false,
                                  borderSide: BorderSide(
                                    color: isDark ? Colors.black : Colors.white,
                                    width: 2,
                                  ),
                                ),
                                PieChartSectionData(
                                  value: sliceRemain,
                                  color: colorRemain,
                                  radius: 22,
                                  showTitle: false,
                                  borderSide: BorderSide(
                                    color: isDark ? Colors.black : Colors.white,
                                    width: 2,
                                  ),
                                ),
                              ],
                            ),
                            swapAnimationDuration: const Duration(milliseconds: 600),
                            swapAnimationCurve: Curves.easeOutCubic,
                          ),
                          // Center labels...
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$live/$target',
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 18,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${(pctAnim * 100).toStringAsFixed(0)}%',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: colorLive,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(width: 20),

                // Enhanced Title and legend
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Modern Legend
                      Row(
                        children: [
                          _ModernLegendDot(color: colorLive),
                          const SizedBox(width: 8),
                          Text(
                            'Live',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                            ),
                          ),
                          const Spacer(),
                          _ModernLegendDot(color: colorRemain),
                          const SizedBox(width: 8),
                          Text(
                            'Remaining',
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (totalThisMonth != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [colorLive.withOpacity(0.2), colorLive.withOpacity(0.05)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: colorLive.withOpacity(0.3)),
                          ),
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: 'This month live: ',
                                  style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                                    fontSize: 13,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: '${totalThisMonth!}',
                                  style: TextStyle(
                                    color: colorLive,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Modern Legend Dot
class _ModernLegendDot extends StatelessWidget {
  final Color color;
  const _ModernLegendDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );
  }
}

// Metric Chip for sub-metrics
class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final Color textColor;
  final bool isDark;

  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: textColor),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  color: textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Loading Placeholder
class _LoadingPlaceholder extends StatelessWidget {
  final double height;
  const _LoadingPlaceholder({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }
}

// Error Tile
class _ErrorTile extends StatelessWidget {
  final String title;
  final String error;
  final VoidCallback onRetry;

  const _ErrorTile({
    required this.title,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: Colors.red.shade50,
      child: ListTile(
        leading: Icon(Icons.error_outline, color: Colors.red.shade600),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          error,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.grey.shade600),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.refresh, color: Colors.red),
          onPressed: onRetry,
        ),
      ),
    );
  }
}