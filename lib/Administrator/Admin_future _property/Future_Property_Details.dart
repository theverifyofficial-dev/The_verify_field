import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Future_Property_OwnerDetails_section/add_flat_form.dart';
import '../../Custom_Widget/constant.dart';
import '../../Custom_Widget/property_preview.dart';
import 'Admin_under_flats.dart';
import '../Update_Future_Property.dart';

class FutureProperty2 {
  final int id;
  final String images;
  final String ownerName;
  final String ownerNumber;
  final String caretakerName;
  final String caretakerNumber;
  final String place;
  final String buyRent;
  final String typeOfProperty;
  final String selectBhk;
  final String floorNumber;
  final String squareFeet;
  final String propertyNameAddress;
  final String buildingInformationFacilities;
  final String propertyAddressForFieldworker;
  final String ownerVehicleNumber;
  final String yourAddress;
  final String fieldworkerName;
  final String fieldworkerNumber;
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
  final String apartmentName; // optional
  final String facility;
  final String currentLocation; // optional
  final String residenceCommercial;
  final String localityList; // Added to match first code if needed

  FutureProperty2({
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
    required this.fieldworkerName,
    required this.fieldworkerNumber,
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
    required this.apartmentName,
    required this.facility,
    required this.currentLocation,
    required this.residenceCommercial,
    required this.localityList,
  });

  factory FutureProperty2.fromJson(Map<String, dynamic> json) {
    return FutureProperty2(
      id: json['id'] ?? 0,
      images: json['images']?.toString() ?? '',
      ownerName: json['ownername']?.toString() ?? '',
      ownerNumber: json['ownernumber']?.toString() ?? '',
      caretakerName: json['caretakername']?.toString() ?? '',
      caretakerNumber: json['caretakernumber']?.toString() ?? '',
      place: json['place']?.toString() ?? '',
      buyRent: json['buy_rent']?.toString() ?? '',
      typeOfProperty: json['typeofproperty']?.toString() ?? '',
      selectBhk: json['select_bhk']?.toString() ?? '',
      floorNumber: json['floor_number']?.toString() ?? '',
      squareFeet: json['sqyare_feet']?.toString() ?? '',
      propertyNameAddress: json['propertyname_address']?.toString() ?? '',
      buildingInformationFacilities: json['building_information_facilitys']?.toString() ?? '',
      propertyAddressForFieldworker: json['property_address_for_fieldworkar']?.toString() ?? '',
      ownerVehicleNumber: json['owner_vehical_number']?.toString() ?? '',
      yourAddress: json['your_address']?.toString() ?? '',
      fieldworkerName: json['fieldworkarname']?.toString() ?? '',
      fieldworkerNumber: json['fieldworkarnumber']?.toString() ?? '',
      currentDate: json['current_date_']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      roadSize: json['Road_Size']?.toString() ?? '',
      metroDistance: json['metro_distance']?.toString() ?? '',
      metroName: json['metro_name']?.toString() ?? '',
      mainMarketDistance: json['main_market_distance']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      lift: json['lift']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      totalFloor: json['total_floor']?.toString() ?? '',
      apartmentName: json['apartment_name']?.toString() ?? '',
      facility: json['facility']?.toString() ?? '',
      currentLocation: json['current_location']?.toString() ?? '',
      residenceCommercial: json['Residence_commercial']?.toString() ?? '',
      localityList: json['locality_list']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'images': images,
      'ownername': ownerName,
      'ownernumber': ownerNumber,
      'caretakername': caretakerName,
      'caretakernumber': caretakerNumber,
      'place': place,
      'buy_rent': buyRent,
      'typeofproperty': typeOfProperty,
      'select_bhk': selectBhk,
      'floor_number': floorNumber,
      'sqyare_feet': squareFeet,
      'propertyname_address': propertyNameAddress,
      'building_information_facilitys': buildingInformationFacilities,
      'property_address_for_fieldworkar': propertyAddressForFieldworker,
      'owner_vehical_number': ownerVehicleNumber,
      'your_address': yourAddress,
      'fieldworkarname': fieldworkerName,
      'fieldworkarnumber': fieldworkerNumber,
      'current_date_': currentDate,
      'longitude': longitude,
      'latitude': latitude,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'metro_name': metroName,
      'main_market_distance': mainMarketDistance,
      'age_of_property': ageOfProperty,
      'lift': lift,
      'parking': parking,
      'total_floor': totalFloor,
      'apartment_name': apartmentName,
      'facility': facility,
      'current_location': currentLocation,
      'Residence_commercial': residenceCommercial,
      'locality_list': localityList,
    };
  }
}

