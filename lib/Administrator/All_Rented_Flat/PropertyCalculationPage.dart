import 'dart:convert';
import 'dart:ui' show FontFeature;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// =====================================================
// MODELS
// =====================================================

class Property {
  final int id;
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String locations;
  final String flatNumber;
  final String advancePayment;
  final String totalBalance;
  final String secondAmount;
  final String finalAmount;

  Property({
    required this.id,
    required this.rent,
    required this.security,
    required this.commission,
    required this.extraExpense,
    required this.locations,
    required this.flatNumber,
    required this.advancePayment,
    required this.totalBalance,
    required this.secondAmount,
    required this.finalAmount,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    double _toD(dynamic v) => double.tryParse(v?.toString() ?? "0") ?? 0;
    return Property(
      id: int.tryParse(json["P_id"]?.toString() ?? "0") ?? 0,
      rent: (_toD(json["Rent"])).toStringAsFixed(0),
      security: (_toD(json["Security"])).toStringAsFixed(0),
      commission: (_toD(json["Commission"])).toStringAsFixed(0),
      extraExpense: (_toD(json["Extra_Expense"])).toStringAsFixed(0),
      locations: json["locations"]?.toString() ?? "",
      flatNumber: json["Flat_number"]?.toString() ?? "",
      advancePayment: json["Advance_Payment"]?.toString() ?? "",
      totalBalance: json["Total_Balance"]?.toString() ?? "",
      secondAmount: json["second_amount"]?.toString() ?? "",
      finalAmount: json["final_amount"]?.toString() ?? "",
    );
  }
}

class PaymentStepStatus {
  final int id;
  final int subid;

  // status flags from backend
  final String? statusFirst;   // "first payment done" or null
  final String? statusTwo;     // non-null/filled when step 2 done
  final String? statusThree;   // non-null/filled when step 3 done

  // amounts
  final String tenantAdvance;              // step 1: tenant_advance
  final String giveToOwnerAdvance;         // step 1: give_to_owner_advance
  final String officeHold;                 // step 1: office_hold
  final String? midPaymentToOwner;         // step 2: mid_payment_to_owner
  final String? ownerReceivedPaymentInMid; // step 2: owner_reccived_payment_in_mid
  final String? tenantPayLastAmount;       // step 3: tenant_pay_last_amount
  final String? bothsideCompanyCommission; // step 3: bothside_company_comition
  final String? ownerReceivedFinalAmount;  // step 3: owner_recived_final_amount

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
    required this.ownerReceivedFinalAmount,
  });

  factory PaymentStepStatus.fromJson(Map<String, dynamic> j) {
    int _i(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
    String _s(dynamic v) => v?.toString() ?? '';
    return PaymentStepStatus(
      id: _i(j['id']),
      subid: _i(j['subid']),
      statusFirst: j['status_fist']?.toString(),
      statusTwo: j['status_tow']?.toString(),
      statusThree: j['status_three']?.toString(),
      tenantAdvance: _s(j['tenant_advance']),
      giveToOwnerAdvance: _s(j['give_to_owner_advance']),
      officeHold: _s(j['office_hold']),
      midPaymentToOwner: j['mid_payment_to_owner']?.toString(),
      ownerReceivedPaymentInMid: j['owner_reccived_payment_in_mid']?.toString(),
      tenantPayLastAmount: j['tenant_pay_last_amount']?.toString(),
      bothsideCompanyCommission: j['bothside_company_comition']?.toString(),
      ownerReceivedFinalAmount: j['owner_recived_final_amount']?.toString(),
    );
  }
}

// =====================================================
// SCREEN
// =====================================================

class PropertyCalculate extends StatefulWidget {
  final int propertyId; // also used as subid for payment status
  const PropertyCalculate({super.key, required this.propertyId});

  @override
  State<PropertyCalculate> createState() => _PropertyCalculateState();
}

class _PropertyCalculateState extends State<PropertyCalculate> {
  // Base fetch
  late Future<Property> _futureProperty;

  // Step inputs
  final s1TenantCtl = TextEditingController();
  final s1GiveCtl = TextEditingController();
  final s1HoldCtl = TextEditingController();
  final s2TenantCtl = TextEditingController();
  final s3TenantCtl = TextEditingController();
  final s3CompanyTotalCtl = TextEditingController(); // total company commission input

