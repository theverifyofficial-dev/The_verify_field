import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/realestateSlider.dart';
import '../../property_preview.dart';
import 'Edit_flat.dart';
import 'add_image_under_futureproperty.dart'; // Note: Fix filename if 'Futureproipoerty' is a typo
import 'add_tenant_infutureproperty.dart';

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
  final int id;
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
  final int sub_id;
  final int video_link;

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
    required this.sub_id,
    required this.video_link,
  });

  factory Catid1.fromJson(Map<String, dynamic> json) {
    return Catid1(
      id: json['id'] ?? 0,
      tenant_name: json['tenant_name'] ?? '',
      tenant_phone_number: json['tenant_phone_number'] ?? '',
      flat_rent: json['flat_rent'] ?? '',
      shifting_date: json['shifting_date'] ?? '',
      members: json['members'] ?? '',
      email: json['email'] ?? '',
      tenant_vichal_details: json['tenant_vichal_details'] ?? '',
      work_profile: json['work_profile'] ?? '',
      bhk: json['bhk'] ?? '',
      type_of_property: json['type_of_property'] ?? '',
      sub_id: json['sub_id'] ?? 0,
      video_link: json['video_link'] ?? 0,
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
  State<underflat_futureproperty> createState() => _underflat_futurepropertyState();
}

class _underflat_futurepropertyState extends State<underflat_futureproperty> {
  bool isMainLoading = false;
  bool isUpcomingLoading = false;
  Property? property;
  String estateStatus = 'Book'; // Default
  String upcomingStatus = 'Book'; // Default
  late Future<List<RealEstateSlider1>> sliderFuture;
  late Future<List<Property>> propertyFuture;
  late Future<List<Catid1>> catidFuture;

  @override
  void initState() {
    super.initState();
    loadProperty();
    loadAllData();
    fetchData1();
    fetchData1Status();
  }
  int countdown = 0;

  Future<List<RealEstateSlider1>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_flat_in_future_property_multiple_images?subid=${widget.id}'));
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
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/detail_page_for_future_property_under_flat.php?P_id=${widget.id}");

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
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_tenant_in_future_property?sub_id=${widget.Subid}");
    final response = await http.get(url).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      // Fix: Explicit cast to List<dynamic>
      final List<dynamic> listresponce = json.decode(response.body);
      return listresponce.map((data) => Catid1.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
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
      debugPrint("Error fetching data: $e");
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
      debugPrint("Error loading property: $e");
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
                builder: (context) => Futureproipoerty_FileUploadPage(idd: widget.id)), // Fix: Rename class/file if typo
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
      debugPrint(
          'WhatsApp open only supported on Android with this method');
    }
  }

  Widget buildInfoRow(IconData icon, Color iconColor, String title,
      String value) {
    if (value.isEmpty || value == "null" || value == "0") {
      return const SizedBox.shrink();
    }

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final Color cardColor = Colors.white;
    final Color borderColor =
    isDarkMode ? Colors.grey.shade700.withOpacity(0.2) : Colors.grey.shade200;
    final Color titleColor =
    isDarkMode ? Colors.black87 : Colors.grey.shade700;
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
            ? [const BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]
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
            child: Icon(icon,
                size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
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
                    fontWeight: FontWeight.w500,
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
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                onTap: () =>
                    showCallConfirmationDialog(role, name, number),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: isSmallScreen ? 6.0 : 8.0),
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
                            child: Icon(PhosphorIcons.whatsapp_logo_bold,
                                color: cardColor,
                                size: isSmallScreen ? 20.0 : 24.0),
                          ),
                          SizedBox(
                              width: isSmallScreen ? 12.0 : 16.0),
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
                    horizontal: 12,
                    vertical: isSmallScreen ? 6.0 : 8.0),
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

  Widget buildSimpleInfoCard(String title, String value, IconData icon,
      Color cardColor,
      {VoidCallback? onTap}) {
    if (value.isEmpty || value == "null" || value == "0") {
      return const SizedBox.shrink();
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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

  Widget _buildAdaptiveRows(
      List<Widget> cards, double verticalPadding) {
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxWidth;
      final spacing =
      MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0;
      final runSpacing = verticalPadding;
      final int itemsPerRow =
      available >= 800 ? 4 : available >= 520 ? 3 : 2;
      final itemWidth =
          (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

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
    List<Widget> rows = [];
    if (prop.facility.isNotEmpty) {
      rows.add(buildInfoRow(
          Icons.local_hospital, Colors.amber, "Building Facility", prop.facility));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final double verticalPadding = isSmallScreen ? 2.0 : 4.0;

    // Row 1: Kitchen and Bathroom
    List<Widget> row1Cards = [];
    if (prop.kitchen.isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard(
          "Kitchen", prop.kitchen, Icons.kitchen, Colors.pink));
    }
    if (prop.bathroom.isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard(
          "Bathroom", prop.bathroom, Icons.bathroom, Colors.lightBlue));
    }
    if (row1Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row1Cards, verticalPadding),
      ));
    }

    // Row 2: Parking, Lift, Meter
    List<Widget> row2Cards = [];
    if (prop.parking.isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard(
          "Parking", prop.parking, Icons.local_parking, Colors.purple));
    }
    if (prop.lift.isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard(
          "Lift", prop.lift, Icons.elevator, Colors.red));
    }
    if (prop.meter.isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard(
          "Meter", prop.meter, Icons.electric_meter, Colors.blue));
    }
    if (row2Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row2Cards, verticalPadding),
      ));
    }

    return rows;
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final String name = prop.fieldWarkarName;
    final String number = prop.fieldWorkarNumber;
    final String address = prop.fieldworkarAddress;
    final String location = prop.fieldWorkerCurrentLocation;

    if (name.isEmpty &&
        number.isEmpty &&
        address.isEmpty &&
        location.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = Colors.blue;
    final Color bgColor = Colors.blue;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: isSmallScreen ? 32.0 : 36.0,
                height: isSmallScreen ? 32.0 : 36.0,
                decoration: BoxDecoration(
                  color: bgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.engineering,
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
                      "FIELD WORKER",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10.0 : 11.0,
                        fontWeight: FontWeight.w600,
                        color: bgColor,
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
          // Number
          if (number.isNotEmpty)
            GestureDetector(
              onTap: () => showCallConfirmationDialog(
                  "FIELD WORKER", name, number),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: isSmallScreen ? 6.0 : 8.0),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: bgColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        maskPhoneNumber(number),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13.0 : 14.0,
                          fontWeight: FontWeight.w500,
                          color: bgColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => openWhatsApp(number),
                          child: Icon(
                            PhosphorIcons.whatsapp_logo_bold,
                            color: bgColor,
                            size: isSmallScreen ? 20.0 : 24.0,
                          ),
                        ),
                        SizedBox(
                            width:
                            isSmallScreen ? 12.0 : 16.0),
                        Icon(Icons.call,
                            color: bgColor,
                            size: isSmallScreen ? 20.0 : 24.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Address
          if (address.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                  top: isSmallScreen ? 6.0 : 8.0),
              child: buildSimpleInfoCard("Fieldworker Address",
                  address, Icons.location_on, Colors.lime),
            ),
          // Location
          if (location.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                  top: isSmallScreen ? 6.0 : 8.0),
              child: buildSimpleInfoCard("Fieldworker Location",
                  location, Icons.my_location, Colors.lightBlue),
            ),
        ],
      ),
    );
  }

  void showCallConfirmationDialog(
      String role, String name, String number) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call $role',
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black)),
        content: Text(
            'Do you really want to call ${name.isNotEmpty ? name : role}?',
            style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor:
        isDarkMode ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('No',
                style: TextStyle(color: Colors.grey)),
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

  Widget buildResponsiveInfoGrid(
      List<Widget> infoRows) {
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: leftColumn,
                ),
              ),
              SizedBox(
                  width:
                  MediaQuery.of(context).size.width < 360
                      ? 8.0
                      : 12.0),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
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
    List<Widget> rows = [];

    // Helper to safely return value or "Not Available"
    String safeValue(String? value, [String suffix = ""]) {
      if (value == null || value.trim().isEmpty || value.trim().toLowerCase() == "null" || value.trim() == "0") {
        return "Not Available";
      }
      return value.trim() + suffix;
    }

    // 1. Metro Station (highwayDistance → actually metro_distance in this model)
    rows.add(buildInfoRow(
      Icons.train,
      Colors.orange,
      "Metro Distance",
      safeValue(prop.metroDistance),
    ));

    // 2. Market Distance
    rows.add(buildInfoRow(
      Icons.store_mall_directory,
      Colors.purple,
      "Market Distance",
      safeValue(prop.mainMarketDistance),
    ));

    // 3. Floor (Floor / Total Floor)
    String floorText = "Not Available";
    if (prop.floor.isNotEmpty && prop.floor.trim() != "null") {
      floorText = prop.floor.trim();
    }
    if (prop.totalFloor.isNotEmpty && prop.totalFloor.trim() != "null") {
      floorText += (floorText != "Not Available" ? " / ${prop.totalFloor.trim()}" : prop.totalFloor.trim());
    }
    rows.add(buildInfoRow(
      Icons.layers,
      Colors.green,
      "Floor",
      floorText,
    ));

    // 4. Type of Property
    rows.add(buildInfoRow(
      Icons.home_work,
      Colors.orange,
      "Type of Property",
      safeValue(prop.typeofProperty),
    ));

    // 5. Square Feet
    rows.add(buildInfoRow(
      Icons.square_foot,
      Colors.teal,
      "Sq. Ft.",
      safeValue(prop.squarefit),
    ));

    // 6. Registry & GPA
    rows.add(buildInfoRow(
      Icons.description,
      Colors.blue,
      "Registry & GPA",
      safeValue(prop.registryAndGpa),
    ));

    // 7. Furnishing
    rows.add(buildInfoRow(
      Icons.chair,
      Colors.pink,
      "Furnishing",
      safeValue(prop.furnishedUnfurnished),
    ));

    // 9. Road Size
    String roadSize = safeValue(prop.roadSize, " Feet");
    if (roadSize == "Not Available Feet") roadSize = "Not Available";
    rows.add(buildInfoRow(
      Icons.straighten,
      Colors.teal,
      "Road Size",
      roadSize,
    ));

    // 10. Flat Number
    rows.add(buildInfoRow(
      Icons.format_list_numbered,
      Colors.green,
      "Flat Number",
      safeValue(prop.flatNumber),
    ));

    // 11. Age of Property
    rows.add(buildInfoRow(
      Icons.history,
      Colors.brown,
      "Age of Property",
      safeValue(prop.ageOfProperty),
    ));

    // 12. Residence / Commercial
    rows.add(buildInfoRow(
      Icons.domain,
      Colors.amber,
      "Residence / Commercial",
      safeValue(prop.residenceCommercial),
    ));

    // 13. Loan
    rows.add(buildInfoRow(
      Icons.account_balance,
      Colors.blue,
      "Loan",
      safeValue(prop.loan),
    ));

    // 14. Highway Distance (extra in first code)
    rows.add(buildInfoRow(
      Icons.directions_car,
      Colors.red,
      "Highway Distance",
      safeValue(prop.highwayDistance),
    ));

    return rows;
  }
  List<Widget> getAdditionalInfoRows(
      Property prop) {
    List<Widget> rows = [];

    if (prop.currentDates.isNotEmpty) {
      rows.add(buildSimpleInfoCard("Current Date", prop.currentDates,
          Icons.date_range, Colors.indigo));
    }

    // Asking & Last Price row
    List<Widget> priceWidgets = [];
    if (prop.askingPrice.isNotEmpty) {
      priceWidgets.add(
        Expanded(
          child: buildSimpleInfoCard("Asking Price", prop.askingPrice,
              Icons.currency_rupee, Colors.green),
        ),
      );
    }
    if (prop.lastPrice.isNotEmpty) {
      if (priceWidgets.isNotEmpty) {
        priceWidgets.add(SizedBox(
            width:
            MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0));
      }
      priceWidgets.add(
        Expanded(
          child: buildSimpleInfoCard("Last Price", prop.lastPrice,
              Icons.currency_rupee, Colors.pink),
        ),
      );
    }
    if (priceWidgets.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(
              vertical:
              MediaQuery.of(context).size.width < 360 ? 2.0 : 4.0),
          child: Row(children: priceWidgets),
        ),
      );
    }

    if (prop.videoLink.isNotEmpty) {
      rows.add(
        InkWell(
          onTap: () => launchVideo(prop.videoLink),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.video_library,
                  color: Colors.red,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Video Link",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        prop.videoLink,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
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


    rows.add(buildFieldworkerInfoCard(prop));

    return rows;
  }

  Future<void> launchVideo(String url) async {
    final Uri videoUri = Uri.parse(url);
    if (await canLaunchUrl(videoUri)) {
      await launchUrl(videoUri);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot launch video")),
        );
      }
    }
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
          Icon(icon,
              size: isSmallScreen ? 14.0 : 16.0, color: color),
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

  Future<void> handleMainButtonAction() async {
    setState(() {
      isMainLoading = true;
    });
    try {
      final url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/move_to_main_realestae.php");

      if (estateStatus == "Book") {
        final updateBody = {"action": "update", "P_id": widget.id};
        final updateResponse =
        await http.post(url, body: updateBody).timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": widget.id};
        final moveResponse =
        await http.post(url, body: copyBody).timeout(const Duration(seconds: 30));

        if (updateResponse.statusCode == 200 &&
            moveResponse.statusCode == 200) {
          final now = DateTime.now();
          final formattedNow = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          final editDateBody = {
            "action": "edit_date",
            "source_id": widget.id,
            "date_for_target": formattedNow,
          };
          await http.post(url, body: editDateBody)
              .timeout(const Duration(seconds: 30));

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                    "Property moved to Live successfully!",
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
        await http.post(url, body: reupdateBody)
            .timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "source_id": widget.id};
        final deleteResponse =
        await http.post(url, body: deleteBody)
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
          SnackBar(content: Text("Error: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() {
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
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php");

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
        final dateUpdateResponse =
        await http.post(upcomingUrl, body: dateUpdateBody)
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
        final updateResponse =
        await http.post(upcomingUrl, body: updateBody)
            .timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": widget.id};
        final moveResponse =
        await http.post(upcomingUrl, body: copyBody)
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
        await http.post(upcomingUrl, body: reupdateBody)
            .timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "subid": widget.Subid};
        final deleteResponse =
        await http.post(upcomingUrl, body: deleteBody)
            .timeout(const Duration(seconds: 30));

        if (deleteResponse.statusCode == 200) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                Text("Removed from Upcoming successfully!",
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
          SnackBar(content: Text("Error: $e"),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() {
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
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding =
    isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding =
    isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight =
        screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight =
        screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale =
    isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);

    return Scaffold(
      backgroundColor:
      isDarkMode ? Colors.grey[900] : Colors.white,
      body: RefreshIndicator(
        onRefresh: refreshData,
        child: FutureBuilder<List<Property>>(
          future: propertyFuture, // Fix: .value to get Future
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return SizedBox(
                height: screenHeight * 0.4,
                child: const Center(
                    child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError ||
                snapshot.data == null ||
                snapshot.data!.isEmpty) {
              return SizedBox(
                height: screenHeight * 0.25,
                child: Center(
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline,
                          size: 50 * fontScale,
                          color: Colors.grey),
                      SizedBox(
                          height: verticalPadding * 2),
                      Text(
                        "No Property Found!",
                        style: TextStyle(
                            fontSize: 16 * fontScale,
                            color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              final prop = snapshot.data![0];
              property = prop;

              return CustomScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(),
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
                                  Navigator.of(context)
                                      .push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PropertyPreview(
                                            ImageUrl:
                                            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                          ),
                                    ),
                                  );
                                },
                                child:
                                CachedNetworkImage(
                                  key: ValueKey(
                                      '${prop.pId}_${prop.propertyPhoto}'),
                                  imageUrl:
                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                  fit: BoxFit.cover,
                                  placeholder:
                                      (context, url) =>
                                      Container(
                                        color:
                                        Colors.grey[300],
                                        child: const Center(
                                            child:
                                            CircularProgressIndicator()),
                                      ),
                                  errorWidget: (context,
                                      url, error) =>
                                      Container(
                                        color:
                                        Colors.grey[300],
                                        child: Icon(Icons.error,
                                            size: 50 *
                                                fontScale,
                                            color:
                                            Colors.grey),
                                      ),
                                ),
                              ),
                            ),
                            // Back
                            Positioned(
                              top: MediaQuery.of(context)
                                  .padding
                                  .top +
                                  (isSmallScreen
                                      ? 4.0
                                      : 8.0),
                              left: horizontalPadding,
                              child: IconButton(
                                onPressed: () =>
                                    Navigator.pop(
                                        context),
                                icon: Icon(
                                  PhosphorIcons
                                      .caret_left_bold,
                                  color: Colors.white,
                                  size: isSmallScreen
                                      ? 24.0
                                      : 28.0,
                                ),
                              ),
                            ),
                            // Menu
                            Positioned(
                              top: MediaQuery.of(context)
                                  .padding
                                  .top +
                                  (isSmallScreen
                                      ? 4.0
                                      : 8.0),
                              right: horizontalPadding,
                              child: PopupMenuButton<
                                  String>(
                                onSelected: (value) =>
                                    handleMenuItemClick(
                                        value),
                                itemBuilder:
                                    (BuildContext
                                context) {
                                  return {
                                    'Edit Flat',
                                    'Add Flat Images'
                                  }
                                      .map((String choice) {
                                    return PopupMenuItem<
                                        String>(
                                      value: choice,
                                      child: Text(
                                        choice,
                                        style: TextStyle(
                                            color: isDarkMode
                                                ? Colors
                                                .white
                                                : Colors
                                                .black),
                                      ),
                                    );
                                  }).toList();
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: isSmallScreen
                                      ? 24.0
                                      : 28.0,
                                ),
                              ),
                            ),
                            // Status Chip
                            Positioned(
                              bottom: isSmallScreen
                                  ? 8.0
                                  : 16.0,
                              right: horizontalPadding,
                              child: Container(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    horizontalPadding,
                                    vertical:
                                    verticalPadding),
                                decoration: BoxDecoration(
                                  color: Colors.green
                                      .withOpacity(0.7),
                                  borderRadius:
                                  BorderRadius
                                      .circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    prop.buyRent,
                                    style: TextStyle(
                                      fontSize: (isSmallScreen
                                          ? 16.0
                                          : 18.0) *
                                          fontScale,
                                      fontWeight:
                                      FontWeight
                                          .bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                            height: verticalPadding * 2),
                        // Price + Maintenance
                        Padding(
                          padding:
                          EdgeInsets.symmetric(
                              horizontal:
                              horizontalPadding),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets
                                      .symmetric(
                                      horizontal:
                                      horizontalPadding,
                                      vertical:
                                      verticalPadding),
                                  decoration:
                                  BoxDecoration(
                                    color: Colors.purple
                                        .withOpacity(
                                        0.8),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '₹ ${prop.showPrice}',
                                      style: TextStyle(
                                        fontSize: (isSmallScreen
                                            ? 14.0
                                            : 16.0) *
                                            fontScale,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color:
                                        Colors.white,
                                      ),
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  width:
                                  horizontalPadding *
                                      0.8),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets
                                      .symmetric(
                                      horizontal:
                                      horizontalPadding,
                                      vertical:
                                      verticalPadding),
                                  decoration:
                                  BoxDecoration(
                                    color: Colors.purple
                                        .withOpacity(
                                        0.8),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                        16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${prop.maintance} Maintance",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen
                                            ? 14.0
                                            : 16.0) *
                                            fontScale,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color:
                                        Colors.white,
                                      ),
                                      overflow:
                                      TextOverflow
                                          .ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Location + Chips
                        Padding(
                          padding: EdgeInsets
                              .symmetric(
                            horizontal:
                            horizontalPadding,
                            vertical:
                            verticalPadding * 1.5,
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                prop.locations,
                                style: TextStyle(
                                  fontSize: (isSmallScreen
                                      ? 15.0
                                      : 16.0) *
                                      fontScale,
                                  fontWeight:
                                  FontWeight.w600,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors
                                      .black87,
                                ),
                              ),
                              SizedBox(
                                  height:
                                  verticalPadding *
                                      1.2),
                              LayoutBuilder(builder: (context, constraints) {
                                final available = constraints.maxWidth;
                                final spacing = chipSpacing * 1.5;
                                final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
                                final rawWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;
                                final chipWidth = rawWidth.clamp(64.0, available).toDouble();

                                final chipsData = <Map<String, dynamic>>[

                                  {'icon': Icons.install_desktop_sharp, 'text': 'Property Id: ${prop.pId}', 'color': Colors.lightGreen},
                                  {'icon': Icons.bedroom_parent, 'text': prop.bhk ?? '', 'color': Colors.purple},
                                  if ((prop.subid ?? '').isNotEmpty && prop.subid != 'null')
                                    {'icon': Icons.file_open, 'text': 'Building Id: ${prop.subid}', 'color': Colors.deepOrange},

                                ].where((e) {

                                  final t = (e['text'] as String?)?.trim() ?? '';
                                  return t.isNotEmpty && t != 'null';

                                }).toList();

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: verticalPadding * 1.2,
                                  children: chipsData.map((e) {
                                    return SizedBox(
                                      width: chipWidth,
                                      child: buildChip(
                                        e['icon'] as IconData,
                                        e['text'] as String,
                                        e['color'] as Color,
                                        context,
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                              SizedBox(height: verticalPadding * 2),
                            ],
                          ),
                        ),
                        // Carousel - Fix: Wrap in Obx for reactivity, use .value
                        FutureBuilder<
                            List<RealEstateSlider1>>(
                          future:
                          sliderFuture,
                          builder: (context,
                              sliderSnapshot) {
                            if (sliderSnapshot
                                .connectionState ==
                                ConnectionState
                                    .waiting) {
                              return SizedBox(
                                  height:
                                  carouselHeight *
                                      0.4);
                            }
                            if (sliderSnapshot
                                .hasError ||
                                sliderSnapshot
                                    .data ==
                                    null ||
                                sliderSnapshot
                                    .data!.isEmpty) {
                              return const SizedBox();
                            }
                            final images =
                            sliderSnapshot
                                .data!;
                            final viewportFraction =
                            isSmallScreen
                                ? 0.85
                                : (isTablet
                                ? 0.7
                                : 0.8);

                            return Container(
                              margin:
                              EdgeInsets.symmetric(
                                horizontal:
                                horizontalPadding,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: [
                                  CarouselSlider(
                                    options:
                                    CarouselOptions(
                                      height:
                                      carouselHeight,
                                      autoPlay: true,
                                      enlargeCenterPage:
                                      false,
                                      autoPlayInterval:
                                      const Duration(
                                          seconds:
                                          3),
                                      viewportFraction:
                                      viewportFraction,
                                    ),
                                    items: images
                                        .asMap()
                                        .entries
                                        .map((entry) {
                                      final item =
                                          entry.value;
                                      return Builder(
                                        builder:
                                            (BuildContext
                                        context) {
                                          return GestureDetector(
                                            onTap:
                                                () {
                                              Navigator.of(context)
                                                  .push(
                                                MaterialPageRoute(
                                                  builder: (context) => PropertyPreview(
                                                    ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                  ),
                                                ),
                                              );
                                            },
                                            child:
                                            Container(
                                              margin: const EdgeInsets
                                                  .symmetric(
                                                  horizontal:
                                                  4),
                                              child:
                                              ClipRRect(
                                                borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10)),
                                                child:
                                                CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) => Container(
                                                    color: Colors.grey[300],
                                                    child: const Center(child: CircularProgressIndicator()),
                                                  ),
                                                  errorWidget: (context, url, error) => Container(
                                                    color: Colors.grey[300],
                                                    child: const Icon(Icons.error, size: 50, color: Colors.grey),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),

                        // Property Details
                        Container(
                          margin: EdgeInsets.all(
                              horizontalPadding),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    horizontalPadding /
                                        2),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .info_outline,
                                      color:
                                      Colors.blue,
                                      size: (isSmallScreen
                                          ? 16.0
                                          : 18.0) *
                                          fontScale,
                                    ),
                                    SizedBox(
                                        width:
                                        horizontalPadding),
                                    Text(
                                      "Property Details",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen
                                            ? 15.0
                                            : 16.0) *
                                            fontScale,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: isDarkMode
                                            ? Colors
                                            .white
                                            : Colors
                                            .black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                  verticalPadding),
                              buildResponsiveInfoGrid(
                                getPropertyDetailsRows(
                                    prop),
                              ),
                            ],
                          ),
                        ),
                        // Building Facility
                        Container(
                          margin: EdgeInsets.all(
                              horizontalPadding),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    horizontalPadding /
                                        2),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .local_hospital,
                                      color:
                                      Colors.blue,
                                      size: (isSmallScreen
                                          ? 16.0
                                          : 18.0) *
                                          fontScale,
                                    ),
                                    SizedBox(
                                        width:
                                        horizontalPadding),
                                    Text(
                                      "Building Facility",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen
                                            ? 15.0
                                            : 16.0) *
                                            fontScale,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: isDarkMode
                                            ? Colors
                                            .white
                                            : Colors
                                            .black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                  verticalPadding),
                              if (getBuildingFacilityRows(prop).isNotEmpty)
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: getBuildingFacilityRows(
                                      prop),
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        // Contact Information
                        Container(
                          margin: EdgeInsets.all(
                              horizontalPadding),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    horizontalPadding /
                                        2),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .contact_page,
                                      color:
                                      Colors.blue,
                                      size: (isSmallScreen
                                          ? 16.0
                                          : 18.0) *
                                          fontScale,
                                    ),
                                    SizedBox(
                                        width:
                                        horizontalPadding),
                                    Text(
                                      "Contact Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen
                                            ? 15.0
                                            : 16.0) *
                                            fontScale,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: isDarkMode
                                            ? Colors
                                            .white
                                            : Colors
                                            .black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                  verticalPadding *
                                      2),
                              buildContactCard(
                                "OWNER",
                                prop.ownerName,
                                prop.ownerNumber,
                                bgColor:
                                Colors.green,
                              ),
                              buildContactCard(
                                "CARETAKER",
                                prop.careTakerName,
                                prop.careTakerNumber,
                                bgColor:
                                Colors.purple,
                              ),
                            ],
                          ),
                        ),
                        // Additional Info
                        Container(
                          margin: EdgeInsets.all(
                              horizontalPadding),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Padding(
                                padding: EdgeInsets
                                    .symmetric(
                                    horizontal:
                                    horizontalPadding /
                                        2),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons
                                          .info_outline,
                                      color:
                                      Colors.blue,
                                      size: (isSmallScreen
                                          ? 16.0
                                          : 18.0) *
                                          fontScale,
                                    ),
                                    SizedBox(
                                        width:
                                        horizontalPadding),
                                    Text(
                                      "Additional Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen
                                            ? 15.0
                                            : 16.0) *
                                            fontScale,
                                        fontWeight:
                                        FontWeight
                                            .bold,
                                        color: isDarkMode
                                            ? Colors
                                            .white
                                            : Colors
                                            .black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                  height:
                                  verticalPadding),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,
                                children: getAdditionalInfoRows(
                                    prop),
                              ),
                            ],
                          ),
                        ),
                        // Tenant Info - Fix: Use .value, loop for multiple tenants if needed
                        FutureBuilder<List<Catid1>>(
                          future:
                          catidFuture,
                          builder: (context,
                              tenantSnapshot) {
                            if (tenantSnapshot
                                .connectionState ==
                                ConnectionState
                                    .waiting) {
                              return Padding(
                                padding:
                                EdgeInsets.all(
                                    horizontalPadding),
                                child: const Center(
                                    child:
                                    CircularProgressIndicator()),
                              );
                            } else if (tenantSnapshot
                                .hasError ||
                                tenantSnapshot
                                    .data ==
                                    null ||
                                tenantSnapshot
                                    .data!
                                    .isEmpty) {
                              return const SizedBox();
                            } else {
                              final tenants =
                              tenantSnapshot
                                  .data!;
                              return Container(
                                margin:
                                EdgeInsets.all(
                                    horizontalPadding),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets
                                          .symmetric(
                                          horizontal:
                                          horizontalPadding /
                                              2),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons
                                                .people,
                                            color: Colors
                                                .blue,
                                            size: (isSmallScreen
                                                ? 16.0
                                                : 18.0) *
                                                fontScale,
                                          ),
                                          SizedBox(
                                              width:
                                              horizontalPadding),
                                          Text(
                                            "Tenant Information",
                                            style:
                                            TextStyle(
                                              fontSize: (isSmallScreen
                                                  ? 15.0
                                                  : 16.0) *
                                                  fontScale,
                                              fontWeight:
                                              FontWeight
                                                  .bold,
                                              color: isDarkMode
                                                  ? Colors
                                                  .white
                                                  : Colors
                                                  .black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                        height:
                                        verticalPadding *
                                            2),
                                    // Fix: Loop for multiple tenants
                                    ...tenants.map((tenant) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8.0),
                                      child: buildContactCard(
                                        "TENANT",
                                        tenant
                                            .tenant_name,
                                        tenant
                                            .tenant_phone_number,
                                        bgColor:
                                        Colors.green,
                                      ),
                                    )),
                                  ],
                                ),
                              );
                            }
                          },
                        ),


                        SizedBox(
                            height: screenHeight *
                                (isSmallScreen
                                    ? 0.1
                                    : 0.08)),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton
          .extended(
        onPressed: () {
          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    AddTenantUnderFutureProperty(
                      id: widget.id,
                      subId: widget.Subid,
                    ),
              ),
            );
          }
        },
        icon: Icon(Icons.person_add,
            color: Colors.white, size: 20 * fontScale),
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
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isDarkMode
              ? Colors.grey[900]
              : Colors.white,
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
                onPressed: isMainLoading || estateStatus.isEmpty || countdown > 0
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
                      : (upcomingStatus ==
                      "Live"
                      ? Colors.grey
                      : Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(
                      vertical: verticalPadding * 2),
                  elevation: 2,
                ),
                onPressed: isUpcomingLoading ||
                    upcomingStatus.isEmpty
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
                  upcomingStatus
                      == "Live"
                      ? "Remove"
                      : upcomingStatus
                      == "Book"
                      ? "Move to Upcoming"
                      : "Loading...",
                  style: TextStyle(
                    fontSize: (isSmallScreen
                        ? 11.0
                        : 13.0) *
                        fontScale,
                    fontWeight:
                    FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow:
                  TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}