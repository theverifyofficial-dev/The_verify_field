import 'dart:convert';
import 'dart:ui' show FontFeature;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Add_Rented_Flat/FieldWorker_Complete_Page.dart';

// =====================================================
// MODELS
// =====================================================

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
class Tenant {
  final int id;
  final String status;
  // Tenant
  final String tenantName;
  final String tenantNumber;
  final String shiftingDate;
  final String paymentModeForTenant;

  // Owner
  final String ownerName;
  final String ownerNumber;
  final String paymentModeForOwner;

  // Visitor
  final String vist_field_workar_name;
  final String vist_field_workar_number;
  // Relation
  final String subId;

  Tenant(
      {required this.id,
        required this.tenantName,
        required this.tenantNumber,
        required this.shiftingDate,
        required this.paymentModeForTenant,
        required this.ownerName,
        required this.ownerNumber,
        required this.paymentModeForOwner,
        required this.subId,
        required this.status,
        required this.vist_field_workar_name,
        required this.vist_field_workar_number});

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: (json['id'] as num?)?.toInt() ?? 0,
      tenantName: json['tenant_name'] ?? '',
      tenantNumber: json['tenant_number'] ?? '',
      shiftingDate: json['shifting_date'] ?? '',
      paymentModeForTenant: json['payment_mode_for_tenant'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      paymentModeForOwner: json['payment_mode_for_owner'] ?? '',
      vist_field_workar_name: json['vist_field_workar_name'] ?? '',
      vist_field_workar_number: json['vist_field_workar_number'] ?? '',
      status: json['status'] ?? "",
      subId: json['subid']?.toString() ?? '',
    );
  }
}
class PaymentRecord {
  final int id;
  final int subid;

  final double tenantAdvance;
  final double giveToOwnerAdvance;
  final double officeHold;

  final double midPaymentToOwner;
  final double tenantPayLastAmount;

  final double companyCommission;
  final double companyKeepCommission;
  final double finalReceivedAmountOwner;
  final double totalPayTenant;

  final double officeGst;
  final double afterGstAmount;
  final double officeShare;
  final double fieldWorkerShare;
  final double visitorShare;

  final String statusFirst;
  final String statusSecond;
  final String statusFinal;

  final String date1;
  final String time1;
  final String date2;
  final String time2;
  final String date3;
  final String time3;

  PaymentRecord({
    required this.id,
    required this.subid,
    required this.tenantAdvance,
    required this.giveToOwnerAdvance,
    required this.officeHold,
    required this.midPaymentToOwner,
    required this.tenantPayLastAmount,
    required this.companyCommission,
    required this.companyKeepCommission,
    required this.finalReceivedAmountOwner,
    required this.totalPayTenant,
    required this.officeGst,
    required this.afterGstAmount,
    required this.officeShare,
    required this.fieldWorkerShare,
    required this.visitorShare,
    required this.statusFirst,
    required this.statusSecond,
    required this.statusFinal,
    required this.date1,
    required this.time1,
    required this.date2,
    required this.time2,
    required this.date3,
    required this.time3,
  });

  factory PaymentRecord.fromJson(Map<String, dynamic> json) {
    double d(dynamic v) =>
        double.tryParse(v?.toString().replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0;

    return PaymentRecord(
      id: int.parse(json['id'].toString()),
      subid: int.parse(json['subid'].toString()),

      tenantAdvance: d(json['tenant_advance']),
      giveToOwnerAdvance: d(json['give_to_owner_advance']),
      officeHold: d(json['office_hold']),
      midPaymentToOwner: d(json['mid_payment_to_owner']),
      tenantPayLastAmount: d(json['tenant_pay_last_amount']),

      companyCommission: d(json['bothside_company_comition']),
      companyKeepCommission: d(json['company_keep_comition']),
      finalReceivedAmountOwner: d(json['final_recived_amount_owner']),
      totalPayTenant: d(json['total_pay_tenant']),

      officeGst: d(json['office_gst']),
      afterGstAmount: d(json['after_gst_amount']),
      officeShare: d(json['office_share_fifty_percent']),
      fieldWorkerShare: d(json['field_workar_share_fifity_percent']),
      visitorShare: d(json['visiter_share']),

      statusFirst: json['status_fist'] ?? '',
      statusSecond: json['status_tow'] ?? '',
      statusFinal: json['status_three'] ?? '',

      date1: json['dates'] ?? '',
      time1: json['times'] ?? '',
      date2: json['dates_2nd'] ?? '',
      time2: json['times_2nd'] ?? '',
      date3: json['dates_3rd'] ?? '',
      time3: json['times_3rd'] ?? '',
    );
  }
}
class OwnerData {
  int id;
  String ownerName;
  String ownerNumber;
  String paymentMode;
  String advanceAmount;
  String rent;
  String securitys;
  String subid;
  String status;

