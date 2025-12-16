import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_decoration_tools/app_images.dart';
import 'Future_Property.dart';
import 'metro_api.dart';

class Add_FutureProperty extends StatefulWidget {
  const Add_FutureProperty({super.key});


  @override
  State<Add_FutureProperty> createState() => _Add_FuturePropertyState();
}

class _Add_FuturePropertyState extends State<Add_FutureProperty> {

  int _countdown = 0;
  bool _isCounting = false;

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedItem;
  String? _selectedItem1;
  // String? _typeofproperty;
  String? _selectedPropertyType;
  String? _selectedLift;
  String? _selectedParking;
  String? selectedRoadSize;
  String? selectedMetroDistance;
  String? metro_name;
  String? selectedMarketDistance;
  String? _ageOfProperty;
  String? _totalFloor;

  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _address = TextEditingController();
  // final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController metroController = TextEditingController();
  final TextEditingController localityController = TextEditingController();

  String _number = '';
  String _name = '';
  List<String> selectedFacilities = [];

  // Image variables
  XFile? _singleImage;
  List<XFile> _selectedImages = [];

  // Location variables
  bool _isGettingLocation = false;
  String _currentAddress = '';
  double? _latitude;
  double? _longitude;

  DateTime uploadDate = DateTime.now();

  List<Map<String, dynamic>> nearbyHospitals = [];
  List<Map<String, dynamic>> nearbySchools = [];
  List<Map<String, dynamic>> nearbyMetros = [];
  List<Map<String, dynamic>> nearbyMalls = [];
  List<Map<String, dynamic>> nearbyParks = [];
  List<Map<String, dynamic>> nearbyCinemas = [];

  bool _isLoading = false;

  // Dropdown options
  final List<String> _items = [
    'SultanPur',
    'ChhattarPur',
    'Aya Nagar',
    'Rajpur Khurd',
    'Mangalpuri',
    'Dwarka Mor',
    'Uttam Nagar',
    'Nawada',
    'Vasant Kunj',
    'Ghitorni'
  ];
  final List<String> _items1 = ['Buy', 'Rent'];
  final List<String> name = [
    '1 BHK',
    '2 BHK',
    '3 BHK',
    '4 BHK',
    '1 RK',
    'Commercial SP'
  ];
  final List<String> propertyTypes = ['Residential', 'Commercial'];
  final List<String> lift_options = ['Yes', 'No'];
  final List<String> parkingOptions = ['Yes', 'No'];
  final List<String> _items_floor2 = [
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
    '10 Floor'
  ];
  final List<String> roadSizeOptions = [
    '15 Feet',
    '20 Feet',
    '25 Feet',
    '30 Feet',
    '35 Feet',
    '40 Above'
  ];
  final List<String> metroDistanceOptions = [
    '200 m',
    '300 m',
    '400 m',
    '500 m',
    '600 m',
    '700 m',
    '1 km',
    '1.5 km',
    '2.5 km',
    '2.5+ km'
  ];
  final List<String> metro_nameOptions = [
    'Hauz khas',
    'Malviya Nagar',
    'Saket',
    'Qutub Minar',
    'ChhattarPur',
    'Sultanpur',
    'Ghitorni',
    'Arjan Garh',
    'Guru Drona',
    'Sikanderpur',
    'Dwarka Mor',
    'Vasant Kunj',
    'Ghitorni'
  ];
  final List<String> marketDistanceOptions = [
    '200 m',
    '300 m',
    '400 m',
    '500 m',
    '600 m',
    '700 m',
    '1 km',
    '1.5 km',
    '2.5 km',
    '2.5+ km'
  ];
  final List<String> Age_Options = [
    '1 years',
    '2 years',
    '3 years',
    '4 years',
    '5 years',
    '6 years',
    '7 years',
    '8 years',
    '9 years',
    '10 years',
    '10+ years',
    ''
  ];
  List<String> allFacilities = [
    'CCTV Camera',
    'Parking',
    'Security',
    'Terrace Garden',
    "Gas Pipeline"
  ];

  String long = '';
  String lat = '';
  String full_address = '';

