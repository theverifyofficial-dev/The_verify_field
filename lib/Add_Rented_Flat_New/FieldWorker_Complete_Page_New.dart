import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Add_Rented_Flat/Action_Form.dart';
import '../../Add_Rented_Flat/Add_Tenent.dart';
import '../../Add_Rented_Flat/FieldWorker_Booking_Page_Details.dart';
import '../../Add_Rented_Flat/FieldWorker_Complete_Detail_Page.dart';
import '../../constant.dart';
import '../Administrator/All_Rented_Flat/CompletePropertyCalculationPage.dart';
import 'CompletePropertyCalculationFieldWorker.dart';
class PaymentAmount {
  final String label;
  final dynamic value;
  final Color color;

  PaymentAmount(this.label, this.value, this.color);
}
class Property {
  final int pId;
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
  final dynamic sourceId;

  // ✅ New fields
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;
  final String secondAmount;
  final String finalAmount;
  final String ownerCommission;

  Property({
    required this.pId,
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
    required this.ownerCommission,
    required this.sourceId,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      pId: json["P_id"] ?? 0,
      propertyPhoto: json["property_photo"] ?? "",
      locations: json["locations"] ?? "",
      flatNumber: json["Flat_number"] ?? "",
      buyRent: json["Buy_Rent"] ?? "",
      residenceCommercial: json["Residence_Commercial"] ?? "",
      apartmentName: json["Apartment_name"] ?? "",
      apartmentAddress: json["Apartment_Address"] ?? "",
      typeOfProperty: json["Typeofproperty"] ?? "",
      bhk: json["Bhk"] ?? "",
      ownerCommission: json["owner_side_commition"] ?? "",
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
      sourceId: json["source_id"] ?? "",
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

class OwnerModel {
  bool success;
  List<OwnerData> data;

  OwnerModel({
    required this.success,
    required this.data,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
        success: json["success"],
        data: List<OwnerData>.from(
            json["data"].map((x) => OwnerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
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
// FirstPaymentRecord.dart

// FirstPaymentRecord.dart

class FirstPaymentRecord {
  final int id;
  final String subid;

  // statuses (backend keys: status_fist, status_tow, status_three)
  final String statusFirst;
  final String statusSec;
  final String statusThird;

  // step 1
  final String tenantAdvance;        // tenant_advance
  final String giveToOwnerAdvance;   // give_to_owner_advance
  final String officeHold;           // office_hold

  // step 2
  final String? midPaymentToOwner;         // mid_payment_to_owner
  final String? ownerReceivedPaymentInMid; // owner_reccived_payment_in_mid

  // step 3 (legacy set you already had)
  final String? tenantPayLastAmount;         // tenant_pay_last_amount
  final String? bothSideCompanyCommission;   // bothside_company_comition
  final String? ownerReceivedFinalAmount;    // owner_recived_final_amount
  final String? tenantTotalPay;              // tenant_tatal_pay
  final String? ownerTotalReceivedAmount;    // owner_total_recived_amount

  // step 3 (new keys to add)
  final String? remainingHold;               // remaining_hold
  final String? companyKeepComition;         // company_keep_comition
  final String? remainBalanceShareToOwner;   // remain_balance_share_to_owner
  final String? finalRecivedAmountOwner;     // final_recived_amount_owner
  final String? remaingFinalBalance;         // remaing_final_balance
  final String? totalPayTenant;              // total_pay_tenant

  // timestamps from backend
  final String? dates;       // 1st step date: "YYYY-MM-DD"
  final String? times;       // 1st step time: "HH:MM:SS"
  final String? dates2nd;    // dates_2nd
  final String? times2nd;    // times_2nd
  final String? dates3rd;    // dates_3rd
  final String? times3rd;    // times_3rd

  final String? visitorShare;
  final String? officeGst;
  final String? afterGstAmount;
  final String? officeShareFiftyPercent;
  final String? fieldWorkarShareFiftyPercent;

  FirstPaymentRecord({
    required this.id,
    required this.subid,
    required this.statusFirst,
    required this.statusSec,
    required this.statusThird,
    required this.tenantAdvance,
    required this.giveToOwnerAdvance,
    required this.officeHold,
    this.midPaymentToOwner,
    this.ownerReceivedPaymentInMid,
    this.tenantPayLastAmount,
    this.bothSideCompanyCommission,
    this.ownerReceivedFinalAmount,
    this.tenantTotalPay,
    this.ownerTotalReceivedAmount,
    this.remainingHold,
    this.companyKeepComition,
    this.remainBalanceShareToOwner,
    this.finalRecivedAmountOwner,
    this.remaingFinalBalance,
    this.totalPayTenant,
    this.dates,
    this.times,
    this.dates2nd,
    this.times2nd,
    this.dates3rd,
    this.times3rd,
    this.visitorShare,
    this.officeGst,
    this.afterGstAmount,
    this.officeShareFiftyPercent,
    this.fieldWorkarShareFiftyPercent,
  });

  factory FirstPaymentRecord.fromJson(Map<String, dynamic> j) {
    String? _s(String key) => j.containsKey(key) ? j[key]?.toString() : null;

    return FirstPaymentRecord(
      id: int.tryParse(j['id']?.toString() ?? '') ?? 0,
      subid: (j['subid'] ?? '').toString(),

      statusFirst: (j['status_fist'] ?? '').toString(),
      statusSec: (j['status_tow'] ?? '').toString(),
      statusThird: (j['status_three'] ?? '').toString(),

      tenantAdvance: (j['tenant_advance'] ?? '').toString(),
      giveToOwnerAdvance: (j['give_to_owner_advance'] ?? '').toString(),
      officeHold: (j['office_hold'] ?? '').toString(),

      midPaymentToOwner: _s('mid_payment_to_owner'),
      ownerReceivedPaymentInMid: _s('owner_reccived_payment_in_mid'),

      tenantPayLastAmount: _s('tenant_pay_last_amount'),
      bothSideCompanyCommission: _s('bothside_company_comition'),
      ownerReceivedFinalAmount: _s('owner_recived_final_amount'),
      tenantTotalPay: _s('tenant_tatal_pay'),
      ownerTotalReceivedAmount: _s('owner_total_recived_amount'),

      remainingHold: _s('remaining_hold'),
      companyKeepComition: _s('company_keep_comition'),
      remainBalanceShareToOwner: _s('remain_balance_share_to_owner'),
      finalRecivedAmountOwner: _s('final_recived_amount_owner'),
      remaingFinalBalance: _s('remaing_final_balance'),
      totalPayTenant: _s('total_pay_tenant'),

      dates: _s('dates'),
      times: _s('times'),
      dates2nd: _s('dates_2nd'),
      times2nd: _s('times_2nd'),
      dates3rd: _s('dates_3rd'),
      times3rd: _s('times_3rd'),

      visitorShare: _s('visiter_share'),
      officeGst: _s('office_gst'),
      afterGstAmount: _s('after_gst_amount'),
      officeShareFiftyPercent: _s('office_share_fifty_percent'),
      fieldWorkarShareFiftyPercent: _s('field_workar_share_fifity_percent'),


    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subid': subid,
    'status_fist': statusFirst,
    'status_tow': statusSec,
    'status_three': statusThird,
    'tenant_advance': tenantAdvance,
    'give_to_owner_advance': giveToOwnerAdvance,
    'office_hold': officeHold,
    'mid_payment_to_owner': midPaymentToOwner,
    'owner_reccived_payment_in_mid': ownerReceivedPaymentInMid,
    'tenant_pay_last_amount': tenantPayLastAmount,
    'bothside_company_comition': bothSideCompanyCommission,
    'owner_recived_final_amount': ownerReceivedFinalAmount,
    'tenant_tatal_pay': tenantTotalPay,
    'owner_total_recived_amount': ownerTotalReceivedAmount,
    'remaining_hold': remainingHold,
    'company_keep_comition': companyKeepComition,
    'remain_balance_share_to_owner': remainBalanceShareToOwner,
    'final_recived_amount_owner': finalRecivedAmountOwner,
    'remaing_final_balance': remaingFinalBalance,
    'total_pay_tenant': totalPayTenant,
    'dates': dates,
    'times': times,
    'dates_2nd': dates2nd,
    'times_2nd': times2nd,
    'dates_3rd': dates3rd,
    'times_3rd': times3rd,

    'visiter_share': visitorShare,
    'office_gst': officeGst,
    'after_gst_amount': afterGstAmount,
    'office_share_fifty_percent': officeShareFiftyPercent,
    'field_workar_share_fifity_percent': fieldWorkarShareFiftyPercent,

  };

  FirstPaymentRecord copyWith({
    int? id,
    String? subid,
    String? statusFirst,
    String? statusSec,
    String? statusThird,
    String? tenantAdvance,
    String? giveToOwnerAdvance,
    String? officeHold,
    String? midPaymentToOwner,
    String? ownerReceivedPaymentInMid,
    String? tenantPayLastAmount,
    String? bothSideCompanyCommission,
    String? ownerReceivedFinalAmount,
    String? tenantTotalPay,
    String? ownerTotalReceivedAmount,
    String? remainingHold,
    String? companyKeepComition,
    String? remainBalanceShareToOwner,
    String? finalRecivedAmountOwner,
    String? remaingFinalBalance,
    String? totalPayTenant,
    String? dates,
    String? times,
    String? dates2nd,
    String? times2nd,
    String? dates3rd,
    String? times3rd,
    String? visitorShare,
    String? officeGst,
    String?afterGstAmount,
    String? officeShareFiftyPercent,
    String? fieldWorkarShareFiftyPercent,

  }) {
    return FirstPaymentRecord(
      id: id ?? this.id,
      subid: subid ?? this.subid,
      statusFirst: statusFirst ?? this.statusFirst,
      statusSec: statusSec ?? this.statusSec,
      statusThird: statusThird ?? this.statusThird,
      tenantAdvance: tenantAdvance ?? this.tenantAdvance,
      giveToOwnerAdvance: giveToOwnerAdvance ?? this.giveToOwnerAdvance,
      officeHold: officeHold ?? this.officeHold,
      midPaymentToOwner: midPaymentToOwner ?? this.midPaymentToOwner,
      ownerReceivedPaymentInMid:
      ownerReceivedPaymentInMid ?? this.ownerReceivedPaymentInMid,
      tenantPayLastAmount: tenantPayLastAmount ?? this.tenantPayLastAmount,
      bothSideCompanyCommission:
      bothSideCompanyCommission ?? this.bothSideCompanyCommission,
      ownerReceivedFinalAmount:
      ownerReceivedFinalAmount ?? this.ownerReceivedFinalAmount,
      tenantTotalPay: tenantTotalPay ?? this.tenantTotalPay,
      ownerTotalReceivedAmount:
      ownerTotalReceivedAmount ?? this.ownerTotalReceivedAmount,
      remainingHold: remainingHold ?? this.remainingHold,
      companyKeepComition: companyKeepComition ?? this.companyKeepComition,
      remainBalanceShareToOwner:
      remainBalanceShareToOwner ?? this.remainBalanceShareToOwner,
      finalRecivedAmountOwner:
      finalRecivedAmountOwner ?? this.finalRecivedAmountOwner,
      remaingFinalBalance: remaingFinalBalance ?? this.remaingFinalBalance,
      totalPayTenant: totalPayTenant ?? this.totalPayTenant,
      dates: dates ?? this.dates,
      times: times ?? this.times,
      dates2nd: dates2nd ?? this.dates2nd,
      times2nd: times2nd ?? this.times2nd,
      dates3rd: dates3rd ?? this.dates3rd,
      times3rd: times3rd ?? this.times3rd,
      visitorShare: visitorShare ?? this.visitorShare,
      officeGst: officeGst ?? this.officeGst,
      afterGstAmount: afterGstAmount ?? this.afterGstAmount,
      officeShareFiftyPercent: officeShareFiftyPercent ?? this.officeShareFiftyPercent,
      fieldWorkarShareFiftyPercent: fieldWorkarShareFiftyPercent ?? this.fieldWorkarShareFiftyPercent,
    );
  }
}

extension FirstPaymentNums on FirstPaymentRecord {
  num _n(String? s) {
    if (s == null) return 0;
    final t = s.replaceAll(RegExp(r'[^\d\.\-]'), '');
    return num.tryParse(t) ?? 0;
  }

  num get nTenantAdvance => _n(tenantAdvance);
  num get nGiveToOwnerAdvance => _n(giveToOwnerAdvance);
  num get nOfficeHold => _n(officeHold);

  num get nMidPaymentToOwner => _n(midPaymentToOwner);
  num get nOwnerReceivedPaymentInMid => _n(ownerReceivedPaymentInMid);

  num get nTenantPayLastAmount => _n(tenantPayLastAmount);
  num get nBothSideCompanyCommission => _n(bothSideCompanyCommission);
  num get nOwnerReceivedFinalAmount => _n(ownerReceivedFinalAmount);
  num get nTenantTotalPayLegacy => _n(tenantTotalPay);
  num get nOwnerTotalReceivedAmount => _n(ownerTotalReceivedAmount);

  num get nRemainingHold => _n(remainingHold);
  num get nCompanyKeepComition => _n(companyKeepComition);
  num get nRemainBalanceShareToOwner => _n(remainBalanceShareToOwner);
  num get nFinalRecivedAmountOwner => _n(finalRecivedAmountOwner);
  num get nRemaingFinalBalance => _n(remaingFinalBalance);
  num get nTotalPayTenant => _n(totalPayTenant);

  /// Convenience: combine "YYYY-MM-DD" + "HH:MM:SS" into DateTime if possible.
  DateTime? _dt(String? d, String? t) {
    if ((d ?? '').isEmpty) return null;
    final s = t == null || t.isEmpty ? d! : '$d $t';
    return DateTime.tryParse(s);
  }

  DateTime? get firstAt => _dt(dates, times);
  DateTime? get secondAt => _dt(dates2nd, times2nd);
  DateTime? get thirdAt => _dt(dates3rd, times3rd);

  bool get isStep1Done => statusFirst.toLowerCase().contains('done');
  bool get isStep2Done => statusSec.toLowerCase().contains('done');
  bool get isStep3Done => statusThird.toLowerCase().contains('done');
}

class FieldWorkerCompleteFlatsNew extends StatefulWidget {
  const FieldWorkerCompleteFlatsNew({super.key});

  @override
  State<FieldWorkerCompleteFlatsNew> createState() =>
      _FieldWorkerCompleteFlatsNewState();
}

class _FieldWorkerCompleteFlatsNewState
    extends State<FieldWorkerCompleteFlatsNew> {
  String _fieldworkarnumber = '';
  static Map<dynamic, DateTime>? _lastTapTimes;

  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_api_complete_page_for_fieldworkar.php?field_workar_number=${_fieldworkarnumber}");
    print("User Name :" + "${userName}");
    print("User Number :" + "${userNumber}");
    print("User Number :" + "${_fieldworkarnumber}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded["success"] == true) {
        List data = decoded["data"];
        return data.map((e) => Property.fromJson(e)).toList().reversed.toList();
      }
    }
    throw Exception("Failed to load data");
  }

  Future<List<Tenant>> fetchTenants(int subId) async {
    final response = await http.get(
      Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Payment/show_api_for_owner_tenant_api_for_complete_api.php?subid=$subId",
      ),
    );

    debugPrint("🔵 STATUS CODE: ${response.statusCode}");
    debugPrint("🔵 RAW RESPONSE: ${response.body}");
    debugPrint("🔵  subId: ${subId}");

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

  Future<List<OwnerData>> fetchPersonDetail(int subid) async {
    final url = Uri.parse(
        'https://verifyserve.social/PHP_Files/owner_tenant_api.php?subid=$subid');
    final response = await http.get(url);

    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded['success'] == true) {
        final data = decoded['data'] as List<dynamic>;
        print("Decoded Owner Data: $data"); // ✅ Check decoded list
        return data.map((e) => OwnerData.fromJson(e)).toList();
      } else {
        return [];
      }
    } else {
      throw Exception("Failed to fetch owner data");
    }
  }

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    loadUserName();
    //initializeService();
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

  /// ---------- FETCH (by subid) ----------
  Future<List<FirstPaymentRecord>> fetchFirstPaymentsBySubId(int subid) async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Payment/show_final_payment_api_for_complete.php?subid=$subid',
    );

    final r = await http.get(uri);
    if (r.statusCode != 200) {
      throw Exception('HTTP ${r.statusCode}');
    }

    final decoded = json.decode(r.body) as Map<String, dynamic>;
    if (decoded['success'] != true) {
      throw Exception('API error: ${decoded['message'] ?? 'unknown'}');
    }

    final List data = (decoded['data'] as List? ?? []);
    return data
        .map((e) => FirstPaymentRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// Optional: get the latest row (highest id) for that subid.
  Future<FirstPaymentRecord?> fetchLatestFirstPayment(int subid) async {
    final list = await fetchFirstPaymentsBySubId(subid);
    if (list.isEmpty) return null;
    list.sort((a, b) => a.id.compareTo(b.id));
    return list.last;
  }

  Future<void> _onRefresh() async {
    setState(() {
      fetchBookingData();
    });
  }

  double _toD(dynamic v) {
    final s = (v ?? '').toString().trim();
    return double.tryParse(s.replaceAll(RegExp(r'[^\d\.-]'), '')) ?? 0;
  }
  double _safeDouble(String? v) {
    if (v == null) return 0;
    return double.tryParse(
        v.replaceAll(RegExp(r'[^0-9.]'), '')
    ) ?? 0;
  }

  String _cur(num n) => "₹ ${n.toStringAsFixed(0)}";
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        body: FutureBuilder<List<Property>>(
          future: fetchBookingData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No booking data available",
                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                ),
              );
            }

            final bookingList = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item = bookingList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      iconColor: isDarkMode ? Colors.blue.shade200 : Colors.blue.shade700,
                      collapsedBackgroundColor: isDarkMode ? Colors.grey.shade900 : Colors.white,
                      backgroundColor: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color:  Colors.blue.shade700,
                        ),
                        child: Text(
                          "Transaction \nId : ${item.pId}",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color:  Colors.white,
                          ),
                        ),
                      ),
                      subtitle: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getStatusColor(item.buyRent, isDarkMode),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item.buyRent ?? "Type",
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          "₹ ${item.showPrice}",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode ? Colors.green.shade300 : Colors.green.shade700,
                          ),
                        ),
                      ),
                      children: [
                        // Property Image
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.propertyPhoto}",
                              height: 120,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Image.asset(AppImages.loading, fit: BoxFit.cover),
                              errorWidget: (context, error, stack) =>
                                  Image.asset(AppImages.imageNotFound, fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Property Details
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            children: [
                              _buildMiniChip("${item.bhk}",
                                  isDarkMode ? Colors.blue.shade900 : Colors.blue.shade100,
                                  isDarkMode ? Colors.blue.shade100 : Colors.blue.shade800),
                              _buildMiniChip(item.typeOfProperty,
                                  isDarkMode ? Colors.green.shade900 : Colors.green.shade100,
                                  isDarkMode ? Colors.green.shade100 : Colors.green.shade800),
                              _buildMiniChip(item.locations,
                                  isDarkMode ? Colors.cyan.shade900 : Colors.cyan.shade100,
                                  isDarkMode ? Colors.cyan.shade100 : Colors.cyan.shade800),
                              _buildMiniChip(
                                "PID: ${item.pId}",
                                isDarkMode ? Colors.teal.shade900 : Colors.teal.shade100,
                                isDarkMode ? Colors.teal.shade100 : Colors.teal.shade800,
                              ),
                              _buildMiniChip(
                                "Building Flat ID: ${item.sourceId}",
                                isDarkMode ? Colors.purple.shade900 : Colors.purple.shade100,
                                isDarkMode ? Colors.purple.shade100 : Colors.purple.shade800,
                              ),
                              _buildMiniChip(
                                "Building ID: ${item.subid}",
                                isDarkMode ? Colors.indigo.shade900 : Colors.indigo.shade100,
                                isDarkMode ? Colors.indigo.shade100 : Colors.indigo.shade800,
                              ),
                              _buildMiniChip(
                                "FlatNo: ${item.flatNumber}",
                                isDarkMode ? Colors.blue.shade900 : Colors.blue.shade100,
                                isDarkMode ? Colors.white : Colors.blue.shade800,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Financial Details Expansion
                        _buildExpansionSection(
                          context: context,
                          title: "Financial Details",
                          icon: Icons.account_balance_wallet,
                          children: [
                            _buildDetailRow2("Rent", "₹ ${item.rent}", isDarkMode: isDarkMode),
                            _buildDetailRow2("Security", "₹ ${item.security}", isDarkMode: isDarkMode),
                            _buildDetailRow2("Tenant Commission", "₹ ${item.commission}", isDarkMode: isDarkMode),
                            _buildDetailRow2("Owner Commission", "₹ ${item.ownerCommission}", isDarkMode: isDarkMode),
                            _buildDetailRow2("Extra Expense", "₹ ${item.extraExpense}", isDarkMode: isDarkMode),
                            Divider(height: 20, thickness: 0.5, color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                            _buildDetailRow2("Total Amount", "₹ ${item.totalBalance}", isBold: true,
                                color: isDarkMode ? Colors.blue.shade300 : Colors.blue.shade800, isDarkMode: isDarkMode),
                            _buildDetailRow2("Advance Paid", "₹ ${item.advancePayment}", isBold: true,
                                color: isDarkMode ? Colors.green.shade300 : Colors.green.shade700, isDarkMode: isDarkMode),
                            _buildDetailRow2("2nd Payment", "₹ ${item.secondAmount}", isDarkMode: isDarkMode),
                            _buildDetailRow2("Final Payment", "₹ ${item.finalAmount}", isDarkMode: isDarkMode),
                            Divider(height: 20, thickness: 0.5, color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300),
                            _buildDetailRow2(
                              "Remaining Balance",
                              "₹ ${(_toD(item.totalBalance) - _toD(item.advancePayment) - _toD(item.secondAmount) - _toD(item.finalAmount)).clamp(0, double.infinity).toStringAsFixed(0)}",
                              isBold: true,
                              color: isDarkMode ? Colors.red.shade300 : Colors.red.shade700,
                              isDarkMode: isDarkMode,
                            ),
                          ],
                        ),

                        // Payment Action Buttons
                        if (item.statusForSecondPayment == "2nd payment pending" ||
                            item.statusForFinalPayment == "final payment pending")
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                if (item.statusForSecondPayment == "2nd payment pending")
                                  Expanded(
                                    child: _buildActionButton(
                                      "Accept 2nd Payment",
                                      Icons.payment,
                                      isDarkMode ? Colors.blue.shade700 : Colors.blue,
                                      onPressed: () async {
                                        final ok = await _changeSecondPaymentStatus(pId: item.pId);
                                        if (!mounted) return;
                                        _onRefresh();
                                      },
                                    ),
                                  ),
                                if (item.statusForSecondPayment == "2nd payment pending" &&
                                    item.statusForFinalPayment == "final payment pending")
                                  const SizedBox(width: 8),
                                if (item.statusForFinalPayment == "final payment pending")
                                  Expanded(
                                    child: _buildActionButton(
                                      "Accept Final Payment",
                                      Icons.check_circle,
                                      isDarkMode ? Colors.orange.shade700 : Colors.deepOrange,
                                      onPressed: () async {
                                        final ok = await _changeFinishPaymentStatus(pId: item.pId);
                                        if (!mounted) return;
                                        _onRefresh();
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),

                        // Tenant & Owner Info Expansion
                        _buildExpansionSection(
                          context: context,
                          title: "People Details",
                          icon: Icons.people,
                          initiallyExpanded: false,
                          children: [
                            FutureBuilder<List<Tenant>>(
                              future: fetchTenants(item.pId),
                              builder: (context, tenantSnapshot) {
                                if (tenantSnapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDarkMode ? Colors.blue.shade200 : Colors.blue,
                                  ));
                                }
                                if (tenantSnapshot.hasError || !tenantSnapshot.hasData || tenantSnapshot.data!.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "No tenant data",
                                      style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                                    ),
                                  );
                                }

                                final tenants = tenantSnapshot.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: tenants.length,
                                  itemBuilder: (context, index) {
                                    final t = tenants[index];
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Owner Info
                                        _buildPersonSection(
                                          "👤 Owner",
                                          [
                                            _buildPersonDetail("Name", t.ownerName, isDarkMode),
                                            _buildPersonDetail("Phone", t.ownerNumber, isDarkMode),
                                            _buildPersonDetail("Payment Mode", t.paymentModeForOwner, isDarkMode),
                                          ],
                                          isDarkMode ? Colors.white10: Colors.blue.shade50,
                                          isDarkMode: isDarkMode,
                                        ),
                                        const SizedBox(height: 12),

                                        // Tenant Info
                                        _buildPersonSection(
                                          "👥 Tenant",
                                          [
                                            _buildPersonDetail("Name", t.tenantName, isDarkMode),
                                            _buildPersonDetail("Phone", t.tenantNumber, isDarkMode),
                                            _buildPersonDetail("Payment Mode", t.paymentModeForTenant, isDarkMode),
                                            _buildPersonDetail("Shifting Date", _formatDate(t.shiftingDate), isDarkMode),
                                          ],
                                          isDarkMode ? Colors.white10: Colors.green.shade50,
                                          isDarkMode: isDarkMode,
                                        ),
                                        const SizedBox(height: 12),

                                        // Visitor Info
                                        _buildPersonSection(
                                          "👁️ Visitor",
                                          [
                                            _buildPersonDetail("Name", t.vist_field_workar_name, isDarkMode),
                                            _buildPersonDetail("Phone", t.vist_field_workar_number, isDarkMode),
                                          ],
                                          isDarkMode ? Colors.white10 : Colors.orange.shade50,
                                          isDarkMode: isDarkMode,
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),

                        // Billing History Expansion
                        _buildExpansionSection(
                          context: context,
                          title: "Payment History",
                          icon: Icons.history,
                          initiallyExpanded: false,
                          children: [
                            FutureBuilder<List<FirstPaymentRecord>>(
                              future: fetchFirstPaymentsBySubId(item.pId),
                              builder: (context, snap) {
                                if (snap.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: isDarkMode ? Colors.blue.shade200 : Colors.blue,
                                  ));
                                }
                                if (snap.hasError) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "Error loading billing data",
                                      style: TextStyle(color: Colors.red.shade400),
                                    ),
                                  );
                                }

                                final allRecords = snap.data ?? const <FirstPaymentRecord>[];
                                if (allRecords.isEmpty) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "No payment records found",
                                      style: TextStyle(color: isDarkMode ? Colors.grey.shade400 : Colors.grey),
                                    ),
                                  );
                                }

                                // Helper functions
                                bool _hasMid(dynamic v) {
                                  if (v == null) return false;
                                  if (v is num) return v != 0;
                                  final s = v.toString().trim();
                                  if (s.isEmpty) return false;
                                  final n = num.tryParse(s.replaceAll(RegExp(r'[^\d\.\-]'), ''));
                                  return (n ?? 0) != 0;
                                }

                                bool _hasAny(dynamic v) {
                                  if (v == null) return false;
                                  return v.toString().trim().isNotEmpty;
                                }

                                bool _hasStep3(FirstPaymentRecord r) =>
                                    _hasAny(r.tenantPayLastAmount) ||
                                        _hasAny(r.bothSideCompanyCommission) ||
                                        _hasAny(r.ownerReceivedFinalAmount) ||
                                        _hasAny(r.tenantTotalPay) ||
                                        _hasAny(r.ownerTotalReceivedAmount) ||
                                        _hasAny(r.remainingHold) ||
                                        _hasAny(r.companyKeepComition) ||
                                        _hasAny(r.remainBalanceShareToOwner) ||
                                        _hasAny(r.finalRecivedAmountOwner) ||
                                        _hasAny(r.remaingFinalBalance) ||
                                        _hasAny(r.totalPayTenant);

                                // Group records
                                final step1Records = allRecords.where((r) =>
                                _hasAny(r.tenantAdvance) || _hasAny(r.giveToOwnerAdvance) || _hasAny(r.officeHold)).toList();
                                final step2Records = allRecords.where((r) => _hasMid(r.midPaymentToOwner)).toList();
                                final step3Records = allRecords.where(_hasStep3).toList();

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (step1Records.isNotEmpty)
                                      _buildPaymentStepCard(
                                        isDarkMode: isDarkMode,
                                        "Step 1 - Advance",
                                        step1Records.first,
                                        status: step1Records.first.statusFirst,
                                        dateTime: "${step1Records.first.dates ?? ""} ${step1Records.first.times ?? ""}",
                                        amounts: [
                                          PaymentAmount("Tenant Advance", step1Records.first.tenantAdvance,
                                              isDarkMode ? Colors.green.shade300 : Colors.green,),
                                          PaymentAmount("Given to Owner", step1Records.first.giveToOwnerAdvance,
                                              isDarkMode ? Colors.blue.shade300 : Colors.blue),
                                          PaymentAmount("Office Hold", step1Records.first.officeHold,
                                              isDarkMode ? Colors.orange.shade300 : Colors.orange),
                                        ],),

                                    if (step2Records.isNotEmpty)
                                      _buildPaymentStepCard(
                                        "Step 2 - Mid Payment",
                                        step2Records.first,
                                        status: step2Records.first.statusSec,
                                        dateTime: "${step2Records.first.dates2nd ?? ""} ${step2Records.first.times2nd ?? ""}",
                                        amounts: [
                                          PaymentAmount("From Tenant", step2Records.first.midPaymentToOwner,
                                              isDarkMode ? Colors.green.shade300 : Colors.green),
                                          PaymentAmount("To Owner", step2Records.first.midPaymentToOwner,
                                              isDarkMode ? Colors.blue.shade300 : Colors.blue),
                                        ],
                                        isDarkMode: isDarkMode,
                                      ),

                                    if (step3Records.isNotEmpty)
                                      _buildPaymentStepCard(
                                        "Step 3 - Final Settlement",
                                        step3Records.first,
                                        status: "Completed",
                                        dateTime: "${step3Records.first.dates3rd ?? ""} ${step3Records.first.times3rd ?? ""}",
                                        isFinal: true,
                                        amounts: [
                                          PaymentAmount(
                                            "Last Payment From Tenant",
                                            step3Records.first.tenantPayLastAmount,
                                            isDarkMode ? Colors.green.shade300 : Colors.green,
                                          ),

                                          PaymentAmount(
                                            "Remaining Hold (Final + Hold)",
                                            step3Records.first..remainingHold,
                                            isDarkMode ? Colors.green.shade300 : Colors.green,
                                          ),

                                          PaymentAmount(
                                            "Visitor Share",
                                            step3Records.first.visitorShare,
                                            isDarkMode ? Colors.white : Colors.black,
                                          ),

                                          PaymentAmount(
                                            "Office GST",
                                            step3Records.first.officeGst,
                                            isDarkMode ? Colors.white : Colors.black,
                                          ),

                                          PaymentAmount(
                                            "After GST Amount",
                                            step3Records.first.afterGstAmount,
                                            isDarkMode ? Colors.green.shade300 : Colors.green,
                                          ),

                                          PaymentAmount(
                                            "Office Share (50%)",
                                            step3Records.first.officeShareFiftyPercent,
                                            isDarkMode ? Colors.green.shade300 : Colors.green,
                                          ),

                                          PaymentAmount(
                                            "Field Worker Share (50%)",
                                            step3Records.first.fieldWorkarShareFiftyPercent,
                                            isDarkMode ? Colors.green.shade300 : Colors.green,
                                          ),

                                          PaymentAmount(
                                            "Company Commission",
                                            step3Records.first.companyKeepComition,
                                            isDarkMode ? Colors.red.shade300 : Colors.red,
                                          ),

                                          PaymentAmount(
                                            "Owner Final Amount",
                                            step3Records.first.finalRecivedAmountOwner,
                                            isDarkMode ? Colors.red.shade300 : Colors.red,
                                          ),

                                          PaymentAmount(
                                            "Remaining Balance",
                                            step3Records.first.remaingFinalBalance,
                                            isDarkMode ? Colors.white : Colors.black,
                                          ),

                                          PaymentAmount(
                                            "Total Paid By Tenant",
                                            step3Records.first.totalPayTenant,
                                            isDarkMode ? Colors.green.shade300 : Colors.green,
                                          ),
                                        ],
                                        isDarkMode: isDarkMode,
                                      ),
                                  ],
                                );
                              },
                            ),
                          ],
                        ),

                        // Footer with date and action
                        Container(
                          padding:  EdgeInsets.only(left: 16, right: 16,),
                          decoration: BoxDecoration(
                            color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                _formatDate(item.currentDates),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode ? Colors.white : Colors.grey.shade600,
                                ),
                              ),
                              TextButton.icon(
                                icon: Icon(Icons.remove_red_eye,
                                    size: 14,
                                    color: isDarkMode ? Colors.blue : Colors.blue),
                                label: Text("View Details",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                        color: isDarkMode ? Colors.blue : Colors.blue,
                                        fontSize: 12)),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  minimumSize: Size.zero,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PropertyCompleteDetailPage(
                                        propertyId: item.pId.toString(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: InkWell(
                              onTap: () async {
                                final int propertyId = item.pId;

                                final double tenantCommission = _safeDouble(item.commission);
                                final double ownerCommission = _safeDouble(item.ownerCommission);

                                final String fieldworkerName = item.fieldWorkerName ?? "";
                                final String fieldworkerNumber = item.fieldWorkerNumber ?? "";

                                final String flatId = item.pId.toString();

                                final ok = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CompletePropertyCalculationFieldWorker(
                                      propertyId: propertyId,
                                      flatId: flatId,
                                      fieldworkerName: fieldworkerName,
                                      fieldworkerNumber: fieldworkerNumber,
                                      tenantCommission: tenantCommission.toString(),
                                      ownerCommission: ownerCommission.toString(),
                                    ),
                                  ),
                                );

                                if (ok == true) {
                                  _onRefresh();
                                }
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.receipt_long, color: Colors.white, size: 16),
                                    SizedBox(width: 6),
                                    Text(
                                      "Show Billing",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow2(String label, String value, {bool isBold = false, Color? color, required bool isDarkMode}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w700,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: color ?? (isDarkMode ? Colors.grey.shade200 : Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniChip(String text, Color backgroundColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
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

  Widget _buildActionButton(String text, IconData icon, Color color, {VoidCallback? onPressed}) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 16),
      label: Text(text, style: const TextStyle(fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
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
// Change this function signature
  Widget _buildPaymentStepCard(String title, FirstPaymentRecord record, {
    String? status,
    String? dateTime,
    required List<PaymentAmount> amounts, // Changed from List<(String, dynamic, Color)>
    bool isFinal = false,
    required bool isDarkMode, // Add this parameter
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark; // Get context if needed

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (status != null)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: _getStatusColor(status, isDarkMode),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        status,
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center ,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          if (dateTime != null && dateTime.trim().isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                dateTime,
                style: TextStyle(fontWeight: FontWeight.w700,fontSize: 10, color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600),
              ),
            ),
          const SizedBox(height: 8),
          ...amounts.map((amount) => _buildAmountRowMini(amount.label, amount.value, amount.color,
          )),
        ],
      ),
    );
  }

  Widget _buildAmountRowMini(String label, dynamic value, Color color) {
    final amount = value != null && value.toString().trim().isNotEmpty
        ? "₹ ${num.tryParse(value.toString().replaceAll(RegExp(r'[^\d\.\-]'), ''))?.toStringAsFixed(0) ?? '0'}"
        : "₹ 0";

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.w700,fontSize: 11, color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade700),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }


  Color _getStatusColor(String status, bool isDarkMode) {
    if (status.toLowerCase().contains('pending'))
      return isDarkMode ? Colors.orange.shade700 : Colors.orange;
    if (status.toLowerCase().contains('completed') || status.toLowerCase().contains('done'))
      return isDarkMode ? Colors.green.shade700 : Colors.green;
    if (status.toLowerCase().contains('rent'))
      return isDarkMode ? Colors.purple.shade700 : Colors.purple;
    if (status.toLowerCase().contains('buy'))
      return isDarkMode ? Colors.blue.shade700 : Colors.blue;
    return isDarkMode ? Colors.grey.shade600 : Colors.grey;
  }

  Future<bool> _changeSecondPaymentStatus({
    required int pId,
  }) async {
    final sw = Stopwatch()..start();
    try {
      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/Change_payment_2nd_status.php",
      );

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "P_id": pId.toString(),
        },
      );

      // ---------- VERBOSE PRINTS ----------
      debugPrint("—— Change_payment_2nd_status CALL ——");
      debugPrint("URL: $url");
      debugPrint("Body:  P_id: $pId");
      debugPrint("Status: ${res.statusCode}  (${sw.elapsedMilliseconds} ms)");
      debugPrint("Headers: ${res.headers}");
      // Try to pretty-print JSON; fall back to raw text.
      final raw = res.body;
      try {
        final j = json.decode(raw);
        debugPrint(
            "Response JSON: ${const JsonEncoder.withIndent('  ').convert(j)}");
      } catch (_) {
        debugPrint("Response Text: $raw");
      }
      debugPrint("—— END ——");

      // Tiny toast so you see something in UI too
      if (mounted) {
        // final snippet = raw.length > 200 ? "${raw.substring(0, 200)}…" : raw;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Confirm..")),
        );
      }

      return res.statusCode == 200 && raw.toLowerCase().contains("success");
    } catch (e) {
      debugPrint("API ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("API error: $e")),
        );
      }
      return false;
    }
  }

  Future<bool> _changeFinishPaymentStatus({
    required int pId,
  }) async {
    final sw = Stopwatch()..start();
    try {
      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/change_final_amount.php",
      );

      final res = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "P_id": pId.toString(),
        },
      );

      // ---------- VERBOSE PRINTS ----------
      debugPrint("—— Change_payment_Final_status CALL ——");
      debugPrint("URL: $url");
      debugPrint("Body:  P_id: $pId");
      debugPrint("Status: ${res.statusCode}  (${sw.elapsedMilliseconds} ms)");
      debugPrint("Headers: ${res.headers}");
      // Try to pretty-print JSON; fall back to raw text.
      final raw = res.body;
      try {
        final j = json.decode(raw);
        debugPrint(
            "Response JSON: ${const JsonEncoder.withIndent('  ').convert(j)}");
      } catch (_) {
        debugPrint("Response Text: $raw");
      }
      debugPrint("—— END ——");

      // Tiny toast so you see something in UI too
      if (mounted) {
        // final snippet = raw.length > 200 ? "${raw.substring(0, 200)}…" : raw;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Payment Confirm..")),
        );
      }

      return res.statusCode == 200 && raw.toLowerCase().contains("success");
    } catch (e) {
      debugPrint("API ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("API error: $e")),
        );
      }
      return false;
    }
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fieldworkarnumber = prefs.getString('number') ?? '';
    });
  }
}

