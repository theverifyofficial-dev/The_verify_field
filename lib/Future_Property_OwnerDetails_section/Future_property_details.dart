import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import '../property_preview.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/futureProperty_Slideer.dart';
import 'Add_FutureProperty_Images.dart';
import 'Duplicate_Property.dart';
import 'Edit_futureproperty/Edit_Building.dart';
import 'Update_future_building.dart';
import 'add_flat_form.dart';
import 'New_Update/under_flats_infutureproperty.dart';
import 'package:intl/intl.dart';
// Your existing model classes
class FutureProperty2 {
  final int id;
  final String images;
  final String ownerName;
  final String ownerNumber;
  final String caretakerName;
  final String caretakerNumber;
  final String place;
  final String buyRent;
  final String typeOfProperty;
  final String selectBhk;
  final String floorNumber;
  final String squareFeet;
  final String propertyNameAddress;
  final String buildingInformationFacilities;
  final String propertyAddressForFieldworker;
  final String ownerVehicleNumber;
  final String yourAddress;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String currentDate;
  final String longitude;
  final String latitude;
  final String roadSize;
  final String metroDistance;
  final String metroName;
  final String mainMarketDistance;
  final String ageOfProperty;
  final String lift;
  final String parking;
  final String totalFloor;
  final String apartmentName;
  final String facility;
  final String localityList;
  final String currentLocation;
  final String residenceCommercial;
  FutureProperty2({
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
    required this.fieldworkerName,
    required this.fieldworkerNumber,
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
    required this.apartmentName,
    required this.facility,
    required this.currentLocation,
    required this.residenceCommercial,
    required this.localityList,
  });
  factory FutureProperty2.fromJson(Map<String, dynamic> json) {
    return FutureProperty2(
      id: json['id'],
      images: json['images'] ?? '',
      ownerName: json['ownername'] ?? '',
      ownerNumber: json['ownernumber'] ?? '',
      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: json['caretakernumber'] ?? '',
      place: json['place'] ?? '',
      buyRent: json['buy_rent'] ?? '',
      typeOfProperty: json['typeofproperty'] ?? '',
      selectBhk: json['select_bhk'] ?? '',
      floorNumber: json['floor_number'] ?? '',
      squareFeet: json['sqyare_feet'] ?? '',
      propertyNameAddress: json['propertyname_address'] ?? '',
      buildingInformationFacilities: json['building_information_facilitys'] ?? '',
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'] ?? '',
      ownerVehicleNumber: json['owner_vehical_number'] ?? '',
      yourAddress: json['your_address'] ?? '',
      fieldworkerName: json['fieldworkarname'] ?? '',
      fieldworkerNumber: json['fieldworkarnumber'] ?? '',
      currentDate: json['current_date_'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      metroName: json['metro_name'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      lift: json['lift'] ?? '',
      parking: json['parking'] ?? '',
      totalFloor: json['total_floor'] ?? '',
      apartmentName: json['apartment_name'] ?? '',
      facility: json['facility'] ?? '',
      currentLocation: json['your_address'] ?? '',
      residenceCommercial: json['Residence_commercial'] ?? '',
      localityList: json['locality_list'] ?? '',
    );
  }
}
class Ground {
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
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerLocation;
  final String careTakerName;
  final String careTakerNumber;
  final String subid;
  Ground({
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
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
  });
  factory Ground.fromJson(Map<String, dynamic> json) {
    return Ground(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeOfProperty: json['Typeofproperty'] ?? '',
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
      currentDate: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      subid: json['subid'] ?? '',
    );
  }
}
class DocumentMainModel_F {
  final String dimage;
  DocumentMainModel_F({
    required this.dimage,
  });
  factory DocumentMainModel_F.fromJson(Map<String, dynamic> json) {
    return DocumentMainModel_F(
      dimage: json['img'] ?? '',
    );
  }
}
class Future_Property_details extends StatefulWidget {
  final String idd;
  Future_Property_details({super.key, required this.idd});
  @override
  State<Future_Property_details> createState() => _Future_Property_detailsState();
}
class _Future_Property_detailsState extends State<Future_Property_details> {
  // API Methods
  Future<List<Ground>> fetchData_Ground() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=G%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<Ground>> fetchData_first() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/frist_floor_base_show_mainrealestae?Floor_=1%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<Ground>> fetchData_second() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/second_floor_base_show_mainrealestae?Floor_=2%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<Ground>> fetchData_third() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=3%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<Ground>> fetchData_four() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=4%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<Ground>> fetchData_five() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=5%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<Ground>> fetchData_six() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=6%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<Ground>> fetchData_seven() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/third_floor_base_show_mainrealestae?Floor_=7%20Floor&subid=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      return listResponse.map((data) => Ground.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<FutureProperty2>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_future_property_by_id?id=${widget.idd}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      listResponse.sort((a, b) => b['id'].compareTo(a['id']));
      return listResponse.map((data) => FutureProperty2.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }
  Future<List<DocumentMainModel_F>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_future_property_multiple_images?subid=${widget.idd}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return DocumentMainModel_F(
          dimage: item['img'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
  Future<Map<String, dynamic>> _fetchAllData() async {
    try {
      final results = await Future.wait([
        fetchData_Ground(),
        fetchData_first(),
        fetchData_second(),
        fetchData_third(),
        fetchData_four(),
        fetchData_five(),
        fetchData_six(),
        fetchData_seven(),
        fetchData(),
        fetchCarouselData(),
      ]);
      return {
        'groundList': results[0],
        'firstList': results[1],
        'secondList': results[2],
        'thirdList': results[3],
        'fourthList': results[4],
        'fifthList': results[5],
        'sixList': results[6],
        'sevenList': results[7],
        'catidList': results[8],
        'imageList': results[9],
      };
    } catch (e) {
      print("Error fetching all data: $e");
      throw Exception('Failed to load all data');
    }
  }
  Future<void> _refreshAllData() async {
    try {
      final ground = await fetchData_Ground();
      final first = await fetchData_first();
      final second = await fetchData_second();
      final third = await fetchData_third();
      final fourth = await fetchData_four();
      final fifth = await fetchData_five();
      final sixth = await fetchData_six();
      final seven = await fetchData_seven();
      final catids = await fetchData();
      final images = await fetchCarouselData();
      setState(() {
        // You can store these in variables if needed
      });
    } catch (e) {
      print('Refresh Error: $e');
    }
  }
  void _handleMenuItemClick(String value) async {
    print("You clicked: $value");
    if (value == 'Edit Building') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateRealEstateProperty(
            propertyId: int.parse(widget.idd),
          ),
        ),
      );
    }
    if (value.toString() == 'Add Building Images') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FuturePropertyFileUploadPage(
            idd: widget.idd,
          ),
        ),
      );
    }
  }
  void _showCallDialog(BuildContext context, String number, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Call $type"),
        content: Text('Do you want to call $number?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              FlutterPhoneDirectCaller.callNumber(number);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Custom Header without AppBar
            _buildCustomHeader(isDarkMode),
            // Floor-wise Flats Sections (moved to top)
            _buildFloorSection("Ground Floor", fetchData_Ground(), isDarkMode),
            _buildFloorSection("First Floor", fetchData_first(), isDarkMode),
            _buildFloorSection("Second Floor", fetchData_second(), isDarkMode),
            _buildFloorSection("Third Floor", fetchData_third(), isDarkMode),
            _buildFloorSection("Fourth Floor", fetchData_four(), isDarkMode),
            _buildFloorSection("Fifth Floor", fetchData_five(), isDarkMode),
            _buildFloorSection("Sixth Floor", fetchData_six(), isDarkMode),
            _buildFloorSection("Seventh Floor", fetchData_seven(), isDarkMode),
            // Property Images Carousel (now below floors)
            _buildImageCarouselSection(isDarkMode),
            // Property Overview Section
            _buildPropertyOverviewSection(isDarkMode),
            // Building Details Section
            _buildBuildingDetailsSection(isDarkMode),
            // Add spacing at the bottom
            const SliverToBoxAdapter(child: SizedBox(height: 1)),
          ],
        ),
      ),
      bottomNavigationBar: _buildAddFlatsButton(isDarkMode),
    );
  }
  // Custom Header without AppBar (AppBar and name removed)
  SliverToBoxAdapter _buildCustomHeader(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.blue,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              // Back Button
              // Container(
              // decoration: BoxDecoration(
              // color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
              // borderRadius: BorderRadius.circular(12),
              // ),
              // child:
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  PhosphorIcons.caret_left_bold,
                  color: isDarkMode ? Colors.white : Colors.black87,
                  size: 30,weight: 50,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              // ),
              const Spacer(),
              Image.asset(AppImages.transparent,height: 45,),
              const Spacer(),
              // Menu Button
              // Container(
              // decoration: BoxDecoration(
              // color: isDarkMode ? Colors.grey[700] : Colors.grey[100],
              // borderRadius: BorderRadius.circular(12),
              // ),
              // child:
              PopupMenuButton<String>(
                onSelected: _handleMenuItemClick,
                itemBuilder: (BuildContext context) {
                  return {
                    'Edit Building',
                    'Add Building Images',
                  }.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                    );
                  }).toList();
                },
                icon: Icon(
                  Icons.more_vert,
                  color: isDarkMode ? Colors.white : Colors.black87,size: 30,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              //),
            ],
          ),
        ),
      ),
    );
  }
  // Image Carousel Section
  SliverToBoxAdapter _buildImageCarouselSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<DocumentMainModel_F>>(
        future: fetchCarouselData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 250,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(
              height: 180,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library, size: 50, color: isDarkMode ? Colors.black87 : Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    "No Images Available",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    enableInfiniteScroll: true,
                    viewportFraction: 0.9,
                    aspectRatio: 16 / 9,
                  ),
                  items: snapshot.data!.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropertyPreview(
                                  ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                key: ValueKey(item.dimage), // Added unique key to force distinct caching
                                imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: isDarkMode ? Colors.grey[200] : Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, error, stackTrace) => Container(
                                  color: isDarkMode ? Colors.grey[200] : Colors.grey[200],
                                  child: const Icon(Icons.error, color: Colors.grey, size: 40),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
  // Property Overview Section
  SliverToBoxAdapter _buildPropertyOverviewSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<FutureProperty2>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard(isDarkMode);
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildErrorCard(isDarkMode);
          } else {
            final property = snapshot.data![0];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property Type Tags - Fixed overflow with Wrap
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (property.place.isNotEmpty) _buildChip(property.place, Colors.blue, isDarkMode),
                      if (property.residenceCommercial.isNotEmpty) _buildChip(property.residenceCommercial, Colors.green, isDarkMode),
                      if (property.buyRent.isNotEmpty) _buildChip(property.buyRent, Colors.orange, isDarkMode),
                      if (property.typeOfProperty.isNotEmpty) _buildChip(property.typeOfProperty, Colors.purple, isDarkMode),
                    ].where((chip) => chip !=  null).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Property Address - Fixed text overflow
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.red[400], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          property.propertyNameAddress.isNotEmpty
                              ? property.propertyNameAddress
                              : "No address available",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quick Stats - Changed to Wrap for responsive layout on small devices
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceAround,
                        children: [
                          _buildStatItem("Total Floors", property.totalFloor, Icons.stairs, isDarkMode),
                          _buildStatItem("Road Size", property.roadSize, Icons.aod, isDarkMode),
                          _buildStatItem("Age", property.ageOfProperty, Icons.calendar_today, isDarkMode),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  // Floor Section Builder
  SliverToBoxAdapter _buildFloorSection(String floorName, Future<List<Ground>> futureData, bool isDarkMode) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Ground>>(
        future: futureData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildFloorLoadingSection(floorName, isDarkMode);
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return const SizedBox.shrink(); // Hide empty floors
          } else {
            return _buildFloorContentSection(floorName, snapshot.data!, isDarkMode);
          }
        },
      ),
    );
  }
  // Floor Content Section - Horizontal scrolling cards
  Widget _buildFloorContentSection(String floorName, List<Ground> flats, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) * 0.65; // Responsive width: 65% of available space minus margins
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floor Header
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    floorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${flats.length} flats",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Flats Horizontal List - Responsive height based on card width
          SizedBox(
            height: cardWidth * 1.2, // Approximate aspect ratio for better responsiveness
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: flats.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildFlatCard(flats[index], isDarkMode, cardWidth),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // Individual Flat Card - Responsive width and unique key for images
  Widget _buildFlatCard(Ground flat, bool isDarkMode, double cardWidth) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => underflat_futureproperty(
              id: '${flat.id}',
              Subid: '${flat.subid}',
            ),
          ),
        );
      },
      child: SizedBox(
        width: cardWidth,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Flat Image - Expanded flex
              Expanded(
                flex: 3,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: CachedNetworkImage(
                    key: ValueKey('${flat.id}_${flat.propertyPhoto}'), // Unique key using flat ID + photo to prevent caching issues across flats
                    imageUrl: flat.propertyPhoto.isNotEmpty
                        ? "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${flat.propertyPhoto}"
                        : "", // Empty URL if no photo to avoid invalid requests
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, error, stackTrace) => Container(
                      color: Colors.grey[200],
                      child:  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.home_outlined, size: 40, color: Colors.grey), // Changed to outlined for less "same image" feel
                          SizedBox(height: 4),
                          Text("No Image", style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Flat Details - Expanded flex
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              "${flat.bhk} • ${flat.typeOfProperty}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (flat.flatNumber.isNotEmpty)
                            Text(
                              "Flat ${flat.flatNumber}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                      Text(
                        flat.locations.isNotEmpty ? flat.locations : "No location",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue[100]!),
                            ),
                            child: Text(
                              flat.buyRent.isNotEmpty ? flat.buyRent : "N/A",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Text(
                           " ${flat.id}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),


                          Text(
                            "₹${flat.showPrice.isNotEmpty ? flat.showPrice : "0"}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
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
      ),
    );
  }
  // Building Details Section
  SliverToBoxAdapter _buildBuildingDetailsSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<FutureProperty2>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard(isDarkMode);
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildErrorCard(isDarkMode);
          } else {
            final property = snapshot.data![0];
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Header
                  Row(
                    children: [
                      Icon(Icons.business, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "Building Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Contact Information
                  _buildContactSection(property, isDarkMode),
                  const SizedBox(height: 20),
                  // Property Specifications - Fixed grid layout with better overflow handling
                  _buildSpecificationsSection(property, isDarkMode),
                  const SizedBox(height: 20),
                  // Location Information
                  _buildLocationSection(property, isDarkMode),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  // Contact Section
  Widget _buildContactSection(FutureProperty2 property, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Information",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        // Owner Info
        if (property.ownerName.isNotEmpty || property.ownerNumber.isNotEmpty)
          _buildContactCard(
            "Owner",
            property.ownerName,
            property.ownerNumber,
            Icons.person,
            Colors.blue,
            isDarkMode,
          ),
        if (property.ownerName.isNotEmpty || property.ownerNumber.isNotEmpty)
          const SizedBox(height: 8),
        // Caretaker Info
        if (property.caretakerName.isNotEmpty || property.caretakerNumber.isNotEmpty)
          _buildContactCard(
            "Caretaker",
            property.caretakerName,
            property.caretakerNumber,
            Icons.support_agent,
            Colors.green,
            isDarkMode,
          ),
      ],
    );
  }
  // Contact Card
  Widget _buildContactCard(String title, String name, String number, IconData icon, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name.isNotEmpty ? name : "Not available",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (number.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () => _showCallDialog(context, number, title),
                    child: Text(
                      number,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (number.isNotEmpty)
            IconButton(
              onPressed: () => _showCallDialog(context, number, title),
              icon: Icon(Icons.phone, color: color, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
  // Specifications Section - Improved with dynamic grid and better overflow
  Widget _buildSpecificationsSection(FutureProperty2 property, bool isDarkMode) {
    final specifications = [
      //{"icon": Icons.stairs, "label": "Total Floors", "value": property.totalFloor},
      //{"icon": Icons.aod, "label": "Road Size", "value": property.roadSize},
      {"icon": Icons.train, "label": "Metro Station", "value": property.metroName},
      {"icon": Icons.place, "label": "Metro Distance", "value": property.metroDistance},
      {"icon": Icons.shopping_cart, "label": "Market Distance", "value": property.mainMarketDistance},
      //{"icon": Icons.calendar_today, "label": "Property Age", "value": property.ageOfProperty},
      {"icon": Icons.elevator, "label": "Lift", "value": property.lift},
      {"icon": Icons.local_parking, "label": "Parking", "value": property.parking},
    ].where((spec) => (spec["value"] as String).isNotEmpty).toList();
    if (specifications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "No specifications available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Specifications",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5, // Adjusted for better fit and less overflow
              ),
              itemCount: specifications.length,
              itemBuilder: (context, index) {
                final spec = specifications[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(spec["icon"] as IconData, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              spec["label"] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spec["value"] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
  // Location Section
  Widget _buildLocationSection(FutureProperty2 property, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (property.propertyNameAddress.isNotEmpty)
                _buildLocationItem("Property Address", property.propertyNameAddress, isDarkMode),
              if (property.propertyNameAddress.isNotEmpty) const SizedBox(height: 8),
              if (property.propertyAddressForFieldworker.isNotEmpty)
                _buildLocationItem("Field Worker Address", property.propertyAddressForFieldworker, isDarkMode),
              if (property.propertyAddressForFieldworker.isNotEmpty) const SizedBox(height: 8),
              if (property.yourAddress.isNotEmpty)
                _buildLocationItem("Current Location", property.yourAddress, isDarkMode, isClickable: true),
            ],
          ),
        ),
      ],
    );
  }
  // Location Item
  Widget _buildLocationItem(String label, String value, bool isDarkMode, {bool isClickable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label == "Current Location")
              Icon(
                Icons.location_on,
                color: Colors.red,
                size: 16,
              ),
            if (label == "Current Location") const SizedBox(width: 4),
            Expanded(
              child: isClickable
                  ? GestureDetector(
                onTap: () async {
                  final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(value)}");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700, // Highlighted with bold
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
                  : Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700, // Highlighted with bold
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
  // Add Flats Button
  Widget _buildAddFlatsButton(bool isDarkMode) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchAllData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            padding: const EdgeInsets.all(16),
            child: const Center(child: CircularProgressIndicator(color: Colors.black)),
          );
        } else if (snapshot.hasError || snapshot.data == null || (snapshot.data!['catidList'] as List).isEmpty) {
          return Container();
        } else {
          final catidList = snapshot.data!['catidList'] as List<FutureProperty2>;
          final data = catidList[0];
          return Container(
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
              onPressed: () {
                if (data.roadSize.isEmpty ||
                    data.metroName.isEmpty ||
                    data.metroDistance.isEmpty ||
                    data.mainMarketDistance.isEmpty ||
                    data.ageOfProperty.isEmpty ||
                    data.lift.isEmpty ||
                    data.parking.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "⚠ Please update property details before adding flats.",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      duration: Duration(seconds: 4),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Add_Flatunder_futureproperty(
                      id: widget.idd,
                      Owner_name: data.ownerName,
                      Owner_num: data.ownerNumber,
                      Caretaker_name: data.caretakerName,
                      Caretaker_num: data.caretakerNumber,
                      market_dis: data.mainMarketDistance,
                      metro_name: data.metroName,
                      metro_dis: data.metroDistance,
                      road_size: data.roadSize,
                      age_property: data.ageOfProperty,
                      apartment_address: data.propertyNameAddress,
                      apartment_name: data.propertyNameAddress,
                      field_address: data.propertyAddressForFieldworker,
                      current_loc: data.currentDate,
                      place: data.place,
                      lift: data.lift,
                      totalFloor: data.totalFloor,
                      Residence_commercial: data.residenceCommercial,
                      facility: data.facility,
                      google_loc: data.currentLocation, locality_list: data.localityList, apartment: '',
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "Add New Flat",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
  // Helper Widgets
  Widget _buildChip(String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
  Widget _buildStatItem(String label, String value, IconData icon, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  Widget _buildFloorLoadingSection(String floorName, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) * 0.65;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              floorName,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: cardWidth * 1.2,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: cardWidth,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: CircularProgressIndicator(color: Colors.black)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLoadingCard(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator(color: Colors.black)),
    );
  }
  Widget _buildErrorCard(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            "Unable to load property details",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}