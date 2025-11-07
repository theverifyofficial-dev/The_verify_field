// frontpage_futureproperty_with_tabs.dart (Fully Fixed: Added PlotPropertyData class, fixed fetch, ensured all tabs work with API data display)
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_commercial_property.dart';
import 'Add_futureProperty.dart';
import 'Add_plot_property.dart';
import 'Commercial_detail.dart';
import 'Future_property_details.dart';
import 'package:intl/intl.dart';
import 'PlotShow.dart';
import 'Plot_detail.dart';
import 'commercialShow.dart';

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

// ✅ ADDED: PlotPropertyData class (with fromJson for API mapping - adjust keys if API response differs)
class PlotPropertyData {
  final int id;
  String? plotStatus;
  String? plotPrice;
  String? mainAddress;
  String? currentLocation;
  String? plotSize;
  String? roadSize;
  String? plotOpen;
  String? waterConnection;
  String? electricPrice;
  String? propertyChain;
  String? plotFrontSize;
  String? plotSideSize;
  String? ageOfProperty;
  String? propertyRent;
  String? fieldworkarName;
  String? fieldworkarNumber;
  XFile? singleImage;
  List<XFile> selectedImages = [];

  PlotPropertyData({
    required this.id,
    this.plotStatus,
    this.plotPrice,
    this.mainAddress,
    this.currentLocation,
    this.plotSize,
    this.roadSize,
    this.plotOpen,
    this.waterConnection,
    this.electricPrice,
    this.propertyChain,
    this.plotFrontSize,
    this.plotSideSize,
    this.ageOfProperty,
    this.propertyRent,
    this.fieldworkarName,
    this.fieldworkarNumber,
    this.singleImage,
    List<XFile>? selectedImages,
  }) : selectedImages = selectedImages ?? [];

  factory PlotPropertyData.fromJson(Map<String, dynamic> json) {
    // Map JSON keys to fields - adjust keys based on actual API response (e.g., check console logs)
    // Example: assuming keys like 'plot_status', 'plot_price', etc. Update as per your API.
    return PlotPropertyData(
      id: json['id'] ?? 0,
      plotStatus: json['plot_status'] ?? json['plotStatus'],
      plotPrice: json['plot_price'] ?? json['plotPrice'],
      mainAddress: json['main_address'] ?? json['mainAddress'],
      currentLocation: json['current_location'] ?? json['currentLocation'],
      plotSize: json['plot_size'] ?? json['plotSize'],
      roadSize: json['road_size'] ?? json['roadSize'],
      plotOpen: json['plot_open'] ?? json['plotOpen'],
      waterConnection: json['water_connection'] ?? json['waterConnection'],
      electricPrice: json['electric_price'] ?? json['electricPrice'],
      propertyChain: json['property_chain'] ?? json['propertyChain'],
      plotFrontSize: json['plot_front_size'] ?? json['plotFrontSize'],
      plotSideSize: json['plot_side_size'] ?? json['plotSideSize'],
      ageOfProperty: json['age_of_property'] ?? json['ageOfProperty'],
      propertyRent: json['property_rent'] ?? json['propertyRent'],
      fieldworkarName: json['fieldworkar_name'] ?? json['fieldworkarName'],
      fieldworkarNumber: json['fieldworkar_number'] ?? json['fieldworkarNumber'],
      // For images: If API returns URL strings, convert to XFile (or handle as String if needed)
      singleImage: json['single_image'] != null ? XFile(json['single_image']) : null,
      selectedImages: (json['selected_images'] as List<dynamic>?)?.map((img) => XFile(img.toString())).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plot_status': plotStatus,
      'plot_price': plotPrice,
      'main_address': mainAddress,
      'current_location': currentLocation,
      'plot_size': plotSize,
      'road_size': roadSize,
      'plot_open': plotOpen,
      'water_connection': waterConnection,
      'electric_price': electricPrice,
      'property_chain': propertyChain,
      'plot_front_size': plotFrontSize,
      'plot_side_size': plotSideSize,
      'age_of_property': ageOfProperty,
      'property_rent': propertyRent,
      'fieldworkar_name': fieldworkarName,
      'fieldworkar_number': fieldworkarNumber,
      'single_image': singleImage?.path,
      'selected_images': selectedImages.map((img) => img.path).toList(),
    };
  }
}

