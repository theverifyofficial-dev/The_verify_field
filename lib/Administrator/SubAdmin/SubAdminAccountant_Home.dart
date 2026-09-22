import 'dart:convert';

import 'package:animated_analog_clock/animated_analog_clock.dart';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Z-Screen/Login_page.dart';
import '../../Adminisstrator_Target_details/Targets.dart';
import '../../Admin_Target_And_Tasks/admin_target_and_tasks_home.dart';
import '../../Administrator/Administator_Agreement/Admin_dashboard.dart';
import '../../Demand_2/Tabbar.dart';
import '../../Future_Property_OwnerDetails_section/Future_Property.dart';
import '../../Future_Property_OwnerDetails_section/Future_Property_Tabbar.dart';
import '../../Home_Screen_click/live_tabbar.dart';
import '../../Rent Agreement/history_tab.dart';
import '../../Tenant_Details_Demand/MainPage_Tenantdemand_Portal.dart';
import '../../Upcoming/Parent_Upcoming.dart';
import '../../Z-Screen/Social_Media_links.dart';
import '../../Z-Screen/profile.dart';
import '../../ui_decoration_tools/app_images.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../AdminInsurance/AdminInsuranceListScreen.dart';
import '../Admin_future _property/Administater_Future_Property.dart';
import '../Admin_future _property/Administater_Future_Tabbar.dart';
import '../Admin_upcoming.dart';
import '../All_Rented_Flat/Administator_Add_Rented_Flat_Tabbar.dart';
import 'SubAdmin_MainRealEstate_Tabbar.dart';
import 'SubAdmin_tabbar.dart';

class SubAdminHomeScreen extends StatefulWidget {
  static const route = "/SubAdminHomeScreen";

  const SubAdminHomeScreen({super.key});

  @override
  State<SubAdminHomeScreen> createState() => _AdministratorHome_ScreenState();
}

