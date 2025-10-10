import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Document/Owner_Document.dart';
import '../Document/Tenant_Document.dart';
import '../ui_decoration_tools/app_images.dart';

class Submit_Police_Verification extends StatefulWidget {
  const Submit_Police_Verification({super.key});

  @override
  State<Submit_Police_Verification> createState() => _Submit_Police_VerificationState();
}

class _Submit_Police_VerificationState extends State<Submit_Police_Verification> {

  String _currentImage = 'assets/images/realestatefeild.png';

  void _changeImage(String image) {
    setState(() {
      _currentImage = image;
    });
  }

  String _currentImage_Tenant = 'assets/images/property.png';

  void _changeImage_tenant(String image) {
    setState(() {
      _currentImage_Tenant = image;
    });
  }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 40),
              child: GestureDetector(
                onTap: () async {

                  final responce = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/show_store_count_document?number=9711777018"));

                  print(responce.body);

                  if (responce.body == '[{"logg":1}]') {

                    _changeImage('assets/images/green_tick.png');

                    Fluttertoast.showToast(
                        msg: "Owner Document Find Successfully",
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
                            child: Text("Owner Document Verify",
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
              width: 20,
            ),

            Container(
              margin: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () async {

                  final responce = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/show_store_count_document?number=123456789"));

                  print(responce.body);

                  if (responce.body == '[{"logg":1}]') {

                    _changeImage_tenant('assets/images/green_tick.png');

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
                                _currentImage_Tenant,
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
          ],
        ),
      ),

    );
  }
}
