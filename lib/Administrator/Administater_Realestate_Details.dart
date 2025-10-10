import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Model.dart';

import '../Home_Screen_click/Preview_Image.dart';
import '../property_preview.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/realestateSlider.dart';
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


class Administater_View_Details extends StatefulWidget {
  String idd;
  Administater_View_Details({super.key, required this.idd});

  @override
  State<Administater_View_Details> createState() => _Administater_View_DetailsState();
}

class _Administater_View_DetailsState extends State<Administater_View_Details> {


  int _currentIndex = 0;

  Future<List<Catid>> fetchData() async {
    final url = Uri.parse(
      "https://verifyserve.social/WebService4.asmx/display_main_realesate_data_by_id?P_id=${widget.idd}",
    );

    // var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> Book_property() async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=${widget.idd}&looking=Book'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
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
  late PageController _pageController;
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "-";
    try {
      DateTime date = DateTime.parse(dateString); // expects yyyy-MM-dd or full ISO format
      return DateFormat('dd-MM-yyyy').format(date); // Example: 29-08-2025
    } catch (e) {
      return dateString; // fallback if parsing fails
    }
  }
  int _id = 0;
// Declare this at the top of your widget class
  late Future<List<RealEstateSlider>> _futureCarousel;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(initialPage: 0);

    // ✅ Assign Future<List<RealEstateSlider>> directly
    _futureCarousel = fetchCarouselData(int.parse(widget.idd));

