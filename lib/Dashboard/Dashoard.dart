import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:animated_flip_counter/animated_flip_counter.dart';

import '../constant.dart';
import 'AllFieldWorkers.dart';
class WorkerId {
  final String name;
  final String number;
  const WorkerId({required this.name, required this.number});
}

class WorkerStats {
  int liveRent = 0;
  int liveBuy = 0;
  int liveCommercial = 0;
  int agreements = 0;
  int buildings = 0;

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
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  bool isLoading = true;
  bool hasError = false;

  int _liveFlats = 0;
  int _liveCommercial = 0;
  int _bookedFlats = 0;
  int _bookedCommercial = 0;
  int _totalBuildings = 0;
  int _flipEpoch = 0;

  bool _loadingWorkers = true;
  String? _workersError;
  final Map<String, WorkerStats> _wstats = {};
  List<WorkerId> _workers = const [];

  int _sumitBuildings = 0;
  int _raviBuildings = 0;
  int _faizanBuildings = 0;
  int _totalWorkerBuildings = 0;


  final Map<String, Color> _lightColors = {
    'primary': const Color(0xFF1E3A8A),
    'secondary': const Color(0xFF3B82F6),
    'background': const Color(0xFFF8FAFC),
    'surface': Colors.white,
    'green': const Color(0xFF10B981),
    'orange': const Color(0xFFF59E0B),
    'blue': const Color(0xFF3B82F6),
    'purple': const Color(0xFF8B5CF6),
    'deepPurple': const Color(0xFF7C3AED),
    'textLight': Colors.white,
    'textDark': Colors.black,
  };

  final Map<String, Color> _darkColors = {
    'primary': const Color(0xFF1E40AF),
    'secondary': const Color(0xFF3B82F6),
    'background': Colors.black87,
    'surface': const Color(0xFF1E293B),
    'green': const Color(0xFF059669),
    'orange': const Color(0xFFD97706),
    'blue': const Color(0xFF2563EB),
    'purple': const Color(0xFF7C3AED),
    'deepPurple': const Color(0xFF6D28D9),
    'textLight': Colors.white,
    'textDark': Colors.white,
  };
  int _totalAgreements = 0;

  Map<String, Color> get colors =>
      Theme.of(context).brightness == Brightness.dark ? _darkColors : _lightColors;

  Color get textColor => _darkColors['textLight']!
        ; // ✅ Changed to textDark for light mode