class FrontPage_FutureProperty extends StatefulWidget {
  const FrontPage_FutureProperty({super.key});

  @override
  State<FrontPage_FutureProperty> createState() => _FrontPage_FuturePropertyState();
}

class _FrontPage_FuturePropertyState extends State<FrontPage_FutureProperty>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

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

  // Commercial properties ke liye variables
  List<CommercialPropertyData> _commercialProperties = [];
  bool _isLoadingCommercial = true;

  // Plot properties ke liye variables
  List<PlotPropertyData> _plotProperties = [];
  bool _isLoadingPlots = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);

    _loaduserdata().then((_) {
      _fetchAndFilterProperties().then((_) {
        setState(() {
          fetchFlatsStatus();
          fetchTotalFlats();
          _filteredProperties = _allProperties;
          propertyCount = _allProperties.length;
        });
        _fetchPlotProperties();  // ✅ Fetch plots after _number is set
      });
    });

    // Commercial properties load karein
    _loadCommercialProperties();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // Commercial properties load karne ka method
  Future<void> _loadCommercialProperties() async {
    setState(() {
      _isLoadingCommercial = true;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? commercialData = prefs.getString('commercial_properties');

      if (commercialData != null) {
        List<dynamic> jsonList = jsonDecode(commercialData);
        setState(() {
          _commercialProperties = jsonList.map((json) =>
              CommercialPropertyData.fromJson(json)).toList();
        });
      }
    } catch (e) {
      print("Error loading commercial properties: $e");
    } finally {
      setState(() {
        _isLoadingCommercial = false;
      });
    }
  }

  // Commercial property save karne ka method
  Future<void> _saveCommercialProperties() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> jsonList = _commercialProperties.map((
          property) =>
          property.toJson()).toList();
      await prefs.setString('commercial_properties', jsonEncode(jsonList));
    } catch (e) {
      print("Error saving commercial properties: $e");
    }
  }

  // Commercial property add karne ka method
  void _addCommercialProperty(CommercialPropertyData newProperty) {
    setState(() {
      _commercialProperties.add(newProperty);
    });
    _saveCommercialProperties();
  }

  // ✅ FIXED: Plot properties API se fetch karne ka method (Direct HTTP with full debug)
  Future<void> _fetchPlotProperties() async {
    if (_number.isEmpty) {
      print("Skipping plot fetch: _number is empty");
      setState(() {
        _plotProperties = [];
        _isLoadingPlots = false;
      });
      return;
    }

    setState(() {
      _isLoadingPlots = true;
    });

    try {
      var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_plot_property_by_field_workar_number?fieldworkarnumber=$_number",
      );
      final response = await http.get(url);

      print("Plot API URL: $url");
      print("Plot API Response Status: ${response.statusCode}");
      print("Plot API Response Body: ${response.body}");  // Check this in console for JSON structure

      if (response.statusCode == 200) {
        List<dynamic> listResponse = json.decode(response.body);
        print("Decoded JSON list length: ${listResponse.length}");

        // Sort by id descending
        listResponse.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));

        _plotProperties = listResponse
            .map((data) => PlotPropertyData.fromJson(data))
            .toList();

        print("Mapped to ${_plotProperties.length} PlotPropertyData objects");
      } else {
        throw Exception('Unexpected error: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching plot properties from API: $e");
      _plotProperties = [];  // Fallback
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load plots: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPlots = false;
        });
      }
    }
  }

  // Plot property save karne ka method
  Future<void> _savePlotProperties() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<Map<String, dynamic>> jsonList = _plotProperties.map((property) =>
          property.toJson()).toList();
      await prefs.setString('plot_properties', jsonEncode(jsonList));
    } catch (e) {
      print("Error saving plot properties: $e");
    }
  }

  // Plot property add karne ka method
  void _addPlotProperty(PlotPropertyData newProperty) {
    setState(() {
      _plotProperties.add(newProperty);
    });
    _savePlotProperties();
  }

  void _openPlotForm() async {
    final PlotPropertyData? newProperty = await Navigator.push<PlotPropertyData?>(
      context,
      MaterialPageRoute(builder: (context) => PropertyListingPage()),
    );

    if (newProperty != null) {
      // Insert immediately so UI shows the new item on submit click
      setState(() {
        _plotProperties.insert(0, newProperty);
      });

      // Optional: show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Plot added'), backgroundColor: Colors.green),
      );

      // Optional: re-fetch from server to ensure full sync (only if server saved already)
      // await _fetchPlotProperties();
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();

      List<Catid> filtered;

      if (query.isEmpty) {
        filtered = List.from(_allProperties);
        selectedLabel = '';
      } else if (query == "Missing Field") {
        filtered = _allProperties.where((item) {
          return (item.images == null || item.images!.trim().isEmpty) ||
              (item.ownerName == null || item.ownerName!.trim().isEmpty) ||
              (item.ownerNumber == null || item.ownerNumber!.trim().isEmpty) ||
              (item.caretakerName == null ||
                  item.caretakerName!.trim().isEmpty) ||
              (item.caretakerNumber == null ||
                  item.caretakerNumber!.trim().isEmpty) ||
              (item.place == null || item.place!.trim().isEmpty) ||
              (item.buyRent == null || item.buyRent!.trim().isEmpty) ||
              (item.propertyNameAddress == null ||
                  item.propertyNameAddress!.trim().isEmpty) ||
              (item.propertyAddressForFieldworker == null || item
                  .propertyAddressForFieldworker!.trim().isEmpty) ||
              (item.ownerVehicleNumber == null || item.ownerVehicleNumber!
                  .trim().isEmpty) ||
              (item.yourAddress == null || item.yourAddress!.trim().isEmpty) ||
              (item.fieldWorkerName == null || item.fieldWorkerName!
                  .trim()
                  .isEmpty) ||
              (item.fieldWorkerNumber == null ||
                  item.fieldWorkerNumber!.trim().isEmpty) ||
              (item.currentDate == null || item.currentDate!.trim().isEmpty) ||
              (item.longitude == null || item.longitude!.trim().isEmpty) ||
              (item.latitude == null || item.latitude!.trim().isEmpty) ||
              (item.roadSize == null || item.roadSize!.trim().isEmpty) ||
              (item.metroDistance == null ||
                  item.metroDistance!.trim().isEmpty) ||
              (item.metroName == null || item.metroName!.trim().isEmpty) ||
              (item.mainMarketDistance == null ||
                  item.mainMarketDistance!.trim().isEmpty) ||
              (item.ageOfProperty == null ||
                  item.ageOfProperty!.trim().isEmpty) ||
              (item.lift == null || item.lift!.trim().isEmpty) ||
              (item.parking == null || item.parking!.trim().isEmpty) ||
              (item.totalFloor == null || item.totalFloor!.trim().isEmpty) ||
              (item.residenceCommercial == null ||
                  item.residenceCommercial!.trim().isEmpty) ||
              (item.facility == null || item.facility!.trim().isEmpty);
        }).toList();
      } else {
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
              (item.residenceCommercial ?? '').toLowerCase().contains(
                  query) ||
              (item.ownerNumber ?? '').toLowerCase().contains(query) ||
              (item.ownerName ?? '').toLowerCase().contains(query) ||
              (item.ownerVehicleNumber ?? '').toLowerCase().contains(query) ||
              (item.buildingInformationFacilities ?? '').toLowerCase().contains(
                  query) ||
              (item.propertyAddressForFieldworker ?? '').toLowerCase().contains(
                  query) ||
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
        "loggValue1": loggValue1,
        "loggValue2": loggValue2,
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

        _filteredProperties = _allProperties;

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
    return _searchController.text
        .trim()
        .isNotEmpty || selectedLabel.isNotEmpty;
  }

  Future<void> _refreshProperties() async {
    await _fetchAndFilterProperties();
    await fetchTotalFlats();
    await fetchFlatsStatus();
    await _loadCommercialProperties();
    await _fetchPlotProperties();
    print("Refreshed plots: ${_plotProperties.length} items");
  }

  int bookFlats = 0;
  int liveFlats = 0;

  Future<void> fetchFlatsStatus() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=${11}',
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

  List<Catid> filtered = [];

  Future<void> fetchTotalFlats() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=${_number}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    print("Phone Number"+phoneNumber);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }



  // Commercial property card widget
  Widget _buildCommercialPropertyCard(CommercialPropertyData property,
      int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  CommercialPropertyDisplayPage(propertyData: property),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: property.singleImage != null
                  ? Image.file(
                File(property.singleImage!.path),
                fit: BoxFit.cover,
              )
                  : Icon(
                  Icons.business_center, size: 50, color: Colors.grey[400]),
            ),

            // Property Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF2D5BFF).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          property.listingType ?? 'For Sale',
                          style: TextStyle(
                            color: Color(0xFF2D5BFF),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Text(
                        property.rentPrice.isNotEmpty
                            ? '₹${property.rentPrice}'
                            : 'Contact for Price',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Text(
                    property.propertyType ?? 'Commercial Property',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      _buildDetailChip('${property.builtupArea} sq ft'),
                      SizedBox(width: 8),
                      if (property.totalFloors != null) ...[
                        _buildDetailChip('${property.totalFloors} Floors'),
                        SizedBox(width: 8),
                      ],
                      if (property.parkingType != null)
                        _buildDetailChip(property.parkingType!),
                    ],
                  ),

                  SizedBox(height: 12),

                  // Amenities preview
                  if (property.amenities.isNotEmpty) ...[
                    Text(
                      'Amenities: ${property.amenities.take(3).join(
                          ', ')}${property.amenities.length > 3 ? '...' : ''}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 8),
                  ],

                  // Field Worker Info
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Color(0xFF2D5BFF),
                          child: Text(
                            property.fieldWorkerName.isNotEmpty
                                ? property.fieldWorkerName[0].toUpperCase()
                                : 'A',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.fieldWorkerName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                property.fieldWorkerNumber,
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone, color: Color(0xFF2D5BFF)),
                          onPressed: () {
                            // Call functionality
                          },
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
    );
  }

  // ✅ FIXED: Plot property card widget (null-safe, handles API data)
  Widget _buildPlotPropertyCard(PlotPropertyData property, int index) {
    // Safe image display
    Widget _safeImage(XFile? file) {
      if (file == null) {
        return Icon(Icons.landscape, size: 50, color: Colors.grey[400]);
      }
      final path = file.path;
      if (path.startsWith('http')) {
        return Image.network(
          path,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null)
              return child;
            return Center(child: CircularProgressIndicator());
          },
          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Colors.red),
        );
      }
      return Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, color: Colors.red),
      );
    }

    XFile? firstImage = property.singleImage ?? (property.selectedImages.isNotEmpty ? property.selectedImages.first : null);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PlotPropertyDisplayPage(fieldworkarNumber: "11",)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                color: Colors.grey[200],
              ),
              child: _safeImage(firstImage),
            ),
            // Details
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          property.plotStatus ?? 'Available',
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                      ),
                      Text(
                        property.plotPrice?.isNotEmpty == true ? '₹${property.plotPrice}' : 'Contact for Price',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[700]),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Text(
                    property.mainAddress ?? 'Plot Property',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.currentLocation ?? 'Location not specified',
                          style: TextStyle(color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildDetailChip('${property.plotSize ?? 'N/A'} gaj'),
                        SizedBox(width: 8),
                        if (property.roadSize?.isNotEmpty == true) ...[
                          _buildDetailChip('${property.roadSize} ft road'),
                          SizedBox(width: 8),
                        ],
                        if (property.plotOpen?.isNotEmpty == true) ...[
                          _buildDetailChip(property.plotOpen!),
                          SizedBox(width: 8),
                        ],
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  // Features
                  if ((property.waterConnection?.isNotEmpty == true || property.electricPrice?.isNotEmpty == true || property.propertyChain?.isNotEmpty == true)) ...[
                    Text(
                      'Features: ${[
                        if (property.waterConnection?.isNotEmpty == true) property.waterConnection,
                        if (property.electricPrice?.isNotEmpty == true) property.electricPrice,
                        if (property.propertyChain?.isNotEmpty == true) 'Chain: ${property.propertyChain}',
                      ].where((f) => f != null && f.isNotEmpty).join(', ')}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                  ],

                  // Fieldworker
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: Colors.green,
                          child: Text(
                            property.fieldworkarName?.isNotEmpty == true ? property.fieldworkarName![0].toUpperCase() : 'F',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                property.fieldworkarName ?? 'Field Worker',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                property.fieldworkarNumber ?? 'N/A',
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.phone, color: Colors.green),
                          onPressed: property.fieldworkarNumber?.isNotEmpty == true ? () => _makePhoneCall(property.fieldworkarNumber!) : null,
                        ),
                      ],
                    ),
                  ),

                  // Additional chips
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      if (property.plotFrontSize?.isNotEmpty == true) _buildSmallChip('Front: ${property.plotFrontSize} ft'),
                      if (property.plotSideSize?.isNotEmpty == true) _buildSmallChip('Side: ${property.plotSideSize} ft'),
                      if (property.ageOfProperty?.isNotEmpty == true) _buildSmallChip('Age: ${property.ageOfProperty}'),
                      if (property.propertyRent?.isNotEmpty == true) _buildSmallChip('Rent: ₹${property.propertyRent}'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
      ),
    );
  }

  Widget _buildSmallChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: Colors.grey[700]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(width: 3),
                Icon(
                  PhosphorIcons.caret_left_bold,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(56),
            child: Container(
              color: Colors.black,
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'Buildings'),
                  Tab(text: 'Plots'),
                  Tab(text: 'Commercial'),
                ],
              ),
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: Lottie.asset(AppImages.loadingHand, height: 400))
            : TabBarView(
          controller: _tabController,
          children: [
            // TAB 1: Buildings
            _buildBuildingsTab(),

            // TAB 2: Plots
            PlotListPage(),
            // TAB 3: Commercial
            CommercialListPage(),
          ],
        ),

        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddOptionsDialog,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add Forms", style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w600)),
          backgroundColor: Colors.blue,
          elevation: 4,
        ),
      ),
    );
  }

  // Buildings tab ke liye UI
  Widget _buildBuildingsTab() {
    return Column(
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
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600, fontSize: 16),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                            Icons.search_rounded, color: Colors.grey.shade700,
                            size: 24),
                      ),
                      suffixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _searchController.text.isNotEmpty
                            ? IconButton(
                          key: const ValueKey('clear'),
                          icon: Icon(
                              Icons.close_rounded, color: Colors.grey.shade700,
                              size: 22),
                          onPressed: () {
                            _searchController.clear();
                            selectedLabel = '';
                            _filteredProperties = _allProperties;
                            propertyCount = _allProperties.length;
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
                        borderSide: BorderSide(color: Colors.blueGrey
                            .withOpacity(0.3), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blueAccent
                            .withOpacity(0.8), width: 1.5),
                      ),
                    ),
                    onChanged: (value) async {
                      String query = value.toLowerCase();

                      List<Catid> filtered = _allProperties.where((item) {
                        return (item.propertyNameAddress
                            ?.toLowerCase()
                            .contains(query) ?? false) ||
                            (item.place?.toLowerCase().contains(query) ??
                                false) ||
                            (item.buyRent?.toLowerCase().contains(query) ??
                                false) ||
                            (item.ownerName?.toLowerCase().contains(query) ??
                                false) ||
                            (item.fieldWorkerName?.toLowerCase().contains(
                                query) ?? false);
                      }).toList();

                      if (selectedLabel == 'Missing Field') {
                        filtered = filtered.where((item) {
                          return (item.images == null ||
                              item.images!.trim().isEmpty) ||
                              (item.ownerName == null ||
                                  item.ownerName!.trim().isEmpty) ||
                              (item.ownerNumber == null ||
                                  item.ownerNumber!.trim().isEmpty) ||
                              (item.caretakerName == null ||
                                  item.caretakerName!.trim().isEmpty);
                        }).toList();
                      } else if (selectedLabel == 'Live' ||
                          selectedLabel == 'Unlive') {
                        List<Catid> temp = [];
                        for (var item in filtered) {
                          try {
                            final res = await http.get(Uri.parse(
                              'https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=${item
                                  .id}',
                            ));
                            if (res.statusCode == 200) {
                              final data = jsonDecode(res.body);
                              bool anyLive = false;
                              if (data is List && data.isNotEmpty) {
                                for (var d in data) {
                                  if (d['live_unlive'] == 'Live' &&
                                      (d['logs'] as num) > 0) {
                                    anyLive = true;
                                    break;
                                  }
                                }
                              }
                              if ((selectedLabel == 'Live' && anyLive) ||
                                  (selectedLabel == 'Unlive' && !anyLive)) {
                                temp.add(item);
                              }
                            }
                          } catch (e) {
                            debugPrint('Live/Unlive fetch error: $e');
                          }
                        }
                        filtered = temp;
                      } else
                      if (selectedLabel == 'Rent' || selectedLabel == 'Sell' ||
                          selectedLabel == 'Commercial') {
                        filtered = filtered.where((item) {
                          return item.buyRent?.toLowerCase() ==
                              selectedLabel.toLowerCase();
                        }).toList();
                      }

                      setState(() {
                        _filteredProperties = filtered;
                        propertyCount = filtered.length;
                      });
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'Rent',
                    'Buy',
                    'Commercial',
                    'Missing Field',
                    'Live',
                    'Unlive',
                    'Empty Building',
                  ]
                      .map((label) {
                    final isSelected = label == selectedLabel;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                            selectedLabel = label;
                          });

                          _searchController.clear();
                          _debounce?.cancel();

                          List<Catid> filtered = [];

                          if (label == 'Missing Field') {
                            filtered = _allProperties.where((item) {
                              return (item.images == null ||
                                  item.images!.trim().isEmpty) ||
                                  (item.ownerName == null ||
                                      item.ownerName!.trim().isEmpty) ||
                                  (item.ownerNumber == null ||
                                      item.ownerNumber!.trim().isEmpty) ||
                                  (item.caretakerName == null ||
                                      item.caretakerName!.trim().isEmpty) ||
                                  (item.caretakerNumber == null ||
                                      item.caretakerNumber!.trim().isEmpty) ||
                                  (item.place == null ||
                                      item.place!.trim().isEmpty) ||
                                  (item.buyRent == null ||
                                      item.buyRent!.trim().isEmpty) ||
                                  (item.propertyNameAddress == null ||
                                      item.propertyNameAddress!
                                          .trim()
                                          .isEmpty) ||
                                  (item.propertyAddressForFieldworker == null ||
                                      item.propertyAddressForFieldworker!
                                          .trim()
                                          .isEmpty) ||
                                  (item.ownerVehicleNumber == null ||
                                      item.ownerVehicleNumber!
                                          .trim()
                                          .isEmpty) ||
                                  (item.yourAddress == null ||
                                      item.yourAddress!.trim().isEmpty) ||
                                  (item.fieldWorkerName == null ||
                                      item.fieldWorkerName!.trim().isEmpty) ||
                                  (item.fieldWorkerNumber == null ||
                                      item.fieldWorkerNumber!.trim().isEmpty) ||
                                  (item.currentDate == null ||
                                      item.currentDate!.trim().isEmpty) ||
                                  (item.longitude == null ||
                                      item.longitude!.trim().isEmpty) ||
                                  (item.latitude == null ||
                                      item.latitude!.trim().isEmpty) ||
                                  (item.roadSize == null ||
                                      item.roadSize!.trim().isEmpty) ||
                                  (item.metroDistance == null ||
                                      item.metroDistance!.trim().isEmpty) ||
                                  (item.metroName == null ||
                                      item.metroName!.trim().isEmpty) ||
                                  (item.mainMarketDistance == null ||
                                      item.mainMarketDistance!
                                          .trim()
                                          .isEmpty) ||
                                  (item.ageOfProperty == null ||
                                      item.ageOfProperty!.trim().isEmpty) ||
                                  (item.lift == null ||
                                      item.lift!.trim().isEmpty) ||
                                  (item.parking == null ||
                                      item.parking!.trim().isEmpty) ||
                                  (item.totalFloor == null ||
                                      item.totalFloor!.trim().isEmpty) ||
                                  (item.residenceCommercial == null ||
                                      item.residenceCommercial!
                                          .trim()
                                          .isEmpty) ||
                                  (item.facility == null ||
                                      item.facility!.trim().isEmpty);
                            }).toList();
                          }
                          else if (label == 'Empty Building') {
                            final futures = _allProperties.map((item) async {
                              try {
                                final status = await fetchPropertyStatus(
                                    item.id);

                                if (status["loggValue2"] == "0") {
                                  return item;
                                }
                              } catch (e) {
                                debugPrint(
                                    "Flat 0 fetch error for ${item.id}: $e");
                              }
                              return null;
                            }).toList();

                            final results = await Future.wait(futures);
                            filtered = results.whereType<Catid>().toList();
                          }

                          else if (label == 'Rent' || label == 'Buy' ||
                              label == 'Commercial') {
                            filtered = _allProperties.where((item) {
                              if (label == 'Commercial') {
                                final value = (item.residenceCommercial ?? '')
                                    .toLowerCase();
                                return value == 'commercial';
                              } else {
                                final value = (item.buyRent ?? '')
                                    .toLowerCase();
                                return value == label.toLowerCase();
                              }
                            }).toList();
                          }
                          else if (label == 'Live' || label == 'Unlive') {
                            final futures = _allProperties.map((item) async {
                              try {
                                final res = await http.get(Uri.parse(
                                  'https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=${item
                                      .id}',
                                ));
                                if (res.statusCode == 200) {
                                  final data = jsonDecode(res.body);
                                  bool anyLive = false;
                                  if (data is List && data.isNotEmpty) {
                                    for (var d in data) {
                                      if (d['live_unlive'] == 'Live' &&
                                          (d['logs'] as num) > 0) {
                                        anyLive = true;
                                        break;
                                      }
                                    }
                                  }
                                  if ((label == 'Live' && anyLive) ||
                                      (label == 'Unlive' && !anyLive)) {
                                    return item;
                                  }
                                }
                              } catch (e) {
                                debugPrint('Live/Unlive fetch error: $e');
                              }
                              return null;
                            }).toList();

                            final results = await Future.wait(futures);
                            filtered = results.whereType<Catid>().toList();
                          }

                          setState(() {
                            _filteredProperties = filtered;
                            propertyCount = filtered.length;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.blue : Colors
                              .grey[300],
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

              if (propertyCount > 0)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme
                              .of(context)
                              .brightness == Brightness.dark ? Colors
                              .transparent : Colors.grey, width: 1.5),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20,
                                color: Colors.green),
                            const SizedBox(width: 6),
                            Text(
                              "$propertyCount building found",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                            const SizedBox(width: 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  selectedLabel = '';
                                  _filteredProperties = _allProperties;
                                  propertyCount = _allProperties.length;
                                });
                              },
                              child: const Icon(
                                  Icons.close, size: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),
                      isLoading
                          ? const SizedBox()
                          : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Total Flats: ${totalFlats ?? 0}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 6),

                      isLoading
                          ? const SizedBox()
                          : Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceEvenly,
                        children: [
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
                final displayIndex = _filteredProperties.length - index;
                return FutureBuilder<Map<String, dynamic>>(
                  future: fetchPropertyStatus(property.id),
                  builder: (context, snapshot) {
                    String logg1 = "Loading...";
                    String logg2 = "Loading...";
                    Color statusColor = Colors.grey;

                    if (snapshot.hasData) {
                      logg1 = snapshot.data!['loggValue1'];
                      logg2 = snapshot.data!['loggValue2'];
                      statusColor = snapshot.data!['statusColor'];
                    }
                    else if (snapshot.hasError) {
                      logg1 = "Error";
                      logg2 = "Error";
                      statusColor = Colors.grey;
                    }

                    return PropertyCard(
                      displayIndex: displayIndex,
                      property: property,
                      statusText: logg2,
                      statusColor: statusColor,
                      Live_Unlive: logg1,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Future_Property_details(
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
    );
  }

  Future<void> _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
      _SUbid = prefs.getString('id_future') ?? '';
    });
  }

  void _showAddOptionsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.52,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .brightness == Brightness.dark ? Colors.grey[900] : Colors
                    .white,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? Colors.grey[700]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Form options',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold, color: Theme
                        .of(context)
                        .brightness == Brightness.dark ? Colors.white : Colors
                        .black),
                  ),
                  const SizedBox(height: 8),
                  Text('Choose one of the options below to add a new forms.',
                      style: TextStyle(color: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.grey[300]
                          : Colors.grey[800])),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        _buildOptionTile(
                          icon: Icons.apartment,
                          title: 'Add Building',
                          subtitle: 'Add a new residential building',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => Add_FutureProperty())).then((_) {
                              _refreshProperties();
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildOptionTile(
                          icon: Icons.landscape,
                          title: 'Add Plot',
                          subtitle: 'Add a new plot record',
                          onTap: () {
                            Navigator.of(context).pop();
                            _openPlotForm();
                          },
                        ),
                        const SizedBox(height: 8),
                        _buildOptionTile(
                          icon: Icons.storefront,
                          title: 'Add Commercial',
                          subtitle: 'Add a commercial property',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) =>
                                    CommercialPropertyForm())).then((newProperty) {
                              if (newProperty != null && newProperty is CommercialPropertyData) {
                                _addCommercialProperty(newProperty);
                              }
                            });
                          },
                        ),
                        const SizedBox(height: 12),
                        Center(
                          child: TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme
                .of(context)
                .brightness == Brightness.dark ? Colors.grey[800] : Colors.grey
                .shade100,
          ),
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 28, color: Colors.black87),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: subtitle != null ? Text(subtitle) : null,
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}

