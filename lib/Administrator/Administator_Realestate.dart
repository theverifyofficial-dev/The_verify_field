import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Home_Screen_click/Add_RealEstate.dart';
import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import '../ui_decoration_tools/constant.dart';
import 'Add_Assign_Tenant_Demand/See_All_Realestate.dart';
import 'Administater_Realestate_Details.dart';

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

class ADministaterShow_realestete extends StatefulWidget {
  const ADministaterShow_realestete({super.key});

  @override
  State<ADministaterShow_realestete> createState() => _ADministaterShow_realesteteState();
}

class _ADministaterShow_realesteteState extends State<ADministaterShow_realestete> {

  void _showBottomSheet(BuildContext context) {

    List<String> timing = [
      "Residential",
      "Plots",
      "Commercial",
    ];
    ValueNotifier<int> timingIndex = ValueNotifier(0);

    String displayedData = "Press a button to display data";

    void updateData(String newData) {
      setState(() {
        displayedData = newData;
      });
    }

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 5,right: 5,top: 0, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(3),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Colors.grey),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.red[500],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    // ignore: prefer_const_literals_to_create_immutables
                    tabs: [
                      Tab(text: 'Residential'),
                      Tab(text: 'Commercial'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    Filter_Options(),
                    Commercial_Filter()
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String _number = '';



  Future<List<Catid>> fetchData() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat?field_workar_number=9711775300&live_unlive=Flat",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Catid>> fetchData1() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat"
            "?field_workar_number=9711275300&live_unlive=Flat",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Catid>> fetchData2() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat"
            "?field_workar_number=9971172204&live_unlive=Flat",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }
  Future<List<Catid>> fetchData_rajpur() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/show_main_realestate_data_by_field_workar_number_live_flat"
            "?field_workar_number=9818306096&live_unlive=Flat",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = json.decode(response.body);

        if (body is List) {
          // Reverse the list instead of sorting by PVR_id
          final reversedList = body.reversed.toList();
          return reversedList.map((data) => Catid.fromJson(data)).toList();
        } else {
          throw Exception("Invalid JSON format: Expected a list");
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      print("fetchData2 error: $e");
      throw Exception("Failed to fetch data: $e");
    }
  }


  @override
  void initState() {
    _loaduserdata();
    super.initState();

  }

  bool _isDeleting = false;

