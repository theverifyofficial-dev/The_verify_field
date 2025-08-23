import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui_decoration_tools/constant.dart';

class motot_insurance_front extends StatefulWidget {
  const motot_insurance_front({super.key});

  @override
  State<motot_insurance_front> createState() => _motot_insurance_frontState();
}

class _motot_insurance_frontState extends State<motot_insurance_front> {

  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();

  bool _isLoading = false;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late SharedPreferences preferences;
  ValueNotifier<String>id = ValueNotifier("");

  String? Vehicle_no;

  @override
  void initState() {
    super.initState();
    init();
    //fetchdata(Vehicle_no,id);
  }

  init() async {
    preferences = await SharedPreferences.getInstance();
    id.value = preferences.getString("id") ?? '';
    print(selectedVehicleTypes);
  }

  TextEditingController addvehiclecontroller = TextEditingController();
  final _vehicleNumberStreamController = StreamController<bool>.broadcast();

  int selectedVehicleType = 0;
  String selectedVehicleTypes = "Two Wheeler";

  //bool _validate = false;

  //bool _isValid = false;

  Widget CustomVehicleTypeButton(String assetImage, String typeName,
      String defaults, int index) {
    return OutlinedButton(
      onPressed: () {
        setState(() {
          selectedVehicleType = index;
          selectedVehicleTypes = typeName;
          print(selectedVehicleTypes);
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        side: BorderSide(
            width: (selectedVehicleType == index) ? 2.0 : 0.5,
            color: (selectedVehicleType == index)
                ? Colors.green
                : Colors.blue.shade600),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              children: [
                Image.asset(
                  assetImage,
                  fit: BoxFit.contain,
                  width: 60,
                  height: 80,
                ),
                Text(typeName, style: TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    letterSpacing: 0),),
                Text(defaults, style: TextStyle(fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                    fontFamily: 'Poppins',
                    letterSpacing: 0),),
              ],
            ),
          ),
          if (selectedVehicleType == index)
            Positioned(
              top: 5,
              right: 5,
              child: Image.asset(
                "assets/images/tick.png",
                width: 25,
                fit: BoxFit.cover,
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    addvehiclecontroller.dispose();
    _vehicleNumberStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 55),
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

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SizedBox(height: 20,),
                //  Text('Add Vehicle Number',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500,color: Colors.white,fontFamily: 'Poppins',letterSpacing: 0),),
                SizedBox(height: 20,),
                Text('Please, Select your vehicle type.', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.pinkAccent.shade200,
                    fontFamily: 'Poppins',
                    letterSpacing: 0),),
                SizedBox(height: 5,),
                Text('(Default type is selected)', style: TextStyle(fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                    fontFamily: 'Poppins',
                    letterSpacing: 0),),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: CustomVehicleTypeButton(
                              "assets/images/car.png", 'Four Wheeler',
                              '(Default)', 0),
                        )),
                    Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 3, right: 3),
                          child: CustomVehicleTypeButton(
                              "assets/images/bike.png", 'Two Wheeler', '', 1),
                        )),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(left: 3, right: 3),
                      child: CustomVehicleTypeButton(
                          "assets/images/truckkkkk.png", 'Other', '', 2),
                    )),
                  ],
                ),
                SizedBox(height: 15,),
                Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    // boxShadow: K.boxShadow,
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    onTapOutside: (event) => FocusScope.of(context).unfocus(),
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(10)
                      //FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      // FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                    ],
                    /*validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vehicle number is required';
                      }
                      // Use a regular expression for vehicle number validation
                      String pattern = r'^[A-Z]{2}\d{2}[A-Z]{2}\d{4}$';
                      RegExp regex = RegExp(pattern);
                      if (!regex.hasMatch(value)) {
                        return 'Enter a valid vehicle number';
                      }
                      return null;
                    },*/
                    /*onChanged: (value) {
                      // You can perform validation here and update the stream accordingly
                      // For simplicity, let's consider a basic validation using a regular expression
                      String pattern = r'^[A-Z]{2}\d{2}[A-Z]{2}\d{4}$';
                      RegExp regex = RegExp(pattern);
                      bool isValid = regex.hasMatch(value);
                      _vehicleNumberStreamController.add(isValid);
                    },*/
                    controller: addvehiclecontroller,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsetsDirectional.all(12),
                        hintText: "Type Vehicle Number..",
                        // errorText: _validate ? "Field Can't Be Empty" : null,
                        suffixIcon: IconButton(
                          onPressed: addvehiclecontroller.clear,
                          icon: Icon(PhosphorIcons.x_circle, size: 20,),
                        ),
                        prefixIcon: Icon(
                          PhosphorIcons.car,
                          color: Colors.black54,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey, fontFamily: 'Poppins',),
                        border: InputBorder.none),
                  ),
                ),
                SizedBox(height: 20),

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
                            controller: _Ownername,
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
                            controller: _Owner_number,
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
                    setState(() {
                      _isLoading = true;
                    });
                    // _handleUpload();
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PdfViewScreen(pdfPath: 'https://www.youtube.com/watch?v=slfKt85aIOk',),
                      ),
                    );*/

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
                          "Check",
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

                //SizedBox(height: 50,),



              ],
            ),
          ),
        ),
      ),



      bottomNavigationBar: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 8, right: 0,bottom: 10),
            padding: EdgeInsets.only(
                left: 5, right: 5, bottom: 10,top: 10),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    blurStyle: BlurStyle.outer
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Iconsax.sort_copy, size: 20,
                    color: Colors.redAccent,
                    weight: 10),
                SizedBox(width: 4,),
                Text(
                  "Show Added All Vehicle",maxLines: 2 ,
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 6), // Space between buttons
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 0, right: 8,bottom: 10),
            padding: EdgeInsets.only(
                left: 5, right: 5, bottom: 10,top: 10   ),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(width: 1, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    color: Colors.white.withOpacity(0.5),
                    blurRadius: 10,
                    offset: Offset(0, 0),
                    blurStyle: BlurStyle.outer
                ),
              ],
            ),
            child: Row(
              children: [
                Icon(Iconsax.sort_copy, size: 20,
                    color: Colors.redAccent,
                    weight: 10),
                SizedBox(width: 4,),
                Text(
                  "Show Added All Vehicle",maxLines: 2,
                  style: TextStyle(
                      fontSize: 12,
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



      /*floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 10,horizontal: 10)),

                ),
                onPressed: () {
                  */ /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => add_Tenant_num()));*/ /*
                  // Navigator.of(context).push(
                  //     MaterialPageRoute(builder: (context) => Provider.value(value: bloc,child: AddTenant(type: widget.type),)));
                },
                child:  Row(
                  children: [
                    const Icon(Icons.add_circle),
                    const SizedBox(width: 5,),
                    Text("Add Demand",style: const TextStyle(fontSize: 15),),
                  ],
                ),),
            ],
          ),
          const SizedBox(height: 30,)
        ],
      ),*/
    );
  }
}
