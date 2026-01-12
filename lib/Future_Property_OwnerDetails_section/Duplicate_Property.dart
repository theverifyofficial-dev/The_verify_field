import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import '../../constant.dart';
import 'New_Update/add_image_under_futureproperty.dart';
import 'New_Update/flat_edit_model.dart';


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
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

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
      'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_flat_in_future_property.php',
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
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_flat_in_future_property.php",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
             print("❌ SERVER ERROR");
        showSnack("Unexpected server response");
      }
    } catch (e, st) {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_flat_in_future_property.php",
          error: e.toString(),
          statusCode: 500,
      );
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: MediaQuery.of(ctx).viewInsets,
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
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: SingleChildScrollView(
                        child: Column(
                          children: furnitureItems.map((item) {
                            // 👇 auto-tick if exists in tempSelection
                            final isSelected = tempSelection.containsKey(item);

                            return Padding(
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
                                                tempSelection[item] =
                                                    tempSelection[item]! - 1;
                                              }
                                            });
                                          },
                                        ),
                                        Text('${tempSelection[item]}'),
                                        IconButton(
                                          icon: const Icon(Icons.add_circle_outline),
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
                    const SizedBox(height: 20),
                    ElevatedButton(
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
                      child: const Text("Save Selection"),
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
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/";

  Future<List<Property1>> fetchData() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/fecth_data_dublicate_flat.php?id=${widget.id}"
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
    final pickedFiles = await picker.pickMultiImage();

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
      // Android permission
      if (Platform.isAndroid) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          Fluttertoast.showToast(msg: "Permission denied");
          return;
        }
      }

      if (file != null) {
        await Gal.putImage(file.path);
      }
      else if (imageUrl != null && imageUrl.isNotEmpty) {
        final response = await Dio().get(
          imageUrl,
          options: Options(responseType: ResponseType.bytes),
        );

        await Gal.putImageBytes(response.data);
      }

      Fluttertoast.showToast(msg: "Image saved to gallery");
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to save image");
      debugPrint("Save image error: $e");
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
    return Scaffold(
        backgroundColor: Colors.black,
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
                  PhosphorIcons.caret_left_bold,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),

        ),
        body: RefreshIndicator(
          color: Colors.blue,
          backgroundColor: Colors.white,
          onRefresh: _refreshPage,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[

                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
                            onPressed: () async {
                              XFile? pickedImage = await pickAndCompressImage(); // XFile returned
                              if (pickedImage != null) {
                                setState(() {
                                  _imageFile = File(pickedImage.path);
                                });
                              }
                            },
                            child: Text('Pick Image',style: TextStyle(color: Colors.white),),
                          ),

                          SizedBox(
                            width: 80,
                          ),
                          GestureDetector(
                            onTap: () {
                              _showImageOptions(
                                context,
                                file: _imageFile,
                                imageUrl: _networkImageUrl,
                              );
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey.shade300,
                              ),
                              child: _imageFile != null
                                  ? Image.file(_imageFile!, fit: BoxFit.cover)
                                  : (_networkImageUrl != null && _networkImageUrl!.isNotEmpty)
                                  ? Image.network(_networkImageUrl!, fit: BoxFit.cover)
                                  : const Center(child: Text("No Image")),
                            ),
                          ),

                          // Container(
                          //   width: 100,
                          //   height: 100,
                          //   child: _imageFile != null
                          //       ? Image.file(_imageFile!)
                          //       : _networkImageUrl != null && _networkImageUrl!.isNotEmpty
                          //       ? ClipRRect(
                          //     borderRadius: BorderRadius.circular(4),
                          //     child: Image.network(
                          //       _networkImageUrl!,
                          //       height: 100,
                          //       width: 100,
                          //       fit: BoxFit.cover,
                          //     ),
                          //   )
                          //       : Center(child: Text('No image selected.',style: TextStyle(color: Colors.black),)),
                          //
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    if (_multipleImages.isNotEmpty)
                      SizedBox(
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
                                    onTap: () => _openImagePreview(file), // 👈 TAP PREVIEW + SAVE
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.file(
                                        file,
                                        width: 110,
                                        height: 110,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _multipleImages.removeAt(index);
                                        });
                                      },
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                    SizedBox(height: 10),

                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                      ),
                      onPressed: () async {
                        await pickMultipleImages(); // 👈 YOU ALREADY HAVE THIS
                      },
                      icon: const Icon(Icons.collections, color: Colors.white),
                      label: const Text(
                        'Add More Images',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),


                SizedBox(height: 20),


                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10,),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildDropdownRow(
                                    'Type of property',
                                    _typeofproperty,
                                    selectedPropertyType,
                                        (val) => setState(() => selectedPropertyType = val),
                                    validator: (val) => val == null || val.isEmpty
                                        ? 'Please select a property type'
                                        : null,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _buildDropdownRow(
                                    'Buy/Rent',
                                    buy_rent,
                                    _selectedItem1,
                                        (val) => setState(() => _selectedItem1 = val),
                                    validator: (val) => val == null || val.isEmpty
                                        ? 'Please select Buy/Rent'
                                        : null,
                                  ),
                                ),
                              ],
                            ),

                            // 👇 Show extra dropdowns when Sell is selected
                            if (_selectedItem1 == "Buy") ...[
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDropdownRegister(
                                      'Register',
                                      registryOptions,
                                      _registry,
                                          (val) => setState(() => _registry = val),
                                      validator: (val) =>
                                      val == null || val.isEmpty
                                          ? 'Please select Register'
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildDropdownRegister(
                                      'Loan',
                                      yesNoOptions,
                                      _loan,
                                          (val) => setState(() => _loan = val),
                                      validator: (val) =>
                                      val == null || val.isEmpty
                                          ? 'Please select Loan'
                                          : null,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ],
                        ),




                        _buildSectionCard(
                          child: DropdownButtonFormField<String>(
                            value: _furnished,
                            decoration: InputDecoration(
                              labelText: "",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            ),
                            items: furnishingOptions.map((option) {
                              return DropdownMenuItem(
                                value: option,
                                child: Text(option,style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _furnished = val;
                                // Clear previously selected furniture if not furnished
                                if (val == 'Unfurnished') {
                                  _selectedFurniture.clear();
                                }
                              });
                            },

                            validator: (val) =>
                            val == null || val.isEmpty ? 'Please select furnishing' : null,
                          ), title: 'Furnishing',
                        ),
                        if (_furnished == 'Fully Furnished' || _furnished == 'Semi Furnished')
                          _blueSectionCard(
                            child: GestureDetector(
                              onTap: () => _showFurnitureBottomSheet(context),
                              child: AbsorbPointer(
                                child: Padding(
                                  padding:  EdgeInsets.only(top: 16.0),
                                  child:
                                  TextFormField(
                                    decoration: InputDecoration(
                                      labelText: "Select Furniture Items",
                                      labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      filled: true, // ✅ enable background color
                                      fillColor: Theme.of(context).brightness==Brightness.dark?Colors.grey.shade800:Colors.white,
                                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    ),
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
                            ), title: 'Furniture Items',
                          ),
                        const SizedBox(height: 10,),
                        _buildDropdownRow(
                          'Parking',
                          _Parking_items,
                          parking,
                              (val) => setState(() => parking = val),
                          validator: (val) => val == null || val.isEmpty ? 'Please select parking type' : null,
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child:
                              _buildDropdownRow('Bathroom', _bathroom_items, bathroom, (val) => setState(() => bathroom = val),
                                validator: (val) => val == null || val.isEmpty ? 'Please select a Bathroom type' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownRow('Kitchen', _kitchen_items, kitchen, (val) => setState(() => kitchen = val),
                                validator: (val) => val == null || val.isEmpty ? 'Please select a Kitchen type' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10,),
                        Row(
                          children: [
                            Expanded(
                              child: appTextInput(
                                'Flat Number',
                                _FlatNumber,
                                keyboardType: TextInputType.text,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: appTextInput(
                                'Sqft',
                                _sqft,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),


                        Row(
                          children: [
                            Expanded(
                              child:
                              _buildDropdownRow('Balcony', _balcony_items, balcony, (val) => setState(() => balcony = val),
                                validator: (val) => val == null || val.isEmpty ? 'Please select a balcony type' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildDropdownRow('Select  BHK',bhkOptions, selectedBHK, (val) => setState(() => selectedBHK = val),
                                validator: (val) => val == null || val.isEmpty ? 'Please select a BHK' : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10,),

                        Row(
                          children: [
                            Expanded(
                              child:
                              _buildSectionCard(
                                title: 'Available Date',
                                child: GestureDetector(
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
                                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade600,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      _availableDate != null
                                          ? DateFormat('dd MMMM yyyy').format(_availableDate!)
                                          : '', // 👈 empty string if null
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child:              _buildDropdownRow('Floor no.',_items_floor1, _floor1, (val) => setState(() => _floor1 = val),
                                validator: (val) => val == null || val.isEmpty ? 'Please select a floor number' : null,
                              ),
                            ),
                          ],
                        ),

                        TextFormField(
                          controller: _showPrice,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText:"Show Price (₹)",
                            floatingLabelStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),

                            suffix: _formattedPrice.isNotEmpty
                                ? Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: Text(
                                _formattedPrice,
                                style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
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
                                      : Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Theme.of(context).brightness == Brightness.dark
                                      ? Colors.blue.shade200
                                      : Colors.blue.shade300,
                                  width: 2),
                            ),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                            filled: true,
                            fillColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.grey.shade900
                                : Colors.white,
                          ),
                          validator: (val) => val == null || val.isEmpty ? "Enter price" : null,
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: _lastPrice,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                          decoration: _buildInputDecoration(
                            context,
                            "Last Price (₹) by owner",
                          ).copyWith(
                            suffix: Text(
                              _formattedLastPrice,
                              style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextFormField(
                          controller: _askingPrice,
                          keyboardType: TextInputType.number,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                          decoration: _buildInputDecoration(
                            context,
                            "Asking Price (₹) by owner",
                          ).copyWith(
                            suffix: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: Text(
                                _formattedAskingPrice ?? '',  // This should be a String variable updated by your listener
                                style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),

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

                            if (_maintenance == 'Custom')

                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: TextFormField(
                                    controller: _customMaintenanceController, // ✅ attach controller
                                    decoration: InputDecoration(
                                        labelText: "Enter Maintenance Fee",
                                        labelStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                            color: Theme.of(context).brightness == Brightness.dark
                                                ? Colors.grey.shade700
                                                : Colors.grey.shade300,
                                          ),
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
                                            color: Colors.red,
                                            width: 2,
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
                                                ? Colors.blue
                                                : Colors.blue.shade300,
                                            width: 2,
                                          ),
                                        ),

                                        contentPadding:
                                        const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                                        filled: true,
                                        fillColor:Colors.blue
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


                        const SizedBox(height: 16,),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonFormField<String>(
                              value: (_houseMeter != null && _houseMeter != 'Custom')
                                  ? _houseMeter
                                  : (_meter.text.isNotEmpty ? 'Custom' : null),
                              decoration: _buildInputDecoration(context, "House Meter Type"),
                              items: meter_Options.map((option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  _houseMeter = val;
                                  if (val != 'Custom') {
                                    _meter.text = val!;
                                    print("DEBUG: Selected predefined meter = $val");
                                  } else {
                                    _meter.clear();
                                    print("DEBUG: Cleared for custom input");
                                  }
                                });
                              },
                              validator: (val) => (val == null || val.isEmpty)
                                  ? "Select house meter type"
                                  : null,
                            ),

                            const SizedBox(height: 20),

                            if (_houseMeter == 'Custom')
                              _blueTextInput(
                                'Enter Custom Meter Type',
                                _meter,
                                keyboardType: TextInputType.text,
                              ),
                          ],
                        ),
                        appTextInput('Video Link', _videoLink, required: false),
                        appTextInput('Caretaker Name (Optional)', _CareTaker_name, required: false),
                        appTextInput(
                          'Caretaker Mobile (Optional)',
                          _CareTaker_number,
                          keyboardType: TextInputType.phone,
                          required: false,
                        ),
                        appTextInput('Owner Name (Optional)', _Ownername, required: false),
                        appTextInput(
                          'Owner Mobile (Optional)',
                          _Owner_number,
                          keyboardType: TextInputType.phone,
                          required: false,
                        ),

                      ],
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: (_isLoading || _countdown > 0)
                          ? null
                          : () {
                        if (!_formKey.currentState!.validate()) {
                          Fluttertoast.showToast(msg: "Please fill all required fields");
                          return;
                        }
                        _startCountdown();
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.red,
                        ),
                        child: Center(
                          child: _countdown > 0
                              ? Text(
                            "Submitting in $_countdown",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          )
                              : _isLoading
                              ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                              : const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ));
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
