import 'dart:convert';
import 'package:get/get.dart';
import '../Controller/Show_demand_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Add_tenantdemand_num.dart';
import 'Tenant_demands_details.dart';

class Catid {
  final int id;
  final String V_name;
  final String V_number;
  final String bhk;
  final String budget;
  final String place;
  final String floor_option;
  final String Additional_Info;
  final String Shifting_date;
  final String Current_date;
  final String Parking;
  final String Gadi_Number;
  final String FeildWorker_Name;
  final String FeildWorker_Number;
  final String Current__Date;
  final String Family_Members;
  final String buyrent;

  Catid(
      {required this.id, required this.V_name, required this.V_number, required this.bhk, required this.budget,
        required this.place, required this.floor_option, required this.Additional_Info, required this.Shifting_date,required this.Current_date,
        required this.Parking, required this.Gadi_Number, required this.FeildWorker_Name, required this.FeildWorker_Number,
        required this.Current__Date,required this.Family_Members,required this.buyrent});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['VTD_id'],
        V_name: json['V_name'],
        V_number: json['V_number'],
        bhk: json['bhk'],
        budget: json['budget'],
        place: json['place'],
        floor_option: json['floor_option'],
        Additional_Info: json['Additional_Info'],
        Shifting_date: json['Shifting_date'],
        Current_date: json['Current__Date'],
        Parking: json['Parking'],
        Gadi_Number: json['Gadi_Number'],
        FeildWorker_Name: json['FeildWorker_Name'],
        FeildWorker_Number: json['FeildWorker_Number'],
        Current__Date: json['Current__Date'],
        Family_Members: json['Family_Members'],
        buyrent: json['Buy_rent']);
  }
}

class Tenant_demands extends StatefulWidget {
  const Tenant_demands({super.key});

  @override
  State<Tenant_demands> createState() => _Tenant_demandsState();
}

class _Tenant_demandsState extends State<Tenant_demands> {

  final TenantController tenantController = Get.put(TenantController());


  // Future<List<Catid>> fetchData(id) async {
  //   var url = Uri.parse('https://verifyserve.social/WebService4.asmx/filter_tenant_demand_by_feildworkar_number_?FeildWorker_Number=$_num');
  //   final responce = await http.get(url);
  //   if (responce.statusCode == 200) {
  //     List listresponce = json.decode(responce.body);
  //     listresponce.sort((a, b) => b['VTD_id'].compareTo(a['VTD_id']));
  //     return listresponce.map((data) => Catid.FromJson(data)).toList();
  //   }
  //   else {
  //     throw Exception('Unexpected error occured!');
  //   }
  // }

  // String _num = '';
  // String _na = '';

