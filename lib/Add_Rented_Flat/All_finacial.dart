import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Property {
  final int id;
  final String currentDates;
  final String availableDate;
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;

  Property({
    required this.id,
    required this.currentDates,
    required this.availableDate,
    required this.rent,
    required this.security,
    required this.commission,
    required this.extraExpense,
    required this.advancePayment,
    required this.totalBalance,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: int.tryParse(json["P_id"].toString()) ?? 0,
      currentDates: json["current_dates"] ?? "",
      availableDate: json["available_date"] ?? "",
      rent: json["Rent"] ?? "0",
      security: json["Security"] ?? "0",
      commission: json["Commission"] ?? "0",
      extraExpense: json["Extra_Expense"] ?? "0",
      advancePayment: json["Advance_Payment"] ?? "0",
      totalBalance: json["Total_Balance"] ?? "0",
    );
  }
}

class TenantPaymentFlowPage extends StatefulWidget {
  final String propertyId;

  const TenantPaymentFlowPage({super.key, required this.propertyId});

  @override
  State<TenantPaymentFlowPage> createState() => _TenantPaymentFlowPageState();
}

class _TenantPaymentFlowPageState extends State<TenantPaymentFlowPage> {
  List<Property> properties = [];
  int currentIndex = 0;
  bool loading = true;

  int step = 1;
  int tenantPaid = 0;
  int officeHold = 0;
  int ownerShare = 0;

  late int rent;
  late int security;
  late int commission;
  late int extraExpense;
  late int advancePayment;
  late int totalBalance;

  int remainingAmount = 0; // decreases step by step

  TextEditingController amountController = TextEditingController();
  String? userNumber;
  String? errorMessage;

  // Map to track keys that changed for highlighting
  Map<String, bool> highlightKeys = {};

  @override
  void initState() {
    super.initState();
    loadUserNumberAndFetchProperties();
  }

