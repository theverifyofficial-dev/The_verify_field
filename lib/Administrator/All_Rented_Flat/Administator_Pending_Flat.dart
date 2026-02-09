import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AdministatorPropertyDetailPage.dart';
import 'PropertyCalculationPage.dart';
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class Property {
  final int pId;
  final String? sourceId;
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
  final String bookingDate;
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

  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;
  final String secondAmount;
  final String finalAmount;

  Property({
    required this.pId,
    required this.sourceId,
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
    required this.bookingDate,
    required this.secondAmount,
    required this.statusForFinalPayment,
    required this.statusForSecondPayment,
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
      bookingDate: json["booking_date"] ?? "",
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
  final String tenantName;
  final String tenantNumber;
  final String shiftingDate;
  final String paymentModeForTenant;

  final String ownerName;
  final String ownerNumber;
  final String paymentModeForOwner;

  final String vist_field_workar_name;
  final String vist_field_workar_number;
  final String subId;

  Tenant({
    required this.id,
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
    required this.vist_field_workar_number
  });

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

class FirstPaymentRecord {
  final int id;
  final String subid;

  final String statusFirst;
  final String statusSec;
  final String statusThird;

  final String tenantAdvance;
  final String giveToOwnerAdvance;
  final String officeHold;

  final String? midPaymentToOwner;
  final String? ownerReceivedPaymentInMid;

  final String? tenantPayLastAmount;
  final String? bothSideCompanyCommission;
  final String? ownerReceivedFinalAmount;
  final String? tenantTotalPay;
  final String? ownerTotalReceivedAmount;

  final String? remainingHold;
  final String? companyKeepComition;
  final String? remainBalanceShareToOwner;
  final String? finalRecivedAmountOwner;
  final String? remaingFinalBalance;
  final String? totalPayTenant;

  final String? dates;
  final String? times;
  final String? dates2nd;
  final String? times2nd;
  final String? dates3rd;
  final String? times3rd;

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


class AdministatiorFieldWorkerPendingFlats extends StatefulWidget {
  const AdministatiorFieldWorkerPendingFlats({super.key});

  @override
  State<AdministatiorFieldWorkerPendingFlats> createState() => _AdministatiorFieldWorkerPendingFlatsState();
}

class _AdministatiorFieldWorkerPendingFlatsState extends State<AdministatiorFieldWorkerPendingFlats> {

  String _fieldworkarnumber = '';
  static Map<dynamic, DateTime>? _lastTapTimes;

  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_admin.php");
    print("User Name :"+"${userName}");
    print("User Number :"+"${userNumber}");
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
  final Map<int, bool> _processingMap = {};

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    loadUserName();
    _onRefresh();
    _propertyFuture = fetchBookingData();
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fieldworkarnumber = prefs.getString('number') ?? '';
    });
  }

  final Map<int, bool> _billingMap = {};
  Future<void> _checkBilling(int pId) async {
    if (_billingMap.containsKey(pId)) return;

    try {
      final records = await fetchFirstPaymentsBySubId(pId);

      bool hasBilling = records.any((r) =>
      r.tenantAdvance.isNotEmpty ||
          r.officeHold.isNotEmpty ||
          (r.midPaymentToOwner?.isNotEmpty ?? false) ||
          (r.tenantPayLastAmount?.isNotEmpty ?? false));

      if (mounted) {
        setState(() {
          _billingMap[pId] = hasBilling;
        });
      }
    } catch (_) {
      _billingMap[pId] = false;
    }
  }

  late Future<List<Property>> _propertyFuture;
  String? userName;
  String? userNumber;
  String? userStoredFAadharCard;

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');
    final storedFAadharCard = prefs.getString('post');
    debugPrint("User Name: $storedName");
    debugPrint("User Number: $storedNumber");
    debugPrint("User FAadharCard: $storedFAadharCard");
    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
        userStoredFAadharCard = storedFAadharCard;

      });
    }
  }

  Future<List<FirstPaymentRecord>> fetchFirstPaymentsBySubId(int subid) async {
    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/Payment/show_payment1_base_on_sub_id.php?subid=$subid',
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

  Future<FirstPaymentRecord?> fetchLatestFirstPayment(int subid) async {
    final list = await fetchFirstPaymentsBySubId(subid);
    if (list.isEmpty) return null;
    list.sort((a, b) => a.id.compareTo(b.id));
    return list.last;
  }



  double _safeDouble(String? v) {
    if (v == null) return 0;
    return double.tryParse(
        v.replaceAll(RegExp(r'[^0-9.]'), '')
    ) ?? 0;
  }

  Future<void> _onRefresh() async {
    final data = await fetchBookingData();
    if (!mounted) return;

    setState(() {
      _propertyFuture = Future.value(data);
    });
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

      debugPrint("—— Change_payment_2nd_status CALL ——");
      debugPrint("URL: $url");
      debugPrint("Body:  P_id: $pId");
      debugPrint("Status: ${res.statusCode}  (${sw.elapsedMilliseconds} ms)");
      debugPrint("Headers: ${res.headers}");

      final raw = res.body;
      try {
        final j = json.decode(raw);
        debugPrint("Response JSON: ${const JsonEncoder.withIndent('  ').convert(j)}");
      } catch (_) {
        debugPrint("Response Text: $raw");
      }
      debugPrint("—— END ——");

      if (mounted) {

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

      debugPrint("—— Change_payment_Final_status CALL ——");
      debugPrint("URL: $url");
      debugPrint("Body:  P_id: $pId");
      debugPrint("Status: ${res.statusCode}  (${sw.elapsedMilliseconds} ms)");
      debugPrint("Headers: ${res.headers}");
      final raw = res.body;
      try {
        final j = json.decode(raw);
        debugPrint("Response JSON: ${const JsonEncoder.withIndent('  ').convert(j)}");
      } catch (_) {
        debugPrint("Response Text: $raw");
      }
      debugPrint("—— END ——");

      if (mounted) {
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
  @override
  Widget build(BuildContext context) {
    final isDark= Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        body: FutureBuilder<List<Property>>(
          future: _propertyFuture,
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
                _checkBilling(item.pId);
                final bool isLoading = _processingMap[item.pId] == true;
                return GestureDetector(
                  onTap:(){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdministatorPropertyDetailPage(
                        propertyId: item.pId.toString(),
                      ),
                    ),
                  );
                },
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade900 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            _idChip("Building ID: ${item.subid}", Colors.indigo, isDark),
                            _idChip("Flat ID: ${item.sourceId}", Colors.purple, isDark),
                            _idChip("Flat No: ${item.flatNumber}", Colors.teal, isDark),
                          ],
                        ),
                        SizedBox(height: 5,),
                        /// ---------------- TOP ROW ----------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl:
                                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.propertyPhoto}",
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// TITLE + PRICE
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          "${item.bhk} - ${item.typeOfProperty}",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        "₹${item.showPrice}",
                                        style: const TextStyle(
                                          fontSize: 15,
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
                                      color: Colors.grey.shade600,
                                    ),
                                  ),

                                  const SizedBox(height: 2),
                                  Text(
                                    "ID: #${item.pId}",
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "PoppinsBold",
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),
                        Text("Booking Date : "+formatBookingDate(item.bookingDate),
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                          ),),
                        const SizedBox(height: 6),
                        /// ---------------- PAYMENT BUTTONS ----------------
                        if(userStoredFAadharCard=="Sub Administrator")
                        Row(
                          children: [
                            if (item.statusForSecondPayment == "2nd payment pending")
                              Expanded(
                                child: _paymentBtn(
                                  label: "Accept 2nd Pay",
                                  color: Colors.blue,
                                  onTap: () async {
                                    await _changeSecondPaymentStatus(pId: item.pId);
                                    _onRefresh();
                                  },
                                ),
                              ),

                            if (item.statusForSecondPayment == "2nd payment pending" &&
                                item.statusForFinalPayment == "final payment pending")
                              const SizedBox(width: 8),

                            if (item.statusForFinalPayment == "final payment pending")
                              Expanded(
                                child: _paymentBtn(
                                  label: "Accept Final Pay",
                                  color: Colors.deepOrange,
                                  onTap: () async {
                                    await _changeFinishPaymentStatus(pId: item.pId);
                                    _onRefresh();
                                  },
                                ),
                              ),
                          ],
                        ),

                        /// ---------------- BILLING BUTTON ----------------
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: double.infinity,
                                child: OutlinedButton.icon(
                                  icon: Icon(
                                      Icons.receipt_long,
                                      size: 18,
                                      color:  Colors.white
                                  ),
                                  label: Text(
                                    userStoredFAadharCard == "Sub Administrator"
                                        ? "Add Billing"
                                        : "Show Billing",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  style: OutlinedButton.styleFrom(
                                    backgroundColor:userStoredFAadharCard == "Sub Administrator" ? Colors.orange.shade900:Colors.blue,
                                    side:  BorderSide(
                                      color: userStoredFAadharCard == "Sub Administrator" ? Colors.orange.shade900:Colors.blue, // 🔒 fixed border color
                                      width: 1.4,
                                    ),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {

                                    final int propertyId = item.pId;
                                    final double tenantCommission = _safeDouble(item.commission);
                                    final double ownerCommission = _safeDouble(item.ownerCommission);
                                    final String fieldworkerName = item.fieldWorkerName ?? "";
                                    final String fieldworkerNumber = item.fieldWorkerNumber ?? "";
                                    final String flatId = item.pId.toString();

                                    final ok = await Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => PropertyCalculate(
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
                                      _billingMap.remove(item.pId);
                                    }
                                  },
                                ),
                              ),
                            ),
                            if (userStoredFAadharCard == "Sub Administrator")
                              Expanded(
                                child: Column(
                                  children: [

                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                setState(() {
                                  _processingMap[item.pId] = true; // ✅ only this card
                                });

                                try {
                                  final response = await http.post(
                                    Uri.parse(
                                      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/new_complete_payment.php",
                                    ),
                                    headers: {
                                      "Content-Type": "application/x-www-form-urlencoded",
                                    },
                                    body: {
                                      "P_id": item.pId.toString(),
                                    },
                                  );

                                  if (response.statusCode == 200) {
                                    final result = jsonDecode(response.body);

                                    if (result["success"] == true) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("Payment completed successfully"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );

                                      if (mounted) {
                                        await _onRefresh();   // ✅ SAME PAGE REFRESH
                                      }
                                    }
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Payment completed successfully")),
                                      );
                                    }
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Error: $e")),
                                  );
                                } finally {
                                  setState(() {
                                    _processingMap[item.pId] = false;
                                  });
                                }
                              },
                              child: isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                "Complete Payment",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                                  ],
                                ),
                              ),
                          ],
                        )

                          ],
                    ),
                  ),

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
  String formatBookingDate(String rawDate) {
    try {
      final DateTime date = DateTime.parse(rawDate);
      return DateFormat('dd MMM yyyy').format(date);
      // Example output: 07 Feb 2026
    } catch (e) {
      return rawDate; // fallback if parsing fails
    }
  }
  Widget _paymentBtn({
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onTap,
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.w600),
      ),
    );
  }
}




