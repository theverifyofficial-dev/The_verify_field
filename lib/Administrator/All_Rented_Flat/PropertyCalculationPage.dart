import 'dart:convert';
import 'dart:ui' show FontFeature;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Add_Rented_Flat_New/FieldWorker_Complete_Page.dart';

class Property {
  final int id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeOfProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squarefit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldworkarAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String ownerCommission;
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String caretakerName;
  final String caretakerNumber;
  final String statusForFinalPayment;
  final String statusForSecondPayment;
  final dynamic subid;

  // ✅ New fields
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;
  final String secondAmount;
  final String finalAmount;

  Property({
    required this.id,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeOfProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squarefit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkarAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.ownerCommission,
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.subid,
    required this.rent,
    required this.security,
    required this.commission,
    required this.extraExpense,
    required this.advancePayment,
    required this.totalBalance,
    required this.finalAmount,
    required this.secondAmount,
    required this.statusForFinalPayment,
    required this.statusForSecondPayment,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json["P_id"] ?? 0,
      propertyPhoto: json["property_photo"] ?? "",
      locations: json["locations"] ?? "",
      flatNumber: json["Flat_number"] ?? "",
      buyRent: json["Buy_Rent"] ?? "",
      residenceCommercial: json["Residence_Commercial"] ?? "",
      apartmentName: json["Apartment_name"] ?? "",
      apartmentAddress: json["Apartment_Address"] ?? "",
      typeOfProperty: json["Typeofproperty"] ?? "",
      bhk: json["Bhk"] ?? "",
      showPrice: json["show_Price"] ?? "",
      lastPrice: json["Last_Price"] ?? "",
      askingPrice: json["asking_price"] ?? "",
      floor: json["Floor_"] ?? "",
      totalFloor: json["Total_floor"] ?? "",
      balcony: json["Balcony"] ?? "",
      squarefit: json["squarefit"] ?? "",
      maintance: json["maintance"] ?? "",
      parking: json["parking"] ?? "",
      ageOfProperty: json["age_of_property"] ?? "",
      fieldworkarAddress: json["fieldworkar_address"] ?? "",
      roadSize: json["Road_Size"] ?? "",
      metroDistance: json["metro_distance"] ?? "",
      highwayDistance: json["highway_distance"] ?? "",
      mainMarketDistance: json["main_market_distance"] ?? "",
      meter: json["meter"] ?? "",
      ownerName: json["owner_name"] ?? "",
      ownerNumber: json["owner_number"] ?? "",
      ownerCommission: json["owner_side_commition"] ?? "",
      currentDates: json["current_dates"] ?? "",
      availableDate: json["available_date"] ?? "",
      kitchen: json["kitchen"] ?? "",
      bathroom: json["bathroom"] ?? "",
      lift: json["lift"] ?? "",
      facility: json["Facility"] ?? "",
      furnishedUnfurnished: json["furnished_unfurnished"] ?? "",
      fieldWorkerName: json["field_warkar_name"] ?? "",
      liveUnlive: json["live_unlive"] ?? "",
      fieldWorkerNumber: json["field_workar_number"] ?? "",
      registryAndGpa: json["registry_and_gpa"] ?? "",
      loan: json["loan"] ?? "",
      longitude: json["Longitude"] ?? "",
      latitude: json["Latitude"] ?? "",
      videoLink: json["video_link"] ?? "",
      caretakerName: json["care_taker_name"] ?? "",
      caretakerNumber: json["care_taker_number"] ?? "",
      subid: json["subid"],
      rent: json["Rent"] ?? "",
      security: json["Security"] ?? "",
      commission: json["Commission"] ?? "",
      extraExpense: json["Extra_Expense"] ?? "",
      advancePayment: json["Advance_Payment"] ?? "",
      totalBalance: json["Total_Balance"] ?? "",
      secondAmount: json["second_amount"] ?? "",
      finalAmount: json["final_amount"] ?? "",
      statusForSecondPayment: json["status_for_second_payment"] ?? "",
      statusForFinalPayment: json["status_for_final_payment"] ?? "",
    );
  }
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

class PropertyCalculate extends StatefulWidget {

  final int propertyId;
  final String tenantCommission;
  final String ownerCommission;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String flatId;

  const PropertyCalculate({super.key, required this.propertyId, required this.tenantCommission, required this.ownerCommission, required this.fieldworkerName, required this.fieldworkerNumber, required this.flatId});

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
  final s3CompanyTotalCtl = TextEditingController();

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
// ====== GST & DISTRIBUTION ======
  double gstAmount = 0;
  double netAfterGst = 0;

  double officeFinalShare = 0;
  double fieldWorkerFinalShare = 0;
  double visitorShare = 0;
// Visitor control
  bool hasVisitor = false;
  final visitorAmountCtl = TextEditingController();

  static const _propListEndpoint = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_admin.php";
  static const _statusEndpoint  = "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_payment1_base_on_sub_id.php";
  bool _s2Submitting = false;

  static const _step1Endpoint   = "https://verifyserve.social/Second%20PHP%20FILE/Payment/paymet_inset.php";

  static const _step2Endpoint =
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/add_second_setp_amount.php";
  late double commissionBothSide;
  final s2OwnerCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserPost();


