import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

import 'Monthly_under_detail/Monthly_Livecommercial_details.dart';

class MonthlyCommercialModel {
  final int id;

  final String image;
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
  final String squareFit;
  final String maintaince;
  final String parking;
  final String ageOfProperty;

  final String fieldworkerAddress;
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

  final String sourceId;
  final String dateForTarget;
  final String localityList;

  MonthlyCommercialModel({
    required this.id,
    required this.image,
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
    required this.squareFit,
    required this.maintaince,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkerAddress,
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
    required this.sourceId,
    required this.dateForTarget,
    required this.localityList,
  });

  factory MonthlyCommercialModel.fromJson(Map<String, dynamic> json) {
    return MonthlyCommercialModel(
      id: int.tryParse(json['P_id']?.toString() ?? '0') ?? 0,

      image: json['property_photo']?.toString() ?? '',
      locations: json['locations']?.toString() ?? '',
      flatNumber: json['Flat_number']?.toString() ?? '',
      buyRent: json['Buy_Rent']?.toString() ?? '',
      residenceCommercial: json['Residence_Commercial']?.toString() ?? '',
      apartmentName: json['Apartment_name']?.toString() ?? '',
      apartmentAddress: json['Apartment_Address']?.toString() ?? '',
      typeOfProperty: json['Typeofproperty']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',

      showPrice: json['show_Price']?.toString() ?? '',
      lastPrice: json['Last_Price']?.toString() ?? '',
      askingPrice: json['asking_price']?.toString() ?? '',

      floor: json['Floor_']?.toString() ?? '',
      totalFloor: json['Total_floor']?.toString() ?? '',
      balcony: json['Balcony']?.toString() ?? '',
      squareFit: json['squarefit']?.toString() ?? '',
      maintaince: json['maintance']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',

      fieldworkerAddress: json['fieldworkar_address']?.toString() ?? '',
      roadSize: json['Road_Size']?.toString() ?? '',
      metroDistance: json['metro_distance']?.toString() ?? '',
      highwayDistance: json['highway_distance']?.toString() ?? '',
      mainMarketDistance: json['main_market_distance']?.toString() ?? '',
      meter: json['meter']?.toString() ?? '',

      ownerName: json['owner_name']?.toString() ?? '',
      ownerNumber: json['owner_number']?.toString() ?? '',

      currentDates: json['current_dates']?.toString() ?? '',
      availableDate: json['available_date']?.toString() ?? '',

      kitchen: json['kitchen']?.toString() ?? '',
      bathroom: json['bathroom']?.toString() ?? '',
      lift: json['lift']?.toString() ?? '',
      facility: json['Facility']?.toString() ?? '',
      furnishedUnfurnished: json['furnished_unfurnished']?.toString() ?? '',

      fieldWorkerName: json['field_warkar_name']?.toString() ?? '',
      liveUnlive: json['live_unlive']?.toString() ?? '',
      fieldWorkerNumber: json['field_workar_number']?.toString() ?? '',

      registryAndGpa: json['registry_and_gpa']?.toString() ?? '',
      loan: json['loan']?.toString() ?? '',

      longitude: json['Longitude']?.toString() ?? '',
      latitude: json['Latitude']?.toString() ?? '',
      videoLink: json['video_link']?.toString() ?? '',

      caretakerName: json['care_taker_name']?.toString() ?? '',
      caretakerNumber: json['care_taker_number']?.toString() ?? '',

      sourceId: json['source_id']?.toString() ?? '',
      dateForTarget: json['date_for_target']?.toString() ?? '',
      localityList: json['locality_list']?.toString() ?? '',
    );
  }
}


Future<List<MonthlyCommercialModel>> fetchMonthlyCommercial() async {
  final prefs = await SharedPreferences.getInstance();
  final FNumber = prefs.getString('number') ?? "";
  print(FNumber);
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/commercial_month.php?field_workar_number=$FNumber",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Commercial Monthly API Error");
  }

  final decoded = json.decode(res.body);
  print(res.body);

  final List list = decoded['data'] ?? [];

  return list.map((e) => MonthlyCommercialModel.fromJson(e)).toList();
}

class MonthlyCommercialScreen extends StatefulWidget {
  const MonthlyCommercialScreen({super.key});

  @override
  State<MonthlyCommercialScreen> createState() =>
      _MonthlyCommercialScreenState();
}

class _MonthlyCommercialScreenState extends State<MonthlyCommercialScreen> {
  late Future<List<MonthlyCommercialModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchMonthlyCommercial();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: FutureBuilder<List<MonthlyCommercialModel>>(
        future: futureData,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final list = snap.data ?? [];

          if (list.isEmpty) {
            return const Center(
                child:
                Text(
                    "No Commercial Property Found"
                ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final b = list[i];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonthluCommercialDetailScreen(c: b),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: theme.brightness == Brightness.dark
                        ? []
                        : [
                      BoxShadow(
                        blurRadius: 12,
                        color: Colors.black.withOpacity(.08),
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// 🔥 PROPERTY IMAGE + PRICE BADGE
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(22),
                            ),
                            child: Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.image}",
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 200,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          /// PRICE BADGE
                          Positioned(
                            right: 12,
                            top: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Commercial",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),

                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            /// LOCATION
                            Text(
                              "${b.locations} • ${b.localityList}",
                              style: theme.textTheme.bodySmall,
                            ),

                            const SizedBox(height: 12),

                            /// 🔥 PROPERTY INFO PILLS
                            Row(
                              children: [
                                _pill(Icons.home, b.bhk),
                                const SizedBox(width: 8),
                                _pill(Icons.layers, "${b.floor}"),
                                const SizedBox(width: 8),
                                _pill(Icons.local_parking, b.parking),
                              ],
                            ),



                            const SizedBox(height: 6),

                            /// OWNER
                            Text(
                              "Owner: ${b.ownerName} (${b.ownerNumber})",
                              style: theme.textTheme.bodySmall,
                            ),

                          ],
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
    );
  }
}
String formatMoney(String value) {
  if (value.isEmpty) return "₹0";

  final number = double.tryParse(value) ?? 0;

  return NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  ).format(number);
}

Widget _pill(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.blue.withOpacity(.08),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Text(
          text.isEmpty ? "-" : text,
          style: const TextStyle(fontSize: 11),
        ),
      ],
    ),
  );
}

