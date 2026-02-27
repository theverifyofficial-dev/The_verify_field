import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/Account_registeration.dart';

import '../Z-Screen/Login_page.dart';
import '../model/Profile_model.dart';

class AdminProfile extends StatefulWidget {
  const AdminProfile({super.key});

  @override
  State<AdminProfile> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<AdminProfile> {
  UserProfile? _user;
  bool _isLoading = true;

  Future<String?> getUserNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('number');
  }

  Future<void> fetchUserProfile() async {
    String? number = await getUserNumber();

    // If still no number, logout for safety
    if (number == null || number.isEmpty) {
      _logout(context);
      return;
    }

    final String url = 'https://verifyserve.social/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=$number';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        if (jsonData.isNotEmpty) {
          final user = UserProfile.fromJson(jsonData[0]);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user', user.name);

          if (mounted) {
            setState(() {
              _user = user;
              _isLoading = false;
            });
          }
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Call this when logging out
  void _logout(BuildContext context) async {
    // Clear any saved login/session data
    final prefs = await SharedPreferences.getInstance();
    print("🚪 Logging out...");
    print("Before clear → number: ${prefs.getString('number')}, name: ${prefs.getString('name')}");

    await prefs.clear();

    print("After clear → number: ${prefs.getString('number')}, name: ${prefs.getString('name')}");

    // 🔥 Reset all GetX controllers (important!)
    Get.reset();

    // Navigate to the login page and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login_page()),
          (Route<dynamic> route) => false, // remove all previous routes
    );
  }



  Future<void> _checkLoginAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('number');

    if (number == null || number.isEmpty) {
      // No user logged in → redirect to login
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login_page()),
        );
      }
      return;
    }

    // Reset UI state before fetching
    setState(() {
      _user = null;
      _isLoading = true;
    });

    await fetchUserProfile();
  }

  @override
  void initState() {
    super.initState();
    _checkLoginAndFetch();
  }

  Future<void> _logoutFromAllDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? number = prefs.getString("number");

    if (number == null || number.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/logout_device.php",
        ),
        body: {
          "FNumber": number,
        },
      );

      if (response.statusCode == 200) {
        print("Logout All Response: ${response.body}");

        await prefs.clear();

        // 🔥 Important
        Get.reset();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const Login_page()),
              (route) => false,
        );
      } else {
        print("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("Logout All Devices Error: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : const Color(0xFFF2F2F7),
      appBar: AppBar(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        elevation: 1,
        centerTitle: true,
        title: Text(
          "Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            fontFamily: "PoppinsBold",
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _user == null
          ? const Center(child: Text("No user found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Avatar
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.white10 : Colors.black12,
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.deepPurple, Colors.purpleAccent]
                      : [Colors.amberAccent, Colors.orangeAccent],
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Image.asset(
                  'assets/images/profile 2.png',
                  fit: BoxFit.cover,
                  height: 80,
                ),
              ),
            ),

            const SizedBox(height: 14),

            Text(
              _user!.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontFamily: "PoppinsBold",
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              _user!.location,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.grey[400] : Colors.grey[700],
              ),
            ),

            const SizedBox(height: 30),

            // Profile Details
            profileCard(theme, isDark),

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 48, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed:  () {
                // Navigate to SignUp page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AccountRegisteration()),
                );
              },
              icon: const Icon(Icons.people_alt_outlined),
              label: const Text("Add Account"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget buildProfileItem({
    required IconData icon,
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: theme.colorScheme.primary, size: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface.withOpacity(0.85),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15.5,

                  color: theme.brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }


  Widget profileCard(ThemeData theme, bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
          colors: [
            Color(0x6F1F1F1F),
            Color(0xFF1F1F1F),
            Color(0x7F2C2C2C)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(
          colors: [Color(0xFFF9F9F9),
            Color(0xFFEAEAEA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black54 : Colors.grey.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoTile(Icons.phone, "Phone Number", _user!.number),
          _divider(),
          _infoTile(Icons.email, "Email", _user!.email.isNotEmpty ? _user!.email : "Not provided"),
          _divider(),
          _infoTile(Icons.credit_card, "Account Holder", _user!.aadhar),
          _divider(),
          _infoTile(Icons.location_on, "Location", _user!.location),
          _divider(),
          _infoTile(Icons.vertical_align_bottom, "App Version", "3.0"),

        ],
      ),
    );
  }

  Widget _infoTile(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.amber, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:  TextStyle(
                  fontSize: 13,
                  color:Theme.of(context).brightness==Brightness.dark ?Colors.grey: Colors.grey.shade700,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style:  TextStyle(
                  fontSize: 15,
                  fontFamily: "PoppinsBold",
                  color:Theme.of(context).brightness==Brightness.dark ?Colors.white:Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(color: Colors.grey.shade300, thickness: 1),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.redAccent.withOpacity(0.1), Colors.red.withOpacity(0.05)]),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout, color: Colors.redAccent, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                "Logout",
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: "PoppinsBold",
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Are you sure you want to logout?",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontFamily: "Poppins",
                  color: isDark ? Colors.grey[400] : const Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: isDark ? Colors.grey[400] : const Color(0xFF6B7280),
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Logout",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontFamily: "PoppinsBold",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showLogoutDialog(BuildContext context) {
  //   final theme = Theme.of(context);
  //   final isDark = theme.brightness == Brightness.dark;
  //
  //   showModalBottomSheet(
  //     context: context,
  //     backgroundColor: Colors.transparent,
  //     builder: (_) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: isDark ? const Color(0xFF1C1C1E) : Colors.white,
  //           borderRadius: const BorderRadius.vertical(
  //             top: Radius.circular(28),
  //           ),
  //         ),
  //         padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //
  //             // Drag handle
  //             Container(
  //               height: 5,
  //               width: 45,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey.shade400,
  //                 borderRadius: BorderRadius.circular(10),
  //               ),
  //             ),
  //
  //             const SizedBox(height: 22),
  //
  //             const Icon(
  //               Icons.power_settings_new_rounded,
  //               size: 38,
  //               color: Colors.redAccent,
  //             ),
  //
  //             const SizedBox(height: 14),
  //
  //             Text(
  //               "Sign Out",
  //               style: theme.textTheme.titleLarge?.copyWith(
  //                 fontWeight: FontWeight.w700,
  //               ),
  //             ),
  //
  //             const SizedBox(height: 6),
  //
  //             Text(
  //               "Select how you want to proceed",
  //               style: theme.textTheme.bodyMedium?.copyWith(
  //                 color: isDark ? Colors.grey[400] : Colors.grey[600],
  //               ),
  //             ),
  //
  //             const SizedBox(height: 26),
  //
  //             // 🔹 This Device
  //             _logoutOptionTile(
  //               context,
  //               icon: Icons.phone_android,
  //               title: "Logout This Device",
  //               subtitle: "You’ll stay logged in on other devices",
  //               color: Colors.blueAccent,
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _logout(context);
  //               },
  //             ),
  //
  //             const SizedBox(height: 16),
  //
  //             // 🔴 All Devices
  //             _logoutOptionTile(
  //               context,
  //               icon: Icons.devices_other,
  //               title: "Logout From All Devices",
  //               subtitle: "This will disconnect every active session",
  //               color: Colors.redAccent,
  //               isDanger: true,
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _logoutFromAllDevices();
  //               },
  //             ),
  //
  //             const SizedBox(height: 18),
  //
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("Cancel"),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _logoutOptionTile(
      BuildContext context, {
        required IconData icon,
        required String title,
        required String subtitle,
        required Color color,
        required VoidCallback onTap,
        bool isDanger = false,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isDanger
              ? color.withOpacity(0.08)
              : (isDark ? const Color(0xFF2C2C2E) : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
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
}
