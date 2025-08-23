import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Police_Verification/Owner_Details.dart';
import '../Police_Verification/Submit_Police_Verification.dart';
import '../ui_decoration_tools/constant.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:verify_feild_worker/Home_Screen_click/Real-Estate.dart';

class Tenant_Document extends StatefulWidget {
  const Tenant_Document({super.key});

  @override
  State<Tenant_Document> createState() => _Tenant_DocumentState();
}

class _Tenant_DocumentState extends State<Tenant_Document> {

  DateTime now = DateTime.now();

  // Format the date as you like
  late String formattedDate;

  bool _isLoading = false;

  int _Subid = 0;
  String _number_Owner = '';
  String _number_Tenant = '';
  String _name_Owner = '';
  String _name_Tenant = '';

  File? _AddharCard_FrontImage;
  File? _AddharCard_BackImage;
  File? _PasportSize_Photo;
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

  Future<void> _pick_AddharCard_FrontImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _AddharCard_FrontImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pick_AddharCard_BlackImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _AddharCard_BackImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _pick_PasportSize_Photo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _PasportSize_Photo = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loaduserdata();

    _name_Tenant = _name.text;
    _number_Tenant = _number.text;

  }



  Future<void> _uploadData() async {
    if (_AddharCard_FrontImage == null || _AddharCard_BackImage == null || _PasportSize_Photo == null) {
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

    formattedDate = "${now.day}-${now.month}-${now.year}";

    setState(() {
      _isLoading = true;
    });


    try {
      final mimeTypeData = lookupMimeType(_AddharCard_FrontImage!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final mimeTypeData1 = lookupMimeType(_AddharCard_BackImage!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final mimeTypeData2 = lookupMimeType(_PasportSize_Photo!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('https://verifyserve.social/PHP_Files/Main_Document/Add_Document_api/insert.php'), // Replace with your API endpoint
      );

      final file = await http.MultipartFile.fromPath(
        'addhar_front',
        _AddharCard_FrontImage!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
      final file1 = await http.MultipartFile.fromPath(
        'addhar_back',
        _AddharCard_BackImage!.path,
        contentType: MediaType(mimeTypeData1![0], mimeTypeData1[1]),
      );
      final file2 = await http.MultipartFile.fromPath(
        'passprot_size',
        _PasportSize_Photo!.path,
        contentType: MediaType(mimeTypeData2![0], mimeTypeData2[1]),
      );



      // Text Feild
      imageUploadRequest.fields['Name_'] = _name.text;
      imageUploadRequest.fields['Number'] = _number.text;
      imageUploadRequest.fields['Father_name'] = _Father_name.text;
      imageUploadRequest.fields['Occupation'] = _Occupation.text;
      imageUploadRequest.fields['Date_of_birth'] = _Dateofbirth.text;
      imageUploadRequest.fields['Permanent_address'] = _Permanant_Address.text;
      imageUploadRequest.fields['District'] = _District.text;
      imageUploadRequest.fields['Pin_code'] = _PinCode.text;
      imageUploadRequest.fields['Police_station'] = _Police_Station.text;
      imageUploadRequest.fields['Place'] = _place.text;
      imageUploadRequest.fields['Currunt_date'] = formattedDate.toString();

      imageUploadRequest.files.add(file);
      imageUploadRequest.files.add(file1);
      imageUploadRequest.files.add(file2);

      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Data uploaded successfully');
        Fluttertoast.showToast(
            msg: "Data uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Owner_details(iid: ,),), (route) => route.isFirst);
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
    if (_AddharCard_FrontImage == null || _AddharCard_BackImage == null || _PasportSize_Photo == null) {
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

    formattedDate = "${now.day}-${now.month}-${now.year}";

    setState(() {
      _isLoading = true;
    });


    try {
      final mimeTypeData = lookupMimeType(_AddharCard_FrontImage!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final mimeTypeData1 = lookupMimeType(_AddharCard_BackImage!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final mimeTypeData2 = lookupMimeType(_PasportSize_Photo!.path, headerBytes: [0xFF, 0xD8])?.split('/');
      final imageUploadRequest = http.MultipartRequest(
        'POST',
        Uri.parse('https://verifyserve.social/PHP_Files/Main_Document/Add_Document_api/insert.php'), // Replace with your API endpoint
      );

      final file = await http.MultipartFile.fromPath(
        'addhar_front',
        _AddharCard_FrontImage!.path,
        contentType: MediaType(mimeTypeData![0], mimeTypeData[1]),
      );
      final file1 = await http.MultipartFile.fromPath(
        'addhar_back',
        _AddharCard_BackImage!.path,
        contentType: MediaType(mimeTypeData1![0], mimeTypeData1[1]),
      );
      final file2 = await http.MultipartFile.fromPath(
        'passprot_size',
        _PasportSize_Photo!.path,
        contentType: MediaType(mimeTypeData2![0], mimeTypeData2[1]),
      );



      // Text Feild
      imageUploadRequest.fields['Name_'] = _name.text;
      imageUploadRequest.fields['Number'] = _number.text;
      imageUploadRequest.fields['Father_name'] = _Father_name.text;
      imageUploadRequest.fields['Occupation'] = _Occupation.text;
      imageUploadRequest.fields['Date_of_birth'] = _Dateofbirth.text;
      imageUploadRequest.fields['Permanent_address'] = _Permanant_Address.text;
      imageUploadRequest.fields['District'] = _District.text;
      imageUploadRequest.fields['Pin_code'] = _PinCode.text;
      imageUploadRequest.fields['Police_station'] = _Police_Station.text;
      imageUploadRequest.fields['Place'] = _place.text;
      imageUploadRequest.fields['Currunt_date'] = formattedDate.toString();

      imageUploadRequest.files.add(file);
      imageUploadRequest.files.add(file1);
      imageUploadRequest.files.add(file2);

      final streamedResponse = await imageUploadRequest.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print('Data uploaded successfully');
        Fluttertoast.showToast(
            msg: "Data uploaded successfully",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Owner_details(),), (route) => route.isFirst);
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
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: _pick_AddharCard_FrontImage,
                      child: Text('Pick AddharCard Front Image',style: TextStyle(color: Colors.white),),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    Container(
                      width: 50,
                      height: 50,
                      child: _AddharCard_FrontImage != null
                          ? Image.file(_AddharCard_FrontImage!)
                          : Center(child: Text('No image selected.',style: TextStyle(color: Colors.white),)),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),

              Container(
                child: Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      onPressed: _pick_AddharCard_BlackImage,
                      child: Text('Pick AddharCard Back Image',style: TextStyle(color: Colors.white),),
                    ),

                    SizedBox(
                      width: 20,
                    ),

                    Container(
                      width: 50,
                      height: 50,
                      child: _AddharCard_BackImage != null
                          ? Image.file(_AddharCard_BackImage!)
                          : Center(child: Text('No image selected.',style: TextStyle(color: Colors.white),)),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 20),

              Container(
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
              SizedBox(height: 20),

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
                          child: Text('Tenant Place',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                              hintText: "Tenant Place",
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
                          child: Text('Tenant Occupation',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                              hintText: "Tenant Occupation",
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
                          child: Text('Tenant DOB',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                              hintText: "Tenant DOP",
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
      _Subid = prefs.getInt('B_Sibid_') ?? 0;
      _number_Owner = prefs.getString('B_Ownernumber_') ?? '';
      _number_Tenant = prefs.getString('B_Tenantnumber_') ?? '';
      _name_Owner = prefs.getString('B_Ownername_') ?? '';
      _name_Tenant = prefs.getString('B_Tenantname_') ?? '';
    });
  }

}
