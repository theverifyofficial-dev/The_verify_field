import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'dart:convert';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import '../Home_Screen_click/View_All_Details.dart';
import '../Police_Verification/Owner_Details.dart';
import '../Police_Verification/Property_Verify_Details.dart';
import '../ui_decoration_tools/app_images.dart';
import '../model/doctenantSlider.dart';
import 'Add_Tenant.dart';
import 'Property_Verification.dart';
import 'ViewAll_Details.dart';


class Catid {
  final int tup_id;
  final String Reelestate_Image;
  final String Address_;
  final String Place_;
  final String floor_ ;
  final String flat_;
  final String Tenant_Rented_Amount;
  final String Tenant_Rented_Date;
  final String Owner_number;
  final String Tenant_number;
  final String maintence;
  final String Bhk_Squarefit;
  final String Subid;

  Catid(
      {required this.tup_id,required this.Reelestate_Image,required this.Address_,required this.Place_,required this.floor_,required this.flat_,
        required this.Tenant_Rented_Amount,required this.Tenant_Rented_Date,required this.Owner_number,required this.Tenant_number,required this.maintence,required this.Bhk_Squarefit,required this.Subid});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(tup_id: json['TUP_id'],Address_: json['Property_Number'],
        Reelestate_Image: json['Property_Image'],Place_: json['PropertyAddress'],
        floor_: json['FLoorr'], flat_: json['Flat'],
        Tenant_Rented_Amount: json['Tenant_Rented_Amount'], Tenant_Rented_Date: json['Tenant_Rented_Date'],
        Owner_number: json['Owner_Number'], Tenant_number: json['Tenant_Number'],maintence: json['Looking_Prop_'],
        Bhk_Squarefit: json['About_tenant'], Subid: json['Subid']);
  }
}


class Catid_real {
  final int id;
  final String Flat;
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
  final String fieldworkarname;
  final String fieldworkarnumber;

  Catid_real(
      {required this.id, required this.Flat, required this.Building_Address, required this.Building_Location, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.sqft, required this.tyope, required this.floor_, required this.maintence, required this.buy_Rent,
        required this.Building_information,required this.balcony,required this.Parking,required this.facility,required this.Furnished,required this.kitchen,required this.Baathroom,required this.Ownername,required this.Owner_number,required this.fieldworkarname,required this.fieldworkarnumber});

  factory Catid_real.FromJson(Map<String, dynamic>json){
    return Catid_real(id: json['PVR_id'],
        Flat: json['flat_'],
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
        fieldworkarname: json['fieldworkarname'],
        fieldworkarnumber: json['fieldworkarnumber']);
  }
}

class Servant {
  //final int id;
  final String Servant_Name;
  final String Servant_Number;
  final String Work_Timing;
  final String Servant_Work;

  Servant(
      {required this.Servant_Name, required this.Servant_Number, required this.Work_Timing, required this.Servant_Work});

  factory Servant.FromJson(Map<String, dynamic>json){
    return Servant(Servant_Name: json['Servant_Name'],
        Servant_Number: json['Servant_Number'],
        Work_Timing: json['Work_Timing'],
        Servant_Work: json['Servant_Work']);
  }
}

class ShowProperty extends StatefulWidget {
  const ShowProperty({Key? key}) : super(key: key);

  State<ShowProperty> createState() => _ShowPropertyState();
}

class _ShowPropertyState extends State<ShowProperty> {
  // late DocumentationBloc bloc;
  List<String> tittle = ["All Properties","Add Tenants"];
  int? pageIndex=0;
  late Future<List<Catid>> _futureCatid;
  late Future<List<Catid_real>> _futureCatidReal;
  @override
  void initState() {
    super.initState();
    _loaduserdata();

    _futureCatid = fetchData();
    _futureCatidReal = fetchDataone();
  }

