import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Custom_Widget/constant.dart';
import 'flat_edit_model.dart';


class EditFlat extends StatefulWidget {
  String id;

  EditFlat({
    super.key,
    required this.id,
  });

  @override
  EditFlatState createState() => EditFlatState();
}

class EditFlatState extends State<EditFlat> {

  int _stepIndex = 0;

  static const Color _kPrimary = Color(0xFF0F6E5C);
  static const Color _kAccent = Color(0xFFE98A15);
  static const Color _kSurface2 = Color(0xFFF1EEE6);
  static const Color _kBorder = Color(0xFFE2DCCB);

  static const List<String> _kStepTitlesEn = [
    'Photo',
    'Basic Details',
    'Deal Type',
    'Condition',
    'Price & Charges',
    'Extra Info',
  ];
  static const List<String> _kStepTitlesHi = [
    'Property ki Photo',
    'Basic Jaankari',
    'Buy ya Rent',
    'Property ki Condition',
    'Price aur Charges',
    'Baaki Jaankari',
  ];
  static const List<IconData> _kStepIcons = [
    Icons.photo_camera_outlined,
    Icons.home_work_outlined,
    Icons.swap_horiz_outlined,
    Icons.weekend_outlined,
    Icons.currency_rupee_outlined,
    Icons.info_outline,
  ];

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
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController _Apartment_Address = TextEditingController();
  final TextEditingController furnitureController = TextEditingController();
  TextEditingController _customMaintenanceController = TextEditingController();

  late TextEditingController _maintenanceController;
  String? _maintenance;
  String? _customMaintenance;



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
  String long = '';
  String lat = '';
  String _number = '';
  String _name = '';
  String _date = '';
  final _formKey = GlobalKey<FormState>();
  List<String> selectedFacilities=[];

