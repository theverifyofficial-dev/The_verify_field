import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Home_Screen_click/Real-Estate.dart';

import '../ui_decoration_tools/app_images.dart';

class Add_Property_Verification extends StatefulWidget {
  @override
  _Add_Property_VerificationState createState() => _Add_Property_VerificationState();
}

class _Add_Property_VerificationState extends State<Add_Property_Verification> {

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
  final TextEditingController _floor = TextEditingController();
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

  String long = '';
  String lat = '';
  String full_address = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _getCurrentLocation();
  }

  String _number = '';
  String _name = '';

  DateTime now = DateTime.now();

  // Format the date as you like
  late String formattedDate;

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

  String? Place_,buyrent,resident_commercial,typeofproperty,bhk,furnished,parking,balcony,kitchen,bathroom;

  get _RestorationId => null;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadData() async {
    if (_image == null) {
      print('Image and name are required');
      Fluttertoast.showToast(
          msg: "Image and name are required",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    formattedDate = "${now.year}-${now.month}-${now.day}";


    try {
      final mimeTypeData = lookupMimeType(_image!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('https://verifyserve.social/insert.php'), // Replace with your API endpoint
      );

      final file = await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
      // Text Feild
      imageUploadRequest.fields['Property_Number'] = _propertyNumber.text;
      imageUploadRequest.fields['Address_'] = _address.text;
      imageUploadRequest.fields['City'] = _sqft.text;
      imageUploadRequest.fields['Price'] = _price.text;
      imageUploadRequest.fields['maintenance'] = _maintenance.text;
      imageUploadRequest.fields['floor_'] = _floor.text;
      imageUploadRequest.fields['flat_'] = _flat.text;
      imageUploadRequest.fields['Details'] = _furnished_details.text;
      imageUploadRequest.fields['Ownername'] = _Ownername.text;
      imageUploadRequest.fields['Owner_number'] = _Owner_number.text;
      imageUploadRequest.fields['Building_information'] = _Building_information.text;
      imageUploadRequest.fields['Address_apnehisaabka'] = _Address_apnehisaabka.text;
      imageUploadRequest.fields['CareTaker_number'] = _CareTaker_number.text;
      // Dropdown
      imageUploadRequest.fields['Place_'] = _selectedItem.toString();
      imageUploadRequest.fields['Buy_Rent'] = _selectedItem1.toString();
      imageUploadRequest.fields['Residence_Commercial'] = resident_commercial.toString();
      imageUploadRequest.fields['Looking_Property_'] = "Book";
      imageUploadRequest.fields['Typeofproperty'] = _typeofproperty.toString();
      imageUploadRequest.fields['Bhk_Squarefit'] = _bhk.toString();
      imageUploadRequest.fields['Furnished'] = furnished.toString();
      imageUploadRequest.fields['Parking'] = _Parking.toString();
      imageUploadRequest.fields['balcony'] = _Balcony.toString();
      imageUploadRequest.fields['kitchen'] = _Kitchen.toString();
      imageUploadRequest.fields['Baathroom'] = _Bathroom.toString();
      // Auto Fill
      imageUploadRequest.fields['date_'] = formattedDate;
      imageUploadRequest.fields['fieldworkarname'] = _name;
      imageUploadRequest.fields['fieldworkarnumber'] = _number;
      imageUploadRequest.fields['Longtitude'] = _Longitude.text;
      imageUploadRequest.fields['Latitude'] = _Latitude.text;
      // Buttons
      imageUploadRequest.fields['Lift'] = tempArray.toString();
      imageUploadRequest.fields['Security_guard'] = " ";
      imageUploadRequest.fields['Goverment_meter'] = " ";
      imageUploadRequest.fields['CCTV'] = " ";
      imageUploadRequest.fields['Powerbackup'] = " ";
      imageUploadRequest.fields['Watertank'] = " ";
      imageUploadRequest.fields['Rooftop'] = " ";
      imageUploadRequest.fields['Wifi'] = _Google_Location.text;
      imageUploadRequest.fields['Waterfilter'] = _Sell_price.text;
      imageUploadRequest.fields['Gas_meter'] = _Verify_Price.text;
      imageUploadRequest.fields['Water_geyser'] = _CareTaker_name.text;

      imageUploadRequest.files.add(file);

      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Data uploaded successfully');
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_Real_Estate(),), (route) => route.isFirst);
        setState(() {
          _isLoading = false;
        });
      } else {

        setState(() {
          _isLoading = true;
        });
        /*print('Data upload failed with status: ${response.statusCode}');

        Fluttertoast.showToast(
            msg: "Press Button Again...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );*/

        _uploadData_two();

      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  Future<void> _uploadData_two() async {
    if (_image == null) {
      print('Image and name are required');
      Fluttertoast.showToast(
          msg: "Image and name are required",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    formattedDate = "${now.year}-${now.month}-${now.day}";


    try {
      final mimeTypeData = lookupMimeType(_image!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('https://verifyserve.social/insert.php'), // Replace with your API endpoint
      );

      final file = await http.MultipartFile.fromPath(
        'image',
        _image!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
      // Text Feild
      imageUploadRequest.fields['Property_Number'] = _propertyNumber.text;
      imageUploadRequest.fields['Address_'] = _address.text;
      imageUploadRequest.fields['City'] = _sqft.text;
      imageUploadRequest.fields['Price'] = _price.text;
      imageUploadRequest.fields['maintenance'] = _maintenance.text;
      imageUploadRequest.fields['floor_'] = _floor.text;
      imageUploadRequest.fields['flat_'] = _flat.text;
      imageUploadRequest.fields['Details'] = _furnished_details.text;
      imageUploadRequest.fields['Ownername'] = _Ownername.text;
      imageUploadRequest.fields['Owner_number'] = _Owner_number.text;
      imageUploadRequest.fields['Building_information'] = _Building_information.text;
      imageUploadRequest.fields['Address_apnehisaabka'] = _Address_apnehisaabka.text;
      imageUploadRequest.fields['CareTaker_number'] = _CareTaker_number.text;
      // Dropdown
      imageUploadRequest.fields['Place_'] = _selectedItem.toString();
      imageUploadRequest.fields['Buy_Rent'] = _selectedItem1.toString();
      imageUploadRequest.fields['Residence_Commercial'] = resident_commercial.toString();
      imageUploadRequest.fields['Looking_Property_'] = "Book";
      imageUploadRequest.fields['Typeofproperty'] = _typeofproperty.toString();
      imageUploadRequest.fields['Bhk_Squarefit'] = _bhk.toString();
      imageUploadRequest.fields['Furnished'] = furnished.toString();
      imageUploadRequest.fields['Parking'] = _Parking.toString();
      imageUploadRequest.fields['balcony'] = _Balcony.toString();
      imageUploadRequest.fields['kitchen'] = _Kitchen.toString();
      imageUploadRequest.fields['Baathroom'] = _Bathroom.toString();
      // Auto Fill
      imageUploadRequest.fields['date_'] = formattedDate;
      imageUploadRequest.fields['fieldworkarname'] = _name;
      imageUploadRequest.fields['fieldworkarnumber'] = _number;
      imageUploadRequest.fields['Longtitude'] = _Longitude.text;
      imageUploadRequest.fields['Latitude'] = _Latitude.text;
      // Buttons
      imageUploadRequest.fields['Lift'] = tempArray.toString();
      imageUploadRequest.fields['Security_guard'] = " ";
      imageUploadRequest.fields['Goverment_meter'] = " ";
      imageUploadRequest.fields['CCTV'] = " ";
      imageUploadRequest.fields['Powerbackup'] = " ";
      imageUploadRequest.fields['Watertank'] = " ";
      imageUploadRequest.fields['Rooftop'] = " ";
      imageUploadRequest.fields['Wifi'] = _Google_Location.text;
      imageUploadRequest.fields['Waterfilter'] = _Sell_price.text;
      imageUploadRequest.fields['Gas_meter'] = _Verify_Price.text;
      imageUploadRequest.fields['Water_geyser'] = _CareTaker_name.text;

      imageUploadRequest.files.add(file);

      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Data uploaded successfully');
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_Real_Estate(),), (route) => route.isFirst);
        setState(() {
          _isLoading = false;
        });
      } else {

        setState(() {
          _isLoading = true;
        });

        /*print('Data upload failed with status: ${response.statusCode}');

        Fluttertoast.showToast(
            msg: "Press Button Again...",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );*/

        _uploadData();

      }
    } catch (e) {
      print('Error uploading data: $e');
    }
  }

  List<String> name = ['Lift','Security CareTaker','GOVT Meter','CCTV','Gas Meter'];

  List<String> tempArray = [];

  String? _selectedItem;
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Hauz Khas','Uttam Nagar East','Uttam Nagar West','Janak Puri East','Janak Puri West','Dwarka Mor'];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent'];

  String? _selectedItem2;
  final List<String> _items2 = ['Residence','Commercial'];

  String? _typeofproperty;
  final List<String> __typeofproperty1 = ['Flat','Office','Shop','Showroom','Godown'];

  String? _bhk;
  final List<String> _bhk1 = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial SP'];

  String? _Balcony;
  final List<String> _balcony_items = ['Front Side Balcony','Back Side Balcony','Window','No'];

  String? _Parking;
  final List<String> _Parking_items = ['Car & Bike','Only bike','No'];

  String? _Kitchen;
  final List<String> _kitchen_items = ['Western Style','Indian Style','No'];

  String? _Bathroom;
  final List<String> _bathroom_items = ['Western Style','Indian Style','No'];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
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
        actions:  [
          GestureDetector(
            onTap: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.image,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[

              Container(
                margin: EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: _pickImage,
                      child: Text('Pick Image',style: TextStyle(color: Colors.white),),
                    ),

                    SizedBox(
                      width: 80,
                    ),

                    Container(
                      width: 100,
                      height: 100,
                      child: _image != null
                          ? Image.file(_image!)
                          : Center(child: Text('No image selected.',style: TextStyle(color: Colors.white),)),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Place',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedItem,
                              hint: Text('Place',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              dropdownColor: Colors.grey.shade600,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedItem = newValue;
                                  print(_selectedItem);
                                });
                              },
                              items: _items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Buy / Rent',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedItem1,
                              hint: Text('Buy / Rent',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              dropdownColor: Colors.grey.shade600,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedItem1 = newValue;
                                });
                              },
                              items: _items1.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white),),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Row(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Owner Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _Ownername,
                              decoration: InputDecoration(
                                  hintText: "Owner Name",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Owner Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _Owner_number,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "Owner Number",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('CareTaker Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _CareTaker_name,
                              decoration: InputDecoration(
                                  hintText: "Name",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('CareTaker Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _CareTaker_number,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "Number",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Property Name & Address',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 5,),

                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: K.boxShadow,
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _address,
                      decoration: InputDecoration(
                          hintText: "Enter Property Name & Address",
                          prefixIcon: Icon(
                            Icons.circle,
                            color: Colors.black54,
                          ),
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                          border: InputBorder.none),
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Building Information & Facilitys',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 5,),

                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: K.boxShadow,
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _Building_information,
                      decoration: InputDecoration(
                          hintText: "Enter Building Information & Facilitys",
                          prefixIcon: Icon(
                            Icons.circle,
                            color: Colors.black54,
                          ),
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                          border: InputBorder.none),
                    ),
                  ),

                  SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Type Of Property',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _typeofproperty,
                              hint: Text('Property Type',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              dropdownColor: Colors.grey.shade600,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _typeofproperty = newValue;
                                  print(_typeofproperty);
                                });
                              },
                              items: __typeofproperty1.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Select BHK',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _bhk,
                              hint: Text('Select BHK',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              dropdownColor: Colors.grey.shade600,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _bhk = newValue;
                                });
                              },
                              items: _bhk1.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white),),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                    ],
                  ),


                  SizedBox(height: 20),

                  Row(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Rent price',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _propertyNumber,
                              decoration: InputDecoration(
                                  hintText: "Rent price",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Maintenance Cost',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _maintenance,
                              decoration: InputDecoration(
                                  hintText: "Maintenance Cost",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Owner Sell price',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _Sell_price,
                              decoration: InputDecoration(
                                  hintText: "Owner Sell price",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Verify price',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _Verify_Price,
                              decoration: InputDecoration(
                                  hintText: "Verify price",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Owner Last Price',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _price,
                              decoration: InputDecoration(
                                  hintText: "Owner Last Price",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Square Feet',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _sqft,
                              decoration: InputDecoration(
                                  hintText: "Square Feet",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('floor Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _floor,
                              decoration: InputDecoration(
                                  hintText: "floor Number",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Flat Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 5,),

                          Container(
                            width: 155,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              // boxShadow: K.boxShadow,
                            ),
                            child: TextField(
                              style: TextStyle(color: Colors.black),
                              controller: _flat,
                              decoration: InputDecoration(
                                  hintText: "Flat Number",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Parking',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _Parking,
                              hint: Text('Parking',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              dropdownColor: Colors.grey.shade600,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _Parking = newValue;
                                  print(_Parking);
                                });
                              },
                              items: _Parking_items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Balcony',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _Balcony,
                              hint: Text('Balcony',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              underline: SizedBox(),
                              dropdownColor: Colors.grey.shade600,
                              onChanged: (String? newValue) {
                                setState(() {
                                  _Balcony = newValue;
                                });
                              },
                              items: _balcony_items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white),),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Kitchen',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _Kitchen,
                              hint: Text('Kitchen',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              dropdownColor: Colors.grey.shade600,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _Kitchen = newValue;
                                  print(_Kitchen);
                                });
                              },
                              items: _kitchen_items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white)),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                      SizedBox(
                        width: 10,
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Container(
                              padding: EdgeInsets.only(left: 5),
                              child: Text('Bathroom',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _Bathroom,
                              hint: Text('Bathroom',style: TextStyle(color: Colors.white)),
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 24,
                              dropdownColor: Colors.grey.shade600,
                              underline: SizedBox(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _Bathroom = newValue;
                                });
                              },
                              items: _bathroom_items.map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,style: TextStyle(color: Colors.white),),
                                );
                              }).toList(),
                            ),
                          ),
                          /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                        ],
                      ),

                    ],
                  ),

                  SizedBox(height: 20),

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Furnished',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 5,),

                  Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      //color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(width: 1, color: Colors.white),
                      // boxShadow: K.boxShadow,
                    ),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          PhosphorIcons.map_pin_line,
                          color: Colors.white,
                        ),
                      ),
                      padding: EdgeInsets.only(right: 10,left: 0),
                      hint: const Text('Select Furnished Type',style: TextStyle(color: Colors.white),),
                      value: furnished,
                      dropdownColor: Colors.grey.shade600,
                      borderRadius: BorderRadius.circular(30),
                      onChanged: (String? newValue) {
                        setState(() {
                          furnished = newValue!;
                        });
                      },
                      items: <String>['Unfurnished','Semi-furnished','Fully-furnished']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(color: Colors.white),),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(height: 20,),


                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Property Furnished Details',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 5,),

                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: K.boxShadow,
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _furnished_details,
                      decoration: InputDecoration(
                          hintText: "Enter Property Furnished Details",
                          prefixIcon: Icon(
                            Icons.circle,
                            color: Colors.black54,
                          ),
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                          border: InputBorder.none),
                    ),
                  ),

                  SizedBox(height: 20),

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Property Address For Feild Worker',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 5,),

                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: K.boxShadow,
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _Address_apnehisaabka,
                      decoration: InputDecoration(
                          hintText: "Enter Property Address For Feild Worker",
                          prefixIcon: Icon(
                            Icons.circle,
                            color: Colors.black54,
                          ),
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                          border: InputBorder.none),
                    ),
                  ),

                  SizedBox(height: 20),

                  ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: name.length,
                      itemBuilder: (context, index){
                        return InkWell(
                          onTap: (){
                            setState(() {
                              if(tempArray.contains(name[index].toString())){
                                tempArray.remove(name[index].toString());
                              }else{
                                tempArray.add(name[index].toString());
                              }
                            });

                            print(tempArray.toString());

                          },
                          child: Card(
                            child: ListTile(
                              title: Text(name[index].toString()),
                              trailing: Container(
                                height: 40,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: tempArray.contains(name[index].toString()) ? Colors.red : Colors.green,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                child: Center(
                                  child: Text(tempArray.contains(name[index].toString()) ? 'Remove' : 'Add'),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),


                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1, color: Colors.white),
                    ),
                    child: Text.rich(
                        TextSpan(
                            text: 'Note:-',
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),
                            children: <InlineSpan>[
                              TextSpan(
                                text: ' Enter Address manually or get your current Address from one tap on location icon.',
                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey.shade400,fontFamily: 'Poppins',letterSpacing: 0),
                              )
                            ]
                        )),
                  ),

                  const SizedBox(height: 10,),

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Address',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 5,),

                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10),bottomRight: Radius.circular(0),bottomLeft: Radius.circular(0)),
                      // boxShadow: K.boxShadow,
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black),
                      controller: _Google_Location,
                      decoration: InputDecoration(
                          hintText: "Your Address",
                          prefixIcon: Icon(
                            PhosphorIcons.map_pin,
                            color: Colors.black,
                          ),
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                          border: InputBorder.none),
                    ),
                  ),



                  SizedBox(height: 5,),

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

                        // _isLoading
                        //     ? Center(child: CircularProgressIndicator())
                        //     :

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
                        border: Border.all(width: 1, color: Colors.red),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.red.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                              blurStyle: BlurStyle.outer// changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(child: Text('Get Current Location',style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 1),)),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  // const SizedBox(height: 20,),

                  Visibility(
                    visible: false,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: K.boxShadow,
                      ),
                      child: TextField(
                        controller: _Longitude,
                        decoration: InputDecoration(
                            hintText: "Enter Longitude",
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
                              color: Colors.black54,
                            ),
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),
                  ),

                  //const SizedBox(height: 20,),

                  Visibility(
                    visible: false,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: K.boxShadow,
                      ),
                      child: TextField(
                        controller: _Latitude,
                        decoration: InputDecoration(
                            hintText: "Enter Latitude",
                            prefixIcon: Icon(
                              Icons.person_2_outlined,
                              color: Colors.black54,
                            ),
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),
                  ),




                ],
              ),




              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  _uploadData();
                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: 200,
                    // margin: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: Colors.red.withOpacity(0.8)),
                    child: _isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Center(
                      child: Text(
                        "Submit",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                            fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
    });
  }

}
