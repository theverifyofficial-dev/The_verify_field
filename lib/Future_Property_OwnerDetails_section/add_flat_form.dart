import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';
import 'package:http/http.dart' as http;



class _StepMeta {
  final String title;
  final String hinglish;
  final IconData icon;
  const _StepMeta(this.title, this.hinglish, this.icon);
}

class Add_Flatunder_futureproperty extends StatefulWidget {
  String id;
  String Owner_name;
  String Owner_num;
  String Caretaker_name;
  String Caretaker_num;
  String market_dis;
  String metro_name;
  String metro_dis;
  String road_size;
  String age_property;
  String apartment_address;
  String field_address;
  String current_loc;
  String place;
  String lift;
  String totalFloor;
  String Residence_commercial;
  String facility;
  String google_loc;
  String locality_list;



  Add_Flatunder_futureproperty({
      super.key,
      required this.id,
      required this.Owner_name,
      required this.Owner_num,
      required this.Caretaker_name,
      required this.Caretaker_num,
      required this.market_dis,
      required this.metro_name,
      required this.metro_dis,
      required this.road_size,
      required this.age_property,
      required this.apartment_address,
      required this.field_address,
      required this.current_loc,
      required this.place,
      required this.lift,
      required this.totalFloor,
      required this.Residence_commercial,
      required this.facility,
      required this.google_loc,
      required this.locality_list,
      required String apartment,
      required String apartment_name,



  });

  @override
  _Add_Flatunder_futurepropertyState createState() => _Add_Flatunder_futurepropertyState();
}