    _futureProperty = _fetchPropertyById(widget.propertyId);
    s2OwnerCtl.addListener(_recalc);

    // Calculate commission safely ONCE
    commissionBothSide =
        _safeDouble(widget.ownerCommission) +
            _safeDouble(widget.tenantCommission);

    // Auto-fill company commission field
    s3CompanyTotalCtl.text = commissionBothSide.toStringAsFixed(0);

    // Listeners
    s1TenantCtl.addListener(_recalc);
    s1GiveCtl.addListener(_recalc);
    s2TenantCtl.addListener(_recalc);
    s3TenantCtl.addListener(_recalc);
    s3CompanyTotalCtl.addListener(_recalc);

    s1TenantCtl.addListener(_syncHold);
    s1GiveCtl.addListener(_syncHold);
  }


  double _safeDouble(dynamic value) {
    if (value == null) return 0;

    final cleaned = value
        .toString()
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .trim();

    if (cleaned.isEmpty) return 0;

    return double.tryParse(cleaned) ?? 0;
  }


  @override
  void dispose() {
    s2OwnerCtl.dispose();

    s1TenantCtl.dispose();
    s1GiveCtl.dispose();
    s1HoldCtl.dispose();
    s2TenantCtl.dispose();
    s3TenantCtl.dispose();
    s3CompanyTotalCtl.dispose();
    super.dispose();
  }
  double get remainingAfterStep1 {
    return (totalDue - s1Tenant).clamp(0, double.infinity);
  }

  double get remainingAfterStep2 {
    return (totalDue - (s1Tenant + s2Tenant + s3Tenant))
        .clamp(0, double.infinity);
  }


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
  double s2OwnerReceive = 0;
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

