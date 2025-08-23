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
import '../ui_decoration_tools/constant.dart';
import '../model/realestateSlider.dart';
import 'Administator_Realestate.dart';

class Catid {
  final int id;
  final String property_num;
  final String Address_;
  final String Place_;
  final String sqft;
  final String Price;
  final String Sell_price;
  final String Persnol_price;
  final String maintenance;
  final String Buy_Rent;
  final String Residence_Commercial;
  final String floor_ ;
  final String flat_;
  final String Furnished;
  final String Details;
  final String Ownername;
  final String Owner_number;
  final String Building_information;
  final String balcony;
  final String kitchen;
  final String Baathroom;
  final String Parking;
  final String Typeofproperty;
  final String Bhk_Squarefit;
  final String Address_apnehisaabka;
  final String Caretaker_name;
  final String Caretaker_number;
  final String Building_Location;
  final String Building_Name;
  final String Building_Address;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Rent;
  final String Verify_price;
  final String BHK;
  final String tyope;
  final String maintence ;
  final String buy_Rent ;
  final String facility;
  final String Feild_name ;
  final String Feild_number;
  final String date;

  Catid(
      {required this.id,required this.property_num,required this.Address_,required this.Place_,required this.sqft,
        required this.Price,required this.Sell_price,required this.Persnol_price,required this.maintenance,
        required this.Buy_Rent,required this.Residence_Commercial,required this.floor_,required this.flat_,
        required this.Furnished,required this.Details,required this.Ownername,required this.Owner_number,
        required this.Building_information,required this.balcony,required this.kitchen,required this.Baathroom,
        required this.Parking,required this.Typeofproperty,required this.Bhk_Squarefit,required this.Address_apnehisaabka,
        required this.Caretaker_name,required this.Caretaker_number, required this.Building_Location, required this.Building_Name, required this.Building_Address, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.tyope, required this.maintence, required this.buy_Rent,
        required this.facility,required this.Feild_name,required this.Feild_number,required this.date});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['PVR_id'],
        property_num: json['Property_Number'], Address_: json['Address_'],
        Place_: json['Place_'], sqft: json['City'],
        Price: json['Price'], Sell_price: json['Waterfilter'],
        Persnol_price: json['Gas_meter'], maintenance: json['maintenance'],
        Buy_Rent: json['Buy_Rent'], Residence_Commercial: json['Residence_Commercial'],
        floor_: json['floor_'], flat_: json['flat_'],
        Furnished: json['Furnished'], Details: json['Details'],
        Ownername: json['Ownername'], Owner_number: json['Owner_number'],
        Building_information: json['Building_information'], balcony: json['balcony'],
        kitchen: json['kitchen'], Baathroom: json['Baathroom'],
        Parking: json['Parking'], Typeofproperty: json['Typeofproperty'],
        Bhk_Squarefit: json['Bhk_Squarefit'], Address_apnehisaabka: json['Address_apnehisaabka'],
        Caretaker_name: json['Water_geyser'], Caretaker_number: json['CareTaker_number'], Building_Location: json['Place_'],
        Building_Name: json['Building_information'],
        Building_Address: json['Address_'],
        Building_image: json['Realstate_image'],
        Longitude: json['Longtitude'],
        Latitude: json['Latitude'],
        Rent: json['Property_Number'],
        Verify_price: json['Gas_meter'],
        BHK: json['Bhk_Squarefit'],
        tyope: json['Typeofproperty'],
        maintence: json['maintenance'],
        buy_Rent: json['Buy_Rent'],
        facility: json['Lift'],
        Feild_name: json['fieldworkarname'],
        Feild_number: json['fieldworkarnumber'],
        date: json['date_']);
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
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=${widget.idd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
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
                      Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
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
                                          imageUrl: "https://verifyserve.social/${abc.data![len].Building_image}",
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
                                            abc.data![len].Building_Location,
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
                                              _buildDetailChip(abc.data![len].tyope, Colors.blue),
                                              _buildDetailChip(abc.data![len].BHK, Colors.green),
                                              _buildDetailChip(abc.data![len].floor_, Colors.orange),
                                              _buildDetailChip(abc.data![len].buy_Rent, Colors.purple),
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
                                        "₹${abc.data![len].Rent}${abc.data![len].Verify_price}",
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
                                    _buildInfoRow('Sqft', abc.data![len].sqft),
                                    _buildInfoRow('Balcony', abc.data![len].balcony),
                                    _buildInfoRow('Parking', "${abc.data![len].Parking} Parking"),
                                    _buildInfoRow('Kitchen', "${abc.data![len].kitchen} Kitchen"),
                                    _buildInfoRow('Bathroom', "${abc.data![len].Baathroom} Bathroom"),
                                    _buildInfoRow('Furnished', abc.data![len].Furnished),
                                    _buildInfoRow('Details', abc.data![len].Details),
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
                                      abc.data![len].Address_,
                                      style: TextStyle(fontFamily: 'Poppins'),
                                    ),
                                  ],
                                ),

                                // Contact Sections
                                _buildSection(
                                  title: 'Property Owner',
                                  icon: Icons.person_outline,
                                  children: [
                                    _buildContactRow(
                                      name: abc.data![len].Ownername,
                                      number: abc.data![len].Owner_number,
                                      context: context,
                                    ),
                                  ],
                                ),

                                _buildSection(
                                  title: 'CareTaker',
                                  icon: Icons.support_agent_outlined,
                                  children: [
                                    _buildContactRow(
                                      name: abc.data![len].Caretaker_name,
                                      number: abc.data![len].Caretaker_number,
                                      context: context,
                                    ),
                                  ],
                                ),

                                _buildSection(
                                  title: 'Field Worker',
                                  icon: Icons.engineering_outlined,
                                  children: [
                                    _buildInfoRow('Name', abc.data![len].Feild_name),
                                    _buildInfoRow('Number', abc.data![len].Feild_number),
                                    _buildInfoRow('Address', abc.data![len].Address_apnehisaabka),
                                  ],
                                ),

                                // Additional Info
                                _buildSection(
                                  title: 'Additional Information',
                                  icon: Icons.note_outlined,
                                  children: [
                                    _buildInfoRow('Added Date', abc.data![len].date),
                                    _buildInfoRow('Sell Price', abc.data![len].Sell_price),
                                    _buildInfoRow('List Price', abc.data![len].Price),
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
