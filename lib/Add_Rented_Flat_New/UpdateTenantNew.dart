import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';

class UpdateTenantPageNew extends StatefulWidget {
  final String propertyId;
  final String tenentId;
  const UpdateTenantPageNew({Key? key, required this.propertyId, required this.tenentId })
      : super(key: key);

  @override
  State<UpdateTenantPageNew> createState() => _UpdateTenantPageNewState();
}

class _UpdateTenantPageNewState extends State<UpdateTenantPageNew> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tenantNameController = TextEditingController();
  final TextEditingController _tenantPhoneController = TextEditingController();
  final TextEditingController _shiftingDateController = TextEditingController();
  final TextEditingController _ownerNameController = TextEditingController();
  final TextEditingController _ownerPhoneController = TextEditingController();

  String? _ownerPaymentMode;
  String? _tenantPaymentMode;
  final _visitorNameController = TextEditingController();
  final _visitorPhoneController = TextEditingController();
  final List<String> paymentModes = ["Online", "Cash"];

  String? _selectedPaymentMode;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTenantData();
  }

  /// Fetch Tenant Data
  Future<void> _fetchTenantData() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_tenant_and_owner_api.php?subid=${widget.propertyId}",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["success"] == true && data["data"].isNotEmpty) {
          final t = data["data"][0];

          setState(() {
            _tenantNameController.text = t["tenant_name"] ?? "";
            _tenantPhoneController.text = t["tenant_number"] ?? "";
            _shiftingDateController.text = t["shifting_date"] ?? "";

            _ownerNameController.text = t["owner_name"] ?? "";
            _ownerPhoneController.text = t["owner_number"] ?? "";

            _ownerPaymentMode = t["payment_mode_for_owner"];
            _tenantPaymentMode = t["payment_mode_for_tenant"];
            _visitorNameController.text = t["vist_field_workar_name"] ?? "";
            _visitorPhoneController.text = t["vist_field_workar_number"] ?? "";

            _isLoading = false;
          });
        }
      }
    } catch (e) {
      _isLoading = false;
      debugPrint("Error: $e");
    }
  }

  /// Update Tenant API Call
  Future<void> _updateTenant() async {
    var uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/update_api_owner_tenant_api.php",
    );

    var request = http.MultipartRequest("POST", uri);

    request.fields.addAll({
      "id": widget.tenentId,
      "tenant_name": _tenantNameController.text,
      "tenant_number": _tenantPhoneController.text,
      "shifting_date": _shiftingDateController.text,

      "owner_name": _ownerNameController.text,
      "owner_number": _ownerPhoneController.text,

      "payment_mode_for_owner": _ownerPaymentMode ?? "",
      "payment_mode_for_tenant": _tenantPaymentMode ?? "",
      "vist_field_workar_name": _visitorNameController.text,
      "vist_field_workar_number": _visitorPhoneController.text,
    });

    final response = await request.send();
    final respStr = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Updated Successfully ✅")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed ❌ $respStr")),
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
        maxLength: 10,
        decoration: InputDecoration(
          counterText: "",
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
          labelText: "Tenant Phone Number",
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _section("Owner Info"),

              _buildInputField(
                "Owner Name",
                "Enter owner name",
                _ownerNameController,
                Icons.person_outline,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                "Owner Phone Number",
                "Enter owner phone",
                _ownerPhoneController,
                Icons.phone,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              /// Owner Payment Mode
              DropdownButtonFormField<String>(
                value: _ownerPaymentMode,
                decoration: _dropdownDecoration("Owner Payment Mode", Icons.account_balance_wallet),
                items: paymentModes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _ownerPaymentMode = v),
                validator: (v) => v == null ? "Required" : null,
              ),
              _section("Tenant Info"),

              _buildInputField("Tenant Name", "Enter tenant name",
                  _tenantNameController, Icons.person),
              const SizedBox(height: 16),
              _buildPhoneField(),
              const SizedBox(height: 16),

              /// Tenant Payment Mode
              DropdownButtonFormField<String>(
                value: _tenantPaymentMode,
                decoration: _dropdownDecoration("Tenant Payment Mode", Icons.payment),
                items: paymentModes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (v) => setState(() => _tenantPaymentMode = v),
                validator: (v) => v == null ? "Required" : null,
              ),

              const SizedBox(height: 16),
              _buildDateField(),
              _section("Visitor Info"),
              _input("FieldWorker Name", _visitorNameController, Icons.badge),
              const SizedBox(height: 12),
              _input("FieldWorker Phone", _visitorPhoneController, Icons.phone,
                  type: TextInputType.phone),

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
  Widget _input(String label, TextEditingController c, IconData icon,
      {TextInputType type = TextInputType.text}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: c,
        keyboardType: type,
        maxLength: type == TextInputType.phone ? 10 : null,

        decoration: InputDecoration(
          counterText: "",
          prefixIcon: Icon(icon, color: Colors.blueAccent),
          labelText: label,
          filled: true,
          fillColor: isDark ? Colors.grey[900] : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
  Widget _section(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  InputDecoration _dropdownDecoration(String label, IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.blueAccent),
      labelText: label,
      filled: true,
      fillColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey[900]
          : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

}