class Ground {
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
  final String squarefit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldworkarAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  // final String videoLink;
  final String fieldWorkerLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String subid;

  Ground({
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
    required this.squarefit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkarAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    // required this.videoLink,
    required this.fieldWorkerLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
  });

  factory Ground.fromJson(Map<String, dynamic> json) {
    return Ground(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeOfProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldworkarAddress: json['fieldworkar_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDate: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      // videoLink: json['video_link'] ?? '',
      fieldWorkerLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      subid: json['subid'] ?? '',
    );
  }
}

class DocumentMainModel_F {
  final String dimage;
  DocumentMainModel_F({
    required this.dimage,
  });
  factory DocumentMainModel_F.fromJson(Map<String, dynamic> json) {
    return DocumentMainModel_F(
      dimage: json['img'] ?? '',
    );
  }
}

class Administater_Future_Property_details extends StatefulWidget {
  final bool fromNotification;
  final String? buildingId;
  late final String? flatId;

  Administater_Future_Property_details({
    super.key,
    this.fromNotification = false,
    this.buildingId,
    this.flatId,
  });

  @override
  State<Administater_Future_Property_details> createState() => _Administater_Future_Property_detailsState();
}

class _Administater_Future_Property_detailsState extends State<Administater_Future_Property_details> {
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Stored data
  List<Ground> _groundList = [];
  List<Ground> _firstList = [];
  List<Ground> _secondList = [];
  List<Ground> _thirdList = [];
  List<Ground> _fourthList = [];
  List<Ground> _fifthList = [];
  List<Ground> _sixthList = [];
  List<Ground> _seventhList = [];
  List<FutureProperty2> _propertyList = [];
  List<DocumentMainModel_F> _imageList = [];

