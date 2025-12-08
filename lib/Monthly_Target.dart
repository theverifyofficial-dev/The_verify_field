import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Statistics/Progressbar.dart';

class Target_Monthly extends StatefulWidget {
  const Target_Monthly({super.key});
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
  static const int _commercialMonthlyTarget = 5;
  static const int _agreementMonthlyTarget = 15;
  static const int _buildingMonthlyTarget = 17;
  int _commercialLiveCount = 0;
  String? _commercialErr;
  int _agreementCount = 0;
  String? _agreementErr;
  int _buildingCount = 0;
  String? _buildingErr;
  // Monthly target data
  Map<String, dynamic>? _mtData;
  bool _mtLoading = false;
  String? _mtError;
  String? _mtStartRaw, _mtEndExclRaw;
  int _mtAchieved = 0;
  static const int _mtTarget = 5;

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

  Future<void> _loadMonthlyTarget() async {
    setState(() { _mtLoading = true; _mtError = null; });
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_book_flat_for_month.php?field_workar_number=$_number',
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
      final start = ((d['period_start'] as Map?)?['date'] ?? '').toString();
      final endExcl = ((d['period_end_excl'] as Map?)?['date'] ?? '').toString();
      final booked = (d['total_booked'] as num?)?.toInt() ?? 0;
      if (!mounted) return;
      setState(() {
        _mtStartRaw = start;
        _mtEndExclRaw = endExcl;
        _mtAchieved = booked;
        _mtData = Map<String, dynamic>.from(d);
      });
    } catch (e) {
      if (!mounted) return;
      setState(() { _mtError = e.toString(); });
    } finally {
      if (mounted) setState(() { _mtLoading = false; });
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
        _buildingCount = count;
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
      int count = 0;
      if (data is Map) {
        final possibleCount = data['total_live_buy_flat'] ?? data['total_live'] ?? data['logg'] ?? data['total_live_rent_flat'];
        count = (possibleCount as num?)?.toInt() ?? int.tryParse(possibleCount?.toString() ?? '0') ?? 0;
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
        final possibleCount = data['total_live_commercial'] ?? data['total_live'] ?? data['logg'] ?? data['total_live_rent_flat'];
        count = (possibleCount as num?)?.toInt() ?? int.tryParse(possibleCount?.toString() ?? '0') ?? 0;
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
        final possibleCount = data['total_agreements'] ?? data['agreements'] ?? data['logg'] ?? data['total_agreement'] ?? data['total'];
        count = (possibleCount as num?)?.toInt() ?? int.tryParse(possibleCount?.toString() ?? '0') ?? 0;
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

  int get _mtBuy => (_mtData?['buy_count'] as num?)?.toInt() ?? 0;
  int get _mtRent => (_mtData?['rent_count'] as num?)?.toInt() ?? 0;

  String _apiDay(String? raw) => (raw ?? '').split(' ').first;

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
                label: "Flat Booked For Rent Monthly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_mtLoading)
                _LoadingPlaceholder(height: 160)
              else if (_mtError != null)
                _ErrorTile(
                  title: 'Monthly Target 15',
                  error: _mtError!,
                  onRetry: _loadMonthlyTarget,
                )
              else ...[
                  if ((_mtStartRaw ?? '').isNotEmpty && (_mtEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_mtStartRaw)} → ${_apiDay(_mtEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Monthly Target 15',
                    liveCount: _mtRent,
                    target: _monthlyTarget,
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
                    value: '${_mtRent}',
                    color: Colors.amber.shade100,
                    textColor: Colors.amber.shade800,
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== Flat Booked For Buy =====================
              _ModernSectionHeader(
                color: const Color(0xff006466),
                label: "Flat Booked For Buy Monthly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_mtLoading)
                _LoadingPlaceholder(height: 160)
              else if (_mtError != null)
                _ErrorTile(
                  title: 'Monthly Target 5',
                  error: _mtError!,
                  onRetry: _loadMonthlyTarget,
                )
              else ...[
                  if ((_mtStartRaw ?? '').isNotEmpty && (_mtEndExclRaw ?? '').isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12, left: 8),
                      child: Text(
                        'Cycle: ${_apiDay(_mtStartRaw)} → ${_apiDay(_mtEndExclRaw)}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: isDark ? Colors.white70 : Colors.grey.shade600,
                        ),
                      ),
                    ),
                  _ModernPieKpiCard(
                    title: 'Monthly Target 5',
                    liveCount: _mtBuy,
                    target: _mtTarget,
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
                    value: '${_mtBuy}',
                    color: const Color(0xff006466).withOpacity(0.1),
                    textColor: const Color(0xff006466),
                    isDark: isDark,
                  ),
                ],
              const SizedBox(height: 24),

              // ===================== RENT SECTION =====================
              _ModernSectionHeader(
                color: Colors.blue.shade600,
                label: "Live Flats (Rent) Monthly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_loadingLive)
                _LoadingPlaceholder(height: 160)
              else if (_liveErr != null)
                _ErrorTile(
                  title: 'Monthly Target 15',
                  error: _liveErr!,
                  onRetry: _fetchLiveCount,
                )
              else ...[
                  _ModernPieKpiCard(
                    title: 'Monthly Target 15',
                    liveCount: _liveCount,
                    target: _monthlyTarget,
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
                label: "Live Flats (Buy) Monthly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_buyErr != null)
                _ErrorTile(
                  title: 'Monthly Target 5',
                  error: _buyErr!,
                  onRetry: _fetchBuyLiveCount,
                )
              else ...[
                _ModernPieKpiCard(
                  title: 'Monthly Target 5',
                  liveCount: _buyLiveCount,
                  target: _moreMonthlyTarget,
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
                label: "Live Commercial Monthly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_commercialErr != null)
                _ErrorTile(
                  title: 'Monthly Target 5',
                  error: _commercialErr!,
                  onRetry: _fetchCommercialLiveCount,
                )
              else ...[
                _ModernPieKpiCard(
                  title: 'Monthly Target 5',
                  liveCount: _commercialLiveCount,
                  target: _commercialMonthlyTarget,
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
                label: "Agreements Monthly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_agreementErr != null)
                _ErrorTile(
                  title: 'Monthly Target 15',
                  error: _agreementErr!,
                  onRetry: _fetchAgreementCount,
                )
              else ...[
                _ModernPieKpiCard(
                  title: 'Monthly Target 15',
                  liveCount: _agreementCount,
                  target: _agreementMonthlyTarget,
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
                label: "Buildings Monthly",
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              if (_buildingErr != null)
                _ErrorTile(
                  title: 'Monthly Target 17',
                  error: _buildingErr!,
                  onRetry: _fetchBuildingCount,
                )
              else ...[
                _ModernPieKpiCard(
                  title: 'Monthly Target 17',
                  liveCount: _buildingCount,
                  target: _buildingMonthlyTarget,
                  colorLive: Colors.pink.shade600,
                  colorRemain: Colors.grey.shade400,
                  elevation: cardElevation,
                  cardColor: cardColor,
                  isDark: isDark,
                ),
              ],
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