import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Custom_Widget/constant.dart';
import '../Administater_Parent_TenantDemand.dart';
import 'Show_Unexpected_Demand.dart';

class Edit_Optionin_Demand extends StatefulWidget {
  String id;
  String name;
  String number;
  String info;
  String buy;
  String referenc;
  Edit_Optionin_Demand({super.key, required this.id,required this.name, required this.number, required this.info, required this.buy, required this.referenc});

  @override
  State<Edit_Optionin_Demand> createState() => _Edit_Optionin_DemandState();
}

class _Edit_Optionin_DemandState extends State<Edit_Optionin_Demand> {

  String _numberSherar = '';
  String _nameSherar = '';

  bool _isLoading = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _Refrence = TextEditingController();

  String? _selectedItem;
  final List<String> _items = ['Buy','Rent','Lease','null'];

  String _location = '';

  Future<void> fetchdata(id,Name,Number,buyrent,Additional_Info) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/update_assign_tanant_demand_2nd_table?id=$id&demand_name=$Name&demand_number=$Number&buy_rent=$buyrent&add_info=$Additional_Info'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Administater_parent_TenandDemand(),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration${responce.statusCode}');
    }

  }

  @override
  void initState() {
    super.initState();
    _loaduserdata();

    _name.text = widget.name;
    _number.text = widget.number;
    _Building_information.text = widget.info;
    _selectedItem = widget.buy;
    _Refrence.text = widget.referenc;

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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              Row(
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Name',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _name,
                          decoration: InputDecoration(
                              hintText: "Name",
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
                          padding: EdgeInsets.only(left: 5, top: 20),
                          child: Text('Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _number,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: "Number",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                    ],
                  ),

                ],
              ),

              SizedBox(height: 20,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: Text('Select Buy/Rent',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                  SizedBox(height: 10,),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      value: _selectedItem,
                      hint: Text('Select Buy/Rent',style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      dropdownColor: Colors.grey.shade600,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedItem = newValue;
                          print(_selectedItem);
                        });
                      },
                      items: _items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(color: Colors.white)),
                        );
                      }).toList(),
                    ),
                  ),
                  /*SizedBox(height: 20),
                          Text(
                            _selectedItem != null ? 'Selected: $_selectedItem' : 'No item selected',
                            style: TextStyle(fontSize: 16),
                          ),*/
                ],
              ),

              SizedBox(height: 20,),

              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('Additional Information',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

              SizedBox(height: 5,),

              Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  // boxShadow: K.boxShadow,
                ),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _Building_information,
                  decoration: InputDecoration(
                      hintText: "Additional Information Tenant & Owner Want?",
                      prefixIcon: Icon(
                        Icons.circle,
                        color: Colors.black54,
                      ),
                      hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                      border: InputBorder.none),
                ),
              ),

              SizedBox(height: 20),





              Center(
                child: Container(
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
                    onPressed: (){
                      fetchdata('${widget.id}',_name.text, _number.text, _selectedItem.toString(), _Building_information.text);
                      //Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tenant_demands(),), (route) => route.isFirst);


                    }, child: Text("Submit", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, ),
                  ),
                  ),

                ),
              ),



            ],
          ),
        ),
      ),

    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameSherar = prefs.getString('FW_Name') ?? '';
      _numberSherar = prefs.getString('FW_Number') ?? '';
      _location = prefs.getString('location') ?? '';
    });
  }

}
