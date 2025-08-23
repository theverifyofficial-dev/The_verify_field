import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Administrator/agreement_details.dart';
import 'package:verify_feild_worker/Home_Screen_click/Real-Estate.dart';
import 'package:verify_feild_worker/Login_page.dart';
import '../Future_Property_OwnerDetails_section/Future_Property.dart';
import '../Statistics/Target_MainPage.dart';
import '../Tenant_Details_Demand/Parent_class_TenantDemand.dart';
import '../main.dart';
import '../ui_decoration_tools/constant.dart';
import '../profile.dart';
import 'Administater_Future_Property.dart';
import 'Administater_Parent_TenantDemand.dart';
import 'Administater_TenanDemand.dart';
import 'Administator_Realestate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class AdministratorHome_Screen extends StatefulWidget {
  static const route = "/AdministratorHome_Screen";
  const AdministratorHome_Screen({super.key});

  @override
  State<AdministratorHome_Screen> createState() => _AdministratorHome_ScreenState();
}

class _AdministratorHome_ScreenState extends State<AdministratorHome_Screen> with TickerProviderStateMixin {
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
    )..repeat();
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

  _AgreementURL() async {
    final Uri url = Uri.parse('https://theverify.in/example.html');
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor:  Colors.black,
        title: Image.asset(AppImages.verify, height: 70),
        leading: Container(
          margin: const EdgeInsets.only(left: 8), // Add some margin if needed
          child: InkWell(
            borderRadius: BorderRadius.circular(20), // For better tap effect
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ProfilePage()),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min, // Important for proper centering
                children: [
                  Icon(
                    PhosphorIcons.user_circle,
                    color: Colors.white,
                    size: 28, // Slightly reduced for better proportion
                  ),
                  if (userName != null && userName!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 2), // Small top padding
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
        leadingWidth: 80, // Fixed width for consistent spacing
        actions: [
          IconButton(
            icon: Icon(
              ThemeSwitcher.of(context)?.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
              color: Colors.yellow,
              size: 26, // Consistent icon size
            ),
            onPressed: () => ThemeSwitcher.of(context)?.toggleTheme(),
            padding: EdgeInsets.zero, // Remove default padding
            constraints: const BoxConstraints(), // Remove default constraints
          ),
          IconButton(
            icon: const Icon(
              PhosphorIcons.share,
              color: Colors.white,
              size: 26, // Consistent icon size
            ),
            onPressed: _launchURL,
            padding: EdgeInsets.zero, // Remove default padding
            constraints: const BoxConstraints(), // Remove default constraints
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: AnimationLimiter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: AnimationConfiguration.toStaggeredList(
              duration: const Duration(milliseconds: 500),
              childAnimationBuilder: (widget) => SlideAnimation(
                verticalOffset: 50.0,
                child: AnimationLimiter(child: widget),
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
                              Color(0xfFF31D8FF),
                              primaryColor.withOpacity(0.1 * _shineAnimation.value),
                              Color(0xFFFD0098)

                            ],
                            stops: const [0.0, 0.5, 1.0],
                            begin: Alignment(-1.0 + (2.0 * _shineAnimation.value), -1.0),
                            end: Alignment(1.0 - (2.0 * _shineAnimation.value), 1.0),
                          ),
                        ),
                        child: Card(
                          color: isDarkMode ? Colors.white10 : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                            side: BorderSide(
                              color: primaryColor.withOpacity(0.3 * _shineAnimation.value),
                              width: 1.5,
                            ),
                          ),
                          elevation: 6,
                          shadowColor: primaryColor.withOpacity(0.2),
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ADministaterShow_realestete(),
                              ),
                            ),
                            borderRadius: BorderRadius.circular(16),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Container(
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
                                          color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade700,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "PoppinsBold"
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade700,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 30),

                // Grid of Feature Cards
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildFeatureCard(
                        context: context,
                        imagePath: AppImages.agreement,
                        title: "Rent Agreement",
                        onTap: _AgreementURL,
                        shineAnimation: _shineAnimation,
                      ),
                      _buildFeatureCard(
                        context: context,
                        imagePath: AppImages.agreement_details,
                        title: "Agreement Details",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AgreementDetails()),
                        ),
                        shineAnimation: _shineAnimation,
                      ),
                      _buildFeatureCard(
                        context: context,
                        imagePath: AppImages.propertysale,
                        title: "Future Property",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ADministaterShow_FutureProperty()),
                        ),
                        shineAnimation: _shineAnimation,
                      ),
                      _buildFeatureCard(
                        context: context,
                        imagePath: AppImages.tenant,
                        title: "Tenant Demands",
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Administater_parent_TenandDemand(),
                          ),
                        ),
                        shineAnimation: _shineAnimation,
                      ),
                    ],
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

  Widget _buildFeatureCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required VoidCallback onTap,
    required Animation<double> shineAnimation,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

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
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
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
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8),
                    CircleAvatar(
                      backgroundColor: isDarkMode ? Colors.white10 : Colors.grey.shade100,
                      child: Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        size: 16,
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