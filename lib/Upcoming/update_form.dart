import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/provider/Theme_provider.dart';
import 'package:verify_feild_worker/provider/main_RealEstate_provider.dart';
import 'package:verify_feild_worker/provider/multile_image_upload_provider.dart';
import 'package:verify_feild_worker/provider/real_Estate_Show_Data_provider.dart';
import '../../provider/property_id_for_multipleimage_provider.dart';
import '../Administrator/Add_Assign_Tenant_Demand/Feild_Workers_Bylocation.dart';
import '../Custom_Widget/constant.dart';
import '../model/realestateSlider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class Catid {
  final int id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeofProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squarefit;
  final String maintenance;
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
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishing;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String caretakerName;
  final String caretakerNumber;
  final int subid;

  Catid({
    required this.id,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeofProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squarefit,
    required this.maintenance,
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
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishing,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.subid,
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeofProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintenance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldWorkerAddress: json['fieldworkar_address'] ?? '',
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
      furnishing: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerCurrentLocation: json['field_worker_current_location'] ?? '',
      caretakerName: json['care_taker_name'] ?? '',
      caretakerNumber: json['care_taker_number'] ?? '',
      subid: int.tryParse(json['subid'].toString()) ?? 0,
    );
  }
}

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class UpdateForm extends StatefulWidget {
  final int propertyId;

  const UpdateForm({super.key, required this.propertyId});

  @override
  State<UpdateForm> createState() => _UpdateRealEstatePropertyState();
}

class _UpdateRealEstatePropertyState extends State<UpdateForm> {
  final _formKey = GlobalKey<FormState>();

  String? _location;
  String _buyOrRent = 'Buy';
  String _resOrComm = 'Residential';
  String? _propertyType;
  String? _bhk;
  String? _customBhk;
  String? _price;
  String? _floor;
  String? _balcony;
  String? _squareFeet;
  String? _maintenance;
  String? _customMaintenance;
  String? _buildingInfo;
  String? _propertyAge;
  String? _kitchenType;
  DateTime? _flatAvailableDate;
  String? _lift;
  String? _furnishing;
  String? _bathroom;
  String? _customParking;
  String? _totalFloor;
  String? _loan;

  String? _registryAndGpa;
  String? _furnished;

  late TextEditingController _locationController;
  late TextEditingController _propertyTypeController;
  late TextEditingController _bhkController;
  late TextEditingController _floorController;
  late TextEditingController _balconyController;
  late TextEditingController _maintenanceController;
  late TextEditingController _squareFeetController;
  late TextEditingController _propertyAgeController;
  late TextEditingController _buildingInfoController;
  late TextEditingController _parkingController;
  late TextEditingController _priceController;
  late TextEditingController _askingPriceController;
  late TextEditingController _lastPriceController;

  late TextEditingController _fieldWorkerAddressController;
  late TextEditingController _flatNumberController;
  late TextEditingController _apartmentAddressController;
  late TextEditingController _facilityController;
  late TextEditingController _roadSizeController;
  late TextEditingController _nearMetroController;
  late TextEditingController _highwayController;
  late TextEditingController _mainMarketController;
  late TextEditingController _houseMeterController;
  late TextEditingController _ownerNameController;
  late TextEditingController _careTakerNumberController;
  late TextEditingController _careTakerNameController;
  late TextEditingController _totalFloorController;
  late TextEditingController _ownerNumberController;
  final TextEditingController _flatAvailableController = TextEditingController();
  final TextEditingController _terraceGardenController = TextEditingController();
  final TextEditingController _propertyNumberController = TextEditingController();
  final TextEditingController _fieldWorkerNameController = TextEditingController();
  final TextEditingController _fieldWorkerNumberController = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController furnitureController = TextEditingController();
  String? apiApartmentName;
  final TextEditingController _videoLinkController = TextEditingController();

  String? _parking, _houseMeter;
  String full_address = '';
  File? _imageFile;
  String? _networkImageUrl;
  String? apiImageUrl;
  File? _imageFile2;
  final cities = ['SultanPur', 'ChhattarPur', 'Aya Nagar', 'Ghitorni', 'Rajpur Khurd','Mangalpuri','Dwarka Mor','Uttam Nagar','Nawada',''];