  // Locks and flags
  bool s1Saved = false, s2Saved = false, s3Saved = false;
  bool _s1Submitting = false;
  bool _loadingStatus = false;

  // Step-done by backend status
  PaymentStepStatus? _status;
  bool step1Done = false;
  bool step2Done = false;
  bool step3Done = false;

  // Calculations
  double rent = 0, security = 0, tenantComm = 0, extraExpense = 0, totalDue = 0;
  double s1Tenant = 0, s1Give = 0, s1Hold = 0;
  double s2Tenant = 0, s3Tenant = 0;
  double settlementPool = 0, companyCommissionTotal = 0, companyKeepNow = 0, ownerFinalNow = 0;
  double tenantPaid = 0, ownerReceivedTotal = 0, remaining = 0;

  static const _propListEndpoint = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_admin.php";
  static const _statusEndpoint  = "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_payment1_base_on_sub_id.php";
  bool _s2Submitting = false;

  static const _step1Endpoint   = "https://verifyserve.social/Second%20PHP%20FILE/Payment/paymet_inset.php";

  static const _step2Endpoint =
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/add_second_setp_amount.php";

  bool _s3Submitting = false;

  static const _step3Endpoint =
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/third_setp_payment.php"; // <- put the real URL
  @override
  void initState() {
    super.initState();
    _futureProperty = _fetchPropertyById(widget.propertyId);
    // Recalc listeners
    s1TenantCtl.addListener(_recalc);
    s1GiveCtl.addListener(_recalc);
    s2TenantCtl.addListener(_recalc);
    s3TenantCtl.addListener(_recalc);
    s3CompanyTotalCtl.addListener(_recalc);
    // Hold sync listeners
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
    s3CompanyTotalCtl.dispose();
    super.dispose();
  }

