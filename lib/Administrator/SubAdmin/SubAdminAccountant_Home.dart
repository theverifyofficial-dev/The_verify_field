import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Login_page.dart';
import '../../Accountant/Company expense/Tabbar_control.dart';
import '../../Accountant/Salaray expense/Tabbar_control.dart';
import '../../Administrator/Administater_Parent_TenantDemand.dart';
import '../../Administrator/Administator_Add_Rented_Flat_Tabbar.dart';
import '../../Administrator/Administator_Agreement/Admin_dashboard.dart';
import '../../Administrator/Administator_Realestate.dart';
import '../../Administrator/New_TenandDemand/Tenant_demand.dart';
import '../../Dashboard/AllFieldWorkers.dart';
import '../../Future_Property_OwnerDetails_section/Future_Property.dart';
import '../../Social_Media_links.dart';
import '../../Statistics/Target_MainPage.dart';
import '../../main.dart';
import '../../profile.dart';
import '../../ui_decoration_tools/app_images.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../Admin_future _property/Administater_Future_Property.dart';
import '../Admin_upcoming.dart';
import 'ShowTenantDemant.dart';
import 'SubAdmin_MainRealEstate_Tabbar.dart';

class SubAdminHomeScreen extends StatefulWidget {
  static const route = "/SubAdminHomeScreen";

  const SubAdminHomeScreen({super.key});

  @override
  State<SubAdminHomeScreen> createState() => _AdministratorHome_ScreenState();
}