class _AdministratorHome_ScreenState extends State<SubAdminHomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int pendingCount = 0;
  int BookCount = 0;
  String? userName;
  String? userNumber;
  int? _todayAgreements;
  int? _todayWebsiteVisits;

  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
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

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    AppLogger.api("User Name: $storedName");
    AppLogger.api("User Number: $storedNumber");
    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
      });
    }
  }

  final List<LinearGradient> cardGradients = [
    LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)]),
    LinearGradient(colors: [Color(0xFF10B981), Color(0xFF047857)]),
    LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFDC2626)]),
    LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)]),
    LinearGradient(colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
    LinearGradient(colors: [Color(0xFF06B6D4), Color(0xFF0891B2)]),
    LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF4F46E5)]),
    LinearGradient(colors: [Color(0xFF1D4ED8), Color(0xFFDC2626)]),
    LinearGradient(colors: [Color(0xFFDC2626), Color(0xFF06B6D4)]),
    LinearGradient(colors: [Colors.blue, Colors.purple]),
    LinearGradient(colors: [Colors.blueAccent, Colors.blue]),
  ];

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
          // cards & add new one"): replaces BOTH the old plain black
          // `AppBar` (profile icon, web-link button -- the theme toggle
          // here was already commented out/disabled before this pass)
          // AND the separate greeting banner added in the previous pass
          // with ONE combined, collapsing gradient `SliverAppBar`,
          // mirroring `Administrator_HomeScreen.dart`'s own identical
          // rebuild in the same pass.
          _buildTopHeader(context, isDarkMode),
          SliverToBoxAdapter(
            child: Column(
          children: [
            AnimationLimiter(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) =>
                      SlideAnimation(
                        verticalOffset: 50.0,
                        child: AnimationLimiter(child: widget),
                      ),
                  children: [
                    const SizedBox(height: 20),
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
                                            context) => const SubAdminRealEstateTabbar (),
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
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
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
                    // the current admin home screen's target & task card
                    // & update the below calender UI & navigation to
                    // same as fieldworkers target & task card ... also
                    // applied it for sub admin"): the separate
                    // `_taskAndTargetCard` this screen used to show
                    // above the grid is gone -- `_todayCard` below is
                    // now itself titled/styled as the "Tasks & Targets"
                    // card (see that method's doc comment) and is the
                    // only entry point into `AdminTargetAndTasksHome`.
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: _todayCard(isDarkMode),
                    ),
                    const SizedBox(height: 10),
                    // Grid of Feature Cards
                    // ================= MAIN FEATURES =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final crossAxisCount =
                          MediaQuery.of(context).size.width > 600 ? 3 : 2;

                          final itemWidth =
                              (constraints.maxWidth - ((crossAxisCount - 1) * 16)) /
                                  crossAxisCount;

                          final childAspectRatio = itemWidth / (itemWidth * 1.1);

                          final mainItems = [
                            {
                              "image": AppImages.agreement,
                              "title": "Property \nAgreement",
                              "onTap": () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AdminDashboard())),
                              "count": pendingCount,
                            },
                            {
                              "image": AppImages.propertysale,
                              "title": "Future\nInventory/Property",
                              "onTap": () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => AdministaterPropertyTabPage())),
                              "count": 0,
                            },
                            {
                              "image": AppImages.demand_2,
                              "title": "Customer Demands",
                              "onTap": () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => SubadminTabbar())),
                              "count": 0,
                            },
                            {
                              "image": AppImages.realestatefeild,
                              "title": "Upcoming\nProperty",
                              "onTap": () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AdminUpcoming())),
                              "count": 0,
                            },
                            if (userNumber == "9711779003" || userNumber=="9315016461")

                              {
                                "image": AppImages.tenant,
                                "title": "Tenant Demands",
                                "onTap": () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MainPage_TenandDemand()));
                                },
                                "count": 0,
                              },
                            if (userNumber == "9711779003" || userNumber=="9315016461")

                              {
                                'image': AppImages.police,
                                'title': "All Rented \nFlat",
                                'onTap': () =>
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => const AdministatorAddRentedFlatTabbar())),
                                "count": BookCount,
                              },
                            if (userNumber == "9711779003" || userNumber == "9315016461")
                              {
                                "image": AppImages.compliant,
                                "title": "Insurance",
                                "onTap": () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const AdminInsuranceListScreen()),
                                ),
                                "count": 0,
                              },
                          ];

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: mainItems.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemBuilder: (context, index) {
                              final item = mainItems[index];
                              return _buildFeatureCard(
                                context: context,
                                imagePath: item['image'] as String,
                                title: item['title'] as String,
                                onTap: item['onTap'] as VoidCallback,
                                count: item['count'] as int,
                                shineAnimation: _shineAnimation,
                                itemWidth: itemWidth,
                                gradient: cardGradients[index % cardGradients.length],

                              );
                            },
                          );
                        },
                      ),
                    ),
                    if (userNumber == "9711779003" || userNumber == "9315016461") ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "Field Work",
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final crossAxisCount =
                            MediaQuery.of(context).size.width > 600 ? 3 : 2;

                            final itemWidth =
                                (constraints.maxWidth - ((crossAxisCount - 1) * 16)) /
                                    crossAxisCount;

                            final childAspectRatio = itemWidth / (itemWidth * 1.1);

                            final fieldItems = [

                              {
                                "image": AppImages.verify_Property,
                                "title": "Live Property (Field)",
                                "onTap": () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const LiveTabbar())),
                              },
                              {
                                "image": AppImages.futureProperty,
                                "title": "Future Property (Field)",
                                "onTap": () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const FuturePropertyTabPage())),
                              },
                              {
                                "image": AppImages.realestatefeild,
                                "title": "Upcoming Flats (Field)",
                                "onTap": () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const ParentUpcoming())),
                              },
                              {
                                "image": AppImages.agreement,
                                "title": "Property Agreement (Field)",
                                "onTap": () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => const HistoryTab())),
                              },
                              {
                                "image": AppImages.demand_2,
                                "title": "Customer Demands (Field)",
                                "onTap": () => Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (_) => Tabbar())),
                                "count": 0,
                              },
                            ];

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: fieldItems.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: childAspectRatio,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemBuilder: (context, index) {
                                final item = fieldItems[index];
                                return _buildFeatureCard(
                                  context: context,
                                  imagePath: item['image'] as String,
                                  title: item['title'] as String,
                                  onTap: item['onTap'] as VoidCallback,

                                  shineAnimation: _shineAnimation,
                                  itemWidth: itemWidth,
                                  gradient: cardGradients[index % cardGradients.length],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
          ),
      ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required VoidCallback onTap,
    required Animation<double> shineAnimation,
    required double itemWidth,
    required LinearGradient gradient,
    int? count,
  }) {
    final imageSize = itemWidth * 0.30;
    final fontSize = itemWidth * 0.07;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          // boxShadow: [
          //   BoxShadow(
          //     color: gradient.colors.first.withOpacity(0.35),
          //     blurRadius: 18,
          //     offset: const Offset(0, 8),
          //   )
          // ],
        ),
        child: Stack(
          children: [

            /// background circle decoration
            Positioned(
              right: -20,
              bottom: -20,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  /// COUNT BADGE
                  Align(
                    alignment: Alignment.topRight,
                    child: (count != null && count > 0)
                        ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        count.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : const SizedBox(height: 10),
                  ),

                  /// ICON
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.20),
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      imagePath,
                      height: imageSize,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// TITLE
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: fontSize.clamp(12, 16),
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontFamily: "PoppinsMedium",
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Small helper used by `_buildTopHeader` below -- mirrors
  /// `Administrator_HomeScreen.dart`'s identically-named helper, added in
  /// the same pass.
  String _greetingText() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  /// Rebuilt 2026-09-21 per explicit follow-up ("remove the admin &
  /// sub-admin's home screen's appbar & header & target task cards &
  /// add new one"): ONE collapsing gradient `SliverAppBar`, mirroring
  /// `Administrator_HomeScreen.dart`'s own identical rebuild in the same
  /// pass, replacing BOTH the old plain black `AppBar` (profile icon,
  /// web-link button -- the theme toggle was already commented out
  /// before this pass, so it is NOT re-added here) AND the separate
  /// greeting banner from the previous pass.
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
                          MaterialPageRoute(builder: (context) => ProfilePage()),
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
                      IconButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => LinksPage()),
                        ),
                        icon: const Text('🌐', style: TextStyle(fontSize: 20)),
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

  /// Sub-admin's "Tasks & Targets" card -- previously a small grid tile
  /// ("Task Calendar" in `mainItems`) navigating to
  /// `CalendarTaskPageForAdmin`. Rebuilt 2026-09-22 per explicit request
  /// ("remove the current admin home screen's target & task card &
  /// update the below calender UI & navigation to same as fieldworkers
  /// target & task card ... also applied it for sub admin"): this is now
  /// a full-width card with the same cyan/purple "Tasks & Targets"
  /// accent-bar header + date/today's-counts layout as
  /// `Administrator_HomeScreen.dart`'s own `_todayCard` (itself matching
  /// the field worker's `_tasksAndTargetsCard` in `Home_Screen.dart`),
  /// and it navigates to `AdminTargetAndTasksHome` instead of the old
  /// calendar screen. The old "Task Calendar" grid tile is removed from
  /// `mainItems` below, and the separate `_taskAndTargetCard` this
  /// screen used to show above the grid is gone -- this card is now the
  /// ONLY "Tasks & Targets" entry point. No "Tomorrow's events" preview
  /// (same explicit decision as the admin screen -- no existing
  /// sub-admin-wide API for it, and guessing one risks showing wrong
  /// data).
  Widget _todayCard(bool isDark) {
    final today = DateTime.now();

    final monthNames = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];

    final weekNames = [
      "MON","TUE","WED","THU","FRI","SAT","SUN"
    ];

    final agreements = _todayAgreements ?? 0;
    final websiteVisits = _todayWebsiteVisits ?? 0;
    final totalToday = agreements + websiteVisits;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminTargetAndTasksHome()),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 12),
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

            /// -------- "TASKS & TARGETS" HEADER --------
            /// Same accent-bar + title treatment as the field worker's
            /// own `_tasksAndTargetsCard` in `Home_Screen.dart` and
            /// `Administrator_HomeScreen.dart`'s `_todayCard`.
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

            /// -------- DATE / CLOCK --------
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
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
                      colors: [Colors.white, Colors.blueGrey.shade100],
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
                    border: Border.all(color: Colors.blueGrey.shade200, width: 1.5),
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
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// -------- TODAY'S COUNTS --------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalToday == 0 ? "No Events Today" : "Today's Events",
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
                      fontFamily: "PoppinsMedium",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.greenAccent : Colors.green.shade700,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _modernCountCard("Agreements", agreements, const Color(0xFFEF4444), isDark),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _modernCountCard("Web Visit", websiteVisits, const Color(0xFF10B981), isDark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _modernCountCard(String title, int count, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? color.withOpacity(0.15) : color.withOpacity(0.08),
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

  String _todayString() {
    final t = DateTime.now();
    return "${t.year}-${t.month.toString().padLeft(2, '0')}-${t.day.toString().padLeft(2, '0')}";
  }

  /// Same admin-wide "today" endpoints `Administrator_HomeScreen.dart`
  /// already calls for its own `_todayCard` (agreement + website-visit
  /// counts only -- the "future/building" count it also fetches is never
  /// shown on that card, so it's not duplicated here). Duplicated rather
  /// than shared, matching this project's existing pattern of
  /// per-screen-duplicated data/constants (see `Targets.dart`'s agent
  /// list and `AdminTargetAndTasksHome`'s own doc comment).
  Future<void> fetchTodayData() async {
    final today = _todayString();
    try {
      final agreementUrl =
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Calender/task_agreement_for_admin.php?current_dates=$today";
      final websiteUrl =
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Calender/web_visit_for_admin.php?dates=$today";

      final responses = await Future.wait([
        http.get(Uri.parse(agreementUrl)),
        http.get(Uri.parse(websiteUrl)),
      ]);

      int agreements = 0;
      int website = 0;

      final agreementDecoded = jsonDecode(responses[0].body);
      if (agreementDecoded is Map && agreementDecoded["data"] is List) {
        agreements = (agreementDecoded["data"] as List).length;
      }

      final websiteDecoded = jsonDecode(responses[1].body);
      if (websiteDecoded is Map &&
          websiteDecoded["status"] != "error" &&
          websiteDecoded["data"] is List) {
        website = (websiteDecoded["data"] as List).length;
      }

      if (!mounted) return;
      setState(() {
        _todayAgreements = agreements;
        _todayWebsiteVisits = website;
      });
    } catch (e) {
      AppLogger.api("ERROR IN SUB-ADMIN fetchTodayData: $e");
    }
  }
}