import 'dart:convert';
import 'dart:ui' show FontFeature; // for tabular figures in amounts
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ---------- Model ----------
class Property {
  final int id;
  final String rent;
  final String security;
  final String commission;     // tenant-side commission
  final String extraExpense;   // not in Total Due (unless you decide to)
  final String locations;
  final String flatNumber;

  Property({
    required this.id,
    required this.rent,
    required this.security,
    required this.commission,
    required this.extraExpense,
    required this.locations,
    required this.flatNumber,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    double _toD(dynamic v) => double.tryParse(v?.toString() ?? "0") ?? 0;
    // Defensive toString() on strings you actually surface
    return Property(
      id: int.tryParse(json["P_id"]?.toString() ?? "0") ?? 0,
      rent: (_toD(json["Rent"])).toStringAsFixed(0),
      security: (_toD(json["Security"])).toStringAsFixed(0),
      commission: (_toD(json["Commission"])).toStringAsFixed(0),
      extraExpense: (_toD(json["Extra_Expense"])).toStringAsFixed(0),
      locations: json["locations"]?.toString() ?? "",
      flatNumber: json["Flat_number"]?.toString() ?? "",
    );
  }
}

// ---------- Screen ----------
class PropertyCalculate extends StatefulWidget {
  final int propertyId;
  const PropertyCalculate({super.key, required this.propertyId});

  @override
  State<PropertyCalculate> createState() => _PropertyCalculateState();
}

class _PropertyCalculateState extends State<PropertyCalculate> {
  late Future<Property> _futureProperty;

  // Step inputs
  final s1TenantCtl = TextEditingController();
  final s1GiveCtl   = TextEditingController();
  final s1HoldCtl   = TextEditingController(); // auto-filled = s1Tenant - s1Give
  final s2TenantCtl = TextEditingController();
  final s3TenantCtl = TextEditingController();
  final s3OwnerCommCtl = TextEditingController(); // extra owner-side commission

  // Lock flags
  bool s1Saved = false;
  bool s2Saved = false;
  bool s3Saved = false;

  // Derived and running totals (base amounts)
  double rent = 0, security = 0, tenantComm = 0, extraExpense = 0;
  double totalDue = 0; // rent + security + tenantComm (matches your flow)

  // step totals
  double s1Tenant = 0, s1Give = 0, s1Hold = 0;
  double s2Tenant = 0;
  double s3Tenant = 0;
  double ownerComm = 0;

  // close-out
  double settlementPool = 0;
  double companyCommissionTotal = 0;
  double companyKeepNow = 0;
  double ownerFinalNow = 0;

  // global running
  double tenantPaid = 0;
  double ownerReceivedTotal = 0;
  double remaining = 0;

  @override
  void initState() {
    super.initState();
    _futureProperty = _fetchPropertyById(widget.propertyId);

    // user input listeners
    s1TenantCtl.addListener(_recalc);
    s1GiveCtl.addListener(_recalc);
    s2TenantCtl.addListener(_recalc);
    s3TenantCtl.addListener(_recalc);
    s3OwnerCommCtl.addListener(_recalc);

    // keep Office Hold auto
    s1TenantCtl.addListener(_syncHold);
    s1GiveCtl.addListener(_syncHold);
  }

  @override
  void dispose() {
    s1TenantCtl.dispose();
    s1GiveCtl.dispose();
    s1HoldCtl.dispose();
    s2TenantCtl.dispose();
    s3TenantCtl.dispose();
    s3OwnerCommCtl.dispose();
    super.dispose();
  }

  Future<Property> _fetchPropertyById(int id) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_admin.php",
    );
    final res = await http.get(url);
    if (res.statusCode != 200) {
      throw Exception("Failed to load data");
    }
    final body = json.decode(res.body);
    if (body["success"] != true) {
      throw Exception(body["message"] ?? "API error");
    }
    final List data = body["data"] as List;
    final list = data.map((e) => Property.fromJson(e)).toList();
    final match = list.firstWhere(
          (p) => p.id == id,
      orElse: () => throw Exception("Property $id not found"),
    );