  String _date = '';
  String _Time = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _generateDateTime();
  }

  void _generateDateTime() {
    setState(() {
      _date = DateFormat('d-MMMM-yyyy').format(DateTime.now());
      _Time = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
    });
  }

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85,
    );

    return result;
  }

  Future<void> uploadImageWithTitle(XFile imageFile) async {
    String uploadUrl =
        'https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/new_future_property_api_with_images.php';

    FormData formData = FormData();

    formData.files.add(MapEntry(
      "images",
      await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path.split('/').last),
    ));

    formData.fields.addAll([
      MapEntry("ownername", _Ownername.text ?? ''),
      MapEntry("ownernumber", _Owner_number.text ?? ''),
      MapEntry("caretakername", _CareTaker_name.text ?? ''),
      MapEntry("caretakernumber", _CareTaker_number.text ?? ''),
      MapEntry("place", _selectedItem ?? ''),
      MapEntry("buy_rent", _selectedItem1 ?? ''),
     // MapEntry("typeofproperty", _typeofproperty ?? ''),
      MapEntry("propertyname_address", _address.text),
     // MapEntry("building_information_facilitys", _Building_information.text),
      MapEntry("property_address_for_fieldworkar", _Address_apnehisaabka.text),
      MapEntry("owner_vehical_number", _vehicleno.text),
      MapEntry("your_address", _Google_Location.text),
      MapEntry("fieldworkarname", _name),
      MapEntry("fieldworkarnumber", _number),
      MapEntry("current_date", uploadDate.toIso8601String()),
      MapEntry("longitude", _longitude?.toString() ?? ''),
      MapEntry("latitude", _latitude?.toString() ?? ''),
      MapEntry("road_size", selectedRoadSize ?? ''),
      MapEntry("parking", _selectedParking ?? ''),
      MapEntry("metro_distance", selectedMetroDistance ?? ''),
      MapEntry("main_market_distance", selectedMarketDistance ?? ''),
      MapEntry("age_of_property", _ageOfProperty ?? ''),
      MapEntry("total_floor", _totalFloor ?? ''),
      MapEntry("lift", _selectedLift ?? ""),
      MapEntry("current_date_",
          DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now())),
      MapEntry("Residence_commercial", _selectedPropertyType ?? ''),
      MapEntry("facility", selectedFacilities.join(', ')),
      MapEntry("metro_name", metroController.text),
      MapEntry("locality_list", localityController.text),
    ]);

    for (var xfile in _selectedImages) {
      formData.files.add(MapEntry(
        "img[]",
        await MultipartFile.fromFile(xfile.path,
            filename: xfile.path.split('/').last),
      ));
    }

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => FrontPage_FutureProperty()),
              (route) => route.isFirst,
        );
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful!')),
        );
        print('Upload successful: ${response.data}');
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
      print('Error occurred: $e');
    }
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields.");
      return;
    }

    if (_singleImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    await uploadImageWithTitle(_singleImage!);
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog(
              'Location permissions are denied. Please enable location services.');
          setState(() {
            _isGettingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(
            'Location permissions are permanently denied. Please enable them in app settings.');
        setState(() {
          _isGettingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      try {
        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final parts = [
            placemark.street,
            placemark.subLocality,
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode,
            placemark.country
          ];
          final address =
          parts.where((p) => p != null && p!.isNotEmpty).join(', ');

          setState(() {
            _Google_Location.text = address;
            _currentAddress = address;
            _isGettingLocation = false;
          });
          _showSuccessSnackbar('Location detected successfully!');
        } else {
          setState(() {
            _Google_Location.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
            _currentAddress =
            'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
            _isGettingLocation = false;
          });
          _showSuccessSnackbar('Location detected (coordinates).');
        }
      } catch (geocodingError) {
        setState(() {
          _Google_Location.text =
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
          _currentAddress =
          'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
          _isGettingLocation = false;
        });
        _showSuccessSnackbar('Location detected (coordinates).');
      }
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
      _showErrorDialog(
          'Failed to get location. Please check GPS, permissions, and internet.');
    }
  }

  // Premium Color Scheme
  final Color primaryColor = const Color(0xFF2D5BFF);
  final Color secondaryColor = const Color(0xFF6C63FF);
  final Color accentColor = const Color(0xFF00D4AA);

  /// Helper: Responsive row for two fields.
  Widget _buildTwoFieldRow(Widget first, Widget second) {
    final width = MediaQuery.of(context).size.width;

    if (width < 420) {
      // Narrow -> vertical
      return Column(
        children: [
          first,
          const SizedBox(height: 12),
          second,
        ],
      );
    }

    // Wider screens -> horizontal
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
    isDarkMode ? Colors.black : const Color(0xFFF8FAFF);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor =
    isDarkMode ? Colors.white : const Color(0xFF2D3748);
    final Color secondaryTextColor = textColor.withOpacity(0.6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: isDarkMode ? Colors.black : primaryColor,
        title: Image.asset(AppImages.transparent, height: 40),
        iconTheme:
        IconThemeData(color: isDarkMode ? Colors.white : Colors.white),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPremiumHeader(isDarkMode),
                const SizedBox(height: 32),
                _buildImageUploadSection(isDarkMode, cardColor, textColor),
                const SizedBox(height: 20),
                _buildBasicInfoSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                const SizedBox(height: 20),
                _buildContactInfoSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                const SizedBox(height: 20),
                _buildPropertyDetailsSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                const SizedBox(height: 20),
                _buildLocationSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                const SizedBox(height: 20),
                _buildNearbyFacilitiesSection(isDarkMode, cardColor, textColor),
                const SizedBox(height: 40),
                _buildPremiumSubmitButton(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  TextStyle _sectionTitleStyle() {
    return TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);
  }

  Widget _buildLocationSection(
      bool isDarkMode, Color cardColor, Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Location Details', Icons.location_on_rounded, textColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: _Address_apnehisaabka,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Address for Field Worker',
                    labelStyle: TextStyle(color: secondaryTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    prefixIcon:
                    Icon(Icons.map_rounded, color: primaryColor),
                    hintText: 'Enter address for field worker',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                  ),
                  maxLines: 2,
                  validator: (value) =>
                  (value == null || value.isEmpty)
                      ? 'Please enter address for field worker'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _vehicleno,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    labelText: 'Owner Vehicle Number (Optional)',
                    labelStyle: TextStyle(color: secondaryTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    prefixIcon: Icon(Icons.directions_car_rounded,
                        color: primaryColor),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _Google_Location,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Google Location',
                    labelStyle: TextStyle(color: secondaryTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                      BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                    prefixIcon:
                    Icon(Icons.search_rounded, color: primaryColor),
                    hintText: 'Enter Google location',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    suffixIcon: _isGettingLocation
                        ? Container(
                      width: 20,
                      height: 20,
                      padding: const EdgeInsets.all(2),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                        AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    )
                        : IconButton(
                      icon: Icon(Icons.my_location_rounded,
                          color: primaryColor),
                      onPressed: _getCurrentLocation,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
                  ),
                  maxLines: 2,
                  validator: (value) =>
                  (value == null || value.isEmpty)
                      ? 'Please enter Google location'
                      : null,
                ),
                const SizedBox(height: 12),
                if (_currentAddress.isNotEmpty || _latitude != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: accentColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_rounded,
                            size: 16, color: accentColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              if (_currentAddress.isNotEmpty)
                                Text(
                                  'Detected: $_currentAddress',
                                  style: TextStyle(
                                    color: accentColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              if (_latitude != null &&
                                  _longitude != null)
                                Text(
                                  'Lat: ${_latitude!.toStringAsFixed(6)}, Lng: ${_longitude!.toStringAsFixed(6)}',
                                  style: TextStyle(
                                    color: accentColor
                                        .withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentAddress = '';
                              _latitude = null;
                              _longitude = null;
                            });
                          },
                          child: Icon(Icons.close_rounded,
                              size: 16, color: accentColor),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          size: 14, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Enter Address manually or get your current Address from one tap on location button',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Basic Information', Icons.info_rounded, textColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedItem,
                    decoration: InputDecoration(
                      labelText: 'Place',
                      labelStyle: TextStyle(color: secondaryTextColor),
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      prefixIcon: Icon(Icons.location_city_rounded,
                          color: primaryColor),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                    ),
                    dropdownColor:
                    isDarkMode ? Colors.grey[850] : Colors.white,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500),
                    items: _items
                        .map((String value) =>
                        DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(
                                    color: textColor))))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedItem = newValue;
                      });
                    },
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please select a Place'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTwoFieldRow(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedItem1,
                      decoration: InputDecoration(
                        labelText: 'Buy / Rent',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.sell_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: _items1
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedItem1 = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select Buy/Rent'
                          : null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _totalFloor,
                      decoration: InputDecoration(
                        labelText: 'Total Floor',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.layers_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: _items_floor2
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _totalFloor = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select total floor'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
               // _buildTwoFieldRow(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedPropertyType,
                      decoration: InputDecoration(
                        labelText: 'Property Type',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.category_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: propertyTypes
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedPropertyType = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Select Property Type'
                          : null,
                    ),
                  ),

                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(
                  //         color: Colors.grey.withOpacity(0.2)),
                  //   ),
                  //   child:
                  //   DropdownButtonFormField<String>(
                  //     // value: _typeofproperty,
                  //     decoration: InputDecoration(
                  //       labelText: 'Type of Property',
                  //       labelStyle:
                  //       TextStyle(color: secondaryTextColor),
                  //       border: InputBorder.none,
                  //       contentPadding:
                  //       const EdgeInsets.symmetric(
                  //           horizontal: 16, vertical: 16),
                  //       prefixIcon: Icon(Icons.home_work_rounded,
                  //           color: primaryColor),
                  //       filled: true,
                  //       fillColor: isDarkMode
                  //           ? Colors.grey[850]
                  //           : Colors.white,
                  //     ),
                  //     dropdownColor: isDarkMode
                  //         ? Colors.grey[850]
                  //         : Colors.white,
                  //     style: TextStyle(
                  //         color: textColor,
                  //         fontWeight: FontWeight.w500),
                  //     items: name
                  //         .map((String value) =>
                  //         DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Text(value,
                  //                 style: TextStyle(
                  //                     color: textColor))))
                  //         .toList(),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         // _typeofproperty = newValue;
                  //       });
                  //     },
                  //     validator: (value) =>
                  //     (value == null || value.isEmpty)
                  //         ? 'Please select type of property'
                  //         : null,
                  //   ),
                  // ),
                //),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(12),
                  //     border: Border.all(
                  //         color: Colors.grey.withOpacity(0.2)),
                  //   ),
                  //   child:
                  //   DropdownButtonFormField<String>(
                  //     value: _typeofproperty,
                  //     decoration: InputDecoration(
                  //       labelText: 'Type of Property',
                  //       labelStyle:
                  //       TextStyle(color: secondaryTextColor),
                  //       border: InputBorder.none,
                  //       contentPadding:
                  //       const EdgeInsets.symmetric(
                  //           horizontal: 16, vertical: 16),
                  //       prefixIcon: Icon(Icons.home_work_rounded,
                  //           color: primaryColor),
                  //       filled: true,
                  //       fillColor: isDarkMode
                  //           ? Colors.grey[850]
                  //           : Colors.white,
                  //     ),
                  //     dropdownColor: isDarkMode
                  //         ? Colors.grey[850]
                  //         : Colors.white,
                  //     style: TextStyle(
                  //         color: textColor,
                  //         fontWeight: FontWeight.w500),
                  //     items: name
                  //         .map((String value) =>
                  //         DropdownMenuItem<String>(
                  //             value: value,
                  //             child: Text(value,
                  //                 style: TextStyle(
                  //                     color: textColor))))
                  //         .toList(),
                  //     onChanged: (String? newValue) {
                  //       setState(() {
                  //         _typeofproperty = newValue;
                  //       });
                  //     },
                  //     validator: (value) =>
                  //     (value == null || value.isEmpty)
                  //         ? 'Please select type of property'
                  //         : null,
                  //   ),
                  // ),
               // ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Contact Information', Icons.contact_phone_rounded, textColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: _Ownername,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: _buildInputDecoration(
                    label: 'Owner Name (Optional)',
                    icon: Icons.person_rounded,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _Owner_number,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: _buildInputDecoration(
                    label: 'Owner No. (Optional)',
                    icon: Icons.phone_rounded,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDarkMode: isDarkMode,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _CareTaker_name,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: _buildInputDecoration(
                    label: 'CareTaker Name (Optional)',
                    icon: Icons.person_outline_rounded,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDarkMode: isDarkMode,
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _CareTaker_number,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: _buildInputDecoration(
                    label: 'CareTaker No. (Optional)',
                    icon: Icons.phone_outlined,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDarkMode: isDarkMode,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Property Details', Icons.home_work_rounded, textColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: _address,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: _buildInputDecoration(
                    label: 'Property Name & Address',
                    icon: Icons.home_rounded,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    isDarkMode: isDarkMode,
                  ),
                  maxLines: 2,
                  validator: (value) =>
                  (value == null || value.trim().isEmpty)
                      ? 'Please enter property address'
                      : null,
                ),
                const SizedBox(height: 12),
                // TextFormField(
                //   controller: _Building_information,
                //   style: TextStyle(
                //     color: textColor,
                //     fontWeight: FontWeight.w500,
                //   ),
                //   decoration: _buildInputDecoration(
                //     label: 'Building Information',
                //     icon: Icons.info_outline_rounded,
                //     textColor: textColor,
                //     secondaryTextColor: secondaryTextColor,
                //     isDarkMode: isDarkMode,
                //   ),
                //   maxLines: 3,
                //   validator: (value) =>
                //   (value == null || value.trim().isEmpty)
                //       ? 'Please enter building information'
                //       : null,
                // ),

                const SizedBox(height: 12),
                _buildFacilityField(
                    isDarkMode, textColor, secondaryTextColor),
                const SizedBox(height: 12),
                _buildTwoFieldRow(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedRoadSize,
                      decoration: InputDecoration(
                        labelText: 'Road width (in ft)',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.aod_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: roadSizeOptions
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedRoadSize = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select road size'
                          : null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _ageOfProperty,
                      decoration: InputDecoration(
                        labelText: 'Age of property',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.date_range_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: Age_Options
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _ageOfProperty = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select age'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTwoFieldRow(
                  TextFormField(
                    controller: metroController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Metro Station",
                      labelStyle:
                      TextStyle(color: secondaryTextColor),
                      prefixIcon: Icon(Icons.train_rounded,
                          color: primaryColor),
                      hintText: "Select Metro Station",
                      hintStyle:
                      TextStyle(color: secondaryTextColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        BorderSide(color: Colors.grey.withOpacity(0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: primaryColor),
                      ),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                    ),
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500),
                    onTap: () {
                      showMetroLocalityPicker(context, (metro, localities) {
                        setState(() {
                          metroController.text = metro;
                          localityController.text =
                              localities.join(", ");
                        });
                      });
                    },
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please select metro station'
                        : null,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedMetroDistance,
                      decoration: InputDecoration(
                        labelText: 'Metro Distance',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.straighten_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: metroDistanceOptions
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMetroDistance = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select metro distance'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTwoFieldRow(
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: selectedMarketDistance,
                      decoration: InputDecoration(
                        labelText: 'Market Distance',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon:
                        Icon(Icons.shopping_cart_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: marketDistanceOptions
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedMarketDistance = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select market distance'
                          : null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonFormField<String>(
                      value: _selectedLift,
                      decoration: InputDecoration(
                        labelText: 'Lift Availability',
                        labelStyle:
                        TextStyle(color: secondaryTextColor),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        prefixIcon: Icon(Icons.elevator_rounded,
                            color: primaryColor),
                        filled: true,
                        fillColor: isDarkMode
                            ? Colors.grey[850]
                            : Colors.white,
                      ),
                      dropdownColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                      style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w500),
                      items: lift_options
                          .map((String value) =>
                          DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      color: textColor))))
                          .toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedLift = newValue;
                        });
                      },
                      validator: (value) =>
                      (value == null || value.isEmpty)
                          ? 'Please select lift availability'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.grey.withOpacity(0.2)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedParking,
                    decoration: InputDecoration(
                      labelText: 'Parking',
                      labelStyle:
                      TextStyle(color: secondaryTextColor),
                      border: InputBorder.none,
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      prefixIcon: Icon(Icons.local_parking_rounded,
                          color: primaryColor),
                      filled: true,
                      fillColor: isDarkMode
                          ? Colors.grey[850]
                          : Colors.white,
                    ),
                    dropdownColor: isDarkMode
                        ? Colors.grey[850]
                        : Colors.white,
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w500),
                    items: parkingOptions
                        .map((String value) =>
                        DropdownMenuItem<String>(
                            value: value,
                            child: Text(value,
                                style: TextStyle(
                                    color: textColor))))
                        .toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedParking = newValue;
                      });
                    },
                    validator: (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please select parking type'
                        : null,
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Localities",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: localityController,
                  readOnly: true,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Selected Localities",
                    hintStyle:
                    TextStyle(color: secondaryTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: isDarkMode
                        ? Colors.grey[850]
                        : Colors.white,
                  ),
                  style: TextStyle(color: textColor),
                ),
                const SizedBox(height: 8),
                if (localityController.text.trim().isNotEmpty)
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: localityController.text
                        .split(",")
                        .map(
                          (loc) => Chip(
                        label: Text(
                          loc.trim(),
                          style: TextStyle(
                            color: Theme.of(context)
                                .brightness ==
                                Brightness.dark
                                ? Colors.white
                                : Colors.black,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        backgroundColor: Colors.grey.shade600,
                      ),
                    )
                        .toList(),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFacilityField(
      bool isDarkMode, Color textColor, Color secondaryTextColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Facilities:',
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: _facilityController,
          readOnly: true,
          onTap: _showFacilitySelectionDialog,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            labelText: 'Tap to select facilities',
            labelStyle: TextStyle(color: secondaryTextColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
              BorderSide(color: Colors.grey.withOpacity(0.2)),
            ),
            suffixIcon: Icon(Icons.arrow_drop_down_rounded,
                color: primaryColor),
            filled: true,
            fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
          ),
          validator: (val) =>
          val == null || val.isEmpty ? "Select facilities" : null,
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: allFacilities.map((facility) {
            final isSelected = selectedFacilities.contains(facility);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedFacilities.remove(facility);
                  } else {
                    selectedFacilities.add(facility);
                  }
                  _facilityController.text =
                      selectedFacilities.join(', ');
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? primaryColor.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? primaryColor
                        : Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isSelected
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 14,
                      color: isSelected ? primaryColor : Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        facility,
                        style: TextStyle(
                          color: isSelected
                              ? primaryColor
                              : textColor.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildNearbyFacilitiesSection(
      bool isDarkMode, Color cardColor, Color textColor) {
    if (nearbyHospitals.isEmpty &&
        nearbySchools.isEmpty &&
        nearbyMetros.isEmpty &&
        nearbyMalls.isEmpty &&
        nearbyParks.isEmpty &&
        nearbyCinemas.isEmpty) {
      return const SizedBox();
    }

    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Nearby Facilities', Icons.local_activity_rounded, textColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                if (nearbyHospitals.isNotEmpty)
                  _buildNearbyCard('Hospitals', nearbyHospitals,
                      textColor, isDarkMode),
                if (nearbySchools.isNotEmpty)
                  _buildNearbyCard(
                      'Schools', nearbySchools, textColor, isDarkMode),
                if (nearbyMetros.isNotEmpty)
                  _buildNearbyCard('Metro Stations', nearbyMetros,
                      textColor, isDarkMode),
                if (nearbyMalls.isNotEmpty)
                  _buildNearbyCard('Shopping Malls', nearbyMalls,
                      textColor, isDarkMode),
                if (nearbyParks.isNotEmpty)
                  _buildNearbyCard(
                      'Parks', nearbyParks, textColor, isDarkMode),
                if (nearbyCinemas.isNotEmpty)
                  _buildNearbyCard(
                      'Cinemas', nearbyCinemas, textColor, isDarkMode),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(String title, List<Map<String, dynamic>> places,
      Color textColor, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(
                        place['name'] ?? 'Unknown',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        place['vicinity'] ?? '',
                        style: TextStyle(
                          fontSize: 11,
                          color: textColor.withOpacity(0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 12, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          '${place['rating'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add_home_work_rounded,
                size: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add Building',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'List your property with premium features',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 2,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.amber[400],
                      borderRadius: BorderRadius.circular(2)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(
      {required bool isDarkMode,
        required Color cardColor,
        required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  secondaryColor.withOpacity(0.1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDarkMode,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: secondaryTextColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      prefixIcon: Icon(icon, color: primaryColor),
      suffixText: suffixText,
      filled: true,
      fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
    );
  }

  Widget _buildImageUploadSection(
      bool isDarkMode, Color cardColor, Color textColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.1),
                        secondaryColor.withOpacity(0.1)
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.photo_library_rounded,
                      size: 18, color: primaryColor),
                ),
                const SizedBox(width: 10),
                Text(
                  'Property Images',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                const Spacer(),
                if (_selectedImages.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${1 + _selectedImages.length} images',
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickSingleImage,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _singleImage == null
                                  ? Colors.grey.withOpacity(0.3)
                                  : primaryColor,
                              width: _singleImage == null ? 1 : 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: _singleImage == null
                                ? Colors.grey.withOpacity(0.03)
                                : primaryColor.withOpacity(0.02),
                          ),
                          child: _singleImage == null
                              ? Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_rounded,
                                  size: 24, color: Colors.grey),
                              const SizedBox(height: 4),
                              Text(
                                'Cover Photo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                              : Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(8),
                                child: Image.file(
                                  File(_singleImage!.path),
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets
                                      .symmetric(
                                      horizontal: 6,
                                      vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black
                                        .withOpacity(0.7),
                                    borderRadius:
                                    BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Main',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickMultipleImages,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.02),
                          ),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Icon(Icons.collections_rounded,
                                  size: 28,
                                  color:
                                  Colors.grey.withOpacity(0.6)),
                              const SizedBox(height: 4),
                              Text(
                                _selectedImages.isEmpty
                                    ? 'Add More'
                                    : '+${_selectedImages.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (_selectedImages.isNotEmpty)
                                Text(
                                  'photos',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.withOpacity(0.6),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildImageActionButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Take Photo',
                      onTap: _takePhoto,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 8),
                    _buildImageActionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'From Gallery',
                      onTap: _pickMultipleImages,
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(width: 8),
                    if (_selectedImages.isNotEmpty)
                      _buildImageActionButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'Clear All',
                        onTap: _clearAllImages,
                        isDanger: true,
                        isDarkMode: isDarkMode,
                      ),
                  ],
                ),
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 60,
                          height: 60,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius:
                                BorderRadius.circular(6),
                                child: Image.file(
                                  File(_selectedImages[index].path),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                        Icons.close_rounded,
                                        size: 10,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDanger
                ? Colors.red.withOpacity(0.05)
                : primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDanger
                  ? Colors.red.withOpacity(0.2)
                  : primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 16,
                  color:
                  isDanger ? Colors.red : primaryColor),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color:
                  isDanger ? Colors.red : primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickSingleImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _singleImage = image;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image. Please try again.');
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images =
      await _imagePicker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick images. Please try again.');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _singleImage = image;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to take photo. Please try again.');
    }
  }

  void _clearAllImages() {
    setState(() {
      _selectedImages.clear();
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.white
                        : const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white70
                          : const Color(0xFF2D3748)
                          .withOpacity(0.7),
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _isCounting
              ? null
              : () {
            if (_formKey.currentState!.validate()) {
              _startCountdown();
            }
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isCounting ? Icons.timer : Icons.touch_app,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  _isCounting
                      ? (_countdown == 0
                      ? "Submitting..."
                      : "Submitting in $_countdown")
                      : 'SUBMIT PROPERTY',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _startCountdown() async {
    setState(() {
      _isCounting = true;
      _countdown = 3;
    });

    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      setState(() {
        _countdown = i - 1;
      });
    }

    setState(() {
      _isCounting = false;
    });

    // ✅ Finally submit
    await _handleUpload();
  }

  void _showFacilitySelectionDialog() async {
    final result =
    await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FacilityBottomSheet(
        options: allFacilities,
        selected: selectedFacilities,
      ),
    );

    if (result != null) {
      setState(() {
        selectedFacilities = result;
        _facilityController.text =
            selectedFacilities.join(', ');
      });
    }
  }

  @override
  void dispose() {
    _Ownername.dispose();
    _Owner_number.dispose();
    _Address_apnehisaabka.dispose();
    _CareTaker_name.dispose();
    _CareTaker_number.dispose();
    _vehicleno.dispose();
    _Google_Location.dispose();
    _address.dispose();
    //_Building_information.dispose();
    _facilityController.dispose();
    metroController.dispose();
    localityController.dispose();
    super.dispose();
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
  State<_FacilityBottomSheet> createState() =>
      _FacilityBottomSheetState();
}

class _FacilityBottomSheetState
    extends State<_FacilityBottomSheet> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding =
    (screenWidth * 0.04).clamp(12.0, 20.0);
    final fontSize =
    (screenWidth * 0.04).clamp(14.0, 18.0);
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
    isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor =
    isDarkMode ? Colors.white : const Color(0xFF2D3748);
    final Color primaryBlue = const Color(0xFF2D5BFF);
    final Color secondaryBlue = const Color(0xFF6C63FF);

    // ✅ Responsive + scrollable bottom sheet (NO overflow)
    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsets.all(padding),
                    child: Text(
                      "Select Facilities",
                      style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                  ),
                  // Scrollable list of facilities
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.options.length,
                      itemBuilder: (context, index) {
                        final option = widget.options[index];
                        final isSelected =
                        _tempSelected.contains(option);
                        return CheckboxListTile(
                          title: Text(
                            option,
                            style: TextStyle(
                              color: textColor,
                              fontSize: fontSize * 0.8,
                            ),
                          ),
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
                          controlAffinity:
                          ListTileControlAffinity.leading,
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ),
                  SizedBox(height: padding),
                  Container(
                    width: double.infinity,
                    height: (fontSize * 3)
                        .clamp(45.0, 55.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryBlue, secondaryBlue],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius:
                      BorderRadius.circular(padding * 0.75),
                    ),
                    child: TextButton(
                      onPressed: () =>
                          Navigator.pop(context, _tempSelected),
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize * 0.8,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: padding * 0.5),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

void showMetroLocalityPicker(
    BuildContext context,
    Function(String metro, List<String> localities) onSelected,
    ) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.60,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, controller) {
          return MetroLocalitySheet(
            onSelected: onSelected,
          );
        },
      );
    },
  );
}

class MetroLocalitySheet extends StatefulWidget {
  final Function(String metro, List<String> localities) onSelected;

  const MetroLocalitySheet(
      {super.key, required this.onSelected});

  @override
  State<MetroLocalitySheet> createState() =>
      _MetroLocalitySheetState();
}

class _MetroLocalitySheetState
    extends State<MetroLocalitySheet> {
  final MetroAPI api = MetroAPI();

  final TextEditingController metroCtrl =
  TextEditingController();
  final TextEditingController localityCtrl =
  TextEditingController();

  List<Map<String, dynamic>> metroList = [];
  List<Map<String, dynamic>> nearbyList = [];
  List<Map<String, dynamic>> filteredNearby = [];

  List<String> selectedLocalities = [];

  bool loadingMetro = false;
  bool loadingNearby = false;

  Timer? metroDebounce;
  Timer? localityDebounce;

  String? selectedMetro;

  @override
  void dispose() {
    metroDebounce?.cancel();
    localityDebounce?.cancel();
    super.dispose();
  }

  void searchMetro(String q) {
    if (metroDebounce?.isActive ?? false) {
      metroDebounce!.cancel();
    }

    metroDebounce =
        Timer(const Duration(milliseconds: 300), () async {
          if (q.trim().length < 2) {
            setState(() => metroList = []);
            return;
          }

          setState(() => loadingMetro = true);
          final result = await api.fetchStations(q);
          setState(() {
            metroList = result;
            loadingMetro = false;
          });
        });
  }

  Future<void> fetchNearby(String metroName) async {
    setState(() {
      loadingNearby = true;
      nearbyList = [];
      filteredNearby = [];
      selectedLocalities.clear();
    });

    final result = await api.fetchNearby(metroName);

    setState(() {
      nearbyList = result;
      filteredNearby = result;
      loadingNearby = false;
    });
  }

  void searchLocality(String q) {
    if (localityDebounce?.isActive ?? false) {
      localityDebounce!.cancel();
    }

    localityDebounce =
        Timer(const Duration(milliseconds: 200), () {
          if (q.trim().isEmpty) {
            setState(() => filteredNearby = nearbyList);
            return;
          }

          setState(() {
            filteredNearby = nearbyList
                .where((e) => e["name"]
                .toString()
                .toLowerCase()
                .contains(q.toLowerCase()))
                .toList();
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final bg =
    isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final cardBg = isDark
        ? const Color(0xFF222222)
        : Colors.grey.shade100;
    final textCol =
    isDark ? Colors.white : Colors.black87;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom:
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Text(
            'Bottom Sheet',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: textCol,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: metroCtrl,
            onChanged: searchMetro,
            style: TextStyle(color: textCol),
            decoration: InputDecoration(
              labelText: "Metro Station",
              labelStyle:
              TextStyle(color: textCol.withOpacity(0.8)),
              filled: true,
              fillColor: cardBg,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (loadingMetro)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          if (metroList.isNotEmpty)
            Expanded(
              flex: 3,
              child: ListView.builder(
                itemCount: metroList.length,
                itemBuilder: (_, i) {
                  final m = metroList[i];

                  return ListTile(
                    tileColor: cardBg,
                    title: Text(
                      m["name"],
                      style: TextStyle(color: textCol),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    onTap: () async {
                      metroCtrl.text = m["name"];
                      selectedMetro = m["name"];
                      metroList.clear();
                      FocusScope.of(context).unfocus();
                      await fetchNearby(m["name"]);
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 20),
          TextField(
            controller: localityCtrl,
            onChanged: searchLocality,
            enabled: nearbyList.isNotEmpty,
            style: TextStyle(color: textCol),
            decoration: InputDecoration(
              labelText: nearbyList.isEmpty
                  ? "Select Metro First"
                  : "Search Locality",
              labelStyle:
              TextStyle(color: textCol.withOpacity(0.8)),
              filled: true,
              fillColor: cardBg,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
          ),
          if (loadingNearby)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),
          if (selectedLocalities.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 6,
                children: selectedLocalities
                    .map(
                      (loc) => Chip(
                    label: Text(
                      loc,
                      overflow: TextOverflow.ellipsis,
                    ),
                    backgroundColor: isDark
                        ? Colors.white12
                        : Colors.grey.shade300,
                    deleteIcon: const Icon(Icons.close,
                        size: 18),
                    onDeleted: () {
                      setState(() {
                        selectedLocalities.remove(loc);
                      });
                    },
                  ),
                )
                    .toList(),
              ),
            ),
          const SizedBox(height: 10),
          if (filteredNearby.isNotEmpty)
            Expanded(
              flex: 5,
              child: ListView.builder(
                itemCount: filteredNearby.length,
                itemBuilder: (_, i) {
                  final loc = filteredNearby[i];
                  return Card(
                    color: cardBg,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(
                        loc["name"],
                        style: TextStyle(color: textCol),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        loc["type"] ?? "",
                        style: TextStyle(
                          color:
                          textCol.withOpacity(0.6),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      trailing: Icon(
                        selectedLocalities
                            .contains(loc["name"])
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: Colors.redAccent,
                      ),
                      onTap: () {
                        setState(() {
                          if (!selectedLocalities
                              .contains(loc["name"])) {
                            selectedLocalities.add(loc["name"]);
                          }
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              if (selectedMetro != null) {
                widget.onSelected(
                    selectedMetro!, selectedLocalities);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding: const EdgeInsets.symmetric(
                  vertical: 14, horizontal: 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              "Done",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
