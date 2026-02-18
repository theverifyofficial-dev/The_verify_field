import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

import 'Target_Under_Details_/BookBuy_details.dart';
import 'Target_Under_Details_/BookRent_details.dart';

class yearlyBookRentModel {
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
  final String rent;
  final String security;
  final String commission;
  final String extraExpense;
  final String advancePayment;
  final String totalBalance;
  final String bookingDate;
  final String bookingTime;
  final String secondAmount;
  final String finalAmount;
  final String ownerSideCommission;
  final String sourceId;

  yearlyBookRentModel({
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
  required this.rent,
  required this.security,
  required this.commission,
  required this.extraExpense,
  required this.advancePayment,
  required this.totalBalance,
  required this.bookingDate,
  required this.bookingTime,
  required this.secondAmount,
  required this.finalAmount,
  required this.ownerSideCommission,
  required this.sourceId,

  });

  factory yearlyBookRentModel.fromJson(Map<String, dynamic> json) {
    String s(v) => v == null ? '' : v.toString();

    return yearlyBookRentModel(
      pId: int.tryParse(s(json['P_id'])) ?? 0,
      propertyPhoto: s(json['property_photo']),
      locations: s(json['locations']),
      flatNumber: s(json['Flat_number']),
      buyRent: s(json['Buy_Rent']),
      residenceCommercial: s(json['Residence_Commercial']),
      apartmentName: s(json['Apartment_name']),
      apartmentAddress: s(json['Apartment_Address']),
      typeOfProperty: s(json['Typeofproperty']),
      bhk: s(json['Bhk']),
      showPrice: s(json['show_Price']),
      lastPrice: s(json['Last_Price']),
      askingPrice: s(json['asking_price']),
      floor: s(json['Floor_']),
      totalFloor: s(json['Total_floor']),
      balcony: s(json['Balcony']),
      squareFit: s(json['squarefit']),
      maintaince: s(json['maintance']),
      parking: s(json['parking']),
      ageOfProperty: s(json['age_of_property']),
      fieldworkerAddress: s(json['fieldworkar_address']),
      roadSize: s(json['Road_Size']),
      metroDistance: s(json['metro_distance']),
      highwayDistance: s(json['highway_distance']),
      mainMarketDistance: s(json['main_market_distance']),
      meter: s(json['meter']),
      ownerName: s(json['owner_name']),
      ownerNumber: s(json['owner_number']),
      currentDates: s(json['current_dates']),
      availableDate: s(json['available_date']),
      kitchen: s(json['kitchen']),
      bathroom: s(json['bathroom']),
      lift: s(json['lift']),
      facility: s(json['Facility']),
      furnishedUnfurnished: s(json['furnished_unfurnished']),
      fieldWorkerName: s(json['field_warkar_name']),
      liveUnlive: s(json['live_unlive']),
      fieldWorkerNumber: s(json['field_workar_number']),
      registryAndGpa: s(json['registry_and_gpa']),
      loan: s(json['loan']),
      longitude: s(json['Longitude']),
      latitude: s(json['Latitude']),
      videoLink: s(json['video_link']),
      caretakerName: s(json['care_taker_name']),
      caretakerNumber: s(json['care_taker_number']),
      rent: s(json['Rent']),
      security: s(json['Security']),
      commission: s(json['Commission']),
      extraExpense: s(json['Extra_Expense']),
      advancePayment: s(json['Advance_Payment']),
      totalBalance: s(json['Total_Balance']),
      bookingDate: s(json['booking_date']),
      bookingTime: s(json['booking_time']),
      secondAmount: s(json['second_amount']),
      finalAmount: s(json['final_amount']),
      ownerSideCommission: s(json['owner_side_commition']),
      sourceId: s(json['source_id']),
    );
  }

}


Future<List<yearlyBookRentModel>> fetchRentBookedBuildings() async {
  final prefs = await SharedPreferences.getInstance();
  final FNumber = prefs.getString('number') ?? "";
  print(FNumber);
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_yearly_show.php?field_workar_number=$FNumber",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Server Error");
  }

  final decoded = json.decode(res.body);
  List list = decoded['data'] ?? [];

  /// ✅ SIRF RENT FILTER
  final rentOnly = list.where((e) => e['Buy_Rent'] == 'Rent').toList();

  return rentOnly.map((e) => yearlyBookRentModel.fromJson(e)).toList();
}

class YearlyBookrentScreen extends StatefulWidget {
  const YearlyBookrentScreen({super.key});

  @override
  State<YearlyBookrentScreen> createState() => _YearlyBookrentScreenState();
}

class _YearlyBookrentScreenState extends State<YearlyBookrentScreen> {
  late Future<List<yearlyBookRentModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchRentBookedBuildings();

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title:
        Image.asset(AppImages.transparent,height: 40,),
        centerTitle: true,
      ),
      body: FutureBuilder<List<yearlyBookRentModel>>(
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
            return const Center(child: Text("No Rent Bookings Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final b = list[i];

              final isDark = Theme.of(context).brightness == Brightness.dark;

              final cardBg = isDark ? const Color(0xFF171717) : Colors.white;
              final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade800;

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookRentDetailScreen(b: b),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ================= IMAGE =================
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(22)),
                            child: Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.propertyPhoto}",
                              height: 210,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 210,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),

                          /// PRICE BADGE 🔥
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(.95),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                indianCurrency(
                                    b.rent.isEmpty ? "0" : b.rent),
                                style: const TextStyle(
                                  fontFamily: "PoppinsBold",
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),

                          /// RENT TAG
                          Positioned(
                            top: 14,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(.9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "RENT",
                                style: TextStyle(
                                  fontFamily: "PoppinsBold",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// ================= DETAILS =================
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// LOCATION
                            Text(
                              b.locations,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// INFO ROW
                            Row(
                              children: [
                                _chip(Icons.layers, "${b.floor}", subText),
                                _chip(Icons.apartment, "${b.totalFloor}", subText),
                                _chip(Icons.local_parking, "${b.parking}", subText),
                              ],
                            ),



                            const SizedBox(height: 8),

                            /// BOOKING DATE 🔥
                            Text(
                              formatDate(b.bookingDate),
                              style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontSize: 11,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// FIELD WORKER
                            Text(
                              "Field Worker: ${b.fieldWorkerName}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: subText,
                              ),
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
String formatDate(String rawDate) {
  if (rawDate.isEmpty) return "";

  try {
    final date = DateTime.parse(rawDate);
    return DateFormat("dd MMM yyyy").format(date);
  } catch (e) {
    return rawDate;
  }
}
String indianCurrency(String value) {
  final amount = int.tryParse(value) ?? 0;

  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  return formatter.format(amount);
}
Widget _chip(IconData icon, String text, Color color) {
  return Padding(
    padding: const EdgeInsets.only(right: 14),
    child: Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: "PoppinsMedium",
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    ),
  );
}
