import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant.dart';
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

  final List<String> _items = ['SultanPur','Manglapuri'];
  final List<String> bhkOptions = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial'];
  final List<String> _resCommOptions = ['Residential', 'Commercial'];
  final List<String> _yesNo = ['Yes', 'No'];
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
      return '${(value / 100000).toStringAsFixed(2)}Lac';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(2)}k';
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
    // Initialize furnishing & furnitureController based on your saved/fetched data:
    // if (_furnishing != null &&
    //     (_furnishing == 'Fully Furnished' || _furnishing == 'Semi Furnished')) {
    //   _selectedFurniture = parseFurnitureString(furnitureController.text);
    // }
    // else {
    //   _selectedFurniture.clear();
    //   furnitureController.clear();
    // }
  }

  DateTime uploadDate = DateTime.now();


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

  Future<void> updateImageWithTitle(File? imageFile) async {
    String uploadUrl = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/update_flat_in_future_property.php';

    print('Starting update to: $uploadUrl');
    FormData formData = FormData();

    // ✅ Only attach image if a new one is picked
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
      MapEntry("owner_name", _Ownername.text.trim()),
      MapEntry("Balcony", balcony.toString()),
      MapEntry("Flat_number", _FlatNumber.text),
      MapEntry("owner_number", _Owner_number.text),
      MapEntry("care_taker_name", _CareTaker_name.text.trim()),
      MapEntry("care_taker_number", _CareTaker_number.text),
      MapEntry("locations", _selectedItem.toString()),
      MapEntry("Buy_Rent", _selectedItem1 ?? ''),
      MapEntry("Residence_Commercial", _residenceCommercial ?? ''),
      MapEntry("Typeofproperty", selectedPropertyType ?? ''),
      MapEntry("Bhk", selectedBHK ?? ''),
      MapEntry("Floor_", _floor1 ?? ''),
      MapEntry("Total_floor", _totalFloor.toString()),
      MapEntry("squarefit", _sqft.text),
      MapEntry("maintance", (_maintenance == "Custom" ? _customMaintenance ?? '' : _maintenance) ?? ''),
      MapEntry("Apartment_name", _ApartmentName.text.trim()),
      MapEntry("Apartment_Address", _Apartment_Address.text),
      MapEntry("fieldworkar_address", field_address.text),
      MapEntry("field_worker_current_location", _Google_Location.text),
      MapEntry("parking", parking.toString()),
      MapEntry("field_warkar_name", _name),
      MapEntry("field_workar_number", _number),
      MapEntry("current_dates", uploadDate.toIso8601String()),
      MapEntry("available_date", _availableDate.toString()),
      MapEntry("Longitude", _Longitude.text),
      MapEntry("Latitude", _Latitude.text),
      MapEntry("kitchen", kitchen.toString()),
      MapEntry("bathroom", bathroom.toString()),
      MapEntry("live_unlive", "Flat"), // <-- Static value sent to API
      MapEntry("lift", _lift.toString()),
      MapEntry("Facility", _facilityController.text),
      MapEntry(
        "furnished_unfurnished",
        (_furnished == 'Semi Furnished' || _furnished == 'Fully Furnished')
            ? (_selectedFurniture.entries.map((e) => '${e.key}(${e.value})').join(', '))
            : (_furnished ?? ''),
      ),
      MapEntry("registry_and_gpa", _registry.toString()),
      MapEntry("loan", _loan.toString()),
      MapEntry("show_Price", _formattedPrice),
      MapEntry("Last_Price", _formattedLastPrice),
      MapEntry("asking_price", _formattedAskingPrice),
      MapEntry("meter", _meter.text),
      MapEntry("subid", widget.id),
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

  Map<String, int> parseFurnitureString(String input) {
    final Map<String, int> furnitureMap = {};
    final regex = RegExp(r'([^,]+)\((\d+)\)');
    // Matches: "Modular Kitchen(2)", "AC(2)" etc.

    for (final match in regex.allMatches(input)) {
      final name = match.group(1)?.trim() ?? '';
      final count = int.tryParse(match.group(2) ?? '0') ?? 0;
      if (name.isNotEmpty && count > 0) {
        furnitureMap[name] = count;
      }
    }

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
      'Fan', 'Light', 'Wardrobe', 'AC', 'Modular Kitchen', 'Chimney',
      'Single Bed', 'Double Bed', 'Geyser', 'Led Tv', 'Sofa Set',
      'Dining Table', 'Induction', 'Gas Stove',
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
          padding: MediaQuery
              .of(ctx)
              .viewInsets,
          child: StatefulBuilder(
            builder: (context, setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Select Furniture',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height * 0.5,
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
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
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
                                        Text(item, style: const TextStyle(
                                            fontSize: 16)),
                                      ],
                                    ),
                                    if (isSelected)
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(
                                                Icons.remove_circle_outline),
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
                                            icon: const Icon(
                                                Icons.add_circle_outline),
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

  Future<List<Property1>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_flat_in_future_property_details_page?id=${widget.id}");
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
        _networkImageUrl = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/"+data.propertyPhoto;
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
        _CareTaker_number.text = data.careTakerNumber;
        _Owner_number.text = data.ownerNumber;
        _Ownername.text = data.ownerName;
        _maintenance = data.maintenance;
        balcony = data.balcony;
        _sqft.text = data.squareFit;
        parking = data.parking;
        _availableDate = data.availableDate;
        kitchen = data.kitchen;
        bathroom = data.bathroom;
        _lift = data.lift;
        field_address.text = data.fieldWorkerAddress;
        _Google_Location.text = data.fieldWorkerCurrentLocation;
        _meter.text = data.meter;
        parseFurnishingFromApi(data.furnishedUnfurnished ?? '');
        _customMaintenanceController.text = data.maintenance;
        _customMaintenance = data.maintenance;
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

    // ✅ Always call updateImageWithTitle, even if no new image picked
    await updateImageWithTitle(_imageFile);
  }

  final List<String> _typeofproperty = ['Flat','Office','Shop','Farms','Godown','Plots'];

  List<String> name = ['Lift','Security CareTaker','GOVT Meter','CCTV','Gas Meter'];

  String? _selectedItem1;
  final List<String> buy_rent = ['Buy', 'Rent'];
  final List<String> yesNoOptions = ['Yes', 'No'];
  String? _floor1;
  final List<String> _items_floor1 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor'];
  final List<String> _items_floor2 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor'];

  final List<String> _balcony_items = ['Front', 'Back', 'Side', 'Park Facing', 'Road Facing', 'Corner', 'No Balcony',];

  final List<String> _Parking_items = ['Car','Bike','Both'];

  final List<String> _kitchen_items = ['Western Style','Indian Style','No'];

  final List<String> _bathroom_items = ['Western Style','Indian Style','No'];
  List<String> allFacilities = ['CCTV Camera', 'Lift', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline"];


  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
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
                              : _networkImageUrl != null && _networkImageUrl!.isNotEmpty
                              ? ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              _networkImageUrl!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          )
                              : Center(child: Text('No image selected.',style: TextStyle(color: Colors.black),)),

                        ),
                      ],
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
                                    yesNoOptions,
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
                              child: Text(option),
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
                                        : 'Select Available Date',
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
                        ),
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
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
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
                          // Dropdown for House Meter Type
                          DropdownButtonFormField<String>(
                            value: (_houseMeter != null && _houseMeter != 'Custom')
                                ? _houseMeter
                                : (_meter.text.isNotEmpty ? 'Custom' : null),
                            decoration: _buildInputDecoration(context, "House Meter Type"),
                            items: ['Commercial', 'Govt', 'Custom'].map((option) {
                              return DropdownMenuItem<String>(
                                value: option,
                                child: Text(option),
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
                              'Enter Custom Meter Type',
                              _meter,
                              keyboardType: TextInputType.text,
                            ),
                        ],
                      ),

                      _buildTextInput('Caretaker Name', _CareTaker_name),
                      _buildTextInput('Caretaker Mobile', _CareTaker_number,keyboardType: TextInputType.phone),
                      _buildTextInput('Owner Name', _Ownername),
                      _buildTextInput('Owner Mobile', _Owner_number,keyboardType: TextInputType.phone),

                    ],
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      _handleUpload();
                    },
                    child: Center(
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                                bottomLeft: Radius.circular(40)),
                            color: Colors.red),
                        child: _isLoading
                            ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Center(
                          child: Text(
                            "Submit",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'poppins',
                                letterSpacing: 0.8,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
    return _buildSectionCard(
      title: label,

      child: DropdownButtonFormField<String>(
        value: selectedValue,
        validator: validator,
        // dropdownColor: Colors.blue,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.blue,

          border: OutlineInputBorder
            (borderRadius: BorderRadius.circular(10)),
        ),
        style: const TextStyle(),
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
        ),
        style: const TextStyle(),
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
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
        // color: isDark ? Colors.grey.shade300 : Colors.black54,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        // borderSide: BorderSide(
        //     color: isDark ? Colors.grey.shade700 : Colors.grey.shade300),
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
  }  void _showFacilitySelectionDialog() async {
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
            labelStyle: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Theme
                  .of(context)
                  .brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.black54,
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
