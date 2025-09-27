import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/constant.dart';
import 'Add_futureProperty.dart';
import 'Future_property_details.dart';
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

  factory Catid.FromJson(Map<String, dynamic> json) {
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

class FrontPage_FutureProperty extends StatefulWidget {
  const FrontPage_FutureProperty({super.key});

  @override
  State<FrontPage_FutureProperty> createState() => _FrontPage_FuturePropertyState();
}

class _FrontPage_FuturePropertyState extends State<FrontPage_FutureProperty> {

  String _number = '';
  String _SUbid = '';

  List<Catid> _allProperties = [];
  List<Catid> _filteredProperties = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String selectedLabel = '';
  int propertyCount = 0;
  int? totalFlats;
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    _loaduserdata().then((_) {
      _fetchAndFilterProperties().then((_) {
        setState(() {
          fetchFlatsStatus();
          fetchTotalFlats();
          _filteredProperties = _allProperties;
          propertyCount = _allProperties.length; // ✅ set count after data is ready
        });
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();

      List<Catid> filtered;

      if (query.isEmpty) {
        filtered = List.from(_allProperties);
        selectedLabel = ''; // optional reset
      } else if (query == "Missing Field") {
        // ✅ Show items if ANY field is null or empty (except ignored fields)
        filtered = _allProperties.where((item) {
          return (item.images == null || item.images!.trim().isEmpty) ||
              (item.ownerName == null || item.ownerName!.trim().isEmpty) ||
              (item.ownerNumber == null || item.ownerNumber!.trim().isEmpty) ||
              (item.caretakerName == null || item.caretakerName!.trim().isEmpty) ||
              (item.caretakerNumber == null || item.caretakerNumber!.trim().isEmpty) ||
              (item.place == null || item.place!.trim().isEmpty) ||
              (item.buyRent == null || item.buyRent!.trim().isEmpty) ||
              // ❌ removed typeOfProperty, selectBhk, floorNumber, squareFeet, buildingInformationFacilities
              (item.propertyNameAddress == null || item.propertyNameAddress!.trim().isEmpty) ||
              (item.propertyAddressForFieldworker == null || item.propertyAddressForFieldworker!.trim().isEmpty) ||
              (item.ownerVehicleNumber == null || item.ownerVehicleNumber!.trim().isEmpty) ||
              (item.yourAddress == null || item.yourAddress!.trim().isEmpty) ||
              (item.fieldWorkerName == null || item.fieldWorkerName!.trim().isEmpty) ||
              (item.fieldWorkerNumber == null || item.fieldWorkerNumber!.trim().isEmpty) ||
              (item.currentDate == null || item.currentDate!.trim().isEmpty) ||
              (item.longitude == null || item.longitude!.trim().isEmpty) ||
              (item.latitude == null || item.latitude!.trim().isEmpty) ||
              (item.roadSize == null || item.roadSize!.trim().isEmpty) ||
              (item.metroDistance == null || item.metroDistance!.trim().isEmpty) ||
              (item.metroName == null || item.metroName!.trim().isEmpty) ||
              (item.mainMarketDistance == null || item.mainMarketDistance!.trim().isEmpty) ||
              (item.ageOfProperty == null || item.ageOfProperty!.trim().isEmpty) ||
              (item.lift == null || item.lift!.trim().isEmpty) ||
              (item.parking == null || item.parking!.trim().isEmpty) ||
              (item.totalFloor == null || item.totalFloor!.trim().isEmpty) ||
              (item.residenceCommercial == null || item.residenceCommercial!.trim().isEmpty) ||
              (item.facility == null || item.facility!.trim().isEmpty);
        }).toList();
      } else {
        // 🔍 Normal search
        filtered = _allProperties.where((item) {
          return (item.id.toString()).toLowerCase().contains(query) ||
              (item.ownerName ?? '').toLowerCase().contains(query) ||
              (item.caretakerName ?? '').toLowerCase().contains(query) ||
              (item.place ?? '').toLowerCase().contains(query) ||
              (item.buyRent ?? '').toLowerCase().contains(query) ||
              (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
              (item.selectBhk ?? '').toLowerCase().contains(query) ||
              (item.floorNumber ?? '').toLowerCase().contains(query) ||
              (item.squareFeet ?? '').toLowerCase().contains(query) ||
              (item.propertyNameAddress ?? '').toLowerCase().contains(query) ||
              (item.buildingInformationFacilities ?? '').toLowerCase().contains(query) ||
              (item.propertyAddressForFieldworker ?? '').toLowerCase().contains(query) ||
              (item.ownerVehicleNumber ?? '').toLowerCase().contains(query) ||
              (item.yourAddress ?? '').toLowerCase().contains(query) ||
              (item.fieldWorkerName ?? '').toLowerCase().contains(query) ||
              (item.fieldWorkerNumber ?? '').toLowerCase().contains(query) ||
              (item.currentDate ?? '').toLowerCase().contains(query) ||
              (item.longitude ?? '').toLowerCase().contains(query) ||
              (item.latitude ?? '').toLowerCase().contains(query) ||
              (item.roadSize ?? '').toLowerCase().contains(query) ||
              (item.metroDistance ?? '').toLowerCase().contains(query) ||
              (item.metroName ?? '').toLowerCase().contains(query) ||
              (item.mainMarketDistance ?? '').toLowerCase().contains(query) ||
              (item.ageOfProperty ?? '').toLowerCase().contains(query) ||
              (item.lift ?? '').toLowerCase().contains(query) ||
              (item.parking ?? '').toLowerCase().contains(query) ||
              (item.totalFloor ?? '').toLowerCase().contains(query) ||
              (item.residenceCommercial ?? '').toLowerCase().contains(query) ||
              (item.facility ?? '').toLowerCase().contains(query);
        }).toList();
      }

      setState(() {
        _filteredProperties = filtered;
        propertyCount = filtered.length;
      });
    });
  }


  Future<Map<String, dynamic>> fetchPropertyStatus(int subid) async {
    try {

      final response1 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/check_live_flat_in_main_realesate?subid=$subid&live_unlive=Flat"));

      final response2 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=$subid"));


      String loggValue1 = "Loading...";
      String loggValue2 = "Loading...";
      Color statusColor = Colors.grey;

      if (response1.statusCode == 200) {
        final body = jsonDecode(response1.body);
        if (body is List && body.isNotEmpty) {
          final logg = body[0]['logg'];
          loggValue1 = logg.toString();
          statusColor = (logg == 0) ? Colors.red : Colors.green;
        }
      }

      if (response2.statusCode == 200) {
        final body = jsonDecode(response2.body);
        if (body is List && body.isNotEmpty) {
          final logg = body[0]['logg'];
          loggValue2 = logg.toString();
        }
      }

      return {
        "loggValue1": loggValue1,   // from first API
        "loggValue2": loggValue2,   // from second API
        "statusColor": statusColor,
      };
    } catch (e) {
      return {
        "loggValue1": "Error",
        "loggValue2": "Error",
        "statusColor": Colors.grey,
      };
    }
  }

  Future<void> _fetchAndFilterProperties() async {
    setState(() {
      _isLoading = true;
    });

    print("FIELDWORKER NUMBER: $_number");

    try {
      var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=$_number",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("API Response Body: ${response.body}");

        List<dynamic> listResponse = json.decode(response.body);

        listResponse.sort((a, b) => b['id'].compareTo(a['id']));

        _allProperties = listResponse
            .map((data) => Catid.FromJson(data))
            .toList();

        _filteredProperties = _allProperties; // show all initially

        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || selectedLabel.isNotEmpty;
  }
  Future<void> _refreshProperties() async {
    await _fetchAndFilterProperties();
    await fetchTotalFlats();
    await fetchFlatsStatus();
  }
  int bookFlats = 0;
  int liveFlats = 0;

  Future<void> fetchFlatsStatus() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=${_number}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        int book = 0;
        int live = 0;

        for (var item in data) {
          if (item['live_unlive'] == "Book") {
            book = item['subid'] ?? 0;
          } else if (item['live_unlive'] == "Live") {
            live = item['subid'] ?? 0;
          }
        }

        setState(() {
          bookFlats = book;
          liveFlats = live;
          isLoading = false;
        });
      } else {
        setState(() {
          bookFlats = 0;
          liveFlats = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching flats status: $e");
      setState(() {
        bookFlats = 0;
        liveFlats = 0;
        isLoading = false;
      });
    }
  }


  Future<void> fetchTotalFlats() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=${_number}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // API returns a list, take the first element's subid
        final subid = data.isNotEmpty ? data[0]['subid'] : 0;

        setState(() {
          totalFlats = subid;
          isLoading = false;
        });
      } else {
        setState(() {
          totalFlats = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        totalFlats = 0;
        isLoading = false;
      });
      print("Error fetching total flats: $e");
    }
  }
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return RefreshIndicator(
      onRefresh: _refreshProperties,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.black,
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
        ),

        body: _isLoading
            ?  Center(child: Lottie.asset(AppImages.loadingHand, height: 400),)
            : Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.grey[100]!, Colors.grey[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search properties...',
                          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.search_rounded, color: Colors.grey.shade700, size: 24),
                          ),
                          suffixIcon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _searchController.text.isNotEmpty
                                ? IconButton(
                              key: const ValueKey('clear'),
                              icon: Icon(Icons.close_rounded, color: Colors.grey.shade700, size: 22),
                              onPressed: () {
                                _searchController.clear();
                                selectedLabel = '';
                                _filteredProperties = _allProperties;
                                propertyCount = 0;
                                FocusScope.of(context).unfocus();
                                setState(() {});
                              },
                            )
                                : const SizedBox(key: ValueKey('empty')),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.3), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.8), width: 1.5),
                          ),
                        ),
                        onChanged: (value) {
                          _onSearchChanged();
                          setState(() {});
                        },
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ['Rent', 'Sell', 'Commercial', 'Missing Field'].map((label) {
                        final isSelected = label == selectedLabel;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                selectedLabel = label;

                                if (label == 'Missing Field') {
                                  // Don’t set text, just trigger filter directly
                                  _searchController.clear();
                                  _onSearchChanged(); // will run with query.isEmpty, but you can call your missing field filter directly too
                                  _debounce?.cancel();
                                  // run missing field filter manually
                                  final filtered = _allProperties.where((item) {
                                    return (item.images == null || item.images!.trim().isEmpty) ||
                                        (item.ownerName == null || item.ownerName!.trim().isEmpty) ||
                                        (item.ownerNumber == null || item.ownerNumber!.trim().isEmpty) ||
                                        (item.caretakerName == null || item.caretakerName!.trim().isEmpty) ||
                                        (item.caretakerNumber == null || item.caretakerNumber!.trim().isEmpty) ||
                                        (item.place == null || item.place!.trim().isEmpty) ||
                                        (item.buyRent == null || item.buyRent!.trim().isEmpty) ||
                                        (item.propertyNameAddress == null || item.propertyNameAddress!.trim().isEmpty) ||
                                        (item.propertyAddressForFieldworker == null || item.propertyAddressForFieldworker!.trim().isEmpty) ||
                                        (item.ownerVehicleNumber == null || item.ownerVehicleNumber!.trim().isEmpty) ||
                                        (item.yourAddress == null || item.yourAddress!.trim().isEmpty) ||
                                        (item.fieldWorkerName == null || item.fieldWorkerName!.trim().isEmpty) ||
                                        (item.fieldWorkerNumber == null || item.fieldWorkerNumber!.trim().isEmpty) ||
                                        (item.currentDate == null || item.currentDate!.trim().isEmpty) ||
                                        (item.longitude == null || item.longitude!.trim().isEmpty) ||
                                        (item.latitude == null || item.latitude!.trim().isEmpty) ||
                                        (item.roadSize == null || item.roadSize!.trim().isEmpty) ||
                                        (item.metroDistance == null || item.metroDistance!.trim().isEmpty) ||
                                        (item.metroName == null || item.metroName!.trim().isEmpty) ||
                                        (item.mainMarketDistance == null || item.mainMarketDistance!.trim().isEmpty) ||
                                        (item.ageOfProperty == null || item.ageOfProperty!.trim().isEmpty) ||
                                        (item.lift == null || item.lift!.trim().isEmpty) ||
                                        (item.parking == null || item.parking!.trim().isEmpty) ||
                                        (item.totalFloor == null || item.totalFloor!.trim().isEmpty) ||
                                        (item.residenceCommercial == null || item.residenceCommercial!.trim().isEmpty) ||
                                        (item.facility == null || item.facility!.trim().isEmpty);
                                  }).toList();

                                  _filteredProperties = filtered;
                                  propertyCount = filtered.length;
                                } else {
                                  // Normal behavior → put label in search box
                                  _searchController.text = label;
                                  _onSearchChanged();
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (propertyCount > 0) // ✅ remove `_isSearchActive` condition
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              "$propertyCount building found",
                              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  selectedLabel = '';
                                  _filteredProperties = _allProperties;
                                  propertyCount = _allProperties.length; // ✅ reset to total
                                });
                              },
                              child: const Icon(Icons.close, size: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                          const SizedBox(width: 6),
                            isLoading
                        ˙
                          const SizedBox(width: 6),

                          isLoading
                          ? Text("")
                          : Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                              children: [
                                // Live Flats Container
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Live Flats: $liveFlats",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 6),
                                // Book Flats Container
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        "Rent Out: $bookFlats",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14),
                                      ),
                                    ],
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
            // No results message
            if (_filteredProperties.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "No properties found",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Try a different search term",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _filteredProperties.length,
                  itemBuilder: (context, index) {
                    final property = _filteredProperties[index];
                    final displayIndex = _filteredProperties.length - index; // ✅ reverse order
                    String loggValue = "Loading...";
                    return FutureBuilder<Map<String, dynamic>>(
                      future: fetchPropertyStatus(property.id),  // ✅ use combined future
                      builder: (context, snapshot) {
                        String logg1 = "Loading...";
                        String logg2 = "Loading...";
                        Color statusColor = Colors.grey;

                        if (snapshot.hasData) {
                          logg1 = snapshot.data!['loggValue1'];
                          logg2 = snapshot.data!['loggValue2'];
                          statusColor = snapshot.data!['statusColor'];
                        } else if (snapshot.hasError) {
                          logg1 = "Error";
                          logg2 = "Error";
                          statusColor = Colors.grey;
                        }

                        return
                          PropertyCard(
                          displayIndex: displayIndex,   // ✅ pass here
                          property: property,
                          statusText: logg2,     // ✅ pass status text
                          statusColor: statusColor,
                            Live_Unlive: logg1,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Future_Property_details(
                                  idd: property.id.toString(),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Add_FutureProperty()),
            );
          },
          icon: const Icon(Icons.add),
          label: const Text("Add Building"),
          backgroundColor: Colors.blue, // Or your primary color
          elevation: 4,
        ),
      ),
    );
  }

  Future<void> _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
      _SUbid = prefs.getString('id_future') ?? '';
    });
  }
}
class PropertyCard extends StatelessWidget {
  final dynamic property;
  final String statusText;
  final String Live_Unlive;
  final Color statusColor;
  final VoidCallback onTap;
  final int displayIndex;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.statusText,
    required this.Live_Unlive,
    required this.statusColor,
    required this.onTap,
    required this.displayIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Utility check
    bool _isNullOrEmpty(String? value) =>
        value == null || value.trim().isEmpty;

