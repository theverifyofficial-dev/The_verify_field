import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddOwnerPage extends StatefulWidget {
  final String propertyId;
  const AddOwnerPage({Key? key, required this.propertyId}) : super(key: key);

  @override
  State<AddOwnerPage> createState() => _AddOwnerPageState();
}

class _AddOwnerPageState extends State<AddOwnerPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();
  final TextEditingController _advanceController = TextEditingController();
  final TextEditingController _sendtoOwnerController = TextEditingController();
  final TextEditingController _totalAmountController = TextEditingController();

  String? _selectedPaymentMode;
  final List<String> paymentModes = ["Online", "Cash"];

  final _formatter = NumberFormat.decimalPattern('hi_IN');
  String _fieldworkarnumber = '';

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      print("_fieldworkarnumber ${_fieldworkarnumber}");
      _fieldworkarnumber = prefs.getString('number') ?? '';
    });
  }
  @override
  void initState() {
    super.initState();
    _fetchAdvanceAmount();
    _loaduserdata();
    _addFormatListener(_advanceController);
    _addFormatListener(_sendtoOwnerController);
    _addFormatListener(_totalAmountController);
  }

  Future<void> _fetchAdvanceAmount() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_fieldworkar.php?field_workar_number=${_fieldworkarnumber}"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data is Map) {
          setState(() {
            _advanceController.text = _formatter.format(
              int.tryParse(data["Advance_Payment"]?.toString() ?? "0") ?? 0,
            );
          });
        } else if (data is List && data.isNotEmpty) {
          setState(() {
            _advanceController.text = _formatter.format(
              int.tryParse(data[0]["Advance_Payment"]?.toString() ?? "0") ?? 0,
            );
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching advance amount: $e");
    }
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

  Future<void> _submitOwner() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse(
        "https://verifyserve.social/PHP_Files/add_owner_in_futuere_property/insert.php");

    try {
      final response = await http.post(url, body: {
        "owner_name": _ownerNameController.text,
        "owner_number": _ownerPhoneController.text,
        "payment_mode": _advanceController.text,
        "subid": widget.propertyId,
      });

      if (response.statusCode == 200) {
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Owner Added Successfully ✅"),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true); // ✅ pass true so previous page refreshes
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed ❌: ${response.body}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error ❌: $e")),
      );
    }
  }

  Widget _buildInputField(String label, TextEditingController controller,
      {TextInputType inputType = TextInputType.text}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
          prefixIcon: Icon(
            label.contains("Phone") ? Icons.phone : Icons.person,
            color: Colors.blueAccent,
          ),
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[900] : Colors.white,
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
      appBar: AppBar(title: const Text("Add Owner")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField("Owner Name", _ownerNameController),
              const SizedBox(height: 16),
              _buildPhoneField("Owner Number", _ownerPhoneController,
                inputType: TextInputType.phone,
                icon: Icons.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 16),

              _buildPhoneField("Owner Commission", _advanceController,
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: _submitOwner,
                  child: const Text(
                    "Submit",
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
