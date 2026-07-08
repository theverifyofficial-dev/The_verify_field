import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../Custom_Widget/constant.dart';
import 'Login_page.dart';

class FieldAgentRegisterScreen extends StatefulWidget {
  const FieldAgentRegisterScreen({super.key});

  @override
  State<FieldAgentRegisterScreen> createState() =>
      _FieldAgentRegisterScreenState();
}

class _FieldAgentRegisterScreenState
    extends State<FieldAgentRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  final String api =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/field_agent_apply.php";

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    passwordController.dispose();
    locationController.dispose();
    super.dispose();
  }

  Future<void> register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(api),
        body: {
          "FName": nameController.text.trim(),
          "FNumber": mobileController.text.trim(),
          "FEmail": emailController.text.trim(),
          "FPassword": passwordController.text.trim(),
          "F_Location": locationController.text.trim(),
        },
      );

      final data = jsonDecode(response.body);

      if (data["status"] == true) {
        if (!mounted) return;

        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              title: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent),
                  SizedBox(width: 10),
                  Text(
                    "Success",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              content: const Text(
                "Your application has been submitted successfully.",
                style: TextStyle(color: Colors.white70),
              ),
              actions: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color.fromRGBO(143, 148, 251, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            );
          },
        );

        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const WaitingApprovalScreen(),
          ),
        );
      } else {
        _showToastLikeSnack(data["message"]?.toString() ?? "Something went wrong");
      }
    } catch (e) {
      _showToastLikeSnack(e.toString());
    }

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  void _showToastLikeSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  InputDecoration _fieldDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: InputBorder.none,
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      prefixIcon: Icon(icon, color: Colors.white70),
      suffixIcon: suffixIcon,
      errorStyle: const TextStyle(color: Colors.redAccent),
    );
  }

  Widget _darkField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLength: maxLength,
        style: const TextStyle(color: Colors.white),
        decoration: _fieldDecoration(
          hint: hint,
          icon: icon,
          suffixIcon: suffixIcon,
        ).copyWith(counterText: maxLength != null ? "" : null),
        validator: validator,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    AppImages.verify,
                    height: 170,
                    width: 250,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Apply as Field Agent",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: "Poppins",
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Register to become a Verify Field Agent",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                    fontFamily: "Poppins",
                  ),
                ),

                const SizedBox(height: 40),

                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    children: [
                      _darkField(
                        controller: nameController,
                        hint: "Full Name",
                        icon: Iconsax.user,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter your name";
                          }
                          return null;
                        },
                      ),
                      _darkField(
                        controller: mobileController,
                        hint: "Mobile Number",
                        icon: Iconsax.call,
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        validator: (value) {
                          if (value == null || value.length != 10) {
                            return "Enter valid mobile number";
                          }
                          return null;
                        },
                      ),
                      _darkField(
                        controller: emailController,
                        hint: "Email",
                        icon: Iconsax.sms,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final emailRegex = RegExp(
                            r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                          );

                          if (!emailRegex.hasMatch(value!)) {
                            return "Enter valid email";
                          }
                        },
                      ),
                      _darkField(
                        controller: locationController,
                        hint: "Current Location",
                        icon: Iconsax.location,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter location";
                          }
                          return null;
                        },
                      ),
                      _darkField(
                        controller: passwordController,
                        hint: "Password",
                        icon: Iconsax.password_check,
                        obscureText: obscurePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white70,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.length < 6) {
                            return "Minimum 6 characters";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                GestureDetector(
                  onTap: isLoading ? null : register,
                  child: Container(
                    height: 55,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromRGBO(143, 148, 251, 1),
                          Color.fromRGBO(143, 148, 251, .6),
                        ],
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      )
                          : const Text(
                        "Apply as Field Agent",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.white70),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Your application will be reviewed by the Verify team. "
                              "You can access the app only after admin approval.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: TextStyle(color: Colors.grey[400], fontSize: 15),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(143, 148, 251, 1),
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WaitingApprovalScreen extends StatefulWidget {
  const WaitingApprovalScreen({super.key});

  @override
  State<WaitingApprovalScreen> createState() =>
      _WaitingApprovalScreenState();
}

class _WaitingApprovalScreenState extends State<WaitingApprovalScreen> {
  bool isRefreshing = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      const Duration(seconds: 20),
          (timer) {
        refreshStatus();
      },
    );
  }

  Future<void> refreshStatus() async {
    setState(() {
      isRefreshing = true;
    });

    /// TODO:
    /// Call your login/status API here.
    ///
    /// Example:
    ///
    /// status == "Pending"
    /// -> Stay on this page
    ///
    /// status == "Accepted"
    /// -> Navigator.pushReplacement(...)
    ///
    /// status == "Rejected"
    /// -> Show rejection dialog

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      isRefreshing = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Application is still pending."),
        backgroundColor: Color(0xFF1A1A1A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        AppImages.verify,
                        height: 100,
                        width: 150,
                      ),
                    ),
          
                    const SizedBox(height: 20),
          
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                      child: const Icon(
                        Icons.pending_actions_rounded,
                        color: Color.fromRGBO(143, 148, 251, 1),
                        size: 60,
                      ),
                    ),
          
                    const SizedBox(height: 30),
          
                    const Text(
                      "Field Agent Application Submitted",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Poppins",
                      ),
                      textAlign: TextAlign.center,
                    ),
          
                    const SizedBox(height: 15),
          
                    Text(
                      "Thank you for applying as a Verify Field Agent.\n\n"
                          "Your application has been received successfully and is currently under review by our admin team.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[400],
                        fontFamily: "Poppins",
                      ),
                    ),
          
                    const SizedBox(height: 35),
          
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor:
                            Color.fromRGBO(143, 148, 251, 1),
                            child: Icon(
                              Icons.hourglass_top,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Application Status",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Pending Approval",
                                style: TextStyle(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          
                    const SizedBox(height: 35),
          
                    GestureDetector(
                      onTap: isRefreshing ? null : refreshStatus,
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [
                              Color.fromRGBO(143, 148, 251, 1),
                              Color.fromRGBO(143, 148, 251, .6),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Center(
                          child: isRefreshing
                              ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                              : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.refresh, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Refresh Status",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 15),
          
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          /// Contact Support
                        },
                        icon: const Icon(Icons.support_agent,
                            color: Colors.white70),
                        label: const Text(
                          "Contact Support",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 40),
          
                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        "You will be able to log in only after your application is approved by the admin. Please check again later.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
          
                    const SizedBox(height: 20),
          
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Already have an account?",
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Login",
                            style: TextStyle(
                              color: Color.fromRGBO(143, 148, 251, 1),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Add this import at the top of the file if it isn't already there
// (needed for the "Back to Login" navigation below):
// import 'Login_page.dart';

class RejectedScreen extends StatelessWidget {
  const RejectedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        AppImages.verify,
                        height: 100,
                        width: 150,
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.redAccent,
                        ),
                      ),
                      child: const Icon(
                        Icons.cancel_rounded,
                        color: Colors.redAccent,
                        size: 60,
                      ),
                    ),

                    const SizedBox(height: 30),

                    const Text(
                      "Application Rejected",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: "Poppins",
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "We're sorry, your application to become a Verify Field Agent "
                          "has not been approved.\n\n"
                          "If you think this is a mistake, please contact our support "
                          "team for more details.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        height: 1.5,
                        color: Colors.grey[400],
                        fontFamily: "Poppins",
                      ),
                    ),

                    const SizedBox(height: 35),

                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.redAccent,
                        ),
                      ),
                      child: const Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Application Status",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Rejected",
                                style: TextStyle(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 35),

                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.white30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          /// Contact Support
                        },
                        icon: const Icon(Icons.support_agent,
                            color: Colors.white70),
                        label: const Text(
                          "Contact Support",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    GestureDetector(
                      onTap: () {
                        // Send them back to a clean login screen — there's
                        // nothing useful to "pop" back to from here since
                        // this screen replaces the login route.
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          Login_page.route,
                              (route) => false,
                        );
                      },
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.redAccent,
                              Color(0xFFB33A3A),
                            ],
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.login, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                "Back to Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white12,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: Text(
                        "Need help? Reach out to our support team and we'll "
                            "guide you through the next steps.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          height: 1.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}