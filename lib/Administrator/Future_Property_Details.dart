import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../constant.dart';
import '../model/docpropertySlider.dart';
import '../model/futureProperty_Slideer.dart';
import '../model/realestateModel.dart';
import 'Update_Future_Property.dart';

class Catid {
  final int id;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String BHK;
  final String tyope;
  final String floor_ ;
  final String buy_Rent ;
  final String Building_information;
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String vehicleNo;
  final String date;
  final String sqft;
  final String property_address_for_fieldworkar;
  final String your_address;

  Catid(
      {required this.id, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.BHK, required this.tyope, required this.floor_, required this.buy_Rent,
        required this.Building_information,required this.Ownername,required this.Owner_number, required this.Caretaker_name,required this.Caretaker_number,required this.vehicleNo,required this.date,required this.sqft,required this.property_address_for_fieldworkar,required this.your_address
      });

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['id'],
        Building_Address: json['propertyname_address'],
        Building_Location: json['place'],
        Building_image: json['images'],
        Longitude: json['longitude'],
        Latitude: json['latitude'],
        BHK: json['select_bhk'],
        tyope: json['typeofproperty'],
        floor_: json['floor_number'],
        buy_Rent: json['buy_rent'],
        Building_information: json['building_information_facilitys'],
        Ownername: json['ownername'],
        Owner_number: json['ownernumber'],
        Caretaker_name: json['caretakername'],
        Caretaker_number: json['caretakernumber'],
        vehicleNo: json['owner_vehical_number'],
        date: json['current_date_'],
        sqft: json['sqyare_feet'],
        property_address_for_fieldworkar: json['property_address_for_fieldworkar'],
        your_address: json['your_address']);
  }
}

class Administater_Future_Property_details extends StatefulWidget {
  String idd;
  Administater_Future_Property_details({super.key, required this.idd});

  @override
  State<Administater_Future_Property_details> createState() => _Administater_Future_Property_detailsState();
}

class _Administater_Future_Property_detailsState extends State<Administater_Future_Property_details> {



