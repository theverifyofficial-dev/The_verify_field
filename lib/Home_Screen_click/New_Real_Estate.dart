import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Propert_verigication_Document/Show_tenant.dart';
import '../add_properties_firstpage.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_New_Property.dart';
import 'Add_RealEstate.dart';
import 'Add_image_under_property.dart';
import 'Commercial_property_Filter.dart';
import 'Filter_Options.dart';
import 'View_All_Details.dart';

class NewRealEstateShowDateModel {
  final int? pId;
  final int? sId; // subid
  final String? sourceId; // NEW
  final String? propertyPhoto;
  final String? locations;
  final String? flatNumber;
  final String? buyRent;
  final String? residenceCommercial; // NEW
  final String? apartmentName;       // NEW
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
  final String? liveUnlive; // NEW
  final String? registryAndGpa;
  final String? loan;
  final String? longitude;
  final String? latitude;
  final String? fieldWorkerCurrentLocation;
  final String? careTakerName;
  final String? careTakerNumber;
  final String? video;

  NewRealEstateShowDateModel({
    this.pId,
    this.sId,
    this.sourceId,
    this.propertyPhoto,
    this.locations,
    this.flatNumber,
    this.buyRent,
    this.residenceCommercial,
    this.apartmentName,
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
    this.liveUnlive,
    this.registryAndGpa,
    this.loan,
    this.longitude,
    this.latitude,
    this.fieldWorkerCurrentLocation,
    this.careTakerName,
    this.careTakerNumber,
    this.video,
  });

  // tiny helpers so backend shenanigans don't break you
  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static String? _asStr(dynamic v) => v?.toString();

