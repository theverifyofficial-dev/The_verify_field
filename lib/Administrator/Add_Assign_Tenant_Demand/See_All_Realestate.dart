import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../Administater_Realestate_Details.dart';
import 'package:intl/intl.dart';

class Catid {
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
  final String squareFit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldWorkerAddress;
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
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final int subid;
  final String? sourceId; // NEW, nullable

  const Catid({
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
    required this.squareFit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldWorkerAddress,
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
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
    this.sourceId, // NEW

  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['P_id'] is int
          ? json['P_id']
          : int.tryParse(json['P_id']?.toString() ?? '0') ?? 0,
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
      maintance: json['maintance']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      fieldWorkerAddress: json['fieldworkar_address']?.toString() ?? '',
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
      fieldWorkerCurrentLocation:
      json['field_worker_current_location']?.toString() ?? '',
      careTakerName: json['care_taker_name']?.toString() ?? '',
      careTakerNumber: json['care_taker_number']?.toString() ?? '',
      sourceId: json['source_id']?.toString(), // NEW

      subid: json['subid'] is int
          ? json['subid']
          : int.tryParse(json['subid']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "P_id": id,
      "property_photo": propertyPhoto,
      "locations": locations,
      "Flat_number": flatNumber,
      "Buy_Rent": buyRent,
      "Residence_Commercial": residenceCommercial,
      "Apartment_name": apartmentName,
      "Apartment_Address": apartmentAddress,
      "Typeofproperty": typeOfProperty,
      "Bhk": bhk,
      "show_Price": showPrice,
      "Last_Price": lastPrice,
      "asking_price": askingPrice,
      "Floor_": floor,
      "Total_floor": totalFloor,
      "Balcony": balcony,
      "squarefit": squareFit,
      "maintance": maintance,
      "parking": parking,
      "age_of_property": ageOfProperty,
      "fieldworkar_address": fieldWorkerAddress,
      "Road_Size": roadSize,
      "metro_distance": metroDistance,
      "highway_distance": highwayDistance,
      "main_market_distance": mainMarketDistance,
      "meter": meter,
      "owner_name": ownerName,
      "owner_number": ownerNumber,
      "current_dates": currentDates,
      "available_date": availableDate,
      "kitchen": kitchen,
      "bathroom": bathroom,
      "lift": lift,
      "Facility": facility,
      "furnished_unfurnished": furnishedUnfurnished,
      "field_warkar_name": fieldWorkerName,
      "live_unlive": liveUnlive,
      "field_workar_number": fieldWorkerNumber,
      "registry_and_gpa": registryAndGpa,
      "loan": loan,
      "Longitude": longitude,
      "Latitude": latitude,
      "video_link": videoLink,
      "field_worker_current_location": fieldWorkerCurrentLocation,
      "care_taker_name": careTakerName,
      "care_taker_number": careTakerNumber,
      "subid": subid,
    };
  }
}

class See_All_Realestate extends StatefulWidget {
  String id;
  See_All_Realestate({super.key, required this.id});

  @override
  State<See_All_Realestate> createState() => _See_All_RealestateState();
}

class _See_All_RealestateState extends State<See_All_Realestate> {

