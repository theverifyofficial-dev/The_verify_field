import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/realestateSlider.dart';
import '../../Custom_Widget/Swipe_preview.dart';
import '../../Custom_Widget/property_preview.dart';
import 'Edit_flat.dart';
import 'add_image_under_futureproperty.dart'; // Note: Fix filename if 'Futureproipoerty' is a typo
import 'add_tenant_infutureproperty.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Property {
  final int pId;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeofProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squarefit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldworkarAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWarkarName;
  final String liveUnlive;
  final String demoLiveUnlive;
  final String fieldWorkarNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String subid;

  Property({
    required this.pId,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeofProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squarefit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkarAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWarkarName,
    required this.liveUnlive,
    required this.demoLiveUnlive,
    required this.fieldWorkarNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      pId: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeofProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldworkarAddress: json['fieldworkar_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDates: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      fieldWarkarName: json['field_warkar_name'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      demoLiveUnlive: json['demo_live_unlive'] ?? '',
      fieldWorkarNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerCurrentLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      subid: json['subid']?.toString() ?? '',
    );
  }
}

class Catid1 {
  final String id;
  final String tenant_name;
  final String tenant_phone_number;
  final String flat_rent;
  final String shifting_date;
  final String members;
  final String email;
  final String tenant_vichal_details;
  final String work_profile;
  final String bhk;
  final String type_of_property;
  final String payment_mode;
  final String status;
  final String sub_id;

  Catid1({
    required this.id,
    required this.tenant_name,
    required this.tenant_phone_number,
    required this.flat_rent,
    required this.shifting_date,
    required this.members,
    required this.email,
    required this.tenant_vichal_details,
    required this.work_profile,
    required this.bhk,
    required this.type_of_property,
    required this.payment_mode,
    required this.status,
    required this.sub_id,
  });

  factory Catid1.fromJson(Map<String, dynamic> json) {
    return Catid1(
      id: json['id'].toString(),
      tenant_name: json['tenant_name']?.toString() ?? '',
      tenant_phone_number: json['tenant_phone_number']?.toString() ?? '',
      flat_rent: json['flat_rent']?.toString() ?? '',
      shifting_date: json['shifting_date']?.toString() ?? '',
      members: json['members']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      tenant_vichal_details: json['tenant_vichal_details']?.toString() ?? '',
      work_profile: json['work_profile']?.toString() ?? '',
      bhk: json['bhk']?.toString() ?? '',
      type_of_property: json['type_of_property']?.toString() ?? '',
      payment_mode: json['payment_mode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      sub_id: json['sub_id'].toString(),
    );
  }
}

// ✅ Widget ab Stateful hai – har flat ka apna controller instance hoga
class underflat_futureproperty extends StatefulWidget {
  final String id;
  final String Subid;

  const underflat_futureproperty({
    super.key,
    required this.id,
    required this.Subid,
  });

  @override
  State<underflat_futureproperty> createState() =>
      _underflat_futurepropertyState();
}

class _underflat_futurepropertyState extends State<underflat_futureproperty> {
  // Section quick-jump anchors (tap a chip in the jump bar to scroll here).
  final GlobalKey _pricingSectionKey = GlobalKey();
  final GlobalKey _facilitySectionKey = GlobalKey();
  final GlobalKey _additionalSectionKey = GlobalKey();
  final GlobalKey _tenantSectionKey = GlobalKey();

