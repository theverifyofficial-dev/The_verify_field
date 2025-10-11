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

import '../ui_decoration_tools/app_images.dart';
import '../Future_Property_OwnerDetails_section/Future_Property.dart';
import '../Future_Property_OwnerDetails_section/Future_property_details.dart';

class Update_FutureProperty extends StatefulWidget {
  String id;
  String ownername;
  String ownernumber;
  String caretakername;
  String caretakernumber;
  String place;
  String buy_rent;
  String typeofproperty;
  String select_bhk;
  String floor_number;
  String sqyare_feet;
  String propertyname_address;
  String building_information_facilitys;
  String property_address_for_fieldworkar;
  String owner_vehical_number;
  String your_address;
  Update_FutureProperty({super.key, required this.id, required this.ownername, required this.ownernumber, required this.caretakername, required this.caretakernumber
    , required this.place, required this.buy_rent, required this.typeofproperty, required this.select_bhk, required this.floor_number, required this.sqyare_feet
    , required this.propertyname_address, required this.building_information_facilitys, required this.property_address_for_fieldworkar, required this.owner_vehical_number, required this.your_address});

  @override
  State<Update_FutureProperty> createState() => _Update_FuturePropertyState();
}

class _Update_FuturePropertyState extends State<Update_FutureProperty> {

  bool _isLoading = false;

  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _sqft = TextEditingController();
  final TextEditingController _floor = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();

  String _number = '';
  String _name = '';



  String long = '';
  String lat = '';
  String full_address = '';

  File? _imageFile;

  DateTime now = DateTime.now();

  // Format the date as you like
  late String formattedDate;


  String? _selectedItem;
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Hauz Khas','Uttam Nagar East','Uttam Nagar West','Janak Puri East','Janak Puri West','Dwarka Mor','Vasant Kunj','Ghitorni'];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent'];

  String? _typeofproperty;
  final List<String> __typeofproperty1 = ['Flat','Office','Shop','Showroom','Godown'];

  String? _bhk;
  final List<String> _bhk1 = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial SP'];

  Future<void> fetchdata() async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/update_futureproperty_by_id_?id=${widget.id}&ownername=${_Ownername.text}&ownernumber=${_Owner_number.text}&caretakername=${_CareTaker_name.text}&caretakernumber=${_CareTaker_number.text}&place=${_selectedItem.toString()}&buy_rent=${_selectedItem1.toString()}&typeofproperty=${_typeofproperty.toString()}&select_bhk=${_bhk.toString()}&floor_number=${_floor.text}&sqyare_feet=${_sqft.text}&propertyname_address=${_address.text}&building_information_facilitys=${_Building_information.text}&property_address_for_fieldworkar=${_Address_apnehisaabka.text}&owner_vehical_number=${_vehicleno.text}&your_address=${_Google_Location.text}'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Future_Property_details(idd: '${widget.id}',),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  @override
  void initState() {
    super.initState();
    _loaduserdata();

    _Ownername.text = widget.ownername;
    _Owner_number.text = widget.ownernumber;
    _Address_apnehisaabka.text = widget.property_address_for_fieldworkar;
    _CareTaker_name.text = widget.caretakername;
    _CareTaker_number.text = widget.caretakernumber;
    _vehicleno.text = widget.owner_vehical_number;
    _Google_Location.text = widget.your_address;
    _sqft.text = widget.sqyare_feet;
    _floor.text = widget.floor_number;
    _address.text = widget.propertyname_address;
    _Building_information.text = widget.building_information_facilitys;
    _selectedItem = widget.place;
    _selectedItem1 = widget.buy_rent;
    _typeofproperty = widget.typeofproperty;
    _bhk = widget.select_bhk;

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
                              child: Text('Floor Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  hintText: " Enter Floor Number",
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
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                  hintText: "Enter Sqft",
                                  hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                  border: InputBorder.none),
                            ),
                          ),

                        ],
                      ),

                    ],
                  ),

                  SizedBox(
                    height: 20,
                  ),

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




                ],
              ),

              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  fetchdata();

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
