import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Home_Screen_click/Add_RealEstate.dart';
import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import '../ui_decoration_tools/constant.dart';
import 'Future_Property_Details.dart';
import 'See_All_Futureproperty.dart';

class Catid {
  final int id;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String BHK;
  final String tyope;
  final String floor_ ;
  final String buy_Rent ;
  final String Building_information;
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String vehicleNo;
  final String date;

  Catid(
      {required this.id, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.BHK, required this.tyope, required this.floor_, required this.buy_Rent,
        required this.Building_information,required this.Ownername,required this.Owner_number, required this.Caretaker_name,required this.Caretaker_number,required this.vehicleNo,required this.date});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['id'],
        Building_Address: json['propertyname_address'],
        Building_Location: json['place'],
        Building_image: json['images'],
        Longitude: json['longitude'],
        Latitude: json['latitude'],
        BHK: json['select_bhk'],
        tyope: json['typeofproperty'],
        floor_: json['floor_number'],
        buy_Rent: json['buy_rent'],
        Building_information: json['building_information_facilitys'],
        Ownername: json['ownername'],
        Owner_number: json['ownernumber'],
        Caretaker_name: json['caretakername'],
        Caretaker_number: json['caretakernumber'],
        vehicleNo: json['owner_vehical_number'],
        date: json['current_date_']);
  }
}