  final propertyTypes = ["Flat","Shop","Office","Godown","Farms","Plots",''];
  final bhkOptions = ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '1 RK', 'Commercial',''];
  final floors = [
    'G Floor',
    '1 Floor',
    '2 Floor',
    '3 Floor',
    '4 Floor',
    '5 Floor',
    '6 Floor',
    '7 Floor',
    '8 Floor',
    '9 Floor',
    '10 Floor',
    ''
  ];

  String _formattedLastPrice = '';
  String _formattedPrice = '';
  String _formattedAskingPrice = '';

  void _loadSavedFieldWorkerData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('name') ?? '';
    final savedNumber = prefs.getString('number') ?? '';

    setState(() {
      _fieldWorkerNameController.text = savedName;
      _fieldWorkerNumberController.text = savedNumber;
    });
  }

  void _loadSavedLatLong() async {
    final latLong = await getSavedLatLong();
    setState(() {
      _latitude = latLong['Latitude'] ?? '';
      _longitude = latLong['Longitude'] ?? '';
    });
  }

  String _latitude = '';
  String _longitude = '';

  Future<Map<String, String>> getSavedLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('latitude')?.toString() ?? '';
    final long = prefs.getDouble('longitude')?.toString() ?? '';
    return {
      'Latitude': lat,
      'Longitude': long,
    };
  }
  String formatPrice(int value) {
    if (value >= 10000000) {
      return '${(value / 10000000).toStringAsFixed(2)}Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(2)}L';
    } else {
      return value.toString();
    }
  }

  DateTime? _lastContinuePressTime;

  bool _hasSubmitted = false;
  Future<void> _checkAndSubmitContinue() async {
    if (_hasSubmitted) return;
    _hasSubmitted = true;

    await _submitForm();

    _hasSubmitted = false;
  }


  @override
  void initState() {
    super.initState();

    autofillFormFields();
    _loadSavedLatLong();
    fetchAndSetData();

    Future.microtask(() async {
      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId();
      _loadSavedFieldWorkerData();
    });

    _priceController = TextEditingController(text: _price ?? '');
    _priceController.addListener(() {
      final input = _priceController.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);
      setState(() {
        _formattedPrice = number != null ? formatPrice(number) : '';
      });
    });
    _askingPriceController = TextEditingController(text: _price ?? '');
    _askingPriceController.addListener(() {
      final input = _askingPriceController.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);

      setState(() {
        _formattedAskingPrice = number != null ? formatPrice(number) : '';
      });
    });

    _lastPriceController = TextEditingController(text: _price ?? '');
    _lastPriceController.addListener(() {
      final input = _lastPriceController.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);

      setState(() {
        _formattedLastPrice = number != null ? formatPrice(number) : '';
      });
    });

    _locationController = TextEditingController(text: _location ?? '');
    _propertyTypeController = TextEditingController(text: _propertyType ?? '');
    _bhkController = TextEditingController(text: _bhk ?? '');
    _floorController = TextEditingController(text: _floor ?? '');
    _balconyController = TextEditingController(text: _balcony ?? '');
    _maintenanceController = TextEditingController(text: _maintenance ?? '');
    _squareFeetController = TextEditingController(text: _squareFeet ?? '');
    _propertyAgeController = TextEditingController(text: _propertyAge ?? '');
    _buildingInfoController = TextEditingController(text: _buildingInfo ?? '');
    _parkingController = TextEditingController(text: _customParking ?? '');
    _fieldWorkerAddressController = TextEditingController();
    _flatNumberController = TextEditingController();
    _roadSizeController = TextEditingController();
    _nearMetroController = TextEditingController();
    _highwayController = TextEditingController();
    _mainMarketController = TextEditingController();
    _houseMeterController = TextEditingController();
    _ownerNameController = TextEditingController();
    _ownerNumberController = TextEditingController();
    _totalFloorController = TextEditingController();
    _apartmentAddressController = TextEditingController();
    _facilityController = TextEditingController();
    _careTakerNameController = TextEditingController();
    _careTakerNumberController = TextEditingController();

    furnitureController.text = apiApartmentName ?? '';
    _flatAvailableController.text = _flatAvailableDate != null
        ? DateFormat('yyyy-MM-dd').format(_flatAvailableDate!)
        : '';

    _terraceGardenController.text = '';
    _propertyNumberController.text = '';
    _askingPriceController.text = '';
    _lastPriceController.text = '';
    _fieldWorkerNameController.text = '';
    _fieldWorkerNumberController.text = '';

    if (_furnishing != null &&
        (_furnishing == 'Fully Furnished' || _furnishing == 'Semi Furnished')) {
      _selectedFurniture = parseFurnitureString(furnitureController.text);
    } else {
      _selectedFurniture.clear();
      furnitureController.clear();
    }
  }


  bool _isLoading = true;

  void autofillFormFields() async {
    try {
      final dataList = await fetchData();
      if (dataList.isNotEmpty) {
        final data = dataList.first;

        _locationController.text = data.locations;
        _flatNumberController.text = data.flatNumber;
        _buyOrRent = data.buyRent;
        _resOrComm = data.residenceCommercial;
        _apartmentAddressController.text = data.apartmentAddress;
        _propertyType = data.typeofProperty;
        _bhk = data.bhk;
        _priceController.text = data.showPrice;
        _lastPriceController.text = data.lastPrice;
        _askingPriceController.text = data.askingPrice;
        _floor = data.floor;
        _totalFloorController.text = data.totalFloor;
        _loan = data.loan;
        _registryAndGpa = data.registryAndGpa;
        _propertyTypeController.text = data.typeofProperty;
        _videoLinkController.text = data.videoLink;
        _bhkController.text = data.bhk;
        _floorController.text = data.floor;
        _balconyController.text = data.balcony;
        _maintenanceController.text = data.maintenance;
        _propertyAgeController.text = data.ageOfProperty;
        _balcony = data.balcony;
        _squareFeetController.text = data.squarefit;
        apiApartmentName = data.apartmentName;
        if (data.availableDate != null &&
            data.availableDate.trim().isNotEmpty &&
            data.availableDate.toLowerCase() != 'N/A') {
          try {
            DateTime parsedDate = DateTime.parse(data.availableDate);
            String formattedDate = DateFormat('dd-MM-yyyy').format(parsedDate);
            _flatAvailableController.text = formattedDate;
          } catch (e) {
            // If parsing fails, set to empty or default
            _flatAvailableController.text = '';
            print("Invalid date format: ${data.availableDate}");
          }
        } else {
          _flatAvailableController.text = '';
        }

        _maintenance = data.maintenance;
        _parking = data.parking;
        _propertyAge = data.ageOfProperty;
        _fieldWorkerAddressController.text = data.fieldWorkerAddress;
        _roadSizeController.text = data.roadSize;
        _nearMetroController.text = data.metroDistance;
        _highwayController.text = data.highwayDistance;
        _mainMarketController.text = data.mainMarketDistance;
        _houseMeter = data.meter;
        _ownerNameController.text = data.ownerName;
        _ownerNumberController.text = data.ownerNumber;
        _flatAvailableDate = DateTime.tryParse(data.availableDate) ?? null;
        _kitchenType = data.kitchen;
        _bathroom = data.bathroom;
        _lift = data.lift;
        _facilityController.text = data.facility;
        parseFurnishingFromApi(data.furnishing ?? '');
        // _customMaintenanceController.text = data.maintenance;
        // _customMaintenance = data.maintenance;
        _furnished = data.furnishing;
        String furnitureString = data.apartmentName; // "Bed(1), Sofa(2), Chair(4)"
        _selectedFurniture = parseFurnitureString(furnitureString);
        _fieldWorkerNumberController.text = data.fieldWorkerNumber;
        _registryAndGpa = data.registryAndGpa;
        _careTakerNameController.text = data.caretakerName;
        _careTakerNumberController.text = data.caretakerNumber;
        _Google_Location.text = data.fieldWorkerCurrentLocation;
        _networkImageUrl =
            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/" +
                data.propertyPhoto; // or whatever the field name is

        double? latitude = double.tryParse(data.latitude);
        double? longitude = double.tryParse(data.longitude);

        setState(() {
          _isLoading = false;
        });
      }
    }
    catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  Map<String, int> parseFurnitureString(String furnitureString) {
    if (furnitureString.isEmpty) return {};

    final Map<String, int> furnitureMap = {};

    furnitureString.split(',').forEach((item) {
      item = item.trim(); // remove extra spaces
      final match = RegExp(r'(.+)\((\d+)\)').firstMatch(item);
      if (match != null) {
        final name = match.group(1)?.trim() ?? '';
        final count = int.tryParse(match.group(2) ?? '0') ?? 0;
        if (name.isNotEmpty) {
          furnitureMap[name] = count;
        }
      }
    });

    return furnitureMap;
  }


  Future<List<Catid>> fetchData() async {
    var url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_details_urgent_flat.php?P_id=${widget.propertyId.toString()}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded['data'] is List) {
        final dataList = decoded['data'] as List;
        return dataList.map((data) => Catid.fromJson(data)).toList();
      } else {
        throw Exception('Unexpected JSON format');
      }
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }


  Future<void> fetchAndSetData() async {
    try {
      // 📥 Get API data
      final apiDataList = await fetchData();

      if (apiDataList.isNotEmpty) {
        final apiData = apiDataList[0]; // Take first if list is not empty
        _Google_Location.text = apiData.fieldWorkerCurrentLocation;
      } else {
        _Google_Location.text = 'No location found from API';
      }

      // 📍 Get saved lat/long
      final saved = await getSavedLatLong();
      print("Latitude: ${saved['Latitude']}");
      print("Longitude: ${saved['Longitude']}");

      _Google_Location.text +=
      "\nSaved: ${saved['Latitude']}, ${saved['Longitude']}";
    } catch (e) {
      print("Error: $e");
      _Google_Location.text = 'Error loading location';
    }
  }

  void parseFurnishingFromApi(String apiString) {
    if (apiString.isEmpty || apiString == 'Unfurnished') {
      _furnishing = 'Unfurnished';
      _selectedFurniture.clear();
      furnitureController.text = '';
      return;
    }

    // Extract furnishing type (Fully/Semi)
    final furnishingType = apiString
        .split('(')
        .first
        .trim();

    // Match dropdown options
    if (furnishingOptions.contains(furnishingType)) {
      _furnishing = furnishingType;
    } else {
      // fallback if API gives unknown type
      _furnishing = null;
    }

    // Extract furniture items if present
    final furnitureMap = <String, int>{};
    final matches = RegExp(r'([\w\s]+)\((\d+)\)').allMatches(apiString);
    for (final m in matches) {
      final name = m.group(1)!.trim();
      final count = int.parse(m.group(2)!);
      furnitureMap[name] = count;
    }

    _selectedFurniture = furnitureMap;

    // Update text controller to show API data
    furnitureController.text = furnitureMap.entries
        .map((e) => '${e.key} (${e.value})')
        .join(', ');

    setState(() {}); // refresh UI to show selected furnishing
  }


  List<String> allFacilities = [
    'CCTV Camera',
    'Parking',
    'Security',
    'Terrace Garden',
    "Gas Pipeline "
        ''
  ];
  List<String> selectedFacilities = [];



  @override
  void dispose() {
    _apartmentAddressController.dispose();
    _priceController.dispose();
    _askingPriceController.dispose();
    _lastPriceController.dispose();
    _locationController.dispose();
    _propertyTypeController.dispose();
    _bhkController.dispose();
    _floorController.dispose();
    _balconyController.dispose();
    _maintenanceController.dispose();
    _parkingController.dispose();
    _buildingInfoController.dispose();
    _fieldWorkerAddressController.dispose();
    _roadSizeController.dispose();
    _nearMetroController.dispose();
    _highwayController.dispose();
    _mainMarketController.dispose();
    _houseMeterController.dispose();
    _ownerNameController.dispose();
    _ownerNumberController.dispose();
    _totalFloorController.dispose();
    _facilityController.dispose();
    _careTakerNameController.dispose();
    _careTakerNumberController.dispose();
    super.dispose();
  }

  final List<String> _metroOptions = [
    'Hauz khas', 'Malviya Nagar', 'Saket','Qutub Minar','ChhattarPur','Sultanpur', 'Ghitorni','Arjan Garh','Guru Drona','Sikanderpur','Dwarka Mor',''
  ];
  Map<String, int> _selectedFurniture = {};
  final List<String> furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
    ''
  ];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

    if (pickedFile != null) {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 40,
        minWidth: 800,
        minHeight: 800,
      );

      if (compressedBytes == null) {
        print('❌ Image compression failed');
        return;
      }

      final kbSize = compressedBytes.lengthInBytes / 1024;
      print('✅ Compressed image size: ${kbSize.toStringAsFixed(2)} KB');

      final tempDir = Directory.systemTemp;
      final compressedFile = await File('${tempDir.path}/${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg')
          .writeAsBytes(compressedBytes);

      setState(() {
        _imageFile = compressedFile;
      });

      print("✅ Image path: ${compressedFile.path}");
    } else {
      print('❌ No image selected.');
    }
  }

  Future<void> uploadCompressedImage(File imageFile) async {
    final uri = Uri.parse(
        "https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php");

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'User-Agent': 'VerifyApp/1.0',
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'property_photo',
        imageFile.path,
        filename: imageFile.path
            .split('/')
            .last,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("✅ Status code: ${response.statusCode}");
      print("✅ Response body: ${response.body}");

      if (response.statusCode != 200) {
        // Handle common errors
        print("❌ Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Upload error: $e");
    }
  }

  final ImagePicker _MultiPicker = ImagePicker();
  List<XFile> _images = [];

  Future<void> pickMultipleImages() async {
    try {
      final List<XFile> pickedImages = await _MultiPicker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        setState(() {
          _images = pickedImages;
        });
        print("Picked ${_images.length} images");
      } else {
        print("No images selected.");
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
        actions: [
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              // physics: NeverScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 10),

                // Location (read-only)
                _buildReadOnlyField(
                  label: "Select Location",
                  controller: _locationController,
                  onTap: () =>
                      _showBottomSheet(
                        options: cities,
                        onSelected: (val) {
                          setState(() {
                            _location = val;
                            _locationController.text = val;
                          });
                        },
                      ),
                  validator: (val) =>
                  val == null || val.isEmpty ? "Please select location" : null,
                ),
                const SizedBox(height: 16),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Purpose Selection (with validation)
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        if (_buyOrRent?.isEmpty ?? true) {
                          return "Please select a purpose";
                        }
                        return null;
                      },
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Purpose:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ChoiceChip(
                                  label: const Text("Buy"),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: _buyOrRent == 'Buy'
                                        ? Colors.white
                                        : Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                  selectedColor: Colors.blueAccent,
                                  backgroundColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .surface,
                                  selected: _buyOrRent == 'Buy',
                                  onSelected: (_) {
                                    setState(() {
                                      _buyOrRent = 'Buy';
                                      state.didChange(
                                          'Buy'); // ✅ update FormField
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text("Rent"),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: _buyOrRent == 'Rent'
                                        ? Colors.white
                                        : Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .color,
                                  ),
                                  selectedColor: Colors.blueAccent,
                                  backgroundColor: Theme
                                      .of(context)
                                      .colorScheme
                                      .surface,
                                  selected: _buyOrRent == 'Rent',
                                  onSelected: (_) {
                                    setState(() {
                                      _buyOrRent = 'Rent';
                                      state.didChange(
                                          'Rent'); // ✅ update FormField
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 5),
                                child: Text(
                                  state.errorText!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ✅ Show only when "Buy" is selected
                    if (_buyOrRent == 'Buy') ...[
                      // Registry or GPA (❌ no validation here)
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          const Text(
                            "Registry or GPA:",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          ChoiceChip(
                            label: const Text("Registry"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _registryAndGpa == 'Registry'
                                  ? Colors.white
                                  : Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .surface,
                            selected: _registryAndGpa == 'Registry',
                            onSelected: (_) {
                              setState(() {
                                _registryAndGpa = 'Registry';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: const Text("GPA"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _registryAndGpa == 'GPA'
                                  ? Colors.white
                                  : Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .surface,
                            selected: _registryAndGpa == 'GPA',
                            onSelected: (_) {
                              setState(() {
                                _registryAndGpa = 'GPA';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Loan Availability (❌ no validation here)
                      Row(
                        children: [
                          const Text(
                            "Loan availability?",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text("Yes"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _loan == 'Yes'
                                  ? Colors.white
                                  : Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .surface,
                            selected: _loan == 'Yes',
                            onSelected: (_) {
                              setState(() {
                                _loan = 'Yes';
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("No"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _loan == 'No'
                                  ? Colors.white
                                  : Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme
                                .of(context)
                                .colorScheme
                                .surface,
                            selected: _loan == 'No',
                            onSelected: (_) {
                              setState(() {
                                _loan = 'No';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                // Category: Residential or Commercial
                FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_resOrComm?.isEmpty ?? true) {
                      return "Please select a category";
                    }
                    return null;
                  },
                  builder: (field) =>
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              const Text(
                                "Category:",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              ChoiceChip(
                                label: Text(
                                  "Residential",
                                  style: TextStyle(
                                    color: _resOrComm == 'Residential'
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                selectedColor: Colors.blueAccent,
                                backgroundColor: Colors.grey.shade200,
                                selected: _resOrComm == 'Residential',
                                onSelected: (_) {
                                  setState(() => _resOrComm = 'Residential');
                                  field.didChange(_resOrComm); // ✅ important
                                },
                              ),
                              ChoiceChip(
                                label: Text(
                                  "Commercial",
                                  style: TextStyle(
                                    color: _resOrComm == 'Commercial'
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                selectedColor: Colors.blueAccent,
                                backgroundColor: Colors.grey.shade200,
                                selected: _resOrComm == 'Commercial',
                                onSelected: (_) {
                                  setState(() => _resOrComm = 'Commercial');
                                  field.didChange(_resOrComm); // ✅ important
                                },
                              ),
                            ],
                          ),
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 5),
                              child: Text(
                                field.errorText ?? "",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    // Property Type
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Property Type",
                        controller: _propertyTypeController,
                        onTap: () =>
                            _showBottomSheet(
                              options: propertyTypes,
                              onSelected: (val) {
                                setState(() {
                                  _propertyType = val;
                                  _propertyTypeController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select property type"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12), // space between the two fields
                    // BHK
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "BHK",
                        controller: _bhkController,
                        onTap: () =>
                            _showBottomSheet(
                              options: bhkOptions,
                              onSelected: (val) {
                                setState(() {
                                  _bhk = val;
                                  _bhkController.text = val;
                                  if (val != 'Custom') {
                                    _customBhk = null;
                                  }
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select BHK" : null,
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 16),

                // Custom BHK TextField only visible if 'Custom' selected
                if (_bhk == 'Custom')
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter custom BHK",
                      labelStyle: TextStyle(
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.blue.shade200
                              : Colors.blue.shade300,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                      filled: true,
                      fillColor: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _customBhk = val,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    validator: (val) =>
                    _bhk == 'Custom' && (val == null || val.isEmpty)
                        ? "Enter custom BHK value"
                        : null,
                  ),
                if (_bhk == 'Custom')
                  const SizedBox(height: 16),

                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _buyOrRent == 'Buy'
                        ? "Selling Price (₹)"
                        : "Rent Price (₹)",
                    suffix: _formattedPrice.isNotEmpty
                        ? Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        _formattedPrice,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : null,

                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.blue.shade200
                              : Colors.blue.shade300,
                          width: 2),
                    ),
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.white,
                  ),
                  validator: (val) => val == null || val.isEmpty ? "Enter price" : null,
                ),
                const SizedBox(height: 16),
                // Asking Price
                TextFormField(
                  controller: _askingPriceController,
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? "Enter Asking Price (₹) by owner" : null,

                  decoration: _buildInputDecoration(
                    context,
                    "Asking Price (₹) by owner",
                  ).copyWith(
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        _formattedAskingPrice ?? '',  // This should be a String variable updated by your listener
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _lastPriceController,
                  keyboardType: TextInputType.number,
                  validator: (val) => val == null || val.isEmpty ? "Enter Last Price (₹) by owner" : null,

                  decoration: _buildInputDecoration(
                    context,
                    "Last Price (₹) by owner",
                  ).copyWith(
                    suffix: Text(
                      _formattedLastPrice,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                //flatNumber
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _flatNumberController,
                  decoration: _buildInputDecoration(context, "Flat Number"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter Flat number"
                      : null,
                ),
                const SizedBox(height: 16),
                // Property Number
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   controller: _propertyNumberController,
                //   decoration: _buildInputDecoration(context, "Property Number"),
                // ),

                // const SizedBox(height: 16),

                // const SizedBox(height: 16),
                //_apartmentAddressController
                TextFormField(
                  controller: _apartmentAddressController,
                  decoration: _buildInputDecoration(
                      context, "Apartment Name & Address"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter Apartment Name & Address "
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _facilityController,
                  readOnly: true,
                  // Prevents manual editing
                  onTap: _showFacilitySelectionDialog,
                  // Opens the selection dialog
                  decoration: _buildInputDecoration(context, "Facility"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter Facility1+"
                      ""
                      : null,
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Floor",
                        controller: _floorController,
                        onTap: () =>
                            _showBottomSheet(
                              options: floors,
                              onSelected: (val) {
                                setState(() {
                                  _floor = val;
                                  _floorController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select floor" : null,
                      ),
                    ),
                    const SizedBox(width: 12),


                    // Total Floor Dropdown
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Total Floor",
                        controller: _totalFloorController,
                        onTap: () => _showBottomSheet(
                          options: [
                            'G Floor',
                            '1 Floor',
                            '2 Floor',
                            '3 Floor',
                            '4 Floor',
                            '5 Floor',
                            '6 Floor',
                            '7 Floor',
                            '8 Floor',
                            '9 Floor',
                            '10 Floor',
                          ],
                          onSelected: (val) {
                            setState(() {
                              _totalFloorController.text = val; // ✅ only use controller
                            });
                          },
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select total floor" : null, // ✅ no _totalFloor check
                      ),
                    ),

                  ],
                ),

                const SizedBox(height: 16),

                // Square Feet
                Row(
                  children: [
                    // Square Feet TextFormField
                    Expanded(
                      // flex: 2,
                      child: TextFormField(
                        controller: _squareFeetController,
                        decoration: InputDecoration(
                          labelText: "Square Feet (sq.ft)",
                          labelStyle: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? Colors.grey.shade300
                                : Colors.black54,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade300,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 14),
                          filled: true,
                          fillColor: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.grey.shade900
                              : Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        onSaved: (val) => _squareFeet = val,
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Enter square feet"
                            : null,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Balcony",
                        controller: _balconyController,
                        onTap: () =>
                            _showBottomSheet(
                              options: ['Front Side Balcony', 'Back Side Balcony','Side','Window', 'Park Facing', 'Road Facing', 'Corner', 'No Balcony','',],
                              onSelected: (val) {
                                setState(() {
                                  _balcony = val;
                                  _balconyController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        _balcony == null || _balcony!.isEmpty
                            ? "Select balcony"
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Maintenance",
                        controller: _maintenanceController,
                        onTap: () =>
                            _showBottomSheet(
                              options: ['Included', 'Custom',''],
                              onSelected: (val) {
                                setState(() {
                                  _maintenance = val;
                                  _maintenanceController.text = val;
                                  if (val != 'Custom')
                                    _customMaintenance = null;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select maintenance"
                            : null,
                      ),
                    ),


                    /// Custom maintenance fee field
                    if (_maintenance == 'Custom')

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Enter Maintenance Fee",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Theme
                                    .of(context)
                                    .brightness == Brightness.dark
                                    ? Colors.grey.shade300
                                    : Colors.black54,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme
                                      .of(context)
                                      .brightness == Brightness.dark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme
                                      .of(context)
                                      .brightness == Brightness.dark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(
                                  color: Theme
                                      .of(context)
                                      .brightness == Brightness.dark
                                      ? Colors.blue.shade200
                                      : Colors.blue.shade300,
                                  width: 2,
                                ),
                              ),
                              contentPadding:
                              const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 14),
                              filled: true,
                              fillColor: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.grey.shade900
                                  : Colors.white,
                            ),
                            style: TextStyle(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            keyboardType: TextInputType.number,
                            onChanged: (val) => _customMaintenance = val,
                            validator: (val) =>
                            _maintenance == 'Custom' &&
                                (val == null || val.isEmpty)
                                ? "Enter maintenance fee"
                                : null,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    // Dropdown for Car, Bike, Both
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Parking",
                        controller: TextEditingController(
                          text: _parking ?? '',
                        ),
                        onTap: () => _showBottomSheet(
                          options: ['Car', 'Bike', 'Both','No Parking',''],
                          onSelected: (val) {
                            setState(() {
                              _parking = val;
                            });
                          },
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select parking type" : null,
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child:   _buildReadOnlyField(
                        label: "Age of Property",
                        controller: _propertyAgeController,
                        onTap: () =>
                            _showBottomSheet(
                              options: ['1 years', '2 years', '3 years', '4 years','5 years','6 years','7 years','8 years','9 years','10 years','10+ years',''],
                              onSelected: (val) {
                                setState(() {
                                  _propertyAge = val;
                                  _propertyAgeController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select property age"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Road Size (in feet)",
                        controller: _roadSizeController,
                        onTap: () =>
                            _showBottomSheet(
                              options: [
                                '15 Feet',
                                '20 Feet',
                                '25 Feet',
                                '30 Feet',
                                '35 Feet',
                                '40 Above',
                                ''
                              ],
                              onSelected: (val) {
                                setState(() {
                                  _roadSizeController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select road size" : null,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    // Near Metro
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Near Metro Station",
                        controller: _nearMetroController,
                        onTap: () =>
                            _showBottomSheet(
                              options: _metroOptions,
                              onSelected: (val) {
                                setState(() {
                                  _nearMetroController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select nearest metro station"
                            : null,
                      ),
                    ),
                    SizedBox(width: 16,),
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Metro Distance",
                        controller: _highwayController,
                        onTap: () =>
                            _showBottomSheet(
                              options: ['200 m','300 m','400 m','500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''],

                              onSelected: (val) {
                                setState(() {
                                  _highwayController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select metro distance"
                            : null,
                      ),
                    ),

                  ],
                ),


                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Main Market Distance",
                        controller: _mainMarketController,
                        onTap: () =>
                            _showBottomSheet(
                              options: ['200 m','300 m','400 m','500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''],

                              onSelected: (val) {
                                setState(() {
                                  _mainMarketController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select main market distance"
                            : null,
                      ),
                    ),

                    const SizedBox(width: 16),
                    // Flat Available (Date Picker)
                    Expanded(
                      child: TextFormField(
                        controller: _flatAvailableController,
                        readOnly: true,
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (date != null) {
                            setState(() {
                              _flatAvailableDate = date;
                              _flatAvailableController.text =
                                  DateFormat('dd-MM-yyyy').format(date);
                            });
                          }
                        },
                        decoration: _buildInputDecoration(
                            context, "Flat Available From"),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select availability date"
                            : null,
                      ),
                    ),


                  ],
                ),

                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "House Meter Type",
                        controller: TextEditingController(
                          text: _houseMeter == 'Custom' ? 'Custom' : _houseMeter,
                        ),
                        onTap: () => _showBottomSheet(
                          options: ['Commercial', 'Govt', 'Custom', ''],
                          onSelected: (val) {
                            setState(() {
                              _houseMeter = val;
                              if (val != 'Custom') {
                                _houseMeterController.text = val; // keep selected value
                              } else {
                                _houseMeterController.clear(); // allow typing new
                              }
                            });
                          },
                        ),
                        // ✅ Show red only if nothing is selected
                        validator: (val) {
                          if ((_houseMeter ?? '').isEmpty) {
                            return "Select house meter type";
                          }
                          return null; // no red if auto-filled
                        },
                      ),
                    ),
                    if (_houseMeter == 'Custom') ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(
                            decoration: _buildInputDecoration(
                              context,
                              "Enter Custom House Meter Type",
                            ),
                            controller: _houseMeterController,
                            onChanged: (val) => _houseMeterController.text = val,
                            // ✅ Red only if user selects Custom but leaves it blank
                            validator: (val) {
                              if (_houseMeter == 'Custom' &&
                                  (val == null || val.isEmpty)) {
                                return "Enter custom meter type";
                              }
                              return null; // don’t show red for auto-filled values
                            },
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Owner Name
                TextFormField(
                  controller: _ownerNameController,
                  decoration: _buildInputDecoration(context, "Owner Name"),
                ),
                const SizedBox(height: 16),

                // Owner Number

                TextFormField(
                  controller: _ownerNumberController,
                  decoration: _buildInputDecoration(
                      context, "Owner Contact Number"),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10), // max 10 chars
                    FilteringTextInputFormatter.digitsOnly, // digits only
                  ],
                ),
                const SizedBox(height: 16),
                _buildSectionCard(
                  child: DropdownButtonFormField<String>(
                    value: _furnished,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                            color: Theme.of(context).brightness==Brightness.dark ? Colors.blue : Colors.blue.shade300,
                            width: 2),
                      ),
                      focusColor: Colors.red,
                      // 🔴 Border when validation fails
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),

                      // 🔴 Border when validation fails & field is focused
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                      // 🔴 Add these two
                      labelText: "",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: furnishingOptions.map((option) {
                      return DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        _furnished = val;
                        // Clear previously selected furniture if not furnished
                        if (val == 'Unfurnished') {
                          _selectedFurniture.clear();
                        }
                      });
                    },

                    validator: (val) =>
                    val == null || val.isEmpty ? 'Please select furnishing' : null,
                  ), title: 'Furnishing',
                ),
                if (_furnished == 'Fully Furnished' || _furnished == 'Semi Furnished')
                  _blueSectionCard(
                    child: GestureDetector(
                      onTap: () => _showFurnitureBottomSheet(context),
                      child: AbsorbPointer(
                        child: Padding(
                          padding:  EdgeInsets.only(top: 16.0),
                          child:
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: "Select Furniture Items",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              filled: true, // ✅ enable background color
                              fillColor: Colors.grey.shade800,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            controller: TextEditingController(
                              text: _selectedFurniture.isEmpty
                                  ? ''
                                  : _selectedFurniture.entries
                                  .map((e) => '${e.key} (${e.value})')
                                  .join(', '),
                            ),
                          ),
                        ),
                      ),
                    ), title: 'Furniture Items',
                  ),



                const SizedBox(height: 16),
                FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_kitchenType?.isEmpty ?? true) {
                      return "Please select a kitchen type";
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kitchen Type:",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [


                            // ✅ Western Style
                            ChoiceChip(
                              label: Text(
                                "Western Style",
                                style: TextStyle(
                                  color: _kitchenType == 'Western Style'
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _kitchenType == 'Western Style',
                              onSelected: (_) {
                                setState(() {
                                  _kitchenType = 'Western Style';
                                  state.didChange(_kitchenType);
                                });
                              },
                            ),

                            // ✅ Indian Style
                            ChoiceChip(
                              label: Text(
                                "Indian Style",
                                style: TextStyle(
                                  color: _kitchenType == 'Indian Style'
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _kitchenType == 'Indian Style',
                              onSelected: (_) {
                                setState(() {
                                  _kitchenType = 'Indian Style';
                                  state.didChange(_kitchenType);
                                });
                              },
                            ),
                            ChoiceChip(
                              label: Text(
                                "No",
                                style: TextStyle(
                                  color: _kitchenType == 'No'
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _kitchenType == 'No',
                              onSelected: (_) {
                                setState(() {
                                  _kitchenType = 'No';
                                  state.didChange(_kitchenType);
                                });
                              },
                            ),
                          ],
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 16),

                FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_bathroom?.isEmpty ?? true) {
                      return "Please select bathroom type";
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bathroom :",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [

                            ChoiceChip(
                              label: const Text("Western Style"),
                              labelStyle: TextStyle(
                                color: _bathroom == 'Western Style'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _bathroom == 'Western Style',
                              onSelected: (_) {
                                setState(() {
                                  _bathroom = 'Western Style';
                                  state.didChange(_bathroom); // ✅ tell FormField value changed
                                });
                              },
                            ),

                            ChoiceChip(
                              label: const Text("Indian Style"),
                              labelStyle: TextStyle(
                                color: _bathroom == 'Indian Style'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _bathroom == 'Indian Style',
                              onSelected: (_) {
                                setState(() {
                                  _bathroom = 'Indian Style';
                                  state.didChange(_bathroom); // ✅ tell FormField value changed
                                });
                              },
                            ),
                            ChoiceChip(
                              label: const Text("No"),
                              labelStyle: TextStyle(
                                color: _bathroom == 'No'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _bathroom == 'No',
                              onSelected: (_) {
                                setState(() {
                                  _bathroom = 'No';
                                  state.didChange(_bathroom);
                                });
                              },
                            ),
                          ],
                        ),

                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text(
                      "Lift :",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(width: 20),
                    ChoiceChip(
                      label: const Text("Yes"),
                      labelStyle: TextStyle(
                        color: _lift == 'Yes' ? Colors.white : Colors
                            .black87,
                      ),
                      selectedColor: Colors.blueAccent,
                      backgroundColor: Colors.grey.shade200,
                      selected: _lift == 'Yes',
                      onSelected: (_) => setState(() => _lift = 'Yes'),
                    ),
                    const SizedBox(width: 10),
                    ChoiceChip(
                      label: const Text("No"),
                      labelStyle: TextStyle(
                        color: _lift == 'No' ? Colors.white : Colors
                            .black87,
                      ),
                      selectedColor: Colors.blueAccent,
                      backgroundColor: Colors.grey.shade200,
                      selected: _lift == 'No',
                      onSelected: (_) =>
                          setState(() => _lift = 'No'),
                    ),
                  ],
                ),
                const SizedBox(height: 16),


                // Field Worker Name
                TextFormField(
                  controller: _fieldWorkerNameController,
                  decoration: _buildInputDecoration(
                      context, "Field Worker Name"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter Field Worker Name"
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _fieldWorkerNumberController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10), // max 10 chars
                    FilteringTextInputFormatter.digitsOnly, // digits only
                  ],

                  decoration: _buildInputDecoration(
                      context, "Field Worker Number"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter Field Worker Number"
                      : null,
                ),
                const SizedBox(height: 16),

                // Field Worker Address
                TextFormField(
                  controller: _fieldWorkerAddressController,
                  decoration: _buildInputDecoration(
                      context, "Field Worker Address"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter address"
                      : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _careTakerNameController,
                  keyboardType: TextInputType.name,
                  decoration: _buildInputDecoration(
                      context, "Care Taker Name"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _careTakerNumberController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10), // max 10 chars
                    FilteringTextInputFormatter.digitsOnly, // digits only
                  ],

                  decoration: _buildInputDecoration(
                      context, "Care Taker Number"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _videoLinkController,
                  // keyboardType: TextInputType.name,
                  decoration: _buildInputDecoration(
                      context, "Video Link"),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: EdgeInsets.zero,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      child: _imageFile != null
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.file(
                          _imageFile!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                          : _networkImageUrl != null &&
                          _networkImageUrl!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          _networkImageUrl!,
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              _placeholder(),
                        ),
                      )
                          : _placeholder(),
                    ),
                  ],
                ),


                // ElevatedButton(
                //   onPressed: pickMultipleImages,
                //   child: Text("Choose Multiple Images"),
                // ),
                const SizedBox(height: 16),


                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? Colors.white10
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white10
                              : Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? Colors.black26
                                : Color(0xFFEDF2F7),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _Google_Location,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white
                              : Color(0xFF2D3748),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                          hintText: 'Enter your address',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(
                            Icons.location_on_rounded,
                            color: Colors.blue.shade300,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    GestureDetector(

                      onTap: () async {
                        final status = await Permission.location.request();
                        if (!status.isGranted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Location permission is required')),
                          );
                          return;
                        }

                        try {
                          // Step 1: Get current GPS location
                          Position position =
                          await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high);

                          double latitude = position.latitude;
                          double longitude = position.longitude;

                          // Step 2: Save to SharedPreferences
                          final prefs =
                          await SharedPreferences.getInstance();
                          await prefs.setDouble('latitude', latitude);
                          await prefs.setDouble('longitude', longitude);

                          // Step 3: Convert to address
                          List<Placemark> placemarks =
                          await placemarkFromCoordinates(
                              latitude, longitude);

                          String output = 'Unable to fetch location';
                          if (placemarks.isNotEmpty) {
                            Placemark place = placemarks.first;
                            output =
                            '${place.street}, ${place.subLocality}, ${place
                                .locality}, '
                                '${place.subAdministrativeArea}, ${place
                                .administrativeArea}, '
                                '${place.country}, ${place.postalCode}';
                          }

                          // Step 4: Update controller and variable
                          setState(() {
                            full_address = output;
                            _Google_Location.text = full_address;
                          });

                          print('Address: $full_address');
                        } catch (e) {
                          print('Error: ${e.toString()}');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Failed to get address: ${e.toString()}')),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade200,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Get Current Location',
                            style: TextStyle(
                              fontFamily: 'PoppinsBold',
                              color: Colors.white,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSubmitting
                        ? null
                        : () async {
                      final pageContext = context;

                      // ✅ Validate form first
                      if (!_formKey.currentState!.validate()) {
                        showDialog(
                          context: pageContext,
                          builder: (_) => AlertDialog(
                            title: const Text(
                              "Form Incomplete",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              "Please fill all required fields before continuing.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(pageContext).pop(),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                        return; // Stop here if fields are empty
                      }

                      setState(() => _isSubmitting = true);
                      int countdown = 3;

                      // ✅ Show countdown dialog
                      await showDialog(
                        context: pageContext,
                        barrierDismissible: false,
                        builder: (_) {
                          return StatefulBuilder(
                            builder: (context, setStateDialog) {
                              bool isDialogActive = true;

                              Future(() async {
                                // Countdown loop
                                for (int i = countdown; i > 0; i--) {
                                  if (!mounted || !isDialogActive) return;
                                  setStateDialog(() => countdown = i);
                                  await Future.delayed(const Duration(seconds: 1));
                                }

                                if (!mounted || !isDialogActive) return;

                                // Show verified icon
                                setStateDialog(() => countdown = 0);

                                // Wait a short moment to allow icon animation
                                await Future.delayed(const Duration(milliseconds: 800));

                                if (!mounted || !isDialogActive) return;

                                // Close dialog safely
                                if (Navigator.of(pageContext).canPop()) {
                                  isDialogActive = false;
                                  Navigator.of(pageContext).pop();
                                }

                                // Call API after icon shown
                                await _checkAndSubmitContinue();

                                // Navigate back safely after short delay
                                await Future.delayed(const Duration(seconds: 1));
                                if (mounted && Navigator.of(pageContext).canPop()) {
                                  Navigator.of(pageContext).pop();
                                }
                              });

                              return AlertDialog(
                                backgroundColor: Theme.of(pageContext).brightness == Brightness.dark
                                    ? Colors.grey[900]
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                title: const Text(
                                  "Submitting...",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AnimatedSwitcher(
                                      duration: const Duration(milliseconds: 500),
                                      transitionBuilder: (child, animation) =>
                                          ScaleTransition(scale: animation, child: child),
                                      child: countdown > 0
                                          ? Text(
                                        "$countdown",
                                        key: ValueKey<int>(countdown),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(pageContext).brightness ==
                                              Brightness.dark
                                              ? Colors.red[300]
                                              : Colors.red,
                                        ),
                                      )
                                          : const Icon(
                                        Icons.verified_rounded,
                                        key: ValueKey<String>("verified"),
                                        color: Colors.green,
                                        size: 60,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      countdown > 0 ? "Please wait..." : "Verified!",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(pageContext).brightness == Brightness.dark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                      setState(() => _isSubmitting = false);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                        : const Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _placeholder() {
    return const SizedBox(
      height: 100,
      width: 100,
      child: Center(
        child: Text(
          'Tap to select image',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: isDark ? Colors.grey.shade300 : Colors.black54,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isDark ? Colors.blue : Colors.blue.shade300,
            width: 2),
      ),
      focusColor: Colors.red,
      // 🔴 Border when validation fails
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),

      // 🔴 Border when validation fails & field is focused
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      // 🔴 Add these two


      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.white,
    );
  }


  Widget _buildReadOnlyField(
      {
        required String label,
        required TextEditingController controller,
        required VoidCallback onTap,
        String? Function(String?)? validator,
      }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: isDark ? Colors.grey.shade300 : Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.blue.shade200 : Colors.blue.shade300,
                width: 2,
              ),
            ),

            // 🔴 Added for validation error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),

            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            filled: true,
            fillColor: isDark ? Colors.grey.shade900 : Colors.white,
          ),
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
          validator: validator,
        ),
      ),
    );
  }
  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,  fontFamily: 'Poppins');
  }
  Widget _blueSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.blue.shade600,
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _sectionTitleStyle()),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 6,right: 6,bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: _sectionTitleStyle()),
            const SizedBox(height: 10),
            child,
          ],
        ),
      ),
    );
  }

  void _showBottomSheet({
    required List<String> options,
    required Function(String) onSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) =>
          DraggableScrollableSheet(
            expand: false,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            initialChildSize: options.length <= 5 ? 0.4 : 0.6,
            builder: (context, scrollController) =>
                ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(
                        option,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500,
                            fontFamily: "Poppins"
                        ),
                      ),
                      onTap: () => Navigator.pop(context, option),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8)),
                      ),
                      hoverColor: Colors.blue.shade50,
                    );
                  },
                ),
          ),
    );

    if (selected != null) {
      // Delay to ensure bottom sheet closes before updating state
      Future.delayed(const Duration(milliseconds: 50), () {
        onSelected(selected);
      });
    }
  }

  String getFurnishingStringForApi() {
    if (_selectedFurniture.isEmpty) {
      return 'Unfurnished';
    } else {
      return _selectedFurniture.entries
          .map((e) => '${e.key} (${e.value})')
          .join(', ');
    }
  }


  bool _isSubmitting = false;

  Future<void> _submitForm() async {
    if (_isSubmitting) return;

    final prefs = await SharedPreferences.getInstance();

    // Validate required fields
    final requiredFields = {
      'Location': _locationController.text,
      'Flat Number': _flatNumberController.text,
      'Buy / Rent': _buyOrRent,
      'Residence / Commercial': _resOrComm,
      'Apartment Address': _apartmentAddressController.text,
      'Type of Property': _propertyType,
      'BHK': (_bhk == "Custom" ? _customBhk : _bhk),
      'Price': _priceController.text,
      'Asking Price': _askingPriceController.text,
      'Last Price': _lastPriceController.text,
      'Floor': _floor,
      'Total Floor': _totalFloorController.text,
      'Balcony': _balcony,
      'Square Feet': _squareFeetController.text,
      'Maintenance': (_maintenance == "Custom" ? _customMaintenance : _maintenance),
      'Parking': _parking,
      'Property Age': _propertyAge,
      'Fieldworker Address': _fieldWorkerAddressController.text,
      'Road Size': _roadSizeController.text,
      'Metro Distance': _nearMetroController.text,
      'Highway Distance': _highwayController.text,
      'Main Market Distance': _mainMarketController.text,
      'Meter Type': (_houseMeter == "Custom" ? _houseMeterController.text : _houseMeter),
      'Kitchen': _kitchenType,
      'Bathroom': _bathroom,
      'Lift': _lift,
      'Facility': _facilityController.text,
      'Field Worker Name': prefs.getString('name'),
      'Field Worker Number': prefs.getString('number'),
    };

    for (var entry in requiredFields.entries) {
      if (entry.value == null || (entry.value is String && (entry.value as String).trim().isEmpty)) {
        Fluttertoast.showToast(
          msg: "${entry.key} is required",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId();

      final uri = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/urgent_flat_update_api.php"
      );

      var request = http.MultipartRequest('POST', uri);

      // Basic details
      request.fields['P_id'] = widget.propertyId.toString();
      request.fields['locations'] = _locationController.text;
      request.fields['Flat_number'] = _flatNumberController.text;
      request.fields['Buy_Rent'] = _buyOrRent ?? '';
      request.fields['Residence_Commercial'] = _resOrComm ?? '';
      request.fields['Apartment_Address'] = _apartmentAddressController.text;
      request.fields['Typeofproperty'] = _propertyType ?? '';
      request.fields['Bhk'] = (_bhk == "Custom" ? _customBhk ?? '' : _bhk ?? '');
      request.fields['show_Price'] = _formattedPrice;
      request.fields['Last_Price'] = _formattedLastPrice;
      request.fields['asking_price'] = _formattedAskingPrice;
      request.fields['Floor_'] = _floor ?? '';
      request.fields['Total_floor'] = _totalFloorController.text;
      request.fields['Balcony'] = _balcony ?? '';
      request.fields['squarefit'] = _squareFeetController.text;
      request.fields['maintance'] = (_maintenance == "Custom" ? _customMaintenance ?? '' : _maintenance ?? '');
      request.fields['parking'] = _parking ?? '';
      request.fields['age_of_property'] = _propertyAge ?? '';
      request.fields['fieldworkar_address'] = _fieldWorkerAddressController.text;
      request.fields['Road_Size'] = _roadSizeController.text;
      request.fields['metro_distance'] = _nearMetroController.text;
      request.fields['highway_distance'] = _highwayController.text;
      request.fields['main_market_distance'] = _mainMarketController.text;
      request.fields['meter'] = (_houseMeter == "Custom" ? _houseMeterController.text : _houseMeter ?? '');
      request.fields['owner_name'] = _ownerNameController.text;
      request.fields['owner_number'] = _ownerNumberController.text;
      request.fields['current_dates'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      request.fields['available_date'] = _flatAvailableDate?.toIso8601String() ?? '';
      request.fields['kitchen'] = _kitchenType ?? '';
      request.fields['bathroom'] = _bathroom ?? '';
      request.fields['lift'] = _lift ?? '';
      request.fields['Facility'] = _facilityController.text;
      request.fields['field_warkar_name'] = prefs.getString('name') ?? '';
      request.fields['field_workar_number'] = prefs.getString('number') ?? '';
      request.fields['care_taker_name'] = _careTakerNameController.text;
      request.fields['care_taker_number'] = _careTakerNumberController.text;
      request.fields['video_link'] = _videoLinkController.text;
      print("Video link field value: '${_videoLinkController.text}'");
      request.fields['registry_and_gpa'] = _registryAndGpa ?? '';
      request.fields['loan'] = _loan ?? '';
      request.fields['field_worker_current_location'] = _Google_Location.text ?? '';

      String _furnishingForBackend(String? val) {
        switch (val) {
          case 'Semi Furnished':  return 'Semi Furnished';
          case 'Fully Furnished': return 'Fully Furnished';
          default:                return 'Unfurnished';
        }
      }

      final bool isFurnished = _furnishing == 'Semi Furnished' || _furnishing == 'Fully Furnished';

      // If user typed in the TextFormField → take that, else use selectedFurniture
      final String furnitureList = furnitureController.text.trim().isNotEmpty
          ? furnitureController.text.trim()
          : _selectedFurniture.entries
          .where((e) => (e.value) > 0)
          .map((e) => '${e.key} (${e.value})')
          .join(', ')
          .trim();

      request.fields['furnished_unfurnished'] = _furnishingForBackend(_furnished);
      request.fields['Apartment_name'] = isFurnished
          ? (furnitureList.isNotEmpty ? furnitureList : 'No Furniture')
          : 'No Furniture';
      print("DEBUG => _furnished: $_furnished");
      print("DEBUG => furnished_unfurnished: ${_furnishingForBackend(_furnished)}");

      print('=> furnished_unfurnished: ${request.fields['furnished_unfurnished']}');
      print('=> Apartment_name: ${request.fields['Apartment_name']}');

      // Lat/Long
      final lat = prefs.getDouble('latitude');
      final long = prefs.getDouble('longitude');
      request.fields['Latitude'] = lat?.toString() ?? '';
      request.fields['Longitude'] = long?.toString() ?? '';

      // Files
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath('property_photo', _imageFile!.path));
      }
      for (int i = 0; i < _images.length; i++) {
        File imageFile = File(_images[i].path);
        request.files.add(await http.MultipartFile.fromPath('images[]', imageFile.path));
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int propertyId = int.tryParse(data['P_id'].toString()) ?? 0;
        Fluttertoast.showToast(
          msg: "Successfully Registered, Property ID: $propertyId",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        // Navigator.pop(context);
      } else {
        throw Exception("Failed to upload data.");
      }
    } catch (e) {

      Fluttertoast.showToast(
        msg: "Error: ${e.toString()}, Unsuccessful",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  void _showFacilitySelectionDialog() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          _FacilityBottomSheet(
            options: allFacilities,
            selected: selectedFacilities,
          ),
    );

    if (result != null) {
      setState(() {
        selectedFacilities = result;
        _facilityController.text = selectedFacilities.join(', ');
      });
    }
  }

  void _showFurnitureBottomSheet(BuildContext context) {
    final List<String> furnitureItems = [
      'Fan',
      'Light',
      'Wardrobe',
      'AC',
      'Water Purifier',
      'Washing Machine',
      'Refrigerator',
      'Modular Kitchen',
      'Chimney',
      'Single Bed',
      'Double Bed',
      'Geyser',
      'Led Tv',
      'Sofa Set',
      'Dining Table',
      'Induction',
      'Gas Stove',
    ];

    final Map<String, int> tempSelection = Map.from(_selectedFurniture);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // avoids keyboard overlap
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Furniture',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: SingleChildScrollView(
                        child: Column(
                          children: furnitureItems.map((item) {
                            final isSelected = tempSelection.containsKey(item);

                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    tempSelection.remove(item);
                                  } else {
                                    tempSelection[item] = 1;
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.blue,
                                          value: isSelected,
                                          onChanged: (checked) {
                                            setModalState(() {
                                              if (checked == true) {
                                                tempSelection[item] = 1;
                                              } else {
                                                tempSelection.remove(item);
                                              }
                                            });
                                          },
                                        ),
                                        Text(item,
                                            style: const TextStyle(fontSize: 14)),
                                      ],
                                    ),
                                    if (isSelected)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
                                            onPressed: () {
                                              setModalState(() {
                                                if (tempSelection[item]! > 1) {
                                                  tempSelection[item] =
                                                      tempSelection[item]! - 1;
                                                }
                                              });
                                            },
                                          ),
                                          Text('${tempSelection[item]}'),
                                          IconButton(
                                            icon: const Icon(
                                                Icons.add_circle_outline),
                                            onPressed: () {
                                              setModalState(() {
                                                tempSelection[item] =
                                                    tempSelection[item]! + 1;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // ✅ Update main selection map
                          _selectedFurniture = Map.fromEntries(
                            tempSelection.entries.where((e) => e.value > 0),
                          );

                          // ✅ Update text field
                          furnitureController.text = _selectedFurniture.entries
                              .map((e) => '${e.key} (${e.value})')
                              .join(', ');

                          // ✅ Update API variable directly here
                          apiApartmentName = furnitureController.text;
                        });

                        Navigator.pop(ctx);
                      },
                      child: const Text("Save Selection"),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.04,
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _FacilityBottomSheet extends StatefulWidget {
  final List<String> options;
  final List<String> selected;

  const _FacilityBottomSheet({
    required this.options,
    required this.selected,
  });

  @override
  State<_FacilityBottomSheet> createState() => _FacilityBottomSheetState();
}

class _FacilityBottomSheetState extends State<_FacilityBottomSheet> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Select Facilities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...widget.options.map((option) {
              final isSelected = _tempSelected.contains(option);
              return CheckboxListTile(
                title: Text(option),
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _tempSelected.add(option);
                    } else {
                      _tempSelected.remove(option);
                    }
                  });
                },
              );
            }).toList(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _tempSelected),
              child: const Text("Done"),
            ),
            SizedBox(height: 10,)
          ],
        ),
      ),
    );

  }
}