import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import '../ui_decoration_tools/app_images.dart';
import '../Tenant_Details_Demand/Feedback_Details_Page.dart';

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
  final String looking_type;

  Catid_pending(
      {required this.id, required this.fieldworkar_name, required this.fieldworkar_number, required this.demand_name, required this.demand_number,
        required this.buy_rent, required this.place, required this.BHK, required this.looking_type});

  factory Catid_pending.FromJson(Map<String, dynamic>json){
    return Catid_pending(id: json['id'],
        fieldworkar_name: json['fieldworkar_name'],
        fieldworkar_number: json['fieldworkar_number'],
        demand_name: json['demand_name'],
        demand_number: json['demand_number'],
        buy_rent: json['buy_rent'],
        place: json['add_info'],
        BHK: json['bhk'],
        looking_type: json['looking_type']);
  }
}

class Pending_demand_Status extends StatefulWidget {
  String id;
  Pending_demand_Status({super.key, required this.id});

  @override
  State<Pending_demand_Status> createState() => _Pending_demand_StatusState();
}

class _Pending_demand_StatusState extends State<Pending_demand_Status> {

  Future<List<Catid>> fetchData() async {
    final String apiUrl =
        'https://verifyserve.social/WebService4.asmx/Verify_Tenant_show_by_V_number_?V_number=${widget.id}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      // 🔹 Log API hit
      BugLogger.log(
        apiLink: apiUrl,
        error: "Response received",
        statusCode: response.statusCode,
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List) {
          decoded.sort(
                (a, b) => (b['VTD_id'] ?? 0).compareTo(a['VTD_id'] ?? 0),
          );

          return decoded
              .map<Catid>((data) => Catid.FromJson(data))
              .toList();
        } else {
          // 🔴 200 but unexpected format
          await BugLogger.log(
            apiLink: apiUrl,
            error: "200 but response is not List | Body: ${response.body}",
            statusCode: response.statusCode,
          );
          throw Exception('Invalid response format');
        }
      } else {
        // 🔴 Non-200 HTTP response
        await BugLogger.log(
          apiLink: apiUrl,
          error: "Non-200 response | Body: ${response.body}",
          statusCode: response.statusCode,
        );
        throw Exception('Failed to fetch data');
      }
    } catch (e, stack) {
      // 🔥 Network / JSON / runtime crash
      await BugLogger.log(
        apiLink: apiUrl,
        error: "Exception: $e\nStackTrace: $stack",
        statusCode: 0,
      );
      rethrow;
    }
  }


  Future<List<Catid_pending>> fetchData_pending(dynamic id) async {
    final String apiUrl =
        'https://verifyserve.social/WebService4.asmx/assign_tenant_demand_show_by_demand_number_?demand_number=${widget.id}';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      // 🔹 Log API hit
      BugLogger.log(
        apiLink: apiUrl,
        error: "Response received",
        statusCode: response.statusCode,
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded is List) {
          decoded.sort(
                (a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0),
          );

          return decoded
              .map<Catid_pending>((data) => Catid_pending.FromJson(data))
              .toList();
        } else {
          // 🔴 200 but unexpected format
          await BugLogger.log(
            apiLink: apiUrl,
            error: "200 but response is not List | Body: ${response.body}",
            statusCode: response.statusCode,
          );
          throw Exception('Invalid response format');
        }
      } else {
        // 🔴 Non-200 HTTP response
        await BugLogger.log(
          apiLink: apiUrl,
          error: "Non-200 response | Body: ${response.body}",
          statusCode: response.statusCode,
        );
        throw Exception('Failed to fetch pending data');
      }
    } catch (e, stack) {
      // 🔥 Network / JSON / runtime crash
      await BugLogger.log(
        apiLink: apiUrl,
        error: "Exception: $e\nStackTrace: $stack",
        statusCode: 0,
      );
      rethrow;
    }
  }


  Future<void> fetchdata_action(dynamic idddd, String looking, String feedback) async {
    final Uri apiUri = Uri.https(
      'verifyserve.social',
      '/WebService4.asmx/update_assign_tenant_demand_by_id_looking_feedback_',
      {
        'id': idddd.toString(),
        'looking_type': looking,
        'feedback': feedback,
      },
    );

    try {
      final response = await http.get(apiUri);

      // 🔹 Log API hit
      BugLogger.log(
        apiLink: apiUri.toString(),
        error: "Response received",
        statusCode: response.statusCode,
      );

      if (response.statusCode == 200) {
        // ASP.NET APIs often return plain text / XML
        final body = response.body.toLowerCase();

        if (body.contains('success') || body.contains('updated') || body.isNotEmpty) {
          print("✅ Update successful: ${response.body}");

          if (!context.mounted) return;

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => Pending_demand_Status(id: '${widget.id}'),
            ),
                (route) => route.isFirst,
          );
        } else {
          // 🔴 200 but logical failure
          await BugLogger.log(
            apiLink: apiUri.toString(),
            error: "200 but logical failure | Body: ${response.body}",
            statusCode: response.statusCode,
          );
          print("⚠️ Update failed (logical error)");
        }
      } else {
        // 🔴 Non-200 HTTP error
        await BugLogger.log(
          apiLink: apiUri.toString(),
          error: "Non-200 response | Body: ${response.body}",
          statusCode: response.statusCode,
        );
        print('❌ Failed Registration');
      }
    } catch (e, stack) {
      // 🔥 Network / runtime / encoding crash
      await BugLogger.log(
        apiLink: apiUri.toString(),
        error: "Exception: $e\nStackTrace: $stack",
        statusCode: 0,
      );
      print('❌ Exception while updating demand: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

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
                color: Colors.black,
                size: 31,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              //_launchURL();
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.apple_logo,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              child: FutureBuilder<List<Catid_pending>>(
                  future: fetchData_pending(""+1.toString()),
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
                            int displayIndex = abc.data!.length - len;
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
                                                    Text(""+abc.data![len].demand_name/*+abc.data![len].Building_Name.toUpperCase()*/,
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
                                                      title: Text("Call "+abc.data![len].demand_name),
                                                      content: Text('Do you really want to Call? '+abc.data![len].demand_name ),
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                      actions: <Widget>[
                                                        ElevatedButton(
                                                          onPressed: () => Navigator.of(context).pop(false),
                                                          child: Text('No'),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () async {
                                                            FlutterPhoneDirectCaller.callNumber('${abc.data![len].demand_number}');
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
                                                      Text(""+abc.data![len].demand_number/*+abc.data![len].Building_Name.toUpperCase()*/,
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

                                          SizedBox(
                                            height: 10,
                                          ),

                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute
                                                        (builder: (context) => Feedback_Details(id: '${abc.data![len].id.toString()}',))
                                                  );
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
                                                      color: Colors.deepPurpleAccent.withOpacity(0.8)),
                                                  child: Center(
                                                    child: Text(
                                                      "Open Page",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                          letterSpacing: 0.8,
                                                          fontSize: 14),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              GestureDetector(
                                                onTap: (){
                                                  fetchdata_action('${abc.data![len].id}', 'Re_Demand', 'Re_Demand');
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
                                                      color: Colors.deepPurpleAccent.withOpacity(0.8)),
                                                  child: Center(
                                                    child: Text(
                                                      "Re Demand",
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

                                          SizedBox(height: 10,),

                                          Row(
                                            children: [
                                              Container(
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
                                                    Text(""+abc.data![len].looking_type/*"Demand No = $displayIndex"*/,/*+abc.data![len].Building_Name.toUpperCase()*/
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

                                                      /*  showDialog<bool>(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                title: Text("Call "+abc.data![len].V_name),
                                                                content: Text('Do you really want to Call? '+abc.data![len].V_name ),
                                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                                                actions: <Widget>[
                                                                  ElevatedButton(
                                                                    onPressed: () => Navigator.of(context).pop(false),
                                                                    child: Text('No'),
                                                                  ),
                                                                  ElevatedButton(
                                                                    onPressed: () async {
                                                                      FlutterPhoneDirectCaller.callNumber('${abc.data![len].V_number}');
                                                                    },
                                                                    child: Text('Yes'),
                                                                  ),
                                                                ],
                                                              ),
                                                            ) ?? false;*/
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

                                                      /* showDialog<bool>(
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
                                                            ) ?? false;*/
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
          ],
        ),
      ),

    );
  }
}
