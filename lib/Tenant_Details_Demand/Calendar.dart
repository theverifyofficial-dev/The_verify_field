import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import 'Tenant_demands_details.dart';
import 'Visit_By_date/Show_Visit_Details.dart';

class Catid_visit {
  final String visit_date;
  final String visit_time;
  final String number;
  final String source_click_website;
  final String subid;
  final String Demand;
  final String other;

  Catid_visit(
      {required this.visit_date, required this.visit_time, required this.number,
        required this.source_click_website, required this.subid, required this.Demand, required this.other});

  factory Catid_visit.FromJson(Map<String, dynamic>json){
    return Catid_visit(
        visit_date: json['visit_date'],
        visit_time: json['visit_time'],
        number: json['number'],
        source_click_website: json['source_click_website'],
        subid: json['subid'],
        Demand: json['ninetynine_acres'],
        other: json['other']);
  }
}

class Calender extends StatefulWidget {
  const Calender({super.key});

  @override
  State<Calender> createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {

  String _number = '';

  Future<List<Catid_visit>> fetchData1(date) async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_tenant_demand_visit_info_by_date_other?visit_date=$date&other=$_number");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b["id"].compareTo(a["id"]));
      return listresponce.map((data) => Catid_visit.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  String _formattedDate = "";

  // Function to format date in dd/MM/yyyy format
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
    /*final DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);*/
  }

  @override
  void initState() {
    _loaduserdata();
    super.initState();

  }
  Map<DateTime, List<String>> _events = {};

  List<String> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
  }

  // Method to build custom decoration for pinned events
  Widget _buildPinnedEventMarker(DateTime date) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,  // Color for pinned event marker
      ),
    );
  }

  // Custom day builder to pin the event date
  BoxDecoration _pinEventDecoration(DateTime date, bool isSelected) {
    return BoxDecoration(
      color: _getEventsForDay(date).isNotEmpty
          ? Colors.blueAccent.withOpacity(0.5)  // Pinned date background color
          : null,
      shape: BoxShape.circle,
      border: isSelected
          ? Border.all(color: Colors.blue, width: 2)
          : Border.all(color: Colors.transparent),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 10,),
          TableCalendar(
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay; // Update the focused day as well
                _formattedDate = _formatDate(selectedDay);
              });
            },

            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                bool isSelected = isSameDay(_selectedDay, day);
                return Container(
                  decoration: _pinEventDecoration(day, isSelected),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        color: isSelected ? Colors.red : Colors.redAccent,
                      ),
                    ),
                  ),
                );
              },
              markerBuilder: (context, day, events) {
                if (_getEventsForDay(day).isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: _buildPinnedEventMarker(day),  // Add pin marker
                  );
                }
                return null;
              },
            ),

            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.sunday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false, // Hide format button
              titleCentered: true, // Center title
            ),
          ),
          //SizedBox(height: 10),
          // Display selected date in dd/MM/yyyy format
          /*Text(
            _selectedDay != null
                ? "Selected Date: ${_formattedDate}"
                : "No date selected",
            style: TextStyle(fontSize: 20),
          ),*/


          Expanded(
            child: FutureBuilder<List<Catid_visit>>(
                future: fetchData1('${_formattedDate}'),
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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute
                                    (builder: (context) => Tenant_Demands_details(idd: '${abc.data![len].subid}', pending_id: '0',))
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
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Row(
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
                                                GestureDetector(
                                                  onTap: (){

                                                    /*showDialog<bool>(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              title: Text("Call "+abc.data![len].number),
                                                              content: Text('Do you really want to Call? '+abc.data![len].number ),
                                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                              actions: <Widget>[
                                                                ElevatedButton(
                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                  child: Text('No'),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    FlutterPhoneDirectCaller.callNumber('${abc.data![len].number}');
                                                                  },
                                                                  child: Text('Yes'),
                                                                ),
                                                              ],
                                                            ),
                                                          ) ?? false;*/
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.purpleAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.purpleAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        //Icon(Iconsax.call,size: 15,color: Colors.red,),
                                                        SizedBox(width: 4,),
                                                        Text(""+abc.data![len].Demand/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
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

                                            SizedBox(
                                              height: 10,
                                            ),

                                            Row(
                                              children: [
                                                Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                SizedBox(width: 2,),
                                                Text(" Name | Number",
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
                                                SizedBox(width: 10,),
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
                                                      Text(""+abc.data![len].source_click_website/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                SizedBox(width: 10,),
                                                GestureDetector(
                                                  onTap: (){
                                                    showDialog<bool>(
                                                      context: context,
                                                      builder: (context) => AlertDialog(
                                                        title: Text("Call "+abc.data![len].source_click_website),
                                                        content: Text('Do you really want to Call? '+abc.data![len].source_click_website),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                        actions: <Widget>[
                                                          ElevatedButton(
                                                            onPressed: () => Navigator.of(context).pop(false),
                                                            child: Text('No'),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              FlutterPhoneDirectCaller.callNumber('${abc.data![len].number}');
                                                            },
                                                            child: Text('Yes'),
                                                          ),
                                                        ],
                                                      ),
                                                    ) ?? false;
                                                  },

                                                  child: Container(
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
                                                        Text(""+abc.data![len].number/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [

                                                Container(
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
                                                    children: [
                                                      // Icon(Iconsax.sort_copy,size: 15,),
                                                      //SizedBox(width: 10,),
                                                      Icon(PhosphorIcons.house,size: 12,color: Colors.red,),
                                                      SizedBox(width: 2,),
                                                      Text(""+abc.data![len].visit_date/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 15,
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
                                                      Text(""+abc.data![len].visit_time/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                        style: TextStyle(
                                                            fontSize: 15,
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
          ),

        ],
      ),
    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }

}
