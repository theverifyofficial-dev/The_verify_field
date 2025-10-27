import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../constant.dart';

class AccountRegisteration extends StatefulWidget {
  static const route = "/SignUp_page";
  const AccountRegisteration({super.key});

  @override
  State<AccountRegisteration> createState() => _SignUp_pageState();
}

class _SignUp_pageState extends State<AccountRegisteration> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String? _selectedPost;
  String? _selected_location;

  Future<void> signUpUser() async {
    try {
      setState(() => _isLoading = true);

      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/register_account.php",
      );

      final response = await http.post(
        url,
        body: {
          "FName": _nameController.text.trim(),
          "FNumber": _mobileController.text.trim(),
          "FEmail": _emailController.text.trim(),
          "FPassword": _passController.text.trim(),
          "F_Location": _selected_location ?? "",
          "FAadharCard": _selectedPost ?? "",
        },
      );

      print("📤 Sending Request Body:");
      print({
        "FName": _nameController.text.trim(),
        "FNumber": _mobileController.text.trim(),
        "FEmail": _emailController.text.trim(),
        "FPassword": _passController.text.trim(),
        "F_Location": _selected_location,
        "FAadharCard": _selectedPost,
      });

      print("📩 Raw Response: ${response.body}");
      final data = json.decode(response.body);

      if (data is Map && data["success"] == true) {
        Fluttertoast.showToast(
          msg: "Account Created Successfully ✅",
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        Navigator.pop(context);
      } else if (data is Map) {
        Fluttertoast.showToast(
          msg: data["message"] ?? "Sign Up Failed ❌",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: "Unexpected response format ❌",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      Fluttertoast.showToast(
        msg: "Error: $e",
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget buildTextField(
      {required TextEditingController controller,
        required String hint,
        required IconData icon,
        TextInputType keyboardType = TextInputType.text,
        bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(icon, color: Colors.white70),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Image.asset(
                AppImages.verify,
                height: 170,
                width: 250,
              ),
            ),
            const Text(
              'Create Account',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Fill your details to register in the Verify App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  buildTextField(
                      controller: _nameController,
                      hint: "Full Name",
                      icon: Iconsax.user),
                  buildTextField(
                      controller: _mobileController,
                      hint: "Phone Number",
                      keyboardType: TextInputType.phone,
                      icon: Iconsax.call),
                  buildTextField(
                      controller: _emailController,
                      hint: "Email Address",
                      icon: Icons.email_outlined),

                  buildDropdown(
                    hint: "Select Post",
                    icon: Iconsax.user_tag,
                    value: _selectedPost,
                    items: ["Administrator", "Sub Administrator","Accountant", "FieldWorkar"],
                    onChanged: (val) {
                      setState(() {
                        _selectedPost = val;
                      });
                    },
                  ),

                  buildDropdown(
                    hint: "Select Location",
                    icon: Iconsax.location,
                    value: _selected_location,
                    items: ["Sultanpur", "Chhattarpur", "Rajpur Khurd"],
                    onChanged: (val) {
                      setState(() {
                        _selected_location = val;
                      });
                    },
                  ),
                  const SizedBox(height: 10),

                  buildTextField(
                      controller: _passController,
                      hint: "Password",
                      icon: Iconsax.password_check,
                      isPassword: true),

                  const SizedBox(height: 10),
                  // Sign Up Button
                  GestureDetector(
                    onTap: _isLoading ? null : signUpUser,
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(143, 148, 251, 1),
                            Color.fromRGBO(143, 148, 251, .6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Center(
                        child: _isLoading
                            ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                            : const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
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

  Widget buildDropdown({
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white30),
      ),
      padding: const EdgeInsets.only(right: 10),
      child: DropdownButtonFormField<String>(
        value: value,
        dropdownColor: Colors.black87,
        style: const TextStyle(color: Colors.white, fontSize: 16),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(icon, color: Colors.white70),
        ),
        hint: Text(
          hint,
          style: TextStyle(color: Colors.grey[600]),
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Colors.white)),
        ))
            .toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? "Please select $hint" : null,
      ),
    );
  }

}
