import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Target_Under_Details_/Building_Details.dart';

class BuildingModel {
  final int id;
  final String image;
  final String ownerName;
  final String ownerNumber;
  final String caretakerName;
  final String caretakerNumber;

  final String place;
  final String buyRent;
  final String typeOfProperty;
  final String bhk;
  final String floorNumber;
  final String squareFeet;
  final String propertyName;
  final String facilities;

  final String fieldWorkerAddress;
  final String ownerVehicleNumber;
  final String yourAddress;

  final String fieldWorkerName;
  final String fieldWorkerNumber;

  final String currentDate;
  final String longitude;
  final String latitude;

  final String roadSize;
  final String metroDistance;
  final String metroName;
  final String mainMarketDistance;
  final String ageOfProperty;
  final String lift;
  final String parking;
  final String totalFloor;
  final String residenceCommercial;
  final String localityList;

  BuildingModel({
    required this.id,
    required this.image,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.typeOfProperty,
    required this.bhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.propertyName,
    required this.facilities,
    required this.fieldWorkerAddress,
    required this.ownerVehicleNumber,
    required this.yourAddress,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.currentDate,
    required this.longitude,
    required this.latitude,
    required this.roadSize,
    required this.metroDistance,
    required this.metroName,
    required this.mainMarketDistance,
    required this.ageOfProperty,
    required this.lift,
    required this.parking,
    required this.totalFloor,
    required this.residenceCommercial,
    required this.localityList,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: int.tryParse(json['id'].toString()) ?? 0,
      image: json['images'] ?? '',
      ownerName: json['ownername'] ?? '',
      ownerNumber: json['ownernumber'] ?? '',
      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: json['caretakernumber'] ?? '',
      place: json['place'] ?? '',
      buyRent: json['buy_rent'] ?? '',
      typeOfProperty: json['typeofproperty'] ?? '',
      bhk: json['select_bhk'] ?? '',
      floorNumber: json['floor_number'] ?? '',
      squareFeet: json['sqyare_feet'] ?? '',
      propertyName: json['propertyname_address'] ?? '',
      facilities: json['facility'] ?? '',
      fieldWorkerAddress: json['property_address_for_fieldworkar'] ?? '',
      ownerVehicleNumber: json['owner_vehical_number'] ?? '',
      yourAddress: json['your_address'] ?? '',
      fieldWorkerName: json['fieldworkarname'] ?? '',
      fieldWorkerNumber: json['fieldworkarnumber'] ?? '',
      currentDate: json['current_date_'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      metroName: json['metro_name'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      lift: json['lift'] ?? '',
      parking: json['parking'] ?? '',
      totalFloor: json['total_floor'] ?? '',
      residenceCommercial: json['Residence_commercial'] ?? '',
      localityList: json['locality_list'] ?? '',
    );
  }
}


Future<List<BuildingModel>> fetchBuildings(String number) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/building_data_yearly.php?fieldworkarnumber=$number",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Server Error");
  }

  final decoded = json.decode(res.body);
  List list = decoded['data'] ?? [];
  return list.map((e) => BuildingModel.fromJson(e)).toList();
}

class YearlyBuilding extends StatefulWidget {
  final String number;
  const YearlyBuilding({super.key, required this.number});

  @override
  State<YearlyBuilding> createState() => _YearlyBuildingState();
}

class _YearlyBuildingState extends State<YearlyBuilding> {
  late Future<List<BuildingModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchBuildings(widget.number);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: FutureBuilder<List<BuildingModel>>(
        future: futureData,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return  Center(child: Image.asset(AppImages.loader,height: 40,));
          }

          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final list = snap.data ?? [];

          if (list.isEmpty) {
            return const Center(child: Text("No Buildings Found"));
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
                      builder: (_) => BuildingDetailScreen(building: b),
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

                            /// IMAGE
                            Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${b.image}",
                              height: 210,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                            /// GRADIENT
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

                            /// BUY / RENT BADGE
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: b.buyRent == "Buy"
                                      ? Colors.green
                                      : Color(0xFF22C55E),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  b.buyRent,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: "PoppinsMedium",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            /// VERIFIED ICON
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Icon(
                                  Icons.apartment,
                                  color: b.buyRent == "Buy"
                                      ? Colors.green
                                      : Color(0xFF22C55E),
                                  size: 18,
                                ),
                              ),
                            ),

                            /// VISUAL HEADLINE
                            Positioned(
                              bottom: 18,
                              left: 18,
                              right: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    b.typeOfProperty,
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
                                          "${b.place} • ${b.localityList}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                            color: Colors.white70,
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

                            /// FIELD WORKER
                            Row(
                              children: [
                                const Icon(Icons.person, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  b.fieldWorkerName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    fontFamily: "PoppinsMedium",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.call, size: 16, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  b.fieldWorkerNumber,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(
                                    fontFamily: "PoppinsMedium",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// TECHNICAL SNAPSHOT
                            Row(
                              children: [
                                _LuxuryChip(
                                    Icons.square_foot,
                                    b.squareFeet),
                                const SizedBox(width: 8),
                                _LuxuryChip(
                                    Icons.layers,
                                    b.totalFloor),
                                const SizedBox(width: 8),
                                _LuxuryChip(
                                    Icons.local_parking,
                                    b.parking),
                              ],
                            ),

                            const SizedBox(height: 10),

                            if (b.facilities.isNotEmpty)
                              Text(
                                b.facilities,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
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
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Color(0xFF22C55E)),
          const SizedBox(width: 4),
          Text(
            text.isEmpty ? "-" : text,
            style: Theme.of(context)
                .textTheme
                .labelSmall
                ?.copyWith(fontFamily: "PoppinsMedium"),
          ),
        ],
      ),
    );
  }
}

