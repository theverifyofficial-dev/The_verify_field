import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Add_Rented_Flat/Action_Form.dart';
import '../../Add_Rented_Flat/Add_Tenent.dart';
import '../../Add_Rented_Flat/FieldWorker_Booking_Page_Details.dart';
import '../../constant.dart';
import 'AdministatorPropertyDetailPage.dart';
import 'Pending_Add _Property_Form.dart';
import 'Pending_Property_Update_Form.dart';
import 'PropertyCalculationPage.dart';
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
  final dynamic subid;

  // ✅ New fields
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;

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
    );
  }
}

class Tenant {
  final int id;
  final String tenantName;
  final String tenantPhoneNumber;
  final String? flatRent;
  final String shiftingDate;
  final String? members;
  final String? email;
  final String? tenantVichalDetails;
  final String? workProfile;
  final String? bhk;
  final String? typeOfProperty;
  final int subId;
  final String paymentMode;
  final String status;

  Tenant({
    required this.id,
    required this.tenantName,
    required this.tenantPhoneNumber,
    this.flatRent,
    required this.shiftingDate,
    this.members,
    this.email,
    this.tenantVichalDetails,
    this.workProfile,
    this.bhk,
    this.typeOfProperty,
    required this.subId,
    required this.paymentMode,
    required this.status,
  });

