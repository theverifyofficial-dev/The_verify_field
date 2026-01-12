import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Add_Rented_Flat/FieldWorker_Complete_Page.dart';

class TransactionDetailsPage extends StatefulWidget {
  final int propertyId;

  const TransactionDetailsPage({super.key, required this.propertyId});

  @override
  State<TransactionDetailsPage> createState() =>
      _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  late Future<_PageData> _future;

  @override
  void initState() {
    super.initState();
    _future = _loadAll();
  }

  // ================= API LOAD =================

  Future<_PageData> _loadAll() async {
    // ================== 1️⃣ PROPERTY LIST ==================
    final propUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_complete_page_for_admin.php";

    debugPrint("🟡 PROPERTY API URL: $propUrl");

    final propRes = await http.get(Uri.parse(propUrl));

    debugPrint("🟡 PROPERTY STATUS: ${propRes.statusCode}");
    debugPrint("🟡 PROPERTY RAW BODY: ${propRes.body}");

    final propJson = json.decode(propRes.body);

    if (propJson["success"] != true) {
      throw "❌ Property API failed";
    }

    final List props = propJson["data"];

    final property = props
        .map((e) => Property.fromJson(e))
        .firstWhere(
          (p) => p.id == widget.propertyId,
      orElse: () => throw "❌ Property not found for ID ${widget.propertyId}",
    );

    // 🔵 IMPORTANT PRINTS
    debugPrint("🟢 PROPERTY FOUND");
    debugPrint("🟢 PROPERTY ID: ${property.id}");
    debugPrint("🟢 PROPERTY SUBID: ${property.subid}");

    // ================== 2️⃣ PAYMENT HISTORY ==================
    final payUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_final_payment_api_for_complete.php?subid=${property.id}";

    debugPrint("🟡 PAYMENT API URL: $payUrl");

    final payRes = await http.get(Uri.parse(payUrl));

    debugPrint("🟡 PAYMENT STATUS: ${payRes.statusCode}");
    debugPrint("🟡 PAYMENT RAW BODY: ${payRes.body}");

    final payJson = json.decode(payRes.body);

    debugPrint(
      "🟢 PAYMENT JSON:\n${const JsonEncoder.withIndent('  ').convert(payJson)}",
    );

    final List<PaymentStepStatus> payments =
    payJson["success"] == true && payJson["data"] is List
        ? (payJson["data"] as List)
        .map((e) => PaymentStepStatus.fromJson(e))
        .toList()
        : [];

    debugPrint("🟢 PAYMENT COUNT: ${payments.length}");

    return _PageData(property, payments);
  }

  // ================= HELPERS =================

  double _d(String? v) =>
      double.tryParse(v?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '') ?? 0;