  // -----------------------------------------------------
  // FETCH PROPERTY
  // -----------------------------------------------------
  Future<Property> _fetchPropertyById(int id) async {
    final res = await http.get(Uri.parse(_propListEndpoint));
    if (res.statusCode != 200) {
      throw Exception("Failed to load properties");
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

    // Base numbers
    rent = _toD(match.rent);
    security = _toD(match.security);
    tenantComm = _toD(match.commission);
    extraExpense = _toD(match.extraExpense);
    totalDue = rent + security + tenantComm;

    // Prefill editable fields with any base API hints
    _prefillFromProperty(match);

    // Then fetch status to override, lock and disable where needed
    await _refreshStatus(widget.propertyId);

    return match;
  }

  bool _changed = false;

  Future<void> _saveStep2() async {
    if (!(s1Saved || step1Done)) {
      _toast(context, "Save Step 1 first.");
      return;
    }
    if (_status == null || _status!.id == 0) {
      _toast(context, "Cannot add Step 2: first payment record not found.");
      return;
    }

    final t = _pc(s2TenantCtl);
    if (t <= 0) {
      _toast(context, "Step 2: Enter a positive amount.");
      return;
    }

    final ok = await _postStep2(id: _status!.id, midPaymentToOwner: t);
    if (!ok) {
      _toast(context, "Step 2 save failed.");
      return;
    }

    s2Saved = true;
    s2Tenant = t;
    _recalc();
    _toast(context, "Step 2 saved.");

    _changed = true; // mark dirty
    await _refreshStatus(widget.propertyId);
  }

  Future<void> _saveStep1() async {
    final t = _pc(s1TenantCtl);
    final g = _pc(s1GiveCtl);
    if (t < 0 || g < 0 || g > t) {
      _toast(context, "Step 1: Give to Owner cannot exceed Tenant pays.");
      return;
    }
    final h = (t - g).clamp(0, double.infinity);

    final ok = await _postStep1(
      tenantAdvance: t,
      giveToOwnerAdvance: g,
      officeHold: h.toDouble(),
      subid: widget.propertyId,
    );
    if (!ok) {
      _toast(context, "Step 1 save failed.");
      return;
    }

    s1Saved = true;
    s1Tenant = t;
    s1Give = g;
    s1Hold = h.toDouble();
    _recalc();
    _toast(context, "Step 1 saved.");

    _changed = true; // mark dirty
    await _refreshStatus(widget.propertyId);
  }

  Future<void> _saveFinal() async {
    if (!(s1Saved || step1Done)) {
      _toast(context, "Save Step 1 first.");
      return;
    }
    if (_status == null || _status!.id == 0) {
      _toast(context, "Cannot add Step 3: first payment record not found.");
      return;
    }

    final t = _pc(s3TenantCtl);
    if (t < 0) {
      _toast(context, "Step 3: Invalid amount.");
      return;
    }

    // lock UI + recompute
    s3Saved = true;
    s3Tenant = t;
    _recalc();

    final ok = await _postStep3(
      id: _status!.id,
      tenantPayLastAmount: s3Tenant,
      bothSideCompanyComition: companyCommissionTotal,
      remainingHold: settlementPool,
      remainBalanceShareToOwner: ownerFinalNow,
      ownerRecivedFinalAmount: s1Give + s2Tenant + ownerFinalNow,
      tenantTotalPay: tenantPaid,
      remainingFinalBalance: remaining,
    );

    if (!ok) {
      _toast(context, "Step 3 save failed.");
      return;
    }

    _toast(context, "Step 3 saved.");

    // optional: refresh local screen state before leaving
    await _refreshStatus(widget.propertyId);

    // tell previous page to refresh
    if (mounted) Navigator.pop(context, true);
  }
  Future<void> _refreshStatus(int subid) async {
    setState(() => _loadingStatus = true);
    try {
      final st = await _fetchPaymentStatusBySubId(subid);
      if (st != null) {
        _applyStatus(st);
      } else {
        // No status: everything starts editable as prefilled above
        step1Done = step2Done = step3Done = false;
        s1Saved = s2Saved = s3Saved = false;
        _recalc();
      }
    } finally {
      if (mounted) setState(() => _loadingStatus = false);
    }
  }

  Future<PaymentStepStatus?> _fetchPaymentStatusBySubId(int subid) async {
    final uri = Uri.parse("$_statusEndpoint?subid=$subid");
    final res = await http.get(uri);
    if (res.statusCode != 200) return null;

    final body = json.decode(res.body);
    if (body['success'] != true) return null;

    final List data = body['data'] as List;
    if (data.isEmpty) return null;

    // use the latest row
    return PaymentStepStatus.fromJson(data.last as Map<String, dynamic>);
  }

  // -----------------------------------------------------
  // APPLY STATUS TO UI
  // -----------------------------------------------------
  void _applyStatus(PaymentStepStatus st) {
    _status = st;

    // Step 1 lock
    step1Done = (st.statusFirst?.toLowerCase().contains('first payment done') ?? false);
    if (step1Done) {
      s1TenantCtl.text = _numOnly(st.tenantAdvance);
      s1GiveCtl.text   = _numOnly(st.giveToOwnerAdvance);
      s1HoldCtl.text   = _numOnly(st.officeHold);
      s1Saved = true;

      s1Tenant = double.tryParse(s1TenantCtl.text) ?? 0;
      s1Give   = double.tryParse(s1GiveCtl.text) ?? 0;
      s1Hold   = double.tryParse(s1HoldCtl.text) ?? 0;
    }

    // Step 2 lock
    step2Done = (st.statusTwo != null && st.statusTwo!.trim().isNotEmpty);
    if (step2Done) {
      final mid = double.tryParse(_numOnly(st.midPaymentToOwner ?? '')) ?? 0;
      s2TenantCtl.text = mid.toStringAsFixed(0);
      s2Saved = true;
      s2Tenant = mid;
    }

    // Step 3 lock
    step3Done = (st.statusThree != null && st.statusThree!.trim().isNotEmpty);
    if (step3Done) {
      final last = double.tryParse(_numOnly(st.tenantPayLastAmount ?? '')) ?? 0;
      final comp = double.tryParse(_numOnly(st.bothsideCompanyCommission ?? '')) ?? 0;
      s3TenantCtl.text = last.toStringAsFixed(0);
      s3CompanyTotalCtl.text = comp.toStringAsFixed(0);
      s3Saved = true;
      s3Tenant = last;
    }

    _recalc();
    if (mounted) setState(() {});
  }

  // -----------------------------------------------------
  // PREFILL FROM PROPERTY (initial hints)
  // -----------------------------------------------------
  void _prefillFromProperty(Property p) {
    // Only prefill tenant payments; office-hold is derived from Step1 fields.
    s1TenantCtl.text = _numOnly(p.advancePayment);
    s2TenantCtl.text = _numOnly(p.secondAmount);
    s3TenantCtl.text = _numOnly(p.finalAmount);
    _syncHold();
    _recalc();
  }

  void _logLine([String msg = ""]) => debugPrint(msg);

  void _logBlock(String title, Map<String, dynamic> data) {
    _logLine("—" * 50);
    _logLine(title);
    data.forEach((k, v) => _logLine("  $k: $v"));
    _logLine("—" * 50);
  }
// --- tiny helpers: no intl needed
  String _two(int n) => n.toString().padLeft(2, '0');
  String _date(DateTime d) => '${d.year}-${_two(d.month)}-${_two(d.day)}';
  String _time(DateTime d) => '${_two(d.hour)}:${_two(d.minute)}:${_two(d.second)}';

  Future<bool> _postStep1({
    required double tenantAdvance,
    required double giveToOwnerAdvance,
    required double officeHold,
    required int subid,
  }) async {
    final sw = Stopwatch()..start();
    final now = DateTime.now();

    try {
      setState(() => _s1Submitting = true);

      final url = Uri.parse(_step1Endpoint);
      final bodyMap = {
        "tenant_advance": _intStr(tenantAdvance),
        "give_to_owner_advance": _intStr(giveToOwnerAdvance),
        "office_hold": _intStr(officeHold),
        "subid": subid.toString(),
        "dates": _date(now),
        "times": _time(now),
      };

      _logBlock("STEP1 REQUEST", {
        "method": "POST",
        "url": url.toString(),
        "contentType": "application/x-www-form-urlencoded",
        "body": bodyMap.toString(),
      });

      final resp = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: bodyMap,
      );

      _logBlock("STEP1 RESPONSE", {
        "status": resp.statusCode,
        "elapsedMs": sw.elapsedMilliseconds,
        "headers": resp.headers.toString(),
        "body": resp.body,
      });

      return resp.statusCode == 200 && resp.body.toLowerCase().contains('success');
    } catch (e) {
      _logBlock("STEP1 ERROR", {"error": e.toString()});
      return false;
    } finally {
      if (mounted) setState(() => _s1Submitting = false);
    }
  }