    // Map all Catid fields with readable labels
    final Map<String, dynamic> fields = {
      "Images": property.images,
      "Owner Name": property.ownerName,
      "Owner Number": property.ownerNumber,
      "Caretaker Name": property.caretakerName,
      "Caretaker Number": property.caretakerNumber,
      "Place": property.place,
      "Buy/Rent": property.buyRent,
      "Property Name/Address": property.propertyNameAddress,
      "Property Address (Fieldworker)": property.propertyAddressForFieldworker,
      "Owner Vehicle Number": property.ownerVehicleNumber,
      "Your Address": property.yourAddress,
      "Field Worker Name": property.fieldWorkerName,
      "Field Worker Number": property.fieldWorkerNumber,
      "Current Date": property.currentDate,
      "Longitude": property.longitude,
      "Latitude": property.latitude,
      "Road Size": property.roadSize,
      "Metro Distance": property.metroDistance,
      "Metro Name": property.metroName,
      "Main Market Distance": property.mainMarketDistance,
      "Age of Property": property.ageOfProperty,
      "Lift": property.lift,
      "Parking": property.parking,
      "Total Floor": property.totalFloor,
      "Residence/Commercial": property.residenceCommercial,
      "Facility": property.facility,
    };

    // Check for missing fields
    final missingFields = fields.entries
        .where((entry) {
      final value = entry.value;
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      return false;
    })
        .map((entry) => entry.key)
        .toList();

