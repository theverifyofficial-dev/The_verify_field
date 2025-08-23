import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../Administater_Realestate_Details.dart';

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
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String Date;

  Catid(
      {required this.id, required this.Building_Name, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.sqft, required this.tyope, required this.floor_, required this.maintence, required this.buy_Rent,
        required this.Building_information,required this.balcony,required this.Parking,required this.facility,required this.Furnished,required this.kitchen,required this.Baathroom,required this.Ownername,required this.Owner_number,
        required this.Caretaker_name,required this.Caretaker_number,required this.Date});

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
        Ownername: json['Ownername'],
        Owner_number: json['Owner_number'],
        Caretaker_name: json['Water_geyser'],
        Caretaker_number: json['CareTaker_number'],
        Date: json['date_']);
  }
}

class See_All_Realestate extends StatefulWidget {
  String id;
  See_All_Realestate({super.key, required this.id});

  @override
  State<See_All_Realestate> createState() => _See_All_RealestateState();
}

class _See_All_RealestateState extends State<See_All_Realestate> {

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=${widget.id}&looking=Flat");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

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
    final size = MediaQuery.of(context).size;
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
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
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
        child: FutureBuilder<List<Catid>>(
          future: fetchData(),
          builder: (context, abc) {
            if (abc.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (abc.hasError) {
              return Center(child: Text('Error: ${abc.error}'));
            } else if (!abc.hasData || abc.data!.isEmpty) {
              return Center(child: Text('No data available'));
            } else {
              final data = abc.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(

                    child: ListView.builder(
                      //scrollDirection: Axis.horizontal,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (BuildContext context,int len) {
                        int displayIndex = abc.data!.length - len;
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute
                                  (builder: (context) => Administater_View_Details(idd: '${abc.data![len].id}',))
                            );
                          },
                          child: Container(
                            width: 310,
                            margin: EdgeInsets.only(
                                bottom: 10, top: 10, left:5, right: 10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 400,
                                  width: size.width,
                                  child:ClipRRect(
                                    borderRadius: const BorderRadius.only(topLeft:Radius.circular(5),topRight: Radius.circular(5)),
                                    child:  CachedNetworkImage(
                                      imageUrl:
                                      "https://www.verifyserve.social/${abc.data![len].Building_image}",
                                      // height: 60.h,
                                      // width: 120.w,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        AppImages.loading,
                                        // height: 60.h,
                                        // width: 120.w,
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, error, stack) =>
                                          Image.asset(
                                            AppImages.imageNotFound,
                                            // height: 60.h,
                                            // width: 120.w,
                                            fit: BoxFit.cover,
                                          ),
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 10,
                                ),

                                Row(
                                  children: [

                                    SizedBox(
                                      width: 5,
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
                                      width: 20,
                                    ),
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
                                        children: <Widget> [


                                          Text(""+abc.data![len].buy_Rent.toUpperCase(),
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
                                      width: 20,
                                    ),

                                    Container(
                                      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(width: 1, color: Colors.pink),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.pink
                                                  .withOpacity(0.5),
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
                                          Text(""+abc.data![len].BHK.toUpperCase()/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [

                                        SizedBox(width: 5,),
                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(width: 1, color: Colors.purple),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.purple.withOpacity(0.5),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 0),
                                                  blurStyle: BlurStyle.outer
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              // Icon(Iconsax.sort_copy,size: 15,),
                                              Text(""+abc.data![len].Building_Location, maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10,),
                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(width: 1, color: Colors.purple),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.purple.withOpacity(0.5),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 0),
                                                  blurStyle: BlurStyle.outer
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              // Icon(Iconsax.sort_copy,size: 15,),
                                              Text(""+abc.data![len].floor_, maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 10,),

                                      ],
                                    ),


                                  ],
                                ),

                                SizedBox(
                                  height: 10,
                                ),

                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal:5),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.location_city_rounded,
                                        size: 20,
                                        color: Colors.blue,
                                      ),
                                      Expanded(

                                          child: Text("${abc.data![len].Building_information}" ,
                                            maxLines: 5,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Colors.black
                                            ),
                                          )
                                      ),

                                    ],
                                  ),
                                ),

                                SizedBox(height: 10,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                      children: [

                                        SizedBox(width: 5,),
                                        Container(
                                          padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(5),
                                            border: Border.all(width: 1, color: Colors.pinkAccent),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.pinkAccent.withOpacity(0.5),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 0),
                                                  blurStyle: BlurStyle.outer
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              // Icon(Iconsax.sort_copy,size: 15,),
                                              Text(""+abc.data![len].Date, maxLines: 2,
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        "₹ ${abc.data![len].Rent}${abc.data![len].Verify_price}",
                                        style: const TextStyle(color: Colors.green,fontWeight: FontWeight.w500,fontSize: 22),
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 10,),

                                Row(
                                  children: [
                                    SizedBox(width: 5,),
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
                                          //w SizedBox(width: 10,),-
                                          Text("Property No = $displayIndex"/* ${len + 1} or +abc.data![len].id.toString()*//*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                          Text("Id = "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                SizedBox(height: 10,),

                                // const SizedBox(
                                //   height: 10,
                                // )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),

    );
  }
}
