import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/constant.dart';
import 'Add_image_under_property.dart';
import 'Image_Update.dart';

class Catid {
  final String property_num;
  final String Address_;
  final String Place_;
  final String sqft;
  final String Price;
  final String Sell_price;
  final String Persnol_price;
  final String maintenance;
  final String Buy_Rent;
  final String Residence_Commercial;
  final String floor_ ;
  final String flat_;
  final String Furnished;
  final String Details;
  final String Ownername;
  final String Owner_number;
  final String Building_information;
  final String balcony;
  final String kitchen;
  final String Baathroom;
  final String Parking;
  final String Typeofproperty;
  final String Bhk_Squarefit;
  final String Address_apnehisaabka;
  final String Caretaker_name;
  final String Caretaker_number;

  Catid(
      {required this.property_num,required this.Address_,required this.Place_,required this.sqft,
        required this.Price,required this.Sell_price,required this.Persnol_price,required this.maintenance,
        required this.Buy_Rent,required this.Residence_Commercial,required this.floor_,required this.flat_,
        required this.Furnished,required this.Details,required this.Ownername,required this.Owner_number,
        required this.Building_information,required this.balcony,required this.kitchen,required this.Baathroom,
        required this.Parking,required this.Typeofproperty,required this.Bhk_Squarefit,required this.Address_apnehisaabka,
        required this.Caretaker_name,required this.Caretaker_number,});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(
      property_num: json['Property_Number'], Address_: json['Address_'],
      Place_: json['Place_'], sqft: json['City'],
      Price: json['Price'], Sell_price: json['Waterfilter'],
      Persnol_price: json['Gas_meter'], maintenance: json['maintenance'],
      Buy_Rent: json['Buy_Rent'], Residence_Commercial: json['Residence_Commercial'],
      floor_: json['floor_'], flat_: json['flat_'],
      Furnished: json['Furnished'], Details: json['Details'],
      Ownername: json['Ownername'], Owner_number: json['Owner_number'],
      Building_information: json['Building_information'], balcony: json['balcony'],
      kitchen: json['kitchen'], Baathroom: json['Baathroom'],
      Parking: json['Parking'], Typeofproperty: json['Typeofproperty'],
      Bhk_Squarefit: json['Bhk_Squarefit'], Address_apnehisaabka: json['Address_apnehisaabka'],
      Caretaker_name: json['Water_geyser'], Caretaker_number: json['CareTaker_number'],);
  }
}

class Edit_Page_realestate extends StatefulWidget {
  const Edit_Page_realestate({super.key});

  @override
  State<Edit_Page_realestate> createState() => _Edit_Page_realestateState();
}

class _Edit_Page_realestateState extends State<Edit_Page_realestate> {


  final TextEditingController _propertyNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _place = TextEditingController();
  final TextEditingController _sqft = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _Sell_price = TextEditingController();
  final TextEditingController _Verify_Price = TextEditingController();
  final TextEditingController _maintenance = TextEditingController();
  final TextEditingController _Buy_Rent = TextEditingController();
  final TextEditingController _Residentiol_Commercial = TextEditingController();
  final TextEditingController _floor = TextEditingController();
  final TextEditingController _flat = TextEditingController();
  final TextEditingController _furnished = TextEditingController();
  final TextEditingController _furnished_details = TextEditingController();
  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _Balcony = TextEditingController();
  final TextEditingController _kitchen = TextEditingController();
  final TextEditingController _Bathroom = TextEditingController();
  final TextEditingController _Parking = TextEditingController();
  final TextEditingController _Typeofproperty = TextEditingController();
  final TextEditingController _BHK = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();

  int _id = 0;

  @override
  void initState() {
    super.initState();
    _loaduserdata();

  }

