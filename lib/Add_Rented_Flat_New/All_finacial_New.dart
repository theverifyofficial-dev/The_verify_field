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
      currentDates: json["current_dates"]?.toString() ?? "",
      availableDate: json["available_date"]?.toString() ?? "",
      rent: json["Rent"]?.toString() ?? "0",
      security: json["Security"]?.toString() ?? "0",
      commission: json["Commission"]?.toString() ?? "0",
      extraExpense: json["Extra_Expense"]?.toString() ?? "0",
      advancePayment: json["Advance_Payment"]?.toString() ?? "0",
      totalBalance: json["Total_Balance"]?.toString() ?? "0",
    );
  }
}

class TenantPaymentFlowPageNew extends StatefulWidget {
  final String propertyId;

  const TenantPaymentFlowPageNew({super.key, required this.propertyId});

  @override
  State<TenantPaymentFlowPageNew> createState() => _TenantPaymentFlowPageNewState();
}

class _TenantPaymentFlowPageNewState extends State<TenantPaymentFlowPageNew> {
  List<Property> properties = [];
  int currentIndex = 0;
  bool loading = true;

  // Step state
  int step = 1;
  int tenantPaid = 0;
  int officeHold = 0;
  int ownerShare = 0;

  // Inputs from API
  late int rent;
  late int security;
  late int commission;     // company commission due from tenant (fixed)
  late int extraExpense;   // also billed to tenant (treated as commission)
  late int advancePayment; // display only
  late int totalBalance;   // display only

  // Derived totals
  int remainingAmount = 0;     // decreases after each tenant payment
  int tenantTotalDue = 0;      // rent + security + commission + extraExpense
  int settlementPool = 0;      // officeHold + step3 final at settlement time (or preview)
  int companyKeepNow = 0;      // company take from pool (preview/final)
  int ownerFinalNow = 0;       // owner from pool now (preview/final)
  int ownerReceivedTotal = 0;  // total owner receipts across steps
  int completionPct = 0;       // paid / total due

  // For Step 3 two-phase input
  bool step3AmountEntered = false;

  // UI controllers
  final TextEditingController amountController = TextEditingController();
  final TextEditingController ownerCommissionController = TextEditingController(); // optional owner-side commission
  final TextEditingController tenantCommissionController = TextEditingController(); // optional override for company due

  String? userNumber;
  String? errorMessage;

