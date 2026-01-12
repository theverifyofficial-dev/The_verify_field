import 'dart:convert';
import 'dart:ui';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
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
import 'package:verify_feild_worker/property_preview.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../Add_Rented_Flat/Book_Flat_For_FieldWorker.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/realestateSlider.dart';
import 'Add_image_under_property.dart';
import 'Add_images_in_Realestate.dart';
import 'Delete_Image.dart';
import 'Edit_Page_Realestate.dart';
import 'Add_multi_image_in_Realestate.dart';
import 'Edit_Property_SecondPage.dart';
import 'Real-Estate.dart';
import 'package:xml/xml.dart' as xml;
import 'Reverse_in_Futureproperty.dart';
import 'Update_realEstate_form.dart';
class Catid {
  final int id;
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
  final String maintenance;
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
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishing;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String fieldWorkerCurrentLocation;
  final String caretakerName;
  final String caretakerNumber;
  final String longitude;
  final String latitude;
  final String videoLink;
  final int subid;
  final String? sourceId; // nullable
  Catid({
    required this.id,
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
    required this.maintenance,
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
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishing,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.fieldWorkerCurrentLocation,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.subid,
    this.sourceId,
  });
  static String _s(dynamic v) => v?.toString() ?? '';
  static int _i(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;
  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: _i(json['P_id']),
      propertyPhoto: _s(json['property_photo']),
      locations: _s(json['locations']),
      flatNumber: _s(json['Flat_number']),
      buyRent: _s(json['Buy_Rent']),
      residenceCommercial: _s(json['Residence_Commercial']),
      apartmentName: _s(json['Apartment_name']),
      apartmentAddress: _s(json['Apartment_Address']),
      typeofProperty: _s(json['Typeofproperty']),
      bhk: _s(json['Bhk']),
      showPrice: _s(json['show_Price']),
      lastPrice: _s(json['Last_Price']),
      askingPrice: _s(json['asking_price']),
      floor: _s(json['Floor_']),
      totalFloor: _s(json['Total_floor']),
      balcony: _s(json['Balcony']),
      squarefit: _s(json['squarefit']),
      maintenance: _s(json['maintance']),
      parking: _s(json['parking']),
      ageOfProperty: _s(json['age_of_property']),
      fieldWorkerAddress: _s(json['fieldworkar_address']),
      roadSize: _s(json['Road_Size']),
      metroDistance: _s(json['metro_distance']),
      highwayDistance: _s(json['highway_distance']),
      mainMarketDistance: _s(json['main_market_distance']),
      meter: _s(json['meter']),
      ownerName: _s(json['owner_name']),
      ownerNumber: _s(json['owner_number']),
      currentDate: _s(json['current_dates']),
      availableDate: _s(json['available_date']),
      kitchen: _s(json['kitchen']),
      bathroom: _s(json['bathroom']),
      lift: _s(json['lift']),
      facility: _s(json['Facility']),
      furnishing: _s(json['furnished_unfurnished']),
      fieldWorkerName: _s(json['field_warkar_name']),
      liveUnlive: _s(json['live_unlive']),
      fieldWorkerNumber: _s(json['field_workar_number']),
      registryAndGpa: _s(json['registry_and_gpa']),
      loan: _s(json['loan']),
      fieldWorkerCurrentLocation: _s(json['field_worker_current_location']),
      caretakerName: _s(json['care_taker_name']),
      caretakerNumber: _s(json['care_taker_number']),
      longitude: _s(json['Longitude']),
      latitude: _s(json['Latitude']),
      videoLink: _s(json['video_link']),
      subid: _i(json['subid']),
      sourceId: json['source_id']?.toString(),
    );
  }
}
class AllViewDetails extends StatefulWidget {
  final int id;
  const AllViewDetails({super.key, required this.id});
  @override
  State<AllViewDetails> createState() => _View_DetailsState();
}
class _View_DetailsState extends State<AllViewDetails> {
  Future<List<RealEstateSlider>> fetchCarouselData(int subid) async {
    final url =
        'https://verifyserve.social/WebService4.asmx/show_multiple_image_in_main_realestate?subid=$subid';
    print('Fetching gallery for subid: $subid'); // Debug
    final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 30));
    print('Gallery Response status: ${response.statusCode}'); // Debug
    print('Gallery Response body: ${response.body}'); // Debug
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is String) {
        final innerData = json.decode(data);
        return (innerData as List).map((item) => RealEstateSlider.fromJson(item)).toList();
      }
      return (data as List).map((item) => RealEstateSlider.fromJson(item)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/WebService4.asmx/show_multiple_image_in_main_realestate?subid=$subid",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
      );
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }

  Future<List<Catid>> fetchData(int id) async {
    final apiLink =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_api_for_details_page_in_main_realestate.php?P_id=$id";

    try {
      print('Fetching property for id: $id');

      final response = await http
          .get(Uri.parse(apiLink))
          .timeout(const Duration(seconds: 30));

      print('Property Response status: ${response.statusCode}');
      print('Property Response body: ${response.body}');

      // 🔴 STATUS CODE ERROR LOG
      if (response.statusCode != 200) {
        await BugLogger.log(
          apiLink: apiLink,
          error: response.body.toString(),
          statusCode: response.statusCode,
        );

        throw Exception("HTTP ${response.statusCode}");
      }

      // 🔴 JSON PARSE TRY
      final decoded = json.decode(response.body);
      final dynamic raw =
      decoded is Map<String, dynamic> ? decoded['data'] : decoded;

      final List<Map<String, dynamic>> listResponse;

      if (raw is List) {
        listResponse =
            raw.map((e) => Map<String, dynamic>.from(e)).toList();
      } else if (raw is Map) {
        listResponse = [Map<String, dynamic>.from(raw)];
      } else {
        listResponse = const [];
      }

      final properties =
      listResponse.map((e) => Catid.fromJson(e)).toList();

      if (properties.isNotEmpty && mounted) {
        setState(() {
          firstProperty = properties.first;
        });
      }

      return properties;
    } catch (e) {
      // 🔴 ANY EXCEPTION / TIMEOUT / FORMAT ERROR LOG
      await BugLogger.log(
        apiLink: apiLink,
        error: e.toString(),
        statusCode: 0,
      );

      rethrow;
    }
  }


  Future<List<Catid>>? _propertyFuture;
  Catid? firstProperty;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _propertyFuture = fetchData(widget.id); // Only property, gallery later
      });
    });
  }
  void _refreshData() {
    setState(() {
      _propertyFuture = fetchData(widget.id);
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final horizontalPadding = isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight = screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight = screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale = isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);
    // Always white cards, adjust borders/text for dark mode
    final cardBgColor = Colors.white;
    final cardBorderColor = isDarkMode ? Colors.grey[400]! : Colors.grey[200]!;
    final titleTextColor = Colors.grey[700]!;
    final valueTextColor = Colors.black87;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 30),
            ],
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshData();
          if (_propertyFuture != null) await _propertyFuture!;
        },
        child: FutureBuilder<List<Catid>>(
          future: _propertyFuture,
          builder: (context, propertySnapshot) {
            if (propertySnapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(height: screenHeight * 0.4, child: const Center(child: CircularProgressIndicator()));
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
                      Text("No Property Found!", style: TextStyle(fontSize: 16 * fontScale, color: Colors.grey)),
                    ],
                  ),
                ),
              );
            } else {
              final prop = propertySnapshot.data!.first;
              firstProperty = prop;
              // Nested Gallery FutureBuilder - Fix #1: Use prop.subid
              return FutureBuilder<List<RealEstateSlider>>(
                future: fetchCarouselData(prop.subid), // Correct subid from prop
                builder: (context, gallerySnapshot) {
                  if (gallerySnapshot.connectionState == ConnectionState.waiting) {
                    // Show property UI, gallery loading
                    return _buildPropertyUI(prop, gallerySnapshot.data ?? [], isDarkMode, screenWidth, screenHeight, isSmallScreen, isTablet, horizontalPadding, verticalPadding, imageHeight, carouselHeight, chipSpacing, fontScale, cardBgColor, cardBorderColor, titleTextColor, valueTextColor);
                  } else if (gallerySnapshot.hasError) {
                    print('Gallery Error: ${gallerySnapshot.error}'); // Debug
                    return _buildPropertyUI(prop, [], isDarkMode, screenWidth, screenHeight, isSmallScreen, isTablet, horizontalPadding, verticalPadding, imageHeight, carouselHeight, chipSpacing, fontScale, cardBgColor, cardBorderColor, titleTextColor, valueTextColor);
                  } else {
                    final images = gallerySnapshot.data ?? [];
                    return _buildPropertyUI(prop, images, isDarkMode, screenWidth, screenHeight, isSmallScreen, isTablet, horizontalPadding, verticalPadding, imageHeight, carouselHeight, chipSpacing, fontScale, cardBgColor, cardBorderColor, titleTextColor, valueTextColor);
                  }
                },
              );
            }
          },
        ),
      ),
    );
  }
  // Extracted UI builder to avoid code duplication
  Widget _buildPropertyUI(Catid prop, List<RealEstateSlider> images, bool isDarkMode, double screenWidth, double screenHeight, bool isSmallScreen, bool isTablet, double horizontalPadding, double verticalPadding, double imageHeight, double carouselHeight, double chipSpacing, double fontScale, Color cardBgColor, Color cardBorderColor, Color titleTextColor, Color valueTextColor) {
    final viewportFraction = isSmallScreen ? 0.85 : (isTablet ? 0.7 : 0.8);
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Image / Video (same, but video check added in widget)
              Stack(
                children: [
                  SizedBox(
                    height: imageHeight,
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => PropertyPreview(ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}"),
                        ),
                      ),
                      child: prop.videoLink.isNotEmpty
                          ? ClipRRect(
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        child: VideoPlayerWidget(videoUrl: prop.videoLink), // Fixed: handles non-YouTube
                      )
                          : ClipRRect(
                        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                        child: CachedNetworkImage(
                          imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${prop.propertyPhoto}",
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(color: Colors.grey[300], child: const Center(child: CircularProgressIndicator())),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[300],
                            child: Icon(Icons.error, size: 50 * fontScale, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: isSmallScreen ? 8.0 : 16.0,
                    right: horizontalPadding,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                      decoration: BoxDecoration(color: Colors.green.withOpacity(0.7), borderRadius: BorderRadius.circular(16)),
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
              // Price & Maintenance (same)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                        decoration: BoxDecoration(color: Colors.purple.withOpacity(0.85), borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            '₹ ${prop.showPrice}',
                            style: TextStyle(fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                        decoration: BoxDecoration(color: Colors.purple.withOpacity(0.85), borderRadius: BorderRadius.circular(16)),
                        child: Center(
                          child: Text(
                            "${prop.maintenance} Maintenance",
                            style: TextStyle(fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
                            maxLines: 2,
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Location + IDs (same)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding * 1.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      prop.locations,
                      style: TextStyle(fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale, fontWeight: FontWeight.w600, color: isDarkMode ? Colors.white : Colors.black87),
                    ),
                    SizedBox(height: verticalPadding * 1.5),
                    LayoutBuilder(builder: (context, constraints) {
                      final available = constraints.maxWidth;
                      final spacing = chipSpacing * 1.5;
                      final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
                      final rawWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;
                      final chipWidth = rawWidth.clamp(64.0, available).toDouble();
                      final chipsData = <Map<String, dynamic>>[
                        {'icon': Icons.install_desktop_sharp, 'text': 'Live Property Id: ${prop.id.toString()}', 'color': Colors.lightGreen},
                        {'icon': Icons.apartment_sharp, 'text': 'Building Id: ${prop.subid.toString()}', 'color': Colors.lightBlue},
                        if ((prop.sourceId ?? '').trim().isNotEmpty) {'icon': Icons.file_open, 'text': 'Building Flat Id: ${prop.sourceId}', 'color': Colors.deepOrange},
                        if ((prop.bhk ?? '').trim().isNotEmpty) {'icon': Icons.apartment_outlined, 'text': ' ${prop.bhk}', 'color': Colors.yellow},
                      ];
                      return Wrap(
                        spacing: spacing,
                        runSpacing: verticalPadding * 1.2,
                        children: chipsData.map((e) => SizedBox(width: chipWidth, child: _buildChip(e['icon'] as IconData, e['text'] as String, e['color'] as Color, context))).toList(),
                      );
                    }),
                    SizedBox(height: verticalPadding * 2),
                  ],
                ),
              ),
              // Multiple Images Carousel (same, but with images param)
              if (images.isNotEmpty)
                Container(
                  margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
                  child: CarouselSlider(
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
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => PropertyPreview(ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item.mImages}"),
                              ),
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
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
                ),
              // Property Details Section (same structure)
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
                          Text("Property Details", style: TextStyle(fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalPadding),
                    _buildResponsiveInfoGrid(
                      _getPropertyDetailsRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding, titleTextColor, valueTextColor, cardBgColor, cardBorderColor),
                      context,
                      isSmallScreen,
                    ),
                  ],
                ),
              ),
              // Building Facility Section (same)
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
                          Text("Building Facility", style: TextStyle(fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalPadding),
                    if (_getBuildingFacilityRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding, titleTextColor, valueTextColor, cardBgColor, cardBorderColor).isNotEmpty)
                      ..._getBuildingFacilityRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding, titleTextColor, valueTextColor, cardBgColor, cardBorderColor),
                  ],
                ),
              ),
              // Additional Information (same)
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
                          Text("Additional Information", style: TextStyle(fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale, fontWeight: FontWeight.bold, color: isDarkMode ? Colors.white : Colors.black)),
                        ],
                      ),
                    ),
                    SizedBox(height: verticalPadding),
                    ..._getAdditionalInfoRows(prop, context, isSmallScreen, isDarkMode, horizontalPadding, titleTextColor, valueTextColor, cardBgColor, cardBorderColor),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.15),
            ],
          ),
        ),
      ],
    );
  }
  // Updated _buildInfoRow with dynamic colors - Fix #3
  Widget _buildInfoRow(IconData icon, Color iconColor, String title, String value, bool isSmallScreen, bool isDarkMode, Color titleTextColor, Color valueTextColor, Color cardBgColor, Color cardBorderColor) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();
    final Color iconBg = iconColor.withOpacity(0.10);
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardBorderColor),
        boxShadow: isDarkMode ? [const BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))] : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
          ),
          SizedBox(width: isSmallScreen ? 6.0 : 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: isSmallScreen ? 10.0 : 11.0, fontWeight: FontWeight.w500, color: titleTextColor)),
                SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                Text(value, style: TextStyle(fontSize: isSmallScreen ? 11.0 : 12.0, fontWeight: FontWeight.w500, color: valueTextColor), softWrap: true),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // Updated _buildContactCard with dynamic colors
  Widget _buildContactCard(
      String role,
      String name,
      String number, {
        Color? bgColor,
        required BuildContext context,
        required VoidCallback onCall,
      }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = bgColor ?? Colors.blue;
    String maskedNumber = _maskPhoneNumber(number);
    final cardBgColor = Colors.white;
    final valueTextColor = Colors.black87;
    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: cardBgColor,
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
                          color: valueTextColor,
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
                  padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: isSmallScreen ? 6.0 : 8.0),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: cardColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          maskedNumber,
                          style: TextStyle(
                            fontSize: isSmallScreen
                                ? 13.0
                                : 14.0,
                            fontWeight: FontWeight.w500,
                            color: cardColor,
                          ),
                          overflow:
                          TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () =>
                                _openWhatsApp(number, context),
                            child: Icon(
                              PhosphorIcons
                                  .whatsapp_logo_bold,
                              color: Colors.green,
                              size: isSmallScreen
                                  ? 20.0
                                  : 24.0,
                            ),
                          ),
                          SizedBox(
                              width: isSmallScreen
                                  ? 12.0
                                  : 16.0),
                          Icon(
                            Icons.call,
                            color: cardColor,
                            size: isSmallScreen
                                ? 20.0
                                : 24.0,
                          ),
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
                      fontSize:
                      isSmallScreen ? 11.0 : 12.0,
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
  // Updated _buildSimpleInfoCard with dynamic colors
  Widget _buildSimpleInfoCard(
      String title,
      String value,
      IconData icon,
      Color cardColor, {
        bool isSmallScreen = false,
        bool isDarkMode = false,
      }) {
    if (value.isEmpty || value == "null" || value == "0") {
      return const SizedBox.shrink();
    }
    final valueTextColor = Colors.black87;
    return Container(
      margin:
      EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding:
        EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
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
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize:
                      isSmallScreen ? 10.0 : 11.0,
                      fontWeight: FontWeight.w600,
                      color: cardColor,
                    ),
                  ),
                  SizedBox(
                      height:
                      isSmallScreen ? 1.0 : 2.0),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize:
                      isSmallScreen ? 13.0 : 14.0,
                      fontWeight: FontWeight.w500,
                      color: valueTextColor,
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
  }
  Widget _buildChip(
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
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
  // Fixed Grid to Adaptive Wrap - No empty spaces for missing details
  Widget _buildResponsiveInfoGrid(List<Widget> infoRows,
      BuildContext context, bool isSmallScreen) {
    if (infoRows.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final padding = isSmallScreen ? 4.0 : 8.0;
        final availableWidth = screenWidth - 2 * padding;
        final spacing = screenWidth > 350 ? (isSmallScreen ? 12.0 : 16.0) : 8.0;
        final itemWidth = (availableWidth - spacing) / 2;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: padding),
          child: Wrap(
            spacing: spacing,
            runSpacing: 8.0,
            children: infoRows.map((row) => SizedBox(
              width: itemWidth,
              child: row,
            )).toList(),
          ),
        );
      },
    );
  }
  // Fixed _getPropertyDetailsRows - Reordered to match image, added missing fields, corrected labels
  List<Widget> _getPropertyDetailsRows(Catid prop,
      BuildContext context, bool isSmallScreen,
      bool isDarkMode, double horizontalPadding,
      Color titleTextColor, Color valueTextColor,
      Color cardBgColor, Color cardBorderColor) {
    List<Widget> rows = [];


    // Metro Distance
    if (
    prop.metroDistance.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.train,
          Colors.orange, "Metro Station",
          prop.metroDistance, isSmallScreen,
          isDarkMode, titleTextColor,
          valueTextColor, cardBgColor,
          cardBorderColor));
    }
    // Highway Distance
    if (
    prop.highwayDistance.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.directions_car,
          Colors.red, "Metro Distance",
          prop.highwayDistance, isSmallScreen,
          isDarkMode, titleTextColor, valueTextColor,
          cardBgColor, cardBorderColor));
    }
    // Main Market Distance
    if (prop.mainMarketDistance.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.store, Colors.purple, "Market Distance", prop.mainMarketDistance, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    // Road Size
    if (prop.roadSize.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.straighten, Colors.teal, "Road Size", "${prop.roadSize} Feet", isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    // Residence/Commercial
    if (prop.residenceCommercial.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.business, Colors.teal, "Residence/Commercial", prop.residenceCommercial, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    // Age of Property
    if (prop.ageOfProperty.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.home, Colors.orange, "Age of Property", prop.ageOfProperty, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    // Type of Property
    if (prop.typeofProperty.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.home, Colors.orange, "Type of Property", prop.typeofProperty, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    // Flat Number
    if (prop.flatNumber.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.format_list_numbered, Colors.green, "Flat Number", prop.flatNumber, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    if (prop.floor.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.layers, Colors.green, "Floor", prop.floor, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    if (prop.squarefit.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.square_foot, Colors.green, "Square Fit", prop.squarefit, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    if (prop.furnishing.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.chair, Colors.green, "Furnishing", prop.furnishing, isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    if (prop.registryAndGpa.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.calendar_today, Colors.blue, "Registry&GPA", _formatDate(prop.registryAndGpa), isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }
    if (prop.loan.isNotEmpty) {
      rows.add(_buildInfoRow(Icons.account_balance_sharp, Colors.blue, "Loan", _formatDate(prop.loan), isSmallScreen, isDarkMode, titleTextColor, valueTextColor, cardBgColor, cardBorderColor));
    }

    return rows;
  }
  // Updated _getBuildingFacilityRows with new params
  List<Widget> _getBuildingFacilityRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding, Color titleTextColor, Color valueTextColor, Color cardBgColor, Color cardBorderColor) {
    List<Widget> rows = [];
    final double verticalPadding = isSmallScreen ? 2.0 : 4.0;
    // Facilities
    if (prop.facility.isNotEmpty) {
      rows.add(_buildInfoRow(
        Icons.local_hospital,
        Colors.amber,
        "Facilities",
        prop.facility,
        isSmallScreen,
        isDarkMode,
        titleTextColor,
        valueTextColor,
        cardBgColor,
        cardBorderColor,
      ));
      if (prop.apartmentName.isNotEmpty) {
        rows.add(_buildInfoRow(
          Icons.apartment_outlined,
          Colors.green,
          "Flat Facility",
          prop.apartmentName,
          isSmallScreen,
          isDarkMode,
          titleTextColor,
          valueTextColor,
          cardBgColor,
          cardBorderColor,
        ));
      }
    }
    // Row 1: Kitchen, Bathroom
    List<Widget> row1Cards = [];
    if (prop.kitchen.isNotEmpty) {
      row1Cards.add(_buildSimpleInfoCard(
        "Kitchen",
        prop.kitchen,
        Icons.kitchen,
        Colors.pink,
        isSmallScreen: isSmallScreen,
        isDarkMode: isDarkMode,
      ));
    }
    if (prop.bathroom.isNotEmpty) {
      row1Cards.add(_buildSimpleInfoCard(
        "Bathroom",
        prop.bathroom,
        Icons.bathroom,
        Colors.lightBlue,
        isSmallScreen: isSmallScreen,
        isDarkMode: isDarkMode,
      ));
    }
    if (row1Cards.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: _buildAdaptiveRows(row1Cards, context, verticalPadding),
        ),
      );
    }
    // Row 2: Parking, Lift, Balcony, Meter Type
    List<Widget> row2Cards = [];
    if (prop.parking.isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard(
        "Parking",
        prop.parking,
        Icons.local_parking,
        Colors.purple,
        isSmallScreen: isSmallScreen,
        isDarkMode: isDarkMode,
      ));
    }
    if (prop.lift.isNotEmpty) {
      final String liftText =
      prop.lift.toLowerCase() == 'yes' ? 'Available' : 'Not Available';
      row2Cards.add(_buildSimpleInfoCard(
        "Lift",
        liftText,
        Icons.elevator,
        Colors.red,
        isSmallScreen: isSmallScreen,
        isDarkMode: isDarkMode,
      ));
    }
    if (prop.balcony.isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard(
        "Balcony",
        prop.balcony,
        Icons.balcony,
        Colors.orange,
        isSmallScreen: isSmallScreen,
        isDarkMode: isDarkMode,
      ));
    }
    if (prop.meter.isNotEmpty) {
      row2Cards.add(_buildSimpleInfoCard(
        "Meter Type",
        prop.meter,
        Icons.electric_meter,
        Colors.blue,
        isSmallScreen: isSmallScreen,
        isDarkMode: isDarkMode,
      ));
    }
    if (row2Cards.isNotEmpty) {
      rows.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          child: _buildAdaptiveRows(row2Cards, context, verticalPadding),
        ),
      );
    }
    return rows;
  }
  Widget _buildAdaptiveRows(
      List<Widget> cards, BuildContext context, double verticalPadding) {
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
          final width =
          cards.length == 1 ? available : itemWidth;
          return SizedBox(width: width, child: card);
        }).toList(),
      );
    });
  }
  // Updated _getAdditionalInfoRows with new params
  List<Widget> _getAdditionalInfoRows(Catid prop, BuildContext context, bool isSmallScreen, bool isDarkMode, double horizontalPadding, Color titleTextColor, Color valueTextColor, Color cardBgColor, Color cardBorderColor) {
    List<Widget> rows = [];
    // Property Added Date
    if (prop.currentDate.isNotEmpty) {
      rows.add(
        _buildSimpleInfoCard(
          "Property Added Date",
          _formatDate(prop.currentDate),
          Icons.date_range,
          Colors.indigo,
          isSmallScreen: isSmallScreen,
          isDarkMode: isDarkMode,
        ),
      );
    }
    // Field Worker Info
    rows.add(
        _buildFieldworkerInfoCard(prop, context, isSmallScreen, isDarkMode));
    return rows;
  }
  // Updated _buildFieldworkerInfoCard with dynamic colors
  Widget _buildFieldworkerInfoCard(Catid prop, BuildContext context,
      bool isSmallScreen, bool isDarkMode) {
    final String name = prop.fieldWorkerName;
    final String number = prop.fieldWorkerNumber;
    //final String address = prop.fieldWorkerAddress;
    final String location = prop.fieldWorkerCurrentLocation;
    final Color cardColor = Colors.blue;
    final Color bgColor = Colors.blue;
    final cardBgColor = Colors.white;
    final valueTextColor = Colors.black87;
    if (name.isEmpty &&
        number.isEmpty &&
        // address.isEmpty &&
        location.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin:
      EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding:
      EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: cardBgColor,
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
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "FIELD WORKER",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(
                        height:
                        isSmallScreen ? 1.0 : 2.0),
                    Text(
                      name.isNotEmpty ? name : "Not Available",
                      style: TextStyle(
                        fontSize:
                        isSmallScreen ? 13.0 : 14.0,
                        fontWeight: FontWeight.w500,
                        color: valueTextColor,
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
              onTap: () =>
                  _showCallConfirmation(context, name, number),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: isSmallScreen ? 6.0 : 8.0),
                decoration: BoxDecoration(
                  color: bgColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: bgColor.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        _maskPhoneNumber(number),
                        style: TextStyle(
                          fontSize: isSmallScreen
                              ? 13.0
                              : 14.0,
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
                          onTap: () =>
                              _openWhatsApp(number, context),
                          child: Icon(
                            PhosphorIcons.whatsapp_logo_bold,
                            color: Colors.green,
                            size: isSmallScreen
                                ? 20.0
                                : 24.0,
                          ),
                        ),
                        SizedBox(
                            width: isSmallScreen
                                ? 12.0
                                : 16.0),
                        Icon(
                          Icons.call,
                          color: bgColor,
                          size: isSmallScreen
                              ? 20.0
                              : 24.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          // Current Location
          if (location.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(
                  top: isSmallScreen ? 6.0 : 8.0),
              child: _buildSimpleInfoCard(
                "Fieldworker Location",
                location,
                Icons.my_location,
                Colors.lightBlue,
                isSmallScreen: isSmallScreen,
                isDarkMode: isDarkMode,
              ),
            ),
        ],
      ),
    );
  }
  void _showCallConfirmation(
      BuildContext context, String name, String number) async {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Call $name',
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black),
        ),
        content: Text(
          'Do you really want to call ${name.isNotEmpty ? name : "this contact"}?',
          style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black),
        ),
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
              await _makePhoneCall(number, context);
            },
            child: const Text('Yes'),
          ),
        ],
      ),
    );
  }
  String _maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String firstPart = number.substring(0, 3);
    String lastPart = number.substring(number.length - 4);
    return '$firstPart****$lastPart';
  }
  Future<void> _launchVideo(
      String url, BuildContext context) async {
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
  Future<void> _openWhatsApp(
      String number, BuildContext context) async {
    try {
      String cleanNumber =
      number.replaceAll(RegExp(r'[^0-9]'), '');
      if (!cleanNumber.startsWith('91')) {
        cleanNumber = '91$cleanNumber';
      }
      final Uri whatsappUri =
      Uri.parse("whatsapp://send?phone=$cleanNumber");
      final Uri whatsappWebUri =
      Uri.parse("https://wa.me/$cleanNumber");
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri,
            mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri,
            mode: LaunchMode.externalApplication);
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
          SnackBar(
              content:
              Text('Error opening WhatsApp: ${e.toString()}')),
        );
      }
    }
  }
  Future<void> _makePhoneCall(
      String number, BuildContext context) async {
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
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "N/A";
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
  Future<bool> _checkCallPermission() async {
    var status = await Permission.phone.status;
    if (status.isDenied) {
      status = await Permission.phone.request();
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return status.isGranted;
  }
  void _showPermissionSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Call permission denied'),
        duration: Duration(seconds: 2),
      ),
    );
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
  bool _isYouTube = false;
  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    _isYouTube = videoId != null && videoId.isNotEmpty;
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
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
    if (!_isYouTube) {
      return Container(
        color: Colors.grey[300],
        child: const Center(child: Icon(Icons.video_file, size: 50, color: Colors.grey)),
      ); // Placeholder for non-YouTube
    }
    return YoutubePlayerBuilder(
      onExitFullScreen: () {},
      builder: (context, player) => ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          width: double.infinity,
          child: player,
        ),
      ),
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.redAccent,
        onReady: () => print("Player is ready."),
      ),
    );
  }
}
void openWhatsApp(String phoneNumber) {
  if (defaultTargetPlatform == TargetPlatform.android) {
    final cleanNumber =
    phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final intent = AndroidIntent(
      action: 'action_view',
      data: Uri.encodeFull('whatsapp://send?phone=$cleanNumber'),
      package: 'com.whatsapp',
    );
    intent.launch();
  } else {
    print(
        'WhatsApp open only supported on Android with this method');
  }
}