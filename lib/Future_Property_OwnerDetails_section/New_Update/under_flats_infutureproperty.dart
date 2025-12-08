import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/realestateSlider.dart';
import '../../property_preview.dart';
import 'Edit_flat.dart';
import 'add_image_under_futureproperty.dart';
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

class UnderFlatFuturePropertyController extends GetxController {
  final String id;
  final String subid;

  UnderFlatFuturePropertyController({required this.id, required this.subid});

  var isMainLoading = false.obs;
  var isUpcomingLoading = false.obs;
  var property = Rxn<Property>();
  var estateStatus = 'Book'.obs; // Default to 'Book' to avoid loading state
  var upcomingStatus = 'Book'.obs; // Default to 'Book' to avoid loading state

  late Rx<Future<List<RealEstateSlider1>>> sliderFuture;
  late Rx<Future<List<Property>>> propertyFuture;
  late Rx<Future<List<Catid1>>> catidFuture;

  @override
  void onInit() {
    super.onInit();
    loadProperty();
    loadAllData();
    fetchData1();
    fetchData1Status(); // Added this to set status initially
  }

  Future<List<RealEstateSlider1>> fetchCarouselData() async {
    final response = await http.get(Uri.parse(
        'https://verifyserve.social/WebService4.asmx/display_flat_in_future_property_multiple_images?subid=$subid')).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => RealEstateSlider1(rimg: item['images'] ?? '')).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<List<Property>> fetchData() async {
    var url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/detail_page_for_future_property_under_flat.php?P_id=$id");

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
        "https://verifyserve.social/WebService4.asmx/display_tenant_in_future_property?sub_id=$subid");
    final response = await http.get(url).timeout(const Duration(seconds: 30));

