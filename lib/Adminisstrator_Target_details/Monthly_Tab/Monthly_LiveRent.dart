import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import 'Monthly_under_detail/Monthly_LiveRent_detail.dart';

class MonthlyLiveRentModel {
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

  MonthlyLiveRentModel({
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

  factory MonthlyLiveRentModel.fromJson(Map<String, dynamic> json) {
    return MonthlyLiveRentModel(
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

/// =======================
/// API FETCH (RENT ONLY)
/// =======================
Future<List<MonthlyLiveRentModel>> fetchLiveMonthlyRent(String number) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/live_monthly_show.php?field_workar_number=$number",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Live Monthly API Error");
  }

  final decoded = json.decode(res.body);
  print(res.body);

  final List list = decoded['data'] ?? [];

  final rentOnly = list.where((e) => e['Buy_Rent'] == 'Rent').toList();

  return rentOnly.map((e) => MonthlyLiveRentModel.fromJson(e)).toList();
}

class MonthlyLiveRent extends StatefulWidget {
  final String number;
  const MonthlyLiveRent({super.key,required this.number});

  @override
  State<MonthlyLiveRent> createState() => _MonthlyLiveRentState();
}

class _MonthlyLiveRentState extends State<MonthlyLiveRent> {
  late Future<List<MonthlyLiveRentModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchLiveMonthlyRent(widget.number);
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
      body: FutureBuilder<List<MonthlyLiveRentModel>>(
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
            return const Center(child: Text("No Live Rent Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final b = list[i];

              return
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LiveMonthlyRentDetailScreen(b: b),
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
                                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.image}",
                                height: 210,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              /// Gradient
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

                              /// Property Type Badge
                              Positioned(
                                top: 14,
                                left: 14,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Color(0xFF22C55E).withOpacity(.85),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    b.residenceCommercial,
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontFamily: "PoppinsBold",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),

                              /// Verified Icon
                              Positioned(
                                top: 14,
                                right: 14,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: const Icon(
                                    Icons.verified,
                                    color: Color(0xFF22C55E),
                                    size: 18,
                                  ),
                                ),
                              ),

                              /// Title + Location
                              Positioned(
                                bottom: 18,
                                left: 18,
                                right: 18,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(
                                      b.furnishedUnfurnished,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontFamily: "PoppinsMedium",
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
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.white70,
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

                              /// Owner + Price
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        b.fieldWorkerName,
                                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "PoppinsMedium",
                                        ),
                                      ),
                                      Text(
                                      "(${b.fieldWorkerNumber})",
                                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "PoppinsMedium",
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "₹${b.showPrice}",
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "PoppinsMedium",

                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// Chips Row
                              Row(
                                children: [
                                  _LuxuryChip(Icons.square_foot, b.squareFit),
                                  const SizedBox(width: 8),
                                  _LuxuryChip(Icons.layers, "${b.floor}"),
                                  const SizedBox(width: 8),
                                  _LuxuryChip(Icons.local_parking, b.parking),
                                ],
                              ),

                              const SizedBox(height: 10),

                              /// Dynamic Facilities / Amenities
                              if (b.facility.isNotEmpty)
                                Text(
                                  b.facility,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness==Brightness.dark?Colors.grey.shade800:Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFF22C55E)),
          const SizedBox(width: 4),
          Text(
            text,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontFamily: "PoppinsMedium",

            ),
          ),
        ],
      ),
    );
  }
}