  //Delete api
  Future<void> DeletePropertybyid(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
    final response = await http.get(url);
    // await Future.delayed(Duration(seconds: 1));
    if (response.statusCode == 200) {
      setState(() {
        _isDeleting = false;
        //ShowVehicleNumbers(id);
        //showVehicleModel?.vehicleNo;
      });
      print(response.body.toString());
      print('Item deleted successfully');
    } else {
      print('Error deleting item. Status code: ${response.statusCode}');
      throw Exception('Failed to load data');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
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
        // actions:  [
        //   GestureDetector(
        //     onTap: () {
        //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Filter_Options()));
        //       _showBottomSheet(context);
        //     },
        //     child: const Icon(
        //       PhosphorIcons.faders,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                return FutureBuilder<List<Catid>>(
                  future: fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return  Center(
                        child: Lottie.asset(AppImages.loadingHand, height: 400),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Failed to load properties',
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                            color: Colors.grey[600],
                            fontFamily: "Poppins",
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.home_work_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No properties available',
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                color: Colors.grey[600],
                                fontFamily: "Poppins",
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Sumit kasaniya',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PoppinsBold",
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            See_All_Realestate(
                                                id: '9711775300'),
                                      ),
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          'View All',
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                            color: Colors.blue[700],
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Poppins",
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          size: 14,
                                          color: Colors.blue[700],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 440,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16),
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context,int len) {
                                final property = snapshot.data![len];
                                int displayIndex = snapshot.data!.length - len;

                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Administater_View_Details(idd: '${property.id}',))
                                    );

                                  },
                                  child: Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(
                                        right: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                      color:Theme.of(context).brightness==Brightness.dark?Colors.white10:Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        // Property Image with Gradient Overlay
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(16)),
                                              child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property
                                                      .propertyPhoto}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: Center(
                                                          child: Image.asset(
                                                            AppImages.loader,
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: const Icon(
                                                          Icons
                                                              .home_work_outlined,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            // Gradient Overlay
                                            Positioned.fill(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius
                                                      .vertical(
                                                      top: Radius.circular(16)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(
                                                          0.4),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Price Tag
                                            Positioned(
                                              bottom: 16,
                                              left: 16,
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "₹${property.showPrice}",
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    fontFamily: "PoppinsBold",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Property Details
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                // Location
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_outlined,
                                                      size: 18,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        property
                                                            .locations,
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight
                                                              .w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),

                                                // Property Features
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _buildFeaturePill(
                                                      Icons.category_outlined,
                                                      property.typeOfProperty
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buyRent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.bhk.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.apartmentAddress,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                      fontSize: 14,
                                                      color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                Text("Property No: $displayIndex"/* ${len + 1} or +abc.data![len].id.toString()*//*+abc.data![len].Building_Name.toUpperCase()*/,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),

                                                // Footer
                                                const SizedBox(height: 12),

                                                Divider(
                                                  height: 1,
                                                  color: Colors.grey[200],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "ID: ${property.id}",
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    Text(
                                                      property.availableDate,
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              childCount: 1,
            ),
          ),

         SliverList(

            delegate: SliverChildBuilderDelegate(
                  (context, index) {

                return FutureBuilder<List<Catid>>(
                  future: fetchData1(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = snapshot.data!;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                                child: Text(
                                  'Ravi Kumar',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PoppinsBold",
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> See_All_Realestate(id: '9711275300',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        'View All',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Colors.blue[700],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 440,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.length,
                              itemBuilder: (BuildContext context,int len) {
                                final property = snapshot.data![len];
                                int displayIndex = snapshot.data!.length - len;
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Administater_View_Details(idd: '${property.id}',))
                                    );

                                  },
                                  child: Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(
                                        right: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                      color:Theme.of(context).brightness==Brightness.dark?Colors.white10:Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        // Property Image with Gradient Overlay
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(16)),
                                              child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property
                                                      .propertyPhoto}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: Center(
                                                          child: Image.asset(
                                                            AppImages.loader,
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: const Icon(
                                                          Icons
                                                              .home_work_outlined,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            // Gradient Overlay
                                            Positioned.fill(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius
                                                      .vertical(
                                                      top: Radius.circular(16)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(
                                                          0.4),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Price Tag
                                            Positioned(
                                              bottom: 16,
                                              left: 16,
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "₹${property.showPrice}",
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    fontFamily: "PoppinsBold",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Property Details
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                // Location
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_outlined,
                                                      size: 18,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        property
                                                            .locations,
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight
                                                              .w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),

                                                // Property Features
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _buildFeaturePill(
                                                      Icons.category_outlined,
                                                      property.typeOfProperty
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buyRent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.bhk.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.apartmentAddress,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                      fontSize: 14,
                                                      color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                Text("Property No: $displayIndex"/* ${len + 1} or +abc.data![len].id.toString()*//*+abc.data![len].Building_Name.toUpperCase()*/,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),

                                                // Footer
                                                const SizedBox(height: 12),

                                                Divider(
                                                  height: 1,
                                                  color: Colors.grey[200],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "ID: ${property.id}",
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    Text(
                                                      property.availableDate,
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                                },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              childCount: 1, // Number of categories
            ),
          ),

          SliverList(

            delegate: SliverChildBuilderDelegate(
                  (context, index) {

                return FutureBuilder<List<Catid>>(
                  future: fetchData2(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                                child: Text(
                                  'Faizan Khan',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PoppinsBold",
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> See_All_Realestate(id: '9971172204',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        'View All',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Colors.blue[700],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 440,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context,int len) {
                                final property = snapshot.data![len];
                                int displayIndex = snapshot.data!.length - len;
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Administater_View_Details(idd: '${property.id}',))
                                    );

                                  },
                                  child: Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(
                                        right: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                      color:Theme.of(context).brightness==Brightness.dark?Colors.white10:Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        // Property Image with Gradient Overlay
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(16)),
                                              child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property
                                                      .propertyPhoto}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: Center(
                                                          child: Image.asset(
                                                            AppImages.loader,
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: const Icon(
                                                          Icons
                                                              .home_work_outlined,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            // Gradient Overlay
                                            Positioned.fill(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius
                                                      .vertical(
                                                      top: Radius.circular(16)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(
                                                          0.4),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Price Tag
                                            Positioned(
                                              bottom: 16,
                                              left: 16,
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "₹${property.showPrice}",
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    fontFamily: "PoppinsBold",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Property Details
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                // Location
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_outlined,
                                                      size: 18,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        property
                                                            .locations,
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight
                                                              .w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),

                                                // Property Features
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _buildFeaturePill(
                                                      Icons.category_outlined,
                                                      property.typeOfProperty
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buyRent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.bhk.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.apartmentAddress,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                      fontSize: 14,
                                                      color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                Text("Property No: $displayIndex"/* ${len + 1} or +abc.data![len].id.toString()*//*+abc.data![len].Building_Name.toUpperCase()*/,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),

                                                // Footer
                                                const SizedBox(height: 12),

                                                Divider(
                                                  height: 1,
                                                  color: Colors.grey[200],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "ID: ${property.id}",
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    Text(
                                                      property.availableDate,
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              childCount: 1, // Number of categories
            ),
          ),

          SliverList(

            delegate: SliverChildBuilderDelegate(
                  (context, index) {

                return FutureBuilder<List<Catid>>(
                  future: fetchData_rajpur(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = snapshot.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                                child: Text(
                                  'Rajpur Properties',
                                  style: Theme
                                      .of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontFamily: "PoppinsBold",
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .onSurface,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> See_All_Realestate(id: '9818306096 ',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        'View All',
                                        style: Theme
                                            .of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(
                                          color: Colors.blue[700],
                                          fontWeight: FontWeight.w600,
                                          fontFamily: "Poppins",
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                        color: Colors.blue[700],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 440,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: data.length,
                              itemBuilder: (BuildContext context,int len) {
                                final property = snapshot.data![len];

                                int displayIndex = snapshot.data!.length - len;
                                return GestureDetector(
                                  onTap: (){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Administater_View_Details(idd: '${property.id}',))
                                    );

                                  },
                                  child: Container(
                                    width: 300,
                                    margin: const EdgeInsets.only(
                                        right: 16, bottom: 16),
                                    decoration: BoxDecoration(
                                      color:Theme.of(context).brightness==Brightness.dark?Colors.white10:Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.08),
                                          blurRadius: 12,
                                          offset: const Offset(0, 6),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        // Property Image with Gradient Overlay
                                        Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius
                                                  .vertical(
                                                  top: Radius.circular(16)),
                                              child: SizedBox(
                                                height: 200,
                                                width: double.infinity,
                                                child: CachedNetworkImage(
                                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property
                                                      .propertyPhoto}",
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: Center(
                                                          child: Image.asset(
                                                            AppImages.loader,
                                                            height: 50,
                                                            width: 50,
                                                          ),
                                                        ),
                                                      ),
                                                  errorWidget: (context, url,
                                                      error) =>
                                                      Container(
                                                        color: Colors.grey[100],
                                                        child: const Icon(
                                                          Icons
                                                              .home_work_outlined,
                                                          size: 50,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                ),
                                              ),
                                            ),
                                            // Gradient Overlay
                                            Positioned.fill(
                                              child: DecoratedBox(
                                                decoration: BoxDecoration(
                                                  borderRadius: const BorderRadius
                                                      .vertical(
                                                      top: Radius.circular(16)),
                                                  gradient: LinearGradient(
                                                    begin: Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                    colors: [
                                                      Colors.black.withOpacity(
                                                          0.4),
                                                      Colors.transparent,
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            // Price Tag
                                            Positioned(
                                              bottom: 16,
                                              left: 16,
                                              child: Container(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: 12, vertical: 6),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius
                                                      .circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      blurRadius: 8,
                                                      offset: const Offset(0, 2),
                                                    ),
                                                  ],
                                                ),
                                                child: Text(
                                                  "₹${property.showPrice}",
                                                  style: const TextStyle(
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 16,
                                                    fontFamily: "PoppinsBold",
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Property Details
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment
                                                  .start,
                                              children: [
                                                // Location
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons.location_on_outlined,
                                                      size: 18,
                                                      color: Colors.grey[600],
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Expanded(
                                                      child: Text(
                                                        property
                                                            .locations,
                                                        style: Theme
                                                            .of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                          color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight
                                                              .w600,
                                                        ),
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),

                                                // Property Features
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    _buildFeaturePill(
                                                      Icons.category_outlined,
                                                      property.typeOfProperty
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buyRent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.bhk.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.apartmentAddress,
                                                    style: Theme
                                                        .of(context)
                                                        .textTheme
                                                        .bodySmall
                                                        ?.copyWith(
                                                      fontSize: 14,
                                                      color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.grey[600],
                                                      fontWeight: FontWeight.w600,
                                                      fontFamily: "Poppins",
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                Text("Property No: $displayIndex"/* ${len + 1} or +abc.data![len].id.toString()*//*+abc.data![len].Building_Name.toUpperCase()*/,
                                                  style: Theme
                                                      .of(context)
                                                      .textTheme
                                                      .bodySmall
                                                      ?.copyWith(
                                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    fontFamily: "Poppins",
                                                  ),
                                                ),

                                                // Footer
                                                const SizedBox(height: 12),

                                                Divider(
                                                  height: 1,
                                                  color: Colors.grey[200],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "ID: ${property.id}",
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                    Text(
                                                      property.availableDate,
                                                      style: Theme
                                                          .of(context)
                                                          .textTheme
                                                          .bodySmall
                                                          ?.copyWith(
                                                        color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600],
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w600,
                                                        fontFamily: "Poppins",
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                );
              },
              childCount: 1, // Number of categories
            ),
          ),

        ],
      ),

    );
  }
// Helper Widget for Feature Pills
  Widget _buildFeaturePill(IconData icon, String text, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: iconColor,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
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

  void _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

}
