import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Administrator/Admin_future _property/Future_Property_Details.dart';
import '../../ui_decoration_tools/constant.dart';

class Edit_Building_futureproperty extends StatefulWidget {
  String id;
  Edit_Building_futureproperty({super.key, required this.id});

  @override
  State<Edit_Building_futureproperty> createState() => _Edit_Building_futurepropertyState();
}

class _Edit_Building_futurepropertyState extends State<Edit_Building_futureproperty> {

  bool _isLoading = false;

  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _Longitude = TextEditingController();
  final TextEditingController _Latitude = TextEditingController();
  final TextEditingController _sqft = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _BHKHAI = TextEditingController();

  String _number = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _getCurrentLocation();
  }

  String long = '';
  String lat = '';
  String full_address = '';

  File? _imageFile;

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


  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85, // Compression quality
    );

    return result;
  }

  Future<void> uploadImageWithTitle(File imageFile) async {
    String uploadUrl = 'https://verifyserve.social/PHP_Files/EDIT_FUTURE_PROPERTY/futureproperty_update.php'; // Replace with your API endpoint
    formattedDate = "${now.day}-${now.month}-${now.year}";
    FormData formData = FormData.fromMap({
      "id": widget.id,
      "images": await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
      "ownername": _Ownername.text,
      "ownernumber": _Owner_number.text,
      "caretakername": _CareTaker_name.text,
      "caretakernumber": _CareTaker_number.text,
      "place": _selectedItem.toString(),
      "buy_rent": _selectedItem1.toString(),
      "typeofproperty": _typeofproperty.toString(),
      "sqyare_feet": 'Sqft',
      "propertyname_address": _address.text,
      "select_bhk": tempArray.toString(),
      "floor_number": 'floor number',
      "building_information_facilitys": _Building_information.text,
      "property_address_for_fieldworkar": _Address_apnehisaabka.text,
      "owner_vehical_number": _vehicleno.text,
      "your_address": _Google_Location.text,
      "fieldworkarname": _name,
      "fieldworkarnumber": _number,
      "current_date_": formattedDate,
      "longitude": _Longitude.text,
      "latitude": _Latitude.text,
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Administater_Future_Property_details(buildingId: '${widget.id}',),), (route) => route.isFirst);

        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful: ${response.data}')),
        );
        print('Upload successful: ${response.data}');
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
      print('Error occurred: $e');
    }
  }

  Future<void> _handleUpload() async {
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select an image and enter a title')),
      );
      return;
    }

    await uploadImageWithTitle(_imageFile!);
  }
  String? _selectedItem;
  final List<String> _items = ['SultanPur','Manglapuri'];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent'];

  String? _typeofproperty;
  final List<String> __typeofproperty1 = ['Flat','Plot','Office','Shop','Showroom','Godown'];

  String? _bhk;
  final List<String> _bhk1 = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Shops'];

  String? _Floor;
  final List<String> _floor1 = ['1','2','3','4','5','6','7','8','9','10'];

  List<String> name = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial SP'];

  List<String> tempArray = [];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
                      onPressed: () async {
                        File? pickedImage = (await pickAndCompressImage()) as File?;
                        if (pickedImage != null) {
                          setState(() {
                            _imageFile = pickedImage;
                          });
                        }
                      },
                      child: Text('Pick Image',style: TextStyle(color: Colors.white),),
                    ),

                    SizedBox(
                      width: 80,
                    ),

                    Container(
                      width: 100,
                      height: 100,
                      child: _imageFile != null
                          ? Image.file(_imageFile!)
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
                              child: Text('Sell / Rent',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                          SizedBox(height: 10,),

                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedItem1,
                              hint: Text('Sell / Rent',style: TextStyle(color: Colors.white)),
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

                  SizedBox(height: 20,),

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




                        ],
                      ),

                    ],
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

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Owner Vehicle Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 5,),

                  Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: K.boxShadow,
                    ),
                    child: TextField(
                      style: TextStyle(color: Colors.black,fontSize: 24 ),
                      controller: _vehicleno,
                      decoration: InputDecoration(
                          hintText: "Enter Owner Vehicle Number",
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
                  setState(() {
                    _isLoading = true;
                  });
                  _handleUpload();

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
