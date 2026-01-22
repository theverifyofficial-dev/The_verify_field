import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Administrator/Administrator_main_tenantdemand.dart';
import '../Home_Screen_click/Add_RealEstate.dart';
import '../Custom_Widget/constant.dart';
import 'Add_TenantDemands.dart';
import 'Add_tenantdemand_num.dart';
import 'Tenant_demands_details.dart';


class Tenant_ALl_demands extends StatefulWidget {
  const Tenant_ALl_demands({super.key});

  @override
  State<Tenant_ALl_demands> createState() => _Tenant_ALl_demandsState();
}

class _Tenant_ALl_demandsState extends State<Tenant_ALl_demands> {

  Future<List<TenantModel>> fetchData(id) async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/show_StoreP_Verify_Tenant_Demands_Show_SimpleMethod');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['VTD_id'].compareTo(a['VTD_id']));
      return listresponce.map((data) => TenantModel.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  String _num = '';
  String _na = '';
  late Future<List<TenantModel>> _futureData;
  List<TenantModel> _allData = [];
  List<TenantModel> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _loaduserdata();

    _searchController.addListener(_onSearchChanged);

    _futureData = fetchData(""+1.toString());
    _futureData.then((data) {
      setState(() {
        _allData = data;
        _filteredData = List.from(_allData.reversed); // show all initially
      });
    }).catchError((e) {
      print("Error fetching data: $e");
    });
  }
  void _onSearchChanged() {
    final query = _searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        _filteredData = List.from(_allData.reversed); // keep reversed when empty
      } else {
        _filteredData = _allData.where((item) {
          return item.id.toString().contains(query) ||
              item.V_name.toLowerCase().contains(query) ||
              item.V_number.toLowerCase().contains(query) ||
              item.bhk.toLowerCase().contains(query) ||
              item.budget.toLowerCase().contains(query) ||
              item.place.toLowerCase().contains(query) ||
              item.floor_option.toLowerCase().contains(query) ||
              item.Additional_Info.toLowerCase().contains(query) ||
              item.Shifting_date.toLowerCase().contains(query) ||
              item.Current_date.toLowerCase().contains(query) ||
              item.Parking.toLowerCase().contains(query) ||
              item.Gadi_Number.toLowerCase().contains(query) ||
              item.FeildWorker_Name.toLowerCase().contains(query) ||
              item.FeildWorker_Number.toLowerCase().contains(query) ||
              item.Current__Date.toLowerCase().contains(query) ||
              item.Family_Members.toLowerCase().contains(query) ||
              item.buyrent.toLowerCase().contains(query);
        }).toList().reversed.toList(); // ✅ reverse search results
      }

    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0),
        child: Column(
          children: [
            AppBar(
              surfaceTintColor: Colors.black,
              centerTitle: true,
              backgroundColor: Colors.black,
              title: Image.asset(AppImages.verify, height: 75),
              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Row(
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
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //  Lottie.asset("assets/images/no data.json",width: 450),
                Text("Tenant Demands",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
              ],
            ),
          ],
        ),),
      body: Column(
        children: [

          // 🔹 Search TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search by any field...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // 🔹 Show count of filtered items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            child: Text(
              "Total Properties Found: ${_filteredData.length}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          // 🔹 List of items
          Expanded(
            child: _filteredData.isEmpty
                ? Center(
              child: Text(
                "No Data Found!",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ),
            )
                : ListView.builder(
              itemCount: _filteredData.length,
              itemBuilder: (context, index) {
                final item = _filteredData[_filteredData.length - 1 - index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 5),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5, bottom: 10),
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Colors.greenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .greenAccent
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Icon(
                                                      PhosphorIcons.house,
                                                      size: 12,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      "" +
                                                          item.bhk /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Colors.greenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .greenAccent
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                          item.buyrent /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color:
                                                          Colors.greenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .greenAccent
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .place /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
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
                                              Icon(
                                                Iconsax.location_copy,
                                                size: 12,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                " Name | Number",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.red),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.red
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .V_name /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog<bool>(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text("Call " +
                                                         item
                                                                  .V_name),
                                                          content: Text(
                                                              'Do you really want to Call? ' +
                                                             item
                                                                      .V_name),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                FlutterPhoneDirectCaller
                                                                    .callNumber(
                                                                        '${item.V_number}');
                                                              },
                                                              child:
                                                                  Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ??
                                                      false;
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 0,
                                                      bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.red),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.red
                                                              .withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle:
                                                              BlurStyle.outer),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Iconsax.call,
                                                        size: 15,
                                                        color: Colors.red,
                                                      ),
                                                      SizedBox(
                                                        width: 4,
                                                      ),
                                                      Text(
                                                        "" +
                                                       item
                                                                .V_number /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.5),
                                                      ),
                                                    ],
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
                                              Icon(
                                                Iconsax.location_copy,
                                                size: 12,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Type Of Requirement / Floor Options",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.purple),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.purple
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .bhk /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.purple),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.purple
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .floor_option /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                PhosphorIcons.car,
                                                size: 12,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Need Parking / Vehicle Number",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.cyanAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.cyanAccent
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .Parking /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.cyanAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.cyanAccent
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .Gadi_Number
                                                              .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
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
                                              Icon(
                                                PhosphorIcons.users_four,
                                                size: 12,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Family Members = ",
                                                overflow:
                                                    TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),

                                              SizedBox(
                                                width: 100,
                                                child: Text(
                                                  "" +
                                                 item
                                                          .Family_Members +
                                                      " Members",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                PhosphorIcons.address_book,
                                                size: 12,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Additional Information",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
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
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 300,
                                                    child: Text(
                                                      "" +
                                                     item
                                                              .Additional_Info,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                PhosphorIcons.address_book,
                                                size: 12,
                                                color: Colors.red,
                                              ),
                                              SizedBox(
                                                width: 2,
                                              ),
                                              Text(
                                                "Budget / Shifting Date",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.blue),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.blue
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Icon(
                                                      PhosphorIcons
                                                          .currency_inr,
                                                      size: 12,
                                                      color: Colors.red,
                                                    ),
                                                    SizedBox(
                                                      width: 2,
                                                    ),
                                                    Text(
                                                      "" +
                                                     item
                                                              .budget /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.blue),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.blue
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .Shifting_date /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Center(
                                            child: Text(
                                              "Field Worker",
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors.purple),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.purple
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Text(
                                                      "" +
                                                     item
                                                              .FeildWorker_Name /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showDialog<bool>(
                                                        context: context,
                                                        builder: (context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Call Feild Worker'),
                                                          content: Text(
                                                              'Do you really want to Call Feild Worker?'),
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () =>
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop(
                                                                          false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                FlutterPhoneDirectCaller
                                                                    .callNumber(
                                                                        '${item.FeildWorker_Number}');
                                                              },
                                                              child:
                                                                  Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ??
                                                      false;
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.only(
                                                      left: 10,
                                                      right: 10,
                                                      top: 0,
                                                      bottom: 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    border: Border.all(
                                                        width: 1,
                                                        color: Colors.purple),
                                                    boxShadow: [
                                                      BoxShadow(
                                                          color: Colors.purple
                                                              .withOpacity(0.5),
                                                          blurRadius: 10,
                                                          offset: Offset(0, 0),
                                                          blurStyle:
                                                              BlurStyle.outer),
                                                    ],
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Text(
                                                        "" +
                                                       item
                                                                .FeildWorker_Number /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            letterSpacing: 0.5),
                                                      ),
                                                    ],
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
                                              Container(
                                                padding: EdgeInsets.only(
                                                    left: 10,
                                                    right: 10,
                                                    top: 0,
                                                    bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  border: Border.all(
                                                      width: 1,
                                                      color: Colors
                                                          .lightGreenAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors
                                                            .lightGreenAccent
                                                            .withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle:
                                                            BlurStyle.outer),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(
                                                      "Tenant id =  " +
                                                     item.id
                                                              .toString() /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          letterSpacing: 0.5),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 10,),
                                          Container(
                                            padding: EdgeInsets.only(
                                                left: 10,
                                                right: 10,
                                                top: 0,
                                                bottom: 0),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(5),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors
                                                      .lightGreenAccent),
                                              boxShadow: [
                                                BoxShadow(
                                                    color: Colors
                                                        .lightGreenAccent
                                                        .withOpacity(0.5),
                                                    blurRadius: 10,
                                                    offset: Offset(0, 0),
                                                    blurStyle:
                                                    BlurStyle.outer),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                // Icon(Iconsax.sort_copy,size: 15,),
                                                //w SizedBox(width: 10,),
                                                Text(
                                                  "" +
                                                      item
                                                          .Current_date
                                                          .toString() /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.black,
                                                      fontWeight:
                                                      FontWeight.w500,
                                                      letterSpacing: 0.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _na = prefs.getString('name') ?? '';
      _num = prefs.getString('number') ?? '';
    });
  }

}