  OwnerData({
    required this.id,
    required this.ownerName,
    required this.ownerNumber,
    required this.paymentMode,
    required this.advanceAmount,
    required this.rent,
    required this.securitys,
    required this.subid,
    required this.status,
  });

  factory OwnerData.fromJson(Map<String, dynamic> json) => OwnerData(
    id: json["id"] ?? 0,
    ownerName: json["owner_name"] ?? "-",
    ownerNumber: json["owner_number"] ?? "-",
    paymentMode: json["payment_mode"] ?? "-",
    advanceAmount: json["advance_amount"] ?? "0",
    rent: json["rent"] ?? "0",
    securitys: json["securitys"] ?? "0",
    subid: json["subid"] ?? "-",
    status: json["status"] ?? "-",
  );


  Map<String, dynamic> toJson() => {
    "id": id,
    "owner_name": ownerName,
    "owner_number": ownerNumber,
    "payment_mode": paymentMode,
    "advance_amount": advanceAmount,
    "rent": rent,
    "securitys": securitys,
    "subid": subid,
    "status": status,
  };
}

// =====================================================
// SCREEN
// =====================================================

class Show_Billing_Fieldworker_Pending_Page extends StatefulWidget {

  final int propertyId;
  final String tenantCommission;
  final String ownerCommission;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String flatId;
  const Show_Billing_Fieldworker_Pending_Page({super.key, required this.propertyId, required this.tenantCommission, required this.ownerCommission, required this.fieldworkerName, required this.fieldworkerNumber, required this.flatId});

  @override
  State<Show_Billing_Fieldworker_Pending_Page> createState() => _Show_Billing_Fieldworker_Pending_PageState();
}

class _Show_Billing_Fieldworker_Pending_PageState extends State<Show_Billing_Fieldworker_Pending_Page> {
  // Base fetch
  late Future<Property?> _futureProperty;

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
  PaymentRecord? _status;
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
// toggle visitor availability (you can later bind from API)


  static const _propListEndpoint = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_complete_page_for_admin.php";
  static const _statusEndpoint  = "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_final_payment_api_for_complete.php";
  bool _s2Submitting = false;

  static const _step1Endpoint   = "https://verifyserve.social/Second%20PHP%20FILE/Payment/paymet_inset.php";

  static const _step2Endpoint =
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/add_second_setp_amount.php";
  late double commissionBothSide;
  double apiNum(String? v) {
    if (v == null) return 0;
    return double.tryParse(v.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0;
  }

  @override
  void initState() {
    super.initState();
    loadUserName();

    _futureProperty = _fetchPropertyById(widget.propertyId);

    _futureProperty.then((p) async {
      if (p == null) return;

      if (_subId == null) {
        debugPrint("❌ subId not available");
        return;
      }

      debugPrint("✅ INIT with subId=$_subId");

      await _loadBooking(_subId!);
      await _refreshStatus(_subId!);
    });

    commissionBothSide =
        _safeDouble(widget.ownerCommission) +
            _safeDouble(widget.tenantCommission);

    s3CompanyTotalCtl.text = commissionBothSide.toStringAsFixed(0);
  }

  Future<PaymentRecord?> _fetchPaymentStatusBySubId(int subid) async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_payment1_base_on_sub_id.php?subid=$subid",
    );

    final res = await http.get(uri);

    debugPrint("🟣 STATUS API CODE: ${res.statusCode}");
    debugPrint("🟣 STATUS API BODY: ${res.body}");

    if (res.statusCode != 200) return null;

    final decoded = json.decode(res.body);

    if (decoded["success"] != true) return null;

    final List list = decoded["data"] ?? [];

    if (list.isEmpty) return null;

    // ✅ API returns history → latest record matters
    final Map<String, dynamic> latest =
    Map<String, dynamic>.from(list.last);

    debugPrint("🟢 STATUS FINAL ROW: $latest");

