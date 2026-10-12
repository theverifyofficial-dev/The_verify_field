import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Custom_Widget/constant.dart';
import 'New_Update/add_image_under_futureproperty.dart';
import 'New_Update/flat_edit_model.dart';
import '../utilities/heic_converter.dart';


class _StepMeta {
  final String title;
  final String hinglish;
  final IconData icon;
  const _StepMeta(this.title, this.hinglish, this.icon);
}

class DuplicateFutureProperty extends StatefulWidget {
  String id;
  String building_id;

  DuplicateFutureProperty({
    super.key,
    required this.id,
    required this.building_id,
  });

  @override
  DuplicateFuturePropertyState createState() => DuplicateFuturePropertyState();
}

class DuplicateFuturePropertyState extends State<DuplicateFutureProperty> {

  bool _isLoading = false;

  // ---- Wizard step state & design tokens (added for stepped UI) ----
  int _stepIndex = 0;

  static const Color _kPrimary = Color(0xFF0F6E5C);
  static const Color _kAccent = Color(0xFFE98A15);
  static const Color _kSurface2 = Color(0xFFF1EEE6);
  static const Color _kBorder = Color(0xFFE2DCCB);

  static const List<_StepMeta> _steps = [
    _StepMeta('Photo', 'Property ki Photo', Icons.photo_camera_outlined),
    _StepMeta('Basic Details', 'Basic Jaankari', Icons.home_work_outlined),
    _StepMeta('Deal Type', 'Deal Kis Tarah ki Hai', Icons.swap_horiz_outlined),
    _StepMeta('Condition & Facilities', 'Property ki Condition', Icons.chair_outlined),
    _StepMeta('Price & Charges', 'Daam aur Charges', Icons.currency_rupee_outlined),
    _StepMeta('Extra Info', 'Aitirikt Jaankari (Optional)', Icons.info_outline),
  ];

  final TextEditingController _FlatNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _sqft = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _ApartmentName = TextEditingController();
  final TextEditingController _showPrice = TextEditingController();
  final TextEditingController _lastPrice = TextEditingController();
  final TextEditingController _askingPrice = TextEditingController();
  final TextEditingController _meter = TextEditingController();
  final TextEditingController field_address = TextEditingController();
  final TextEditingController _Apartment_Address = TextEditingController();
  final TextEditingController furnitureController = TextEditingController();
  TextEditingController _customMaintenanceController = TextEditingController();

  late TextEditingController _maintenanceController;
  String? _maintenance;
  String? _customMaintenance;
  bool _isSubmitting = false;
  int _countdown = 0;
  Timer? _countdownTimer;




  String? _residenceCommercial;
  String? selectedPropertyType;
  String? _totalFloor;
  String? selectedBHK;
  String? _selectedItem;
  String? _networkImageUrl;

  final List<String> bhkOptions = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial',''];
  String? _lift, _registry, _loan;
  String? resident_commercial,bhk,parking,balcony,kitchen,bathroom;
  DateTime? _availableDate;

  File? _imageFile;
  List<File> _multipleImages = [];  // ALL extra images (API + new)


  String long = '';
  String lat = '';
  String _number = '';
  String _name = '';
  String _date = '';
  final _formKey = GlobalKey<FormState>();
  List<String> selectedFacilities=[];

  String? _furnishing;
  String? _ageOfProperty;
  String? _roadSize;
  String? _metroDistance;
  String? _highwayDistance;
  String? _mainMarketDistance;
  String? _facilityFromApi;

  String? _apiLongitude;
  String? _apiLatitude;


  DateTime now = DateTime.now();

  late String formattedDate;
  String formatPrice(int value) {
    if (value >= 10000000) {
      return '${(value / 10000000).toStringAsFixed(2)}Cr';
    } else if (value >= 100000) {
      return '${(value / 100000).toStringAsFixed(2)}L';
    } else {
      return value.toString();
    }
  }


  String _formattedLastPrice = '';
  String _formattedPrice = '';
  String _formattedAskingPrice = '';
  String? apiImageUrl;