  Future<bool> _postStep2({
    required int id,
    required double midPaymentToOwner,
  }) async {
    final sw = Stopwatch()..start();
    final now = DateTime.now();

    try {
      setState(() => _s2Submitting = true);

      final url = Uri.parse(_step2Endpoint);
      final req = http.MultipartRequest('POST', url)
        ..fields['id'] = id.toString()
        ..fields['mid_payment_to_owner'] = _intStr(midPaymentToOwner)
        ..fields['dates_2nd'] = _date(now)
        ..fields['times_2nd'] = _time(now);

      _logBlock("STEP2 REQUEST", {
        "method": "POST (multipart/form-data)",
        "url": url.toString(),
        "fields": req.fields.toString(),
        "files": "[]",
      });

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      _logBlock("STEP2 RESPONSE", {
        "status": res.statusCode,
        "elapsedMs": sw.elapsedMilliseconds,
        "headers": res.headers.toString(),
        "body": res.body,
      });

      return res.statusCode == 200 && res.body.toLowerCase().contains('success');
    } catch (e) {
      _logBlock("STEP2 ERROR", {"error": e.toString()});
      return false;
    } finally {
      if (mounted) setState(() => _s2Submitting = false);
    }
  }

  Future<bool> _postStep3({
    required int id,
    required double tenantPayLastAmount,
    required double bothSideCompanyComition,
    required double remainingHold,
    required double remainBalanceShareToOwner,
    required double ownerRecivedFinalAmount, // final_recived_amount_owner
    required double tenantTotalPay,          // total_pay_tenant
    required double remainingFinalBalance,   // remaing_final_balance
  }) async {
    final sw = Stopwatch()..start();
    final now = DateTime.now();

    try {
      setState(() => _s3Submitting = true);

      final url = Uri.parse(_step3Endpoint);
      final req = http.MultipartRequest('POST', url)
        ..fields['id']                            = id.toString()
        ..fields['tenant_pay_last_amount']        = _intStr(tenantPayLastAmount)
        ..fields['bothside_company_comition']     = _intStr(bothSideCompanyComition)
        ..fields['remaining_hold']                = _intStr(remainingHold)
        ..fields['company_keep_comition']         = _intStr(companyKeepNow)
        ..fields['remain_balance_share_to_owner'] = _intStr(remainBalanceShareToOwner)
        ..fields['final_recived_amount_owner']    = _intStr(ownerRecivedFinalAmount)
        ..fields['total_pay_tenant']              = _intStr(tenantTotalPay)
        ..fields['remaing_final_balance']         = _intStr(remainingFinalBalance)
        ..fields['dates_3rd']                         = _date(now)
        ..fields['times_3rd']                         = _time(now);

      _logBlock("STEP3 REQUEST", {
        "method": "POST (multipart/form-data)",
        "url": url.toString(),
        "fields": req.fields.toString(),
        "files": "[]",
      });

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      _logBlock("STEP3 RESPONSE", {
        "status": res.statusCode,
        "elapsedMs": sw.elapsedMilliseconds,
        "headers": res.headers.toString(),
        "body": res.body,
      });

      return res.statusCode == 200 && res.body.toLowerCase().contains('success');
    } catch (e) {
      _logBlock("STEP3 ERROR", {"error": e.toString()});
      return false;
    } finally {
      if (mounted) setState(() => _s3Submitting = false);
    }
  }