    // ✅ Optionally call other setup methods, if needed
    _loaduserdata(); // but don't assign it to _futureCarousel
  }


  Future<List<RealEstateSlider>> fetchCarouselData(int subid) async {
    final response = await http.get(Uri.parse(
        'https://verifyserve.social/WebService4.asmx/show_multiple_image_in_main_realestate?subid=$subid'));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => RealEstateSlider.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load carousel data');
    }
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
        // actions:  [
        //   GestureDetector(
        //     onTap: () async {
        //
        //       showDialog<bool>(
        //         context: context,
        //         builder: (context) => AlertDialog(
        //           title: Text('Delete Property'),
        //           content: Text('Do you really want to Delete This Property?'),
        //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        //           backgroundColor: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white,
        //           actions: <Widget>[
        //             ElevatedButton(
        //               onPressed: () => Navigator.of(context).pop(false),
        //               child: Text('No'),
        //             ),
        //             ElevatedButton(
        //               onPressed: () async {
        //                 final result_delete = await fetchData();
        //                 print(result_delete.first.id);
        //                 DeletePropertybyid('${result_delete.first.id}');
        //                 setState(() {
        //                   _isDeleting = true;
        //                 });
        //                 Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => ADministaterShow_realestete(),), (route) => route.isFirst);
        //               },
        //               child: Text('Yes'),
        //             ),
        //           ],
        //         ),
        //       ) ?? false;
        //       /*final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Delete_Image()));
        //
        //       if (result == true) {
        //         _refreshData();
        //       }*/
        //     },
        //     child: const Icon(
        //       PhosphorIcons.trash,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
      ),

      body: SingleChildScrollView(
        child: FutureBuilder<List<Catid>>(
            future: fetchData(),
            builder: (context,abc){
              if(abc.connectionState == ConnectionState.waiting){
                return  Center(
                    child:Image.asset(AppImages.loader,height: 50,width: 50,)
                );
              }
              else if(abc.hasError){
                return Text('${abc.error}');
              }
              else if (abc.data == null || abc.data!.isEmpty) {
                // If the list is empty, show an empty image
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Lottie.asset("assets/images/no data.json",width: 450),
                      Text("${widget.idd} No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                    ],
                  ),
                );
              }
              else{
                return ListView.builder(
                  itemCount: 1,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int len) {
                    return Column(
                      children: [
                        // Professional Image Carousel with Interactive Elements
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: FutureBuilder<List<RealEstateSlider>>(
                            future: _futureCarousel,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return const Text('No images available');
                              }

                              final List<RealEstateSlider> images = snapshot.data!;

                              return SizedBox(
                                height: 200,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: images.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PropertyPreview(
                                              ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${images[index].mImages}",
                                            ),
                                          ),
                                        );
                                      },

                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${images[index].mImages}',
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          errorBuilder: (context, error, stackTrace) =>
                                          const Center(child: Icon(Icons.broken_image)),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Divider(),
                        ),
                        // Property Details Card
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Basic Info Row
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Property Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        width: 120,
                                        height: 120,
                                        child: CachedNetworkImage(
                                          imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${abc.data![len].propertyPhoto}",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(color: Colors.grey[200]),
                                          errorWidget: (context, url, error) => Icon(Icons.home),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12),
                                    // Property Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            abc.data![len].locations,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Poppins',
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Wrap(
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: [
                                              _buildDetailChip(abc.data![len].typeOfProperty, Colors.blue),
                                              _buildDetailChip(abc.data![len].bhk, Colors.green),
                                              _buildDetailChip(abc.data![len].floor, Colors.orange),
                                              _buildDetailChip(abc.data![len].buyRent, Colors.purple),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),

                                // Price Section
                                Container(
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Price',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      Text(
                                        "₹${abc.data![len].showPrice}",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.green[800],
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),

                                // Property Information Sections
                                _buildSection(
                                  title: 'Property Information',
                                  icon: Icons.info_outline,
                                  children: [
                                    _buildInfoRow('Flat Number', abc.data![len].flatNumber),
                                    _buildInfoRow('Sqft', abc.data![len].squareFit),
                                    _buildInfoRow('Balcony', abc.data![len].balcony),
                                    _buildInfoRow('Total Floor', abc.data![len].totalFloor),
                                    _buildInfoRow('Parking', "${abc.data![len].parking} Parking"),
                                    _buildInfoRow('Kitchen', "${abc.data![len].kitchen} Kitchen"),
                                    _buildInfoRow('Bathroom', "${abc.data![len].bathroom} Bathroom"),
                                    _buildInfoRow('Balcony', "${abc.data![len].balcony} "),
                                    _buildInfoRow('Maintance', "${abc.data![len].maintance} "),
                                    _buildInfoRow('Age Of Property', "${abc.data![len].ageOfProperty} "),
                                    _buildInfoRow('Road Size', "${abc.data![len].roadSize} "),
                                    _buildInfoRow('Near Metro', "${abc.data![len].metroDistance} "),
                                    _buildInfoRow('Metro Distance', "${abc.data![len].highwayDistance} "),
                                    _buildInfoRow('Main Market Distance', "${abc.data![len].registryAndGpa} "),
                                    _buildInfoRow('Registry and Gpa', "${abc.data![len].mainMarketDistance} "),
                                    _buildInfoRow('Loan', "${abc.data![len].loan} "),
                                    _buildInfoRow('Meter', "${abc.data![len].meter} unit "),
                                    _buildInfoRow('Lift', "${abc.data![len].lift}"),
                                    _buildInfoRow('Residence /Commercial', "${abc.data![len].residenceCommercial}"),
                                    _buildInfoRow('Facility', "${abc.data![len].facility}"),
                                    _buildInfoRow('Furnished', "${abc.data![len].furnishedUnfurnished}, ${abc.data![len].apartmentName}"),
                                  ],
                                ),

                                _buildSection(
                                  title: 'Facilities',
                                  icon: Icons.emoji_food_beverage_outlined,
                                  children: [
                                    Text(
                                      abc.data![len].facility,
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),

                                _buildSection(
                                  title: 'Address',
                                  icon: Icons.location_on_outlined,
                                  children: [
                                    Text(
                                      abc.data![len].apartmentAddress,
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 16),
                                if(abc.data![len].fieldWorkerCurrentLocation!=""&& abc.data![len].fieldWorkerCurrentLocation!=null)
                                  Column(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          final address =  abc.data![len]
                                              .fieldWorkerCurrentLocation;
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
                                            const Icon(Icons.location_on, color: Colors.red, size: 20),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  children: [
                                                    const TextSpan(
                                                      text: "Current Location: ",
                                                      style: TextStyle(
                                                          fontFamily: "Poppins",
                                                          fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: abc.data![0].fieldWorkerCurrentLocation,
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
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                // Contact Sections
                                _buildSection(
                                  title: 'Property Owner',
                                  icon: Icons.person_outline,
                                  children: [
                                    _buildContactRow(
                                      name: abc.data![len].ownerName,
                                      number: abc.data![len].ownerNumber,
                                      context: context,
                                    ),
                                  ],
                                ),

                                _buildSection(
                                  title: 'CareTaker',
                                  icon: Icons.support_agent_outlined,
                                  children: [
                                    _buildContactRow(
                                      name: abc.data![len].careTakerName,
                                      number: abc.data![len].careTakerNumber,
                                      context: context,
                                    ),
                                  ],
                                ),

                                _buildSection(
                                  title: 'Field Worker',
                                  icon: Icons.engineering_outlined,
                                  children: [
                                    _buildInfoRow('Name', abc.data![len].fieldWorkerName),
                                    _buildInfoRow('Number', abc.data![len].fieldWorkerNumber),
                                    _buildInfoRow('Address', abc.data![len].fieldWorkerAddress),
                                  ],
                                ),

                                // Additional Info
                                _buildSection(
                                  title: 'Additional Information',
                                  icon: Icons.note_outlined,
                                  children: [
                                    _buildInfoRow('Added Date',  _formatDate(abc.data![len].availableDate),),
                                    _buildInfoRow('Show Price', abc.data![len].showPrice),
                                    _buildInfoRow('Ask Price', abc.data![len].askingPrice),
                                    _buildInfoRow('Last Price', abc.data![len].lastPrice),
                                    _buildInfoRow('Property ID', abc.data![len].id.toString(),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                );

              }


            }

        ),
      ),

    );
  }

  Widget _buildSection({required String title, required IconData icon, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16),
        Row(
          children: [
            Icon(icon, size: 20, color: Colors.red),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        ...children,
      ],
    );
  }
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Poppins',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow({required String name, required String number, required BuildContext context}) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(
            name,
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          subtitle: Text(
            number,
            style: TextStyle(fontFamily: 'Poppins'),
          ),
          trailing: IconButton(
            icon: Icon(Icons.call, color: Colors.green),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Confirm Call'),
                  content: Text('Call $name?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        FlutterPhoneDirectCaller.callNumber(number);
                      },
                      child: Text('Call'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Divider(height: 1),
      ],
    );
  }

  Widget _buildDetailChip(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getInt('id_Building') ?? 0;
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
