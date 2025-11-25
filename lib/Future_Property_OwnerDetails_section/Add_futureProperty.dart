import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Future_Property.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'metro_api.dart';


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
  //String formattedDate = DateFormat('yyyy-MM-dd').format(uploadDate);

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
  final TextEditingController metroController = TextEditingController();
  final TextEditingController localityController = TextEditingController();

  String _number = '';
  String _name = '';
  List<String> selectedFacilities=[];

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

  // String? selectedHighwayDistance;
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
  String? selectedLocality;


  void _generateDateTime() {
    setState(() {
      _date = DateFormat('d-MMMM-yyyy').format(DateTime.now());
      _Time = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  Future<void> _getCurrentLocation() async {
    // Check for location permissions
    if (await _checkLocationPermission()) {
      // Get the current location
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
      // Permission granted, try getting the location again
      await _getCurrentLocation();
    } else {
      // Permission denied, handle accordingly
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

    // Single image
    formData.files.add(MapEntry(
      "images",
      await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
    ));
    // Text Fields
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
      MapEntry("main_market_distance", selectedMarketDistance ?? ''),
      MapEntry("age_of_property", _ageOfProperty ?? ''),
      MapEntry("total_floor", _totalFloor ?? ''),
      MapEntry("lift", _selectedLift != null ? _selectedLift! : ""),
      MapEntry("current_date_", DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),),
      MapEntry("Residence_commercial", _selectedPropertyType!),
      MapEntry("facility", selectedFacilities.join(', ')),
      // MapEntry("metro_name", metro_name ?? ''),
      // MapEntry("locality_list", selectedLocality ?? ''),
      MapEntry("metro_name", metroController.text),
      MapEntry("locality_list", localityController.text),


    ]);

    // Multiple images
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
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Rajpur Khurd','Mangalpuri','Dwarka Mor','Uttam Nagar','Nawada','Vasant Kunj','Ghitorni'];
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





  // Future<List<Map<String, dynamic>>> getNearbyPlaces(
  //     double latitude, double longitude, String placeType) async {
  //
  //   final url =
  //       "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=$latitude,$longitude&radius=2000&type=$placeType&key=$googleApiKey";
  //
  //   final response = await http.get(Uri.parse(url));
  //   print("Google Places API Response for $placeType: ${response.body}");
  //
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body);
  //     final results = data['results'] as List<dynamic>;
  //     return results.map((e) => e as Map<String, dynamic>).toList();
  //   } else {
  //     throw Exception("Failed to fetch places");
  //   }
  // }
  //
  // Future<void> fetchNearbyFacilities(Position position) async {
  //   double latitude = position.latitude;
  //   double longitude = position.longitude;
  //
  //   print("Fetching nearby places for lat: $latitude, long: $longitude");
  //
  //   try {
  //     var hospitals = await getNearbyPlaces(latitude, longitude, "hospital");
  //     var schools = await getNearbyPlaces(latitude, longitude, "school");
  //     var metros = await getNearbyPlaces(latitude, longitude, "subway_station");
  //     var malls = await getNearbyPlaces(latitude, longitude, "shopping_mall");
  //     var parks = await getNearbyPlaces(latitude, longitude, "park");
  //     var cinemas = await getNearbyPlaces(latitude, longitude, "movie_theater");
  //
  //     setState(() {
  //       nearbyHospitals = hospitals;
  //       nearbySchools = schools;
  //       nearbyMetros = metros;
  //       nearbyMalls = malls;
  //       nearbyParks = parks;
  //       nearbyCinemas = cinemas;
  //
  //       if (metros.isNotEmpty) metro_name = metros.first['name'];
  //     });
  //   } catch (e) {
  //     print("Error fetching nearby facilities: $e");
  //   }
  // }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add Building",style: TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black,fontSize: 25,fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 5,),
              _buildSectionCard(
                title: 'Upload Main Image',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: const Text('Pick Image', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
                      onPressed: () async {
                        XFile? pickedXFile = await pickAndCompressImage();
                        File? pickedImage = pickedXFile != null ? File(pickedXFile.path) : null;
                        if (pickedImage != null) {
                          setState(() {
                            _imageFile = pickedImage;
                          });
                        }
                      },
                    ),
                    _imageFile != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(_imageFile!, width: 150, height: 120, fit: BoxFit.cover),
                    )
                        : const Text('No image selected', style: TextStyle()),
                  ],
                ),
              ),
              const SizedBox(height: 20,),
              _buildSectionCard(
                title: 'Upload Multiple Images',
                child: Column(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.collections, color: Colors.white),
                      label: const Text('Pick Images', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
                      onPressed: pickMultipleImages,
                    ),
                    const SizedBox(height: 10),

                    // Show selected images count
                    Text(
                      "Selected Images: ${_multipleImages.length}",
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, ),
                    ),

                    const SizedBox(height: 10),
                    _multipleImages.isNotEmpty
                        ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _multipleImages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    _multipleImages[index],
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 0,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _multipleImages.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                        : const Text('No images selected', style: TextStyle()),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child:
                    _buildDropdownRow('Place', _items, _selectedItem, (val) => setState(() => _selectedItem = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select a Place' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                    _buildDropdownRow('Buy / Rent', _items1, _selectedItem1, (val) => setState(() => _selectedItem1 = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select a Buy/Rent' : null,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdownRow('Total floor', _items_floor2, _totalFloor, (val) => setState(() => _totalFloor = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select a balcony type' : null,
                    ),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: _buildDropdownRow(
                      'Property Type',
                      propertyTypes,
                      _selectedPropertyType,
                          (val) => setState(() => _selectedPropertyType = val),
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Select Property Type' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              buildTextInput('Owner Name (Optional)', _Ownername,),
              buildTextInput('Owner No. (Optional)', _Owner_number, keyboardType: TextInputType.phone, validateLength: true),
              buildTextInput('CareTaker Name (Optional)', _CareTaker_name,),
              buildTextInput('CareTaker No. (Optional)', _CareTaker_number,keyboardType: TextInputType.phone,validateLength: true),


              _buildTextInput('Property Name & Address', _address),
              _buildSectionCard(
                child: TextFormField(
                  controller: _facilityController,
                  readOnly: true, // Prevents manual editing
                  onTap: _showFacilitySelectionDialog, // Opens the selection dialog
                  style:  TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Select Facilities',
                    hintStyle:  TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,

                    // ✅ Error text style
                    errorStyle: const TextStyle(
                      color: Colors.redAccent, // deep red text
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),

                    // ✅ Error border (deep red)
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                    ),

                    // ✅ Focused border when error
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Colors.redAccent,
                        width: 2,
                      ),
                    ),

                  ),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Select facilities"
                      : null,
                ), title: 'Facility',
              ),

              const SizedBox(height: 10,),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildDropdownRow(
                      'Road width (in ft)',
                      roadSizeOptions,
                      selectedRoadSize,
                          (val) => setState(() => selectedRoadSize = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select road size' : null,
                    ),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: _buildDropdownRow(
                      'Age of property',
                      Age_Options,
                      _ageOfProperty,
                          (val) => setState(() => _ageOfProperty = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select market distance' : null,
                    ),
                  ),
                ],
              ),



              /// ------------------ METRO FIELD ------------------
              _buildSectionCard(
                title: "Metro Station",
                child: TextFormField(
                  controller: metroController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Select Metro Station",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    showMetroLocalityPicker(context, (metro, localities) {
                      setState(() {
                        metroController.text = metro;
                        localityController.text = localities.join(", ");
                      });
                    });
                  },
                ),
              ),

              /// ------------------ LOCALITY FIELD ------------------
              _buildSectionCard(
                title: "Localities",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: localityController,
                      readOnly: true,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: "Selected Localities",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // SHOW CHIPS VISUALLY
                    if (localityController.text.trim().isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: localityController.text
                            .split(",")
                            .map((loc) => Chip(
                          label: Text(loc.trim()),
                          backgroundColor: Colors.grey.shade600,
                        ))
                            .toList(),
                      ),
                  ],
                ),
              ),


              Row(
                children: [
                  Expanded(
                    child: _buildDropdownRow(
                      'Market Distance',
                      marketDistanceOptions,
                      selectedMarketDistance,
                          (val) => setState(() => selectedMarketDistance = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select market distance' : null,
                    ),
                  ),
                  SizedBox(width: 6,),

                  Expanded( child: _buildDropdownRow( 'Metro Distance', metroDistanceOptions, selectedMetroDistance, (val) => setState(() => selectedMetroDistance = val), validator: (val) => val == null || val.isEmpty ? 'Please select metro distance' : null, ), ), ], ),


              Row(
                children: [
                  Expanded(
                    child: _buildDropdownRow(
                      'Parking',
                      parkingOptions,
                      _selectedParking,
                          (val) => setState(() => _selectedParking = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select parking type' : null,
                    ),
                  ),
                  SizedBox(width: 6,),

                  Expanded(
                    child: _buildDropdownRow(
                      'Lift Availability',
                      lift_options,
                      _selectedLift,
                          (val) => setState(() => _selectedLift = val),
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Lift Availability' : null,
                    ),
                  ),
                ],
              ),

              _buildTextInput('Address for Field Worker', _Address_apnehisaabka),
              UpperCase(  'Owner Vehicle Number (Optional)', _vehicleno, keyboardType: TextInputType.text, toUpperCase: true,),

              const SizedBox(height: 20),

              buildNearbyCard('Nearby Hospitals', nearbyHospitals),
              buildNearbyCard('Nearby Schools', nearbySchools),
              buildNearbyCard('Nearby Metro Stations', nearbyMetros),
              buildNearbyCard('Nearby Malls', nearbyMalls),
              buildNearbyCard('Nearby Parks', nearbyParks),
              buildNearbyCard('Nearby Cinemas', nearbyCinemas),

              const SizedBox(height: 8),


              _buildTextInput('Google Location', _Google_Location, icon: PhosphorIcons.map_pin),
              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade600),
                ),
                child: Text.rich(
                    TextSpan(
                        text: 'Note :',
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Poppins',letterSpacing: 0),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' Enter Address manually or get your current Address from one tap on location icon.',
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,fontFamily: 'Poppins',letterSpacing: 0),
                          )
                        ]
                    )),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: ()async {

                  double? latitude = double.tryParse(long);
                  double? longitude = double.tryParse(lat);

                  placemarkFromCoordinates(latitude!, longitude!).then((placemarks) {

                    var output = 'Unable to fetch location';
                    if (placemarks.isNotEmpty) {
                      final place = placemarks.first;

                      // Collect all available parts, ignoring null or empty ones
                      List<String> parts = [
                        place.street,
                        place.subLocality,
                        place.locality,
                        place.subAdministrativeArea,
                        place.administrativeArea,
                        place.postalCode,
                        place.country,
                      ].whereType<String>() // 👈 filters out null automatically
                          .where((e) => e.trim().isNotEmpty) // 👈 removes empty strings
                          .toList();

                      // Join them with commas
                      output = parts.join(', ');
                    }
                    setState(() {
                      full_address = output;

                      _Google_Location.text = full_address;

                      print('Your Current Address:- $full_address');
                    });

                  });
                },


                child: Container(

                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(0),topLeft: Radius.circular(0),bottomRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                      border: Border.all(width: 1, color: Colors.blue),
                      color: Colors.blue.shade600
                  ),
                  child: Center(child: Text('Get Current Location',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 1),)),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                    // 🔹 Validate form first
                    if (!_formKey.currentState!.validate()) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                            "Form Incomplete",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          content: const Text(
                            "Please fill all the required fields before submitting.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Text("OK"),
                            )
                          ],
                        ),
                      );
                      return; // ❌ Stop here if empty fields
                    }

                    setState(() {
                      _isLoading = true;
                    });

                    int countdown = 3;

                    // Show dialog
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
                                // ✅ When countdown ends, show verified
                                setStateDialog(() {
                                  countdown = 0;
                                });

                                await Future.delayed(const Duration(seconds: 1));
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop(); // close dialog
                                }

                                // Run your upload logic
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
                              backgroundColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.grey[900]
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: const Text(
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
                                        color: Theme.of(context).brightness ==
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
                                      color: Theme.of(context).brightness ==
                                          Brightness.dark
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

                    setState(() {
                      _isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
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
                      : const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
          ]
          ),
          ),
        ),
    );
  }
  TextInputFormatter upperCaseTextFormatter() {
    return TextInputFormatter.withFunction(
          (oldValue, newValue) {
        return TextEditingValue(
          text: newValue.text.toUpperCase(),
          selection: newValue.selection,
        );
      },
    );
  }
  Widget UpperCase(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType,
        bool toUpperCase = false,
      }) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        // style: const TextStyle(color: Colors.black),
        textCapitalization:
        toUpperCase ? TextCapitalization.characters : TextCapitalization.none,
        inputFormatters:
        toUpperCase ? [upperCaseTextFormatter()] : null,
        decoration: InputDecoration(
          hintText: 'Enter $label',
          // hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          // fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget buildNearbyCard(String title, List<Map<String, dynamic>> places) {
    if (places.isEmpty) return SizedBox(); // hide if empty
    return _buildSectionCard(
      title: title,
      child: SizedBox(
        height: 100,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: places.length,
          itemBuilder: (context, index) {
            final place = places[index];
            return Card(
              margin: EdgeInsets.symmetric(horizontal: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 3,
              child: Container(
                width: 160,
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      place['name'] ?? 'Unknown',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      place['vicinity'] ?? '',
                      style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Rating: ${place['rating'] ?? 'N/A'}',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }


  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
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

  Widget _buildTextInput(String label, TextEditingController controller, {IconData? icon, TextInputType? keyboardType}) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType, // <--- Add this line
        // style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle:  TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
          filled: true,
          // ✅ Error text style (deep red)
          errorStyle: const TextStyle(
            color: Colors.redAccent, // deeper red text
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),

          // ✅ Error border (deep red)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent, // deep red border
              width: 2,
            ),
          ),

          // ✅ Focused border when still error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent, // deep red border when focused
              width: 2,
            ),
            // fillColor: Colors.grey.shade100,
          ),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }

  Widget buildTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType,
        bool validateLength = false, // keep if you still want digit-only & length limiter
      }) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: 'Enter $label',
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
        ),
        inputFormatters: validateLength
            ? [
          FilteringTextInputFormatter.digitsOnly, // only digits
          LengthLimitingTextInputFormatter(10),   // max 10 digits
        ]
            : [],
      ),
    );
  }

  Widget _buildDropdownRow(
      String label,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged, {
        String? Function(String?)? validator,
      }) {
    return _buildSectionCard(
      title: label,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
        validator: validator,
        // dropdownColor: Colors.grey.shade100,
        decoration: InputDecoration(
          filled: true,
          // fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)

          ),

          // ✅ Error text style
          errorStyle: const TextStyle(
            color: Colors.redAccent, // deep red text
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),

          // ✅ Error border (deep red)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),

          // ✅ Focused border when error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),


        // style: const TextStyle(color: Colors.grey),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style:  TextStyle(fontSize: 10)),
        ))
            .toList(),
      ),
    );
  }




  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, fontFamily: 'Poppins');
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
    });
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

}


