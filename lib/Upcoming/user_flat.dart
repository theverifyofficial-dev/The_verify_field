import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Upcoming_details.dart';

class Upcoming_model {
  final int? pId;
  final int? subId;
  final String? propertyPhoto;
  final String? locations;
  final String? flatNumber;
  final String? buyRent;
  final String? apartmentAddress;
  final String? typeOfProperty;
  final String? bhk;
  final String? showPrice;
  final String? lastPrice;
  final String? askingPrice;
  final String? floor;
  final String? totalFloor;
  final String? balcony;
  final String? squarefit;
  final String? maintance;
  final String? parking;
  final String? ageOfProperty;
  final String? fieldWorkerAddress;
  final String? roadSize;
  final String? metroDistance;
  final String? highwayDistance;
  final String? mainMarketDistance;
  final String? meter;
  final String? ownerName;
  final String? ownerNumber;
  final String? currentDates;
  final String? availableDate;
  final String? kitchen;
  final String? bathroom;
  final String? lift;
  final String? facility;
  final String? furnishedUnfurnished;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? registryAndGpa;
  final String? loan;
  final String? longitude;
  final String? latitude;
  final String? fieldWorkerCurrentLocation;
  final String? careTakerName;
  final String? careTakerNumber;
  final String? video;

  Upcoming_model({
    this.pId,
    this.subId,
    this.propertyPhoto,
    this.locations,
    this.flatNumber,
    this.buyRent,
    this.apartmentAddress,
    this.typeOfProperty,
    this.bhk,
    this.showPrice,
    this.lastPrice,
    this.askingPrice,
    this.floor,
    this.totalFloor,
    this.balcony,
    this.squarefit,
    this.maintance,
    this.parking,
    this.ageOfProperty,
    this.fieldWorkerAddress,
    this.roadSize,
    this.metroDistance,
    this.highwayDistance,
    this.mainMarketDistance,
    this.meter,
    this.ownerName,
    this.ownerNumber,
    this.currentDates,
    this.availableDate,
    this.kitchen,
    this.bathroom,
    this.lift,
    this.facility,
    this.furnishedUnfurnished,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.registryAndGpa,
    this.loan,
    this.longitude,
    this.latitude,
    this.fieldWorkerCurrentLocation,
    this.careTakerName,
    this.careTakerNumber,
    this.video,
  });

