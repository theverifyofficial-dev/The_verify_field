import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import '../../provider/property_id_for_multipleimage_provider.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Real-Estate.dart';

class AddPropertiesFirstPage extends StatefulWidget {
  const AddPropertiesFirstPage({super.key});

  @override
  State<AddPropertiesFirstPage> createState() => _AddPropertiesFirstPageState();
}

class _AddPropertiesFirstPageState extends State<AddPropertiesFirstPage> {
  final _formKey = GlobalKey<FormState>();

  String? _location;
  String _buyOrRent = 'Buy';
  String _resOrComm = 'Residential';
  String? _propertyType;
  String? _bhk;
  String? _customBhk;
  String? _price;
  String? _floor;
  String? _balcony;
  String? _squareFeet;
  String? _maintenance;
  String? _customMaintenance;
  String? _buildingInfo;
  String? _propertyAge;
  String? _kitchenType;
  DateTime? _flatAvailableDate;
  String? _lift;
  String? _securityGuard;
  String? _guestParking;
  String? _cctv;
  String? _furnishing;
  String? _bathroom;
  String? _customParking;
  String? _totalFloor;

  late TextEditingController _locationController;
  late TextEditingController _propertyTypeController;
  late TextEditingController _bhkController;
  late TextEditingController _floorController;
  late TextEditingController _balconyController;
  late TextEditingController _maintenanceController;
  late TextEditingController _squareFeetController;
  late TextEditingController _propertyAgeController;
  late TextEditingController _buildingInfoController;
  late TextEditingController _parkingController;
  late TextEditingController _priceController;
  late TextEditingController _fieldWorkerAddressController;
  late TextEditingController _roadSizeController;
  late TextEditingController _nearMetroController;
  late TextEditingController _highwayController;
  late TextEditingController _mainMarketController;
  late TextEditingController _houseMeterController;
  late TextEditingController _ownerNameController;
  late TextEditingController _totalFloorController;
  late TextEditingController _ownerNumberController;
  final TextEditingController _flatAvailableController = TextEditingController();
  final TextEditingController _terraceGardenController = TextEditingController();
  final TextEditingController _propertyNumberController = TextEditingController();
  final TextEditingController _askingPriceController = TextEditingController();
  final TextEditingController _lastPriceController = TextEditingController();
  final TextEditingController _fieldWorkerNameController = TextEditingController();
  final TextEditingController _fieldWorkerNumberController = TextEditingController();

  String? _parking, _houseMeter;

