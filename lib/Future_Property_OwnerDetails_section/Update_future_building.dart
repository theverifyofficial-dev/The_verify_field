import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/property_id_for_multipleimage_provider.dart';
import '../constant.dart';
import 'Future_property_details.dart';
import 'package:geocoding/geocoding.dart';

class Catid {
  final int id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeofProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squarefit;
  final String maintenance;
  final String parking;
  final String ageOfProperty;
  final String fieldWorkerAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishing;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String fieldWorkerCurrentLocation;
  final String caretakerName;
  final String caretakerNumber;
  final String longitude;
  final String latitude;
  final String videoLink;
  final int subid;

  Catid({
    required this.id,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeofProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squarefit,
    required this.maintenance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldWorkerAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishing,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.fieldWorkerCurrentLocation,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.subid,
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeofProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintenance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldWorkerAddress: json['fieldworkar_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDate: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishing: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      fieldWorkerCurrentLocation: json['field_worker_current_location'] ?? '',
      caretakerName: json['care_taker_name'] ?? '',
      caretakerNumber: json['care_taker_number'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      subid: json['subid'] ?? 0,
    );
  }
}
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class UpdateRealEstateProperty extends StatefulWidget {
  final int propertyId;

  const UpdateRealEstateProperty({super.key, required this.propertyId});

  @override
  State<UpdateRealEstateProperty> createState() => _UpdateRealEstatePropertyState();
}

class _UpdateRealEstatePropertyState extends State<UpdateRealEstateProperty> {
  final _formKey = GlobalKey<FormState>();

  List<String> selectedFacilities=[];

  String? selectedRoadSize;
  String? selectedMetroDistance;
  String? metro_name;
  String? selectedMarketDistance;
  String? _ageOfProperty;
  String? _totalFloor;
  String? _selectedLift;
  String? _selectedParking;
  String? _selectedPropertyType;



  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _Building_information = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();
  final TextEditingController apartment_name = TextEditingController();

  final List<String> roadSizeOptions = ['15 Feet', '20 Feet', '25 Feet', '30 Feet', '35 Feet', '40 Above',''];
  final List<String> metroDistanceOptions = ['200 m', '300 m', '400 m', '500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''];
  final List<String> metro_nameOptions = ['Hauz khas', 'Malviya Nagar', 'Saket','Qutub Minar','ChhattarPur','Sultanpur', 'Ghitorni','Arjan Garh','Guru Drona','Sikanderpur','Dwarka Mor',''];
  final List<String> _items_floor2 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor',''];

  final List<String> marketDistanceOptions =  ['200 m', '300 m', '400 m', '500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''];
  final List<String> Age_Options = ['1 years', '2 years', '3 years', '4 years','5 years','6 years','7 years','8 years','9 years','10 years','10+ years',''];
  List<String> allFacilities = ['CCTV Camera', 'Lift', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline",''];

  String long = '';
  String lat = '';
  String? _networkImageUrl;
  String full_address = '';
  File? _imageFile;

  void _loadSavedFieldWorkerData() async {
    final prefs = await SharedPreferences.getInstance();

    final savedName = prefs.getString('name') ?? '';
    final savedNumber = prefs.getString('number') ?? '';

    setState(() {
      //_name = savedName;
      //_number = savedNumber;
    }
    );
  }



  String? _selectedItem;
  String? apiImageUrl;


  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Rajpur Khurd','Mangalpuri','Dwarka Mor','Uttam Nagar','Nawada',''];

  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent',''];

  List<String> name = ['1 BHK','2 BHK','3 BHK', '4 BHK','1 RK','Commercial SP',''];

  void _loadSavedLatLong() async {
    final latLong = await getSavedLatLong();
    print('Latitude: ${latLong['Latitude']}');
    print('Longitude: ${latLong['Longitude']}');

    // If you want to set it to a controller or variable, do it here
    setState(() {
      _latitude = latLong['Latitude'] ?? '';
      _longitude = latLong['Longitude'] ?? '';
    });
  }
  String _latitude = '';
  String _longitude = '';
  Future<Map<String, String>> getSavedLatLong() async {
    final prefs = await SharedPreferences.getInstance();
    final lat = prefs.getDouble('latitude')?.toString() ?? '';
    final long = prefs.getDouble('longitude')?.toString() ?? '';
    return {
      'Latitude': lat,
      'Longitude': long,
    };
  }
  @override
  void initState() {
    super.initState();
    autofillFormFields();
    _loadSavedLatLong();


    Future.microtask(() async {
      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId();
      _loadSavedFieldWorkerData();

    });
  }

  Future<List<FutureProperty2>> fetchData() async {
    var url = Uri.parse("https://verifyserve.social/WebService4.asmx/display_future_property_by_id?id=${widget.propertyId}");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List listResponse = json.decode(response.body);
      listResponse.sort((a, b) => b['id'].compareTo(a['id']));
      return listResponse.map((data) => FutureProperty2.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occurred!');
    }
  }

  void autofillFormFields() async {
    try {
      final dataList = await fetchData();
      if (dataList.isNotEmpty) {
        print(dataList);
        final data = dataList.first;
        _networkImageUrl = "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/"+data.images;
        _facilityController.text = data.facility;
        apiImageUrl = data.images;
        _selectedItem = data.place;
        print(data.place);
        _selectedItem1 = data.buyRent;
        apartment_name.text = data.apartmentName;
        _vehicleno.text = data.ownerVehicleNumber;
        _address.text = data.propertyNameAddress;
        _totalFloor = data.totalFloor;
        _Address_apnehisaabka.text = data.propertyAddressForFieldworker;
        _Ownername.text = data.ownerName;
        _Owner_number.text = data.ownerNumber;
        _CareTaker_name.text = data.caretakerName;
        _CareTaker_number.text = data.caretakerNumber;
        _Building_information.text = data.buildingInformationFacilities;
        metro_name = data.metroName;
        _ageOfProperty = data.ageOfProperty;
        selectedMetroDistance = data.metroDistance;
        selectedRoadSize = data.roadSize;
        selectedMarketDistance = data.mainMarketDistance;
        _Google_Location.text = data.yourAddress;
        _selectedLift = data.lift;
        _selectedParking = data.parking;
        _selectedPropertyType = data.residenceCommercial;
        lat = data.longitude; 
        long = data.latitude;
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
  bool _isLoading = true;
  Map<String, int> _selectedFurniture = {};
  final List<String> furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
    '',
  ];
  final List<String> lift = ['Yes','No',''];
  List<String> parkingOptions = ['Yes','No',''];
  final List<String> propertyTypes = ['Residential', 'Commercial',''];

  final ImagePicker _picker = ImagePicker();

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

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath = '${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85,
    );

    return result;
  }


  Future<void> updateImageWithTitle(File? imageFile) async {

      String uploadUrl = 'https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/update_allfeilds_with_single_image.php';

    print('Starting update to: $uploadUrl');
    FormData formData = FormData();

      // ✅ Case 1: new image picked
      if (imageFile != null) {
        formData.files.add(
          MapEntry(
            "images",
            await MultipartFile.fromFile(
              imageFile.path,
              filename: imageFile.path.split('/').last,
            ),
          ),
        );
      }
// ✅ Case 2: no new image → send old image name/url
      else if (apiImageUrl != null && apiImageUrl!.isNotEmpty) {
        formData.fields.add(MapEntry("images", apiImageUrl!));
      }

    List<MapEntry<String, String>> fields = [
      MapEntry("id", widget.propertyId.toString()),
      MapEntry("ownername", _Ownername.text ?? ''),
      MapEntry("ownernumber", _Owner_number.text ?? ''),
      MapEntry("caretakername", _CareTaker_name.text ?? ''),
      MapEntry("caretakernumber", _CareTaker_number.text ?? ''),
      MapEntry("place", _selectedItem ?? ''),
      MapEntry("buy_rent", _selectedItem1 ?? ''),
      MapEntry("propertyname_address", _address.text),
      MapEntry("building_information_facilitys", _Building_information.text),
      MapEntry("property_address_for_fieldworkar", _Address_apnehisaabka.text),
      MapEntry("owner_vehical_number", _vehicleno.text ?? ''),
      MapEntry("your_address", _Google_Location.text),
      MapEntry("road_size", selectedRoadSize ?? ''),
      MapEntry("metro_distance", selectedMetroDistance ?? ''),
      MapEntry("metro_name", metro_name.toString()),
      MapEntry("main_market_distance", selectedMarketDistance ?? ''),
      MapEntry("age_of_property", _ageOfProperty ?? ''),
      MapEntry("total_floor", _totalFloor ?? ''),
      MapEntry("Residence_Commercial", _selectedPropertyType.toString()),
      MapEntry("lift", _selectedLift.toString()),
      MapEntry("parking", _selectedParking.toString()),
          //selectedFacilities.contains("Parking") ? 'yes' : 'no'),
      MapEntry("facility", _facilityController.text),
    ];
    formData.fields.addAll(fields);

    print('📝 Fields to send (${fields.length}):');
    for (var field in fields) {
      print('➡️ ${field.key}: ${field.value}');
    }

    Dio dio = Dio();

    try {
      Response response = await dio.post(
        uploadUrl,
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          validateStatus: (status) => status! < 500, // Let 400 come through
        ),
      );
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
  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.grey,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionCard(
                title: 'Upload Main Image',
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.upload, color: Colors.white),
                      label: const Text('Pick Image', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.blue.shade600),
                      onPressed: () async {
                        XFile? pickedXFile = await pickAndCompressImage();
                        File? pickedImage = pickedXFile != null ? File(pickedXFile.path) : null;

                        setState(() {
                          if (pickedImage != null) {
                            _imageFile = pickedImage;  // New image selected
                          } else {
                            _imageFile = null;         // Keep it null, means "no new image"
                          }
                        });
                      },
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
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child:
                    _buildDropdownRow('Place', _items, _selectedItem, (val) => setState(() => _selectedItem = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select a Place' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                    _buildDropdownRow('Buy / Rent', _items1, _selectedItem1, (val) => setState(() => _selectedItem1 = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select a Buy/Rent' : null,
                    ),
                  ),
                ],
              ),

              Row(
                children: [
                  Expanded(
                    child: _buildDropdownRow(
                      'Lift Availability',
                      lift,
                      _selectedLift,
                          (val) => setState(() => _selectedLift = val),
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Lift Availability' : null,
                    ),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: _buildDropdownRow(
                      'Property Type',
                      propertyTypes,
                      _selectedPropertyType,
                          (val) => setState(() => _selectedPropertyType = val),
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Select Property Type' : null,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child:   _buildDropdownRow(
                      'Parking',
                      parkingOptions,
                      _selectedParking,
                          (val) => setState(() => _selectedParking = val),
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Select Property Type' : null,
                    ),
                  ),
                  SizedBox(width: 6,),
                  Expanded(
                    child: _buildDropdownRow('Total floor', _items_floor2, _totalFloor, (val) => setState(() => _totalFloor = val),
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Select Property Type' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              buildTextInput('Owner Name (Optional)', _Ownername,),
              buildTextInput('Owner No. (Optional)', _Owner_number,keyboardType: TextInputType.phone,validateLength: true ),
              buildTextInput('CareTaker Name (Optional)', _CareTaker_name,),
              buildTextInput('CareTaker No. (Optional)', _CareTaker_number,keyboardType: TextInputType.phone,validateLength: true ),

              _buildTextInput('Property Name & Address', _address),
              _buildSectionCard(
                child: TextFormField(
                  controller: _facilityController,
                  autovalidateMode: AutovalidateMode.always, // ✅ show error on load
                  readOnly: true, // Prevents manual editing
                  onTap: _showFacilitySelectionDialog, // Opens the selection dialog
                  style:  TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Select Facilities',
                    hintStyle:  TextStyle(color: Colors.grey.shade800),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Colors.grey.shade100,
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
                  validator: (val) =>
                  val == null || val.isEmpty
                      ? "Select facilities"
                      : null,
                ), title: 'Facility',
              ),

              const SizedBox(height: 10,),

              _buildDropdownRow(
                'Road width (in ft)',
                roadSizeOptions,
                selectedRoadSize,
                    (val) => setState(() => selectedRoadSize = val),
                validator: (val) => val == null || val.isEmpty ? 'Please select road size' : null,
              ),

              _buildDropdownRow(
                'Age of property (in years)',
                Age_Options,
                _ageOfProperty,
                    (val) => setState(() => _ageOfProperty = val),
                validator: (val) => val == null || val.isEmpty ? 'Please select Age of property' : null,
              ),

              Row(
                children: [
                  Expanded(
                    child:
                    _buildDropdownRow(
                      'Metro Name',
                      metro_nameOptions,
                      metro_name,
                          (val) => setState(() => metro_name = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select metro Name' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child:
                    _buildDropdownRow(
                      'Metro Distance',
                      metroDistanceOptions,
                      selectedMetroDistance,
                          (val) => setState(() => selectedMetroDistance = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select metro distance' : null,
                    ),
                  ),
                ],
              ),
              _buildDropdownRow(
                'Market Distance',
                marketDistanceOptions,
                selectedMarketDistance,
                    (val) => setState(() => selectedMarketDistance = val),
                validator: (val) => val == null || val.isEmpty ? 'Please select market distance' : null,
              ),

              _buildTextInput('Address for Field Worker', _Address_apnehisaabka),
              buildTextInput('Owner Vehicle Number (Optional)', _vehicleno,),

              _buildTextInput('Google Location', _Google_Location, icon: PhosphorIcons.map_pin),

              const SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(width: 1, color: Colors.grey.shade600),
                ),
                child: Text.rich(
                    TextSpan(
                        text: 'Note :',
                        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,fontFamily: 'Poppins',letterSpacing: 0,color: Colors.black),
                        children: <InlineSpan>[
                          TextSpan(
                            text: ' Enter Address manually or get your current Address from one tap on location icon.',
                            style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black,fontFamily: 'Poppins',letterSpacing: 0),
                          )
                        ]
                    )),
              ),
              SizedBox(height: 20),

        InkWell(
            onTap: () async {
      try {
      double? latitude;
      double? longitude;

      // Validate API lat & long before using
      bool isLatValid = lat != null &&
      lat.toString().trim().isNotEmpty &&
      double.tryParse(lat.toString().trim()) != null;
      bool isLongValid = long != null &&
      long.toString().trim().isNotEmpty &&
      double.tryParse(long.toString().trim()) != null;

      if (isLatValid && isLongValid) {
      latitude = double.parse(lat.toString().trim());
      longitude = double.parse(long.toString().trim());
      print("✅ Using API coordinates → Lat: $latitude, Long: $longitude");
      } else {
      print("⚠️ Invalid or missing API coordinates. Fetching current location...");

      // Request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
      permission == LocationPermission.denied) {
      print("❌ Location permission denied by user");
      return;
      }

      // Get current location
      Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

      latitude = position.latitude;
      longitude = position.longitude;
      print("📍 Using device location → Lat: $latitude, Long: $longitude");
      }

      // Fetch address using coordinates
      List<Placemark> placemarks =
      await placemarkFromCoordinates(latitude!, longitude!);

      String output = 'Unable to fetch location';
      if (placemarks.isNotEmpty) {
      final place = placemarks.first;
      output = [
      place.street,
      place.subLocality,
      place.locality,
      place.subAdministrativeArea,
      place.administrativeArea,
      place.country,
      place.postalCode
      ].where((e) => e != null && e.isNotEmpty).join(', ');
      }

      setState(() {
      full_address = output;
      _Google_Location.text = full_address;
      });

      print('✅ Your Current Address: $full_address');
      } catch (e) {
      print('❌ Error fetching address: $e');
      }
      },
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(10),
              bottomLeft: Radius.circular(10),
            ),
            border: Border.all(width: 1, color: Colors.blue),
            color: Colors.blue.shade600,
          ),
          child: const Center(
            child: Text(
              'Get Current Location',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontFamily: 'Poppins',
                letterSpacing: 1,
              ),
            ),
          ),
        ),
      ),


      const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  onPressed: _isLoading
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
                            // Countdown logic
                            Future.delayed(const Duration(seconds: 1), () async {
                              if (countdown > 1) {
                                setStateDialog(() {
                                  countdown--;
                                });
                              } else {
                                // ✅ Countdown finished, show verified icon
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

                                // Optionally: go back after a short delay
                                await Future.delayed(const Duration(seconds: 1));
                                if (mounted) Navigator.of(context).pop();
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      : const Text(
                    "Submit",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields.");
      return;
    }

    // ✅ Always call updateImageWithTitle, even if no new image picked
    await updateImageWithTitle(_imageFile);

  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity, // 🔥 Forces full width
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
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
        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: 'Enter $label',
            hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),

            prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: Colors.grey.shade100
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

  Widget _buildTextInput(
      String label,
      TextEditingController controller, {
        IconData? icon,
        TextInputType? keyboardType,
        bool validate10Digits = false, // <-- extra flag
      }) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
        decoration: InputDecoration(
          hintText: 'Enter $label',
          hintStyle: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),

          prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
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
        maxLines: 1,
        inputFormatters: validate10Digits
            ? [
          FilteringTextInputFormatter.digitsOnly, // only numbers
          LengthLimitingTextInputFormatter(10),  // max 10 digits
        ]
            : [],
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Please enter $label';
          }
          if (validate10Digits) {
            if (value.trim().length != 10) {
              return '$label must be exactly 10 digits';
            }
          }
          return null;
        },
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
        style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),

        validator: validator,
        autovalidateMode: AutovalidateMode.always, // ✅ show error on load
        dropdownColor: Colors.grey.shade100,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey.shade200,
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
          child: Text(item, style:  TextStyle(color: Colors.grey.shade800,fontSize: 11)),
        ))
            .toList(),
      ),
    );
  }


  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins');
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
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
      filled: true,
      fillColor: isDark ? Colors.grey.shade900 : Colors.white,

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