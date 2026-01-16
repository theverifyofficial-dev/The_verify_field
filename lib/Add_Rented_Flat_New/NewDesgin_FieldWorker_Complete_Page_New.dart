import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FieldWorker_Complete_Detail_Page.dart';
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

class NewDesignFieldWorkerCompleteFlatsNew extends StatefulWidget {
  const NewDesignFieldWorkerCompleteFlatsNew({super.key});

  @override
  State<NewDesignFieldWorkerCompleteFlatsNew> createState() =>
      _NewDesignFieldWorkerCompleteFlatsNewState();
}

class _NewDesignFieldWorkerCompleteFlatsNewState
    extends State<NewDesignFieldWorkerCompleteFlatsNew> {
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

  @override
  Widget build(BuildContext context) {

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
              padding: const EdgeInsets.all(12),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item = bookingList[index];
                return _transactionCard(context, item);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _transactionCard(BuildContext context, Property item) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ID CHIPS
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _idChip("Building ID: ${item.subid}", Colors.indigo, isDarkMode),
                _idChip("Flat ID: ${item.sourceId}", Colors.purple, isDarkMode),
                _idChip("Flat No: ${item.flatNumber}", Colors.teal, isDarkMode),
              ],
            ),

            const SizedBox(height: 10),

            /// MAIN ROW
            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PropertyCompleteDetailPage(
                      propertyId: item.pId.toString(),
                    ),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl:
                      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.propertyPhoto}",
                      height: 72,
                      width: 72,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// INFO
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "${item.bhk} ${item.typeOfProperty}",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                            Text(
                              "₹ ${item.showPrice}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item.locations,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [
                            Text(
                              "Txn ID: #${item.pId}",
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: isDarkMode
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade500,
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

            const SizedBox(height: 12),

            // _billingSection(item),
            /// SHOW BILLING BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.receipt_long, size: 16, color: Colors.white,),
                label: const Text(
                  "Show Billing",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12, fontWeight: FontWeight.w600),
                ),
                onPressed: () async {
                  print(item.pId);
                  final ok = await Navigator.push<bool>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CompletePropertyCalculationFieldWorker(
                        propertyId: item.pId,
                        flatId: item.flatNumber.toString(),
                        fieldworkerName: item.fieldWorkerName,
                        fieldworkerNumber: item.fieldWorkerNumber,
                        tenantCommission: item.commission,
                        ownerCommission: item.ownerCommission,
                      ),
                    ),
                  );

                  if (ok == true && context.mounted) {
                    setState(() {});
                  }
                },
              ),
            ),

            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.blue,
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //     ),
            //     icon: const Icon(Icons.receipt_long, size: 16),
            //     label: const Text(
            //       "Show Billing",
            //       style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            //     ),
            //     onPressed: () async {
            //       final ok = await Navigator.push<bool>(
            //         context,
            //         MaterialPageRoute(
            //           builder: (_) => TransactionDetailsPage(
            //               propertyId:item.pId
            //           ),
            //
            //         ),
            //       );
            //
            //       if (ok == true && context.mounted) {
            //         setState(() {});
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _statusBadge(Property item, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    late String label;
    late Color bgColor;
    late Color textColor;

    if (item.statusForFinalPayment == "final payment pending") {
      label = "Due";
      bgColor = isDark ? Colors.orange.shade900 : Colors.orange.shade100;
      textColor = isDark ? Colors.orange.shade200 : Colors.orange.shade800;
    }
    else if (item.statusForSecondPayment == "processing") {
      label = "Processing";
      bgColor = isDark ? Colors.blue.shade900 : Colors.blue.shade100;
      textColor = isDark ? Colors.blue.shade200 : Colors.blue.shade800;
    }
    else if (item.statusForFinalPayment == "completed") {
      label = "Completed";
      bgColor = isDark ? Colors.green.shade900 : Colors.green.shade100;
      textColor = isDark ? Colors.green.shade200 : Colors.green.shade800;
    }
    else {
      label = "Pending";
      bgColor = isDark ? Colors.grey.shade800 : Colors.grey.shade200;
      textColor = isDark ? Colors.grey.shade300 : Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _idChip(String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDarkMode
            ? color.withOpacity(0.25)
            : color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: isDarkMode ? Colors.white : color,
        ),
      ),
    );
  }

  Widget _officeDistributionCard({
    required List<PaymentAmount> amounts,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Office / Commission Distribution",
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...amounts.map(
                (e) => _buildAmountRowMini(e.label, e.value, e.color),
          ),
        ],
      ),
    );
  }

  Widget _billingSection(Property property) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return FutureBuilder<List<FirstPaymentRecord>>(
      future: fetchFirstPaymentsBySubId(property.subid),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox();
        }

        final records = snapshot.data!;
        final last = records.last;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 PAYMENT PROCESS
            const Text(
              "Payment Process",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// STEP 1
            _paymentStepTimeline(
              title: "Step 1 : Advance Payment",
              status: last.statusFirst,
              date: _formatDate(last.dates),
              isDark: isDark,
              amounts: [
                PaymentAmount(
                    "Tenant Advance",
                    last.tenantAdvance,
                    Colors.green),
                PaymentAmount(
                    "Given to Owner",
                    last.giveToOwnerAdvance,
                    Colors.red),
                PaymentAmount(
                    "Office Hold",
                    last.officeHold,
                    Colors.orange),
              ],
            ),

            /// STEP 2
            if (last.midPaymentToOwner != null)
              _paymentStepTimeline(
                title: "Step 2 : Mid Payment",
                status: last.statusSec,
                date: _formatDate(last.dates2nd),
                isDark: isDark,
                amounts: [
                  PaymentAmount(
                      "Paid to Owner",
                      last.midPaymentToOwner,
                      Colors.red),
                  PaymentAmount(
                      "Owner Received",
                      last.ownerReceivedPaymentInMid,
                      Colors.green),
                ],
              ),

            /// STEP 3
            if (last.tenantPayLastAmount != null)
              _paymentStepTimeline(
                title: "Step 3 : Final Settlement",
                status: last.statusThird,
                date: _formatDate(last.dates3rd),
                isDark: isDark,
                amounts: [
                  PaymentAmount(
                      "Tenant Paid",
                      last.tenantPayLastAmount,
                      Colors.green),
                  PaymentAmount(
                      "Owner Received",
                      last.finalRecivedAmountOwner,
                      Colors.red),
                  PaymentAmount(
                      "Remaining Hold",
                      last.remainingHold,
                      Colors.orange),
                ],
              ),

            const SizedBox(height: 12),

            /// 🔹 OFFICE DISTRIBUTION
            _officeDistributionCard(
              isDark: isDark,
              amounts: [
                PaymentAmount(
                    "Company Commission",
                    last.companyKeepComition,
                    Colors.blue),
                PaymentAmount(
                    "Visitor Share",
                    last.visitorShare,
                    Colors.purple),
                PaymentAmount(
                    "Office GST",
                    last.officeGst,
                    Colors.red),
                PaymentAmount(
                    "After GST",
                    last.afterGstAmount,
                    Colors.green),
              ],
            ),

          ],
        );
      },
    );
  }

  Widget _paymentStepTimeline({
    required String title,
    required String status,
    required String date,
    required List<PaymentAmount> amounts,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// TIMELINE DOT
        Column(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _getStatusColor(status, isDark),
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 2,
              height: 60,
              color: Colors.grey.shade400,
            ),
          ],
        ),

        const SizedBox(width: 10),

        /// CONTENT
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _getStatusColor(status, isDark),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        status,
                        style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  date,
                  style: TextStyle(
                      fontSize: 10,
                      color:
                      isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                ),

                const SizedBox(height: 6),

                /// AMOUNTS
                ...amounts.map(
                      (e) => _buildAmountRowMini(e.label, e.value, e.color),
                ),
              ],
            ),
          ),
        ),
      ],
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

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fieldworkarnumber = prefs.getString('number') ?? '';
    });
  }
}
enum Polarity { credit, debit, neutral }

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
