import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Home_Screen_click/Real-Estate.dart';
import '../ui_decoration_tools/constant.dart';

class Catid {
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
  final String lift_Facility;
  final String bhkk;

  Catid(
      {required this.property_num,required this.Address_,required this.Place_,required this.sqft,
        required this.Price,required this.Sell_price,required this.Persnol_price,required this.maintenance,
        required this.Buy_Rent,required this.Residence_Commercial,required this.floor_,required this.flat_,
        required this.Furnished,required this.Details,required this.Ownername,required this.Owner_number,
        required this.Building_information,required this.balcony,required this.kitchen,required this.Baathroom,
        required this.Parking,required this.Typeofproperty,required this.Bhk_Squarefit,required this.Address_apnehisaabka,
        required this.Caretaker_name,required this.Caretaker_number,required this.lift_Facility, required this.bhkk});

  factory Catid.FromJson(Map<String, dynamic>json){
    return Catid(
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
      Caretaker_name: json['Water_geyser'], Caretaker_number: json['CareTaker_number'], lift_Facility: json['Lift'], bhkk: json['Bhk_Squarefit']);
  }
}

class Catid11 {
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

  Catid11(
      {required this.id,required this.property_num,required this.Address_,required this.Place_,required this.sqft,
        required this.Price,required this.Sell_price,required this.Persnol_price,required this.maintenance,
        required this.Buy_Rent,required this.Residence_Commercial,required this.floor_,required this.flat_,
        required this.Furnished,required this.Details,required this.Ownername,required this.Owner_number,
        required this.Building_information,required this.balcony,required this.kitchen,required this.Baathroom,
        required this.Parking,required this.Typeofproperty,required this.Bhk_Squarefit,required this.Address_apnehisaabka,
        required this.Caretaker_name,required this.Caretaker_number, required this.Building_Location, required this.Building_Name, required this.Building_Address, required this.Building_image, required this.Longitude, required this.Latitude, required this.Rent, required this.Verify_price, required this.BHK, required this.tyope, required this.maintence, required this.buy_Rent,
        required this.facility,required this.Feild_name,required this.Feild_number,required this.date});

  factory Catid11.FromJson(Map<String, dynamic>json){
    return Catid11(id: json['PVR_id'],
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


class Edit_Realestate_Secondpage extends StatefulWidget {
  @override
  _Edit_Realestate_SecondpageState createState() => _Edit_Realestate_SecondpageState();
}

class _Edit_Realestate_SecondpageState extends State<Edit_Realestate_Secondpage> {

  bool _isLoading = false;

  /*void _handleButtonClick() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate a network request or any async task
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });
  }*/

  File? _image;
  final TextEditingController _propertyNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _sqft = TextEditingController();
  final TextEditingController _price = TextEditingController();
  final TextEditingController _Sell_price = TextEditingController();
  final TextEditingController _Verify_Price = TextEditingController();
  final TextEditingController _maintenance = TextEditingController();
  final TextEditingController _flat = TextEditingController();
  final TextEditingController _furnished_details = TextEditingController();
  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();

  int _id = 0;

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _Adata();
  }

  void _Adata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final result_Owner = await fetchData();

    setState(() {
      _Ownername.text = result_Owner.first.Ownername;
      _Owner_number.text = result_Owner.first.Owner_number;
      _CareTaker_name.text = result_Owner.first.Caretaker_name;
      _CareTaker_number.text = result_Owner.first.Caretaker_number;
      _address.text = result_Owner.first.Address_;
      _Building_information.text = result_Owner.first.Building_information;
      _propertyNumber.text = result_Owner.first.property_num;
      _maintenance.text = result_Owner.first.maintenance;
      _Sell_price.text = result_Owner.first.Sell_price;
      _Verify_Price.text = result_Owner.first.Persnol_price;
      _price.text = result_Owner.first.Price;
      _sqft.text = result_Owner.first.sqft;
      _flat.text = result_Owner.first.flat_;
      _furnished_details.text = result_Owner.first.Details;
      _Address_apnehisaabka.text = result_Owner.first.Address_apnehisaabka;

      _selectedItem = result_Owner.first.Place_;
      _selectedItem1 = result_Owner.first.Buy_Rent;
      _typeofproperty = result_Owner.first.Typeofproperty;
      _bhk = result_Owner.first.bhkk;
      _floor1 = result_Owner.first.floor_;
      _Parking = result_Owner.first.Parking;
      _Balcony = result_Owner.first.balcony;
      _Kitchen = result_Owner.first.kitchen;
      _Bathroom = result_Owner.first.Baathroom;
      furnished = result_Owner.first.Furnished;





      //tempArray = result_Owner.first.lift_Facility as List<String>;
    });


  }



  Future<void> fetc2hdata(_propertyNumber,_address,_place,_sqft,_price,_Sell_price,_Verify_Price,_maintenance,_Buy_Rent,_Residentiol_Commercial,_floor, _flat,_furnished,_furnished_details,_Ownername,_Owner_number,_Building_information,_Balcony,_kitchen,_Bathroom,_Parking,_Typeofproperty,_BHK,_Address_apnehisaabka, _CareTaker_name,_CareTaker_number) async{
    final responce = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/Update_realstatedata?iddd=$_id&property_num=$_propertyNumber&Address_=$_address&Place_=$_place&sqft=$_sqft&Price=$_price&Sell_price=$_Sell_price&Persnol_price=$_Verify_Price&maintenance=$_maintenance&Buy_Rent=$_Buy_Rent&Residence_Commercial=$_Residentiol_Commercial&floor_=$_floor&flat_=$_flat&Furnished=$_furnished&Details=$_furnished_details&Ownername=$_Ownername&Owner_number=$_Owner_number&Building_information=$_Building_information&balcony=$_Balcony&kitchen=$_kitchen&Baathroom=$_Bathroom&Parking=$_Parking&Looking_Property_=Flat&Typeofproperty=$_Typeofproperty&Bhk_Squarefit=$_BHK&Address_apnehisaabka=$_Address_apnehisaabka&Caretaker_name=$_CareTaker_name&Caretaker_number=$_CareTaker_number'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      print('Failed Registration');
    }

  }

