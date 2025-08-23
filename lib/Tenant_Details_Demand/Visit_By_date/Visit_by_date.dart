import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../constant.dart';
import 'Show_Visit_Details.dart';


class Catid_visit {
  final String visit_date;
  final String visit_time;
  final String number;
  final String source_click_website;
  final String subid;

  Catid_visit(
      {required this.visit_date, required this.visit_time, required this.number, required this.source_click_website, required this.subid});

  factory Catid_visit.FromJson(Map<String, dynamic>json){
    return Catid_visit(
        visit_date: json['visit_date'],
        visit_time: json['visit_time'],
        number: json['number'],
        source_click_website: json['source_click_website'],
        subid: json['subid']);
  }
}

class visit_by_date extends StatefulWidget {
  const visit_by_date({super.key});

  @override
  State<visit_by_date> createState() => _visit_by_dateState();
}

class _visit_by_dateState extends State<visit_by_date> {

  Future<List<Catid_visit>> fetchData1() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_tenant_demand_visit_info_by_date_?visit_date=22/09/2024');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid_visit.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};  // Store events for specific dates

  @override
  void initState() {
    super.initState();

    // Sample data: Dates with events (pinned dates)
    _events = {
      DateTime(2024, 9, 27): ['Event 1'],
      DateTime(2024, 10, 5): ['Event 2'],
      DateTime(2024, 10, 12): ['Event 3', 'Event 4'],
      DateTime(2024, 10, 18): ['Event 5'],
    };
  }

  // Function to format the date (optional)
  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  // Function to retrieve events for a specific date
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
      appBar: AppBar(
        title: Text('Calendar with Pinned Events'),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
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
                _focusedDay = focusedDay;
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
                        color: isSelected ? Colors.red : Colors.tealAccent,
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
            eventLoader: _getEventsForDay,
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          SizedBox(height: 20),
          // Display selected date in dd/MM/yyyy format as a string
          Text(
            _selectedDay != null
                ? "Selected Date: ${_formatDate(_selectedDay!)}"
                : "No date selected",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          // Display events for the selected date
          ..._getEventsForDay(_selectedDay ?? _focusedDay)
              .map((event) => ListTile(
            title: Text(event),
          )),
        ],
      ),
    );
  }

  // Method to build the event marker (custom UI for event markers)


    /*Scaffold(
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
                color: Colors.black,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              //_launchURL();
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.apple_logo,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: Container(
        child: FutureBuilder<List<Catid_visit>>(
            future: fetchData1(),
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
                                (builder: (context) => Show_Visit_Details(id: '${abc.data![len].subid}',))
                          );
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
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

                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [

                                            Container(
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 1, color: Colors.greenAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.greenAccent.withOpacity(0.5),
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
                                                  Text(""+abc.data![len].visit_date*/
/*+abc.data![len].Building_Name.toUpperCase()*//*,
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
                                                border: Border.all(width: 1, color: Colors.greenAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.greenAccent.withOpacity(0.5),
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
                                                  Text(""+abc.data![len].visit_time*/
/*+abc.data![len].Building_Name.toUpperCase()*//*,
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
                                        SizedBox(
                                          height: 10,
                                        ),

                                        Row(
                                          children: [
                                            Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text(" Source",
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
                                                  Text(""+abc.data![len].source_click_website*/
/*+abc.data![len].Building_Name.toUpperCase()*/
/*,
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

                                        Row(
                                          children: [
                                            Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text(" Additional Number",
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
                                            GestureDetector(
                                              onTap: (){

                                                */
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
/*
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
                                                    Icon(Iconsax.call,size: 15,color: Colors.red,),
                                                    SizedBox(width: 4,),
                                                    Text(""+abc.data![len].number*/
/*+abc.data![len].Building_Name.toUpperCase()*//*,
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

    );*/

}