    if (response.statusCode == 200) {
      List listresponce = json.decode(response.body);
      return listresponce.map((data) => Catid1.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> fetchData1Status() async {
    try {
      final result = await fetchData();
      if (result.isEmpty) {
        estateStatus.value = 'Book';
        upcomingStatus.value = 'Book';
        return;
      }
      final propertyData = result.firstWhere(
            (item) => item.subid == subid,
        orElse: () => result.first,
      );

      estateStatus.value = propertyData.liveUnlive.isEmpty ? 'Book' : propertyData.liveUnlive;
      upcomingStatus.value = propertyData.demoLiveUnlive.isEmpty ? 'Book' : propertyData.demoLiveUnlive;
    } catch (e) {
      debugPrint("Error fetching data: $e");
      estateStatus.value = 'Book';
      upcomingStatus.value = 'Book';
    }
  }

  Future<void> loadAllData() async {
    sliderFuture = fetchCarouselData().obs;
    propertyFuture = fetchData().obs;
    catidFuture = fetchData1().obs;
  }

  Future<void> loadProperty() async {
    try {
      final list = await fetchData();
      if (list.isNotEmpty) {
        property.value = list.first;
      }
    } catch (e) {
      debugPrint("Error loading property: $e");
    }
  }

  Future<void> refreshData() async {
    await loadAllData();
    await fetchData1Status();
  }

  Future<void> handleMenuItemClick(String value, BuildContext context) async {
    try {
      if (value == 'Edit Flat') {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => EditFlat(id: id)),
          );
        }
      }
      if (value == 'Add Flat Images') {
        if (context.mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => Futureproipoerty_FileUploadPage(idd: id)),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Navigation error: $e')),
        );
      }
    }
  }

  Future<void> openWhatsApp(String number, BuildContext context) async {
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
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('WhatsApp is not installed')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
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
      // For iOS or others fallback to url_launcher or show message
      print('WhatsApp open only supported on Android with this method');
    }
  }

  // UI Helper Methods (moved to controller but used in view)
  // Note: These are now static or can be called from controller, but for simplicity, kept as instance methods

  Widget buildInfoRow(IconData icon, Color iconColor, String title, String value, BuildContext context) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final Color cardColor = Colors.white;
    final Color borderColor = isDarkMode ? Colors.grey.shade700.withOpacity(0.2) : Colors.grey.shade200;
    final Color titleColor = isDarkMode ? Colors.black87 : Colors.grey.shade700;
    final Color valueColor = isDarkMode ? Colors.black87 : Colors.black87;
    final Color iconBg = iconColor.withOpacity(0.10);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: isDarkMode
            ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]
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
            child: Icon(icon, size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
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

  Widget buildContactCard(String role, String name, String number, {Color? bgColor, required BuildContext context}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = bgColor ?? Colors.blue;
    String maskedNumber = maskPhoneNumber(number);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
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
                    role == "OWNER" ? Icons.person
                        : role == "CARETAKER" ? Icons.support_agent
                        : role == "FIELD WORKER" ? Icons.engineering
                        : role == "TENANT" ? Icons.people
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
                onTap: () => showCallConfirmationDialog(role, name, number, context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
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
                            onTap: () => openWhatsApp(number, context),
                            child: Icon(PhosphorIcons.whatsapp_logo_bold, color: cardColor, size: isSmallScreen ? 20.0 : 24.0),
                          ),
                          SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                          Icon(Icons.call, color: cardColor, size: isSmallScreen ? 20.0 : 24.0),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
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

  Widget buildSimpleInfoCard(String title, String value, IconData icon, Color cardColor, {VoidCallback? onTap, required BuildContext context}) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Widget card = Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
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


  // dart
// Responsive helper to layout cards with wrapping so long text can wrap and be visible
  Widget _buildAdaptiveRows(List<Widget> cards, BuildContext context, double verticalPadding) {
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxWidth;
      final spacing = MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0;
      final runSpacing = verticalPadding;
      // Decide how many items fit horizontally
      final int itemsPerRow = available >= 800
          ? 4
          : available >= 520
          ? 3
          : 2;
      final itemWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

      // If only one card, give it full width
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

// Replace the original Row1 / Row2 building with this updated logic
  List<Widget> getBuildingFacilityRows(Property prop, BuildContext context) {
    List<Widget> rows = [];
    if ((prop.facility ?? '').isNotEmpty) {
      rows.add(buildInfoRow(Icons.local_hospital, Colors.amber, "Building Facility", prop.facility, context));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final double verticalPadding = isSmallScreen ? 2.0 : 4.0;

    // Row 1: Kitchen and Bathroom (use cards list, no Expanded here)
    List<Widget> row1Cards = [];
    if ((prop.kitchen ?? '').isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard("Kitchen", prop.kitchen, Icons.kitchen, Colors.pink, context: context));
    }
    if ((prop.bathroom ?? '').isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard("Bathroom", prop.bathroom, Icons.bathroom, Colors.lightBlue, context: context));
    }
    if (row1Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row1Cards, context, verticalPadding),
      ));
    }

    // Row 2: Parking, Lift, and Meter
    List<Widget> row2Cards = [];
    if ((prop.parking ?? '').isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard("Parking", prop.parking, Icons.local_parking, Colors.purple, context: context));
    }
    if ((prop.lift ?? '').isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard("Lift", prop.lift, Icons.elevator, Colors.red, context: context));
    }
    if ((prop.meter ?? '').isNotEmpty) {
      // Ensure long meter/commercial names can wrap by using the same adaptive layout
      row2Cards.add(buildSimpleInfoCard("Meter", prop.meter, Icons.electric_meter, Colors.blue, context: context));
    }
    if (row2Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row2Cards, context, verticalPadding),
      ));
    }

    return rows;
  }



  List<Widget> getFlatFacilityRows(Property prop, BuildContext context) {
    List<Widget> rows = [];
    if ((prop.apartmentName ?? '').isNotEmpty) {
      rows.add(buildInfoRow(Icons.local_hospital, Colors.amber, "Flat Facility", prop.facility, context));
    }

    return rows;
  }


  Widget buildFieldworkerInfoCard(Property prop, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final String name = prop.fieldWarkarName ?? '';
    final String number = prop.fieldWorkarNumber ?? '';
    final String address = prop.fieldworkarAddress ?? '';
    final String location = prop.fieldWorkerCurrentLocation ?? '';
    final String asking = prop.mainMarketDistance ??  '';
    if (name.isEmpty && number.isEmpty && address.isEmpty && location.isEmpty) {
      return const SizedBox.shrink();
    }

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = Colors.blue;
    final Color bgColor = Colors.blue;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Role and Name
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
          // Number (if available)
          if (number.isNotEmpty)
            GestureDetector(
              onTap: () => showCallConfirmationDialog("FIELD WORKER", name, number, context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: bgColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          onTap: () => openWhatsApp(number, context),
                          child: Icon(PhosphorIcons.whatsapp_logo_bold, color: Colors.green, size: isSmallScreen ? 20.0 : 24.0),
                        ),
                        SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                        Icon(Icons.call, color: bgColor, size: isSmallScreen ? 20.0 : 24.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Address (if available)
          if (address.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: buildSimpleInfoCard("Fieldworker Address", address, Icons.location_on, Colors.lime, context: context),
            ),
          // Current Location (if available)
          if (location.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: buildSimpleInfoCard("Fieldworker Location", location, Icons.my_location, Colors.lightBlue, context: context),
            ),

        ],
      ),
    );
  }

  void showCallConfirmationDialog(String role, String name, String number, BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

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

  Widget buildResponsiveInfoGrid(List<Widget> infoRows, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        if (screenWidth > 350) {
          final half = (infoRows.length / 2).ceil();
          final leftColumn = infoRows.sublist(0, half);
          final rightColumn = infoRows.length > half ? infoRows.sublist(half) : <Widget>[];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: leftColumn,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8.0 : 12.0),
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

  List<Widget> getPropertyDetailsRows(Property prop, BuildContext context) {
    List<Widget> rows = [];
    if ((prop.metroDistance ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.train, Colors.orange, "Metro Station", prop.metroDistance, context));


    if ((prop.mainMarketDistance ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.store, Colors.purple, "Market Distance", prop.mainMarketDistance, context));

    if ((prop.registryAndGpa ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.document_scanner, Colors.purple, "Registry & GPA", prop.registryAndGpa, context));




    if ((prop.typeofProperty ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.category, Colors.deepOrange, "Type of Property", prop.typeofProperty, context));
    if ((prop.availableDate ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.calendar_today, Colors.blue, "Available From", prop.availableDate, context));

    if ((prop.highwayDistance ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.directions_car, Colors.red, "Highway Distance", prop.highwayDistance, context));

    if ((prop.roadSize ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.straighten, Colors.teal, "Road Size", "${prop.roadSize} Feet", context));
    final floorText = (prop.floor ?? '').isNotEmpty && (prop.totalFloor ?? '').isNotEmpty
        ? "${prop.floor}/${prop.totalFloor}"
        : (prop.floor ?? '').isNotEmpty
        ? prop.floor
        : (prop.totalFloor ?? '').isNotEmpty
        ? prop.totalFloor
        : '';

    if ((prop.loan ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.balance, Colors.purple, "Loan", prop.loan, context));

    if ((prop.flatNumber ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.format_list_numbered, Colors.green, "Flat Number", prop.flatNumber, context));


    if ((prop.apartmentAddress ?? '').isNotEmpty)
      rows.add(buildInfoRow(Icons.location_on, Colors.pink, "Apartment Address", prop.apartmentAddress, context));


    return rows;
  }

  List<Widget> getAdditionalInfoRows(Property prop, BuildContext context) {
    List<Widget> rows = [];
    // Current Date
    if ((prop.currentDates ?? '').isNotEmpty) {
      rows.add(buildSimpleInfoCard("Current Date", prop.currentDates, Icons.date_range, Colors.indigo, context: context));
    }

    // Asking Price and Last Price Row
    List<Widget> priceWidgets = [];
    if ((prop.askingPrice ?? '').isNotEmpty) {
      priceWidgets.add(Expanded(
        child: buildSimpleInfoCard("Asking Price", prop.askingPrice, Icons.currency_rupee, Colors.green, context: context),
      ));
    }
    if ((prop.lastPrice ?? '').isNotEmpty) {
      if (priceWidgets.isNotEmpty) {
        priceWidgets.add(SizedBox(width: MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0));
      }
      priceWidgets.add(Expanded(
        child: buildSimpleInfoCard("Last Price", prop.lastPrice, Icons.currency_rupee, Colors.pink, context: context),
      ));
    }
    if (priceWidgets.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 360 ? 2.0 : 4.0),
          child: Row(children: priceWidgets),
        ),
      );
    }
    // Video Link
    if ((prop.videoLink ?? '').isNotEmpty) {
      rows.add(
        GestureDetector(
          onTap: () => launchVideo(prop.videoLink, context),
          child: buildSimpleInfoCard("Video Link", prop.videoLink, Icons.video_library, Colors.lime, onTap: () {}, context: context),
        ),
      );
    }
    // Fieldworker Info Card
    rows.add(buildFieldworkerInfoCard(prop, context));
    return rows;
  }

  Future<void> launchVideo(String url, BuildContext context) async {
    final Uri videoUri = Uri.parse(url);
    if (await canLaunchUrl(videoUri)) {
      await launchUrl(videoUri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cannot launch video")),
        );
      }
    }
  }

  Widget buildChip(IconData icon, String text, Color color, BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6.0 : 8.0, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmallScreen ? 14.0 : 16.0, color: color),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSmallScreen ? 9.0 : 10.0,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Button Action Methods
  Future<void> handleMainButtonAction(BuildContext context) async {
    isMainLoading.value = true;
    try {
      final url = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/move_to_main_realestae.php");

      if (estateStatus.value == "Book") {
        final updateBody = {"action": "update", "P_id": id};
        final updateResponse = await http.post(url, body: updateBody).timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": id};
        final moveResponse = await http.post(url, body: copyBody).timeout(const Duration(seconds: 30));

        if (updateResponse.statusCode == 200 && moveResponse.statusCode == 200) {
          final now = DateTime.now();
          final formattedNow = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          final editDateBody = {
            "action": "edit_date",
            "source_id": id,
            "date_for_target": formattedNow,
          };
          await http.post(url, body: editDateBody).timeout(const Duration(seconds: 30));

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Property moved to Live successfully!", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            );
          }
          estateStatus.value = "Live";
        }
      } else if (estateStatus.value == "Live") {
        final reupdateBody = {"action": "reupdate", "P_id": id};
        await http.post(url, body: reupdateBody).timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "source_id": id};
        final deleteResponse = await http.post(url, body: deleteBody).timeout(const Duration(seconds: 30));

        if (deleteResponse.statusCode == 200) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Property UnLived successfully!", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue,
              ),
            );
          }
          estateStatus.value = "Book";
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      // Always reset loading, even if context not mounted, but since obs, it's fine
      isMainLoading.value = false;
    }
  }

  Future<String?> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );

    if (picked == null) return null;
    return "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
  }

  Future<void> handleUpcomingButtonAction(BuildContext context) async {
    isUpcomingLoading.value = true;
    try {
      final upcomingUrl = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php");
      if (upcomingStatus.value == "Book") {
        final selectedDate = await _pickDate(context);

        if (selectedDate == null) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("No date selected!"),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // 1️⃣ UPDATE DATE BEFORE MOVE
        final dateUpdateBody = {
          "action": "update_available_date",
          "P_id": id,
          "date": selectedDate,
        };
        final dateUpdateResponse = await http.post(upcomingUrl, body: dateUpdateBody).timeout(const Duration(seconds: 30));

        if (dateUpdateResponse.statusCode != 200) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Failed to update date!"),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Successfully updated with date"),
                backgroundColor: Colors.green,
              ),
            );
          }
        }

        // 2️⃣ CONTINUE WITH MOVE PROCESS
        final updateBody = {"action": "update", "P_id": id};
        final updateResponse = await http.post(upcomingUrl, body: updateBody).timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": id};
        final moveResponse = await http.post(upcomingUrl, body: copyBody).timeout(const Duration(seconds: 30));

        if (updateResponse.statusCode == 200 && moveResponse.statusCode == 200) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Moved to Upcoming successfully!", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.orange,
              ),
            );
          }
          upcomingStatus.value = "Live";
        }
      } else if (upcomingStatus.value == "Live") {
        final reupdateBody = {"action": "reupdate", "P_id": id};
        await http.post(upcomingUrl, body: reupdateBody).timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "subid": subid};
        final deleteResponse = await http.post(upcomingUrl, body: deleteBody).timeout(const Duration(seconds: 30));

        if (deleteResponse.statusCode == 200) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Removed from Upcoming successfully!", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue,
              ),
            );
          }
          upcomingStatus.value = "Book";
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      // Always reset loading
      isUpcomingLoading.value = false;
    }
  }
}

