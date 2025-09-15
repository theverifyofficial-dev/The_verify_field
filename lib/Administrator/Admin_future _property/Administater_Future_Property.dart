import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Home_Screen_click/Commercial_property_Filter.dart';
import '../../Home_Screen_click/Filter_Options.dart';
import '../../ui_decoration_tools/constant.dart';
import 'Future_Property_Details.dart';
import 'See_All_Futureproperty.dart';
import 'package:intl/intl.dart';

class Catid {
  final int id;
  final String? images;
  final String? ownerName;
  final String? ownerNumber;
  final String? caretakerName;
  final String? caretakerNumber;
  final String? place;
  final String? buyRent;
  final String? typeOfProperty;
  final String? selectBhk;
  final String? floorNumber;
  final String? squareFeet;
  final String? propertyNameAddress;
  final String? buildingInformationFacilities;
  final String? propertyAddressForFieldworker;
  final String? ownerVehicleNumber;
  final String? yourAddress;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? currentDate;
  final String? longitude;
  final String? latitude;
  final String? roadSize;
  final String? metroDistance;
  final String? metroName;
  final String? mainMarketDistance;
  final String? ageOfProperty;
  final String? lift;
  final String? parking;
  final String? totalFloor;
  final String? residenceCommercial;
  final String? facility;

  Catid({
    required this.id,
    required this.images,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.typeOfProperty,
    required this.selectBhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.propertyNameAddress,
    required this.buildingInformationFacilities,
    required this.propertyAddressForFieldworker,
    required this.ownerVehicleNumber,
    required this.yourAddress,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.currentDate,
    required this.longitude,
    required this.latitude,
    required this.roadSize,
    required this.metroDistance,
    required this.metroName,
    required this.mainMarketDistance,
    required this.ageOfProperty,
    required this.lift,
    required this.parking,
    required this.totalFloor,
    required this.residenceCommercial,
    required this.facility,
  });

  factory Catid.FromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['id'] ?? 0,
      images: json['images'],
      ownerName: json['ownername'],
      ownerNumber: json['ownernumber'],
      caretakerName: json['caretakername'],
      caretakerNumber: json['caretakernumber'],
      place: json['place'],
      buyRent: json['buy_rent'],
      typeOfProperty: json['typeofproperty'],
      selectBhk: json['select_bhk'],
      floorNumber: json['floor_number'],
      squareFeet: json['sqyare_feet'],
      propertyNameAddress: json['propertyname_address'],
      buildingInformationFacilities: json['building_information_facilitys'],
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'],
      ownerVehicleNumber: json['owner_vehical_number'],
      yourAddress: json['your_address'],
      fieldWorkerName: json['fieldworkarname'],
      fieldWorkerNumber: json['fieldworkarnumber'],
      currentDate: json['current_date_'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      metroName: json['metro_name'],
      mainMarketDistance: json['main_market_distance'],
      ageOfProperty: json['age_of_property'],
      lift: json['lift'],
      parking: json['parking'],
      totalFloor: json['total_floor'],
      residenceCommercial: json['Residence_commercial'],
      facility: json['facility'],
    );
  }
}

class ADministaterShow_FutureProperty extends StatefulWidget {
  static const administaterShowFutureProperty = '/administaterShowFutureProperty';
  final bool fromNotification;
  final String? buildingId;
  const ADministaterShow_FutureProperty({super.key ,
    this.fromNotification = false,
    this.buildingId,});

  @override
  State<ADministaterShow_FutureProperty> createState() => _ADministaterShow_FuturePropertyState();
}

