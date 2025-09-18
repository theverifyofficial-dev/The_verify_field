import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constant.dart';
import '../model/realestateModel.dart';
import 'Add_Tenant_Visit.dart';
import 'Edit_TenantDemand.dart';
import 'Feedback_Details_Page.dart';
import 'Show_TenantDemands.dart';

class Catid {
  final int id;
  final String V_name;
  final String V_number;
  final String bhk;
  final String budget;
  final String place;
  final String floor_option;
  final String Additional_Info;
  final String Shifting_date;
  final String Current_date;
  final String Parking;
  final String Gadi_Number;
  final String FeildWorker_Name;
  final String FeildWorker_Number;
  final String Current__Date;
  final String Family_Members;
  final String buyrent;

  Catid(
      {required this.id, required this.V_name, required this.V_number, required this.bhk, required this.budget,
        required this.place, required this.floor_option, required this.Additional_Info, required this.Shifting_date,required this.Current_date,
        required this.Parking, required this.Gadi_Number, required this.FeildWorker_Name, required this.FeildWorker_Number,
        required this.Current__Date,required this.Family_Members,required this.buyrent});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['VTD_id'],
        V_name: json['V_name'],
        V_number: json['V_number'],
        bhk: json['bhk'],
        budget: json['budget'],
        place: json['place'],
        floor_option: json['floor_option'],
        Additional_Info: json['Additional_Info'],
        Shifting_date: json['Shifting_date'],
        Current_date: json['Current__Date'],
        Parking: json['Parking'],
        Gadi_Number: json['Gadi_Number'],
        FeildWorker_Name: json['FeildWorker_Name'],
        FeildWorker_Number: json['FeildWorker_Number'],
        Current__Date: json['Current__Date'],
        Family_Members: json['Family_Members'],
        buyrent: json['Buy_rent']);
  }
}

class Catid_pending {
  final int id;
  final String fieldworkar_name;
  final String fieldworkar_number;
  final String demand_name;
  final String demand_number;
  final String buy_rent;
  final String place;
  final String BHK;

  Catid_pending(
      {required this.id, required this.fieldworkar_name, required this.fieldworkar_number, required this.demand_name, required this.demand_number,
        required this.buy_rent, required this.place, required this.BHK});

  factory Catid_pending.FromJson(Map<String, dynamic>json){
    return Catid_pending(id: json['id'],
        fieldworkar_name: json['fieldworkar_name'],
        fieldworkar_number: json['fieldworkar_number'],
        demand_name: json['demand_name'],
        demand_number: json['demand_number'],
        buy_rent: json['buy_rent'],
        place: json['add_info'],
        BHK: json['bhk']);
  }
}

class Catid_review {
  final String feedback;
  final String subid;
  final String addtional_info;

  Catid_review(
      {required this.feedback, required this.subid, required this.addtional_info});

  factory Catid_review.FromJson(Map<String, dynamic>json){
    return Catid_review(feedback: json['feedback'],
        subid: json['subid'],
        addtional_info: json['addtional_info']);
  }
}

class Catid_visit {
  final String visit_date;
  final String visit_time;
  final String number;
  final String source_click_website;


  Catid_visit(
      {required this.visit_date, required this.visit_time, required this.number, required this.source_click_website});

  factory Catid_visit.FromJson(Map<String, dynamic>json){
    return Catid_visit(
        visit_date: json['visit_date'],
        visit_time: json['visit_time'],
        number: json['number'],
        source_click_website: json['source_click_website']);
  }
}

class Catid_respo {
  final String visit_date;
  final String visit_time;
  final String txt;


  Catid_respo(
      {required this.visit_date, required this.visit_time, required this.txt});

  factory Catid_respo.FromJson(Map<String, dynamic>json){
    return Catid_respo(
        visit_date: json['dates'],
        visit_time: json['times'],
        txt: json['text_filed']);
  }
}