  void _jumpTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.05);
    }
  }

  bool isMainLoading = false;
  bool isUpcomingLoading = false;
  Property? property;
  String estateStatus = 'Book'; // Default
  String upcomingStatus = 'Book'; // Default
  late Future<List<RealEstateSlider1>> sliderFuture;
  late Future<List<Property>> propertyFuture;
  late Future<List<Catid1>> catidFuture;
  String userRole = '';
  bool isFieldWorker = false;
  final List<String> furnitureItems = [
    'Fan',
    'Light',
    'Refrigerator',
    'Washing Machine',
    'Wardrobe',
    'AC',
    'Water Purifier',
    'Modular Kitchen',
    'Chimney',
    'Single Bed',
    'Double Bed',
    'Geyser',
    'Led Tv',
    'Sofa Set',
    'Dining Table',
    'Induction',
    'Gas Stove',
  ];

  @override
  void initState() {
    super.initState();
    loadProperty();
    loadAllData();
    fetchData1();
    fetchData1Status();
    _loadUserRole();

  }

  int countdown = 0;

  IconData _getFurnitureIcon(String item) {
    final name = item.trim().toLowerCase();

    switch (name) {
      case 'fan':
        return Icons.air;

      case 'light':
        return Icons.lightbulb_outline;

      case 'refrigerator':
        return Icons.kitchen;

      case 'washing machine':
        return Icons.local_laundry_service;

      case 'wardrobe':
        return Icons.door_sliding_outlined;

      case 'ac':
        return Icons.ac_unit;

      case 'water purifier':
        return Icons.water_drop_outlined;

      case 'modular kitchen':
        return Icons.countertops_outlined;

      case 'chimney':
        return Icons.air;

      case 'single bed':
        return Icons.bed_outlined;

      case 'double bed':
        return Icons.bed;

      case 'geyser':
        return Icons.hot_tub_outlined;

      case 'led tv':
        return Icons.tv;

      case 'sofa set':
        return Icons.weekend_outlined;

      case 'dining table':
        return Icons.table_restaurant_outlined;

      case 'induction':
        return Icons.local_fire_department_outlined;

      case 'gas stove':
        return Icons.local_fire_department;

      default:
        return Icons.inventory_2_outlined;
    }
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();

    final role = prefs.getString('post') ?? '';

    if (!mounted) return;

    setState(() {
      userRole = role.trim().toLowerCase();

      isFieldWorker =
          userRole == 'fieldworkar' ||
              userRole == 'fieldworker' ||
              userRole == 'field worker' ||
              userRole == 'field_worker';
    });

    debugPrint('USER ROLE: $userRole');
    debugPrint('IS FIELD WORKER: $isFieldWorker');
  }

  Future<List<RealEstateSlider1>> fetchCarouselData() async {
    final response = await http.get(Uri.parse(
        'https://verifyrealestateandservices.in/WebService4.asmx/display_flat_in_future_property_multiple_images?subid=${widget.id}'));
    print(" Multi Image ID: ${widget.id}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return RealEstateSlider1(
          rimg: item['images'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Property>> fetchData() async {
    var url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/detail_page_for_future_property_under_flat.php?P_id=${widget.id}");

    final response = await http.get(url).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['status'] == 'success' && decoded['data'] != null) {
        List<dynamic> list = decoded['data'];
        return list.map((e) => Property.fromJson(e)).toList();
      } else {
        throw Exception('No data found');
      }
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  Future<List<Catid1>> fetchData1() async {
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/PHP_Files/add_tanant_in_future_property/show_api_add_tenant.php?sub_id=${widget.id}",
    );

    final response = await http.get(url).timeout(const Duration(seconds: 30));
    print('tenant data : ${response.body}');
    if (response.statusCode != 200) {
      throw Exception("Server error");
    }

    final decoded = json.decode(response.body);

    // ✅ STRICT MATCH WITH API
    if (decoded is Map &&
        decoded['status'] == 'success' &&
        decoded['data'] is List) {
      final List list = decoded['data'];
      return list.map((e) => Catid1.fromJson(e)).toList();
    }

    return [];
  }

  Future<void> fetchData1Status() async {
    try {
      final result = await fetchData();
      if (result.isEmpty) {
        setState(() {
          estateStatus = 'Book';
          upcomingStatus = 'Book';
        });
        return;
      }
      final propertyData = result.firstWhere(
        (item) => item.subid == widget.Subid,
        orElse: () => result.first,
      );

      setState(() {
        estateStatus =
            propertyData.liveUnlive.isEmpty ? 'Book' : propertyData.liveUnlive;
        upcomingStatus = propertyData.demoLiveUnlive.isEmpty
            ? 'Book'
            : propertyData.demoLiveUnlive;
      });
    } catch (e) {
      //AppLogger.log("Error fetching data: $e");
      setState(() {
        estateStatus = 'Book';
        upcomingStatus = 'Book';
      });
    }
  }

  Future<void> loadAllData() async {
    setState(() {
      sliderFuture = fetchCarouselData();
      propertyFuture = fetchData();
      catidFuture = fetchData1();
    });
  }

  Future<void> loadProperty() async {
    try {
      final list = await fetchData();
      if (list.isNotEmpty) {
        setState(() {
          property = list.first;
        });
      }
    } catch (e) {
      //AppLogger.log("Error loading property: $e");
    }
  }

  Future<void> refreshData() async {
    await loadAllData();
    await fetchData1Status();
    if (mounted) setState(() {});
  }

  Future<void> handleMenuItemClick(String value) async {
    try {
      if (value == 'Edit Flat') {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditFlat(id: widget.id)),
          );
        }
      }
      if (value == 'Add Flat Images') {
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => Futureproipoerty_FileUploadPage(
                    idd: widget.id)), // Fix: Rename class/file if typo
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigation error: $e')),
        );
      }
    }
  }

  Future<void> openWhatsApp(String number) async {
    try {
      String cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
      if (!cleanNumber.startsWith('91')) {
        cleanNumber = '91$cleanNumber';
      }

      final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$cleanNumber");
      final Uri whatsappWebUri = Uri.parse("https://wa.me/$cleanNumber");

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('WhatsApp is not installed')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error opening WhatsApp: ${e.toString()}')),
        );
      }
    }
  }

  void openWhatsAppAndroid(String phoneNumber) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final cleanNumber = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
      final intent = AndroidIntent(
        action: 'action_view',
        data: Uri.encodeFull('whatsapp://send?phone=$cleanNumber'),
        package: 'com.whatsapp',
      );
      intent.launch();
    } else {
      //AppLogger.log(
      //     'WhatsApp open only supported on Android with this method');
    }
  }

  Widget buildInfoRow(
      IconData icon, Color iconColor, String title, String value) {
    if (value.isEmpty || value == "null" || value == "0") {
      return const SizedBox.shrink();
    }

    final bool isDarkMode = false /* forced light theme */;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final Color cardColor = Colors.white;
    final Color borderColor = isDarkMode
        ? Colors.grey.shade700.withOpacity(0.2)
        : Colors.grey.shade200;
    final Color titleColor = isDarkMode ? Colors.black87 : Colors.grey.shade700;
    final Color valueColor = isDarkMode ? Colors.black87 : Colors.black87;
    final Color iconBg = iconColor.withOpacity(0.10);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.symmetric(
          horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: isDarkMode
            ? [
                const BoxShadow(
                    color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
              ]
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(6),
            ),
            child:
                Icon(icon, size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
          ),
          SizedBox(width: isSmallScreen ? 6.0 : 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 10.0 : 11.0,
                    fontWeight: FontWeight.w600,
                    color: titleColor,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 11.0 : 12.0,
                    fontWeight: FontWeight.w500,
                    color: valueColor,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildContactCard(String role, String name, String number,
      {Color? bgColor}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = false /* forced light theme */;
    Color cardColor = bgColor ?? Colors.blue;
    String maskedNumber = maskPhoneNumber(number);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: isSmallScreen ? 32.0 : 36.0,
                  height: isSmallScreen ? 32.0 : 36.0,
                  decoration: BoxDecoration(
                    color: cardColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    role == "OWNER"
                        ? Icons.person
                        : role == "CARETAKER"
                            ? Icons.support_agent
                            : role == "FIELD WORKER"
                                ? Icons.engineering
                                : role == "TENANT"
                                    ? Icons.people
                                    : Icons.person,
                    color: Colors.white,
                    size: isSmallScreen ? 16.0 : 18.0,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 10.0 : 11.0,
                          fontWeight: FontWeight.w600,
                          color: cardColor,
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                      Text(
                        name.isNotEmpty ? name : "Not Available",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13.0 : 14.0,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.black : Colors.black87,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: isSmallScreen ? 6.0 : 8.0),
            if (number.isNotEmpty)
              GestureDetector(
                onTap: () => showCallConfirmationDialog(role, name, number),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: cardColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          maskedNumber,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13.0 : 14.0,
                            fontWeight: FontWeight.w500,
                            color: cardColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => openWhatsApp(number),
                            child: Icon(PhosphorIcons.whatsappLogo(),
                                color: cardColor,
                                size: isSmallScreen ? 20.0 : 24.0),
                          ),
                          SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                          Icon(Icons.call,
                              color: cardColor,
                              size: isSmallScreen ? 20.0 : 24.0),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    "Not Available",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11.0 : 12.0,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildSimpleInfoCard(
      String title, String value, IconData icon, Color cardColor,
      {VoidCallback? onTap}) {
    if (value.isEmpty || value == "null" || value == "0") {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = false /* forced light theme */;

    final Widget card = Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 32.0 : 36.0,
              height: isSmallScreen ? 32.0 : 36.0,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: isSmallScreen ? 16.0 : 18.0,
              ),
            ),
            SizedBox(width: isSmallScreen ? 6.0 : 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 11.0,
                      fontWeight: FontWeight.w600,
                      color: cardColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13.0 : 14.0,
                      fontWeight: FontWeight.w500,
                      color: isDarkMode ? Colors.black : Colors.black87,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }

  Widget _buildAdaptiveRows(List<Widget> cards, double verticalPadding) {
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxWidth;
      final spacing = MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0;
      final runSpacing = verticalPadding;
      final int itemsPerRow = available >= 800
          ? 4
          : available >= 520
              ? 3
              : 2;
      final itemWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: cards.map((card) {
          final width = cards.length == 1 ? available : itemWidth;
          return SizedBox(width: width, child: card);
        }).toList(),
      );
    });
  }

  List<Widget> getBuildingFacilityRows(Property prop) {
    final List<Widget> items = [];

    // Parking
    if (prop.parking.trim().isNotEmpty &&
        prop.parking.trim().toLowerCase() != 'no') {
      items.add(
        _compactDetailItem(
          icon: Icons.local_parking,
          title: 'Parking',
          value: prop.parking,
          color: Colors.blue,
        ),
      );
    }

    // Lift
    if (prop.lift.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.elevator,
          title: 'Lift',
          value: prop.lift,
          color: Colors.red,
        ),
      );
    }

    // Nearest Metro / Metro Distance
    if (prop.metroDistance.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.train,
          title: 'Metro',
          value: prop.metroDistance,
          color: Colors.orange,
        ),
      );
    }

    // Market Distance
    if (prop.mainMarketDistance.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.storefront,
          title: 'Market',
          value: prop.mainMarketDistance,
          color: Colors.purple,
        ),
      );
    }

    // Road Size
    if (prop.roadSize.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.straighten,
          title: 'Road Size',
          value: prop.roadSize,
          color: Colors.teal,
        ),
      );
    }

    // Age
    if (prop.ageOfProperty.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.history,
          title: 'Age',
          value: prop.ageOfProperty,
          color: Colors.brown,
        ),
      );
    }

    // Main Building Facility
    if (prop.facility.trim().isNotEmpty) {
      items.add(
        _compactDetailItem2(
          icon: Icons.domain,
          title: 'Facility',
          value: prop.facility,
          color: Colors.green,
        ),
      );
    }

    return items;
  }

  List<Widget> getFlatFacilityRows(Property prop) {
    List<Widget> rows = [];
    if (prop.apartmentName.isNotEmpty) {
      rows.add(buildInfoRow(
          Icons.local_hospital, Colors.amber, "Flat Facility", prop.facility));
    }
    return rows;
  }

  Widget buildFieldworkerInfoCard(Property prop) {
    final name = prop.fieldWarkarName.trim();
    final number = prop.fieldWorkarNumber.trim();
    final address = prop.fieldworkarAddress.trim();
    final location = prop.fieldWorkerCurrentLocation.trim();

    if (name.isEmpty && number.isEmpty && address.isEmpty && location.isEmpty) {
      return const SizedBox.shrink();
    }

    final maskedNumber =
        number.isNotEmpty ? maskPhoneNumber(number) : 'Not Available';

    return _overviewSection(
      icon: Icons.engineering,
      iconColor: Colors.blue,
      title: 'Field Worker / Contact',
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 42,
              height: 42,
              decoration: const BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'F',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 9),

            // Name + role
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name.isNotEmpty ? name : 'Field Worker',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Field Worker',
                    style: TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),
                  if (number.isNotEmpty)
                    Text(
                      maskedNumber,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.black54,
                      ),
                    ),
                ],
              ),
            ),

            // WhatsApp
            if (number.isNotEmpty)
              _contactCircleButton(
                icon: PhosphorIcons.whatsappLogo(),
                color: Colors.green,
                onTap: () => openWhatsApp(number),
              ),

            const SizedBox(width: 6),

            // Call
            if (number.isNotEmpty)
              _contactCircleButton(
                icon: Icons.call,
                color: Colors.blue,
                onTap: () => showCallConfirmationDialog(
                  'FIELD WORKER',
                  name,
                  number,
                ),
              ),

            const SizedBox(width: 6),

            // Message / details
            _contactCircleButton(
              icon: Icons.chat,
              color: Colors.deepPurple,
              onTap: () {
                if (number.isNotEmpty) {
                  openWhatsApp(number);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactCircleButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 17,
        ),
      ),
    );
  }

  String formatDate(String date) {
    if (date.trim().isEmpty ||
        date.trim().toLowerCase() == 'null' ||
        date.trim() == '0') {
      return '';
    }

    try {
      final value = date.trim();

      DateTime? parsedDate;

      // Handles:
      // 2026-10-06
      // 2026-10-06 00:00:00
      // 2026-10-06T00:00:00
      parsedDate = DateTime.tryParse(value);

      // Handles dd-MM-yyyy
      if (parsedDate == null) {
        try {
          parsedDate = DateFormat('dd-MM-yyyy').parseStrict(value);
        } catch (_) {}
      }

      // Handles dd/MM/yyyy
      if (parsedDate == null) {
        try {
          parsedDate = DateFormat('dd/MM/yyyy').parseStrict(value);
        } catch (_) {}
      }

      if (parsedDate == null) {
        return date;
      }

      return DateFormat('dd MMM yyyy').format(parsedDate);
    } catch (_) {
      return date;
    }
  }

  void showCallConfirmationDialog(String role, String name, String number) {
    bool isDarkMode = false /* forced light theme */;

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call $role',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        content: Text(
            'Do you really want to call ${name.isNotEmpty ? name : role}?',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop(true);
              await FlutterPhoneDirectCaller.callNumber(number);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }

  String maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String firstPart = number.substring(0, 3);
    String lastPart = number.substring(number.length - 4);
    return '$firstPart****$lastPart';
  }

  Widget buildResponsiveInfoGrid(List<Widget> infoRows) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        if (screenWidth > 350) {
          final half = (infoRows.length / 2).ceil();
          final leftColumn = infoRows.sublist(0, half);
          final rightColumn =
              infoRows.length > half ? infoRows.sublist(half) : <Widget>[];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: leftColumn,
                ),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width < 360 ? 8.0 : 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: rightColumn,
                ),
              ),
            ],
          );
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: infoRows,
          );
        }
      },
    );
  }

  List<Widget> getPropertyDetailsRows(Property prop) {
    final List<Widget> items = [];

    // Type
    if (prop.typeofProperty.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.apartment,
          title: 'Type',
          value: prop.typeofProperty,
          color: Colors.blue,
        ),
      );
    }

    // Flat Number
    if (prop.flatNumber.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.format_list_numbered,
          title: 'Flat no.',
          value: prop.flatNumber,
          color: Colors.green,
        ),
      );
    }

    // BHK
    if (prop.bhk.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.king_bed,
          title: 'BHK',
          value: prop.bhk,
          color: Colors.indigo,
        ),
      );
    }

    // Meter
    if (prop.meter.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.electric_meter,
          title: 'Meter',
          value: prop.meter,
          color: Colors.blue,
        ),
      );
    }

    // Kitchen
    if (prop.kitchen.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.kitchen,
          title: 'Kitchen',
          value: prop.kitchen,
          color: Colors.orange,
        ),
      );
    }

    // Bathroom
    if (prop.bathroom.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.bathroom,
          title: 'Bathroom',
          value: prop.bathroom,
          color: Colors.cyan,
        ),
      );
    }

    // Balcony
    if (prop.balcony.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.balcony,
          title: 'Balcony',
          value: prop.balcony,
          color: Colors.pink,
        ),
      );
    }

    // Floor
    String floorText = '';

    if (prop.floor.trim().isNotEmpty) {
      floorText = prop.floor.trim();
    }

    if (floorText.isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.layers,
          title: 'Floor',
          value: floorText,
          color: Colors.green,
        ),
      );
    }

    // Square Feet
    if (prop.squarefit.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.square_foot,
          title: 'Area',
          value: '${prop.squarefit} Sq.Ft.',
          color: Colors.teal,
        ),
      );
    }

    // Available From
    if (prop.availableDate.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.calendar_month,
          title: 'Available From',
          value: prop.availableDate,
          color: Colors.blue,
        ),
      );
    }

    // Registry & GPA
    if (prop.registryAndGpa.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.description,
          title: 'Registry & GPA',
          value: prop.registryAndGpa,
          color: Colors.deepPurple,
        ),
      );
    }

    // Loan
    if (prop.loan.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.account_balance,
          title: 'Loan',
          value: prop.loan,
          color: Colors.deepPurple,
        ),
      );
    }

    // Residence / Commercial
    if (prop.residenceCommercial.trim().isNotEmpty) {
      items.add(
        _compactDetailItem2(
          icon: Icons.domain,
          title: 'Standard',
          value: prop.residenceCommercial,
          color: Colors.amber.shade800,
        ),
      );
    }

    return items;
  }

  Widget buildChip(
      IconData icon, String text, Color color, BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 6.0 : 8.0, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmallScreen ? 14.0 : 16.0, color: color),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSmallScreen ? 9.0 : 10.0,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis, // Fix: Consistent overflow
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFurnishedDetailsCard(Property prop) {
    final status = prop.furnishedUnfurnished.trim();

    if (status.isEmpty) {
      return const SizedBox.shrink();
    }

    final lowerStatus = status.toLowerCase();

    final bool isFully =
        lowerStatus.contains('full') && !lowerStatus.contains('semi');

    final bool isSemi = lowerStatus.contains('semi');

    final bool isUnfurnished = lowerStatus.contains('unfurnish');

    final Color statusColor = isFully
        ? Colors.green
        : isSemi
            ? Colors.green
            : isUnfurnished
                ? Colors.red
                : Colors.purple;

    final String statusLabel = isFully
        ? 'Fully Furnished'
        : isSemi
            ? 'Semi Furnished'
            : isUnfurnished
                ? 'Unfurnished'
                : status;


    final List<String> apartmentItems = [];

    if (isFully || isSemi) {
      apartmentItems.addAll(
        prop.apartmentName
            .split(',')
            .map((item) => item.trim())
            .where((item) => item.isNotEmpty),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: statusColor.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isUnfurnished ? Icons.cancel : Icons.check_circle,
                color: statusColor,
                size: 19,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  statusLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isFully
                      ? 'Move-in Ready'
                      : isSemi
                          ? 'Partially Ready'
                          : isUnfurnished
                              ? 'Bare Shell'
                              : 'Available',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          if ((isFully || isSemi) && apartmentItems.isNotEmpty) ...[
            const SizedBox(height: 8),

            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;

                final int columns = width < 360 ? 2 : 3;

                const spacing = 6.0;

                final itemWidth =
                    (width - ((columns - 1) * spacing)) / columns;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  children: apartmentItems.map((item) {
                    return SizedBox(
                      width: itemWidth,
                      child: _buildFurnitureItemCard(
                        item,
                        statusColor,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPricingSection(Property prop) {
    final List<Widget> items = [];

    if (prop.askingPrice.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.sell,
          title: 'Asking Price',
          value: '₹ ${prop.askingPrice}',
          color: Colors.green,
        ),
      );
    }

    if (prop.lastPrice.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.currency_rupee,
          title: 'Last Price',
          value: '₹ ${prop.lastPrice}',
          color: Colors.red,
        ),
      );
    }

    if (prop.currentDates.trim().isNotEmpty) {
      items.add(
        _compactDetailItem2(
          icon: Icons.calendar_today,
          title: 'Added on',
          value: formatDate(prop.currentDates),
          color: Colors.blue,
        ),
      );
    }

    if (prop.availableDate.trim().isNotEmpty) {
      items.add(
        _compactDetailItem(
          icon: Icons.event_available,
          title: 'Available From',
          value: formatDate(prop.availableDate),
          color: Colors.orange,
        ),
      );
    }

    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return _overviewSection(
      icon: Icons.currency_rupee,
      iconColor: Colors.green,
      title: 'Pricing & Timeline',
      child: _compactDetailGrid(items),
    );
  }

  Future<void> handleMainButtonAction() async {
    setState(() {
      isMainLoading = true;
    });
    try {
      final url = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/move_to_main_realestae.php");

      if (estateStatus == "Book") {
        final updateBody = {"action": "update", "P_id": widget.id};
        final updateResponse = await http
            .post(url, body: updateBody)
            .timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": widget.id};
        final moveResponse = await http
            .post(url, body: copyBody)
            .timeout(const Duration(seconds: 30));

        if (updateResponse.statusCode == 200 &&
            moveResponse.statusCode == 200) {
          final now = DateTime.now();
          final formattedNow =
              "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          final editDateBody = {
            "action": "edit_date",
            "source_id": widget.id,
            "date_for_target": formattedNow,
          };
          await http
              .post(url, body: editDateBody)
              .timeout(const Duration(seconds: 30));

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Property moved to Live successfully!",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            );
          }
          setState(() {
            estateStatus = "Live";
          });
        }
      } else if (estateStatus == "Live") {
        final reupdateBody = {"action": "reupdate", "P_id": widget.id};
        await http
            .post(url, body: reupdateBody)
            .timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "source_id": widget.id};
        final deleteResponse = await http
            .post(url, body: deleteBody)
            .timeout(const Duration(seconds: 30));

        if (deleteResponse.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Property UnLived successfully!",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue,
              ),
            );
          }
          setState(() {
            estateStatus = "Book";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          isMainLoading = false;
        });
    }
  }

  Future<String?> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked == null) return null;
    return "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  }

  Future<void> handleUpcomingButtonAction() async {
    setState(() {
      isUpcomingLoading = true;
    });
    try {
      final upcomingUrl = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php");

      if (upcomingStatus == "Book") {
        final selectedDate = await _pickDate();

        if (selectedDate == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No date selected!"),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // 1) Update available_date
        final dateUpdateBody = {
          "action": "update_available_date",
          "P_id": widget.id,
          "date": selectedDate,
        };
        final dateUpdateResponse = await http
            .post(upcomingUrl, body: dateUpdateBody)
            .timeout(const Duration(seconds: 30));

        if (dateUpdateResponse.statusCode != 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to update date!"),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Successfully updated with date"),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

        // 2) Move to upcoming
        final updateBody = {"action": "update", "P_id": widget.id};
        final updateResponse = await http
            .post(upcomingUrl, body: updateBody)
            .timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": widget.id};
        final moveResponse = await http
            .post(upcomingUrl, body: copyBody)
            .timeout(const Duration(seconds: 30));

        if (updateResponse.statusCode == 200 &&
            moveResponse.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Moved to Upcoming successfully!",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.orange,
              ),
            );
          }
          setState(() {
            upcomingStatus = "Live";
          });
        }
      } else if (upcomingStatus == "Live") {
        final reupdateBody = {"action": "reupdate", "P_id": widget.id};
        await http
            .post(upcomingUrl, body: reupdateBody)
            .timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "subid": widget.Subid};
        final deleteResponse = await http
            .post(upcomingUrl, body: deleteBody)
            .timeout(const Duration(seconds: 30));

        if (deleteResponse.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Removed from Upcoming successfully!",
                    style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue,
              ),
            );
          }
          setState(() {
            upcomingStatus = "Book";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted)
        setState(() {
          isUpcomingLoading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final bool isDarkMode = false /* forced light theme */;

    final horizontalPadding = isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight = screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight = screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale = isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<Property>>(
          future: propertyFuture, // Fix: .value to get Future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: screenHeight * 0.4,
                child: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return SizedBox(
                height: screenHeight * 0.25,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 50 * fontScale, color: Colors.grey),
                      SizedBox(height: verticalPadding * 2),
                      Text(
                        "No Property Found!",
                        style: TextStyle(
                            fontSize: 16 * fontScale, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final prop = snapshot.data![0];
              property = prop;

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Hero Image
                        Stack(
                          children: [
                            SizedBox(
                              height: imageHeight,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PropertyPreview(
                                        ImageUrl:
                                            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  key: ValueKey(
                                      '${prop.pId}_${prop.propertyPhoto}'),
                                  imageUrl:
                                      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: const Center(
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error,
                                        size: 50 * fontScale,
                                        color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            // Back
// Back Button
                            Positioned(
                              top: MediaQuery.of(context).padding.top +
                                  (isSmallScreen ? 4.0 : 8.0),
                              left: horizontalPadding,
                              child: CircleAvatar(
                                radius: isSmallScreen ? 20 : 22,
                                backgroundColor: Colors.black.withOpacity(0.6),
                                child: IconButton(
                                  splashRadius: 22,
                                  padding: EdgeInsets.zero,
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    PhosphorIconsRegular.caretLeft,
                                    color: Colors.white,
                                    size: isSmallScreen ? 22 : 26,
                                  ),
                                ),
                              ),
                            ),

// Menu Button
                            if (isFieldWorker)
                              Positioned(
                                top: MediaQuery.of(context).padding.top +
                                    (isSmallScreen ? 4.0 : 8.0),
                                right: horizontalPadding,
                                child: CircleAvatar(
                                  radius: isSmallScreen ? 20 : 22,
                                  backgroundColor: Colors.black.withOpacity(0.6),
                                  child: PopupMenuButton<String>(
                                    splashRadius: 22,
                                    offset: const Offset(0, 45),
                                    onSelected: handleMenuItemClick,
                                    itemBuilder: (context) => const [
                                      PopupMenuItem(
                                        value: 'Edit Flat',
                                        child: Text('Edit Flat'),
                                      ),
                                      PopupMenuItem(
                                        value: 'Add Flat Images',
                                        child: Text('Add Flat Images'),
                                      ),
                                    ],
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: Colors.white,
                                      size: isSmallScreen ? 22 : 26,
                                    ),
                                  ),
                                ),
                              ),

                            Positioned(
                              left: 10,
                              right: 10,
                              bottom: 10,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  // Rent / Buy
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      prop.buyRent,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),

                                  // Showing Price
                                  if (prop.showPrice.trim().isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        '₹${prop.showPrice}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: verticalPadding * 2),
                        // Carousel - Fix: Wrap in Obx for reactivity, use .value
                        FutureBuilder<List<RealEstateSlider1>>(
                          future: sliderFuture,
                          builder: (context, sliderSnapshot) {
                            if (sliderSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(height: carouselHeight * 0.4);
                            }
                            if (sliderSnapshot.hasError ||
                                sliderSnapshot.data == null ||
                                sliderSnapshot.data!.isEmpty) {
                              return const SizedBox();
                            }
                            final images = sliderSnapshot.data!;
                            final viewportFraction =
                                isSmallScreen ? 0.85 : (isTablet ? 0.7 : 0.8);

                            return Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 118,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: horizontalPadding),
                                      itemCount: images.length + 1,
                                      itemBuilder: (context, index) {
                                        final imageUrls = images
                                            .map((e) =>
                                                "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${e.rimg}")
                                            .toList();
                                        if (index == 0) {
                                          final bool hasVideo =
                                              prop.videoLink.isNotEmpty;
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(right: 8),
                                            child: SizedBox(
                                              width: 110,
                                              child: GestureDetector(
                                                onTap: hasVideo
                                                    ? () {
                                                        showDialog(
                                                          context: context,
                                                          barrierColor:
                                                              Colors.black87,
                                                          builder: (context) =>
                                                              Dialog(
                                                            backgroundColor:
                                                                Colors
                                                                    .transparent,
                                                            insetPadding:
                                                                const EdgeInsets
                                                                    .all(16),
                                                            child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12),
                                                                  child: _InlineYoutubePlayer(
                                                                      videoUrl:
                                                                          prop.videoLink),
                                                                ),
                                                                IconButton(
                                                                  icon: const Icon(
                                                                      Icons
                                                                          .close,
                                                                      color: Colors
                                                                          .white),
                                                                  onPressed: () =>
                                                                      Navigator.of(
                                                                              context)
                                                                          .pop(),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      }
                                                    : null,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: Container(
                                                    color: hasVideo
                                                        ? Colors.black
                                                        : Colors.grey[800],
                                                    child: Center(
                                                      child: hasVideo
                                                          ? const Icon(
                                                              Icons
                                                                  .play_circle_fill,
                                                              color:
                                                                  Colors.white,
                                                              size: 36)
                                                          : Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: const [
                                                                  Icon(
                                                                      Icons
                                                                          .videocam_off,
                                                                      color: Colors
                                                                          .white54,
                                                                      size: 20),
                                                                  SizedBox(
                                                                      height:
                                                                          4),
                                                                  Text(
                                                                    "Video not available",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white54,
                                                                        fontSize:
                                                                            9),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        final item = images[index - 1];
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: SizedBox(
                                            width: 110,
                                            child: GestureDetector(
                                              onTap: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SwipePreview(
                                                      imageUrls: imageUrls,
                                                      initialIndex: index - 1,
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                    color: Colors.grey[300],
                                                    child: const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(
                                                        Icons.error,
                                                        size: 30,
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),

// ============================================================
// PROPERTY / FLAT DETAILS
// ============================================================

                        _overviewSection(
                          icon: Icons.apartment,
                          iconColor: Colors.blue,
                          title: 'Property Details',
                          child: _compactDetailGrid(
                            getPropertyDetailsRows(prop),
                          ),
                        ),

// ============================================================
// BUILDING & FACILITIES
// ============================================================

                        _overviewSection(
                          icon: Icons.business,
                          iconColor: Colors.indigo,
                          title: 'Building & Facilities',
                          child: _compactDetailGrid(
                            getBuildingFacilityRows(prop),
                          ),
                        ),

// ============================================================
// FURNISHED / INCLUDED ITEMS
// ============================================================

                        if (prop.furnishedUnfurnished.trim().isNotEmpty)
                          _overviewSection(
                            icon: Icons.chair,
                            iconColor: Colors.purple,
                            title: 'Furnished / Included Items',
                            trailing: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                prop.furnishedUnfurnished,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.purple,
                                ),
                              ),
                            ),
                            child: _buildFurnishedDetailsCard(prop),
                          ),

// ============================================================
// PRICING & TIMELINE
// ============================================================

                        _buildPricingSection(prop),

// ============================================================
// FIELD WORKER
// ============================================================

                        buildFieldworkerInfoCard(prop),

                        const SizedBox(height: 10),
                        KeyedSubtree(
                            key: _tenantSectionKey,
                            child: const SizedBox.shrink()),
                        // Tenant Info - Fix: Use .value, loop for multiple tenants if needed
                        FutureBuilder<List<Catid1>>(
                          future: catidFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Padding(
                                padding: EdgeInsets.all(horizontalPadding),
                                child: const Center(
                                    child: CircularProgressIndicator()),
                              );
                            }

                            final tenants = snapshot.data ?? [];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: tenants.map((tenant) {
                                return buildTenantFullCard(
                                  tenant,
                                  isDarkMode: isDarkMode,
                                );
                              }).toList(),
                            );
                          },
                        ),

                        SizedBox(
                            height:
                                screenHeight * (isSmallScreen ? 0.1 : 0.08)),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: isFieldWorker
          ? FloatingActionButton.extended(
        onPressed: () {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddTenantUnderFutureProperty(
                  id: widget.id,
                  subId: widget.Subid,
                ),
              ),
            );
          }
        },
        icon: Icon(Icons.person_add, color: Colors.white, size: 20 * fontScale),
        label: Text(
          "Add Tenant",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14 * fontScale,
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 4,
      )
          : null,


      bottomNavigationBar:
      isFieldWorker
          ?
      Container(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isMainLoading
                      ? Colors.grey
                      : (estateStatus == "Live"
                          ? Colors.grey
                          : estateStatus == "Book"
                              ? Colors.red
                              : Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  elevation: 2,
                ),

                // -----------------------------
                // ON PRESS WITH 3 SECOND TIMER
                // -----------------------------
                onPressed:
                    isMainLoading || estateStatus.isEmpty || countdown > 0
                        ? null
                        : () async {
                            setState(() {
                              countdown = 3;
                            });

                            for (int i = 3; i > 0; i--) {
                              setState(() => countdown = i);
                              await Future.delayed(const Duration(seconds: 1));
                            }

                            setState(() {
                              countdown = 0;
                              isMainLoading = true;
                            });

                            await handleMainButtonAction();

                            setState(() {
                              isMainLoading = false;
                            });
                          },

                // -----------------------------
                // CHILD WITH LOADER + COUNTDOWN
                // -----------------------------
                child: isMainLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : countdown > 0
                        ? Text(
                            "$countdown",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            estateStatus == "Live"
                                ? "Rent out / Book"
                                : estateStatus == "Book"
                                    ? "Move to Live"
                                    : "Loading...",
                            style: TextStyle(
                              fontSize:
                                  (isSmallScreen ? 11.0 : 13.0) * fontScale,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
              ),
            ),
            SizedBox(width: horizontalPadding),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isUpcomingLoading
                      ? Colors.grey
                      : (upcomingStatus == "Live"
                          ? Colors.grey
                          : Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  elevation: 2,
                ),
                onPressed: isUpcomingLoading || upcomingStatus.isEmpty
                    ? null
                    : () => handleUpcomingButtonAction(),
                child: isUpcomingLoading
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        upcomingStatus == "Live"
                            ? "Remove"
                            : upcomingStatus == "Book"
                                ? "Move to Upcoming"
                                : "Loading...",
                        style: TextStyle(
                          fontSize: (isSmallScreen ? 11.0 : 13.0) * fontScale,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
              ),
            ),
          ],
        ),
      )
          : null,

    );
  }

  // ============================================================
// COMPACT DETAIL CARD - USED BY ALL DETAIL SECTIONS
// ============================================================

  Widget _compactDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (value.trim().isEmpty ||
        value.trim().toLowerCase() == 'null' ||
        value.trim() == '0') {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(
        minHeight: 58,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth < 360 ? 27 : 31,
            height: screenWidth < 360 ? 27 : 31,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: screenWidth < 360 ? 15 : 17,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 8 : 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 10 : 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _compactDetailItem2({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (value.trim().isEmpty ||
        value.trim().toLowerCase() == 'null' ||
        value.trim() == '0') {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: const BoxConstraints(
        minHeight: 58,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: screenWidth < 360 ? 27 : 31,
            height: screenWidth < 360 ? 27 : 31,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: screenWidth < 360 ? 15 : 17,
            ),
          ),
          const SizedBox(width: 7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 8 : 9,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  maxLines: 3,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    fontSize: screenWidth < 360 ? 10 : 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// ============================================================
// RESPONSIVE GRID
// ============================================================


  Widget _compactDetailGrid(List<Widget> items) {
    if (items.isEmpty) {
      return const SizedBox.shrink();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Keep normal detail cards in 3 columns.
        final int columns = width < 360 ? 2 : 3;

        const spacing = 6.0;

        final itemWidth =
            (width - ((columns - 1) * spacing)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: items.map((item) {
            return SizedBox(
              width: itemWidth,
              child: item,
            );
          }).toList(),
        );
      },
    );
  }

// ============================================================
// SECTION CONTAINER
// ============================================================

  Widget _overviewSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required Widget child,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(
        left: 10,
        right: 10,
        bottom: 10,
      ),
      padding: const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 17,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (trailing != null) trailing,
            ],
          ),
          const SizedBox(height: 9),
          child,
        ],
      ),
    );
  }

// ============================================================
// SAFE VALUE
// ============================================================

  String _displayValue(
    String value, {
    String fallback = 'Not Available',
  }) {
    final v = value.trim();

    if (v.isEmpty || v.toLowerCase() == 'null' || v == '0') {
      return fallback;
    }

    return v;
  }

  Widget _buildFurnitureItemCard(
      String rawItem,
      Color statusColor,
      ) {
    final item = rawItem.trim();

    if (item.isEmpty) {
      return const SizedBox.shrink();
    }

    // Example:
    // Fan(3)           -> Fan / 3
    // Refrigerator(2)  -> Refrigerator / 2
    // Washing Machine   -> Washing Machine
    final match = RegExp(r'^(.*?)\s*\((.*?)\)\s*$').firstMatch(item);

    String itemName;
    String quantity = '';

    if (match != null) {
      itemName = match.group(1)?.trim() ?? item;
      quantity = match.group(2)?.trim() ?? '';
    } else {
      itemName = item;
    }

    // Find the proper icon from the predefined list.
    String matchedName = itemName;

    for (final furniture in furnitureItems) {
      if (furniture.toLowerCase() == itemName.toLowerCase()) {
        matchedName = furniture;
        break;
      }
    }

    final icon = _getFurnitureIcon(matchedName);

    return Container(
      constraints: const BoxConstraints(
        minHeight: 68,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: statusColor.withOpacity(0.18),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: statusColor,
              size: 17,
            ),
          ),

          const SizedBox(width: 6),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  itemName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                if (quantity.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    'Qty: $quantity',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTenantFullCard(
    Catid1 tenant, {
    required bool isDarkMode,
  }) {
    final Color bg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color labelColor = isDarkMode ? Colors.white70 : Colors.grey.shade700;
    final Color valueColor = isDarkMode ? Colors.white : Colors.black;
    final Color accent = Colors.green;

    Widget infoRow(IconData icon, String label, String value) {
      if (value.isEmpty) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: accent),
            const SizedBox(width: 10),
            SizedBox(
              width: 110,
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: labelColor,
                ),
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 6,
      margin: const EdgeInsets.only(bottom: 14),
      color: bg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ================= HEADER =================
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.person, color: Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    tenant.tenant_name.isEmpty
                        ? "Unnamed Tenant"
                        : tenant.tenant_name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: valueColor,
                    ),
                  ),
                ),
                // Status badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    tenant.status.isEmpty ? "ACTIVE" : tenant.status,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // ================= DETAILS =================
            infoRow(Icons.phone, "Phone", tenant.tenant_phone_number),
            infoRow(Icons.currency_rupee, "Rent", tenant.flat_rent),
            infoRow(
              Icons.calendar_today,
              "Shifting Date",
              formatDate(tenant.shifting_date),
            ),
            infoRow(Icons.group, "Members", tenant.members),
            infoRow(Icons.email, "Email", tenant.email),

            const SizedBox(height: 8),

            infoRow(
                Icons.directions_car, "Vehicle", tenant.tenant_vichal_details),
            infoRow(Icons.work, "Work Profile", tenant.work_profile),
            infoRow(Icons.home, "BHK", tenant.bhk),
            infoRow(Icons.apartment, "Property Type", tenant.type_of_property),
            infoRow(Icons.payments, "Payment Mode", tenant.payment_mode),
          ],
        ),
      ),
    );
  }
}

class _InlineYoutubePlayer extends StatefulWidget {
  final String videoUrl;

  const _InlineYoutubePlayer({
    required this.videoUrl,
  });

  @override
  State<_InlineYoutubePlayer> createState() => _InlineYoutubePlayerState();
}

class _InlineYoutubePlayerState extends State<_InlineYoutubePlayer> {
  YoutubePlayerController? _controller;

  bool _invalidUrl = false;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId == null || videoId.isEmpty) {
      _invalidUrl = true;
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        // Autoplay
        autoPlay: true,

        // Required for reliable autoplay
        mute: true,

        // Cleaner embedded player
        enableCaption: false,

        // Don't show the large YouTube controls
        hideControls: false,

        controlsVisibleAtStart: false,

        // Don't allow drag seeking in the small card
        disableDragSeek: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_invalidUrl || _controller == null) {
      return Container(
        color: Colors.grey.shade900,
        child: const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.videocam_off,
                color: Colors.white54,
                size: 22,
              ),
              SizedBox(height: 5),
              Text(
                'Video unavailable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: false,
        progressIndicatorColor: Colors.red,
        bottomActions: const [
          CurrentPosition(),
          ProgressBar(
            isExpanded: true,
          ),
          RemainingDuration(),
        ],
      ),
    );
  }
}
