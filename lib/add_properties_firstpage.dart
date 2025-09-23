import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/property_id_for_multipleimage_provider.dart';
import 'constant.dart';

// final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class RegisterProperty extends StatefulWidget {

  const RegisterProperty({super.key});

  @override
  State<RegisterProperty> createState() => _RegisterPropertyState();
}

class _RegisterPropertyState extends State<RegisterProperty> {
  final _formKey = GlobalKey<FormState>();

  String? _location;
  String? _buyOrRent;
  String? _resOrComm ;
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
  String? _liveOrNot;
  String? _bathroom;
  String? _customParking;
  String? _totalFloor;
  String? _loan;
  String? _registryOrGpa;
  String _buyDetail = 'registry_and_gpa';
  String? _registryAndGpa;
  String? _customParkingCount;
  bool _isButtonDisabled = false;

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
  late  TextEditingController _askingPriceController;
  late TextEditingController _fieldWorkerAddressController;
  late TextEditingController _flatNumberController;
  late TextEditingController _apartmentAddressController;
  late TextEditingController _facilityController;
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
  final TextEditingController _fieldWorkerNameController = TextEditingController();
  final TextEditingController _fieldWorkerNumberController = TextEditingController();
  final TextEditingController _careTakerNameController = TextEditingController();
  final TextEditingController _videoLinkController = TextEditingController();
  final TextEditingController _careTakerNumberController = TextEditingController();
  late TextEditingController _someController;
  final TextEditingController _Google_Location = TextEditingController();
  late TextEditingController _lastPriceController;
  String _formattedLastPrice = '';
  String _formattedPrice = '';
  String _formattedAskingPrice = '';

  String? _parking, _houseMeter;
  String full_address = '';

  final cities = ['SultanPur', 'ChhattarPur', 'Aya Nagar', 'Ghitorni', 'Rajpur Khurd','Mangalpuri','Dwarka Mor',];
  final propertyTypes = ["Flat","Shop","Office","Godown","Farms","Plots"];
  final bhkOptions = ['1 BHK', '2 BHK', '3 BHK', '4 BHK', '1 RK', 'Commercial'];
  final floors = [
    'G Floor',
    '1 Floor',
    '2 Floor',
    '3 Floor',
    '4 Floor',
    '5 Floor',
    '6 Floor',
    '7 Floor',
    '8 Floor',
    '9 Floor',
    '10 Floor',
  ];
  bool get _isFormValid {
    return (_location?.isNotEmpty ?? false) &&
        _flatNumberController.text.trim().isNotEmpty &&
        (_buyOrRent?.isNotEmpty ?? false) &&
        _apartmentAddressController.text.trim().isNotEmpty &&
        (_propertyType?.isNotEmpty ?? false) &&
        ((_bhk == "Custom" ? _customBhk : _bhk)?.isNotEmpty ?? false) &&
        _priceController.text.trim().isNotEmpty &&
        _lastPriceController.text.trim().isNotEmpty &&
        _askingPriceController.text.trim().isNotEmpty &&
        (_floor?.isNotEmpty ?? false) &&
        _totalFloorController.text.trim().isNotEmpty &&
        (_balcony?.isNotEmpty ?? false) &&
        _squareFeetController.text.trim().isNotEmpty &&
        ((_maintenance == "Custom" ? _customMaintenance : _maintenance)?.isNotEmpty ?? false) &&
        (_parking?.isNotEmpty ?? false) &&
        (_propertyAge?.isNotEmpty ?? false) &&
        _fieldWorkerAddressController.text.trim().isNotEmpty &&
        _roadSizeController.text.trim().isNotEmpty &&
        _nearMetroController.text.trim().isNotEmpty &&
        _highwayController.text.trim().isNotEmpty &&
        _mainMarketController.text.trim().isNotEmpty &&
        ((_houseMeter == "Custom" ? _houseMeterController.text : _houseMeter)?.isNotEmpty ?? false) &&
        _ownerNameController.text.trim().isNotEmpty &&
        _ownerNumberController.text.trim().isNotEmpty &&
        (_flatAvailableDate != null) &&
        (_kitchenType?.isNotEmpty ?? false) &&
        (_bathroom?.isNotEmpty ?? false) &&
        (_lift?.isNotEmpty ?? false) &&
        _facilityController.text.trim().isNotEmpty &&
        (_furnishing?.isNotEmpty ?? false) &&
        _careTakerNameController.text.trim().isNotEmpty &&
        _careTakerNumberController.text.trim().isNotEmpty &&
        (_loan?.isNotEmpty ?? false) &&
        full_address?.isNotEmpty == true &&
        _imageFile != null; // Ensure at least 1 main image
  }


  void _loadSavedFieldWorkerData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('name') ?? '';
    final savedNumber = prefs.getString('number') ?? '';