// PropertyCard class (unchanged)
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

    bool _isNullOrEmpty(String? value) =>
        value == null || value.trim().isEmpty;

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
                        'https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=${property.id}')),
                    builder: (context, snapshot) {
                      String label = "Unlive: 0";
                      Color color = Colors.red.withOpacity(0.8);

                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData &&
                          !snapshot.hasError) {
                        final data = jsonDecode(snapshot.data!.body);

                        bool anyLive = false;
                        if (data is List && data.isNotEmpty) {
                          for (var item in data) {
                            if (item['live_unlive'] == 'Live' && (item['logs'] as num) > 0) {
                              anyLive = true;
                              break;
                            }
                          }
                        }

                        if (anyLive) {
                          final liveItem = data.firstWhere(
                                (item) => item['live_unlive'] == 'Live',
                            orElse: () => null,
                          );
                          label = "Live: ${liveItem?['logs'] ?? 0}";
                          color = Colors.green.withOpacity(0.8);
                        } else {
                          label = "Unlive: 0";
                          color = Colors.red.withOpacity(0.8);
                        }
                      }

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          label,
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
                          text: property.place ?? '-',
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
                          text: property.residenceCommercial ?? '-',
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
                          text: property.buyRent ?? '-',
                          backgroundColor: isDark ? Colors.orange.withOpacity(0.2) : Colors.orange.shade50,
                          textColor: isDark ? Colors.orange.shade200 : Colors.orange.shade800,
                          borderColor: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

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
                    property.propertyAddressForFieldworker ?? '-',
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
                    margin: const EdgeInsets.all(5.0),
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
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
            fontSize: 14,
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
              fontSize: 15,
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
    child: FittedBox(
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