Widget _pillButton({
  required String label,
  required Color color,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      minimumSize: const Size(0, 36),
      shape: const StadiumBorder(),
      elevation: 0,
    ),
  );
}

// Helper widget for billing steps
Widget _buildBillingStep({
  required String title,
  required List<FirstPaymentRecord> records,
  required Widget Function(FirstPaymentRecord) buildContent,
  bool isStep3 = false,
}) {
  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12)),
        child: ExpansionTile(
          iconColor: Colors.blue,
          collapsedIconColor: Colors.black54,

          initiallyExpanded: false,
          // tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          backgroundColor: Colors.grey.shade200,
          collapsedBackgroundColor: Colors.grey.shade200,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          subtitle: isStep3 && records.isNotEmpty
              ? Wrap(
                  spacing: 6,
                  children: [
                    _buildTag(
                      (records.last.statusThird.isEmpty
                          ? "—"
                          : records.last.statusThird),
                      Colors.deepPurple,
                    ),
                  ],
                )
              : null,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...records.map((rec) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: buildContent(rec),
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );
}

// Your existing helper methods
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

enum Polarity { credit, debit, neutral }

bool _isEmpty(dynamic v) => v == null || v.toString().trim().isEmpty;

num _numVal(dynamic v) =>
    num.tryParse(v.toString().replaceAll(RegExp(r'[^\d\.\-]'), '')) ?? 0;

String _moneySigned(dynamic v, Polarity p) {
  if (_isEmpty(v)) return "—";
  final n = _numVal(v).abs();
  final sign = p == Polarity.credit
      ? "+"
      : p == Polarity.debit
          ? "-"
          : "";
  return "$sign ₹ ${n.toStringAsFixed(0)}";
}

Color _amtColor(BuildContext c, Polarity p) {
  switch (p) {
    case Polarity.credit:
      return Colors.green;
    case Polarity.debit:
      return Colors.red;
    case Polarity.neutral:
      return Colors.black;
  }
}

Widget _amountRow(
    String label, dynamic value, Polarity p, BuildContext context) {
  if (_isEmpty(value)) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black)),
        ),
        const SizedBox(width: 8),
        Text(
          _moneySigned(value, p),
          style: TextStyle(
            fontFeatures: const [FontFeature.tabularFigures()],
            fontWeight: FontWeight.w700,
            color: _amtColor(context, p),
          ),
        ),
      ],
    ),
  );
}

Widget _buildDetailRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTenantButton({
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 30,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    ),
  );
}

/// --- Helper Row for fields
Widget _buildAdvancePayment(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: "PoppinsBold",
            color: Colors.lightBlue,
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
