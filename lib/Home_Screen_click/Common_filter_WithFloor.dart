import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_decoration_tools/constant.dart';
import 'Add_image_under_property.dart';
import 'Filter_All_Details.dart';

class Residential_filter_withfloor extends StatefulWidget {
  const Residential_filter_withfloor({super.key});

  @override
  State<Residential_filter_withfloor> createState() => _Residential_filter_withfloorState();
}

class _Residential_filter_withfloorState extends State<Residential_filter_withfloor> {

  ValueNotifier<int> timingIndex = ValueNotifier(0);

  List<String> timing = [
    "Flat",
    "Villa",
    "Farms",
    "House",
  ];

  ValueNotifier<int> bhkIndex = ValueNotifier(0);

  List<String> bhk = [
    "1 BHK",
    "2 BHK",
    "3 BHK",
    "4 BHK",
    "1 RK",
  ];

  ValueNotifier<int> _FloorIndex = ValueNotifier(0);

  List<String> _floor = [
    "1st Floor",
    "2nd Floor",
    "3rd Floor",
    "4th Floor",
    "UG",
    "LG",
    "Ground",
  ];

  ValueNotifier<int> buyIndex = ValueNotifier(0);

  List<String> rent = [
    "Buy",
    "Rent",
  ];

  String? _place;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),
            ValueListenableBuilder(
                valueListenable: buyIndex,
                builder: (context,int selectedIndex,_ ) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    childAspectRatio: 4.5,
                    padding: EdgeInsets.zero,
                    children: List.generate(

                        rent.length,
                            (index) {
                              final isSelected = selectedIndex == index;
                              final theme = Theme.of(context);
                          return GestureDetector(
                            onTap: () {
                              buyIndex.value = index;
                              print("${rent[buyIndex.value]}");
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.redAccent
                                    : theme.brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                rent[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: selectedIndex ==index ?Colors.white:Colors.black,
                                    fontWeight: selectedIndex == index
                                        ? FontWeight.w500
                                        : FontWeight.w400),
                              ),
                            ),
                          );
                        }),
                  );
                }
            ),
            const SizedBox(height: 20,),

            Container(
                padding: EdgeInsets.only(left: 5),
                child: Text('Choose Property Type',style: TextStyle(fontSize: 16,fontFamily: 'Poppins'),)),

            const SizedBox(height: 5,),

            ValueListenableBuilder(
                valueListenable: timingIndex,
                builder: (context,int time,_ ) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    padding: EdgeInsets.zero,
                    // crossAxisSpacing: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                    children: List.generate(
                        timing.length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              timingIndex.value = index;
                              print("${timing[timingIndex.value]}");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: time == index
                                      ? Colors.red
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                timing[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: time == index
                                        ? FontWeight.w500
                                        : FontWeight.w400),
                              ),
                            ),
                          );
                        }),
                  );
                }
            ),
            const SizedBox(height: 20,),

            Container(
                padding: EdgeInsets.only(left: 5),
                child: Text('Choose Location',style: TextStyle(fontSize: 16,fontFamily: 'Poppins'),)),

            const SizedBox(height: 5,),

            Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(width: 1,),
                // boxShadow: K.boxShadow,
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    PhosphorIcons.map_pin_line,
                    // color: Colors.white,
                  ),
                ),
                padding: EdgeInsets.only(right: 10,left: 0),
                hint: const Text('Select Place',style: TextStyle(),),
                value: _place,
                dropdownColor: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(30),
                onChanged: (String? newValue) {
                  setState(() {
                    _place = newValue!;
                  });
                },
                items: <String>['SultanPur','Uttam Nagar','Dwarka mor','Ghitoni','Chhattarpur','Nawada','Janak Puri','Vikas Puri','Hauz Khas']
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
                child: Text('Choose Area',style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: 'Poppins'),)),

            const SizedBox(height: 5,),

            ValueListenableBuilder(
                valueListenable: bhkIndex,
                builder: (context,int time,_ ) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    padding: EdgeInsets.zero,
                    // crossAxisSpacing: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                    children: List.generate(
                        bhk.length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              bhkIndex.value = index;
                              print("${bhk[bhkIndex.value]}");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: time == index
                                      ? Colors.red
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                bhk[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: time == index
                                        ? FontWeight.w500
                                        : FontWeight.w400),
                              ),
                            ),
                          );
                        }),
                  );
                }
            ),

            SizedBox(height: 20,),

            Container(
                padding: EdgeInsets.only(left: 5),
                child: Text('Floor Options',style: TextStyle(fontSize: 16,color: Colors.white,fontFamily: 'Poppins'),)),

            const SizedBox(height: 5,),

            ValueListenableBuilder(
                valueListenable: _FloorIndex,
                builder: (context,int time,_ ) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics:
                    const NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    padding: EdgeInsets.zero,
                    // crossAxisSpacing: 1,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                    children: List.generate(
                        _floor.length,
                            (index) {
                          return GestureDetector(
                            onTap: () {
                              _FloorIndex.value = index;
                              print("${_floor[_FloorIndex.value]}");
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                  color: time == index
                                      ? Colors.red
                                      : Colors.grey,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Text(
                                _floor[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: time == index
                                        ? FontWeight.w500
                                        : FontWeight.w400),
                              ),
                            ),
                          );
                        }),
                  );
                }
            ),

            SizedBox(height: 20,),

            Center(
              child: Container(
                height: 40,
                width: 200,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red
                  ),
                  onPressed: (){

                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_CommonFilter_WithFloor(Buy_Rent: "${rent[buyIndex.value]}", Typeofproperty: "${timing[timingIndex.value]}", Place_: "${_place.toString()}", floor: "${_floor[_FloorIndex.value]}", Bhk_Squarefit: "${bhk[bhkIndex.value]}")));

                  }, child: Text("Show Property", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, ),
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