class ADministaterShow_FutureProperty extends StatefulWidget {
  const ADministaterShow_FutureProperty({super.key});

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
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=9711775300");
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
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=9711275300");
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
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=9971172204");
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
    final size = MediaQuery.of(context).size;
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
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SeeAll_FutureProperty(id: '9711775300',)));
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
                            height: 700,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: abc.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (abc.data == null || abc.data!.isEmpty || index >= abc.data!.length) {
                                  return Container();
                                }

                                final property = abc.data![index];
                                final displayIndex = abc.data!.length - index;
                                final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

                                // Color scheme for light and dark mode
                                final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
                                final textColor = isDarkMode ? Colors.white : Colors.black87;
                                final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];
                                final cardColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
                                final greenColor = isDarkMode ? Colors.green[300] : Colors.green;
                                final redColor = isDarkMode ? Colors.red[300] : Colors.red;
                                final orangeColor = isDarkMode ? Colors.orange[300] : Colors.orange;
                                final blueColor = isDarkMode ? Colors.blue[300] : Colors.blue;
                                final purpleColor = isDarkMode ? Colors.purple[300] : Colors.purple;

                                return Container(
                                  width: 350,
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
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
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                          child: Container(
                                            height: 300,
                                            width: 310,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              "https://verifyserve.social/PHP_Files/future_property/"+(property.Building_image??""),
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) => Image.asset(
                                                AppImages.loading,
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget: (context, error, stack) =>
                                                  Image.asset(
                                                    AppImages.imageNotFound,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ),
                                        ),



                                        // Property Details
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Property Type, BHK, Floor, Buy/Rent
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    if (property.tyope != null)
                                                      _buildFeatureChip(property.tyope!, greenColor!, isDarkMode),
                                                    if (property.BHK != null)
                                                      _buildFeatureChip(property.BHK!, redColor!, isDarkMode),
                                                    if (property.floor_ != null)
                                                      _buildFeatureChip(property.floor_!, orangeColor!, isDarkMode),
                                                    if (property.buy_Rent != null)
                                                      _buildFeatureChip(property.buy_Rent!, blueColor!, isDarkMode),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Owner Information
                                                Row(
                                                  children: [
                                                    Icon(Icons.person_outline, size: 16, color: secondaryTextColor),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        "Owner Information",
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          color: secondaryTextColor,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

                                                // Owner Name and Number
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: isDarkMode ? Colors.green[900]!.withOpacity(0.3) : Colors.green[50],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          property.Ownername ?? 'N/A',
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 14,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    if (property.Owner_number != null)
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog<bool>(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                                                              title: Text(
                                                                'Call Property Owner',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.bold,
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                              content: Text(
                                                                'Do you really want to call the owner?',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      color: textColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    Navigator.of(context).pop(true);
                                                                    FlutterPhoneDirectCaller.callNumber(property.Owner_number!);
                                                                  },
                                                                  child: Text(
                                                                    'Call',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: isDarkMode ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.phone, size: 16, color: blueColor),
                                                              const SizedBox(width: 4),
                                                              Text(
                                                                property.Owner_number!,
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 14,
                                                                  color: blueColor,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Property Address
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.location_on_outlined, size: 16, color: secondaryTextColor),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Property Address",
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12,
                                                              color: secondaryTextColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            property.Building_Address ?? 'Address not available',
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 13,
                                                              color: textColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Location and Date
                                                Row(
                                                  children: [
                                                    if (property.Building_Location != null)
                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: isDarkMode ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            property.Building_Location!,
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12,
                                                              color: blueColor,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    if (property.Building_Location != null && property.date != null)
                                                      const SizedBox(width: 8),
                                                    if (property.date != null)
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: isDarkMode ? Colors.purple[900]!.withOpacity(0.3) : Colors.purple[50],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          property.date!,
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: purpleColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Property ID and Index
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: cardColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          "Property No #$displayIndex",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: cardColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          "Property ID: ${property.id?.toString() ?? 'N/A'}",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
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
                  future: fetchData1(),
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
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SeeAll_FutureProperty(id: '9711275300',)));
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
                            height: 700,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: abc.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (abc.data == null || abc.data!.isEmpty || index >= abc.data!.length) {
                                  return Container();
                                }

                                final property = abc.data![index];
                                final displayIndex = abc.data!.length - index;
                                final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

                                // Color scheme for light and dark mode
                                final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
                                final textColor = isDarkMode ? Colors.white : Colors.black87;
                                final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];
                                final cardColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
                                final greenColor = isDarkMode ? Colors.green[300] : Colors.green;
                                final redColor = isDarkMode ? Colors.red[300] : Colors.red;
                                final orangeColor = isDarkMode ? Colors.orange[300] : Colors.orange;
                                final blueColor = isDarkMode ? Colors.blue[300] : Colors.blue;
                                final purpleColor = isDarkMode ? Colors.purple[300] : Colors.purple;

                                return Container(
                                  width: 350,
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
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
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                          child: Container(
                                            height: 300,
                                            width: 310,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              "https://verifyserve.social/PHP_Files/future_property/"+(property.Building_image??""),
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) => Image.asset(
                                                AppImages.loading,
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget: (context, error, stack) =>
                                                  Image.asset(
                                                    AppImages.imageNotFound,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ),
                                        ),



                                        // Property Details
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Property Type, BHK, Floor, Buy/Rent
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    if (property.tyope != null)
                                                      _buildFeatureChip(property.tyope!, greenColor!, isDarkMode),
                                                    if (property.BHK != null)
                                                      _buildFeatureChip(property.BHK!, redColor!, isDarkMode),
                                                    if (property.floor_ != null)
                                                      _buildFeatureChip(property.floor_!, orangeColor!, isDarkMode),
                                                    if (property.buy_Rent != null)
                                                      _buildFeatureChip(property.buy_Rent!, blueColor!, isDarkMode),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Owner Information
                                                Row(
                                                  children: [
                                                    Icon(Icons.person_outline, size: 16, color: secondaryTextColor),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        "Owner Information",
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          color: secondaryTextColor,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

                                                // Owner Name and Number
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: isDarkMode ? Colors.green[900]!.withOpacity(0.3) : Colors.green[50],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          property.Ownername ?? 'N/A',
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 14,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    if (property.Owner_number != null)
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog<bool>(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                                                              title: Text(
                                                                'Call Property Owner',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.bold,
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                              content: Text(
                                                                'Do you really want to call the owner?',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      color: textColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    Navigator.of(context).pop(true);
                                                                    FlutterPhoneDirectCaller.callNumber(property.Owner_number!);
                                                                  },
                                                                  child: Text(
                                                                    'Call',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: isDarkMode ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.phone, size: 16, color: blueColor),
                                                              const SizedBox(width: 4),
                                                              Text(
                                                                property.Owner_number!,
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 14,
                                                                  color: blueColor,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Property Address
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.location_on_outlined, size: 16, color: secondaryTextColor),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Property Address",
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12,
                                                              color: secondaryTextColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            property.Building_Address ?? 'Address not available',
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 13,
                                                              color: textColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Location and Date
                                                Row(
                                                  children: [
                                                    if (property.Building_Location != null)
                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: isDarkMode ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            property.Building_Location!,
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12,
                                                              color: blueColor,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    if (property.Building_Location != null && property.date != null)
                                                      const SizedBox(width: 8),
                                                    if (property.date != null)
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: isDarkMode ? Colors.purple[900]!.withOpacity(0.3) : Colors.purple[50],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          property.date!,
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: purpleColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Property ID and Index
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: cardColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          "Property No #$displayIndex",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: cardColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          "Property ID: ${property.id?.toString() ?? 'N/A'}",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
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
                                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SeeAll_FutureProperty(id: '9971172204',)));
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
                            height: 700,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: abc.data?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                if (abc.data == null || abc.data!.isEmpty || index >= abc.data!.length) {
                                  return Container();
                                }

                                final property = abc.data![index];
                                final displayIndex = abc.data!.length - index;
                                final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

                                // Color scheme for light and dark mode
                                final backgroundColor = isDarkMode ? Colors.grey[900] : Colors.white;
                                final textColor = isDarkMode ? Colors.white : Colors.black87;
                                final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[700];
                                final cardColor = isDarkMode ? Colors.grey[800] : Colors.grey[100];
                                final greenColor = isDarkMode ? Colors.green[300] : Colors.green;
                                final redColor = isDarkMode ? Colors.red[300] : Colors.red;
                                final orangeColor = isDarkMode ? Colors.orange[300] : Colors.orange;
                                final blueColor = isDarkMode ? Colors.blue[300] : Colors.blue;
                                final purpleColor = isDarkMode ? Colors.purple[300] : Colors.purple;

                                return Container(
                                  width: 350,
                                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: backgroundColor,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: isDarkMode ? Colors.black.withOpacity(0.4) : Colors.grey.withOpacity(0.2),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
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
                                      // crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                          const BorderRadius.all(Radius.circular(10)),
                                          child: Container(
                                            height: 300,
                                            width: 310,
                                            child: CachedNetworkImage(
                                              imageUrl:
                                              "https://verifyserve.social/PHP_Files/future_property/"+(property.Building_image??""),
                                              fit: BoxFit.contain,
                                              placeholder: (context, url) => Image.asset(
                                                AppImages.loading,
                                                fit: BoxFit.cover,
                                              ),
                                              errorWidget: (context, error, stack) =>
                                                  Image.asset(
                                                    AppImages.imageNotFound,
                                                    fit: BoxFit.cover,
                                                  ),
                                            ),
                                          ),
                                        ),



                                        // Property Details
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                // Property Type, BHK, Floor, Buy/Rent
                                                Wrap(
                                                  spacing: 8,
                                                  runSpacing: 8,
                                                  children: [
                                                    if (property.tyope != null)
                                                      _buildFeatureChip(property.tyope!, greenColor!, isDarkMode),
                                                    if (property.BHK != null)
                                                      _buildFeatureChip(property.BHK!, redColor!, isDarkMode),
                                                    if (property.floor_ != null)
                                                      _buildFeatureChip(property.floor_!, orangeColor!, isDarkMode),
                                                    if (property.buy_Rent != null)
                                                      _buildFeatureChip(property.buy_Rent!, blueColor!, isDarkMode),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Owner Information
                                                Row(
                                                  children: [
                                                    Icon(Icons.person_outline, size: 16, color: secondaryTextColor),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Text(
                                                        "Owner Information",
                                                        style: TextStyle(
                                                          fontFamily: 'Poppins',
                                                          fontSize: 12,
                                                          color: secondaryTextColor,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 8),

                                                // Owner Name and Number
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: isDarkMode ? Colors.green[900]!.withOpacity(0.3) : Colors.green[50],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          property.Ownername ?? 'N/A',
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 14,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    if (property.Owner_number != null)
                                                      GestureDetector(
                                                        onTap: () {
                                                          showDialog<bool>(
                                                            context: context,
                                                            builder: (context) => AlertDialog(
                                                              backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
                                                              title: Text(
                                                                'Call Property Owner',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontWeight: FontWeight.bold,
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                              content: Text(
                                                                'Do you really want to call the owner?',
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  color: textColor,
                                                                ),
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(16),
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () => Navigator.of(context).pop(false),
                                                                  child: Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      color: textColor,
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    Navigator.of(context).pop(true);
                                                                    FlutterPhoneDirectCaller.callNumber(property.Owner_number!);
                                                                  },
                                                                  child: Text(
                                                                    'Call',
                                                                    style: TextStyle(
                                                                      fontFamily: 'Poppins',
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: isDarkMode ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Icon(Icons.phone, size: 16, color: blueColor),
                                                              const SizedBox(width: 4),
                                                              Text(
                                                                property.Owner_number!,
                                                                style: TextStyle(
                                                                  fontFamily: 'Poppins',
                                                                  fontSize: 14,
                                                                  color: blueColor,
                                                                  fontWeight: FontWeight.w600,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Property Address
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Icon(Icons.location_on_outlined, size: 16, color: secondaryTextColor),
                                                    const SizedBox(width: 4),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            "Property Address",
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12,
                                                              color: secondaryTextColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                          const SizedBox(height: 4),
                                                          Text(
                                                            property.Building_Address ?? 'Address not available',
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 13,
                                                              color: textColor,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Location and Date
                                                Row(
                                                  children: [
                                                    if (property.Building_Location != null)
                                                      Expanded(
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                          decoration: BoxDecoration(
                                                            color: isDarkMode ? Colors.blue[900]!.withOpacity(0.3) : Colors.blue[50],
                                                            borderRadius: BorderRadius.circular(8),
                                                          ),
                                                          child: Text(
                                                            property.Building_Location!,
                                                            style: TextStyle(
                                                              fontFamily: 'Poppins',
                                                              fontSize: 12,
                                                              color: blueColor,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                            overflow: TextOverflow.ellipsis,
                                                          ),
                                                        ),
                                                      ),
                                                    if (property.Building_Location != null && property.date != null)
                                                      const SizedBox(width: 8),
                                                    if (property.date != null)
                                                      Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: isDarkMode ? Colors.purple[900]!.withOpacity(0.3) : Colors.purple[50],
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          property.date!,
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: purpleColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                  ],
                                                ),

                                                const SizedBox(height: 16),

                                                // Property ID and Index
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: cardColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          "Property No #$displayIndex",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Expanded(
                                                      child: Container(
                                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                        decoration: BoxDecoration(
                                                          color: cardColor,
                                                          borderRadius: BorderRadius.circular(8),
                                                        ),
                                                        child: Text(
                                                          "Property ID: ${property.id?.toString() ?? 'N/A'}",
                                                          style: TextStyle(
                                                            fontFamily: 'Poppins',
                                                            fontSize: 12,
                                                            color: textColor,
                                                            fontWeight: FontWeight.w600,
                                                          ),
                                                        ),
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

}