  Future<List<Catid>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=$_id");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }


  String? Place_,buyrent,resident_commercial,typeofproperty,bhk,furnished,District,policesttion,pincode,parking,balcony,kitchen,bathroom;



  get _RestorationId => null;

  // actuall image upload

  List<String> name = ['Lift','Security CareTaker','GOVT Meter','CCTV','Gas Meter','null'];

  List<String> tempArray = [];

  String? _selectedItem;
  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Manglapuri','Rajpur Khurd','Maidan Garhi','JonaPur','Dera Mandi','Gadaipur','Fatehpur Beri','Mehrauli','Sat Bari','Neb Sarai','Saket','null'];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent','null'];

  String? _floor1;
  final List<String> _items_floor1 = ['Ground Floor','First Floor','Second Floor','Third Floor','Forth Floor','Fifth Floor','Sixth Floor','Seventh Floor','Eighth Floor','Ninth Floor','Tenth Floor','G-Floor','1st Floor','2nd Floor','3rd Floor','4th Floor','5th Floor','null'];

  String? _selectedItem2;
  final List<String> _items2 = ['Residence','Commercial','null'];

  String? _typeofproperty;
  final List<String> __typeofproperty1 = ['Flat','Office','Shop','Farms','Godown','Plots','null'];

  String? _bhk;
  final List<String> _bhk1 = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial','null'];

  String? _Balcony;
  final List<String> _balcony_items = ['Front Side Balcony','Back Side Balcony','Window','No','null'];

  String? _Parking;
  final List<String> _Parking_items = ['Car/Bike','Only bike','No','Car','null'];

  String? _Kitchen;
  final List<String> _kitchen_items = ['Western Style','Indian Style','No','null'];

  String? _Bathroom;
  final List<String> _bathroom_items = ['Western Style','Indian Style','No','null'];

  Future<void> DeletePropertybyid(itemId) async {
    final url = Uri.parse('https://verifyserve.social/WebService4.asmx/Verify_Property_Verification_delete_by_id?PVR_id=$itemId');
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

  Future<List<Catid11>> fetchData22() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/Show_proprty_realstate_by_originalid?PVR_id=$_id");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Catid11.FromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }

  bool _isDeleting = false;
  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      _id = prefs.getInt('id_Building') ?? 0;
    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
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
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Place and Buy/Rent Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                      label: 'Place',
                      value: _selectedItem,
                      items: _items,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedItem = newValue;
                        });
                      }),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Buy / Rent',
                    value: _selectedItem1,
                    items: _items1,
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItem1 = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Owner Name and Number Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      label: 'Owner Name',
                      controller: _Ownername,
                      hint: 'Owner Name'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                      label: 'Owner Number',
                      controller: _Owner_number,
                      hint: 'Owner Number',
                      keyboardType: TextInputType.number),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Caretaker Name and Number Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      label: 'CareTaker Name',
                      controller: _CareTaker_name,
                      hint: 'Name'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                      label: 'CareTaker Number',
                      controller: _CareTaker_number,
                      hint: 'Number',
                      keyboardType: TextInputType.number),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Property Address
            _buildTextField(
              label: 'Property Name & Address',
              controller: _address,
              hint: 'Enter Property Name & Address',
            ),

            SizedBox(height: 20),

            // Building Information
            _buildTextField(
              label: 'Building Information & Facilities',
              controller: _Building_information,
              hint: 'Enter Building Information & Facilities',
            ),

            SizedBox(height: 20),

            // Property Type and BHK Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Type Of Property',
                    value: _typeofproperty,
                    items: __typeofproperty1,
                    onChanged: (newValue) {
                      setState(() {
                        _typeofproperty = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Select BHK',
                    value: _bhk,
                    items: _bhk1,
                    onChanged: (newValue) {
                      setState(() {
                        _bhk = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Rent Price and Maintenance Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      label: 'Rent price',
                      controller: _propertyNumber,
                      hint: 'Rent price'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                      label: 'Maintenance Cost',
                      controller: _maintenance,
                      hint: 'Maintenance Cost'),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Sell Price and Verify Price Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      label: 'Owner Sell price',
                      controller: _Sell_price,
                      hint: 'Owner Sell price'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                      label: 'Verify price',
                      controller: _Verify_Price,
                      hint: 'Verify price'),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Last Price and Square Feet Row
            Row(
              children: [
                Expanded(
                  child: _buildTextField(
                      label: 'Owner Last Price',
                      controller: _price,
                      hint: 'Owner Last Price'),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                      label: 'Square Feet',
                      controller: _sqft,
                      hint: 'Square Feet'),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Floor and Flat Number Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Select Floor',
                    value: _floor1,
                    items: _items_floor1,
                    onChanged: (newValue) {
                      setState(() {
                        _floor1 = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildTextField(
                      label: 'Flat Number',
                      controller: _flat,
                      hint: 'Flat Number'),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Parking and Balcony Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Parking',
                    value: _Parking,
                    items: _Parking_items,
                    onChanged: (newValue) {
                      setState(() {
                        _Parking = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Balcony',
                    value: _Balcony,
                    items: _balcony_items,
                    onChanged: (newValue) {
                      setState(() {
                        _Balcony = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Kitchen and Bathroom Row
            Row(
              children: [
                Expanded(
                  child: _buildDropdownField(
                    label: 'Kitchen',
                    value: _Kitchen,
                    items: _kitchen_items,
                    onChanged: (newValue) {
                      setState(() {
                        _Kitchen = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: _buildDropdownField(
                    label: 'Bathroom',
                    value: _Bathroom,
                    items: _bathroom_items,
                    onChanged: (newValue) {
                      setState(() {
                        _Bathroom = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Furnished Type
            _buildDropdownField(
              label: 'Furnished',
              value: furnished,
              items: ['Unfurnished', 'Semi-furnished', 'Fully-furnished'],
              onChanged: (newValue) {
                setState(() {
                  furnished = newValue;
                });
              },
            ),

            SizedBox(height: 20),

            // Furnished Details
            _buildTextField(
              label: 'Property Furnished Details',
              controller: _furnished_details,
              hint: 'Enter Property Furnished Details',
            ),

            SizedBox(height: 20),

            // Field Worker Address
            _buildTextField(
              label: 'Property Address For Field Worker',
              controller: _Address_apnehisaabka,
              hint: 'Enter Property Address For Field Worker',
            ),

            SizedBox(height: 30),

            // Submit Button with Gradient
            _buildGradientButton(
              text: "Submit",
              onPressed: () async {
                setState(() => _isLoading = true);
                final result_Owner = await fetchData();
                fetc2hdata(
                    _propertyNumber.text,
                    _address.text,
                    _selectedItem.toString(),
                    _sqft.text,
                    _price.text,
                    _Sell_price.text,
                    _Verify_Price.text,
                    _maintenance.text,
                    _selectedItem1.toString(),
                    result_Owner.first.Residence_Commercial.toString(),
                    _floor1.toString(),
                    _flat.text,
                    furnished.toString(),
                    _furnished_details.text,
                    _Ownername.text,
                    _Owner_number.text,
                    _Building_information.text,
                    _Balcony.toString(),
                    _Kitchen.toString(),
                    _Bathroom.toString(),
                    _Parking.toString(),
                    _typeofproperty.toString(),
                    _bhk.toString(),
                    _Address_apnehisaabka.text,
                    _CareTaker_name.text,
                    _CareTaker_number.text
                );
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => Show_Real_Estate()),
                        (route) => route.isFirst
                );
              },
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.grey.shade800,
              fontFamily: 'Poppins',
            ),
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontFamily: 'Poppins',
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
            fontFamily: 'Poppins',
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isDarkMode ? Colors.grey[800] : Colors.white,
          ),
          child: DropdownButton<String>(
            isExpanded: true,
            value: items.contains(value) ? value : null,
            hint: Text(
              'Select $label',
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? Colors.white : Colors.black87,
                fontFamily: 'Poppins',
              ),
            ),
            icon: Icon(Icons.arrow_drop_down, color: isDarkMode ? Colors.white : Colors.black87),
            iconSize: 24,
            dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
            underline: SizedBox(),
            onChanged: onChanged,
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black87,
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGradientButton({
    required String text,
    required VoidCallback onPressed,
    bool isLoading = false,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.blue[800]!, Colors.blue[600]!]
              : [Colors.blueAccent, Colors.lightBlueAccent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(isDarkMode ? 0.2 : 0.3),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: Colors.white,
          ),
        )
            : Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
            fontFamily: 'PoppinsBold',
          ),
        ),
      ),
    );
  }
}