  // -----------------------------------------------------
  // CALC & HELPERS
  // -----------------------------------------------------
  void _syncHold() {
    final t = _pc(s1TenantCtl);
    final g = _pc(s1GiveCtl);
    final h = (t - g).clamp(0, double.infinity);
    final newText = h.toStringAsFixed(0);
    if (s1HoldCtl.text != newText) s1HoldCtl.text = newText;
  }

  void _recalc() {
    // Lock-aware values
    s1Tenant = (s1Saved || step1Done) ? s1Tenant : _pc(s1TenantCtl);
    s1Give   = (s1Saved || step1Done) ? s1Give   : _pc(s1GiveCtl);
    s1Hold   = (s1Saved || step1Done) ? s1Hold   : (s1Tenant - s1Give).clamp(0, double.infinity);

    s2Tenant = (s2Saved || step2Done) ? s2Tenant : _pc(s2TenantCtl);
    s3Tenant = (s3Saved || step3Done) ? s3Tenant : _pc(s3TenantCtl);

    // Pool
    settlementPool = s1Hold + s3Tenant;

// Commission total: 0 until user types something in the "Company commission (TOTAL)" field
    final hasUserInput = s3CompanyTotalCtl.text.trim().isNotEmpty;
    final overrideTotal = _pc(s3CompanyTotalCtl);
    companyCommissionTotal = hasUserInput ? overrideTotal.clamp(0, double.infinity) : 0;

    // Company keep, then owner share from pool
    companyKeepNow = companyCommissionTotal <= settlementPool ? companyCommissionTotal : settlementPool;
    ownerFinalNow  = (settlementPool - companyKeepNow).clamp(0, double.infinity);

    // Running sums
    tenantPaid = s1Tenant + s2Tenant + s3Tenant;
    ownerReceivedTotal = s1Give + s2Tenant + ownerFinalNow;

    // Remaining toward tenant bill (rent + security + tenant side commission)
    remaining = (totalDue - tenantPaid).clamp(0, double.infinity);

    if (mounted) setState(() {});
  }

  double _toD(String v) => double.tryParse(v.replaceAll(',', '').trim()) ?? 0;
  double _pc(TextEditingController c) => double.tryParse(c.text) ?? 0;
  String _cur(num n) => "₹${n.toStringAsFixed(0)}";
  String _intStr(num v) => v.toStringAsFixed(0);
  String _numOnly(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
    final d = double.tryParse(cleaned) ?? 0;
    return d.toStringAsFixed(0);
  }