class underflat_futureproperty extends GetView<UnderFlatFuturePropertyController> {
  final String id;
  final String Subid;

  const underflat_futureproperty({super.key, required this.id, required this.Subid});

  @override
  Widget build(BuildContext context) {
    Get.put(UnderFlatFuturePropertyController(id: id, subid: Subid));
    final controller = Get.find<UnderFlatFuturePropertyController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Responsive values
    final horizontalPadding = isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight = screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight = screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale = isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: RefreshIndicator(
        onRefresh: controller.refreshData,
        child: Obx(() => FutureBuilder<List<Property>>(
          future: controller.propertyFuture.value,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: screenHeight * 0.4,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
              return SizedBox(
                height: screenHeight * 0.25,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 50 * fontScale, color: Colors.grey),
                      SizedBox(height: verticalPadding * 2),
                      Text("No Property Found!",
                          style: TextStyle(fontSize: 16 * fontScale, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            } else {
              final prop = snapshot.data![0];
              controller.property.value = prop;
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        // Hero Image Section
                        Stack(
                          children: [
                            Container(
                              height: imageHeight,
                              width: double.infinity,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PropertyPreview(
                                        ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  key: ValueKey('${prop.pId}_${prop.propertyPhoto}'), // Unique key to prevent caching issues
                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: Colors.grey[300],
                                    child: Center(child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.error, size: 50 * fontScale, color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                            // Back Button
                            Positioned(
                              top: MediaQuery.of(context).padding.top + (isSmallScreen ? 4.0 : 8.0),
                              left: horizontalPadding,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  PhosphorIcons.caret_left_bold,
                                  color: Colors.white,
                                  size: isSmallScreen ? 24.0 : 28.0,
                                ),
                              ),
                            ),
                            // Menu Button
                            Positioned(
                              top: MediaQuery.of(context).padding.top + (isSmallScreen ? 4.0 : 8.0),
                              right: horizontalPadding,
                              child: PopupMenuButton<String>(
                                onSelected: (value) => controller.handleMenuItemClick(value, context),
                                itemBuilder: (BuildContext context) {
                                  return {'Edit Flat', 'Add Flat Images'}.map((String choice) {
                                    return PopupMenuItem<String>(
                                      value: choice,
                                      child: Text(choice,
                                          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                                    );
                                  }).toList();
                                },
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.white,
                                  size: isSmallScreen ? 24.0 : 28.0,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: isSmallScreen ? 8.0 : 16.0,
                              right: horizontalPadding,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Center(
                                  child: Text(
                                    prop.buyRent,
                                    style: TextStyle(
                                      fontSize: (isSmallScreen ? 16.0 : 18.0) * fontScale,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: verticalPadding * 2),
                        // Price and Buy/Rent Chips - Fixed uneven sizing
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      prop.showPrice,
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: horizontalPadding * 8.0),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${prop.maintance} Maintance",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Property Info Section - Reduced indentation for location and chips

                        // dart
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: verticalPadding * 1.5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                prop.locations,
                                style: TextStyle(
                                  fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                              SizedBox(height: verticalPadding * 1.2),
                              // Responsive chips using LayoutBuilder
                              LayoutBuilder(builder: (context, constraints) {
                                final available = constraints.maxWidth;
                                final spacing = chipSpacing * 1.5;
                                // choose items per row by available width
                                final int itemsPerRow = available >= 800
                                    ? 4
                                    : available >= 520
                                    ? 3
                                    : 2;
                                final chipWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

                                final chipsData = [
                                  {'icon': Icons.bedroom_parent, 'text': prop.bhk, 'color': Colors.blue},
                                  {'icon': Icons.kitchen, 'text': prop.kitchen, 'color': Colors.green},
                                  {'icon': Icons.chair, 'text': prop.furnishedUnfurnished, 'color': Colors.purple},
                                  {'icon': Icons.apartment, 'text': prop.residenceCommercial, 'color': Colors.amber},
                                ].where((e) => (e['text'] as String).isNotEmpty).toList();

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: verticalPadding * 1.2,
                                  children: chipsData.map((e) {
                                    return SizedBox(
                                      width: chipWidth,
                                      child: controller.buildChip(
                                        e['icon'] as IconData,
                                        "${e['text']}",
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


                        // Image Carousel
                        FutureBuilder<List<RealEstateSlider1>>(
                          future: controller.sliderFuture.value,
                          builder: (context, sliderSnapshot) {
                            if (sliderSnapshot.connectionState == ConnectionState.waiting) {
                              return SizedBox(height: carouselHeight * 0.4);
                            }
                            if (sliderSnapshot.hasError || sliderSnapshot.data == null || sliderSnapshot.data!.isEmpty) {
                              return const SizedBox();
                            }
                            final images = sliderSnapshot.data!;
                            final viewportFraction = isSmallScreen ? 0.85 : (isTablet ? 0.7 : 0.8);
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CarouselSlider(
                                    options: CarouselOptions(
                                      height: carouselHeight,
                                      autoPlay: true,
                                      enlargeCenterPage: false,
                                      autoPlayInterval: const Duration(seconds: 3),
                                      viewportFraction: viewportFraction,
                                    ),
                                    items: images.asMap().entries.map((entry) {
                                      final index = entry.key;
                                      final item = entry.value;
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => PropertyPreview(
                                                    ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  key: ValueKey('${prop.pId}_carousel_${index}_${item.rimg}'), // Unique key to prevent caching issues
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.rimg}",
                                                  fit: BoxFit.cover,
                                                  width: double.infinity,
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
                        // Property Details Section
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Property Details",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              controller.buildResponsiveInfoGrid(controller.getPropertyDetailsRows(prop, context), context),
                            ],
                          ),
                        ),
                        // Building Facility Section
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_hospital, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Building Facility",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              if (controller.getBuildingFacilityRows(prop, context).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: controller.getBuildingFacilityRows(prop, context),
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_hospital, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Flat Facility",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              if (controller.getFlatFacilityRows(prop, context).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: controller.getFlatFacilityRows(prop, context),
                                )
                              else
                                const SizedBox.shrink(),
                            ],
                          ),
                        ),
                        // Contact Information Section
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.contact_page, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Contact Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding * 2),
                              controller.buildContactCard("OWNER", prop.ownerName, prop.ownerNumber, bgColor: Colors.green, context: context),
                              controller.buildContactCard("CARETAKER", prop.careTakerName, prop.careTakerNumber, bgColor: Colors.purple, context: context),
                            ],
                          ),
                        ),
                        // Additional Information Section
                        Container(
                          margin: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Additional Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller.getAdditionalInfoRows(prop, context),
                              ),
                            ],
                          ),
                        ),
                        // Tenant Information
                        FutureBuilder<List<Catid1>>(
                          future: controller.catidFuture.value,
                          builder: (context, tenantSnapshot) {
                            if (tenantSnapshot.connectionState == ConnectionState.waiting) {
                              return Padding(
                                padding: EdgeInsets.all(horizontalPadding),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            } else if (tenantSnapshot.hasError || tenantSnapshot.data == null || tenantSnapshot.data!.isEmpty) {
                              return const SizedBox();
                            } else {
                              final tenant = tenantSnapshot.data![0];
                              return Container(
                                margin: EdgeInsets.all(horizontalPadding),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                      child: Row(
                                        children: [
                                          Icon(Icons.people, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                          SizedBox(width: horizontalPadding),
                                          Text(
                                            "Tenant Information",
                                            style: TextStyle(
                                              fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                              fontWeight: FontWeight.bold,
                                              color: isDarkMode ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: verticalPadding * 2),
                                    controller.buildContactCard("TENANT", tenant.tenant_name, tenant.tenant_phone_number, bgColor: Colors.green, context: context),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                        // Bottom spacing for FAB - Reduced and made responsive
                        SizedBox(height: screenHeight * (isSmallScreen ? 0.1 : 0.08)),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        )),
      ),
      // Floating Action Button - Fixed navigation to AddTenantUnderFutureProperty
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (context.mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddTenantUnderFutureProperty(
                  id: id,
                  subId: Subid,
                ),
              ),
            );
          }
        },
        icon: Icon(Icons.person_add, color: Colors.white, size: 20 * fontScale),
        label: Text("Add Tenant", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14 * fontScale)),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      // Bottom Navigation Bar with Action Buttons
      bottomNavigationBar: Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isMainLoading.value
                      ? Colors.grey
                      : (controller.estateStatus.value == "Live"
                      ? Colors.grey
                      : controller.estateStatus.value == "Book"
                      ? Colors.red
                      : Colors.green),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  elevation: 2,
                ),
                onPressed: controller.isMainLoading.value || controller.estateStatus.value.isEmpty
                    ? null
                    : () => controller.handleMainButtonAction(context),
                child: controller.isMainLoading.value
                    ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  controller.estateStatus.value == "Live"
                      ? "Rent out / Book"
                      : controller.estateStatus.value == "Book"
                      ? "Move to Live"
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
            SizedBox(width: horizontalPadding),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isUpcomingLoading.value
                      ? Colors.grey
                      : (controller.upcomingStatus.value == "Live" ? Colors.grey : Colors.orange),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  elevation: 2,
                ),
                onPressed: controller.isUpcomingLoading.value || controller.upcomingStatus.value.isEmpty
                    ? null
                    : () => controller.handleUpcomingButtonAction(context),
                child: controller.isUpcomingLoading.value
                    ? SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
                    : Text(
                  controller.upcomingStatus.value == "Live"
                      ? "Remove"
                      : controller.upcomingStatus.value == "Book"
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
      )),
    );
  }
}