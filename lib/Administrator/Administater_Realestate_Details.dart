import 'dart:async';
import 'dart:convert';
import 'package:android_intent_plus/android_intent.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Model.dart';

import '../Home_Screen_click/All_view_details.dart';
import '../Home_Screen_click/Preview_Image.dart';
import '../property_preview.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/realestateSlider.dart';
import 'Admin_future _property/Future_Property_Details.dart';
import 'Administator_Realestate.dart';
import 'package:intl/intl.dart';

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
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
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body:RefreshIndicator(
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
            // Determine current theme mode
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;
            final theme = Theme.of(context);

            if (propertySnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (propertySnapshot.hasError) {
              return Center(child: Text('Error: ${propertySnapshot.error}'));
            } else if (propertySnapshot.data == null || propertySnapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Data Found!",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: isDarkMode ? Colors.white : Colors.black87,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              );
            }
            else {
              final property = propertySnapshot.data!.first;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: (property.videoLink != null && property.videoLink!.isNotEmpty)
                                  ? LayoutBuilder(
                                builder: (context, constraints) {
                                  return AspectRatio(
                                    aspectRatio: 16 / 9, // standard YouTube aspect ratio
                                    child: VideoPlayerWidget(videoUrl: property.videoLink!),
                                  );
                                },
                              )
                                  : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PropertyPreview(
                                        ImageUrl:
                                        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                                      ),
                                    ),
                                  );
                                },
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                                  height: MediaQuery.of(context).size.height * 0.25,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Center(
                                      child: Image.asset(AppImages.loader, height: 70, fit: BoxFit.contain),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Center(
                                      child: Image.asset(AppImages.imageNotFound, fit: BoxFit.cover),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Quick Facts Row
                          Wrap(
                            children: [
                              _FactChip(
                                icon: Icons.bed,
                                label: "${property.bhk}",
                                color: Colors.redAccent,
                                isDarkMode: isDarkMode,
                              ),
                              SizedBox(width: 8),
                              _FactChip(
                                icon: Icons.gite_rounded,
                                label: property.floor,
                                color: Colors.blueAccent,
                                isDarkMode: isDarkMode,
                              ),
                              SizedBox(width: 8),
                              _FactChip(
                                icon: Icons.type_specimen,
                                label: property.buyRent,
                                color: Colors.green,
                                isDarkMode: isDarkMode,
                              ),

                            ],
                          ),
                          SizedBox(height: 10
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    '₹ ${property.showPrice ?? ""}',
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "PoppinsBold",
                                    ),
                                  ),
                                ],
                              ),
                              // _InfoChip(
                              //   icon: Icons.star,
                              //   value: property.id.toString(),
                              //   color: Colors.amber,
                              //   isDarkMode: isDarkMode,
                              // ),
                            ],
                          ),
                          _DetailRow(
                            icon: Icons.home_repair_service,
                            title: "Maintenance",
                            value: "₹ ${property.maintance}",
                            color: Colors.orangeAccent,
                            isDarkMode: isDarkMode,
                          ),

                          SizedBox(height: 4),
                          Wrap(
                            children: [
                              _FactChip(
                                icon: Icons.location_on_sharp,
                                label: "${property.locations}",
                                color: Colors.redAccent,
                                isDarkMode: isDarkMode,
                              ),
                              SizedBox(width: 8),
                              _FactChip(
                                icon: Icons.gite_rounded,
                                label: property.typeOfProperty,
                                color: Colors.blueAccent,
                                isDarkMode: isDarkMode,
                              ),
                              SizedBox(width: 8),
                              _FactChip(
                                icon: Icons.square_foot,
                                label: "${property.squareFit} sqft",
                                color: Colors.purpleAccent,
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                          SizedBox(height: 4),
                          // Contact Information
                          _SectionHeader(
                            title: "Contact Information",
                            isDarkMode: isDarkMode,
                          ),
                          _ContactCard(
                            name: property.ownerName,
                            phone: property.ownerNumber,
                            role: "Owner",
                            color: Colors.amber,
                            onCall: () => _showCallConfirmation(
                              context,
                              property.ownerName,
                              property.ownerNumber,
                            ),
                            isDarkMode: isDarkMode,
                          ),
                          SizedBox(height: 12),
                          _ContactCard(
                            name: property.careTakerName,
                            phone: property.careTakerNumber,
                            role: "Caretaker",
                            color: Colors.purpleAccent,
                            onCall: () => _showCallConfirmation(
                              context,
                              property.careTakerNumber,
                              property.careTakerNumber,
                            ),
                            isDarkMode: isDarkMode,
                          ),

                          SizedBox(height: 10),

                          // Property Details
                          _SectionHeader(
                            title: "Property Details",
                            isDarkMode: isDarkMode,
                          ),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _FactChip(
                                icon: Icons.install_desktop_sharp,
                                label: "Live Property Id : ${property.id}",
                                color: Colors.lightGreen,
                                isDarkMode: isDarkMode,
                              ),
                              _FactChip(
                                icon: Icons.apartment_sharp,
                                label: "Building Id : ${property.subid}",
                                color: Colors.lightBlue,
                                isDarkMode: isDarkMode,
                              ),
                            ],
                          ),
                          _FactChip(
                            icon: Icons.file_open,
                            label: "Building Flat Id : "+ property.sourceId.toString(),
                            color: Colors.deepOrange,
                            isDarkMode: isDarkMode,
                          ),

                          // Full Address
                          _SectionHeader(
                            title: "Full Address",
                            isDarkMode: isDarkMode,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              property.apartmentAddress,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          if(property.fieldWorkerCurrentLocation!=""&&property.fieldWorkerCurrentLocation!=null)
                            InkWell(
                              onTap: () async {
                                final address = property.fieldWorkerCurrentLocation;
                                final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$address");

                                if (await canLaunchUrl(url)) {
                                  await launchUrl(url, mode: LaunchMode.externalApplication);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.location_on, color: Colors.red, size: 25),
                                  const SizedBox(width: 15),
                                  Expanded(
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: "Current Location : ",
                                            style: TextStyle(
                                              color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,

                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text: property.fieldWorkerCurrentLocation,
                                            style: const TextStyle(
                                              color: Colors.blue,
                                              fontFamily: "Poppins",
                                              decoration: TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Icon(Icons.location_on, color: Colors.red, size: 25),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Current Location : ",
                                          style: TextStyle(
                                            color: Theme.of(context).brightness == Brightness.dark?Colors.white:Colors.black,
                                            fontFamily: "Poppins",
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextSpan(
                                          text: "Not Available",
                                          style:  TextStyle(
                                            color: Colors.blue,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),

                          SizedBox(height: 8),

                          _DetailRow(
                            icon: Icons.construction,
                            title: "Facilities",
                            value: property.facility,
                            color: Colors.blueGrey,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.upload_sharp,
                            title: "Lift Availability",
                            value:
                            "${property.lift.toLowerCase() == 'yes' ? 'Available' : 'Not Available'}",
                            color: Colors.deepPurpleAccent,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.gas_meter_rounded,
                            title: "Meter Type",
                            value:  "${property.meter}/- per unit",
                            color: Colors.deepPurpleAccent,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.chair,
                            title: "Furnishing",
                            value: "${property.furnishedUnfurnished}, ${property.apartmentName}",
                            color: Colors.brown,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.kitchen,
                            title: "Kitchen & Bathroom",
                            value: "${property.kitchen} Kitchen | ${property.bathroom} Bathroom",
                            color: Colors.indigoAccent,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.local_parking,
                            title: "Parking & Main Market Distance",
                            value: property.parking+" | "+ property.mainMarketDistance  ,
                            color: Colors.teal,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.balcony,
                            title: "Balcony",
                            value: property.balcony,
                            color: Colors.lightGreen,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.train,
                            title: "Near Metro & Metro Distance",
                            value:  property.metroDistance + " | "+property.highwayDistance,
                            color: Colors.amber,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.home,
                            title: "Flat Number & Total Floor",
                            value:  property.flatNumber+" | "+property.totalFloor ,
                            color: Colors.cyanAccent,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.real_estate_agent_rounded,
                            title: "Age of Property & Road Size",
                            value:  property.ageOfProperty+" | "+property.roadSize ,
                            color: Colors.redAccent,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.app_registration,
                            title: "Registry & GPA",
                            value:  property.registryAndGpa ,
                            color: Colors.greenAccent,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.screen_lock_landscape,
                            title: "Loan Availability",
                            value:  property.loan ,
                            color: Colors.orangeAccent,
                            isDarkMode: isDarkMode,
                          ),

                          _DetailRow(
                            icon: Icons.place,
                            title: "Residence / Commercial",
                            value:  property.residenceCommercial ,
                            color: Colors.green,
                            isDarkMode: isDarkMode,
                          ),
                          SizedBox(height: 24),


                          SizedBox(height: 24),

                          // Gallery Section
                          _SectionHeader(
                            title: "Gallery",
                            isDarkMode: isDarkMode,
                          ),
                          SizedBox(height: 8),
                          FutureBuilder<List<RealEstateSlider>>(
                            future: _galleryFuture,
                            builder: (context, gallerySnapshot) {
                              if (gallerySnapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (gallerySnapshot.hasError) {
                                return Center(child: Text("Error loading gallery"));
                              } else if (!gallerySnapshot.hasData || gallerySnapshot.data!.isEmpty) {
                                return Center(child: Text("No images available"));
                              } else {
                                final images = gallerySnapshot.data!;
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    final image = images[index];
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PropertyPreview(
                                              ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${image.mImages}",
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Container(
                                          // height: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.2),
                                                blurRadius: 4,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          child: ClipRRect(
                                            borderRadius: BorderRadiusGeometry.circular(10),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${image.mImages}",
                                              fit: BoxFit.fill,
                                              placeholder: (context, url) => Container(
                                                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                                child: Center(
                                                  child: Image.asset(
                                                    AppImages.loader,
                                                    height: 50,
                                                    width: 50,
                                                  ),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) => Container(
                                                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: isDarkMode ? Colors.white : Colors.black54,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          ),

                          SizedBox(height: 12),
                          _ContactCard(
                            name: property.fieldWorkerName,
                            phone: property.fieldWorkerNumber,
                            role: "Field Worker",
                            color: Colors.blueAccent,
                            onCall: () => _showCallConfirmation(
                              context,
                              property.fieldWorkerName,
                              property.fieldWorkerNumber,
                            ),
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.location_history,
                            title: "Worker Address",
                            value: property.fieldWorkerAddress,
                            color: Colors.cyan,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.pages_outlined,
                            title: "Property Added Date",
                            value: formatDate(property.availableDate),
                            color: Colors.orangeAccent,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.price_change_sharp,
                            title: "Property Ask & Last Price",
                            value: "₹ ${property.askingPrice}"+" | " + "₹ ${property.lastPrice}",
                            color: Colors.greenAccent,
                            isDarkMode: isDarkMode,
                          ),

                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Administater_Future_Property_details(
                                    buildingId: property.subid.toString(),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              backgroundColor: Colors.purple.shade300,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
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
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),

    );

  }

}
class _FactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isDarkMode;

  const _FactChip({
    required this.icon,
    required this.label,
    required this.color,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      backgroundColor: color.withOpacity(isDarkMode ? 0.2 : 0.1),
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final bool isDarkMode;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w500,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontFamily: "Poppins",
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _ContactCard extends StatelessWidget {
  final String name;
  final String phone;
  final String role;
  final Color color;
  final VoidCallback onCall;
  final bool isDarkMode;

  const _ContactCard({
    required this.name,
    required this.phone,
    required this.role,
    required this.color,
    required this.onCall,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: isDarkMode ? Colors.grey[850] : Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color),
              ),
              child: Icon(Icons.person, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  Text(
                    name,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: "PoppinsBold",
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    phone,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.phone, color: color),
              onPressed: onCall,
            ),
          ],
        ),
      ),
    );
  }
}
class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDarkMode;

  const _SectionHeader({
    required this.title,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
          fontFamily: "PoppinsBold",
          color: isDarkMode ? Colors.blue : theme.primaryColorDark,
        ),
      ),
    );
  }
}
String formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return "N/A";
  try {
    final date = DateTime.parse(dateString);
    return DateFormat('dd MMM yyyy').format(date); // e.g., 02 Aug 2025
  } catch (e) {
    return "Invalid Date";
  }
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