class Catid {
  final int id;
  final String Building_Name;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Rent;
  final String Verify_price;
  final String BHK;
  final String sqft;
  final String tyope;
  final String floor_ ;
  final String maintence ;
  final String buy_Rent ;
  final String Building_information;
  final String Parking;
  final String balcony;
  final String facility;
  final String Furnished;
  final String kitchen;
  final String Baathroom;
  final String Date;

  Catid(
      {required this.id, required this.Building_Name, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.sqft, required this.tyope, required this.floor_, required this.maintence, required this.buy_Rent,
        required this.Building_information,required this.balcony,required this.Parking,required this.facility,required this.Furnished,required this.kitchen,required this.Baathroom,required this.Date});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['PVR_id'],
        Building_Name: json['Building_information'],
        Building_Address: json['Address_'],
        Building_Location: json['Place_'],
        Building_image: json['Realstate_image'],
        Longitude: json['Longtitude'],
        Latitude: json['Latitude'],
        Rent: json['Property_Number'],
        Verify_price: json['Gas_meter'],
        BHK: json['Bhk_Squarefit'],
        sqft: json['City'],
        tyope: json['Typeofproperty'],
        floor_: json['floor_'],
        maintence: json['maintenance'],
        buy_Rent: json['Buy_Rent'],
        Building_information: json['Building_information'],
        balcony: json['balcony'],
        Parking: json['Parking'],
        facility: json['Lift'],
        Furnished: json['Furnished'],
        kitchen: json['kitchen'],
        Baathroom: json['Baathroom'],
        Date: json['date_']);
  }
}

class Show_CommonFilter_WithFloor extends StatefulWidget {
  final String Buy_Rent;
  final String Typeofproperty;
  final String Place_;
  final String floor;
  final String Bhk_Squarefit;
  const Show_CommonFilter_WithFloor({Key? key, required this.Buy_Rent, required this.Bhk_Squarefit, required this.Place_, required this.Typeofproperty, required this.floor}) : super(key: key);

  @override
  State<Show_CommonFilter_WithFloor> createState() => _Show_CommonFilter_WithFloorState();
}

class _Show_CommonFilter_WithFloorState extends State<Show_CommonFilter_WithFloor> {

