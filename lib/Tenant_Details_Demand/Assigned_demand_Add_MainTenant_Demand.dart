import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';
import 'package:intl/intl.dart';
import 'Show_TenantDemands.dart';

class Add_Assigned_TenantDemands extends StatefulWidget {
  String id;
  String name;
  String number;
  String buyrent;
  Add_Assigned_TenantDemands({super.key, required this.id, required this.name, required this.number, required this.buyrent});

  @override
  State<Add_Assigned_TenantDemands> createState() => _Add_Assigned_TenantDemandsState();
}

class _Add_Assigned_TenantDemandsState extends State<Add_Assigned_TenantDemands> {

  bool _isLoading = false;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _number = TextEditingController();
  final TextEditingController _floor = TextEditingController();
  final TextEditingController _budget = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Seifting_date = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _FamilyMembers = TextEditingController();




  String? _bhk;
  final List<String> _bhk1 = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial SP'];

  String? _buyrent;
  final List<String> _buyrent1 = ['Buy','Rent'];

  String? _selectedItem;
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Hauz Khas','Uttam Nagar East','Uttam Nagar West','Janak Puri East','Janak Puri West','Dwarka Mor'];

  String? _Parking;
  final List<String> _Parking_items = ['Car','Bike','No'];

  String _num = '';
  String _na = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();