    setState(() {
      _fieldWorkerNameController.text = savedName;
      _fieldWorkerNumberController.text = savedNumber;
    });
  }
  int _countdown = 0; // countdown state

  bool _hasError = false; // ✅ add this
  @override
  void initState() {
    super.initState();

    _loadSavedFieldWorkerData();

    // Initialize controllers first
    _priceController = TextEditingController();
    _askingPriceController = TextEditingController();

    // Add listener for _priceController
    _priceController.addListener(() {
      final input = _priceController.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);
      setState(() {
        _formattedPrice = number != null ? formatPrice(number) : '';
      });
    });

    _askingPriceController.addListener(() {
      final input = _askingPriceController.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);
      setState(() {
        _formattedAskingPrice = number != null ? formatPrice(number) : '';
      });
    });

    _lastPriceController = TextEditingController();

    _lastPriceController.addListener(() {
      final input = _lastPriceController.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);
      setState(() {
        _formattedLastPrice = number != null ? formatPrice(number) : '';
      });
    });
    Future.microtask(() async {
      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId.toString();
    });

    // Initialize all other controllers (unchanged)
    _someController = TextEditingController(text: _registryAndGpa);
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
    _fieldWorkerAddressController = TextEditingController();
    _flatNumberController = TextEditingController();
    _roadSizeController = TextEditingController();
    _nearMetroController = TextEditingController();
    _highwayController = TextEditingController();
    _mainMarketController = TextEditingController();
    _houseMeterController = TextEditingController();
    _ownerNameController = TextEditingController();
    _ownerNumberController = TextEditingController();
    _totalFloorController = TextEditingController();
    _apartmentAddressController = TextEditingController();
    _facilityController = TextEditingController();

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

  String formatPrice(int value) {
    if (value >= 10000000) {
      return '${(value / 10000000).toStringAsFixed(2)}Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(2)}L';
    } else {
      return value.toString();
    }
  }
  final Map<String, bool> _fieldErrors = {};


  List<String> allFacilities = ['CCTV Camera', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline "];
  List<String> selectedFacilities = [];
  @override
  void dispose() {
    _apartmentAddressController.dispose();
    _priceController.dispose();
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
    _facilityController.dispose();

    super.dispose();
  }

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery);

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
      final compressedFile = await File('${tempDir.path}/${DateTime
          .now()
          .millisecondsSinceEpoch}.jpg')
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
    final uri = Uri.parse(
        "https://verifyserve.social/PHP_Files/Main_Realestate/insert_property.php");

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
        filename: imageFile.path
            .split('/')
            .last,
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
      print("❌ Upload error: $e");
    }
  }

  final ImagePicker _MultiPicker = ImagePicker();
  List<XFile> _images = [];

  Future<void> pickMultipleImages() async {
    try {
      final List<XFile> pickedImages = await _MultiPicker.pickMultiImage();
      if (pickedImages.isNotEmpty) {
        setState(() {
          _images = pickedImages;
        });
        print("Picked ${_images.length} images");
      } else {
        print("No images selected.");
      }
    } catch (e) {
      print("Error picking images: $e");
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }
  final List<String> _metroOptions = [
    'Hauz khas', 'Malviya Nagar', 'Saket','Qutub Minar','ChhattarPur','Sultanpur', 'Ghitorni','Arjan Garh','Guru Drona','Sikanderpur','Dwarka Mor',
  ];
  Map<String, int> _selectedFurniture = {};
  final List<String> furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.black,
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
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,

          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 8),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // Location (read-only)
                _buildReadOnlyField(
                  label: "Select Location",
                  controller: _locationController,
                  onTap: () =>
                      _showBottomSheet(
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

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Purpose Selection (with validation)
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        if (_buyOrRent?.isEmpty ?? true) {
                          return "Please select a purpose";
                        }
                        return null;
                      },
                      builder: (state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Text(
                                  "Purpose:",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                const SizedBox(width: 20),
                                ChoiceChip(
                                  label: const Text("Buy"),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: _buyOrRent == 'Buy'
                                        ? Colors.white
                                        : Theme.of(context).textTheme.bodyMedium!.color,
                                  ),
                                  selectedColor: Colors.blueAccent,
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  selected: _buyOrRent == 'Buy',
                                  onSelected: (_) {
                                    setState(() {
                                      _buyOrRent = 'Buy';
                                      state.didChange('Buy'); // ✅ update FormField
                                    });
                                  },
                                ),
                                const SizedBox(width: 10),
                                ChoiceChip(
                                  label: const Text("Rent"),
                                  labelStyle: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: _buyOrRent == 'Rent'
                                        ? Colors.white
                                        : Theme.of(context).textTheme.bodyMedium!.color,
                                  ),
                                  selectedColor: Colors.blueAccent,
                                  backgroundColor: Theme.of(context).colorScheme.surface,
                                  selected: _buyOrRent == 'Rent',
                                  onSelected: (_) {
                                    setState(() {
                                      _buyOrRent = 'Rent';
                                      state.didChange('Rent'); // ✅ update FormField
                                    });
                                  },
                                ),
                              ],
                            ),
                            if (state.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 5),
                                child: Text(
                                  state.errorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // ✅ Show only when "Buy" is selected
                    if (_buyOrRent == 'Buy') ...[
                      // Registry or GPA (❌ no validation here)
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 8,
                        children: [
                          const Text(
                            "Registry or GPA:",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          ChoiceChip(
                            label: const Text("Registry"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _registryAndGpa == 'Registry'
                                  ? Colors.white
                                  : Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            selected: _registryAndGpa == 'Registry',
                            onSelected: (_) {
                              setState(() {
                                _registryAndGpa = 'Registry';
                              });
                            },
                          ),
                          ChoiceChip(
                            label: const Text("GPA"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _registryAndGpa == 'GPA'
                                  ? Colors.white
                                  : Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            selected: _registryAndGpa == 'GPA',
                            onSelected: (_) {
                              setState(() {
                                _registryAndGpa = 'GPA';
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Loan Availability (❌ no validation here)
                      Row(
                        children: [
                          const Text(
                            "Loan availability?",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text("Yes"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _loan == 'Yes'
                                  ? Colors.white
                                  : Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            selected: _loan == 'Yes',
                            onSelected: (_) {
                              setState(() {
                                _loan = 'Yes';
                              });
                            },
                          ),
                          const SizedBox(width: 10),
                          ChoiceChip(
                            label: const Text("No"),
                            labelStyle: TextStyle(
                              fontFamily: 'Poppins',
                              color: _loan == 'No'
                                  ? Colors.white
                                  : Theme.of(context).textTheme.bodyMedium!.color,
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Theme.of(context).colorScheme.surface,
                            selected: _loan == 'No',
                            onSelected: (_) {
                              setState(() {
                                _loan = 'No';
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ],
                ) ,
                // Category: Residential or Commercial
                FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_resOrComm?.isEmpty ?? true) {
                      return "Please select a category";
                    }
                    return null;
                  },
                  builder: (field) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          const Text(
                            "Category:",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          ChoiceChip(
                            label: Text(
                              "Residential",
                              style: TextStyle(
                                color: _resOrComm == 'Residential'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Colors.grey.shade200,
                            selected: _resOrComm == 'Residential',
                            onSelected: (_) {
                              setState(() => _resOrComm = 'Residential');
                              field.didChange(_resOrComm); // ✅ important
                            },
                          ),
                          ChoiceChip(
                            label: Text(
                              "Commercial",
                              style: TextStyle(
                                color: _resOrComm == 'Commercial'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            selectedColor: Colors.blueAccent,
                            backgroundColor: Colors.grey.shade200,
                            selected: _resOrComm == 'Commercial',
                            onSelected: (_) {
                              setState(() => _resOrComm = 'Commercial');
                              field.didChange(_resOrComm); // ✅ important
                            },
                          ),
                        ],
                      ),
                      if (field.hasError)
                        Padding(
                          padding: const EdgeInsets.only(top: 5, left: 5),
                          child: Text(
                            field.errorText ?? "",
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Property Type
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Property Type",
                        controller: _propertyTypeController,
                        onTap: () =>
                            _showBottomSheet(
                              options: propertyTypes,
                              onSelected: (val) {
                                setState(() {
                                  _propertyType = val;
                                  _propertyTypeController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Select property type"
                            : null,
                      ),
                    ),
                    const SizedBox(width: 12), // space between the two fields
                    // BHK
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "BHK",
                        controller: _bhkController,
                        onTap: () =>
                            _showBottomSheet(
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


                const SizedBox(height: 16),

                // Custom BHK TextField only visible if 'Custom' selected
                if (_bhk == 'Custom')
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: "Enter custom BHK",
                      labelStyle: TextStyle(
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? Colors.grey.shade300
                            : Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.grey.shade700
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.blue.shade200
                              : Colors.blue.shade300,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                      filled: true,
                      fillColor: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.grey.shade900
                          : Colors.white,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (val) => _customBhk = val,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    validator: (val) =>
                    _bhk == 'Custom' && (val == null || val.isEmpty)
                        ? "Enter custom BHK value"
                        : null,
                  ),
                if (_bhk == 'Custom')
                  const SizedBox(height: 16),

                // Price (normal input)
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: _buyOrRent == 'Buy' ? "Selling Price (₹)" : "Rent Price (₹)",

                    suffix: _formattedPrice.isNotEmpty
                        ? Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Text(
                        _formattedPrice,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : null,

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
                    focusColor: Colors.red,
                    // 🔴 Border when validation fails
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),

                    // 🔴 Border when validation fails & field is focused
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),

                    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade900
                        : Colors.white,
                  ),
                  validator: (val) => val == null || val.isEmpty ? "Enter price" : null,
                ),
                const SizedBox(height: 16),
                // Asking Price
                TextFormField(
                  controller: _askingPriceController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter asking price";
                    }
                    if (double.tryParse(value) == null) {
                      return "Enter a valid number";
                    }
                    return null;
                  },
                  decoration: _buildInputDecoration(
                    context,
                    "Asking Price (₹) by owner",
                  ).copyWith(
                    suffix: Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        _formattedAskingPrice ?? '',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400), // normal border
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2), // 🔴 red border
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red, width: 2), // 🔴 red when focused
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Last Price
                TextFormField(
                  controller: _lastPriceController,
                  keyboardType: TextInputType.number,
                  decoration: _buildInputDecoration(
                    context,
                    "Last Price (₹) by owner",
                  ).copyWith(
                    suffix: Text(
                      _formattedLastPrice,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    errorStyle: const TextStyle(color: Colors.red), // Red error text
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.red, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.blue),
                    ),

                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Last Price is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),
                //flatNumber
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _flatNumberController,
                  decoration: _buildInputDecoration(context, "Flat Number"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter number"
                      : null,
                ),
                const SizedBox(height: 16),
                // Property Number
                // TextFormField(
                //   keyboardType: TextInputType.number,
                //   controller: _propertyNumberController,
                //   decoration: _buildInputDecoration(context, "Property Number"),
                // ),

                // const SizedBox(height: 16),

                //_apartmentAddressController
                TextFormField(
                  controller: _apartmentAddressController,
                  decoration: _buildInputDecoration(
                      context, "Apartment Name & Address"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter Apartment Name"
                      : null,
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _facilityController,
                  readOnly: true, // Prevents manual editing
                  onTap: _showFacilitySelectionDialog, // Opens the selection dialog
                  decoration: _buildInputDecoration(context, "Facility"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter Apartment Name"
                      : null,
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Floor",
                        controller: _floorController,
                        onTap: () =>
                            _showBottomSheet(
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


                    // Total Floor Dropdown
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Total Floor",
                        controller: _totalFloorController,
                        onTap: () => _showBottomSheet(
                          options: [
                            'G Floor',
                            '1 Floor',
                            '2 Floor',
                            '3 Floor',
                            '4 Floor',
                            '5 Floor',
                            '6 Floor',
                            '7 Floor',
                            '8 Floor',
                            '9 Floor',
                            '10 Floor',
                          ],
                          onSelected: (val) {
                            setState(() {
                              _totalFloor = val;
                              _totalFloorController.text = val;
                            });
                          },
                        ),
                        validator: (val) =>
                        _totalFloor == null || _totalFloor!.isEmpty
                            ? "Select total floor"
                            : null,
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
                            color: Theme
                                .of(context)
                                .brightness == Brightness.dark
                                ? Colors.grey.shade300
                                : Colors.black54,
                          ),
                          errorStyle: const TextStyle(color: Colors.redAccent), // Red error text
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme
                                  .of(context)
                                  .brightness == Brightness.dark
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade300,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 14, horizontal: 14),
                          filled: true,
                          fillColor: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.grey.shade900
                              : Colors.white,
                        ),
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          color: Theme
                              .of(context)
                              .brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                        onSaved: (val) => _squareFeet = val,
                        validator: (val) =>
                        val == null || val.isEmpty
                            ? "Enter square feet"
                            : null,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Balcony",
                        controller: _balconyController,
                        onTap: () =>
                            _showBottomSheet(
                              options: ['Front Side Balcony', 'Back Side Balcony','Side','Window', 'Park Facing', 'Road Facing', 'Corner', 'No Balcony',],
                              onSelected: (val) {
                                setState(() {
                                  _balcony = val;
                                  _balconyController.text = val;
                                });
                              },
                            ),
                        validator: (val) =>
                        _balcony == null || _balcony!.isEmpty
                            ? "Select balcony"
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                //
                // TextFormField(
                //   controller: _buildingInfoController,
                //   decoration: InputDecoration(
                //     labelText: "Building Info (e.g. Tower A, Flat 301)",
                //     labelStyle: TextStyle(
                //       fontWeight: FontWeight.w600,
                //       fontSize: 15,
                //       color: Theme
                //           .of(context)
                //           .brightness == Brightness.dark
                //           ? Colors.grey.shade300
                //           : Colors.black54,
                //     ),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: BorderSide(
                //         color: Theme
                //             .of(context)
                //             .brightness == Brightness.dark
                //             ? Colors.grey.shade700
                //             : Colors.grey.shade300,
                //       ),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: BorderSide(
                //         color: Theme
                //             .of(context)
                //             .brightness == Brightness.dark
                //             ? Colors.grey.shade700
                //             : Colors.grey.shade300,
                //       ),
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: BorderSide(
                //         color: Theme
                //             .of(context)
                //             .brightness == Brightness.dark
                //             ? Colors.blue.shade200
                //             : Colors.blue.shade300,
                //         width: 2,
                //       ),
                //     ),
                //     contentPadding: const EdgeInsets.symmetric(
                //         vertical: 14, horizontal: 14),
                //     filled: true,
                //     fillColor: Theme
                //         .of(context)
                //         .brightness == Brightness.dark
                //         ? Colors.grey.shade900
                //         : Colors.white,
                //   ),
                //   style: TextStyle(
                //     color: Theme
                //         .of(context)
                //         .brightness == Brightness.dark
                //         ? Colors.white
                //         : Colors.black,
                //   ),
                //   onSaved: (val) => _buildingInfo = val,
                // ),
                // const SizedBox(height: 16),

                // Maintenance
                Row(
                  children: [
                    /// Maintenance dropdown field
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
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select maintenance" : null,
                      ),
                    ),


                    /// Custom maintenance fee field
                    if (_maintenance == 'Custom')

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Enter Maintenance Fee",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
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
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
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
                            keyboardType: TextInputType.number,
                            onChanged: (val) => _customMaintenance = val,
                            validator: (val) => _maintenance == 'Custom' &&
                                (val == null || val.isEmpty)
                                ? "Enter maintenance fee"
                                : null,
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Age of Property",
                        controller: _propertyAgeController,
                        onTap: () => _showBottomSheet(
                          options: ['1 years', '2 years', '3 years', '4 years','5 years','6 years','7 years','8 years','9 years','10 years','10+ years'],
                          onSelected: (val) {
                            setState(() {
                              _propertyAge = val;
                              _propertyAgeController.text = val;
                            });
                          },
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select property age" : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Road Size (in feet)",
                        controller: _roadSizeController,
                        onTap: () => _showBottomSheet(
                          options: ['15 Feet', '20 Feet', '25 Feet', '30 Feet', '35 Feet', '40 Above'],
                          onSelected: (val) {
                            setState(() {
                              _roadSizeController.text = val;
                            });
                          },
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select road size" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Parking Dropdown
                // Row(
                //   children: [
                //     // Dropdown for Car, Bike, Custom
                //     _buildReadOnlyField(
                //       label: "Parking",
                //       controller: TextEditingController(
                //         text: _parking == 'Custom' ? 'Parking' : (_parking ?? ''),
                //       ),
                //       onTap: () => _showBottomSheet(
                //         options: ['Car', 'Bike', 'Both'],
                //         onSelected: (val) {
                //           setState(() {
                //             _parking = val;
                //             if (val != 'Custom') _customParking = null;  // clear custom when not selected
                //           });
                //         },
                //       ),
                //       validator: (val) =>
                //       val == null || val.isEmpty ? "Select parking type" : null,
                //     ),
                //
                //     // Show this TextFormField only if Custom is selected
                //     // if (_parking == 'Custom')
                //     //   Expanded(
                //     //     child: Padding(
                //     //       padding: const EdgeInsets.only(left: 16.0),
                //     //       child: TextFormField(
                //     //         decoration: InputDecoration(
                //     //           labelText: "Enter Custom Parking",
                //     //           labelStyle: TextStyle(
                //     //             fontWeight: FontWeight.w600,
                //     //             fontSize: 13,
                //     //             color: Theme.of(context).brightness == Brightness.dark
                //     //                 ? Colors.grey.shade300
                //     //                 : Colors.black54,
                //     //           ),
                //     //           border: OutlineInputBorder(
                //     //             borderRadius: BorderRadius.circular(10),
                //     //             borderSide: BorderSide(
                //     //               color: Theme.of(context).brightness == Brightness.dark
                //     //                   ? Colors.grey.shade700
                //     //                   : Colors.grey.shade300,
                //     //             ),
                //     //           ),
                //     //           enabledBorder: OutlineInputBorder(
                //     //             borderRadius: BorderRadius.circular(10),
                //     //             borderSide: BorderSide(
                //     //               color: Theme.of(context).brightness == Brightness.dark
                //     //                   ? Colors.grey.shade700
                //     //                   : Colors.grey.shade300,
                //     //             ),
                //     //           ),
                //     //           focusedBorder: OutlineInputBorder(
                //     //             borderRadius: BorderRadius.circular(10),
                //     //             borderSide: BorderSide(
                //     //               color: Theme.of(context).brightness == Brightness.dark
                //     //                   ? Colors.blue.shade200
                //     //                   : Colors.blue.shade300,
                //     //               width: 2,
                //     //             ),
                //     //           ),
                //     //           contentPadding:
                //     //           const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                //     //           filled: true,
                //     //           fillColor: Theme.of(context).brightness == Brightness.dark
                //     //               ? Colors.grey.shade900
                //     //               : Colors.white,
                //     //         ),
                //     //
                //     //         onChanged: (val) => _customParking = val,
                //     //         validator: (val) =>
                //     //         _parking == 'Custom' && (val == null || val.isEmpty)
                //     //             ? "Enter custom parking type"
                //     //             : null,
                //     //       ),
                //     //     ),
                //     //   ),
                //   ],
                // ),

                Row(
                  children: [
                    // Dropdown for Car, Bike, Both
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Parking",
                        controller: TextEditingController(
                          text: _parking ?? '',
                        ),
                        onTap: () => _showBottomSheet(
                          options: ['Car', 'Bike', 'Both'],
                          onSelected: (val) {
                            setState(() {
                              _parking = val;
                            });
                          },
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select parking type" : null,
                      ),
                    ),
                  ],
                ),




                const SizedBox(height: 16),



                // Road Size

                Row(
                  children: [
                    // Near Metro
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Near Metro Station",
                        controller: _nearMetroController,
                        onTap: () => _showBottomSheet(
                          options: _metroOptions,
                          onSelected: (val) {
                            setState(() {
                              _nearMetroController.text = val;
                            });
                          },
                        ),
                        validator: (val) => val == null || val.isEmpty
                            ? "Select nearest metro station"
                            : null,
                      ),
                    ),
                    SizedBox(width: 16,),
                    // Highway
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Metro Distance",
                        controller: _highwayController,
                        onTap: () => _showBottomSheet(
                          options: ['200 m','300 m','400 m','500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km'],
                          onSelected: (val) {
                            setState(() {
                              _highwayController.text = val;
                            });
                          },
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select metro distance" : null,
                      ),
                    ),

                  ],
                ),



                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "Main Market Distance",
                        controller: _mainMarketController,
                        onTap: () => _showBottomSheet(
                          options: ['200 m','300 m','400 m','500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km'],
                          onSelected: (val) {
                            setState(() {
                              _mainMarketController.text = val;
                            });
                          },
                        ),
                        validator: (val) =>
                        val == null || val.isEmpty ? "Select main market distance" : null,
                      ),
                    ),

                    const SizedBox(width: 16),
                    // Flat Available (Date Picker)
                    Expanded(
                      child: TextFormField(
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
                        decoration: _buildInputDecoration(
                            context, "Flat Available From"),

                      ),
                    ),


                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: _buildReadOnlyField(
                        label: "House Meter Type",
                        controller: TextEditingController(
                            text: _houseMeter == 'Custom'
                                ? 'Custom'
                                : _houseMeter),
                        onTap: () =>
                            _showBottomSheet(
                              options: ['Commercial', 'Govt', 'Custom'],
                              onSelected: (val) {
                                setState(() {
                                  _houseMeter = val;
                                  if (val != 'Custom') {
                                    _houseMeterController.text =
                                        val; // assign directly
                                  } else {
                                    _houseMeterController
                                        .clear(); // clear so user can type in custom input field
                                  }
                                });
                              },
                            ),
                        validator: (val) =>
                        (_houseMeterController.text.isEmpty)
                            ? "Select house meter type"
                            : null,
                      ),
                    ),
                    // Custom input only when "Custom" is selected
                    if (_houseMeter == 'Custom') ...[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: TextFormField(
                            decoration: _buildInputDecoration(
                                context, "Enter Custom House Meter Type"),
                            onChanged: (val) => _houseMeterController.text = val,
                            // update same controller
                            validator: (val) =>
                            val == null || val.isEmpty
                                ? "Enter custom meter type"
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 16),

                // Owner Name
                TextFormField(
                  controller: _ownerNameController,
                  decoration: _buildInputDecoration(context, "Owner Name"),

                ),
                const SizedBox(height: 16),
                // Owner Number
                TextFormField(
                  controller: _ownerNumberController,
                  decoration:
                  _buildInputDecoration(context, "Owner Contact Number"),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],

                ),

                const SizedBox(height: 16),

                // Tarrish Garden
                // TextFormField(
                //   controller: _terraceGardenController,
                //   decoration: _buildInputDecoration(
                //       context, "Terrace/Garden Info"),
                // ),
                // const SizedBox(height: 16),


                DropdownButtonFormField<String>(
                  value: _furnishing,
                  decoration: _buildInputDecoration(context, "Furnishing"),
                  items: furnishingOptions.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(option),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      _furnishing = val;

                      // Clear previously selected furniture if not furnished
                      if (val == 'Unfurnished') {
                        _selectedFurniture.clear();
                      }
                    });
                  },
                  validator: (val) =>
                  val == null || val.isEmpty ? 'Please select furnishing' : null,
                ),
                if (_furnishing == 'Fully Furnished' || _furnishing == 'Semi Furnished')
                  GestureDetector(
                    onTap: () => _showFurnitureBottomSheet(context),
                    child: AbsorbPointer(
                      child: Padding(
                        padding:  EdgeInsets.only(top: 16.0),
                        child: TextFormField(
                          decoration: _buildInputDecoration(context, "Select Furniture Items"),
                          controller: TextEditingController(
                            text: _selectedFurniture.isEmpty
                                ? ''
                                : _selectedFurniture.entries
                                .map((e) => '${e.key} (${e.value})')
                                .join(', '),
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),

                FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_kitchenType?.isEmpty ?? true) {
                      return "Please select a kitchen type";
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Kitchen Type:",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [


                            // ✅ Western Style
                            ChoiceChip(
                              label: Text(
                                "Western Style",
                                style: TextStyle(
                                  color: _kitchenType == 'Western Style'
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _kitchenType == 'Western Style',
                              onSelected: (_) {
                                setState(() {
                                  _kitchenType = 'Western Style';
                                  state.didChange(_kitchenType);
                                });
                              },
                            ),

                            // ✅ Indian Style
                            ChoiceChip(
                              label: Text(
                                "Indian Style",
                                style: TextStyle(
                                  color: _kitchenType == 'Indian Style'
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _kitchenType == 'Indian Style',
                              onSelected: (_) {
                                setState(() {
                                  _kitchenType = 'Indian Style';
                                  state.didChange(_kitchenType);
                                });
                              },
                            ),

                            // ✅ No
                            ChoiceChip(
                              label: Text(
                                "No",
                                style: TextStyle(
                                  color: _kitchenType == 'No'
                                      ? Colors.white
                                      : Colors.black87,
                                ),
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _kitchenType == 'No',
                              onSelected: (_) {
                                setState(() {
                                  _kitchenType = 'No';
                                  state.didChange(_kitchenType);
                                });
                              },
                            ),
                          ],
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                //bathroom
                FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_bathroom?.isEmpty ?? true) {
                      return "Please select bathroom type";
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bathroom :",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 10,
                          runSpacing: 10,
                          children: [

                            ChoiceChip(
                              label: const Text("Western Style"),
                              labelStyle: TextStyle(
                                color: _bathroom == 'Western Style'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _bathroom == 'Western Style',
                              onSelected: (_) {
                                setState(() {
                                  _bathroom = 'Western Style';
                                  state.didChange(_bathroom); // ✅ tell FormField value changed
                                });
                              },
                            ),

                            ChoiceChip(
                              label: const Text("Indian Style"),
                              labelStyle: TextStyle(
                                color: _bathroom == 'Indian Style'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _bathroom == 'Indian Style',
                              onSelected: (_) {
                                setState(() {
                                  _bathroom = 'Indian Style';
                                  state.didChange(_bathroom); // ✅ tell FormField value changed
                                });
                              },
                            ),
                            ChoiceChip(
                              label: const Text("No"),
                              labelStyle: TextStyle(
                                color: _bathroom == 'No'
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              selectedColor: Colors.blueAccent,
                              backgroundColor: Colors.grey.shade200,
                              selected: _bathroom == 'No',
                              onSelected: (_) {
                                setState(() {
                                  _bathroom = 'No';
                                  state.didChange(_bathroom);
                                });
                              },
                            ),
                          ],
                        ),

                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),
                FormField<String>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_lift?.isEmpty ?? true) {
                      return "Please select Lift option";
                    }
                    return null;
                  },
                  builder: (FormFieldState<String> state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "Lift :",
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
                              onSelected: (_) {
                                setState(() => _lift = 'Yes');
                                state.didChange(_lift);
                              },
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
                              onSelected: (_) {
                                setState(() => _lift = 'No');
                                state.didChange(_lift);
                              },
                            ),
                          ],
                        ),
                        if (state.hasError)
                          Padding(
                            padding: const EdgeInsets.only(top: 5, left: 5),
                            child: Text(
                              state.errorText!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 16),



                // Field Worker Name
                TextFormField(
                  controller: _fieldWorkerNameController,
                  decoration: _buildInputDecoration(context, "Field Worker Name"),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _fieldWorkerNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(context, "Field Worker Number"),
                ),
                const SizedBox(height: 16),
                // Field Worker Address
                TextFormField(
                  controller: _fieldWorkerAddressController,
                  decoration: _buildInputDecoration(
                      context, "Field Worker Address"),
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Enter address"
                      : null,
                ),

                const SizedBox(height: 16),
                TextFormField(
                  controller: _careTakerNameController,
                  keyboardType: TextInputType.name,
                  decoration: _buildInputDecoration(
                      context, "Care Taker Name"),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _careTakerNumberController,
                  keyboardType: TextInputType.phone,
                  decoration: _buildInputDecoration(context, "Care Taker Number"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly, // allow only digits
                    LengthLimitingTextInputFormatter(10), // max 10 digits
                  ],

                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _videoLinkController,
                  // keyboardType: TextInputType.name,
                  decoration: _buildInputDecoration(
                      context, "Video Link"),
                ),



                const SizedBox(height: 16),
                Row(
                  children: [
                    FormField<File?>(
                      validator: (value) {
                        if (_imageFile == null) {
                          return "Please select an image";
                        }
                        return null;
                      },
                      builder: (FormFieldState<File?> field) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ElevatedButton(
                              onPressed: _pickImage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[300],
                                padding: EdgeInsets.zero,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              child: _imageFile != null
                                  ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.file(
                                  _imageFile!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              )
                                  : const SizedBox(
                                height: 100,
                                width: 100,
                                child: Center(
                                  child: Text(
                                    'Tap to select image',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 5, left: 8),
                                child: Text(
                                  field.errorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                ),

                // ElevatedButton(
                //   onPressed: pickMultipleImages,
                //   child: Text("Choose Multiple Images"),
                // ),
                const SizedBox(height: 16),

                FormField<List<XFile>>(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (_) {
                    if (_images.isEmpty) {
                      return "Please upload at least one image";
                    }
                    return null;
                  },
                  builder: (field) => Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Upload Multiple Images',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),

                          // Show number of selected images
                          Text(
                            'Images selected: ${_images.length}',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 10),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                // Show image list
                                for (int i = 0; i < _images.length; i++)
                                  Stack(
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.symmetric(horizontal: 6),
                                        width: 100,
                                        height: 100,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: FileImage(File(_images[i].path)),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      // ❌ Remove button
                                      Positioned(
                                        right: 0,
                                        top: 0,
                                        child: GestureDetector(
                                          onTap: () {
                                            _removeImage(i);
                                            field.validate(); // re-check validation
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: const BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(Icons.close, size: 20, color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                // Show "Tap to select" only if no image selected
                                if (_images.isEmpty)
                                  ElevatedButton(
                                    onPressed: () {
                                      pickMultipleImages();
                                      field.validate(); // re-check validation
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade600,
                                    ),
                                    child: const Text(
                                      'Tap to select Multiple image',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(fontSize: 12, color: Colors.white),
                                    ),
                                  ),

                                // Optional: Always show an add image button
                                if (_images.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      pickMultipleImages();
                                      field.validate(); // re-check validation
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 6),
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: const Icon(Icons.add_a_photo, color: Colors.black54),
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Show validation error
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 5, left: 8),
                              child: Text(
                                field.errorText!,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16,),

                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white10
                            : Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white10
                              : Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black26
                                : Color(0xFFEDF2F7),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _Google_Location,
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Color(0xFF2D3748),
                        ),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          hintText: 'Enter your address',
                          hintStyle: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.grey.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                          prefixIcon: Icon(
                            Icons.location_on_rounded,
                            color: Colors.blue.shade300,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    FormField<String>(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (_) {
                        if (_Google_Location.text.trim().isEmpty) {
                          return "Please fetch current location";
                        }
                        return null;
                      },
                      builder: (field) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final status = await Permission.location.request();
                              if (!status.isGranted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Location permission is required')),
                                );
                                return;
                              }

                              try {
                                final savedLocation = await getSavedLatLong();

                                double latitude = double.tryParse(
                                  savedLocation['Latitude']!.replaceAll(RegExp(r'[^\d\.\-]'), ''),
                                ) ??
                                    0.0;
                                double longitude = double.tryParse(
                                  savedLocation['Longitude']!.replaceAll(RegExp(r'[^\d\.\-]'), ''),
                                ) ??
                                    0.0;

                                List<Placemark> placemarks =
                                await placemarkFromCoordinates(latitude, longitude);

                                String output = 'Unable to fetch location';
                                if (placemarks.isNotEmpty) {
                                  Placemark place = placemarks.first;
                                  output =
                                  '${place.street}, ${place.subLocality}, ${place.locality}, '
                                      '${place.subAdministrativeArea}, ${place.administrativeArea}, '
                                      '${place.country}, ${place.postalCode}';
                                }

                                setState(() {
                                  full_address = output;
                                  _Google_Location.text = full_address;
                                });

                                field.validate(); // 🔹 refresh validator after setting value
                              } catch (e) {
                                print('Error: ${e.toString()}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Failed to get address: ${e.toString()}')),
                                );
                              }
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade200,
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                                border: Border.all(
                                  color: Colors.blue.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: const Center(
                                child: Text(
                                  'Get Current Location',
                                  style: TextStyle(
                                    fontFamily: 'PoppinsBold',
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          // 🔹 Validation error message
                          if (field.hasError)
                            Padding(
                              padding: const EdgeInsets.only(top: 6, left: 4),
                              child: Text(
                                field.errorText!,
                                style: const TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                // Submit Button

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_isSubmitting || _isButtonDisabled)
                        ? null
                        : () async {
                            // 🔹 Validate form before countdown
                            if (!_formKey.currentState!.validate()) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text(
                                    "Form Incomplete",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  content: const Text(
                                    "Please fill all the required fields before submitting.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: const Text("OK"),
                                    )
                                  ],
                                ),
                              );
                              return; // ❌ stop here, don't show countdown
                            }

                            // ✅ If form is valid → show countdown
                            setState(() {
                              _isButtonDisabled = true;
                            });

                            int countdown = 3;

                            // Show dialog
                            await showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setStateDialog) {
                                    // Start countdown
                                    Future.delayed(const Duration(seconds: 1),
                                        () async {
                                      if (countdown > 1) {
                                        setStateDialog(() {
                                          countdown--;
                                        });
                                      } else {
                                        // ✅ When countdown finishes
                                        setStateDialog(() {
                                          countdown = 0;
                                        });

                                        await Future.delayed(
                                            const Duration(seconds: 1));
                                        if (Navigator.of(context).canPop()) {
                                          Navigator.of(context)
                                              .pop(); // close dialog
                                        }

                                        // Run submit after countdown ends
                                        await _checkFormAndSubmit();

                                        if (!mounted) return;

                                        // Show success message
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "✅ Submitted Successfully!"),
                                            backgroundColor: Colors.green,
                                          ),
                                        );

                                        // Navigate back after short delay
                                        await Future.delayed(
                                            const Duration(seconds: 1));
                                        if (mounted)
                                          Navigator.of(context).pop();
                                      }
                                    });

                                    return AlertDialog(
                                      backgroundColor:
                                          Theme.of(context).brightness ==
                                                  Brightness.dark
                                              ? Colors.grey[900]
                                              : Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      title: const Text(
                                        "Submitting...",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 500),
                                            transitionBuilder: (child,
                                                    animation) =>
                                                ScaleTransition(
                                                    scale: animation,
                                                    child: child),
                                            child: countdown > 0
                                                ? Text(
                                                    "$countdown",
                                                    key: ValueKey<int>(
                                                        countdown),
                                                    style: TextStyle(
                                                      fontSize: 40,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.red[300]
                                                          : Colors.red,
                                                    ),
                                                  )
                                                : const Icon(
                                                    Icons.verified_rounded,
                                                    key: ValueKey<String>(
                                                        "verified"),
                                                    color: Colors.green,
                                                    size: 60,
                                                  ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            countdown > 0
                                                ? "Please wait..."
                                                : "Verified!",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Theme.of(context)
                                                          .brightness ==
                                                      Brightness.dark
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            );

                            // Reset state
                            if (mounted) {
                              setState(() {
                                _isButtonDisabled = false;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _checkFormAndSubmit() async {
    final Map<String, dynamic> fields = {
      'Location': _location,
      'Flat Number': _flatNumberController.text,
      'Buy/Rent': _buyOrRent,
      'Apartment Address': _apartmentAddressController.text,
      'Property Type': _propertyType,
      'BHK': _bhk == "Custom" ? _customBhk : _bhk,
      'Price': _priceController.text,
      'Last Price': _lastPriceController.text,
      'Asking Price': _askingPriceController.text,
      'Floor': _floor,
      'Total Floor': _totalFloorController.text,
      'Balcony': _balcony,
      'Square Feet': _squareFeetController.text,
      'Maintenance': _maintenance == "Custom" ? _customMaintenance : _maintenance,
      'Parking': _parking,
      'Property Age': _propertyAge,
      'Field Worker Address': _fieldWorkerAddressController.text,
      'Road Size': _roadSizeController.text,
      'Metro Distance': _nearMetroController.text,
      'Highway Distance': _highwayController.text,
      'Main Market Distance': _mainMarketController.text,
      'House Meter': _houseMeter == "Custom" ? _houseMeterController.text : _houseMeter,
      'Kitchen Type': _kitchenType,
      'Bathroom': _bathroom,
      'Lift': _lift,
      'Facility': _facilityController.text,
      'Furnishing': _furnishing,
      'Full Address': full_address,
      'Main Image': _imageFile?.path,
    };

    // 🔴 Reset old errors
    setState(() {
      _fieldErrors.clear();
    });

    // Find empty fields
    final emptyFields = fields.entries
        .where((entry) => entry.value == null || entry.value.toString().trim().isEmpty)
        .map((e) => e.key)
        .toList();

    if (emptyFields.isNotEmpty) {
      // Mark errors
      setState(() {
        for (var field in emptyFields) {
          _fieldErrors[field] = true;
        }
      });

      // Show toast
      Fluttertoast.showToast(
        msg: "Please fill out: ${emptyFields.join(', ')}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 14.0,
      );
      return;
    }

    // ✅ No errors → submit
    _submitForm();
  }

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
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isDark ? Colors.blue.shade200 : Colors.blue.shade300,
            width: 2),
      ),

      // 🔴 Add these two
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red, width: 2),
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
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
              color: isDark ? Colors.grey.shade300 : Colors.black54,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: isDark ? Colors.blue.shade200 : Colors.blue.shade300,
                width: 2,
              ),
            ),

            // 🔴 Added for validation error
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),

            contentPadding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: 14,
            ),
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            filled: true,
            fillColor: isDark ? Colors.grey.shade900 : Colors.white,
          ),
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
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
      builder: (context) =>
          DraggableScrollableSheet(
            expand: false,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            initialChildSize: options.length <= 5 ? 0.4 : 0.6,
            builder: (context, scrollController) =>
                ListView.builder(
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    return ListTile(
                      title: Text(
                        option,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500,
                            fontFamily: "Poppins"
                        ),
                      ),
                      onTap: () => Navigator.pop(context, option),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 8),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(8)),
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

  bool _isSubmitting = false;

  void _submitForm() async {
    if (_isSubmitting) return;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSubmitting = true;
      });

      final prefs = await SharedPreferences.getInstance();

      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId.toString();
      final propertyId = provider.latestPropertyId.toString();
      String? name = prefs.getString('name');
      String? number = prefs.getString('number');
      final uri = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_main_realestate_propperty.php");
      var request = http.MultipartRequest('POST', uri);

      request.fields['locations'] = _location ?? '';
      request.fields['Flat_number'] = _flatNumberController.text;
      request.fields['Buy_Rent'] = _buyOrRent ?? '';
      request.fields['Residence_Commercial'] = _resOrComm ?? '';
      request.fields['Apartment_Address'] = _apartmentAddressController.text;
      request.fields['Typeofproperty'] = _propertyType ?? '';
      request.fields['Bhk'] = (_bhk == "Custom" ? _customBhk ?? '' : _bhk) ?? '';
      request.fields['show_Price'] = _formattedPrice.isNotEmpty ? _formattedPrice : _priceController.text.replaceAll(',', '').trim();
      request.fields['Last_Price'] = _formattedLastPrice.isNotEmpty
          ? _formattedLastPrice
          : _lastPriceController.text.replaceAll(',', '').trim();
      request.fields['asking_price'] = _formattedAskingPrice.isNotEmpty
          ? _formattedAskingPrice
          : _askingPriceController.text.replaceAll(',', '').trim();
      request.fields['Floor_'] = _floor ?? '';
      request.fields['Total_floor'] = _totalFloorController.text;
      request.fields['Balcony'] = _balcony ?? '';
      request.fields['squarefit'] = _squareFeetController.text;
      request.fields['maintance'] = (_maintenance == "Custom" ? _customMaintenance ?? '' : _maintenance) ?? '';
      request.fields['parking'] = _parking ?? '';
      request.fields['age_of_property'] = _propertyAge ?? '';
      request.fields['fieldworkar_address'] = _fieldWorkerAddressController.text;
      request.fields['Road_Size'] = _roadSizeController.text;
      request.fields['metro_distance'] = _nearMetroController.text;
      request.fields['highway_distance'] = _highwayController.text;
      request.fields['main_market_distance'] = _mainMarketController.text;
      request.fields['meter'] = (_houseMeter == "Custom" ? _houseMeterController.text : (_houseMeter ?? ''));
      request.fields['owner_name'] = _ownerNameController.text;
      request.fields['owner_number'] = _ownerNumberController.text;
      request.fields['video_link'] = _videoLinkController.text;
      print("Video link field value: '${_videoLinkController.text}'");
      request.fields['current_dates'] = DateFormat('yyyy-MM-dd').format(DateTime.now());
      request.fields['available_date'] = _flatAvailableDate?.toIso8601String() ?? '';
      request.fields['kitchen'] = _kitchenType ?? '';
      request.fields['bathroom'] = _bathroom ?? '';
      request.fields['live_unlive'] = 'Live';
      request.fields['lift'] = _lift ?? '';
      request.fields['Facility'] = _facilityController.text;
// Map UI value -> backend value (change to 'Semi Furnished' / 'Fully Furnished' if your API wants full labels)
      String _furnishingForBackend(String? val) {
        switch (val) {
          case 'Semi Furnished':  return 'Semi Furnished';
          case 'Fully Furnished': return 'Fully Furnished';
          default:                return 'Unfurnished';
        }
      }

      final bool isFurnished = _furnishing == 'Semi Furnished' || _furnishing == 'Fully Furnished';

// Build "Fan (1), Light (2)" string (only items with qty > 0)
      final String furnitureList = (_selectedFurniture.entries)
          .where((e) => (e.value) > 0)
          .map((e) => '${e.key} (${e.value})')
          .join(', ')
          .trim();

// Always send clean furnished flag
      request.fields['furnished_unfurnished'] = _furnishingForBackend(_furnishing);

// Send furniture details (or "No Furniture" to avoid NULL)
      request.fields['Apartment_name'] = isFurnished
          ? (furnitureList.isNotEmpty ? furnitureList : 'No Furniture')
          : 'No Furniture';

// (Optional) debug logs to see exactly what's going out:
      print('=> furnished_unfurnished: ${request.fields['furnished_unfurnished']}');
      print('=> Apartment_name: ${request.fields['Apartment_name']}');

      request.fields['field_warkar_name'] = name!;
      request.fields['field_workar_number'] = number!;
      request.fields['care_taker_name'] = _careTakerNameController.text;
      request.fields['care_taker_number'] = _careTakerNumberController.text;
      request.fields['registry_and_gpa'] = _registryAndGpa ?? '';
      request.fields['loan'] = _loan ?? '';
      request.fields['field_worker_current_location'] = full_address ?? '';

      final lat = prefs.getDouble('latitude');
      final long = prefs.getDouble('longitude');
      request.fields['Latitude'] = lat?.toString() ?? '';
      request.fields['Longitude'] = long?.toString() ?? '';

      // Add single main image
      if (_imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'property_photo',
          _imageFile!.path,
        ));
      }

      // ✅ Add multiple images to "images[]"
      for (int i = 0; i < _images.length; i++) {
        File imageFile = File(_images[i].path);
        request.files.add(await http.MultipartFile.fromPath(
          'images[]', // Must match your PHP input name
          imageFile.path,
        ));
      }

      try {
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        print('Status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          int propertyId = 0;

          if (data['status'] == 'success' && data['P_id'] != null) {
            propertyId = data['P_id'];
          }

          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();
              messenger.showSnackBar(
                SnackBar(
                  content: Text("Successfully Registered, Property ID: $propertyId"),
                  backgroundColor: Colors.green,
                ),
              );

              // Only pop after a successful response
              Future.delayed(const Duration(milliseconds: 50), () {
                Navigator.pop(context);
              });
            });
          }
        } else {
          if (mounted) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final messenger = ScaffoldMessenger.of(context);
              messenger.clearSnackBars();
              messenger.showSnackBar(
                SnackBar(
                  content: Text("Failed to upload data. Status code: ${response.statusCode}"),
                  backgroundColor: Colors.red,
                ),
              );
            });
          }
        }
      } catch (e) {
        if (mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            messenger.showSnackBar(
              SnackBar(
                content: Text("Error: $e"),
                backgroundColor: Colors.red,
              ),
            );
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
        }
      }

    }
  }
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('number');
    await prefs.remove('name');
  }
  void _showFacilitySelectionDialog() async {
    final result = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _FacilityBottomSheet(
        options: allFacilities,
        selected: selectedFacilities,
      ),
    );

    if (result != null) {
      setState(() {
        selectedFacilities = result;
        _facilityController.text = selectedFacilities.join(', ');
      });
    }
  }
  void _showFurnitureBottomSheet(BuildContext context) {
    final List<String> furnitureItems = [
      'Fan',
      'Light',
      'Wardrobe',
      'AC',
      'Washing Machine',
      'Refrigerator',
      'Modular Kitchen',
      'Chimney',
      'Single Bed',
      'Double Bed',
      'Geyser',
      'Led Tv',
      'Sofa Set',
      'Dining Table',
      'Induction',
      'Gas Stove',
    ];

    final Map<String, int> tempSelection = Map.from(_selectedFurniture);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets, // ensures keyboard doesn't hide content
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Furniture',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.4, // Limit height
                      child: SingleChildScrollView(
                        child: Column(
                          children: furnitureItems.map((item) {
                            final isSelected = tempSelection.containsKey(item);

                            return InkWell(
                              onTap: () {
                                setModalState(() {
                                  if (isSelected) {
                                    tempSelection.remove(item);
                                  } else {
                                    tempSelection[item] = 1;
                                  }
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.blue,
                                          value: isSelected,
                                          onChanged: (checked) {
                                            setModalState(() {
                                              if (checked == true) {
                                                tempSelection[item] = 1;
                                              } else {
                                                tempSelection.remove(item);
                                              }
                                            });
                                          },
                                        ),
                                        Text(item, style: const TextStyle(fontSize: 16)),
                                      ],
                                    ),
                                    if (isSelected)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline),
                                            onPressed: () {
                                              setModalState(() {
                                                if (tempSelection[item]! > 1) {
                                                  tempSelection[item] = tempSelection[item]! - 1;
                                                }
                                              });
                                            },
                                          ),
                                          Text('${tempSelection[item]}'),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline),
                                            onPressed: () {
                                              setModalState(() {
                                                tempSelection[item] = tempSelection[item]! + 1;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedFurniture = Map.fromEntries(
                            tempSelection.entries.where((e) => e.value > 0),
                          );
                        });

                        // Print all selected furniture and their quantities
                        _selectedFurniture.forEach((item, quantity) {
                          print('$item: $quantity');
                        });

                        Navigator.pop(ctx);
                      },
                      child: const Text("Save Selection"),
                    ),
                    SizedBox(
                      height: 50 // 2% of screen height
                    ),

                  ],
                ),
              );
            },
          ),
        );
      },
    );
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
class _FacilityBottomSheet extends StatefulWidget {
  final List<String> options;
  final List<String> selected;

  const _FacilityBottomSheet({
    required this.options,
    required this.selected,
  });

  @override
  State<_FacilityBottomSheet> createState() => _FacilityBottomSheetState();
}

class _FacilityBottomSheetState extends State<_FacilityBottomSheet> {
  late List<String> _tempSelected;

  @override
  void initState() {
    super.initState();
    _tempSelected = List.from(widget.selected);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Select Facilities",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...widget.options.map((option) {
              final isSelected = _tempSelected.contains(option);
              return CheckboxListTile(
                title: Text(option),
                value: isSelected,
                onChanged: (val) {
                  setState(() {
                    if (val == true) {
                      _tempSelected.add(option);
                    } else {
                      _tempSelected.remove(option);
                    }
                  });
                },
              );
            }).toList(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, _tempSelected),
              child: const Text("Done"),
            ),
            SizedBox(height: 40,)
          ],
        ),
      ),
    );

  }
}
