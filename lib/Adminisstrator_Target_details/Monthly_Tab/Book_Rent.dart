import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import 'Monthly_under_detail/Monthly_bookrent_detail.dart';
/// =======================
/// MODEL
/// =======================
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

/// =======================
/// API FETCH (ONLY RENT)
/// =======================
Future<List<BookRentMonthlyModel>> fetchMonthlyRentBooked(String number) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_monthly_show.php?field_workar_number=${number}",
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

class MonthlyBookRent extends StatefulWidget {
  final String number;
  const MonthlyBookRent({super.key, required this.number});

  @override
  State<MonthlyBookRent> createState() => _MonthlyBookRentState();
}

class _MonthlyBookRentState extends State<MonthlyBookRent> {
  late Future<List<BookRentMonthlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchMonthlyRentBooked(widget.number);
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

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MonthlyBookRentDetailScreen(b: b),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: theme.cardColor,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ================= IMAGE =================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [

                            Image.network(
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

                            /// Gradient Overlay
                            Container(
                              height: 210,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withOpacity(.65),
                                  ],
                                ),
                              ),
                            ),

                            /// BOOKED BADGE 🔥
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFF6366F1).withOpacity(.9),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Text(
                                  "BOOKED",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "PoppinsBold",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            /// PRICE
                            Positioned(
                              bottom: 18,
                              right: 18,
                              child: Text(
                                "₹${b.rent}",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontFamily: "PoppinsBold",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            /// PROPERTY TITLE
                            Positioned(
                              bottom: 18,
                              left: 18,
                              right: 100,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    b.furnishedUnfurnished,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontFamily: "PoppinsBold",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Row(
                                    children: [
                                      const Icon(Icons.location_on,
                                          color: Colors.white70, size: 15),
                                      const SizedBox(width: 4),
                                      Expanded(
                                        child: Text(
                                          b.locations,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                            fontFamily: "PoppinsMedium",
                                          ),
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

                      const SizedBox(height: 14),

                      /// ================= DETAILS =================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// OWNER + SECURITY
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      b.ownerName,
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: "PoppinsMedium",
                                      ),
                                    ),
                                    Text(
                                      "(${b.ownerNumber})",
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontFamily: "PoppinsMedium",
                                      ),
                                    ),
                                  ],
                                ),

                                Text(
                                  "Security ₹${b.security}",
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: "PoppinsMedium",
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// CHIPS ROW
                            Row(
                              children: [
                                _LuxuryChip(Icons.home, b.bhk),
                                const SizedBox(width: 8),
                                _LuxuryChip(Icons.layers, b.floor),
                                const SizedBox(width: 8),
                                _LuxuryChip(Icons.local_parking, b.parking),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// COMMISSION + BALANCE
                            Text(
                              "Commission ₹${b.commission}  |  Balance ₹${b.totalBalance}",
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey,
                                fontFamily: "PoppinsMedium",
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// FACILITIES
                            if (b.facility.isNotEmpty)
                              Text(
                                b.facility,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey,
                                  fontFamily: "PoppinsMedium",
                                ),
                              ),

                            const SizedBox(height: 12),
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
class _LuxuryChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LuxuryChip(this.icon, this.text);

  String safe(String? v) {
    if (v == null) return "-";
    if (v.trim().isEmpty) return "-";
    if (v.toLowerCase() == "null") return "-";
    return v;
  }

  @override
  Widget build(BuildContext context) {
    final primary = const Color(0xFF6366F1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 15, color: primary.withOpacity(.9)),
          const SizedBox(width: 4),
          Text(
            safe(text),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: "PoppinsMedium",
            ),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// INFO ITEM
/// =======================
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.iconTheme.color),
        const SizedBox(width: 4),
        Text(text, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
