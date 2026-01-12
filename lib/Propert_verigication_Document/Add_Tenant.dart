import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';

import '../ui_decoration_tools/app_images.dart';
import 'Show_tenant.dart';

class TenantDetails extends StatefulWidget {
  const TenantDetails({super.key});

  @override
  State<TenantDetails> createState() => _TenantDetailsState();
}

class _TenantDetailsState extends State<TenantDetails> {



  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late SharedPreferences preferences;
  ValueNotifier<String>name=ValueNotifier("");
  ValueNotifier<String>email=ValueNotifier("");
  ValueNotifier<String>number=ValueNotifier("");

  @override
  void initState() {
    super.initState();
    init();
    _Tenant_Rented_Date.text = "";
    _loaduserdata();
  }

  init()async{
    preferences=await SharedPreferences.getInstance();
    name.value=preferences.getString("name")??'';
    email.value=preferences.getString("email")??'';
    number.value=preferences.getString("phone")??'';

  }
  String data1 = '';

  String _Property_Number = '';
  String _PropertyAddress = '';
  String _Looking_Prop_ = '';
  String _FLoorr = '';
  String _Flat = '';

  String _Owner_Name = '';
  String _Owner_Number = '';
  String _fieldworkarname = '';
  String _fieldworkarnumber = '';

  String _property_image = '';
  String _maintence = '';
  String _bhk_bhk = '';

  late String formattedDate;
  DateTime now = DateTime.now();

  //TextEditingController dateinput = TextEditingController();

  final TextEditingController _Tenant_Name = TextEditingController();
  final TextEditingController _Tenant_Rented_Amount = TextEditingController();
  final TextEditingController _Tenant_Rented_Date = TextEditingController();
  final TextEditingController _About_tenant = TextEditingController();
  final TextEditingController _Tenant_Number = TextEditingController();
  final TextEditingController _Tenant_Email = TextEditingController();
  final TextEditingController _Tenant_WorkProfile = TextEditingController();
  final TextEditingController _Tenant_Members = TextEditingController();

  Future<void> fetchdata(
      Tenant_Name,Tenant_Rented_Amount,Tenant_Rented_Date,Tenant_Number,Tenant_Email,Tenant_WorkProfile,Tenant_Members
      ) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/insert_Verify_AddTenant_Under_Property_Table?Property_Image=$_property_image&Property_Number=$_Property_Number&PropertyAddress=$_PropertyAddress&Looking_Prop_=$_Looking_Prop_&maintence=$_maintence&FLoorr=$_FLoorr&Flat=$_Flat&Tenant_Name=$Tenant_Name&Tenant_Rented_Amount=$Tenant_Rented_Amount&Tenant_Rented_Date=$Tenant_Rented_Date&bhk=$_bhk_bhk&Tenant_Number=$Tenant_Number&Tenant_Email=$Tenant_Email&Tenant_WorkProfile=$Tenant_WorkProfile&Tenant_Members=$Tenant_Members&Owner_Name=$_Owner_Name&Owner_Number=$_Owner_Number&Subid=$data1&fieldworkarname=$_fieldworkarname&fieldworkarnumber=$_fieldworkarnumber'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);

