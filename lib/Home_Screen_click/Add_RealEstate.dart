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
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Home_Screen_click/Real-Estate.dart';
import '../ui_decoration_tools/app_images.dart';

class  Add_Realestate extends StatefulWidget {
  @override
  _Add_RealestateState createState() => _Add_RealestateState();
}

class _Add_RealestateState extends State<Add_Realestate> {

  bool _isLoading = false;

  /*void _handleButtonClick() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network request or any async task
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }*/

  File? _image;
  final TextEditingController _propertyNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _sqft = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _Sell_price = TextEditingController();
  final TextEditingController _Verify_Price = TextEditingController();
  final TextEditingController _maintenance = TextEditingController();
  final TextEditingController _flat = TextEditingController();
  final TextEditingController _furnished_details = TextEditingController();
  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _Longitude = TextEditingController();
  final TextEditingController _Latitude = TextEditingController();
  final TextEditingController _district = TextEditingController();
  final TextEditingController _policestation = TextEditingController();
  final TextEditingController _pincode = TextEditingController();
  File? _imageFile;

  String long = '';
  String lat = '';
  String full_address = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _getCurrentLocation();
    _generateDateTime();
  }

  String _number = '';
  String _name = '';

  DateTime now = DateTime.now();

  // Format the date as you like
  late String formattedDate;

  Future<void> _getCurrentLocation() async {
    // Check for location permissions
    if (await _checkLocationPermission()) {
      try {
        // Get the current location
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        if (!mounted) return; // ⛔ prevent calling setState if widget is disposed

        setState(() {
          long = '${position.longitude}';
          lat = '${position.latitude}';
          _Longitude.text = long;
          _Latitude.text = lat;
        });
      } catch (e) {
        // Optional: handle error
        print('Error fetching location: $e');
      }
    } else {
      // If permissions are not granted, request them
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

  String? Place_,buyrent,resident_commercial,typeofproperty,bhk,furnished,District,policesttion,pincode,parking,balcony,kitchen,bathroom;

  String _date = '';
  String _Time = '';

  void _generateDateTime() {
    setState(() {
      _date = DateFormat('d-MMMM-yyyy').format(DateTime.now());
      _Time = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  get _RestorationId => null;

  // actual image upload

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    formattedDate = "${now.day}_${now.month}_${now.year}";

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/verify_${formattedDate}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85, // Compression quality
    );

    return result;
  }

  Future<void> uploadImageWithTitle(File imageFile, String propertyNumber, String address, String sqft, String price, String maintenance, String floor, String flat, String furnished_details, String Ownername, String Owner_number, String Building_information, String Address_apnehisaabka, String _CareTaker_number,
      String Place_,String Buy_Rent,String Residence_Commercial,String Looking_Property_,String Typeofproperty,String Bhk_Squarefit,String Furnished,String Parking,String balcony,String kitchen,String Baathroom,
      String date_,String fieldworkarname,String fieldworkarnumber,String Longtitude,String Latitude,
      String facility,String blank_one,String Blank_two,String Blank_three,String district,String policestation,String pincode,String Google_Location,String Sell_price,String Verify_Price,String caretaker_name) async {
    String uploadUrl = 'https://verifyserve.social/insert.php';
    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
      "Property_Number": propertyNumber,
      "Address_": _address.text,
      "City": sqft,
      "Price": price,
      "maintenance": maintenance,
      "floor_": floor,
      "flat_": flat,
      "Details": furnished_details,
      "Ownername": Ownername,
      "Owner_number": Owner_number,
      "Building_information": Building_information,
      "Address_apnehisaabka": Address_apnehisaabka,
      "CareTaker_number": _CareTaker_number,

      "Place_": Place_,
      "Buy_Rent": Buy_Rent,
      "Residence_Commercial": Residence_Commercial,
      "Looking_Property_": "Flat",
      "Typeofproperty": Typeofproperty,
      "Bhk_Squarefit": Bhk_Squarefit,
      "Furnished": Furnished,
      "Parking": Parking,
      "balcony": balcony,
      "kitchen": kitchen,
      "Baathroom": Baathroom,

      "date_": date_,
      "fieldworkarname": fieldworkarname,
      "fieldworkarnumber": fieldworkarnumber,
      "Longtitude": Longtitude,
      "Latitude": Latitude,

      "Lift": facility,
      "Security_guard": blank_one,
      "Goverment_meter": Blank_two,
      "CCTV": Blank_three,
      "District": "_district",
      "Police_Station": "_policestation",
      "Pin_Code": "_pincode",
      "Wifi": Google_Location,
      "Waterfilter": Sell_price,
      "Gas_meter": Verify_Price,
      "Water_geyser": caretaker_name,
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Upload successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful')),
        );
        setState(() {
          _isLoading = false;
        });
        print('Upload successful: ${response.data}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
        Fluttertoast.showToast(
            msg: "Error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
      Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print('Error occurred: $e');
    }
  }

  Future<void> _handleUpload() async {
    if (_imageFile == null) {
      Fluttertoast.showToast(
          msg: "Image are required",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );

      return;
    }

    await uploadImageWithTitle(_imageFile!, _propertyNumber.text, _address.text
        , _sqft.text, _price.text, _maintenance.text, _floor1.toString(), _flat.text, _furnished_details.text
        , _Ownername.text, _Owner_number.text, _Building_information.text, _Address_apnehisaabka.text, _CareTaker_number.text,

        _selectedItem.toString(),_selectedItem1.toString(),resident_commercial.toString(),"Flat",_typeofproperty.toString(),
        _bhk.toString(),furnished.toString(),_Parking.toString(),_Balcony.toString(),_Kitchen.toString(),_Bathroom.toString(),

        _date,_name,_number,_Longitude.text,_Latitude.text,

        tempArray.toString()," "," "," ","District","Police Station","Pin Code",_Google_Location.text,
        _Sell_price.text,_Verify_Price.text,_CareTaker_name.text);
  }

  List<String> name = ['Lift','Security CareTaker','GOVT Meter','CCTV','Gas Meter'];

  List<String> tempArray = [];

  String? _selectedItem;
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Manglapuri','Rajpur Khurd','Maidan Garhi','JonaPur','Dera Mandi','Gadaipur','Fatehpur Beri','Mehrauli','Sat Bari','Neb Sarai','Saket'];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent'];

  String? _floor1;
  final List<String> _items_floor1 = ['Ground Floor','First Floor','Second Floor','Third Floor','Forth Floor','Fifth Floor','Sixth Floor','Seventh Floor','Eighth Floor','Ninth Floor','Tenth Floor'];

  String? _selectedItem2;
  final List<String> _items2 = ['Residence','Commercial'];

  String? _typeofproperty;
  final List<String> __typeofproperty1 = ['Flat','Office','Shop','Farms','Godown','Plots'];

  String? _bhk;
  final List<String> _bhk1 = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial'];

  String? _Balcony;
  final List<String> _balcony_items = ['Front Side Balcony','Back Side Balcony','Window','No'];

  String? _Parking;
  final List<String> _Parking_items = ['Car/Bike','Only bike','No'];

  String? _Kitchen;
  final List<String> _kitchen_items = ['Western Style','Indian Style','No'];

  String? _Bathroom;
  final List<String> _bathroom_items = ['Western Style','Indian Style','No'];

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.black,
      backgroundColor: Colors.white,

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
              child: _buildButton(
                text: 'Add Images',
                onPressed: () async {
                  XFile? pickedImage = await pickAndCompressImage();
                  if (pickedImage != null) {
                    setState(() => _imageFile = File(pickedImage.path));
                  }
                },
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildButton(
                text: 'Submit',
                onPressed: () async {
                  if (_imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please select an image')),
                    );
                    return;
                  }
                  setState(() => _isLoading = true);
                  await _handleUpload();
                  setState(() => _isLoading = false);
                  Navigator.pop(context);

                },
                isDarkMode: isDarkMode,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Picker Section
            _buildImagePickerSection(isDarkMode),
            SizedBox(height: 24),

            // Basic Information Section
            _buildSectionHeader('Basic Information', isDarkMode),
            SizedBox(height: 16),

            // Place and Transaction Type
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Place',
                    value: _selectedItem,
                    items: _items,
                    onChanged: (value) => setState(() => _selectedItem = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Buy/Rent',
                    value: _selectedItem1,
                    items: _items1,
                    onChanged: (value) => setState(() => _selectedItem1 = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Owner Information
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Owner Name',
                    controller: _Ownername,
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Owner Number',
                    controller: _Owner_number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10), // max 10 chars
                      FilteringTextInputFormatter.digitsOnly, // digits only
                    ],

                    keyboardType: TextInputType.phone,

                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Caretaker Information
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Caretaker Name',
                    controller: _CareTaker_name,
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Caretaker Number',
                    controller: _CareTaker_number,
                    keyboardType: TextInputType.phone,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            // Property Details Section
            _buildSectionHeader('Property Details', isDarkMode),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Property Name & Address',
              controller: _address,
              isDarkMode: isDarkMode,
              maxLines: 2,
            ),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Building Information',
              controller: _Building_information,
              isDarkMode: isDarkMode,
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // Property Type and BHK
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Property Type',
                    value: _typeofproperty,
                    items: __typeofproperty1,
                    onChanged: (value) => setState(() => _typeofproperty = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'BHK',
                    value: _bhk,
                    items: _bhk1,
                    onChanged: (value) => setState(() => _bhk = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Pricing Information
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Rent Price',
                    controller: _propertyNumber,
                    prefixText: '₹',
                    keyboardType: TextInputType.number,
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Maintenance',
                    controller: _maintenance,
                    prefixText: '₹',
                    keyboardType: TextInputType.number,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Selling Price',
                    controller: _Sell_price,
                    prefixText: '₹',
                    keyboardType: TextInputType.number,
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildTextField(
                    label: 'Verified Price',
                    controller: _Verify_Price,
                    prefixText: '₹',
                    keyboardType: TextInputType.number,
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Area and Floor
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                    label: 'Square Feet',
                    controller: _sqft,
                    suffixText: 'sqft',
                    keyboardType: TextInputType.number,
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Floor',
                    value: _floor1,
                    items: _items_floor1,
                    onChanged: (value) => setState(() => _floor1 = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Property Features
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Parking',
                    value: _Parking,
                    items: _Parking_items,
                    onChanged: (value) => setState(() => _Parking = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Balcony',
                    value: _Balcony,
                    items: _balcony_items,
                    onChanged: (value) => setState(() => _Balcony = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                    label: 'Kitchen',
                    value: _Kitchen,
                    items: _kitchen_items,
                    onChanged: (value) => setState(() => _Kitchen = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDropdown(
                    label: 'Bathroom',
                    value: _Bathroom,
                    items: _bathroom_items,
                    onChanged: (value) => setState(() => _Bathroom = value),
                    isDarkMode: isDarkMode,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),

            // Furnishing
            _buildDropdown(
              label: 'Furnishing',
              value: furnished,
              items: ['Unfurnished','Semi-furnished','Fully-furnished'],
              onChanged: (value) => setState(() => furnished = value),
              isDarkMode: isDarkMode,
            ),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Furnishing Details',
              controller: _furnished_details,
              isDarkMode: isDarkMode,
              maxLines: 2,
            ),
            SizedBox(height: 24),

            // Location Section
            _buildSectionHeader('Location', isDarkMode),
            SizedBox(height: 16),

            _buildTextField(
              label: 'Field Worker Address',
              controller: _Address_apnehisaabka,
              isDarkMode: isDarkMode,
              maxLines: 2,
            ),
            SizedBox(height: 16),

            _buildLocationField(isDarkMode),
            SizedBox(height: 24),

            // Facilities Section
            _buildSectionHeader('Facilities', isDarkMode),
            SizedBox(height: 16),

            _buildFacilitiesList(isDarkMode),
            SizedBox(height: 24),

            // Submit Buttons

          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'PoppinsBold',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Color(0xFF2D3748),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildImagePickerSection(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Property Image',
          style: TextStyle(
            fontFamily: 'PoppinsBold',
            fontSize: 19,
            color: isDarkMode ? Colors.white: Colors.black87,
          ),
        ),
        SizedBox(height: 12),
        GestureDetector(
          onTap: () async {
            XFile? pickedImage = await pickAndCompressImage();
            if (pickedImage != null) {
              setState(() => _imageFile = File(pickedImage.path)); // ✅ fixed here
            }
          },
          child: Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.white10 : Color(0xFFF7FAFC),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDarkMode ? Colors.white10  : Color(0xFFE2E8F0),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: isDarkMode ? Colors.black54 : Color(0xFFEDF2F7),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: _imageFile != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(_imageFile!, fit: BoxFit.cover),
            )
                : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_rounded,
                  size: 42,
                  color: isDarkMode ? Color(0xFFCBD5E0) : Color(0xFF718096),
                ),
                SizedBox(height: 10),
                Text(
                  'Tap to add image',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                      fontSize: 12,
                      color: isDarkMode ? Color(0xFFA0AEC0) : Colors.grey.shade700,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDarkMode,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: isDarkMode ? Color(0xFFCBD5E0) : Color(0xFF4A5568),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode ? Colors.white10 : Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black26 : Color(0xFFEDF2F7),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 14),
          child: DropdownButton<String>(
            value: value,
            hint: Text(
              'Select $label',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600
              ),
            ),
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: isDarkMode ? Color(0xFFCBD5E0) : Color(0xFF4A5568),
            ),
            isExpanded: true,
            underline: SizedBox(),
            dropdownColor: isDarkMode ? Color(0xFF2D3748) : Colors.white,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isDarkMode ? Colors.white : Color(0xFF2D3748),
            ),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isDarkMode = true,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? prefixText,
    String? suffixText,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,  // <-- Add this
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: isDarkMode ? Color(0xFFCBD5E0) : Color(0xFF4A5568),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode ? Colors.white10 : Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black26 : Color(0xFFEDF2F7),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            inputFormatters: inputFormatters,  // <-- use it here
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isDarkMode ? Colors.white : Color(0xFF2D3748),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: 'Enter $label',
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
              ),
              prefixText: prefixText,
              suffixText: suffixText,
              border: InputBorder.none,
            ),
            validator: validator,
          ),
        ),
      ],
    );
  }



  Widget _buildLocationField(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Address',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: isDarkMode ? Color(0xFFCBD5E0) : Color(0xFF4A5568),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ?Colors.white10 : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10),
            ),
            border: Border.all(
              color: isDarkMode ? Colors.white10 : Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black26 : Color(0xFFEDF2F7),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _Google_Location,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: isDarkMode ? Colors.white : Color(0xFF2D3748),
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              hintText: 'Enter your address',
              hintStyle: TextStyle(
                fontFamily: 'Poppins',
                  fontSize: 12,
                  color: isDarkMode ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w600
              ),
              prefixIcon: Icon(
                Icons.location_on_rounded,
                color: Colors.blue.shade300, // Changed to green
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
              double latitude =
                  double.tryParse(lat.replaceAll(RegExp(r'[^\d\.\-]'), '')) ??
                      0.0;
              double longitude =
                  double.tryParse(long.replaceAll(RegExp(r'[^\d\.\-]'), '')) ??
                      0.0;

              List<Placemark> placemarks =
                  await placemarkFromCoordinates(latitude, longitude);

              String output = 'Unable to fetch location';
              if (placemarks.isNotEmpty) {
                Placemark place = placemarks.first;
                output =
                    '${place.street}, ${place.subLocality}, ${place.locality}, '
                    '${place.subAdministrativeArea}, ${place.administrativeArea}, '
                    '${place.country}, ${place.postalCode}';
              }

              setState(() {
                full_address = output;
                _Google_Location.text = full_address;
              });
            } catch (e) {
               print('Error: ${e.toString()}');
            }
          },
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              color:  Colors.blue.shade200, // Green shades
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              border: Border.all(
                color:  Colors.blue.shade200,
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                'Get Current Location',
                style: TextStyle(
                  fontFamily: 'PoppinsBold',
                  color: isDarkMode ? Colors.white : Colors.white,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFacilitiesList(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Facilities',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: isDarkMode ? Color(0xFFCBD5E0) : Color(0xFF4A5568),
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.white10 : Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isDarkMode ?Colors.white10 : Color(0xFFE2E8F0),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isDarkMode ? Colors.black26 : Color(0xFFEDF2F7),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(vertical: 4),
            itemCount: name.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(
                  name[index],
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: isDarkMode ? Colors.white : Color(0xFF2D3748),
                  ),
                ),
                value: tempArray.contains(name[index]),
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      tempArray.add(name[index]);
                    } else {
                      tempArray.remove(name[index]);
                    }
                  });
                },
                activeColor: isDarkMode ? Colors.white70 : Colors.blue, // Green
                checkColor: isDarkMode ? Colors.black : Colors.white,
                tileColor: isDarkMode ? Colors.transparent : Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required bool isDarkMode,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Color(0xFF3182CE), Color(0xFF63B3ED)] // Dark mode blue gradient
              : [Color(0xFF4299E1), Color(0xFF90CDF4)], // Light mode blue gradient
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode ? Colors.black54 : Color(0xFFBEE3F8),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent, // Makes button transparent
          shadowColor: Colors.transparent, // Removes default shadow
          elevation: 0, // Removes default elevation
        ),
        onPressed: onPressed,
        child: _isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : Text(
          text,
          style: TextStyle(
            fontFamily: 'PoppinsBold',
            color: Colors.white,
            fontSize: 16,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}