// -----------------------------------------------------
//              METRO + LOCALITY PICKER
// -----------------------------------------------------

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

  const MetroLocalitySheet({super.key, required this.onSelected});

  @override
  State<MetroLocalitySheet> createState() => _MetroLocalitySheetState();
}

class _MetroLocalitySheetState extends State<MetroLocalitySheet> {
  final MetroAPI api = MetroAPI();

  // Controllers
  final TextEditingController metroCtrl = TextEditingController();
  final TextEditingController localityCtrl = TextEditingController();

  // State
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

  /* ------------------------ FETCH METRO ------------------------ */
  void searchMetro(String q) {
    if (metroDebounce?.isActive ?? false) metroDebounce!.cancel();

    metroDebounce = Timer(const Duration(milliseconds: 300), () async {
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

  /* ------------------------ FETCH LOCALITIES ------------------------ */
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

  /* ------------------------ FILTER LOCALITY ------------------------ */
  void searchLocality(String q) {
    if (localityDebounce?.isActive ?? false) localityDebounce!.cancel();

    localityDebounce = Timer(const Duration(milliseconds: 200), () {
      if (q.trim().isEmpty) {
        setState(() => filteredNearby = nearbyList);
        return;
      }

      setState(() {
        filteredNearby = nearbyList
            .where((e) =>
            e["name"].toString().toLowerCase().contains(q.toLowerCase()))
            .toList();
      });
    });
  }

  /* ------------------------ MAIN UI ------------------------ */
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF222222) : Colors.grey.shade100;
    final textCol = isDark ? Colors.white : Colors.black87;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
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

          Text('Bottom Sheet',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
          SizedBox(height: 10,),

          TextField(
            controller: metroCtrl,
            onChanged: searchMetro,
            style: TextStyle(color: textCol),
            decoration: InputDecoration(
              labelText: "Metro Station",
              labelStyle: TextStyle(color: textCol.withOpacity(0.8)),
              filled: true,
              fillColor: cardBg,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
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
                    title: Text(m["name"], style: TextStyle(color: textCol)),
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

          /* ------------------- LOCALITY INPUT ------------------- */
          TextField(
            controller: localityCtrl,
            onChanged: searchLocality,
            enabled: nearbyList.isNotEmpty,
            style: TextStyle(color: textCol),
            decoration: InputDecoration(
              labelText: nearbyList.isEmpty
                  ? "Select Metro First"
                  : "Search Locality",
              labelStyle: TextStyle(color: textCol.withOpacity(0.8)),
              filled: true,
              fillColor: cardBg,
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            ),
          ),

          if (loadingNearby)
            const Padding(
              padding: EdgeInsets.all(10),
              child: CircularProgressIndicator(),
            ),

          /* ------------------- SELECTED CHIPS ------------------- */
          if (selectedLocalities.isNotEmpty)
            Wrap(
              spacing: 6,
              children: selectedLocalities
                  .map(
                    (loc) => Chip(
                  label: Text(loc),
                  backgroundColor:
                  isDark ? Colors.white12 : Colors.grey.shade300,
                  deleteIcon: const Icon(Icons.close, size: 18),
                  onDeleted: () {
                    setState(() {
                      selectedLocalities.remove(loc);
                    });
                  },
                ),
              )
                  .toList(),
            ),

          const SizedBox(height: 10),

          /* ------------------- LOCALITY LIST ------------------- */
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
                      title: Text(loc["name"],
                          style: TextStyle(color: textCol)),
                      subtitle: Text(
                        loc["type"] ?? "",
                        style: TextStyle(
                          color: textCol.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                      trailing: Icon(
                        selectedLocalities.contains(loc["name"])
                            ? Icons.check_circle
                            : Icons.add_circle_outline,
                        color: Colors.redAccent,
                      ),
                      onTap: () {
                        setState(() {
                          if (!selectedLocalities.contains(loc["name"])) {
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
                widget.onSelected(selectedMetro!, selectedLocalities);
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              padding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Done",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
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

      child: Container(
        // color: Colors.white,
        child: Padding(
          padding:
          EdgeInsets.only(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Select Facilities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                ),
              ),
              ...widget.options.map((option) {
                final isSelected = _tempSelected.contains(option);
                return CheckboxListTile(
                  title: Text(option,style: TextStyle(),),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background
                  foregroundColor: Colors.black, // Text/icon color
                  side: const BorderSide(color: Colors.black), // Optional border
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context, _tempSelected),
                child: const Text("Done"),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}


