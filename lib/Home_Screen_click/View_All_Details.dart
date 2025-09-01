import 'dart:convert';
import 'dart:ui';
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
import 'package:verify_feild_worker/property_preview.dart';

import '../ui_decoration_tools/constant.dart';
import '../model/realestateSlider.dart';
import 'Add_image_under_property.dart';
import 'Add_images_in_Realestate.dart';
import 'Delete_Image.dart';
import 'Edit_Page_Realestate.dart';
import 'Add_multi_image_in_Realestate.dart';
import 'Edit_Property_SecondPage.dart';
import 'Real-Estate.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'package:xml/xml.dart' as xml;

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
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
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
      maintenance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldWorkerAddress: json['fieldworkar_address'] ?? '',
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
      furnishing: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      fieldWorkerCurrentLocation: json['field_worker_current_location'] ?? '',
      caretakerName: json['care_taker_name'] ?? '',
      caretakerNumber: json['care_taker_number'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      subid: json['subid'] ?? 0,
    );
  }
}



class View_Details extends StatefulWidget {
  final int id;

  const View_Details({super.key, required this.id});

  @override
  State<View_Details> createState() => _View_DetailsState();
}

class _View_DetailsState extends State<View_Details> {
  Future<void> Book_property() async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=$_id&looking=Book'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_Real_Estate(),), (route) => route.isFirst);
      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<List<RealEstateSlider>> fetchCarouselData(int id) async {
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
      // No data found for this subid, return empty list instead of throwing
      return [];
    } else {
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }

  Future<List<Catid>> fetchData(int id) async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/details_page_data_in_main_realestate?P_id=$id");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> listResponse = json.decode(response.body);
      return listResponse.map((data) => Catid.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
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

 // final result = await fetchData();

  List<String> name = [];

 // late final int iid;

  int _id = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loaduserdata();
      if (_id != 0) {
        setState(() {
          _propertyFuture = fetchData(widget.id);
          _galleryFuture = fetchCarouselData(_id); // pass _id here
        });
      } else {
        print('Invalid ID loaded: $_id');
      }
    });
  }



  Future<void> _loaduserdata() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      int loadedId = prefs.getInt('id_Building') ?? 0;
      print('Loaded ID from SharedPreferences: $loadedId');
      setState(() {
        _id = loadedId;
      });
    } catch (e) {
      print('Error loading ID: $e');
      setState(() {
        _id = 0;
      });
    }
  }
  Future<List<Catid>>? _propertyFuture;
  Future<List<RealEstateSlider>>? _galleryFuture;

  final PageController _galleryController = PageController();
  int _currentGalleryIndex = 0;
  void _refreshData() {
    setState(() {
      _propertyFuture = fetchData(widget.id);
      _galleryFuture = fetchCarouselData(_id);
      data = 'Refreshed Data at ${DateTime.now()}';

    });
  }
  String data = 'Initial Data';


