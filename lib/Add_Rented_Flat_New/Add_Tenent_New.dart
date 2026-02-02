import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class AddTenantPageNew extends StatefulWidget {
  final String id;
  const AddTenantPageNew({Key? key, required this.id}) : super(key: key);

  @override
  State<AddTenantPageNew> createState() => _AddTenantPageNewState();
}

class _AddTenantPageNewState extends State<AddTenantPageNew> {
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

  String? _selectedPaymentMode;
  final List<String> paymentModes = ["Online", "Cash"];

  /// API Call to Insert Tenant
  Future<void> _submitTenant() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/add_owner_and_tenant_details.php",
    );

    final response = await http.post(url, body: {

      "subid": widget.id,
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

    if (response.statusCode == 200) {
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tenant & Owner Added Successfully ✅")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed ❌ ${response.body}")),
      );
    }
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
          fillColor: isDark ? Colors.grey[900] : Colors.white,
        ),
      ),
    );
  }
  Widget _buildInputNameField(
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
          counterText: "",
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
        maxLength: 10,

        decoration: InputDecoration(
          counterText: "", // hides the "0/10" counter
          prefixIcon: const Icon(Icons.phone, color: Colors.blueAccent),
          labelText: "Tenant Number",
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

              _section("Owner Info"),
              _buildInputNameField(
                "Owner Name",
                "Enter owner name",
                _ownerNameController,
                Icons.person_outline,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                "Owner Phone",
                "Enter owner phone number",
                _ownerPhoneController,
                Icons.phone,
                inputType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _ownerPaymentMode,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.account_balance_wallet, color: Colors.blueAccent),
                  labelText: "Owner Payment Mode",
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
                onChanged: (value) => setState(() => _ownerPaymentMode = value),
                validator: (value) =>
                value == null ? "Owner payment mode required" : null,
              ),

              _section("Tenant Info"),

              _buildInputNameField(
                "Tenant Name",
                "Enter tenant name",
                _tenantNameController,
                Icons.person,
              ),
              const SizedBox(height: 16),

              _buildPhoneField(),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: _tenantPaymentMode,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.payment, color: Colors.blueAccent),
                  labelText: "Tenant Payment Mode",
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
                onChanged: (value) => setState(() => _tenantPaymentMode = value),
                validator: (value) =>
                value == null ? "Tenant payment mode required" : null,
              ),
              const SizedBox(height: 16),

              _buildDateField(),

              _section("Visitor Info"),
              _input("FieldWorker Name", _visitorNameController, Icons.badge),
              const SizedBox(height: 12),
              _input("FieldWorker Phone", _visitorPhoneController, Icons.phone,
                  type: TextInputType.phone),

              const SizedBox(height: 24),
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
