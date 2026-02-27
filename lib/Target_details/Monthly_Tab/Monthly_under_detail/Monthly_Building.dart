import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../ui_decoration_tools/app_images.dart';
import 'BuildingMonthlyDetail.dart';

class MonthlyBuildingResponse {
  final bool status;
  final int total;
  final List<MonthlyBuilding> data;

  MonthlyBuildingResponse({
    required this.status,
    required this.total,
    required this.data,
  });

  factory MonthlyBuildingResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyBuildingResponse(
      status: json['status'] ?? false,
      total: json['total'] ?? 0,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => MonthlyBuilding.fromJson(e))
          .toList() ??
          [],
    );
  }
}
class MonthlyBuilding {
  final int id;
  final String image;
  final String place;
  final String buyRent;

  final String propertyName;
  final String propertyAddress;

  final String totalFloor;
  final String floor;
  final String bhk;
  final String squareFeet;
  final String ageOfProperty;

  final String residenceType;
  final String parking;
  final String lift;
  final String roadSize;

  final String metroDistance;
  final String metroName;
  final String marketDistance;

  final String facility;
  final String localityList;

  final String ownerName;
  final String ownerNumber;

  final String caretakerName;
  final String caretakerNumber;

  final String fieldWorkerName;
  final String fieldWorkerNumber;

  final String latitude;
  final String longitude;

  final String currentDate;

  MonthlyBuilding({
    required this.id,
    required this.image,
    required this.place,
    required this.buyRent,
    required this.propertyName,
    required this.propertyAddress,
    required this.totalFloor,
    required this.floor,
    required this.bhk,
    required this.squareFeet,
    required this.ageOfProperty,
    required this.residenceType,
    required this.parking,
    required this.lift,
    required this.roadSize,
    required this.metroDistance,
    required this.metroName,
    required this.marketDistance,
    required this.facility,
    required this.localityList,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.latitude,
    required this.longitude,
    required this.currentDate,
  });

  factory MonthlyBuilding.fromJson(Map<String, dynamic> json) {
    return MonthlyBuilding(
      id: json['id'] ?? 0,
      image: json['images'] ?? '',
      place: json['place'] ?? '',
      buyRent: json['buy_rent'] ?? '',

      propertyName: json['propertyname_address'] ?? '',
      propertyAddress: json['property_address_for_fieldworkar'] ?? '',

      totalFloor: json['total_floor'] ?? '',
      floor: json['floor_number'] ?? '',
      bhk: json['select_bhk'] ?? '',
      squareFeet: json['sqyare_feet'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',

      residenceType: json['Residence_commercial'] ?? '',
      parking: json['parking'] ?? '',
      lift: json['lift'] ?? '',
      roadSize: json['Road_Size'] ?? '',

      metroDistance: json['metro_distance'] ?? '',
      metroName: json['metro_name'] ?? '',
      marketDistance: json['main_market_distance'] ?? '',

      facility: json['facility'] ?? '',
      localityList: json['locality_list'] ?? '',

      ownerName: json['ownername'] ?? '',
      ownerNumber: (json['ownernumber'] ?? '').toString(),

      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: (json['caretakernumber'] ?? '').toString(),

      fieldWorkerName: json['fieldworkarname'] ?? '',
      fieldWorkerNumber: json['fieldworkarnumber'] ?? '',

      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',

      currentDate: json['current_date_'] ?? '',
    );
  }
}

Future<List<MonthlyBuilding>> fetchLiveMonthlyBuy(String number) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/"
        "Target_New_2026/builidng_monthly_data.php"
        "?fieldworkarnumber=$number",
  );

  final res = await http.get(url);

  debugPrint(res.body);

  if (res.statusCode != 200) {
    throw Exception("Monthly Building API Error");
  }

  final decoded = json.decode(res.body);
  final List list = decoded['data'] ?? [];

  return list.map((e) => MonthlyBuilding.fromJson(e)).toList();
}

/// ✅ SCREEN
class BuildingMonthlyListScreen extends StatefulWidget {
  final String? number;

  const BuildingMonthlyListScreen({
    super.key,
    this.number,
  });

  @override
  State<BuildingMonthlyListScreen> createState() =>
      _BuildingMonthlyListScreenState();
}

class _BuildingMonthlyListScreenState
    extends State<BuildingMonthlyListScreen> {
  late Future<List<MonthlyBuilding>> futureData;

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    String numberToUse;

    if (widget.number != null && widget.number!.isNotEmpty) {
      numberToUse = widget.number!;
    } else {
      final prefs = await SharedPreferences.getInstance();
      numberToUse = prefs.getString('number') ?? "";
    }

    if (numberToUse.isEmpty) {
      futureData = Future.error("Field Worker Number Missing");
    } else {
      futureData = fetchLiveMonthlyBuy(numberToUse);
    }

    if (mounted) setState(() {});
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
      body: FutureBuilder<List<MonthlyBuilding>>(
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
                      builder: (_) =>
                          BuildingMonthlyDetailScreen(p: b),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: theme.cardColor,
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

                      /// ================= IMAGE SECTION =================
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: Stack(
                          children: [

                            /// IMAGE
                            Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/"
                                  "new_future_property_api_with_multile_images_store/${b.image}",
                              height: 210,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                            /// 🔥 GRADIENT OVERLAY (Premium Depth)
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

                            /// ✅ BUY / RENT BADGE
                            Positioned(
                              top: 14,
                              left: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: b.buyRent == "Buy"
                                      ? Colors.green
                                      : Color(0xFFD747FF),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  b.buyRent.toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: "PoppinsBold",
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ),
                            ),

                            /// ✅ PROPERTY TYPE (Glass Badge 😏)
                            Positioned(
                              top: 14,
                              right: 14,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.35),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.white24),
                                ),
                                child: Text(
                                  b.residenceType,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontFamily: "PoppinsMedium",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),

                            /// 🔥 VISUAL HEADLINE
                            Positioned(
                              bottom: 18,
                              left: 18,
                              right: 18,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    b.propertyAddress,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.5,
                                      fontFamily: "PoppinsMedium",
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// ================= DETAILS SECTION =================
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// 📍 LOCATION
                            Text(
                              "${b.place} • ${b.localityList}",
                              style: TextStyle(
                                fontSize: 11.5,
                                fontFamily: "PoppinsMedium",
                                color: Colors.grey,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// 🔥 LUXURY CHIPS ROW
                            Row(
                              children: [
                                _LuxuryChip(Icons.layers_outlined, b.totalFloor),
                                const SizedBox(width: 8),
                                _LuxuryChip(Icons.train_outlined, b.metroDistance),
                                const SizedBox(width: 8),
                                _LuxuryChip(Icons.local_parking_outlined, b.parking),
                              ],
                            ),

                            const SizedBox(height: 10),

                            /// 👤 OWNER
                            Text(
                              "Owner: ${b.ownerName} (${b.ownerNumber.isEmpty ? '-' : b.ownerNumber})",
                              style: theme.textTheme.bodySmall,
                            ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),              );
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
    final safe = text.isEmpty ? "-" : text;

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
          Icon(icon, size: 16, color: Color(0xFFD747FF)),
          const SizedBox(width: 4),
          Text(
            safe,
            style: const TextStyle(
              fontSize: 11,
              fontFamily: "PoppinsMedium",
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
/// INFO WIDGET
class _ModernInfo extends StatelessWidget {
  final IconData icon;
  final String text;

  const _ModernInfo(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 6),
        Text(text.isEmpty ? "-" : text),
      ],
    );
  }
}