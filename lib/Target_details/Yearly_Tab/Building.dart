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


Future<List<BuildingModel>> fetchBuildings() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/building_data_yearly.php?fieldworkarnumber=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Server Error");
  }

  final decoded = json.decode(res.body);
  List list = decoded['data'] ?? [];
  return list.map((e) => BuildingModel.fromJson(e)).toList();
}

class YearlyBuildingScreen extends StatefulWidget {
  const YearlyBuildingScreen({super.key});

  @override
  State<YearlyBuildingScreen> createState() => _YearlyBuildingScreenState();
}

class _YearlyBuildingScreenState extends State<YearlyBuildingScreen> {
  late Future<List<BuildingModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchBuildings();
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
                        builder: (_) => BuildingDetailScreen(building: b,),
                      ),
                    );
                  },
                  child:
                  Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: theme.brightness == Brightness.dark
                      ? []
                      : [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black.withOpacity(.08),
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// IMAGE
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${b.image}",
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 190,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// BUY / RENT TAG
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: b.buyRent == "Buy"
                                  ? Colors.green.withOpacity(.20)
                                  : Colors.blue.withOpacity(.20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              b.buyRent,
                              style: TextStyle(
                                color: b.buyRent == "Buy"
                                    ? Colors.green
                                    : Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// PROPERTY NAME
                          Text(
                            b.propertyName,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 4),

                          /// PLACE
                          Text(
                            b.place,
                            style: textTheme.bodySmall,
                          ),

                          const SizedBox(height: 10),

                          /// INFO ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoItem(Icons.train, b.metroName),
                              _InfoItem(Icons.apartment, b.totalFloor),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// FACILITY
                          Text(
                            b.facilities,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.bodySmall,
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