  Future<void> _saveStep2() async {
    if (!(s1Saved || step1Done)) {
      _toast(context, "Save Step 1 first.");
      return;
    }

    if (_status == null || _status!.id == 0) {
      _toast(context, "Payment record not found.");
      return;
    }

    final tenantPay = _pc(s2TenantCtl);
    final ownerGet = _pc(s2OwnerCtl);

    if (tenantPay <= 0) {
      _toast(context, "Enter tenant payment.");
      return;
    }

    if (ownerGet > tenantPay) {
      _toast(context, "Owner cannot receive more than tenant pays.");
      return;
    }

    final ok = await _postStep2(
      id: _status!.id,
      midPaymentToOwner: ownerGet,
    );

    if (!ok) {
      _toast(context, "Step 2 save failed.");
      return;
    }

    s2Tenant = tenantPay;
    s2OwnerReceive = ownerGet;
    s2Saved = true;

    _recalc();
    _toast(context, "Step 2 saved.");

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
    final double ownerFinalSettlement =
    (settlementPool + s3Tenant - companyCommissionTotal)
        .clamp(0, double.infinity);

    final ok = await _postStep3(
      id: _status!.id,
      tenantPayLastAmount: s3Tenant,
      bothSideCompanyComition: companyCommissionTotal,
      remainingHold: settlementPool,
      remainBalanceShareToOwner: ownerFinalNow,
      ownerRecivedFinalAmount: ownerFinalSettlement,
      tenantTotalPay: tenantPaid,
      remainingFinalBalance: remaining,
    );

    if (!ok) {
      _toast(context, "Step 3 save failed.");
      return;
    }

    _toast(context, "Step 3 saved.");

    await _refreshStatus(widget.propertyId);

    if (mounted) Navigator.pop(context, true);
  }
  Future<void> _refreshStatus(int subid) async {
    setState(() => _loadingStatus = true);
    try {
      final st = await _fetchPaymentStatusBySubId(subid);
      if (st != null) {
        _applyStatus(st);
      } else {

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

    return PaymentStepStatus.fromJson(data.last as Map<String, dynamic>);
  }
  bool _visitorInitialized = false;

  void _applyStatus(PaymentStepStatus st) {
    _status = st;

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

    step2Done = (st.statusTwo != null && st.statusTwo!.trim().isNotEmpty);

    if (step2Done) {

      s2TenantCtl.text = _numOnly(
        st.midPaymentToOwner == null
            ? s2TenantCtl.text
            : s2TenantCtl.text,
      );

      final ownerGet =
          double.tryParse(_numOnly(st.midPaymentToOwner ?? '0')) ?? 0;

      s2OwnerCtl.text = ownerGet.toStringAsFixed(0);

      s2Tenant = _pc(s2TenantCtl);
      s2OwnerReceive = ownerGet;
      s2Saved = true;
    }

    // Step 3 lock
    step3Done = (st.statusThree != null && st.statusThree!.trim().isNotEmpty);
    if (step3Done) {
      final last = double.tryParse(_numOnly(st.tenantPayLastAmount ?? '')) ?? 0;
      final comp = double.tryParse(_numOnly(st.bothsideCompanyCommission ?? '')) ?? 0;
      s3CompanyTotalCtl.text = comp.toStringAsFixed(0);
      s3Saved = true;
      s3Tenant = last;
    }
    if (!_visitorInitialized) {
      final apiVisitor =
          double.tryParse(st.visitorShare ?? '0') ?? 0;

      if (apiVisitor > 0) {
        hasVisitor = true;
        visitorShare = apiVisitor;
        visitorLocked = true; // 🔒 lock after API
      } else {
        hasVisitor = false;
        visitorShare = 0;
        visitorLocked = false;
      }

      _visitorInitialized = true;
    }

    _recalc();
    _calcTick.value++;

  }
  final ValueNotifier<int> _calcTick = ValueNotifier(0);

  void _prefillFromProperty(Property p) {
    s1TenantCtl.text = _numOnly(p.advancePayment);
    s2TenantCtl.text = _numOnly(p.secondAmount);
    s3TenantCtl.text = _numOnly(p.finalAmount);
    _syncHold();
    _recalc();
  }
  bool visitorLocked = false;

  void _logLine([String msg = ""]) => debugPrint(msg);

  void _logBlock(String title, Map<String, dynamic> data) {
    _logLine("—" * 50);
    _logLine(title);
    data.forEach((k, v) => _logLine("  $k: $v"));
    _logLine("—" * 50);
  }
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
  bool _s3Submitting = false;
  String? userStoredFAadharCard;


  static const _step3Endpoint =
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/third_setp_payment.php";

  Future<bool> _postStep3({
    required int id,
    required double tenantPayLastAmount,
    required double bothSideCompanyComition,
    required double remainingHold,
    required double remainBalanceShareToOwner,
    required double ownerRecivedFinalAmount,
    required double tenantTotalPay,
    required double remainingFinalBalance,
  }) async {
    final sw = Stopwatch()..start();
    final now = DateTime.now();

    try {
      setState(() => _s3Submitting = true);

      final req = http.MultipartRequest(
        'POST',
        Uri.parse(_step3Endpoint),
      )
        ..fields['id'] = id.toString()
        ..fields['tenant_pay_last_amount'] = _intStr(tenantPayLastAmount)
        ..fields['bothside_company_comition'] = _intStr(bothSideCompanyComition)
        ..fields['remaining_hold'] = _intStr(remainingHold)
        ..fields['company_keep_comition'] = _intStr(companyKeepNow)
        ..fields['remain_balance_share_to_owner'] = _intStr(remainBalanceShareToOwner)
        ..fields['final_recived_amount_owner'] = _intStr(ownerRecivedFinalAmount)
        ..fields['total_pay_tenant'] = _intStr(tenantTotalPay)
        ..fields['remaing_final_balance'] = _intStr(remainingFinalBalance)
        ..fields['visiter_share'] = _intStr(visitorShare)
        ..fields['office_gst'] = _intStr(gstAmount)
        ..fields['after_gst_amount'] = _intStr(netAfterGst)
        ..fields['office_share_fifty_percent'] = _intStr(officeFinalShare)
        ..fields['field_workar_share_fifity_percent'] = _intStr(fieldWorkerFinalShare)

        ..fields['dates_3rd'] = _date(now)
        ..fields['times_3rd'] = _time(now);

      _logBlock("STEP3 REQUEST", {
        "url": _step3Endpoint,
        "fields": req.fields,
      });

      final streamed = await req.send();
      final res = await http.Response.fromStream(streamed);

      _logBlock("STEP3 RESPONSE", {
        "status": res.statusCode,
        "body": res.body,
      });

      return res.statusCode == 200 &&
          res.body.toLowerCase().contains('success');
    } catch (e) {
      _logBlock("STEP3 ERROR", {"error": e.toString()});
      return false;
    } finally {
      if (mounted) setState(() => _s3Submitting = false);
    }
  }

  Future<void> loadUserPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedFAadharCard = prefs.getString('post');

    debugPrint("User FAadharCard: $storedFAadharCard");
    if (mounted) {
      setState(() {

        userStoredFAadharCard = storedFAadharCard;

      });
    }
  }

  void _syncHold() {
    final t = _pc(s1TenantCtl);
    final g = _pc(s1GiveCtl);
    final h = (t - g).clamp(0, double.infinity);
    final newText = h.toStringAsFixed(0);
    if (s1HoldCtl.text != newText) s1HoldCtl.text = newText;
  }

  void _recalc() {
    s1Tenant = _pc(s1TenantCtl);
    s1Give   = _pc(s1GiveCtl);
    s1Hold   = (s1Tenant - s1Give).clamp(0, double.infinity);

    s2Tenant        = _pc(s2TenantCtl);     // 🔒 Tenant NEVER changes
    s2OwnerReceive  = _pc(s2OwnerCtl);

    final s2Hold =
    (s2Tenant - s2OwnerReceive).clamp(0, double.infinity);

    s3Tenant = _pc(s3TenantCtl);

    settlementPool = s1Hold + s2Hold;

    final inputCommission = _pc(s3CompanyTotalCtl);

    companyCommissionTotal =
    inputCommission > 0
        ? inputCommission
        : commissionBothSide;

    gstAmount   = companyCommissionTotal * 0.18;
    netAfterGst = companyCommissionTotal - gstAmount;

    companyKeepNow = companyCommissionTotal;

    ownerFinalNow =
        (settlementPool - companyCommissionTotal)
            .clamp(0, double.infinity);

    ownerReceivedTotal = s1Give + s2OwnerReceive +
            (settlementPool + s3Tenant - companyCommissionTotal).clamp(0, double.infinity);

    tenantPaid = s1Tenant + s2Tenant + s3Tenant;

    remaining =
        (totalDue - tenantPaid).clamp(0, double.infinity);

    officeFinalShare      = netAfterGst * 0.5;
    fieldWorkerFinalShare = netAfterGst * 0.5;

    if (hasVisitor) {
      visitorShare = fieldWorkerFinalShare * 0.15;
      fieldWorkerFinalShare =
          (fieldWorkerFinalShare - visitorShare)
              .clamp(0, double.infinity);
    }
    else {
      visitorShare = 0;
    }

    _calcTick.value++;
  }

  double _toD(String v) => double.tryParse(v.replaceAll(',', '').trim()) ?? 0;
  double _pc(TextEditingController c) => double.tryParse(c.text) ?? 0;
  String _cur(num value) {
    final bool hasDecimal = value % 1 != 0;

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: hasDecimal ? 2 : 0,
    );

    return formatter.format(value);
  }  String _intStr(num v) => v.toStringAsFixed(0);
  String _numOnly(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
    final d = double.tryParse(cleaned) ?? 0;
    return d.toStringAsFixed(0);
  }
  double get apiBothSideCommission {
    if (_status?.bothsideCompanyCommission == null) return 0;
    return double.tryParse(
        _status!.bothsideCompanyCommission!
            .replaceAll(RegExp(r'[^0-9.]'), '')
    ) ??
        0;
  }
  bool visitorAvailable = false; // 🔒 only from API
  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_admin.php");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded["success"] == true) {
        List data = decoded["data"];
        return data
            .map((e) => Property.fromJson(e))
            .toList()
            .reversed
            .toList();
      }
    }
    throw Exception("Failed to load data");
  }
  Future<List<Tenant>> fetchTenants(int subId) async {
    final response = await http.get(
      Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_pending_rentout_api_tenant_owner.php?subid=$subId",
      ),
    );

    debugPrint("🔵 STATUS CODE: ${response.statusCode}");
    debugPrint("🔵 RAW RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["success"] == true) {
        List data = jsonResponse["data"];
        debugPrint("🟢 TENANT COUNT: ${data.length}");
        return data.map((e) => Tenant.fromJson(e)).toList();
      } else {
        throw Exception("API success = false");
      }
    } else {
      throw Exception("Failed to load tenants");
    }
  }
  int _safeSubId(dynamic v) {
    return int.tryParse(v?.toString() ?? '') ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
            child: Icon(CupertinoIcons.back,color: Colors.white,)),
            title: const Text("Add Billing",style: TextStyle(
              fontFamily: "Poppins",
              color: Colors.white,
              fontWeight: FontWeight.w600
            ),

            )
        ),
        body: FutureBuilder<Property>(
          future: _futureProperty,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            }

            if (snap.hasError) {
              return _buildError(snap.error.toString());
            }

            final property = snap.data!;
            commissionBothSide = _toD(widget.ownerCommission) + _toD(widget.tenantCommission);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _exactHeader(property),

                  // Header Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.blue.shade700,
                          Colors.blue.shade900,
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.apartment,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Flat ID: ${widget.flatId}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Field Worker: ${widget.fieldworkerName}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.9),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Summary Cards
                        Row(
                          children: [
                            Expanded(
                              child: _buildSummaryCard(
                                title: "Total Due",
                                amount: totalDue,
                                color: Colors.white,
                                icon: Icons.account_balance_wallet,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildSummaryCard(
                                title: "Commission",
                                amount: commissionBothSide,
                                color: Colors.amber.shade100,
                                icon: Icons.percent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  FutureBuilder<List<Tenant>>(
                    future: fetchTenants(_safeSubId(widget.propertyId)),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "No tenant data",
                            style: TextStyle(
                              fontSize: 13,
                              color: Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white60
                                  : Colors.grey.shade600,
                            ),
                          ),
                        );
                      }

                      final t = snapshot.data!.first;
                      final bool apiVisitorAvailable =
                          t.vist_field_workar_name.trim().isNotEmpty &&
                              t.vist_field_workar_name.trim() != "-";

                      if (visitorAvailable != apiVisitorAvailable) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              visitorAvailable = apiVisitorAvailable;
                              // ❌ hasVisitor ko yahan mat chhedo
                            });
                          }
                        });
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          children: [

                            // ================= OWNER =================
                            _peopleInfoCard(
                              title: "Owner Detail",
                              color: Colors.green,
                              rows: {
                                "Name": t.ownerName,
                                "Phone": t.ownerNumber,
                                "Payment Mode": t.paymentModeForOwner,
                              },
                            ),

                            const SizedBox(height: 12),

                            // ================= TENANT =================
                            _peopleInfoCard(
                              title: "Tenant Detail",
                              color: Colors.blue,
                              rows: {
                                "Name": t.tenantName,
                                "Phone": t.tenantNumber,
                                "Payment Mode": t.paymentModeForTenant,
                                "Shifting Date": _formatDate(t.shiftingDate),
                              },
                            ),

                            const SizedBox(height: 12),

                            // ================= VISITOR =================
                            _peopleInfoCard(
                              title: "Visitor Detail",
                              color: Colors.orange,
                              rows: {
                                "Name": t.vist_field_workar_name.isNotEmpty
                                    ? t.vist_field_workar_name
                                    : "-",
                                "Phone": t.vist_field_workar_number.isNotEmpty
                                    ? t.vist_field_workar_number
                                    : "-",
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  // Financial Details Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Financial Details",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        FutureBuilder<List<Property>>(
                          future: fetchBookingData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.red.shade100),
                                ),
                                child: Center(
                                  child: Text(
                                    "Error loading details",
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                    ),
                                  ),
                                ),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                  child: Text("No data available"),
                                ),
                              );
                            }

                            final bookingList = snapshot.data!
                                .where((e) => e.id == widget.propertyId)
                                .toList();

                            if (bookingList.isEmpty) {
                              return Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.orange.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.orange.shade100),
                                ),
                                child: const Center(
                                  child: Text("No data for this Flat ID"),
                                ),
                              );
                            }

                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: bookingList.length,
                              itemBuilder: (context, index) {
                                final item = bookingList[index];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).cardColor,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      children: [
                                        _buildDetailRow(
                                          "Rent",
                                          "₹ ${_formatNumber(item.rent)}",
                                          context,
                                        ),
                                        _buildDetailRow(
                                          "Security",
                                          "₹ ${_formatNumber(item.security)}",
                                          context,
                                        ),
                                        _buildDetailRow(
                                          "Tenant Commission",
                                          "₹ ${_formatNumber(item.commission)}",
                                          context,
                                        ),

                                        _buildDetailRow(
                                          "Extra Expense",
                                          "₹ ${_formatNumber(item.extraExpense)}",
                                          context,
                                        ),
                                        _buildDetailRow(
                                          "Total Amount",
                                          "₹ ${_formatNumber(item.totalBalance)}",
                                          context,
                                          isTotal: true,
                                        ),
                                        _buildDetailRow(
                                          "Owner Commission",
                                          "₹ ${_formatNumber(item.ownerCommission)}",
                                          context,
                                        ),
                                        const Divider(height: 24),

                                        // Payment Schedule
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildPaymentItem(
                                                "Advance",
                                                item.advancePayment,
                                                Colors.blue.shade100,
                                                context,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: _buildPaymentItem(
                                                "Second",
                                                item.secondAmount,
                                                Colors.green.shade100,
                                                context,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: _buildPaymentItem(
                                                "Final",
                                                item.finalAmount,
                                                Colors.orange.shade100,
                                                context,
                                              ),
                                            ),
                                          ],
                                        ),

                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Payment Process Steps
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.payment,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Payment Process",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Steps Container
                        Column(
                          children: [

                        // ================= STEP 1 ===================
                            Container(
                          margin: EdgeInsets.only(left: 4,right: 4,top: 4),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.grey.shade200,

                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,

                            shape: const Border(),           // ⬅ removes expanded divider
                            collapsedShape: const Border(),
                          initiallyExpanded: !step1Done,
                            maintainState: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      step1Done ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: step1Done ? Colors.green : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text("Step 1: Advance Payment"),
                                  ],
                                ),
                                if (step1Done && _status?.statusFirst != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32, top: 4),
                                    child: Text(
                                      _status!.statusFirst!,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    _buildAmountInput("Tenant Pays", s1TenantCtl, !step1Done, context),
                                    const SizedBox(height: 10),
                                    _buildAmountInput("Give To Owner", s1GiveCtl, !step1Done, context),
                                    const SizedBox(height: 10),
                                    ValueListenableBuilder<int>(
                                      valueListenable: _calcTick,
                                      builder: (_, __, ___) {
                                        return _buildAmountDisplay("Office Hold", s1HoldCtl.text, context);
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    ElevatedButton(
                                      onPressed: step1Done ? null : _saveStep1,
                                      child: Text(step1Done ? "Completed" : "Save Step 1"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                            const SizedBox(height: 12),

                            // ================= STEP 2 ===================
                            Container(
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                              color: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.grey.shade200,

                              borderRadius: BorderRadius.circular(10)
                          ),

                          child: ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            childrenPadding: EdgeInsets.zero,

                            shape: const Border(),
                            collapsedShape: const Border(),
                            initiallyExpanded: step1Done && !step2Done,
                            maintainState: true,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      step2Done ? Icons.check_circle : Icons.radio_button_unchecked,
                                      color: step2Done ? Colors.green : Colors.orange,
                                    ),
                                    const SizedBox(width: 8),
                                    const Text("Step 2: Mid Payment"),

                                  ],
                                ),

                                if (step2Done && _status?.statusTwo != null)
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32, top: 4),
                                    child: Text(
                                      _status!.statusTwo!,
                                      style: const TextStyle(
                                        color: Colors.green,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    _buildAmountInput(
                                      "Tenant Pays",
                                      s2TenantCtl,
                                      step1Done && !step2Done,
                                      context,
                                    ),

                                    const SizedBox(height: 10),

                                    _buildAmountInput(
                                      "Owner Receives",
                                      s2OwnerCtl,
                                      step1Done && !step2Done,
                                      context,
                                    ),

                                    ValueListenableBuilder<int>(
                                      valueListenable: _calcTick,
                                      builder: (_, __, ___) {
                                        final double tenantVal = _pc(s2TenantCtl);
                                        final double ownerVal  = _pc(s2OwnerCtl);

                                        final bool canCalculate =
                                            s2TenantCtl.text.trim().isNotEmpty &&
                                                s2OwnerCtl.text.trim().isNotEmpty &&
                                                tenantVal > 0;

                                        final double step2Hold = canCalculate
                                            ? (tenantVal - ownerVal).clamp(0, double.infinity)
                                            : 0;

                                        return _buildSummaryItem(
                                          "Office Hold (Step-2)",
                                          step2Hold,
                                          Colors.orange,
                                        );
                                      },
                                    ),
                                    const SizedBox(height: 14),
                                    ElevatedButton(
                                      onPressed: step1Done && !step2Done ? _saveStep2 : null,
                                      child: const Text("Save Step 2"),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                            const SizedBox(height: 12),

                            // ================== Step 3 =================
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.black
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ExpansionTile(
                                tilePadding: EdgeInsets.zero,
                                childrenPadding: EdgeInsets.zero,

                             // 🔥 THESE TWO LINES REMOVE ALL BORDERS
                            shape: const RoundedRectangleBorder(
                              side: BorderSide.none,
                            ),
                            collapsedShape: const RoundedRectangleBorder(
                              side: BorderSide.none,
                            ),

                            initiallyExpanded: step1Done && !step2Done,
                            maintainState: true,

                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  step3Done ? Icons.check_circle : Icons.radio_button_unchecked,
                                  color: step3Done ? Colors.green : Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                const Text("Step 3: Final Settlement"),
                              ],
                            ),
                            if (step3Done && _status?.statusThree != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 32, top: 4),
                                child: Text(
                                  _status!.statusThree!,
                                  style: const TextStyle(
                                    color: Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _buildAmountInput(
                                  "Tenant pays (final)",
                                  s3TenantCtl,
                                  (s1Saved || step1Done) && !step3Done,
                                  context,
                                ),
                                const SizedBox(height: 12),

                                _buildAmountInput(
                                  "Company Commission",
                                  s3CompanyTotalCtl,
                                  (s1Saved || step1Done) && !step3Done,
                                  context,
                                ),
                                _buildSummaryItem(
                                  "Office Hold (Step-3)",
                                  settlementPool, // s1Hold + s2Hold
                                  Colors.orangeAccent,
                                ),
                              ],
                            ),
                          ),
                        ],

                              ),

                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8,),

                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.amber.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Office Detail",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // ================= STEP HOLDS =================
                      _buildColoredAmountRow(
                        "Step 1: Office Hold Added = ${_cur(s1Hold)}",
                        forcePolarity: Polarity.credit,
                      ),
                      const SizedBox(height: 4),

                      _buildColoredAmountRow(
                        "Step 2: Mid Amount transfer to owner = ${_cur(s2OwnerReceive)}",
                        forcePolarity: Polarity.debit,
                      ),
                      _buildColoredAmountRow(
                        "Office Hold (Step 2) = ${_cur(
                          (s2Tenant - s2OwnerReceive).clamp(0, double.infinity),
                        )}",
                        forcePolarity: Polarity.credit,
                      ),

                      const SizedBox(height: 8),

                      // ================= PENDING SETTLEMENT =================
                      _buildColoredAmountRow(
                        "Office Hold   = ${_cur(settlementPool)}",
                        forcePolarity: Polarity.officeSpecial,
                      ),


                      const SizedBox(height: 8),

                      // ================= STEP 3 =================
                      _buildColoredAmountRow(
                        "Step 3: Tenant Paid Final Amount = ${_cur(s3Tenant)}",
                        forcePolarity: Polarity.credit,
                      ),
                      const Divider(height: 24),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total Amount = ${_cur(settlementPool)} (Office Hold Amount) + ${_cur(s3Tenant)}(Tenant Final Amount)",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _buildColoredAmountRow(
                              "= ${_cur(settlementPool + s3Tenant)}",
                              forcePolarity: Polarity.officeSpecial,
                              showSign: false,
                            ),
                          ),
                        ],
                      ),


                      const SizedBox(height: 8),

                      // ================= COMMISSION CUT =================
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Company Cut Commission = ${_cur(settlementPool + s3Tenant)} − ${_cur(companyCommissionTotal)}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _buildColoredAmountRow(
                              "= ${_cur((settlementPool + s3Tenant - companyCommissionTotal).clamp(0, double.infinity))}",
                              forcePolarity: Polarity.officeSpecial,
                            ),
                          ),                        ],
                      ),

                      const Divider(),

                      // ================= FINAL =================
                      _buildColoredAmountRow(
                        "Company Received (Commission) = ${_cur(companyCommissionTotal)}",
                        forcePolarity: Polarity.neutral,
                      ),

                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              "Remaining Settlement to Owner",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white60
                                    : Colors.grey.shade600,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ),
                          Expanded(
                            child: _buildColoredAmountRow(
                              "= ${_cur(
                                (settlementPool + s3Tenant - companyCommissionTotal)
                                    .clamp(0, double.infinity),
                              )}",
                              forcePolarity: Polarity.neutral,
                              showSign: false,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      _buildColoredAmountRow(
                        "Balance = ${_cur(remaining)}",
                        forcePolarity: Polarity.neutral,
                      ),
                    ],
                  ),
                ),
                  // Visitor toggle
                  // ✅ ONLY show if visitor exists
                  if (visitorAvailable) ...[

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text("Visitor Commission (15%)"),
                        value: hasVisitor,
                        onChanged: step3Done || visitorLocked
                            ? null
                            : (v) {
                          setState(() {
                            hasVisitor = v;
                            _recalc(); // 🔥 recalc commission
                          });
                        },
                      ),
                    ),


                    // ✅ Amount ONLY when switch ON
                    if (hasVisitor)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: _buildAmountDisplay(
                          "Visitor Share",
                          visitorShare.toStringAsFixed(2),
                          context,
                        ),
                      ),
                  ],
                  Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Same header styling
                          Row(
                            children: [
                              Container(
                                width: 4,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: Colors.deepOrange,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                "Commission Distribution",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.deepOrange,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildColoredAmountRow(
                            "Company Commission (Total) = ${_cur(companyCommissionTotal)}",
                            forcePolarity: Polarity.credit, // or debit based on your logic
                          ),
                          const SizedBox(height: 4),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "GST (18%)",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 2),
                                  child: Text(
                                    "- ₹ ${gstAmount % 1 != 0
                                        ? gstAmount.toStringAsFixed(2)
                                        : gstAmount.toStringAsFixed(0)}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // _buildColoredAmountRow(
                          //   "GST (18%) = ${_cur(gstAmount)}",
                          //   forcePolarity: Polarity.debit,
                          // ),
                          const SizedBox(height: 4),
                          _buildColoredAmountRow(
                            "After GST = ${_cur(netAfterGst)}",
                            forcePolarity: Polarity.credit,
                          ),
                          const SizedBox(height: 4),
                          _buildColoredAmountRow(
                            "Office Share (50%) = ${_cur(officeFinalShare)}",
                            forcePolarity: Polarity.officeSpecial,
                          ),
                          const SizedBox(height: 4),
                          _buildColoredAmountRow(
                            "Field Worker Share = ${_cur(fieldWorkerFinalShare)}",
                            forcePolarity: Polarity.officeSpecial,
                          ),
                          if (hasVisitor) ...[
                            const SizedBox(height: 4),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Visitor Share (15%)",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: isDark ? Colors.white70 : Colors.grey.shade700,
                                      ),
                                    ),
                                  ),
                                    Text(
                                      "₹ ${visitorShare % 1 != 0
                                          ? visitorShare.toStringAsFixed(2)
                                          : visitorShare.toStringAsFixed(0)}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                      ),
                                    ),
                                ],
                              ),
                            )

                          ],
                        ],
                      ),
                    ),
                  ),
                  // Calculation Breakdown
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calculate,
                              color: Colors.blue.shade700,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Calculation Breakdown",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.cyan.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.cyan.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.cyan,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Tenant Detail",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.cyan,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // All payments are debits (red)
                              _buildColoredAmountRow(
                                "Step 1: Tenant Paid Advance = ${_cur(s1Tenant)}",
                                forcePolarity: Polarity.debit, // Force debit
                              ),
                              const SizedBox(height: 4),
                              _buildColoredAmountRow(
                                "Step 2: Tenant Paid Mid Amount = ${_cur(s2Tenant)}",
                                forcePolarity: Polarity.debit, // Force debit
                              ),
                              const SizedBox(height: 4),
                              _buildColoredAmountRow(
                                "Step 3: Tenant Paid last Amount = ${_cur(s3Tenant)}",
                                forcePolarity: Polarity.debit, // Force debit
                              ),
                              const SizedBox(height: 4),
                              _buildColoredAmountRow(
                                "Tenant Total Paid = ${_cur(s1Tenant+s2Tenant+s3Tenant)}",
                                forcePolarity: Polarity.neutral,
                              ),
                            ],
                          ),
                        ),

                        // Owner Details Section (All credits/green)
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.greenAccent.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 16,
                                    decoration: BoxDecoration(
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Owner Detail",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.greenAccent,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // All receipts are credits (green)
                              _buildColoredAmountRow(
                                "Step 1: Received by Owner = ${_cur(s1Give)}",
                                forcePolarity: Polarity.credit,
                              ),
                              const SizedBox(height: 4),
                              _buildColoredAmountRow(
                                "Step 2: Received by Owner = ${_cur(s2OwnerReceive)}",
                                forcePolarity: Polarity.credit,
                              ),

                              const SizedBox(height: 4),
                              _buildColoredAmountRow(
                                "Step 3: Received by Owner = ${_cur((settlementPool + s3Tenant - companyCommissionTotal).clamp(0, double.infinity))}",
                                forcePolarity: Polarity.credit, // Force credit
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Owner Total Received = ${_cur(s1Give)} + ${_cur(s2OwnerReceive)} + ${_cur((settlementPool + s3Tenant - companyCommissionTotal).clamp(0, double.infinity))}",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.white60
                                            : Colors.grey.shade600,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Expanded(
                                    child: _buildColoredAmountRow(
                                      "= ${_cur(ownerReceivedTotal)}",
                                      forcePolarity: Polarity.officeSpecial, // Force credit
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),


                      ],
                    ),
                  ),
                  // Final Action Button
                  if(userStoredFAadharCard == "Sub Administrator") ...[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (!(s1Saved || step1Done) || s3Saved || step3Done || _s3Submitting)
                            ? null
                            : _saveFinal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_s3Submitting)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            else if (step3Done)
                              const Icon(Icons.check_circle, size: 20),
                            if (_s3Submitting || step3Done) const SizedBox(width: 8),
                            Text(
                              _s3Submitting
                                  ? "Processing..."
                                  : ("Complete Final Settlement"),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _exactHeader(Property? p) {
    return Stack(
      children: [
        p != null && p.propertyPhoto.isNotEmpty
            ? Image.network(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.propertyPhoto}",
          height: 220,
          width: double.infinity,
          fit: BoxFit.cover,
        )
            : Container(
          height: 220,
          color: Colors.grey.shade300,
          child: const Center(
            child: Icon(Icons.home, size: 60, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
          const SizedBox(height: 16),
          const Text(
            "Loading Payment Details...",
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildError(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 16),
            const Text(
              "Failed to load data",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double amount,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _cur(amount),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "-";
    try {
      final dt = DateFormat('yyyy-MM-dd').parse(rawDate);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      try {
        final dt2 = DateTime.parse(rawDate);
        return DateFormat('dd MMM yyyy').format(dt2);
      } catch (_) {
        return rawDate;
      }
    }

  }

  Widget _peopleInfoCard({
    required String title,
    required Color color,
    required Map<String, String> rows,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ---------- HEADER ----------
          Row(
            children: [
              Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // ---------- ROWS ----------
          ...rows.entries.map(
                (e) => _infoRow(e.key, e.value, isDark),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white60 : Colors.grey.shade700,
            ),
          ),
          Text(
            value.isNotEmpty ? value : "-",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: Theme.of(context).colorScheme.onBackground.withOpacity(0.8),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal
                  ? Colors.lightBlue.shade300
                  : Theme.of(context).colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentItem(String label, String amount, Color color, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "₹ ${_formatNumber(amount)}",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(String label, TextEditingController controller, bool enabled, BuildContext context, {String? hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          enabled: enabled,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade400
                  : Colors.grey.shade600,
            ),
            prefixText: "₹ ",
            prefixStyle: TextStyle(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.blue.shade400,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade300,
              ),
            ),
            filled: true,
            fillColor: enabled
                ? (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade900
                    : Colors.white)
                : (Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade100),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
      ],

    );
  }

  Widget _buildAmountDisplay(String label, String value, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness==Brightness.dark ?Colors.white10:Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildColoredAmountRow(
    String text, {
    Polarity? forcePolarity,
    bool showSign = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Regex supports ₹12,34,567 and ₹123456
    final match = RegExp(r'₹\s*([\d,]+)').firstMatch(text);

    if (match != null) {
      final rawAmount = match.group(1)!.replaceAll(',', '');
      final amount = double.tryParse(rawAmount) ?? 0;

      // Split label and value safely
      final parts = text.split('=');
      final label = parts.first.trim();

      // -------- Determine polarity ----------
      Polarity polarity;

      if (forcePolarity != null) {
        polarity = forcePolarity;
      } else if (text.contains('Paid') ||
          text.contains('Hold') ||
          text.contains('Commission') ||
          text.contains('Gets') ||
          text.contains('Share') && !text.contains('Received')) {
        polarity = Polarity.debit;
      } else if (text.contains('Received') ||
          text.contains('Balance') ||
          text.contains('Total')) {
        polarity = Polarity.credit;
      } else {
        polarity = Polarity.neutral;
      }

      // -------- Color & Sign ----------
      Color amountColor;
      String sign = '';

      switch (polarity) {
        case Polarity.credit:
          amountColor = Colors.green;
          sign = showSign ? '+ ' : '';
          break;
        case Polarity.debit:
          amountColor = Colors.red;
          sign = showSign ? '- ' : '';
          break;
          case Polarity.officeSpecial:
          amountColor = Colors.blue;
          sign = showSign ? '' : '';
          break;
        case Polarity.neutral:
          amountColor = isDark ? Colors.white70 : Colors.grey.shade700;
          sign = '';
          break;
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.grey.shade700,
                ),
              ),
            ),

            if (sign.isNotEmpty)
              Text(
                sign,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: amountColor,
                ),
              ),
            Text(
              _cur(amount), // uses your existing ₹ formatter
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: amountColor,
              ),
            ),
          ],
        ),
      );
    }

    // -------- Non-amount / formula lines ----------
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          fontStyle: text.contains('+') || text.contains('−')
              ? FontStyle.italic
              : FontStyle.normal,
          color: isDark ? Colors.white60 : Colors.grey.shade600,
        ),
      ),
    );
  }

  Widget _buildSummaryItem(String label, double amount, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          Text(
            _cur(amount),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _formatNumber(String value) {
    final num = double.tryParse(value.replaceAll(',', '')) ?? 0;
    return NumberFormat('#,##0').format(num);
  }

  void _toast(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(msg)));
  }
}
