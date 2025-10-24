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
import '../Administrator/All_Rented_Flat/AdministatorPropertyDetailPage.dart';
import '../Administrator/All_Rented_Flat/Pending_Add _Property_Form.dart';
import '../Administrator/All_Rented_Flat/Pending_Property_Update_Form.dart';
import '../Administrator/All_Rented_Flat/PropertyCalculationPage.dart';
import 'All_finacial.dart';
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

class FirstPaymentRecord {
  final int id;
  final String subid;
  final String statusFirst;
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

  FirstPaymentRecord({
    required this.id,
    required this.subid,
    required this.statusFirst,
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
  });

  factory FirstPaymentRecord.fromJson(Map<String, dynamic> j) => FirstPaymentRecord(
    id: int.tryParse(j['id']?.toString() ?? '') ?? 0,
    subid: (j['subid'] ?? '').toString(),
    statusFirst: (j['status_fist'] ?? '').toString(),
    tenantAdvance: (j['tenant_advance'] ?? '').toString(),
    giveToOwnerAdvance: (j['give_to_owner_advance'] ?? '').toString(),
    officeHold: (j['office_hold'] ?? '').toString(),
    midPaymentToOwner: j['mid_payment_to_owner']?.toString(),
    ownerReceivedPaymentInMid: j['owner_reccived_payment_in_mid']?.toString(),
    tenantPayLastAmount: j['tenant_pay_last_amount']?.toString(),
    bothSideCompanyCommission: j['bothside_company_comition']?.toString(),
    ownerReceivedFinalAmount: j['owner_recived_final_amount']?.toString(),
    tenantTotalPay: j['tenant_tatal_pay']?.toString(),
    ownerTotalReceivedAmount: j['owner_total_recived_amount']?.toString(),
  );
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
class FieldWorkerPendingFlats extends StatefulWidget {
  const FieldWorkerPendingFlats({super.key});

  @override
  State<FieldWorkerPendingFlats> createState() => _FieldWorkerPendingFlatsState();
}

class _FieldWorkerPendingFlatsState extends State<FieldWorkerPendingFlats> {

  String _fieldworkarnumber = '';
  static Map<dynamic, DateTime>? _lastTapTimes;
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
  void _openAmountSheet(
      BuildContext context,
      int pId,
      String title,
      String apiUrl,
      String fieldName,
      ) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: "Enter Amount",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final amount = controller.text.trim();
                    if (amount.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please enter amount")),
                      );
                      return;
                    }

                    Navigator.pop(context,true); // close sheet
                    await _sendAmount(context, pId, apiUrl, fieldName, amount);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: const Text("Save",style: TextStyle(color: Colors.white),),
                ),
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

      String message;

      if (resp.statusCode == 200) {
        try {
          final data = json.decode(resp.body);
          message = data["message"]?.toString() ??
              data["status"]?.toString() ??
              resp.body.toString();
        } catch (_) {
          message = resp.body.toString();
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("✅ Update Successfully",style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
          ),
        );

        // ---- REFRESH PAGE ----
        if (context.mounted) {
          // re-call your refresh or rebuild function here
          if (context.findAncestorStateOfType<_FieldWorkerPendingFlatsState>() != null) {
            final parentState = context.findAncestorStateOfType<_FieldWorkerPendingFlatsState>()!;
            parentState._onRefresh(); // this re-fetches your data
          }
        }

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
                              _buildDetailRow("Company Commission \nFrom Tenant", "₹ ${item.commission}"),
                              _buildDetailRow("Extra Expense", "₹ ${item.extraExpense}"),
                              _buildDetailRow("Total Amount", "₹ ${item.totalBalance}"),
                              _buildDetailRow("Advance Payment", "₹ ${item.advancePayment}"),
                              _buildDetailRow("Second Amount", "₹ ${item.secondAmount}"),
                              _buildDetailRow("Final Payment", "₹ ${item.finalAmount}"),
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
                              // --- Two Buttons (Open Sheets) ---
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                    onPressed: () {
                                      _openAmountSheet(
                                        context,
                                        item.id,
                                        "Second Amount",
                                        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/update_2nd_amount_api.php",
                                        "second_amount",
                                      );
                                    },
                                    child: const Text("Set 2nd Amount",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,),),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                                    onPressed: () {
                                      _openAmountSheet(
                                        context,
                                        item.id,
                                        "Final Amount",
                                        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/final_amount.php",
                                        "final_amount",
                                      );
                                    },
                                    child: const Text("Set Final Amount",style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,),),
                                  ),
                                ],
                              ),


                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            if(item.statusForSecondPayment!=null&& item.statusForSecondPayment!="")
                            _buildTag(item.statusForSecondPayment, Colors.green),
                            if(item.statusForFinalPayment!=null&& item.statusForFinalPayment!="")

                              _buildTag(item.statusForFinalPayment, Colors.deepOrangeAccent),
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
                              return const Text("Data Empty",
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
                        /// --- Owner Details Section
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
