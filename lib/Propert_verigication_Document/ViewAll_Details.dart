import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Police_Verification/Owner_Details.dart';
import '../property_preview.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/docpropertySlider.dart';

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

class Catid_details {
  final String Reelestate_Image;
  final String Address_;
  final String Place_;
  final String floor_ ;
  final String flat_;
  final String Tenant_Rented_Amount;
  final String Tenant_Rented_Date;
  final String maintence;
  final String Bhk_Squarefit;
  final String Tenant_Name;
  final String Tenant_Number;
  final String Tenant_Email;
  final String Tenant_WorkProfile;
  final String Tenant_Members;
  final String Property_Number;
  final String Looking_Prop_;
  final String Subid;

  Catid_details(
      {required this.Reelestate_Image,required this.Address_,required this.Place_,required this.floor_,required this.flat_,
        required this.Tenant_Rented_Amount,required this.Tenant_Rented_Date,required this.maintence,required this.Bhk_Squarefit,
        required this.Tenant_Name,required this.Tenant_Number,required this.Tenant_Email,required this.Tenant_WorkProfile,
        required this.Tenant_Members,required this.Property_Number,required this.Looking_Prop_,required this.Subid});

  factory Catid_details.FromJson(Map<String, dynamic>json){
    return Catid_details(Address_: json['Property_Number'],
        Reelestate_Image: json['Property_Image'],Place_: json['PropertyAddress'],
        floor_: json['FLoorr'], flat_: json['Flat'],
        Tenant_Rented_Amount: json['Tenant_Rented_Amount'], Tenant_Rented_Date: json['Tenant_Rented_Date'],
        maintence: json['Looking_Prop_'], Bhk_Squarefit: json['About_tenant'],
        Tenant_Name: json['Tenant_Name'],Tenant_Number: json['Tenant_Number'],
        Tenant_Email: json['Tenant_Email'], Tenant_WorkProfile: json['Tenant_WorkProfile'],
        Tenant_Members: json['Tenant_Members'], Property_Number: json['Property_Number'],
        Looking_Prop_: json['Looking_Prop_'], Subid: json['Subid']);
  }
}


class View_Detailsdocs extends StatefulWidget {
  final String iidd;
  final String SUbid;
  const View_Detailsdocs({Key? key, required this.iidd, required this.SUbid}) : super(key: key);

  @override
  State<View_Detailsdocs> createState() => _View_DetailsdocsState();
}

class _View_DetailsdocsState extends State<View_Detailsdocs> {

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=${widget.SUbid}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid_details>> fetchData_Tenant_Detail() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_Verify_AddTenant_Under_Property_Table_by_id_?TUP_id=${widget.iidd}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid_details.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<DocumentMainModel>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Show_Image_under_Realestatet?id_num=${widget.SUbid}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return DocumentMainModel(
          dimage: item['imagepath'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> Book_property() async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=${widget.SUbid}&looking=Flat'));
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
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=${widget.SUbid}');
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
    _loaduserdata();

  }

  String data = 'Initial Data';

  void _refreshData() {
    setState(() {
      data = 'Refreshed Data at ${DateTime.now()}';
    });
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getInt('id_Building') ?? 0;
    });


  }

