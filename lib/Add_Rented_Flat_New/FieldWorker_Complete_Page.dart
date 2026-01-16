import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'FieldWorker_Booking_Page_Details.dart';
import 'FieldWorker_Complete_Detail_Page.dart';
import '../../constant.dart';

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
class OwnerModel {
  bool success;
  List<OwnerData> data;

  OwnerModel({
    required this.success,
    required this.data,
  });

  factory OwnerModel.fromJson(Map<String, dynamic> json) => OwnerModel(
    success: json["success"],
    data: List<OwnerData>.from(json["data"].map((x) => OwnerData.fromJson(x))),
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


class FieldWorkerCompleteFlats extends StatefulWidget {
  const FieldWorkerCompleteFlats({super.key});

  @override
  State<FieldWorkerCompleteFlats> createState() => _FieldWorkerCompleteFlatsState();
}

class _FieldWorkerCompleteFlatsState extends State<FieldWorkerCompleteFlats> {

  String _fieldworkarnumber = '';
  static Map<dynamic, DateTime>? _lastTapTimes;

  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_complete_page_for_fieldworkar.php?field_workar_number=$_fieldworkarnumber");
    print("User Name :"+"${userName}");
    print("User Number :"+"${userNumber}");
    print("User Number :"+"${_fieldworkarnumber}");
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
      Uri.parse("https://verifyserve.social/PHP_Files/show_tenant_api.php?sub_id=$subId"),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse["success"] == true) {
        List data = jsonResponse["data"];
        return data.map((e) => Tenant.fromJson(e)).toList();
      } else {
        throw Exception("API success = false");
      }
    } else {
      throw Exception("Failed to load tenants");
    }
  }
  Future<List<OwnerData>> fetchPersonDetail(int subid) async {
    final url = Uri.parse('https://verifyserve.social/PHP_Files/owner_tenant_api.php?subid=$subid');
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

  String _cur(num n) => "₹ ${n.toStringAsFixed(0)}";
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
              return const Center(child: Text("No booking data available"));
            }

            final bookingList = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item = bookingList[index];
                return GestureDetector(
                  onTap: (){
                    print(item.id);
                    final pid = int.parse(item.id.toString()); // check/validate
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PropertyCompleteDetailPage(
                          propertyId: pid.toString(),
                        ),
                      ),
                    );

                  },
                  child:Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 6,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// --- Tags Row (Type, Location, Buy/Rent)
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _buildTag(item.bhk, Colors.blue),
                            _buildTag(item.typeOfProperty, Colors.green),
                            _buildTag(item.locations, Colors.cyan),
                            _buildTag(item.buyRent, Colors.deepPurple),
                            _buildTag("₹ ${item.showPrice}", Colors.red),

                          ],
                        ),

                        const SizedBox(height: 12),

                        /// --- Property Image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            imageUrl:
                            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.propertyPhoto}",
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Image.asset(AppImages.loading, fit: BoxFit.cover),
                            errorWidget: (context, error, stack) =>
                                Image.asset(AppImages.imageNotFound, fit: BoxFit.cover),
                          ),
                        ),

                        const SizedBox(height: 12),

                        /// --- Financial Details Box
