import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../constant.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;


class UpdateActionFormNew extends StatefulWidget {
  final String propertyId;
  final String userNumber;

  const UpdateActionFormNew({super.key,required this.propertyId, required this.userNumber});

  @override
  State<UpdateActionFormNew> createState() => _UpdateActionFormNewState();
}

class _UpdateActionFormNewState extends State<UpdateActionFormNew> {
  final TextEditingController rentController = TextEditingController();
  final TextEditingController securityController = TextEditingController();
  final TextEditingController commissionController = TextEditingController();
  final TextEditingController ownerController = TextEditingController();
  final TextEditingController advanceController = TextEditingController();
  final TextEditingController balanceController = TextEditingController();
  final TextEditingController extraExpenseController = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();

    _loadPropertyData();
    rentController.addListener(_calculateBalance);
    securityController.addListener(_calculateBalance);
    commissionController.addListener(_calculateBalance);
    ownerController.addListener(_calculateBalance);
    advanceController.addListener(_calculateBalance);
    extraExpenseController.addListener(_calculateBalance);
  }

  Future<void> _loadPropertyData() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_book_flat_by_fieldworkar.php?field_workar_number=${widget.userNumber}",
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded["success"] == true) {
          final List list = decoded["data"];

          final matched = list.firstWhere(
                (e) => e["P_id"].toString() == widget.propertyId,
            orElse: () => null,
          );

          if (matched != null) {
            setState(() {
              rentController.text = matched["Rent"] ?? "";
              securityController.text = matched["Security"] ?? "";
              commissionController.text = matched["Commission"] ?? "";
              ownerController.text = matched["owner_side_commition"] ?? "";
              extraExpenseController.text = matched["Extra_Expense"] ?? "";
              advanceController.text = matched["Advance_Payment"] ?? "";
              balanceController.text = matched["Total_Balance"] ?? "";
            });

            _calculateBalance(); // 🔥 recalc totals
          }
        }
      }
    } catch (e) {
      debugPrint("Auto-fill error: $e");
    }
  }

  bool _isSubmitting = false;

  String _step1 = "";
  String _step2 = "";
  final _indianFormat = NumberFormat.currency(locale: "en_IN", symbol: "₹ ");

  double rent = 0, security = 0, commission = 0, advance = 0, extra = 0,ownerSideCommission=0;
  double addPart = 0, _finalBalance = 0;

  void _calculateBalance() {
    setState(() {
      rent = double.tryParse(rentController.text.replaceAll(',', '')) ?? 0;
      security = double.tryParse(securityController.text.replaceAll(',', '')) ?? 0;
      commission = double.tryParse(commissionController.text.replaceAll(',', '')) ?? 0;
      ownerSideCommission = double.tryParse(ownerController.text.replaceAll(',', '')) ?? 0;
      extra = double.tryParse(extraExpenseController.text.replaceAll(',', '')) ?? 0;
      advance = double.tryParse(advanceController.text.replaceAll(',', '')) ?? 0;

      // ✅ Only add these, don't subtract advance
      addPart = rent + security + commission + extra;
      _finalBalance = addPart;

      balanceController.text = _finalBalance > 0
          ? _indianFormat.format(_finalBalance)
          : '';
    });
  }

  String _calculationText = "";


  Future<void> sendData() async {
    final rent = rentController.text.replaceAll(',', '');
    final security = securityController.text.replaceAll(',', '');
    final commission = commissionController.text.replaceAll(',', '');
    final ownerSideCommission = ownerController.text.replaceAll(',', '');
    final extraExpense = extraExpenseController.text.replaceAll(',', '');
    final advance = advanceController.text.replaceAll(',', '');
    final totalBalance = balanceController.text.replaceAll('₹', '').replaceAll(',', '').trim();

    // Get current date and time
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final formattedTime = DateFormat('HH:mm:ss').format(now);

    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/book_flat_update_api_for_field_workar.php',
    );

    try {
      final response = await http.post(
        uri,
        body: {
          'P_id': widget.propertyId,
          'Rent': rent,
          'Security': security,
          'Commission': commission,
          'owner_side_commition': ownerSideCommission,
          'Extra_Expense': extraExpense,
          'Advance_Payment': advance,
          'Total_Balance': totalBalance,
          'dates': formattedDate,
          'tims': formattedTime,
        },
      );

      if (response.statusCode == 200) {
        print("API Response: ${response.body}");
        Navigator.pop(context, true);
      } else {
        print("Failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,

        surfaceTintColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.black ,
        title: Image.asset(AppImages.verify, height: 65),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 10),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,

            child: Column(
              children: [
                const SizedBox(height: 6),


                _buildInputField("Rent", "e.g. 15000", rentController, Icons.home_work_rounded),
                const SizedBox(height: 16),
                _buildInputField("Security", "e.g. 30000", securityController, Icons.security),
                const SizedBox(height: 16),
                _buildInputField("Tenant Commission", "e.g. 2000", commissionController, Icons.percent),
                const SizedBox(height: 16),
                _buildInputField("Owner Commission", "e.g. 2000", ownerController, Icons.percent_rounded),
                const SizedBox(height: 16),
                _buildInputField("Extra Expense", "e.g. 5000", extraExpenseController, Icons.money_off, isOptional: true, ),// optional parameter),
                const SizedBox(height: 16),
                _buildInputField("Total Amount", "Auto calculated", balanceController, Icons.account_balance_wallet_outlined),
                const SizedBox(height: 16),
                Card(

                  elevation: 2,
                  color: Theme.of(context).brightness==Brightness.dark?Colors.grey[900] :Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Calculation Steps:",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Q: Find Balance =",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "(${_indianFormat.format(rent)} + ${_indianFormat.format(security)} + "
                              "${_indianFormat.format(commission)} + ${_indianFormat.format(ownerSideCommission)} + ${_indianFormat.format(extra)})",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(height: 4),
                        Text(
                          "Rent + Security + Commission + OwnerCommission + Extra Expense",
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 6),

                        Text(
                          "= ${_indianFormat.format(addPart)}",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),

                        Row(
                          children: [
                            const Text(
                              "= ",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            AnimatedFlipCounter(
                              value: _finalBalance,
                              fractionDigits: 0,
                              duration: const Duration(milliseconds: 800),
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                              prefix: "₹ ",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInputField("Advance Payment", "e.g. 10000", advanceController, Icons.payments),



                const SizedBox(height: 80),

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          bottom: MediaQuery.of(context).viewInsets.bottom + 12,
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.save, color: Colors.white),
              label: const Text(
                "Update Bill",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isSubmitting ? Colors.grey : Colors.blueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _isSubmitting
                  ? null
                  : () {
                if (_formKey.currentState!.validate()) {
                  setState(() => _isSubmitting = true);

                  sendData();
                  print("Rent: ${rentController.text}");
                  print("Security: ${securityController.text}");
                  print("Tenant Commission: ${commissionController.text}");
                  print("Owner Commission: ${ownerController.text}");
                  print("Advance Payment: ${advanceController.text}");
                  print("Extra Expense: ${extraExpenseController.text}");
                  print("Total Balance: ${balanceController.text}");

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text(" ✅ Successfully Sent.")),
                  );

                  // Re-enable after 3 seconds
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      setState(() => _isSubmitting = false);
                    }
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
  Widget _buildInputField(
      String label,
      String hint,
      TextEditingController controller,
      IconData icon, {
        bool isOptional = false, // optional parameter for fields like Extra Expense
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Listener to format numbers in Indian format
    controller.addListener(() {
      String text = controller.text.replaceAll(',', ''); // Remove existing commas
      if (text.isEmpty) return;
      int? value = int.tryParse(text);
      if (value != null) {
        final formatted = NumberFormat("#,##,###").format(value);
        if (formatted != controller.text) {
          controller.value = TextEditingValue(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      }
    });

    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(14),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        validator: (value) {
          if (!isOptional && (value == null || value.isEmpty)) {
            return "$label is required"; // only validate if not optional
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
          hintStyle: TextStyle(
            color: isDark ? Colors.grey[600] : Colors.grey[500],
            fontWeight: FontWeight.w400,
          ),
          labelStyle: TextStyle(
            color: isDark ? Colors.grey[400] : Colors.grey[800],
            fontWeight: FontWeight.w600,
          ),
          filled: true,
          fillColor: isDark ? Colors.grey[900] : Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.blueAccent, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }



}