  @override
  void initState() {
    super.initState();
    _loaduserdata();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      autofillFormFields(); // ✅ AFTER build
    });

    _maintenanceController = TextEditingController();
    getFurnishingStringForApi();
    // Add listener for _priceController
    _showPrice.addListener(() {
      final input = _showPrice.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);
      setState(() {
        _formattedPrice = number != null ? formatPrice(number) : '';
      });
    });
    _lastPrice.addListener(() {
      final input = _lastPrice.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);
      setState(() {
        _formattedLastPrice = number != null ? formatPrice(number) : '';
      });
    });
    _askingPrice.addListener(() {
      final input = _askingPrice.text.replaceAll(',', '').trim();
      final number = int.tryParse(input);
      setState(() {
        _formattedAskingPrice = number != null ? formatPrice(number) : '';
      });
    });
  }

  DateTime uploadDate = DateTime.now();
  final dateFormatter = DateFormat('yyyy-MM-dd');



  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await HeicConverter.pickImage(picker, source: ImageSource.gallery);

    formattedDate = "${now.day}_${now.month}_${now.year}";

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/verify_${formattedDate}_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85,
    );

    return result;
  }
  String getFurnishingStringForApi() {
    if (_furnishing == null || _furnishing == 'Unfurnished') {
      return 'Unfurnished';
    } else if (_selectedFurniture.isNotEmpty) {
      // Only send furniture items for Semi/Fully Furnished
      return _selectedFurniture.entries
          .map((e) => '${e.key} (${e.value})')
          .join(', ');
    } else {
      // If nothing selected, just send furnishing type
      return _furnishing!;
    }
  }


  Future<void> duplicateFlatSubmit(File? imageFile) async {
    print("🚀 duplicateFlatSubmit() CALLED");

    final uploadUrl = Uri.parse(
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/add_flat_in_future_property.php',
    );

    print("🌍 API URL: $uploadUrl");

    final request = http.MultipartRequest('POST', uploadUrl);



    if (imageFile != null) {
      print("📸 Image selected: ${imageFile.path}");
      request.files.add(
        await http.MultipartFile.fromPath(
          'property_photo',
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      );
    } else {
      print("⚠️ No image selected (imageFile == null)");
    }

    // 🖼️ MULTIPLE IMAGES
    for (int i = 0; i < _multipleImages.length; i++) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'images[]',
          _multipleImages[i].path,
          filename: _multipleImages[i].path.split('/').last,
        ),
      );
    }

    // 🧾 Fields
    final fields = {
      // ---------------- BASIC ----------------
      "owner_name": _Ownername.text.trim(),
      "owner_number": _Owner_number.text.trim(),
      "care_taker_name": _CareTaker_name.text.trim(),
      "care_taker_number": _CareTaker_number.text.trim(),
      "video_link": _videoLink.text.trim(),

      "locations": _selectedItem ?? '',
      "Buy_Rent": _selectedItem1 ?? '',
      "Residence_Commercial": _residenceCommercial ?? '',
      "Typeofproperty": selectedPropertyType ?? '',
      "Bhk": selectedBHK ?? '',
      "Floor_": _floor1 ?? '',
      "Total_floor": _totalFloor ?? '',
      "squarefit": _sqft.text.trim(),

      "Balcony": balcony ?? '',
      "parking": parking ?? '',
      "kitchen": kitchen ?? '',
      "bathroom": bathroom ?? '',
      "lift": _lift ?? '',

      "registry_and_gpa": _registry ?? '',
      "loan": _loan ?? '',
      "furnished_unfurnished": _furnished ?? '',

      "Apartment_name": _ApartmentName.text.trim(),
      "Apartment_Address": _Apartment_Address.text.trim(),
      "fieldworkar_address": field_address.text.trim(),
      "field_worker_current_location": _Google_Location.text.trim(),

      // ---------------- PRICE ----------------
      "maintance": _maintenance == "Custom"
          ? (_customMaintenance ?? '')
          : (_maintenance ?? ''),

      "show_Price": _showPrice.text.trim(),
      "Last_Price": _lastPrice.text.trim(),
      "asking_price": _askingPrice.text.trim(),


      "meter": _meter.text.trim().isNotEmpty
          ? _meter.text.trim()
          : (_houseMeter ?? ''),
      "current_dates": dateFormatter.format(uploadDate),
      "available_date": _availableDate != null
          ? dateFormatter.format(_availableDate!)
          : '',

      "Flat_number": _FlatNumber.text.trim(),
      "live_unlive": "Book", // <-- Static value sent to API


      // ---------------- 🔥 REQUIRED BUT HIDDEN ----------------
      "age_of_property": _ageOfProperty ?? '',
      "Road_Size": _roadSize ?? '',
      "metro_distance": _metroDistance ?? '',
      "highway_distance": _highwayDistance ?? '',
      "main_market_distance": _mainMarketDistance ?? '',
      "Facility": selectedFacilities.isNotEmpty
          ? selectedFacilities.join(',')
          : (_facilityFromApi ?? ''),

      "Longitude": _Longitude.text.trim().isNotEmpty
          ? _Longitude.text.trim()
          : (_apiLongitude ?? ''),

      "Latitude": _Latitude.text.trim().isNotEmpty
          ? _Latitude.text.trim()
          : (_apiLatitude ?? ''),

      // ---------------- META ----------------
      "field_warkar_name": _name,
      "field_workar_number": _number,
      "subid": widget.building_id,
    };

    request.fields.addAll(fields);

    print("🧾 REQUEST FIELDS:");
    fields.forEach((key, value) {
      print("   🔹 $key = '$value'");
    });

    try {
      print("⏳ Sending request...");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("✅ STATUS CODE: ${response.statusCode}");
      print("📩 RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        print("🎉 SUCCESS");
        showSnack("Property Updated Successfully");
        Navigator.pop(context);
      } else {
        print("❌ SERVER ERROR");
        showSnack("Unexpected server response");
      }
    } catch (e, st) {
      print("🔥 HTTP EXCEPTION OCCURRED");
      print("❌ ERROR: $e");
      print("📍 STACK TRACE:\n$st");
      rethrow;
    } finally {
      print("🔚 duplicateFlatSubmit() FINISHED");
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Map<String, int> parseFurnitureString(String furnitureString) {
    if (furnitureString.isEmpty) return {};

    final Map<String, int> furnitureMap = {};

    furnitureString.split(',').forEach((item) {
      item = item.trim(); // remove extra spaces
      final match = RegExp(r'(.+)\((\d+)\)').firstMatch(item);
      if (match != null) {
        final name = match.group(1)?.trim() ?? '';
        final count = int.tryParse(match.group(2) ?? '0') ?? 0;
        if (name.isNotEmpty) {
          furnitureMap[name] = count;
        }
      }
    });

    return furnitureMap;
  }


  void parseFurnishingFromApi(String apiString) {
    if (apiString.isEmpty || apiString == 'Unfurnished') {
      _furnishing = 'Unfurnished';
      _selectedFurniture.clear();
      furnitureController.text = 'Semi Furnished';
      return;
    }

    final furnishingType = apiString.split('(').first.trim();
    _furnishing = furnishingType;

    final furnitureMap = <String, int>{};

    final start = apiString.indexOf('(');
    final end = apiString.lastIndexOf(')');
    if (start != -1 && end != -1 && end > start) {
      final inner = apiString.substring(start + 1, end);
      final items = inner.split(',');

      for (var item in items) {
        final match = RegExp(r'(.+?)\s*\((\d+)\)').firstMatch(item.trim());
        if (match != null) {
          final name = match.group(1)!.trim();
          final count = int.parse(match.group(2)!);
          furnitureMap[name] = count;
        }
      }
    }

    _selectedFurniture = furnitureMap;
    furnitureController.text = furnitureMap.entries
        .map((e) => '${e.key} (${e.value})')
        .join(', ');
  }



  Map<String, int> _selectedFurniture = {};
  final List<String> furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];
  void _showFurnitureBottomSheet(BuildContext context) {
    final List<String> furnitureItems = [
      'Fan', 'Light', 'Refrigerator', 'Washing Machine',
      'Wardrobe', 'AC','Water Purifier', 'Modular Kitchen', 'Chimney',
      'Single Bed', 'Double Bed', 'Geyser', 'Led Tv',
      'Sofa Set', 'Dining Table', 'Induction', 'Gas Stove','',
    ];

    // 👇 clone current selection so it shows already selected items ticked
    Map<String, int> tempSelection = Map.from(_selectedFurniture);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: MediaQuery.of(ctx).viewInsets,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: _kBorder,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      const Text(
                        'Select Furniture',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: SingleChildScrollView(
                          child: Column(
                            children: furnitureItems.map((item) {
                              // 👇 auto-tick if exists in tempSelection
                              final isSelected = tempSelection.containsKey(item);

                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: _kPrimary,
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
                                        Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isSelected)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.remove_circle_outline, color: Colors.black54),
                                            onPressed: () {
                                              setModalState(() {
                                                if (tempSelection[item]! > 1) {
                                                  tempSelection[item] =
                                                      tempSelection[item]! - 1;
                                                }
                                              });
                                            },
                                          ),
                                          Text(
                                            '${tempSelection[item]}',
                                            style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.add_circle_outline, color: Colors.black54),
                                            onPressed: () {
                                              setModalState(() {
                                                tempSelection[item] =
                                                    tempSelection[item]! + 1;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          ),
                          onPressed: () {
                            setState(() {
                              // 👇 update global selected furniture
                              _selectedFurniture = Map.fromEntries(
                                tempSelection.entries.where((e) => e.value > 0),
                              );

                              // 👇 update textfield with items + counts
                              furnitureController.text = _selectedFurniture.entries
                                  .map((e) => '${e.key} (${e.value})')
                                  .join(', ');
                            });
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Save Selection',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _FlatNumber.dispose();
    _address.dispose();
    _sqft.dispose();
    _maintenanceController.dispose();
    _Building_information.dispose();
    _Google_Location.dispose();
    _ApartmentName.dispose();
    _showPrice.dispose();
    _lastPrice.dispose();
    _askingPrice.dispose();
    _meter.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }

  DateTime? _parseApiDate(dynamic raw) {
    if (raw == null) return null;
    final str = raw.toString().trim();
    if (str.isEmpty) return null;

    // Try ISO first
    final iso = DateTime.tryParse(str);
    if (iso != null) return iso;

    // Try dd-MM-yyyy
    try {
      return DateFormat("dd-MM-yyyy").parseStrict(str);
    } catch (_) {}

    // Try dd/MM/yyyy
    try {
      return DateFormat("dd/MM/yyyy").parseStrict(str);
    } catch (_) {}

    // Couldn’t parse
    print("DEBUG: Unrecognized date format from API → $str");
    return null;
  }
  static const String imageBaseUrl =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/";

  Future<List<Property1>> fetchData() async {
    final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/fecth_data_dublicate_flat.php?id=${widget.id}"
    );

    final response = await http.get(url);
    final decoded = json.decode(response.body);

    if (decoded is Map<String, dynamic>) {
      final flat = decoded['flat'];
      final List images = decoded['multiple_images'] ?? [];

      if (flat != null) {
        final model = Property1.fromJson(flat);

        // ✅ convert relative paths → full URLs
        model.multipleImages = images
            .map<String>((e) => imageBaseUrl + e)
            .toList();

        return [model];
      }
    }
    return [];
  }

  String? matchDropdown(String? apiValue, List<String> items) {
    if (apiValue == null) return null;

    try {
      return items.firstWhere(
            (e) => e.trim().toLowerCase() == apiValue.trim().toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }

  Future<File?> downloadImageAsFile(String imageUrl) async {
    try {
      print("⬇️ Downloading API image: $imageUrl");

      final response = await http.get(Uri.parse(imageUrl));
      if (response.statusCode != 200) {
        print("❌ Failed to download image");
        return null;
      }

      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/api_${DateTime.now().microsecondsSinceEpoch}_${imageUrl.hashCode}.jpg';


      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      print("✅ API image saved as File: $filePath");
      return file;
    } catch (e) {
      print("🔥 Image download error: $e");
      return null;
    }
  }


  Future autofillFormFields() async {
    try {
      final dataList = await fetchData();
      if (dataList.isEmpty || !mounted) return;

      final data = dataList.first;

      // 1️⃣ Download everything FIRST
      File? mainImage;
      if (data.propertyPhoto.isNotEmpty) {
        mainImage = await downloadImageAsFile(
          "$imageBaseUrl${data.propertyPhoto}",
        );
      }

      final List<File> downloadedMultiple = [];
      for (final url in data.multipleImages) {
        final f = await downloadImageAsFile(url);
        if (f != null) downloadedMultiple.add(f);
      }

      if (!mounted) return;

      // 2️⃣ ONE clean setState (NO async)
      setState(() {
        _imageFile = mainImage;
        _multipleImages = downloadedMultiple;

        selectedPropertyType =
            matchDropdown(data.typeOfProperty, _typeofproperty);
        selectedBHK = matchDropdown(data.bhk, bhkOptions);
        _selectedItem1 = matchDropdown(data.buyRent, buy_rent);
        _registry = matchDropdown(data.registryAndGpa, registryOptions);
        _loan = matchDropdown(data.loan, yesNoOptions);
        balcony = matchDropdown(data.balcony, _balcony_items);
        parking = matchDropdown(data.parking, _Parking_items);
        kitchen = matchDropdown(data.kitchen, _kitchen_items);
        bathroom = matchDropdown(data.bathroom, _bathroom_items);
        _floor1 = matchDropdown(data.floor, _items_floor1);
        _lift = matchDropdown(data.lift, yesNoOptions);
        _houseMeter = matchDropdown(data.meter, meter_Options );

        _furnished =
            matchDropdown(data.furnishedUnfurnished, furnishingOptions);

        _residenceCommercial = data.residenceCommercial;
        _selectedItem = data.locations;
        _totalFloor = data.totalFloor;
        _availableDate = _parseApiDate(data.availableDate);

        // Maintenance
        final apiMaintenance = data.maintenance?.trim() ?? '';
        if (apiMaintenance.isNotEmpty &&
            apiMaintenance.toLowerCase() != 'included') {
          _maintenance = 'Custom';
          _maintenanceController.text = 'Custom';
          _customMaintenance = apiMaintenance;
          _customMaintenanceController.text = apiMaintenance;
        } else {
          _maintenance = 'Included';
          _maintenanceController.text = 'Included';
          _customMaintenance = null;
          _customMaintenanceController.clear();
        }

        _isLoading = false;
      });

      // 3️⃣ Controllers (outside setState)
      _FlatNumber.text = data.flatNumber;
      _sqft.text = data.squareFit;
      _videoLink.text = data.videoLink;
      _ApartmentName.text = data.apartmentName;
      _Apartment_Address.text = data.apartmentAddress;
      _showPrice.text = data.showPrice;
      _lastPrice.text = data.lastPrice;
      _askingPrice.text = data.askingPrice;
      _Ownername.text = data.ownerName;
      _Owner_number.text = data.ownerNumber;
      _CareTaker_name.text = data.careTakerName;
      _CareTaker_number.text = data.careTakerNumber;
      field_address.text = data.fieldWorkerAddress;
      // 🔥 REQUIRED HIDDEN FIELDS (BACKEND NEEDS THESE)
      _ageOfProperty = data.ageOfProperty;
      _roadSize = data.roadSize;
      _metroDistance = data.metroDistance;
      _highwayDistance = data.highwayDistance;
      _mainMarketDistance = data.mainMarketDistance;
      _facilityFromApi = data.facility;

      _apiLongitude = data.longitude;
      _apiLatitude = data.latitude;

// meter fallback
      _meter.text = data.meter;

    } catch (e, st) {
      print("❌ autofill error");
      print(e);
      print(st);
    }
  }

  void _startCountdown() {
    if (_isSubmitting) return;

    setState(() {
      _countdown = 3;
    });

    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_countdown > 1) {
        setState(() => _countdown--);
      } else {
        timer.cancel();
        setState(() => _countdown = 0);

        // 🚀 SUBMIT EXACTLY ONCE
        await _handleUpload();
      }
    });
  }


  Future<void> _handleUpload() async {
    if (_isSubmitting) {
      print("🚫 Duplicate submit blocked");
      return;
    }

    _isSubmitting = true;
    print("🚦 _handleUpload() START");

    if (!_formKey.currentState!.validate()) {
      _isSubmitting = false;
      Fluttertoast.showToast(msg: "Please fill all required fields.");
      return;
    }

    await duplicateFlatSubmit(_imageFile);

    print("🏁 _handleUpload() END");
  }
  final List<String> _typeofproperty = ['Flat','Office','Shop','Farms','Godown','Plots',''];

  List<String> name = ['Lift','Security CareTaker','GOVT Meter','CCTV','Gas Meter',''];

  String? _selectedItem1;
  final List<String> buy_rent = ['Buy', 'Rent',''];
  final List<String> yesNoOptions = ['Yes', 'No',''];
  final List<String> meter_Options = ['Commercial', 'Govt', 'Custom'];
  final List<String> registryOptions = ['Registry', 'GPA'];
  String? _floor1;
  final List<String> _items_floor1 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor',''];
  final List<String> _items_floor2 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor',''];

  final List<String> _balcony_items = ['Front Side Balcony', 'Back Side Balcony','Side','Window', 'Park Facing', 'Road Facing', 'Corner', 'No Balcony',''];


  final List<String> _Parking_items = ['Car','Bike','Both','No Parking',''];

  final List<String> _kitchen_items = ['Western Style','Indian Style','No',''];

  final List<String> _bathroom_items = ['Western Style','Indian Style','No',''];
  List<String> allFacilities = ['CCTV Camera', 'Lift', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline",''];


  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _videoLink = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _Longitude = TextEditingController();
  final TextEditingController _Latitude = TextEditingController();
  final TextEditingController full_address = TextEditingController();
  String? _houseMeter; // selected dropdown value

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        // color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _sectionTitleStyle()),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }


  String? _furnished;

  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,  fontFamily: 'Poppins');
  }

  Future<void> pickMultipleImages() async {
    final picker = ImagePicker();
    final pickedFiles = await HeicConverter.pickMultiImage(picker, );

    if (pickedFiles.isNotEmpty) {
      List<File> temp = [];
      for (var xfile in pickedFiles) {
        final tempDir = await getTemporaryDirectory();
        final targetPath = '${tempDir.path}/img_${DateTime.now().millisecondsSinceEpoch}.jpg';

        var compressed = await FlutterImageCompress.compressAndGetFile(
          xfile.path,
          targetPath,
          quality: 80,
        );
        if (compressed != null) temp.add(File(compressed.path));
      }
      setState(() {
        final existingPaths = _multipleImages.map((e) => e.path).toSet();

        for (final f in temp) {
          if (!existingPaths.contains(f.path)) {
            _multipleImages.add(f);
          }
        }      });
    }
  }
  Future<void> _refreshPage() async {
    await autofillFormFields(); // re-fetch API
  }

  Future<void> saveImageToGallery({
    File? file,
    String? imageUrl,
  }) async {
    try {
      if (file != null) {
        await Gal.putImage(file.path);
      } else if (imageUrl != null && imageUrl.isNotEmpty) {
        final response = await Dio().get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        await Gal.putImageBytes(response.data);
      }

      Fluttertoast.showToast(msg: "Image saved");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to save image");
    }
  }

  void _showImageOptions(
      BuildContext context, {
        File? file,
        String? imageUrl,
      }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.save_alt),
                  title: const Text("Save image to gallery"),
                  onTap: () async {
                    Navigator.pop(context);
                    await saveImageToGallery(
                      file: file,
                      imageUrl: imageUrl,
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close),
                  title: const Text("Cancel"),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  void _openImagePreview(File file) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            InteractiveViewer(
              child: Image.file(
                file,
                fit: BoxFit.contain,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: FloatingActionButton.extended(
                backgroundColor: Colors.green.shade600,
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  try {
                    await Gal.putImage(file.path);
                    Navigator.pop(context);
                    Fluttertoast.showToast(
                      msg: "Image saved to gallery",
                    );
                  } catch (e) {
                    Fluttertoast.showToast(
                      msg: "Failed to save image",
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: _kSurface2,
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
                  width: 10,
                ),
                Icon(
                  PhosphorIconsRegular.caretLeft,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Column(
            children: [
              _buildProgressDots(),
              const SizedBox(height: 14),
              _buildStepHeader(),
              const SizedBox(height: 14),
              const Divider(color: Colors.black54),
              const SizedBox(height: 14),
              Expanded(
                child: RefreshIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.white,
                  onRefresh: _refreshPage,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: _buildStepContent(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------- Wizard chrome (progress dots / header / footer) ----------------

  Widget _buildProgressDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_steps.length, (i) {
        final bool active = i == _stepIndex;
        final bool done = i < _stepIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 20 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: (active || done) ? _kPrimary : _kBorder,
            borderRadius: BorderRadius.circular(6),
          ),
        );
      }),
    );
  }

  Widget _buildStepHeader() {
    final _StepMeta step = _steps[_stepIndex];
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _kAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(step.icon, color: _kAccent, size: 20),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                step.title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              Text(
                step.hinglish,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
        Text(
          'Step ${_stepIndex + 1}/${_steps.length}',
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final bool isLast = _stepIndex == _steps.length - 1;
    final bool submitBusy = _isLoading || _countdown > 0;
    return Row(
      children: [
        if (_stepIndex > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: submitBusy ? null : () => setState(() => _stepIndex--),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: _kBorder),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                'Back',
                style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: submitBusy ? null : _onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLast ? Colors.red : _kPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: !isLast
                ? const Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.6,
                      fontSize: 16,
                    ),
                  )
                : (_countdown > 0
                    ? Text(
                        'Submitting in $_countdown',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      )
                    : (_isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.6,
                              fontSize: 16,
                            ),
                          ))),
          ),
        ),
      ],
    );
  }

  void _onNextPressed() {
    final bool isLast = _stepIndex == _steps.length - 1;
    if (!_validateStep(_stepIndex)) return;
    if (isLast) {
      _onSubmitPressed();
    } else {
      setState(() => _stepIndex++);
    }
  }

  bool _validateStep(int step) {
    final List<String> missing = [];
    switch (step) {
      case 0:
        // Photo step has no required fields in this form (matches original _handleUpload,
        // which never checked _imageFile).
        break;
      case 1:
        if (selectedPropertyType == null || selectedPropertyType!.isEmpty) {
          missing.add('Type of Property');
        }
        if (_FlatNumber.text.trim().isEmpty) missing.add('Flat Number');
        if (selectedBHK == null || selectedBHK!.isEmpty) missing.add('BHK');
        if (_floor1 == null || _floor1!.isEmpty) missing.add('Floor Number');
        if (_sqft.text.trim().isEmpty) missing.add('Sqft');
        break;
      case 2:
        if (_selectedItem1 == null || _selectedItem1!.isEmpty) {
          missing.add('Buy/Rent');
        }
        if (_selectedItem1 == 'Buy') {
          if (_registry == null || _registry!.isEmpty) missing.add('Register');
          if (_loan == null || _loan!.isEmpty) missing.add('Loan');
        }
        break;
      case 3:
        if (_furnished == null || _furnished!.isEmpty) missing.add('Furnishing');
        if (balcony == null || balcony!.isEmpty) missing.add('Balcony');
        if (bathroom == null || bathroom!.isEmpty) missing.add('Bathroom');
        if (kitchen == null || kitchen!.isEmpty) missing.add('Kitchen');
        if (parking == null || parking!.isEmpty) missing.add('Parking');
        break;
      case 4:
        if (_showPrice.text.trim().isEmpty) missing.add('Show Price');
        if (_maintenance == null || _maintenance!.isEmpty) {
          missing.add('Maintenance');
        }
        if (_maintenance == 'Custom' &&
            (_customMaintenance == null || _customMaintenance!.trim().isEmpty)) {
          missing.add('Maintenance Fee');
        }
        if (_houseMeter == null || _houseMeter!.isEmpty) {
          missing.add('House Meter Type');
        }
        if (_houseMeter == 'Custom' && _meter.text.trim().isEmpty) {
          missing.add('Custom Meter Type');
        }
        break;
      case 5:
        break;
    }
    if (missing.isNotEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill: ${missing.join(', ')}',
        toastLength: Toast.LENGTH_LONG,
      );
      return false;
    }
    return true;
  }

  // The exact original submit flow (validate -> _startCountdown -> _handleUpload),
  // unchanged, only moved into a named method so the wizard's final-step button can call it.
  void _onSubmitPressed() {
    if (_isLoading || _countdown > 0) return;
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields");
      return;
    }
    _startCountdown();
  }

  // ---------------- Step content dispatch ----------------

  Widget _buildStepContent() {
    switch (_stepIndex) {
      case 0:
        return _photoStep();
      case 1:
        return _basicDetailsStep();
      case 2:
        return _dealTypeStep();
      case 3:
        return _conditionStep();
      case 4:
        return _priceStep();
      case 5:
      default:
        return _extraInfoStep();
    }
  }

  // ---------------- Shared field chrome ----------------

  Widget _fieldHeader({
    required String label,
    required String hinglish,
    required IconData icon,
    bool required = true,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: _kPrimary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: _kPrimary, size: 17),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      label,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                  const SizedBox(width: 6),
                  if (required)
                    Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: _kSurface2,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: _kBorder),
                      ),
                      child: const Text(
                        'Optional',
                        style: TextStyle(
                          fontSize: 9,
                          color: Colors.black54,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                hinglish,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Compact tap-to-open row shown in the step body for every chip-select
  // field. Shows the current value (or a muted placeholder) and a trailing
  // chevron; tapping it invokes [onTap], which opens the picker bottom sheet.
  Widget _bottomSheetSelector({
    required String label,
    required String hinglish,
    required IconData icon,
    required String? valueText,
    required VoidCallback onTap,
    bool required = true,
    String? placeholder,
  }) {
    final bool hasValue = valueText != null && valueText.trim().isNotEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldHeader(label: label, hinglish: hinglish, icon: icon, required: required),
          const SizedBox(height: 10),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kBorder),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      hasValue ? valueText! : (placeholder ?? 'Select $label'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: hasValue ? Colors.black54 : Colors.black45,
                      ),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: Colors.black45),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Single-select chip field rendered as a [_bottomSheetSelector] row that
  // opens a chip picker sheet ([_openChipSheet]) instead of showing every
  // chip inline.
  Widget _chipSelectorField({
    required String label,
    required String hinglish,
    required IconData icon,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
    bool required = true,
  }) {
    return _bottomSheetSelector(
      label: label,
      hinglish: hinglish,
      icon: icon,
      valueText: value,
      required: required,
      onTap: () => _openChipSheet(
        title: label,
        options: options,
        selected: value,
        onSelected: onChanged,
      ),
    );
  }

  // Shared bottom sheet used by every single-select chip field: shows the
  // field's options as a Wrap of chips; tapping one selects it and closes
  // the sheet immediately.
  void _openChipSheet({
    required String title,
    required List<String> options,
    required String? selected,
    required ValueChanged<String?> onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 14),
                    decoration: BoxDecoration(
                      color: _kBorder,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final bool isSelected = selected == opt;
                    return GestureDetector(
                      onTap: () {
                        onSelected(opt);
                        Navigator.pop(ctx);
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? _kPrimary : _kSurface2,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: isSelected ? _kPrimary : _kBorder),
                        ),
                        child: Text(
                          opt,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black54,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Multi-select chip field (used by Facilities): shows a selector row
  // summarising how many items are chosen, and opens a chip sheet that stays
  // open (chips just toggle) until "Done" is pressed, instead of closing on
  // the first tap like the single-select sheet above.
  Widget _multiChipSelectorField({
    required String label,
    required String hinglish,
    required IconData icon,
    required List<String> options,
    required List<String> selected,
    required ValueChanged<List<String>> onChanged,
    bool required = false,
  }) {
    final String? valueText = selected.isEmpty ? null : '${selected.length} selected';
    return _bottomSheetSelector(
      label: label,
      hinglish: hinglish,
      icon: icon,
      valueText: valueText,
      required: required,
      placeholder: 'Select $label',
      onTap: () => _openMultiChipSheet(
        title: label,
        options: options,
        selected: selected,
        onDone: onChanged,
      ),
    );
  }

  void _openMultiChipSheet({
    required String title,
    required List<String> options,
    required List<String> selected,
    required ValueChanged<List<String>> onDone,
  }) {
    final List<String> temp = List.from(selected);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          color: _kBorder,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            onDone(temp);
                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            'Done',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _kPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: options.map((opt) {
                        final bool isSelected = temp.contains(opt);
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              if (isSelected) {
                                temp.remove(opt);
                              } else {
                                temp.add(opt);
                              }
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? _kPrimary : _kSurface2,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(color: isSelected ? _kPrimary : _kBorder),
                            ),
                            child: Text(
                              opt,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colors.black54,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _wizardTextField({
    required String label,
    required String hinglish,
    required IconData icon,
    required TextEditingController controller,
    bool required = true,
    TextInputType? keyboardType,
    Widget? suffixHint,
    String? hintText,
    ValueChanged<String>? onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fieldHeader(label: label, hinglish: hinglish, icon: icon, required: required),
          const SizedBox(height: 10),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            onChanged: onChanged,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
            decoration: InputDecoration(
              hintText: hintText ?? 'Enter $label',
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black38,
                fontSize: 13,
              ),
              suffixIcon: suffixHint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: _kPrimary, width: 1.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Step 1: Photo ----------------

  Widget _photoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
          label: 'Cover Photo',
          hinglish: 'Property ki Mukhya Photo',
          icon: Icons.photo_camera_outlined,
          required: false,
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: _kPrimary),
              onPressed: () async {
                XFile? pickedImage = await pickAndCompressImage();
                if (pickedImage != null) {
                  setState(() {
                    _imageFile = File(pickedImage.path);
                  });
                }
              },
              child: const Text('Pick Image', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 16),
            GestureDetector(
              onTap: () {
                _showImageOptions(
                  context,
                  file: _imageFile,
                  imageUrl: _networkImageUrl,
                );
              },
              child: Container(
                width: 90,
                height: 90,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kBorder),
                ),
                child: _imageFile != null
                    ? Image.file(_imageFile!, fit: BoxFit.cover)
                    : (_networkImageUrl != null && _networkImageUrl!.isNotEmpty)
                        ? Image.network(_networkImageUrl!, fit: BoxFit.cover)
                        : const Center(
                            child: Text(
                              'No image',
                              style: TextStyle(fontSize: 11, color: Colors.black45),
                            ),
                          ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        _fieldHeader(
          label: 'Gallery Images',
          hinglish: 'Aur Photos (Optional)',
          icon: Icons.collections_outlined,
          required: false,
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          icon: const Icon(Icons.collections, color: Colors.white),
          label: const Text('Add More Images', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(backgroundColor: _kPrimary),
          onPressed: pickMultipleImages,
        ),
        const SizedBox(height: 10),
        Text(
          'Images selected: ${_multipleImages.length}',
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        _multipleImages.isNotEmpty
            ? SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _multipleImages.length,
                  itemBuilder: (context, index) {
                    final file = _multipleImages[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () => _openImagePreview(file),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                file,
                                width: 110,
                                height: 110,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 4,
                            top: 4,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _multipleImages.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close, size: 16, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )
            : const Text(
                'No images selected',
                style: TextStyle(fontSize: 12, color: Colors.black45),
              ),
      ],
    );
  }

  // ---------------- Step 2: Basic Details ----------------

  Widget _basicDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _chipSelectorField(
          label: 'Type of Property',
          hinglish: 'Property Kis Tarah ki Hai',
          icon: Icons.home_work_outlined,
          options: _typeofproperty,
          value: selectedPropertyType,
          onChanged: (val) => setState(() => selectedPropertyType = val),
        ),
        _wizardTextField(
          label: 'Flat Number',
          hinglish: 'Flat ka Number',
          icon: Icons.tag_outlined,
          controller: _FlatNumber,
          keyboardType: TextInputType.text,
        ),
        _chipSelectorField(
          label: 'BHK',
          hinglish: 'Kitne BHK ka Flat Hai',
          icon: Icons.bed_outlined,
          options: bhkOptions,
          value: selectedBHK,
          onChanged: (val) => setState(() => selectedBHK = val),
        ),
        _chipSelectorField(
          label: 'Floor Number',
          hinglish: 'Konsi Manzil Par Hai',
          icon: Icons.stairs_outlined,
          options: _items_floor1,
          value: _floor1,
          onChanged: (val) => setState(() => _floor1 = val),
        ),
        _wizardTextField(
          label: 'Sqft',
          hinglish: 'Kitne Square Feet Ka Hai',
          icon: Icons.straighten_outlined,
          controller: _sqft,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  // ---------------- Step 3: Deal Type ----------------

  Widget _dealTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _chipSelectorField(
          label: 'Buy/Rent',
          hinglish: 'Bikri ya Kiraya',
          icon: Icons.swap_horiz_outlined,
          options: buy_rent,
          value: _selectedItem1,
          onChanged: (val) => setState(() => _selectedItem1 = val),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _selectedItem1 == 'Buy'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _chipSelectorField(
                      label: 'Register',
                      hinglish: 'Registry ka Type',
                      icon: Icons.verified_outlined,
                      options: registryOptions,
                      value: _registry,
                      onChanged: (val) => setState(() => _registry = val),
                    ),
                    _chipSelectorField(
                      label: 'Loan',
                      hinglish: 'Loan Chal Raha Hai Kya',
                      icon: Icons.verified_outlined,
                      options: yesNoOptions,
                      value: _loan,
                      onChanged: (val) => setState(() => _loan = val),
                    ),
                  ],
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }

  // ---------------- Step 4: Condition & Facilities ----------------

  Widget _conditionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _chipSelectorField(
          label: 'Furnishing',
          hinglish: 'Furnishing Kaisi Hai',
          icon: Icons.weekend_outlined,
          options: furnishingOptions,
          value: _furnished,
          onChanged: (val) => setState(() {
            _furnished = val;
            if (val == 'Unfurnished') {
              _selectedFurniture.clear();
            }
          }),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: (_furnished == 'Fully Furnished' || _furnished == 'Semi Furnished')
              ? _bottomSheetSelector(
                  label: 'Furniture Items',
                  hinglish: 'Kaunse Furniture Hain',
                  icon: Icons.chair_outlined,
                  required: false,
                  valueText: _selectedFurniture.isEmpty
                      ? null
                      : '${_selectedFurniture.length} item${_selectedFurniture.length > 1 ? 's' : ''} selected',
                  placeholder: 'Select furniture items',
                  onTap: () => _showFurnitureBottomSheet(context),
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
        _chipSelectorField(
          label: 'Balcony',
          hinglish: 'Balcony Kis Type ki Hai',
          icon: Icons.balcony_outlined,
          options: _balcony_items,
          value: balcony,
          onChanged: (val) => setState(() => balcony = val),
        ),
        _chipSelectorField(
          label: 'Bathroom',
          hinglish: 'Bathroom Kis Type ka Hai',
          icon: Icons.bathtub_outlined,
          options: _bathroom_items,
          value: bathroom,
          onChanged: (val) => setState(() => bathroom = val),
        ),
        _chipSelectorField(
          label: 'Kitchen',
          hinglish: 'Kitchen Kis Type ka Hai',
          icon: Icons.kitchen_outlined,
          options: _kitchen_items,
          value: kitchen,
          onChanged: (val) => setState(() => kitchen = val),
        ),
        _chipSelectorField(
          label: 'Parking',
          hinglish: 'Parking Available Hai Kya',
          icon: Icons.directions_car_outlined,
          options: _Parking_items,
          value: parking,
          onChanged: (val) => setState(() => parking = val),
        ),
        _multiChipSelectorField(
          label: 'Facilities',
          hinglish: 'Konsi Facilities Available Hain',
          icon: Icons.apartment_outlined,
          options: allFacilities,
          selected: selectedFacilities,
          onChanged: (val) => setState(() => selectedFacilities = val),
        ),
      ],
    );
  }

  // ---------------- Step 5: Price & Charges ----------------

  Widget _priceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _wizardTextField(
          label: 'Show Price',
          hinglish: 'Dikhane Wala Daam (₹)',
          icon: Icons.currency_rupee_outlined,
          controller: _showPrice,
          keyboardType: TextInputType.number,
          suffixHint: _formattedPrice.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _formattedPrice,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              : null,
        ),
        _wizardTextField(
          label: 'Last Price',
          hinglish: 'Malik ka Aakhri Daam (₹, Optional)',
          icon: Icons.currency_rupee_outlined,
          controller: _lastPrice,
          required: false,
          keyboardType: TextInputType.number,
          suffixHint: _formattedLastPrice.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _formattedLastPrice,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
                  ),
                )
              : null,
        ),
        _wizardTextField(
          label: 'Asking Price',
          hinglish: 'Maangi Gayi Keemat (₹, Optional)',
          icon: Icons.currency_rupee_outlined,
          controller: _askingPrice,
          required: false,
          keyboardType: TextInputType.number,
          suffixHint: _formattedAskingPrice.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _formattedAskingPrice,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black54),
                  ),
                )
              : null,
        ),
        _chipSelectorField(
          label: 'Maintenance',
          hinglish: 'Maintenance Kaisi Hai',
          icon: Icons.build_outlined,
          options: const ['Included', 'Custom'],
          value: _maintenance,
          onChanged: (val) => setState(() {
            _maintenance = val;
            _maintenanceController.text = val ?? '';
            if (val != 'Custom') _customMaintenance = null;
          }),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _maintenance == 'Custom'
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldHeader(
                        label: 'Maintenance Fee',
                        hinglish: 'Maintenance Fee Bataye',
                        icon: Icons.build_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _customMaintenanceController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
                        decoration: InputDecoration(
                          hintText: 'Enter Maintenance Fee',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _kBorder),
                          ),
                        ),
                        onChanged: (val) => _customMaintenance = val,
                        validator: (val) => _maintenance == 'Custom' &&
                                (val == null || val.isEmpty)
                            ? "Enter maintenance fee"
                            : null,
                      ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
        _chipSelectorField(
          label: 'House Meter Type',
          hinglish: 'Bijli Meter Kis Tarah Ka Hai',
          icon: Icons.speed_outlined,
          options: meter_Options,
          value: (_houseMeter != null && _houseMeter != 'Custom')
              ? _houseMeter
              : (_meter.text.isNotEmpty ? 'Custom' : null),
          onChanged: (val) => setState(() {
            _houseMeter = val;
            if (val != 'Custom') {
              _meter.text = val ?? '';
            } else {
              _meter.clear();
            }
          }),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _houseMeter == 'Custom'
              ? Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _fieldHeader(
                        label: 'Custom Meter Type',
                        hinglish: 'Meter Ka Naya Type Likhein',
                        icon: Icons.speed_outlined,
                        required: true,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _meter,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black54),
                        decoration: InputDecoration(
                          hintText: 'Enter Custom Meter Type',
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.black38,
                            fontSize: 13,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _kBorder),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _kBorder),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: _kPrimary, width: 1.6),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter Enter Custom Meter Type';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity, height: 0),
        ),
      ],
    );
  }

  // ---------------- Step 6: Extra Info (optional group) ----------------

  Widget _extraInfoStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
          label: 'Available Date',
          hinglish: 'Kab Se Available Hai',
          icon: Icons.calendar_month_outlined,
          required: false,
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2100),
            );
            if (picked != null) {
              setState(() {
                _availableDate = picked;
              });
            }
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _availableDate != null
                        ? DateFormat('dd MMMM yyyy').format(_availableDate!)
                        : 'Select Available Date',
                    style: TextStyle(
                      color: _availableDate != null ? Colors.black54 : Colors.black45,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black45),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        _wizardTextField(
          label: 'Video Link',
          hinglish: 'Video ka Link',
          icon: Icons.videocam_outlined,
          controller: _videoLink,
          required: false,
        ),
        _wizardTextField(
          label: 'Caretaker Name',
          hinglish: 'Caretaker ka Naam',
          icon: Icons.person_outline,
          controller: _CareTaker_name,
          required: false,
        ),
        _wizardTextField(
          label: 'Caretaker Mobile',
          hinglish: 'Caretaker ka Mobile Number',
          icon: Icons.phone_outlined,
          controller: _CareTaker_number,
          required: false,
          keyboardType: TextInputType.phone,
        ),
        _wizardTextField(
          label: 'Owner Name',
          hinglish: 'Malik ka Naam',
          icon: Icons.person_outline,
          controller: _Ownername,
          required: false,
        ),
        _wizardTextField(
          label: 'Owner Mobile',
          hinglish: 'Malik ka Mobile Number',
          icon: Icons.phone_outlined,
          controller: _Owner_number,
          required: false,
          keyboardType: TextInputType.phone,
        ),
      ],
    );
  }

  Widget _buildDropdownRegister(
      String label,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged, {
        String? Function(String?)? validator,
      }) {
    return _blueSectionCard(
      title: label,

      child: DropdownButtonFormField<String>(
        value: selectedValue,
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
        validator: validator,
        // dropdownColor: Colors.blue,
        decoration: InputDecoration(
          filled: true,
          //fillColor: Colors.blue,

          border: OutlineInputBorder
            (borderRadius: BorderRadius.circular(10)),
          // ✅ Error text style
          errorStyle: const TextStyle(
            color: Colors.redAccent, // deep red text
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),

          // ✅ Error border (deep red)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),

          // ✅ Focused border when error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down, /*color: Colors.black*/),
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style:  TextStyle(/*color: Colors.grey.shade800*/)),
        ))
            .toList(),
      ),
    );
  }
  Widget _buildDropdownRow(
      String label,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged, {
        String? Function(String?)? validator,
      }) {
    return _buildSectionCard(
      title: label,

      child: DropdownButtonFormField<String>(
        value: selectedValue,
        validator: validator,
        // dropdownColor: Colors.grey.shade100,
        decoration: InputDecoration(
          filled: true,
          // fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

          // ✅ Error text style
          errorStyle: const TextStyle(
            color: Colors.redAccent, // deep red text
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),

          // ✅ Error border (deep red)
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),

          // ✅ Focused border when error
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
        icon: const Icon(Icons.arrow_drop_down, /*color: Colors.black*/),
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style:  TextStyle(fontSize: 10)),
        ))
            .toList(),
      ),
    );
  }
  Widget _blueSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.blue.shade600,
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: _sectionTitleStyle()),
              const SizedBox(height: 10),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _blueTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType, // optional keyboard type
      }) {
    return _blueSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,  // set keyboard type here
        style: TextStyle(),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          // fillColor: Colors.grey.shade100,
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        },
      ),
    );
  }
  Widget _blueDropdownRow(
      String label,
      List<String> items,
      String? selectedValue,
      Function(String?) onChanged, {
        String? Function(String?)? validator,
      }) {
    return _blueSectionCard(
      title: label,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        validator: validator,
        // dropdownColor: Colors.grey.shade100,
        decoration: InputDecoration(
          filled: true,
          // fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: const TextStyle(color: Colors.grey),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style:  TextStyle()),
        ))
            .toList(),
      ),
    );
  }
  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        // borderSide: BorderSide(
        //     color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      // ✅ Error text style
      errorStyle: const TextStyle(
        color: Colors.redAccent, // deep red text
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),

      // ✅ Error border (deep red)
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),

      // ✅ Focused border when error
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        // borderSide: BorderSide(
        //     color: isDark ? Colors.blue.shade200 : Colors.blue.shade300,
        //     width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
      // fillColor: isDark ? Colors.grey.shade900 : Colors.white,
    );
  }


  Widget appTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType,
        bool required = true,
      }) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
        ),
        validator: required
            ? (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          return null;
        }
            : null,
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
  Widget _buildReadOnlyField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
    String? Function(String?)? validator,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
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
            suffixIcon: const Icon(Icons.arrow_drop_down, color: Colors.grey),
            filled: true,
            fillColor: Theme
                .of(context)
                .brightness == Brightness.dark
                ? Colors.grey.shade900
                : Colors.white,
          ),
          style: TextStyle(
            fontSize: 16,
            color: Theme
                .of(context)
                .brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          validator: validator,
        ),
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
  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
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
      child: Container(
        color: Colors.white,
        child: Padding(
          padding:
          EdgeInsets.only(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Select Facilities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ),
              ...widget.options.map((option) {
                final isSelected = _tempSelected.contains(option);
                return CheckboxListTile(
                  title: Text(option,style: TextStyle(color: Colors.grey.shade900),),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // Button background
                  foregroundColor: Colors.black, // Text/icon color
                  side: const BorderSide(color: Colors.black), // Optional border
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context, _tempSelected),
                child: const Text("Done"),
              ),
              SizedBox(height: 10,)
            ],
          ),
        ),
      ),
    );
  }
}