class Tenant_Demands_details extends StatefulWidget {
  String idd;
  String pending_id;
  Tenant_Demands_details({super.key, required this.idd, required this.pending_id});

  @override
  State<Tenant_Demands_details> createState() => _Tenant_Demands_detailsState();
}

class _Tenant_Demands_detailsState extends State<Tenant_Demands_details> {



  Future<List<Catid>> fetchData() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_Verify_Tenant_Demands_by_id_?VTD_id=${widget.idd}');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['VTD_id'].compareTo(a['VTD_id']));
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }



  Future<List<RealstateModel>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Show_Image_under_Realestatet?id_num=1'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return RealstateModel(
          rimage: item['Rimage'],
        );
      }).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> Book_property() async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=1&looking=Book'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<List<Catid_review>> fetchData_review(id) async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/showing_under_feedback_tenant_demand_by_subid?subid=$id');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid_review.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid_visit>> fetchDatavisit(id) async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_tenant_demand_visit_info_by_subid_?subid=${id}');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid_visit.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid_respo>> fetchDataresponce(id) async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/show_add_info_in_tanat_demand?sub_id=${id}');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid_respo.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }



  bool _isDeleting = false;

  //Delete api
  Future<void> DeletePropertybyid(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=1');
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

  DateTime now = DateTime.now();

  // Format the date as you like
  late String formattedDate;

  @override
  void initState() {
    super.initState();

  }

  String data = 'Initial Data';

  void _refreshData() {
    setState(() {
      data = 'Refreshed Data at ${DateTime.now()}';
    });
  }

  Future<void> _handleMenuItemClick(String value) async {
    // Handle the menu item click
    print("You clicked: $value");
    if (value.toString() == 'Edit Property'){
      fetchData();
      final result = await fetchData();
      Navigator.push(
          context,
          MaterialPageRoute
            (builder: (context) => Edit_TenantDemands(id: '${result.first.id}', V_name: '${result.first.V_name}', V_number: '${result.first.V_number}', bhk: '${result.first.bhk}',
            budget: '${result.first.budget}', place: '${result.first.place}', floor_option: '${result.first.floor_option}', Family_Members: '${result.first.Family_Members}', Shifting_date: '${result.first.Shifting_date}', Parking: '${result.first.Parking}'
            , Gadi_Number: '${result.first.Gadi_Number}', FeildWorker_Name: '${result.first.FeildWorker_Name}', FeildWorker_Number: '${result.first.FeildWorker_Number}', Current__Date: '${result.first.Current__Date}', buyrent: '${result.first.buyrent}',))
      );
    }
  }

  Future<void> fetchdata_insurt(Name,Number,BHK,Budget,Place,Floor_option,Family_Members,Additional_Info,Shifting_date,Parking,Gadi_Number,FeildWorker_Name,FeildWorker_Number,Current__Date) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/add_Tanant_demands_book_details_2nd_table?V_name=$Name&V_number=$Number&bhk=$BHK&budget=$Budget&place=$Place&floor_option=$Floor_option&Family_Members=$Family_Members&Additional_Info=$Additional_Info&Shifting_date=$Shifting_date&Parking=$Parking&Gadi_Number=$Gadi_Number&FeildWorker_Name=$FeildWorker_Name&FeildWorker_Number=$FeildWorker_Number&Current__Date=$Current__Date'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tenant_demands(),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<void> DeleteVehicleNumbers(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/delete_Verify_Tenant_Demands_by_id_?VTD_id=$itemId');
    final response = await http.get(url);
    // await Future.delayed(Duration(seconds: 1));
    if (response.statusCode == 200) {

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
      appBar: AppBar(
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

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: FutureBuilder<List<Catid>>(
                  future: fetchData(),
                  builder: (context,abc){
                    if(abc.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(abc.hasError){
                      return Text('${abc.error}');
                    }
                    else if (abc.data == null || abc.data!.isEmpty) {
                      // If the list is empty, show an empty image
                      return Center(
                        child: Column(
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
                          itemBuilder: (BuildContext context,int len){
                            return GestureDetector(
                              onTap: () async {
                                //  int itemId = abc.data![len].id;
                                //int iiid = abc.data![len].PropertyAddress
                                /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('id_Document', abc.data![len].id.toString());*/
                                /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('id_Building', abc.data![len].id);
                                prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
                                prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute
                                      (builder: (context) => Tenant_Demands_details())
                                );*/

                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 5,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Icon(PhosphorIcons.house,size: 12,color: Colors.red,),
                                                        SizedBox(width: 2,),
                                                        Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].buyrent/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].place/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text(" Name | Number",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: 10,),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.red),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.red.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].V_name/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  GestureDetector(
                                                    onTap: (){

                                                      showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Contact "+abc.data![len].V_number),
                                                          content: Text('Do you really want to Contact? '+abc.data![len].V_number ),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          actions: <Widget>[

                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                ElevatedButton(
                                                                  onPressed: () async {
                                                                    DateTime now = DateTime.now();
                                                                    formattedDate = "${now.day}-${now.month}-${now.year}";
                                                                    //formattedTime = "${now.hour}:${now.minute}:${now.second}";
                                                                    //fetchdata_add_responce('Try to contact on Whatsapp', widget.id, 'Date: $formattedDate Time: $formattedTime');

                                                                    String phone = "+91${abc.data![len].V_number}"; // Ensure phone number is in international format without '+'
                                                                    String message = Uri.encodeComponent("Looking for a ${abc.data![len].bhk} flat for ${abc.data![len].buyrent} in Sultanpur? Feel free to contact us for further details.\n\nRegards,\nVerify Properties");

                                                                    String url;

                                                                    if(Platform.isAndroid){
                                                                      //String url = 'whatsapp://send?phone="+91${abc.data![len].demand_number}"&text="Hello"';
                                                                      url = "https://wa.me/$phone?text=$message";
                                                                      await launchUrl(Uri.parse(url));
                                                                    }else {
                                                                      String url = 'https://wa.me/${abc.data![len].V_number}';
                                                                      await launchUrl(Uri.parse(url));
                                                                    }

                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Colors.grey.shade800,
                                                                  ),
                                                                  child: Container(
                                                                    padding: EdgeInsets.only(top: 15,bottom: 15),
                                                                    child: ClipRRect(
                                                                      borderRadius:
                                                                      const BorderRadius.all(Radius.circular(10)),
                                                                      child: Container(
                                                                        height: 60,
                                                                        width: 60,
                                                                        child: CachedNetworkImage(
                                                                          imageUrl:
                                                                          AppImages.whatsaap,
                                                                          fit: BoxFit.cover,
                                                                          placeholder: (context, url) => Image.asset(
                                                                            AppImages.whatsaap,
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                          errorWidget: (context, error, stack) =>
                                                                              Image.asset(
                                                                                AppImages.whatsaap,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                ElevatedButton(
                                                                  onPressed: () async {

                                                                    DateTime now = DateTime.now();
                                                                    formattedDate = "${now.day}-${now.month}-${now.year}";
                                                                    //formattedTime = "${now.hour}:${now.minute}:${now.second}";
                                                                    //fetchdata_add_responce('Try for Calling', widget.id, 'Date: $formattedDate Time: $formattedTime');

                                                                    /*if (await canLaunchUrl(Uri.parse('${abc.data![len].demand_number}'))) {
                                                                await launchUrl(Uri.parse('${abc.data![len].demand_number}'));
                                                              } else {
                                                                throw 'Could not launch ${abc.data![len].demand_number}';
                                                              }*/
                                                                    FlutterPhoneDirectCaller.callNumber('${abc.data![len].V_number}');
                                                                  },
                                                                  style: ElevatedButton.styleFrom(
                                                                    backgroundColor: Colors.grey.shade800,
                                                                  ),
                                                                  child: Container(
                                                                    padding: EdgeInsets.only(top: 15,bottom: 15),
                                                                    child: ClipRRect(
                                                                      borderRadius:
                                                                      const BorderRadius.all(Radius.circular(10)),
                                                                      child: Container(
                                                                        height: 60,
                                                                        width: 60,
                                                                        child: CachedNetworkImage(
                                                                          imageUrl:
                                                                          AppImages.call,
                                                                          fit: BoxFit.cover,
                                                                          placeholder: (context, url) => Image.asset(
                                                                            AppImages.call,
                                                                            fit: BoxFit.cover,
                                                                          ),
                                                                          errorWidget: (context, error, stack) =>
                                                                              Image.asset(
                                                                                AppImages.call,
                                                                                fit: BoxFit.cover,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],),


                                                          ],
                                                        ),
                                                      ) ?? false;
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(width: 1, color: Colors.red),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.red.withOpacity(0.5),
                                                              blurRadius: 10,
                                                              offset: Offset(0, 0),
                                                              blurStyle: BlurStyle.outer
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(Iconsax.call,size: 15,color: Colors.red,),
                                                          SizedBox(width: 4,),
                                                          Text(""+abc.data![len].V_number/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500,
                                                                letterSpacing: 0.5
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Type Of Requirement / Floor Options",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.purple),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.purple.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].bhk/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              Container(
                                                margin: EdgeInsets.all(10),
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.purple),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.purple.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].floor_option/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              
                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons.car,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Need Parking / Vehicle Number",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.cyanAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.cyanAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].Parking/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),




                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.cyanAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.cyanAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].Gadi_Number.toUpperCase(),
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),





                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons
                                                      .users_four, size: 12,
                                                    color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text(
                                                    "Family Members : ",
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors
                                                            .black,
                                                        fontWeight: FontWeight
                                                            .w600
                                                    ),
                                                  ),
                                                  Text("" +
                                                      abc.data![len].Family_Members +
                                                      " Members",
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors
                                                            .black,
                                                        fontWeight: FontWeight
                                                            .w400
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Additional Information",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      SizedBox(
                                                        width: 300,
                                                        child: Text(""+abc.data![len].Additional_Info,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w400
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),


                                                ],
                                              ),

                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(PhosphorIcons.address_book,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text("Budget / Shifting Date",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),

                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.blue),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.blue.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Icon(PhosphorIcons.currency_inr,size: 12,color: Colors.red,),
                                                        SizedBox(width: 2,),
                                                        Text(""+abc.data![len].budget/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.blue),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.blue.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].Shifting_date/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                ],
                                              ),

                                              SizedBox(height: 10,),

                                              Center(
                                                child: Text("Field Worker",style: TextStyle(fontSize: 16,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),),
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),

                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.purple),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.purple.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].FeildWorker_Name/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  GestureDetector(
                                                    onTap: (){

                                                      showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text('Call Feild Worker'),
                                                          content: Text('Do you really want to Call Feild Worker?'),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                FlutterPhoneDirectCaller.callNumber('${abc.data![len].FeildWorker_Number}');
                                                              },
                                                              child: Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ?? false;
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(width: 1, color: Colors.purple),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.purple.withOpacity(0.5),
                                                              blurRadius: 10,
                                                              offset: Offset(0, 0),
                                                              blurStyle: BlurStyle.outer
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        children: [
                                                          // Icon(Iconsax.sort_copy,size: 15,),
                                                          //SizedBox(width: 10,),
                                                          Text(""+abc.data![len].FeildWorker_Number/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                            style: TextStyle(
                                                                fontSize: 14,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500,
                                                                letterSpacing: 0.5
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              SizedBox(
                                                height: 5,
                                              ),

                                              Row(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.lightGreenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.lightGreenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text("Tenant id =  "+abc.data![len].id.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.lightGreenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.lightGreenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].Current_date.toString()/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                ],
                                              ),



                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }


                  }

              ),


            ),

            Container(
              child: FutureBuilder<List<Catid_visit>>(
                  future: fetchDatavisit(widget.pending_id),
                  builder: (context,abc){
                    if(abc.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(abc.hasError){
                      return Text('${abc.error}');
                    }
                    else if (abc.data == null || abc.data!.isEmpty) {
                      // If the list is empty, show an empty image
                      return Center(
                        child: Column(
                          children: [
                            // Lottie.asset("assets/images/no data.json",width: 450),
                            Text("",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                          ],
                        ),
                      );
                    }
                    else{
                      return ListView.builder(
                          itemCount: abc.data!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int len){
                            return GestureDetector(
                              onTap: () async {

                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 5,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Text(" Clint Visit",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.redAccent,fontFamily: 'Poppins',letterSpacing: 0)),

                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Icon(PhosphorIcons.house,size: 12,color: Colors.red,),
                                                        SizedBox(width: 2,),
                                                        Text(""+abc.data![len].visit_date/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].visit_time/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text(" Name",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: 10,),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.red),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.red.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].source_click_website/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text(" Additional Number",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),

                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){

                                                      showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Call "+abc.data![len].number),
                                                          content: Text('Do you really want to Call? '+abc.data![len].number ),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                FlutterPhoneDirectCaller.callNumber('${abc.data![len].number}');
                                                              },
                                                              child: Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ?? false;
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(width: 1, color: Colors.red),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.red.withOpacity(0.5),
                                                              blurRadius: 10,
                                                              offset: Offset(0, 0),
                                                              blurStyle: BlurStyle.outer
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(Iconsax.call,size: 15,color: Colors.red,),
                                                          SizedBox(width: 4,),
                                                          Text(""+abc.data![len].number/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500,
                                                                letterSpacing: 0.5
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),



                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }


                  }

              ),


            ),

            Container(
              child: FutureBuilder<List<Catid_respo>>(
                  future: fetchDataresponce(widget.pending_id),
                  builder: (context,abc){
                    if(abc.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(abc.hasError){
                      return Text('${abc.error}');
                    }
                    else if (abc.data == null || abc.data!.isEmpty) {
                      // If the list is empty, show an empty image
                      return Center(
                        child: Column(
                          children: [
                            // Lottie.asset("assets/images/no data.json",width: 450),
                            Text("",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                          ],
                        ),
                      );
                    }
                    else{
                      return ListView.builder(
                          itemCount: abc.data!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int len){
                            return GestureDetector(
                              onTap: () async {

                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 5,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              Text(" Clint Responce",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.redAccent,fontFamily: 'Poppins',letterSpacing: 0)),


                                              SizedBox(
                                                height: 20,
                                              ),
                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Icon(PhosphorIcons.house,size: 12,color: Colors.red,),
                                                        SizedBox(width: 2,),
                                                        Text(""+abc.data![len].visit_date/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].visit_time/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text(" Empty Text",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: 10,),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.red),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.red.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Container(
                                                          width: 200,
                                                          child: Text(""+abc.data![len].txt,maxLines: 5/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500,
                                                                letterSpacing: 0.5
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),





                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }


                  }

              ),


            ),

            Container(
              child: FutureBuilder<List<Catid_review>>(
                  future: fetchData_review(widget.pending_id),
                  builder: (context,abc){
                    if(abc.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(abc.hasError){
                      return Text('${abc.error}');
                    }
                    else if (abc.data == null || abc.data!.isEmpty) {
                      // If the list is empty, show an empty image
                      return Center(
                        child: Column(
                          children: [
                            // Lottie.asset("assets/images/no data.json",width: 450),
                            Text("",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                          ],
                        ),
                      );
                    }
                    else{
                      return ListView.builder(
                          itemCount: abc.data!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int len){
                            return GestureDetector(
                              onTap: () async {
                                //  int itemId = abc.data![len].id;
                                //int iiid = abc.data![len].PropertyAddress
                                /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('id_Document', abc.data![len].id.toString());*/
                                /*SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setInt('id_Building', abc.data![len].id);
                                    prefs.setString('id_Longitude', abc.data![len].Longitude.toString());
                                    prefs.setString('id_Latitude', abc.data![len].Latitude.toString());
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute
                                          (builder: (context) => Tenant_Demands_details())
                                    );*/

                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            children: [

                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.black),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //SizedBox(width: 10,),
                                                    Text(""+abc.data![len].feedback/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),



                                            ],
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),

                                          Row(
                                            children: [
                                              Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                              SizedBox(width: 2,),
                                              Text(" Additional Info",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SizedBox(width: 10,),
                                              Container(
                                                padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                  border: Border.all(width: 1, color: Colors.indigoAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.indigoAccent.withOpacity(0.5),
                                                        blurRadius: 10,
                                                        offset: Offset(0, 0),
                                                        blurStyle: BlurStyle.outer
                                                    ),
                                                  ],
                                                ),
                                                child: Row(
                                                  children: [
                                                    // Icon(Iconsax.sort_copy,size: 15,),
                                                    //w SizedBox(width: 10,),
                                                    Text(""+abc.data![len].addtional_info/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w500,
                                                          letterSpacing: 0.5
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(
                                            height: 10,
                                          ),


                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }


                  }

              ),


            ),

            SizedBox(height: 20,),

           /* Container(
              child: FutureBuilder<List<Catid_visit>>(
                  future: fetchData1(),
                  builder: (context,abc){
                    if(abc.connectionState == ConnectionState.waiting){
                      return Center(child: CircularProgressIndicator());
                    }
                    else if(abc.hasError){
                      return Text('${abc.error}');
                    }
                    else if (abc.data == null || abc.data!.isEmpty) {
                      // If the list is empty, show an empty image
                      return Center(
                        child: Column(
                          children: [
                            // Lottie.asset("assets/images/no data.json",width: 450),
                            Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                          ],
                        ),
                      );
                    }
                    else{
                      return ListView.builder(
                          itemCount: abc.data!.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context,int len){
                            return GestureDetector(
                              onTap: () async {

                              },
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          SizedBox(width: 5,),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              SizedBox(
                                                height: 10,
                                              ),
                                              Row(
                                                children: [

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Icon(PhosphorIcons.house,size: 12,color: Colors.red,),
                                                        SizedBox(width: 2,),
                                                        Text(""+abc.data![len].visit_date*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  SizedBox(
                                                    width: 10,
                                                  ),

                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.greenAccent),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.greenAccent.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //SizedBox(width: 10,),
                                                        Text(""+abc.data![len].visit_time*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),


                                                ],
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text(" Name",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Row(
                                                children: [
                                                  SizedBox(width: 10,),
                                                  Container(
                                                    padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(5),
                                                      border: Border.all(width: 1, color: Colors.red),
                                                      boxShadow: [
                                                        BoxShadow(
                                                            color: Colors.red.withOpacity(0.5),
                                                            blurRadius: 10,
                                                            offset: Offset(0, 0),
                                                            blurStyle: BlurStyle.outer
                                                        ),
                                                      ],
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        // Icon(Iconsax.sort_copy,size: 15,),
                                                        //w SizedBox(width: 10,),
                                                        Text(""+abc.data![len].source_click_website*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                          style: TextStyle(
                                                              fontSize: 13,
                                                              color: Colors.black,
                                                              fontWeight: FontWeight.w500,
                                                              letterSpacing: 0.5
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              Row(
                                                children: [
                                                  Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                                  SizedBox(width: 2,),
                                                  Text(" Additional Number",
                                                    overflow: TextOverflow.ellipsis,
                                                    maxLines: 2,
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),

                                              Row(
                                                children: [
                                                  GestureDetector(
                                                    onTap: (){

                                                      showDialog<bool>(
                                                        context: context,
                                                        builder: (context) => AlertDialog(
                                                          title: Text("Call "+abc.data![len].number),
                                                          content: Text('Do you really want to Call? '+abc.data![len].number ),
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                          actions: <Widget>[
                                                            ElevatedButton(
                                                              onPressed: () => Navigator.of(context).pop(false),
                                                              child: Text('No'),
                                                            ),
                                                            ElevatedButton(
                                                              onPressed: () async {
                                                                FlutterPhoneDirectCaller.callNumber('${abc.data![len].number}');
                                                              },
                                                              child: Text('Yes'),
                                                            ),
                                                          ],
                                                        ),
                                                      ) ?? false;
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        border: Border.all(width: 1, color: Colors.red),
                                                        boxShadow: [
                                                          BoxShadow(
                                                              color: Colors.red.withOpacity(0.5),
                                                              blurRadius: 10,
                                                              offset: Offset(0, 0),
                                                              blurStyle: BlurStyle.outer
                                                          ),
                                                        ],
                                                      ),
                                                      child: Row(
                                                        children: [
                                                          Icon(Iconsax.call,size: 15,color: Colors.red,),
                                                          SizedBox(width: 4,),
                                                          Text(""+abc.data![len].number*//*+abc.data![len].Building_Name.toUpperCase()*//*,
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors.black,
                                                                fontWeight: FontWeight.w500,
                                                                letterSpacing: 0.5
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),



                                            ],
                                          ),


                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    }


                  }

              ),


            ),*/
          ],
        ),
      ),

      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
              onPressed: () async {
                fetchData();
                final result = await fetchData();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Visit_Form(id: '${widget.idd}', NName: '${result.first.V_name}', NNumber: '${result.first.V_number}', NBHK: '${result.first.bhk} For ${result.first.buyrent}',)));

              },

              child: Text('Add Visit',style: TextStyle(fontSize: 13),),
            ),
          ),
          SizedBox(width: 6), // Space between buttons
          Expanded(
            child: FutureBuilder<List<Catid>>(
                future: fetchData(),
                builder: (context,abc){
                  if(abc.connectionState == ConnectionState.waiting){
                    return Center(child: CircularProgressIndicator());
                  }
                  else if(abc.hasError){
                    return Text('${abc.error}');
                  }
                  else if (abc.data == null || abc.data!.isEmpty) {
                    // If the list is empty, show an empty image
                    return Center(
                      child: Column(
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
                        scrollDirection: Axis.vertical,
                        itemBuilder: (BuildContext context,int len){
                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                            onPressed: () {
                              // Button 2 action

                              showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Demand Full Filled'),
                                  content: Text('Do you really want to Full Filled this Demand?'),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: Text('No'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {

                                        formattedDate = "${now.day}-${now.month}-${now.year}";
                                        
                                        fetchdata_insurt('${abc.data![len].V_name}', '${abc.data![len].V_number}', '${abc.data![len].bhk}', '${abc.data![len].budget}', '${abc.data![len].place}', '${abc.data![len].floor_option}', '${abc.data![len].Family_Members}', '${abc.data![len].Additional_Info}', '${abc.data![len].Shifting_date}', '${abc.data![len].Parking}', '${abc.data![len].Gadi_Number}', '${abc.data![len].FeildWorker_Name}', '${abc.data![len].FeildWorker_Number}', '${formattedDate}');

                                        DeleteVehicleNumbers("${widget.idd}");

                                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tenant_demands(),), (route) => route.isFirst);

                                      },
                                      child: Text('Yes'),
                                    ),
                                  ],
                                ),
                              ) ?? false;

                              print('Button 2 pressed');
                            },
                            child: Text('Demand Full Filled',style: TextStyle(fontSize: 13)),
                          );
                        });
                  }


                }

            ),


          ),
        ],
      ),
    );
  }
}
