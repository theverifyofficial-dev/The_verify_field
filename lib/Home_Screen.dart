import 'dart:async';
import 'dart:convert';
import 'dart:math';
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
import 'package:verify_feild_worker/Administrator/SubAdmin/ShowTenantDemant.dart';
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Add_commercial_property.dart';
import 'package:verify_feild_worker/Home_Screen_click/live_tabbar.dart';
import 'package:verify_feild_worker/Monthly_Target.dart';
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
import 'Propert_verigication_Document/Show_tenant.dart';
import 'Rent Agreement/Dashboard_screen.dart';
import 'Rent Agreement/history_tab.dart';
import 'Social_Media_links.dart';
import 'Tenant_Details_Demand/MainPage_Tenantdemand_Portal.dart';
import 'Web_query/web_query.dart' hide SlideAnimation, ScaleAnimation;
import 'Yearly_Target.dart';
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

// Dummy classes for JSON parsing - replace with actual if available
class AgreementTask {
  final String? agreementType;
  final String? ownerName;

  AgreementTask({this.agreementType, this.ownerName});
}

class FutureProperty {
  final String propertyName;
  final String place;
  final String buyRent;

  FutureProperty({required this.propertyName, required this.place, required this.buyRent});
}

class WebsiteVisit {
  final String? name;
  final String? contactNo;

  WebsiteVisit({this.name, this.contactNo});
}

class AgreementTaskResponse {
  final List<AgreementTask> data;

  AgreementTaskResponse({required this.data});

  factory AgreementTaskResponse.fromRawJson(String str) {
    final jsonData = json.decode(str);
    List<AgreementTask> dataList = [];
    if (jsonData is List) {
      dataList = jsonData.map((i) => AgreementTask()).toList();
    }
    return AgreementTaskResponse(data: dataList);
  }
}

class FuturePropertyResponse {
  final List<FutureProperty> data;

  FuturePropertyResponse({required this.data});

  factory FuturePropertyResponse.fromRawJson(String str) {
    final jsonData = json.decode(str);
    List<FutureProperty> dataList = [];
    if (jsonData is List) {
      dataList = jsonData.map((i) => FutureProperty(
        propertyName: i['propertyName'] ?? '',
        place: i['place'] ?? '',
        buyRent: i['buyRent'] ?? '',
      )).toList();
    }
    return FuturePropertyResponse(data: dataList);
  }
}

class WebsiteVisitResponse {
  final List<WebsiteVisit> data;

  WebsiteVisitResponse({required this.data});