  factory Tenant.fromJson(Map<String, dynamic> json) {
    return Tenant(
      id: json['id'],
      tenantName: json['tenant_name'] ?? "",
      tenantPhoneNumber: json['tenant_phone_number'] ?? "",
      flatRent: json['flat_rent']?.toString(),
      shiftingDate: json['shifting_date'] ?? "",
      members: json['members'],
      email: json['email'],
      tenantVichalDetails: json['tenant_vichal_details'],
      workProfile: json['work_profile'],
      bhk: json['bhk'],
      typeOfProperty: json['type_of_property'],
      subId: json['sub_id'],
      paymentMode: json['payment_mode'] ?? "",
      status: json['status'] ?? "",
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
class FirstPaymentRecord {
  final int id;
  final String subid;

  // statuses
  final String statusFirst;   // status_fist
  final String statusSec;     // status_tow
  final String statusThird;   // status_three

  // step 1
  final String tenantAdvance;        // tenant_advance
  final String giveToOwnerAdvance;   // give_to_owner_advance
  final String officeHold;           // office_hold

  // step 2
  final String? midPaymentToOwner;         // mid_payment_to_owner
  final String? ownerReceivedPaymentInMid; // owner_reccived_payment_in_mid

  // step 3 (old set you already had)
  final String? tenantPayLastAmount;         // tenant_pay_last_amount
  final String? bothSideCompanyCommission;   // bothside_company_comition
  final String? ownerReceivedFinalAmount;    // owner_recived_final_amount
  final String? tenantTotalPay;              // tenant_tatal_pay
  final String? ownerTotalReceivedAmount;    // owner_total_recived_amount

  // step 3 (NEW keys to add)
  final String? remainingHold;                 // remaining_hold
  final String? companyKeepComition;           // company_keep_comition
  final String? remainBalanceShareToOwner;     // remain_balance_share_to_owner
  final String? finalRecivedAmountOwner;       // final_recived_amount_owner
  final String? remaingFinalBalance;           // remaing_final_balance
  final String? totalPayTenant;                // total_pay_tenant

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
    // new ones
    this.remainingHold,
    this.companyKeepComition,
    this.remainBalanceShareToOwner,
    this.finalRecivedAmountOwner,
    this.remaingFinalBalance,
    this.totalPayTenant,
  });

  factory FirstPaymentRecord.fromJson(Map<String, dynamic> j) => FirstPaymentRecord(
    id: int.tryParse(j['id']?.toString() ?? '') ?? 0,
    subid: (j['subid'] ?? '').toString(),

    statusFirst: (j['status_fist'] ?? '').toString(),
    statusSec: (j['status_tow'] ?? '').toString(),
    statusThird: (j['status_three'] ?? '').toString(),

    tenantAdvance: (j['tenant_advance'] ?? '').toString(),
    giveToOwnerAdvance: (j['give_to_owner_advance'] ?? '').toString(),
    officeHold: (j['office_hold'] ?? '').toString(),

    midPaymentToOwner: j['mid_payment_to_owner']?.toString(),
    ownerReceivedPaymentInMid: j['owner_reccived_payment_in_mid']?.toString(),

    // existing step-3 fields
    tenantPayLastAmount: j['tenant_pay_last_amount']?.toString(),
    bothSideCompanyCommission: j['bothside_company_comition']?.toString(),
    ownerReceivedFinalAmount: j['owner_recived_final_amount']?.toString(),
    tenantTotalPay: j['tenant_tatal_pay']?.toString(),
    ownerTotalReceivedAmount: j['owner_total_recived_amount']?.toString(),

    // NEW fields (exact keys from new payload)
    remainingHold: j['remaining_hold']?.toString(),
    companyKeepComition: j['company_keep_comition']?.toString(),
    remainBalanceShareToOwner: j['remain_balance_share_to_owner']?.toString(),
    finalRecivedAmountOwner: j['final_recived_amount_owner']?.toString(),
    remaingFinalBalance: j['remaing_final_balance']?.toString(),
    totalPayTenant: j['total_pay_tenant']?.toString(),
  );
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

  // new ones
  num get nRemainingHold => _n(remainingHold);
  num get nCompanyKeepComition => _n(companyKeepComition);
  num get nRemainBalanceShareToOwner => _n(remainBalanceShareToOwner);
  num get nFinalRecivedAmountOwner => _n(finalRecivedAmountOwner);
  num get nRemaingFinalBalance => _n(remaingFinalBalance);
  num get nTotalPayTenant => _n(totalPayTenant);
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return AdministatorPropertyDetailPage(propertyId: item.id.toString(),);
                    }));
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
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Financial Details",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    "ID: ${item.id}",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(thickness: 0.5, color: Colors.grey),

                              _buildDetailRow("Rent", "₹ ${item.rent}"),
                              _buildDetailRow("Security", "₹ ${item.security}"),
                              _buildDetailRow("Tenant Commission", "₹ ${item.commission}"),
                              _buildDetailRow("Extra Expense", "₹ ${item.extraExpense}"),
                              _buildDetailRow("Total Amount", "₹ ${item.totalBalance}"),
                              _buildAdvancePayment("Advance Payment", "₹ ${item.advancePayment}"),

                            ],
                          ),
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
                                        _buildTag(tenant.tenantPhoneNumber, Colors.green),
                                        _buildTag(_formatDate(tenant.shiftingDate), Colors.blue),
                                        _buildTag(tenant.paymentMode, Colors.red),

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

                            Row(
                              children: [
                              _buildTenantButton(
                              label: "Add Billing",
                              color: Colors.blue,
                              onTap: () async {
                                // wherever you have the current property's id:
                                final int propertyId = item.id; // or however you get it

                                final ok = await Navigator.push<bool>(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => PropertyCalculate(propertyId: propertyId),
                                  ),
                                );

                                if (ok == true) {
                                  _onRefresh();
                                }
                              },
                            ),
                                SizedBox(width: 6,),
                                FutureBuilder<List<OwnerData>>(
                                  future: fetchPersonDetail(item.id),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const SizedBox(
                                        height: 40,
                                        child: Center(),
                                      );
                                    }

                                    if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                      // 👉 No Owner → Show Add Owner button
                                      return _buildTenantButton(
                                        label: "Add Owner Detail",
                                        color: Colors.green,
                                        onTap: () async {
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AddOwnerPage(propertyId: item.id.toString()),
                                            ),
                                          );

                                          if (result == true) {
                                            // refresh UI if owner was added
                                            _onRefresh();
                                          }
                                        },
                                      );
                                    }
                                    else {
                                      final owner = snapshot.data!.first; // ✅ Get first owner (or loop if multiple)
                                      return _buildTenantButton(
                                        label: "Update Owner Detail",
                                        color: Colors.deepOrange,
                                        onTap: () async {
                                          print("Owner Id :"+owner.id.toString());
                                          final result = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => UpdateOwnerPage(
                                                ownerId: owner.id.toString(), // ✅ Pass ownerId
                                                propertyId: item.id.toString(), // ✅ Pass ownerId
                                              ),
                                            ),
                                          );

                                          if (result == true) {
                                            _onRefresh();
                                          }
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            )

                          ],
                        ),
                        const SizedBox(height: 20),

                        FutureBuilder<List<FirstPaymentRecord>>(
                          future: fetchFirstPaymentsBySubId(item.id), // returns list for this property/subid
                          builder: (context, billingSnapshot) {
                            if (billingSnapshot.connectionState == ConnectionState.waiting) {
                              return const Center();
                            }

                            if (billingSnapshot.hasError) {
                              return const Text("Billing data error", style: TextStyle(color: Colors.black54));
                            }

                            final list = billingSnapshot.data ?? const <FirstPaymentRecord>[];

                            // No step-1 record yet -> show Add button
                            if (list.isEmpty) {
                              return Text("");
                            }
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              padding: EdgeInsets.all(6),

                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 8),
                                  const Text(
                                    "Step 1 Billing",
                                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                                  ),
                                  const SizedBox(height: 10),

                                  // Map each record to a card. If you only want the latest shown, render [list.last] instead.
                                  ...list.map((rec) => Column(
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
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: Column(
                                          children: [
                                            _buildDetailRow("Tenant Advance: ", "₹ ${rec.tenantAdvance}"),
                                            _buildDetailRow("Give to Owner: ", "₹ ${rec.giveToOwnerAdvance}"),
                                            _buildDetailRow("Office Hold: ", "₹ ${rec.officeHold}"),
                                          ],
                                        ),
                                      ),
                                      // const SizedBox(height: 8),

                                      const SizedBox(height: 12),
                                    ],
                                  )),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        FutureBuilder<List<FirstPaymentRecord>>(
                          future: fetchFirstPaymentsBySubId(item.id),
                          builder: (context, billingSnapshot) {
                            if (billingSnapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }

                            if (billingSnapshot.hasError) {
                              return const Text("Billing data error", style: TextStyle(color: Colors.black54));
                            }

                            final all = billingSnapshot.data ?? const <FirstPaymentRecord>[];

                            // Treat null/empty/zero as "no value"
                            bool _hasMid(dynamic v) {
                              if (v == null) return false;
                              if (v is num) return v != 0;
                              final s = v.toString().trim();
                              if (s.isEmpty) return false;
                              final n = num.tryParse(s.replaceAll(RegExp(r'[^\d\.\-]'), ''));
                              return (n ?? 0) != 0;
                            }

                            // Keep only records where Mid Payment To Owner has a value
                            final list = all.where((r) => _hasMid(r.midPaymentToOwner)).toList();

                            // If none have the field, show nothing at all
                            if (list.isEmpty) return const SizedBox.shrink();

                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Step 2 Billing",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                                      ),
                                      const SizedBox(height: 10),

                                      // Only mapped over records that actually have the field
                                      ...list.map((rec) => Column(
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
                                              border: Border.all(color: Colors.grey.shade200),
                                            ),
                                            child: Column(
                                              children: [
                                                _buildDetailRow("Mid Payment From Tenant: ", "₹ ${rec.midPaymentToOwner}"),
                                                _buildDetailRow("Office Transfer Payment \nTo Owner: ", "₹ ${rec.midPaymentToOwner}"),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 12),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 10),

                        FutureBuilder<List<FirstPaymentRecord>>(
                          future: fetchFirstPaymentsBySubId(item.id),
                          builder: (context, billingSnapshot) {
                            if (billingSnapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink();
                            }
                            if (billingSnapshot.hasError) {
                              return const Text("Billing data error", style: TextStyle(color: Colors.black54));
                            }

                            final all = billingSnapshot.data ?? const <FirstPaymentRecord>[];

                            // show value if it’s present (even "0"), hide only if null or empty string
                            bool _hasAny(dynamic v) {
                              if (v == null) return false;
                              final s = v.toString().trim();
                              return s.isNotEmpty;
                            }

                            String _money(dynamic v) {
                              if (v == null || v.toString().trim().isEmpty) return "—";
                              final n = num.tryParse(v.toString().replaceAll(RegExp(r'[^\d\.\-]'), '')) ?? 0;
                              return "₹ ${n.toStringAsFixed(0)}";
                            }

                            // consider a record as having step 3 if ANY of these keys exist (old + new)
                            bool _hasStep3(FirstPaymentRecord r) =>
                                _hasAny(r.tenantPayLastAmount) ||
                                    _hasAny(r.bothSideCompanyCommission) ||
                                    _hasAny(r.ownerReceivedFinalAmount) ||
                                    _hasAny(r.tenantTotalPay) ||
                                    _hasAny(r.ownerTotalReceivedAmount) || // legacy
                                    _hasAny(r.remainingHold) ||
                                    _hasAny(r.companyKeepComition) ||
                                    _hasAny(r.remainBalanceShareToOwner) ||
                                    _hasAny(r.finalRecivedAmountOwner) ||
                                    _hasAny(r.remaingFinalBalance) ||
                                    _hasAny(r.totalPayTenant);

                            final filtered = all.where(_hasStep3).toList();
                            if (filtered.isEmpty) return const SizedBox.shrink();

                            // latest row only
                            final rec = filtered.last;

                            List<Widget> rows = [];
                            void addRow(String k, dynamic v) {
                              if (_hasAny(v)) rows.add(_buildDetailRow(k, _money(v)));
                            }

                            // Step 3 — use the CORRECT fields
                            addRow("Last Payment From Tenant", rec.tenantPayLastAmount);
                            addRow("Both-side Company Commission (Total)", rec.bothSideCompanyCommission);

                            // NEW server keys
                            addRow("Remaining Hold (Final + Hold)", rec.remainingHold);
                            addRow("Company Keep Commission", rec.companyKeepComition);
                            addRow("Owner Share From Pool", rec.remainBalanceShareToOwner);
                            addRow("Owner Final Received", rec.finalRecivedAmountOwner);
                            addRow("Remaining Final Balance", rec.remaingFinalBalance);
                            addRow("Total Paid By Tenant", rec.totalPayTenant);

                            // // Context (optional)
                            // addRow("Mid Payment To Owner (Step 2)", rec.midPaymentToOwner);
                            // addRow("Advance Given To Owner (Step 1)", rec.giveToOwnerAdvance);
                            // addRow("Office Hold (Step 1)", rec.officeHold);

                            return Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      const Text(
                                        "Step 3 Billing",
                                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        children: [
                                          _buildTag(rec.statusThird.isEmpty ? "—" : rec.statusThird, Colors.deepPurple),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade50,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(color: Colors.grey.shade200),
                                        ),
                                        child: Column(children: rows),
                                      ),
                                      const SizedBox(height: 12),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 8),
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
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fieldworkarnumber = prefs.getString('number') ?? '';
    });
  }
}
Widget _buildTenantButton({
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 40,
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
Widget _buildDetailRow(String label, String value) {
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
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}
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
Widget _buildTag(String text, Color color) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(width: 1, color: color),
      boxShadow: [
        BoxShadow(
          color: color.withOpacity(0.5),
          blurRadius: 10,
          offset: const Offset(0, 0),
          blurStyle: BlurStyle.outer,
        ),
      ],
    ),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.black,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      ),
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
