import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';

class Target_MainPage extends StatefulWidget {
  const Target_MainPage({super.key}); // no external inputs anymore

  @override
  State<Target_MainPage> createState() => _Target_MainPageState();
}

class _Target_MainPageState extends State<Target_MainPage> {
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
  static const int _commercialYearlyTarget = 60;
  static const int _agreementMonthlyTarget = 15;
  static const int _agreementYearlyTarget = 180;
  int _agreementCount = 0;
  String? _agreementErr;
  int _buildingCount = 0;
  String? _buildingErr;

  static const int _buildingMonthlyTarget = 17;
  static const int _buildingYearlyTarget  = 204;

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
    ]);

    if (!mounted) return;
    setState(() {
      _loadingLive = false;
    });
  }

  String _number = '';
  String _SUbid = '';

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
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_building.php'
            '?fieldworkarnumber=${_number}',
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
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_flat_for_buy_field.php'
            '?field_workar_number=${_number}',
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
        _buyLiveCount = count; // e.g. 11
        _buyErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _buyLiveCount = 0;
        _buyErr = 'Failed to load buy live count';
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
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_flat_for_field.php'
            '?field_workar_number=${_number}',
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
        _liveCount = count;
        _loadingLive = false;
        _liveErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _liveCount = 0;
        _loadingLive = false;
        _liveErr = 'Failed to load live count';
      });
    }
  }

  Future<void> _fetchCommercialLiveCount() async {
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_commercial_space.php'
            '?field_workar_number=${_number}',
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
        _commercialLiveCount = count; // e.g. 6
        _commercialErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _commercialLiveCount = 0;
        _commercialErr = 'Failed to load commercial live count';
      });
    }
  }

  Future<void> _fetchAgreementCount() async {
    try {
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_agreement.php'
            '?Fieldwarkarnumber=${_number}', // note the param casing and number
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
        _agreementCount = count; // e.g. 2
        _agreementErr = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _agreementCount = 0;
        _agreementErr = 'Failed to load agreement count';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final overallPct = (_liveCount / _overallTarget).clamp(0.0, 1.0);
    final monthlyPct = (_liveCount / _monthlyTarget).clamp(0.0, 1.0);

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
            children: [
              if (_liveErr != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent),
                  ),
                  child: Text(
                    _liveErr!,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ),

              // ===================== RENT SECTION =====================
              _sectionHeader('Live Flats (Rent)'),
              const SizedBox(height: 8),

              _PieKpiCard(
                title: 'Yearly Target 100',
                liveCount: _liveCount,
                // e.g. 27
                target: _overallTarget,
                // 100
                colorLive: Colors.blue,
                // live dot blue
                colorRemain: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),

              _PieKpiCard(
                title: 'Monthly Target 15',
                liveCount: _liveCount,
                // e.g. 27
                target: _monthlyTarget,
                // 15
                colorLive: Colors.green,
                // live dot green
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _liveCount, // show 27 as highlighted pill
              ),

              _sectionDivider(),

              // ===================== BUY SECTION =====================
              _sectionHeader('Live Flats (Buy)'),
              const SizedBox(height: 8),

              _PieKpiCard(
                title: 'Yearly Target 60',
                liveCount: _buyLiveCount,
                target: _moreYearlyTarget,
                colorLive: Colors.deepPurple,
                colorRemain: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),

              _PieKpiCard(
                title: 'Monthly Target 5',
                liveCount: _buyLiveCount,
                target: _moreMonthlyTarget,
                colorLive: Colors.teal,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _buyLiveCount,
              ),

              const SizedBox(height: 16),
              _sectionDivider(),

              // ===================== Commercial Live Spaces =====================
              _sectionHeader('Live Flats (Commercial)'),
              const SizedBox(height: 8),

// Commercial Yearly 60
              _PieKpiCard(
                title: 'Yearly Target 60',
                liveCount: _commercialLiveCount,
                target: _commercialYearlyTarget,
                colorLive: Colors.cyan.shade400,
                colorRemain: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),
// Commercial Monthly 5
              _PieKpiCard(
                title: 'Monthly Target 5',
                liveCount: _commercialLiveCount,
                target: _commercialMonthlyTarget,
                colorLive: Colors.orange.shade400,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _commercialLiveCount,
              ),

              _sectionDivider(),

              // ===================== Agreements =====================
              _sectionHeader('Agreements'),
              const SizedBox(height: 8),

// Agreements (Yearly 180)
              _PieKpiCard(
                title: 'Yearly Target 180',
                liveCount: _agreementCount,
                target: _agreementYearlyTarget,
                colorLive: Colors.redAccent,
                colorRemain: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),

// Agreements (Monthly 15)

              _PieKpiCard(
                title: 'Monthly Target 15',
                liveCount: _agreementCount,
                target: _agreementMonthlyTarget,
                colorLive: Colors.lime,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _agreementCount,
              ),


              // ===================== Agreements =====================

              _sectionDivider(),
              _sectionHeader('Buildings'),
              const SizedBox(height: 8),

// Buildings (Yearly 204)
              _PieKpiCard(
                title: 'Yearly Target 204',
                liveCount: _buildingCount,
                target: _buildingYearlyTarget,
                colorLive: Colors.pinkAccent,         // your call
                colorRemain: Colors.grey.shade700,
              ),
              const SizedBox(height: 16),

// Buildings (Monthly 17)
              _PieKpiCard(
                title: 'Monthly Target 17',
                liveCount: _buildingCount,
                target: _buildingMonthlyTarget,
                colorLive: Colors.lightBlueAccent,
                colorRemain: Colors.grey.shade700,
                totalThisMonth: _buildingCount,       // show raw in the pill
              ),

            ],
          ),
        ),
      ),
    );
  }

}
Widget _sectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

Widget _sectionDivider() {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Divider(color: Colors.grey, height: 1),
  );
}

class _PieKpiCard extends StatelessWidget {
  final String title;
  final int liveCount;
  final int target;
  final Color colorLive;      // <- drives both pie + legend for "Live"
  final Color colorRemain;    // <- drives both pie + legend for "Remaining"
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
      color: Theme.of(context).brightness==Brightness.dark?Colors.white12:Colors.grey.shade100,
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