  Color get secondaryTextColor => Colors.white; // ✅ Was white earlier — now black

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _scaleAnimation = CurvedAnimation(parent: _animationController, curve: Curves.elasticOut);
    _fetchDashboardData();
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is double) return v.round();
    return int.tryParse(v?.toString() ?? '0') ?? 0;
  }

  Future<void> _fetchDashboardData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Fetch all data in parallel for SPEED ⚡️
      final responses = await Future.wait([
        // Dashboard main data
        http.get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Target/show_all_live_flat.php'))
            .timeout(const Duration(seconds: 6)),

        // Agreement APIs (Sumit, Ravi, Faizan)
        http.get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Target/show_tatal_agreement.php?Fieldwarkarnumber=9711775300')),
        http.get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Target/show_tatal_agreement.php?Fieldwarkarnumber=9711275300')),
        http.get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Target/show_tatal_agreement.php?Fieldwarkarnumber=9971172204')),

        // Building APIs (Sumit, Ravi, Faizan)
        http.get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Target/show_total_building.php?fieldworkarnumber=9711775300')),
        http.get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Target/show_total_building.php?fieldworkarnumber=9711275300')),
        http.get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Target/show_total_building.php?fieldworkarnumber=9971172204')),
      ]);

      // Parse dashboard stats
      final response = responses[0];
      if (response.statusCode == 200) {
        final root = json.decode(response.body);
        if (root['success'] == true && root['data'] is Map<String, dynamic>) {
          final data = root['data'] as Map<String, dynamic>;

          final liveFlats = _asInt(data['live flats']);
          final liveCommercial = _asInt(data['live commercial spaces']);
          final bookedFlats = _asInt(data['Book flats']);
          final bookedCommercial = _asInt(data['Book commercial spaces']);
          final totalBuildings = _asInt(data['Total Building']);

          // ✅ Agreements
          final List<int> agreements = [];
          for (int i = 1; i <= 3; i++) {
            final r = responses[i];
            if (r.statusCode == 200) {
              final aRoot = json.decode(r.body);
              final data = aRoot['data'] as Map<String, dynamic>? ?? {};
              agreements.add(_asInt(data['logg']));
            } else {
              agreements.add(0);
            }
          }

          // ✅ Buildings
          final List<int> workerBuildings = [];
          for (int i = 4; i <= 6; i++) {
            final r = responses[i];
            if (r.statusCode == 200) {
              final bRoot = json.decode(r.body);
              final data = bRoot['data'] as Map<String, dynamic>? ?? {};
              workerBuildings.add(_asInt(data['logg']));
            } else {
              workerBuildings.add(0);
            }
          }

          // Extract values
          final sumitAg = agreements[0];
          final raviAg = agreements[1];
          final faizanAg = agreements[2];
          final totalAg = sumitAg + raviAg + faizanAg;

          final sumitBld = workerBuildings[0];
          final raviBld = workerBuildings[1];
          final faizanBld = workerBuildings[2];
          final totalBld = sumitBld + raviBld + faizanBld;

          // Update state
          setState(() {
            _flipEpoch++;

            _liveFlats = liveFlats;
            _liveCommercial = liveCommercial;
            _bookedFlats = bookedFlats;
            _bookedCommercial = bookedCommercial;
            _totalBuildings = totalBuildings;

            _sumitAgreements = sumitAg;
            _raviAgreements = raviAg;
            _faizanAgreements = faizanAg;
            _totalAgreements = totalAg;

            _sumitBuildings = sumitBld;
            _raviBuildings = raviBld;
            _faizanBuildings = faizanBld;
            _totalWorkerBuildings = totalBld;

            isLoading = false;
            hasError = false;
          });

          Future.microtask(() => _animationController.forward(from: 0));
        } else {
          setState(() {
            hasError = true;
            isLoading = false;
          });
        }
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('⚠️ Dashboard fetch error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

// ✅ Much faster version (no long waits)
  Future<void> _replayFlip({
    required int liveFlats,
    required int liveCommercial,
    required int bookedFlats,
    required int bookedCommercial,
    required int totalBuildings,
  }) async {
    // instant reset without full rebuild
    setState(() {
      _flipEpoch++;
      _liveFlats = liveFlats;
      _liveCommercial = liveCommercial;
      _bookedFlats = bookedFlats;
      _bookedCommercial = bookedCommercial;
      _totalBuildings = totalBuildings;
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  int _sumitAgreements = 0;
  int _raviAgreements = 0;
  int _faizanAgreements = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colors['background'],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 70),
        leadingWidth: 80,
        actions: [
          IconButton(
            icon: const Icon(PhosphorIcons.arrow_clockwise, color: Colors.white),
            onPressed: _fetchDashboardData,
          ),
        ],
      ),
      body: isLoading
          ? _buildLoadingState()
          : hasError
          ? _buildErrorState()
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardContent(),
            // const SizedBox(height: 10),
            // _buildAgreementsSection(),
            // _buildWorkerBuildingsSection(),
          ],
        ),
      ),

    );
  }

  Widget _buildWorkerBuildingsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            "Buildings by Field Workers",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAgreementCard(
              name: "Sumit",
              count: _sumitBuildings,
              color: colors['purple']!,
              gradient: [
                colors['purple']!.withOpacity(0.7),
                colors['purple']!.withOpacity(0.9)
              ],
            ),
            _buildAgreementCard(
              name: "Ravi",
              count: _raviBuildings,
              color: colors['orange']!,
              gradient: [
                colors['orange']!.withOpacity(0.7),
                colors['orange']!.withOpacity(0.9)
              ],
            ),
            _buildAgreementCard(
              name: "Faizan",
              count: _faizanBuildings,
              color: colors['blue']!,
              gradient: [
                colors['blue']!.withOpacity(0.7),
                colors['blue']!.withOpacity(0.9)
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAgreementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8),
          child: Text(
            "Agreements by Field Workers",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
            ),
          ),
        ),
        const SizedBox(height: 12),

        // 🧱 Use GridView for gradient boxes just like main stats
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildAgreementCard(
              name: "Sumit",
              count: _sumitAgreements,
              color: colors['green']!,
              gradient: [
                colors['green']!.withOpacity(0.7),
                colors['green']!.withOpacity(0.9)
              ],
            ),
            _buildAgreementCard(
              name: "Ravi",
              count: _raviAgreements,
              color: colors['orange']!,
              gradient: [
                colors['orange']!.withOpacity(0.7),
                colors['orange']!.withOpacity(0.9)
              ],
            ),
            _buildAgreementCard(
              name: "Faizan",
              count: _faizanAgreements,
              color: colors['blue']!,
              gradient: [
                colors['blue']!.withOpacity(0.7),
                colors['blue']!.withOpacity(0.9)
              ],
            ),
          ],
        ),
      ],
    );
  }
  Widget _buildAgreementCard({
    required String name,
    required int count,
    required Color color,
    required List<Color> gradient,
  }) {
    return GestureDetector(
      onTapDown: (_) => setState(() {}),
      onTapUp: (_) => setState(() {}),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutQuad,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              gradient.first.withOpacity(0.9),
              gradient.last.withOpacity(0.85),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 15,
              spreadRadius: -2,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            // 💫 Light shimmer overlay
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.white.withOpacity(0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.description, color: Colors.white, size: 22),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(PhosphorIcons.trend_up, color: Colors.white70, size: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedFlipCounter(
                    key: ValueKey('agreement-$name-$count'),
                    value: count.toDouble(),
                    fractionDigits: 0,
                    duration: const Duration(milliseconds: 1100),
                    curve: Curves.easeOutBack,
                    thousandSeparator: ',',
                    textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name.toUpperCase(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: Colors.white.withOpacity(0.7),
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



  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(colors['primary']!)),
          const SizedBox(height: 20),
          Text(
            'Loading Dashboard...',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            'Failed to load data',
            style: TextStyle(
              fontSize: 18,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[300] : Colors.grey[700],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchDashboardData,
            style: ElevatedButton.styleFrom(backgroundColor: colors['primary']!, foregroundColor:colors['primary']! ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardContent() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(scale: _scaleAnimation, child: child),
        );
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeaderSummary(),
            const SizedBox(height: 10),
            GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AllFieldWorkersPage()),
                  );

                },
                child: _buildTotalBuildingsCard(_totalBuildings)),
            const SizedBox(height: 10),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildStatCard(
                  keyLabel: 'live-flats',
                  title: 'Live Flats',
                  value: _liveFlats,
                  icon: Icons.apartment,
                  color: colors['green']!,
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? [colors['green']!.withOpacity(0.7), colors['green']!.withOpacity(0.9)]
                      : [colors['green']!.withOpacity(0.7), colors['green']!],
                ),
                _buildStatCard(
                  keyLabel: 'live-com',
                  title: 'Live Commercial',
                  value: _liveCommercial,
                  icon: Icons.business_center,
                  color: colors['orange']!,
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? [colors['orange']!.withOpacity(0.7), colors['orange']!.withOpacity(0.9)]
                      : [colors['orange']!.withOpacity(0.7), colors['orange']!],
                ),
                _buildStatCard(
                  keyLabel: 'booked-flats',
                  title: 'Unlive Flats',
                  value: _bookedFlats,
                  icon: Icons.assignment_turned_in,
                  color: colors['blue']!,
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? [colors['blue']!.withOpacity(0.7), colors['blue']!.withOpacity(0.9)]
                      : [colors['blue']!.withOpacity(0.7), colors['blue']!],
                ),
                _buildStatCard(
                  keyLabel: 'booked-com',
                  title: 'Unlive Commercial',
                  value: _bookedCommercial,
                  icon: Icons.business,
                  color: colors['primary']!,
                  gradient: Theme.of(context).brightness == Brightness.dark
                      ? [colors['primary']!.withOpacity(0.7), colors['blue']!.withOpacity(0.9)]
                      : [colors['primary']!.withOpacity(0.7), colors['blue']!],
                ),
              ],
            ),
            const SizedBox(height: 24),

          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSummary() {
    final primaryText = Theme.of(context).brightness == Brightness.dark ? textColor : Colors.black;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.dashboard, color: primaryText, size: 24),
              const SizedBox(width: 8),
              Text(
                'Property Overview',
                style: TextStyle(color: primaryText, fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Real-time statistics and insights about your properties',
            style: TextStyle(color: primaryText, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String keyLabel,
    required String title,
    required int value,
    required IconData icon,
    required Color color,
    required List<Color> gradient,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: gradient),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                  child: Icon(icon, color: textColor, size: 20),
                ),
                Icon(PhosphorIcons.trend_up, color: textColor.withOpacity(0.7)),
              ],
            ),
            const SizedBox(height: 8),
            AnimatedFlipCounter(
              key: ValueKey('fc-$_flipEpoch-$keyLabel-$value'),
              value: value.toDouble(),
              fractionDigits: 0,
              duration: const Duration(milliseconds: 1200),
              curve: Curves.easeOutQuart,
              thousandSeparator: ',',
              textStyle: TextStyle(color: textColor, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(title, style: TextStyle(color: secondaryTextColor, fontSize: 14)),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalBuildingsCard(int totalBuildings) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: Theme.of(context).brightness == Brightness.dark
              ? [colors['deepPurple']!.withOpacity(0.7), colors['deepPurple']!.withOpacity(0.9)]
              : [colors['deepPurple']!.withOpacity(0.7), colors['deepPurple']!],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: colors['deepPurple']!.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Total Buildings', style: TextStyle(color: textColor, fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                AnimatedFlipCounter(
                  key: ValueKey('fc-$_flipEpoch-total-$_totalBuildings'),
                  value: totalBuildings.toDouble(),
                  fractionDigits: 0,
                  duration: const Duration(milliseconds: 1400),
                  curve: Curves.easeOutQuart,
                  thousandSeparator: ',',
                  textStyle: TextStyle(color: textColor, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text('Managed Properties', style: TextStyle(color: secondaryTextColor, fontSize: 14)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(Icons.architecture, color: textColor, size: 32),
          ),
        ],
      ),
    );
  }
}
