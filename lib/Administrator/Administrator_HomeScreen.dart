import 'dart:convert';
import 'package:animated_analog_clock/animated_analog_clock.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/Admin_upcoming.dart';
import '../Admin_Target_And_Tasks/admin_target_and_tasks_home.dart';
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

    AppLogger.api("🔥 Loaded FieldWorker Number: $number");

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
      body: CustomScrollView(
        slivers: [
          // Rebuilt 2026-09-21 per explicit follow-up ("remove the admin
          // & sub-admin's home screen's appbar & header & target task
          // cards & add new one"): this replaces BOTH the old plain
          // black `AppBar` (profile icon, theme toggle, web-link button)
          // AND the separate greeting banner added in the previous pass
          // with ONE combined, collapsing gradient `SliverAppBar` --
          // matching `Home_Screen.dart`'s (field worker) own top header
          // shape exactly, instead of two stacked headers. All three of
          // the old AppBar's actions (profile nav, theme toggle, web
          // link) are preserved, just moved into this header's row.
          _buildTopHeader(context, isDarkMode),
          SliverToBoxAdapter(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             _AddTenantCard(),                 // <-- add this line
        AnimationLimiter(
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

                // Rebuilt 2026-09-22 per explicit follow-up ("remove
                // the current admin home screen's target & task card &
                // update the below calender UI & navigation to same as
                // fieldworkers target & task card"): the separate
                // `_taskAndTargetCard` this screen used to show above
                // the calendar-preview card is gone -- `_todayCard`
                // below is now itself titled/styled as the "Tasks &
                // Targets" card (see that method's doc comment) and is
                // the only entry point into `AdminTargetAndTasksHome`.
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
                        itemCount: 8,
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
                              "gradient": AppGradients.cyan
                                (),
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
                              "gradient": AppGradients.red(),
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
        ]
      ),
          ),
        ],
      ),
    );
  }

  /// Small helper used by `_buildTopHeader` below -- mirrors
  /// `Home_Screen.dart`'s (field worker) own local `getGreeting()`
  /// closure, copied rather than shared since that one lives inline
  /// inside a `build()` method, not as an exported function.
  String _greetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  /// Rebuilt 2026-09-21 per explicit follow-up ("remove the admin &
  /// sub-admin's home screen's appbar & header & target task cards &
  /// add new one"): ONE collapsing gradient `SliverAppBar`, styled like
  /// `Home_Screen.dart`'s (field worker) own top header, replacing BOTH
  /// the plain black `AppBar` this screen used to have AND the separate
  /// greeting banner added in the previous pass. The old `AppBar`'s three
  /// pieces of real functionality -- profile nav, theme toggle, web link
  /// -- are preserved here, just rearranged into this header's own row
  /// instead of `leading`/`actions`.
  Widget _buildTopHeader(BuildContext context, bool isDark) {
    final screenWidth = MediaQuery.of(context).size.width;
    final expandedHeight = (MediaQuery.of(context).size.height * 0.15).clamp(160.0, 250.0);

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: 64,
      floating: true,
      pinned: true,
      elevation: 10,
      backgroundColor: Colors.black,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade700, Colors.indigo.shade800, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => AdminProfile()),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.account_circle, color: Colors.white, size: 30),
                            if (userName != null && userName!.isNotEmpty)
                              Text(
                                userName!.length > 10 ? '${userName!.substring(0, 10)}..' : userName!,
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                      Image.asset(AppImages.transparent, height: 36),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              ThemeSwitcher.of(context)?.themeMode == ThemeMode.dark
                                  ? Icons.light_mode
                                  : Icons.dark_mode,
                              color: Colors.yellow,
                            ),
                            onPressed: () => ThemeSwitcher.of(context)?.toggleTheme(),
                          ),
                          IconButton(
                            onPressed: () => Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => LinksPage())),
                            icon: const Text('🌐', style: TextStyle(fontSize: 20)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      Text(
                        _greetingText(),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontFamily: "PoppinsMedium",
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          '${userName ?? ''}.',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontFamily: "PoppinsMedium",
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
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
  /// Admin's "Tasks & Targets" card -- previously a plain "Today's
  /// Events" calendar teaser navigating to `CalendarTaskPageForAdmin`
  /// (`CalenderForAdmin.dart`). Rebuilt 2026-09-22 per explicit request
  /// ("update the below calender UI & navigation to same as
  /// fieldworkers target & task card"): gained the same cyan/purple
  /// "Tasks & Targets" accent-bar header the field worker's own
  /// `_tasksAndTargetsCard` (`Home_Screen.dart`) shows above its
  /// date/today's-counts content, and now navigates to
  /// `AdminTargetAndTasksHome` instead of the old calendar screen --
  /// this card is now the ONLY "Tasks & Targets" entry point on this
  /// home screen (the separate card that used to sit above it is gone).
  /// The field worker's card also has a "Tomorrow's events" preview
  /// below its today's-counts section; that's deliberately NOT
  /// replicated here -- there's no existing admin-wide API for
  /// tomorrow's events, and guessing one would risk showing wrong data,
  /// per explicit decision to skip it rather than guess.
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
          MaterialPageRoute(builder: (_) => const AdminTargetAndTasksHome()),
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

            /// -------- "TASKS & TARGETS" HEADER (2026-09-22) --------
            /// Same accent-bar + title treatment as the field worker's
            /// own `_tasksAndTargetsCard` in `Home_Screen.dart`.
            Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.cyan, Colors.purpleAccent],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  "Tasks & Targets",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

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
                  child: const ClipOval(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
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

    AppLogger.api("📅 TODAY DATE SENT TO ADMIN API: $today");

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
      AppLogger.api("---- ADMIN AGREEMENT RESPONSE ----");
      AppLogger.api(responses[0].body);

      final agreementDecoded = jsonDecode(responses[0].body);
      if (agreementDecoded is Map &&
          agreementDecoded["data"] is List) {
        agreements = (agreementDecoded["data"] as List).length;
      }

      // ---------------- FUTURE ----------------
      AppLogger.api("---- ADMIN FUTURE RESPONSE ----");
      AppLogger.api(responses[1].body);

      final futureDecoded = jsonDecode(responses[1].body);

      if (futureDecoded is List) {
        future = futureDecoded.length;
      } else if (futureDecoded is Map &&
          futureDecoded["data"] is List) {
        future = (futureDecoded["data"] as List).length;
      }

      // ---------------- WEBSITE ----------------
      AppLogger.api("---- ADMIN WEBSITE RESPONSE ----");
      AppLogger.api(responses[2].body);

      final websiteDecoded = jsonDecode(responses[2].body);
      if (websiteDecoded is Map &&
          websiteDecoded["status"] != "error" &&
          websiteDecoded["data"] is List) {
        website = (websiteDecoded["data"] as List).length;
      }

      AppLogger.api("🔥 FINAL ADMIN TOTAL");
      AppLogger.api("Agreements: $agreements");
      AppLogger.api("Future: $future");
      AppLogger.api("Website: $website");

      if (mounted) {
        setState(() {
          todayCounts = TodayCounts(
            agreements: agreements,
            websiteVisits: website,
          );
        });
      }

    } catch (e) {
      AppLogger.api("🔥 ERROR IN ADMIN fetchTodayData: $e");
    }
  }
}

