import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Propert_verigication_Document/Add_Property_Veerification.dart';
import '../Propert_verigication_Document/Show_tenant.dart';
import '../ui_decoration_tools/constant.dart';
import 'Owner_Details.dart';
import 'Submit_Police_Verification.dart';

class Catid {
  final int id;
  final String Property_Number;
  final String PropertyAddress;
  final String Looking_Prop_;
  final String FLoorr;
  final String Flat;
  final String Tenant_Name;
  final String Tenant_Rented_Amount;
  final String Tenant_Rented_Date;
  final String About_tenant;
  final String Tenant_Number;
  final String Tenant_Email;
  final String Tenant_WorkProfile;
  final String Tenant_Members;
  final String Owner_Name ;
  final String Owner_Number;
  final String Subid;

  Catid(
      {required this.id, required this.Property_Number, required this.PropertyAddress, required this.Looking_Prop_, required this.FLoorr, required this.Flat, required this.Tenant_Name, required this.Tenant_Rented_Amount, required this.Tenant_Rented_Date, required this.About_tenant, required this.Tenant_Number, required this.Tenant_Email, required this.Tenant_WorkProfile, required this.Tenant_Members, required this.Owner_Name,
        required this.Owner_Number,required this.Subid});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(id: json['TUP_id'],
        Property_Number: json['Property_Number'],
        PropertyAddress: json['PropertyAddress'],
        Looking_Prop_: json['Looking_Prop_'],
        FLoorr: json['FLoorr'],
        Flat: json['Flat'],
        Tenant_Name: json['Tenant_Name'],
        Tenant_Rented_Amount: json['Tenant_Rented_Amount'],
        Tenant_Rented_Date: json['Tenant_Rented_Date'],
        About_tenant: json['About_tenant'],
        Tenant_Number: json['Tenant_Number'],
        Tenant_Email: json['Tenant_Email'],
        Tenant_WorkProfile: json['Tenant_WorkProfile'],
        Tenant_Members: json['Tenant_Members'],
        Owner_Name: json['Owner_Name'],
        Owner_Number: json['Owner_Number'],
        Subid: json['Subid']);
  }
}

class Police_Verification extends StatefulWidget {
  const Police_Verification({super.key});

  @override
  State<Police_Verification> createState() => _Police_VerificationState();
}

class _Police_VerificationState extends State<Police_Verification> {

  String _number = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  Future<List<Catid>> fetchData(id) async{
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/Verify_AddTenant_show_by_fieldworkar_?fieldworkarnumber=$_number");
    final responce=await http.get(url);
    if(responce.statusCode==200){
      List listresponce=json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else{
      throw Exception('Unexpected error occured!');
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
            Navigator.pop(context, true);

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
        actions:  [
          GestureDetector(
            onTap: () {
              //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Delete_Image()));
            },
            child: const Icon(
              PhosphorIcons.trash,
              color: Colors.black,
              size: 30,
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),

      body: Container(
        child: FutureBuilder<List<Catid>>(
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
                      Text("No Data Found!",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                    ],
                  ),
                );
              }
              else{
                return ListView.builder(
                    itemCount: abc.data!.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemBuilder: (BuildContext context,int len){
                      return GestureDetector(
                        onTap: () async {
                          //  int itemId = abc.data![len].id;
                          //int iiid = abc.data![len].PropertyAddress
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          /*prefs.setString('id_Document', abc.data![len].id.toString());
                          prefs.setString('Property_Number', abc.data![len].Building_Address.toString());
                          prefs.setString('PropertyAddress', abc.data![len].Building_Location.toString());
                          prefs.setString('Looking_Prop_', abc.data![len].tyope.toString());
                          prefs.setString('FLoorr', abc.data![len].floor_.toString());
                          prefs.setString('Flat', abc.data![len].Flat.toString());
                          prefs.setString('Owner_Name', abc.data![len].Ownername.toString());
                          prefs.setString('Owner_Number', abc.data![len].Owner_number.toString());*/
                          prefs.setString('FLoorr_For_PoliceVerification', abc.data![len].FLoorr.toString());
                          prefs.setString('Flat_PoliceVerification', abc.data![len].Flat.toString());
                          prefs.setString('Tenant_Rented_Amount_PoliceVerification', abc.data![len].Tenant_Rented_Amount.toString());
                          prefs.setString('Building_Sibid_For_PoliceVerification', abc.data![len].Subid.toString());
                          prefs.setString('Owner_Number_For_PoliceVerification', abc.data![len].Owner_Number.toString());
                          prefs.setString('Tenant_Number_For_PoliceVerification', abc.data![len].Tenant_Number.toString());
                          //prefs.setString('Owner_no', abc.data![len].Owner_number.toString());
                          /*Navigator.push(
                              context,
                              MaterialPageRoute
                                (builder: (context) => Owner_details())
                          );*/
                        },
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15, left: 10, right: 10, bottom: 10),
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
                                    Column(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(5)),
                                          child:  Container(
                                            child: Image.asset(AppImages.tenantprofile,width: 110,height: 100,fit: BoxFit.fill),
                                          ),
                                        ),

                                      ],
                                    ),
                                    SizedBox(width: 10,),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Iconsax.user_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text("Tenant Name",
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
                                          width: 140,
                                          child: Text(
                                            abc.data![len].Tenant_Name.toUpperCase(),
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Iconsax.mobile_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text("Contact",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Text('+91 '+abc.data![len].Tenant_Number,
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Iconsax.calendar_1_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text("Address & Place",
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
                                          width: 130,
                                          child: Text(''+abc.data![len].Property_Number+""+abc.data![len].PropertyAddress,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 3,
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          children: [
                                            Icon(Iconsax.money_3_copy,size: 12,color: Colors.red,),
                                            SizedBox(width: 2,),
                                            Text("Rent Amt.",
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Icon(Icons.currency_rupee_rounded,size: 10,color: Colors.black),
                                            SizedBox(
                                              width: 130,
                                              child: Text(''+abc.data![len].Tenant_Rented_Amount,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.green,
                                                    fontWeight: FontWeight.w500
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

    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }

}
