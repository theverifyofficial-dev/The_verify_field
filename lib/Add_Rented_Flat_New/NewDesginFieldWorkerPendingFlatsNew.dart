import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Administrator/All_Rented_Flat/AdministatorPropertyDetailPage.dart';
import 'Show_Billing_Fieldworker_Pending_Page.dart';
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
  final String bookingDate;

  // ✅ New fields
  final String rent;
  final String security;
  final String commission;
  final String ownerCommission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;
  final String secondAmount;
  final String finalAmount;

  Property({
    required this.pId,
    required this.bookingDate,
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
    required this.ownerCommission,
    required this.extraExpense,
    required this.advancePayment,
    required this.totalBalance,
    required this.finalAmount,
    required this.secondAmount,
    required this.statusForFinalPayment,
    required this.statusForSecondPayment,
    required this.sourceId,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      pId: json["P_id"] ?? 0,
      bookingDate: json["booking_date"] ?? "",
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
      ownerCommission: json["owner_side_commition"] ?? "",
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
class PaymentAmount {
  final String label;
  final dynamic value;
  final Color color;

  PaymentAmount(this.label, this.value, this.color);
}

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

class NewDesginFieldWorkerPendingFlatsNew extends StatefulWidget {
  final String? highlightPropertyId;

  const NewDesginFieldWorkerPendingFlatsNew({super.key, this.highlightPropertyId});

  @override
  State<NewDesginFieldWorkerPendingFlatsNew> createState() => _NewDesginFieldWorkerPendingFlatsNewState();
}

class _NewDesginFieldWorkerPendingFlatsNewState extends State<NewDesginFieldWorkerPendingFlatsNew> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  static Map<dynamic, DateTime>? _lastTapTimes;

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

  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_pending_flat_for_fieldworkar.php?field_workar_number=${userNumber}");
    print("User Name :"+"${userName}");
    print("User Number :"+"${userNumber}");
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

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<List<Property>>? _bookingFuture;

  Future<void> _init() async {
    await loadUserName();

    _bookingFuture = fetchBookingData();

    if (mounted) setState(() {});
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

  Key _listKey = UniqueKey();

  Future<void> _onRefresh() async {
    setState(() {
      _listKey = UniqueKey();
      _bookingFuture = fetchBookingData();
    });
  }

  double _toD(dynamic v) {
    final s = (v ?? '').toString().trim();
    return double.tryParse(s.replaceAll(RegExp(r'[^\d\.-]'), '')) ?? 0;
  }

  String _cur(num n) => "₹ ${n.toStringAsFixed(0)}";
  double remaining = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Scaffold(
        body:  _bookingFuture == null
            ? const Center(child: CircularProgressIndicator(
          color: Colors.blue,
        ))
            :
        FutureBuilder<List<Property>>(
          future: _bookingFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(
                color: Colors.blue,
              ));
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
              key: _listKey,
              padding: const EdgeInsets.all(12),
              itemCount: bookingList.length,
              itemBuilder: (context, index) {
                final item = bookingList[index];

                return _transactionCard(
                  context,
                  item,
                  isDarkMode,
                  _onRefresh, // ✅ PASS STATE METHOD
                );
              },
            );

          },
        ),
      ),
    );
  }
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
    });
  }
}
Widget _transactionCard(BuildContext context, Property item, bool isDarkMode, VoidCallback onRefresh,) {
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
    child: InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AdministatorPropertyDetailPage(
              propertyId: item.pId.toString(),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            /// ID CHIPS (THIS IS WHAT YOU ASKED 🔥)
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _idChip("Building ID: ${item.subid}", Colors.indigo, isDarkMode),
                _idChip("Flat ID: ${item.sourceId}", Colors.purple, isDarkMode),
                _idChip("Flat No: ${item.flatNumber}", Colors.teal, isDarkMode),
              ],
            ),

            const SizedBox(height: 8),
            Row(
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
                    placeholder: (_, __) =>
                        Container(color: Colors.grey.shade300),
                    errorWidget: (_, __, ___) =>
                        Icon(Icons.home, size: 40, color: Colors.grey),
                  ),
                ),

                const SizedBox(width: 12),

                /// CONTENT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE + PRICE
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${item.bhk} ${item.typeOfProperty ?? ""}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                          Text(
                            "₹ ${item.showPrice}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              fontFamily: "PoppinsMedium",
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      /// LOCATION
                      Text(
                        item.locations ?? "",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                          color: isDarkMode
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),

                      const SizedBox(height: 8),

                      /// STATUS + TRANSACTION ID
                      Row(
                        children: [
                          Text(
                            "Txn ID: #${item.pId}",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "PoppinsBold",
                              fontWeight: FontWeight.w500,
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
            const SizedBox(height: 12),

            Text("Booking Date : "+formatBookingDate(item.bookingDate),
              style: const TextStyle(
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w600,
              ),),
            SizedBox(height: 5,),
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
                  final int propertyId =
                      int.tryParse(item.pId.toString()) ?? 0;

                  if (propertyId == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid Property ID"),
                        backgroundColor: Colors.red,
                      ),
                    );
                    return;
                  }

                  debugPrint("➡️ Opening calculation page for subid: $propertyId");

                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Show_Billing_Fieldworker_Pending_Page(
                        propertyId: propertyId,
                        flatId: item.flatNumber.toString(),
                        fieldworkerName: item.fieldWorkerName,
                        fieldworkerNumber: item.fieldWorkerNumber,
                        tenantCommission: item.commission,
                        ownerCommission: item.ownerCommission,
                      ),
                    ),
                  );
                },
              ),
            ),
            if (item.statusForSecondPayment == null ||
                item.statusForSecondPayment!.isEmpty ||
                item.statusForFinalPayment == null ||
                item.statusForFinalPayment!.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Row(
                  children: [
                    if (item.statusForSecondPayment == null || item.statusForSecondPayment!.isEmpty)
                      Expanded(
                        child: _buildActionButton(
                          "Set 2nd Amount",
                          Icons.payment,
                          isDarkMode ? Colors.blue.shade700 : Colors.blue,
                          onPressed: () {
                            _openAmountSheet(
                              context,
                              item.pId,
                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/update_2nd_amount_api.php",
                              "second_amount",
                              double.tryParse(item.totalBalance) ?? 0,
                              double.tryParse(item.advancePayment) ?? 0,
                              double.tryParse(item.secondAmount) ?? 0,
                              double.tryParse(item.finalAmount) ?? 0,
                                  () {
                                onRefresh();
                              },

                            );

                          },
                        ),
                      ),
                    if ((item.statusForSecondPayment == null || item.statusForSecondPayment!.isEmpty) &&
                        (item.statusForFinalPayment == null || item.statusForFinalPayment!.isEmpty))
                      const SizedBox(width: 8),
                    if (item.statusForFinalPayment == null || item.statusForFinalPayment!.isEmpty)
                      Expanded(
                        child: _buildActionButton(
                          "Set Final Amount",
                          Icons.check_circle,
                          isDarkMode ? Colors.deepOrange.shade700 : Colors.deepOrange,
                          onPressed: () {
                            _openAmountSheet(
                              context,
                              item.pId,
                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/final_amount.php",
                              "final_amount",
                              double.tryParse(item.totalBalance) ?? 0,
                              double.tryParse(item.advancePayment) ?? 0,
                              double.tryParse(item.secondAmount) ?? 0,
                              double.tryParse(item.finalAmount) ?? 0,
                                  () {
                                onRefresh(); // ✅ SAFE REFRESH
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ),

          ],
        ),
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
void _openAmountSheet(
    BuildContext context,
    int pId,
    String apiUrl,
    String fieldName,
    double totalAmount,
    double advanceAmount,
    double secondAmount,
    double finalAmount,
    VoidCallback onUpdated,
    ) {
  final TextEditingController controller = TextEditingController();

  double remaining =
      totalAmount - advanceAmount - secondAmount - finalAmount;

  // Set initial value in input
  controller.text = remaining.toStringAsFixed(0);

  final ValueNotifier<double> remainingNotifier =
  ValueNotifier<double>(remaining);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            /// INPUT FIELD
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final entered = double.tryParse(value) ?? 0;

                final newRemaining =
                    totalAmount - advanceAmount - secondAmount - finalAmount - entered;

                remainingNotifier.value =
                newRemaining < 0 ? 0 : newRemaining;
              },
            ),

            const SizedBox(height: 12),

            /// LIVE REMAINING TEXT
            ValueListenableBuilder<double>(
              valueListenable: remainingNotifier,
              builder: (_, value, __) {
                return Text(
                  "Remaining: ₹ ${value.toStringAsFixed(0)}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: value == 0 ? Colors.red : Colors.green,
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);

                await _sendAmount(
                  context,
                  pId,
                  apiUrl,
                  fieldName,
                  controller.text,
                );

                Future.microtask(onUpdated);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Save"),
            ),
          ],
        ),
      );
    },
  );
}
Future<void> _sendAmount(
    BuildContext context,
    int pId,
    String apiUrl,
    String fieldName,
    String amount,
    ) async {
  try {
    final resp = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {"P_id": pId.toString(), fieldName: amount},
    );

    if (resp.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "✅ Update Successfully",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 4),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ HTTP ${resp.statusCode}: ${resp.body}"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("⚠️ Error: $e"),
        backgroundColor: Colors.orange,
      ),
    );
  }
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