  factory Upcoming_model.fromJson(Map<String, dynamic> json) {
    return Upcoming_model(
      pId: json['P_id'],
      subId: json['subid'],
      propertyPhoto: json['property_photo'],
      locations: json['locations'],
      flatNumber: json['Flat_number'],
      buyRent: json['Buy_Rent'],
      apartmentAddress: json['Apartment_Address'],
      typeOfProperty: json['Typeofproperty'],
      bhk: json['Bhk'],
      showPrice: json['show_Price'],
      lastPrice: json['Last_Price'],
      askingPrice: json['asking_price'],
      floor: json['Floor_'],
      totalFloor: json['Total_floor'],
      balcony: json['Balcony'],
      squarefit: json['squarefit'],
      maintance: json['maintance'],
      parking: json['parking'],
      ageOfProperty: json['age_of_property'],
      fieldWorkerAddress: json['fieldworkar_address'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      highwayDistance: json['highway_distance'],
      mainMarketDistance: json['main_market_distance'],
      meter: json['meter'],
      ownerName: json['owner_name'],
      ownerNumber: json['owner_number'],
      currentDates: json['current_dates'],
      availableDate: json['available_date'],
      kitchen: json['kitchen'],
      bathroom: json['bathroom'],
      lift: json['lift'],
      facility: json['Facility'],
      furnishedUnfurnished: json['furnished_unfurnished'],
      fieldWorkerName: json['field_warkar_name'],
      fieldWorkerNumber: json['field_workar_number'],
      registryAndGpa: json['registry_and_gpa'],
      loan: json['loan'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      fieldWorkerCurrentLocation: json['field_worker_current_location'],
      careTakerName: json['care_taker_name'],
      careTakerNumber: json['care_taker_number'],
      video: json['video_link'],
    );
  }
}

class UserFlat extends StatefulWidget {
  const UserFlat({super.key});

  @override
  State<UserFlat> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<UserFlat> {

  List<Upcoming_model> _allProperties = [];
  List<Upcoming_model> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _number = '';
  int propertyCount = 0;
  String? selectedLabel;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    final filtered = _allProperties.where((item) {
      return (item.locations ?? '').toLowerCase().contains(query) ||
          (item.apartmentAddress ?? '').toLowerCase().contains(query) ||
          (item.pId ?? '').toString().toLowerCase().contains(query) ||
          (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
          (item.bhk ?? '').toLowerCase().contains(query) ||
          (item.showPrice ?? '').toLowerCase().contains(query) ||
          (item.floor ?? '').toLowerCase().contains(query) ||
          (item.totalFloor ?? '').toLowerCase().contains(query) ||
          (item.balcony ?? '').toLowerCase().contains(query) ||
          (item.squarefit ?? '').toLowerCase().contains(query) ||
          (item.maintance ?? '').toLowerCase().contains(query) ||
          (item.parking ?? '').toLowerCase().contains(query) ||
          (item.kitchen ?? '').toLowerCase().contains(query) ||
          (item.bathroom ?? '').toLowerCase().contains(query) ||
          (item.facility ?? '').toLowerCase().contains(query) ||
          (item.furnishedUnfurnished ?? '').toLowerCase().contains(query) ||
          (item.buyRent ?? '').toLowerCase().contains(query) ||
          (item.longitude ?? '').toLowerCase().contains(query) ||
          (item.latitude ?? '').toLowerCase().contains(query) ||
          (item.propertyPhoto ?? '').toLowerCase().contains(query) ||
          (item.ageOfProperty ?? '').toLowerCase().contains(query) ||
          (item.registryAndGpa ?? '').toLowerCase().contains(query) ||
          (item.loan ?? '').toLowerCase().contains(query) ||
          (item.flatNumber ?? '').toLowerCase().contains(query) ||
          (item.currentDates ?? '').toLowerCase().contains(query) ||
          (item.availableDate ?? '').toLowerCase().contains(query) ||
          (item.ownerName ?? '').toLowerCase().contains(query) ||
          (item.ownerNumber ?? '').toLowerCase().contains(query) ||
          (item.fieldWorkerName ?? '').toLowerCase().contains(query) ||
          (item.fieldWorkerNumber ?? '').toLowerCase().contains(query) ||
          (item.careTakerName ?? '').toLowerCase().contains(query) ||
          (item.careTakerNumber ?? '').toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredProperties = filtered;
      propertyCount = filtered.length;
    });
  }


  Future<List<Upcoming_model>> fetchData(String number) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_show_api_for_fieldworkar.php?field_workar_number=$number",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        final List<dynamic> dataList = decoded['data'];

        // Sort by P_id descending
        dataList.sort((a, b) {
          if (a['P_id'] != null && b['P_id'] != null) {
            return b['P_id'].compareTo(a['P_id']);
          }
          return 0;
        });

        return dataList.map((e) => Upcoming_model.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response structure: missing 'data' key");
      }
    } else {
      throw Exception('Unexpected server response: ${response.statusCode}');
    }
  }



  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata(); // fetch _number from SharedPreferences

    _loaduserdata().then((_) {
      _fetchInitialData(); // Call your API after loading user data
    });
  }

