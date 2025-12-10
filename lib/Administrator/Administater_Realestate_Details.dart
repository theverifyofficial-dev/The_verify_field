import 'dart:async';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Model.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Home_Screen_click/All_view_details.dart';
import '../Home_Screen_click/Preview_Image.dart';
import '../property_preview.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/realestateSlider.dart';
import 'Admin_future _property/Future_Property_Details.dart';
import 'Administator_Realestate.dart';

class Catid {
  final int id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeOfProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squareFit;
  final String maintance;
  final String parking;
  final String ageOfProperty;
  final String fieldWorkerAddress;
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
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final int subid;
  final String? sourceId; // NEW, nullable

  const Catid({
    required this.id,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeOfProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squareFit,
    required this.maintance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldWorkerAddress,
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
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
    required  this.sourceId,
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['P_id'] is int
          ? json['P_id']
          : int.tryParse(json['P_id']?.toString() ?? '0') ?? 0,
      propertyPhoto: json['property_photo']?.toString() ?? '',
      locations: json['locations']?.toString() ?? '',
      flatNumber: json['Flat_number']?.toString() ?? '',
      buyRent: json['Buy_Rent']?.toString() ?? '',
      residenceCommercial: json['Residence_Commercial']?.toString() ?? '',
      apartmentName: json['Apartment_name']?.toString() ?? '',
      apartmentAddress: json['Apartment_Address']?.toString() ?? '',
      typeOfProperty: json['Typeofproperty']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      showPrice: json['show_Price']?.toString() ?? '',
      lastPrice: json['Last_Price']?.toString() ?? '',
      askingPrice: json['asking_price']?.toString() ?? '',
      floor: json['Floor_']?.toString() ?? '',
      totalFloor: json['Total_floor']?.toString() ?? '',
      balcony: json['Balcony']?.toString() ?? '',
      squareFit: json['squarefit']?.toString() ?? '',
      maintance: json['maintance']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      fieldWorkerAddress: json['fieldworkar_address']?.toString() ?? '',
      roadSize: json['Road_Size']?.toString() ?? '',
      metroDistance: json['metro_distance']?.toString() ?? '',
      highwayDistance: json['highway_distance']?.toString() ?? '',
      mainMarketDistance: json['main_market_distance']?.toString() ?? '',
      meter: json['meter']?.toString() ?? '',
      ownerName: json['owner_name']?.toString() ?? '',
      ownerNumber: json['owner_number']?.toString() ?? '',
      currentDates: json['current_dates']?.toString() ?? '',
      availableDate: json['available_date']?.toString() ?? '',
      kitchen: json['kitchen']?.toString() ?? '',
      bathroom: json['bathroom']?.toString() ?? '',
      lift: json['lift']?.toString() ?? '',
      facility: json['Facility']?.toString() ?? '',
      furnishedUnfurnished: json['furnished_unfurnished']?.toString() ?? '',
      fieldWorkerName: json['field_warkar_name']?.toString() ?? '',
      liveUnlive: json['live_unlive']?.toString() ?? '',
      fieldWorkerNumber: json['field_workar_number']?.toString() ?? '',
      registryAndGpa: json['registry_and_gpa']?.toString() ?? '',
      loan: json['loan']?.toString() ?? '',
      longitude: json['Longitude']?.toString() ?? '',
      latitude: json['Latitude']?.toString() ?? '',
      videoLink: json['video_link']?.toString() ?? '',
      fieldWorkerCurrentLocation:
      json['field_worker_current_location']?.toString() ?? '',
      careTakerName: json['care_taker_name']?.toString() ?? '',
      careTakerNumber: json['care_taker_number']?.toString() ?? '',
      sourceId: json['source_id']?.toString(), // NEW
      subid: json['subid'] is int
          ? json['subid']
          : int.tryParse(json['subid']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "P_id": id,
      "property_photo": propertyPhoto,
      "locations": locations,
      "Flat_number": flatNumber,
      "Buy_Rent": buyRent,
      "Residence_Commercial": residenceCommercial,
      "Apartment_name": apartmentName,
      "Apartment_Address": apartmentAddress,
      "Typeofproperty": typeOfProperty,
      "Bhk": bhk,
      "show_Price": showPrice,
      "Last_Price": lastPrice,
      "asking_price": askingPrice,
      "Floor_": floor,
      "Total_floor": totalFloor,
      "Balcony": balcony,
      "squarefit": squareFit,
      "maintance": maintance,
      "parking": parking,
      "age_of_property": ageOfProperty,
      "fieldworkar_address": fieldWorkerAddress,
      "Road_Size": roadSize,
      "metro_distance": metroDistance,
      "highway_distance": highwayDistance,
      "main_market_distance": mainMarketDistance,
      "meter": meter,
      "owner_name": ownerName,
      "owner_number": ownerNumber,
      "current_dates": currentDates,
      "available_date": availableDate,
      "kitchen": kitchen,
      "bathroom": bathroom,
      "lift": lift,
      "Facility": facility,
      "furnished_unfurnished": furnishedUnfurnished,
      "field_warkar_name": fieldWorkerName,
      "live_unlive": liveUnlive,
      "field_workar_number": fieldWorkerNumber,
      "registry_and_gpa": registryAndGpa,
      "loan": loan,
      "Longitude": longitude,
      "Latitude": latitude,
      "video_link": videoLink,
      "field_worker_current_location": fieldWorkerCurrentLocation,
      "care_taker_name": careTakerName,
      "care_taker_number": careTakerNumber,
      "subid": subid,
    };
  }
}


class Administater_View_Details extends StatefulWidget {
  String idd;
  Administater_View_Details({super.key, required this.idd});