class _ADministaterShow_FuturePropertyState extends State<ADministaterShow_FutureProperty> {

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
        return DefaultTabController(
          length: 2,
          child: Padding(
            padding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5,),
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.all(3),
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey),
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
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=9711775300"); //sumit
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData1() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=9711275300"); //ravi
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData2() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=9971172204"); //faizan
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }
  Future<List<Catid>> av() async {
    var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=11"); //faizan
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
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
    final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
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
  String formatDate(String date) {
    try {
      return DateFormat("dd/MMM/yyyy").format(DateTime.parse(date));
    } catch (e) {
      return date; // fallback if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
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
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Center(child: Text('Error: ${abc.error}'));
                    } else if (!abc.hasData || abc.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = abc.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Sumit kasaniya',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    // color: Colors.white
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await fetchData();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SeeAll_FutureProperty(
                                            id: '9711775300',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 520,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: abc.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (abc.data == null || abc.data!.isEmpty ||
                                    index >= abc.data!.length) {
                                  return Container();
                                }

                                final property = abc.data![index];
                                final displayIndex = abc.data!.length - index;
                                final bool isDarkMode = Theme
                                    .of(context)
                                    .brightness == Brightness.dark;

                                // Color scheme for light and dark mode
                                final backgroundColor = isDarkMode ? Colors
                                    .grey[900] : Colors.white;
                                final textColor = isDarkMode
                                    ? Colors.white
                                    : Colors.black87;
                                final secondaryTextColor = isDarkMode ? Colors
                                    .grey[400] : Colors.grey[700];
                                final cardColor = isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100];
                                final greenColor = isDarkMode ? Colors
                                    .green[300] : Colors.green;
                                final redColor = isDarkMode
                                    ? Colors.red[300]
                                    : Colors.red;
                                final orangeColor = isDarkMode ? Colors
                                    .orange[300] : Colors.orange;
                                final blueColor = isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue;
                                final purpleColor = isDarkMode ? Colors
                                    .purple[300] : Colors.purple;
                                print(" Sumit : ${property.images}");

                                return Container(
                                  width: 340,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isDarkMode
                                          ? Colors.grey[700]!
                                          : Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              Administater_Future_Property_details(
                                                idd: property.id?.toString() ??
                                                    '',
                                              ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        // ---------- Image ----------
                                        ClipRRect(
                                          borderRadius: const BorderRadius
                                              .vertical(
                                              top: Radius.circular(20)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property
                                                .images ?? ""}",
                                            height: 220,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                Container(
                                                  height: 220,
                                                  color: Colors.grey[200],
                                                  child: const Center(
                                                    child: CircularProgressIndicator(
                                                        strokeWidth: 2),
                                                  ),
                                                ),
                                            errorWidget: (context, error,
                                                stack) =>
                                                Container(
                                                  height: 220,
                                                  color: Colors.grey[100],
                                                  child: Icon(
                                                      Icons.broken_image,
                                                      size: 60,
                                                      color: Colors.grey[400]),
                                                ),
                                          ),
                                        ),

                                        // ---------- Content ----------
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              // Chips: Property type / floors / buy-rent
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  if (property.typeOfProperty !=
                                                      null)
                                                    _buildChip(property
                                                        .typeOfProperty!,
                                                        greenColor!,
                                                        isDarkMode),
                                                  if (property.totalFloor !=
                                                      null)
                                                    _buildChip(
                                                        "Total: ${property
                                                            .totalFloor!}",
                                                        orangeColor!,
                                                        isDarkMode),
                                                  if (property.buyRent != null)
                                                    _buildChip(
                                                        property.buyRent!,
                                                        blueColor!, isDarkMode),
                                                ],
                                              ),

                                              const SizedBox(height: 12),

                                              // ---------- Owner Info ----------
                                              Text(
                                                "Owner Information",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      property.ownerName ??
                                                          'Unknown Owner',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight
                                                            .w600,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                  if (property.ownerNumber !=
                                                      null)
                                                    InkWell(
                                                      onTap: () {
                                                        FlutterPhoneDirectCaller
                                                            .callNumber(property
                                                            .ownerNumber!);
                                                      },
                                                      borderRadius: BorderRadius
                                                          .circular(30),
                                                      child: Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 12,
                                                            vertical: 6),
                                                        decoration: BoxDecoration(
                                                          color: blueColor!
                                                              .withOpacity(0.1),
                                                          borderRadius: BorderRadius
                                                              .circular(12),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.phone,
                                                                size: 16,
                                                                color: blueColor),
                                                            const SizedBox(
                                                                width: 4),
                                                            Text(
                                                              property
                                                                  .ownerNumber!,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: blueColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Property Address ----------
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Icon(Icons
                                                      .location_on_outlined,
                                                      size: 18,
                                                      color: secondaryTextColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      property
                                                          .propertyAddressForFieldworker ??
                                                          'Address not available',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight
                                                            .w400,
                                                        color: textColor,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Location + Date ----------
                                              Row(
                                                children: [
                                                  if (property.place != null)
                                                    _buildMiniChip(
                                                        property.place!,
                                                        blueColor!),
                                                  if (property.currentDate !=
                                                      null) ...[
                                                    const SizedBox(width: 8),
                                                    _buildMiniChip(property.currentDate??"", purpleColor!),
                                                  ],
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- IDs ----------
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Property No: $displayIndex",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        color: secondaryTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "ID: ${property.id
                                                        .toString() ?? 'N/A'}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight
                                                          .w600,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                  future: fetchData1(),
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Center(child: Text('Error: ${abc.error}'));
                    } else if (!abc.hasData || abc.data!.isEmpty) {
                      return Center(child: Text('No Building available'));
                    } else {
                      final data = abc.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Ravi Kumar',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await fetchData1();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SeeAll_FutureProperty(
                                            id: '9711275300',)));
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 520,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: abc.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (abc.data == null || abc.data!.isEmpty ||
                                    index >= abc.data!.length) {
                                  return Container();
                                }

                                final property = abc.data![index];
                                final displayIndex = abc.data!.length - index;
                                final bool isDarkMode = Theme
                                    .of(context)
                                    .brightness == Brightness.dark;

                                // Color scheme for light and dark mode
                                final backgroundColor = isDarkMode ? Colors
                                    .grey[900] : Colors.white;
                                final textColor = isDarkMode
                                    ? Colors.white
                                    : Colors.black87;
                                final secondaryTextColor = isDarkMode ? Colors
                                    .grey[400] : Colors.grey[700];
                                final cardColor = isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100];
                                final greenColor = isDarkMode ? Colors
                                    .green[300] : Colors.green;
                                final redColor = isDarkMode
                                    ? Colors.red[300]
                                    : Colors.red;
                                final orangeColor = isDarkMode ? Colors
                                    .orange[300] : Colors.orange;
                                final blueColor = isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue;
                                final purpleColor = isDarkMode ? Colors
                                    .purple[300] : Colors.purple;

                                return Container(
                                  width: 340,
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Administater_Future_Property_details(
                                            idd: property.id?.toString() ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ---------- Image ----------
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.images ?? ""}",
                                            height: 220,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              height: 220,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            ),
                                            errorWidget: (context, error, stack) => Container(
                                              height: 220,
                                              color: Colors.grey[100],
                                              child: Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
                                            ),
                                          ),
                                        ),

                                        // ---------- Content ----------
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Chips: Property type / floors / buy-rent
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  if (property.typeOfProperty != null)
                                                    _buildChip(property.typeOfProperty!, greenColor!, isDarkMode),
                                                  if (property.totalFloor != null)
                                                    _buildChip("Total: ${property.totalFloor!}", orangeColor!, isDarkMode),
                                                  if (property.buyRent != null)
                                                    _buildChip(property.buyRent!, blueColor!, isDarkMode),
                                                ],
                                              ),

                                              const SizedBox(height: 12),

                                              // ---------- Owner Info ----------
                                              Text(
                                                "Owner Information",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      property.ownerName ?? 'Unknown Owner',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                  if (property.ownerNumber != null)
                                                    InkWell(
                                                      onTap: () {
                                                        FlutterPhoneDirectCaller.callNumber(property.ownerNumber!);
                                                      },
                                                      borderRadius: BorderRadius.circular(30),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        decoration: BoxDecoration(
                                                          color: blueColor!.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.phone, size: 16, color: blueColor),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              property.ownerNumber!,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w500,
                                                                color: blueColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Property Address ----------
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.location_on_outlined, size: 18, color: secondaryTextColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      property.propertyAddressForFieldworker ??
                                                          'Address not available',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: textColor,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Location + Date ----------
                                              Row(
                                                children: [
                                                  if (property.place != null)
                                                    _buildMiniChip(property.place!, blueColor!),
                                                  if (property.currentDate != null) ...[
                                                    const SizedBox(width: 8),
                                                    _buildMiniChip(property.currentDate!, purpleColor!),
                                                  ],
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- IDs ----------
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Property No: $displayIndex",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                        color: secondaryTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "ID: ${property.id?.toString() ?? 'N/A'}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Center(child: Text('Error: ${abc.error}'));
                    } else if (!abc.hasData || abc.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = abc.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Faizan khan',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await fetchData2();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SeeAll_FutureProperty(
                                            id: '9971172204',)));
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 520,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: abc.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (abc.data == null || abc.data!.isEmpty ||
                                    index >= abc.data!.length) {
                                  return Container();
                                }

                                final property = abc.data![index];
                                final displayIndex = abc.data!.length - index;
                                final bool isDarkMode = Theme
                                    .of(context)
                                    .brightness == Brightness.dark;

                                // Color scheme for light and dark mode
                                final backgroundColor = isDarkMode ? Colors
                                    .grey[900] : Colors.white;
                                final textColor = isDarkMode
                                    ? Colors.white
                                    : Colors.black87;
                                final secondaryTextColor = isDarkMode ? Colors
                                    .grey[400] : Colors.grey[700];
                                final cardColor = isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100];
                                final greenColor = isDarkMode ? Colors
                                    .green[300] : Colors.green;
                                final redColor = isDarkMode
                                    ? Colors.red[300]
                                    : Colors.red;
                                final orangeColor = isDarkMode ? Colors
                                    .orange[300] : Colors.orange;
                                final blueColor = isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue;
                                final purpleColor = isDarkMode ? Colors
                                    .purple[300] : Colors.purple;

                                return Container(
                                  width: 340,
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Administater_Future_Property_details(
                                            idd: property.id?.toString() ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ---------- Image ----------
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.images ?? ""}",
                                            height: 220,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              height: 220,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            ),
                                            errorWidget: (context, error, stack) => Container(
                                              height: 220,
                                              color: Colors.grey[100],
                                              child: Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
                                            ),
                                          ),
                                        ),

                                        // ---------- Content ----------
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Chips: Property type / floors / buy-rent
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  if (property.typeOfProperty != null)
                                                    _buildChip(property.typeOfProperty!, greenColor!, isDarkMode),
                                                  if (property.totalFloor != null)
                                                    _buildChip("Total: ${property.totalFloor!}", orangeColor!, isDarkMode),
                                                  if (property.buyRent != null)
                                                    _buildChip(property.buyRent!, blueColor!, isDarkMode),
                                                ],
                                              ),

                                              const SizedBox(height: 12),

                                              Text(
                                                "Owner Information",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      property.ownerName ?? 'Unknown Owner',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                  if (property.ownerNumber != null)
                                                    InkWell(
                                                      onTap: () {
                                                        FlutterPhoneDirectCaller.callNumber(property.ownerNumber!);
                                                      },
                                                      borderRadius: BorderRadius.circular(30),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        decoration: BoxDecoration(
                                                          color: blueColor!.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.phone, size: 16, color: blueColor),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              property.ownerNumber!,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w500,
                                                                color: blueColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Property Address ----------
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.location_on_outlined, size: 18, color: secondaryTextColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      property.propertyAddressForFieldworker ??
                                                          'Address not available',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: textColor,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Location + Date ----------
                                              Row(
                                                children: [
                                                  if (property.place != null)
                                                    _buildMiniChip(property.place!, blueColor!),
                                                  if (property.currentDate != null) ...[
                                                    const SizedBox(width: 8),
                                                    _buildMiniChip(property.currentDate!, purpleColor!),
                                                  ],
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- IDs ----------
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Property No: $displayIndex",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                        color: secondaryTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "ID: ${property.id?.toString() ?? 'N/A'}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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
                  future: av(),
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Center(child: Text('Error: ${abc.error}'));
                    } else if (!abc.hasData || abc.data!.isEmpty) {
                      return Center(child: Text('No data available'));
                    } else {
                      final data = abc.data!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Avjit',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await fetchData2();
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) =>
                                          SeeAll_FutureProperty(
                                            id: '11',)));
                                  //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Show_See_All(iid: 'Flat',)));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    margin: EdgeInsets.only(right: 10),
                                    child: Text(
                                      'See All',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.red
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 520,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: abc.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (abc.data == null || abc.data!.isEmpty ||
                                    index >= abc.data!.length) {
                                  return Container();
                                }

                                final property = abc.data![index];
                                final displayIndex = abc.data!.length - index;
                                final bool isDarkMode = Theme
                                    .of(context)
                                    .brightness == Brightness.dark;

                                // Color scheme for light and dark mode
                                final backgroundColor = isDarkMode ? Colors
                                    .grey[900] : Colors.white;
                                final textColor = isDarkMode
                                    ? Colors.white
                                    : Colors.black87;
                                final secondaryTextColor = isDarkMode ? Colors
                                    .grey[400] : Colors.grey[700];
                                final cardColor = isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[100];
                                final greenColor = isDarkMode ? Colors
                                    .green[300] : Colors.green;
                                final redColor = isDarkMode
                                    ? Colors.red[300]
                                    : Colors.red;
                                final orangeColor = isDarkMode ? Colors
                                    .orange[300] : Colors.orange;
                                final blueColor = isDarkMode
                                    ? Colors.blue[300]
                                    : Colors.blue;
                                final purpleColor = isDarkMode ? Colors
                                    .purple[300] : Colors.purple;

                                return Container(
                                  width: 340,
                                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 15,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                    border: Border.all(
                                      color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Administater_Future_Property_details(
                                            idd: property.id?.toString() ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // ---------- Image ----------
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                          child: CachedNetworkImage(
                                            imageUrl:
                                            "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.images ?? ""}",
                                            height: 220,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) => Container(
                                              height: 220,
                                              color: Colors.grey[200],
                                              child: const Center(
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              ),
                                            ),
                                            errorWidget: (context, error, stack) => Container(
                                              height: 220,
                                              color: Colors.grey[100],
                                              child: Icon(Icons.broken_image, size: 60, color: Colors.grey[400]),
                                            ),
                                          ),
                                        ),

                                        // ---------- Content ----------
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              // Chips: Property type / floors / buy-rent
                                              Wrap(
                                                spacing: 8,
                                                runSpacing: 8,
                                                children: [
                                                  if (property.typeOfProperty != null)
                                                    _buildChip(property.typeOfProperty!, greenColor!, isDarkMode),
                                                  if (property.totalFloor != null)
                                                    _buildChip("Total: ${property.totalFloor!}", orangeColor!, isDarkMode),
                                                  if (property.buyRent != null)
                                                    _buildChip(property.buyRent!, blueColor!, isDarkMode),
                                                ],
                                              ),

                                              const SizedBox(height: 12),

                                              Text(
                                                "Owner Information",
                                                style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                  color: secondaryTextColor,
                                                ),
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      property.ownerName ?? 'Unknown Owner',
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600,
                                                        color: textColor,
                                                      ),
                                                    ),
                                                  ),
                                                  if (property.ownerNumber != null)
                                                    InkWell(
                                                      onTap: () {
                                                        FlutterPhoneDirectCaller.callNumber(property.ownerNumber!);
                                                      },
                                                      borderRadius: BorderRadius.circular(30),
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                        decoration: BoxDecoration(
                                                          color: blueColor!.withOpacity(0.1),
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.phone, size: 16, color: blueColor),
                                                            const SizedBox(width: 4),
                                                            Text(
                                                              property.ownerNumber!,
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                fontWeight: FontWeight.w500,
                                                                color: blueColor,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Property Address ----------
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Icon(Icons.location_on_outlined, size: 18, color: secondaryTextColor),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      property.propertyAddressForFieldworker ??
                                                          'Address not available',
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.w400,
                                                        color: textColor,
                                                      ),
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- Location + Date ----------
                                              Row(
                                                children: [
                                                  if (property.place != null)
                                                    _buildMiniChip(property.place!, blueColor!),
                                                  if (property.currentDate != null) ...[
                                                    const SizedBox(width: 8),
                                                    _buildMiniChip(property.currentDate!, purpleColor!),
                                                  ],
                                                ],
                                              ),

                                              const SizedBox(height: 14),

                                              // ---------- IDs ----------
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "Property No: $displayIndex",
                                                      style: TextStyle(
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                        color: secondaryTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                    "ID: ${property.id?.toString() ?? 'N/A'}",
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w600,
                                                      color: textColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
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

// Updated helper widget for feature chips with dark mode support
  Widget _buildFeatureChip(String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDarkMode ? color.withOpacity(0.2) : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(isDarkMode ? 0.4 : 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600,
        ),
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

  Widget _buildChip(String label, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(isDarkMode ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildMiniChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: color,
        ),
      ),
    );
  }
}
