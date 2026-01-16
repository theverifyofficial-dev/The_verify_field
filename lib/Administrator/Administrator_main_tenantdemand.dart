import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Home_Screen_click/Add_RealEstate.dart';
import '../Tenant_Details_Demand/ALl_Demands.dart';
import '../Tenant_Details_Demand/Add_tenantdemand_num.dart';
import '../Tenant_Details_Demand/Tenant_demands_details.dart';
import '../Custom_Widget/constant.dart';
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

class Administrator_Tenant_demands extends StatefulWidget {
  const Administrator_Tenant_demands({super.key});

  @override
  State<Administrator_Tenant_demands> createState() => _Administrator_Tenant_demandsState();
}

class _Administrator_Tenant_demandsState extends State<Administrator_Tenant_demands> {

  Future<List<Catid>> fetchData(id) async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/filter_tenant_demand_by_feildworkar_number_?FeildWorker_Number=$_num');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['VTD_id'].compareTo(a['VTD_id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }
  late Future<List<Catid>> _futureData;
  List<Catid> _allData = [];
  List<Catid> _filteredData = [];
  final TextEditingController _searchController = TextEditingController();
  String _num = '';
  String _na = '';
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
        _filteredData = List.from(_allData); // show all if no search
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
        }).toList();
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: [

            GestureDetector(
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Tenant_ALl_demands()));
              },
              child: Center(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10)),
                      color: Colors.red.withOpacity(0.8)),
                  child: Center(
                    child: Text(
                      " All Tenant Demands",
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

            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search by any field...",
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // // 🔹 Count of total properties found
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
            //   child: Text(
            //     "Total Properties Found: ${_filteredData.length}",
            //     style: const TextStyle(
            //       fontSize: 16,
            //       fontWeight: FontWeight.bold,
            //     ),
            //   ),
            // ),
            Expanded(
              child: FutureBuilder<List<Catid>>(
                future: fetchData("" + 1.toString()), // your API call
                builder: (context, abc) {
                  if (abc.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (abc.hasError) {
                    return Text('${abc.error}');
                  } else if (abc.data == null || abc.data!.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          Text(
                            "No Data Found!",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                letterSpacing: 0),
                          ),
                        ],
                      ),
                    );
                  } else {
                    final query = _searchController.text.trim().toLowerCase();

                    // Filter data based on search text
                    final filtered = abc.data!.where((item) {
                      bool contains(dynamic field) {
                        if (field == null) return false;
                        return field.toString().toLowerCase().contains(query);
                      }

                      return query.isEmpty ||
                          contains(item.id) ||
                          contains(item.V_name) ||
                          contains(item.V_number) ||
                          contains(item.bhk) ||
                          contains(item.budget) ||
                          contains(item.place) ||
                          contains(item.floor_option) ||
                          contains(item.Additional_Info) ||
                          contains(item.Shifting_date) ||
                          contains(item.Current_date) ||
                          contains(item.Parking) ||
                          contains(item.Gadi_Number) ||
                          contains(item.FeildWorker_Name) ||
                          contains(item.FeildWorker_Number) ||
                          contains(item.Current__Date) ||
                          contains(item.Family_Members) ||
                          contains(item.buyrent);
                    }).toList().reversed.toList(); // reverse order

                    return ListView.builder(
                      itemCount: filtered.length,
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        final item = filtered[index];
                        int displayIndex = filtered.length - index;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Tenant_Demands_details(
                                  idd: '${item.id}',
                                  pending_id: '0',
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  /// First Row: BHK - Buy/Rent - Place
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildTag(
                                        icon: PhosphorIcons.house,
                                        text: item.bhk,
                                        borderColor: Colors.red,
                                        iconColor: Colors.red,
                                      ),
                                      _buildTag(
                                        text: item.buyrent,
                                        borderColor: Colors.blue,
                                      ),
                                      _buildTag(
                                        text: item.place,
                                        borderColor: Colors.green,
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  /// Name Row
                                  Center(
                                    child: _buildTag(
                                      text: item.V_name,
                                      borderColor: Colors.red,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      horizontalPadding: 40,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  /// Budget + Shifting Row
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTag(
                                          icon: PhosphorIcons.currency_inr,
                                          text: "Budget : ${item.budget}",
                                          borderColor: Colors.blue,
                                          iconColor: Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildTag(
                                          text: "Shifting: ${item.Shifting_date}",
                                          borderColor: Colors.blue,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  /// Tenant ID + Demand No
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildTag(
                                          text: "Tenant id = ${item.id}",
                                          borderColor: Colors.lightGreenAccent,
                                          fontSize: 13,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildTag(
                                          text: "Demand No = $displayIndex",
                                          borderColor: Colors.brown,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );

                      },
                    );
                  }
                },
              ),
            ),

          ],
        ),

      ),


    );
  }
  Widget _buildTag({
    String text = "",
    IconData? icon,
    Color borderColor = Colors.grey,
    Color? iconColor,
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w500,
    double horizontalPadding = 10,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(width: 1, color: borderColor),
        boxShadow: [
          BoxShadow(
            color: borderColor.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: iconColor ?? borderColor),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.black,
                fontWeight: fontWeight,
                letterSpacing: 0.5,
              ),
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