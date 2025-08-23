import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:intl/intl.dart';
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';
import 'dart:io';
import '../../ui_decoration_tools/constant.dart';

class add_tenant_under_futureproperty extends StatefulWidget {
  String id;
  String Subid;
  add_tenant_under_futureproperty({super.key, required this.id,required this.Subid});

  @override
  State<add_tenant_under_futureproperty> createState() => _add_tenant_under_futurepropertyState();
}

class _add_tenant_under_futurepropertyState extends State<add_tenant_under_futureproperty> {

  bool _isLoading = false;

  final TextEditingController _tenant_name = TextEditingController();
  final TextEditingController _tenant_phone_number = TextEditingController();
  final TextEditingController _flat_rent = TextEditingController();
  final TextEditingController _shifting_date = TextEditingController();
  final TextEditingController _members = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _tenant_vichal_details = TextEditingController();
  final TextEditingController _work_profile = TextEditingController();
  final TextEditingController _bhk = TextEditingController();
  final TextEditingController _type_of_property = TextEditingController();

  Future<void> uploadImageWithTitle() async {
    String uploadUrl = 'https://verifyserve.social/PHP_Files/add_tanant_in_future_property/insert.php'; // Replace with your API endpoint
    //formattedDate = "${now.day}-${now.month}-${now.year}";
    //https://verifyserve.social/PHP_Files/add_tanant_in_future_property/insert.php
    FormData formData = FormData.fromMap({
      "tenant_name": _tenant_name.text,
      "tenant_phone_number": _tenant_phone_number.text,
      "flat_rent": _flat_rent.text,
      "shifting_date": _shifting_date.text,
      "members": _members.text,
      "email": _email.text,
      "tenant_vichal_details": _tenant_vichal_details.text,
      "work_profile": _work_profile.text,
      "bhk": ' ',
      "type_of_property": ' ',
      "sub_id": '${widget.id}',
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => underflat_futureproperty(Subid: widget.Subid,id: '${widget.id}',),), (route) => route.isFirst);

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


    await uploadImageWithTitle();
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
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
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
        child: Column(
          children: [
            Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Tenant Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                        controller: _tenant_name,
                        decoration: InputDecoration(
                            hintText: "Tenant Name",
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
                        child: Text('Tenant Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                        controller: _tenant_phone_number,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            hintText: "Tenant Number",
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),

                  ],
                ),

              ],
            ),

            SizedBox(height: 10,),

            Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Tenant Rent Amount',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                    SizedBox(height: 5,),

                    Container(
                      width: 350,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: K.boxShadow,
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _flat_rent,
                        decoration: InputDecoration(
                            hintText: "Tenant Rent Amount",
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),

                  ],
                ),

                SizedBox(
                  width: 10,
                ),



              ],
            ),
            SizedBox(height: 10,),

            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      // boxShadow: K.boxShadow,
                    ),
                    child: TextField(style: TextStyle(color: Colors.black),
                      controller: _shifting_date,
                      readOnly: true,
                      onTap: () async{
                        DateTime? pickedDate = await showDatePicker(
                            context: context, initialDate: DateTime.now(),
                            firstDate: DateTime(2010), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if(pickedDate != null ){
                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement
                          //yyyy-MM-dd
                          setState(() {
                            _shifting_date.text = formattedDate; //set output date to TextField value.
                          });
                        }else{
                          print("Date is not selected");
                        }
                      },
                      decoration: InputDecoration(
                          hintText: "Enter Shifting Date",
                          prefixIcon: Icon(
                            PhosphorIcons.calendar,
                            color: Colors.black54,
                          ),
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                          border: InputBorder.none),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      color: Colors.pinkAccent.shade100
                  ),
                  child: IconButton(
                    onPressed: () async{
                      DateTime? pickedDate = await showDatePicker(
                          context: context, initialDate: DateTime.now(),
                          firstDate: DateTime(2010), //DateTime.now() - not to allow to choose before today.
                          lastDate: DateTime(2101));

                      if(pickedDate != null ){
                        print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                        String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                        print(formattedDate); //formatted date output using intl package =>  2021-03-16
                        //you can implement different kind of Date Format here according to your requirement
                        //yyyy-MM-dd
                        setState(() {
                          _shifting_date.text = formattedDate; //set output date to TextField value.
                        });
                      }else{
                        print("Date is not selected");
                      }
                    },
                    icon: Icon(
                      PhosphorIcons.calendar,
                      color: Colors.black,
                    ),),
                )
              ],
            ),

            SizedBox(height: 10,),

            Row(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Family Member',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                        controller: _members,
                        decoration: InputDecoration(
                            hintText: "Family Member",
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
                        child: Text('Tenant Email id',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                        controller: _email,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Tenant Email id",
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),

                  ],
                ),

              ],
            ),

            SizedBox(height: 10,),

            Row(
               children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('tenant Vehicle details',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                        controller: _tenant_vichal_details,
                        decoration: InputDecoration(
                            hintText: "tenant Vehicle details",
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
                        child: Text('work_profile',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                        controller: _work_profile,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "work_profile",
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),

                  ],
                ),

              ],
            ),

            SizedBox(height: 10,),

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

    );
  }
}
