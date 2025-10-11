import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class UpdateTenantPage extends StatefulWidget {
  final String propertyId;
  final String tenentId;
  const UpdateTenantPage({Key? key, required this.propertyId, required this.tenentId })
      : super(key: key);

  @override
  State<UpdateTenantPage> createState() => _UpdateTenantPageState();
}

class _UpdateTenantPageState extends State<UpdateTenantPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _tenantPhoneController = TextEditingController();
  final TextEditingController _shiftingDateController = TextEditingController();

  String? _selectedPaymentMode;
  final List<String> paymentModes = ["Online", "Cash"];

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTenantData();
  }

  /// Fetch Tenant Data
  Future<void> _fetchTenantData() async {
    final url = Uri.parse(
        "https://verifyserve.social/PHP_Files/show_tenant_api.php?sub_id=${widget.propertyId}");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data["success"] == true && data["data"].isNotEmpty) {
          final tenant = data["data"][0];

          setState(() {
            _tenantNameController.text = tenant["tenant_name"] ?? "";
            _tenantPhoneController.text = tenant["tenant_phone_number"] ?? "";
            _shiftingDateController.text = tenant["shifting_date"] ?? "";
            _selectedPaymentMode = tenant["payment_mode"];
            _isLoading = false;
          });
        }
      } else {
        throw Exception("Failed to load tenant");
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error fetching tenant data: $e");
    }
  }

  /// Update Tenant API Call
  Future<void> _updateTenant() async {
    try {
      var uri = Uri.parse(
          "https://verifyserve.social/PHP_Files/add_tanant_in_future_property/update_tenant.php");

      var request = http.MultipartRequest("POST", uri);

      // 👇 send ID inside fields instead of URL
      request.fields["id"] = widget.tenentId;
      request.fields["tenant_name"] = _tenantNameController.text;
      request.fields["tenant_phone_number"] = _tenantPhoneController.text;
      request.fields["shifting_date"] = _shiftingDateController.text;
      request.fields["payment_mode"] = _selectedPaymentMode ?? "";

      var response = await request.send();

      final respStr = await response.stream.bytesToString();
      print("Response: $respStr");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tenant Updated Successfully ✅")),
        );
        Navigator.pop(context,true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to update ❌: $respStr")),
        );
      }
    } catch (e) {
      print("Exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  /// Input Field
  Widget _buildInputField(String label, String hint,
      TextEditingController controller, IconData icon,
      {bool isOptional = false, TextInputType inputType = TextInputType.text}) {
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
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          hintText: hint,
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

  Widget _buildPhoneField() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: _tenantPhoneController,
        keyboardType: TextInputType.phone,
        maxLength: 10,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Phone Number is required";
          } else if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
            return "Enter a valid 10-digit number";
          }
          return null;
        },
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
          labelText: "Phone Number",
          hintText: "Enter 10-digit phone number",
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

  Widget _buildDateField() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: _shiftingDateController,
        readOnly: true,
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
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.calendar_today, color: Colors.blueAccent),
          labelText: "Shifting Date",
          hintText: "Select Shifting Date",
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
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),        // centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildInputField("Tenant Name", "Enter tenant name",
                  _tenantNameController, Icons.person),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 16),

              /// Payment Mode
              Material(
                elevation: 2,
                borderRadius: BorderRadius.circular(14),
                child: DropdownButtonFormField<String>(
                  value: _selectedPaymentMode,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.payment,
                        color: Colors.blueAccent),
                    labelText: "Payment Mode",
                    filled: true,
                    fillColor:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[900]
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  items: paymentModes
                      .map((mode) => DropdownMenuItem(
                      value: mode, child: Text(mode)))
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

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _updateTenant,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Update Tenant",
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