//  final result = await profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        // actions: [
        //
        //   PopupMenuButton<String>(
        //     icon: Icon(Icons.how_to_reg
        //       ,color: Colors.white,size: 30,),
        //     onSelected: (value) {
        //       if (value == 'Book Property') {
        //         showDialog<bool>(
        //           context: context,
        //           builder: (context) => AlertDialog(
        //             title: Text('Book Property'),
        //             content: Text('Do you really want to book this property?'),
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(12),
        //             ),
        //             backgroundColor: Theme.of(context).dialogBackgroundColor,
        //             titleTextStyle: TextStyle(
        //               color: Theme.of(context).textTheme.titleLarge?.color,
        //               fontSize: MediaQuery.of(context).size.width * 0.05,
        //               fontWeight: FontWeight.bold,
        //             ),
        //             contentTextStyle: TextStyle(
        //               color: Theme.of(context).textTheme.bodyMedium?.color,
        //             ),
        //             actions: [
        //               TextButton(
        //                 onPressed: () => Navigator.pop(context, false),
        //                 child: Text(
        //                   'CANCEL',
        //                   style: TextStyle(
        //                     color: Theme.of(context).colorScheme.error,
        //                   ),
        //                 ),
        //               ),
        //               ElevatedButton(
        //                 style: ElevatedButton.styleFrom(
        //                   backgroundColor: Theme.of(context).colorScheme.tertiary,
        //                 ),
        //                 onPressed: () async {
        //                   await Book_property();
        //                   Navigator.pop(context, true);
        //                 },
        //                 child: Text(
        //                   'CONFIRM',
        //                   style: TextStyle(
        //                     color: Theme.of(context).colorScheme.onTertiary,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           ),
        //         );
        //       }
        //     },
        //     itemBuilder: (context) => [
        //       PopupMenuItem(
        //         value: 'Book Property',
        //         child: Text('Book Property'),
        //       ),
        //     ],
        //   ),
        // ],
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
            } else {
              final property = propertySnapshot.data!.first;
              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Main Property Image with Gallery Indicator
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropertyPreview(
                                  ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: "property-${property.id}",
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              height: MediaQuery.of(context).size.height * 0.25,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),

                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(isDarkMode ? 0.4 : 0.2),
                                    blurRadius: 10,
                                    offset: Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                child: CachedNetworkImage(

                                  imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${property.propertyPhoto}",
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Center(
                                      child: Image.asset(
                                        AppImages.loader,
                                        height: 70,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                                    child: Center(
                                      child: Image.asset(
                                        AppImages.imageNotFound,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Property Details Section
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
                          // Property Title and Basic Info
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
                            value: "₹ ${property.maintenance}",
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
                                label: property.typeofProperty,
                                color: Colors.blueAccent,
                                isDarkMode: isDarkMode,
                              ),
                              SizedBox(width: 8),
                              _FactChip(
                                icon: Icons.square_foot,
                                label: "${property.squarefit} sqft",
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
                            name: property.caretakerName,
                            phone: property.caretakerNumber,
                            role: "Caretaker",
                            color: Colors.purpleAccent,
                            onCall: () => _showCallConfirmation(
                              context,
                              property.caretakerName,
                              property.caretakerNumber,
                            ),
                            isDarkMode: isDarkMode,
                          ),

                          SizedBox(height: 10),

                          // Property Details
                          _SectionHeader(
                            title: "Property Details",
                            isDarkMode: isDarkMode,
                          ),
                          _FactChip(
                            icon: Icons.install_desktop_sharp,
                            label: "Property Id : "+ property.id.toString(),
                            color: Colors.lightGreen,
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

                          SizedBox(height: 8),

                          _DetailRow(
                            icon: Icons.construction,
                            title: "Facilities",
                            value: property.facility,
                            color: Colors.blueGrey,
                            isDarkMode: isDarkMode,
                          ),
                          _DetailRow(
                            icon: Icons.chair,
                            title: "Furnishing",
                            value: "${property.furnishing}, ${property.apartmentName}",
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
                            icon: Icons.gas_meter_rounded,
                            title: "Meter Type & Lift Availability",
                            value:  property.meter+" | "+property.lift ,
                            color: Colors.deepPurpleAccent,
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
                          // SizedBox(height: 24),
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
                            title: "Property Ask & Last",
                            value: "₹ ${property.askingPrice}"+" | " + "₹ ${property.lastPrice}",
                            color: Colors.greenAccent,
                            isDarkMode: isDarkMode,
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
      bottomNavigationBar: _BottomActionBar(

        onAddImages: () {
          // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MultiImageCompressor(id: _id.toString(),)));
          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MultiImagePickerPage(propertyId: _id,)));

        }, onEdit: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> UpdateRealEstateProperty(propertyId: _id,)));

      },
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
  } }


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


class _BottomActionBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onAddImages;
  final bool isDarkMode;

  const _BottomActionBar({
    required this.onEdit,
    required this.onAddImages,
    this.isDarkMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0,top: 5,left: 8,right: 8),
        child: Row(
          children: [


            // 🌈 Add Images Button with Gradient
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.blue.shade400, Colors.blueAccent]
                        : [Colors.blueAccent, Colors.blue.shade700],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.folder_copy_sharp,size: 25,),
                  label: const Text('Update data ',style: TextStyle(fontFamily: "PoppinsBold",fontSize: 15),),
                  onPressed:  onEdit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 6,),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkMode
                        ? [Colors.deepPurple.shade700, Colors.purpleAccent]
                        : [Colors.purple, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.add_photo_alternate,size: 25,),
                  label: const Text('Add Images',style: TextStyle(fontFamily: "PoppinsBold",fontSize: 15),),
                  onPressed:
                    onAddImages,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


Widget infoSection({
  required IconData icon,
  required String title,
  required String value,
  required bool isDarkMode,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      border: Border.all(
          color: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!),
      borderRadius: BorderRadius.circular(10),
      color: isDarkMode ? Colors.grey[900] : Colors.grey[50],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: Colors.red),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode
                  ? Colors.white.withOpacity(0.9)
                  : Colors.black.withOpacity(0.8),
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    ),
  );
}




