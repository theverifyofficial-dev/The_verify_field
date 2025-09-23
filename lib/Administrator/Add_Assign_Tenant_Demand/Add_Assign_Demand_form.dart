import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
import '../Administater_Parent_TenantDemand.dart';

class assign_demand_form extends StatefulWidget {
  String A_num;
  assign_demand_form({required this.A_num, super.key});

  @override
  State<assign_demand_form> createState() => _assign_demand_formState();
}

class _assign_demand_formState extends State<assign_demand_form> {

  String _numberSherar = '';
  String _nameSherar = '';

  bool _isLoading = false;

  List<String> name = ['1 RK','1 BHK','2 BHK','3 BHK','COMMERCIAL','PLOT'];

  List<String> tempArray = [];

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _Refrence = TextEditingController();
  //final TextEditingController _bhkkkkkkkkk = TextEditingController();

  String? _selectedItem;
  final List<String> _items = ['Buy','Rent'];

  String _location = '';

  String _date = '';
  String _Time = '';

  void _generateDateTime() {
    setState(() {
      _Time = DateFormat('d-MMMM-yyyy').format(DateTime.now());
      _date = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  Future<void> fetchdata(FN,FNO,Name,Number,buyrent,Additional_Info,refrence,bhk) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/add_assign_tanant_demand_2nd_table?fieldworkar_name=$FN&fieldworkar_number=$FNO&demand_name=$Name&demand_number=$Number&buy_rent=$buyrent&add_info=$Additional_Info&location_=$_location&reference=$refrence&feedback=Pending&looking_type=Blank&bhk=$bhk'));
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

    _number.text = widget.A_num;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
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

              Row(
                children: [

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

                  SizedBox(
                    width: 10,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Reference',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                      SizedBox(height: 5,),

                      Container(
                        width: 150,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: K.boxShadow,
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _Refrence,
                          decoration: InputDecoration(
                              hintText: "Reference",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                    ],
                  ),

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
                      hintText: "Price",
                      prefixIcon: Icon(
                        Icons.circle,
                        color: Colors.black54,
                      ),
                      hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                      border: InputBorder.none),
                ),
              ),

              SizedBox(height: 20,),

              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('BHK',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

              SizedBox(height: 5,),


              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: name.length,
                  itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        setState(() {
                          if(tempArray.contains(name[index].toString())){
                            tempArray.remove(name[index].toString());
                          }else{
                            tempArray.add(name[index].toString());
                          }
                        });

                        print(tempArray.join(', '));

                      },
                      child: Card(
                        child: ListTile(
                          title: Text(name[index].toString()),
                          trailing: Container(
                            height: 40,
                            width: 100,
                            decoration: BoxDecoration(
                                color: tempArray.contains(name[index].toString()) ? Colors.red : Colors.green,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Center(
                              child: Text(tempArray.contains(name[index].toString()) ? 'Remove' : 'Add'),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),

              /*Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('BHK',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                  controller: _BHK,
                  decoration: InputDecoration(
                      hintText: "Add BHK",
                      prefixIcon: Icon(
                        Icons.circle,
                        color: Colors.black54,
                      ),
                      hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                      border: InputBorder.none),
                ),
              ),

              SizedBox(height: 20),*/

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

                      _generateDateTime();

                      fetchdata(_date,_Time,_name.text, _number.text, _selectedItem.toString(), _Building_information.text, _Refrence.text, tempArray.join(', '));
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
      _nameSherar = prefs.getString('name') ?? '';
      _numberSherar = prefs.getString('number') ?? '';
      _location = prefs.getString('location') ?? '';
    });
  }
}