  factory NewRealEstateShowDateModel.fromJson(Map<String, dynamic> json) {
    return NewRealEstateShowDateModel(
      pId: _asInt(json['P_id']),
      sId: _asInt(json['subid']),
      sourceId: _asStr(json['source_id']), // "921" in your sample
      propertyPhoto: _asStr(json['property_photo']),
      locations: _asStr(json['locations']),
      flatNumber: _asStr(json['Flat_number']),
      buyRent: _asStr(json['Buy_Rent']),
      residenceCommercial: _asStr(json['Residence_Commercial']),
      apartmentName: _asStr(json['Apartment_name']),
      apartmentAddress: _asStr(json['Apartment_Address']),
      typeOfProperty: _asStr(json['Typeofproperty']),
      bhk: _asStr(json['Bhk']),
      showPrice: _asStr(json['show_Price']),
      lastPrice: _asStr(json['Last_Price']),
      askingPrice: _asStr(json['asking_price']),
      floor: _asStr(json['Floor_']),
      totalFloor: _asStr(json['Total_floor']),
      balcony: _asStr(json['Balcony']),
      squarefit: _asStr(json['squarefit']),
      maintance: _asStr(json['maintance']),
      parking: _asStr(json['parking']),
      ageOfProperty: _asStr(json['age_of_property']),
      fieldWorkerAddress: _asStr(json['fieldworkar_address']),
      roadSize: _asStr(json['Road_Size']),
      metroDistance: _asStr(json['metro_distance']),
      highwayDistance: _asStr(json['highway_distance']),
      mainMarketDistance: _asStr(json['main_market_distance']),
      meter: _asStr(json['meter']),
      ownerName: _asStr(json['owner_name']),
      ownerNumber: _asStr(json['owner_number']),
      currentDates: _asStr(json['current_dates']),
      availableDate: _asStr(json['available_date']),
      kitchen: _asStr(json['kitchen']),
      bathroom: _asStr(json['bathroom']),
      lift: _asStr(json['lift']),
      facility: _asStr(json['Facility']),
      furnishedUnfurnished: _asStr(json['furnished_unfurnished']),
      fieldWorkerName: _asStr(json['field_warkar_name']),
      fieldWorkerNumber: _asStr(json['field_workar_number']),
      liveUnlive: _asStr(json['live_unlive']),
      registryAndGpa: _asStr(json['registry_and_gpa']),
      loan: _asStr(json['loan']),
      longitude: _asStr(json['Longitude']),
      latitude: _asStr(json['Latitude']),
      fieldWorkerCurrentLocation: _asStr(json['field_worker_current_location']),
      careTakerName: _asStr(json['care_taker_name']),
      careTakerNumber: _asStr(json['care_taker_number']),
      video: _asStr(json['video_link']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'P_id': pId,
      'subid': sId,
      'source_id': sourceId,
      'property_photo': propertyPhoto,
      'locations': locations,
      'Flat_number': flatNumber,
      'Buy_Rent': buyRent,
      'Residence_Commercial': residenceCommercial,
      'Apartment_name': apartmentName,
      'Apartment_Address': apartmentAddress,
      'Typeofproperty': typeOfProperty,
      'Bhk': bhk,
      'show_Price': showPrice,
      'Last_Price': lastPrice,
      'asking_price': askingPrice,
      'Floor_': floor,
      'Total_floor': totalFloor,
      'Balcony': balcony,
      'squarefit': squarefit,
      'maintance': maintance,
      'parking': parking,
      'age_of_property': ageOfProperty,
      'fieldworkar_address': fieldWorkerAddress,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'highway_distance': highwayDistance,
      'main_market_distance': mainMarketDistance,
      'meter': meter,
      'owner_name': ownerName,
      'owner_number': ownerNumber,
      'current_dates': currentDates,
      'available_date': availableDate,
      'kitchen': kitchen,
      'bathroom': bathroom,
      'lift': lift,
      'Facility': facility,
      'furnished_unfurnished': furnishedUnfurnished,
      'field_warkar_name': fieldWorkerName,
      'field_workar_number': fieldWorkerNumber,
      'live_unlive': liveUnlive,
      'registry_and_gpa': registryAndGpa,
      'loan': loan,
      'Longitude': longitude,
      'Latitude': latitude,
      'field_worker_current_location': fieldWorkerCurrentLocation,
      'care_taker_name': careTakerName,
      'care_taker_number': careTakerNumber,
      'video_link': video,
    };
  }
}

class Show_New_Real_Estate extends StatefulWidget {
  const Show_New_Real_Estate({super.key});

