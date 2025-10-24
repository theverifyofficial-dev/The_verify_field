import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'Action_Form.dart';
import 'Add_Tenent.dart';
import 'FieldWorker_Booking_Page_Details.dart';
import 'UpdateTenant.dart';

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
    required this.secondAmount,
    required this.finalAmount,
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

class FieldWorkerBookingPage extends StatefulWidget {
  const FieldWorkerBookingPage({super.key});

  @override
  State<FieldWorkerBookingPage> createState() => _FieldWorkerBookingPageState();
}

class _FieldWorkerBookingPageState extends State<FieldWorkerBookingPage> {

  String _fieldworkarnumber = '';

  Future<List<Property>> fetchBookingData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_book_flat_by_fieldworkar.php?field_workar_number=${userNumber}");
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
  late Future<List<Property>> _bookingFuture;
  late Future<List<Tenant>> _tenantFuture;
  void _loadData() {
    _bookingFuture = fetchBookingData();
  }
  Future<void> _onRefresh() async {
    setState(() {
      _loadData();
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
                        return PropertyDetailPage(propertyId: item.id.toString(),);
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
                                _buildDetailRow("Company Commission \nfrom Tenant", "₹ ${item.commission}"),
                                _buildDetailRow("Extra Expense", "₹ ${item.extraExpense}"),
                                _buildDetailRow("Total Amount", "₹ ${item.totalBalance}"),
                                _buildDetailRow("Advance Payment", "₹ ${item.advancePayment}"),
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
                          const SizedBox(height: 8),
                          /// --- Tenant Details Section
                          FutureBuilder<List<Tenant>>(
                            future: fetchTenants(item.id),
                            builder: (context, tenantSnapshot) {
                              if (tenantSnapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
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
                          /// --- Date & ID Row
                          const SizedBox(height: 10),
                          Row(
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
                                  FutureBuilder<List<Tenant>>(
                                    future: fetchTenants(item.id),
                                    builder: (context, tenantSnapshot) {
                                      if (tenantSnapshot.connectionState == ConnectionState.waiting) {
                                        return const SizedBox(
                                          height: 40,
                                          width: 100,
                                          child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                        );
                                      }
                                      if (tenantSnapshot.hasError || !tenantSnapshot.hasData || tenantSnapshot.data!.isEmpty) {
                                        // 👇 No tenant or error → Show Add Tenant
                                        return _buildTenantButton(
                                          label: "Add Tenant",
                                          color: Colors.green,
                                          onTap: () {
                                            _onRefresh();

                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => AddTenantPage(id: item.id.toString()),
                                              ),
                                            );
                                          },
                                        );
                                      }

                                      final tenant = tenantSnapshot.data!.first; // Taking first tenant for status check
                                      if (tenant.status == null || tenant.status!.isEmpty) {
                                        return _buildTenantButton(
                                          label: "Add Tenant",
                                          color: Colors.green,
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) => AddTenantPage(id: item.id.toString()),
                                              ),
                                            );
                                          },
                                        );
                                      } else {
                                        return _buildTenantButton(
                                          label: "Update Tenant",
                                          color: Colors.deepOrange,
                                          onTap: () async {
                                            final result = await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => UpdateTenantPage(
                                                    propertyId: item.id.toString(),
                                                    tenentId: tenant.id.toString(), // ✅ Pass ownerId
                                                ),
                                              ),
                                            );

                                            if (result == true) {
                                              // refresh UI if owner was added
                                              _onRefresh();
                                            }
                                          },

                                        );
                                      }
                                    },
                                  ),
                                  const SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ActionForm(propertyId: item.id.toString()),
                                        ),
                                      );

                                      if (result == true) {
                                        // refresh UI if owner was added
                                        _onRefresh();
                                      }
                                    },

                                    child: Container(
                                      height: 40,
                                      width: 90,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Text(
                                          "Add Bill",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
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
      width: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
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
