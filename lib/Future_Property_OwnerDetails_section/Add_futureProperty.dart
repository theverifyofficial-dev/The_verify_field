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

import '../ui_decoration_tools/constant.dart';
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
  //String formattedDate = DateFormat('yyyy-MM-dd').format(uploadDate);

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
  final List<String> metro_nameOptions = ['Hauz khas', 'Malviya Nagar', 'Saket','Qutub Minar','ChhattarPur','Sultanpur', 'Ghitorni','Arjan Garh','Guru Drona','Sikanderpur','Dwarka Mor',];
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

  void _generateDateTime() {
    setState(() {
      _date = DateFormat('d-MMMM-yyyy').format(DateTime.now());
      _Time = DateFormat('h:mm a').format(DateTime.now());
    });
  }
  // Format the date as you like

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
      MapEntry("metro_name", metro_name.toString()),
      MapEntry("main_market_distance", selectedMarketDistance ?? ''),
      MapEntry("age_of_property", _ageOfProperty ?? ''),
      MapEntry("total_floor", _totalFloor ?? ''),
      MapEntry("lift", _selectedLift != null ? _selectedLift! : ""),
      MapEntry("current_date_", DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now()),),
      MapEntry("Residence_commercial", _selectedPropertyType!),
      MapEntry("facility", selectedFacilities.join(', ')),
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
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Rajpur Khurd','Mangalpuri','Dwarka Mor','Uttam Nagar','Nawada'];
  String? _selectedLift;
  final List<String> lift_options = ['Yes','No'];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent'];

  List<String> parkingOptions = ['Yes','No'];
  String? _selectedParking;

  String? _typeofproperty;

  List<String> name = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial SP'];

  List<String> tempArray = [];



  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      // backgroundColor: Colors.grey.shade100,
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

              // _buildTextInput('Building Info', _Building_information),



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

              Row(
                children: [
                  Expanded(
                    child:
                    _buildDropdownRow(
                      'Metro Name',
                      metro_nameOptions,
                      metro_name,
                          (val) => setState(() => metro_name = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select metro Name' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                    _buildDropdownRow(
                      'Metro Distance',
                      metroDistanceOptions,
                      selectedMetroDistance,
                          (val) => setState(() => selectedMetroDistance = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select metro distance' : null,
                    ),
                  ),
                ],
              ),
              // _buildDropdownRow(
              //   'Highway Distance (in m)',
              //   highwayDistanceOptions,
              //   selectedHighwayDistance,
              //       (val) => setState(() => selectedHighwayDistance = val),
              //   validator: (val) => val == null || val.isEmpty ? 'Please select highway distance' : null,
              // ),
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
              _buildDropdownRow(
                'Parking',
                parkingOptions,
                _selectedParking,
                    (val) => setState(() => _selectedParking = val),
                validator: (val) => val == null || val.isEmpty ? 'Please select parking type' : null,
              ),

              _buildTextInput('Address for Field Worker', _Address_apnehisaabka),
              UpperCase(  'Owner Vehicle Number (Optional)', _vehicleno, keyboardType: TextInputType.text, toUpperCase: true,),

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

                  double latitude = double.parse(long.replaceAll(RegExp(r'[^0-9.]'),''));
                  double longitude = double.parse(lat.replaceAll(RegExp(r'[^0-9.]'),''));

                  placemarkFromCoordinates(latitude, longitude).then((placemarks) {

                    var output = 'Unable to fetch location';
                    if (placemarks.isNotEmpty) {

                      output = placemarks.reversed.last.street.toString()+', '+placemarks.reversed.last.locality.toString()+', '
                          +placemarks.reversed.last.subLocality.toString()+', '+placemarks.reversed.last.administrativeArea.toString()+', '
                          +placemarks.reversed.last.subAdministrativeArea.toString()+', '+placemarks.reversed.last.country.toString()+', '
                          +placemarks.reversed.last.postalCode.toString();
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
            ],
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

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity, // 🔥 Forces full width
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