  Future<void> fetchdata(propertyNumber_,address_,place_,sqft_,price_,Sell_price_,Verify_Price_,maintenance_,Buy_Rent_,Residentiol_Commercial_,floor_,
      flat_,furnished_,furnished_details_,Ownername_,Owner_number_,Building_information_,Balcony_,kitchen_,Bathroom_,Parking_,Typeofproperty_,BHK_,Address_apnehisaabka_,
      CareTaker_name_,CareTaker_number_) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_realstatedata?iddd=$_id&property_num=$propertyNumber_&Address_=$address_&Place_=$place_&sqft=$sqft_&Price=$price_&Sell_price=$Sell_price_&Persnol_price=$Verify_Price_&maintenance=$maintenance_&Buy_Rent=$Buy_Rent_&Residence_Commercial=$Residentiol_Commercial_&floor_=$floor_&flat_=$flat_&Furnished=$furnished_&Details=$furnished_details_&Ownername=$Ownername_&Owner_number=$Owner_number_&Building_information=$Building_information_&balcony=$Balcony_&kitchen=$kitchen_&Baathroom=$Bathroom_&Parking=$Parking_&Looking_Property_=Flat&Typeofproperty=$Typeofproperty_&Bhk_Squarefit=$BHK_&Address_apnehisaabka=$Address_apnehisaabka_&Caretaker_name=$CareTaker_name_&Caretaker_number=$CareTaker_number_'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=$_id");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=> image_Update(id: '${_id.toString()}',)));
            },
            child: const Icon(
              PhosphorIcons.pencil,
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
          child: FutureBuilder<List<Catid>>(
              future: fetchData(),
              builder: (context,abc){

                if(abc.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                else if(abc.hasError){
                  return Text('${abc.error}');
                }
                else if (abc.data == null || abc.data!.isEmpty) {
                  // If the list is empty, show an empty image
                  return Center(
                    child: Column(
                      children: [
                        // Lottie.asset("assets/images/no data.json",width: 450),
                        Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                      ],
                    ),
                  );
                }
                else{

                  return ListView.builder(
                      itemCount: 1,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context,int len){
                        return Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // main data start

                              Container(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Text('Property Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _propertyNumber,
                                  decoration: InputDecoration(
                                      hintText: "Enter Property Number",
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
                                  child: Text('Property Address',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                      hintText: "Enter Property Address",
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
                                  child: Text('Property Place',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _place,
                                  decoration: InputDecoration(
                                      hintText: "Enter Property Place",
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
                                  child: Text('Property Square Feet',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _sqft,
                                  decoration: InputDecoration(
                                      hintText: "Enter Property Square Feet",
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
                                  child: Text('Property Owner Last Price',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _price,
                                  decoration: InputDecoration(
                                      hintText: "Enter Owner Last Property Price",
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
                                  child: Text('Property Owner Sell Price',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Sell_price,
                                  decoration: InputDecoration(
                                      hintText: "Enter Property Owner Sell Price",
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
                                  child: Text('Verify Price',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Verify_Price,
                                  decoration: InputDecoration(
                                      hintText: "Enter Verify Price",
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
                                  child: Text('Property Maintenance Cost',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _maintenance,
                                  decoration: InputDecoration(
                                      hintText: "Enter Maintenance Cost",
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
                                  child: Text('Buy / Rent',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Buy_Rent,
                                  decoration: InputDecoration(
                                      hintText: "Enter Buy / Rent",
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
                                  child: Text('Residence / Commercial',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Residentiol_Commercial,
                                  decoration: InputDecoration(
                                      hintText: "Residence / Commercial",
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
                                  child: Text('Property Floor',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _floor,
                                  decoration: InputDecoration(
                                      hintText: "Enter Property Floor",
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
                                  child: Text('Property Flat',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _flat,
                                  decoration: InputDecoration(
                                      hintText: "Enter Property Flat",
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
                                  child: Text('Property Furnished Type',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _furnished,
                                  decoration: InputDecoration(
                                      hintText: "Enter Furnished Type",
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
                                      hintText: "Enter Furnished Details",
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
                                  child: Text('Owner Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Ownername,
                                  decoration: InputDecoration(
                                      hintText: "Enter Owner Name",
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
                                  child: Text('Owner Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Owner_number,
                                  decoration: InputDecoration(
                                      hintText: "Enter Owner Number",
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
                                  child: Text('Building Info',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                      hintText: "Enter Building Info",
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
                                  child: Text('Balcony Style',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Balcony,
                                  decoration: InputDecoration(
                                      hintText: "Enter Balcony Style",
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
                                  child: Text('Kitchen Style',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _kitchen,
                                  decoration: InputDecoration(
                                      hintText: "Enter Kitchen Style",
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
                                  child: Text('Bathroom Style',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Bathroom,
                                  decoration: InputDecoration(
                                      hintText: "Enter Bathroom Style",
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
                                  child: Text('Parking Space',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Parking,
                                  decoration: InputDecoration(
                                      hintText: "Enter Parking Space",
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
                                  child: Text('Type Of Property',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _Typeofproperty,
                                  decoration: InputDecoration(
                                      hintText: "Enter Type Of Property",
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
                                  child: Text('BHK',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _BHK,
                                  decoration: InputDecoration(
                                      hintText: "Enter Property BHK",
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
                                  child: Text('Address Apne Hisaab ka',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                      hintText: "Enter Property Address",
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
                                  child: Text('CareTaker Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _CareTaker_name,
                                  decoration: InputDecoration(
                                      hintText: "Enter CareTaker Name",
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
                                  child: Text('CareTaker Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                                  controller: _CareTaker_number,
                                  decoration: InputDecoration(
                                      hintText: "Enter CareTaker Number",
                                      prefixIcon: Icon(
                                        Icons.circle,
                                        color: Colors.black54,
                                      ),
                                      hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                      border: InputBorder.none),
                                ),
                              ),

                              SizedBox(height: 20),

                              //main data end
                              Visibility(
                                visible: false,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Number = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_propertyNumber.text = abc.data![len].property_num,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Address = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_address.text = abc.data![len].Address_,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Place = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_place.text = abc.data![len].Place_,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Square Feet = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_sqft.text = abc.data![len].sqft,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Last Price = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_price.text = abc.data![len].Price,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Owner Sell Price",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Sell_price.text = abc.data![len].Sell_price,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Verify Price = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Verify_Price.text = abc.data![len].Persnol_price,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Maintenance = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_maintenance.text = abc.data![len].maintenance,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Buy Rent = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Buy_Rent.text = abc.data![len].Buy_Rent,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Residence Commercial = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Residentiol_Commercial.text = abc.data![len].Residence_Commercial,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Floor = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_floor.text =abc.data![len].floor_,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Flat = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_flat.text = abc.data![len].flat_,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Property Furnished = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_furnished.text = abc.data![len].Furnished,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text("Furnished Details ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(_furnished_details.text = abc.data![len].Details,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Owner Name = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Ownername.text = abc.data![len].Ownername,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Owner Number = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Owner_number.text = abc.data![len].Owner_number,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text("Building Facility Information ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(_Building_information.text = abc.data![len].Building_information,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Balcony = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Balcony.text = abc.data![len].balcony,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Kitchen Style = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_kitchen.text = abc.data![len].kitchen,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Bathroom Style = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Bathroom.text = abc.data![len].Baathroom,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Parking = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Parking.text = abc.data![len].Parking,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("Type Of Property = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_Typeofproperty.text = abc.data![len].Typeofproperty,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("BHK = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_BHK.text = abc.data![len].Bhk_Squarefit,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          Text("Adderss Apne Hisaab ka ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(_Address_apnehisaabka.text = abc.data![len].Address_apnehisaabka,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("CareTaker Name = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_CareTaker_name.text = abc.data![len].Caretaker_name,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),

                                    Padding(padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          Text("CareTaker Number = ",style: TextStyle(color: Colors.red, fontSize: 16),),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(_CareTaker_number.text = abc.data![len].Caretaker_number,style: TextStyle(color: Colors.white, fontSize: 16),),
                                        ],
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
                                    ),


                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  );

                }


              }
          ),
        )
      ),


      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {

                fetchdata(_propertyNumber.text, _address.text, _place.text, _sqft.text, _price.text, _Sell_price.text, _Verify_Price.text, _maintenance.text, _Buy_Rent.text, _Residentiol_Commercial.text, _floor.text, _flat.text, _furnished.text, _furnished_details.text, _Ownername.text, _Owner_number.text, _Building_information.text, _Balcony.text, _kitchen.text, _Bathroom.text, _Parking.text, _Typeofproperty.text, _BHK.text, _Address_apnehisaabka.text, _CareTaker_name.text, _CareTaker_number.text);

                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => FileUploadPage(),), (route) => route.isFirst);
                //Navigator.pop(context, true);
              },
              child: Text('Update Property',style: TextStyle(fontSize: 15)),
            ),
          ),
        ],
      ),


    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getInt('id_Building') ?? 0;
    });


  }

}
