import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Document/Owner_Document.dart';
import '../Document/Tenant_Document.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Rented_property_Details.dart';


class Tenant_details extends StatefulWidget {
  const Tenant_details({super.key});

  @override
  State<Tenant_details> createState() => _Tenant_detailsState();
}

class _Tenant_detailsState extends State<Tenant_details> {

  final TextEditingController _Father_name = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _Occupation = TextEditingController();
  final TextEditingController _Dateofbirth = TextEditingController();
  final TextEditingController _Permanant_Address = TextEditingController();
  final TextEditingController _PinCode = TextEditingController();
  final TextEditingController _District = TextEditingController();
  final TextEditingController _Police_Station = TextEditingController();

  String _currentImage = 'assets/images/property.png';

  void _changeImage(String image) {
    setState(() {
      _currentImage = image;
    });
  }

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
            Navigator.pop(context, true);

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
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Delete_Image()));
            },
            child: const Icon(
              PhosphorIcons.trash,
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
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                width: size.width,
                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.red.withOpacity(0.8)),
                ),
                margin: const EdgeInsets.only(left: 0, right: 0),
                child: Text('Please Click Tenant Verify Document for Verification.', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',letterSpacing: 0.5 ),textAlign: TextAlign.start),
              ),

              Container(
                margin: EdgeInsets.only(top: 0),
                child: GestureDetector(
                  onTap: () async {

                    final responce = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/show_store_count_document?number=123456789"));

                    print(responce.body);

                    if (responce.body == '[{"logg":1}]') {

                      _changeImage('assets/images/green_tick.png');

                      Fluttertoast.showToast(
                          msg: "Tenant Document Find Successfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      // Successful login
                      print("Login successful");
                    } else {
                      // Failed login

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Owner_Document()));

                    }


                  },
                  child: Card(
                    color: Colors.white12,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  _currentImage,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 35, bottom: 40, left: 20),
                              child: Text("Tenant Document Verify",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
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
                          child: Text('Tenant Father Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                              hintText: "Tenant Father Name",
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
                          keyboardType: TextInputType.number,
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
                          keyboardType: TextInputType.number,
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
                              hintText: "Permanent Address Pin Code",
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
                        width: 155,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: K.boxShadow,
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _Police_Station,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Address Police Station",
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

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red
                ),
                onPressed: (){

                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Rented_Property()));


                  //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tenant_demands(),), (route) => route.isFirst);


                }, child: Text("Next To Rented Property Details", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, ),
              ),
              ),

            ],
          ),
        ),
      ),

    );
  }
}
