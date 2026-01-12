import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Administrator/Admin_upcoming.dart';
import 'package:verify_feild_worker/Login_page.dart';
import '../Calender/CalenderForAdmin.dart';
import '../Dashboard/AllFieldWorkers.dart';
import '../Dashboard/Dashoard.dart';
import '../Social_Media_links.dart';
import '../Web_query/web_query.dart' hide SlideAnimation;
import '../administrator/Administator_Realestate.dart';
import '../main.dart';
import '../ui_decoration_tools/app_images.dart';
import 'AdminRealEstateTabbar.dart';
import 'Admin_future _property/Administater_Future_Property.dart';
import 'Admin_profile.dart';
import 'Administater_Parent_TenantDemand.dart';
import 'All_Rented_Flat/Administator_Add_Rented_Flat_Tabbar.dart';
import 'Administator_Agreement/Admin_dashboard.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'New_TenandDemand/Tenant_demand.dart';

class AdministratorHome_Screen extends StatefulWidget {
  static const route = "/AdministratorHome_Screen";
  const AdministratorHome_Screen({super.key});

  @override
  State<AdministratorHome_Screen> createState() => _AdministratorHome_ScreenState();
}

class _AdministratorHome_ScreenState extends State<AdministratorHome_Screen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    // Future.microtask(() => hitAgreementRenewalAPI());
    loadUserName();
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

  Future<void> hitAgreementRenewalAPI() async {

    const String url = "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreement_renewal_cron.php";

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

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    final storedFAadharCard = prefs.getString('post');
    // debugPrint("User Name: $storedName");
    // debugPrint("User Number: $storedNumber");
    // debugPrint("User FAadharCard: $storedFAadharCard");
    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
        userStoredFAadharCard = storedFAadharCard;
      });
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
                const Text('Web',style: TextStyle(color: Colors.white),),
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
                        itemCount: 9,
                        itemBuilder: (context, index) {
                          final List<Map<String, dynamic>> featureItems = [
                            {
                              "image": AppImages.agreement,
                              "title": "Property \nAgreement",
                              "onTap": () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AdminDashboard(),
                                  ),
                                );
                              },
                            },
                            {
                              "image": AppImages.dashboard,
                              "title": "Dashboard",
                              "onTap": () async {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  DashboardScreen(),
                                  ),
                                );
                              },
                            },

                            {
                              'image': AppImages.propertysale,
                              'title': "Future\n Inventory/Property",
                              'onTap': () {
                                // Pass the buildingId you want to highlight
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ADministaterShow_FutureProperty(),
                                  ),
                                );
                              },
                            },
                            {
                              'image': AppImages.tenant,
                              'title': "Costumer Demands",
                              'onTap': () =>
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (
                                          context) => const Administater_parent_TenandDemand())),
                            },
                            {
                              "image": AppImages.police,
                              "title": "All Rented Flat",
                              "onTap": () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const AdministatorAddRentedFlatTabbar()));
                              },
                            },
                            {
                              "image": AppImages.websiteIssue,
                              "title": "Web \nQuery",
                              "onTap": () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const WebQueryPage()));
                              },
                            },

                            {
                              "image": AppImages.realestatefeild,
                              "title": "Upcoming\n Property",
                              "onTap": () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const AdminUpcoming()));
                              },
                            },
                            {
                              "image": AppImages.calendar,
                              "title": "Task Calendar",
                              "onTap": () {
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (_) => const CalendarTaskPageForAdmin()));
                              },
                           },
                            {
                              'image': AppImages.demand_2,
                              'title': "Costumer Demands 2.O",
                              'onTap': () =>
                                  Navigator.push(context, MaterialPageRoute(
                                      builder: (
                                          context) => const TenantDemand())),
                            },
                          ];

                          final item = featureItems[index];

                          return _buildFeatureCard(
                            context: context,
                            imagePath: item['image'],
                            title: item['title'],
                            onTap: item['onTap'],
                            shineAnimation: _shineAnimation,
                            itemWidth: itemWidth,
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
          MaterialPageRoute(builder: (_) => AllFieldWorkersPage()),
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
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Tap to view progress",
                    style: TextStyle(
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
    required Animation<double> shineAnimation,
    required double itemWidth,
  }) {
    final isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final primaryColor = Theme
        .of(context)
        .primaryColor;

    // Calculate sizes based on item width
    final imageSize = itemWidth * 0.35;
    final fontSize = itemWidth * 0.07;
    final padding = itemWidth * 0.08;

    return AnimatedBuilder(
      animation: shineAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.transparent,
                primaryColor.withOpacity(0.05 * shineAnimation.value),
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(-1.0 + (2.0 * shineAnimation.value), -1.0),
              end: Alignment(1.0 - (2.0 * shineAnimation.value), 1.0),
            ),
          ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: primaryColor.withOpacity(0.1 * shineAnimation.value),
                width: 1,
              ),
            ),
            color: isDarkMode ? Colors.white10 : Colors.white,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: imageSize,
                      width: imageSize,
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
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize.clamp(12, 16),
                          // Minimum 12, maximum 16
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    CircleAvatar(
                      radius: imageSize * 0.25,
                      backgroundColor: isDarkMode ? Colors.white10 : Colors.grey
                          .shade100,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        size: imageSize * 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}