// ===================== FINANCIAL DETAILS EXPANSION TILE =====================
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(12)
                          ),
                          // margin: const EdgeInsets.symmetric(horizontal: 8, ),

                          child: ExpansionTile(
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
                            title: const Text(
                              "Financial Details",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                            trailing: Text(
                              "ID: ${item.id}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildDetailRow("Rent", "₹ ${item.rent}"),
                                    _buildDetailRow("Security", "₹ ${item.security}"),
                                    _buildDetailRow("Tenant Commission", "₹ ${item.commission}"),
                                    _buildDetailRow("Extra Expense", "₹ ${item.extraExpense}"),
                                    _buildDetailRow("Total Amount", "₹ ${item.totalBalance}"),
                                    _buildAdvancePayment("Advance Payment", "₹ ${item.advancePayment}"),
                                    _buildDetailRow("Second Amount ", "₹ ${item.secondAmount}"),
                                    _buildDetailRow("Final Amount ", "₹ ${item.finalAmount}"),
                                    const Divider(thickness: 0.5, color: Colors.grey),
                                    _buildDetailRow(
                                      "Remaining Amount",
                                      _cur(
                                        (_toD(item.totalBalance)
                                            - _toD(item.advancePayment)
                                            - _toD(item.secondAmount)
                                            - _toD(item.finalAmount))
                                            .clamp(0, double.infinity),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            // STEP 2
                            if (item.statusForSecondPayment=="2nd payment pending")
                              _pillButton(
                                label: "Accept 2nd Amount",
                                color: Colors.blue,
                                onPressed: () async {
                                  final ok = await _changeSecondPaymentStatus(pId: item.id,);
                                  if (!mounted) return;
                                  _onRefresh();
                                },
                              ),

                            if (item.statusForFinalPayment=="final payment pending")
                              _pillButton(
                                label: "Accept Final Amount",
                                color: Colors.deepOrange,
                                onPressed: () async {
                                  final ok = await _changeFinishPaymentStatus(pId: item.id,);
                                  if (!mounted) return;
                                  _onRefresh();
                                },
                              ),

                            // STEP 3 / FINAL
                          ],
                        ),

                        const SizedBox(height: 8),
                        /// --- Tenant Details Section
                        FutureBuilder<List<Tenant>>(
                          future: fetchTenants(item.id),
                          builder: (context, tenantSnapshot) {
                            if (tenantSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center();
                            }
                            if (tenantSnapshot.hasError) {
                              return const Text("Tenant Data Empty",
                                  style: TextStyle(color: Colors.black54));
                            }
                            if (!tenantSnapshot.hasData || tenantSnapshot.data!.isEmpty) {
                              return const Text("No tenant data available",
                                  style: TextStyle(color: Colors.black54));
                            }

                            final tenants = tenantSnapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                const Text(
                                  "Tenant Details",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                ...tenants.map((tenant) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        _buildTag(tenant.tenantName, Colors.purple),
                                        _buildTag(tenant.tenantNumber, Colors.green),
                                        _buildTag(_formatDate(tenant.shiftingDate), Colors.blue),
                                        _buildTag(tenant.paymentModeForTenant, Colors.red),

                                      ],
                                    ),

                                  ],
                                )),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        FutureBuilder<List<OwnerData>>(
                          future: fetchPersonDetail(item.id),
                          builder: (context, ownerSnapshot) {
                            if (ownerSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center();
                            }
                            if (ownerSnapshot.hasError) {
                              return const Text("Data Empty",
                                  style: TextStyle(color: Colors.black54));
                            }
                            if (!ownerSnapshot.hasData || ownerSnapshot.data!.isEmpty) {
                              return const Text("No owner data available",
                                  style: TextStyle(color: Colors.black54));
                            }

                            final owner = ownerSnapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                const Text(
                                  "Owner Details",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 10,),
                                ...owner.map((owner) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 6,
                                      children: [
                                        _buildTag(owner.ownerName, Colors.deepPurple),
                                        _buildTag(owner.ownerNumber, Colors.teal),
                                        SizedBox(height: 10,),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey.shade200),
                                          ),
                                          child: Column(
                                            children: [
                                              _buildDetailRow("Company Commission \nFrom Owner: ","₹ ${owner.paymentMode}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),

                        /// --- Date & ID Row
                        Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _formatDate(item.currentDates),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black54,
                              ),
                            ),


                          ],
                        ),
                        const SizedBox(height: 10),

// ===================== SINGLE FUTURE BUILDER =====================
                        FutureBuilder<List<FirstPaymentRecord>>(
                          future: fetchFirstPaymentsBySubId(item.id),
                          builder: (context, snap) {
                            if (snap.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }
                            if (snap.hasError) {
                              return const Text("Billing data error", style: TextStyle(color: Colors.black54));
                            }

                            final allRecords = snap.data ?? const <FirstPaymentRecord>[];
                            if (allRecords.isEmpty) return const SizedBox.shrink();

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

                            String _money(dynamic v) {
                              if (v == null || v.toString().trim().isEmpty) return "—";
                              final n = num.tryParse(v.toString().replaceAll(RegExp(r'[^\d\.\-]'), '')) ?? 0;
                              return "₹ ${n.toStringAsFixed(0)}";
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

                            // Filter records for each step
                            final step1Records = allRecords.where((r) =>
                            _hasAny(r.tenantAdvance) || _hasAny(r.giveToOwnerAdvance) || _hasAny(r.officeHold)).toList();

                            final step2Records = allRecords.where((r) => _hasMid(r.midPaymentToOwner)).toList();

                            final step3Records = allRecords.where(_hasStep3).toList();

                            return Column(
                              children: [
                                // ===================== STEP 1 =====================
                                if (step1Records.isNotEmpty) ...[
                                  _buildBillingStep(
                                    title: "Step 1 Billing",
                                    records: step1Records,
                                    buildContent: (rec) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            _buildTag("${rec.statusFirst ?? '—'}", Colors.deepPurple),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            children: [
                                              _amountRow("Tenant Advance", rec.tenantAdvance, Polarity.credit,context),
                                              _amountRow("Give to Owner", rec.giveToOwnerAdvance, Polarity.debit,context),
                                              _amountRow("Office Hold", rec.officeHold, Polarity.credit,context),
                                              _buildDetailRow("Date/Time ", "${rec.dates??""},${rec.times??""}"),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                // ===================== STEP 2 =====================
                                if (step2Records.isNotEmpty) ...[
                                  _buildBillingStep(
                                    title: "Step 2 Billing",
                                    records: step2Records,
                                    buildContent: (rec) => Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 6,
                                          children: [
                                            _buildTag("${rec.statusSec ?? '—'}", Colors.deepPurple),
                                          ],
                                        ),
                                        const SizedBox(height: 10),
                                        Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade50,
                                            borderRadius: BorderRadius.circular(10),
                                            border: Border.all(color: Colors.grey.shade300),
                                          ),
                                          child: Column(
                                            children: [
                                              _amountRow("Mid Payment From Tenant", rec.midPaymentToOwner, Polarity.credit,context),
                                              _amountRow("Office Transfer Payment To Owner", rec.midPaymentToOwner, Polarity.debit,context),
                                              _buildDetailRow("Date/Time ", "${rec.dates2nd??""},${rec.times2nd??""}"),

                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],

                                // ===================== STEP 3 =====================
                                if (step3Records.isNotEmpty) ...[
                                  _buildBillingStep(
                                    title: "Step 3 Billing",
                                    records: step3Records,
                                    isStep3: true,
                                    buildContent: (rec) {
                                      final rows = <Widget>[
                                        _amountRow("Last Payment From Tenant", rec.tenantPayLastAmount, Polarity.credit, context),
                                        _amountRow("Remaining Hold (Final + Hold)", rec.remainingHold, Polarity.credit, context),
                                        _amountRow("Company Keep Commission Both-side", rec.companyKeepComition, Polarity.debit, context),
                                        _amountRow("Remaining Balance Share To Owner", rec.remainBalanceShareToOwner, Polarity.debit, context),
                                        _amountRow("Owner Final Received", rec.finalRecivedAmountOwner, Polarity.debit, context),
                                        _amountRow("Remaining Final Balance", rec.remaingFinalBalance, Polarity.neutral, context),
                                        _amountRow("Total Paid By Tenant", rec.totalPayTenant, Polarity.credit, context),
                                        _buildDetailRow("Date/Time ", "${rec.dates3rd ?? ""}, ${rec.times3rd ?? ""}"),

                                        const SizedBox(height: 16),

                                      ];

                                      return Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey.shade300),
                                        ),
                                        child: Column(children: rows),
                                      );
                                    },
                                  ),
                                ],
                              ],
                            );
                          },
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
        debugPrint("Response JSON: ${const JsonEncoder.withIndent('  ').convert(j)}");
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
        debugPrint("Response JSON: ${const JsonEncoder.withIndent('  ').convert(j)}");
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
            borderRadius: BorderRadius.circular(12)
        ),
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
                (records.last.statusThird.isEmpty ? "—" : records.last.statusThird),
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
enum Polarity { credit, debit, neutral,officeSpecial }

bool _isEmpty(dynamic v) => v == null || v.toString().trim().isEmpty;

num _numVal(dynamic v) =>
    num.tryParse(v.toString().replaceAll(RegExp(r'[^\d\.\-]'), '')) ?? 0;

String _moneySigned(dynamic v, Polarity p) {
  if (_isEmpty(v)) return "—";
  final n = _numVal(v).abs();
  final sign = p == Polarity.credit ? "+" : p == Polarity.debit ? "-" : "";
  return "$sign ₹ ${n.toStringAsFixed(0)}";
}

Color _amtColor(BuildContext c, Polarity p) {
  switch (p) {
    case Polarity.credit: return Colors.green;
    case Polarity.debit:  return Colors.red;
    case Polarity.neutral:return Colors.black;
    case Polarity.officeSpecial:return Colors.blue;
  }
}

Widget _amountRow(String label, dynamic value, Polarity p,BuildContext context) {
  if (_isEmpty(value)) return const SizedBox.shrink();
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black)),
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
