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
  final String Building_Name;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Rent;
  final String Verify_price;
  final String BHK;
  final String sqft;
  final String tyope;
  final String floor_ ;
  final String maintence ;
  final String buy_Rent ;
  final String Building_information;
  final String Parking;
  final String balcony;
  final String facility;
  final String Furnished;
  final String kitchen;
  final String Baathroom;
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String Date;

  Catid(
      {required this.id, required this.Building_Name, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.sqft, required this.tyope, required this.floor_, required this.maintence, required this.buy_Rent,
        required this.Building_information,required this.balcony,required this.Parking,required this.facility,required this.Furnished,required this.kitchen,required this.Baathroom,required this.Ownername,required this.Owner_number,
        required this.Caretaker_name,required this.Caretaker_number,required this.Date});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['PVR_id'],
        Building_Name: json['Building_information'],
        Building_Address: json['Address_'],
        Building_Location: json['Place_'],
        Building_image: json['Realstate_image'],
        Longitude: json['Longtitude'],
        Latitude: json['Latitude'],
        Rent: json['Property_Number'],
        Verify_price: json['Gas_meter'],
        BHK: json['Bhk_Squarefit'],
        sqft: json['City'],
        tyope: json['Typeofproperty'],
        floor_: json['floor_'],
        maintence: json['maintenance'],
        buy_Rent: json['Buy_Rent'],
        Building_information: json['Building_information'],
        balcony: json['balcony'],
        Parking: json['Parking'],
        facility: json['Lift'],
        Furnished: json['Furnished'],
        kitchen: json['kitchen'],
        Baathroom: json['Baathroom'],
        Ownername: json['Ownername'],
        Owner_number: json['Owner_number'],
        Caretaker_name: json['Water_geyser'],
        Caretaker_number: json['CareTaker_number'],
        Date: json['date_']);
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
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=9711775300&looking=Flat");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData1() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=9711275300&looking=Flat");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData2() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=9971172204&looking=Flat");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid>> fetchData_rajpur() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_RealEstate_by_fieldworkarnumber?fieldworkarnumber=9818306096&looking=Flat");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {

      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
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
                                                  imageUrl: "https://www.verifyserve.social/${property
                                                      .Building_image}",
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
                                                  "₹${property.Rent}${property
                                                      .Verify_price}",
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
                                                            .Building_Location,
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
                                                      property.tyope
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buy_Rent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.BHK.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor_}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.Building_information,
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
                                                      property.Date,
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
                                        left: 16,
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
                                                  imageUrl: "https://www.verifyserve.social/${property
                                                      .Building_image}",
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
                                                  "₹${property.Rent}${property
                                                      .Verify_price}",
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
                                                            .Building_Location,
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
                                                      property.tyope
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buy_Rent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.BHK.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor_}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.Building_information,
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
                                                      property.Date,
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
                                        left: 16,
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
                                                  imageUrl: "https://www.verifyserve.social/${property
                                                      .Building_image}",
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
                                                  "₹${property.Rent}${property
                                                      .Verify_price}",
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
                                                            .Building_Location,
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
                                                      property.tyope
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buy_Rent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.BHK.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor_}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.Building_information,
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
                                                      property.Date,
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
                                      left: 16,
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
                                                  imageUrl: "https://www.verifyserve.social/${property
                                                      .Building_image}",
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
                                                  "₹${property.Rent}${property
                                                      .Verify_price}",
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
                                                            .Building_Location,
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
                                                      property.tyope
                                                          .toUpperCase(),
                                                      Colors.blue[100]!,
                                                      Colors.blue[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons
                                                          .currency_rupee_outlined,
                                                      property.buy_Rent
                                                          .toUpperCase(),
                                                      Colors.green[100]!,
                                                      Colors.green[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.bed_outlined,
                                                      property.BHK.toUpperCase(),
                                                      Colors.orange[100]!,
                                                      Colors.orange[800]!,
                                                    ),
                                                    _buildFeaturePill(
                                                      Icons.stairs_outlined,
                                                      "${property.floor_}",
                                                      Colors.purple[100]!,
                                                      Colors.purple[800]!,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 16),

                                                // Description
                                                Expanded(
                                                  child: Text(
                                                    property.Building_information,
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
                                                      property.Date,
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