    // Seed base amounts
    rent       = _p(match.rent);
    security   = _p(match.security);
    tenantComm = _p(match.commission);
    extraExpense = _p(match.extraExpense);

    // Your flow: Total Due = rent + security + tenantCommission (not extra)
    totalDue = rent + security + tenantComm;

    // initial UI sync
    _recalc();

    return match;
  }

  double _p(String v) => double.tryParse(v.replaceAll(',', '').trim()) ?? 0;
  double _pc(TextEditingController c) => double.tryParse(c.text) ?? 0;
  String _cur(num n) => "₹${n.toStringAsFixed(0)}";

  void _syncHold() {
    // Office hold is derived: S1Hold = S1Tenant − S1Give. Keep field in sync while editing.
    final t = _pc(s1TenantCtl);
    final g = _pc(s1GiveCtl);
    final h = (t - g).clamp(0, double.infinity);
    final newText = h == h.roundToDouble() ? h.toStringAsFixed(0) : h.toStringAsFixed(2);
    if (s1HoldCtl.text != newText) {
      s1HoldCtl.text = newText;
    }
  }

  void _recalc() {
    // Respect locks
    s1Tenant = s1Saved ? s1Tenant : _pc(s1TenantCtl);
    s1Give   = s1Saved ? s1Give   : _pc(s1GiveCtl);
    s1Hold   = s1Saved ? s1Hold   : (s1Tenant - s1Give).clamp(0, double.infinity);

    s2Tenant = s2Saved ? s2Tenant : _pc(s2TenantCtl);
    s3Tenant = s3Saved ? s3Tenant : _pc(s3TenantCtl);

    // ---------- the only part that really matters ----------
    // Pool = office hold + final tenant payment
    settlementPool = s1Hold + s3Tenant;

    // TOTAL company commission:
    // If user entered a total, use it. Otherwise default to tenant commission only.
    final overrideTotal = _pc(s3CompanyTotalCtl);
    companyCommissionTotal = overrideTotal > 0 ? overrideTotal : tenantComm;

    // Company keeps up to the pool
    companyKeepNow = companyCommissionTotal <= settlementPool
        ? companyCommissionTotal
        : settlementPool;

    // Owner gets what remains of the pool
    ownerFinalNow = (settlementPool - companyKeepNow).clamp(0, double.infinity);

    // Running sums
    tenantPaid = s1Tenant + s2Tenant + s3Tenant;
    ownerReceivedTotal = s1Give + s2Tenant + ownerFinalNow;

    // Remaining vs tenant’s bill (rent + security + tenant commission only)
    totalDue = rent + security + tenantComm;
    remaining = (totalDue - tenantPaid).clamp(0, double.infinity);

    if (mounted) setState(() {});
  }

  void _saveStep1() {
    final t = _pc(s1TenantCtl);
    final g = _pc(s1GiveCtl);
    if (t < 0 || g < 0 || g > t) {
      _toast(context, "Step 1: Give to Owner cannot exceed Tenant pays.");
      return;
    }
    s1Saved = true;
    // freeze values
    s1Tenant = t;
    s1Give   = g;
    s1Hold   = (t - g).clamp(0, double.infinity);
    _recalc();
  }

  void _saveStep2() {
    if (!s1Saved) {
      _toast(context, "Save Step 1 first.");
      return;
    }
    final t = _pc(s2TenantCtl);
    if (t <= 0) {
      _toast(context, "Step 2: Enter a positive amount.");
      return;
    }
    s2Saved = true;
    s2Tenant = t;
    _recalc();
  }

  void _saveFinal() {
    if (!s1Saved) {
      _toast(context, "Save Step 1 first.");
      return;
    }
    final t = _pc(s3TenantCtl);
    if (t < 0) {
      _toast(context, "Step 3: Invalid amount.");
      return;
    }
    s3Saved = true;
    s3Tenant = t;
    ownerComm = _pc(s3OwnerCommCtl);
    _recalc();
    // if you want to auto-close page after final:
    // Navigator.of(context).pop(true);
  }
  final s3CompanyTotalCtl = TextEditingController(); // TOTAL company commission override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Billing"),
      ),
      body: FutureBuilder<Property>(
        future: _futureProperty,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }
          final property = snap.data!;

          final poolDetail =
              "${_cur(settlementPool)} = ${_cur(s3Tenant)} (final) + ${_cur(s1Hold)} (hold)";

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 40),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    "${property.locations} • ${property.flatNumber}",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Total Due: ${_cur(totalDue)}",
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  // Steps grid (responsive)
                  LayoutBuilder(
                    builder: (ctx, cons) {
                      final w = cons.maxWidth;
                      final threeCol = w >= 960;
                      final itemW = threeCol ? (w - 24) / 3 : w;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          SizedBox(width: itemW, child: _panel(
                            title: "Step 1 • Advance",
                            body: Column(
                              children: [
                                _tf("Tenant pays", s1TenantCtl, enabled: !s1Saved),
                                _tf("Give to Owner", s1GiveCtl, enabled: !s1Saved),
                                _tf("Office Hold", s1HoldCtl, enabled: false),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: ElevatedButton(
                                    onPressed: s1Saved ? null : _saveStep1,
                                    child: const Text("Save Step 1"),
                                  ),
                                ),
                              ],
                            ),
                          )),

                          SizedBox(width: itemW, child: _panel(
                            title: "Step 2 • Mid Payment",
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _tf("Tenant pays", s2TenantCtl, enabled: s1Saved && !s2Saved),
                                const SizedBox(height: 8),
                                _kv("Office → Owner",
                                    _cur(s2Saved ? s2Tenant : _pc(s2TenantCtl))),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: (!s1Saved || s2Saved) ? null : _saveStep2,
                                  child: const Text("Save Step 2"),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  "Mid payment is forwarded fully to owner.",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          )),

                          SizedBox(width: itemW, child: _panel(
                            title: "Step 3 • Close Out",
                            body: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _tf("Tenant pays (final)", s3TenantCtl, enabled: s1Saved && !s3Saved),

                                _tf(
                                  "Company commission (TOTAL)",
                                  s3CompanyTotalCtl,
                                  enabled: s1Saved && !s3Saved,
                                  hint: "Enter TOTAL company commission, e.g. 6000",
                                ),

                                const SizedBox(height: 8),
                                _kv("Remaining Balance + \nOffice Hold Amount", _cur(settlementPool)),
                                Padding(
                                  padding: const EdgeInsets.only(top: 2, bottom: 8),
                                  child: Text("Breakdown: $poolDetail",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                ),
                                _kv("Company Commission (total)", _cur(companyCommissionTotal)),
                                _kv("Company Keep (now)", _cur(companyKeepNow)),
                                _kv("Owner Final (now)", _cur(ownerFinalNow)),
                                _kv("Remaining (auto)", _cur(remaining)),
                                const SizedBox(height: 8),
                                ElevatedButton(
                                  onPressed: (!s1Saved || s3Saved) ? null : _saveFinal,
                                  child: const Text("Save Final"),
                                ),
                              ],
                            ),
                          )),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 12),
                  const Divider(),
                  _kv("Tenant Paid", _cur(tenantPaid)),
                  _kv("Owner Received (total)", _cur(ownerReceivedTotal)),
                  _kv("Remaining (tenant)", _cur(remaining)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // UI helpers
  Widget _panel({required String title, required Widget body}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0x22000000)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF6EA8FF),
              )),
          const SizedBox(height: 8),
          body,
        ],
      ),
    );
  }

  Widget _tf(String label, TextEditingController c, {bool enabled = true, String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: c,
        enabled: enabled,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
        onChanged: (_) => _recalc(),
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            v,
            style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
          ),
        ],
      ),
    );
  }

  void _toast(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}
