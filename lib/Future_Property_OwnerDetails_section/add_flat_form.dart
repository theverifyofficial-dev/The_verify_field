import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';



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

    // this is for API current date & available date
    final DateFormat dateOnlyFormatter = DateFormat('yyyy-MM-dd');
    final DateFormat dateTimeFormatter = DateFormat('yyyy-MM-dd HH:mm:ss');

    String availableDate = _availableDate != null
        ? dateOnlyFormatter.format(_availableDate!)
        : '';

    // Current Date
    String currentDateTime = dateTimeFormatter.format(DateTime.now());


    String uploadUrl = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/add_flat_in_future_property.php';
    print('🚀 Starting upload to: $uploadUrl');

    FormData formData = FormData();

    print('📸 Primary Image: ${imageFile.path}');
    formData.files.add(MapEntry(
      "property_photo",
      await MultipartFile.fromFile(imageFile.path, filename: imageFile.path.split('/').last),
    ));

    // 🔍 Multiple Images
    for (int i = 0; i < _multipleImages.length; i++) {
      var image = _multipleImages[i];
      print('🖼️ Multiple Image $i: ${image.path}');
      formData.files.add(MapEntry(
        "images[]",
        await MultipartFile.fromFile(image.path, filename: image.path.split('/').last),
      ));
    }

    List<MapEntry<String, String>> fields = [
      MapEntry("owner_name", _Ownername.text.trim() ?? ''),
      MapEntry("Balcony", balcony.toString()),
      MapEntry("Flat_number", _FlatNumber.text),
      MapEntry("owner_number", _Owner_number.text ?? ''),
      MapEntry("care_taker_name", _CareTaker_name.text.trim() ?? ''),
      MapEntry("care_taker_number", _CareTaker_number.text ?? ''),
      MapEntry("video_link", _videoLink.text ?? ''),
      MapEntry("locations", widget.place),
      MapEntry("Buy_Rent", _selectedItem1 ?? ''),
      MapEntry("Residence_Commercial", widget.Residence_commercial ?? ''),
      MapEntry("Typeofproperty", selectedPropertyType ?? ''),
      MapEntry("Bhk", selectedBHK ?? ''),
      MapEntry("Floor_", _floor1 ?? ''),
      MapEntry("Total_floor", widget.totalFloor),
      MapEntry("squarefit", _sqft.text),
      MapEntry("maintance", (_maintenance == "Custom" ? _customMaintenance ?? '' : _maintenance) ?? ''),
      MapEntry("Apartment_name", (_furnished == 'Semi Furnished' || _furnished == 'Fully Furnished')
          ? (_selectedFurniture.entries.map((e) => '${e.key}(${e.value})').join(', '))
          : (_furnished ?? ''),),
      MapEntry("Apartment_Address", widget.apartment_address),
      MapEntry("fieldworkar_address", widget.field_address),
      MapEntry("field_worker_current_location", worker_address.toString()),
      MapEntry("parking", _selectedParking.toString()),
      MapEntry("age_of_property", widget.age_property),
      MapEntry("field_warkar_name", _name),
      MapEntry("field_workar_number", _number),
      MapEntry("current_dates", currentDateTime),
      MapEntry(
        "available_date",
        _availableDate != null
            ? DateFormat('yyyy-MM-dd').format(_availableDate!)
            : '', // empty if not selected
      ),
      MapEntry("Longitude", _Longitude.text),
      MapEntry("Latitude", _Latitude.text),
      MapEntry("kitchen", kitchen.toString()),
      MapEntry("bathroom", bathroom.toString()),
      MapEntry("live_unlive", "Book"), // <-- Static value sent to API
      MapEntry("lift", widget.lift),
      MapEntry("Facility", widget.facility),
      MapEntry("furnished_unfurnished", _furnished.toString()),
      MapEntry("registry_and_gpa", _registry.toString()),
      MapEntry("loan", _loan.toString()),
      MapEntry("show_Price", _formattedPrice),
      MapEntry("Last_Price", _formattedLastPrice),
      MapEntry("asking_price", _formattedAskingPrice),
      MapEntry("Road_Size", widget.road_size),
      MapEntry("locality_list", widget.locality_list),
      MapEntry("metro_distance", widget.metro_name),
      MapEntry("highway_distance", widget.metro_dis),
      MapEntry("main_market_distance", widget.market_dis),
      MapEntry("meter", _meter.text),
      MapEntry("subid", widget.id),
    ];

    // Add fields to formData
    formData.fields.addAll(fields);

    // 🔍 Print all fields for debugging
    print('📝 Fields going to API:');
    for (var field in fields) {
      print('➡️ ${field.key}: ${field.value}');
    }

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      print('✅ Status Code: ${response.statusCode}');
      print('🔁 Response from API: ${response.data}');

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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
              children: <Widget>[
      
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Add Flat",style: TextStyle(fontSize: 25,fontFamily: "Poppins",fontWeight: FontWeight.bold),)
                  ],
                ),
                SizedBox(height: 5,),
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
      
                      Container(
                        width: 100,
                        height: 100,
                        child: _imageFile != null
                            ? Image.file(_imageFile!)
                            : Center(child: Text('No image selected.',style: TextStyle(),)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
      
                _buildSectionCard(
                  title: 'Upload Multiple Images',
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.collections, color: Colors.white),
                          label: const Text('Pick Images', style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
                          onPressed: pickMultipleImages,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Images selected: ${_multipleImages.length}',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        _multipleImages.isNotEmpty
                            ? SizedBox(
                          height: 100,
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
                                        width: 100,
                                        height: 100,
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
                            : const Text('No images selected', style: TextStyle()),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
      
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdownRow('Type of property',_typeofproperty, selectedPropertyType, (val) => setState(() => selectedPropertyType = val),
                            validator: (val) => val == null || val.isEmpty ? 'Please select a property type' : null,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child:
                            _buildDropdownRow('Buy/Rent', buy_rent, _selectedItem1, (val) => setState(() => _selectedItem1 = val),
                              validator: (val) => val == null || val.isEmpty ? 'Please select a Buy/Rent' : null,
                            ),
                        ),
                      ],
                    ),
                    if (_selectedItem1 == "Buy") ...[
                      const SizedBox(width: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _blueDropdownRow(
                              'Registry',
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
                            child: _blueDropdownRow(
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
      
                    // const SizedBox(height: 10,),
      
                    _buildSectionCard(
                      child: DropdownButtonFormField<String>(
                        value: _furnished,
                        decoration: InputDecoration(
                          labelText: "",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true, // ✅ enable background color
                                  fillColor: Colors.grey.shade800,
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
                      _selectedParking,
                          (val) => setState(() => _selectedParking = val),
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
                          child:
                          _buildTextInput('Flat Number', _FlatNumber,keyboardType: TextInputType.name),
      
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextInput('Sqft', _sqft,keyboardType: TextInputType.phone),
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
                            title: 'Available Date  ',
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
                                      : 'Select Available Date', // placeholder
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
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
      
      
                        labelText:"Show Price (₹)",
      
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
                              ? Colors.white
                              : Colors.black,
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
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                        filled: true,
                        fillColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey.shade900
                            : Colors.white,
                      ),
                      validator: (val) => val == null || val.isEmpty ? "Enter Amount" : null,
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _lastPrice,
                      keyboardType: TextInputType.number,
                      decoration: _buildInputDecoration(
                        context,
                        "Last Price (₹) by owner",
                      ).copyWith(
                        suffix: Text(
                          _formattedLastPrice,
                          style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
      
                        ),
                      ),
                      validator: (val) => val == null || val.isEmpty ? "Enter Amount" : null,
      
                    ),
                    const SizedBox(height: 10,),
                    TextFormField(
                      controller: _askingPrice,
                      keyboardType: TextInputType.number,
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
                      validator: (val) => val == null || val.isEmpty ? "Enter Amount" : null,
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
                                decoration: InputDecoration(
                                  labelText: "Enter Maintenance Fee",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
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
      
      
                    const SizedBox(height: 16,),
      
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Dropdown for House Meter Type
                        DropdownButtonFormField<String>(
                          value: (_houseMeter != null && _houseMeter != 'Custom')
                              ? _houseMeter
                              : (_meter.text.isNotEmpty ? 'Custom' : null),
                          decoration: _buildInputDecoration(context, "House Meter Type"),
                          items: ['Commercial', 'Govt', 'Custom'].map((option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(option,style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              _houseMeter = val;
                              if (val != 'Custom') {
                                _meter.text = val!; // assign predefined value
                              } else {
                                _meter.clear(); // clear for custom input
                              }
                            });
                          },
                          validator: (val) => (val == null || val.isEmpty)
                              ? "Select house meter type"
                              : null,
      
                        ),
      
                        const SizedBox(height: 20),
      
                        // Show custom input if 'Custom' is selected
                        if (_houseMeter == 'Custom')
                          _blueTextInput(
                            'Enter Meter amount per Unit',
                            _meter,
                            keyboardType: TextInputType.number,
                          ),
                      ],
                    ),
                    buildTextInput('Video Link', _videoLink),
                    buildTextInput('Caretaker Name (Optional)', _CareTaker_name),
                    buildTextInput('Caretaker Mobile (Optional)', _CareTaker_number,keyboardType: TextInputType.phone,validateLength: true),
                    buildTextInput('Owner Name (Optional)', _Ownername),
                    buildTextInput('Owner Mobile (Optional)', _Owner_number,keyboardType: TextInputType.phone,validateLength: true),
      
                  ],
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: _isLoading
                      ? null
                      : () async {
                    // ✅ Validate form before starting countdown
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
                          "Add Flat",
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
                )
              ],
            ),
          ),
        ),
      )),
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
Widget _buildInputDecoration(String label, TextEditingController controller, BuildContext context, {IconData? icon}) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return TextFormField(
    controller: controller,
    style: TextStyle(
      color: isDark ? Colors.white : Colors.black, // typing text color
    ),
    decoration: InputDecoration(
      labelText: label,
      hintText: 'Enter $label',
      hintStyle: TextStyle(
        color: isDark ? Colors.grey.shade400 : Colors.grey.shade500,
      ),
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        color: isDark ? Colors.grey.shade300 : Colors.black54,
      ),
      prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
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
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.white,
    ),
    validator: (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter $label';
      }
      return null;
    },
  );
}