class _AdministratorHome_ScreenState extends State<SubAdminHomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  String? userName;
  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
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

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('number');
                Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Login_page()),
                );
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://theverify.in/');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');

    if (mounted) {
      setState(() {
        userName = storedName;
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
                  MaterialPageRoute(builder: (context) => ProfilePage()),
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
                          fontSize: 10, // Reduced font size
                          fontWeight: FontWeight.bold,
                          height: 1.2, // Line height adjustment
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
          // IconButton(
          //   icon: Icon(
          //       ThemeSwitcher.of(context)?.themeMode == ThemeMode.dark
          //           ? Icons.light_mode
          //           : Icons.dark_mode,
          //       color: Colors.yellow
          //
          //   ),
          //   onPressed: () {
          //     ThemeSwitcher.of(context)?.toggleTheme();
          //   },
          // ),
         //SizedBox(width: 5,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LinksPage()),
              );
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('🌐'),
                Text('Web',
                    style:
                    TextStyle(
                        color: Colors.white,
                        fontSize: 12)),
              ],
            ),
          ),
          //const SizedBox(width: 12),
          const SizedBox(
            width: 10,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
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
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    //   child: _TargetHeaderCard(context),
                    // ),
                    const SizedBox(height: 10),

                    // Grid of Feature Cards
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

                          final crossAxisCount = screenWidth > 800 ? 4 :
                          screenWidth > 600 ? 3 : 2;

                          final availableWidth = constraints.maxWidth;
                          final itemWidth = (availableWidth -
                              ((crossAxisCount - 1) * 16)) / crossAxisCount;
                          final childAspectRatio = itemWidth /
                              (itemWidth * 1.1);

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              childAspectRatio: childAspectRatio,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: 3,
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
                                // {
                                //   'image': AppImages.tenant,
                                //   'title': "Tenant Demands",
                                //   'onTap': () =>
                                //       Navigator.push(context, MaterialPageRoute(
                                //           builder: (
                                //               context) => const Administater_parent_TenandDemand())),
                                // },
                                // {
                                //   'image': AppImages.police,
                                //   'title': "All Rented \nFlat",
                                //   'onTap': () =>
                                //       Navigator.push(context, MaterialPageRoute(
                                //           builder: (context) => const AdministatorAddRentedFlatTabbar())),
                                // },
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
                                  'image': AppImages.demand_2,
                                  'title': "Costumer Demands 2.O",
                                  'onTap': () =>
                                      Navigator.push(context, MaterialPageRoute(
                                          builder: (
                                              context) =>  ShowTenantDemandPage())),
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

                  ],
                ),
              ),
              // Column(
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 16),
              //       child: AnimatedBuilder(
              //         animation: _shineAnimation,
              //         builder: (context, child) {
              //           return Container(
              //             decoration: BoxDecoration(
              //               borderRadius: BorderRadius.circular(16),
              //               gradient: LinearGradient(
              //                 colors: [
              //                   const Color(0xFF00C6FF),
              //                   primaryColor.withOpacity(0.25 + 0.4 * _shineAnimation.value),
              //                   const Color(0xFF0072FF),
              //                 ],
              //                 stops: const [0.0, 0.5, 1.0],
              //                 begin: Alignment(
              //                     -1.0 + (2.0 * _shineAnimation.value), -1.0),
              //                 end: Alignment(
              //                     1.0 - (2.0 * _shineAnimation.value), 1.0),
              //               ),
              //             ),
              //             child: Card(
              //               color: isDarkMode ? Colors.white10 : Colors.white,
              //               shape: RoundedRectangleBorder(
              //                 borderRadius: BorderRadius.circular(16),
              //                 side: BorderSide(
              //                   color: primaryColor.withOpacity(
              //                       0.3 * _shineAnimation.value),
              //                   width: 1.5,
              //                 ),
              //               ),
              //               elevation: 6,
              //               shadowColor: primaryColor.withOpacity(0.2),
              //               child: InkWell(
              //                 // onTap: () =>
              //                 //     Navigator.push(
              //                 //       context,
              //                 //       MaterialPageRoute(
              //                 //         builder: (
              //                 //             context) =>
              //                 //         const ADministaterShow_realestete(),
              //                 //       ),
              //                 //     ),
              //                 borderRadius: BorderRadius.circular(16),
              //                 child: Padding(
              //                   padding: const EdgeInsets.all(16.0),
              //                   child: Row(
              //                     crossAxisAlignment: CrossAxisAlignment.center,
              //                     children: [
              //                       Container(
              //                         height: 50,
              //                         width: 50,
              //                         decoration: BoxDecoration(
              //                           borderRadius: BorderRadius.circular(12),
              //                           boxShadow: [
              //                             BoxShadow(
              //                               color: Colors.black.withOpacity(0.1),
              //                               blurRadius: 8,
              //                               offset: const Offset(2, 4),
              //                             ),
              //                           ],
              //                         ),
              //                         child: ClipRRect(
              //                           borderRadius: BorderRadius.circular(12),
              //                           child: Image.asset(
              //                             AppImages.dividend,
              //                             fit: BoxFit.cover,
              //                           ),
              //                         ),
              //                       ),
              //                       const SizedBox(width: 16),
              //                       Expanded(
              //                         child: Text(
              //                           "Manage Accounts",
              //                           style: Theme
              //                               .of(context)
              //                               .textTheme
              //                               .titleLarge
              //                               ?.copyWith(
              //                             color: isDarkMode
              //                                 ? Colors.white
              //                                 : Colors.grey.shade700,
              //                             fontWeight: FontWeight.w700,
              //                             fontFamily: "PoppinsBold",
              //                           ),
              //                         ),
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           );
              //         },
              //       ),
              //
              //     ),
              //     const SizedBox(height: 10),
              //     Padding(
              //       padding: const EdgeInsets.symmetric(horizontal: 16),
              //       child: LayoutBuilder(
              //         builder: (context, constraints) {
              //           final screenWidth = MediaQuery
              //               .of(context)
              //               .size
              //               .width;
              //           final screenHeight = MediaQuery
              //               .of(context)
              //               .size
              //               .height;
              //
              //           // Dynamic grid calculation
              //           final crossAxisCount = screenWidth > 800 ? 4 :
              //           screenWidth > 600 ? 3 : 2;
              //
              //           // Calculate item width based on available space
              //           final availableWidth = constraints.maxWidth;
              //           final itemWidth = (availableWidth -
              //               ((crossAxisCount - 1) * 16)) / crossAxisCount;
              //           final childAspectRatio = itemWidth /
              //               (itemWidth * 1.1); // Height is 10% more than width
              //
              //           return GridView.builder(
              //             shrinkWrap: true,
              //             physics: const NeverScrollableScrollPhysics(),
              //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //               crossAxisCount: crossAxisCount,
              //               childAspectRatio: childAspectRatio,
              //               crossAxisSpacing: 16,
              //               mainAxisSpacing: 16,
              //             ),
              //             itemCount: 2,
              //             itemBuilder: (context, index) {
              //               final List<Map<String, dynamic>> featureItems = [
              //                 {
              //                   "image": AppImages.agreement,
              //                   "title": "Company \nExpenses",
              //                   "onTap": () async {
              //                     Navigator.push(
              //                       context,
              //                       MaterialPageRoute(
              //                         builder: (_) => const TabbarControl(),
              //                       ),
              //                     );
              //                   },
              //                 },
              //                 {
              //                   'image': AppImages.pay,
              //                   'title': "Salary \nExpenses",
              //                   'onTap': () {
              //                     Navigator.push(context, MaterialPageRoute(
              //                         builder: (
              //                             context) => const Salary_TabbarControl()));
              //                   }
              //                 },
              //               ];
              //
              //               final item = featureItems[index];
              //
              //               return _buildFeatureCard(
              //                 context: context,
              //                 imagePath: item['image'],
              //                 title: item['title'],
              //                 onTap: item['onTap'],
              //                 shineAnimation: _shineAnimation,
              //                 itemWidth: itemWidth,
              //               );
              //             },
              //           );
              //         },
              //       ),
              //     ),
              //     const SizedBox(height: 40),
              //   ],
              // ),

            ],
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

}