  @override
  State<Administater_View_Details> createState() => _Administater_View_DetailsState();
}

class _Administater_View_DetailsState extends State<Administater_View_Details> {
  @override
  void initState() {
    super.initState();
    _propertyFuture = fetchData(widget.idd);
    _galleryFuture = fetchCarouselData(widget.idd); // pass _id her
  }


  Future<List<Catid>> fetchData(String id) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_api_for_details_page_in_main_realestate.php?P_id=$id",
    );

    final response = await http.get(url);
    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }
    print('data response : ${response.body}');

    final decoded = json.decode(response.body);
    final dynamic raw = decoded is Map<String, dynamic> ? decoded['data'] : decoded;

    final List<Map<String, dynamic>> listResponse;
    if (raw is List) {
      listResponse = raw.map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (raw is Map) {
      listResponse = [Map<String, dynamic>.from(raw)];
    } else {
      listResponse = const [];
    }

    final properties = listResponse.map((e) => Catid.fromJson(e)).toList();

    return properties;
  }


  List<String> name = [];
  Future<List<Catid>>? _propertyFuture;
  Future<List<RealEstateSlider>>? _galleryFuture;

  Future<List<RealEstateSlider>> fetchCarouselData(String id) async {
    final url =
        'https://verifyserve.social/WebService4.asmx/show_multiple_image_in_main_realestate?subid=$id';

    final response = await http.get(Uri.parse(url));

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is String) {
        final innerData = json.decode(data);
        return (innerData as List)
            .map((item) => RealEstateSlider.fromJson(item))
            .toList();
      }
      return (data as List)
          .map((item) => RealEstateSlider.fromJson(item))
          .toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }


  void _refreshData() {
    setState(() {
      _propertyFuture = fetchData(widget.idd);
      _galleryFuture = fetchCarouselData(widget.idd);
      data = 'Refreshed Data at ${DateTime.now()}';

    });
  }


  String data = 'Initial Data';

  Catid? firstProperty;

  String formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date); // e.g., 02 Aug 2025
    } catch (e) {
      return "Invalid Date";
    }
  }

  Future<bool> _checkCallPermission() async {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      status = await Permission.phone.request();
    }
    if (status.isPermanentlyDenied) {
      // Open app settings
      openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  void _showCallConfirmation(BuildContext parentContext, String name, String number) {
    // Remove any non-digit characters from number
    String cleanNumber = number.replaceAll(RegExp(r'[^0-9+]'), '');

    showDialog(
      context: parentContext,
      builder: (dialogContext) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Theme.of(parentContext).dialogBackgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with icon
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.contact_phone_rounded,
                  size: 32,
                  color: Colors.blue[600],
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                'Contact $name',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(parentContext).textTheme.titleLarge?.color,
                ),
              ),

              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Choose how you want to connect',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(parentContext).textTheme.bodyMedium?.color,
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Call Button
                  Expanded(
                    child: _buildActionButton(
                      context: parentContext,
                      icon: Icons.call_rounded,
                      label: 'Call',
                      color: Colors.green,
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        bool granted = await _checkCallPermission();
                        if (!granted) {
                          _showPermissionSnackbar(parentContext);
                          return;
                        }
                        await _makePhoneCall(cleanNumber, parentContext);
                      },
                    ),
                  ),

                  const SizedBox(width: 16),

                  // WhatsApp Button
                  Expanded(
                    child: _buildActionButton(
                      context: parentContext,
                      icon: Icons.message_rounded,
                      label: 'WhatsApp',
                      color: const Color(0xFF25D366),
                      onPressed: () async {
                        Navigator.pop(dialogContext);
                        await _openWhatsApp(cleanNumber, parentContext);
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(parentContext).textTheme.bodyMedium?.color,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color.withOpacity(0.3), width: 1),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _makePhoneCall(String number, BuildContext context) async {
    try {
      bool? res = await FlutterPhoneDirectCaller.callNumber(number);
      if (res != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not initiate call')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Future<void> _openWhatsApp(String number, BuildContext context) async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('WhatsApp is not installed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening WhatsApp: ${e.toString()}')),
      );
    }
  }

  void _showPermissionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Call permission denied'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String _maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String firstPart = number.substring(0, 3);
    String lastPart = number.substring(number.length - 4);
    return '$firstPart****$lastPart';
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    // Responsive values
    final horizontalPadding = isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight = screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight = screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale = isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
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
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
          // Wait for futures to complete to reflect changes in UI
          if (_propertyFuture != null && _galleryFuture != null) {
            await Future.wait([
              _propertyFuture!,
              _galleryFuture!,
            ]);
          }
        },
        child: FutureBuilder<List<Catid>>(
          future: _propertyFuture,
          builder: (context, propertySnapshot) {
            if (propertySnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
                height: screenHeight * 0.4,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (propertySnapshot.hasError) {
              return SizedBox(
                height: screenHeight * 0.25,
                child: Center(child: Text('Error: ${propertySnapshot.error}')),
              );
            } else if (propertySnapshot.data == null || propertySnapshot.data!.isEmpty) {
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
              final prop = propertySnapshot.data!.first;
              firstProperty = prop;
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
                              child: (prop.videoLink != null && prop.videoLink!.isNotEmpty)
                                  ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                child: VideoPlayerWidget(videoUrl: prop.videoLink!),
                              )
                                  : GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => PropertyPreview(
                                        ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                                  child: CachedNetworkImage(
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
                            ),
                            // Back Button - already in AppBar, but if needed
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
                        // Price and Maintenance Chips
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            children: [
                              /// PRICE BOX
                              Expanded(
                                flex: 1,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: verticalPadding,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '₹ ${prop.showPrice}',
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 12),

                              /// MAINTENANCE BOX — FULL TEXT SHOW!
                              Expanded(
                                flex: 2,  // <- Maintenance ko zyada space mil jayega
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: horizontalPadding,
                                    vertical: verticalPadding,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.purple.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "${prop.maintance} Maintenance", // Full visible
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                      maxLines: 2,        // FULL TEXT SHOW
                                      overflow: TextOverflow.visible, // No cutting
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Property Info Section
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
                              LayoutBuilder(builder: (context, constraints) {

                                final available = constraints.maxWidth;
                                final spacing = chipSpacing * 1.5;
                                final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
                                final rawWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;
                                final chipWidth = rawWidth.clamp(64.0, available).toDouble();

                                final chipsData = <Map<String, dynamic>>[

                                  {'icon': Icons.install_desktop_sharp, 'text': 'Live Property Id: ${prop.id}', 'color': Colors.lightGreen},
                                  {'icon': Icons.bedroom_parent, 'text': prop.bhk ?? '', 'color': Colors.blue},
                                  {'icon': Icons.chair, 'text': prop.furnishedUnfurnished ?? '', 'color': Colors.purple},
                                  {'icon': Icons.apartment, 'text': prop.residenceCommercial ?? '', 'color': Colors.amber},
                                  {'icon': Icons.apartment_sharp, 'text': 'Building Id: ${prop.subid}', 'color': Colors.lightBlue},

                                  if ((prop.sourceId ?? '').isNotEmpty && prop.sourceId != 'null')
                                    {'icon': Icons.file_open, 'text': 'Building Flat Id: ${prop.sourceId}', 'color': Colors.deepOrange},

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
                                      child: _buildChip(
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

                        // Image Carousel
                        FutureBuilder<List<RealEstateSlider>>(
                          future: _galleryFuture,
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
                                    items: images.map((item) {
                                      return Builder(
                                        builder: (BuildContext context) {
                                          return GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => PropertyPreview(
                                                    ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.mImages}",
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 4),
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.mImages}",
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
                              _buildResponsiveInfoGrid(_getPropertyDetailsRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding), context, isSmallScreen),
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
                              if (_getBuildingFacilityRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: _getBuildingFacilityRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding),
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
                              if (prop.ownerNumber.isNotEmpty)
                                _buildContactCard("OWNER", prop.ownerName, prop.ownerNumber, bgColor: Colors.green, context: context, onCall: () => _showCallConfirmation(context, prop.ownerName, prop.ownerNumber)),
                              if (prop.careTakerNumber.isNotEmpty)
                                _buildContactCard("CARETAKER", prop.careTakerName, prop.careTakerNumber, bgColor: Colors.purple, context: context, onCall: () => _showCallConfirmation(context, prop.careTakerName, prop.careTakerNumber)),
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
                                children: _getAdditionalInfoRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding),
                              ),
                            ],
                          ),
                        ),
                        // Bottom spacing for bottom nav
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
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
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Administater_Future_Property_details(
                        buildingId: firstProperty!.subid.toString(),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  backgroundColor: Colors.purple.shade300,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.move_up_sharp, size: 22),
                label: const Text(
                  "Go to Building",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods adapted from upper code
  Widget _buildInfoRow(IconData icon, Color iconColor, String title, String value, bool isSmallScreen, bool isDarkMode) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();
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
  Widget _buildContactCard(String role, String name, String number, {Color? bgColor, required BuildContext context, required VoidCallback onCall}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = bgColor ?? Colors.blue;
    String maskedNumber = _maskPhoneNumber(number);
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
                onTap: onCall,
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
                            onTap: () => _openWhatsApp(number, context),
                            child: Icon(PhosphorIcons.whatsapp_logo_bold, color: Colors.green, size: isSmallScreen ? 20.0 : 24.0),
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
  Widget _buildSimpleInfoCard(String title, String value, IconData icon, Color cardColor, {bool isSmallScreen = false, bool isDarkMode = false}) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();
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
    return card;
  }
  Widget _buildChip(IconData icon, String text, Color color, BuildContext context) {
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
  Widget  _buildResponsiveInfoGrid(List<Widget> infoRows, BuildContext context, bool isSmallScreen) {
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
              SizedBox(width: isSmallScreen ? 8.0 : 12.0),
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
  List<Widget> _getPropertyDetailsRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding) {
    List<Widget> rows = [];
    if ((prop.metroDistance ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.train, Colors.orange, "Metro Station", prop.metroDistance, isSmallScreen, isDarkMode));
    if ((prop.mainMarketDistance ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.store, Colors.purple, "Market Distance", prop.mainMarketDistance, isSmallScreen, isDarkMode));
    if ((prop.registryAndGpa ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.document_scanner, Colors.purple, "Registry & GPA", prop.registryAndGpa, isSmallScreen, isDarkMode));
    if ((prop.typeOfProperty ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.category, Colors.deepOrange, "Type of Property", prop.typeOfProperty, isSmallScreen, isDarkMode));
    if ((prop.availableDate ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.calendar_today, Colors.blue, "Available From", formatDate(prop.availableDate), isSmallScreen, isDarkMode));

    if ((prop.floor ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.apartment, Colors.red, "Floor", prop.floor, isSmallScreen, isDarkMode));

    if ((prop.highwayDistance ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.vaccines, Colors.red, "Highway Distance", prop.highwayDistance, isSmallScreen, isDarkMode));
    if ((prop.roadSize ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.straighten, Colors.teal, "Road Size", "${prop.roadSize} Feet", isSmallScreen, isDarkMode));
    final floorText = (prop.floor ?? '').isNotEmpty && (prop.totalFloor ?? '').isNotEmpty
        ? "${prop.floor}/${prop.totalFloor}"
        : (prop.floor ?? '').isNotEmpty
        ? prop.floor
        : (prop.totalFloor ?? '').isNotEmpty
        ? prop.totalFloor
        : '';

    if ((prop.loan ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.balance, Colors.purple, "Loan", prop.loan, isSmallScreen, isDarkMode));
    if ((prop.flatNumber ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.format_list_numbered, Colors.green, "Flat Number", prop.flatNumber, isSmallScreen, isDarkMode));

    if ((prop.ageOfProperty ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.real_estate_agent, Colors.green, "Age of property", prop.ageOfProperty, isSmallScreen, isDarkMode));

    if ((prop.squareFit ?? '').isNotEmpty)
      rows.add(_buildInfoRow(Icons.square_foot, Colors.black, "Square Fit", prop.squareFit, isSmallScreen, isDarkMode));


    //
    // if ((prop.id ?? '').isNotEmpty)
    //   rows.add(_buildInfoRow(Icons.location_on, Colors.pink, "Apartment Address", prop.id, isSmallScreen, isDarkMode));
    // Add ID chips
    // rows.add(
    //   Padding(
    //     padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
    //     child: Wrap(
    //       spacing: 8,
    //       runSpacing: 8,
    //       children: [
    //         _buildChip(Icons.install_desktop_sharp, "Live Property Id : ${prop.id}", Colors.lightGreen, context),
    //         _buildChip(Icons.apartment_sharp, "Building Id : ${prop.subid}", Colors.lightBlue, context),
    //         if (prop.sourceId != null) _buildChip(Icons.file_open, "Building Flat Id : ${prop.sourceId}", Colors.deepOrange, context),
    //       ],
    //     ),
    //   ),
    //);
    return rows;
  }
  List<Widget> _getBuildingFacilityRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding) {
    List<Widget> rows = [];
    if ((prop.facility ?? '').isNotEmpty) {
      rows.add(_buildInfoRow(Icons.local_hospital, Colors.amber, "Building Facility", prop.facility, isSmallScreen, isDarkMode));
    }
    final double verticalPadding = isSmallScreen ? 2.0 : 4.0;
    // Row 1: Kitchen and Bathroom
    List<Widget> row1Cards = [];
    if ((prop.kitchen ?? '').isNotEmpty) {
      row1Cards.add(_buildSimpleInfoCard("Kitchen", prop.kitchen, Icons.kitchen, Colors.pink, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    if ((prop.bathroom ?? '').isNotEmpty) {
      row1Cards.add(_buildSimpleInfoCard("Bathroom", prop.bathroom, Icons.bathroom, Colors.lightBlue, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
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
      row2Cards.add(_buildSimpleInfoCard("Parking", prop.parking, Icons.local_parking, Colors.purple, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    if ((prop.lift ?? '').isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard("Lift", "${prop.lift.toLowerCase() == 'yes' ? 'Available' : 'Not Available'}", Icons.elevator, Colors.red, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }

    if ((prop.balcony ?? '').isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard("Balcony", prop.balcony, Icons.balcony, Colors.purple, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }

    if ((prop.meter ?? '').isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard("Meter", "${prop.meter}/- per unit.", Icons.electric_meter, Colors.blue, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    if (row2Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row2Cards, context, verticalPadding),
      ));
    }
    return rows;
  }
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
  List<Widget> _getAdditionalInfoRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding) {
    List<Widget> rows = [];
    // Current Date
    if ((prop.currentDates ?? '').isNotEmpty) {
      rows.add(_buildSimpleInfoCard("Current Date", formatDate(prop.currentDates), Icons.date_range, Colors.indigo, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode));
    }
    // Asking Price and Last Price Row
    List<Widget> priceWidgets = [];
    // if ((prop.askingPrice ?? '').isNotEmpty) {
    //   priceWidgets.add(Expanded(
    //     child: _buildSimpleInfoCard("Asking Price", prop.askingPrice, Icons.currency_rupee, Colors.green, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
    //   ));
    // }
    // if ((prop.lastPrice ?? '').isNotEmpty) {
    //   if (priceWidgets.isNotEmpty) {
    //     priceWidgets.add(SizedBox(width: isSmallScreen ? 6.0 : 8.0));
    //   }
    //   priceWidgets.add(Expanded(
    //     child: _buildSimpleInfoCard("Last Price", prop.lastPrice, Icons.currency_rupee, Colors.pink, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
    //   ));
    // }
    if (priceWidgets.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
          child: Row(children: priceWidgets),
        ),
      );
    }
    // Video Link
    if ((prop.videoLink ?? '').isNotEmpty) {
      rows.add(
        GestureDetector(
          onTap: () => _launchVideo(prop.videoLink, context),
          child: _buildSimpleInfoCard("Video Link", prop.videoLink, Icons.video_library, Colors.lime, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
        ),
      );
    }
    // Fieldworker Info Card
    rows.add(_buildFieldworkerInfoCard(prop, context, isSmallScreen, isDarkMode));
    return rows;
  }
  Widget _buildFieldworkerInfoCard(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode) {
    final String name = prop.fieldWorkerName ?? '';
    final String number = prop.fieldWorkerNumber ?? '';
    final String address = prop.fieldWorkerAddress ?? '';
    final String location = prop.fieldWorkerCurrentLocation ?? '';
    if (name.isEmpty && number.isEmpty && address.isEmpty && location.isEmpty) {
      return const SizedBox.shrink();
    }
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
              onTap: () => _showCallConfirmation(context, name, number),
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
                        _maskPhoneNumber(number),
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
                          onTap: () => _openWhatsApp(number, context),
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
              child: _buildSimpleInfoCard("Fieldworker Address", address, Icons.location_on, Colors.lime, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
            ),
          // Current Location (if available)
          if (location.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: _buildSimpleInfoCard("Fieldworker Location", location, Icons.my_location, Colors.lightBlue, isSmallScreen: isSmallScreen, isDarkMode: isDarkMode),
            ),
        ],
      ),
    );
  }

  Future<void> _launchVideo(String url, BuildContext context) async {
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

  String _formatDate(String? dateString) {
    return formatDate(dateString);
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;
  const VideoPlayerWidget({super.key, required this.videoUrl});
  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}
class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        isLive: false,
        forceHD: false,
        disableDragSeek: false,
        hideControls: true,
        hideThumbnail: false,
        loop: false,
        showLiveFullscreenButton: false,
      ),
    );
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // code to run when exiting full screen, if any
      },
      builder: (context, player) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.25,
            width: double.infinity,
            child: player,
          ),
        );
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.redAccent,
        onReady: () {
          print("Player is ready.");
        },
      ),
    );
  }
}
void openWhatsApp(String phoneNumber) {
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