import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../ui_decoration_tools/app_images.dart';
import 'under_flats_infutureproperty.dart';

class AddTenantUnderFutureProperty extends StatefulWidget {
  final String id;
  final String subId;

  const AddTenantUnderFutureProperty({
    super.key,
    required this.id,
    required this.subId,
  });

  @override
  State<AddTenantUnderFutureProperty> createState() =>
      _AddTenantUnderFuturePropertyState();
}

class _AddTenantUnderFuturePropertyState
    extends State<AddTenantUnderFutureProperty> {
  bool _isLoading = false;
  String? _selectedPaymentMode;
  String? _selectedPropertyType;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _tenantName = TextEditingController();
  final TextEditingController _tenantPhone = TextEditingController();
  final TextEditingController _flatRent = TextEditingController();
  final TextEditingController _shiftingDate = TextEditingController();
  final TextEditingController _members = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _tenantVehicle = TextEditingController();
  final TextEditingController _workProfile = TextEditingController();

  // 🔥 NEW API FIELDS
  final TextEditingController _bhk = TextEditingController();


  Future<void> uploadTenant() async {
    setState(() => _isLoading = true);

    final Uri url = Uri.parse(
      'https://verifyserve.social/PHP_Files/add_tanant_in_future_property/insert.php',
    );

    try {
      final request = http.MultipartRequest('POST', url);

      request.fields.addAll({
        "tenant_name": _tenantName.text.trim(),
        "tenant_phone_number": _tenantPhone.text.trim(),
        "flat_rent": _flatRent.text.trim(),
        "shifting_date": _shiftingDate.text.trim(),
        "members": _members.text.trim(),
        "email": _email.text.trim(),
        "tenant_vichal_details": _tenantVehicle.text.trim(),
        "work_profile": _workProfile.text.trim(),
        "bhk": _bhk.text.trim(),
        "type_of_property": _selectedPropertyType ?? "",
        "payment_mode": _selectedPaymentMode ?? "",
        "sub_id": widget.id,
      });

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode == 200) {
        if (!mounted) return;

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => underflat_futureproperty(
              Subid: widget.subId,
              id: widget.id,
            ),
          ),
              (route) => route.isFirst,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Tenant added successfully")),
        );
      } else {
        debugPrint(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Upload failed (${response.statusCode})")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold,
              color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                "Add Tenant",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),

              _buildTextInput("Tenant Name", _tenantName),

              _buildPhoneInput(),

              Row(
                children: [
                  Expanded(child: _buildTextInput("Rent Amount", _flatRent)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildDatePicker()),
                ],
              ),

              Row(
                children: [
                  Expanded(child: _buildTextInput("Family Members", _members)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildTextInput("Email", _email)),
                ],
              ),

              Row(
                children: [
                  Expanded(
                      child:
                      _buildTextInput("Vehicle Details", _tenantVehicle)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _buildTextInput("Work Profile", _workProfile)),
                ],
              ),

              Row(
                children: [
                  Expanded(child: _buildPropertyTypeDropdown()),
                  const SizedBox(width: 12),
                  Expanded(child: _buildPaymentModeDropdown()),
                ],
              ),

            _buildTextInput("BHK", _bhk),



              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      uploadTenant();
                    }
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Submit",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
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

  Widget _buildPhoneInput() {
    return _buildSectionCard(
      title: "Phone Number",
      child: TextFormField(
        controller: _tenantPhone,
        keyboardType: TextInputType.number,
        maxLength: 10,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: const InputDecoration(
          hintText: "Enter Phone Number",
          counterText: "",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
        ),
        validator: (v) {
          if (v == null || v.isEmpty) return "Enter phone number";
          if (v.length != 10) return "Phone must be 10 digits";
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return _buildSectionCard(
      title: "Shifting Date",
      child: TextFormField(
        controller: _shiftingDate,
        readOnly: true,
        decoration: const InputDecoration(
          hintText: "Pick a date",
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
        ),
        validator: (v) =>
        v == null || v.isEmpty ? "Select shifting date" : null,
        onTap: () async {
          final picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2010),
            lastDate: DateTime(2101),
          );
          if (picked != null) {
            _shiftingDate.text = DateFormat('dd/MM/yyyy').format(picked);
          }
        },
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          hintText: "Enter $label",
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
        ),
        validator: (v) =>
        v == null || v.trim().isEmpty ? "Enter $label" : null,
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Poppins")),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildPropertyTypeDropdown() {
    return _buildSectionCard(
      title: "Type of Property",
      child: DropdownButtonFormField<String>(
        value: _selectedPropertyType,
        isExpanded: true, // ✅ FIX 1
        isDense: true,    // ✅ FIX 2
        items: const [
          DropdownMenuItem(value: "Residential", child: Text("Residential")),
          DropdownMenuItem(value: "Commercial", child: Text("Commercial")),
        ],
        decoration: const InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric( // ✅ FIX 3
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onChanged: (value) {
          setState(() => _selectedPropertyType = value);
        },
        validator: (value) =>
        value == null ? "Select property type" : null,
      ),
    );
  }


  Widget _buildPaymentModeDropdown() {
    return _buildSectionCard(
      title: "Payment Mode",
      child: DropdownButtonFormField<String>(
        value: _selectedPaymentMode,
        isExpanded: true, // ✅ FIX 1
        isDense: true,    // ✅ FIX 2
        items: const [
          DropdownMenuItem(value: "Cash", child: Text("Cash")),
          DropdownMenuItem(value: "UPI", child: Text("UPI")),
          DropdownMenuItem(value: "Bank Transfer", child: Text("Bank Transfer")),
          DropdownMenuItem(value: "Cheque", child: Text("Cheque")),
        ],
        decoration: const InputDecoration(
          filled: true,
          contentPadding: EdgeInsets.symmetric( // ✅ FIX 3
            horizontal: 12,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        onChanged: (value) {
          setState(() => _selectedPaymentMode = value);
        },
        validator: (value) =>
        value == null ? "Select payment mode" : null,
      ),
    );
  }

}
