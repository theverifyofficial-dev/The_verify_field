import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Home_Screen_click/Commercial_property_Filter.dart';
import '../../Home_Screen_click/Filter_Options.dart';
import '../../ui_decoration_tools/constant.dart';
import 'Future_Property_Details.dart';
import 'See_All_Futureproperty.dart';
import 'package:intl/intl.dart';

class Catid {
  final int id;
  final String? images;
  final String? ownerName;
  final String? ownerNumber;
  final String? caretakerName;
  final String? caretakerNumber;
  final String? place;
  final String? buyRent;
  final String? typeOfProperty;
  final String? selectBhk;
  final String? floorNumber;
  final String? squareFeet;
  final String? propertyNameAddress;
  final String? buildingInformationFacilities;
  final String? propertyAddressForFieldworker;
  final String? ownerVehicleNumber;
  final String? yourAddress;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? currentDate;
  final String? longitude;
  final String? latitude;
  final String? roadSize;
  final String? metroDistance;
  final String? metroName;
  final String? mainMarketDistance;
  final String? ageOfProperty;
  final String? lift;
  final String? parking;
  final String? totalFloor;
  final String? residenceCommercial;
  final String? facility;

  Catid({
    required this.id,
    required this.images,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.typeOfProperty,
    required this.selectBhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.propertyNameAddress,
    required this.buildingInformationFacilities,
    required this.propertyAddressForFieldworker,
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
    required this.facility,
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['id'] ?? 0,
      images: json['images'],
      ownerName: json['ownername'],
      ownerNumber: json['ownernumber'],
      caretakerName: json['caretakername'],
      caretakerNumber: json['caretakernumber'],
      place: json['place'],
      buyRent: json['buy_rent'],
      typeOfProperty: json['typeofproperty'],
      selectBhk: json['select_bhk'],
      floorNumber: json['floor_number'],
      squareFeet: json['sqyare_feet'],
      propertyNameAddress: json['propertyname_address'],
      buildingInformationFacilities: json['building_information_facilitys'],
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'],
      ownerVehicleNumber: json['owner_vehical_number'],
      yourAddress: json['your_address'],
      fieldWorkerName: json['fieldworkarname'],
      fieldWorkerNumber: json['fieldworkarnumber'],
      currentDate: json['current_date_'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      metroName: json['metro_name'],
      mainMarketDistance: json['main_market_distance'],
      ageOfProperty: json['age_of_property'],
      lift: json['lift'],
      parking: json['parking'],
      totalFloor: json['total_floor'],
      residenceCommercial: json['Residence_commercial'],
      facility: json['facility'],
    );
  }
}

class ADministaterShow_FutureProperty extends StatefulWidget {
  final bool fromNotification;
  final String? buildingId;
  const ADministaterShow_FutureProperty({super.key, this.fromNotification = false, this.buildingId});

  @override
  State<ADministaterShow_FutureProperty> createState() => _ADministaterShow_FuturePropertyState();
}

class _ADministaterShow_FuturePropertyState extends State<ADministaterShow_FutureProperty> {

  final Map<String, GlobalKey> _cardKeys = {};
  final ScrollController _horizontalController = ScrollController();
  final ScrollController _verticalController = ScrollController();
  String _number = '';
  String? _highlightedBuildingId;
  bool _isLoading = true;
  bool _hasScrolled = false;

  Map<String, List<Catid>> _groupedData = {};
  final List<Map<String, String>> fieldWorkers = [
    {"name": "Sumit", "id": "9711775300"},
    {"name": "Ravi", "id": "9711275300"},
    {"name": "Faizan", "id": "9971172204"},
    {"name": "avjit", "id": "11"},
  ];

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Initialize empty grouped data with static headlines
    for (var fw in fieldWorkers) {
      _groupedData[fw['name']!] = [];
    }