  Future<List<Catid>> fetchData(by_rt,bhk,floo,plc,type) async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/filter_Residental_with_floor_api_?Buy_Rent=$by_rt&Bhk_Squarefit=$bhk&Place_=$plc&floor_=$floo&Typeofproperty=$type&Looking_Property_=Flat");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      //print(floo);


      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
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
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Filter_Options()));
              //_showBottomSheet(context);
            },
            child: const Icon(
              PhosphorIcons.faders,
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
            Container(
              child: FutureBuilder<List<Catid>>(
                  future: fetchData(widget.Buy_Rent.toString(), widget.Bhk_Squarefit.toString(), widget.floor.toString(),  widget.Place_.toString(), widget.Typeofproperty.toString()),
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
                          itemCount: abc.data!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context,int len){
                            return Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    //  int itemId = abc.data![len].id;
                                    //int iiid = abc.data![len].PropertyAddress
                                    /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('id_Document', abc.data![len].id.toString());*/
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setInt('id_Building', abc.data![len].id);
                                    prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
                                    prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Filter_View_Details(id: '${abc.data![len].id.toString()}',))
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 0),
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                        const BorderRadius.all(Radius.circular(10)),
                                                        child: Container(
                                                          height: 200,
                                                          width: 120,
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                            "https://verifyserve.social/"+abc.data![len].Building_image,
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => Image.asset(
                                                              AppImages.loading,
                                                              fit: BoxFit.cover,
                                                            ),
                                                            errorWidget: (context, error, stack) =>
                                                                Image.asset(
                                                                  AppImages.imageNotFound,
                                                                  fit: BoxFit.cover,
                                                                ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),

                                                    ],
                                                  ),
                                                  SizedBox(width: 5,),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [

                                                      Row(
                                                        children: [
                                                          SizedBox(width: 10,),
                                                          Container(
                                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(width: 1, color: Colors.red),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.red.withOpacity(0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(0, 0),
                                                                    blurStyle: BlurStyle.outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //w SizedBox(width: 10,),
                                                                Text(""+abc.data![len].BHK/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w500,
                                                                      letterSpacing: 0.5
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),

                                                          SizedBox(
                                                            width: 10,
                                                          ),

                                                          Container(
                                                            padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(5),
                                                              border: Border.all(width: 1, color: Colors.red),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors.red.withOpacity(0.5),
                                                                    blurRadius: 10,
                                                                    offset: Offset(0, 0),
                                                                    blurStyle: BlurStyle.outer
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                                //w SizedBox(width: 10,),
                                                                Text(""+abc.data![len].floor_/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                  style: TextStyle(
                                                                      fontSize: 13,
                                                                      color: Colors.black,
                                                                      fontWeight: FontWeight.w500,
                                                                      letterSpacing: 0.5
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 10,
                                                      ),

                                                      Row(
                                                        children: [
                                                          Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                          SizedBox(width: 2,),
                                                          Text("Building Sell | Rent & Maintaince",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            child: Text(""+abc.data![len].Verify_price+"  |  "+abc.data![len].Rent+"  |  "+abc.data![len].maintence,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 14,

                                                                  color: Colors.green,
                                                                  fontWeight: FontWeight.w700),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                          SizedBox(width: 2,),
                                                          Text("Sqft | Balcony & Parking",
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(

                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            child: Text(""+abc.data![len].sqft+"  |  "+abc.data![len].balcony+"  |  "+abc.data![len].Parking+" Parking" ,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w500
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                          SizedBox(width: 2,),
                                                          Text("Building facilities",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            child: Text(""+abc.data![len].facility,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                          SizedBox(width: 2,),
                                                          Text("Building Information & facilitys",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w600),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          SizedBox(
                                                            width: 180,
                                                            child: Text(""+abc.data![len].Building_information,
                                                              overflow: TextOverflow.ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight.w400
                                                              ),
                                                            ),
                                                          ),

                                                        ],
                                                      ),

                                                      SizedBox(
                                                        height: 5,
                                                      ),




                                                    ],
                                                  ),


                                                ],
                                              ),

                                              SizedBox(height: 10,),

                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.blue),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.blue.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].tyope.toUpperCase()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.blue),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.blue.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].Building_Location/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.blue),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.blue.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].buy_Rent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.blue),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.blue.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].Date/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              ],
                            );
                          });
                    }


                  }

              ),



              /*FutureBuilder<List<Catid>>(
                  future: fetchData(""+1.toString()),
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
                          itemCount: abc.data!.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context,int len){
                            return GestureDetector(
                              onTap: () async {
                                //  int itemId = abc.data![len].id;
                                //int iiid = abc.data![len].PropertyAddress
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('id_Document', abc.data![len].id.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute
                                      (builder: (context) => ShowProperty(iidd: abc.data![len].id.toString()))
                                );
                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                                child:  Container(
                                                  child: Image.asset(AppImages.propertysale,width: 120,fit: BoxFit.fill),
                                                ),
                                              ),
                                              SizedBox(height: 5,),
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.green),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.green.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].type.toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 5,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Property Address",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 180,
                                                child: Text(""+abc.data![len].PropertyAddress,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Iconsax.home_1_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Society",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 180,
                                                child: Text(""+abc.data![len].Society,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons.push_pin,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Place",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: 180,
                                                child: Text(""+abc.data![len].Place,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Icon(Iconsax.building_3_copy,size: 14,color: Colors.red,),
                                                  SizedBox(width: 3,),
                                                  Text(""+abc.data![len].City.toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey.shade600,
                                                        fontWeight: FontWeight.w500
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }


                  }

              ),*/


            ),



          ],
        ),
      ),
    );
  }
}