  // @override
  // void initState() {
  //   super.initState();
  //   _loaduserdata();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      Obx(() {
        if (tenantController.tenantList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final reversedList = tenantController.filteredList.reversed.toList();

        return Column(
            children: [
              // 🔎 Search Bar
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  onChanged: (value) => tenantController.searchText.value = value,
                  decoration: InputDecoration(
                    hintText: 'Search tenant name, place, BHK...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: tenantController.searchText.value.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        tenantController.searchText.value = '';
                        FocusScope.of(context).unfocus();
                      },
                    )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              if (reversedList.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    "No matching result found.",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Total Result: ${reversedList.length}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

        Expanded(
        child: RefreshIndicator(
          onRefresh: () => tenantController.fetchTenants(
            tenantController.number, // call API again
          ),
          child: ListView.builder(
                                    itemCount: reversedList.length,
                                    shrinkWrap: true,
                                    //physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (BuildContext context,index) {
                                      final item = reversedList[index];
                                      int DisplayIndex = reversedList.length;
                                      return GestureDetector(
                                        onTap: () async {
                                          //  int itemId = abc.data![len].id;
                                          //int iiid = abc.data![len].PropertyAddress
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setString('id_Document', abc.data![len].id.toString());*/
                                          /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                        prefs.setInt('id_Building', abc.data![len].id);
                                        prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
                                        prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute
                                              (builder: (context) => Tenant_Demands_details())
                                        );*/
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute
                                                (builder: (context) =>
                                                  Tenant_Demands_details(
                                                    idd: '${item.id}',
                                                    pending_id: '0',))
                                          );
                                        },
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top: 20,
                                                  left: 10,
                                                  right: 10,
                                                  bottom: 10),
                                              child: Container(
                                                padding: const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(
                                                      10),
                                                ),
                                                child: Row(
                                                  crossAxisAlignment: CrossAxisAlignment
                                                      .center,
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .start,
                                                  children: [
                                                    SizedBox(width: 5,),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .center,
                                                      children: [
          
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          children: [
          
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .greenAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .greenAccent
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //SizedBox(width: 10,),
                                                                  Icon(PhosphorIcons
                                                                      .house,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(width: 2,),
                                                                  Text(
                                                                    item.bhk /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .greenAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .greenAccent
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.buyrent /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .greenAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .greenAccent
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text("" +
                                                                      item.place /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                            Icon(
                                                              Iconsax.location_copy,
                                                              size: 12,
                                                              color: Colors.red,),
                                                            SizedBox(width: 2,),
                                                            Text(" Name | Number",
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight
                                                                      .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            SizedBox(width: 10,),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .red),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .red
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //w SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.V_name /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        letterSpacing: 0.5
                                                                    ),
                                                                  ),
                                                                ],
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
                                                              color: Colors.red,),
                                                            SizedBox(width: 2,),
                                                            Text(
                                                              "Type Of Requirement / Floor Options",
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              maxLines: 2,
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight
                                                                      .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .purple),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .purple
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //w SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.bhk /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .purple),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .purple
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text("" +
                                                                      item.floor_option /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        letterSpacing: 0.5
                                                                    ),
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
                                                            Icon(PhosphorIcons.car,
                                                              size: 12,
                                                              color: Colors.red,),
                                                            SizedBox(width: 2,),
                                                            Text(
                                                              "Need Parking / Vehicle Number",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight
                                                                      .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          crossAxisAlignment: CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            SizedBox(
                                                              width: 20,
                                                            ),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .cyanAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .cyanAccent
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //w SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.Parking /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .cyanAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .cyanAccent
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //w SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.Gadi_Number
                                                                          .toUpperCase(),
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                            Icon(PhosphorIcons
                                                                .users_four, size: 12,
                                                              color: Colors.red,),
                                                            SizedBox(width: 2,),
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text(
                                                                "Family Members = ",
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontSize: 11,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight: FontWeight
                                                                        .w600
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(width: 10,),
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text("" +
                                                                  item.Family_Members +
                                                                  " Members",
                                                                overflow: TextOverflow
                                                                    .ellipsis,
                                                                maxLines: 2,
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight: FontWeight
                                                                        .w400
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
                                                            Icon(PhosphorIcons
                                                                .address_book,
                                                              size: 12,
                                                              color: Colors.red,),
                                                            SizedBox(width: 2,),
                                                            Text(
                                                              "Additional Information",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight
                                                                      .w600),
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
                                                              crossAxisAlignment: CrossAxisAlignment
                                                                  .start,
                                                              children: [
          
                                                                SizedBox(
                                                                  width: 300,
                                                                  child: Text("" +
                                                                      item.Additional_Info,
                                                                    overflow: TextOverflow
                                                                        .ellipsis,
                                                                    maxLines: 2,
                                                                    style: TextStyle(
                                                                        fontSize: 12,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w400
                                                                    ),
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
                                                            Icon(PhosphorIcons
                                                                .address_book,
                                                              size: 12,
                                                              color: Colors.red,),
                                                            SizedBox(width: 2,),
                                                            Text(
                                                              "Budget / Shifting Date",
                                                              style: TextStyle(
                                                                  fontSize: 11,
                                                                  color: Colors.black,
                                                                  fontWeight: FontWeight
                                                                      .w600),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(
                                                          height: 5,
                                                        ),
          
                                                        Row(
                                                          children: [
          
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .blue),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .blue
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //SizedBox(width: 10,),
                                                                  Icon(PhosphorIcons
                                                                      .currency_inr,
                                                                    size: 12,
                                                                    color: Colors
                                                                        .red,),
                                                                  SizedBox(width: 2,),
                                                                  Text("" +
                                                                      item.budget /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 15,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .blue),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .blue
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //w SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.Shifting_date /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        letterSpacing: 0.5
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
          
          
                                                          ],
                                                        ),
          
                                                        SizedBox(height: 10,),
          
                                                        Center(
                                                          child: Text("Field Worker",
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight
                                                                    .w600),),
                                                        ),
          
                                                        SizedBox(
                                                          height: 5,
                                                        ),
          
                                                        Row(
                                                          children: [
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .purple),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .purple
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.FeildWorker_Name /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 14,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
                                                                        letterSpacing: 0.5
                                                                    ),
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
                                                                  builder: (
                                                                      context) =>
                                                                      AlertDialog(
                                                                        title: Text(
                                                                            'Call Feild Worker'),
                                                                        content: Text(
                                                                            'Do you really want to Call Feild Worker?'),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius: BorderRadius
                                                                                .circular(
                                                                                20)),
                                                                        actions: <
                                                                            Widget>[
                                                                          ElevatedButton(
                                                                            onPressed: () =>
                                                                                Navigator
                                                                                    .of(
                                                                                    context)
                                                                                    .pop(
                                                                                    false),
                                                                            child: Text(
                                                                                'No'),
                                                                          ),
                                                                          ElevatedButton(
                                                                            onPressed: () async {
                                                                              FlutterPhoneDirectCaller
                                                                                  .callNumber(
                                                                                  '${item.FeildWorker_Number}');
                                                                            },
                                                                            child: Text(
                                                                                'Yes'),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                ) ?? false;
                                                              },
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .only(left: 10,
                                                                    right: 10,
                                                                    top: 0,
                                                                    bottom: 0),
                                                                decoration: BoxDecoration(
                                                                  borderRadius: BorderRadius
                                                                      .circular(5),
                                                                  border: Border.all(
                                                                      width: 1,
                                                                      color: Colors
                                                                          .purple),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                        color: Colors
                                                                            .purple
                                                                            .withOpacity(
                                                                            0.5),
                                                                        blurRadius: 10,
                                                                        offset: Offset(
                                                                            0, 0),
                                                                        blurStyle: BlurStyle
                                                                            .outer
                                                                    ),
                                                                  ],
                                                                ),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment
                                                                      .center,
                                                                  children: [
                                                                    Text("" +
                                                                        item.FeildWorker_Number /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          color: Colors
                                                                              .black,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          letterSpacing: 0.5
                                                                      ),
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
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .lightGreenAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .lightGreenAccent
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Tenant id =  " +
                                                                        item.id.toString() /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .lightGreenAccent),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .lightGreenAccent
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                                  //w SizedBox(width: 10,),
                                                                  Text("" +
                                                                      item.Current_date.toString() /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(left: 10,
                                                                  right: 10,
                                                                  top: 0,
                                                                  bottom: 0),
                                                              decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(5),
                                                                border: Border.all(
                                                                    width: 1,
                                                                    color: Colors
                                                                        .brown),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                      color: Colors
                                                                          .brown
                                                                          .withOpacity(
                                                                          0.5),
                                                                      blurRadius: 10,
                                                                      offset: Offset(
                                                                          0, 0),
                                                                      blurStyle: BlurStyle
                                                                          .outer
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Text(
                                                                    "Demand No = $DisplayIndex" /*+abc.data![len].Building_Name.toUpperCase()*/,
                                                                    style: TextStyle(
                                                                        fontSize: 13,
                                                                        color: Colors
                                                                            .black,
                                                                        fontWeight: FontWeight
                                                                            .w500,
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
          
          
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    }),
        ),
      ),
        ]
    );
      }
      ),
        floatingActionButton:
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                        EdgeInsets.symmetric(vertical: 10, horizontal: 10)),

                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => add_Tenant_num()));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.add_circle),
                      const SizedBox(width: 5,),
                      Text("Add Demand", style: const TextStyle(fontSize: 15),),
                    ],
                  ),),
              ],
            ),
            const SizedBox(height: 30,)
          ],
        )
        );
  }
  // void _loaduserdata() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _na = prefs.getString('name') ?? '';
  //     _num = prefs.getString('number') ?? '';
  //     print(_num);
  //   });
  // }
}

