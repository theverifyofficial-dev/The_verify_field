import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Document/Owner_Document.dart';
import '../Document/Tenant_Document.dart';
import '../Pending_Document/Pending_Document.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Tenant_Details.dart';

class Catid_pp {
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

  Catid_pp(
      {required this.id,required this.property_num,required this.Address_,required this.Place_,required this.sqft,
        required this.Price,required this.Sell_price,required this.Persnol_price,required this.maintenance,
        required this.Buy_Rent,required this.Residence_Commercial,required this.floor_,required this.flat_,
        required this.Furnished,required this.Details,required this.Ownername,required this.Owner_number,
        required this.Building_information,required this.balcony,required this.kitchen,required this.Baathroom,
        required this.Parking,required this.Typeofproperty,required this.Bhk_Squarefit,required this.Address_apnehisaabka,
        required this.Caretaker_name,required this.Caretaker_number, required this.Building_Location, required this.Building_Name, required this.Building_Address, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.tyope, required this.maintence, required this.buy_Rent,
        required this.facility,required this.Feild_name,required this.Feild_number,required this.date});

  factory Catid_pp.FromJson(Map<String, dynamic>json){
    return Catid_pp(id: json['PVR_id'],
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

class Realestate {
  final String tananted_address;
  final String tananted_address_district;
  final String tananted_address_police_station;
  final String tananted_address_pincode;
  final String tananted_place;


  Realestate(
      {required this.tananted_address, required this.tananted_address_district, required this.tananted_address_police_station,
        required this.tananted_address_pincode, required this.tananted_place});

  factory Realestate.FromJson(Map<String, dynamic>json){
    return Realestate(tananted_address: json['Address_'],
        tananted_address_district: json['District'],
        tananted_address_police_station: json['Police_Station'],
        tananted_address_pincode: json['Pin_Code'],
        tananted_place: json['Place_']);
  }
}

class detailModel {
  final int id;
  final String Name_;
  final String Number;
  final String Father_name;
  final String Occupation;
  final String Date_of_birth;
  final String Permanent_address;
  final String District;
  final String Pin_code;
  final String Police_station;
  final String Place;

  detailModel(
      {required this.id,required this.Name_,required this.Number,required this.Father_name,required this.Occupation,
        required this.Date_of_birth, required this.Permanent_address,required this.District,required this.Pin_code,
        required this.Police_station,required this.Place});

  factory detailModel.FromJson(Map<String, dynamic>json){
    return detailModel(id: json['id'],
        Name_: json['Name_'],
        Number: json['Number'],
        Father_name: json['Father_name'],
        Occupation: json['Occupation'],
        Date_of_birth: json['Date_of_birth'],
        Permanent_address: json['Permanent_address'],
        District: json['District'],
        Pin_code: json['Pin_code'],
        Police_station: json['Police_station'],
        Place: json['Place']);
  }
}

class Catid_Tenant {
  final int id;
  final String Name_;
  final String Number;
  final String Father_name;
  final String Occupation;
  final String Date_of_birth;
  final String Permanent_address;
  final String District;
  final String Pin_code;
  final String Police_station;
  final String Place;

  Catid_Tenant(
      {required this.id,required this.Name_,required this.Number,required this.Father_name,required this.Occupation,
        required this.Date_of_birth, required this.Permanent_address,required this.District,required this.Pin_code,
        required this.Police_station,required this.Place});

  factory Catid_Tenant.FromJson(Map<String, dynamic>json){
    return Catid_Tenant(id: json['id'],
        Name_: json['Name_'],
        Number: json['Number'],
        Father_name: json['Father_name'],
        Occupation: json['Occupation'],
        Date_of_birth: json['Date_of_birth'],
        Permanent_address: json['Permanent_address'],
        District: json['District'],
        Pin_code: json['Pin_code'],
        Police_station: json['Police_station'],
        Place: json['Place']);
  }
}

class Owner_details extends StatefulWidget {
  final String iid;
  const Owner_details({super.key, required this.iid});

  @override
  State<Owner_details> createState() => _Owner_detailsState();
}

class _Owner_detailsState extends State<Owner_details> {

  String _id = '';

  bool _isLoading = false;

  Future<List<detailModel>> fetchData() async{
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/show_store_document_by_number_?number=${_number_Owner.toString()}");
    final responce=await http.get(url);
    if(responce.statusCode==200){
      List listresponce=json.decode(responce.body);
      return listresponce.map((data) => detailModel.FromJson(data)).toList();
    }
    else{
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Catid_Tenant>> fetchData_Tenant() async{
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/show_store_document_by_number_?number=${_number_Tenant.toString()}");
    final responce=await http.get(url);
    if(responce.statusCode==200){
      List listresponce=json.decode(responce.body);
      return listresponce.map((data) => Catid_Tenant.FromJson(data)).toList();
    }
    else{
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Realestate>> _demoji() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=${widget.iid}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Realestate.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  Future<List<Realestate>> Tenanted_Property_Details(id) async{
    var url=Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=${widget.iid}");
    final responce=await http.get(url);
    if(responce.statusCode==200){

      List listresponce=json.decode(responce.body);
      return listresponce.map((data) => Realestate.FromJson(data)).toList();
    }
    else{
      throw Exception('Unexpected error occured!');
    }
  }

  Future<void> Insurt_Document(ownername,ownernumber,tanantname,tanantnumber,floor_number_tanant,flat_number_tanant,rent_amount_tanat,owner_fathername,tanant_fathername,owner_occupation,tanant_occupation,owner_dateofbirth,tanant_dateofbirth,owner_permanant_address,tanant_permanant_address,owner_district,tanant_district,owner_permanant_address_police_station,tanant_permanant_address_police_station,owner_permanant_address_pincode,tanant_permanant_address_pincode,owner_place,tanant_place,tananted_address,tananted_address_district,tananted_address_police_station,tananted_address_pincode,tananted_place,current_date_,owner_document_id,tanant_document_id,document_type,amount) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/add_police_verification_and_rent_document_?ownername=$ownername&ownernumber=$ownernumber&tanantname=$tanantname&tanantnumber=$tanantnumber&floor_number_tanant=$floor_number_tanant&flat_number_tanant=$flat_number_tanant&rent_amount_tanat=$rent_amount_tanat&owner_fathername=$owner_fathername&tanant_fathername=$tanant_fathername&owner_occupation=$owner_occupation&tanant_occupation=$tanant_occupation&owner_dateofbirth=$owner_dateofbirth&tanant_dateofbirth=$tanant_dateofbirth&owner_permanant_address=$owner_permanant_address&tanant_permanant_address=$tanant_permanant_address&owner_district=$owner_district&tanant_district=$tanant_district&owner_permanant_address_police_station=$owner_permanant_address_police_station&tanant_permanant_address_police_station=$tanant_permanant_address_police_station&owner_permanant_address_pincode=$owner_permanant_address_pincode&tanant_permanant_address_pincode=$tanant_permanant_address_pincode&owner_place=$owner_place&tanant_place=$tanant_place&tananted_address=$tananted_address&tananted_address_district=$tananted_address_district&tananted_address_police_station=$tananted_address_police_station&tananted_address_pincode=$tananted_address_pincode&tananted_place=$tananted_place&current_date_=$current_date_&owner_document_id=$owner_document_id&tanant_document_id=$tanant_document_id&document_type=$document_type&building_subid=$_Subid&looking_type=Payment Pending&amount=$amount'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Pending_Document(),), (route) => route.isFirst);

      Fluttertoast.showToast(
          msg: "Request Upload successful",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0
      );
      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration = ${responce.statusCode}');
    }

  }

  int _Subid = 0;
  String _number_Owner = '';
  String _number_Tenant = '';

  String _Floorr = '';
  String _Flat = '';
  String _Rented_Amount = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _loaduser();
  }

  DateTime now = DateTime.now();

  // Format the date as you like
  late String formattedDate;


  List<String> name = ['Police Verification','Rent Agreement'];

  List<String> tempArray = [];

  String _currentImage = 'assets/images/box.webp';

  void _changeImage(String image) {
    setState(() {
      _currentImage = image;
    });
  }

  String _currentImage_tenant = 'assets/images/box.webp';

  void _changeImage_tenant(String image) {
    setState(() {
      _currentImage_tenant = image;
    });
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
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                width: size.width,
                padding: EdgeInsets.only(left: 10,right: 10,top: 5,bottom: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.red.withOpacity(0.8)),
                ),
                margin: const EdgeInsets.only(left: 0, right: 0),
                child: Text('Please Click to Verify Document for Verification.', style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'Poppins',letterSpacing: 0.5 ),textAlign: TextAlign.start),
              ),

              Container(
                margin: EdgeInsets.all(0),
                child: GestureDetector(
                  onTap: () async {

                    final responce = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/show_store_count_document?number=${_number_Owner.toString()}"));

                    print(responce.body);

                    if (responce.body == '[{"logg":1}]') {

                      _changeImage('assets/images/green_tick.png');

                      Fluttertoast.showToast(
                          msg: "Owner Document Find Successfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      // Successful login
                      print("Login successful");
                    } else {
                      // Failed login

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Owner_Document()));

                    }


                  },
                  child: Card(
                    color: Colors.white12,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  _currentImage,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 35, bottom: 40, left: 20),
                              child: Text("Owner Document Verify",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              Container(
                margin: EdgeInsets.all(0),
                child: GestureDetector(
                  onTap: () async {

                    final responce = await http.get(Uri.parse("https://verifyserve.social/WebService4.asmx/show_store_count_document?number=${_number_Tenant.toString()}"));

                    print(responce.body);

                    if (responce.body == '[{"logg":1}]') {

                      _changeImage_tenant('assets/images/green_tick.png');

                      Fluttertoast.showToast(
                          msg: "tenant Document Find Successfully",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                      // Successful login
                      print("Login successful");
                    } else {
                      // Failed login

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Tenant_Document()));

                    }


                  },
                  child: Card(
                    color: Colors.white12,
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: 80,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.asset(
                                  _currentImage_tenant,
                                  fit: BoxFit.cover,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(top: 35, bottom: 40, left: 20),
                              child: Text("Tenant Document Verify",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                  padding: EdgeInsets.only(left: 5),
                  child: Text('Add Your Documents',style: TextStyle(fontSize: 16,color: Colors.grey[500],fontFamily: 'Poppins'),)),

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

                        print(tempArray.toString());

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

              Column(
                children: [
                  if (tempArray.toString() == "[Police Verification, Rent Agreement]") Text("Rs 598".toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5
                    ),
                  ),

                  if (tempArray.toString() == "[Rent Agreement, Police Verification]") Text("Rs 598".toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5
                    ),
                  ),

                  if (tempArray.toString() == "[Rent Agreement]") Text("Rs 299".toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5
                    ),
                  ),
                  if (tempArray.toString() == "[Police Verification]") Text("Rs 299".toUpperCase(),
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5
                    ),
                  ),

                ],
              ),


              SizedBox(height: 20),
              GestureDetector(
                onTap: () async {
                  //_uploadData();

                  fetchData();
                  fetchData_Tenant();
                  _demoji();

                  final result_Owner = await fetchData();


                  final result_Tenant = await fetchData_Tenant();


                  final demo = await _demoji();


                  formattedDate = "${now.day}-${now.month}-${now.year}";

                  if (tempArray.toString() == "[Police Verification, Rent Agreement]"){

                    Insurt_Document(result_Owner.first.Name_.toString(), result_Owner.first.Number.toString(), result_Tenant.first.Name_.toString(), result_Tenant.first.Number.toString(),
                        _Floorr.toString(), _Flat.toString(), _Rented_Amount.toString(), result_Owner.first.Father_name.toString(), result_Tenant.first.Father_name.toString(),
                        result_Owner.first.Occupation.toString(), result_Tenant.first.Occupation.toString(), result_Owner.first.Date_of_birth.toString(),
                        result_Tenant.first.Date_of_birth.toString(), result_Owner.first.Permanent_address.toString(), result_Tenant.first.Permanent_address.toString(),
                        result_Owner.first.District.toString(), result_Tenant.first.District.toString(), result_Owner.first.Police_station.toString(), result_Tenant.first.Police_station.toString(),
                        result_Owner.first.Pin_code.toString(), result_Tenant.first.Pin_code.toString(), result_Owner.first.Place.toString(), result_Tenant.first.Place.toString(),
                        demo.first.tananted_address.toString(), demo.first.tananted_address_district.toString(),
                        demo.first.tananted_address_police_station.toString(), demo.first.tananted_address_pincode.toString(),
                        demo.first.tananted_place.toString(), formattedDate, result_Owner.first.id, result_Tenant.first.id, tempArray.toString(), "Rs 598");

                  }else if (tempArray.toString() == "[Rent Agreement, Police Verification]"){

                    Insurt_Document(result_Owner.first.Name_.toString(), result_Owner.first.Number.toString(), result_Tenant.first.Name_.toString(), result_Tenant.first.Number.toString(),
                        _Floorr.toString(), _Flat.toString(), _Rented_Amount.toString(), result_Owner.first.Father_name.toString(), result_Tenant.first.Father_name.toString(),
                        result_Owner.first.Occupation.toString(), result_Tenant.first.Occupation.toString(), result_Owner.first.Date_of_birth.toString(),
                        result_Tenant.first.Date_of_birth.toString(), result_Owner.first.Permanent_address.toString(), result_Tenant.first.Permanent_address.toString(),
                        result_Owner.first.District.toString(), result_Tenant.first.District.toString(), result_Owner.first.Police_station.toString(), result_Tenant.first.Police_station.toString(),
                        result_Owner.first.Pin_code.toString(), result_Tenant.first.Pin_code.toString(), result_Owner.first.Place.toString(), result_Tenant.first.Place.toString(),
                        demo.first.tananted_address.toString(), demo.first.tananted_address_district.toString(),
                        demo.first.tananted_address_police_station.toString(), demo.first.tananted_address_pincode.toString(),
                        demo.first.tananted_place.toString(), formattedDate, result_Owner.first.id, result_Tenant.first.id, tempArray.toString(), "Rs 598");

                  } else if (tempArray.toString() == "[Rent Agreement]"){

                    Insurt_Document(result_Owner.first.Name_.toString(), result_Owner.first.Number.toString(), result_Tenant.first.Name_.toString(), result_Tenant.first.Number.toString(),
                        _Floorr.toString(), _Flat.toString(), _Rented_Amount.toString(), result_Owner.first.Father_name.toString(), result_Tenant.first.Father_name.toString(),
                        result_Owner.first.Occupation.toString(), result_Tenant.first.Occupation.toString(), result_Owner.first.Date_of_birth.toString(),
                        result_Tenant.first.Date_of_birth.toString(), result_Owner.first.Permanent_address.toString(), result_Tenant.first.Permanent_address.toString(),
                        result_Owner.first.District.toString(), result_Tenant.first.District.toString(), result_Owner.first.Police_station.toString(), result_Tenant.first.Police_station.toString(),
                        result_Owner.first.Pin_code.toString(), result_Tenant.first.Pin_code.toString(), result_Owner.first.Place.toString(), result_Tenant.first.Place.toString(),
                        demo.first.tananted_address.toString(), demo.first.tananted_address_district.toString(),
                        demo.first.tananted_address_police_station.toString(), demo.first.tananted_address_pincode.toString(),
                        demo.first.tananted_place.toString(), formattedDate, result_Owner.first.id, result_Tenant.first.id, tempArray.toString(), "Rs 299");

                  } else if (tempArray.toString() == "[Police Verification]"){

                    Insurt_Document(result_Owner.first.Name_.toString(), result_Owner.first.Number.toString(), result_Tenant.first.Name_.toString(), result_Tenant.first.Number.toString(),
                        _Floorr.toString(), _Flat.toString(), _Rented_Amount.toString(), result_Owner.first.Father_name.toString(), result_Tenant.first.Father_name.toString(),
                        result_Owner.first.Occupation.toString(), result_Tenant.first.Occupation.toString(), result_Owner.first.Date_of_birth.toString(),
                        result_Tenant.first.Date_of_birth.toString(), result_Owner.first.Permanent_address.toString(), result_Tenant.first.Permanent_address.toString(),
                        result_Owner.first.District.toString(), result_Tenant.first.District.toString(), result_Owner.first.Police_station.toString(), result_Tenant.first.Police_station.toString(),
                        result_Owner.first.Pin_code.toString(), result_Tenant.first.Pin_code.toString(), result_Owner.first.Place.toString(), result_Tenant.first.Place.toString(),
                        demo.first.tananted_address.toString(), demo.first.tananted_address_district.toString(),
                        demo.first.tananted_address_police_station.toString(), demo.first.tananted_address_pincode.toString(),
                        demo.first.tananted_place.toString(), formattedDate, result_Owner.first.id, result_Tenant.first.id, tempArray.toString(), "Rs 299");

                  }



                  Fluttertoast.showToast(
                      msg: "${widget.iid}",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.grey,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                },
                child: Center(
                  child: Container(
                    height: 50,
                    width: 200,
                    // margin: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10)),
                        color: Colors.red.withOpacity(0.8)),
                    child: _isLoading
                        ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    )
                        : const Center(
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
        ),
      ),

    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _Subid = prefs.getInt('B_Sibid_') ?? 0;
      _number_Owner = prefs.getString('Owner_Number_For_PoliceVerification') ?? '';
      _number_Tenant = prefs.getString('Tenant_Number_For_PoliceVerification') ?? '';

      _Floorr = prefs.getString('FLoorr_For_PoliceVerification') ?? '';
      _Flat = prefs.getString('Flat_PoliceVerification') ?? '';
      _Rented_Amount = prefs.getString('Tenant_Rented_Amount_PoliceVerification') ?? '';
    });
  }

  void _loaduser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getString('Building_Sibid_') ?? '';
    });


  }

}