class _Add_Flatunder_futurepropertyState extends State<Add_Flatunder_futureproperty> {

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
    _StepMeta('Condition', 'Property ki Condition', Icons.chair_outlined),
    _StepMeta('Price & Charges', 'Daam aur Charges', Icons.currency_rupee_outlined),
    _StepMeta('Extra Info', 'Aitirikt Jaankari (Optional)', Icons.info_outline),
  ];

  final TextEditingController _FlatNumber = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _sqft = TextEditingController();
  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _videoLink = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _Longitude = TextEditingController();
  final TextEditingController _Latitude = TextEditingController();
  final TextEditingController _ApartmentName = TextEditingController();
  final TextEditingController _showPrice = TextEditingController();
  final TextEditingController _lastPrice = TextEditingController();
  final TextEditingController _askingPrice = TextEditingController();
  final TextEditingController _meter = TextEditingController();
  final TextEditingController full_address = TextEditingController();
  final TextEditingController _Apartment_Address = TextEditingController();
  final TextEditingController _maintenanceController = TextEditingController();
  final TextEditingController _customMaintenanceController = TextEditingController();
  String? _maintenance;
  String? _customMaintenance;
  String? _houseMeter;
  String? selectedPropertyType;
  String? _totalFloor;
  String? selectedBHK;
  String? _selectedItem;
  String _formattedPrice = '';
  String _formattedAskingPrice = '';
  String _formattedLastPrice = '';

  final List<String> bhkOptions = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial'];
  final List<String> furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
  ];

  String? _furnished, _registry, _loan;
  String? Place_,bhk,parking,balcony,kitchen,bathroom;
  DateTime? _availableDate;
  File? _imageFile;
  List<File> _multipleImages = [];
  String long = '';
  String lat = '';
  String _number = '';
  String _name = '';
  final _formKey = GlobalKey<FormState>();
  List<String> selectedFacilities=[];

  Map<String, int> _selectedFurniture = {}; // e.g., {'Sofa': 2, 'Bed': 1}

  // this is for image compressor
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

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _getCurrentLocation();
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

    // Manually trigger listeners so _formatted... variables get updated
    _showPrice.notifyListeners();
    _lastPrice.notifyListeners();
    _askingPrice.notifyListeners();
    _Ownername.text = widget.Owner_name;
    _Owner_number.text = widget.Owner_num;
    _CareTaker_name.text = widget.Caretaker_name;
    _CareTaker_number.text = widget.Caretaker_num;
    _Apartment_Address.text = widget.apartment_address;

  }

  Future<void> _getCurrentLocation() async {
    // Check for location permissions
    if (await _checkLocationPermission()) {
      // Get the current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        long = '${position.latitude}';
        lat = '${position.longitude}';
        _Longitude.text = long;
        _Latitude.text = lat;
      });
    } else {
      // If permissions are not granted, request them
      await _requestLocationPermission();
    }
  }

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;
    return status == PermissionStatus.granted;
  }

  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      await _getCurrentLocation();
    } else {
      print('Location permission denied');
    }
  }

  String worker_address = '';



  get _RestorationId => null;

  String? _selectedParking;

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
  void _prepareFormattedPrices() {
    final showInput = _showPrice.text.replaceAll(',', '').trim();
    final lastInput = _lastPrice.text.replaceAll(',', '').trim();
    final askingInput = _askingPrice.text.replaceAll(',', '').trim();

    _formattedPrice = int.tryParse(showInput) != null ? formatPrice(int.parse(showInput)) : '';
    _formattedLastPrice = int.tryParse(lastInput) != null ? formatPrice(int.parse(lastInput)) : '';
    _formattedAskingPrice = int.tryParse(askingInput) != null ? formatPrice(int.parse(askingInput)) : '';
  }
  final List<String> yesNoOptions = ['Yes', 'No'];
  final List<String> registryOptions = ['Registry', 'GPA'];



  Future<void> uploadImageWithTitle(File imageFile) async {
    // Date formatting
    final DateFormat dateOnlyFormatter = DateFormat('dd-MMMM-yyyy');
    final DateFormat dateTimeFormatter = DateFormat('dd-MMMM-yyyy HH:mm:ss');

    String availableDate = _availableDate != null
        ? dateOnlyFormatter.format(_availableDate!)
        : '';

    String currentDateTime = dateTimeFormatter.format(DateTime.now());

    String uploadUrl =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/add_flat_in_future_property.php';

    print('🚀 Starting upload to: $uploadUrl');

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(uploadUrl),
      );

      // Primary Image
      print('📸 Primary Image: ${imageFile.path}');
      request.files.add(
        await http.MultipartFile.fromPath(
          'property_photo',
          imageFile.path,
        ),
      );

      // Multiple Images
      for (int i = 0; i < _multipleImages.length; i++) {
        var image = _multipleImages[i];
        print('🖼️ Multiple Image $i: ${image.path}');

        request.files.add(
          await http.MultipartFile.fromPath(
            'images[]',
            image.path,
          ),
        );
      }

      // Fields
      request.fields.addAll({
        "owner_name": _Ownername.text.trim(),
        "Balcony": balcony.toString(),
        "Flat_number": _FlatNumber.text,
        "owner_number": _Owner_number.text,
        "care_taker_name": _CareTaker_name.text.trim(),
        "care_taker_number": _CareTaker_number.text,
        "video_link": _videoLink.text,
        "locations": widget.place,
        "Buy_Rent": _selectedItem1 ?? '',
        "Residence_Commercial": widget.Residence_commercial,
        "Typeofproperty": selectedPropertyType ?? '',
        "Bhk": selectedBHK ?? '',
        "Floor_": _floor1 ?? '',
        "Total_floor": widget.totalFloor,
        "squarefit": _sqft.text,
        "maintance": (_maintenance == "Custom"
            ? _customMaintenance ?? ''
            : _maintenance) ??
            '',
        "Apartment_name": (_furnished == 'Semi Furnished' ||
            _furnished == 'Fully Furnished')
            ? _selectedFurniture.entries
            .map((e) => '${e.key}(${e.value})')
            .join(', ')
            : (_furnished ?? ''),
        "Apartment_Address": widget.apartment_address,
        "fieldworkar_address": widget.field_address,
        "field_worker_current_location": worker_address.toString(),
        "parking": _selectedParking.toString(),
        "age_of_property": widget.age_property,
        "field_warkar_name": _name,
        "field_workar_number": _number,
        "current_dates": currentDateTime,
        "available_date": _availableDate != null
            ? DateFormat('yyyy-MM-dd').format(_availableDate!)
            : '',
        "Longitude": _Longitude.text,
        "Latitude": _Latitude.text,
        "kitchen": kitchen.toString(),
        "bathroom": bathroom.toString(),
        "live_unlive": "Book",
        "lift": widget.lift,
        "Facility": widget.facility,
        "furnished_unfurnished": _furnished.toString(),
        "registry_and_gpa": _registry.toString(),
        "loan": _loan.toString(),
        "show_Price": _formattedPrice,
        "Last_Price": _formattedLastPrice,
        "asking_price": _formattedAskingPrice,
        "Road_Size": widget.road_size,
        "locality_list": widget.locality_list,
        "metro_distance": widget.metro_name,
        "highway_distance": widget.metro_dis,
        "main_market_distance": widget.market_dis,
        "meter": _meter.text,
        "subid": widget.id,
      });

      // Print fields
      print("📝 Fields going to API:");
      request.fields.forEach((key, value) {
        print("➡️ $key : $value");
      });

      // Send request
      var streamedResponse = await request.send();

      // Read response
      var response = await http.Response.fromStream(streamedResponse);

      print("✅ Status Code: ${response.statusCode}");
      print("🔁 Response: ${response.body}");

      if (response.statusCode == 200) {
        showSnack("Property Added Successfully");
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

  @override
  void dispose() {
    _FlatNumber.dispose();
    _address.dispose();
    _sqft.dispose();
    _Ownername.dispose();
    _maintenanceController.dispose();
    _Owner_number.dispose();
    _Address_apnehisaabka.dispose();
    _CareTaker_name.dispose();
    _videoLink.dispose();
    _CareTaker_number.dispose();
    _Longitude.dispose();
    _Latitude.dispose();
    _ApartmentName.dispose();
    _showPrice.dispose();
    _lastPrice.dispose();
    _askingPrice.dispose();
    _meter.dispose();

    super.dispose();
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields.");
      print("Please fill all required fields.");
      return;
    }

    if (_imageFile == null) {
      Fluttertoast.showToast(
        msg: "Images are required",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    List<String> missingFields = [];

    if (balcony == null) missingFields.add("Balcony");
    if (kitchen == null) missingFields.add("Kitchen");
    if (bathroom == null) missingFields.add("Bathroom");
    // if (_registry == null) missingFields.add("Registry");
    // if (_loan == null) missingFields.add("Loan");
    if (_selectedItem1 == null) missingFields.add("Buy/Rent");

    if (missingFields.isNotEmpty) {
      Fluttertoast.showToast(
        msg: "Please fill: ${missingFields.join(', ')}",
        toastLength: Toast.LENGTH_LONG,
      );
      return;
    }

    await uploadImageWithTitle(
        _imageFile!,
    );
  }

  final List<String> _typeofproperty = ['Flat','Office','Shop','Farms','Godown','Plots'];

  List<String> name = ['CCTV Camera', 'Lift', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline"];

  String? _selectedItem1;
  final List<String> buy_rent = ['Buy','Rent'];

  String? _floor1;
  final List<String> _items_floor1 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor'];

  final List<String>_balcony_items = ['Front Side', 'Back Side','Two Side', 'Side','Window', 'Park Facing', 'Road Facing', 'Corner', 'No Balcony',];

  final List<String> _Parking_items = ['Car','Bike','Both','No Parking',];

  final List<String> _kitchen_items = ['Western Style','Indian Style','No'];

  final List<String> _bathroom_items = ['Western Style','Indian Style','No'];
  List<String> allFacilities = ['CCTV Camera', 'Lift', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline"];


  final List<String> roadSizeOptions = ['10 feet', '15 feet', '20 feet', '30 feet'];
  final List<String> metroDistanceOptions = ['200 m', '300 m', '400 m', '500 m', '600 m', '700 m', '1 km', '1.5 km', '2.5 km',];
  final List<String> metro_nameOptions = ['Hauz khas', 'Malviya Nagar', 'Saket','Qutub Minar','Chhatarpur','Sultanpur', 'Ghitorni','Arjan Garh','Guru Dronacharya','Sikanderpur'];
  // final List<String> highwayDistanceOptions = ['< 1km', '1km–3km', '3km–5km', '> 5km'];

  final List<String> marketDistanceOptions = ['200 m', '300 m', '400 m', '500 m', '600 m', '700 m', '1 km', '1.5 km', '2.5 km'];
  final List<String> Age_Options = ['1 years', '2 years', '3 years', '4 years','5 years','6 years','7 years','8 years','9 years','10 years','10+ years'];  Widget _buildSectionCard({required String title, required Widget child}) {
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

  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,fontFamily: 'Poppins');
  }

  void _showFurnitureBottomSheet(BuildContext context) {
    final List<String> furnitureItems = [
      'Fan',
      'Light',
      'Refrigerator',
      'Washing Machine',
      'Wardrobe',
      'AC',
      'Water Purifier',
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
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.5, // ⬅️ Half screen
              child: Column(
                children: [
                  // 🔹 Header with Save
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Select Furniture',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _selectedFurniture = Map.fromEntries(
                                tempSelection.entries
                                    .where((e) => e.value > 0),
                              );
                            });

                            _selectedFurniture.forEach((item, quantity) {
                              print('$item: $quantity');
                            });

                            Navigator.pop(ctx);
                          },
                          child: const Text(
                            "Save",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),

                  // 🔹 Scrollable furniture list
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
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
                              padding:
                              const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
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
                                      Text(item,
                                          style: const TextStyle(fontSize: 16)),
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
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
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
              const Divider(color: Colors.black54,),
              const SizedBox(height: 14),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: _buildStepContent(),
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
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold,color: Colors.black54),
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
    return Row(
      children: [
        if (_stepIndex > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : () => setState(() => _stepIndex--),
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
            onPressed: _isLoading ? null : _onNextPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLast ? Colors.red : _kPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    isLast ? 'Add Flat' : 'Next',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      letterSpacing: 0.6,
                      fontSize: 16,
                    ),
                  ),
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
        if (_imageFile == null) missing.add('Primary Photo');
        break;
      case 1:
        if (selectedPropertyType == null || selectedPropertyType!.isEmpty) {
          missing.add('Type of Property');
        }
        if (_FlatNumber.text.trim().isEmpty) missing.add('Flat Number');
        if (selectedBHK == null || selectedBHK!.isEmpty) missing.add('BHK');
        if (_floor1 == null || _floor1!.isEmpty) missing.add('Floor Number');
        break;
      case 2:
        if (_selectedItem1 == null || _selectedItem1!.isEmpty) {
          missing.add('Buy/Rent');
        }
        if (_selectedItem1 == 'Buy') {
          if (_registry == null || _registry!.isEmpty) missing.add('Registry');
          if (_loan == null || _loan!.isEmpty) missing.add('Loan');
        }
        break;
      case 3:
        if (_furnished == null || _furnished!.isEmpty) missing.add('Furnishing');
        if (balcony == null || balcony!.isEmpty) missing.add('Balcony');
        if (bathroom == null || bathroom!.isEmpty) missing.add('Bathroom');
        if (kitchen == null || kitchen!.isEmpty) missing.add('Kitchen');
        if (_selectedParking == null || _selectedParking!.isEmpty) {
          missing.add('Parking');
        }
        if (_sqft.text.trim().isEmpty) missing.add('Sqft');
        break;
      case 4:
        if (_showPrice.text.trim().isEmpty) missing.add('Show Price');
        if (_lastPrice.text.trim().isEmpty) missing.add('Last Price');
        if (_askingPrice.text.trim().isEmpty) missing.add('Asking Price');
        if (_maintenance == null || _maintenance!.isEmpty) {
          missing.add('Maintenance');
        }
        if (_maintenance == 'Custom' &&
            (_customMaintenance == null || _customMaintenance!.isEmpty)) {
          missing.add('Maintenance Fee');
        }
        if (_houseMeter == null || _houseMeter!.isEmpty) {
          missing.add('House Meter Type');
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

  // The exact original submit flow (validate -> 3..1 countdown -> _handleUpload),
  // unchanged, moved into a named method so the wizard's final-step "Next" can call it.
  Future<void> _onSubmitPressed() async {
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
      return; // Stop here if any field is empty
    }

    setState(() {
      _isLoading = true;
    });

    int countdown = 3;

    // Show countdown dialog
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
                  Navigator.of(context).pop(); // close dialog
                }

                // Run your upload logic
                await _handleUpload();

                if (!mounted) return;

                // Show success message
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
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold,color: Colors.black54),
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

  // Shared bottom sheet used by every chip-select field: shows the field's
  // options as a Wrap of chips; tapping one selects it and closes the sheet.
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

  Widget _wizardTextField({
    required String label,
    required String hinglish,
    required IconData icon,
    required TextEditingController controller,
    bool required = true,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
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
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14,color: Colors.black54),
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
          label: 'Primary Photo',
          hinglish: 'Property ki Mukhya Photo',
          icon: Icons.photo_camera_outlined,
          required: true,
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
            Container(
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
                  : const Center(
                      child: Text(
                        'No image',
                        style: TextStyle(fontSize: 11, color: Colors.black45),
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
          label: const Text('Pick Images', style: TextStyle(color: Colors.white)),
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
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _multipleImages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _multipleImages[index],
                              width: 90,
                              height: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
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
          hinglish: 'Flat Number',
          icon: Icons.tag_outlined,
          controller: _FlatNumber,
          keyboardType: TextInputType.name,
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
                      label: 'Registry',
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

  // ---------------- Step 4: Condition ----------------

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
          value: _selectedParking,
          onChanged: (val) => setState(() => _selectedParking = val),
        ),
        _wizardTextField(
          label: 'Sqft',
          hinglish: 'Kitne Square Feet Ka Hai',
          icon: Icons.straighten_outlined,
          controller: _sqft,
          keyboardType: TextInputType.phone,
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
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                )
              : null,
        ),
        _wizardTextField(
          label: 'Last Price',
          hinglish: 'Malik ka Aakhri Daam (₹)',
          icon: Icons.currency_rupee_outlined,
          controller: _lastPrice,
          keyboardType: TextInputType.number,
          suffixHint: _formattedLastPrice.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _formattedLastPrice,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.grey[600],),
                  ),
                )
              : null,
        ),
        _wizardTextField(
          label: 'Asking Price',
          hinglish: 'Maangi Gayi Keemat (₹)',
          icon: Icons.currency_rupee_outlined,
          controller: _askingPrice,
          keyboardType: TextInputType.number,
          suffixHint: _formattedAskingPrice.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    _formattedAskingPrice,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12,color: Colors.grey[600],),
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
                        keyboardType: TextInputType.number,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
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
          options: const ['Commercial', 'Govt', 'Custom'],
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
              ? _wizardTextField(
                  label: 'Meter Amount per Unit',
                  hinglish: 'Har Unit Ka Rate',
                  icon: Icons.speed_outlined,
                  controller: _meter,
                  required: false,
                  keyboardType: TextInputType.number,
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
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
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(10),
          ],
        ),
      ],
    );
  }

  InputDecoration _buildInputDecoration(BuildContext context, String label) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: isDark ? Colors.white : Colors.black,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
            color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
      ),
        errorStyle: const TextStyle(
          color: Colors.redAccent, // deeper red text
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),

        // ✅ Error border (deep red)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent, // deep red border
            width: 2,
          ),
        ),

        // ✅ Focused border when still error
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.redAccent, // deep red border when focused
            width: 2,
          ),
        ),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.white,
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
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
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
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
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
          child: Text(item, style:  TextStyle(fontSize: 11)),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType, // optional keyboard type
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


  Widget buildTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType,
        bool validateLength = false, // keep if you still want digit-only & length limiter
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
          FilteringTextInputFormatter.digitsOnly, // only digits
          LengthLimitingTextInputFormatter(10),   // max 10 digits
        ]
            : [],
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
          hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),

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
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
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
            suffixIcon:  Icon(Icons.arrow_drop_down, color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
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