    return PaymentRecord.fromJson(latest);
  }

  int? _subId;


  Future<void> _loadBooking(int subid) async {
    final booking = await _fetchBookingBySubId(subid);

    if (booking == null) {
      debugPrint("❌ No booking found for subid $subid");
      return;
    }

    setState(() {
      s1TenantCtl.text = booking['Advance_Payment'] ?? '0';
      s2TenantCtl.text = booking['second_amount'] ?? '0';
      s3TenantCtl.text = booking['final_amount'] ?? '0';

      rent        = _safeDouble(booking['Rent']);
      security    = _safeDouble(booking['Security']);
      tenantComm  = _safeDouble(booking['Commission']);
      totalDue    = _safeDouble(booking['Total_Balance']);
    });

    _recalc();
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

  String? userName;
  String? userNumber;
  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');

    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
      });
    }
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
  Future<List<Tenant>> fetchTenants(int subId) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_pending_rentout_api_tenant_owner.php?subid=$subId",
    );

    final response = await http.get(url);

    debugPrint("🟡 TENANT STATUS: ${response.statusCode}");
    debugPrint("🟡 TENANT RAW RESPONSE: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}");
    }

    final jsonResponse = json.decode(response.body);
    debugPrint("🟢 TENANT PARSED JSON: $jsonResponse");

    if (jsonResponse["success"] == true &&
        jsonResponse["data"] is List) {
      return (jsonResponse["data"] as List)
          .map((e) => Tenant.fromJson(e))
          .toList();
    }

    return [];
  }
  Future<Property> _fetchPropertyById(int id) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_fieldworkar.php?field_workar_number=${widget.fieldworkerNumber}",
    );


    final res = await http.get(url);

    debugPrint("🟡 PROPERTY STATUS CODE: ${res.statusCode}");
    debugPrint("🟡 PROPERTY RAW RESPONSE: ${res.body}");

    if (res.statusCode != 200) {
      throw Exception("Failed to load properties");
    }

    final body = json.decode(res.body);
    debugPrint("🟢 PROPERTY PARSED JSON: $body");

    if (body["success"] != true) {
      throw Exception(body["message"] ?? "API error");
    }

    final List data = body["data"] as List;
    debugPrint("🟢 PROPERTY COUNT: ${data.length}");

    final list = data.map((e) => Property.fromJson(e)).toList();

    final match = list.firstWhere(
          (p) => p.id == id,
      orElse: () => list.first,
    );