  // -----------------------------------------------------
  // UI
  // -----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // returning true here just allows the pop; but pass a result:
        Navigator.pop(context, s3Saved); // true if saved, else null/false
        return false; // we've handled it
      },
      child: Scaffold(
        appBar: AppBar(
            surfaceTintColor: Colors.black,
            backgroundColor: Colors.black,
            leading: InkWell(
            onTap: (){
              Navigator.pop(context,true);
            },
            child: Icon(CupertinoIcons.back)),
            title: const Text("Add Billing",style: TextStyle(
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600
            ),

            )
        ),
        body: FutureBuilder<Property>(
          future: _futureProperty,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting || _loadingStatus) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text("Error: ${snap.error}"));
            }
            final property = snap.data!;
            final poolDetail = "${_cur(settlementPool)} = ${_cur(s3Tenant)} (final) + ${_cur(s1Hold)} (hold)";

            return SingleChildScrollView(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${property.locations} • ${property.flatNumber}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text("Total Due: ${_cur(totalDue)}",
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),

                  LayoutBuilder(
                    builder: (ctx, cons) {
                      final w = cons.maxWidth;
                      final threeCol = w >= 960;
                      final itemW = threeCol ? (w - 24) / 3 : w;

                      return Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          // STEP 1
                          SizedBox(
                            width: itemW,
                            child: _panel(
                              title: "Step 1 • Advance",
                              body: Column(
                                children: [
                                  _tf("Tenant pays", s1TenantCtl, enabled: !(s1Saved || step1Done)),
                                  _tf("Give to Owner", s1GiveCtl, enabled: !(s1Saved || step1Done)),
                                  _tf("Office Hold", s1HoldCtl, enabled: false),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: (s1Saved || step1Done || _s1Submitting) ? null : _saveStep1,
                                    child: Text(_s1Submitting
                                        ? "Saving..."
                                        : (step1Done ? "Saved" : "Save Step 1")),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // STEP 2
                          SizedBox(
                            width: itemW,
                            child: _panel(
                              title: "Step 2 • Mid Payment",
                              body: Column(
                                children: [
                                  _tf("Tenant pays", s2TenantCtl,
                                      enabled: (s1Saved || step1Done) && !(s2Saved || step2Done)),
                                  const SizedBox(height: 8),
                                  _kv("Office → Owner", _cur(s2Saved || step2Done ? s2Tenant : _pc(s2TenantCtl))),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: (!(s1Saved || step1Done) || s2Saved || step2Done || _s2Submitting)
                                        ? null
                                        : _saveStep2,
                                    child: Text(_s2Submitting
                                        ? "Saving..."
                                        : (step2Done ? "Saved" : "Save Step 2")),
                                  ),

                                ],
                              ),
                            ),
                          ),

                          // STEP 3
                          SizedBox(
                            width: itemW,
                            child: _panel(
                              title: "Step 3 • Close Out",
                              body: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _tf("Tenant pays (final)", s3TenantCtl,
                                      enabled: (s1Saved || step1Done) && !(s3Saved || step3Done)),
                                  _tf("Company commission (TOTAL)", s3CompanyTotalCtl,
                                      enabled: (s1Saved || step1Done) && !(s3Saved || step3Done),
                                      hint: "Enter both-side total (e.g. 6000)"),
                                  const SizedBox(height: 8),
                                  _kv("Remaining + Hold", _cur(settlementPool)),
                                  Text("Breakdown: $poolDetail",
                                      style: const TextStyle(fontSize: 12, color: Colors.grey)),
                                  _kv("Company Commission Keep", _cur(companyKeepNow)),
                                  _kv("Remaining Share to Owner", _cur(ownerFinalNow)),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: (!(s1Saved || step1Done) ||
                                            s3Saved ||
                                            step3Done ||
                                            _s3Submitting)
                                        ? null
                                        : _saveFinal,
                                    child: Text(_s3Submitting
                                        ? "Saving..."
                                        : (step3Done ? "Saved" : "Save Final")),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const Divider(),
                  _kv("Tenant Paid", _cur(tenantPaid)),
                  _kv("Owner Received (total)", _cur(ownerReceivedTotal)),
                  _kv("Remaining (tenant)", _cur(remaining)),
                  SizedBox(height: 30,)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // UI helpers
  Widget _panel({required String title, required Widget body}) => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0x22000000)),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF6EA8FF))),
      const SizedBox(height: 8),
      body,
    ]),
  );

  Widget _tf(String label, TextEditingController c, {bool enabled = true, String? hint}) => Padding(
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

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
      Text(v, style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
    ]),
  );

  void _toast(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}
