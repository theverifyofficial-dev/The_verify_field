import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utilities/bug_founder_fuction.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Future_Property.dart';
import 'Future_Property_Tabbar.dart';
import '../utilities/heic_converter.dart';

class Add_FutureProperty extends StatefulWidget {
  const Add_FutureProperty({super.key});

  @override
  State<Add_FutureProperty> createState() => _Add_FuturePropertyState();
}

class _Add_FuturePropertyState extends State<Add_FutureProperty> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  bool _isCounting = false;
  Timer? _timer;

  // ---- Stepped wizard state ----
  int _stepIndex = 0;
  static const int _totalSteps = 6;

  // ---- Small internal design tokens for the wizard UI ----
  static const Color _kPrimary = Color(0xFF0F6E5C);
  static const Color _kAccent = Color(0xFFE98A15);
  static const Color _kSurface2 = Color(0xFFF1EEE6);
  static const Color _kBorder = Color(0xFFE2DCCB);

  String? _selectedItem;
  String? _selectedItem1;
  // String? _typeofproperty;
  String? _selectedPropertyType;
  String? _selectedLift;
  String? _selectedParking;
  String? selectedRoadSize;
  String? selectedMetroDistance;
  String? metro_name;
  String? selectedMarketDistance;
  String? _ageOfProperty;
  String? _totalFloor;
  String? _selectedMetro;

  final TextEditingController _Ownername = TextEditingController();
  final TextEditingController _Owner_number = TextEditingController();
  final TextEditingController _Address_apnehisaabka = TextEditingController();
  final TextEditingController _CareTaker_name = TextEditingController();
  final TextEditingController _CareTaker_number = TextEditingController();
  final TextEditingController _vehicleno = TextEditingController();
  final TextEditingController _Google_Location = TextEditingController();
  final TextEditingController _address = TextEditingController();
  // final TextEditingController _Building_information = TextEditingController();

  String _number = '';
  String _name = '';
  List<String> selectedFacilities = [];

  // Image variables
  XFile? _singleImage;
  List<XFile> _selectedImages = [];

  // Location variables
  bool _isGettingLocation = false;
  String _currentAddress = '';
  double? _latitude;
  double? _longitude;

  DateTime uploadDate = DateTime.now();

  bool _isLoading = false;

  // Dropdown options
  final List<String> _items = [
    'SultanPur',
    'ChhattarPur',
    'Aya Nagar',
    'Rajpur Khurd',
    'Manglapuri',
    'Dwarka Mor',
    'Uttam Nagar',
    'Nawada',
    'Vasant Kunj',
    'Ghitorni'
  ];
  final List<String> _items1 = ['Buy', 'Rent'];

  final List<String> propertyTypes = ['Residential', 'Commercial'];
  final List<String> lift_options = ['Yes', 'No'];
  final List<String> parkingOptions = ['Yes', 'No'];
  final List<String> _items_floor2 = [
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
    '10 Floor'
  ];
  final List<String> roadSizeOptions = [
    '15 Feet',
    '20 Feet',
    '25 Feet',
    '30 Feet',
    '35 Feet',
    '40 Above'
  ];
  final List<String> metroDistanceOptions = [
    '200 m',
    '300 m',
    '400 m',
    '500 m',
    '600 m',
    '700 m',
    '1 km',
    '1.5 km',
    '2.5 km',
    '2.5+ km'
  ];
  final List<String> metro_nameOptions = [
    'Hauz khas',
    'Malviya Nagar',
    'Saket',
    'Qutub Minar',
    'ChhattarPur',
    'Sultanpur',
    'Ghitorni',
    'Arjan Garh',
    'Guru Drona',
    'Sikanderpur',
    'Dwarka Mor',
    'Vasant Kunj',
    'Ghitorni'
  ];
  // New fixed list of metro station chip options for the redesigned Metro field.
  final List<String> _metroOptions = [
    'Hauz Khas',
    'Malviya Nagar',
    'Saket',
    'Qutub Minar',
    'Chhattarpur',
    'Sultanpur',
    'Ghitorni',
    'Arjan Garh',
  ];
  final List<String> marketDistanceOptions = [
    '200 m',
    '300 m',
    '400 m',
    '500 m',
    '600 m',
    '700 m',
    '1 km',
    '1.5 km',
    '2.5 km',
    '2.5+ km'
  ];
  final List<String> Age_Options = [
    'Under Construction',
    'New Construction',
    '1 years',
    '2 years',
    '3 years',
    '4 years',
    '5 years',
    '6 years',
    '7 years',
    '8 years',
    '9 years',
    '10 years',
    '10+ years',
  ];
  List<String> allFacilities = [
    'CCTV Camera',
    'Parking',
    'Security',
    'Terrace Garden',
    "Gas Pipeline"
  ];

  String long = '';
  String lat = '';
  String full_address = '';

  String _date = '';
  String _Time = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    _generateDateTime();
  }

  void _generateDateTime() {
    setState(() {
      _date = DateFormat('dd-MMMM-yyyy').format(DateTime.now());
      _Time = DateFormat('h:mm a').format(DateTime.now());
    });
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
    });
  }

  Future<XFile?> pickAndCompressImage() async {
    final picker = ImagePicker();
    final pickedFile = await HeicConverter.pickImage(picker, source: ImageSource.gallery);

    if (pickedFile == null) return null;

    final tempDir = await getTemporaryDirectory();
    final targetPath =
        '${tempDir.path}/verify_${DateTime.now().millisecondsSinceEpoch}.jpg';

    var result = await FlutterImageCompress.compressAndGetFile(
      pickedFile.path,
      targetPath,
      quality: 85,
    );

    return result;
  }
  bool _isSubmitting = false;
  int _countdown = 3;

  Future<void> uploadImageWithTitle(XFile imageFile) async {
    String uploadUrl =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/new_future_property_api_with_images.php';

    FormData formData = FormData();

    formData.files.add(MapEntry(
      "images",
      await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path.split('/').last),
    ));

    formData.fields.addAll([
      MapEntry("ownername", _Ownername.text ?? ''),
      MapEntry("ownernumber", _Owner_number.text ?? ''),
      MapEntry("caretakername", _CareTaker_name.text ?? ''),
      MapEntry("caretakernumber", _CareTaker_number.text ?? ''),
      MapEntry("place", _selectedItem ?? ''),
      MapEntry("buy_rent", _selectedItem1 ?? ''),
      MapEntry("propertyname_address", _address.text),
      MapEntry("property_address_for_fieldworkar", _Address_apnehisaabka.text),
      MapEntry("owner_vehical_number", _vehicleno.text),
      MapEntry("your_address", _Google_Location.text),
      MapEntry("fieldworkarname", _name),
      MapEntry("fieldworkarnumber", _number),
      MapEntry("current_date", uploadDate.toIso8601String()),
      MapEntry("longitude", _longitude?.toString() ?? ''),
      MapEntry("latitude", _latitude?.toString() ?? ''),
      MapEntry("road_size", selectedRoadSize ?? ''),
      MapEntry("parking", _selectedParking ?? ''),
      MapEntry("metro_distance", selectedMetroDistance ?? ''),
      MapEntry("main_market_distance", selectedMarketDistance ?? ''),
      MapEntry("age_of_property", _ageOfProperty ?? ''),
      MapEntry("total_floor", _totalFloor ?? ''),
      MapEntry("lift", _selectedLift ?? ""),
      MapEntry("current_date_",DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.now())),
      MapEntry("Residence_commercial", _selectedPropertyType ?? ''),
      MapEntry("facility", selectedFacilities.join(', ')),
      MapEntry("metro_name", _selectedMetro ?? ""),
      MapEntry("locality_list", "Sultanpur"),
    ]);

    for (var xfile in _selectedImages) {
      formData.files.add(MapEntry(
        "img[]",
        await MultipartFile.fromFile(xfile.path,
            filename: xfile.path.split('/').last),
      ));
    }

    Dio dio = Dio();

    try {
      Response response = await dio.post(uploadUrl, data: formData);
      if (response.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => FuturePropertyTabPage()),
              (route) => route.isFirst,
        );
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Upload successful!')),
        );
        print('Upload successful: ${response.data}');
      } else {
        // 🔴 LOG BACKEND FAILURE
        await BugLogger.log(
          apiLink: uploadUrl,
          error: response.data.toString(),
          statusCode: response.statusCode ?? 0,
        );

        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: ${response.statusCode}')),
        );
        print('Upload failed: ${response.statusCode}');
      }
    } catch (e) {
      // 🔴 LOG EXCEPTION
      await BugLogger.log(
        apiLink: uploadUrl,
        error: e.toString(),
        statusCode: 500,
      );

      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong!! ')),
      );

      print('Error occurred: $e');
    }
  }

  Future<void> _handleUpload() async {
    if (!_formKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please fill all required fields.");
      return;
    }

    if (_singleImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
      return;
    }

    await uploadImageWithTitle(_singleImage!);
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    try {
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showErrorDialog(
              'Location permissions are denied. Please enable location services.');
          setState(() {
            _isGettingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog(
            'Location permissions are permanently denied. Please enable them in app settings.');
        setState(() {
          _isGettingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      try {
        final placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        if (placemarks.isNotEmpty) {
          final placemark = placemarks.first;
          final parts = [
            placemark.street,
            placemark.subLocality,
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode,
            placemark.country
          ];
          final address =
          parts.where((p) => p != null && p!.isNotEmpty).join(', ');

          setState(() {
            _Google_Location.text = address;
            _currentAddress = address;
            _isGettingLocation = false;
          });
          _showSuccessSnackbar('Location detected successfully!');
        } else {
          setState(() {
            _Google_Location.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
            _currentAddress =
            'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
            _isGettingLocation = false;
          });
          _showSuccessSnackbar('Location detected (coordinates).');
        }
      } catch (geocodingError) {
        setState(() {
          _Google_Location.text =
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude.toStringAsFixed(6)}';
          _currentAddress =
          'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position.longitude.toStringAsFixed(6)}';
          _isGettingLocation = false;
        });
        _showSuccessSnackbar('Location detected (coordinates).');
      }
    } catch (e) {
      setState(() {
        _isGettingLocation = false;
      });
      _showErrorDialog(
          'Failed to get location. Please check GPS, permissions, and internet.');
    }
  }

  // Premium Color Scheme
  final Color primaryColor = const Color(0xFF2D5BFF);
  final Color secondaryColor = const Color(0xFF6C63FF);
  final Color accentColor = const Color(0xFF00D4AA);

  /// Helper: Responsive row for two fields.
  Widget _buildTwoFieldRow(Widget first, Widget second) {
    final width = MediaQuery.of(context).size.width;

    if (width < 420) {
      // Narrow -> vertical
      return Column(
        children: [
          first,
          const SizedBox(height: 12),
          second,
        ],
      );
    }

    // Wider screens -> horizontal
    return Row(
      children: [
        Expanded(child: first),
        const SizedBox(width: 16),
        Expanded(child: second),
      ],
    );
  }

  // =========================================================================
  // Step-wizard helpers
  // =========================================================================

  final List<String> _stepTitlesEn = const [
    'Cover Photo',
    'Basic Info',
    'Address & Location',
    'Facilities & Access',
    'Metro & Distance',
    'Owner & Caretaker',
  ];

  final List<String> _stepTitlesHi = const [
    'Mukhya Photo',
    'Basic Jaankari',
    'Address aur Location',
    'Suvidhayein aur Access',
    'Metro aur Doori',
    'Malik aur Caretaker',
  ];

  final List<IconData> _stepIcons = const [
    Icons.photo_camera_outlined,
    Icons.info_outline,
    Icons.location_on_outlined,
    Icons.checklist_outlined,
    Icons.train_outlined,
    Icons.person_outline,
  ];

  /// Returns an error message when the current step's required fields are
  /// not filled, or null when the step can be advanced.
  String? _validateStep(int step) {
    switch (step) {
      case 0:
        if (_singleImage == null) {
          return 'Please select a cover photo';
        }
        return null;
      case 1:
        if (_selectedItem == null || _selectedItem!.isEmpty) {
          return 'Please select a Place';
        }
        if (_selectedPropertyType == null) {
          return 'Please select Property Type';
        }
        if (_selectedItem1 == null) {
          return 'Please select Buy or Rent';
        }
        if (_totalFloor == null) {
          return 'Please select Total Floor';
        }
        if (_ageOfProperty == null) {
          return 'Please select Age of property';
        }
        return null;
      case 2:
        if (_address.text.trim().isEmpty) {
          return 'Please enter property name & address';
        }
        if (_Address_apnehisaabka.text.trim().isEmpty) {
          return 'Please enter address for field worker';
        }
        if (_Google_Location.text.trim().isEmpty) {
          return 'Please enter Google location';
        }
        return null;
      case 3:
        if (selectedFacilities.isEmpty) {
          return 'Please select at least one facility';
        }
        if (selectedRoadSize == null) {
          return 'Please select road width';
        }
        if (_selectedLift == null) {
          return 'Please select lift availability';
        }
        if (_selectedParking == null) {
          return 'Please select parking';
        }
        return null;
      case 4:
        if (selectedMetroDistance == null) {
          return 'Please select metro distance';
        }
        if (selectedMarketDistance == null) {
          return 'Please select market distance';
        }
        return null;
      default:
        return null;
    }
  }

  void _goNext() {
    final error = _validateStep(_stepIndex);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error)),
      );
      return;
    }
    if (_stepIndex < _totalSteps - 1) {
      setState(() => _stepIndex++);
    }
  }

  void _goBack() {
    if (_stepIndex > 0) {
      setState(() => _stepIndex--);
    }
  }

  Widget _buildStepProgress() {
    return Row(
      children: List.generate(_totalSteps, (i) {
        final bool active = i <= _stepIndex;
        return Expanded(
          child: Container(
            margin:
            EdgeInsets.only(right: i == _totalSteps - 1 ? 0 : 4),
            height: 5,
            decoration: BoxDecoration(
              color: active ? _kPrimary : _kBorder,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStepHeaderRow(Color textColor) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (_stepIndex > 0)
          InkWell(
            onTap: _goBack,
            borderRadius: BorderRadius.circular(20),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.chevron_left_rounded, size: 26),
            ),
          )
        else
          const SizedBox(width: 34),
        const SizedBox(width: 4),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _kAccent.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(_stepIcons[_stepIndex], size: 18, color: _kAccent),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Step ${_stepIndex + 1} of $_totalSteps  ·  ${_stepTitlesEn[_stepIndex]}',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              Text(
                _stepTitlesHi[_stepIndex],
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Renders a field's leading icon badge + English label (bold) with a
  /// small Hinglish caption underneath, plus a required dot or an
  /// "Optional" pill.
  Widget _chipLabel({
    required IconData icon,
    required String title,
    required String hinglish,
    bool required = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: _kPrimary.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: _kPrimary),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 6),
                  if (required)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 1),
                      decoration: BoxDecoration(
                        color: _kSurface2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: _kBorder),
                      ),
                      child: const Text(
                        'Optional',
                        style: TextStyle(fontSize: 9, color: Colors.grey),
                      ),
                    ),
                ],
              ),
              Text(
                hinglish,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// A wrapping row of tappable pill chips bound to a single-select state
  /// variable. Selecting a chip calls [onSelect] exactly like a dropdown's
  /// onChanged would.
  Widget _chipOptionsRow({
    required List<String> options,
    required String? value,
    required ValueChanged<String> onSelect,
    required Color textColor,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: options.map((opt) {
        final bool selected = value == opt;
        return GestureDetector(
          onTap: () => onSelect(opt),
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: selected ? _kPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: selected ? _kPrimary : _kBorder,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selected) ...[
                  const Icon(Icons.check, size: 14, color: Colors.white),
                  const SizedBox(width: 4),
                ],
                Text(
                  opt,
                  style: TextStyle(
                    // Selected chips have a solid _kPrimary fill, so white
                    // stays correct there. Unselected chips are only a
                    // border on a transparent/light background, so they
                    // must use the theme-appropriate text color instead.
                    color: selected ? Colors.white : textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Inline multi-select chip row for facilities. Tapping a chip toggles it
  /// in/out of [selectedFacilities].
  Widget _buildFacilityChipsInline(Color textColor, {VoidCallback? onChanged}) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: allFacilities.map((facility) {
        final bool isSelected = selectedFacilities.contains(facility);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedFacilities.remove(facility);
              } else {
                selectedFacilities.add(facility);
              }
            });
            onChanged?.call();
          },
          child: Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: isSelected ? _kPrimary : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? _kPrimary : _kBorder,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected
                      ? Icons.check_circle_rounded
                      : Icons.radio_button_unchecked_rounded,
                  size: 15,
                  color: isSelected ? Colors.white : Colors.grey,
                ),
                const SizedBox(width: 6),
                Text(
                  facility,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// Compact, tappable "selector row" shown in the step body for any field
  /// that used to render its chips inline. Shows the current selection (or
  /// a muted placeholder) and opens a bottom sheet with the chip options
  /// when tapped.
  Widget _bottomSheetSelector({
    required String currentDisplay,
    required bool hasValue,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDarkMode,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                currentDisplay,
                style: TextStyle(
                  color: hasValue ? textColor : secondaryTextColor,
                  fontWeight: hasValue ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 13.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.keyboard_arrow_down_rounded,
                color: secondaryTextColor),
          ],
        ),
      ),
    );
  }

  /// Shared chrome (drag handle + English/Hinglish title + scrollable body
  /// + optional footer button) used by every chip-picker bottom sheet.
  Widget _buildChipSheetShell({
    required BuildContext sheetContext,
    required Color sheetBg,
    required Color textColor,
    required String titleEn,
    required String titleHi,
    required Widget optionsChild,
    Widget? footer,
  }) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(sheetContext).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: sheetBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 4),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _kBorder,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titleEn,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  Text(
                    titleHi,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                child: optionsChild,
              ),
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                child: footer,
              )
            else
              const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  /// Opens a bottom sheet with a single-select chip [Wrap] for [options].
  /// Tapping a chip immediately applies [onSelect] and closes the sheet.
  void _openChipSheet({
    required String titleEn,
    required String titleHi,
    required List<String> options,
    required String? value,
    required ValueChanged<String> onSelect,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color sheetTextColor =
        isDarkMode ? Colors.white : const Color(0xFF2D3748);
    final Color sheetBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        String? currentValue = value;
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            return _buildChipSheetShell(
              sheetContext: sheetContext,
              sheetBg: sheetBg,
              textColor: sheetTextColor,
              titleEn: titleEn,
              titleHi: titleHi,
              optionsChild: _chipOptionsRow(
                options: options,
                value: currentValue,
                textColor: sheetTextColor,
                onSelect: (v) {
                  onSelect(v);
                  setModalState(() => currentValue = v);
                  Navigator.pop(sheetContext);
                },
              ),
            );
          },
        );
      },
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  /// Opens a bottom sheet with the multi-select Facilities chips. The sheet
  /// stays open as chips are toggled and only closes via the Done button
  /// (or the usual swipe/tap-outside dismissal).
  void _openFacilitiesSheet() {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color sheetTextColor =
        isDarkMode ? Colors.white : const Color(0xFF2D3748);
    final Color sheetBg = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setModalState) {
            return _buildChipSheetShell(
              sheetContext: sheetContext,
              sheetBg: sheetBg,
              textColor: sheetTextColor,
              titleEn: 'Facilities',
              titleHi: 'Suvidhayein',
              optionsChild: _buildFacilityChipsInline(
                sheetTextColor,
                onChanged: () => setModalState(() {}),
              ),
              footer: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(sheetContext),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _kPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      if (mounted) setState(() {});
    });
  }

  Widget _buildBottomNav() {
    final bool isLast = _stepIndex == _totalSteps - 1;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.black : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (_stepIndex > 0) ...[
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: _isSubmitting ? null : _goBack,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: _kBorder),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text(
                    'Back',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 5,
              child: Container(
                height: 54,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [primaryColor, secondaryColor],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _isSubmitting
                        ? null
                        : () async {
                      if (!isLast) {
                        _goNext();
                        return;
                      }

                      if (!_formKey.currentState!.validate()) return;

                      setState(() {
                        _isSubmitting = true;
                        _countdown = 3;
                      });

                      // ⏳ Countdown timer
                      for (int i = 3; i > 0; i--) {
                        await Future.delayed(const Duration(seconds: 1));
                        setState(() {
                          _countdown = i - 1;
                        });
                      }

                      // 🚀 API Call
                      await _handleUpload();

                      setState(() {
                        _isSubmitting = false;
                      });
                    },
                    child: Center(
                      child: _isSubmitting
                          ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timer,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _countdown > 0
                                ? "Submitting in $_countdown"
                                : "Submitting...",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isLast ? 'SUBMIT PROPERTY' : 'Next',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            isLast
                                ? Icons.rocket_launch_rounded
                                : Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color backgroundColor =
    isDarkMode ? Colors.black : const Color(0xFFF8FAFF);
    final Color cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final Color textColor =
    isDarkMode ? Colors.white : const Color(0xFF2D3748);
    final Color secondaryTextColor = textColor.withOpacity(0.6);

    return
      Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.transparent, height: 40),
        iconTheme:
        IconThemeData(color: isDarkMode ? Colors.white : Colors.white),
        centerTitle: true,
      ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: _buildStepProgress(),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildStepHeaderRow(textColor),
                        const SizedBox(height: 18),
                        _buildCurrentStepContent(
                            isDarkMode, cardColor, textColor, secondaryTextColor),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
              _buildBottomNav(),
            ],
          ),
        ),
    );
  }

  Widget _buildCurrentStepContent(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    switch (_stepIndex) {
      case 0:
        return _buildStepCoverPhoto(isDarkMode, cardColor, textColor);
      case 1:
        return _buildStepBasicInfo(
            isDarkMode, cardColor, textColor, secondaryTextColor);
      case 2:
        return _buildStepAddressLocation(
            isDarkMode, cardColor, textColor, secondaryTextColor);
      case 3:
        return _buildStepFacilitiesAccess(
            isDarkMode, cardColor, textColor, secondaryTextColor);
      case 4:
        return _buildStepMetroDistance(
            isDarkMode, cardColor, textColor, secondaryTextColor);
      case 5:
        return _buildStepOwnerCaretaker(
            isDarkMode, cardColor, textColor, secondaryTextColor);
      default:
        return const SizedBox();
    }
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[900]
            : Colors.white,
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

  TextStyle _sectionTitleStyle() {
    return TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black);
  }

  // =========================================================================
  // Step 1: Cover Photo
  // =========================================================================
  Widget _buildStepCoverPhoto(
      bool isDarkMode, Color cardColor, Color textColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chipLabel(
              icon: Icons.photo_camera_outlined,
              title: 'Cover Photo',
              hinglish: 'Mukhya Photo',
              required: true,
            ),
            const SizedBox(height: 14),
            GestureDetector(
              onTap: _pickSingleImage,
              child: CustomPaint(
                painter: _DashedBorderPainter(
                  color: _singleImage == null ? _kBorder : _kPrimary,
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _singleImage == null
                        ? _kSurface2.withOpacity(0.6)
                        : _kPrimary.withOpacity(0.05),
                  ),
                  child: _singleImage == null
                      ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined,
                          size: 30, color: _kPrimary),
                      const SizedBox(height: 8),
                      const Text(
                        'Tap to add cover photo',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'Cover photo lagayein',
                        style:
                        TextStyle(fontSize: 10, color: Colors.grey[800]),
                      ),
                    ],
                  )
                      : Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_singleImage!.path),
                          width: double.infinity,
                          height: 140,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              size: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildImageActionButton(
                  icon: Icons.camera_alt_rounded,
                  label: 'Take Photo',
                  onTap: _takePhoto,
                  isDarkMode: isDarkMode,
                ),
                const SizedBox(width: 8),
                _buildImageActionButton(
                  icon: Icons.photo_library_rounded,
                  label: 'From Gallery',
                  onTap: _pickMultipleImages,
                  isDarkMode: isDarkMode,
                ),
              ],
            ),
            const SizedBox(height: 22),
            _chipLabel(
              icon: Icons.collections_outlined,
              title: 'Gallery Photos',
              hinglish: 'Aur Photos',
              required: false,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _pickMultipleImages,
              child: CustomPaint(
                painter: _DashedBorderPainter(color: _kBorder),
                child: Container(
                  height: 80,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: _kSurface2.withOpacity(0.6 ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       const Icon(Icons.add_photo_alternate_outlined,
                          size: 24, color: _kAccent),
                      const SizedBox(height: 4),
                      Text(
                        _selectedImages.isEmpty
                            ? 'Add gallery photos'
                            : '${_selectedImages.length} photo(s) added',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_selectedImages.isNotEmpty) ...[
              const SizedBox(height: 12),
              SizedBox(
                height: 64,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      width: 64,
                      height: 64,
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_selectedImages[index].path),
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 2,
                            right: 2,
                            child: GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.close_rounded,
                                    size: 11, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: _clearAllImages,
                  icon: const Icon(Icons.delete_outline_rounded,
                      size: 16, color: Colors.red),
                  label: const Text('Clear All',
                      style: TextStyle(color: Colors.red, fontSize: 12)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Step 2: Basic Info
  // =========================================================================
  Widget _buildStepBasicInfo(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chipLabel(
              icon: Icons.location_city_outlined,
              title: 'Place',
              hinglish: 'Jagah',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _selectedItem ?? 'Select Place',
              hasValue: _selectedItem != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Place',
                titleHi: 'Jagah',
                options: _items,
                value: _selectedItem,
                onSelect: (v) => setState(() => _selectedItem = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.apartment_outlined,
              title: 'Property Type',
              hinglish: 'Property ka Prakar',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _selectedPropertyType ?? 'Select Property Type',
              hasValue: _selectedPropertyType != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Property Type',
                titleHi: 'Property ka Prakar',
                options: propertyTypes,
                value: _selectedPropertyType,
                onSelect: (v) => setState(() => _selectedPropertyType = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.sell_outlined,
              title: 'Buy or Rent',
              hinglish: 'Kiraya ya Bikri',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _selectedItem1 ?? 'Select Buy or Rent',
              hasValue: _selectedItem1 != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Buy or Rent',
                titleHi: 'Kiraya ya Bikri',
                options: _items1,
                value: _selectedItem1,
                onSelect: (v) => setState(() => _selectedItem1 = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.stairs_outlined,
              title: 'Total Floor',
              hinglish: 'Kul Manzil',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _totalFloor ?? 'Select Total Floor',
              hasValue: _totalFloor != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Total Floor',
                titleHi: 'Kul Manzil',
                options: _items_floor2,
                value: _totalFloor,
                onSelect: (v) => setState(() => _totalFloor = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.calendar_month_outlined,
              title: 'Age of Property',
              hinglish: 'Property ki Umar',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _ageOfProperty ?? 'Select Age of Property',
              hasValue: _ageOfProperty != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Age of Property',
                titleHi: 'Property ki Umar',
                options: Age_Options,
                value: _ageOfProperty,
                onSelect: (v) => setState(() => _ageOfProperty = v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Step 3: Address & Location
  // =========================================================================
  Widget _buildStepAddressLocation(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chipLabel(
              icon: Icons.home_outlined,
              title: 'Property Name & Address',
              hinglish: 'Property ka Naam aur Address',
              required: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _address,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                label: 'Property Name & Address',
                icon: Icons.home_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ),
              maxLines: 2,
              validator: (value) =>
              (value == null || value.trim().isEmpty)
                  ? 'Please enter property address'
                  : null,
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.location_on_outlined,
              title: 'Address for Field Worker',
              hinglish: 'Field Worker ke liye Address',
              required: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _Address_apnehisaabka,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                label: 'Address for Field Worker',
                icon: Icons.map_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ),
              maxLines: 2,
              validator: (value) =>
              (value == null || value.isEmpty)
                  ? 'Please enter address for field worker'
                  : null,
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.location_on_outlined,
              title: 'Google Location',
              hinglish: 'Google Location',
              required: true,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _Google_Location,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                label: 'Google Location',
                icon: Icons.search_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ).copyWith(
                suffixIcon: _isGettingLocation
                    ? Container(
                  width: 10,
                  height: 10,
                  padding: const EdgeInsets.only(right: 2),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                    AlwaysStoppedAnimation<Color>(primaryColor),
                  ),
                )
                    : IconButton(
                  icon: Icon(Icons.my_location_rounded,
                      color: primaryColor),
                  onPressed: _getCurrentLocation,
                ),
              ),
              maxLines: 2,
              validator: (value) =>
              (value == null || value.isEmpty)
                  ? 'Please enter Google location'
                  : null,
            ),
            if (_currentAddress.isNotEmpty || _latitude != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: accentColor.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 16, color: accentColor),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_currentAddress.isNotEmpty)
                            Text(
                              'Detected: $_currentAddress',
                              style: TextStyle(
                                color: accentColor,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (_latitude != null && _longitude != null)
                            Text(
                              'Lat: ${_latitude!.toStringAsFixed(6)}, Lng: ${_longitude!.toStringAsFixed(6)}',
                              style: TextStyle(
                                color: accentColor.withOpacity(0.9),
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _currentAddress = '';
                          _latitude = null;
                          _longitude = null;
                        });
                      },
                      child: Icon(Icons.close_rounded,
                          size: 16, color: accentColor),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Step 4: Facilities & Access
  // =========================================================================
  Widget _buildStepFacilitiesAccess(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chipLabel(
              icon: Icons.checklist_outlined,
              title: 'Facilities',
              hinglish: 'Suvidhayein',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: selectedFacilities.isEmpty
                  ? 'Select Facilities'
                  : selectedFacilities.join(', '),
              hasValue: selectedFacilities.isNotEmpty,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: _openFacilitiesSheet,
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.rule_outlined,
              title: 'Road Width',
              hinglish: 'Sadak ki Chaudai',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: selectedRoadSize ?? 'Select Road Width',
              hasValue: selectedRoadSize != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Road Width',
                titleHi: 'Sadak ki Chaudai',
                options: roadSizeOptions,
                value: selectedRoadSize,
                onSelect: (v) => setState(() => selectedRoadSize = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.elevator_outlined,
              title: 'Lift Availability',
              hinglish: 'Lift Hai ya Nahi',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _selectedLift ?? 'Select Lift Availability',
              hasValue: _selectedLift != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Lift Availability',
                titleHi: 'Lift Hai ya Nahi',
                options: lift_options,
                value: _selectedLift,
                onSelect: (v) => setState(() => _selectedLift = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.directions_car_outlined,
              title: 'Parking',
              hinglish: 'Parking Hai ya Nahi',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _selectedParking ?? 'Select Parking',
              hasValue: _selectedParking != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Parking',
                titleHi: 'Parking Hai ya Nahi',
                options: parkingOptions,
                value: _selectedParking,
                onSelect: (v) => setState(() => _selectedParking = v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Step 5: Metro & Distance
  // =========================================================================
  Widget _buildStepMetroDistance(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chipLabel(
              icon: Icons.train_outlined,
              title: 'Metro Station',
              hinglish: 'Metro Station',
              required: false,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: _selectedMetro ?? 'Select Metro Station',
              hasValue: _selectedMetro != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Metro Station',
                titleHi: 'Metro Station',
                options: _metroOptions,
                value: _selectedMetro,
                onSelect: (v) => setState(() => _selectedMetro = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.straighten_outlined,
              title: 'Metro Distance',
              hinglish: 'Metro ki Doori',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay: selectedMetroDistance ?? 'Select Metro Distance',
              hasValue: selectedMetroDistance != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Metro Distance',
                titleHi: 'Metro ki Doori',
                options: metroDistanceOptions,
                value: selectedMetroDistance,
                onSelect: (v) => setState(() => selectedMetroDistance = v),
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.shopping_cart_outlined,
              title: 'Market Distance',
              hinglish: 'Bazaar ki Doori',
              required: true,
            ),
            const SizedBox(height: 10),
            _bottomSheetSelector(
              currentDisplay:
                  selectedMarketDistance ?? 'Select Market Distance',
              hasValue: selectedMarketDistance != null,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
              isDarkMode: isDarkMode,
              onTap: () => _openChipSheet(
                titleEn: 'Market Distance',
                titleHi: 'Bazaar ki Doori',
                options: marketDistanceOptions,
                value: selectedMarketDistance,
                onSelect: (v) => setState(() => selectedMarketDistance = v),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // Step 6: Owner & Caretaker (optional group)
  // =========================================================================
  Widget _buildStepOwnerCaretaker(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _chipLabel(
              icon: Icons.person_outline,
              title: 'Owner Name',
              hinglish: 'Malik ka Naam',
              required: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _Ownername,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                label: 'Owner Name (Optional)',
                icon: Icons.person_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.phone_outlined,
              title: 'Owner Number',
              hinglish: 'Malik ka Number',
              required: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _Owner_number,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                label: 'Owner No. (Optional)',
                icon: Icons.phone_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ).copyWith(
                counterText: "", // 🔥 hides "0/10"
              ),
              maxLength: 10,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.person_outline,
              title: 'Caretaker Name',
              hinglish: 'Caretaker ka Naam',
              required: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _CareTaker_name,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                label: 'CareTaker Name (Optional)',
                icon: Icons.person_outline_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.phone_outlined,
              title: 'Caretaker Number',
              hinglish: 'Caretaker ka Number',
              required: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _CareTaker_number,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                label: 'CareTaker No. (Optional)',
                icon: Icons.phone_outlined,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ).copyWith(
                counterText: "", // 🔥 hides "0/10"
              ),
              maxLength: 10,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            _chipLabel(
              icon: Icons.directions_car_outlined,
              title: 'Owner Vehicle Number',
              hinglish: 'Malik ki Gaadi Number',
              required: false,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _vehicleno,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              textCapitalization: TextCapitalization.characters,
              decoration: _buildInputDecoration(
                label: 'Owner Vehicle Number (Optional)',
                icon: Icons.directions_car_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
                isDarkMode: isDarkMode,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      size: 14, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Review your details and tap Submit Property to finish.',
                      style: const TextStyle(color: Colors.blue, fontSize: 11),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumCard(
      {required bool isDarkMode,
        required Color cardColor,
        required Widget child}) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(
      String title, IconData icon, Color textColor) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(0.1),
                  secondaryColor.withOpacity(0.1)
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: textColor,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String label,
    required IconData icon,
    required Color textColor,
    required Color secondaryTextColor,
    required bool isDarkMode,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: secondaryTextColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
      ),
      prefixIcon: Icon(icon, color: primaryColor),
      suffixText: suffixText,
      filled: true,
      fillColor: isDarkMode ? Colors.grey[850] : Colors.white,
    );
  }

  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
    required bool isDarkMode,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDanger
                ? Colors.red.withOpacity(0.05)
                : primaryColor.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDanger
                  ? Colors.red.withOpacity(0.2)
                  : primaryColor.withOpacity(0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 16,
                  color:
                  isDanger ? Colors.red : primaryColor),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color:
                  isDanger ? Colors.red : primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickSingleImage() async {
    try {
      final XFile? image = await HeicConverter.pickImage(_imagePicker, 
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _singleImage = image;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick image. Please try again.');
    }
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images =
      await HeicConverter.pickMultiImage(_imagePicker, 
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 80,
      );
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to pick images. Please try again.');
    }
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? image = await HeicConverter.pickImage(_imagePicker, 
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (image != null) {
        setState(() {
          _singleImage = image;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to take photo. Please try again.');
    }
  }

  void _clearAllImages() {
    setState(() {
      _selectedImages.clear();
    });
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color(0xFF1E1E1E)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline_rounded,
                    size: 50, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode
                        ? Colors.white
                        : const Color(0xFF2D3748),
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white70
                          : const Color(0xFF2D3748)
                          .withOpacity(0.7),
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('OK',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _Ownername.dispose();
    _Owner_number.dispose();
    _Address_apnehisaabka.dispose();
    _CareTaker_name.dispose();
    _CareTaker_number.dispose();
    _vehicleno.dispose();
    _Google_Location.dispose();
    _address.dispose();
    // _Building_information.dispose();
    super.dispose();
  }
}

/// Lightweight dashed rounded-rect border painter used by the cover
/// photo / gallery tap targets, so no new package dependency is needed.
class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double radius;

  _DashedBorderPainter({required this.color, this.radius = 12});

  @override
  void paint(Canvas canvas, Size size) {
    final RRect rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final Path path = Path()..addRRect(rrect);
    final Path dashPath = Path();

    const double dashWidth = 6.0;
    const double dashGap = 4.0;

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final double next = distance + dashWidth;
        dashPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + dashGap;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