  String _cur(num v) =>
      NumberFormat.currency(symbol: "₹ ", decimalDigits: 0).format(v);

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Transaction Details"),
        actions: const [Icon(Icons.share)],
      ),
      body: FutureBuilder<_PageData>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text(snap.error.toString()));
          }

          final p = snap.data!.property;
          final payments = snap.data!.payments;

          final total = _d(p.totalBalance);
          final paid =
              _d(p.advancePayment) + _d(p.secondAmount) + _d(p.finalAmount);
          final remaining =
          (total - paid).clamp(0, double.infinity).toDouble();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== HEADER =====
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ID: #TRX-${p.id}",
                        style: const TextStyle(color: Colors.grey)),
                    _statusChip(remaining > 0),
                  ],
                ),

                const SizedBox(height: 12),

                // ===== PROPERTY CARD =====
                _propertyCard(p),

                const SizedBox(height: 20),

                // ===== PEOPLE =====
                _section("People Involved"),
                _person(p.ownerName, "Owner"),
                _person("Tenant", "UPI / Bank"),

                const SizedBox(height: 20),

                // ===== FINANCE =====
                _section("Financial Breakdown"),
                _financeCard(p, remaining),

                const SizedBox(height: 20),

                // ===== PAYMENT HISTORY =====
                _section("Payment History"),
                if (payments.isEmpty)
                  const Text("No payment history")
                else
                  Column(
                    children: [
                      ...payments.map(_paymentTile),

                      // use latest payment for calculations
                      _officeDetail(payments.last),
                      _commissionDistribution(payments.last),
                      _tenantBreakdown(p),
                      _ownerBreakdown(payments.last),
                    ],
                  ),


                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),

      // ===== BOTTOM =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.receipt),
                label: const Text("Billing"),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.payment),
                label: const Text("Pay Now"),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
  num _n(String? s) {
    if (s == null) return 0;
    return num.tryParse(
      s.replaceAll(RegExp(r'[^\d\.\-]'), ''),
    ) ?? 0;
  }
  Widget _box(String title, Color color, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: color,
              )),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
  Widget _officeDetail(PaymentStepStatus p) {
    return _box(
      "Office Detail",
      Colors.amber,
      [
        _row("Office Hold", _cur(_n(p.officeHold)), red: true),
        _row("Settlement Pool", _cur(_n(p.remainingHold)), green: true),
        _row("Company Commission", _cur(_n(p.companyKeepCommission))),
        _row(
          "Owner Final Share",
          _cur(_n(p.finalReceivedAmountOwner)),
          red: true,
        ),
        _row(
          "Balance Remaining",
          _cur(_n(p.remainingFinalBalance)),
        ),
      ],
    );
  }
  Widget _commissionDistribution(PaymentStepStatus p) {
    return _box(
      "Commission Distribution",
      Colors.deepOrange,
      [
        _row("Company Commission", _cur(_n(p.companyKeepCommission)), green: true),
        _row("GST (18%)", _cur(_n(p.officeGst)), red: true),
        _row("After GST", _cur(_n(p.afterGstAmount)), green: true),
        _row(
          "Office Share (50%)",
          _cur(_n(p.officeShareFiftyPercent)),
        ),
        _row(
          "Field Worker Share",
          _cur(_n(p.fieldWorkerShareFiftyPercent)),
        ),
      ],
    );
  }
  Widget _tenantBreakdown(Property p) {
    final a = _d(p.advancePayment);
    final b = _d(p.secondAmount);
    final c = _d(p.finalAmount);

    return _box(
      "Tenant Payment Detail",
      Colors.cyan,
      [
        _row("Advance Paid", _cur(a), red: true),
        _row("Second Payment", _cur(b), red: true),
        _row("Final Payment", _cur(c), red: true),
        _row("Total Paid", _cur(a + b + c), bold: true),
      ],
    );
  }
  Widget _ownerBreakdown(PaymentStepStatus p) {
    final s1 = _n(p.giveToOwnerAdvance);
    final s2 = _n(p.ownerReceivedPaymentInMid);
    final s3 = _n(p.finalReceivedAmountOwner);

    return _box(
      "Owner Payment Detail",
      Colors.green,
      [
        _row("Step 1 Received", _cur(s1), green: true),
        _row("Step 2 Received", _cur(s2), green: true),
        _row("Final Received", _cur(s3), green: true),
        _row(
          "Total Received",
          _cur(s1 + s2 + s3),
          bold: true,
          green: true,
        ),
      ],
    );
  }

  // ================= WIDGETS =================

  Widget _statusChip(bool pending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: pending
            ? Colors.purple.withOpacity(0.15)
            : Colors.green.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        pending ? "In Progress" : "Completed",
        style: TextStyle(
            color: pending ? Colors.purple : Colors.green,
            fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _propertyCard(Property p) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        children: [
          Image.network(
            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.propertyPhoto}",
            height: 160,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _info("Flat Number", p.flatNumber),
                _info("Location", p.locations),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _financeCard(Property p, double remaining) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _row("Rent", _cur(_d(p.rent))),
            _row("Security", _cur(_d(p.security))),
            _row("Tenant Commission", "+ ${_cur(_d(p.commission))}",
                green: true),
            _row("Owner Commission", "+ ${_cur(_d(p.ownerCommission))}",
                green: true),
            const Divider(),
            _row("Total Deal", _cur(_d(p.totalBalance)), bold: true),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: _row("Remaining Amount", _cur(remaining),
                  red: true, bold: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentTile(PaymentStepStatus p) {
    final done = p.statusThree != null && p.statusThree!.isNotEmpty;

    return ListTile(
      leading: Icon(done ? Icons.check_circle : Icons.timelapse,
          color: done ? Colors.green : Colors.orange),
      title: Text(done ? "Final Settlement" : "Payment"),
      subtitle: Text(p.dates ?? ""),
      trailing: Text(
        _cur(double.tryParse(p.totalPayTenant ?? "0") ?? 0),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _section(String title) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(title,
        style:
        const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
  );

  Widget _person(String name, String role) => Card(
    child: ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text("$name ($role)"),
      trailing: const Icon(Icons.call),
    ),
  );

  Widget _row(String l, String v,
      {bool green = false, bool red = false, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(l,
              style: TextStyle(
                  fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
          Text(v,
              style: TextStyle(
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
                color: green
                    ? Colors.green
                    : red
                    ? Colors.red
                    : null,
              )),
        ],
      ),
    );
  }

  Widget _info(String l, String v) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(l, style: const TextStyle(color: Colors.grey)),
      Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
    ],
  );
}

// ================= DATA HOLDER =================

class _PageData {
  final Property property;
  final List<PaymentStepStatus> payments;

  _PageData(this.property, this.payments);
}
class PaymentStepStatus {
  final int id;
  final int subid;

  // Status flags
  final String? statusFirst;
  final String? statusTwo;
  final String? statusThree;

  // Step 1
  final String tenantAdvance;
  final String giveToOwnerAdvance;
  final String officeHold;

  // Step 2
  final String? midPaymentToOwner;
  final String? ownerReceivedPaymentInMid;

  // Step 3
  final String? tenantPayLastAmount;
  final String? bothsideCompanyCommission;

  // Final calculations
  final String? remainingHold;
  final String? companyKeepCommission;
  final String? remainBalanceShareToOwner;
  final String? finalReceivedAmountOwner;
  final String? remainingFinalBalance;
  final String? totalPayTenant;

  // Extra distribution
  final String? visitorShare;
  final String? officeGst;
  final String? afterGstAmount;
  final String? officeShareFiftyPercent;
  final String? fieldWorkerShareFiftyPercent;

  // Dates
  final String? dates;
  final String? times;
  final String? dates2nd;
  final String? times2nd;
  final String? dates3rd;
  final String? times3rd;

  PaymentStepStatus({
    required this.id,
    required this.subid,
    required this.statusFirst,
    required this.statusTwo,
    required this.statusThree,
    required this.tenantAdvance,
    required this.giveToOwnerAdvance,
    required this.officeHold,
    required this.midPaymentToOwner,
    required this.ownerReceivedPaymentInMid,
    required this.tenantPayLastAmount,
    required this.bothsideCompanyCommission,
    required this.remainingHold,
    required this.companyKeepCommission,
    required this.remainBalanceShareToOwner,
    required this.finalReceivedAmountOwner,
    required this.remainingFinalBalance,
    required this.totalPayTenant,
    required this.visitorShare,
    required this.officeGst,
    required this.afterGstAmount,
    required this.officeShareFiftyPercent,
    required this.fieldWorkerShareFiftyPercent,
    required this.dates,
    required this.times,
    required this.dates2nd,
    required this.times2nd,
    required this.dates3rd,
    required this.times3rd,
  });

  factory PaymentStepStatus.fromJson(Map<String, dynamic> j) {
    int _i(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
    String? _s(dynamic v) => v?.toString();

    return PaymentStepStatus(
      id: _i(j['id']),
      subid: _i(j['subid']),

      statusFirst: _s(j['status_fist']),
      statusTwo: _s(j['status_tow']),
      statusThree: _s(j['status_three']),

      tenantAdvance: _s(j['tenant_advance']) ?? '0',
      giveToOwnerAdvance: _s(j['give_to_owner_advance']) ?? '0',
      officeHold: _s(j['office_hold']) ?? '0',

      midPaymentToOwner: _s(j['mid_payment_to_owner']),
      ownerReceivedPaymentInMid: _s(j['owner_reccived_payment_in_mid']),

      tenantPayLastAmount: _s(j['tenant_pay_last_amount']),
      bothsideCompanyCommission: _s(j['bothside_company_comition']),

      remainingHold: _s(j['remaining_hold']),
      companyKeepCommission: _s(j['company_keep_comition']),
      remainBalanceShareToOwner: _s(j['remain_balance_share_to_owner']),
      finalReceivedAmountOwner: _s(j['final_recived_amount_owner']),
      remainingFinalBalance: _s(j['remaing_final_balance']),
      totalPayTenant: _s(j['total_pay_tenant']),

      visitorShare: _s(j['visiter_share']),
      officeGst: _s(j['office_gst']),
      afterGstAmount: _s(j['after_gst_amount']),
      officeShareFiftyPercent: _s(j['office_share_fifty_percent']),
      fieldWorkerShareFiftyPercent:
      _s(j['field_workar_share_fifity_percent']),

      dates: _s(j['dates']),
      times: _s(j['times']),
      dates2nd: _s(j['dates_2nd']),
      times2nd: _s(j['times_2nd']),
      dates3rd: _s(j['dates_3rd']),
      times3rd: _s(j['times_3rd']),
    );
  }
}