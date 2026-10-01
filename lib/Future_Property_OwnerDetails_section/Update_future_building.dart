import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/property_id_for_multipleimage_provider.dart';
import '../Custom_Widget/constant.dart';


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

  // ----- wizard step colors -----
  static const _kPrimary = Color(0xFF0F6E5C);
  static const _kAccent = Color(0xFFE98A15);
  static const _kSurface2 = Color(0xFFF1EEE6);
  static const _kBorder = Color(0xFFE2DCCB);

  int _stepIndex = 0;

  static const List<String> _stepTitlesEn = [
    'Photo',
    'Basic Info',
    'Address & Location',
    'Facilities & Access',
    'Metro & Distance',
    'Owner & Caretaker',
  ];
  static const List<String> _stepTitlesHi = [
    'Foto',
    'Basic Jaankari',
    'Address aur Location',
    'Suvidhaye aur Access',
    'Metro aur Doori',
    'Malik aur Caretaker',
  ];
  static const List<IconData> _stepIcons = [
    Icons.photo_camera_outlined,
    Icons.info_outline,
    Icons.location_on_outlined,
    Icons.checklist_outlined,
    Icons.train_outlined,
    Icons.person_outline,
  ];

  // fixed metro chip options (replaces the old metro-search dialog)
  static const List<String> _metroOptions = [
    'Hauz Khas',
    'Malviya Nagar',
    'Saket',
    'Qutub Minar',
    'Chhattarpur',
    'Sultanpur',
    'Ghitorni',
    'Arjan Garh',
  ];
  String? _selectedMetro;

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

  final List<String> roadSizeOptions = ['15 Feet', '20 Feet', '25 Feet', '30 Feet', '35 Feet', '40 Above',''];
  final List<String> metroDistanceOptions = ['200 m', '300 m', '400 m', '500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''];
  final List<String> metro_nameOptions = ['','']; // kept but not used (picker used)
  final List<String> _items_floor2 = ['G Floor','1 Floor','2 Floor','3 Floor','4 Floor','5 Floor','6 Floor','7 Floor','8 Floor','9 Floor','10 Floor',''];

  final List<String> marketDistanceOptions =  ['200 m', '300 m', '400 m', '500 m','600 m','700 m','1 km','1.5 km','2.5 km','2.5+ km',''];
  final List<String> Age_Options = [    'Under Construction', 'New Construction','1 years', '2 years', '3 years', '4 years','5 years','6 years','7 years','8 years','9 years','10 years','10+ years',''];
  List<String> allFacilities = ['CCTV Camera', 'Lift', 'Parking', 'Security', 'Terrace Garden',"Gas Pipeline",''];

  String long = '';
  String lat = '';
  String? _networkImageUrl;
  String full_address = '';
  File? _imageFile;

  String? _selectedItem;
  String? apiImageUrl;

  final List<String> _items = ['SultanPur','ChhattarPur','Aya Nagar','Ghitorni','Rajpur Khurd','Manglapuri','Dwarka Mor','Uttam Nagar','Nawada','Vasant Kunj',''];
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
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_for_details_page.php?id=${widget.propertyId}"
    );

    final res = await http.get(url);

    if (res.statusCode != 200) throw Exception("API error");

    final decoded = jsonDecode(res.body);

    if (decoded is Map && decoded.containsKey("data")) {
      List list = decoded["data"];
      return list.map((e) => FutureProperty2.fromJson(e)).toList();
    }

    throw Exception("Invalid API structure");
  }

  void autofillFormFields() async {
    try {
      final dataList = await fetchData();
      if (dataList.isNotEmpty) {
        final data = dataList.first;

        // network image
        _networkImageUrl = "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/" + (data.images.isNotEmpty ? data.images : '');

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
        print('metro name : ${data.metroName}');

        // pre-select the metro chip only if it exactly matches one of the fixed options
        final fetchedMetro = data.metroName.trim();
        _selectedMetro = _metroOptions.contains(fetchedMetro) ? fetchedMetro : null;

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

  String normalizePropertyType(String? val) {
    if (val == null) return '';
    if (val.toLowerCase().startsWith('res')) return 'Residential';
    if (val.toLowerCase().startsWith('com')) return 'Commercial';
    return val;
  }

  Future<void> updateImageWithTitle(File? imageFile) async {
    String uploadUrl =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/update_allfeilds_with_single_image.php';

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
      "metro_name": _selectedMetro ?? "",
      "locality_list": "Sultanpur",
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
        showSnack("Something went wrong");
      }
    } catch (e) {
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

  // ---------------------------------------------------------------------
  // step navigation
  // ---------------------------------------------------------------------

  String? _validateStep(int step) {
    switch (step) {
      case 0: // Photo — optional
        return null;
      case 1: // Basic Info
        if (_selectedItem == null || _selectedItem!.isEmpty) return 'Please select a Place';
        if (_selectedPropertyType == null || _selectedPropertyType!.isEmpty) return 'Please select property type';
        if (_selectedItem1 == null || _selectedItem1!.isEmpty) return 'Please select Buy/Rent';
        if (_totalFloor == null || _totalFloor!.isEmpty) return 'Please select total floor';
        if (_ageOfProperty == null || _ageOfProperty!.isEmpty) return 'Please select age of property';
        return null;
      case 2: // Address & Location
        if (_address.text.trim().isEmpty) return 'Please enter property name & address';
        if (_Address_apnehisaabka.text.trim().isEmpty) return 'Please enter address for field worker';
        if (_Google_Location.text.trim().isEmpty) return 'Please enter google location';
        return null;
      case 3: // Facilities & Access
        if (_facilityController.text.trim().isEmpty) return 'Please select facilities';
        if (selectedRoadSize == null || selectedRoadSize!.isEmpty) return 'Please select road size';
        if (_selectedLift == null || _selectedLift!.isEmpty) return 'Please select lift availability';
        if (_selectedParking == null || _selectedParking!.isEmpty) return 'Please select parking type';
        return null;
      case 4: // Metro & Distance
        if (selectedMetroDistance == null || selectedMetroDistance!.isEmpty) return 'Please select metro distance';
        return null;
      case 5: // Owner & Caretaker — all optional
        return null;
      default:
        return null;
    }
  }

  void _goBack() {
    if (_stepIndex == 0) {
      Navigator.pop(context);
    } else {
      setState(() => _stepIndex--);
    }
  }

  void _goNext() {
    final err = _validateStep(_stepIndex);
    if (err != null) {
      showSnack(err);
      return;
    }
    if (_stepIndex < _stepTitlesEn.length - 1) {
      setState(() => _stepIndex++);
    } else {
      _handleSubmit();
    }
  }

  // ---------------------------------------------------------------------
  // submit (unchanged logic — validate -> countdown dialog -> upload -> pop)
  // ---------------------------------------------------------------------

  Future<void> _handleSubmit() async {
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
  }

  // ---------------------------------------------------------------------
  // build
  // ---------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kSurface2,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          icon: const Icon(PhosphorIconsRegular.caretLeft, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          _buildProgressDots(),
          _buildStepHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
              child: Form(
                key: _formKey,
                child: _buildStepContent(),
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildProgressDots() {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(_stepTitlesEn.length, (i) {
          final active = i <= _stepIndex;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == _stepIndex ? 18 : 8,
            height: 8,
            decoration: BoxDecoration(
              color: active ? _kPrimary : _kBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStepHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 16, 8),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: _goBack,
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.chevron_left, size: 26, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 2),
          _iconBadge(_stepIcons[_stepIndex]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_stepTitlesEn[_stepIndex], style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text(_stepTitlesHi[_stepIndex], style: const TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
          Text('${_stepIndex + 1}/${_stepTitlesEn.length}', style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    final isLast = _stepIndex == _stepTitlesEn.length - 1;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: _kBorder)),
      ),
      child: Row(
        children: [
          if (_stepIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _isLoading ? null : _goBack,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: _kBorder),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Back', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
              ),
            ),
          if (_stepIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _goNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: _kPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
                  : Text(isLast ? 'Submit' : 'Next', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_stepIndex) {
      case 0:
        return _stepPhoto();
      case 1:
        return _stepBasicInfo();
      case 2:
        return _stepAddress();
      case 3:
        return _stepFacilities();
      case 4:
        return _stepMetro();
      case 5:
        return _stepOwner();
      default:
        return const SizedBox.shrink();
    }
  }

  // ---------------------------------------------------------------------
  // step groups
  // ---------------------------------------------------------------------

  Widget _stepPhoto() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldWrap(
          icon: Icons.photo_camera_outlined,
          en: 'Cover Photo',
          hi: 'Cover Foto',
          required: false,
          child: Center(
            child: GestureDetector(
              onTap: () async {
                XFile? pickedXFile = await pickAndCompressImage();
                File? pickedImage = pickedXFile != null ? File(pickedXFile.path) : null;
                if (pickedImage != null) setState(() => _imageFile = pickedImage);
              },
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: _kSurface2,
                  border: Border.all(color: _kBorder),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: _imageFile != null
                      ? Image.file(_imageFile!, fit: BoxFit.cover)
                      : (_networkImageUrl != null && _networkImageUrl!.isNotEmpty)
                      ? Image.network(_networkImageUrl!, fit: BoxFit.cover)
                      : const Center(child: Icon(Icons.add_a_photo_outlined, size: 34, color: Colors.black38)),
                ),
              ),
            ),
          ),
        ),
        Center(
          child: TextButton.icon(
            onPressed: () async {
              XFile? pickedXFile = await pickAndCompressImage();
              File? pickedImage = pickedXFile != null ? File(pickedXFile.path) : null;
              if (pickedImage != null) setState(() => _imageFile = pickedImage);
            },
            icon: const Icon(Icons.image_outlined, color: _kPrimary),
            label: const Text('Change Photo', style: TextStyle(color: _kPrimary, fontWeight: FontWeight.w600)),
          ),
        ),
      ],
    );
  }

  Widget _stepBasicInfo() {
    return Column(
      children: [
        _fieldWrap(
          icon: Icons.location_on_outlined,
          en: 'Place',
          hi: 'Jagah',
          child: _bottomSheetSelector(
            label: 'Place',
            values: (_selectedItem != null && _selectedItem!.isNotEmpty) ? [_selectedItem!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Place',
              options: _items,
              selectedValues: (_selectedItem != null && _selectedItem!.isNotEmpty) ? [_selectedItem!] : [],
              onDone: (vals) => setState(() => _selectedItem = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.apartment_outlined,
          en: 'Property Type',
          hi: 'Property ka Prakar',
          child: _bottomSheetSelector(
            label: 'Property Type',
            values: propertyTypes.contains(_selectedPropertyType) ? [_selectedPropertyType!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Property Type',
              options: propertyTypes,
              selectedValues: propertyTypes.contains(_selectedPropertyType) ? [_selectedPropertyType!] : [],
              onDone: (vals) => setState(() => _selectedPropertyType = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.sell_outlined,
          en: 'Buy / Rent',
          hi: 'Kharido ya Kiraya',
          child: _bottomSheetSelector(
            label: 'Buy / Rent',
            values: (_selectedItem1 != null && _selectedItem1!.isNotEmpty) ? [_selectedItem1!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Buy / Rent',
              options: _items1,
              selectedValues: (_selectedItem1 != null && _selectedItem1!.isNotEmpty) ? [_selectedItem1!] : [],
              onDone: (vals) => setState(() => _selectedItem1 = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.stairs_outlined,
          en: 'Total Floor',
          hi: 'Kul Floor',
          child: _bottomSheetSelector(
            label: 'Total Floor',
            values: (_totalFloor != null && _totalFloor!.isNotEmpty) ? [_totalFloor!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Total Floor',
              options: _items_floor2,
              selectedValues: (_totalFloor != null && _totalFloor!.isNotEmpty) ? [_totalFloor!] : [],
              onDone: (vals) => setState(() => _totalFloor = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.calendar_month_outlined,
          en: 'Age of Property',
          hi: 'Property ki Umar',
          child: _bottomSheetSelector(
            label: 'Age of Property',
            values: (_ageOfProperty != null && _ageOfProperty!.isNotEmpty) ? [_ageOfProperty!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Age of Property',
              options: Age_Options,
              selectedValues: (_ageOfProperty != null && _ageOfProperty!.isNotEmpty) ? [_ageOfProperty!] : [],
              onDone: (vals) => setState(() => _ageOfProperty = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepAddress() {
    return Column(
      children: [
        _fieldWrap(
          icon: Icons.home_outlined,
          en: 'Property Name & Address',
          hi: 'Property ka Naam aur Address',
          child: _styledTextField(_address, hint: 'Enter property name & address'),
        ),
        _fieldWrap(
          icon: Icons.badge_outlined,
          en: 'Address for Field Worker',
          hi: 'Field Worker ke liye Address',
          child: _styledTextField(_Address_apnehisaabka, hint: 'Enter address for field worker'),
        ),
        _fieldWrap(
          icon: Icons.my_location_outlined,
          en: 'Google Location',
          hi: 'Google Location',
          child: _styledTextField(_Google_Location, hint: 'Enter google location'),
        ),
      ],
    );
  }

  Widget _stepFacilities() {
    return Column(
      children: [
        _fieldWrap(
          icon: Icons.checklist_outlined,
          en: 'Facilities',
          hi: 'Suvidhaye',
          child: _bottomSheetSelector(
            label: 'Facilities',
            values: selectedFacilities,
            onTap: () => _openChipSheet(
              title: 'Select Facilities',
              options: allFacilities,
              selectedValues: selectedFacilities,
              multiSelect: true,
              onDone: (vals) => setState(() {
                selectedFacilities = vals;
                _facilityController.text = selectedFacilities.join(', ');
              }),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.rule_outlined,
          en: 'Road Width',
          hi: 'Road ki Chaudai',
          child: _bottomSheetSelector(
            label: 'Road Width',
            values: (selectedRoadSize != null && selectedRoadSize!.isNotEmpty) ? [selectedRoadSize!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Road Width',
              options: roadSizeOptions,
              selectedValues: (selectedRoadSize != null && selectedRoadSize!.isNotEmpty) ? [selectedRoadSize!] : [],
              onDone: (vals) => setState(() => selectedRoadSize = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.elevator_outlined,
          en: 'Lift Availability',
          hi: 'Lift Suvidha',
          child: _bottomSheetSelector(
            label: 'Lift Availability',
            values: (_selectedLift != null && _selectedLift!.isNotEmpty) ? [_selectedLift!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Lift Availability',
              options: parkingOptions,
              selectedValues: (_selectedLift != null && _selectedLift!.isNotEmpty) ? [_selectedLift!] : [],
              onDone: (vals) => setState(() => _selectedLift = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.local_parking_outlined,
          en: 'Parking',
          hi: 'Parking',
          child: _bottomSheetSelector(
            label: 'Parking',
            values: (_selectedParking != null && _selectedParking!.isNotEmpty) ? [_selectedParking!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Parking',
              options: parkingOptions,
              selectedValues: (_selectedParking != null && _selectedParking!.isNotEmpty) ? [_selectedParking!] : [],
              onDone: (vals) => setState(() => _selectedParking = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepMetro() {
    return Column(
      children: [
        _fieldWrap(
          icon: Icons.train_outlined,
          en: 'Metro Station',
          hi: 'Metro Station',
          required: false,
          child: _bottomSheetSelector(
            label: 'Metro Station',
            values: (_selectedMetro != null && _selectedMetro!.isNotEmpty) ? [_selectedMetro!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Metro Station',
              options: _metroOptions,
              selectedValues: (_selectedMetro != null && _selectedMetro!.isNotEmpty) ? [_selectedMetro!] : [],
              onDone: (vals) => setState(() => _selectedMetro = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.directions_walk_outlined,
          en: 'Metro Distance',
          hi: 'Metro ki Doori',
          child: _bottomSheetSelector(
            label: 'Metro Distance',
            values: (selectedMetroDistance != null && selectedMetroDistance!.isNotEmpty) ? [selectedMetroDistance!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Metro Distance',
              options: metroDistanceOptions,
              selectedValues: (selectedMetroDistance != null && selectedMetroDistance!.isNotEmpty) ? [selectedMetroDistance!] : [],
              onDone: (vals) => setState(() => selectedMetroDistance = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
        _fieldWrap(
          icon: Icons.storefront_outlined,
          en: 'Market Distance',
          hi: 'Bazaar ki Doori',
          required: false,
          child: _bottomSheetSelector(
            label: 'Market Distance',
            values: (selectedMarketDistance != null && selectedMarketDistance!.isNotEmpty) ? [selectedMarketDistance!] : [],
            onTap: () => _openChipSheet(
              title: 'Select Market Distance',
              options: marketDistanceOptions,
              selectedValues: (selectedMarketDistance != null && selectedMarketDistance!.isNotEmpty) ? [selectedMarketDistance!] : [],
              onDone: (vals) => setState(() => selectedMarketDistance = vals.isEmpty ? null : vals.first),
            ),
          ),
        ),
      ],
    );
  }

  Widget _stepOwner() {
    return Column(
      children: [
        _fieldWrap(
          icon: Icons.person_outline,
          en: 'Owner Name',
          hi: 'Malik ka Naam',
          required: false,
          child: _styledTextField(_Ownername, hint: 'Enter owner name'),
        ),
        _fieldWrap(
          icon: Icons.phone_outlined,
          en: 'Owner Number',
          hi: 'Malik ka Number',
          required: false,
          child: _styledTextField(
            _Owner_number,
            hint: 'Enter owner number',
            keyboardType: TextInputType.phone,
            formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          ),
        ),
        _fieldWrap(
          icon: Icons.person_outline,
          en: 'Caretaker Name',
          hi: 'Caretaker ka Naam',
          required: false,
          child: _styledTextField(_CareTaker_name, hint: 'Enter caretaker name'),
        ),
        _fieldWrap(
          icon: Icons.phone_outlined,
          en: 'Caretaker Number',
          hi: 'Caretaker ka Number',
          required: false,
          child: _styledTextField(
            _CareTaker_number,
            hint: 'Enter caretaker number',
            keyboardType: TextInputType.phone,
            formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
          ),
        ),
        _fieldWrap(
          icon: Icons.directions_car_outlined,
          en: 'Owner Vehicle Number',
          hi: 'Malik ki Gaadi Number',
          required: false,
          child: _styledTextField(_vehicleno, hint: 'Enter vehicle number'),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // shared small widgets
  // ---------------------------------------------------------------------

  Widget _iconBadge(IconData icon, {Color color = _kPrimary}) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _fieldWrap({
    required IconData icon,
    required String en,
    required String hi,
    bool required = true,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _iconBadge(icon),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(en, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.black87)),
                        const SizedBox(width: 6),
                        if (required)
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: _kSurface2,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: _kBorder),
                            ),
                            child: const Text('Optional', style: TextStyle(fontSize: 9, color: Colors.black54)),
                          ),
                      ],
                    ),
                    Text(hi, style: const TextStyle(fontSize: 11, color: Colors.black45)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _chipRow(List<String> options, String? selected, ValueChanged<String?> onChanged) {
    final opts = options.where((o) => o.isNotEmpty).toList();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: opts.map((o) {
        final isSel = selected == o;
        return GestureDetector(
          onTap: () => onChanged(o),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isSel ? _kPrimary : _kSurface2,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: isSel ? _kPrimary : _kBorder),
            ),
            child: Text(
              o,
              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: isSel ? Colors.white : Colors.black87),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _styledTextField(
      TextEditingController controller, {
        String? hint,
        TextInputType? keyboardType,
        List<TextInputFormatter>? formatters,
        int maxLines = 1,
      }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: formatters,
      style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
        isDense: true,
        filled: true,
        fillColor: _kSurface2,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kBorder)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: _kPrimary, width: 1.4)),
      ),
    );
  }

  // Compact tappable row: shows the current selection (or a muted
  // placeholder) and opens a bottom sheet of chips when tapped.
  Widget _bottomSheetSelector({
    required String label,
    required List<String> values,
    required VoidCallback onTap,
  }) {
    final isEmpty = values.isEmpty;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: _kSurface2,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: isEmpty
                  ? Text('Select $label', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black38))
                  : values.length == 1
                  ? Text(values.first, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87))
                  : Wrap(
                spacing: 6,
                runSpacing: 6,
                children: values.map((v) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: _kPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(v, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: _kPrimary)),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black38),
          ],
        ),
      ),
    );
  }

  // Shared bottom sheet used by every chip-select field. Single-select
  // closes the sheet as soon as a chip is tapped; multi-select keeps the
  // sheet open (toggling chips) until "Done" is tapped.
  Future<void> _openChipSheet({
    required String title,
    required List<String> options,
    required List<String> selectedValues,
    bool multiSelect = false,
    required ValueChanged<List<String>> onDone,
  }) async {
    List<String> temp = List<String>.from(selectedValues);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetCtx) {
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(color: _kBorder, borderRadius: BorderRadius.circular(2)),
                      ),
                    ),
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 14),
                    multiSelect
                        ? Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: options.where((o) => o.isNotEmpty).map((o) {
                        final isSel = temp.contains(o);
                        return GestureDetector(
                          onTap: () => setSheetState(() {
                            if (isSel) {
                              temp.remove(o);
                            } else {
                              temp.add(o);
                            }
                          }),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? _kPrimary : _kSurface2,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSel ? _kPrimary : _kBorder),
                            ),
                            child: Text(
                              o,
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: isSel ? Colors.white : Colors.black87),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                        : _chipRow(options, temp.isEmpty ? null : temp.first, (v) {
                      temp = v == null ? [] : [v];
                      Navigator.pop(sheetCtx);
                    }),
                    if (multiSelect) ...[
                      const SizedBox(height: 18),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _kPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => Navigator.pop(sheetCtx),
                          child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    onDone(temp);
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