  String data1 = '';
  String _Owner_Number = '';
  String _number = '';

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_Tenant_Table_by_Feildworker_Number_?fieldworkarnumber=$_number");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['TUP_id'].compareTo(a['TUP_id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/WebService4.asmx/Show_Tenant_Table_by_Feildworker_Number_?fieldworkarnumber=$_number",
          error: responce.body.toString(),
          statusCode: responce.statusCode ?? 0,
      );
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid_real>> fetchData_All(id) async{

    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/show_propertyverifycation_by_lookingproperty_fieldworkarnumber?Looking_Property_=Book&fieldworkarnumber=$_number");
    final responce=await http.get(url);
    if(responce.statusCode==200){

      List listresponce=json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));

      return listresponce.map((data) => Catid_real.FromJson(data)).toList();
    }
    else{
      await BugLogger.log(
        apiLink: "https://verifyserve.social/WebService4.asmx/show_propertyverifycation_by_lookingproperty_fieldworkarnumber?Looking_Property_=Book&fieldworkarnumber=$_number",
        error: responce.body.toString(),
        statusCode: responce.statusCode ?? 0,
      );
      throw Exception('Unexpected error occured!');
    }


  }

  Future<List<Catid_real>> fetchDataone() async{
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/show_propertyverifycation_by_lookingproperty_fieldworkarnumber?Looking_Property_=Book&fieldworkarnumber=$_number");
    final responce=await http.get(url);
    if(responce.statusCode==200){

      List listresponce=json.decode(responce.body);
      listresponce.sort((a, b) => b['PVR_id'].compareTo(a['PVR_id']));
      return listresponce.map((data) => Catid_real.FromJson(data)).toList();
    }
    else{
      await BugLogger.log(
          apiLink: "https://verifyserve.social/WebService4.asmx/show_propertyverifycation_by_lookingproperty_fieldworkarnumber?Looking_Property_=Book&fieldworkarnumber=$_number",
          error: responce.body.toString(),
          statusCode: responce.statusCode ?? 0,
      );
      throw Exception('Unexpected error occured!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
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
      body: Container(
        margin: EdgeInsets.only(top: 10),
        child: Column(
          children: [
            SizedBox(
              height: 65,
              child: ListView.builder(
                itemCount: tittle.length,
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final isSelected = pageIndex == index;
                  return GestureDetector(
                    onTap: () {
                      pageIndex = index;
                      if (pageIndex == 1) {
                        // Keep your existing bloc logic
                        // bloc.yourInfo(widget.data.dTPid);
                      }
                      setState(() {});
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).brightness==Brightness.dark?Colors.white12:Colors.deepPurple
                            : Theme.of(context).cardColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (isSelected)
                            BoxShadow(
                              color: Theme.of(context).primaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                              offset: const Offset(0, 3),
                            ),
                        ],
                        border: Border.all(
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).dividerColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          tittle[index],
                          style: TextStyle(
                            fontFamily: 'PoppinsBold',
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected
                                ? Colors.white // Selected state always white
                                : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white.withOpacity(0.9) // Dark mode unselected
                                : Colors.grey[800], // Light mode unselected
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Content Area
            if(pageIndex == 0)
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(top: 10),
                  child: FutureBuilder<List<Catid>>(
                    future: fetchData(),
                    builder: (context, abc) {
                      if(abc.connectionState == ConnectionState.waiting) {
                        return Center(child: Image.asset(AppImages.loader,height: 70,));
                       }
                      else if(abc.hasError) {
                        return Text('${abc.error}');
                      }
                      else if (abc.data == null || abc.data!.isEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              // Keep your existing Lottie animation if needed
                              // Lottie.asset("assets/images/no data.json",width: 450),
                              Text(
                                "No Data Found!",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      else {
                        return ListView.builder(
                          itemCount: abc.data!.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int len) {
                            return GestureDetector(
                              onTap: () async {
                                // Keep all your existing SharedPreferences logic
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('Building_Sibid_', abc.data![len].Subid);
                                prefs.setString('Owner_Number_For_PoliceVerification', abc.data![len].Owner_number.toString());
                                prefs.setString('Tenant_Number_For_PoliceVerification', abc.data![len].Tenant_number.toString());
                                prefs.setString('FLoorr_For_PoliceVerification', abc.data![len].floor_.toString());
                                prefs.setString('Flat_PoliceVerification', abc.data![len].flat_.toString());
                                prefs.setString('Tenant_Rented_Amount_PoliceVerification', abc.data![len].Tenant_Rented_Amount.toString());

                                // Keep your existing navigation
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => View_Detailsdocs(
                                      iidd: abc.data![len].tup_id.toString(),
                                      SUbid: abc.data![len].Subid.toString(),
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).brightness==Brightness.dark?Colors.black26:Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // Property Image
                                    ClipRRect(
                                      borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                      child: Container(
                                        height: 400,
                                        width: double.infinity,
                                        child: CachedNetworkImage(
                                          imageUrl: "https://verifyserve.social/${abc.data![len].Reelestate_Image}",
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Image.asset(
                                            AppImages.loading,
                                            fit: BoxFit.fill,
                                          ),
                                          errorWidget: (context, error, stack) => Image.asset(
                                            AppImages.imageNotFound,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // Property Details
                                    Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Address
                                          Text(
                                            abc.data![len].Address_,
                                            style: TextStyle(
                                              fontFamily: 'PoppinsBold',
                                              fontSize: 16,
                                            ),
                                          ),
                                          SizedBox(height: 8),

                                          // Location
                                          Row(
                                            children: [
                                              Icon(Icons.location_on, size: 16, color: Colors.red),
                                              SizedBox(width: 4),
                                              Text(
                                                abc.data![len].Place_,
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 14,
                                                  color: Colors.grey[600],
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),

                                          // Details Row
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildDetailChip(
                                                text: abc.data![len].floor_,
                                                color: Colors.purple,
                                              ),
                                              _buildDetailChip(
                                                text: abc.data![len].Bhk_Squarefit,
                                                color: Colors.orange,
                                              ),
                                              _buildDetailChip(
                                                text: abc.data![len].Tenant_Rented_Date,
                                                color: Colors.green,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 12),

                                          // Rent and Maintenance
                                          Row(
                                            children: [
                                              _buildPriceInfo(
                                                label: "Rent",
                                                value: abc.data![len].Tenant_Rented_Amount,
                                              ),
                                              SizedBox(width: 16),
                                              _buildPriceInfo(
                                                label: "Maintenance",
                                                value: abc.data![len].maintence,
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
                        );
                      }
                    },
                  ),
                ),
              ),

            if(pageIndex == 1)
              Expanded(
                child: FutureBuilder<List<Catid_real>>(
                  future: fetchData_All("1"),
                  builder: (context, abc) {
                    if(abc.connectionState == ConnectionState.waiting) {
                      return Center(child: Image.asset(AppImages.loader,height: 70,));
                    }
                    else if(abc.hasError) {
                      return Text('${abc.error}');
                    }
                    else if (abc.data == null || abc.data!.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            // Keep your existing Lottie animation if needed
                            // Lottie.asset("assets/images/no data.json",width: 450),
                            Text(
                              "No Data Found!",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    else {
                      return ListView.builder(
                        itemCount: abc.data!.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context, int len) {
                          return GestureDetector(
                            onTap: () async {
                              // Keep all your existing SharedPreferences logic
                              SharedPreferences prefs = await SharedPreferences.getInstance();
                              prefs.setString('id_Subid', abc.data![len].id.toString());
                              prefs.setString('Property_Number', abc.data![len].Building_Address.toString());
                              prefs.setString('PropertyAddress', abc.data![len].Building_Location.toString());
                              prefs.setString('Looking_Prop_', abc.data![len].tyope.toString());
                              prefs.setString('FLoorr', abc.data![len].floor_.toString());
                              prefs.setString('Flat', abc.data![len].Flat.toString());
                              prefs.setString('Owner_Name', abc.data![len].Ownername.toString());
                              prefs.setString('Owner_Number', abc.data![len].Owner_number.toString());
                              prefs.setString('fieldworkarname', abc.data![len].fieldworkarname.toString());
                              prefs.setString('fieldworkarnumber', abc.data![len].fieldworkarnumber.toString());
                              prefs.setString('property_image', abc.data![len].Building_image.toString());
                              prefs.setString('maintence', abc.data![len].maintence.toString());
                              prefs.setString('bhk_bhk', abc.data![len].BHK.toString());

                              // Keep your existing navigation
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TenantDetails(),
                                ),
                              );
                            },
                            child: Container(
                              margin: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).brightness==Brightness.dark?Colors.black26:Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  // Property Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                    child: Container(
                                      height: 400,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: "https://verifyserve.social/${abc.data![len].Building_image}",
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Image.asset(
                                          AppImages.loading,
                                          fit: BoxFit.cover,
                                        ),
                                        errorWidget: (context, error, stack) => Image.asset(
                                          AppImages.imageNotFound,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Property Details
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Address
                                        Text(
                                          abc.data![len].Building_Address,
                                          style: TextStyle(
                                            fontFamily: 'PoppinsBold',
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(height: 8),

                                        // Location
                                        Row(
                                          children: [
                                            Icon(Icons.location_on, size: 16, color: Colors.red),
                                            SizedBox(width: 4),
                                            Text(
                                              abc.data![len].Building_Location,
                                              style: TextStyle(
                                                fontFamily: 'Poppins',
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 12),

                                        // Property Type
                                        _buildDetailChip(
                                          text: abc.data![len].tyope.toUpperCase(),
                                          color: Colors.blue,
                                        ),
                                        SizedBox(height: 12),

                                        // BHK and Floor
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            _buildDetailChip(
                                              text: abc.data![len].BHK,
                                              color: Colors.teal,
                                            ),
                                            _buildDetailChip(
                                              text: abc.data![len].floor_,
                                              color: Colors.orange,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 16),

                                        // Action Buttons
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: _buildActionButton(
                                                text: "View Details",
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => Property_Verify_Details(
                                                        id: abc.data![len].id.toString(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: _buildActionButton(
                                                text: "Add Tenant",
                                                onPressed: () async {
                                                  // Keep all your existing SharedPreferences logic
                                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                                  prefs.setString('id_Subid', abc.data![len].id.toString());
                                                  prefs.setString('Property_Number', abc.data![len].Building_Address.toString());
                                                  prefs.setString('PropertyAddress', abc.data![len].Building_Location.toString());
                                                  prefs.setString('Looking_Prop_', abc.data![len].tyope.toString());
                                                  prefs.setString('FLoorr', abc.data![len].floor_.toString());
                                                  prefs.setString('Flat', abc.data![len].Flat.toString());
                                                  prefs.setString('Owner_Name', abc.data![len].Ownername.toString());
                                                  prefs.setString('Owner_Number', abc.data![len].Owner_number.toString());
                                                  prefs.setString('fieldworkarname', abc.data![len].fieldworkarname.toString());
                                                  prefs.setString('fieldworkarnumber', abc.data![len].fieldworkarnumber.toString());
                                                  prefs.setString('property_image', abc.data![len].Building_image.toString());
                                                  prefs.setString('maintence', abc.data![len].maintence.toString());
                                                  prefs.setString('bhk_bhk', abc.data![len].BHK.toString());

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => TenantDetails(),
                                                    ),
                                                  );
                                                },
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
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
      /*floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add'),
        icon: Icon(Icons.add),
        onPressed: (){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const Book_Property()));
        },
      ),*/
    );
  }
  Widget _buildDetailChip({String? text, required Color color}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text ?? '',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }

  Widget _buildPriceInfo({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: 'PoppinsBold',
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({required String text, required VoidCallback onPressed}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.blueGrey.shade500, Colors.black87]
                : [Colors.blue.shade200, Colors.blue.shade300],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'PoppinsBold',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      data1 = prefs.getString('id_Document') ?? '';
      _Owner_Number = prefs.getString('Owner_Number') ?? '';
      _number = prefs.getString('number') ?? '';
    });


  }

}