  String? _furnishing;


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
    autofillFormFields();
    _maintenanceController = TextEditingController();
    getFurnishingStringForApi();
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
      return _selectedFurniture.entries
          .map((e) => '${e.key} (${e.value})')
          .join(', ');
    } else {
      return _furnishing!;
    }
  }

  Future<void> updateImageWithTitle(File? imageFile) async {
    String uploadUrl = 'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/update_flat_in_future_property.php';

    print('Starting update to: $uploadUrl');
    FormData formData = FormData();

    if (imageFile != null) {
      formData.files.add(
        MapEntry(
          "property_photo",
          await MultipartFile.fromFile(
            imageFile.path,
            filename: imageFile.path.split('/').last,
          ),
        ),
      );
    }

    List<MapEntry<String, String>> fields = [
      MapEntry("P_id", widget.id),
      MapEntry("owner_name", _Ownername.text.trim() ?? ''),
      MapEntry("Balcony", balcony.toString()),
      MapEntry("Flat_number", _FlatNumber.text),
      MapEntry("owner_number", _Owner_number.text ?? ''),
      MapEntry("video_link", _videoLink.text ?? ''),
      MapEntry("care_taker_name", _CareTaker_name.text.trim() ?? ''),
      MapEntry("care_taker_number", _CareTaker_number.text ?? ''),
      MapEntry("locations", _selectedItem.toString()),
      MapEntry("Buy_Rent", _selectedItem1 ?? ''),
      MapEntry("Residence_Commercial", _residenceCommercial ?? ''),
      MapEntry("Typeofproperty", selectedPropertyType ?? ''),
      MapEntry("Bhk", selectedBHK ?? ''),
      MapEntry("Floor_", _floor1 ?? ''),
      MapEntry("Total_floor", _totalFloor.toString()),
      MapEntry("squarefit", _sqft.text),
      MapEntry("maintance", (_maintenance == "Custom" ? _customMaintenance ?? '' : _maintenance) ?? ''),
      MapEntry("Apartment_name", (_furnished == 'Semi Furnished' || _furnished == 'Fully Furnished')
          ? (_selectedFurniture.entries.map((e) => '${e.key}(${e.value})').join(', '))
          : (_furnished ?? ''),),
      MapEntry("Apartment_Address", _Apartment_Address.text),
      MapEntry("fieldworkar_address", field_address.text),
      MapEntry("field_worker_current_location", _Google_Location.text),
      MapEntry("parking", parking.toString()),
      MapEntry("field_warkar_name", _name),
      MapEntry("field_workar_number", _number),
      MapEntry("current_dates", dateFormatter.format(uploadDate)),
      MapEntry(
        "available_date",
        _availableDate != null ? dateFormatter.format(_availableDate!) : '',
      ),
      MapEntry("Longitude", _Longitude.text),
      MapEntry("Latitude", _Latitude.text),
      MapEntry("kitchen", kitchen.toString()),
      MapEntry("bathroom", bathroom.toString()),
      MapEntry("lift", _lift.toString()),
      MapEntry("Facility", _facilityController.text),
      MapEntry("furnished_unfurnished", _furnished.toString()),
      MapEntry("registry_and_gpa", _registry.toString()),
      MapEntry("loan", _loan.toString()),
      MapEntry("show_Price", _formattedPrice),
      MapEntry("Last_Price", _formattedLastPrice),
      MapEntry("asking_price", _formattedAskingPrice),
      MapEntry("meter", _meter.text),
    ];

    formData.fields.addAll(fields);

    print('📝 Fields to send (${fields.length}):');
    for (var field in fields) {
      print('➡️ ${field.key}: ${field.value}');
    }

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      print('✅ Status Code: ${response.statusCode}');
      print('🔁 Response: ${response.data}');

      if (response.statusCode == 200) {
        showSnack("Property Updated Successfully");
        Navigator.pop(context);
      } else {
        showSnack("Something went wrong");
      }
    } catch (e) {
      print("❌ Upload error: $e");
      showSnack("Upload failed: $e");

    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Map<String, int> parseFurnitureString(String furnitureString) {
    if (furnitureString.isEmpty) return {};

    final Map<String, int> furnitureMap = {};

    furnitureString.split(',').forEach((item) {
      item = item.trim();
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
                            final isSelected = tempSelection.containsKey(item);

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  // ✅ FIX: Flexible wraps checkbox+text to prevent overflow
                                  Flexible(
                                    child: Row(
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
                                        Flexible(
                                          child: Text(
                                            item,
                                            style: const TextStyle(fontSize: 16),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (isSelected)
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
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
                          _selectedFurniture = Map.fromEntries(
                            tempSelection.entries.where((e) => e.value > 0),
                          );

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
    super.dispose();
  }

  DateTime? _parseApiDate(dynamic raw) {
    if (raw == null) return null;
    final str = raw.toString().trim();
    if (str.isEmpty) return null;

    final iso = DateTime.tryParse(str);
    if (iso != null) return iso;

    try {
      return DateFormat("dd-MM-yyyy").parseStrict(str);
    } catch (_) {}

    try {
      return DateFormat("dd/MM/yyyy").parseStrict(str);
    } catch (_) {}

    print("DEBUG: Unrecognized date format from API → $str");
    return null;
  }

  Future<List<Property1>> fetchData() async {
    var url = Uri.parse("https://verifyrealestateandservices.in/WebService4.asmx/display_flat_in_future_property_details_page?id=${widget.id}");
    final responce = await http.get(url);
    if (responce.statusCode == 200) {
      List listresponce = json.decode(responce.body);
      return listresponce.map((data) => Property1.fromJson(data)).toList();
    }
    else {
      throw Exception('Unexpected error occured!');
    }
  }




  void autofillFormFields() async {
    try {
      final dataList = await fetchData();
      if (dataList.isNotEmpty) {
        print(dataList);
        final data = dataList.first;
        _networkImageUrl = "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/"+data.propertyPhoto;
        apiImageUrl = data.propertyPhoto;
        _facilityController.text = data.facility;
        _FlatNumber.text = data.flatNumber;
        _selectedItem = data.locations;
        print(data.locations);
        _selectedItem1 = data.buyRent;
        _residenceCommercial = data.residenceCommercial;
        _ApartmentName.text = data.apartmentName;
        _Apartment_Address.text = data.apartmentAddress;
        selectedPropertyType = data.typeOfProperty;
        selectedBHK = data.bhk;
        _lastPrice.text = data.lastPrice;
        _askingPrice.text = data.askingPrice;
        _showPrice.text = data.showPrice;
        _floor1 = data.floor;
        _totalFloor = data.totalFloor;
        _loan= data.loan;
        _registry = data.registryAndGpa;
        _CareTaker_name.text = data.careTakerName;
        _videoLink.text = data.videoLink;
        _CareTaker_number.text = data.careTakerNumber;
        _Owner_number.text = data.ownerNumber;
        _Ownername.text = data.ownerName;

        final apiMaintenance = data.maintenance?.toString() ?? '';
        print("DEBUG: Maintenance from API = $apiMaintenance");

        if (apiMaintenance.toLowerCase() == "included") {
          _maintenance = "Included";
          _maintenanceController.text = "Included";
          _customMaintenance = null;
          _customMaintenanceController.clear();
        } else if (apiMaintenance.isNotEmpty) {
          _maintenance = "Custom";
          _maintenanceController.text = "Custom";
          _customMaintenance = apiMaintenance;
          _customMaintenanceController.text = apiMaintenance;
        } else {
          _maintenance = null;
          _maintenanceController.clear();
          _customMaintenance = null;
          _customMaintenanceController.clear();
        }
        print("DEBUG: _maintenance=$_maintenance, _maintenanceController.text=${_maintenanceController.text}, _customMaintenance=$_customMaintenance");

        if (data.meter == 'Commercial' || data.meter == 'Govt') {
          _houseMeter = data.meter;
          _meter.text = data.meter;
          print("DEBUG: Predefined meter = ${data.meter}");
        } else {
          _houseMeter = 'Custom';
          _meter.text = data.meter;
          print("DEBUG: Custom meter = ${data.meter}");
        }

        balcony = data.balcony;
        _sqft.text = data.squareFit;
        parking = data.parking;
        final apiDate = data.availableDate;

        _availableDate = _parseApiDate(apiDate);


        kitchen = data.kitchen;
        bathroom = data.bathroom;
        _lift = data.lift;
        field_address.text = data.fieldWorkerAddress;
        _Google_Location.text = data.fieldWorkerCurrentLocation;
        parseFurnishingFromApi(data.furnishedUnfurnished ?? '');
        _furnished = data.furnishedUnfurnished;
        print(_furnished);
        String furnitureString = data.apartmentName;
        print(furnitureString);
        _selectedFurniture = parseFurnitureString(furnitureString);
        print(_selectedFurniture);
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields.");
      print("Please fill all required fields.");
      return;
    }

    List<String> missingFields = [];

    if (balcony == null) missingFields.add("Balcony");
    if (kitchen == null) missingFields.add("Kitchen");
    if (bathroom == null) missingFields.add("Bathroom");
    if (_lift == null) missingFields.add("Lift");
    if (_selectedItem1 == null) missingFields.add("Buy/Rent");
    if (_residenceCommercial == null) missingFields.add("Residence/Commercial");

    if (missingFields.isNotEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill: ${missingFields.join(', ')}",
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    await updateImageWithTitle(_imageFile);
  }

  final List<String> _typeofproperty = ['Flat','Office','Shop','Farms','Godown','Plots',''];

  List<String> name = ['Lift','Security CareTaker','GOVT Meter','CCTV','Gas Meter',''];

  String? _selectedItem1;
  final List<String> buy_rent = ['Buy', 'Rent',''];
  final List<String> yesNoOptions = ['Yes', 'No',''];
  final List<String> registryOptions = ['Registry', 'GPA'];
  String? _floor1;
  final List<String> _items_floor1 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor',''];
  final List<String> _items_floor2 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor',''];

  final List<String> _balcony_items = ['Front Side','Front Side Balcony','Back Side','Back Side Balcony','Side','Window', 'Park Facing', 'Road Facing', 'Corner', 'No Balcony',''];


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
  String? _houseMeter;

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
  List<File> _multipleImages = [];

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
        _multipleImages = temp;
      });
    }
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
                  PhosphorIconsRegular.caretLeft,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),

        ),
        body: Container(
          color: _kSurface2,
          child: SafeArea(
            child: Column(
              children: [
                _buildProgressDots(),
                _buildStepHeader(),
                const SizedBox(height: 14),
                const Divider(color: Colors.black54,),
                const SizedBox(height: 14),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Form(
                      key: _formKey,
                      child: _buildStepBody(),
                    ),
                  ),
                ),
                _buildFooter(),
              ],
            ),
          ),
        ));
  }

  Widget _buildStepBody() {
    switch (_stepIndex) {
      case 0:
        return _stepPhoto();
      case 1:
        return _stepBasicDetails();
      case 2:
        return _stepDealType();
      case 3:
        return _stepCondition();
      case 4:
        return _stepPriceCharges();
      case 5:
        return _stepExtraInfo();
      default:
        return _stepPhoto();
    }
  }

  Widget _buildProgressDots() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_kStepTitlesEn.length, (i) {
          final bool active = i == _stepIndex;
          final bool done = i < _stepIndex;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: active ? 22 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: (active || done) ? _kPrimary : _kBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _kPrimary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_kStepIcons[_stepIndex], color: _kPrimary, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _kStepTitlesEn[_stepIndex],
                  style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                Text(
                  _kStepTitlesHi[_stepIndex],
                  style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.5)),
                ),
              ],
            ),
          ),
          Text(
            'Step ${_stepIndex + 1}/${_kStepTitlesEn.length}',
            style: TextStyle(
                fontSize: 11,
                color: Colors.black.withOpacity(0.4),
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _goBack() {
    if (_stepIndex > 0) {
      setState(() => _stepIndex--);
    }
  }

  void _goNext() {
    if (!_validateCurrentStep()) return;
    if (_stepIndex < _kStepTitlesEn.length - 1) {
      setState(() => _stepIndex++);
    }
  }

  bool _validateCurrentStep() {
    switch (_stepIndex) {
      case 0:
        return true;
      case 1:
        if (selectedPropertyType == null || selectedPropertyType!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select a property type');
          return false;
        }
        if (_FlatNumber.text.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Please enter Flat Number');
          return false;
        }
        if (selectedBHK == null || selectedBHK!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select a BHK');
          return false;
        }
        if (_floor1 == null || _floor1!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select a floor number');
          return false;
        }
        return true;
      case 2:
        if (_selectedItem1 == null || _selectedItem1!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select Buy/Rent');
          return false;
        }
        if (_selectedItem1 == 'Buy') {
          if (_registry == null || _registry!.isEmpty) {
            Fluttertoast.showToast(msg: 'Please select Register');
            return false;
          }
          if (_loan == null || _loan!.isEmpty) {
            Fluttertoast.showToast(msg: 'Please select Loan');
            return false;
          }
        }
        return true;
      case 3:
        if (_furnished == null || _furnished!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select furnishing');
          return false;
        }
        if (balcony == null || balcony!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select a balcony type');
          return false;
        }
        if (bathroom == null || bathroom!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select a Bathroom type');
          return false;
        }
        if (kitchen == null || kitchen!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select a Kitchen type');
          return false;
        }
        if (parking == null || parking!.isEmpty) {
          Fluttertoast.showToast(msg: 'Please select parking type');
          return false;
        }
        if (_sqft.text.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Please enter Sqft');
          return false;
        }
        return true;
      case 4:
        if (_showPrice.text.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Enter price');
          return false;
        }
        if (_maintenance == null || _maintenance!.isEmpty) {
          Fluttertoast.showToast(msg: 'Select maintenance');
          return false;
        }
        if (_maintenance == 'Custom' &&
            (_customMaintenance == null || _customMaintenance!.isEmpty)) {
          Fluttertoast.showToast(msg: 'Enter maintenance fee');
          return false;
        }
        if (_houseMeter == null || _houseMeter!.isEmpty) {
          Fluttertoast.showToast(msg: 'Select house meter type');
          return false;
        }
        if (_houseMeter == 'Custom' && _meter.text.trim().isEmpty) {
          Fluttertoast.showToast(msg: 'Please enter Custom Meter Type');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Widget _fieldHeader({
    required IconData icon,
    required Color badgeColor,
    required String label,
    required String hinglish,
    bool required = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: badgeColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black54),
                    ),
                    const SizedBox(width: 6),
                    if (required)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                            color: Colors.redAccent, shape: BoxShape.circle),
                      )
                    else
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: _kSurface2,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: _kBorder),
                        ),
                        child: const Text('Optional',
                            style: TextStyle(fontSize: 9, color: Colors.black54)),
                      ),
                  ],
                ),
                Text(
                  hinglish,
                  style: TextStyle(fontSize: 11, color: Colors.black.withOpacity(0.45)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipGroup({
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    final visible = items.where((e) => e.trim().isNotEmpty).toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: visible.map((item) {
        final selected = value == item;
        return GestureDetector(
          onTap: () => onChanged(item),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? _kPrimary : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: selected ? _kPrimary : _kBorder),
            ),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : Colors.black54,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Compact tap-to-open selector row used for every chip-select field.
  /// Shows the current value (or a muted placeholder) with a trailing
  /// chevron, and opens the field's bottom sheet on tap.
  Widget _bottomSheetSelector({
    required String? value,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    final bool hasValue = value != null && value.trim().isNotEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                hasValue ? value! : placeholder,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: hasValue ? Colors.black54 : Colors.black38,
                ),
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: Colors.black45),
          ],
        ),
      ),
    );
  }

  /// Opens a rounded bottom sheet with the field's title and its chip
  /// options in a Wrap. Tapping a chip sets the value and closes the sheet.
  void _openChipSheet({
    required String title,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
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
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
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
                      color: Colors.black54),
                ),
                const SizedBox(height: 14),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(ctx).size.height * 0.5,
                  ),
                  child: SingleChildScrollView(
                    child: _chipGroup(
                      items: items,
                      value: value,
                      onChanged: (v) {
                        onChanged(v);
                        Navigator.pop(ctx);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _styledTextField({
    required TextEditingController controller,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    String? suffixText,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      style: const TextStyle(
          fontWeight: FontWeight.w600, color: Colors.black54, fontSize: 14),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        suffixText: suffixText,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _kBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: _kPrimary, width: 2)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.redAccent)),
      ),
    );
  }

  Widget _stepPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
          icon: Icons.photo_camera_outlined,
          badgeColor: _kPrimary,
          label: 'Property Photo',
          hinglish: 'Property ki Photo',
          required: false,
        ),
        Center(
          child: Column(
            children: [
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: _kBorder),
                  color: Colors.white,
                ),
                child: _imageFile != null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.file(_imageFile!,
                      fit: BoxFit.cover, width: 160, height: 160),
                )
                    : (_networkImageUrl != null && _networkImageUrl!.isNotEmpty)
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(_networkImageUrl!,
                      fit: BoxFit.cover, width: 160, height: 160),
                )
                    : const Center(
                  child: Text('No image selected.',
                      style: TextStyle(color: Colors.black54)),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () async {
                  XFile? pickedImage = await pickAndCompressImage();
                  if (pickedImage != null) {
                    setState(() {
                      _imageFile = File(pickedImage.path);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  decoration: BoxDecoration(
                    color: _kPrimary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined, size: 16, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Change Photo',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _stepBasicDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
            icon: Icons.apartment_outlined,
            badgeColor: _kPrimary,
            label: 'Type of Property',
            hinglish: 'Property ka Type'),
        _bottomSheetSelector(
          value: selectedPropertyType,
          placeholder: 'Select Property Type',
          onTap: () => _openChipSheet(
            title: 'Type of Property',
            items: _typeofproperty,
            value: selectedPropertyType,
            onChanged: (v) => setState(() => selectedPropertyType = v),
          ),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.tag_outlined,
            badgeColor: _kAccent,
            label: 'Flat Number',
            hinglish: 'Flat Number'),
        _styledTextField(controller: _FlatNumber, keyboardType: TextInputType.name),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.bed_outlined,
            badgeColor: _kPrimary,
            label: 'BHK',
            hinglish: 'Kitne BHK'),
        _bottomSheetSelector(
          value: selectedBHK,
          placeholder: 'Select BHK',
          onTap: () => _openChipSheet(
            title: 'BHK',
            items: bhkOptions,
            value: selectedBHK,
            onChanged: (v) => setState(() => selectedBHK = v),
          ),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.stairs_outlined,
            badgeColor: _kAccent,
            label: 'Floor Number',
            hinglish: 'Kaunsi Floor'),
        _bottomSheetSelector(
          value: _floor1,
          placeholder: 'Select Floor',
          onTap: () => _openChipSheet(
            title: 'Floor Number',
            items: _items_floor1,
            value: _floor1,
            onChanged: (v) => setState(() => _floor1 = v),
          ),
        ),
      ],
    );
  }

  Widget _stepDealType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
            icon: Icons.swap_horiz_outlined,
            badgeColor: _kPrimary,
            label: 'Buy/Rent',
            hinglish: 'Buy ya Rent'),
        _bottomSheetSelector(
          value: _selectedItem1,
          placeholder: 'Select Buy or Rent',
          onTap: () => _openChipSheet(
            title: 'Buy/Rent',
            items: buy_rent,
            value: _selectedItem1,
            onChanged: (v) => setState(() => _selectedItem1 = v),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: _selectedItem1 == 'Buy'
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              _fieldHeader(
                  icon: Icons.verified_outlined,
                  badgeColor: _kAccent,
                  label: 'Registry',
                  hinglish: 'Registry ya GPA'),
              _bottomSheetSelector(
                value: _registry,
                placeholder: 'Select Registry',
                onTap: () => _openChipSheet(
                  title: 'Registry',
                  items: registryOptions,
                  value: _registry,
                  onChanged: (v) => setState(() => _registry = v),
                ),
              ),
              const SizedBox(height: 18),
              _fieldHeader(
                  icon: Icons.account_balance_outlined,
                  badgeColor: _kAccent,
                  label: 'Loan',
                  hinglish: 'Loan hai kya'),
              _bottomSheetSelector(
                value: _loan,
                placeholder: 'Select Loan status',
                onTap: () => _openChipSheet(
                  title: 'Loan',
                  items: yesNoOptions,
                  value: _loan,
                  onChanged: (v) => setState(() => _loan = v),
                ),
              ),
            ],
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _stepCondition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
            icon: Icons.weekend_outlined,
            badgeColor: _kPrimary,
            label: 'Furnishing',
            hinglish: 'Furnishing kaisi hai'),
        _bottomSheetSelector(
          value: _furnished,
          placeholder: 'Select Furnishing',
          onTap: () => _openChipSheet(
            title: 'Furnishing',
            items: furnishingOptions,
            value: _furnished,
            onChanged: (v) => setState(() {
              _furnished = v;
              if (v == 'Unfurnished') {
                _selectedFurniture.clear();
              }
            }),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: (_furnished == 'Fully Furnished' || _furnished == 'Semi Furnished')
              ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              _fieldHeader(
                  icon: Icons.chair_outlined,
                  badgeColor: _kAccent,
                  label: 'Furniture Items',
                  hinglish: 'Kaunse Furniture hai',
                  required: false),
              _bottomSheetSelector(
                value: _selectedFurniture.isEmpty
                    ? null
                    : _selectedFurniture.entries
                        .map((e) => '${e.key} (${e.value})')
                        .join(', '),
                placeholder: 'Select Furniture Items',
                onTap: () => _showFurnitureBottomSheet(context),
              ),
            ],
          )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.balcony_outlined,
            badgeColor: _kPrimary,
            label: 'Balcony',
            hinglish: 'Balcony ka type'),
        _bottomSheetSelector(
          value: balcony,
          placeholder: 'Select Balcony Type',
          onTap: () => _openChipSheet(
            title: 'Balcony',
            items: _balcony_items,
            value: _balcony_items.contains(balcony) ? balcony : null,
            onChanged: (v) => setState(() => balcony = v),
          ),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.bathtub_outlined,
            badgeColor: _kAccent,
            label: 'Bathroom',
            hinglish: 'Bathroom ka type'),
        _bottomSheetSelector(
          value: bathroom,
          placeholder: 'Select Bathroom Type',
          onTap: () => _openChipSheet(
            title: 'Bathroom',
            items: _bathroom_items,
            value: bathroom,
            onChanged: (v) => setState(() => bathroom = v),
          ),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.kitchen_outlined,
            badgeColor: _kAccent,
            label: 'Kitchen',
            hinglish: 'Kitchen ka type'),
        _bottomSheetSelector(
          value: kitchen,
          placeholder: 'Select Kitchen Type',
          onTap: () => _openChipSheet(
            title: 'Kitchen',
            items: _kitchen_items,
            value: kitchen,
            onChanged: (v) => setState(() => kitchen = v),
          ),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.directions_car_outlined,
            badgeColor: _kPrimary,
            label: 'Parking',
            hinglish: 'Parking available hai'),
        _bottomSheetSelector(
          value: parking,
          placeholder: 'Select Parking',
          onTap: () => _openChipSheet(
            title: 'Parking',
            items: _Parking_items,
            value: parking,
            onChanged: (v) => setState(() => parking = v),
          ),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.straighten_outlined,
            badgeColor: _kAccent,
            label: 'Sqft',
            hinglish: 'Area Sqft mein'),
        _styledTextField(controller: _sqft, keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _stepPriceCharges() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
            icon: Icons.currency_rupee_outlined,
            badgeColor: _kPrimary,
            label: 'Show Price',
            hinglish: 'Dikhane wali Price'),
        _styledTextField(
          controller: _showPrice,
          keyboardType: TextInputType.number,
          suffixText: _formattedPrice.isNotEmpty ? _formattedPrice : null,
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.currency_rupee_outlined,
            badgeColor: _kAccent,
            label: 'Last Price',
            hinglish: 'Owner ki Last Price',
            required: false),
        _styledTextField(
          controller: _lastPrice,
          keyboardType: TextInputType.number,
          suffixText: _formattedLastPrice.isNotEmpty ? _formattedLastPrice : null,
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.currency_rupee_outlined,
            badgeColor: _kAccent,
            label: 'Asking Price',
            hinglish: 'Owner ki Asking Price',
            required: false),
        _styledTextField(
          controller: _askingPrice,
          keyboardType: TextInputType.number,
          suffixText: _formattedAskingPrice.isNotEmpty ? _formattedAskingPrice : null,
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.build_outlined,
            badgeColor: _kPrimary,
            label: 'Maintenance',
            hinglish: 'Maintenance Included ya Custom'),
        _bottomSheetSelector(
          value: _maintenance,
          placeholder: 'Select Maintenance type',
          onTap: () => _openChipSheet(
            title: 'Maintenance',
            items: const ['Included', 'Custom'],
            value: _maintenance,
            onChanged: (v) => setState(() {
              _maintenance = v;
              _maintenanceController.text = v ?? '';
              if (v != 'Custom') _customMaintenance = null;
            }),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: _maintenance == 'Custom'
              ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _styledTextField(
              controller: _customMaintenanceController,
              keyboardType: TextInputType.number,
            ),
          )
              : const SizedBox.shrink(),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.speed_outlined,
            badgeColor: _kAccent,
            label: 'House Meter Type',
            hinglish: 'Meter kaunsa hai'),
        _bottomSheetSelector(
          value: (_houseMeter != null && _houseMeter != 'Custom')
              ? _houseMeter
              : (_meter.text.isNotEmpty ? 'Custom' : null),
          placeholder: 'Select House Meter Type',
          onTap: () => _openChipSheet(
            title: 'House Meter Type',
            items: const ['Commercial', 'Govt', 'Custom'],
            value: (_houseMeter != null && _houseMeter != 'Custom')
                ? _houseMeter
                : (_meter.text.isNotEmpty ? 'Custom' : null),
            onChanged: (v) => setState(() {
              _houseMeter = v;
              if (v != 'Custom') {
                _meter.text = v ?? '';
              } else {
                _meter.clear();
              }
            }),
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          child: _houseMeter == 'Custom'
              ? Padding(
            padding: const EdgeInsets.only(top: 12),
            child: _styledTextField(controller: _meter, keyboardType: TextInputType.text),
          )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _stepExtraInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldHeader(
            icon: Icons.calendar_month_outlined,
            badgeColor: _kPrimary,
            label: 'Available Date',
            hinglish: 'Kab se available hai',
            required: false),
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
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: _kBorder),
            ),
            child: Row(
              children: [
                Icon(Icons.event, size: 18, color: _kPrimary),
                const SizedBox(width: 10),
                Text(
                  _availableDate != null
                      ? DateFormat('dd MMMM yyyy').format(_availableDate!)
                      : 'Select date',
                  style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.videocam_outlined,
            badgeColor: _kAccent,
            label: 'Video Link',
            hinglish: 'Property ka Video',
            required: false),
        _styledTextField(controller: _videoLink),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.person_outline,
            badgeColor: _kPrimary,
            label: 'Owner Name',
            hinglish: 'Owner ka Naam',
            required: false),
        _styledTextField(controller: _Ownername),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.phone_outlined,
            badgeColor: _kPrimary,
            label: 'Owner Mobile',
            hinglish: 'Owner ka Number',
            required: false),
        _styledTextField(controller: _Owner_number, keyboardType: TextInputType.phone),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.person_outline,
            badgeColor: _kAccent,
            label: 'Caretaker Name',
            hinglish: 'Caretaker ka Naam',
            required: false),
        _styledTextField(controller: _CareTaker_name),
        const SizedBox(height: 18),
        _fieldHeader(
            icon: Icons.phone_outlined,
            badgeColor: _kAccent,
            label: 'Caretaker Mobile',
            hinglish: 'Caretaker ka Number',
            required: false),
        _styledTextField(controller: _CareTaker_number, keyboardType: TextInputType.phone),
      ],
    );
  }

  Widget _buildFooter() {
    final bool isLast = _stepIndex == _kStepTitlesEn.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          if (_stepIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _goBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(color: _kBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Back',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black54)),
              ),
            ),
          if (_stepIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: isLast ? _buildSubmitButton() : _buildNextButton(),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _goNext,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _kPrimary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
              letterSpacing: 0.8,
              fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return                   GestureDetector(
                    onTap: _isLoading
                        ? null
                        : () async {
                      if (!_formKey.currentState!.validate()) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                              "Form Incomplete",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            content: const Text(
                              "Please fill all the required fields before submitting.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("OK"),
                              )
                            ],
                          ),
                        );
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      int countdown = 3;

                      await showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) {
                          return StatefulBuilder(
                            builder: (context, setStateDialog) {
                              Future.delayed(const Duration(seconds: 1), () async {
                                if (countdown > 1) {
                                  setStateDialog(() {
                                    countdown--;
                                  });
                                } else {
                                  setStateDialog(() {
                                    countdown = 0;
                                  });

                                  await Future.delayed(const Duration(seconds: 1));
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(context).pop();
                                  }

                                  await _handleUpload();

                                  if (!mounted) return;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("✅ Submitted Successfully!"),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              });

                              return AlertDialog(
                                backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
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
                                      duration: const Duration(milliseconds: 500),
                                      transitionBuilder: (child, animation) =>
                                          ScaleTransition(scale: animation, child: child),
                                      child: countdown > 0
                                          ? Text(
                                        "$countdown",
                                        key: ValueKey<int>(countdown),
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).brightness ==
                                              Brightness.dark
                                              ? Colors.red[300]
                                              : Colors.red,
                                        ),
                                      )
                                          : const Icon(
                                        Icons.verified_rounded,
                                        key: ValueKey<String>("verified"),
                                        color: Colors.green,
                                        size: 60,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      countdown > 0 ? "Please wait..." : "Verified!",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Theme.of(context).brightness ==
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

                      setState(() {
                        _isLoading = false;
                      });
                    },
                    child: Center(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: Colors.red,
                        ),
                        child: _isLoading
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                              width: 18,
                              height: 30,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Processing...",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                            : const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                              letterSpacing: 0.8,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
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
        isExpanded: true, // ✅ FIX
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder
            (borderRadius: BorderRadius.circular(10)),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle()),
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
        isExpanded: true, // ✅ FIX: prevents text overflow in dropdown
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
        ),
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
        icon: const Icon(Icons.arrow_drop_down),
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle(fontSize: 16)),
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
        TextInputType? keyboardType,
      }) {
    return _blueSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
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
        isExpanded: true, // ✅ FIX
        decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        style: const TextStyle(color: Colors.grey),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle()),
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
      ),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontSize: 13,
        fontWeight: FontWeight.bold,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          color: Colors.redAccent,
          width: 2,
        ),
      ),
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
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
    );
  }


  Widget buildTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType,
        bool validateLength = false,
      }) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),

          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
        ),
        inputFormatters: validateLength
            ? [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10),
        ]
            : [],
      ),
    );
  }

  Widget _buildTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType,
      }) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          errorStyle: const TextStyle(
            color: Colors.redAccent,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.redAccent,
              width: 2,
            ),
          ),
          filled: true,
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
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  side: const BorderSide(color: Colors.black),
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