  final cities = ['Delhi', 'Mumbai', 'Bangalore', 'Noida', 'Gurgaon'];
  final propertyTypes = ['Home', 'Flat', 'Villa', 'Apartment'];
  final bhkOptions = ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '5 BHK', 'Custom'];
  final floors = ['1st Floor', '2nd Floor', '3rd Floor', '4th Floor', '5th Floor'];

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId();
    });
    _locationController = TextEditingController(text: _location ?? '');
    _propertyTypeController = TextEditingController(text: _propertyType ?? '');
    _bhkController = TextEditingController(text: _bhk ?? '');
    _floorController = TextEditingController(text: _floor ?? '');
    _balconyController = TextEditingController(text: _balcony ?? '');
    _maintenanceController = TextEditingController(text: _maintenance ?? '');
    _squareFeetController = TextEditingController(text: _squareFeet ?? '');
    _propertyAgeController = TextEditingController(text: _propertyAge ?? '');
    _buildingInfoController = TextEditingController(text: _buildingInfo ?? '');
    _parkingController = TextEditingController(text: _customParking ?? '');
    _priceController = TextEditingController(text: _price ?? '');
    _fieldWorkerAddressController = TextEditingController();
    _roadSizeController = TextEditingController();
    _nearMetroController = TextEditingController();
    _highwayController = TextEditingController();
    _mainMarketController = TextEditingController();
    _houseMeterController = TextEditingController();
    _ownerNameController = TextEditingController();
    _ownerNumberController = TextEditingController();
    _totalFloorController = TextEditingController();

    _flatAvailableController.text = _flatAvailableDate != null
        ? DateFormat('yyyy-MM-dd').format(_flatAvailableDate!)
        : '';

    _terraceGardenController.text = '';
    _propertyNumberController.text = '';
    _askingPriceController.text = '';
    _lastPriceController.text = '';
    _fieldWorkerNameController.text = '';
    _fieldWorkerNumberController.text = '';
  }
  @override
  void dispose() {

    _locationController.dispose();
    _propertyTypeController.dispose();
    _bhkController.dispose();
    _floorController.dispose();
    _balconyController.dispose();
    _maintenanceController.dispose();
    _parkingController.dispose();
    _buildingInfoController.dispose();
    _fieldWorkerAddressController.dispose();
    _roadSizeController.dispose();
    _nearMetroController.dispose();
    _highwayController.dispose();
    _mainMarketController.dispose();
    _houseMeterController.dispose();
    _ownerNameController.dispose();
    _ownerNumberController.dispose();
    _totalFloorController.dispose();

    super.dispose();
  }
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        pickedFile.path,
        quality: 40,
        minWidth: 800,
        minHeight: 800,
      );

      if (compressedBytes == null) {
        print('❌ Image compression failed');
        return;
      }

      final kbSize = compressedBytes.lengthInBytes / 1024;
      print('✅ Compressed image size: ${kbSize.toStringAsFixed(2)} KB');

      final tempDir = Directory.systemTemp;
      final compressedFile = await File('${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg')
          .writeAsBytes(compressedBytes);

      setState(() {
        _imageFile = compressedFile;
      });

      print("✅ Image path: ${compressedFile.path}");
    } else {
      print('❌ No image selected.');
    }
  }

  Future<void> uploadCompressedImage(File imageFile) async {
    final uri = Uri.parse("https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php");

    var request = http.MultipartRequest('POST', uri);
    request.headers.addAll({
      'Accept': '*/*',
      'Connection': 'keep-alive',
      'User-Agent': 'VerifyApp/1.0',
    });
    request.files.add(
      await http.MultipartFile.fromPath(
        'property_photo',
        imageFile.path,
        filename: imageFile.path.split('/').last,
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("✅ Status code: ${response.statusCode}");
      print("✅ Response body: ${response.body}");

      if (response.statusCode != 200) {
        // Handle common errors
        print("❌ Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php",
          error: e.toString(),
          statusCode: 500,
      );
      print("❌ Upload error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final propertyId = Provider.of<PropertyIdProvider>(context).latestPropertyId;

    return Scaffold(

      appBar: AppBar(

        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
        actions: [
          // Text('${propertyId ?? "Loading..."}',style: TextStyle(color: Colors.white),),


        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 10),

              // Location (read-only)
              _buildReadOnlyField(
                label: "Select Location",
                controller: _locationController,
                onTap: () => _showBottomSheet(
                  options: cities,
                  onSelected: (val) {
                    setState(() {
                      _location = val;
                      _locationController.text = val;
                    });
                  },
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Please select location" : null,
              ),
              const SizedBox(height: 16),

              // Buy or Rent
              // Purpose: Buy or Rent
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Purpose:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Buy"),
                    labelStyle: TextStyle(
                      color: _buyOrRent == 'Buy' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _buyOrRent == 'Buy',
                    onSelected: (_) => setState(() => _buyOrRent = 'Buy'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Rent"),
                    labelStyle: TextStyle(
                      color: _buyOrRent == 'Rent' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _buyOrRent == 'Rent',
                    onSelected: (_) => setState(() => _buyOrRent = 'Rent'),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Category: Residential or Commercial
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Category:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Residential"),
                    labelStyle: TextStyle(
                      color: _resOrComm == 'Residential' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _resOrComm == 'Residential',
                    onSelected: (_) => setState(() => _resOrComm = 'Residential'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Commercial"),
                    labelStyle: TextStyle(
                      color: _resOrComm == 'Commercial' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _resOrComm == 'Commercial',
                    onSelected: (_) => setState(() => _resOrComm = 'Commercial'),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  // Property Type
                  Expanded(
                    child: _buildReadOnlyField(
                      label: "Property Type",
                      controller: _propertyTypeController,
                      onTap: () => _showBottomSheet(
                        options: propertyTypes,
                        onSelected: (val) {
                          setState(() {
                            _propertyType = val;
                            _propertyTypeController.text = val;
                          });
                        },
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Select property type" : null,
                    ),
                  ),
                  const SizedBox(width: 12), // space between the two fields
                  // BHK
                  Expanded(
                    child: _buildReadOnlyField(
                      label: "BHK",
                      controller: _bhkController,
                      onTap: () => _showBottomSheet(
                        options: bhkOptions,
                        onSelected: (val) {
                          setState(() {
                            _bhk = val;
                            _bhkController.text = val;
                            if (val != 'Custom') {
                              _customBhk = null;
                            }
                          });
                        },
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Select BHK" : null,
                    ),
                  ),
                ],
              ),



              const SizedBox(height: 10),

              // Custom BHK TextField only visible if 'Custom' selected
              if (_bhk == 'Custom')
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter custom BHK",
                    labelStyle: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : Colors.black54,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue.shade200
                            : Colors.blue.shade300,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.white,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _customBhk = val,
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  validator: (val) => _bhk == 'Custom' && (val == null || val.isEmpty)
                      ? "Enter custom BHK value"
                      : null,
                ),
              if (_bhk == 'Custom')
                const SizedBox(height: 16),

              // Price (normal input)
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  labelText: _buyOrRent == 'Buy' ? "Selling Price (₹)" : "Rent Price (₹)",
                  // ... rest of your decoration
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                validator: (val) => val == null || val.isEmpty ? "Enter price" : null,
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyField(
                      label: "Floor",
                      controller: _floorController,
                      onTap: () => _showBottomSheet(
                        options: floors,
                        onSelected: (val) {
                          setState(() {
                            _floor = val;
                            _floorController.text = val;
                          });
                        },
                      ),
                      validator: (val) =>
                      val == null || val.isEmpty ? "Select floor" : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildReadOnlyField(
                      label: "Balcony",
                      controller: _balconyController,
                      onTap: () => _showBottomSheet(
                        options: ['Front', 'Back'],
                        onSelected: (val) {
                          setState(() {
                            _balcony = val;
                            _balconyController.text = val;
                          });
                        },
                      ),
                      validator: (val) =>
                      _balcony == null || _balcony!.isEmpty ? "Select balcony" : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

// Square Feet
              Row(
                children: [
                  // Square Feet TextFormField
                  Expanded(
                    // flex: 2,
                    child: TextFormField(
                      controller: _squareFeetController,
                      decoration: InputDecoration(
                        labelText: "Square Feet (sq.ft)",
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey.shade300
                              : Colors.black54,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade700
                                : Colors.grey.shade300,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.blue.shade200
                                : Colors.blue.shade300,
                            width: 2,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        filled: true,
                        fillColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900
                            : Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                      onSaved: (val) => _squareFeet = val,
                      validator: (val) => val == null || val.isEmpty ? "Enter square feet" : null,
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Total Floor Dropdown
                  Expanded(
                    child: _buildReadOnlyField(
                      label: "Total Floor",
                      controller: _totalFloorController,
                      onTap: () => _showBottomSheet(
                        options: List.generate(10, (index) => (index + 1).toString()), // ['1', '2', ..., '10']
                        onSelected: (val) {
                          setState(() {
                            _totalFloor = val;
                            _totalFloorController.text = val;
                          });
                        },
                      ),
                      validator: (val) =>
                      _totalFloor == null || _totalFloor!.isEmpty ? "Select total floor" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _buildingInfoController,
                decoration: InputDecoration(
                  labelText: "Building Info (e.g. Tower A, Flat 301)",
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade300
                        : Colors.black54,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade700
                          : Colors.grey.shade300,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.blue.shade200
                          : Colors.blue.shade300,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey.shade900
                      : Colors.white,
                ),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
                ),
                onSaved: (val) => _buildingInfo = val,
              ),
              const SizedBox(height: 16),

// Maintenance
              Row(
                children: [
                  Expanded(
                    child: _buildReadOnlyField(
                      label: "Maintenance",
                      controller: _maintenanceController,
                      onTap: () => _showBottomSheet(
                        options: ['Included', 'Custom'],
                        onSelected: (val) {
                          setState(() {
                            _maintenance = val;
                            _maintenanceController.text = val;
                            if (val != 'Custom') _customMaintenance = null;
                          });
                        },
                      ),
                      validator: (val) => val == null || val.isEmpty ? "Select maintenance" : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildReadOnlyField(
                      label: "Age of Property",
                      controller: _propertyAgeController,
                      onTap: () => _showBottomSheet(
                        options: ['0-1 year', '1-3 years', '3-5 years', '5+ years'],
                        onSelected: (val) {
                          setState(() {
                            _propertyAge = val;
                            _propertyAgeController.text = val;
                          });
                        },
                      ),
                      validator: (val) => val == null || val.isEmpty ? "Select property age" : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),
              if (_maintenance == 'Custom') ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter Maintenance Fee",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue.shade200
                            : Colors.blue.shade300,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.white,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (val) => _customMaintenance = val,
                  validator: (val) =>
                  _maintenance == 'Custom' && (val == null || val.isEmpty)
                      ? "Enter maintenance fee"
                      : null,
                ),
              ],
              const SizedBox(height: 16),

// Parking Dropdown
              // Dropdown (always shows selected value or 'Parking' for Custom)
              _buildReadOnlyField(
                label: "Parking",
                controller: TextEditingController(
                  text: _parking == 'Custom' ? 'Parking' : _parking ?? '',
                ),
                onTap: () => _showBottomSheet(
                  options: ['Car', 'Bike', 'Custom'],
                  onSelected: (val) {
                    setState(() {
                      _parking = val;
                      if (val != 'Custom') {
                        _customParking = null; // clear custom
                      }
                    });
                  },
                ),
                validator: (val) =>
                _parking == null || _parking!.isEmpty ? "Select parking type" : null,
              ),

              const SizedBox(height: 10),

// Custom parking input (visible only when 'Custom' selected)
              if (_parking == 'Custom')
                TextFormField(
                  decoration: InputDecoration(
                    labelText: "Enter Custom Parking",
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.grey.shade300
                          : Colors.black54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade700
                            : Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.blue.shade200
                            : Colors.blue.shade300,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.white,
                  ),
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ),
                  onChanged: (val) => _customParking = val,
                  validator: (val) =>
                  _parking == 'Custom' && (val == null || val.isEmpty)
                      ? "Enter custom parking type"
                      : null,
                ),
              if (_parking == 'Custom')


                const SizedBox(height: 16),

// Field Worker Address
              TextFormField(
                controller: _fieldWorkerAddressController,
                decoration: _buildInputDecoration(context, "Field Worker Address"),
                validator: (val) => val == null || val.isEmpty ? "Enter address" : null,
              ),
              const SizedBox(height: 16),

// Road Size
              TextFormField(
                controller: _roadSizeController,
                decoration: _buildInputDecoration(context, "Road Size (in feet)"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "Enter road size" : null,
              ),
              const SizedBox(height: 16),

// Near Metro
              TextFormField(
                controller: _nearMetroController,
                decoration: _buildInputDecoration(context, "Near Metro Station"),
                validator: (val) => val == null || val.isEmpty ? "Enter nearest metro" : null,
              ),
              const SizedBox(height: 16),

// Highway
              TextFormField(
                controller: _highwayController,
                decoration: _buildInputDecoration(context, "Nearby Highway"),
              ),
              const SizedBox(height: 16),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Nearby Main Market TextField
                      Expanded(
                        child: TextFormField(
                          controller: _mainMarketController,
                          decoration: _buildInputDecoration(context, "Nearby Main Market"),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // House Meter Type Dropdown
                      Expanded(
                        child: _buildReadOnlyField(
                          label: "House Meter Type",
                          controller: TextEditingController(text: _houseMeter == 'Custom' ? 'Custom' : _houseMeter),
                          onTap: () => _showBottomSheet(
                            options: ['Commercial', 'Govt', 'Custom'],
                            onSelected: (val) {
                              setState(() {
                                _houseMeter = val;
                                if (val != 'Custom') {
                                  _houseMeterController.text = val; // assign directly
                                } else {
                                  _houseMeterController.clear(); // clear so user can type in custom input field
                                }
                              });
                            },
                          ),
                          validator: (val) => (_houseMeterController.text.isEmpty)
                              ? "Select house meter type"
                              : null,
                        ),
                      ),
                    ],
                  ),

                  // Custom input only when "Custom" is selected
                  if (_houseMeter == 'Custom') ...[
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: _buildInputDecoration(context, "Enter Custom House Meter Type"),
                      onChanged: (val) => _houseMeterController.text = val, // update same controller
                      validator: (val) => val == null || val.isEmpty
                          ? "Enter custom meter type"
                          : null,
                    ),
                  ],

                  const SizedBox(height: 16),
                ],
              ),



// Owner Name
              TextFormField(
                controller: _ownerNameController,
                decoration: _buildInputDecoration(context, "Owner Name"),
                validator: (val) => val == null || val.isEmpty ? "Enter owner name" : null,
              ),
              const SizedBox(height: 16),

// Owner Number
              TextFormField(
                controller: _ownerNumberController,
                decoration: _buildInputDecoration(context, "Owner Contact Number"),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10), // max 10 chars
                  FilteringTextInputFormatter.digitsOnly, // digits only
                ],
                validator: (val) => val == null || val.length < 10 ? "Enter valid contact number" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "Kitchen Type:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Modern"),
                    labelStyle: TextStyle(
                      color: _kitchenType == 'Modern' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _kitchenType == 'Modern',
                    onSelected: (_) => setState(() => _kitchenType = 'Modern'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Western"),
                    labelStyle: TextStyle(
                      color: _kitchenType == 'Western' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _kitchenType == 'Western',
                    onSelected: (_) => setState(() => _kitchenType = 'Western'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

// Flat Available (Date Picker)
              TextFormField(
                controller: _flatAvailableController,
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() {
                      _flatAvailableDate = date;
                      _flatAvailableController.text =
                          DateFormat('dd-MM-yyyy').format(date);
                    });
                  }
                },
                decoration: _buildInputDecoration(context, "Flat Available From"),
                validator: (val) =>
                val == null || val.isEmpty ? "Select availability date" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "Bathroom:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Modern"),
                    labelStyle: TextStyle(
                      color: _bathroom == 'Modern' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _bathroom == 'Modern',
                    onSelected: (_) => setState(() => _bathroom = 'Modern'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Western"),
                    labelStyle: TextStyle(
                      color: _bathroom == 'Western' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _bathroom == 'Western',
                    onSelected: (_) => setState(() => _bathroom = 'Western'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    "Lift Available:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Yes"),
                    labelStyle: TextStyle(
                      color: _lift == 'Yes' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _lift == 'Yes',
                    onSelected: (_) => setState(() => _lift = 'Yes'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("No"),
                    labelStyle: TextStyle(
                      color: _lift == 'No' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _lift == 'No',
                    onSelected: (_) => setState(() => _lift = 'No'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "Security Guard:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Yes"),
                    labelStyle: TextStyle(
                      color: _securityGuard == 'Yes' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _securityGuard == 'Yes',
                    onSelected: (_) => setState(() => _securityGuard = 'Yes'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("No"),
                    labelStyle: TextStyle(
                      color: _securityGuard == 'No' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _securityGuard == 'No',
                    onSelected: (_) => setState(() => _securityGuard = 'No'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "Guest Parking:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Yes"),
                    labelStyle: TextStyle(
                      color: _guestParking == 'Yes' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _guestParking == 'Yes',
                    onSelected: (_) => setState(() => _guestParking = 'Yes'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("No"),
                    labelStyle: TextStyle(
                      color: _guestParking == 'No' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _guestParking == 'No',
                    onSelected: (_) => setState(() => _guestParking = 'No'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    "CCTV Camera:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Yes"),
                    labelStyle: TextStyle(
                      color: _cctv == 'Yes' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _cctv == 'Yes',
                    onSelected: (_) => setState(() => _cctv = 'Yes'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("No"),
                    labelStyle: TextStyle(
                      color: _cctv == 'No' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _cctv == 'No',
                    onSelected: (_) => setState(() => _cctv = 'No'),
                  ),
                ],
              ),
              const SizedBox(height: 16),

// Tarrish Garden
              TextFormField(
                controller: _terraceGardenController,
                decoration: _buildInputDecoration(context, "Terrace/Garden Info"),
              ),
              const SizedBox(height: 16),

// Property Number
              TextFormField(
                controller: _propertyNumberController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration(context, "Property Number"),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    "Furnishing:",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 20),
                  ChoiceChip(
                    label: const Text("Furnished"),
                    labelStyle: TextStyle(
                      color: _furnishing == 'Furnished' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _furnishing == 'Furnished',
                    onSelected: (_) => setState(() => _furnishing = 'Furnished'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: const Text("Unfurnished"),
                    labelStyle: TextStyle(
                      color: _furnishing == 'Unfurnished' ? Colors.white : Colors.black87,
                    ),
                    selectedColor: Colors.blueAccent,
                    backgroundColor: Colors.grey.shade200,
                    selected: _furnishing == 'Unfurnished',
                    onSelected: (_) => setState(() => _furnishing = 'Unfurnished'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
// Asking Price
              TextFormField(
                controller: _askingPriceController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration(context, "Asking Price (₹)"),
              ),
              const SizedBox(height: 16),

// Last Price
              TextFormField(
                controller: _lastPriceController,
                keyboardType: TextInputType.number,
                decoration: _buildInputDecoration(context, "Last Price (₹)"),
              ),
              const SizedBox(height: 16),

// Field Worker Name
              TextFormField(
                controller: _fieldWorkerNameController,
                decoration: _buildInputDecoration(context, "Field Worker Name"),
              ),
              const SizedBox(height: 16),

// Field Worker Number
              TextFormField(
                controller: _fieldWorkerNumberController,
                keyboardType: TextInputType.phone,
                decoration: _buildInputDecoration(context, "Field Worker Number"),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  GestureDetector(
                    onTap: _pickImage, // Always allow picking/replacing image
                    child: _imageFile != null
                        ? Image.file(
                      _imageFile!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    )
                        : Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4)
                      ),
                      child: const Center(child: Text('Tap to select image',textAlign: TextAlign.center,)),
                    ),
                  ),
                ],
              ),


// Building Info
              const SizedBox(height: 24),
              // Submit Button
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.blueAccent,
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    color: Colors.white,  // White text for good visibility
                  ),
                ),
              ),
              const SizedBox(height: 16),

            ],
          ),
        ),
      ),
    );
  }
  /// Helper widget: readonly TextFormField with onTap to open bottom sheet
  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: isDark ? Colors.grey.shade300 : Colors.black54,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: isDark ? Colors.blue.shade200 : Colors.blue.shade300, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.white,
    );
  }

  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }){
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade700
                    : Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.blue.shade200
                    : Colors.blue.shade300,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            filled: true,
            fillColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.white,
          ),
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          validator: validator,
        ),
      ),
    );
  }

  void _showBottomSheet({
    required List<String> options,
    required Function(String) onSelected,
  }) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        minChildSize: 0.3,
        maxChildSize: 0.7,
        initialChildSize: options.length <= 5 ? 0.4 : 0.6,
        builder: (context, scrollController) => ListView.builder(
          controller: scrollController,
          shrinkWrap: true,
          itemCount: options.length,
          itemBuilder: (context, index) {
            final option = options[index];
            return ListTile(
              title: Text(
                option,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500,
                    fontFamily: "Poppins"),
              ),
              onTap: () => Navigator.pop(context, option),
              contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
              ),
              hoverColor: Colors.blue.shade50,
            );
          },
        ),
      ),
    );

    if (selected != null) {
      // Delay to ensure bottom sheet closes before updating state
      Future.delayed(const Duration(milliseconds: 50), () {
        onSelected(selected);
      });
    }
  }

  bool _isSubmitting = false; // Add this in your State class

  void _submitForm() async {
    if (_isSubmitting) return; // prevent duplicate taps

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
      });

      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId();
      final propertyId = provider.latestPropertyId;

      final prefs = await SharedPreferences.getInstance();

      final uri = Uri.parse("https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php");
      var request = http.MultipartRequest('POST', uri);

      request.fields['locations'] = _location ?? '';
      request.fields['Buy_Rent'] = _buyOrRent ?? '';
      request.fields['Residence_Commercial'] = _resOrComm ?? '';
      request.fields['Typeofproperty'] = _propertyType ?? '';
      request.fields['Bhk_space'] = (_bhk == "Custom" ? _customBhk ?? '' : _bhk) ?? '';
      request.fields['Price'] = _priceController.text;
      request.fields['maintance'] = (_maintenance == "Custom" ? _customMaintenance ?? '' : _maintenance) ?? '';
      request.fields['Floor_'] = _floor ?? '';
      request.fields['Balcony'] = _balcony ?? '';
      request.fields['squarefit'] = _squareFeetController.text;
      request.fields['building_information'] = _buildingInfoController.text;
      request.fields['age_of_property'] = _propertyAge ?? '';
      request.fields['parking'] = _parking ?? '';
      request.fields['field_address'] = _fieldWorkerAddressController.text;
      request.fields['Road_Size'] = _roadSizeController.text;
      request.fields['metro_distance'] = _nearMetroController.text;
      request.fields['highway_distance'] = _highwayController.text;
      request.fields['main_market_distance'] = _mainMarketController.text;
      request.fields['meter'] = (_houseMeter == "Custom" ? _houseMeterController.text : (_houseMeter ?? ''));
      request.fields['owner_name'] = _ownerNameController.text;
      request.fields['owner_number'] = _ownerNumberController.text;
      request.fields['current_dates'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      request.fields['available_date'] = _flatAvailableDate?.toIso8601String() ?? '';
      request.fields['kitchen'] = _kitchenType ?? '';
      request.fields['bathroom'] = _bathroom ?? '';
      request.fields['lift'] = _lift ?? '';
      request.fields['security_guard'] = _securityGuard ?? '';
      request.fields['cctv_cemera'] = _cctv ?? '';
      request.fields['guest_parking'] = _guestParking ?? '';
      request.fields['Tarrice_garden'] = _terraceGardenController.text;
      request.fields['furnished_unfurnished'] = _furnishing ?? '';
      request.fields['field_warkar_name'] = _fieldWorkerNameController.text;
      request.fields['field_workar_number'] = _fieldWorkerNumberController.text;
      request.fields['property_number'] = _propertyNumberController.text;
      request.fields['Last_Price'] = _lastPriceController.text;
      request.fields['asking_price'] = _askingPriceController.text;
      request.fields['Total_floor'] = _totalFloorController.text;
      // request.fields['property_photo'] = "https://theverify.in/photo/abouts%20us.jpg";

      final lat = prefs.getDouble('latitude');
      final long = prefs.getDouble('longitude');
      request.fields['Latitude'] = lat?.toString() ?? '';
      request.fields['Longitude'] = long?.toString() ?? '';

      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'property_photo',
          _imageFile!.path,
        ));
      }

      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          if (response.body.contains('already exists')) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("This property already exists.")),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Property submitted successfully")),
            );
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => Show_Real_Estate(),), (route) => route.isFirst);

            // Navigator.of(context).push(MaterialPageRoute(
            //   builder: (context) => MultiImagePickerPage(propertyId: propertyId ?? 0),
            // ));
          }
        } else {
          await BugLogger.log(
              apiLink: "https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php",
              error: response.body.toString(),
              statusCode: response.statusCode ?? 0,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to submit property. Status code: ${response.statusCode}")),
          );
        }
      } catch (e) {
        await BugLogger.log(
          apiLink: "https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php",
          error: e.toString(),
          statusCode: 500,
        );
        print('Error submitting form: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("An error occurred: $e")),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
  Future<Map<String, String>> getSavedLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('latitude')?.toString() ?? '';
    final long = prefs.getDouble('longitude')?.toString() ?? '';
    return {
      'Latitude': lat,
      'Longitude': long,
    };
  }

}