  // Highlight helpers
  Map<String, bool> highlightKeys = {};
  void _highlight(String key) {
    setState(() => highlightKeys[key] = true);
    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => highlightKeys[key] = false);
    });
  }

  // Log
  final List<Map<String, dynamic>> paymentLog = [];


  @override
  void initState() {
    super.initState();
    loadUserNumberAndFetchProperties();
  }

  Future<void> loadUserNumberAndFetchProperties() async {
    final prefs = await SharedPreferences.getInstance();
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
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_fieldworkar.php?field_workar_number=$userNumber",
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

  void _loadProperty(Property p) {
    rent           = int.tryParse(p.rent) ?? 0;
    security       = int.tryParse(p.security) ?? 0;
    commission     = int.tryParse(p.commission) ?? 0;
    extraExpense   = int.tryParse(p.extraExpense) ?? 0;
    advancePayment = int.tryParse(p.advancePayment) ?? 0;
    totalBalance   = int.tryParse(p.totalBalance) ?? 0;

    // reset step totals
    tenantPaid = 0;
    officeHold = 0;
    ownerShare = 0;
    step = 1;
    step3AmountEntered = false;
    amountController.clear();
    ownerCommissionController.clear();
    tenantCommissionController.clear();

    // derived
    tenantTotalDue = rent + security + commission + extraExpense;
    remainingAmount = tenantTotalDue;

    // clear ui state
    highlightKeys.clear();
    paymentLog.clear();

    _recomputeSummary(); // initialize preview fields
  }

  // Recompute summary with preview or final numbers
  void _recomputeSummary({int s3JustPaid = 0, bool finalizeNow = false}) {
    // totals
    tenantTotalDue = rent + security + commission + extraExpense;
    final paid = tenantPaid;
    remainingAmount = (tenantTotalDue - paid).clamp(0, tenantTotalDue);

    // live pool: office hold + any just-entered s3 amount (for preview)
    settlementPool = officeHold + s3JustPaid;

    // company due: either override from tenantCommissionController or default (commission + extraExpense)
    final overrideCompanyDue = int.tryParse(tenantCommissionController.text) ?? 0;
    final companyDueTotal = overrideCompanyDue > 0 ? overrideCompanyDue : (commission + extraExpense);

    final ownerCommission = int.tryParse(ownerCommissionController.text) ?? 0;
    final maxCompanyCanTake = (settlementPool - ownerCommission).clamp(0, settlementPool);

    if (finalizeNow) {
      // lock the numbers
      companyKeepNow = companyDueTotal <= maxCompanyCanTake ? companyDueTotal : maxCompanyCanTake;
      ownerFinalNow  = (settlementPool - companyKeepNow - ownerCommission).clamp(0, settlementPool);
      ownerReceivedTotal = ownerShare + ownerFinalNow;

      // consume the pool
      settlementPool = 0;
      officeHold = 0;
      remainingAmount = 0;
    } else {
      // preview only
      companyKeepNow = companyDueTotal <= maxCompanyCanTake ? companyDueTotal : maxCompanyCanTake;
      ownerFinalNow  = (settlementPool - companyKeepNow - ownerCommission).clamp(0, settlementPool);
      ownerReceivedTotal = ownerShare + ownerFinalNow;
    }

    completionPct = tenantTotalDue > 0 ? ((paid * 100) ~/ tenantTotalDue) : 0;
    setState(() {});
  }

  void completeStep() {
    // If we are at Step 3 and remaining is already zero, allow settle directly.
    _pushSnapshot();

    if (step == 3 && remainingAmount == 0 && !step3AmountEntered) {
      _recomputeSummary(s3JustPaid: 0, finalizeNow: true);

      // apply owner final to ownerShare
      ownerShare += ownerFinalNow;

      paymentLog.add({
        "Step": 3,
        "Tenant Paid": tenantPaid,
        "Owner Share": ownerShare,
        "Office Hold": officeHold,
        "Remaining": remainingAmount,
      });

      step = 4;
      _highlight("Tenant Paid");
      _highlight("Owner Share");
      _highlight("Remaining Amount");
      return;
    }

    final enteredAmount = int.tryParse(amountController.text) ?? 0;

    // Second press in Step 3: finalize settlement using pool = officeHold + last entered s3
    if (step == 3 && step3AmountEntered == true) {
      _recomputeSummary(s3JustPaid: 0, finalizeNow: true);

      // apply owner final to ownerShare
      ownerShare += ownerFinalNow;

      paymentLog.add({
        "Step": 3,
        "Tenant Paid": tenantPaid,
        "Owner Share": ownerShare,
        "Office Hold": officeHold,
        "Remaining": remainingAmount,
      });

      step3AmountEntered = false;
      amountController.clear();

      step = 4;
      _highlight("Tenant Paid");
      _highlight("Owner Share");
      _highlight("Remaining Amount");
      return;
    }

    // For Step 1/2 or Step 3 first press, need a valid amount
    if (enteredAmount <= 0 && !(step == 3 && remainingAmount == 0)) return;

    // Cache old for highlight comparison
    final prevTenant = tenantPaid;
    final prevOwner = ownerShare;
    final prevHold = officeHold;

    if (step == 1) {
      // 50/50 split
      final giveOwner = enteredAmount ~/ 2;
      final holdAmt   = enteredAmount - giveOwner;

      tenantPaid   += enteredAmount;
      ownerShare   += giveOwner;
      officeHold   += holdAmt;
      remainingAmount -= enteredAmount;

      paymentLog.add({
        "Step": 1,
        "Tenant Paid": tenantPaid,
        "Owner Share": ownerShare,
        "Office Hold": officeHold,
        "Remaining": remainingAmount,
      });

      step = 2;
      amountController.clear();
      _recomputeSummary();
    } else if (step == 2) {
      // Fully to owner
      tenantPaid += enteredAmount;
      ownerShare += enteredAmount;
      remainingAmount -= enteredAmount;

      paymentLog.add({
        "Step": 2,
        "Tenant Paid": tenantPaid,
        "Owner Share": ownerShare,
        "Office Hold": officeHold,
        "Remaining": remainingAmount,
      });

      step = 3;
      amountController.clear();
      _recomputeSummary();
    }
    else if (step == 3) {
      // Step 3: Final settlement
      tenantPaid += enteredAmount;
      remainingAmount -= enteredAmount;

      // Pool = final payment + any hold
      final prevHold = officeHold;
      final pool = prevHold + enteredAmount;

      final ownerCommission = int.tryParse(ownerCommissionController.text) ?? 0;
      final tenantCommissionOverride = int.tryParse(tenantCommissionController.text) ?? 0;

      // company due = override or (commission + extraExpense)
      final companyDueTotal = tenantCommissionOverride > 0
          ? tenantCommissionOverride
          : (commission + extraExpense);

      final maxCompanyCanTake = (pool - ownerCommission).clamp(0, pool);
      companyKeepNow = companyDueTotal <= maxCompanyCanTake ? companyDueTotal : maxCompanyCanTake;

      ownerFinalNow = (pool - companyKeepNow - ownerCommission).clamp(0, pool);
      ownerShare += ownerFinalNow;

      ownerReceivedTotal = ownerShare;
      settlementPool = 0;
      officeHold = 0;
      remainingAmount = 0;

      String fmt(num? n) => "₹${(n ?? 0)}";

      paymentLog.add({
        "Step": 3,
        "Tenant Pays (final)": fmt(enteredAmount),
        "Hold Brought Forward": fmt(prevHold),
        "Settlement Pool": fmt(pool),
        "Settlement Pool Detail": "${fmt(pool)} (${fmt(enteredAmount)} from tenant + ${fmt(prevHold)} from hold)",
        "Company Keep (Total Commission)": fmt(companyKeepNow),
        "Owner Receives Now": fmt(ownerFinalNow),
        "Final Owner Total": fmt(ownerShare),
        "Tenant Total Paid": fmt(tenantPaid),
        "Remaining": fmt(remainingAmount),
      });


      step = 4;
      amountController.clear();

      tenantTotalDue = rent + security + commission + extraExpense;
      completionPct = tenantTotalDue > 0 ? ((tenantPaid * 100) ~/ tenantTotalDue) : 0;

      _highlight("Tenant Paid");
      _highlight("Owner Share");
      _highlight("Remaining Amount");

      setState(() {});
    }

    // Highlights
    if (prevTenant != tenantPaid) _highlight("Tenant Paid");
    if (prevOwner  != ownerShare) _highlight("Owner Share");
    if (prevHold   != officeHold) _highlight("Office Hold");
    _highlight("Remaining Amount");
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
  String _moneyOrZero(dynamic v) {
    if (v == null) return "0";            // missing → 0
    if (v is num) return v.toString();    // 123 → "123"
    if (v is String) {
      // if it's already like "₹8000" or "8000", keep digits
      final m = RegExp(r'\d+').firstMatch(v.replaceAll(',', ''));
      return m != null ? m.group(0)! : "0";
    }
    return "0";
  }
// --- Undo history (one-step-back) ---
  final List<Map<String, dynamic>> _history = [];

  bool get _canGoBack => _history.isNotEmpty;

  Map<String, dynamic> _makeSnapshot() {
    return {
      // core step state
      "step": step,
      "tenantPaid": tenantPaid,
      "officeHold": officeHold,
      "ownerShare": ownerShare,

      // derived
      "remainingAmount": remainingAmount,
      "tenantTotalDue": tenantTotalDue,
      "settlementPool": settlementPool,
      "companyKeepNow": companyKeepNow,
      "ownerFinalNow": ownerFinalNow,
      "ownerReceivedTotal": ownerReceivedTotal,
      "completionPct": completionPct,

      // flags and inputs
      "step3AmountEntered": step3AmountEntered,
      "ownerCommissionText": ownerCommissionController.text,
      "tenantCommissionText": tenantCommissionController.text,

      // log deep copy
      "paymentLog": paymentLog.map((e) => Map<String, dynamic>.from(e)).toList(),
    };
  }

  void _pushSnapshot() {
    _history.add(_makeSnapshot());
  }

  void _restoreSnapshot(Map<String, dynamic> s) {
    step                 = s["step"] ?? step;
    tenantPaid           = s["tenantPaid"] ?? tenantPaid;
    officeHold           = s["officeHold"] ?? officeHold;
    ownerShare           = s["ownerShare"] ?? ownerShare;

    remainingAmount      = s["remainingAmount"] ?? remainingAmount;
    tenantTotalDue       = s["tenantTotalDue"] ?? tenantTotalDue;
    settlementPool       = s["settlementPool"] ?? settlementPool;
    companyKeepNow       = s["companyKeepNow"] ?? companyKeepNow;
    ownerFinalNow        = s["ownerFinalNow"] ?? ownerFinalNow;
    ownerReceivedTotal   = s["ownerReceivedTotal"] ?? ownerReceivedTotal;
    completionPct        = s["completionPct"] ?? completionPct;

    step3AmountEntered   = s["step3AmountEntered"] ?? false;
    ownerCommissionController.text  = (s["ownerCommissionText"] ?? "").toString();
    tenantCommissionController.text = (s["tenantCommissionText"] ?? "").toString();

    paymentLog
      ..clear()
      ..addAll((s["paymentLog"] as List).map((e) => Map<String, dynamic>.from(e)));

    setState(() {});
  }

  void _undoOneStep() {
    if (_history.isEmpty) return;
    final snap = _history.removeLast();
    _restoreSnapshot(snap);
    // flash the main rows so the user sees we jumped back
    _highlight("Tenant Paid");
    _highlight("Owner Share");
    _highlight("Office Hold");
    _highlight("Remaining Amount");
  }
  late final enteredAmount = int.tryParse(amountController.text) ?? 0;

  @override
  Widget build(BuildContext context) {
    if (loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (errorMessage != null) return Scaffold(body: Center(child: Text(errorMessage!)));
    if (properties.isEmpty) return const Scaffold(body: Center(child: Text("No properties found")));
    final totalCompanyCommission = commission + extraExpense;

    final property = properties[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Tenant Payment - Flat ${currentIndex + 1}/${properties.length}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Total Due: ₹$tenantTotalDue    •    Remaining: ₹$remainingAmount",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            if (step <= 3)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Step $step: ${step == 1 ? 'Advance' : step == 2 ? 'Mid' : step3AmountEntered ? 'Final (Settle)' : 'Final (Pay)'}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  // Amount field (hide only during Step 3 after first press)
                  if (!(step == 3 && step3AmountEntered))
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Enter Amount",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                  // Commission fields should ALWAYS be visible in Step 3
                  if (step == 3) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: ownerCommissionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Owner Commission (optional)",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (_) {
                        // live preview updates when editing fields
                        _recomputeSummary(s3JustPaid: step3AmountEntered ? 0 : 0, finalizeNow: false);
                      },
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: tenantCommissionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Tenant Commission (override, optional)",
                        helperText: "Leave blank to use Commission + Extra Expense",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onChanged: (_) {
                        _recomputeSummary(s3JustPaid: step3AmountEntered ? 0 : 0, finalizeNow: false);
                      },
                    ),
                  ],
                  const SizedBox(height: 10),
                ],
              ),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton.icon(
                  onPressed: _canGoBack ? _undoOneStep : null,
                  icon: const Icon(Icons.undo, size: 18),
                  label: const Text("Back"),
                ),
                ElevatedButton(
                  onPressed: step <= 3 ? completeStep : null,
                  child: Text(
                    step < 3
                        ? "Save & Next"
                        : (step3AmountEntered || remainingAmount == 0 ? "Settle Now" : "Save Final"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Expanded(
              child: ListView(
                children: [

                  _buildDetailRow("Tenant Paid", tenantPaid, highlight: highlightKeys["Tenant Paid"] ?? false),
                  _buildDetailRow("Owner Share", ownerShare, highlight: highlightKeys["Owner Share"] ?? false),
                  _buildDetailRow("Office Hold", officeHold, highlight: highlightKeys["Office Hold"] ?? false),
                  _buildDetailRow("Remaining Amount", remainingAmount, highlight: highlightKeys["Remaining Amount"] ?? false),
                  const Divider(height: 28, thickness: 1),

                  const Text("Summary", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),

                  _buildDetailRow("Total Company Commission", (totalCompanyCommission)),
                  _buildDetailRow("Total (Tenant)", tenantTotalDue),
                  _buildDetailRow("Tenant Commission Total", (totalCompanyCommission)),
                  _buildDetailRow("Settlement Pool", settlementPool),
                  _buildDetailRow("Company Keep (now)", companyKeepNow),
                  _buildDetailRow("Owner Final (now)", ownerFinalNow),
                  _buildDetailRow("Owner Received (total)", ownerReceivedTotal),
                  // _buildDetailRow("Completion %", completionPct),

                  const Divider(height: 28, thickness: 1),

                  if (paymentLog.isNotEmpty)
                    const Text("Log", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  if (paymentLog.isNotEmpty)
                    ...paymentLog.map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        "Step ${e['Step'] ?? ''}: "
                            "Tenant ₹${_moneyOrZero(e['Tenant Paid'])} | "
                            "Owner ₹${_moneyOrZero(e['Owner Share'])} | "
                            "Hold ₹${_moneyOrZero(e['Office Hold'])} | "
                            "Rem ₹${_moneyOrZero(e['Remaining'])}",
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    )),

                  const Divider(height: 28, thickness: 1),

                  const Text("Property", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  _buildDetailRow("Rent", rent),
                  _buildDetailRow("Security", security),
                  _buildDetailRow("Commission", commission),
                  _buildDetailRow("Extra Expense", extraExpense),
                  _buildDetailRow("Advance Payment", advancePayment),
                  _buildDetailRow("Total Balance", property.totalBalance),
                  _buildDetailRow("Current Date", property.currentDates),
                  _buildDetailRow("Available Date", property.availableDate),
                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(onPressed: currentIndex > 0 ? previousProperty : null, child: const Text("Previous")),
                ElevatedButton(
                  onPressed: step > 3 && currentIndex < properties.length - 1 ? nextProperty : null,
                  child: const Text("Next"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, dynamic value, {bool highlight = false}) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white
        : Colors.black;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: highlight ? Colors.orangeAccent : baseColor,
            ),
            child: Text("₹$value"),
          ),
        ],
      ),
    );
  }
}
