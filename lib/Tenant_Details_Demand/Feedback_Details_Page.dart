import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Home_Screen_click/Add_RealEstate.dart';
import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import '../Custom_Widget/constant.dart';
import 'Add_Review_Under_feedback.dart';
import 'Add_TenantDemands.dart';
import 'Add_Tenant_Visit.dart';
import 'Add_moredetails_for_assigndemand/add_moredetails.dart';
import 'Assigned_demand_Add_MainTenant_Demand.dart';
import 'Feedback_Details_Page.dart';
import 'Feild_Accpte_TenantDemand.dart';
import 'MainPage_Tenantdemand_Portal.dart';
import 'Parent_class_TenantDemand.dart';
import 'Perant_Class_Accpte_Demand.dart';

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
    return Catid(id: json['id'],
        V_name: json['V_name'],
        V_number: json['V_number'],
        bhk: json['bhk'],
        budget: json['budget'],
        place: json['place'],
        floor_option: json['floor_option'],
        Additional_Info: json['additional_info'],
        Shifting_date: json['shifting_date'],
        Current_date: json['Current_Dates'],
        Parking: json['parking'],
        Gadi_Number: json['Gadi_Number'],
        FeildWorker_Name: json['FeildWorkar_Name'],
        FeildWorker_Number: json['FeildWorkar_Number'],
        Current__Date: json['Current_Dates'],
        Family_Members: json['family_members'],
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

class Feedback_Details extends StatefulWidget {
  String id;
  Feedback_Details({super.key, required this.id});

  @override
  State<Feedback_Details> createState() => _Feedback_DetailsState();
}

class _Feedback_DetailsState extends State<Feedback_Details> {

  String _num = '';
  String _location = '';

  bool _isLoading = false;

  Future<void> uploadImageWithTitle(String V_name, String V_number, String bhk, String budget, String place, String floor_option, String Family_Members, String Additional_Info, String Shifting_date,
      String Parking, String Gadi_Number, String FeildWorker_Name, String FeildWorker_Number,
      String Current__Date,String Buy_rent,String pending_sub_id) async {
    String uploadUrl = 'https://verifyserve.social/PHP_Files/add_verify_tenant_demand/insert.php'; // Replace with your API endpoint

    FormData formData = FormData.fromMap({
      "V_name": V_name,
      "V_number": V_number,
      "bhk": bhk,
      "budget": budget,
      "place": place,
      "floor_option": floor_option,
      "Family_Members": Family_Members,
      "Additional_Info": Additional_Info,
      "Shifting_date": Shifting_date,
      "Parking": Parking,
      "Gadi_Number": Gadi_Number,
      "FeildWorker_Name": FeildWorker_Name,
      "FeildWorker_Number": FeildWorker_Number,
      "Current__Date": Current__Date,
      "Buy_rent": Buy_rent,
      "pending_sub_id": pending_sub_id,
    });

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
            msg: "Upload successful",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Persnol_Assignd_Tenant_details(),), (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload successful')),
        );
        setState(() {
          _isLoading = false;
        });
        print('Upload successful: ${response.data}');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
        Fluttertoast.showToast(
            msg: "Error",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 16.0
        );
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
      Fluttertoast.showToast(
          msg: "Error",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      print('Error occurred: $e');
    }
  }

  Future<void> fetchdata_insurt_TenantDemand_original(Name,Number,BHK,Budget,Place,Floor_option,Family_Members,Additional_Info,Shifting_date,Parking,Gadi_Number,FeildWorker_Name,FeildWorker_Number,Current__Date,Buy_rent) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Tenant_Demands_insurt?V_name=$Name&V_number=$Number&bhk=$BHK&budget=$Budget&place=$Place&floor_option=$Floor_option&Family_Members=$Family_Members&Additional_Info=$Additional_Info&Shifting_date=$Shifting_date&Parking=$Parking&Gadi_Number=$Gadi_Number&FeildWorker_Name=$FeildWorker_Name&FeildWorker_Number=$FeildWorker_Number&Current__Date=$Current__Date&Buy_rent=$Buy_rent'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => MainPage_TenandDemand(),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<void> fetchData_delete(item) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Delete_assign_tenant_demand_?id=$item');
    final response = await http.get(url);
    // await Future.delayed(Duration(seconds: 1));
    if (response.statusCode == 200) {
      setState(() {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => parent_TenandDemand(),), (route) => route.isFirst);
        //_isDeleting = false;
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



  Future<List<Catid>> fetchData(id) async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/show_by_subid_verify_pending_visit_tenant_demand?sub_id=${widget.id}');
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

  Future<List<Catid_pending>> fetchData_pendinhg() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_assign_tenant_demand_by_id_?id=${widget.id}');
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      listresponce.sort((a, b) => b['id'].compareTo(a['id']));
      return listresponce.map((data) => Catid_pending.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid_review>> fetchData_review_call_whatsapp(id) async {
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

  Future<List<Catid_visit>> fetchDatavisit() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/display_tenant_demand_visit_info_by_subid_?subid=${widget.id}');
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

  Future<List<Catid_respo>> fetchDataresponce() async {
    var url = Uri.parse('https://verifyserve.social/WebService4.asmx/show_add_info_in_tanat_demand?sub_id=${widget.id}');
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

  Future<void> fetchdata_add_responce(feedback,su_id,datetime) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/add_under_feedback_tenant_demand_?feedback=$feedback&subid=$su_id&addtional_info=$datetime'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Feedback_Details(id: '${widget.id}',),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  final TextEditingController _Visit_Date = TextEditingController();
  final TextEditingController _Visit_Time = TextEditingController();
  final TextEditingController _info = TextEditingController();

  late String formattedDate;
  late String formattedTime;

  Future<void> fetchdata_vis(Visit_Date,Visit_Time,number,idddd,name,bhhkk,aditional_info) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/add_tenant_demand_visit_info_?visit_date=$Visit_Date&visit_time=$Visit_Time&number=$number&subid=$idddd&source_click_website=$name&ninetynine_acres=$bhhkk&other=$aditional_info'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Feedback_Details(id: '${widget.id}',),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<void> fetchdata_responce(Visit_Date,Visit_Time,txt,idd) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/insert_data_add_info_in_tanat_demand?dates=$Visit_Date&times=$Visit_Time&text_filed=$txt&sub_id=$idd'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Feedback_Details(id: '${widget.id}',),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  void _showBottomSheet(BuildContext context) {



    final List<String> names = ['Not Reachable', 'Cut the phone', 'Talk to me Later'];

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {





              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),

                    Row(
                      children: [

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text('Visit Date',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                            SizedBox(height: 5,),

                            Container(
                              width: 155,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                // boxShadow: K.boxShadow,
                              ),
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                controller: _Visit_Date,
                                readOnly: true,
                                onTap: () async{
                                  DateTime? pickedDate = await showDatePicker(
                                      context: context, initialDate: DateTime.now(),
                                      firstDate: DateTime(2010), //DateTime.now() - not to allow to choose before today.
                                      lastDate: DateTime(2101));

                                  if(pickedDate != null ){
                                    print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                                    String formattedDate = DateFormat('dd-MMMM-yyyy').format(pickedDate);
                                    print(formattedDate); //formatted date output using intl package =>  2021-03-16
                                    //you can implement different kind of Date Format here according to your requirement
                                    //yyyy-MM-dd
                                    setState(() {
                                      _Visit_Date.text = formattedDate; //set output date to TextField value.
                                    });
                                  }else{
                                    print("Date is not selected");
                                  }
                                },
                                decoration: InputDecoration(
                                    hintText: "Visit Date",
                                    hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                    border: InputBorder.none),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(
                          width: 10,
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                                padding: EdgeInsets.only(left: 5),
                                child: Text('Visit Time',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                            SizedBox(height: 5,),

                            Container(
                              width: 155,
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                // boxShadow: K.boxShadow,
                              ),
                              child: TextField(
                                style: TextStyle(color: Colors.black),
                                controller: _Visit_Time,
                                readOnly: true,
                                onTap: () async{
                                  final TimeOfDay? picked = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );
                                  if (picked != null) {
                                    setState(() {
                                      _Visit_Time.text = picked.format(context);
                                    });
                                  }

                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                    hintText: "Visit Time",
                                    hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                                    border: InputBorder.none),
                              ),
                            ),

                          ],
                        ),

                      ],
                    ),

                    /*SizedBox(height: 20,),

              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("Talk Detail",style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

              SizedBox(height: 5,),

              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // boxShadow: K.boxShadow,
                ),
                child: TextField(style: TextStyle(color: Colors.black),
                  controller: _Additional_info,
                  decoration: InputDecoration(
                      hintText: "Talk Detail",
                      prefixIcon: Icon(
                        Icons.work_outline,
                        color: Colors.black54,
                      ),
                      hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                      border: InputBorder.none),
                ),
              ),*/

                    SizedBox(height: 40,),

                    Center(
                      child:  Container(
                        height: 50,
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.red.withOpacity(0.8)
                        ),



                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                          ),
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            formattedDate = "${now.day}/${now.month}/${now.year}";
                            formattedTime = "${now.hour}:${now.minute}:${now.second}";

                            fetchData_pendinhg();
                            final result = await fetchData_pendinhg();
                            //data = _email.toString();
                            //fetchdata(_Visit_Date.text, _Visit_Time.text, _Additional_Number.text, _Source.text);
                            //fetchdata_vis(_Visit_Date.text, _Visit_Time.text,_num);
                            fetchdata_vis(_Visit_Date.text, _Visit_Time.text, '${result.first.demand_number}', widget.id, '${result.first.demand_name}', '${result.first.BHK} For ${result.first.buy_rent}', _num);
                            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tenant_Demands_details(idd: '${widget.id}',),), (route) => route.isFirst);

                          }, child: Text("Submit", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, ),
                        ),
                        ),

                      ),
                    ),

                    SizedBox(height: 40,),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showBottomSheet_responce(BuildContext context) {



    final List<String> names = ['Not Reachable', 'Cut the phone', 'Talk to me Later'];

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {





              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),

                    Container(
                        padding: EdgeInsets.only(left: 5),
                        child: Text('Information',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                    SizedBox(height: 5,),

                    Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: K.boxShadow,
                      ),
                      child: TextField(
                        style: TextStyle(color: Colors.black),
                        controller: _info,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            hintText: "Empty Text",
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),

                    /*SizedBox(height: 20,),

              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text("Talk Detail",style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

              SizedBox(height: 5,),

              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // boxShadow: K.boxShadow,
                ),
                child: TextField(style: TextStyle(color: Colors.black),
                  controller: _Additional_info,
                  decoration: InputDecoration(
                      hintText: "Talk Detail",
                      prefixIcon: Icon(
                        Icons.work_outline,
                        color: Colors.black54,
                      ),
                      hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                      border: InputBorder.none),
                ),
              ),*/

                    SizedBox(height: 40,),

                    Center(
                      child:  Container(
                        height: 50,
                        width: 200,
                        margin: const EdgeInsets.symmetric(horizontal: 50),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            color: Colors.red.withOpacity(0.8)
                        ),



                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red
                          ),
                          onPressed: () async {
                            DateTime now = DateTime.now();
                            formattedDate = "${now.day}/${now.month}/${now.year}";
                            formattedTime = "${now.hour}:${now.minute}:${now.second}";

                            fetchData_pendinhg();
                            final result = await fetchData_pendinhg();
                            //data = _email.toString();
                            //fetchdata(_Visit_Date.text, _Visit_Time.text, _Additional_Number.text, _Source.text);
                            //fetchdata_vis(_Visit_Date.text, _Visit_Time.text,_num);
                            //fetchdata_vis(_Visit_Date.text, _Visit_Time.text, '${result.first.demand_number}', widget.id, '${result.first.demand_name}', '${result.first.BHK} For ${result.first.buy_rent}', _num);
                            fetchdata_responce(formattedDate, formattedTime, _info.text, widget.id);
                            //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tenant_Demands_details(idd: '${widget.id}',),), (route) => route.isFirst);

                          }, child: Text("Submit", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, ),
                        ),
                        ),

                      ),
                    ),

                    SizedBox(height: 40,),

                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> fetchdata_action(idddd,looking,fedback) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/update_assign_tenant_demand_by_id_looking_feedback_?id=$idddd&looking_type=$looking&feedback=$fedback'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => parent_TenandDemand(),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  void _showBottomSheet_list_actionbutton(BuildContext context) {



    final List<String> items = ['Demand Full Filled', 'Wrong Query','Wrong Number','Not Interested','Not in Budget'];

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {

                showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('${items[index]}'),
                    content: Text(''),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: Text('No'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          fetchdata_action('${widget.id}', '${items[index]}', '${items[index]}');
                          //fetchData_delete(widget.id);
                        },
                        child: Text('Yes'),
                      ),
                    ],
                  ),
                ) ?? false;
                /*fetchdata_action('${widget.id}', '${items[index]}', '${items[index]}');*/
                print(items[index]);


              },
              child: Container(
                margin: EdgeInsets.only(left: 10,right: 10),
                child: Column(
                  children: [
                    Container(
                      child: ListTile(
                        title: Center(child: Text(items[index])),
                      ),
                    ),
                    Divider(
                      thickness: 2, // Thickness of the divider
                      color: Colors.blue, // Color of the divider
                      indent: 20, // Space before the divider
                      endIndent: 20, // Space after the divider
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100.0), // Set the height here
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              title: Image.asset(AppImages.verify, height: 75),


              leading: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Column(
                  children: [
                    Row(
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

                  ],
                ),
              ),
              actions:  [
                GestureDetector(
                  onTap: () {
                    //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
                  },
                  child: const Icon(
                    PhosphorIcons.image,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
              ],
            ),


          ],
        ),),

      body: SingleChildScrollView(
        child: Column(
          children: [

            FutureBuilder<List<Catid_pending>>(
                future: fetchData_pendinhg(),
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
                          final propertyType = abc.data![len].BHK?.toLowerCase() ?? '';

                          final nextWord = propertyType.contains('commercial') ? 'Space' : 'Flat';

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
                                  padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 0),
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                fetchData_pendinhg();
                                                final result = await fetchData_pendinhg();

                                                _showBottomSheet(context);
                                                /*avigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) => Visit_Form(id: '${widget.id}', NName: '${result.first.demand_name}', NNumber: '${result.first.demand_number}', NBHK: '${result.first.BHK} For ${result.first.buy_rent}',)));
*/
                                              },
                                              child: Container(
                                                height: 40,
                                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(10)),
                                                    color: Colors.green.withOpacity(0.8)),
                                                child: Center(
                                                  child: Text(
                                                    "Add Visit",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.8,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            GestureDetector(
                                              onTap: () async {
                                                //_showBottomSheet(context, '${abc.data![len].id}');
                                                //print("${abc.data![len].id}");
                                                final url = Uri.parse('https://verifyserve.social/WebService4.asmx/countapi_verify_pending_visit_tenant_demand?sub_id=${widget.id}');
                                                final response = await http.get(url);
                                                print(response.body);
                                                if(response.body == '[{"logg":0}]'){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute
                                                        (builder: (context) => Add_Moredetails_for_assigndemand(iddd: '${abc.data![len].id}', name_: '${abc.data![len].demand_name}', number_: '${abc.data![len].demand_number}', Pending_id: '${widget.id}',))
                                                  );
                                                } else{
                                                  Fluttertoast.showToast(
                                                      msg: "Already Added information",
                                                      toastLength: Toast.LENGTH_LONG,
                                                      gravity: ToastGravity.BOTTOM,
                                                      timeInSecForIosWeb: 1,
                                                      backgroundColor: Colors.grey,
                                                      textColor: Colors.white,
                                                      fontSize: 16.0
                                                  );
                                                }

                                                /*Navigator.push(
                                                    context,
                                                    MaterialPageRoute
                                                      (builder: (context) => Add_Moredetails_for_assigndemand(iddd: '${abc.data![len].id}', name_: '${abc.data![len].demand_name}', number_: '${abc.data![len].demand_number}',))
                                                );*/

                                              },

                                              child: Container(
                                                height: 40,
                                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                                decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.only(
                                                        topLeft: Radius.circular(10),
                                                        topRight: Radius.circular(10),
                                                        bottomRight: Radius.circular(10),
                                                        bottomLeft: Radius.circular(10)),
                                                    color: Colors.red.withOpacity(0.8)),
                                                child: Center(
                                                  child: Text(
                                                    "Add More Details",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.8,
                                                        fontSize: 14),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          children: [

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
                                                  //SizedBox(width: 10,),
                                                  Text(""+abc.data![len].buy_rent/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                  Text(""+abc.data![len].BHK/*+abc.data![len].Building_Name.toUpperCase()*/,
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


                                            GestureDetector(

                                              onTap: () async {


                                                showDialog<bool>(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: Text("Contact "+abc.data![len].demand_name),
                                                    content: Text('Do you really want to Contact? '+abc.data![len].demand_name ),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    actions: <Widget>[

                                                      Row(
                                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                        children: [
                                                          ElevatedButton(
                                                            onPressed: () async {
                                                              DateTime now = DateTime.now();
                                                              formattedDate = "${now.day}-${now.month}-${now.year}";
                                                              formattedTime = "${now.hour}:${now.minute}:${now.second}";
                                                              fetchdata_add_responce('Try to contact on Whatsapp', widget.id, 'Date: $formattedDate Time: $formattedTime');

                                                              String phone = "+91${abc.data![len].demand_number}"; // Ensure phone number is in international format without '+'
                                                              String message = Uri.encodeComponent(
                                                                  "Looking for a ${abc.data![len].BHK} $nextWord for ${abc.data![len].buy_rent} in Sultanpur? "
                                                                      "Feel free to contact us for further details.\n\nRegards,\nVerify Properties"
                                                              );
                                                              String url;

                                                              if(Platform.isAndroid){
                                                                //String url = 'whatsapp://send?phone="+91${abc.data![len].demand_number}"&text="Hello"';
                                                                url = "https://wa.me/$phone?text=$message";
                                                                await launchUrl(Uri.parse(url));
                                                              }else {
                                                                String url = 'https://wa.me/${abc.data![len].demand_number}';
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
                                                              formattedTime = "${now.hour}:${now.minute}:${now.second}";
                                                              fetchdata_add_responce('Try for Calling', widget.id, 'Date: $formattedDate Time: $formattedTime');

                                                              /*if (await canLaunchUrl(Uri.parse('${abc.data![len].demand_number}'))) {
                                                                await launchUrl(Uri.parse('${abc.data![len].demand_number}'));
                                                              } else {
                                                                throw 'Could not launch ${abc.data![len].demand_number}';
                                                              }*/
                                                              FlutterPhoneDirectCaller.callNumber('${abc.data![len].demand_number}');
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
                                                    /*Icon(Iconsax.call,size: 15,color: Colors.blue,),
                                                    SizedBox(width: 4,),*/
                                                    Text(""+abc.data![len].demand_name/*+abc.data![len].Building_Name.toUpperCase()*/,
                                                      style: TextStyle(
                                                          fontSize: 18,
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
                                          height: 10,
                                        ),

                                        Row(
                                          children: [
                                            Icon(Iconsax.location_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text("Feild Worker Name | Number",
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
                                                border: Border.all(width: 1, color: Colors.blueAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.blueAccent.withOpacity(0.5),
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
                                                  Text(""+abc.data![len].fieldworkar_name/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                    title: Text("Call "+abc.data![len].fieldworkar_number),
                                                    content: Text('Do you really want to Call? '+abc.data![len].fieldworkar_name ),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                    actions: <Widget>[
                                                      ElevatedButton(
                                                        onPressed: () => Navigator.of(context).pop(false),
                                                        child: Text('No'),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () async {
                                                          FlutterPhoneDirectCaller.callNumber('${abc.data![len].fieldworkar_number}');
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
                                                  border: Border.all(width: 1, color: Colors.pinkAccent),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.pinkAccent.withOpacity(0.5),
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
                                                    Text(""+abc.data![len].fieldworkar_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                          height: 10,
                                        ),

                                        Row(
                                          children: [
                                            SizedBox(width: 10,),
                                            Container(
                                              width: 300,
                                              padding: EdgeInsets.only(left: 10,right: 10,top: 0,bottom: 0),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(5),
                                                border: Border.all(width: 1, color: Colors.orangeAccent),
                                                boxShadow: [
                                                  BoxShadow(
                                                      color: Colors.orangeAccent.withOpacity(0.5),
                                                      blurRadius: 10,
                                                      offset: Offset(0, 0),
                                                      blurStyle: BlurStyle.outer
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                children: [
                                                  // Icon(Iconsax.sort_copy,size: 15,),
                                                  //w SizedBox(width: 10,),
                                                  Text(""+abc.data![len].place,maxLines: 3,/*+abc.data![len].Building_Name.toUpperCase()*/
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


                                        FutureBuilder<List<Catid>>(
                                            future: fetchData(""+1.toString()),
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
                                                    //scrollDirection: Axis.vertical,
                                                    physics: NeverScrollableScrollPhysics(),
                                                    itemBuilder: (BuildContext context,int len){
                                                      return GestureDetector(
                                                        onTap: () async {

                                                        },
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 10),
                                                              child: Container(
                                                                padding: const EdgeInsets.all(0),
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
                                                                              width: 20,
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

                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),


                                                                          ],
                                                                        ),
                                                                        SizedBox(
                                                                          height: 5,
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
                                                                            Icon(PhosphorIcons.users_four,size: 12,color: Colors.red,),
                                                                            SizedBox(width: 2,),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: Text("Family Members = ",
                                                                                overflow: TextOverflow.ellipsis,
                                                                                maxLines: 2,
                                                                                style: TextStyle(
                                                                                    fontSize: 11,
                                                                                    color: Colors.black,
                                                                                    fontWeight: FontWeight.w600
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            SizedBox(width: 10,),
                                                                            SizedBox(
                                                                              width: 100,
                                                                              child: Text(""+abc.data![len].Family_Members+" Members",
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




            Container(
              child: FutureBuilder<List<Catid_visit>>(
                  future: fetchDatavisit(),
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
                  future: fetchDataresponce(),
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
                  future: fetchData_review_call_whatsapp(widget.id),
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



          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: 10,top: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () async {
                  // Button 1 action
                  /*final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FileUploadPage()));

                  if (result == true) {
                    _refreshData();
                  }*/
                  _showBottomSheet_responce(context);
                  print('Button 1 pressed');
                },
                child: Text('Add Responce',style: TextStyle(fontSize: 13,color: Colors.white),),
              ),
            ),

            SizedBox(
              width: 2,
            ),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () async {
                  // Button 1 action
                  /*final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FileUploadPage()));

                  if (result == true) {
                    _refreshData();
                  }*/
                  _showBottomSheet_list_actionbutton(context);
                  print('Button 1 pressed');
                },
                child: Text('Action Button',style: TextStyle(fontSize: 13,color: Colors.white),),
              ),
            ),

            SizedBox(
              width: 2,
            ),

            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                onPressed: () async {

                  final url = Uri.parse('https://verifyserve.social/WebService4.asmx/countapi_verify_pending_visit_tenant_demand?sub_id=${widget.id}');
                  final response = await http.get(url);
                  print(response.body);
                  if(response.body == '[{"logg":0}]'){
                    Fluttertoast.showToast(
                        msg: "Error: Firstly Fill More Details About this Demand",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );
                    /*Navigator.push(
                        context,
                        MaterialPageRoute
                          (builder: (context) => Add_Moredetails_for_assigndemand(iddd: '${abc.data![len].id}', name_: '${abc.data![len].demand_name}', number_: '${abc.data![len].demand_number}',))
                    );*/
                  } else{

                    showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Add Demand'),
                        content: Text('Do you Really add to All Demands?'),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: Text('No'),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              fetchData(widget.id);
                              final result_tenant = await fetchData(widget.id);

                              uploadImageWithTitle(result_tenant.first.V_name, result_tenant.first.V_number, result_tenant.first.bhk, result_tenant.first.budget, result_tenant.first.place, result_tenant.first.floor_option, result_tenant.first.Family_Members, result_tenant.first.Additional_Info, result_tenant.first.Shifting_date, result_tenant.first.Parking, result_tenant.first.Gadi_Number, result_tenant.first.FeildWorker_Name, result_tenant.first.FeildWorker_Number, result_tenant.first.Current_date, result_tenant.first.buyrent, widget.id);

                              fetchData_delete(widget.id);

                            },
                            child: Text('Yes'),
                          ),
                        ],
                      ),
                    ) ?? false;


                    /*Fluttertoast.showToast(
                        msg: "Already Added information",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.white,
                        fontSize: 16.0
                    );*/
                  }

                  // Button 1 action
                  /*final result = await Navigator.of(context).push(MaterialPageRoute(builder: (context)=> FileUploadPage()));

                  if (result == true) {
                    _refreshData();
                  }*/
                  //_showBottomSheet_list_actionbutton(context);
                  print('Button 1 pressed');
                },
                child: Text('Add Demand',style: TextStyle(fontSize: 13,color: Colors.white),),
              ),
            ),

          ],
        ),
      ),

    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _num = prefs.getString('number') ?? '';
      _location = prefs.getString('location') ?? '';
    });
  }

}