  Future<void> _loaduserdata() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';
    await _fetchProperties();
  }

  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(_number);
      setState(() {
        _allProperties = data;
        _filteredProperties = data;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(""); // Call your API
      setState(() {
        // _originalData = data;
        // _filteredData = data;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  void _setSearchText(String label, String text) {
    setState(() {
      selectedLabel = label;
      _searchController.text = text;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),

      );
      // propertyCount = _getMockPropertyCount(text); // Mock or real count

    });

    print("Search for: $text");
  }

  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || selectedLabel!="";
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      _isLoading
          ? Center(child: Image.asset(AppImages.loader,height: 50,))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search Flats here',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                  ),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          if (propertyCount > 0 && _isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "$propertyCount properties found",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              selectedLabel = '';
                              _filteredProperties = _allProperties;
                              propertyCount = 0;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          _filteredProperties.isEmpty
              ? Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No Flats found",
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
              : Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchProperties,
              child: ListView.builder(
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = _filteredProperties[index];
                  return StreamBuilder<http.Response>(
                    stream: Stream.periodic(const Duration(seconds: 5))
                        .asyncMap((_) => http.get(Uri.parse(
                      "https://verifyserve.social/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${_filteredProperties[index].pId??0}",
                    ))),
                    builder: (context, snapshot) {
                      bool isRedDot = false;

                      if (snapshot.hasData) {
                        try {
                          final body = jsonDecode(snapshot.data!.body);
                          isRedDot = body is List && body.isNotEmpty && body[0]['logg'] == 0;
                        } catch (_) {}
                      }

                      final Map<String, dynamic> fields = {
                        "Images": property.propertyPhoto,
                        "Owner Name": property.ownerName,
                        "Owner Number": property.ownerNumber,
                        "Caretaker Name": property.careTakerName,
                        "Caretaker Number": property.careTakerNumber,
                        "Place": property.locations,
                        "Buy/Rent": property.buyRent,
                        "Property Name/Address": property.apartmentAddress,
                        "Property Address (Fieldworker)":
                        property.fieldWorkerAddress,
                        // "Owner Vehicle Number": property.ownerVehicleNumber,
                        // "Your Address": property.fieldWorkerCurrentLocation,
                        "Field Worker Name": property.fieldWorkerName,
                        "Field Worker Number": property.fieldWorkerNumber,
                        "Current Date": property.currentDates,
                        "Longitude": property.longitude,
                        "Latitude": property.latitude,
                        "Road Size": property.roadSize,
                        "Metro Distance": property.metroDistance,
                        "Metro Name": property.highwayDistance,
                        "Main Market Distance": property.mainMarketDistance,
                        "Age of Property": property.ageOfProperty,
                        "Lift": property.lift,
                        "Parking": property.parking,
                        "Total Floor": property.totalFloor,
                        "Residence/Commercial": property.typeOfProperty,
                        "Facility": property.facility,
                      };

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
                      return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('id_Building', _filteredProperties[index].pId??0);
                                prefs.setString('id_Longitude', _filteredProperties[index].longitude.toString());
                                prefs.setString('id_Latitude', _filteredProperties[index].latitude.toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpcomingDetailsPage(id: _filteredProperties[index].pId??0),
                                  ),
                                );
                                print(_filteredProperties[index].pId??0);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                                child: Card(
                                  elevation: 4, // ✅ elevation added
                                  shadowColor:  Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.white,
                                  child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Stack(
                                        children: [
                                          Container(
                                            height: 450,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Theme.of(context).highlightColor,
                                              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                            ),
                                            child: Image.network(
                                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${_filteredProperties[index].propertyPhoto}",
                                              fit: BoxFit.cover,
                                              errorBuilder: (context, error, stackTrace) => Center(
                                                child: Icon(Icons.home, size: 50, color: Theme.of(context).hintColor),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 12,
                                            right: 12,
                                            child: Wrap(
                                              spacing: 8, // space between the two containers
                                              children: [
                                                _buildFeatureItem(
                                                  context: context,
                                                  // icon: Icons.king_bed,
                                                  text: "Property ID: ${_filteredProperties[index].pId}",
                                                  borderColor: Colors.red.shade200,
                                                  backgroundColor: Colors.red.shade50,
                                                  textColor: Colors.red.shade700,
                                                  shadowColor: Colors.red.shade100,
                                                ),  _buildFeatureItem(
                                                  context: context,
                                                  // icon: Icons.king_bed,
                                                  text: "For: ${_filteredProperties[index].buyRent}" ?? "Property",
                                                  borderColor: Colors.blue.shade200,
                                                  backgroundColor: Colors.blue.shade50,
                                                  textColor: Colors.blue.shade700,
                                                  shadowColor: Colors.blue.shade100,
                                                ),

                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  "₹${_filteredProperties[index].showPrice??"-"
                                                      ".0"}"
                                                  ,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20,
                                                    fontFamily: "PoppinsBold",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  _filteredProperties[index].locations ?? "",
                                                  style: TextStyle(
                                                    fontFamily: "PoppinsBold",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              spacing: 4, // horizontal spacing between items
                                              runSpacing: 8, // vertical spacing between lines
                                              alignment: WrapAlignment.start,
                                              children: [
                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.king_bed,
                                                  text: "${_filteredProperties[index].bhk}",
                                                  borderColor: Colors.purple.shade200,
                                                  backgroundColor: Colors.purple.shade50,
                                                  textColor: Colors.purple.shade700,
                                                  shadowColor: Colors.purple.shade100,
                                                ),
                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.apartment,
                                                  text: "${_filteredProperties[index].floor}",
                                                  borderColor: Colors.teal.shade200,
                                                  backgroundColor: Colors.teal.shade50,
                                                  textColor: Colors.teal.shade700,
                                                  shadowColor: Colors.teal.shade100,
                                                ),
                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.receipt_rounded,
                                                  text: "Flat No. ${_filteredProperties[index].flatNumber}",
                                                  borderColor: Colors.red.shade200,
                                                  backgroundColor: Colors.red.shade50,
                                                  textColor: Colors.red.shade700,
                                                  shadowColor: Colors.red.shade100,
                                                ),
                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.home_work,
                                                  text: _filteredProperties[index].typeOfProperty ?? "",
                                                  borderColor: Colors.orange.shade200,
                                                  backgroundColor: Colors.orange.shade50,
                                                  textColor: Colors.orange.shade700,
                                                  shadowColor: Colors.orange.shade100,
                                                ),
                                                _buildFeatureItem(
                                                  context: context,
                                                  icon: Icons.home_work,
                                                  text: "Building ID: ${_allProperties[index].subId.toString()}" ?? "",
                                                  borderColor: Colors.orange.shade200,
                                                  backgroundColor: Colors.orange.shade50,
                                                  textColor: Colors.orange.shade700,
                                                  shadowColor: Colors.orange.shade100,
                                                ),
                                              ],
                                            ),
                                            if (hasMissingFields) ...[
                                              SizedBox(height: 20),
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
                                            ]
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]
                      );
                    },
                  );

                },
              ),
            ),
          ),
        ],
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(bottom: 30,left: 8,right: 8),
      //   child: Container(
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(6),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black.withOpacity(0.2),
      //           blurRadius: 10,
      //           offset: const Offset(0, 5),
      //         ),
      //       ],
      //       gradient: LinearGradient(
      //         colors: [Colors.blueAccent, Colors.lightBlueAccent],
      //         begin: Alignment.centerLeft,
      //         end: Alignment.centerRight,
      //       ),
      //     ),
      //     child: ElevatedButton.icon(
      //       onPressed: () {
      //         Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddComingFlats()));
      //       },
      //       icon: const Icon(Icons.add, color: Colors.white),
      //       label: const Text(
      //         'Add Flats',
      //         style: TextStyle(
      //           fontSize: 17,
      //           fontFamily: "PoppinsBold",
      //           fontWeight: FontWeight.w600,
      //           letterSpacing: 0.5,
      //           color: Colors.white,
      //         ),
      //       ),
      //       style: ElevatedButton.styleFrom(
      //         elevation: 0, // Shadow handled by container
      //         backgroundColor: Colors.transparent,
      //         shadowColor: Colors.transparent,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(16),
      //         ),
      //         padding: const EdgeInsets.symmetric(vertical: 16),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }



  Widget _buildFeatureItem({
    required BuildContext context,
    required String text,
    required Color borderColor,
    IconData? icon, // 👈 optional now
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final width = MediaQuery.of(context).size.width;

    // Scale text, padding, and icon size relative to screen width
    double fontSize = width < 350 ? 10 : (width < 500 ? 12 : 14);
    double horizontalPadding = width < 350 ? 8 : (width < 500 ? 12 : 14);
    double verticalPadding = width < 350 ? 6 : (width < 500 ? 8 : 12);
    double iconSize = width < 350 ? 14 : (width < 500 ? 16 : 18);

    return Container(
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
            color: (shadowColor ?? borderColor).withOpacity(0.10),
            blurRadius: 6,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[ // 👈 only shows if passed
            Icon(
              icon,
              size: iconSize,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : (textColor ?? Colors.black),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: "Poppins",
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : (textColor ?? Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}
