import 'dart:async';
import 'dart:convert';
import 'dart:ui';
import 'package:animated_analog_clock/animated_analog_clock.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Add_commercial_property.dart';
import 'package:verify_feild_worker/Home_Screen_click/live_tabbar.dart';
import 'package:verify_feild_worker/Statistics/Target_MainPage.dart';
import 'package:verify_feild_worker/Upcoming/Parent_Upcoming.dart';
import 'package:verify_feild_worker/profile.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Add_Rented_Flat/Add_Rented_Flat_Tabbar.dart';
import 'Add_Rented_Flat/Field_Worker_Target.dart';
import 'Administrator/agreement_details.dart';
import 'Calender/CalenderForFieldWorker.dart';
import 'Demand_2/Costumer_demand.dart';
import 'Future_Property_OwnerDetails_section/Future_Property.dart';
import 'Home_Screen_click/New_Real_Estate.dart';
import 'Home_Screen_click/live_tabbar.dart';
import 'Propert_verigication_Document/Show_tenant.dart';
import 'Rent Agreement/Dashboard_screen.dart';
import 'Rent Agreement/history_tab.dart';
import 'Social_Media_links.dart';
import 'Tenant_Details_Demand/MainPage_Tenantdemand_Portal.dart';
import 'Web_query/web_query.dart' hide SlideAnimation, ScaleAnimation;
import 'add_properties_firstpage.dart';
import 'main.dart';
class TodayCounts {
  final int agreements;
  final int futureProperties;
  final int websiteVisits;

  TodayCounts({
    required this.agreements,
    required this.futureProperties,
    required this.websiteVisits,
  });
}
class TomorrowEvent {
  final String time;
  final String title;
  final String type; // agreement / future / website

  TomorrowEvent({
    required this.time,
    required this.title,
    required this.type,
  });
}

class Catid1122 {
  final int id;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String BHK;
  final String tyope;
  final String floor_;
  final String buy_Rent;
  final String Building_information;
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String vehicleNo;
  final String property_address_for_fieldworkar;
  final String date;

  Catid1122({
    required this.id,
    required this.Building_Address,
    required this.Building_Location,
    required this.Building_image,
    required this.Longitude,
    required this.Latitude,
    required this.BHK,
    required this.tyope,
    required this.floor_,
    required this.buy_Rent,
    required this.Building_information,
    required this.Ownername,
    required this.Owner_number,
    required this.Caretaker_name,
    required this.Caretaker_number,
    required this.vehicleNo,
    required this.property_address_for_fieldworkar,
    required this.date,
  });

  factory Catid1122.fromJson(Map<String, dynamic> json) {
    return Catid1122(
      id: json['id'],
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
      property_address_for_fieldworkar: json['property_address_for_fieldworkar'],
      date: json['current_date_'],
    );
  }
}

class Catid {
  final int id;

  Catid({required this.id});

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(id: json['logg']);
  }
}

