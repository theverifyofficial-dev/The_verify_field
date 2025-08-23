import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Home_Screen_click/Real-Estate.dart';
import 'ui_decoration_tools/constant.dart';

class PersonalDocument extends StatefulWidget {
  const PersonalDocument({super.key});

  @override
  State<PersonalDocument> createState() => _PersonalDocumentState();
}

class _PersonalDocumentState extends State<PersonalDocument> {

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
  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _Father_name = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _Occupation = TextEditingController();
  final TextEditingController _Dateofbirth = TextEditingController();
  final TextEditingController _Permanant_Address = TextEditingController();
  final TextEditingController _PinCode = TextEditingController();
  final TextEditingController _District = TextEditingController();
  final TextEditingController _Police_Station = TextEditingController();
  File? _pick_AddharCard_FrontImage;
  File? _pick_AddharCard_BlackImage;
  //File? _pick_AddharCard_FrontImage;

  String long = '';
  String lat = '';
  String full_address = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _getCurrentLocation();
  }

  /*String _number = '';
  String _name = '';*/

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

  String? Place_,buyrent,resident_commercial,typeofproperty,bhk,furnished,District,policesttion,pincode,parking,balcony,kitchen,bathroom;



  get _RestorationId => null;

  // actuall image upload

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
    String uploadUrl = 'https://verifyserve.social/insert.php'; // Replace with your API endpoint

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
    if (_pick_AddharCard_FrontImage == null) {
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
    if (_pick_AddharCard_BlackImage == null) {
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

    await uploadImageWithTitle(_pick_AddharCard_FrontImage!, _propertyNumber.text, _address.text
        , _sqft.text, _price.text, _maintenance.text, _floor1.toString(), _flat.text, _furnished_details.text
        , _Ownername.text, _Owner_number.text, _Building_information.text, _Address_apnehisaabka.text, _CareTaker_number.text,

        _selectedItem.toString(),_selectedItem1.toString(),resident_commercial.toString(),"Flat",_typeofproperty.toString(),
        _bhk.toString(),furnished.toString(),_Parking.toString(),_Balcony.toString(),_Kitchen.toString(),_Bathroom.toString(),

        formattedDate,"_name","_number",_Longitude.text,_Latitude.text,

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
  final List<String> _items_floor1 = ['G-Floor','1st Floor','2nd Floor','3rd Floor','4th Floor','5th Floor','6th Floor','UG Floor','LG FLoor'];

  String? _selectedItem2;
  final List<String> _items2 = ['Residence','Commercial'];

  String? _typeofproperty;
  final List<String> __typeofproperty1 = ['Flat','Office','Shop','Farms','Godown','Plots'];

  String? _bhk;
  final List<String> _bhk1 = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial'];

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
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.image,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 20),

              Container(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () async {
                              File? pickedImage = (await pickAndCompressImage()) as File?;
                              if (pickedImage != null) {
                                setState(() {
                                  _pick_AddharCard_FrontImage = pickedImage;
                                });
                              }
                            },
                            child: Text('Pick Aaddhar Card Front Image',style: TextStyle(color: Colors.white),),
                          ),

                          SizedBox(
                            width: 80,
                          ),

                          Container(
                            width: 100,
                            height: 100,
                            child: _pick_AddharCard_FrontImage != null
                                ? Image.file(_pick_AddharCard_FrontImage!)
                                : Center(child: Text('No image selected.',style: TextStyle(color: Colors.white),)),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),

              Container(
                child: Column(
                  children: [

                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                            onPressed: () async {
                              File? pickedImage = (await pickAndCompressImage()) as File?;
                              if (pickedImage != null) {
                                setState(() {
                                  _pick_AddharCard_FrontImage = pickedImage;
                                });
                              }
                            },
                            child: Text('Pick Aaddhar Card Front Image',style: TextStyle(color: Colors.white),),
                          ),

                          SizedBox(
                            width: 80,
                          ),

                          Container(
                            width: 100,
                            height: 100,
                            child: _pick_AddharCard_FrontImage != null
                                ? Image.file(_pick_AddharCard_FrontImage!)
                                : Center(child: Text('No image selected.',style: TextStyle(color: Colors.white),)),
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),

              /*Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: _pick_PasportSize_Photo,
                      child: Text('Pick Pasport Size Photo',style: TextStyle(color: Colors.white),),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    Container(
                      width: 50,
                      height: 50,
                      child: _PasportSize_Photo != null
                          ? Image.file(_PasportSize_Photo!)
                          : Center(child: Text('No image selected.',style: TextStyle(color: Colors.white),)),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),*/

              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _name,
                          decoration: InputDecoration(
                              hintText: "Your Name",
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
                          padding: EdgeInsets.only(left: 5, top: 20),
                          child: Text('Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _number,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Your Number",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),

                ],
              ),

              const SizedBox(
                height: 0,
              ),

              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Father Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _Father_name,
                          decoration: InputDecoration(
                              hintText: "Father Name",
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
                          padding: EdgeInsets.only(left: 5, top: 20),
                          child: Text('Owner Place',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _place,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Owner Place",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),

                ],
              ),

              const SizedBox(
                height: 0,
              ),

              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Owner Occupation',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _Occupation,
                          decoration: InputDecoration(
                              hintText: "Owner Occupation",
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
                          padding: EdgeInsets.only(left: 5, top: 20),
                          child: Text('Owner DOB',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _Dateofbirth,
                          keyboardType: TextInputType.datetime,
                          decoration: InputDecoration(
                              hintText: "Owner DOP",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),

                ],
              ),

              const SizedBox(
                height: 0,
              ),

              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Permanent Address',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _Permanant_Address,
                          decoration: InputDecoration(
                              hintText: "Permanent Address",
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
                          padding: EdgeInsets.only(left: 5, top: 20),
                          child: Text('Address Pin Code',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _PinCode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Address Pin Code",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),

                ],
              ),

              const SizedBox(
                height: 0,
              ),

              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Address District',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _District,
                          decoration: InputDecoration(
                              hintText: "Address District",
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
                          padding: EdgeInsets.only(left: 5, top: 20),
                          child: Text('Address Police Station',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                      SizedBox(height: 5,),

                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: K.boxShadow,
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _Police_Station,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              hintText: "Address Police St",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),

                ],
              ),

              const SizedBox(
                height: 10,
              ),

              GestureDetector(
                onTap: () async {
                  //_uploadData();
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
      /*_name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';*/
    });
  }

}