    final hasMissingFields = missingFields.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      elevation: 5,
      shadowColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image with overlay + badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl:
                    "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.images}",
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Image.asset(AppImages.loader, height: 50),
                    ),
                    errorWidget: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey[300],
                    ),
                  ),
                ),

                Positioned(
                  top: 16,
                  right: 16,
                  child: FutureBuilder(
                    future: http.get(Uri.parse(
                        'https://verifyserve.social/WebService4.asmx/count_api_for_live_unlive_flat_under_building?subid=${property.id}')),
                    builder: (context, snapshot) {
                      int liveCount = 0;
                      int unliveCount = 0;

                      if (snapshot.hasData) {
                        final data = jsonDecode(snapshot.data!.body);

                        for (var item in data) {
                          if (item['live_unlive'] == 'Live') {
                            liveCount += (item['logs'] as num).toInt();
                          } else if (item['live_unlive'] == 'Book') {
                            unliveCount = 0; // Book always shows unlive: 0
                          } else {
                            unliveCount += (item['logs'] as num).toInt();
                          }
                        }
                      }

                      // Decide which to show
                      bool isLive = liveCount > 0;

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isLive ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          isLive ? "Live: $liveCount" : "Unlive: $unliveCount",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                )

              ],
            ),

            // 🔹 Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        child: _buildInfoChip(
                          context: context,
                          text: property.place,
                          backgroundColor: isDark ? Colors.green.withOpacity(0.2) : Colors.green.shade50,
                          textColor: isDark ? Colors.white : Colors.green.shade800,
                          borderColor: Colors.green,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        fit: FlexFit.tight,
                        child: _buildInfoChip(
                          context: context,
                          text: property.residenceCommercial,
                          backgroundColor: isDark ? Colors.blue.withOpacity(0.2) : Colors.blue.shade50,
                          textColor: isDark ? Colors.blue.shade200 : Colors.blue.shade800,
                          borderColor: Colors.blue,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        fit: FlexFit.tight,
                        child: _buildInfoChip(
                          context: context,
                          text: property.buyRent,
                          backgroundColor: isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.shade50,
                          textColor: isDark ? Colors.orange.shade200 : Colors.orange.shade800,
                          borderColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Address
                  Text(
                    "Field Worker Address",
                    style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.propertyAddressForFieldworker,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      height: 1.3,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _buildCompactDetailItem( "🏠 Building ID ","${property.id}",context),
                      _buildCompactDetailItem( "  +  Total Flat ",statusText,context),
                    ],
                  ),

                   const SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Added: ${(() {
                            final s = property.currentDate?.toString() ?? '';
                            if (s.isEmpty) return '-';
                            try {
                    
                              final dt = DateFormat('yyyy-MM-dd hh:mm a').parse(s);
                              return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
                            } catch (_) {
                              try {
                                final dt2 = DateTime.parse(s);
                                return DateFormat('dd MMM yyyy, hh:mm a').format(dt2);
                              } catch (_) {
                                return s;
                              }
                            }
                          })()}",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                          ),
                        ),
                        Text(
                          "Count No : $displayIndex",
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Poppins",
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 10),

                  // ⚠ Missing fields
                  if (hasMissingFields)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent, width: 1),
                      ),
                      child: Text(
                        "⚠ Missing fields: ${missingFields.join(", ")}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
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

}
Widget _buildCompactDetailItem(String title, String value,BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // more space
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black87,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      children: [
        Text(
          "$title: ",
          style: TextStyle(
            fontSize: 14, // bigger text
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color:
              Theme.of(context).brightness==Brightness.dark?
              Colors.black:
              Colors.white,
              // shadows: [
              //   Shadow(
              //     blurRadius: 1,
              //     // offset: Offset(2, 2),
              //     color: Theme.of(context).brightness == Brightness.dark
              //         ? Colors.amber
              //         : Colors.black87,
              //   )
              // ],
              fontSize: 15, // bigger text
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoChip({
  required String text,
  required Color borderColor,
  required BuildContext context,
  Color? backgroundColor,
  Color? textColor,
  Color? shadowColor,
}) {
  final width = MediaQuery.of(context).size.width;

  // Scale text & padding relative to screen width
  double fontSize = width < 350 ? 10 : (width < 500 ? 12 : 14);
  double horizontalPadding = width < 350 ? 8 : (width < 500 ? 12 : 14);
  double verticalPadding = width < 350 ? 6 : (width < 500 ? 8 : 12);

  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ),
    margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.transparent,
      border: Border.all(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? borderColor).withOpacity(0.3),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: FittedBox( // makes text auto-fit if needed
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : (textColor ?? Colors.black),
        ),
      ),
    ),
  );
}
