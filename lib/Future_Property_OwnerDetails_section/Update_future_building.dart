import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/property_id_for_multipleimage_provider.dart';
import '../constant.dart';
import '../utilities/bug_founder_fuction.dart';
import 'metro_api.dart';

// ----------------- Model -----------------
class Catid {
  final int id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String totalFloor;
  final String balcony;
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
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.totalFloor,
    required this.balcony,
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
      residenceCommercial: json['Residence_commercial'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
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

// ----------------- Update Form -----------------
class UpdateRealEstateProperty extends StatefulWidget {
  final int propertyId;


  const UpdateRealEstateProperty({super.key, required this.propertyId});

  @override
  State<UpdateRealEstateProperty> createState() => _UpdateRealEstatePropertyState();
}

class _UpdateRealEstatePropertyState extends State<UpdateRealEstateProperty> {
  final _formKey = GlobalKey<FormState>();

  List<String> selectedFacilities = [];

  String? selectedRoadSize;
  String? selectedMetroDistance;
  String? metro_name;
  String? selectedMarketDistance;
  String? _ageOfProperty;
  String? _totalFloor;
  String? _selectedLift;
  String? _selectedParking;
  String? _selectedPropertyType;

  // text controllers
  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _facilityController = TextEditingController();

  // NEW: metro/locality controllers and list
  final TextEditingController metroController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  List<String> selectedLocalities = [];

  final List<String> roadSizeOptions = ['15 Feet', '20 Feet', '25 Feet', '30 Feet', '35 Feet', '40 Above',''];
  final List<String> metroDistanceOptions = ['200 m', '300 m', '400 m', '500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''];
  final List<String> metro_nameOptions = ['','']; // kept but not used (picker used)
  final List<String> _items_floor2 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor',''];

  final List<String> marketDistanceOptions =  ['200 m', '300 m', '400 m', '500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''];
  final List<String> Age_Options = ['1 years', '2 years', '3 years', '4 years','5 years','6 years','7 years','8 years','9 years','10 years','10+ years',''];
  List<String> allFacilities = ['CCTV Camera', 'Lift', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline",''];

  String long = '';
  String lat = '';
  String? _networkImageUrl;
  String full_address = '';
  File? _imageFile;

  String? _selectedItem;
  String? apiImageUrl;

  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Rajpur Khurd','Mangalpuri','Dwarka Mor','Uttam Nagar','Nawada','Vasant Kunj',''];
  String? _selectedItem1;
  final List<String> _items1 = ['Buy','Rent',''];

  String _latitude = '';
  String _longitude = '';

  bool _isLoading = true;
  final List<String> furnishingOptions = [
    'Fully Furnished',
    'Semi Furnished',
    'Unfurnished',
    '',
  ];
  final List<String> lift = ['Yes','No',''];
  List<String> parkingOptions = ['Yes','No',''];
  final List<String> propertyTypes = ['Residential', 'Commercial'];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    autofillFormFields();
    _loadSavedLatLong();

    Future.microtask(() async {
      final provider = Provider.of<PropertyIdProvider>(context, listen: false);
      await provider.fetchLatestPropertyId();
    });
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

  void _loadSavedLatLong() async {
    final latLong = await getSavedLatLong();
    setState(() {
      _latitude = latLong['Latitude'] ?? '';
      _longitude = latLong['Longitude'] ?? '';
    });
  }

  Future<List<FutureProperty2>> fetchData() async {
    var url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_for_details_page.php?id=${widget.propertyId}"
    );

    final res = await http.get(url);

    if (res.statusCode != 200) throw Exception("API error");

    final decoded = jsonDecode(res.body);

    if (decoded is Map && decoded.containsKey("data")) {
      List list = decoded["data"];
      return list.map((e) => FutureProperty2.fromJson(e)).toList();
    }
    else{
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_for_details_page.php?id=${widget.propertyId}",
        error: res.body.toString(),
        statusCode: res.statusCode ?? 0,
      );
    }

    throw Exception("Invalid API structure");
  }

  void autofillFormFields() async {
    try {
      final dataList = await fetchData();
      if (dataList.isNotEmpty) {
        final data = dataList.first;

        // network image
        _networkImageUrl = "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/" + (data.images.isNotEmpty ? data.images : '');

        // regular fields
        _facilityController.text = data.facility;
        apiImageUrl = data.images;
        _selectedItem = data.place;
        _selectedItem1 = data.buyRent;
        _vehicleno.text = data.ownerVehicleNumber;
        _address.text = data.propertyNameAddress;
        _totalFloor = data.totalFloor;
        _Address_apnehisaabka.text = data.propertyAddressForFieldworker;
        _Ownername.text = data.ownerName;
        _Owner_number.text = data.ownerNumber;
        _CareTaker_name.text = data.caretakerName;
        _CareTaker_number.text = data.caretakerNumber;
        metro_name = data.metroName;
        _ageOfProperty = data.ageOfProperty;
        selectedMetroDistance = data.metroDistance;
        selectedRoadSize = data.roadSize;
        selectedMarketDistance = data.mainMarketDistance;
        _Google_Location.text = data.yourAddress;
        _selectedLift = data.lift;
        _selectedParking = data.parking;
        _selectedPropertyType = normalizePropertyType(data.residenceCommercial);
        lat = data.longitude;
        long = data.latitude;
        metroController.text = data.metroName;
        print('metro name : ${data.metroName}');

// split localities into list
        if (data.localities_list.isNotEmpty) {
          selectedLocalities = data.localities_list.split(", ").toList();
          localityController.text = selectedLocalities.join(", ");
        }


        setState(() {
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        _isLoading = false;
      });
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

  final TextEditingController localityCtrl = TextEditingController();


  String normalizePropertyType(String? val) {
    if (val == null) return '';
    if (val.toLowerCase().startsWith('res')) return 'Residential';
    if (val.toLowerCase().startsWith('com')) return 'Commercial';
    return val;
  }

  Future<void> updateImageWithTitle(File? imageFile) async {
    String uploadUrl =
        'https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/update_allfeilds_with_single_image.php';

    var uri = Uri.parse(uploadUrl);
    var request = http.MultipartRequest('POST', uri);

    // ----------------------------------------------------------
    // IMAGE HANDLING (NEW IMAGE / OLD IMAGE / NO IMAGE)
    // ----------------------------------------------------------
    if (imageFile != null) {
      final fileName = imageFile.path.split("/").last;
      print("📸 Sending NEW image: $fileName");

      request.files.add(
        await http.MultipartFile.fromPath(
          'images',
          imageFile.path,
          contentType: http.MediaType('image', 'jpeg'),
        ),
      );
    } else if (apiImageUrl != null && apiImageUrl!.isNotEmpty) {
      print("📁 Sending OLD image path: $apiImageUrl");
      request.fields['images'] = apiImageUrl!;
    } else {
      print("⚠️ No image sent — backend will keep old image.");
    }

    // ----------------------------------------------------------
    // LOCALITY LIST
    // ----------------------------------------------------------
    final localityListString = selectedLocalities.join(', ');

    // ----------------------------------------------------------
    // ALL OTHER FIELDS
    // ----------------------------------------------------------
    request.fields.addAll({
      "id": widget.propertyId.toString(),
      "ownername": _Ownername.text,
      "ownernumber": _Owner_number.text,
      "caretakername": _CareTaker_name.text,
      "caretakernumber": _CareTaker_number.text,
      "place": _selectedItem ?? '',
      "buy_rent": _selectedItem1 ?? '',
      "propertyname_address": _address.text,
      "property_address_for_fieldworkar": _Address_apnehisaabka.text,
      "owner_vehical_number": _vehicleno.text,
      "your_address": _Google_Location.text,
      "road_size": selectedRoadSize ?? '',
      "metro_distance": selectedMetroDistance ?? '',
      "metro_name": metroController.text,
      "locality_list": localityListString,
      "main_market_distance": selectedMarketDistance ?? '',
      "age_of_property": _ageOfProperty ?? '',
      "total_floor": _totalFloor ?? '',
      "Residence_commercial": normalizePropertyType(_selectedPropertyType),
      "lift": _selectedLift.toString(),
      "parking": _selectedParking.toString(),
      "facility": _facilityController.text,
    });

    print("📝 Sending fields:");
    request.fields.forEach((k, v) => print(" - $k: $v"));

    try {
      // SEND REQUEST
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("Status Code: ${response.statusCode}");
      print("🔍 RAW RESPONSE BODY:");
      print(response.body);

      if (response.statusCode == 200) {
        showSnack("Property Updated Successfully");
        Navigator.pop(context);
      } else {
        await BugLogger.log(
            apiLink: uploadUrl,
            error: response.body.toString(),
            statusCode: response.statusCode ?? 0,
        );
        showSnack("Something went wrong");
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: uploadUrl,
        error: e.toString(),
        statusCode: 500,
      );
      print("Upload error: $e");
      showSnack("Upload failed: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: Colors.white)), backgroundColor: Colors.grey, duration: const Duration(seconds: 2)),
    );
  }
  void _addManualLocalityFromMain(String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    final parts = text.split(',');

    setState(() {
      for (final part in parts) {
        final loc = part.trim();
        if (loc.isNotEmpty &&
            !selectedLocalities
                .any((e) => e.toLowerCase() == loc.toLowerCase())) {
          selectedLocalities.add(loc);
        }
      }

      // update text field
      localityController.text = selectedLocalities.join(", ");
    });
  }

  @override
  Widget build(BuildContext context) {
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          _imageFile = pickedImage;
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
                          : Center(child: Text('No image selected.', style: TextStyle(color: Colors.black))),
                    ),
                  ],
                ),
              ),

              // ... other fields (place, buy/rent, floors etc.)
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownRow('Place', _items, _selectedItem, (val) => setState(() => _selectedItem = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select a Place' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownRow('Buy / Rent', _items1, _selectedItem1, (val) => setState(() => _selectedItem1 = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select a Buy/Rent' : null,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              buildTextInput('Owner Name (Optional)', _Ownername),
              buildTextInput('Owner No. (Optional)', _Owner_number, keyboardType: TextInputType.phone, validateLength: true),
              buildTextInput('CareTaker Name (Optional)', _CareTaker_name),
              buildTextInput('CareTaker No. (Optional)', _CareTaker_number, keyboardType: TextInputType.phone, validateLength: true),
              _buildTextInput('Property Name & Address', _address),
              _buildDropdownRow(
                'Property Type',
                propertyTypes,
                propertyTypes.contains(_selectedPropertyType)
                    ? _selectedPropertyType
                    : null,
                    (val) {
                  setState(() {
                    _selectedPropertyType = val;
                  });
                },
                validator: (val) =>
                val == null ? 'Please select property type' : null,
              ),

              _buildSectionCard(
                child: TextFormField(
                  controller: _facilityController,
                  readOnly: true, // Prevents manual editing
                  onTap: _showFacilitySelectionDialog, // Opens the selection dialog
                  style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    hintText: 'Select Facilities',
                    hintStyle:  TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                    border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                    filled: true,
                    fillColor: Colors.white,

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

              /// METRO STATION
              _buildSectionCard(
                title: "Metro Station",
                child: TextFormField(
                  controller: metroController,
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "Select Metro Station",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () {
                    showMetroLocalityPicker(context, (metro, localities) {
                      setState(() {
                        metroController.text = metro;

                        selectedLocalities = List.from(localities);

                        // 🔥 THIS IS THE KEY LINE
                        localityController.text = selectedLocalities.join(", ");
                      });
                    });
                  },
                ),
              ),

              const SizedBox(height: 12),

              /// LOCALITIES
              _buildSectionCard(
                title: "Localities",
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: localityController,
                      readOnly: false,
                      maxLines: 2,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),

                      // ⏎ Enter key support
                      onFieldSubmitted: (value) {
                        _addManualLocalityFromMain(value);
                      },

                      // , comma support
                      onChanged: (value) {
                        if (value.endsWith(',')) {
                          _addManualLocalityFromMain(value);
                        }
                      },

                      decoration: InputDecoration(
                        hintText: "Type locality or select from list",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      children: selectedLocalities.map((loc) {
                        return Chip(
                          label: Text(loc,style: TextStyle(color: Colors.black),),
                          backgroundColor: Colors.grey.shade200,
                          onDeleted: () {
                            setState(() {
                              selectedLocalities.remove(loc);
                              localityController.text =
                                  selectedLocalities.join(", ");
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),


              Row(
                children: [
                  Expanded(
                    child: _buildDropdownRow('Metro Distance', metroDistanceOptions, selectedMetroDistance, (val) => setState(() => selectedMetroDistance = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select metro distance' : null),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdownRow('Total floor', _items_floor2, _totalFloor, (val) => setState(() => _totalFloor = val),
                        validator: (val) => val == null || val.isEmpty ? 'Please select total floor' : null),
                  ),
                ],
              ),


              Row(
                children: [
                  Expanded(
                    child: _buildDropdownRow(
                      'Parking',
                      parkingOptions,
                      _selectedParking,
                          (val) => setState(() => _selectedParking = val),
                      validator: (val) => val == null || val.isEmpty ? 'Please select parking type' : null,
                    ),
                  ),
                  SizedBox(width: 6,),

                  Expanded(
                    child: _buildDropdownRow(
                      'Lift Availability',
                      parkingOptions,
                      _selectedLift,
                          (val) => setState(() => _selectedLift = val),
                      validator: (val) =>
                      val == null || val.isEmpty ? 'Lift Availability' : null,
                    ),
                  ),
                ],
              ),

              _buildDropdownRow('Road width (in ft)', roadSizeOptions, selectedRoadSize, (val) => setState(() => selectedRoadSize = val),
                  validator: (val) => val == null || val.isEmpty ? 'Please select road size' : null),

              _buildDropdownRow('Age of property (in years)', Age_Options, _ageOfProperty, (val) => setState(() => _ageOfProperty = val),
                  validator: (val) => val == null || val.isEmpty ? 'Please select Age of property' : null),

              _buildTextInput('Address for Field Worker', _Address_apnehisaabka),
              buildTextInput('Owner Vehicle Number (Optional)', _vehicleno),
              _buildTextInput('Google Location', _Google_Location, icon: PhosphorIcons.map_pin),

              const SizedBox(height: 20),
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
                  bool actionStarted = false; // 🔥 prevents multiple triggers

                  // Show countdown dialog
                  await showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) {
                      return StatefulBuilder(
                        builder: (context, setStateDialog) {
                          Future.delayed(const Duration(seconds: 1), () async {

                            // if (!actionStarted) {
                            //   actionStarted = true;
                            //   updateImageWithTitle(_imageFile).then((_) {
                            //     if (!mounted) return;
                            //
                            //     ScaffoldMessenger.of(context).showSnackBar(
                            //       const SnackBar(
                            //         content: Text("✅ Submitted Successfully!"),
                            //         backgroundColor: Colors.green,
                            //       ),
                            //     );
                            //     Navigator.pop(context);
                            //   });
                            // }

                            if (countdown > 1) {
                              setStateDialog(() {
                                countdown--;
                              });
                            } else {
                              setStateDialog(() {
                                countdown = 0;
                              });

                              await Future.delayed(const Duration(milliseconds: 1));
                              if (Navigator.of(context).canPop()) {
                                Navigator.of(context).pop(); // close dialog
                              }

                              // Run your upload logic
                              await updateImageWithTitle(_imageFile);

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
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
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

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        margin: const EdgeInsets.only(bottom: 20),
        child: Padding(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: _sectionTitleStyle()), const SizedBox(height: 10), child])),
      ),
    );
  }

  Widget buildTextInput(String label, TextEditingController controller, {IconData? icon, TextInputType? keyboardType, bool validateLength = false}) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(hintText: 'Enter $label', hintStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), filled: true, fillColor: Colors.grey.shade100),
        inputFormatters: validateLength ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : [],
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller, {IconData? icon, TextInputType? keyboardType, bool validate10Digits = false}) {
    return _buildSectionCard(
      title: label,
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        decoration: InputDecoration(hintText: 'Enter $label', hintStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black), prefixIcon: icon != null ? Icon(icon, color: Colors.redAccent) : null, border: const OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))), filled: true, fillColor: Colors.grey.shade100),
        maxLines: 1,
        inputFormatters: validate10Digits ? [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)] : [],
        validator: (value) {
          if (value == null || value.trim().isEmpty) return 'Please enter $label';
          if (validate10Digits && value.trim().length != 10) return '$label must be exactly 10 digits';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownRow(String label, List<String> items, String? selectedValue, Function(String?) onChanged, {String? Function(String?)? validator}) {
    return _buildSectionCard(
      title: label,
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
        validator: validator,
        autovalidateMode: AutovalidateMode.always,
        dropdownColor: Colors.grey.shade100,
        decoration: InputDecoration(filled: true, fillColor: Colors.grey.shade200, border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          // ✅ Error text style
          errorStyle: const TextStyle(
          color: Colors.red, // deep red text
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),

        // ✅ Error border (deep red)
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Colors.red,
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
        ),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        onChanged: onChanged,
        items: items.map((item) => DropdownMenuItem<String>(value: item, child: Text(item, style: TextStyle(color: Colors.grey.shade800, fontSize: 11)))).toList(),
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'Poppins');
  }
}

void showMetroLocalityPicker(BuildContext context, Function(String metro, List<String> localities) onSelected) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(0.5),
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.60,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, controller) {
          return MetroLocalitySheet(onSelected: onSelected);
        },
      );
    },
  );
}

class MetroLocalitySheet extends StatefulWidget {
  final Function(String metro, List<String> localities) onSelected;
  const MetroLocalitySheet({super.key, required this.onSelected});
  @override
  State<MetroLocalitySheet> createState() => _MetroLocalitySheetState();
}

class _MetroLocalitySheetState extends State<MetroLocalitySheet> {
  final MetroAPI api = MetroAPI();
  final TextEditingController metroCtrl = TextEditingController();
  final TextEditingController localityCtrl = TextEditingController();

  List<Map<String, dynamic>> metroList = [];
  List<Map<String, dynamic>> nearbyList = [];
  List<Map<String, dynamic>> filteredNearby = [];
  List<String> selectedLocalities = [];

  bool loadingMetro = false;
  bool loadingNearby = false;

  Timer? metroDebounce;
  Timer? localityDebounce;
  String? selectedMetro;

  @override
  void dispose() {
    metroDebounce?.cancel();
    localityDebounce?.cancel();
    super.dispose();
  }

  void searchMetro(String q) {
    if (metroDebounce?.isActive ?? false) metroDebounce!.cancel();
    metroDebounce = Timer(const Duration(milliseconds: 300), () async {
      if (q.trim().length < 2) {
        setState(() => metroList = []);
        return;
      }
      setState(() => loadingMetro = true);
      final result = await api.fetchStations(q);
      setState(() {
        metroList = result;
        loadingMetro = false;
      });
    });
  }

  Future<void> fetchNearby(String metroName) async {
    setState(() {
      loadingNearby = true;
      nearbyList = [];
      filteredNearby = [];
      selectedLocalities.clear();
    });
    final result = await api.fetchNearby(metroName);
    setState(() {
      nearbyList = result;
      filteredNearby = result;
      loadingNearby = false;
    });
  }

  void searchLocality(String q) {
    if (localityDebounce?.isActive ?? false) localityDebounce!.cancel();
    localityDebounce = Timer(const Duration(milliseconds: 200), () {
      if (q.trim().isEmpty) {
        setState(() => filteredNearby = nearbyList);
        return;
      }
      setState(() {
        filteredNearby = nearbyList.where((e) => e["name"].toString().toLowerCase().contains(q.toLowerCase())).toList();
      });
    });
  }
  void _addManualLocality(String value) {
    final text = value.trim();
    if (text.isEmpty) return;

    final parts = text.split(',');

    setState(() {
      for (final part in parts) {
        final loc = part.trim();
        if (loc.isNotEmpty &&
            !selectedLocalities
                .any((e) => e.toLowerCase() == loc.toLowerCase())) {
          selectedLocalities.add(loc);
        }
      }

      // 🔥 clear input after adding
      localityCtrl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final cardBg = isDark ? const Color(0xFF222222) : Colors.grey.shade100;
    final textCol = isDark ? Colors.white : Colors.black87;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      decoration: BoxDecoration(color: bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        children: [
          Container(width: 40, height: 5, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10))),
          TextField(controller: metroCtrl, onChanged: searchMetro, style: TextStyle(color: textCol), decoration: InputDecoration(labelText: "Metro Station", labelStyle: TextStyle(color: textCol.withOpacity(0.8)), filled: true, fillColor: cardBg, border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)))),
          if (loadingMetro) const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
          if (metroList.isNotEmpty)
            Expanded(
              flex: 3,
              child: ListView.builder(itemCount: metroList.length, itemBuilder: (_, i) {
                final m = metroList[i];
                return ListTile(
                  tileColor: cardBg,
                  title: Text(m["name"], style: TextStyle(color: textCol)),
                  onTap: () async {
                    metroCtrl.text = m["name"];
                    selectedMetro = m["name"];
                    metroList.clear();
                    FocusScope.of(context).unfocus();
                    await fetchNearby(m["name"]);
                  },
                );
              }),
            ),
          const SizedBox(height: 20),
          TextField(
            controller: localityCtrl,
            enabled: nearbyList.isNotEmpty,
            style: TextStyle(color: textCol),
            decoration: InputDecoration(
              labelText: nearbyList.isEmpty
                  ? "Select Metro First"
                  : "Search or type locality",
              hintText: "Type & press enter or comma",
              filled: true,
              fillColor: cardBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            // 🔍 API search
            onChanged: (value) {
              searchLocality(value);

              // 👇 comma se manual add
              if (value.contains(',')) {
                _addManualLocality(value);
              }
            },

            // ⏎ enter se manual add
            onSubmitted: (value) {
              _addManualLocality(value); // ✅ manual add
            },
          ),
          if (loadingNearby) const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
          if (selectedLocalities.isNotEmpty)
            Wrap(spacing: 6, children: selectedLocalities.map((loc) => Chip(label: Text(loc), backgroundColor: isDark ? Colors.white12 : Colors.grey.shade300, deleteIcon: const Icon(Icons.close, size: 18), onDeleted: () { setState(() { selectedLocalities.remove(loc); }); })).toList()),
          const SizedBox(height: 10),
          if (filteredNearby.isNotEmpty)
            Expanded(
              flex: 5,
              child: ListView.builder(itemCount: filteredNearby.length, itemBuilder: (_, i) {
                final loc = filteredNearby[i];
                return Card(
                  color: cardBg,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(loc["name"], style: TextStyle(color: textCol)),
                    subtitle: Text(loc["type"] ?? "", style: TextStyle(color: textCol.withOpacity(0.6), fontSize: 12)),
                    trailing: Icon(selectedLocalities.contains(loc["name"]) ? Icons.check_circle : Icons.add_circle_outline, color: Colors.redAccent),
                    onTap: () {
                      final name = loc["name"].toString();

                      setState(() {
                        if (!selectedLocalities
                            .any((e) => e.toLowerCase() == name.toLowerCase())) {
                          selectedLocalities.add(name);
                        }
                      });
                    },
                  ),
                );
              }),
            ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              // 🔥 LAST typed locality bhi add karo
              if (localityCtrl.text.trim().isNotEmpty) {
                _addManualLocality(localityCtrl.text);
              }

              final metroName = selectedMetro ?? metroCtrl.text.trim();

              widget.onSelected(
                metroName,
                List<String>.from(selectedLocalities),
              );

              Navigator.pop(context);
            },

            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text("Done", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

class FutureProperty2 {
  final String id;
  final String images;
  final String ownerName;
  final String ownerNumber;
  final String caretakerName;
  final String caretakerNumber;
  final String place;
  final String buyRent;
  final String typeOfProperty;
  final String selectBhk;
  final String floorNumber;
  final String squareFeet;
  final String propertyNameAddress;
  final String buildingInformationFacilities;
  final String propertyAddressForFieldworker;
  final String ownerVehicleNumber;
  final String yourAddress;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String currentDate;
  final String longitude;
  final String latitude;
  final String roadSize;
  final String metroDistance;
  final String metroName;
  final String mainMarketDistance;
  final String ageOfProperty;
  final String lift;
  final String parking;
  final String totalFloor;
  final String apartmentName;
  final String facility;
  final String currentLocation;
  final String residenceCommercial;
  final String localities_list;

  FutureProperty2({
    required this.id,
    required this.images,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.typeOfProperty,
    required this.selectBhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.propertyNameAddress,
    required this.buildingInformationFacilities,
    required this.propertyAddressForFieldworker,
    required this.ownerVehicleNumber,
    required this.yourAddress,
    required this.fieldworkerName,
    required this.fieldworkerNumber,
    required this.currentDate,
    required this.longitude,
    required this.latitude,
    required this.roadSize,
    required this.metroDistance,
    required this.metroName,
    required this.mainMarketDistance,
    required this.ageOfProperty,
    required this.lift,
    required this.parking,
    required this.totalFloor,
    required this.apartmentName,
    required this.facility,
    required this.currentLocation,
    required this.residenceCommercial,
    required this.localities_list,
  });

  factory FutureProperty2.fromJson(Map<String, dynamic> json) {
    return FutureProperty2(
      id: json['id'].toString(),
      images: json['images'] ?? '',
      ownerName: json['ownername'] ?? '',
      ownerNumber: json['ownernumber'] ?? '',
      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: json['caretakernumber'] ?? '',
      place: json['place'] ?? '',
      buyRent: json['buy_rent'] ?? '',
      typeOfProperty: json['typeofproperty'] ?? '',
      selectBhk: json['select_bhk'] ?? '',
      floorNumber: json['floor_number'] ?? '',
      squareFeet: json['sqyare_feet'] ?? '',
      propertyNameAddress: json['propertyname_address'] ?? '',
      buildingInformationFacilities: json['building_information_facilitys'] ?? '',
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'] ?? '',
      ownerVehicleNumber: json['owner_vehical_number'] ?? '',
      yourAddress: json['your_address'] ?? '',
      fieldworkerName: json['fieldworkarname'] ?? '',
      fieldworkerNumber: json['fieldworkarnumber'] ?? '',
      currentDate: json['current_date_'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',

      // ✔ FIXED metro field (old issue)
      metroName: json['metro_name']
          ?? json['Metro_name']
          ?? json['metroName']
          ?? '',

      mainMarketDistance: json['main_market_distance'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      lift: json['lift'] ?? '',
      parking: json['parking'] ?? '',
      totalFloor: json['total_floor'] ?? '',
      apartmentName: json['apartment_name'] ?? '',
      facility: json['facility'] ?? '',

      // ✔ localities_list fix
      localities_list: json['locality_list']
          ?? json['localities_list']
          ?? '',

      currentLocation: json['your_address'] ?? '',
      residenceCommercial: json['Residence_commercial'] ?? '',
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
        // color: Colors.white,
        child: Padding(
          padding:
          EdgeInsets.only(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  "Select Facilities",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black),
                ),
              ),
              ...widget.options.map((option) {
                final isSelected = _tempSelected.contains(option);
                return CheckboxListTile(
                  title: Text(option,style: TextStyle(),),
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