  Future<void> _loadData() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
            "?field_workar_number=${widget.id}&live_unlive=Live",
      );

      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        debugPrint("HTTP ${resp.statusCode}: ${resp.body}");
        return;
      }

      final decoded = json.decode(resp.body);

      // --- unwrap payloads: {success,data} or .asmx {"d":"[...]"}
      dynamic payload;
      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        payload = decoded['data'];
      } else if (decoded is Map<String, dynamic> && decoded.containsKey('d')) {
        final d = decoded['d'];
        try {
          payload = d is String ? json.decode(d) : d;
        } catch (_) {
          payload = d;
        }
      } else {
        payload = decoded;
      }

      // --- normalize to List<Map<String,dynamic>>
      List<Map<String, dynamic>> list;
      if (payload is List) {
        list = payload.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else if (payload is Map) {
        list = [Map<String, dynamic>.from(payload)];
      } else {
        list = const [];
      }

      // --- newest first by P_id (even if it comes as string)
      int asInt(dynamic v) => v is int ? v : (int.tryParse(v?.toString() ?? '') ?? 0);
      list.sort((a, b) => asInt(b['P_id']).compareTo(asInt(a['P_id'])));

      final items = list.map((m) => Catid.fromJson(m)).toList();

      if (!mounted) return;
      setState(() {
        _allData = items;
        _filteredData = List<Catid>.from(_allData);
      });
    } catch (e) {
      debugPrint("fetchData error: $e");
    }
  }
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "-";
    try {
      DateTime date = DateTime.parse(dateString); // expects yyyy-MM-dd or full ISO format
      return DateFormat('dd/MMM/yyyy').format(date); // Example: 29-08-2025
    } catch (e) {
      return dateString; // fallback if parsing fails
    }
  }
  TextEditingController _searchController = TextEditingController();
  List<Catid> _allData = [];   // full fetched data
  List<Catid> _filteredData = []; // filtered list
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  void _searchData(String query) {
    final input = query.toLowerCase();

    final results = _allData.where((item) {
      // Convert whole object into a big searchable string
      final combined = [
        item.id.toString(),
        item.propertyPhoto,
        item.locations,
        item.flatNumber,
        item.buyRent,
        item.residenceCommercial,
        item.apartmentName,
        item.apartmentAddress,
        item.typeOfProperty,
        item.bhk,
        item.showPrice,
        item.lastPrice,
        item.askingPrice,
        item.floor,
        item.totalFloor,
        item.balcony,
        item.squareFit,
        item.maintance,
        item.parking,
        item.ageOfProperty,
        item.fieldWorkerAddress,
        item.roadSize,
        item.metroDistance,
        item.highwayDistance,
        item.mainMarketDistance,
        item.meter,
        item.ownerName,
        item.ownerNumber,
        item.currentDates,
        item.availableDate,
        item.kitchen,
        item.bathroom,
        item.lift,
        item.facility,
        item.furnishedUnfurnished,
        item.fieldWorkerName,
        item.liveUnlive,
        item.fieldWorkerNumber,
        item.registryAndGpa,
        item.loan,
        item.longitude,
        item.latitude,
        item.videoLink,
        item.fieldWorkerCurrentLocation,
        item.careTakerName,
        item.careTakerNumber,
        item.subid.toString(),
      ].join(" ").toLowerCase();

      return combined.contains(input);
    }).toList();

    setState(() {
      _filteredData = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        // actions:  [
        //   GestureDetector(
        //     onTap: () {
        //       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
        //     },
        //     child: const Icon(
        //       PhosphorIcons.image,
        //       color: Colors.black,
        //       size: 30,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search property...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _searchData, // call search on typing
            ),
          ),
          if (_searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Results found: ${_filteredData.length}",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),

          // Now ListView.builder will use _filteredData
          Expanded(
            child: ListView.builder(

              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[index];
                int displayIndex = _filteredData.length - index;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Administater_View_Details(idd: '${item.id}'),
                      ),
                    );
                  },
                  child: Container(
                    width: 320,
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: Theme.of(context).brightness == Brightness.dark
                          ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.6),
                          blurRadius: 20,
                          offset: const Offset(0, 6),
                          spreadRadius: 1,
                        ),
                      ]
                          : [
                        BoxShadow(
                          color: Colors.blueGrey.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Image with subtle overlay
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              child: Container(
                                height: 300,
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.propertyPhoto}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[800]
                                        : Colors.grey[50],
                                    child: Center(
                                      child: Image.asset(
                                        AppImages.loading,
                                        width: 40,
                                        height: 40,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.blueGrey[200],
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, error, stack) => Container(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey[800]
                                        : Colors.grey[50],
                                    child: Center(
                                      child: Image.asset(
                                        AppImages.imageNotFound,
                                        width: 40,
                                        height: 40,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[400]
                                            : Colors.blueGrey[200],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Property Details
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Property Type, Buy/Rent, BHK
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  _buildFeatureChip(
                                    context: context,
                                    text: item.typeOfProperty.toUpperCase(),
                                    color: Colors.blue,
                                    icon: Icons.apartment,
                                  ),
                                  _buildFeatureChip(
                                    context: context,
                                    text: item.buyRent.toUpperCase(),
                                    color: Colors.teal,
                                    icon: Icons.swap_horiz,
                                  ),
                                  _buildFeatureChip(
                                    context: context,
                                    text: item.bhk.toUpperCase(),
                                    color: Colors.orange,
                                    icon: Icons.hotel,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Location and Floor
                              Row(
                                children: [
                                  _buildInfoItem(
                                    context: context,
                                    icon: Icons.location_on,
                                    value: item.locations,
                                    color: Colors.orangeAccent,
                                  ),
                                  const SizedBox(width: 12),
                                  _buildInfoItem(
                                    context: context,
                                    icon: Icons.stairs,
                                    value: item.floor,
                                    color: Colors.redAccent,
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Property Address
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.location_city_rounded,
                                    size: 20,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.blue[300]
                                        : Colors.blue[600],
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      item.apartmentAddress,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13,
                                        color: Theme.of(context).brightness == Brightness.dark
                                            ? Colors.grey[300]
                                            : Colors.blueGrey,
                                        fontWeight: FontWeight.w500,
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Available Date and Price
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _buildInfoItem(
                                    context: context,
                                    icon: Icons.calendar_today,
                                    value:  _formatDate(item.availableDate),
                                    color: Colors.cyan,
                                  ),

                                  Text(
                                    "₹ ${item.showPrice}",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.green[300]
                                          : Colors.green[700],
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Property ID and Index
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey[800]
                                      : Colors.grey[50],
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade100,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildIdBadge(
                                      context: context,
                                      label: "TOTAL ID #",
                                      value: displayIndex.toString(),
                                    ),
                                    Container(
                                      width: 1,
                                      height: 20,
                                      color: Theme.of(context).brightness == Brightness.dark
                                          ? Colors.grey[600]
                                          : Colors.grey[200],
                                    ),
                                    _buildIdBadge(
                                      context: context,
                                      label: "PROPERTY ID #",
                                      value: item.id.toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );            },
            ),
          ),
        ],
      )


    );
  }


// Helper widget for feature chips
  Widget _buildFeatureChip({
    required BuildContext context,
    required String text,
    required Color color,
    required IconData icon,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color getAdaptiveColor(Color lightColor, Color darkColor) {
      return isDarkMode ? darkColor : lightColor;
    }

    final adaptiveColor = color is MaterialColor
        ? getAdaptiveColor(color[600]!, color[300]!)
        : getAdaptiveColor(color, color.withOpacity(0.8));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: adaptiveColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: adaptiveColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: adaptiveColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: adaptiveColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for info items
  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color getAdaptiveColor(Color lightColor, Color darkColor) {
      return isDarkMode ? darkColor : lightColor;
    }

    final adaptiveColor = color is MaterialColor
        ? getAdaptiveColor(color[300]!, color[300]!)
        : getAdaptiveColor(color, color.withOpacity(0.9));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: adaptiveColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: adaptiveColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: adaptiveColor,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: adaptiveColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for ID badges
  Widget _buildIdBadge({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;
    final textColor = isDarkMode ? Colors.grey[300]! : Colors.grey[800]!;
    final labelColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 15,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