  factory WebsiteVisitResponse.fromRawJson(String str) {
    final jsonData = json.decode(str);
    List<WebsiteVisit> dataList = [];
    if (jsonData is List) {
      dataList = jsonData.map((i) => WebsiteVisit()).toList();
    }
    return WebsiteVisitResponse(data: dataList);
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

  String number = '';

  String? userName;
  String? userNumber;

  int rentPropertiesCount = 0;
  int futurePropertiesCount = 0;
  int agreementCount = 0;
  int targetCount = 85; // Example target percentage

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int monthlyAchieved = 0;
  int yearlyAchieved = 0;
  static const int monthlyTarget = 15;
  static const int yearlyTarget = 100;

  double? _latitude;
  double? _longitude;

  bool _isLoadingData = true; // Add loading indicator

  List<AgreementTask> todayAgreements = [];
  List<FutureProperty> todayFutureProperties = [];
  List<WebsiteVisit> todayWebsiteVisits = [];
  List<TomorrowEvent> tomorrowEvents = [];

  TodayCounts? todayCounts;
  bool todayLoading = true;

  @override
  void initState() {
    super.initState();
    formattedDate = "${now.month}/${now.year}";
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

    // Start animations
    _controller.forward();

    // Load user data and then fetch stats
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loaduserdata();
    await loadUserName();
    await _requestLocationPermissionAndGetLocation();

    // Now that number is loaded, fetch the data
    if (number.isNotEmpty) {
      try {
        await Future.wait([
          _fetchMonthly(),
          _fetchYearly(),
          _loadStats(),
          fetchTodayCounts(),
        ]);
        if (mounted) {
          setState(() {
            todayLoading = false;
            todayCounts = TodayCounts(agreements: todayAgreements.length, futureProperties: todayFutureProperties.length, websiteVisits: todayWebsiteVisits.length);
          });
        }
      } catch (e) {
        debugPrint('Error in _initializeData: $e');
        if (mounted) {
          setState(() {
            todayLoading = false;
            todayCounts = TodayCounts(agreements: 0, futureProperties: 0, websiteVisits: 0);
          });
        }
        // Optional: Show toast
        Fluttertoast.showToast(msg: 'Data load error: $e', toastLength: Toast.LENGTH_SHORT);
      }
    } else {
      debugPrint('Number is empty, cannot fetch targets');
      if (mounted) {
        setState(() {
          todayLoading = false;
          todayCounts = TodayCounts(agreements: 0, futureProperties: 0, websiteVisits: 0);
        });
      }
    }

    if (mounted) {
      setState(() {
        _isLoadingData = false;
      });
    }
  }

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

  Future<TodayCounts> fetchTodayCounts() async {
    final now = DateTime.now();
    final today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final fieldNo = number;

    try {
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
    } catch (e) {
      debugPrint('Error in fetchTodayCounts: $e');
      return TodayCounts(agreements: 0, futureProperties: 0, websiteVisits: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
      debugPrint('Error loading stats: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Stats load error: $e')),
        );
      }
    }
  }

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
          debugPrint("Latitude: ${position.latitude}");
          debugPrint("Longitude: ${position.longitude}");
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
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/count_rent_proerty?feildworkar_number=$number&random_text=${formattedDate.toString()}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      debugPrint(number.toString());
      debugPrint(formattedDate.toString());
      List listresponse = json.decode(response.body);
      return listresponse.map((data) => Catid.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid1122>> fetchData_Logg() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=$number");
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
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/count_police_verification_rent_target_by_fnumber_random_text?feildworkar_number=$number&random_text=${formattedDate.toString()}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      debugPrint(number.toString());
      debugPrint(formattedDate.toString());
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

    if (mounted) {
      setState(() {
        number = prefs.getString('number') ?? '';
        debugPrint('Loaded number: $number'); // Debug print
      });
    }
  }

  Future<void> _fetchMonthly() async {
    try {
      if (number.isEmpty) {
        debugPrint('Number is empty, skipping monthly fetch');
        return;
      }
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_live_flat_for_field.php?field_workar_number=$number',
      );
      final res = await http.get(uri).timeout(const Duration(seconds: 8));
      debugPrint('Monthly API Response Status: ${res.statusCode}');
      debugPrint('Monthly API Response Body: ${res.body}'); // Debug the response
      if (res.statusCode != 200) throw Exception('HTTP ${res.statusCode}');
      final root = jsonDecode(res.body);
      final data = root['data'] as Map?;
      final count = (data?['total_live_rent_flat'] as num?)?.toInt() ?? 0;
      debugPrint('Monthly achieved: $count'); // Debug print
      if (mounted) setState(() { monthlyAchieved = count; });
    } catch (e) {
      debugPrint('Monthly fetch error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Monthly data error: $e')),
        );
      }
    }
  }

  Future<void> _fetchYearly() async {
    try {
      if (number.isEmpty) {
        debugPrint('Number is empty, skipping yearly fetch');
        return;
      }
      final uri = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Target/count_live_flat_rent_yearly.php?field_workar_number=$number',
      );
      final resp = await http.get(uri);
      debugPrint('Yearly API Response Status: ${resp.statusCode}');
      debugPrint('Yearly API Response Body: ${resp.body}'); // Debug the response
      if (resp.statusCode != 200) throw Exception('HTTP ${resp.statusCode}');
      final root = json.decode(resp.body) as Map<String, dynamic>;
      if (root['success'] != true) throw Exception('API returned success=false');
      final d = (root['data'] as Map?) ?? const {};
      final achieved = (d['total_live_rent_flat'] as num?)?.toInt() ?? 0;
      debugPrint('Yearly achieved: $achieved'); // Debug print
      if (mounted) setState(() { yearlyAchieved = achieved; });
    } catch (e) {
      debugPrint('Yearly fetch error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Yearly data error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final monthlyProgress = (monthlyAchieved / monthlyTarget).clamp(0.0, 1.0);
    final yearlyProgress = (yearlyAchieved / yearlyTarget).clamp(0.0, 1.0);
    final isTablet = screenWidth > 600;

    // Dynamic expanded height to prevent overflow on small screens
    final expandedHeight = (screenHeight * 0.28).clamp(220.0, 350.0);

    // Get current theme
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Dynamic colors based on theme for text
    final Color welcomeTextColor = isDark ? Colors.white : Colors.black87;
    final Color scaffoldBackground = isDark ? Color(0xFF0F172A) : Color(0xFFF3F4F6);

    // Enhanced gradients
    final primaryGradient = LinearGradient(
      colors: [Colors.purple.shade700, Colors.indigo.shade800, Colors.blue.shade900],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // Card gradients with premium colors
    final List<LinearGradient> cardGradients = [
      LinearGradient(colors: [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)]),
      LinearGradient(colors: [const Color(0xFF10B981), const Color(0xFF047857)]),
      LinearGradient(colors: [const Color(0xFFF59E0B), const Color(0xFFDC2626)]),
      LinearGradient(colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)]),
      LinearGradient(colors: [const Color(0xFFEF4444), const Color(0xFFDC2626)]),
      LinearGradient(colors: [const Color(0xFF06B6D4), const Color(0xFF0891B2)]),
      LinearGradient(colors: [const Color(0xFF6366F1), const Color(0xFF4F46E5)]),
      LinearGradient(colors: [const Color(0xFF1D4ED8), const Color(0xFFDC2626)]),
      LinearGradient(colors: [const Color(0xFFDC2626), const Color(0xFF06B6D4)]),
      LinearGradient(colors: [const Color(0xFF06B6D4), const Color(0xFFF59E0B)]),
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
        "image": AppImages.tenant,
        "title": "Verification",
        "onTap": () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const ShowTenantDemandPage())),
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
        "image": AppImages.demand_2,
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
      }, {
        "image": AppImages.calendar,
        "title": "Task Calendar",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CalendarTaskPage()));
        },
        "gradient": cardGradients[8],
      }, {
        "image": AppImages.demand_2,
        "title": "Costumer Demands 2.O",
        "onTap": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CostumerDemand()));
        },
        "gradient": cardGradients[9],
      },
    ];

    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: _isLoadingData
          ? const Center(child: CircularProgressIndicator()) // Show loading while data fetches
          : CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Curved Silver App Bar with Dual Target Indicators
          SliverAppBar(
            expandedHeight: expandedHeight,
            collapsedHeight: (screenHeight * 0.1).clamp(60.0, 80.0),
            floating: true,
            pinned: true,
            snap: false,
            elevation: 10,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: Container(
                decoration: BoxDecoration(
                  gradient: primaryGradient,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                ),
                child: SafeArea(
                  bottom: true,
                  child: Column(
                    children: [
                      // App Bar Section
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.010),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfilePage()));
                              },
                              icon: Image.asset(
                                AppImages.man,
                                height: (screenWidth * 0.1).clamp(28.0, 40.0),
                              ),
                            ),
                            // App Logo
                            Container(
                              padding: EdgeInsets.all(screenWidth * 0.03),
                              decoration: BoxDecoration(
                              ),
                              child: Image.asset(AppImages.transparent,
                                  height: (screenWidth * 0.1).clamp(32.0, 45.0)),
                            ),

                            // Social Links
                            IconButton(
                              onPressed: (){
                                Navigator.push(
                                    context, MaterialPageRoute(
                                    builder: (context) => LinksPage()));
                              },
                              icon: Image.asset(
                                AppImages.browser,
                                height: (screenWidth * 0.09).clamp(25.0, 35.0),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: screenHeight * 0.02),
                      // Dual Target Progress Indicators - Use Wrap for responsiveness
                      Expanded(
                        child: Wrap(
                          spacing: screenWidth * 0.15,
                          runSpacing: screenHeight * 0.1,
                          alignment: WrapAlignment.spaceEvenly,
                          children: [
                            _TargetProgressCircle(
                              progress: monthlyProgress,
                              percentage: '${(monthlyProgress * 100).toInt()}%',
                              title: 'Monthly Target',
                              icon: Icons.track_changes_rounded,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Target_Monthly()),
                                );
                              },
                            ),
                            _TargetProgressCircle(
                              progress: yearlyProgress,
                              percentage: '${(yearlyProgress * 100).toInt()}%',
                              title: 'Yearly Target',
                              icon: Icons.calendar_today_rounded,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const Target_Yearly()),
                                );
                              },
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

          // Dashboard Grid Section
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Today's Card (replacing welcome back)
                  _todayCard(isDark),
                  const SizedBox(height: 16),
                  // Feature Grid
                  GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 3 : 2,
                      crossAxisSpacing: screenWidth * 0.04,
                      mainAxisSpacing: screenWidth * 0.04,
                      childAspectRatio: isTablet ? 1.0 : 0.95, // Slightly adjust for smaller screens
                    ),
                    itemCount: cardData.length,
                    itemBuilder: (context, index) {
                      final item = cardData[index];

                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 600),
                        columnCount: isTablet ? 3 : 2,
                        child: ScaleAnimation(
                          scale: 0.9,
                          child: FadeInAnimation(
                            child: _PremiumFeatureCard(
                              title: item["title"],
                              gradient: item["gradient"],
                              imagePath: item["image"],
                              onTap: item["onTap"],
                              screenWidth: screenWidth, // Pass for dynamic sizing
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCircle extends StatelessWidget {
  final Widget child;

  const _GlassCircle({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TargetProgressCircle extends StatefulWidget {
  final double progress;
  final String percentage;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _TargetProgressCircle({
    required this.progress,
    required this.percentage,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_TargetProgressCircle> createState() => _TargetProgressCircleState();
}

class _TargetProgressCircleState extends State<_TargetProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Enhanced dynamic sizing for premium feel
    final double baseSize = screenWidth < 360 ? 70.0 : screenWidth < 500 ? 85.0 : 100.0;
    final double iconSize = baseSize * 0.22;
    final double textSize = baseSize * 0.18;
    final double titleSize = (screenWidth * 0.032).clamp(11.0, 13.0);

    // Premium gradient for progress ring
    final progressGradient = LinearGradient(
      colors: [
        Colors.cyan.shade300.withOpacity(0.8),
        Colors.purple.shade400.withOpacity(0.8),
        Colors.indigo.shade300.withOpacity(0.8),
      ],
      stops: const [0.0, 0.5, 1.0],
    );

    return Flexible(
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(baseSize * 0.08), // Added padding for premium spacing
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withOpacity(0.1),
                          Colors.transparent,
                        ],
                        center: Alignment.center,
                        radius: 1.2,
                      ),
                      boxShadow: [
                        // Multi-layer shadows for depth
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: -2,
                          offset: const Offset(0, 4),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.05),
                          blurRadius: 20,
                          spreadRadius: 2,
                          offset: const Offset(0, -4),
                        ),
                      ],
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer glow ring
                        Container(
                          width: baseSize + 10,
                          height: baseSize + 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyan.shade100.withOpacity(0.3),
                                Colors.purple.shade200.withOpacity(0.3),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: progressGradient.colors.first.withOpacity(0.4),
                                blurRadius: baseSize * 0.2,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // Main progress container
                        Container(
                          width: baseSize,
                          height: baseSize,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Colors.white.withOpacity(0.2),
                                Colors.white.withOpacity(0.05),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.25),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background progress ring (thin)
                                SizedBox(
                                  width: baseSize - 8,
                                  height: baseSize - 8,
                                  child: CircularProgressIndicator(
                                    value: 1.0,
                                    strokeWidth: baseSize * 0.05,
                                    backgroundColor: Colors.white.withOpacity(0.15),
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                // Foreground progress ring with gradient sweep
                                SizedBox(
                                  width: baseSize - 8,
                                  height: baseSize - 8,
                                  child: CustomPaint(
                                    painter: _ProgressPainter(
                                      progress: widget.progress,
                                      strokeWidth: baseSize * 0.08,
                                      gradient: progressGradient,
                                    ),
                                  ),
                                ),
                                // Inner content with glassmorphism
                                Container(
                                  width: baseSize * 0.75,
                                  height: baseSize * 0.75,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.1),
                                        Colors.white.withOpacity(0.05),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 4,
                                        offset: const Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        widget.icon,
                                        color: Colors.white.withOpacity(0.9),
                                        size: iconSize,
                                        shadows: [
                                          Shadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 2,
                                            offset: const Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: baseSize * 0.04),
                                      FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          widget.percentage,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: textSize,
                                            fontWeight: FontWeight.bold,
                                            shadows: [
                                              Shadow(
                                                color: Colors.black.withOpacity(0.3),
                                                blurRadius: 2,
                                                offset: const Offset(0, 1),
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
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  // Enhanced title with gradient text effect
                  ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      colors: [Colors.white.withOpacity(0.95), Colors.white.withOpacity(0.8)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ).createShader(bounds),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: titleSize,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 2,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// Custom painter for gradient progress arc
class _ProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Gradient gradient;

  _ProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _PremiumFeatureCard extends StatefulWidget {
  final String title;
  final Gradient gradient;
  final String imagePath;
  final VoidCallback onTap;
  final double screenWidth; // Added for dynamic sizing

  const _PremiumFeatureCard({
    required this.title,
    required this.gradient,
    required this.imagePath,
    required this.onTap,
    required this.screenWidth,
  });

  @override
  _PremiumFeatureCardState createState() => _PremiumFeatureCardState();
}

class _PremiumFeatureCardState extends State<_PremiumFeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final imageSize = (widget.screenWidth * 0.12).clamp(40.0, 55.0);
    final patternSize = (widget.screenWidth * 0.18).clamp(60.0, 80.0);
    final paddingSize = (widget.screenWidth * 0.04).clamp(12.0, 18.0);
    final titleFontSize = (widget.screenWidth * 0.035).clamp(11.0, 15.0);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()
            ..scale(_isHovered ? 1.05 : 1.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: widget.gradient,
            boxShadow: [
              BoxShadow(
                color: widget.gradient.colors.first.withOpacity(0.3),
                blurRadius: _isHovered ? 25 : 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background pattern - dynamic size
              Positioned(
                right: -patternSize * 0.2,
                bottom: -patternSize * 0.2,
                child: Container(
                  width: patternSize,
                  height: patternSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: EdgeInsets.all(paddingSize),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with background
                    Container(
                      padding: EdgeInsets.all(paddingSize * 0.6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        widget.imagePath,
                        height: imageSize,
                      ),
                    ),

                    SizedBox(height: paddingSize),

                    // Title - wrapped for overflow
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.3,
                            height: 1.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
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
    );
  }
}