class Home_Screen extends StatefulWidget {
  static const route = "/Home_Screen";
  const Home_Screen({super.key});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> with TickerProviderStateMixin {
  late String formattedDate;
  DateTime now = DateTime.now();

  String _fieldworkarnumber = '';
  String _fieldworkarname = '';

  String? userName;
  String? userNumber;

  int rentPropertiesCount = 0;
  int futurePropertiesCount = 0;
  int agreementCount = 0;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String currentTime = "";

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30)); // IST Time

      final hour = now.hour > 12 ? now.hour - 12 : (now.hour == 0 ? 12 : now.hour);
      final ampm = now.hour >= 12 ? "PM" : "AM";

      setState(() {
        currentTime =
        "${hour.toString().padLeft(2, '0')}:"
            "${now.minute.toString().padLeft(2, '0')}:"
            "${now.second.toString().padLeft(2, '0')} $ampm";
      });
    });
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(-0.3, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    fetchTodayCounts().then((value) {
      if (mounted) {
        setState(() {
          todayCounts = value;
          todayLoading = false;
        });
      }
    });

    _loaduserdata();
    loadUserName();
    _requestLocationPermissionAndGetLocation();
    _loadStats();
    _controller.forward();
  }
  List<AgreementTask> todayAgreements = [];
  List<FutureProperty> todayFutureProperties = [];
  List<WebsiteVisit> todayWebsiteVisits = [];
  List<TomorrowEvent> tomorrowEvents = [];

  Widget _todayCard(bool isDark) {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));

    final monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    final weekNames = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"];

    if (todayLoading || todayCounts == null) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Colors.grey.shade900, Colors.black87]
                : [Colors.blueGrey.shade50, Colors.white],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.1),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(
              isDark ? Colors.blueAccent : Colors.blue.shade800,
            ),
          ),
        ),
      );
    }

    int totalToday = todayCounts!.agreements +
        todayCounts!.futureProperties +
        todayCounts!.websiteVisits;

      return GestureDetector(
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(
              builder: (_) => const CalendarTaskPage()));

        },
      child: Container(
        margin:  EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
              Colors.grey.shade900,
              Colors.black87,
              Colors.grey.shade900,
            ]
                : [
              Colors.white,
              Colors.white,

            ],
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.15),
              blurRadius: 25,
              spreadRadius: 1,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative background elements
            Positioned(
              top: -20,
              right: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.blueAccent.withOpacity(0.1),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// ---------------- HEADER ----------------
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DATE SECTION
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blueAccent,
                              Colors.purpleAccent,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weekNames[today.weekday - 1],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              today.day.toString(),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                height: 0.9,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              monthNames[today.month - 1],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Spacer(),

                      /// ---------------- DIGITAL TIMER ----------------
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      //   decoration: BoxDecoration(
                      //     gradient: LinearGradient(
                      //       colors: isDark
                      //           ? [
                      //         Colors.grey.shade800.withOpacity(0.8),
                      //         Colors.grey.shade900.withOpacity(0.9),
                      //       ]
                      //           : [
                      //         Colors.white,
                      //         Colors.blueGrey.shade100,
                      //       ],
                      //       begin: Alignment.topLeft,
                      //       end: Alignment.bottomRight,
                      //     ),
                      //     borderRadius: BorderRadius.circular(16),
                      //     border: Border.all(
                      //       color: Colors.white.withOpacity(0.1),
                      //       width: 1,
                      //     ),
                      //     boxShadow: [
                      //       BoxShadow(
                      //         color:
                      //         isDark?
                      //         Colors.black.withOpacity(0.4): Colors.grey.withOpacity(0.4),
                      //         blurRadius: 15,
                      //         offset: const Offset(0, 6),
                      //       ),
                      //       BoxShadow(
                      //         color: Colors.blueAccent.withOpacity(0.1),
                      //         blurRadius: 10,
                      //         spreadRadius: 1,
                      //       ),
                      //     ],
                      //   ),
                      //   child: Column(
                      //     children: [
                      //       Text(
                      //         "NOW",
                      //         style: TextStyle(
                      //           fontSize: 10,
                      //           color: Colors.blueAccent.shade200,
                      //           fontWeight: FontWeight.bold,
                      //           letterSpacing: 1,
                      //         ),
                      //       ),
                      //       const SizedBox(height: 4),
                      //       Text(
                      //         currentTime,
                      //         style:  TextStyle(
                      //           fontSize: 16,
                      //           color: isDark?Colors.white:Colors.grey.shade900,
                      //           fontWeight: FontWeight.w700,
                      //           letterSpacing: 2,
                      //           fontFamily: 'Courier',
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.blueGrey.shade100,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          border: Border.all(
                            color: Colors.blueGrey.shade200,
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: AnimatedAnalogClock(
                              size: 90,
                              hourHandColor: Colors.black,
                              minuteHandColor: Colors.black87,
                              secondHandColor: Colors.redAccent,
                            ),
                          ),
                        ),
                      )

                    ],
                  ),

                  const SizedBox(height: 4),

                  /// ---------------- TODAY EVENTS ----------------
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 20,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.redAccent, Colors.orangeAccent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        totalToday == 0 ? "No Events Today" : "Today's Events",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Spacer(),
                      if (totalToday > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.greenAccent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.greenAccent.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            "$totalToday total",
                            style: TextStyle(
                              fontSize: 13,
                              color:
                              Theme.of(context).brightness==Brightness.dark?
                              Colors.greenAccent.shade200:Colors.black87,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  if (totalToday > 0) ...[
                    const SizedBox(height: 6),

                    // ENHANCED COUNT BOXES
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black.withOpacity(0.3) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade200,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          _enhancedCountBox(
                            "Agreements",
                            todayCounts!.agreements,
                            LinearGradient(
                              colors: [Colors.redAccent, Colors.orangeAccent],
                            ),
                            Icons.handshake,
                            isDark,
                          ),
                          _enhancedCountBox(
                            "Future",
                            todayCounts!.futureProperties,
                            LinearGradient(
                              colors: [Colors.blueAccent, Colors.indigoAccent],
                            ),
                            Icons.fitbit_outlined,
                            isDark,
                          ),
                          _enhancedCountBox(
                            "Web Visit",
                            todayCounts!.websiteVisits,
                            LinearGradient(
                              colors: [Colors.greenAccent, Colors.tealAccent],
                            ),
                            Icons.travel_explore,
                            isDark,
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 8),

                  // ---------------- TOMORROW SECTION ----------------


                  Row(
                    children: [
                      Icon(Icons.calendar_today, color: Colors.blueAccent, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        "Tomorrow",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blueAccent.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${weekNames[tomorrow.weekday - 1]}, ${tomorrow.day} ${monthNames[tomorrow.month - 1]}",
                          style: TextStyle(
                            color: Colors.blueAccent.shade200,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  if (tomorrowEvents.isNotEmpty) ...[

                    // Event CARD BOX
                    Column(
                      children: tomorrowEvents.take(3).map((event) =>
                          Container(
                            // margin: const EdgeInsets.only(bottom: 0),
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.grey.shade900 : Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blueAccent.withOpacity(0.15),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                // Time Box
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.blueAccent.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    event.time,
                                    style: TextStyle(
                                      color: Colors.blueAccent.shade200,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 12),

                                // Event TITLE
                                Expanded(
                                  child: Text(
                                    event.title,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),

                                // Type Dot
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: _getEventColor(event.type),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ).toList(),
                    ),

                    if (tomorrowEvents.length > 3)
                      Center(
                        child: Text(
                          "View ${tomorrowEvents.length - 3} more →",
                          style: TextStyle(
                            color: Colors.blueAccent.shade200,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                  ] else ...[
                    // NO EVENT UI
                    Text(
                      "No events scheduled",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ]

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Color _getEventColor(String eventType) {
    switch (eventType.toLowerCase()) {
      case 'agreement':
        return Colors.redAccent;
      case 'future':
        return Colors.blueAccent;
      case 'website':
        return Colors.greenAccent;
      default:
        return Colors.blueGrey;
    }
  }
  Widget _enhancedCountBox(String title, int count, Gradient gradient, IconData icon, bool isDark) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            // Icon with gradient background
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                gradient: gradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: gradient.colors.first.withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = gradient.createShader(
                    const Rect.fromLTWH(0, 0, 200, 100),
                  ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 10,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<TodayCounts> fetchTodayCounts() async {
    final now = DateTime.now();
    final today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final fieldNo = _fieldworkarnumber;

    final res = await Future.wait([
      http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_agreement_on_date.php?current_dates=$today&Fieldwarkarnumber=$fieldNo")),

      http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_building.php?current_date_=$today&fieldworkarnumber=$fieldNo")),

      http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_website_visit.php?dates=$today&field_workar_number=$fieldNo")),
    ]);

    try {
      todayAgreements = AgreementTaskResponse.fromRawJson(res[0].body).data;
    } catch (_) {
      todayAgreements = [];
    }

    try {
      todayFutureProperties = FuturePropertyResponse.fromRawJson(res[1].body).data;
    } catch (_) {
      todayFutureProperties = [];
    }

    try {
      todayWebsiteVisits = WebsiteVisitResponse.fromRawJson(res[2].body).data;
    } catch (_) {
      todayWebsiteVisits = [];
    }

    return TodayCounts(
      agreements: todayAgreements.length,
      futureProperties: todayFutureProperties.length,
      websiteVisits: todayWebsiteVisits.length,
    );
  }

  TodayCounts? todayCounts;
  bool todayLoading = true;

  Widget _buildTodayTile(bool isDark) {
    final today = DateTime.now();

    final monthNames = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];

    final formatted = "${today.day} ${monthNames[today.month - 1]}, ${today.year}";

    // Use your TodayCounts model here instead of agreements list
    int totalCount = todayCounts == null
        ? 0
        : todayCounts!.agreements +
        todayCounts!.futureProperties +
        todayCounts!.websiteVisits;

    return GestureDetector(
      onTap: () {
        // Open Calendar Page (CalendarTaskPage will handle _fetchData and _selectedDay)
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CalendarTaskPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black45 : Colors.black12,
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            // ⭕ Circle date icon
            Container(
              padding: const EdgeInsets.all(18),
              decoration: const BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
              child: Text(
                today.day.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 16),

            // 📅 Text info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatted,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Today’s Tasks: $totalCount",
                    style: const TextStyle(
                      color: Colors.indigo,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.indigo),
          ],
        ),
      ),
    );
  }
  Future<void> _refreshDashboard() async {
    // Reload today counts
    await fetchTodayCounts().then((value) {
      if (mounted) {
        setState(() {
          todayCounts = value;
          todayLoading = false;
        });
      }
    });

    // Reload stats
    await _loadStats();

    // Reload user data if required
    await loadUserName();
    await _loaduserdata();
  }

  Future<void> _loadStats() async {
    try {
      final rentData = await fetchData();
      final futureData = await fetchData_Logg();
      final agreementData = await fetchData_aggrement();
      if (mounted) {
        setState(() {
          rentPropertiesCount = rentData.isNotEmpty ? rentData.first.id : 0;
          futurePropertiesCount = futureData.length;
          agreementCount = agreementData.isNotEmpty ? agreementData.first.id : 0;
        });
      }
    } catch (e) {
    }
  }

  double? _latitude;
  double? _longitude;

  Future<void> _saveLocationToPrefs(double latitude, double longitude) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('latitude', latitude);
    await prefs.setDouble('longitude', longitude);
  }

  Future<void> _requestLocationPermissionAndGetLocation() async {
    final status = await Permission.location.request();

    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (mounted) {
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          print("Latitude: ${position.latitude}");
          print("Longitude: ${position.longitude}");
        });
      }
      await _saveLocationToPrefs(_latitude!, _longitude!);
    } else if (status.isDenied) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Permission Required"),
          content: const Text("Location permission is required to proceed."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await Permission.location.request();
              },
              child: const Text("Allow"),
            ),
          ],
        ),
      );
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<List<Catid>> fetchData() async {
    formattedDate = "${now.month}/${now.year}";
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/count_rent_proerty?feildworkar_number=$_fieldworkarnumber&random_text=${formattedDate.toString()}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(_fieldworkarnumber.toString());
      print(formattedDate.toString());
      List listresponse = json.decode(response.body);
      return listresponse.map((data) => Catid.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid1122>> fetchData_Logg() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=$_fieldworkarnumber");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listresponse = json.decode(response.body);
      listresponse.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponse.map((data) => Catid1122.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData_aggrement() async {
    formattedDate = "${now.month}/${now.year}";
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/count_police_verification_rent_target_by_fnumber_random_text?feildworkar_number=$_fieldworkarnumber&random_text=${formattedDate.toString()}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print(_fieldworkarnumber.toString());
      print(formattedDate.toString());
      List listresponse = json.decode(response.body);
      return listresponse.map((data) => Catid.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');

    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
      });
    }
  }

  Future<void> _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _fieldworkarnumber = prefs.getString('number') ?? '';
      _fieldworkarname = prefs.getString('name') ?? '';
    });

    // 🔥 Now call API — number is READY
    fetchTodayCounts().then((value) {
      if (mounted) {
        setState(() {
          todayCounts = value;
          todayLoading = false;
        });
      }
    });
  }

  Widget buildSmallAgreementCard(AgreementTask a, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 16),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.agreementType ?? "Agreement",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a.ownerName ?? "",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSmallFuturePropertyCard(FutureProperty f, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.home_work, color: Colors.blue, size: 16),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.propertyName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "${f.place} • ${f.buyRent}",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSmallWebsiteVisitCard(WebsiteVisit w, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.language, color: Colors.green, size: 16),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  w.name ?? "Website Visit",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  w.contactNo ?? "",
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    // Responsive values
    final horizontalPadding = isTablet ? 32.0 : 20.0;
    final verticalSpacing = isTablet ? 16.0 : 12.0;
    final cardAspectRatio = screenWidth < 400 ? 1.2 : 1.0; // Slightly taller for premium feel
    final gridCrossAxisCount = isTablet ? 3 : 2; // Responsive grid columns

    // Premium theme: Enhanced gradients, shadows, and colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryGradient = LinearGradient(
      colors: [Colors.purple.shade700, Colors.indigo.shade800, Colors.blue.shade900],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Different gradients for each card
    final List<LinearGradient> cardGradients = [
      LinearGradient(colors: [Colors.blue.shade600, Colors.blue.shade900]),
      LinearGradient(colors: [Colors.green.shade600, Colors.green.shade900]),
      LinearGradient(colors: [Colors.orange.shade900, Colors.orange.shade900]),
      LinearGradient(colors: [Colors.purple.shade900, Colors.purple.shade600]),
      LinearGradient(colors: [Colors.red.shade900, Colors.red.shade900]),
      LinearGradient(colors: [Colors.teal.shade600, Colors.indigo.shade300]),
      LinearGradient(colors: [Colors.indigo.shade600, Colors.indigo.shade900]),
      LinearGradient(colors: [Colors.blueAccent, Colors.blueAccent]),
      LinearGradient(colors: [Colors.grey.shade600, Colors.grey.shade600]),
    ];

    final List<Map<String, dynamic>> cardData = [
      {
        "image": AppImages.verify_Property,
        "title": "Live Property",
        "onTap": () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const LiveTabbar())),
        "gradient": cardGradients[0],
      },
      {
        "image": AppImages.documents,
        "title": "Verification",
        "onTap": () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ShowProperty())),

        "gradient": cardGradients[1],
      },
      {
        "image": AppImages.futureProperty,
        "title": "Future Property",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const FrontPage_FutureProperty(),
          ),
        ),
        "gradient": cardGradients[2],
      },
      {
        "image": AppImages.tenant,
        "title": "Tenant Demands",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const MainPage_TenandDemand()));
        },
        "gradient": cardGradients[3],
      },
      {
        "image": AppImages.agreement,
        "title": "Property Agreement",
        "onTap": () => Navigator.push(context, MaterialPageRoute(
            builder: (context) => const HistoryTab()
        )),
        "gradient": cardGradients[4],
      },
      {
        "image": AppImages.police,
        "title": "All Rented Flat",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const AddRentedFlatTabbar()));
        },
        "gradient": cardGradients[5],
      },
      {
        "image": AppImages.target,
        "title": "Target",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const Target_MainPage()));
        },
        "gradient": cardGradients[6],
      },
      {
        "image": AppImages.realestatefeild,
        "title": "Upcoming Flats",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const ParentUpcoming()));
        },
        "gradient": cardGradients[7],
      },
      {
        "image": AppImages.calendar,
        "title": "Task Calendar",
        "onTap": () {
          Navigator.push(
              context, MaterialPageRoute(
              builder: (_) => const CalendarTaskPage()));
        },
        "gradient": cardGradients[8],

      },

      {
        "image": AppImages.demand_2,
        "title": "Costumer Demands 2.O",
        "onTap": () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CostumerDemand()),
        ),
        "gradient": LinearGradient(
          colors: [Colors.purple, Colors.blue,],
        ),
      },


    ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Top Header without curve - straight container with gradient
          SizedBox(
            height: 150,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(gradient: primaryGradient),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(horizontalPadding, 0, horizontalPadding, 8),
                  child: Column(
                    children: [

                      // Top Row: Profile, Logo with premium styling
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Enhanced Profile with glow effect
                            Hero(
                              tag: 'profile',
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    AppImages.man,
                                    height: 30,
                                    // color: Colors.white,
                                    // Tint if needed; remove if image is already white
                                  ),
                                ),
                              ),
                            ),
                            // Premium Logo with subtle animation
                            Expanded(
                              child: Center(
                                child: TweenAnimationBuilder<double>(
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  duration: const Duration(milliseconds: 1000),
                                  builder: (context, value, child) {
                                    return Transform.scale(
                                      scale: value,
                                      child: Opacity(
                                        opacity: value,
                                        child: Image.asset(AppImages.transparent, height: 40),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            // Notification icon on right for balance and premium touch
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.2),
                                    blurRadius: 20,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: IconButton(
                                onPressed: (){
                                  Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) => LinksPage()));
                                },
                                icon: Image.asset(
                                  AppImages.browser,
                                  height: 30,
                                  //color: Colors.white, // Tint if needed; remove if image is already white
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Dashboard Section with 16 padding - Now in Expanded for scrolling grid
          Expanded(
            child: RefreshIndicator(
              color: Colors.blueAccent,
              strokeWidth: 2.5,
              backgroundColor: Theme.of(context).cardColor,
              onRefresh: _refreshDashboard,
              child: Scrollbar(
                thumbVisibility: true,
                radius: const Radius.circular(20),
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [

                    // TODAY CARD (scrollable)
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: _todayCard(isDark),
                      ),
                    ),

                    // GRID CARDS (scrollable)
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverGrid(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCrossAxisCount,
                          crossAxisSpacing: verticalSpacing,
                          mainAxisSpacing: verticalSpacing,
                          childAspectRatio: cardAspectRatio,
                        ),
                        delegate: SliverChildBuilderDelegate(
                              (context, index) {
                            final item = cardData[index];

                            return AnimationConfiguration.staggeredGrid(
                              position: index,
                              duration: const Duration(milliseconds: 600),
                              columnCount: gridCrossAxisCount,
                              child: ScaleAnimation(
                                scale: 0.8,
                                child: FadeInAnimation(
                                  child: SlideAnimation(
                                    horizontalOffset: 30.0,
                                    child: _PremiumDashboardCard(
                                      image: item["image"],
                                      title: item["title"],
                                      onTap: item["onTap"],
                                      gradient: item["gradient"],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          childCount: cardData.length,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _PremiumStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Gradient gradient;

  const _PremiumStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Wrap Icon in Container for shadow effect
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 9, // Slightly reduced font size for longer labels
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumDashboardCard extends StatefulWidget {
  final String image;
  final String title;
  final VoidCallback onTap;
  final Gradient gradient;

  const _PremiumDashboardCard({
    required this.image,
    required this.title,
    required this.onTap,
    required this.gradient,
  });

  @override
  _PremiumDashboardCardState createState() => _PremiumDashboardCardState();
}

class _PremiumDashboardCardState extends State<_PremiumDashboardCard> {
  bool _isPressed = false;


  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);
    final accentColor = widget.gradient.colors.first;
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.96 : 1.0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: widget.gradient.colors.map((c) => c.withOpacity(0.40)).toList(),
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 6),
                spreadRadius: 0,
              ),
              if (_isPressed)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
            ],
            border: Border.all(
              color: accentColor.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              splashColor: accentColor.withOpacity(0.2),
              highlightColor: Colors.white.withOpacity(0.1),
              onTap: widget.onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Enhanced Image Container with glow
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.gradient.colors.map((c) => c.withOpacity(0.2)).toList(),
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: accentColor.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Image.asset(
                          widget.image,
                          fit: BoxFit.contain,
                          width: 42,
                          height: 42,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Premium Title with better typography
                    Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 12,
                        letterSpacing: 0.3,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

}