  // API Methods - Centralized
  Future<List<Ground>> _fetchGroundData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=G%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load Ground Floor');
    }
  }

  Future<List<Ground>> _fetchFirstData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=1%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load First Floor');
    }
  }

  Future<List<Ground>> _fetchSecondData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/second_floor_base_show_mainrealestae?Floor_=2%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load Second Floor');
    }
  }

  Future<List<Ground>> _fetchThirdData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=3%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load Third Floor');
    }
  }

  Future<List<Ground>> _fetchFourthData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=4%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load Fourth Floor');
    }
  }

  Future<List<Ground>> _fetchFifthData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=5%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load Fifth Floor');
    }
  }

  Future<List<Ground>> _fetchSixthData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=6%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load Sixth Floor');
    }
  }

  Future<List<Ground>> _fetchSeventhData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=7%20Floor&subid=${widget.buildingId}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      List<Ground> data = listResponse.map((data) => Ground.fromJson(data)).toList();
      return data.reversed.toList();
    } else {
      throw Exception('Failed to load Seventh Floor');
    }
  }

  Future<List<FutureProperty2>> _fetchPropertyData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_future_property_by_id?id=${widget.buildingId}");
    print(widget.buildingId);
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => FutureProperty2.fromJson(data)).toList();
    }
    else {
      throw Exception('Failed to load property data');
    }
  }

  Future<List<DocumentMainModel_F>> _fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_future_property_addimages_by_subid_?subid=${widget.buildingId}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return DocumentMainModel_F(
          dimage: item['img'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load carousel data');
    }
  }

  Future<void> _loadAllData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final results = await Future.wait([
        _fetchGroundData(),
        _fetchFirstData(),
        _fetchSecondData(),
        _fetchThirdData(),
        _fetchFourthData(),
        _fetchFifthData(),
        _fetchSixthData(),
        _fetchSeventhData(),
        _fetchPropertyData(),
        _fetchCarouselData(),
      ]);

      if (mounted) {
        setState(() {
          _groundList = results[0] as List<Ground>;
          _firstList = results[1] as List<Ground>;
          _secondList = results[2] as List<Ground>;
          _thirdList = results[3] as List<Ground>;
          _fourthList = results[4] as List<Ground>;
          _fifthList = results[5] as List<Ground>;
          _sixthList = results[6] as List<Ground>;
          _seventhList = results[7] as List<Ground>;
          _propertyList = results[8] as List<FutureProperty2>;
          _imageList = results[9] as List<DocumentMainModel_F>;
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error loading all data: $e");
      if (mounted) {
        setState(() {
          _hasError = true;
          _errorMessage = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshAllData() async {
    await _loadAllData();
  }

  void _handleNotification(Map<String, dynamic> payload) {
    if (payload.containsKey('flat_id')) {
      setState(() {
        widget.flatId = payload['flat_id'].toString();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Notification: ${message.data}");
      _handleNotification(message.data);
    });
    _loadAllData(); // Centralized fetch
  }

  void _handleMenuItemClick(String value) async {
    print("You clicked: $value");
    if (value == 'Edit Property') {
      if (_propertyList.isNotEmpty) {
        final property = _propertyList.first;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Update_FutureProperty(
              id: '${property.id}',
              ownername: '${property.ownerName}',
              ownernumber: '${property.ownerNumber}',
              caretakername: '${property.caretakerName}',
              caretakernumber: '${property.caretakerNumber}',
              place: '${property.place}',
              buy_rent: '${property.buyRent}',
              typeofproperty: '${property.typeOfProperty}',
              select_bhk: '${property.selectBhk}',
              floor_number: '${property.floorNumber}',
              sqyare_feet: '${property.squareFeet}',
              propertyname_address: '${property.propertyNameAddress}',
              building_information_facilitys: '${property.buildingInformationFacilities}',
              property_address_for_fieldworkar: '${property.propertyAddressForFieldworker}',
              owner_vehical_number: '${property.ownerVehicleNumber}',
              your_address: '${property.yourAddress}',
            ),
          ),
        );
      } else {
        Fluttertoast.showToast(
          msg: 'Property data not loaded',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    }
    if (value == 'Add Property Images') {
      Fluttertoast.showToast(
        msg: 'Add Property Images',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
    if (value == 'Delete Added Images') {
      Fluttertoast.showToast(
        msg: 'Delete Added Images',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _showCallDialog(BuildContext context, String number, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Call $type"),
        content: Text('Do you want to call $number?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              FlutterPhoneDirectCaller.callNumber(number);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, String number) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Contact Owner"),
        content: Text('Would you like to contact $number?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Cancel"),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Image.asset(AppImages.whatsaap, height: 36, width: 36),
                onPressed: () async {
                  Navigator.of(context).pop();
                  if (Platform.isAndroid) {
                    String url = 'whatsapp://send?phone=91$number&text=Hello';
                    await launchUrl(Uri.parse(url));
                  } else {
                    String url = 'https://wa.me/$number';
                    await launchUrl(Uri.parse(url));
                  }
                },
              ),
              IconButton(
                icon: Image.asset(AppImages.call, height: 36, width: 36),
                onPressed: () {
                  Navigator.of(context).pop();
                  FlutterPhoneDirectCaller.callNumber(number);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    if (_isLoading) {
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_hasError) {
      return Scaffold(
        backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _refreshAllData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : Colors.blue,
        elevation: 4,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            PhosphorIcons.caret_left_bold,
            color: isDarkMode ? Colors.white : Colors.black87,
            size: 30,
          ),
          padding: const EdgeInsets.all(8),
          constraints: const BoxConstraints(),
        ),
        title: Image.asset(AppImages.transparent, height: 45),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(), // Smoother physics
          slivers: [
            // Floor-wise Flats Sections - Now using stored data
            _buildFloorContentSliver("Ground Floor", _groundList, isDarkMode),
            _buildFloorContentSliver("First Floor", _firstList, isDarkMode),
            _buildFloorContentSliver("Second Floor", _secondList, isDarkMode),
            _buildFloorContentSliver("Third Floor", _thirdList, isDarkMode),
            _buildFloorContentSliver("Fourth Floor", _fourthList, isDarkMode),
            _buildFloorContentSliver("Fifth Floor", _fifthList, isDarkMode),
            _buildFloorContentSliver("Sixth Floor", _sixthList, isDarkMode),
            _buildFloorContentSliver("Seventh Floor", _seventhList, isDarkMode),
            // Property Images Carousel
            _buildImageCarouselSection(isDarkMode),
            // Property Overview Section
            _buildPropertyOverviewSection(isDarkMode),
            // Building Details Section
            _buildBuildingDetailsSection(isDarkMode),
            // Add spacing at the bottom
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  // Floor Section - Now direct content sliver using stored data
  SliverToBoxAdapter _buildFloorContentSliver(String floorName, List<Ground> flats, bool isDarkMode) {
    if (flats.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) * 0.65;

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration:  BoxDecoration(
                      color: Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      floorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      "${flats.length} flats",
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: cardWidth * 1.2,
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: flats.length,
                itemBuilder: (context, index) {
                  final flat = flats[index];
                  final isHighlighted = widget.flatId != null && widget.flatId == flat.id.toString();
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Admin_underflat_futureproperty(
                              id: '${flat.id}',
                              Subid: '${flat.subid}',
                            ),
                          ),
                        );
                      },
                      child: SizedBox(
                        width: cardWidth,
                        child: Card(
                          color: Colors.white,
                          elevation: isHighlighted ? 4 : 2,
                          shape: RoundedRectangleBorder(
                            side: isHighlighted ? const BorderSide(color: Colors.red, width: 2) : BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                flex: 3,
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    topRight: Radius.circular(12),
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: flat.propertyPhoto.isNotEmpty
                                        ? "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${flat.propertyPhoto}"
                                        : "",
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Container(
                                      color: Colors.grey[200],
                                      child: const Center(child: CircularProgressIndicator()),
                                    ),
                                    errorWidget: (context, error, stackTrace) => Container(
                                      color: Colors.grey[200],
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.home_outlined, size: 40, color: Colors.grey),
                                          const SizedBox(height: 4),
                                          Text("No Image", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${flat.bhk} • ${flat.typeOfProperty}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (flat.flatNumber.isNotEmpty)
                                            Text(
                                              "Flat ${flat.flatNumber}",
                                              style: const TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                              ),
                                            ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                flat.locations.isNotEmpty ? flat.locations : "No location",
                                                style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              flat.id != 0 ? "ID: ${flat.id}" : "N/A",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.purple,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.blue[50],
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: Colors.blue[100]!),
                                            ),
                                            child: Text(
                                              flat.buyRent.isNotEmpty ? flat.buyRent : "N/A",
                                              style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.blue[700],
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Text(
                                            "₹${flat.showPrice.isNotEmpty ? flat.showPrice : "0"}",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.green,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Image Carousel Section - Using stored data
  SliverToBoxAdapter _buildImageCarouselSection(bool isDarkMode) {
    if (_imageList.isEmpty) {
      return SliverToBoxAdapter(
        child: Container(
          height: 180,
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.photo_library, size: 50, color: isDarkMode ? Colors.black87 : Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                "No Images Available",
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.black87 : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CarouselSlider(
            options: CarouselOptions(
              height: 250,
              enlargeCenterPage: true,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              enableInfiniteScroll: true,
              viewportFraction: 0.9,
              aspectRatio: 16 / 9,
              scrollPhysics: const BouncingScrollPhysics(),
            ),
            items: _imageList.map((item) {
              return Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PropertyPreview(
                            ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          key: ValueKey(item.dimage),
                          imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, color: Colors.grey, size: 40),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  // Property Overview Section - Using stored data
  SliverToBoxAdapter _buildPropertyOverviewSection(bool isDarkMode) {
    if (_propertyList.isEmpty) {
      return SliverToBoxAdapter(child: _buildErrorCard(isDarkMode));
    }

    final property = _propertyList[0];
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (property.place.isNotEmpty) _buildChip(property.place, Colors.blue, isDarkMode),
                if (property.residenceCommercial.isNotEmpty) _buildChip(property.residenceCommercial, Colors.green, isDarkMode),
                if (property.buyRent.isNotEmpty) _buildChip(property.buyRent, Colors.orange, isDarkMode),
                if (property.typeOfProperty.isNotEmpty) _buildChip(property.typeOfProperty, Colors.purple, isDarkMode),
              ],
            ),
            const SizedBox(height: 16),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Icon(Icons.location_on, color: Colors.red[400], size: 20),
            //     const SizedBox(width: 8),
            //     Expanded(
            //       child: Text(
            //         property.propertyNameAddress.isNotEmpty
            //             ? property.propertyNameAddress
            //             : "No address available",
            //         style: const TextStyle(
            //           fontSize: 15,
            //           fontWeight: FontWeight.w600,
            //           color: Colors.black87,
            //         ),
            //         maxLines: 2,
            //         overflow: TextOverflow.ellipsis,
            //       ),
            //     ),
            //   ],
            // ),
            // const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    _buildStatItem("Total Floors", property.totalFloor, Icons.stairs, isDarkMode),
                    _buildStatItem("Road Size", property.roadSize, Icons.aod, isDarkMode),
                    _buildStatItem("Age", property.ageOfProperty, Icons.calendar_today, isDarkMode),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Building Details Section - Using stored data
  SliverToBoxAdapter _buildBuildingDetailsSection(bool isDarkMode) {
    if (_propertyList.isEmpty) {
      return SliverToBoxAdapter(child: _buildErrorCard(isDarkMode));
    }

    final property = _propertyList[0];
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.business, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text(
                  "Building Details",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // _buildContactSection(property, isDarkMode),
            // const SizedBox(height: 20),
            _buildSpecificationsSection(property, isDarkMode),
            // const SizedBox(height: 20),
            // _buildLocationSection(property, isDarkMode),
          ],
        ),
      ),
    );
  }

  // Contact Section
  Widget _buildContactSection(FutureProperty2 property, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Information",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        if (property.ownerName.isNotEmpty || property.ownerNumber.isNotEmpty)
          _buildContactCard(
            "Owner",
            property.ownerName,
            property.ownerNumber,
            Icons.person,
            Colors.blue,
            isDarkMode,
          ),

      ],
    );
  }

  // Contact Card
  Widget _buildContactCard(String title, String name, String number, IconData icon, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name.isNotEmpty ? name : "Not available",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (number.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () => _showContactDialog(context, number),
                    child: Text(
                      number,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (number.isNotEmpty)
            IconButton(
              onPressed: () => _showCallDialog(context, number, title),
              icon: Icon(Icons.phone, color: color, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  // Specifications Section
  Widget _buildSpecificationsSection(FutureProperty2 property, bool isDarkMode) {
    final specifications = [
      {"icon": Icons.train, "label": "Metro Station", "value": property.metroName},
      {"icon": Icons.place, "label": "Metro Distance", "value": property.metroDistance},
      {"icon": Icons.shopping_cart, "label": "Market Distance", "value": property.mainMarketDistance},
      {"icon": Icons.elevator, "label": "Lift", "value": property.lift},
      {"icon": Icons.local_parking, "label": "Parking", "value": property.parking},
      {"icon": Icons.local_parking, "label": "", "value": property.localityList},
    ].where((spec) => (spec["value"] as String).isNotEmpty).toList();
    if (specifications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "No specifications available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "Specifications",
        //   style: TextStyle(
        //     fontSize: 15,
        //     fontWeight: FontWeight.w600,
        //     color: Colors.black87,
        //   ),
        // ),
        // const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
              ),
              itemCount: specifications.length,
              itemBuilder: (context, index) {
                final spec = specifications[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(spec["icon"] as IconData, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              spec["label"] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spec["value"] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
        ),
      ],
    );
  }

  // Location Section
  Widget _buildLocationSection(FutureProperty2 property, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (property.propertyNameAddress.isNotEmpty)
                _buildLocationItem("Property Address", property.propertyNameAddress, isDarkMode),
              if (property.propertyNameAddress.isNotEmpty) const SizedBox(height: 8),
              if (property.propertyAddressForFieldworker.isNotEmpty)
                _buildLocationItem("Field Worker Address", property.propertyAddressForFieldworker, isDarkMode),
              if (property.propertyAddressForFieldworker.isNotEmpty) const SizedBox(height: 8),
              if (property.yourAddress.isNotEmpty)
                _buildLocationItem("Current Location", property.yourAddress, isDarkMode, isClickable: true),
            ],
          ),
        ),
      ],
    );
  }

  // Location Item
  Widget _buildLocationItem(String label, String value, bool isDarkMode, {bool isClickable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label == "Current Location")
              Icon(
                Icons.location_on,
                color: Colors.red,
                size: 26,
              ),
            if (label == "Current Location") const SizedBox(width: 4),
            Expanded(
              child: isClickable
                  ? GestureDetector(
                onTap: () async {
                  final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(value)}");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
                  : Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            "Unable to load property details",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}