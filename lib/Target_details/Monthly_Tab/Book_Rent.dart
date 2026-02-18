import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import 'Monthly_under_detail/Monthly_bookrent_detail.dart';

class BookRentMonthlyModel {
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

  // BOOKING
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

  BookRentMonthlyModel({
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

  factory BookRentMonthlyModel.fromJson(Map<String, dynamic> json) {
    return BookRentMonthlyModel(
      pId: int.tryParse(json['P_id']?.toString() ?? '0') ?? 0,
      propertyPhoto: json['property_photo']?.toString() ?? '',
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
      rent: json['Rent']?.toString() ?? '',
      security: json['Security']?.toString() ?? '',
      commission: json['Commission']?.toString() ?? '',
      extraExpense: json['Extra_Expense']?.toString() ?? '',
      advancePayment: json['Advance_Payment']?.toString() ?? '',
      totalBalance: json['Total_Balance']?.toString() ?? '',
      bookingDate: json['booking_date']?.toString() ?? '',
      bookingTime: json['booking_time']?.toString() ?? '',
      secondAmount: json['second_amount']?.toString() ?? '',
      finalAmount: json['final_amount']?.toString() ?? '',
      ownerSideCommission: json['owner_side_commition']?.toString() ?? '',
      sourceId: json['source_id']?.toString() ?? '',
    );
  }
}

Future<List<BookRentMonthlyModel>> fetchMonthlyRentBooked() async {
  final prefs = await SharedPreferences.getInstance();
  final FNumber = prefs.getString('number') ?? "";
  print(FNumber);
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_monthly_show.php?field_workar_number=$FNumber",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Book Monthly API Error");
  }

  final decoded = json.decode(res.body);
  print(res.body);

  final List list = decoded['data'] ?? [];

  /// ✅ ONLY RENT FILTER
  final rentOnly = list.where((e) => e['Buy_Rent'] == 'Rent').toList();

  return rentOnly.map((e) => BookRentMonthlyModel.fromJson(e)).toList();
}

class MonthlyBookRentScreen extends StatefulWidget {
  const MonthlyBookRentScreen({super.key});

  @override
  State<MonthlyBookRentScreen> createState() => _MonthlyBookRentScreenState();
}

class _MonthlyBookRentScreenState extends State<MonthlyBookRentScreen> {
  late Future<List<BookRentMonthlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchMonthlyRentBooked();
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
      body: FutureBuilder<List<BookRentMonthlyModel>>(
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
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
              itemBuilder: (context, i) {
                final b = list[i];

                final isDark = Theme.of(context).brightness == Brightness.dark;

                final cardColor =
                isDark ? const Color(0xFF1A1A1A) : Colors.white;

                final textColor =
                isDark ? Colors.white : Colors.black;

                final subText =
                isDark ? Colors.grey.shade400 : Colors.grey.shade600;

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MonthlyBookRentDetailScreen(b: b),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: isDark
                          ? []
                          : [
                        BoxShadow(
                          blurRadius: 14,
                          color: Colors.black.withOpacity(.08),
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🔥 IMAGE HEADER
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                          child: Stack(
                            children: [

                              Image.network(
                                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.propertyPhoto}",
                                height: 220,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              /// 🔥 GRADIENT OVERLAY
                              Container(
                                height: 220,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(.55),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              /// 🔥 RENT BADGE
                              Positioned(
                                bottom: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 7),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Text(
                                    "RENT",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "PoppinsBold",
                                    ),
                                  ),
                                ),
                              ),

                              /// 🔥 PRICE BADGE
                              Positioned(
                                top: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    "${formatMoney(b.rent)}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12.5,
                                      fontFamily: "PoppinsBold",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// 🔥 CONTENT
                        Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 🔥 PROPERTY NAME
                              Text(
                                b.apartmentName,
                                style: TextStyle(
                                  fontSize: 17,
                                  fontFamily: "PoppinsBold",
                                  color: textColor,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 4),

                              /// 🔥 LOCATION
                              Text(
                                b.locations,
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: subText,
                                ),
                              ),

                              const SizedBox(height: 16),

                              /// 🔥 PROPERTY PILLS
                              Row(
                                children: [
                                  _pill(Icons.home, b.bhk),
                                  const SizedBox(width: 10),
                                  _pill(Icons.layers, b.floor),
                                  const SizedBox(width: 10),
                                  _pill(Icons.local_parking, b.parking),
                                ],
                              ),

                              const SizedBox(height: 16),

                              /// 🔥 SECURITY STRIP
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.black26
                                            : const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Security Deposit",
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              fontWeight: FontWeight.w600,
                                              color: subText,
                                            ),
                                          ),
                                          Text(
                                            "${formatMoney(b.security)}",
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontFamily: "PoppinsBold",
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),


                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// 🔥 OWNER STRIP
                              Text(
                                "Owner • ${b.ownerName} (${b.ownerNumber})",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
              }
          );
        },
      ),
    );
  }
}
final indianCurrency = NumberFormat.currency(
  locale: 'en_IN',
  symbol: '₹',
  decimalDigits: 0,
);

String formatMoney(String value) {
  if (value.isEmpty) return "₹0";

  final number = double.tryParse(value) ?? 0;

  return indianCurrency.format(number);
}

Widget _pill(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.06),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Text(
          text.isEmpty ? "-" : text,
          style: const TextStyle(fontSize: 11.5),
        ),
      ],
    ),
  );
}