class _AddTenantCard extends StatefulWidget {
  const _AddTenantCard();

  @override
  State<_AddTenantCard> createState() => _AddTenantCardState();
}

class _AddTenantCardState extends State<_AddTenantCard> {
  void _openAddTenantSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // so it can grow above keyboard
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.4,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white24 : Colors.black12,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const _AddTenantForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: GestureDetector(
        onTap: () => _openAddTenantSheet(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
                  : [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.4 : 0.1),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppGradients.indigo(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Add Tenant Demand',
                  style: TextStyle(
                    fontFamily: "PoppinsBold",
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: isDark ? Colors.white70 : Colors.black45,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddTenantForm extends StatefulWidget {
  const _AddTenantForm();

  @override
  State<_AddTenantForm> createState() => _AddTenantFormState();
}

class _AddTenantFormState extends State<_AddTenantForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _numberCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String? _bhk;
  String _buyRent = 'Rent';
  bool _loading = false;

  final List<String> _bhkOptions = ['1 RK', '1 BHK', '2 BHK', '3 BHK', '4 BHK+'];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _numberCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_bhk == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select BHK')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final fn = prefs.getString('name') ?? '';
      final fno = prefs.getString('number') ?? '';

      final addInfo = 'Budget: ${_priceCtrl.text.trim()} | call par baat ho gyi hai deal handle karo';

      final url = Uri.parse(
        'https://verifyrealestateandservices.in/WebService4.asmx/add_assign_tanant_demand_2nd_table'
            '?fieldworkar_name=${Uri.encodeComponent(fn)}'
            '&fieldworkar_number=${Uri.encodeComponent(fno)}'
            '&demand_name=${Uri.encodeComponent(_nameCtrl.text.trim())}'
            '&demand_number=${Uri.encodeComponent(_numberCtrl.text.trim())}'
            '&buy_rent=${Uri.encodeComponent(_buyRent)}'
            '&add_info=${Uri.encodeComponent(addInfo)}'
            '&location_=Sultanpur'
            '&reference=Call'
            '&feedback=Pending'
            '&looking_type=Blank'
            '&bhk=${Uri.encodeComponent(_bhk!)}',
      );

      final response = await http.get(url);

      if (!mounted) return;

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tenant demand added successfully'),
            backgroundColor: Colors.green,
          ),
        );
        _formKey.currentState!.reset();
        _nameCtrl.clear();
        _numberCtrl.clear();
        _priceCtrl.clear();
        setState(() => _bhk = null);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  InputDecoration _decoration(String label, IconData icon, bool isDark) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontFamily: "PoppinsMedium",
        color: isDark ? Colors.white60 : Colors.grey.shade600,
        fontSize: 13,
      ),
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6366F1)),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.shade100,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// -------- GRADIENT HEADER BANNER (matches _TargetHeaderCard) --------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E1E1E), const Color(0xFF2C2C2C)]
                    : [Colors.grey.shade100, Colors.white],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.black.withOpacity(0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: AppGradients.indigo(),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person_add_alt_1, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Add Tenant Demand",
                        style: TextStyle(
                          fontFamily: "PoppinsBold",
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Fill in the details below",
                        style: TextStyle(
                          fontFamily: "PoppinsMedium",
                          fontSize: 12.5,
                          color: (isDark ? Colors.white : Colors.black).withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// -------- FORM FIELDS CARD --------
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.grey.shade50,
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.05),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _nameCtrl,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                        decoration: _decoration('Name', Icons.person_outline, isDark),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          if (v.trim().length < 3) return 'Too short';
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: _numberCtrl,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                        decoration: _decoration('Number', Icons.call_outlined, isDark),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return 'Required';
                          final cleaned = v.trim().replaceAll(RegExp(r'[\s-]'), '');
                          // accepts: 9876543210 | +919876543210 | 919876543210
                          if (!RegExp(r'^(\+?91)?[6-9]\d{9}$').hasMatch(cleaned)) {
                            return 'Invalid number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _bhk,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        decoration: _decoration('BHK', Icons.house_outlined, isDark),
                        items: _bhkOptions
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                            .toList(),
                        onChanged: (v) => setState(() => _bhk = v),
                        validator: (v) => v == null ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _buyRent,
                        style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                        dropdownColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                        decoration: _decoration('Buy/Rent', Icons.swap_horiz, isDark),
                        items: ['Rent', 'Buy']
                            .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13))))
                            .toList(),
                        onChanged: (v) => setState(() => _buyRent = v ?? 'Rent'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 13.5),
                  decoration: _decoration('Price / Budget', Icons.currency_rupee, isDark),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (double.tryParse(v.trim()) == null) return 'Numbers only';
                    return null;
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// -------- GRADIENT SUBMIT BUTTON (matches home screen gradient cards) --------
          SizedBox(
            width: double.infinity,
            height: 50,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: AppGradients.indigo(),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6366F1).withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: _loading ? null : _submit,
                  child: Center(
                    child: _loading
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                        : const Text(
                      'Add Tenant',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "PoppinsMedium",
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}