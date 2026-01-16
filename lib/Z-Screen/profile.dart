import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Login_page.dart';
import '../model/Profile_model.dart';
import '../main.dart'; // Import to access ThemeSwitcher

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserProfile? _user;
  bool _isLoading = true;

  Future<String?> getUserNumber() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('number');
  }

  Future<void> fetchUserProfile() async {
    final number = await getUserNumber();

    if (number == null || number.isEmpty) {
      _logout(context);
      return;
    }

    final url = 'https://verifyserve.social/WebService3_ServiceWork.asmx/account_FeildWorkers_Register?num=$number';

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

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Login_page()),
          (Route<dynamic> route) => false,
    );
  }

  Future<void> _checkLoginAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('number');

    if (number == null || number.isEmpty) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Login_page()),
        );
      }
      return;
    }

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeSwitcher = ThemeSwitcher.of(context);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: "PoppinsBold",
            color: isDark ? Colors.white : const Color(0xFF1A1A1A),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.amber))
          : _user == null
          ? const Center(child: Text("No user found", style: TextStyle(color: Colors.grey)))
          : SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Premium Profile Picture with Gradient Border
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.white.withOpacity(0.1), Colors.amber.withOpacity(0.2)]
                      : [Colors.amber.withOpacity(0.2), Colors.white.withOpacity(0.1)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: const AssetImage('assets/images/profile 2.png'),
                backgroundColor: isDark ? Colors.grey[900] : Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            // Premium Name with Shadow
            Text(
              _user!.name,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontFamily: "PoppinsBold",
                color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                shadows: [
                  Shadow(
                    color: isDark ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Premium Personal Info Section with Gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.grey[900]!, Colors.grey[800]!]
                      : [Colors.white, const Color(0xFFF8F9FA)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Personal info",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white70 : const Color(0xFF6B7280),
                        ),
                      ),
                      Text(
                        "Edit",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF3B82F6),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem(Icons.person, "Name", _user!.name),
                  _buildInfoItem(Icons.email, "E-mail", _user!.email.isNotEmpty ? _user!.email : "Not provided"),
                  _buildInfoItem(Icons.phone, "Phone number", _user!.number),
                  _buildInfoItem(Icons.account_box_rounded, "Account Holder", _user!.aadhar),
                  _buildInfoItem(Icons.business, "Office address", _user!.location),
                  _buildInfoItem(Icons.vertical_align_bottom, "App Version", "3.0"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Integrated Premium Theme Toggle (without label and box)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildIntegratedThemeToggle(context, isDark, themeSwitcher),
            ),
            const SizedBox(height: 20),
            // Premium Logout Button with Gradient
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Logout",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: "PoppinsBold",
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildIntegratedThemeToggle(BuildContext context, bool isDark, ThemeSwitcher? themeSwitcher) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tabWidth = (constraints.maxWidth - 0) / 2; // Adjusted for tighter padding
        return Stack(
          children: [
            // Background Container
            Container(
              height: 44,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isDark ? Colors.grey[700]! : Colors.grey[300]!),
              ),
            ),
            // Sliding Indicator
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              left: isDark ? tabWidth : 0,
              top: 2,
              bottom: 2,
              child: Container(
                width: tabWidth,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3B82F6).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
              ),
            ),
            // Tabs
            Row(
              children: [
                InkWell(
                  onTap: () {
                    if (isDark && themeSwitcher != null) themeSwitcher.toggleTheme();
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    width: tabWidth,
                    height: 40,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.light_mode, size: 16, color: !isDark ? Colors.white : (isDark ? const Color(0xFF9CA3AF) : Colors.grey[600])),
                        const SizedBox(width: 4),
                        Text(
                          "Light",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: !isDark ? Colors.white : (isDark ? const Color(0xFF9CA3AF) : Colors.grey[600]),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (!isDark && themeSwitcher != null) themeSwitcher.toggleTheme();
                  },
                  borderRadius: BorderRadius.circular(20),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    width: tabWidth,
                    height: 40,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.dark_mode, size: 16, color: isDark ? Colors.white : (isDark ? Colors.grey[600] : const Color(0xFF9CA3AF))),
                        const SizedBox(width: 4),
                        Text(
                          "Dark",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : (isDark ? Colors.grey[600] : const Color(0xFF9CA3AF)),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF6B7280), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? Colors.grey[400] : const Color(0xFF6B7280),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : const Color(0xFF1A1A1A),
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
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
}