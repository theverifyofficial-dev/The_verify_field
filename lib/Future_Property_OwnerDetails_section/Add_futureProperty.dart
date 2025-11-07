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

class Add_FutureProperty extends StatefulWidget {
  const Add_FutureProperty({super.key});

  @override
  State<Add_FutureProperty> createState() => _Add_FuturePropertyState();
}

class _Add_FuturePropertyState extends State<Add_FutureProperty> {
  bool _isLoading = false;
  List<File> _multipleImages = [];
  final _formKey = GlobalKey<FormState>();

  DateTime uploadDate = DateTime.now();

  List<Map<String, dynamic>> nearbyHospitals = [];
  List<Map<String, dynamic>> nearbySchools = [];
  List<Map<String, dynamic>> nearbyMetros = [];
  List<Map<String, dynamic>> nearbyMalls = [];
  List<Map<String, dynamic>> nearbyParks = [];
  List<Map<String, dynamic>> nearbyCinemas = [];

  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _Longitude = TextEditingController();
  final TextEditingController _Latitude = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();

  String _number = '';
  String _name = '';
  List<String> selectedFacilities = [];

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _getCurrentLocation();
    _generateDateTime();
  }

  String? selectedRoadSize;
  String? selectedMetroDistance;
  String? metro_name;
  String? selectedMarketDistance;
  String? _ageOfProperty;
  String? _totalFloor;
  String? _liftAvailable;

  final List<String> roadSizeOptions = ['15 Feet', '20 Feet', '25 Feet', '30 Feet', '35 Feet', '40 Above'];
  final List<String> metroDistanceOptions = ['200 m', '300 m', '400 m', '500 m', '600 m', '700 m', '1 km', '1.5 km', '2.5 km','2.5+ km'];
  final List<String> metro_nameOptions = ['Hauz khas', 'Malviya Nagar', 'Saket','Qutub Minar','ChhattarPur','Sultanpur', 'Ghitorni','Arjan Garh','Guru Drona','Sikanderpur','Dwarka Mor','Vasant Kunj','Ghitorni'];
  final List<String> _items_floor2 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor'];

  final List<String> marketDistanceOptions = ['200 m', '300 m', '400 m', '500 m', '600 m', '700 m', '1 km', '1.5 km', '2.5 km','2.5+ km'];
  final List<String> Age_Options = ['1 years', '2 years', '3 years', '4 years','5 years','6 years','7 years','8 years','9 years','10 years','10+ years',''];
  List<String> allFacilities = ['CCTV Camera', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline"];

  String long = '';
  String lat = '';
  String full_address = '';

  File? _imageFile;

  DateTime now = DateTime.now();

  String _date = '';
  String _Time = '';

  // Premium Color Scheme
  final Color primaryColor = Color(0xFF2D5BFF);
  final Color secondaryColor = Color(0xFF6C63FF);
  final Color accentColor = Color(0xFF00D4AA);
  final Color backgroundColor = Color(0xFFF8FAFF);
  final Color cardColor = Colors.white;
  final Color textColor = Color(0xFF2D3748);

  void _generateDateTime() {
    setState(() {
      _date = DateFormat('d-MMMM-yyyy').format(DateTime.now());
      _Time = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  Future<void> _getCurrentLocation() async {
    if (await _checkLocationPermission()) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        long = '${position.latitude}';
        lat = '${position.longitude}';
        _Longitude.text = long;
        _Latitude.text = lat;
      });
    } else {
      await _requestLocationPermission();
    }
  }

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      await _getCurrentLocation();
    } else {
      print('Location permission denied');
    }
  }

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85,
    );

    return result;
  }

  Future<void> pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      List<File> temp = [];
      for (var xfile in pickedFiles) {
        final tempDir = await getTemporaryDirectory();
        final targetPath = '${tempDir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg';

        var compressed = await FlutterImageCompress.compressAndGetFile(
          xfile.path,
          targetPath,
          quality: 80,
        );
        if (compressed != null) temp.add(File(compressed.path));
      }
      setState(() {
        _multipleImages = temp;
      });
    }
  }

  String? _selectedPropertyType;
  final List<String> propertyTypes = ['Residential', 'Commercial'];

  Future<void> uploadImageWithTitle(File imageFile) async {
    String uploadUrl = 'https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/new_future_property_api_with_images.php';

    FormData formData = FormData();

    formData.files.add(MapEntry(
      "images",
      await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
    ));

    formData.fields.addAll([
      MapEntry("ownername", _Ownername.text ?? ''),
      MapEntry("ownernumber", _Owner_number.text ?? ''),
      MapEntry("caretakername", _CareTaker_name.text ?? ''),
      MapEntry("caretakernumber", _CareTaker_number.text ?? ''),
      MapEntry("place", _selectedItem ?? ''),
      MapEntry("buy_rent", _selectedItem1 ?? ''),
      MapEntry("typeofproperty", _typeofproperty ?? ''),
      MapEntry("propertyname_address", _address.text),
      MapEntry("building_information_facilitys", _Building_information.text),
      MapEntry("property_address_for_fieldworkar", _Address_apnehisaabka.text),
      MapEntry("owner_vehical_number", _vehicleno.text),
      MapEntry("your_address", _Google_Location.text),
      MapEntry("fieldworkarname", _name),
      MapEntry("fieldworkarnumber", _number),
      MapEntry("current_date", uploadDate.toIso8601String(),),
      MapEntry("longitude", _Longitude.text),
      MapEntry("latitude", _Latitude.text),
      MapEntry("road_size", selectedRoadSize ?? ''),
      MapEntry("parking", _selectedParking ?? ''),
      MapEntry("metro_distance", selectedMetroDistance ?? ''),
      MapEntry("metro_name", metro_name.toString()),
      MapEntry("main_market_distance", selectedMarketDistance ?? ''),
      MapEntry("age_of_property", _ageOfProperty ?? ''),
      MapEntry("total_floor", _totalFloor ?? ''),
      MapEntry("lift", _selectedLift != null ? _selectedLift! : ""),
      MapEntry("current_date_", DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),),
      MapEntry("Residence_commercial", _selectedPropertyType!),
      MapEntry("facility", selectedFacilities.join(', ')),
    ]);

    for (var image in _multipleImages) {
      formData.files.add(MapEntry(
        "img[]",
        await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      ));
    }

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => FrontPage_FutureProperty()),
              (route) => route.isFirst,
        );
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful!')),
        );
        print('Upload successful: ${response.data}');
      }
      else {
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

    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and enter a title')),
      );
      return;
    }

    await uploadImageWithTitle(_imageFile!);
  }

  String? _selectedItem;
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Rajpur Khurd','Mangalpuri','Dwarka Mor','Uttam Nagar','Nawada','Vasant Kunj','Ghitorni'];
  String? _selectedLift;
  final List<String> lift_options = ['Yes','No'];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent'];

  List<String> parkingOptions = ['Yes','No'];
  String? _selectedParking;

  String? _typeofproperty;

  List<String> name = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial SP'];

  List<String> tempArray = [];

  String googleApiKey = "AIzaSyAFB2UEvMTcgeH2MrlX2oUq08yVWPVlVr0";

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Color(0xFF121212) : Color(0xFFF8FAFF);
    final Color cardColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Color(0xFF2D3748);
    final Color secondaryTextColor = isDarkMode ? Colors.white70 : Color(0xFF2D3748).withOpacity(0.6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Image.asset(
          AppImages.transparent,
          height: 45,
          errorBuilder: (context, error, stackTrace) {
            return Text(
              'Add Building',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPremiumHeader(isDarkMode),
              SizedBox(height: 32),
              _buildImageUploadSection(isDarkMode, cardColor, textColor),
              SizedBox(height: 20),
              _buildBasicInfoSection(isDarkMode, cardColor, textColor, secondaryTextColor),
              SizedBox(height: 20),
              _buildContactInfoSection(isDarkMode, cardColor, textColor, secondaryTextColor),
              SizedBox(height: 20),
              _buildPropertyDetailsSection(isDarkMode, cardColor, textColor, secondaryTextColor),
              SizedBox(height: 20),
              _buildLocationSection(isDarkMode, cardColor, textColor, secondaryTextColor),
              SizedBox(height: 20),
              _buildNearbyFacilitiesSection(isDarkMode, cardColor, textColor),
              SizedBox(height: 40),
              _buildPremiumSubmitButton(),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28),
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
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_home_work_rounded, size: 32, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Building',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'List your property with premium features',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                    height: 2,
                    width: 198,
                    decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(2)
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard({required Widget child, required Color cardColor}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(0.1), secondaryColor.withOpacity(0.1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(bool isDarkMode, Color cardColor, Color textColor) {
    return _buildPremiumCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor.withOpacity(0.1), secondaryColor.withOpacity(0.1)],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.photo_library_rounded, size: 18, color: primaryColor),
                ),
                SizedBox(width: 10),
                Text(
                  'Property Images',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
                Spacer(),
                if (_multipleImages.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${1 + _multipleImages.length} images',
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
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Main Image with Gallery in Row
                Row(
                  children: [
                    // Main Image
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          XFile? pickedXFile = await pickAndCompressImage();
                          File? pickedImage = pickedXFile != null ? File(pickedXFile.path) : null;
                          if (pickedImage != null) {
                            setState(() {
                              _imageFile = pickedImage;
                            });
                          }
                        },
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _imageFile == null ? Colors.grey.withOpacity(0.3) : primaryColor,
                              width: _imageFile == null ? 1 : 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: _imageFile == null ? Colors.grey.withOpacity(0.03) : primaryColor.withOpacity(0.02),
                          ),
                          child: _imageFile == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_rounded, size: 24, color: Colors.grey),
                              SizedBox(height: 4),
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
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _imageFile!,
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
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

                    SizedBox(width: 12),

                    // Gallery Images
                    Expanded(
                      child: GestureDetector(
                        onTap: pickMultipleImages,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.3), width: 1),
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.grey.withOpacity(0.02),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.collections_rounded, size: 28, color: Colors.grey.withOpacity(0.6)),
                              SizedBox(height: 4),
                              Text(
                                _multipleImages.isEmpty ? 'Add More' : '+${_multipleImages.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (_multipleImages.isNotEmpty)
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

                // Quick Actions Row
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildImageActionButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Take Photo',
                      onTap: () async {
                        final picker = ImagePicker();
                        final pickedFile = await picker.pickImage(source: ImageSource.camera);
                        if (pickedFile != null) {
                          setState(() {
                            _imageFile = File(pickedFile.path);
                          });
                        }
                      },
                    ),
                    SizedBox(width: 8),
                    _buildImageActionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'From Gallery',
                      onTap: pickMultipleImages,
                    ),
                    SizedBox(width: 8),
                    if (_multipleImages.isNotEmpty)
                      _buildImageActionButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'Clear All',
                        onTap: () {
                          setState(() {
                            _multipleImages.clear();
                          });
                        },
                        isDanger: true,
                      ),
                  ],
                ),

                // Selected Images Mini Preview
                if (_multipleImages.isNotEmpty) ...[
                  SizedBox(height: 12),
                  Container(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _multipleImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(right: 6),
                          width: 60,
                          height: 60,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  _multipleImages[index],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _multipleImages.removeAt(index);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.close_rounded,
                                        size: 10, color: Colors.white),
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
          SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDanger ? Colors.red.withOpacity(0.05) : primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDanger ? Colors.red.withOpacity(0.2) : primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 16,
                  color: isDanger ? Colors.red : primaryColor),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDanger ? Colors.red : primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(bool isDarkMode, Color cardColor, Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Basic Information', Icons.info_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Place',
                        value: _selectedItem,
                        items: _items,
                        onChanged: (val) => setState(() => _selectedItem = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select a Place' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Buy / Rent',
                        value: _selectedItem1,
                        items: _items1,
                        onChanged: (val) => setState(() => _selectedItem1 = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select Buy/Rent' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Total Floor',
                        value: _totalFloor,
                        items: _items_floor2,
                        onChanged: (val) => setState(() => _totalFloor = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select total floor' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Property Type',
                        value: _selectedPropertyType,
                        items: propertyTypes,
                        onChanged: (val) => setState(() => _selectedPropertyType = val),
                        validator: (val) => val == null || val.isEmpty ? 'Select Property Type' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection(bool isDarkMode, Color cardColor, Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Contact Information', Icons.contact_phone_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildTextInputField(
                  label: 'Owner Name (Optional)',
                  controller: _Ownername,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                SizedBox(height: 16),
                _buildTextInputField(
                  label: 'Owner No. (Optional)',
                  controller: _Owner_number,
                  keyboardType: TextInputType.phone,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                SizedBox(height: 16),
                _buildTextInputField(
                  label: 'CareTaker Name (Optional)',
                  controller: _CareTaker_name,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                SizedBox(height: 16),
                _buildTextInputField(
                  label: 'CareTaker No. (Optional)',
                  controller: _CareTaker_number,
                  keyboardType: TextInputType.phone,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPropertyDetailsSection(bool isDarkMode, Color cardColor, Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Property Details', Icons.home_work_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildTextInputField(
                  label: 'Property Name & Address',
                  controller: _address,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter property address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildFacilityField(textColor, secondaryTextColor),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Road width (in ft)',
                        value: selectedRoadSize,
                        items: roadSizeOptions,
                        onChanged: (val) => setState(() => selectedRoadSize = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select road size' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Age of property',
                        value: _ageOfProperty,
                        items: Age_Options,
                        onChanged: (val) => setState(() => _ageOfProperty = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select age' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Metro Name',
                        value: metro_name,
                        items: metro_nameOptions,
                        onChanged: (val) => setState(() => metro_name = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select metro name' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Metro Distance',
                        value: selectedMetroDistance,
                        items: metroDistanceOptions,
                        onChanged: (val) => setState(() => selectedMetroDistance = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select metro distance' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Market Distance',
                        value: selectedMarketDistance,
                        items: marketDistanceOptions,
                        onChanged: (val) => setState(() => selectedMarketDistance = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select market distance' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: _buildDropdownField(
                        label: 'Lift Availability',
                        value: _selectedLift,
                        items: lift_options,
                        onChanged: (val) => setState(() => _selectedLift = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select lift availability' : null,
                        textColor: textColor,
                        secondaryTextColor: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _buildDropdownField(
                  label: 'Parking',
                  value: _selectedParking,
                  items: parkingOptions,
                  onChanged: (val) => setState(() => _selectedParking = val),
                  validator: (val) => val == null || val.isEmpty ? 'Please select parking type' : null,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLocationSection(bool isDarkMode, Color cardColor, Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Location Details', Icons.location_on_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildTextInputField(
                  label: 'Address for Field Worker',
                  controller: _Address_apnehisaabka,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter address for field worker';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                _buildUpperCaseField(
                  label: 'Owner Vehicle Number (Optional)',
                  controller: _vehicleno,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                ),
                SizedBox(height: 16),
                _buildTextInputField(
                  label: 'Google Location',
                  controller: _Google_Location,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Google location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 14, color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Enter Address manually or get your current Address from one tap on location button',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [primaryColor, secondaryColor],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () async {
                        double? latitude = double.tryParse(long);
                        double? longitude = double.tryParse(lat);

                        if (latitude == null || longitude == null) {
                          print("Invalid coordinates! long: $long, lat: $lat");
                          return;
                        }

                        try {
                          List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
                          var output = 'Unable to fetch location';
                          if (placemarks.isNotEmpty) {
                            final place = placemarks.first;
                            List<String> parts = [
                              place.street,
                              place.subLocality,
                              place.locality,
                              place.subAdministrativeArea,
                              place.administrativeArea,
                              place.postalCode,
                              place.country,
                            ].whereType<String>()
                                .where((e) => e.trim().isNotEmpty)
                                .toList();
                            output = parts.join(', ');
                          }
                          setState(() {
                            full_address = output;
                            _Google_Location.text = full_address;
                          });
                        } catch (e) {
                          print('Error getting location: $e');
                        }
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.my_location_rounded, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Get Current Location',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNearbyFacilitiesSection(bool isDarkMode, Color cardColor, Color textColor) {
    if (nearbyHospitals.isEmpty && nearbySchools.isEmpty && nearbyMetros.isEmpty &&
        nearbyMalls.isEmpty && nearbyParks.isEmpty && nearbyCinemas.isEmpty) {
      return SizedBox();
    }

    return _buildPremiumCard(
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Nearby Facilities', Icons.local_activity_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                if (nearbyHospitals.isNotEmpty) _buildNearbyCard('Hospitals', nearbyHospitals, textColor),
                if (nearbySchools.isNotEmpty) _buildNearbyCard('Schools', nearbySchools, textColor),
                if (nearbyMetros.isNotEmpty) _buildNearbyCard('Metro Stations', nearbyMetros, textColor),
                if (nearbyMalls.isNotEmpty) _buildNearbyCard('Shopping Malls', nearbyMalls, textColor),
                if (nearbyParks.isNotEmpty) _buildNearbyCard('Parks', nearbyParks, textColor),
                if (nearbyCinemas.isNotEmpty) _buildNearbyCard('Cinemas', nearbyCinemas, textColor),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNearbyCard(String title, List<Map<String, dynamic>> places, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        SizedBox(height: 8),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: places.length,
            itemBuilder: (context, index) {
              final place = places[index];
              return Container(
                width: 200,
                margin: EdgeInsets.only(right: 12),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'] ?? 'Unknown',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      place['vicinity'] ?? '',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star_rounded, size: 12, color: Colors.amber),
                        SizedBox(width: 4),
                        Text(
                          '${place['rating'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 10,
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

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: secondaryTextColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        dropdownColor: cardColor,
        style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
        icon: Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
        items: items.map((String item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item, style: TextStyle(color: textColor)),
          );
        }).toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Widget _buildTextInputField({
    required String label,
    required TextEditingController controller,
    TextInputType? keyboardType,
    required Color textColor,
    required Color secondaryTextColor,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
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
      ),
      validator: validator,
    );
  }

  Widget _buildUpperCaseField({
    required String label,
    required TextEditingController controller,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return TextFormField(
      controller: controller,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      textCapitalization: TextCapitalization.characters,
      decoration: InputDecoration(
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
      ),
    );
  }

  Widget _buildFacilityField(Color textColor, Color secondaryTextColor) {
    return TextFormField(
      controller: _facilityController,
      readOnly: true,
      onTap: _showFacilitySelectionDialog,
      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: 'Select Facilities',
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
        suffixIcon: Icon(Icons.arrow_drop_down_rounded, color: primaryColor),
      ),
      validator: (val) => val == null || val.isEmpty ? "Select facilities" : null,
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
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _isLoading
              ? null
              : () async {
            if (!_formKey.currentState!.validate()) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    "Form Incomplete",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  content: Text(
                    "Please fill all the required fields before submitting.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text("OK"),
                    )
                  ],
                ),
              );
              return;
            }

            setState(() {
              _isLoading = true;
            });

            int countdown = 3;

            await showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setStateDialog) {
                    Future.delayed(const Duration(seconds: 1), () async {
                      if (countdown > 1) {
                        setStateDialog(() {
                          countdown--;
                        });
                      } else {
                        setStateDialog(() {
                          countdown = 0;
                        });

                        await Future.delayed(const Duration(seconds: 1));
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        }

                        await _handleUpload();

                        if (!mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("✅ Submitted Successfully!"),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    });

                    return AlertDialog(
                      backgroundColor: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        "Submitting...",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
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
                                color: Theme.of(context).brightness == Brightness.dark
                                    ? Colors.red[300]
                                    : Colors.red,
                              ),
                            )
                                : Icon(
                              Icons.verified_rounded,
                              key: ValueKey<String>("verified"),
                              color: Colors.green,
                              size: 60,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            countdown > 0 ? "Please wait..." : "Verified!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            );

            setState(() {
              _isLoading = false;
            });
          },
          child: Center(
            child: _isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 18,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                SizedBox(width: 12),
                Text(
                  "Processing...",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.rocket_launch_rounded, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'SUBMIT PROPERTY',
                  style: TextStyle(
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

  void _showFacilitySelectionDialog() async {
    final result = await showModalBottomSheet<List<String>>(
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
        _facilityController.text = selectedFacilities.join(', ');
      });
    }
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
    });
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Color(0xFF1E1E1E) : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Color(0xFF2D3748);

    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Select Facilities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                ),
              ),
              ...widget.options.map((option) {
                final isSelected = _tempSelected.contains(option);
                return CheckboxListTile(
                  title: Text(option, style: TextStyle(color: textColor)),
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
              SizedBox(height: 16),
              Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF2D5BFF), Color(0xFF6C63FF)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextButton(
                  onPressed: () => Navigator.pop(context, _tempSelected),
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}