  @override
  State<Show_New_Real_Estate> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<Show_New_Real_Estate> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  List<NewRealEstateShowDateModel> _allProperties = [];
  List<NewRealEstateShowDateModel> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _number = '';
  int propertyCount = 0;
  String? selectedLabel;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    _searchController.addListener(_onSearchChanged);
    _loaduserdata();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
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
    });
  }

  Future<List<NewRealEstateShowDateModel>> fetchData(String number) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
          "?field_workar_number=$number&live_unlive=Live",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }

    final decoded = json.decode(response.body);

    // Most backends wrap results like { success: true, data: [...] }
    final raw = decoded is Map<String, dynamic> ? decoded['data'] : decoded;

    // Normalize to a List<Map<String,dynamic>>
    final List<Map<String, dynamic>> listResponse;
    if (raw is List) {
      listResponse = raw.map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (raw is Map) {
      listResponse = [Map<String, dynamic>.from(raw)];
    } else {
      listResponse = const [];
    }

    // Sort by P_id desc, even if P_id comes as String sometimes
    int _asInt(dynamic v) =>
        v is int ? v : (int.tryParse(v?.toString() ?? "0") ?? 0);

    listResponse.sort((a, b) => _asInt(b['P_id']).compareTo(_asInt(a['P_id'])));

    return listResponse
        .map((data) => NewRealEstateShowDateModel.fromJson(data))
        .toList();
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

  void _setSearchText(String label, String text) {
    setState(() {
      selectedLabel = label;
      _searchController.text = text;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    });

    print("Search for: $text");
  }

  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || selectedLabel != null && selectedLabel!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Colors.black.withOpacity(0.8)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              PhosphorIcons.caret_left_bold,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading properties...',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.textTheme.bodyLarge?.color),
            ),
          ],
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          children: [
            // Premium Search Bar
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withOpacity(0.8),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  hintText: 'Search properties by location, price, or features...',
                  hintStyle: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.hintColor,
                    fontSize: 14,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: theme.iconTheme.color?.withOpacity(0.7),
                    size: 24,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear_rounded,
                      color: theme.iconTheme.color?.withOpacity(0.6),
                    ),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        selectedLabel = null;
                        _filteredProperties = _allProperties;
                        propertyCount = _allProperties.length;
                      });
                    },
                  )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
            ),
            // Filter Chips - Premium Style
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ['Rent', 'Buy', 'Commercial'].map((label) {
                  final bool isSelected = selectedLabel == label;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(
                        label,
                        style: TextStyle(
                          color: isSelected ? Colors.white : theme.textTheme.bodyLarge?.color,
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      onSelected: (_) => _setSearchText(label, label),
                      backgroundColor: isSelected ? primaryColor.withOpacity(0.1) : theme.colorScheme.surfaceVariant.withOpacity(0.5),
                      selectedColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? primaryColor : theme.colorScheme.outline.withOpacity(0.3),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      elevation: isSelected ? 4 : 0,
                      shadowColor: primaryColor.withOpacity(0.2),
                    ),
                  );
                }).toList(),
              ),
            ),
            // Property Count Badge
            if (propertyCount > 0 && _isSearchActive)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.withOpacity(0.1), Colors.green.withOpacity(0.05)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "$propertyCount properties found",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                          selectedLabel = null;
                          _filteredProperties = _allProperties;
                          propertyCount = _allProperties.length;
                        });
                      },
                      icon: Icon(Icons.close, size: 18, color: theme.iconTheme.color?.withOpacity(0.6)),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                  ],
                ),
              ),
            // List or Empty State
            Expanded(
              child: _filteredProperties.isEmpty
                  ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 80, color: theme.colorScheme.outline.withOpacity(0.4)),
                    const SizedBox(height: 24),
                    Text(
                      "No properties found",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Try adjusting your search or filters",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton.icon(
                      onPressed: _fetchProperties,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                ),
              )
                  : RefreshIndicator(
                onRefresh: _fetchProperties,
                color: primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _filteredProperties.length,
                  itemBuilder: (context, index) {
                    final property = _filteredProperties[index];
                    return AnimatedOpacity(
                      opacity: 1.0,
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      child: StreamBuilder<http.Response>(
                        stream: Stream.periodic(const Duration(seconds: 5))
                            .asyncMap((_) => http.get(Uri.parse(
                          "https://verifyserve.social/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${_filteredProperties[index].pId ?? 0}",
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
                            "Property Address (Fieldworker)": property.fieldWorkerAddress,
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
                            "Video": property.video,
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
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            elevation: 8,
                            shadowColor: theme.colorScheme.shadow.withOpacity(0.2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('id_Building', property.pId ?? 0);
                                prefs.setString('id_Longitude', property.longitude.toString());
                                prefs.setString('id_Latitude', property.latitude.toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => View_Details(id: property.pId ?? 0),
                                  ),
                                );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Premium Image Section with Gradient Overlay
                                  Stack(
                                    children: [
                                      Container(
                                        height: 240,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: theme.colorScheme.surfaceVariant,
                                            child: const Center(
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) => Container(
                                            color: theme.colorScheme.surfaceVariant,
                                            child: Icon(
                                              Icons.home_outlined,
                                              size: 60,
                                              color: theme.colorScheme.onSurface.withOpacity(0.3),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Gradient Overlay
                                      Container(
                                        height: 240,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              Colors.transparent,
                                              Colors.black.withOpacity(0.3),
                                            ],
                                          ),
                                        ),
                                      ),
                                      // Badges
                                      Positioned(
                                        top: 12,
                                        right: 12,
                                        left: 12,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildPremiumBadge(
                                              context: context,
                                              text: "ID: ${property.pId}",
                                              icon: Icons.confirmation_number_outlined,
                                              backgroundColor: primaryColor.withOpacity(0.9),
                                              textColor: Colors.white,
                                            ),
                                            _buildPremiumBadge(
                                              context: context,
                                              text: "For: ${property.buyRent ?? 'Sale'}",
                                              icon: Icons.trending_up,
                                              backgroundColor: Colors.green.withOpacity(0.9),
                                              textColor: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                      if (isRedDot)
                                        Positioned(
                                          top: 12,
                                          left: 12,
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.notifications_active,
                                              color: Colors.white,
                                              size: 16,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  // Content Section
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Price and Location
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "₹${property.showPrice ?? '-'}",
                                              style: theme.textTheme.headlineSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24,
                                                fontFamily: "PoppinsBold",
                                                color: theme.colorScheme.onSurface,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                              decoration: BoxDecoration(
                                                color: _getPropertyTypeColor(property.buyRent ?? '').withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                property.locations ?? '',
                                                style: theme.textTheme.bodyMedium?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: _getPropertyTypeColor(property.buyRent ?? ''),
                                                  fontFamily: "PoppinsBold",
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        // Feature Chips - Premium
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: [
                                            _buildPremiumChip(
                                              context: context,
                                              icon: Icons.king_bed_outlined,
                                              text: property.bhk ?? '',
                                              color: Colors.purple,
                                            ),
                                            _buildPremiumChip(
                                              context: context,
                                              icon: Icons.layers_outlined,
                                              text: "${property.floor} / ${property.totalFloor}",
                                              color: Colors.teal,
                                            ),
                                            _buildPremiumChip(
                                              context: context,
                                              icon: Icons.home_outlined,
                                              text: "Flat ${property.flatNumber}",
                                              color: Colors.red,
                                            ),
                                            _buildPremiumChip(
                                              context: context,
                                              icon: Icons.business_outlined,
                                              text: property.typeOfProperty ?? '',
                                              color: Colors.orange,
                                            ),
                                            if (property.sId != null && property.sId != 0)
                                              _buildPremiumChip(
                                                context: context,
                                                icon: Icons.apartment_outlined,
                                                text: "Bldg: ${property.sId}",
                                                color: Colors.deepOrange,
                                              ),
                                            _buildPremiumChip(
                                              context: context,
                                              icon: Icons.description_outlined,
                                              text: "Agr: ${property.sourceId}",
                                              color: Colors.blue,
                                            ),
                                          ],
                                        ),
                                        // Missing Fields Warning
                                        if (hasMissingFields) ...[
                                          const SizedBox(height: 16),
                                          Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: [Colors.red.withOpacity(0.1), Colors.red.withOpacity(0.05)],
                                              ),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                                            ),
                                            child: Row(
                                              children: [
                                                Icon(Icons.warning_amber_outlined, color: Colors.red, size: 20),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    "Incomplete: ${missingFields.take(3).join(", ")}${missingFields.length > 3 ? '...' : ''}",
                                                    style: theme.textTheme.bodySmall?.copyWith(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getPropertyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'rent':
        return Colors.green;
      case 'buy':
        return Colors.blue;
      case 'commercial':
        return Colors.orange;
      default:
        return Colors.transparent;
    }
  }

  Widget _buildPremiumBadge({
    required BuildContext context,
    required String text,
    required IconData icon,
    required Color backgroundColor,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [backgroundColor, backgroundColor.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: textColor),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumChip({
    required BuildContext context,
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Chip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: "Poppins",
        ),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color.withOpacity(0.3)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      shadowColor: color.withOpacity(0.2),
    );
  }
}