// ✅ ADD THIS LINE
    _subId = int.tryParse(match.subid.toString());
    debugPrint("🟢 SUBID SET = $_subId");
    return match;

  }

  Future<Map<String, dynamic>?> _fetchBookingBySubId(int subid) async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_payment1_base_on_sub_id.php?subid=$subid",
    );

    final res = await http.get(uri);

    debugPrint("🟡 BOOKING STATUS CODE: ${res.statusCode}");
    debugPrint("🟡 BOOKING RAW RESPONSE: ${res.body}");

    if (res.statusCode != 200) return null;

    final body = json.decode(res.body);
    debugPrint("🟢 BOOKING PARSED JSON: $body");

    if (body['success'] != true) return null;

    final List list = body['data'] ?? [];
    debugPrint("🟢 BOOKING DATA COUNT: ${list.length}");

    if (list.isEmpty) return null;

    // ✅ API already gives correct subid data → take latest record
    final Map<String, dynamic> booking =
    Map<String, dynamic>.from(list.last);

    debugPrint("🟢 BOOKING FINAL ROW: $booking");

    return booking;
  }

  bool _visitorInitialized = false;
  bool _changed = false;

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
      subid: _subId!,
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
    await _refreshStatus(_subId!);
  }
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
    await _refreshStatus(_subId!); // ✅
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
    await _refreshStatus(_subId!);

    // tell previous page to refresh
    if (mounted) Navigator.pop(context, true);
  }
  Future<void> _refreshStatus(int subid) async {
    setState(() => _loadingStatus = true);

    try {
      final booking = await _fetchBookingBySubId(subid);

      if (booking == null) {
        step1Done = step2Done = step3Done = false;
        return;
      }

      // ✅ STATUS FLAGS (FROM YOUR API)
      step1Done = booking['Advance_Payment'] != null &&
          booking['Advance_Payment'].toString().isNotEmpty;

      step2Done = booking['second_amount'] != null &&
          booking['second_amount'].toString().isNotEmpty;

      step3Done = booking['final_amount'] != null &&
          booking['final_amount'].toString().isNotEmpty;

      // ✅ LOCK VALUES IF DONE
      if (step1Done) {
        s1TenantCtl.text = booking['Advance_Payment'].toString();
        s1Saved = true;
      }

      if (step2Done) {
        s2TenantCtl.text = booking['second_amount'].toString();
        s2Saved = true;
      }

      if (step3Done) {
        s3TenantCtl.text = booking['final_amount'].toString();
        s3Saved = true;
      }

      _recalc();
    } finally {
      if (mounted) setState(() => _loadingStatus = false);
    }
  }


  // -----------------------------------------------------
  // APPLY STATUS TO UI
  // -----------------------------------------------------
  final ValueNotifier<int> _calcTick = ValueNotifier(0);

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
  bool _s3Submitting = false;

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
    // STEP 1
    s1Tenant = _pc(s1TenantCtl);
    s1Give   = _pc(s1GiveCtl);
    s1Hold   = (s1Tenant - s1Give).clamp(0, double.infinity);

    // STEP 2
    s2Tenant = _pc(s2TenantCtl);

    // STEP 3
    s3Tenant = _pc(s3TenantCtl);

    // COMMISSION (both-side)
    companyCommissionTotal =
        _pc(s3CompanyTotalCtl).clamp(0, double.infinity);

    // GST (DISPLAY ONLY)
    gstAmount = companyCommissionTotal * 0.18;
    netAfterGst = companyCommissionTotal - gstAmount;

    // TENANT TOTAL PAID
    tenantPaid = s1Tenant + s2Tenant + s3Tenant;

    // ✅ FINAL + HOLD POOL
    settlementPool = s3Tenant + s1Hold;

    // ✅ COMPANY GETS ONLY COMMISSION
    companyKeepNow = companyCommissionTotal;

    // ✅ OWNER FINAL SHARE FROM POOL
    ownerFinalNow =
        (settlementPool - companyCommissionTotal).clamp(0, double.infinity);

    // ✅ OWNER TOTAL RECEIVED
    ownerReceivedTotal =
        s1Give + s2Tenant + ownerFinalNow;

    // REMAINING (if any)
    remaining = (totalDue - tenantPaid).clamp(0, double.infinity);

    // SPLIT (DISPLAY ONLY)
    officeFinalShare = netAfterGst * 0.5;
    fieldWorkerFinalShare = netAfterGst * 0.5;

    if (hasVisitor) {
      visitorShare = companyCommissionTotal * 0.15;
      fieldWorkerFinalShare =
          (fieldWorkerFinalShare - visitorShare).clamp(0, double.infinity);
    } else {
      visitorShare = 0;
    }
    _calcTick.value++;
  }

  double _toD(String v) => double.tryParse(v.replaceAll(',', '').trim()) ?? 0;
  double _pc(TextEditingController c) => double.tryParse(c.text) ?? 0;
  String _cur(num value) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹ ',
      decimalDigits: 0,
    );
    return formatter.format(value);
  }
  String _intStr(num v) => v.toStringAsFixed(0);
  String _numOnly(String s) {
    final cleaned = s.replaceAll(RegExp(r'[^0-9.]'), '');
    final d = double.tryParse(cleaned) ?? 0;
    return d.toStringAsFixed(0);
  }

  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_fieldworkar.php?field_workar_number=${widget.fieldworkerNumber}",
    );

    final response = await http.get(url);

    debugPrint("🟡 BOOKING LIST STATUS: ${response.statusCode}");
    debugPrint("🟡 BOOKING LIST RAW RESPONSE: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}");
    }

    final decoded = json.decode(response.body);

    if (decoded["success"] == true) {
      List data = decoded["data"];

      return data
          .map((e) => Property.fromJson(e))
          .toList()
          .reversed
          .toList();
    }

    throw Exception("API success=false");
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
            title: const Text("Show Billing",style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.white,
                fontWeight: FontWeight.w600
            ),

            )
        ),
        body:FutureBuilder<Property?>(
          future: _futureProperty,
          builder: (ctx, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            }

            if (snap.connectionState == ConnectionState.waiting) {
              return _buildSkeletonUI(); // 👈 NEW
            }


            final property = snap.data!;
            commissionBothSide = _toD(widget.ownerCommission) + _toD(widget.tenantCommission);

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [


                  const SizedBox(height: 8),
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
                                    "Field Worker : ${widget.fieldworkerName}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Field Worker No : ${widget.fieldworkerNumber}",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
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
                      final bool newHasVisitor =
                          t.vist_field_workar_name.trim().isNotEmpty &&
                              t.vist_field_workar_name.trim() != "-";

                      if (hasVisitor != newHasVisitor) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (mounted) {
                            setState(() {
                              hasVisitor = newHasVisitor;
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
                  const SizedBox(height: 8),

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
                                // 🔹 TOTAL AMOUNT (DOUBLE)
                                final double newTotalAmount =
                                item.totalBalance.trim().isNotEmpty &&
                                    item.totalBalance.trim() != "-"
                                    ? double.tryParse(
                                  item.totalBalance.replaceAll(RegExp(r'[^0-9.]'), ''),
                                ) ??
                                    0
                                    : 0;
                                if (totalDue != newTotalAmount) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    if (mounted) {
                                      setState(() {
                                        totalDue = newTotalAmount;
                                      });
                                    }
                                  });
                                }

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
              FutureBuilder<PaymentRecord?>(
                future: _fetchPaymentStatusBySubId(widget.propertyId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (!snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Container(
                        margin: const EdgeInsets.all( 16),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange.shade700,
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                "Payment details are not available yet.\nPlease complete the payment steps to view records.",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }


                  final p = snapshot.data!;

                  return Container(

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ================= STEP 1 =================
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                            ],
                          ),
                          child: Column(
                            children: [
                              _stepTitle("Step 1 : Advance Payment", completed: true),
                              _buildAmountDisplay("Tenant Advance", _cur(p.tenantAdvance), context),
                              _buildAmountDisplay("Give To Owner", _cur(p.giveToOwnerAdvance), context),
                              _buildAmountDisplay("Office Hold", _cur(p.officeHold), context),
                              _savedButton(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Divider(height: 32),
                        ),
                        if (p.midPaymentToOwner > 0)
                          // ================= STEP 2 =================
                          Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.all(16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    _stepTitle("Step 2 : Mid Payment", completed: true),
                                    _buildAmountDisplay(
                                      "Mid Payment to Owner",
                                      _cur(p.midPaymentToOwner),
                                      context,
                                    ),
                                    _savedButton(),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                child: Divider(height: 32),
                              ),
                            ],
                          ),


                        // ================= STEP 3 =================
                        if (p.tenantPayLastAmount > 0 && p.companyCommission > 0)
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
                            ],
                          ),
                          child: Column(
                            children: [
                              _stepTitle("Step 3 : Final Settlement", completed: true),
                              _buildAmountDisplay(
                                "Tenant Final Payment",
                                _cur(p.tenantPayLastAmount),
                                context,
                              ),
                              _buildAmountDisplay(
                                "Company Commission",
                                _cur(p.companyCommission),
                                context,
                              ),

                              SizedBox(height: 6,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Visitor Commission",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    hasVisitor ? "YES" : "NO",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: hasVisitor ? Colors.green : Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              _buildAmountDisplay(
                                "Commission",
                                _cur(p.visitorShare),
                                context,
                              ),
                            ],
                          ),
                        ),
                        // Commission Distribution
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
                                  "Company Commission (Total) = ${_cur(p.companyCommission)}",
                                  forcePolarity: Polarity.credit, // or debit based on your logic
                                ),
                                const SizedBox(height: 4),
                                _buildColoredAmountRow(
                                  "GST (18%) = ${_cur(p.officeGst)}",
                                  forcePolarity: Polarity.debit,
                                ),
                                const SizedBox(height: 4),
                                _buildColoredAmountRow(
                                  "After GST = ${_cur(p.afterGstAmount)}",
                                  forcePolarity: Polarity.credit,
                                ),
                                const SizedBox(height: 4),
                                _buildColoredAmountRow(
                                  "Office Share (50%) = ${_cur(p.officeShare)}",
                                  forcePolarity: Polarity.officeSpecial,
                                ),
                                const SizedBox(height: 4),
                                _buildColoredAmountRow(
                                  "Field Worker Share = ${_cur(p.fieldWorkerShare)}",
                                  forcePolarity: Polarity.officeSpecial,
                                ),
                                if (hasVisitor) ...[
                                  const SizedBox(height: 4),
                                  _buildColoredAmountRow(
                                    "Visitor Share (15%) = ${_cur(p.visitorShare)}",
                                    forcePolarity: Polarity.officeSpecial,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 8,),
                        Container(
                          margin: const EdgeInsets.all(16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.amber.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.amber.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // HEADER
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

                              // STEP 1
                              _buildColoredAmountRow(
                                "Step 1: Office Hold = ${_cur(p.officeHold)}",
                                forcePolarity: Polarity.credit,
                              ),

                              const SizedBox(height: 4),

                              // STEP 2
                              _buildColoredAmountRow(
                                "Step 2: Mid Amount transfer to owner = ${_cur(p.midPaymentToOwner)}",
                                forcePolarity: Polarity.debit,
                              ),

                              const SizedBox(height: 4),

                              // STEP 3
                              _buildColoredAmountRow(
                                "Step 3: Tenant Paid Final Amount = ${_cur(p.tenantPayLastAmount)}",
                                forcePolarity: Polarity.credit,
                              ),

                              const SizedBox(height: 6),

                              // SETTLEMENT POOL (API LOGIC)
                              Text(
                                "Settlement Pool = ${p.officeHold}+ ${p.tenantPayLastAmount}",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white60
                                      : Colors.grey.shade600,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),

                              _buildColoredAmountRow(
                                "= ${_cur(p.officeHold + p.tenantPayLastAmount)}",
                                forcePolarity: Polarity.officeSpecial,
                              ),

                              const Divider(),

                              // COMPANY COMMISSION
                              _buildColoredAmountRow(
                                "Company Commission = ${_cur(p.companyKeepCommission)}",
                                forcePolarity: Polarity.debit,
                              ),

                              const SizedBox(height: 4),

                              // OWNER FINAL SHARE
                              _buildColoredAmountRow(
                                "Owner Final Share = ${_cur(p.officeHold + p.tenantPayLastAmount-p.companyKeepCommission)}",
                                forcePolarity: Polarity.credit,
                              ),


                            ],
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
                                        const Text(
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

                                    _buildColoredAmountRow(
                                      "Step 1: Tenant Paid Advance = ${_cur(p.tenantAdvance)}",
                                      forcePolarity: Polarity.debit,
                                    ),
                                    const SizedBox(height: 4),
                                    _buildColoredAmountRow(
                                      "Step 2: Tenant Paid Mid Amount = ${_cur(p.midPaymentToOwner)}",
                                      forcePolarity: Polarity.debit,
                                    ),
                                    const SizedBox(height: 4),
                                    _buildColoredAmountRow(
                                      "Step 3: Tenant Paid Last Amount = ${_cur(p.tenantPayLastAmount)}",
                                      forcePolarity: Polarity.debit,
                                    ),
                                    const SizedBox(height: 4),

                                    // TENANT TOTAL
                                    _buildColoredAmountRow(
                                      "Tenant Total Paid = ${_cur(p.totalPayTenant)}",
                                      forcePolarity: Polarity.neutral,
                                    ),
                                  ],
                                ),
                              ),
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
                                        const Text(
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

                                    _buildColoredAmountRow(
                                      "Step 1: Received by Owner = ${_cur(p.giveToOwnerAdvance)}",
                                      forcePolarity: Polarity.credit,
                                    ),
                                    const SizedBox(height: 4),
                                    _buildColoredAmountRow(
                                      "Step 2: Received by Owner = ${_cur(p.midPaymentToOwner)}",
                                      forcePolarity: Polarity.credit,
                                    ),
                                    const SizedBox(height: 4),
                                    _buildColoredAmountRow(
                                      "Step 3: Received by Owner = ${_cur(p.officeHold + p.tenantPayLastAmount-p.companyKeepCommission)}",
                                      forcePolarity: Polarity.credit,
                                    ),
                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 2,
                                          child: Text(
                                            "Owner Total Received = ${_cur(p.giveToOwnerAdvance)} + ${_cur(p.midPaymentToOwner)} + ${_cur(p.officeHold + p.tenantPayLastAmount-p.companyKeepCommission)}",
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
                                                p.giveToOwnerAdvance +
                                                    p.midPaymentToOwner +
                                                    p.officeHold + p.tenantPayLastAmount-p.companyKeepCommission
                                            )}",
                                            forcePolarity: Polarity.officeSpecial,
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
                        if(p.statusFinal!=null && p.statusFinal.isNotEmpty)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.green.withOpacity(0.4)),
                          ),
                          child: Center(
                            child: Text(
                              p.statusFinal,
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,)
                      ],
                    ),
                  );
                },
              ),






                ],
              ),
            );
          },
        ),
      ),
    );
  }
  Widget _stepTitle(String title, {bool completed = false}) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: completed ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: completed ? Colors.green : Colors.grey.shade800,
          ),
        ),
      ],
    );
  }
  Widget _savedButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.12),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green.withOpacity(0.4)),
        ),
        child: const Center(
          child: Text(
            "Saved",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
  Widget _sectionHeader(String title, Color color) {
    return Row(
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
    );
  }
  String safeStatus(String? v) {
    if (v == null || v.trim().isEmpty) return "Completed";
    return v;
  }

  Widget _buildSkeletonUI() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(height: 220, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          _skeletonCard(),
          _skeletonCard(),
          _skeletonCard(),
        ],
      ),
    );
  }
  Widget amountRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _skeletonCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 120,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
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

  Widget _simpleTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _simpleRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value.isNotEmpty ? value : "-",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  int _safeSubId(dynamic v) {
    return int.tryParse(v?.toString() ?? '') ?? 0;
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

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  // Helper Widget Methods
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
  Widget _buildExpansionSection({
    required BuildContext context,
    required String title,
    required IconData icon,
    required List<Widget> children,
    bool initiallyExpanded = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            initiallyExpanded: initiallyExpanded,
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            leading: Icon(icon, size: 18, color: Colors.blue.shade700),
            title: Text(
              title,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.expand_more, size: 16),
            children: children,
          ),
        ),
      ),
    );
  }
  Widget _buildPersonSection(String title, List<Widget> details, Color bgColor, {required bool isDarkMode}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          ...details,
        ],
      ),
    );
  }
  Widget _buildPersonDetail(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              "$label:",
              style: TextStyle(
                fontSize: 11,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : "Not provided",
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800,
              ),
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

  Widget _buildStepContainer({
    required int step,
    required String title,
    required bool isCompleted,
    required Widget child,
    String? status,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade200,
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isCompleted ? Colors.green.shade500 : Colors.grey.shade300,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    step.toString(),
                    style: TextStyle(
                      color: isCompleted ? Colors.white : Colors.grey.shade700,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isCompleted ? Colors.green.shade700 :Theme.of(context).brightness==Brightness.dark?Colors.white: Colors.grey.shade800,
                  ),
                ),
              ),
              if (isCompleted)
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade500,
                  size: 20,
                ),
            ],
          ),
          if (status != null && status.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 40),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.green.shade600,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _amountViewRow(String label, String value, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey.shade900 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
            ),
          ),
          child: Text(
            value.isNotEmpty ? value : "—",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black,
            ),
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

  Widget _buildDateTimeStamp(String? date, String? time, BuildContext context) {
    if (date == null || date.isEmpty || time == null || time.isEmpty) {
      return const SizedBox();
    }

    try {
      // Combine date + time from API
      final rawDateTime = DateTime.parse("$date $time");

      // Format to Indian standard (dd/MM/yyyy hh:mm a)
      final formatted = DateFormat("dd/MM/yyyy  hh:mm a").format(rawDateTime);

      return Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.green.withOpacity(0.15)
              : Colors.green.shade50,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.greenAccent.withOpacity(0.4)
                : Colors.green.shade100,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.access_time,
              size: 14,
              color: Colors.green.shade600,
            ),
            const SizedBox(width: 6),
            Text(
              formatted, // 👈 IST + AM/PM
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.greenAccent
                    : Colors.green.shade700,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return const SizedBox();
    }
  }

  Widget _buildStepButton({
    required VoidCallback onPressed,
    required bool isSubmitting,
    required bool isCompleted,
    required String label,
    required bool isEnabled,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: isCompleted ? Colors.green.shade500 : Colors.blue.shade600,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSubmitting)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            if (isSubmitting) const SizedBox(width: 8),
            Text(
              isSubmitting
                  ? "Saving..."
                  : (isCompleted ? "✓ Completed" : label),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalculationSection({
    required String title,
    required Color color,
    required List<String> items,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
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
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: _buildColoredAmountRow(item),
          )).toList(),
        ],
      ),
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
            Text(
              '= ',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
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