//  final result = await profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey[100],
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(AppImages.verify, height: 75),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Property Images Carousel
            FutureBuilder<List<DocumentMainModel>>(
              future: fetchCarouselData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    height: 200,
                    child: Center(child: Text('Error loading images')),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    height: 200,
                    child: Center(
                      child: Text(
                        'No images available',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey
                              : Colors.grey[200],
                        ),
                      ),
                    ),
                  );
                } else {
                  return CarouselSlider(
                    options: CarouselOptions(
                      height: 220,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      viewportFraction: 0.9,
                    ),
                    items: snapshot.data!.map((item) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PropertyPreview(
                                ImageUrl: "https://www.verifyserve.social/${item.dimage}",
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: "https://www.verifyserve.social/${item.dimage}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, error, stack) => Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.error, color: Colors.grey),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                }
              },
            ),
            SizedBox(height: 20),

            // Property Basic Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: FutureBuilder<List<Catid_details>>(
                  future: fetchData_Tenant_Detail(),
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Text('Error: ${abc.error}');
                    } else if (abc.data == null || abc.data!.isEmpty) {
                      return Center(child: Text("No Tenant Data Found!"));
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildInfoChip(context, 'Flat No: ${abc.data![0].flat_}', Colors.blue),
                              _buildInfoChip(context, 'Floor: ${abc.data![0].floor_}', Colors.green),
                              _buildInfoChip(context, abc.data![0].Bhk_Squarefit, Colors.orange),
                            ],
                          ),

                          SizedBox(height: 16),

                          // Tenant Section
                          _buildSectionHeader('Property Tenant'),
                          SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildDetailCard(
                                  abc.data![0].Tenant_Name,
                                  'Tenant Name',
                                  PhosphorIcons.user,
                                  Colors.purple,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    final confirmCall = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Call Property tenant'),
                                        content: Text('Do you really want to Call Tenant?'),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () => Navigator.of(context).pop(false),
                                            child: Text('No', style: TextStyle(color: Colors.teal)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true); // return true on 'Yes'
                                            },
                                            child: Text('Yes', style: TextStyle(color: Colors.teal)),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirmCall == true) {
                                      FlutterPhoneDirectCaller.callNumber('${abc.data![0].Tenant_Number}');
                                    }
                                  },
                                  child: _buildDetailCard(
                                    abc.data![0].Tenant_Number,
                                    'Contact Number',
                                    PhosphorIcons.phone_call,
                                    Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          _buildDetailRow(
                            'Rent & Maintenance',
                            '${abc.data![0].Tenant_Rented_Amount} | ${abc.data![0].maintence}',
                            PhosphorIcons.money,
                            Colors.green,
                          ),

                          _buildDetailRow(
                            'Shifting Date',
                            abc.data![0].Tenant_Rented_Date,
                            PhosphorIcons.calendar,
                            Colors.orange,
                          ),

                          _buildDetailRow(
                            'Living Members',
                            '${abc.data![0].Tenant_Members} Members',
                            PhosphorIcons.users,
                            Colors.purple,
                          ),

                          _buildDetailRow(
                            'Work Profile',
                            abc.data![0].Tenant_WorkProfile,
                            PhosphorIcons.briefcase,
                            Colors.blue,
                          ),

                          _buildDetailRow(
                            'Email',
                            abc.data![0].Tenant_Email,
                            PhosphorIcons.envelope,
                            Colors.red,
                          ),

                          _buildDetailRow(
                            'Vehicle Details',
                            'Vehicle no coming soon',
                            PhosphorIcons.car,
                            Colors.teal,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 16),

            // Property Owner and Caretaker Info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: FutureBuilder<List<Catid>>(
                  future: fetchData(),
                  builder: (context, abc) {
                    if (abc.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (abc.hasError) {
                      return Text('Error: ${abc.error}');
                    } else if (abc.data == null || abc.data!.isEmpty) {
                      return Center(child: Text("No Property Data Found!"));
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader('Property Owner'),
                          SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildDetailCard(
                                  abc.data![0].Ownername,
                                  'Owner Name',
                                  PhosphorIcons.user_circle,
                                  Colors.purple,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Call Property Owner'),
                                        content: Text('Do you really want to Call Owner?'),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('No', style: TextStyle(color: Colors.teal))),
                                          TextButton(
                                              onPressed: () async {
                                                FlutterPhoneDirectCaller.callNumber('${abc.data![0].Owner_number}');
                                              },
                                              child: Text('Yes', style: TextStyle(color: Colors.teal))),
                                        ],
                                      ),
                                    ) ?? false;
                                  },
                                  child: _buildDetailCard(
                                    abc.data![0].Owner_number,
                                    'Contact Number',
                                    PhosphorIcons.phone_call_bold,
                                    Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          _buildSectionHeader('CareTaker Info'),
                          SizedBox(height: 8),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildDetailCard(
                                  abc.data![0].Caretaker_name,
                                  'Caretaker Name',
                                  PhosphorIcons.user,
                                  Colors.cyan,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('Call Property CareTaker'),
                                        content: Text('Do you really want to Call CareTaker?'),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                        actions: <Widget>[
                                          TextButton(
                                              onPressed: () => Navigator.of(context).pop(false),
                                              child: Text('No', style: TextStyle(color: Colors.teal))),
                                          TextButton(
                                              onPressed: () async {
                                                FlutterPhoneDirectCaller.callNumber('${abc.data![0].Caretaker_number}');
                                              },
                                              child: Text('Yes', style: TextStyle(color: Colors.teal))),
                                        ],
                                      ),
                                    ) ?? false;
                                  },
                                  child: _buildDetailCard(
                                    abc.data![0].Caretaker_number,
                                    'Contact Number',
                                    PhosphorIcons.phone_call,
                                    Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 16),

                          _buildSectionHeader('Property Details'),
                          SizedBox(height: 8),

                          _buildDetailRow(
                            'Rent & Maintenance',
                            '${abc.data![0].Rent} | ${abc.data![0].maintence}',
                            PhosphorIcons.money,
                            Colors.red,
                          ),

                          _buildDetailRow(
                            'Area & Parking',
                            '${abc.data![0].sqft} | ${abc.data![0].balcony} | ${abc.data![0].Parking} Parking',
                            PhosphorIcons.ruler,
                            Colors.blue,
                          ),

                          _buildDetailRow(
                            'Building Info',
                            abc.data![0].Building_information,
                            PhosphorIcons.info,
                            Colors.green,
                          ),

                          _buildDetailRow(
                            'Address',
                            abc.data![0].Address_,
                            PhosphorIcons.map_pin,
                            Colors.orange,
                          ),

                          _buildDetailRow(
                            'Floor & Flat',
                            '${abc.data![0].floor_} | ${abc.data![0].flat_}',
                            PhosphorIcons.buildings,
                            Colors.purple,
                          ),

                          _buildDetailRow(
                            'Facilities',
                            abc.data![0].facility,
                            PhosphorIcons.wifi_high,
                            Colors.teal,
                          ),

                          _buildDetailRow(
                            'Furnishing',
                            '${abc.data![0].Furnished} | ${abc.data![0].Details}',
                            PhosphorIcons.bathtub,
                            Colors.brown,
                          ),

                          _buildDetailRow(
                            'Kitchen & Bathroom',
                            '${abc.data![0].kitchen} Kitchen | ${abc.data![0].Baathroom} Bathroom',
                            Icons.kitchen_sharp,
                            Colors.indigo,
                          ),

                          SizedBox(height: 12),

                          Center(
                            child: _buildInfoChip(
                              context,
                              'Property ID: ${abc.data![0].id}',
                              Colors.teal,
                            ),
                          ),

                          SizedBox(height: 16),

                          _buildSectionHeader('Field Worker'),
                          SizedBox(height: 8),

                          Row(
                            children: [
                              Expanded(
                                child: _buildDetailCard(
                                  abc.data![0].Feild_name,
                                  'Name',
                                  PhosphorIcons.user,
                                  Colors.yellow[700]!,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: _buildDetailCard(
                                  abc.data![0].Feild_number,
                                  'Contact',
                                  PhosphorIcons.phone,
                                  Colors.yellow[700]!,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final result_Tenanted_property = await fetchData();
                  final Tenanted_property = await fetchData_Tenant_Detail();
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.setInt('B_Sibid_', result_Tenanted_property.first.id);
                  prefs.setString('B_Ownername_', result_Tenanted_property.first.Ownername);
                  prefs.setString('B_Ownernumber_', result_Tenanted_property.first.Owner_number);
                  prefs.setString('B_Tenantname_', Tenanted_property.first.Tenant_Name);
                  prefs.setString('B_Tenantnumber_', Tenanted_property.first.Tenant_Number);
                  print(result_Tenanted_property.first.Ownername);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Owner_details(iid: '${result_Tenanted_property.first.id.toString()}')),
                  );
                },
                child: Text(
                  'Apply Document',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.teal),
                ),
                onPressed: () {
                  print('Move to Real-Estate pressed');
                },
                child: Text(
                  'Move To Real-Estate',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.teal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blue,
        fontFamily: "PoppinsBold",

      ),
    );
  }

  Widget _buildInfoChip(BuildContext context, String text, Color color) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w500,
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      ),
    );
  }

  Widget _buildDetailCard(String value, String label, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: color),
              SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "Poppins",
                  color: Theme.of(context).brightness==Brightness.dark?Colors.white60:Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              fontFamily: "Poppins",
              color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.black87,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Poppins",
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).brightness==Brightness.dark?Colors.white70:Colors.black87,
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