    // Fetch API data after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAndUpdateData();
    });

    // Listen for notification opens
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // 1️⃣ Highlight the property from notification
      final buildingId = message.data['buildingId']; // make sure your payload has buildingId
      if (buildingId != null) {
        setState(() {
          _highlightedBuildingId = buildingId.toString();
        });

        // 2️⃣ Scroll to the highlighted property
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToHighlighted();
        });
      }

      // 3️⃣ Optionally, refresh your data
      _fetchAndUpdateData();
    });
  }


  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }

  Future<List<Catid>> _fetchDataByNumber(String number) async {
    final url = Uri.parse(
      "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=$number",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        debugPrint("📡 Raw response for $number: ${response.body}");

        if (response.body.isEmpty) {
          debugPrint("⚠️ Empty body for $number");
          return [];
        }

        dynamic decoded;
        try {
          decoded = json.decode(response.body);
        } catch (e) {
          debugPrint("❌ JSON decode error for $number: $e");
          return [];
        }

        if (decoded is List) {
          decoded.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
          return decoded.map((data) => Catid.fromJson(data)).toList();
        }

        if (decoded is Map<String, dynamic>) {
          final listData = decoded['data'] ?? decoded['Table'] ?? [];
          if (listData is List) {
            listData.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
            return listData.map((data) => Catid.fromJson(data)).toList();
          }
        }

        debugPrint("⚠️ Unexpected JSON structure for $number: $decoded");
        return [];
      } else {
        debugPrint("❌ HTTP error for $number: ${response.statusCode} ${response.reasonPhrase}");
        return [];
      }
    } catch (e, stack) {
      debugPrint("❌ Exception for $number: $e");
      debugPrint("$stack"); // full stacktrace
      return [];
    }
  }



  void _scrollToHighlighted() {
    if (_highlightedBuildingId == null) return;
    final key = _cardKeys[_highlightedBuildingId!];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        alignment: 0.2,
      );
    } else {
      Future.delayed(const Duration(milliseconds: 300), _scrollToHighlighted);
    }
  }

  Future<List<Catid>> _fetchDataWithRetry(String number, {int retries = 3}) async {
    for (int i = 0; i < retries; i++) {
      final data = await _fetchDataByNumber(number);
      if (data.isNotEmpty) return data;
      await Future.delayed(const Duration(seconds: 1)); // wait 1 second before retry
    }
    return []; // return empty if all retries fail
  }

  Future<void> _fetchAndUpdateData() async {
    setState(() => _isLoading = true);

    try {
      List<Catid> allProperties = [];
      for (var fw in fieldWorkers) {
        final props = await _fetchDataWithRetry(fw['id']!);
        allProperties.addAll(props);
      }

      Map<String, List<Catid>> grouped = {};
      for (var fw in fieldWorkers) {
        final workerProperties = allProperties
            .where((p) => (p.fieldWorkerNumber ?? '') == (fw['id'] ?? ''))
            .toList();
        grouped[fw['name'] ?? ''] = workerProperties;
      }

      setState(() {
        _groupedData = grouped;
      });

      // ✅ Call _scrollToHighlighted here
      if (_highlightedBuildingId == null && allProperties.isNotEmpty) {
        _highlightedBuildingId = allProperties.first.id.toString();
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToHighlighted());
      }

    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildChip(String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(isDarkMode ? 0.3 : 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildMiniChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
      child: Text(text, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 30),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: fieldWorkers.map((fw) {
            final props = _groupedData[fw['name']] ?? [];
            return _buildFieldWorkerSection(props, fw['id']!, fw['name']!);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildFieldWorkerSection(List<Catid> data, String workerId, String workerName) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Worker Header
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(workerName,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              GestureDetector(
                onTap: () => Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => SeeAll_FutureProperty(id: workerId))),
                child: const Text("See All", style: TextStyle(fontSize: 16, color: Colors.red)),
              ),
            ],
          ),
        ),

        // 🔹 If no properties found, show card
        if (data.isEmpty)
          Container(
            height: 150,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent, width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "No Properties Found",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.redAccent,
                ),
              ),
            ),
          )
        else
        // Horizontal List of Properties
          SizedBox(
            height: 520,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final property = data[index];
                final displayIndex = data.length - index;

                final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
                final textColor = isDarkMode ? Colors.white : Colors.black87;
                final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];
                final greenColor = isDarkMode ? Colors.green[300]! : Colors.green;
                final orangeColor = isDarkMode ? Colors.orange[300]! : Colors.orange;
                final blueColor = isDarkMode ? Colors.blue[300]! : Colors.blue;
                final purpleColor = isDarkMode ? Colors.purple[300]! : Colors.purple;

                return Container(
                  key: ValueKey("${workerId}_${property.id}"),
                  width: 340,
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: _highlightedBuildingId == property.id.toString() ? Colors.red : Colors.grey[300]!,
                        width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => Administater_Future_Property_details(idd: property.id.toString()),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Property Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                          child: CachedNetworkImage(
                            imageUrl:
                            "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.images}",
                            height: 220,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                                height: 220,
                                color: Colors.grey[200],
                                child: const Center(child: CircularProgressIndicator())),
                            errorWidget: (context, url, error) => Container(
                                height: 220,
                                color: Colors.grey[100],
                                child: Icon(Icons.broken_image, size: 60, color: Colors.grey[400])),
                          ),
                        ),

                        // Property Details (unchanged)
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: [
                                  if (property.typeOfProperty != null)
                                    _buildChip(property.typeOfProperty!, greenColor, isDarkMode),
                                  if (property.totalFloor != null)
                                    _buildChip("Total: ${property.totalFloor!}", orangeColor, isDarkMode),
                                  if (property.buyRent != null)
                                    _buildChip(property.buyRent!, blueColor, isDarkMode),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text("Owner Information",
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: secondaryTextColor)),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(property.ownerName ?? "",
                                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: textColor))),
                                  if (property.ownerNumber != null)
                                    InkWell(
                                      onTap: () => FlutterPhoneDirectCaller.callNumber(property.ownerNumber!),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                        decoration: BoxDecoration(
                                            color: blueColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12)),
                                        child: Row(
                                          children: [
                                            Icon(Icons.phone, size: 16, color: blueColor),
                                            const SizedBox(width: 4),
                                            Text(property.ownerNumber!,
                                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: blueColor)),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on_outlined, size: 18, color: secondaryTextColor),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      property.propertyAddressForFieldworker ?? "Address not available",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: textColor),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  if (property.place != null) _buildMiniChip(property.place!, blueColor),
                                  if (property.currentDate != null) ...[
                                    const SizedBox(width: 8),
                                    _buildMiniChip(property.currentDate!, purpleColor),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 14),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text("Property No: $displayIndex",
                                          style: TextStyle(fontSize: 13, color: secondaryTextColor))),
                                  Text("ID: ${property.id}",
                                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: textColor)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}
