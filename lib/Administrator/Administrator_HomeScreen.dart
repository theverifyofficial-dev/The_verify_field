import 'dart:convert';

import 'package:animated_analog_clock/animated_analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/Admin_upcoming.dart';
import '../Adminisstrator_Target_details/Targets.dart';
import '../Calender/CalenderForAdmin.dart';
import '../Home_Screen.dart' hide AgreementTaskResponse, FuturePropertyResponse, WebsiteVisitResponse;
import '../Web_query/web_query.dart' hide SlideAnimation;
import '../Z-Screen/Social_Media_links.dart';
import '../main.dart';
import '../ui_decoration_tools/app_images.dart';
import 'AdminInsurance/AdminInsuranceListScreen.dart';
import 'AdminRealEstateTabbar.dart';
import 'Admin_future _property/Administater_Future_Tabbar.dart';
import 'Admin_profile.dart';
import 'Administater_Parent_TenantDemand.dart';
import 'All_Rented_Flat/Administator_Add_Rented_Flat_Tabbar.dart';
import 'Administator_Agreement/Admin_dashboard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'New_TenandDemand/Admin_tabbar.dart';

class AppGradients {

  static LinearGradient blue() => const LinearGradient(
    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient green() => const LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF047857)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient orangeRed() => const LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient purple() => const LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient red() => const LinearGradient(
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cyan() => const LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF0891B2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient indigo() => const LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient dual() => const LinearGradient(
    colors: [Colors.blue, Colors.purple],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient blueRed() => const LinearGradient(
    colors: [Color(0xFF1D4ED8), Color(0xFFDC2626)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient redCyan() => const LinearGradient(
    colors: [Color(0xFFDC2626), Color(0xFF06B6D4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
class AdministratorHome_Screen extends StatefulWidget {
  static const route = "/AdministratorHome_Screen";
  const AdministratorHome_Screen({super.key});

  @override
  State<AdministratorHome_Screen> createState() => _AdministratorHome_ScreenState();
}

class _AdministratorHome_ScreenState extends State<AdministratorHome_Screen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int pendingCount = 0;
  int BookCount = 0;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;
  bool todayLoading = false;
  String number = '';

  @override
  void initState() {
    super.initState();
    // Future.microtask(() => hitAgreementRenewalAPI());
    loadUserName();
    fetchAgreementCount(); // must exist
    fetchBookCount(); // must exist
    fetchTodayData();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )
      ..repeat();
    _shineAnimation = CurvedAnimation(
      parent: _shineController,
      curve: Curves.easeInOut,
    );
  }
  TodayCounts? todayCounts;
  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    final storedFAadharCard = prefs.getString('post');

    if (!mounted) return;

    setState(() {
      userName = storedName;
      userNumber = storedNumber;
      userStoredFAadharCard = storedFAadharCard;
      number = storedNumber ?? '';   // 🔥 IMPORTANT
    });

    debugPrint("🔥 Loaded FieldWorker Number: $number");

    if (number.isNotEmpty) {
    }
  }

  Future<void> hitAgreementRenewalAPI() async {

    const String url = "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement_renewal_cron.php";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        print("✅ Agreement renewal API triggered successfully.");
        print("Response: ${response.body}");
      } else {
        print("⚠️ API failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error hitting agreement renewal API: $e");
    }
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  String? userName;
  String? userNumber;
  String? userStoredFAadharCard;

  // Future<void> loadUserName() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   final storedName = prefs.getString('name');
  //   final storedNumber = prefs.getString('number');
  //   final storedFAadharCard = prefs.getString('post');
  //
  //   if (mounted) {
  //     setState(() {
  //       userName = storedName;
  //       userNumber = storedNumber;
  //       userStoredFAadharCard = storedFAadharCard;
  //     });
  //   }
  // }

  Future<void> fetchAgreementCount() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/all_agreement_count.php',
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true) {
          final data = decoded["data"];

          setState(() {
            pendingCount = data[0][0]["PreviewCount"] ?? 0;

          });
        }
      }
    } catch (e) {
    }
  }

  Future<void> fetchBookCount() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Payment/all_payment_count_for_admin.php',
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true) {
          final data = decoded["data"];

          setState(() {
            BookCount = data[0][0]["BookingCount"] ?? 0;

          });
        }
      }
    } catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final primaryColor = Theme
        .of(context)
        .primaryColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 70),
        leading: Container(
          margin: const EdgeInsets.only(left: 8),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () =>
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AdminProfile()),
                ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                // Important for proper centering
                children: [
                  Icon(
                    PhosphorIcons.user_circle,
                    color: Colors.white,
                    size: 28, // Slightly reduced for better proportion
                  ),
                  if (userName != null && userName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      // Small top padding
                      child: Text(
                        userName!.length > 10
                            ? '${userName!.substring(0, 10)}..'
                            : userName!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
        leadingWidth: 80,
        // Fixed width for consistent spacing
        actions:  [
          IconButton(
            icon: Icon(
                ThemeSwitcher.of(context)?.themeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
                color: Colors.yellow

            ),
            onPressed: () {
              ThemeSwitcher.of(context)?.toggleTheme();
            },
          ),
          SizedBox(width: 5,),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> LinksPage()));
            },
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  children: [
                    const Text('🌐'),
                  ],
                ),
                const Text('Web', style: TextStyle(
                      fontFamily: "PoppinsMedium",color: Colors.white),),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) =>
                  SlideAnimation(
                    verticalOffset: 50.0,
                    child:
                    AnimationLimiter(child: widget),
                  ),
              children: [
                const SizedBox(height: 20),
                // Main Real Estate Card with Shine Effect
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF31D8FF),
                              primaryColor.withOpacity(
                                  0.1 + 0.3 * _shineAnimation.value),
                              const Color(0xFFFD0098),
                            ],
                            stops: const [0.0, 0.5, 1.0],
                            begin: Alignment(
                                -1.0 + (2.0 * _shineAnimation.value), -1.0),
                            end: Alignment(
                                1.0 - (2.0 * _shineAnimation.value), 1.0),
                          ),
                        ),
                        child: Card(
                          color: isDarkMode ? Colors.white10 : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: primaryColor.withOpacity(
                                  0.3 * _shineAnimation.value),
                              width: 1.5,
                            ),
                          ),
                          elevation: 6,
                          shadowColor: primaryColor.withOpacity(0.2),
                          child: InkWell(
                            onTap: () =>
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (
                                        context) => const AdminRealEstateTabbar(),
                                  ),
                                ),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 8,
                                          offset: const Offset(2, 4),
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.asset(
                                        AppImages.houseRealEstate,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      "Real Estate",
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "PoppinsBold",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: _TargetHeaderCard(context),
                ),
                _todayCard(isDarkMode),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = MediaQuery
                          .of(context)
                          .size
                          .width;
                      final screenHeight = MediaQuery
                          .of(context)
                          .size
                          .height;

                      // Dynamic grid calculation
                      final crossAxisCount = screenWidth > 800 ? 4 :
                      screenWidth > 600 ? 3 : 2;

                      // Calculate item width based on available space
                      final availableWidth = constraints.maxWidth;
                      final itemWidth = (availableWidth -
                          ((crossAxisCount - 1) * 16)) / crossAxisCount;
                      final childAspectRatio = itemWidth /
                          (itemWidth * 1.1); // Height is 10% more than width

                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final List<Map<String, dynamic>> featureItems = [
                            {
                              "image": AppImages.agreement,
                              "title": "Property \nAgreement",
                              "gradient": AppGradients.blue(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AdminDashboard()),
                                );
                              },
                              "count": pendingCount,
                            },
                            {
                              "image": AppImages.propertysale,
                              "title": "Future\nInventory/Property",
                              "gradient": AppGradients.orangeRed(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AdministaterPropertyTabPage()),
                                );
                              },
                              "count": 0,
                            },

                            {
                              "image": AppImages.police,
                              "title": "All Rented Flat",
                              "gradient": AppGradients.red(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AdministatorAddRentedFlatTabbar()),
                                );
                              },
                              "count": BookCount,
                            },
                            {
                              "image": AppImages.websiteIssue,
                              "title": "Web \nQuery",
                              "gradient": AppGradients.cyan(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const WebQueryPage()),
                                );
                              },
                              "count": 0,
                            },

                            {
                              "image": AppImages.realestatefeild,
                              "title": "Upcoming\n Property",
                              "gradient": AppGradients.purple(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AdminUpcoming()),
                                );
                              },
                              "count": 0,
                            },
                            // {
                            //   "image": AppImages.calendar,
                            //   "title": "Task Calendar",
                            //   "gradient": AppGradients.blueRed(),
                            //   "onTap": () {
                            //     Navigator.push(
                            //       context,
                            //       MaterialPageRoute(
                            //           builder: (_) => const CalendarTaskPageForAdmin()),
                            //     );
                            //   },
                            //   "count": 0,
                            // },
                            {
                              "image": AppImages.demand_2,
                              "title": "Costumer Demands",
                              "gradient": AppGradients.indigo(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AdminTabbar()),
                                );
                              },
                              "count": 0,
                            },

                            {
                              "image": AppImages.tenant,
                              "title": "Costumer Demands",
                              "gradient": AppGradients.blue(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Administater_parent_TenandDemand()),
                                );
                              },
                              "count": 0,
                            },
                            {
                              "image": AppImages.compliant,
                              "title": "Insurance",
                              "gradient": AppGradients.dual(),
                              "onTap": () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const AdminInsuranceListScreen()),
                                );
                              },
                              "count": 0,

                            },
                          ];

                          final item = featureItems[index];

                          return _buildFeatureCard(
                            context: context,
                            imagePath: item['image'],
                            title: item['title'],
                            onTap: item['onTap'],
                            gradient: item['gradient'],
                            itemWidth: itemWidth,
                            count: item['count'],
                          );
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _TargetHeaderCard(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Target()),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: isDark?
            [Color(0xFF1E1E1E), Color(0xFF2C2C2C)]
                :
            [Colors.grey.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : Colors.black.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔥 Animated Glow with Image
            Stack(
              alignment: Alignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.blueAccent.withOpacity(0.4)
                            : Colors.blue.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    AppImages.target, // your target image asset here
                    height: 55,
                    width: 55,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 18),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Target",
                      style: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tap to view progress",
                      style: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: 13.5,
                      color: (isDark ? Colors.white : Colors.black).withOpacity(0.75),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 18,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildFeatureCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required VoidCallback onTap,
    required double itemWidth,
    required Gradient gradient,
    int? count,
  }) {
    final imageSize = itemWidth * 0.24;
    final fontSize = itemWidth * 0.075;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: gradient,
          // boxShadow: [
          //   BoxShadow(
          //     color: (gradient as LinearGradient)
          //         .colors
          //         .first
          //         .withOpacity(0.4),
          //     blurRadius: 25,
          //     offset: const Offset(0, 12),
          //   ),
          // ],
        ),
        child: Stack(
          children: [

            Positioned(
              bottom: -20,
              right: -20,
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),

            /// 🔥 Badge (Top Right)
            if (count != null && count > 0)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  height: 26,
                  width: 26,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    count > 99 ? "99+" : count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "PoppinsMedium",
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            /// 🔥 Main Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ICON CIRCLE
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.2),
                    ),
                    child: Image.asset(
                      imagePath,
                      height: imageSize,
                      fit: BoxFit.contain,
                    ),
                  ),

                  const Spacer(),

                  /// TITLE
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: "PoppinsMedium",
                      fontSize: fontSize.clamp(14, 18),
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _todayCard(bool isDark) {
    final today = DateTime.now();

    final monthNames = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    final weekNames = [
      "MON","TUE","WED","THU","FRI","SAT","SUN"
    ];

    int agreements = todayCounts?.agreements ?? 0;
    int websiteVisits = todayCounts?.websiteVisits ?? 0;

    int totalToday = agreements + websiteVisits;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CalendarTaskPageForAdmin()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
              Colors.grey.shade900,
              Colors.black87,
              Colors.grey.shade900,
            ]
                : [
              Colors.white,
              Colors.white,

            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
              blurRadius: 25,
              spreadRadius: 1,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// -------- HEADER --------
            Row(
              children: [

                /// DATE BOX
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    children: [
                      Text(
                        weekNames[today.weekday - 1],
                        style: const TextStyle(
                          fontFamily: "PoppinsMedium",
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        today.day.toString(),
                        style: const TextStyle(
                          fontFamily: "PoppinsMedium",
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        monthNames[today.month - 1],
                        style: const TextStyle(
                          fontFamily: "PoppinsMedium",
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Colors.white,
                        Colors.blueGrey.shade100,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: Colors.blueGrey.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: ClipOval(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: AnimatedAnalogClock(
                        size: 90,
                        hourHandColor: Colors.black,
                        minuteHandColor: Colors.black87,
                        secondHandColor: Colors.redAccent,
                      ),
                    ),
                  ),
                )

              ],
            ),

            const SizedBox(height: 20),

            /// -------- TITLE --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalToday == 0
                      ? "No Events Today"
                      : "Today's Events",
                  style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),
                if (totalToday > 0)
                Text(
                  "$totalToday Total",
                  style: TextStyle(
                    fontFamily: "PoppinsMedium ",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark
                        ? Colors.greenAccent
                        : Colors.green.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// -------- COUNT CARDS --------
            Row(
              children: [
                Expanded(
                  child: _modernCountCard(
                    "Agreements",
                    agreements,
                    const Color(0xFFEF4444),
                    isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _modernCountCard(
                    "Web Visit",
                    websiteVisits,
                    const Color(0xFF10B981),
                    isDark,
                  ),
                ),
              ],
            ),



          ],
        ),
      ),
    );
  }
  Widget _modernCountCard(
      String title,
      int count,
      Color color,
      bool isDark,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isDark
            ? color.withOpacity(0.15)
            : color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontFamily: "PoppinsMedium",
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PoppinsMedium",
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  Widget _countBox(String title, int count, Color color) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _enhancedCountBox(String title, int count, Gradient gradient, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            // Icon with gradient background
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontFamily: "PoppinsMedium",
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = gradient.createShader(
                    const Rect.fromLTWH(0, 0, 200, 100),
                  ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                fontFamily: "PoppinsMedium",
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'agreement':
        return Colors.redAccent;
      case 'future':
        return Colors.blueAccent;
      case 'website':
        return Colors.greenAccent;
      default:
        return Colors.blueGrey;
    }
  }


  String _todayString() {
    final t = DateTime.now();
    return "${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}";
  }

  Future<void> fetchTodayData() async {
    final today = _todayString();

    debugPrint("📅 TODAY DATE SENT TO ADMIN API: $today");

    int agreements = 0;
    int future = 0;
    int website = 0;

    try {
      final agreementUrl =
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Calender/task_agreement_for_admin.php?current_dates=$today";

      final futureUrl =
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Calender/task_building_for_admin.php?current_date_=$today";

      final websiteUrl =
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Calender/web_visit_for_admin.php?dates=$today";

      final responses = await Future.wait([
        http.get(Uri.parse(agreementUrl)),
        http.get(Uri.parse(futureUrl)),
        http.get(Uri.parse(websiteUrl)),
      ]);

      // ---------------- AGREEMENT ----------------
      debugPrint("---- ADMIN AGREEMENT RESPONSE ----");
      debugPrint(responses[0].body);

      final agreementDecoded = jsonDecode(responses[0].body);
      if (agreementDecoded is Map &&
          agreementDecoded["data"] is List) {
        agreements = (agreementDecoded["data"] as List).length;
      }

      // ---------------- FUTURE ----------------
      debugPrint("---- ADMIN FUTURE RESPONSE ----");
      debugPrint(responses[1].body);

      final futureDecoded = jsonDecode(responses[1].body);

      if (futureDecoded is List) {
        future = futureDecoded.length;
      } else if (futureDecoded is Map &&
          futureDecoded["data"] is List) {
        future = (futureDecoded["data"] as List).length;
      }

      // ---------------- WEBSITE ----------------
      debugPrint("---- ADMIN WEBSITE RESPONSE ----");
      debugPrint(responses[2].body);

      final websiteDecoded = jsonDecode(responses[2].body);
      if (websiteDecoded is Map &&
          websiteDecoded["status"] != "error" &&
          websiteDecoded["data"] is List) {
        website = (websiteDecoded["data"] as List).length;
      }

      debugPrint("🔥 FINAL ADMIN TOTAL");
      debugPrint("Agreements: $agreements");
      debugPrint("Future: $future");
      debugPrint("Website: $website");

      if (mounted) {
        setState(() {
          todayCounts = TodayCounts(
            agreements: agreements,
            websiteVisits: website,
          );
        });
      }

    } catch (e) {
      debugPrint("🔥 ERROR IN ADMIN fetchTodayData: $e");
    }
  }
}