import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../utilities/bug_founder_fuction.dart';

class AddTenantPage extends StatefulWidget {
  final String id;
  const AddTenantPage({Key? key, required this.id}) : super(key: key);

  @override
  State<AddTenantPage> createState() => _AddTenantPageState();
}

class _AddTenantPageState extends State<AddTenantPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _tenantPhoneController = TextEditingController();
  final TextEditingController _shiftingDateController = TextEditingController();

  String? _selectedPaymentMode;
  final List<String> paymentModes = ["Online", "Cash"];

  /// API Call to Insert Tenant
  Future<void> _submitTenant() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse(
        "https://verifyserve.social/PHP_Files/add_tanant_in_future_property/insert.php");
    print("id :"+ widget.id ,);
    final response = await http.post(url, body: {
      "tenant_name": _tenantNameController.text,
      "tenant_phone_number": _tenantPhoneController.text,
      "shifting_date": _shiftingDateController.text,
      "payment_mode": _selectedPaymentMode ?? "",
      "sub_id": widget.id.toString() ,

    });

    if (response.statusCode == 200) {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tenant Added Successfully ✅")),
      );
      Navigator.pop(context);
    } else {
      // 🔴 LOG BACKEND FAILURE
      await BugLogger.log(
        apiLink: 'https://verifyserve.social/PHP_Files/add_tanant_in_future_property/insert.php',
        error: response.body.toString(),
        statusCode: response.statusCode ?? 0,
      );
      print(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add tenant ❌: ${response.body}")),
      );
    }
  }

  /// Custom Input Field
  Widget _buildInputField(
      String label, String hint, TextEditingController controller, IconData icon,
      {bool isOptional = false, TextInputType inputType = TextInputType.text}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return "$label is required";
          }
          return null;
        },
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          hintText: hint,
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
  Widget _buildPhoneField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: _tenantPhoneController,
        keyboardType: TextInputType.phone,
        maxLength: 10, // 🚨 restrict input to 10 digits
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Phone Number is required";
          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return "Enter a valid 10-digit number";
          }
          return null;
        },
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: "", // hides the "0/10" counter
          prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
          labelText: "Phone Number",
          hintText: "Enter 10-digit phone number",
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

  /// Date Picker Field
  Widget _buildDateField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: _shiftingDateController,
        readOnly: true,
        validator: (value) =>
        value == null || value.isEmpty ? "Shifting Date is required" : null,
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            String formatted = DateFormat("yyyy-MM-dd").format(pickedDate);
            setState(() {
              _shiftingDateController.text = formatted;
            });
          }
        },
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          labelText: "Shifting Date",
          hintText: "Select Shifting Date",
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Tenant")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                "Tenant Name",
                "Enter tenant name",
                _tenantNameController,
                Icons.person,
              ),
              const SizedBox(height: 16),

              _buildPhoneField(),
              const SizedBox(height: 16),

              _buildDateField(),
              const SizedBox(height: 16),

              /// Payment Mode Dropdown
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(14),
                child: DropdownButtonFormField<String>(
                  value: _selectedPaymentMode,
                  decoration: InputDecoration(
                    prefixIcon:
                    const Icon(Icons.payment, color: Colors.blueAccent),
                    labelText: "Payment Mode",
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[900]
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: paymentModes
                      .map((mode) =>
                      DropdownMenuItem(value: mode, child: Text(mode)))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMode = value;
                    });
                  },
                  validator: (value) =>
                  value == null ? "Payment Mode is required" : null,
                ),
              ),
              const SizedBox(height: 24),

              /// Submit Button
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
                  onPressed: _submitTenant,
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: Colors.white),
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