    _name.text = widget.name;
    _number.text = widget.number;

  }

  DateTime now = DateTime.now();

  // Format the date as you like
  late String formattedDate;

  Future<void> fetchdata(Name,Number,BHK,Budget,Place,Floor_option,Family_Members,Additional_Info,Shifting_date,Parking,Gadi_Number,FeildWorker_Name,FeildWorker_Number,Current__Date,Buy_rent) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Tenant_Demands_insurt?V_name=$Name&V_number=$Number&bhk=$BHK&budget=$Budget&place=$Place&floor_option=$Floor_option&Family_Members=$Family_Members&Additional_Info=$Additional_Info&Shifting_date=$Shifting_date&Parking=$Parking&Gadi_Number=$Gadi_Number&FeildWorker_Name=$FeildWorker_Name&FeildWorker_Number=$FeildWorker_Number&Current__Date=$Current__Date&Buy_rent=$Buy_rent'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Tenant_demands(),), (route) => route.isFirst);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<void> Delete(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Delete_assign_tenant_demand_?id=$itemId');
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
    final size = MediaQuery.of(context).size;
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
        actions:  [
          GestureDetector(
            onTap: () {
              // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
            },
            child: const Icon(
              PhosphorIcons.image,
              color: Colors.white,
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

              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Select',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<String>(
                          value: _bhk,
                          hint: Text('Select BHK',style: TextStyle(color: Colors.white)),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          dropdownColor: Colors.grey.shade600,
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _bhk = newValue;
                            });
                          },
                          items: _bhk1.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style: TextStyle(color: Colors.white),),
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
                          child: Text('Budget',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _budget,
                          decoration: InputDecoration(
                              hintText: "Enter Budget",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                    ],
                  ),

                ],
              ),

              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Place',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<String>(
                          value: _selectedItem,
                          hint: Text('Place',style: TextStyle(color: Colors.white)),
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
                          padding: EdgeInsets.only(left: 5, top: 5),
                          child: Text('Floor Options',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                      SizedBox(height: 5,),

                      Container(
                        width: 130,
                        padding: const EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          // boxShadow: K.boxShadow,
                        ),
                        child: TextField(
                          style: TextStyle(color: Colors.black),
                          controller: _floor,
                          decoration: InputDecoration(
                              hintText: "Floor Options",
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
                  child: Text('Additional Information Tenant & Owner Want?',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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

              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        // boxShadow: K.boxShadow,
                      ),
                      child: TextField(style: TextStyle(color: Colors.black),
                        controller: _Seifting_date,
                        readOnly: true,
                        onTap: () async{
                          DateTime? pickedDate = await showDatePicker(
                              context: context, initialDate: DateTime.now(),
                              firstDate: DateTime(2010), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if(pickedDate != null ){
                            print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                            print(formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement
                            //yyyy-MM-dd
                            setState(() {
                              _Seifting_date.text = formattedDate; //set output date to TextField value.
                            });
                          }else{
                            print("Date is not selected");
                          }
                        },
                        decoration: InputDecoration(
                            hintText: "Enter Rent Date",
                            prefixIcon: Icon(
                              PhosphorIcons.calendar,
                              color: Colors.black54,
                            ),
                            hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                            border: InputBorder.none),
                      ),
                    ),
                  ),
                  SizedBox(width: 10,),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        color: Colors.pinkAccent.shade100
                    ),
                    child: IconButton(
                      onPressed: () async{
                        DateTime? pickedDate = await showDatePicker(
                            context: context, initialDate: DateTime.now(),
                            firstDate: DateTime(2010), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if(pickedDate != null ){
                          print(pickedDate);  //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
                          print(formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement
                          //yyyy-MM-dd
                          setState(() {
                            _Seifting_date.text = formattedDate; //set output date to TextField value.
                          });
                        }else{
                          print("Date is not selected");
                        }
                      },
                      icon: Icon(
                        PhosphorIcons.calendar,
                        color: Colors.black,
                      ),),
                  )
                ],
              ),

              SizedBox(height: 20),

              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('Select Buy Rent',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

              SizedBox(height: 10,),

              Row(
                children: [



                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: DropdownButton<String>(
                      value: _buyrent,
                      hint: Text('Select Buy Rent',style: TextStyle(color: Colors.white)),
                      icon: Icon(Icons.arrow_drop_down),
                      iconSize: 24,
                      dropdownColor: Colors.grey.shade600,
                      underline: SizedBox(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _buyrent = newValue;
                        });
                      },
                      items: _buyrent1.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value,style: TextStyle(color: Colors.white),),
                        );
                      }).toList(),
                    ),
                  ),

                  SizedBox(
                    width: 10,
                  ),

                  Column(
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Family Members',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          controller: _FamilyMembers,
                          decoration: InputDecoration(
                              hintText: "Family Members",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                        ),
                      ),

                    ],
                  ),

                ],
              ),



              SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Container(
                          padding: EdgeInsets.only(left: 5),
                          child: Text('Select Parking',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

                      SizedBox(height: 10,),

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButton<String>(
                          value: _Parking,
                          hint: Text('Select Parking',style: TextStyle(color: Colors.white)),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 24,
                          dropdownColor: Colors.grey.shade600,
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _Parking = newValue;
                            });
                          },
                          items: _Parking_items.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,style: TextStyle(color: Colors.white),),
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
                          child: Text('Vehicle Number',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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
                          style: TextStyle(color: Colors.black,fontSize: 22),
                          controller: _vehicleno,
                          decoration: InputDecoration(
                              hintText: "Vehicle No..",
                              hintStyle: TextStyle(color: Colors.grey,fontFamily: 'Poppins',),
                              border: InputBorder.none),
                          textCapitalization: TextCapitalization.characters,
                          inputFormatters: [
                            UpperCaseTextFormatter(),
                          ],
                        ),
                      ),

                    ],
                  ),

                ],
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



                  child: _isLoading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      : ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red
                    ),
                    onPressed: (){

                      formattedDate = "${now.year}-${now.month}-${now.day}";

                      //data = _email.toString();
                      fetchdata(_name.text, _number.text, _bhk.toString(), _budget.text, _selectedItem.toString(), _floor.text, _FamilyMembers.text, _Building_information.text, _Seifting_date.text, _Parking.toString(), _vehicleno.text, _na, _num, formattedDate,_buyrent.toString());

                      Delete(widget.id);

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
      _na = prefs.getString('name') ?? '';
      _num = prefs.getString('number') ?? '';
    });
  }



}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