  Future<List<Catid>> fetchData(id_num) async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_id?id=$id_num");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<DocumentMainModel_F>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_future_property_addimages_by_subid_?subid=${widget.idd}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return DocumentMainModel_F(
          dimage: item['img'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  bool _isDeleting = false;



  // final result = await fetchData();

  List<String> name = [];

  // late final int iid;

  int _id = 0;

  @override
  void initState() {
    super.initState();

  }

  String data = 'Initial Data';

  void _refreshData() {
    setState(() {
      data = 'Refreshed Data at ${DateTime.now()}';
    });
  }

  Future<void> _handleMenuItemClick(String value) async {
    // Handle the menu item click
    print("You clicked: $value");
    if(value.toString() == 'Edit Property'){

      fetchData(widget.idd);
      final Result = await fetchData(widget.idd);

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Update_FutureProperty(id: '${Result.first.id}',ownername: '${Result.first.Ownername}',ownernumber: '${Result.first.Owner_number}', caretakername: '${Result.first.Caretaker_name}',
                caretakernumber: '${Result.first.Caretaker_number}', place: '${Result.first.Building_Location}', buy_rent: '${Result.first.buy_Rent}', typeofproperty: '${Result.first.tyope}', select_bhk: '${Result.first.BHK}',
                floor_number: '${Result.first.floor_}', sqyare_feet: '${Result.first.sqft}', propertyname_address: '${Result.first.Building_Address}', building_information_facilitys: '${Result.first.Building_information}',
                property_address_for_fieldworkar: '${Result.first.property_address_for_fieldworkar}', owner_vehical_number: '${Result.first.vehicleNo}', your_address: '${Result.first.your_address}',)));

    }
    if(value.toString() == 'Add Property Images'){

      /*Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => FutyureProperty_FileUploadPage(idd: '${widget.idd}',)));*/


      /*Fluttertoast.showToast(
          msg: 'Add Property Images',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );*/
    }
    if(value.toString() == 'Delete Added Images'){
      Fluttertoast.showToast(
          msg: 'Delete Added Images',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
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
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuItemClick,
            itemBuilder: (BuildContext context) {
              return {'Edit Property',  'Add Property Images', 'Delete This Property'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              FutureBuilder<List<DocumentMainModel_F>>(
                future: fetchCarouselData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text('No data available.'));
                  } else {
                    return CarouselSlider(
                      options: CarouselOptions(
                        height: 180.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 2),
                      ),
                      items: snapshot.data!.map((item) {
                        return Builder(
                          builder: (BuildContext context) {
                            return  Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 320,
                              child: ClipRRect(
                                borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "https://verifyserve.social/PHP_Files/future_property_slider_images/${item.dimage}",
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
                            );
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),

              FutureBuilder<List<Catid>>(
                  future: fetchData(widget.idd),
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
                            return GestureDetector(
                              onTap: () async {

                              },
                              child: Column(
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 5),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [

                                          const SizedBox(height: 20,),

                                          Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
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
                                                            Text(""+abc.data![len].tyope/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                              style: TextStyle(
                                                                  fontSize: 14,
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
                                                          border: Border.all(width: 1, color: Colors.teal),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.teal.withOpacity(0.5),
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



                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Center(
                                                        child: Text("Property Owner",style: TextStyle(fontSize: 16,
                                                            color: Colors.black,
                                                            fontWeight: FontWeight.w600),),
                                                      ),

                                                      SizedBox(
                                                        height: 10,
                                                      ),

                                                      Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Container(
                                                              width: 140,
                                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(5),
                                                                border: Border.all(width: 1, color: Colors.indigoAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors.indigoAccent.withOpacity(0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(0, 0),
                                                                      blurStyle: BlurStyle.outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //SizedBox(width: 10,),
                                                                  Text(""+abc.data![len].Ownername/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 14,
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

                                                            GestureDetector(
                                                              onTap: (){

                                                                showDialog<bool>(
                                                                  context: context,
                                                                  builder: (context) => AlertDialog(
                                                                    title: Text('Call Property tenant'),
                                                                    content: Text('Do you really want to Call Tenant?'),
                                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                    actions: <Widget>[
                                                                      ElevatedButton(
                                                                        onPressed: () => Navigator.of(context).pop(false),
                                                                        child: Text('No'),
                                                                      ),
                                                                      ElevatedButton(
                                                                        onPressed: () async {
                                                                          FlutterPhoneDirectCaller.callNumber('${abc.data![len].Owner_number}');
                                                                        },
                                                                        child: Text('Yes'),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ) ?? false;
                                                              },
                                                              child: Container(
                                                                width: 140,
                                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius.circular(5),
                                                                  border: Border.all(width: 1, color: Colors.indigoAccent),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors.indigoAccent.withOpacity(0.5),
                                                                        blurRadius: 10,
                                                                        offset: Offset(0, 0),
                                                                        blurStyle: BlurStyle.outer
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                  children: [
                                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                                    //SizedBox(width: 10,),
                                                                    Text(""+abc.data![len].Owner_number/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors.black,
                                                                          fontWeight: FontWeight.w500,
                                                                          letterSpacing: 0.5
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
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
                                                      Text("Caretaker Name & Caretaker Number",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        child: Text(""+abc.data![len].Caretaker_name+"  |  "+abc.data![len].Caretaker_number,
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
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Date",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        width: 250,
                                                        child: Text('${abc.data![len].date}',
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
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Building Address for feildworker",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        width: 250,
                                                        child: Text('${abc.data![len].property_address_for_fieldworkar}',
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
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Building Information",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        width: 250,
                                                        child: Text('${abc.data![len].Building_information}',
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
                                                    height: 10,
                                                  ),

                                                  Row(
                                                    children: [
                                                      Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text("Owner Vehicle Details",
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 2,
                                                        style: TextStyle(
                                                            fontSize: 12,
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
                                                        width: 250,
                                                        child: Text('${abc.data![len].vehicleNo}',
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
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(5),
                                                          border: Border.all(width: 1, color: Colors.brown),
                                                          boxShadow: [
                                                            BoxShadow(
                                                                color: Colors.brown.withOpacity(0.5),
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
                                                            Text(""+abc.data![len].buy_Rent.toUpperCase()/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                            Text(""+abc.data![len].Building_Location.toUpperCase()/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                    height: 20,
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

              ),

            ],
          ),






        ),
      ),
    );
  }
}
