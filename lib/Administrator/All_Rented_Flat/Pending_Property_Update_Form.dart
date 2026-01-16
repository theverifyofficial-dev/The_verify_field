import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../Custom_Widget/constant.dart';

class UpdateOwnerPage extends StatefulWidget {
  final String propertyId;
  final String ownerId;

  const UpdateOwnerPage({Key? key, required this.propertyId, required this.ownerId}) : super(key: key);

  @override
  State<UpdateOwnerPage> createState() => _UpdateOwnerPageState();
}

class _UpdateOwnerPageState extends State<UpdateOwnerPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _securityController = TextEditingController();

  String? _selectedPaymentMode;
  final List<String> paymentModes = ["Online", "Cash"];

  bool _isLoading = true;
  bool _isSubmitting = false;

  final _formatter = NumberFormat.decimalPattern('hi_IN'); // ✅ Indian format

  @override
  void initState() {
    super.initState();
    _addFormatListener(_advanceController);
    _addFormatListener(_rentController);
    _addFormatListener(_securityController);
    _fetchOwnerData();
  }

  void _addFormatListener(TextEditingController controller) {
    controller.addListener(() {
      final text = controller.text.replaceAll(',', '');
      if (text.isEmpty) return;
      final value = int.tryParse(text);
      if (value != null) {
        final newText = _formatter.format(value);
        if (controller.text != newText) {
          controller.value = TextEditingValue(
            text: newText,
            selection: TextSelection.collapsed(offset: newText.length),
          );
        }
      }
    });
  }

  Future<void> _fetchOwnerData() async {
    final url = Uri.parse(
        "https://verifyserve.social/PHP_Files/owner_tenant_api.php?subid=${widget.propertyId}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"] == true && data["data"].isNotEmpty) {
          final owner = data["data"][0];
          setState(() {
            _ownerNameController.text = owner["owner_name"] ?? "";
            _ownerPhoneController.text = owner["owner_number"] ?? "";
            _advanceController.text =
                _formatter.format(int.tryParse(owner["advance_amount"] ?? "0") ?? 0);
            _rentController.text =
                _formatter.format(int.tryParse(owner["rent"] ?? "0") ?? 0);
            _securityController.text =
                _formatter.format(int.tryParse(owner["securitys"] ?? "0") ?? 0);
            _selectedPaymentMode = owner["payment_mode"];
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load owner");
      }
    } catch (e) {
      setState(() => _isLoading = false);
      print("Error fetching owner data: $e");
    }
  }

  Future<void> _updateOwner() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final url = Uri.parse(
        "https://verifyserve.social/PHP_Files/add_owner_in_futuere_property/update.php");

    try {
      final response = await http.post(url, body: {
        "id": widget.ownerId,
        "owner_name": _ownerNameController.text.trim(),
        "owner_number": _ownerPhoneController.text.trim(),
        "subid": widget.propertyId.trim(),
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["status"] == "success") {
          print(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(data['message'] ?? "Owner Updated Successfully ✅",
                  style: const TextStyle(color: Colors.white)),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );

          await Future.delayed(const Duration(seconds: 1));
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Failed ❌: ${data['message'] ?? response.body}"),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("HTTP Error ❌: ${response.statusCode}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Exception ❌: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }
  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text, IconData? icon}) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: (value) {
          if (value == null || value.isEmpty) return "$label is required";
          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon ?? Icons.person, color: Colors.blueAccent),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.white,
        ),
      ),
    );
  }
  Widget _buildPhoneField(
      String label,
      TextEditingController controller, {
        TextInputType inputType = TextInputType.text,
        IconData? icon,
        List<TextInputFormatter>? inputFormatters,
      }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        inputFormatters: inputFormatters,
        validator: (value) {
          if (value == null || value.isEmpty) return "$label is required";

          if (label == "Owner Number" && value.length != 10) {
            return "Owner Number must be exactly 10 digits";
          }

          return null;
        },
        decoration: InputDecoration(
          prefixIcon: Icon(icon ?? Icons.person, color: Colors.blueAccent),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey[900]
              : Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AppImages.verify, height: 75),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(PhosphorIcons.caret_left_bold,
              color: Colors.white, size: 30),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField("Owner Name", _ownerNameController,
                  icon: Icons.person),
              const SizedBox(height: 16),
              _buildPhoneField("Owner Number", _ownerPhoneController,
                inputType: TextInputType.phone,
                icon: Icons.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _updateOwner,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text(
                    "Update Owner",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
