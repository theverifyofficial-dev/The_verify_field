import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant.dart';
import 'Dmand_Fullfilled_TanantName.dart';

class Add_tenant_under_demandfullfilled extends StatefulWidget {
  String id;
  Add_tenant_under_demandfullfilled({super.key, required this.id});

  @override
  State<Add_tenant_under_demandfullfilled> createState() => _Add_tenant_under_demandfullfilledState();
}

class _Add_tenant_under_demandfullfilledState extends State<Add_tenant_under_demandfullfilled> {

  final TextEditingController _Name = TextEditingController();
  final TextEditingController _Number = TextEditingController();

  Future<void> fetchdata(feild_name,feild_number,tenantid,document_id,tenant_name,tenant_number) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/add_tenant_under_book_table?fieldwarkar_name=$feild_name&fieldwarkar_number=$feild_number&tenant_id=$tenantid&demand_id=$document_id&tenant_name=$tenant_name&tenant_number=$tenant_number'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Details_Fullfilled_Demand(id: '${widget.id}',),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  String _number = '';
  String _name = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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

      body: Column(
        children: [
          Row(
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Owner Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                      controller: _Name,
                      decoration: InputDecoration(
                          hintText: "Owner Name",
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
                      child: Text('Owner Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                      controller: _Number,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Owner Number",
                          hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                          border: InputBorder.none),
                    ),
                  ),



                ],
              ),

            ],
          ),

          SizedBox(height: 20),

          GestureDetector(
            onTap: () async {
              fetchdata(_name, _number, " ", widget.id, _Name.text, _Number.text);
              //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_realestete(),), (route) => route.isFirst);
            },
            child: Center(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10)),
                    color: Colors.red.withOpacity(0.8)),
                child: Center(
                  child: Text(
                    "Submit",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.8,
                        fontSize: 18),
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
    });
  }
}