  Future<void> loadUserNumberAndFetchProperties() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userNumber = prefs.getString('number') ?? "";
    if (userNumber == null || userNumber!.isEmpty) {
      setState(() {
        errorMessage = "Field worker number not found!";
        loading = false;
      });
      return;
    }
    await _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    try {
      final url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_fieldworkar.php?field_workar_number=$userNumber"
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["success"] == true) {
          final data = decoded["data"] as List<dynamic>;
          setState(() {
            properties = data.map((e) => Property.fromJson(e)).toList().reversed.toList();
            if (properties.isNotEmpty) _loadProperty(properties[currentIndex]);
            loading = false;
          });
        } else {
          setState(() {
            loading = false;
            errorMessage = decoded["message"] ?? "No properties found";
          });
        }
      } else {
        setState(() {
          loading = false;
          errorMessage = "Failed to fetch properties!";
        });
      }
    } catch (e) {
      setState(() {
        loading = false;
        errorMessage = "Error: $e";
      });
    }
  }

  void _loadProperty(Property property) {
    rent = int.tryParse(property.rent) ?? 0;
    security = int.tryParse(property.security) ?? 0;
    commission = int.tryParse(property.commission) ?? 0;
    extraExpense = int.tryParse(property.extraExpense) ?? 0;
    advancePayment = int.tryParse(property.advancePayment) ?? 0;
    totalBalance = int.tryParse(property.totalBalance) ?? 0;

    tenantPaid = 0;
    officeHold = 0;
    ownerShare = 0;
    step = 1;
    amountController.clear();

    remainingAmount = rent + security + commission + extraExpense;

    highlightKeys.clear(); // reset highlights for new property
  }

  void _highlight(String key) {
    setState(() => highlightKeys[key] = true);
    Timer(const Duration(seconds: 2), () {
      setState(() => highlightKeys[key] = false);
    });
  }

  List<Map<String, int>> paymentLog = [];

  void completeStep() {
    int enteredAmount = int.tryParse(amountController.text) ?? 0;
    if (enteredAmount <= 0) return;
    if (enteredAmount > remainingAmount) enteredAmount = remainingAmount;

    setState(() {
      int tenantStep = tenantPaid;
      int ownerStep = ownerShare;
      int officeStep = officeHold;

      switch (step) {
        case 1: // Advance
          tenantPaid += enteredAmount;
          ownerShare += enteredAmount ~/ 2;
          officeHold += enteredAmount - (enteredAmount ~/ 2);
          break;
        case 2: // Mid
          tenantPaid += enteredAmount;
          ownerShare += enteredAmount;
          break;
        case 3: // Final
          tenantPaid += enteredAmount;
          int remaining = remainingAmount - enteredAmount;
          int totalCommission = commission * 2;
          int ownerFinalShare = remaining - totalCommission;
          officeHold += remaining - ownerFinalShare;
          ownerShare += ownerFinalShare;
          break;
      }

      // Highlight changed values (text color)
      highlightKeys["Tenant Paid"] = tenantStep != tenantPaid;
      highlightKeys["Owner Share"] = ownerStep != ownerShare;
      highlightKeys["Office Hold"] = officeStep != officeHold;
      highlightKeys["Remaining Amount"] = true;

      // Add step to payment log
      paymentLog.add({
        "Step": step,
        "Tenant Paid": tenantPaid,
        "Owner Share": ownerShare,
        "Office Hold": officeHold,
        "Remaining": remainingAmount - enteredAmount
      });

      remainingAmount -= enteredAmount;
      if (step < 3) step++;
      amountController.clear();

      // Remove highlight after 2 seconds
      Timer(const Duration(seconds: 2), () {
        setState(() {
          highlightKeys["Tenant Paid"] = false;
          highlightKeys["Owner Share"] = false;
          highlightKeys["Office Hold"] = false;
          highlightKeys["Remaining Amount"] = false;
        });
      });
    });
  }

  void nextProperty() {
    if (currentIndex < properties.length - 1) {
      setState(() {
        currentIndex++;
        _loadProperty(properties[currentIndex]);
      });
    }
  }

  void previousProperty() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _loadProperty(properties[currentIndex]);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));
    if (properties.isEmpty) return const Scaffold(body: Center(child: Text("No properties found")));

    final property = properties[currentIndex];

    Color _getRowColor(String key) =>
        highlightKeys[key] == true ? Colors.yellow.shade300 : Colors.transparent;

    return Scaffold(
      appBar: AppBar(
        title: Text("Tenant Payment - Flat ${currentIndex + 1}/${properties.length}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (remainingAmount > 0)
              Text("Total Amount Remaining: ₹$remainingAmount",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            if (step <= 3 && remainingAmount > 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Step $step: ${step == 1 ? 'Advance' : step == 2 ? 'Mid' : 'Final'} Payment",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter Amount",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildDetailRow("Tenant Paid", tenantPaid, highlight: highlightKeys["Tenant Paid"] ?? false),
                  _buildDetailRow("Owner Share", ownerShare, highlight: highlightKeys["Owner Share"] ?? false),
                  _buildDetailRow("Office Hold", officeHold, highlight: highlightKeys["Office Hold"] ?? false),
                  _buildDetailRow("Remaining Amount", remainingAmount, highlight: highlightKeys["Remaining Amount"] ?? false),

                  const Divider(height: 30, thickness: 1),

                  // Show payment log below
                  if (paymentLog.isNotEmpty)
                    ...paymentLog.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          "Step ${e['Step']}: Tenant Paid ₹${e['Tenant Paid']}, Owner Share ₹${e['Owner Share']}, Office Hold ₹${e['Office Hold']}, Remaining ₹${e['Remaining']}",
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500,),
                        ),
                      );
                    }).toList(),

                  const Divider(height: 30, thickness: 1),

                  // Static property info
                  _buildDetailRow("Rent", rent),
                  _buildDetailRow("Security", security),
                  _buildDetailRow("Commission", commission),
                  _buildDetailRow("Extra Expense", extraExpense),
                  _buildDetailRow("Advance Payment", advancePayment),
                  _buildDetailRow("Total Balance", totalBalance),
                  _buildDetailRow("Current Date", property.currentDates),
                  _buildDetailRow("Available Date", property.availableDate),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentIndex > 0 ? previousProperty : null,
                  child: const Text("Previous"),
                ),
                ElevatedButton(
                  onPressed: step <= 3 && remainingAmount > 0 ? completeStep : () {
                    if (currentIndex < properties.length - 1) nextProperty();
                  },
                  child: Text(currentIndex < properties.length - 1 ? "Next" : "Finish"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildDetailRow(String label, dynamic value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          Text(
            "₹$value",
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: highlight ? Colors.red : Theme.of(context).brightness==Brightness.dark? Colors.white:Colors.black),
          ),
        ],
      ),
    );
  }
}
