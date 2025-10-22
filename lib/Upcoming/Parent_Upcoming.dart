import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Upcoming/All_flats.dart';
import 'package:verify_feild_worker/Upcoming/user_flat.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Upcoming_details.dart';
import 'add_coming_flats.dart';

class Upcoming_model {
  final int? pId;
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

class ParentUpcoming extends StatefulWidget {
  const ParentUpcoming({super.key});

  @override
  State<ParentUpcoming> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<ParentUpcoming> {

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
      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
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
      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab, // Full width of tab
                tabs: const [
                  Tab(text: 'All Flats'),
                  Tab(text: 'Your Flats'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(children: [
                AllFlats(),
                UserFlat(),
              ]),
            )
          ],
        ),
      ),


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