      fetchdata_update();

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/WebService4.asmx/insert_Verify_AddTenant_Under_Property_Table?Property_Image=$_property_image&Property_Number=$_Property_Number&PropertyAddress=$_PropertyAddress&Looking_Prop_=$_Looking_Prop_&maintence=$_maintence&FLoorr=$_FLoorr&Flat=$_Flat&Tenant_Name=$Tenant_Name&Tenant_Rented_Amount=$Tenant_Rented_Amount&Tenant_Rented_Date=$Tenant_Rented_Date&bhk=$_bhk_bhk&Tenant_Number=$Tenant_Number&Tenant_Email=$Tenant_Email&Tenant_WorkProfile=$Tenant_WorkProfile&Tenant_Members=$Tenant_Members&Owner_Name=$_Owner_Name&Owner_Number=$_Owner_Number&Subid=$data1&fieldworkarname=$_fieldworkarname&fieldworkarnumber=$_fieldworkarnumber",
          error: responce.body.toString(),
          statusCode: responce.statusCode ?? 0,
      );
      print('Failed Registration');
    }

  }

  //for target
  Future<void> fetchdata_target(owner_name,owner_number,tenant_name,tanant_number,property_address,rent_amount,building_id,feildworkar_name,feildworkar_number,random_text) async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/add_rent_property?owner_name=$owner_name&owner_number=$owner_number&tenant_name=$tenant_name&tanant_number=$tanant_number&property_address=$property_address&rent_amount=$rent_amount&building_id=$building_id&feildworkar_name=$feildworkar_name&feildworkar_number=$feildworkar_number&random_text=$random_text'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);
      print('ok');
      //fetchdata_update();

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/WebService4.asmx/add_rent_property?owner_name=$owner_name&owner_number=$owner_number&tenant_name=$tenant_name&tanant_number=$tanant_number&property_address=$property_address&rent_amount=$rent_amount&building_id=$building_id&feildworkar_name=$feildworkar_name&feildworkar_number=$feildworkar_number&random_text=$random_text",
        error: responce.body.toString(),
        statusCode: responce.statusCode ?? 0,
      );
      print('Failed Registration');
    }

  }

  Future<void> fetchdata_update() async{
    final responce = await http.get(Uri.parse
      ('https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=$data1&looking=Tenant_Added'));
    //final responce = await http.get(Uri.parse('https://verifyserve.social/WebService2.asmx/Add_Tenants_Documaintation?Tenant_Name=gjhgjg&Tenant_Rented_Amount=entamount&Tenant_Rented_Date=entdat&About_tenant=bout&Tenant_Number=enentnum&Tenant_Email=enentemail&Tenant_WorkProfile=nantwor&Tenant_Members=enentmember&Owner_Name=wnername&Owner_Number=umb&Owner_Email=emi&Subid=3'));

    if(responce.statusCode == 200){
      print(responce.body);

      //SharedPreferences prefs = await SharedPreferences.getInstance();

    } else {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/WebService4.asmx/Update_Book_Realestate_by_feildworker?idd=$data1&looking=Tenant_Added",
          error: responce.body.toString(),
          statusCode: responce.statusCode ?? 0,
      );
      print('Failed Registration');
    }

  }

  String? dropdownValue,dropdownValue_dob,dropdownValue_gender;

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      data1 = prefs.getString('id_Subid') ?? '';

      _Property_Number = prefs.getString('Property_Number') ?? '';
      _PropertyAddress = prefs.getString('PropertyAddress') ?? '';
      _Looking_Prop_ = prefs.getString('Looking_Prop_') ?? '';
      _FLoorr = prefs.getString('FLoorr') ?? '';
      _Flat = prefs.getString('Flat') ?? '';

      _Owner_Name = prefs.getString('Owner_Name') ?? '';
      _Owner_Number = prefs.getString('Owner_Number') ?? '';
      _fieldworkarname = prefs.getString('fieldworkarname') ?? '';
      _fieldworkarnumber = prefs.getString('fieldworkarnumber') ?? '';

      _property_image = prefs.getString('property_image') ?? '';
      _maintence = prefs.getString('maintence') ?? '';
      _bhk_bhk = prefs.getString('bhk_bhk') ?? '';
    });


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tenant Name
            _buildSectionTitle('Tenant Name'),
            _buildTextField(
              controller: _Tenant_Name,
              hintText: "Enter Tenant Name",
              icon: Icons.person_outline_rounded,
            ),

            // Tenant Number
            _buildSectionTitle('Tenant Number'),
            _buildTextField(
              controller: _Tenant_Number,
              hintText: "Enter Tenant Number",
              icon: PhosphorIcons.phone,
              keyboardType: TextInputType.phone,
            ),

            // Tenant Email
            _buildSectionTitle('Tenant Email'),
            _buildTextField(
              controller: _Tenant_Email,
              hintText: "Enter Tenant Email",
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
            ),

            // Rent Amount
            _buildSectionTitle('Rent Amount'),
            _buildTextField(
              controller: _Tenant_Rented_Amount,
              hintText: "Enter Rent Amount",
              icon: PhosphorIcons.currency_btc,
              keyboardType: TextInputType.number,
              prefixText: '₹ ',
            ),

            // Rent Date
            _buildSectionTitle('Rent Date'),
            _buildDatePickerField(),

            // Work Profile
            _buildSectionTitle('Tenant Work Profile'),
            _buildTextField(
              controller: _Tenant_WorkProfile,
              hintText: "Enter Work Profile",
              icon: Icons.work_outline_rounded,
            ),

            // Tenant Members
            _buildSectionTitle('Tenant Members'),
            _buildTextField(
              controller: _Tenant_Members,
              hintText: "Enter Number of Members",
              icon: Icons.people_alt_outlined,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 30),

            // Submit Button
            _buildSubmitButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 15, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "PoppinsBold",
          color: Theme.of(context).brightness==Brightness.dark ?Colors.white:Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? prefixText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness==Brightness.dark ?Colors.white10:Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        style:  TextStyle(
            fontFamily: "Poppins",
            color: Theme.of(context).brightness==Brightness.dark ?Colors.white:Colors.black87, fontSize: 15),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Theme.of(context).brightness==Brightness.dark ?Colors.white:Colors.grey[800],
          fontFamily: "Poppins"),
          prefixIcon: Icon(icon, color: Theme.of(context).brightness==Brightness.dark ?Colors.white:Colors.grey[600]),
          prefixText: prefixText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          filled: true,
          fillColor: Theme.of(context).brightness==Brightness.dark ?Colors.white10:Colors.white,
        ),
      ),
    );
  }

  Widget _buildDatePickerField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.white10 : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _Tenant_Rented_Date,
              style: TextStyle(
                color: isDark ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
              readOnly: true,
              onTap: _selectDate,
              decoration: InputDecoration(
                hintText: "Select Rent Date",
                hintStyle: TextStyle(color: isDark ? Colors.white : Colors.grey[800]),
                prefixIcon: Icon(PhosphorIcons.calendar, color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey[600]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                filled: true,
                fillColor: backgroundColor,
              ),
            ),
          ),
          IconButton(
            onPressed: _selectDate,
            icon: Icon(
              PhosphorIcons.calendar_blank,
              color: Theme.of(context).brightness==Brightness.dark?Colors.lightBlueAccent:Colors.blue[700],
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).brightness == Brightness.dark
                ? const ColorScheme.dark(
              primary: Colors.blue,       // Header background
              onPrimary: Colors.white,    // Header text
              surface: Color(0xFF121212), // Dialog background
              onSurface: Colors.white,    // Body text
            )
                : const ColorScheme.light(
              primary: Colors.blue,       // Header background
              onPrimary: Colors.white,    // Header text
              onSurface: Colors.black,    // Body text
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _Tenant_Rented_Date.text = DateFormat('dd MMM yyyy').format(pickedDate);
      });
    }
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          formattedDate = "${now.month}/${now.year}";
          // Process form data
          // fetchdata(_Tenant_Name.text, _Tenant_Rented_Amount.text,
          //   _Tenant_Rented_Date.text, _Tenant_Number.text,
          //   _Tenant_Email.text, _Tenant_WorkProfile.text,
          //   _Tenant_Members.text);
          // fetchdata_target(_Owner_Name.toString(), _Owner_Number.toString(),
          //   _Tenant_Name.text, _Tenant_Number.text,
          //   _PropertyAddress.toString(), _Tenant_Rented_Amount.text,
          //   data1.toString(), _fieldworkarname.toString(),
          //   _fieldworkarnumber.toString(), formattedDate.toString());

          // Navigate after submission
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const ShowProperty()),
                (route) => route.isFirst,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: const Text(
          'SUBMIT DETAILS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
