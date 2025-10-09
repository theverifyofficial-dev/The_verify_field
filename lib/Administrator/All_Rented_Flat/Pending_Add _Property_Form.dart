import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // ✅ for Indian number format

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
  final TextEditingController _rentController = TextEditingController();
  final TextEditingController _securityController = TextEditingController();

  String? _selectedPaymentMode;
  final List<String> paymentModes = ["Online", "Cash"];

  final _formatter = NumberFormat.decimalPattern('hi_IN'); // ✅ Indian format

  @override
  void initState() {
    super.initState();

    // Add format listeners to amount fields
    _addFormatListener(_advanceController);
    _addFormatListener(_rentController);
    _addFormatListener(_securityController);
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

  /// API Call to Insert Owner
  Future<void> _submitOwner() async {
    if (!_formKey.currentState!.validate()) return;

    final url = Uri.parse(
        "https://verifyserve.social/PHP_Files/add_owner_in_futuere_property/insert.php");

    try {
      final response = await http.post(url, body: {
        "owner_name": _ownerNameController.text,
        "owner_number": _ownerPhoneController.text,
        "payment_mode": _selectedPaymentMode ?? "",
        "advance_amount": _advanceController.text.replaceAll(',', ''), // ✅ remove commas before sending
        "rent": _rentController.text.replaceAll(',', ''),
        "securitys": _securityController.text.replaceAll(',', ''),
        "subid": widget.propertyId,
        "status": "Active", // default status
      });

      if (response.statusCode == 200) {
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

  /// Custom Input Field
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

  /// Number input field
  Widget _buildNumberField(String label, TextEditingController controller) {
    return _buildInputField(label, controller, inputType: TextInputType.number);
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

          // ✅ Special case for phone number
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
              const SizedBox(height: 16),
              _buildNumberField("Advance Amount", _advanceController),
              const SizedBox(height: 16),
              _buildNumberField("Rent", _rentController),
              const SizedBox(height: 16),
              _buildNumberField("Security", _securityController),
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
