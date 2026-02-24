import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/constant.dart';
import '../Plot_detail.dart';

class EditPlotform extends StatefulWidget {
  final int propertyId;
  final PlotPropertyData propertyData;

  const EditPlotform({
    super.key,
    required this.propertyId,
    required this.propertyData,
  });

  @override
  State<EditPlotform> createState() => _EditPlotformState();
}

class _EditPlotformState extends State<EditPlotform> {
  final _formKey = GlobalKey<FormState>();
  final _imagePicker = ImagePicker();

  // Controllers
  late final List<TextEditingController> _controllers;

  // Individual controllers
  final TextEditingController _plotSizeController = TextEditingController();
  final TextEditingController _frontSizeController = TextEditingController();
  final TextEditingController _sideSizeController = TextEditingController();
  final TextEditingController _roadSizeController = TextEditingController();
  final TextEditingController _plotPriceController = TextEditingController();
  final TextEditingController _fieldAddressController = TextEditingController();
  final TextEditingController _mainAddressController = TextEditingController();
  final TextEditingController _currentLocationController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _fieldworkerNameController = TextEditingController();
  final TextEditingController _fieldworkerNumberController = TextEditingController();
  final TextEditingController _DescriptionController = TextEditingController();


  @override
  void initState() {
    super.initState();

    final data = widget.propertyData;

    // Controllers Prefill
    _frontSizeController.text = data.plotFrontSize ?? '';
    _sideSizeController.text = data.plotSideSize ?? '';
    _plotPriceController.text = data.plotPrice ?? '';
    _fieldAddressController.text = data.fieldAddress ?? '';
    _mainAddressController.text = data.mainAddress ?? '';
    _currentLocationController.text = data.currentLocation ?? '';
    _longitudeController.text = data.longitude ?? '';
    _latitudeController.text = data.latitude ?? '';
    _DescriptionController.text = data.Description ?? '';

    // 🔥 SAFE FRONT VALUE PREFILL

    String roadRaw = data.roadSize.trim();

    if (_roadSizeOptions.contains(roadRaw)) {
      _selectedRoadSize = roadRaw;
    }
    else if (_roadSizeOptions.contains("$roadRaw ft")) {
      _selectedRoadSize = "$roadRaw ft";
    }
    else {
      _selectedRoadSize = 'Custom';
      _roadSizeController.text = roadRaw;
    }

    if (_roadSizeOptions.contains(roadRaw)) {
      _selectedRoadSize = roadRaw;
    }
    else if (_roadSizeOptions.contains("$roadRaw ft")) {
      _selectedRoadSize = "$roadRaw ft";
    }
    else {
      _selectedRoadSize = 'Custom';
      _roadSizeController.text = roadRaw;
    }

    if (_frontSizeController.text.isNotEmpty) {
      final val = double.tryParse(_frontSizeController.text);
      if (val != null) {
        _frontValue = val;
      }
    }

    // 🔥 SAFE SIDE VALUE PREFILL
    if (_sideSizeController.text.isNotEmpty) {
      final val = double.tryParse(_sideSizeController.text);
      if (val != null) {
        _sideValue = val;
      }
    }

    // Plot size
    String plotSizeRaw = (data.plotSize ?? '').trim();
    String plotSizeClean = plotSizeRaw.replaceAll(' gaj', '');

    if (_plotSizeOptions.contains("$plotSizeClean gaj")) {
      _selectedPlotSize = "$plotSizeClean gaj";
    } else {
      _selectedPlotSize = 'Custom';
      _plotSizeController.text = plotSizeClean;
    }

    // Safe dropdowns
    String clean(String? v) => v?.trim() ?? '';

    _selectedPlotStatus =
    _plotStatusOptions.contains(clean(data.plotStatus))
        ? clean(data.plotStatus)
        : null;

    _selectedPropertyChain =
    _propertyChainOptions.contains(clean(data.propertyChain))
        ? clean(data.propertyChain)
        : null;

    _selectedPropertyRent =
    _propertyRentOptions.contains(clean(data.propertyRent))
        ? clean(data.propertyRent)
        : null;

    _selectedWaterConnection =
    _yesNoOptions.contains(clean(data.waterConnection))
        ? clean(data.waterConnection)
        : null;

    _selectedElectricMeter =
    _yesNoOptions.contains(clean(data.electricPrice))
        ? clean(data.electricPrice)
        : null;

    _selectedPlotOpen =
    _plotOpenOptions.contains(clean(data.plotOpen))
        ? clean(data.plotOpen)
        : null;

    _selectedAge =
    _ageOptions.contains(clean(data.ageOfProperty))
        ? clean(data.ageOfProperty)
        : null;

    // 🔥 calculate AFTER values set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculatePriceDetails();
    });
  }




  // Dropdown values
  String? _selectedPlotSize;
  String? _selectedFrontSize;
  String? _selectedSideSize;
  String? _selectedRoadSize;
  String? _selectedAge;
  String? _selectedPlotStatus;
  String? _selectedPropertyChain;
  String? _selectedPropertyRent;
  String? _selectedPlotOpen;
  String? _selectedWaterConnection;
  String? _selectedElectricMeter;


  double? _plotGaj;
  double? _plotSqft;
  double? _frontValue;
  double? _sideValue;

  double? _pricePerGaj;
  double? _pricePerSqft;

  String _priceUnit = 'INR';

  String formatIndianCurrency(double amount) {
    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '',
      decimalDigits: 0,
    );
    return formatter.format(amount).trim();
  }

  String formatShortIndian(double amount) {
    if (amount >= 10000000) {
      return "${(amount / 10000000).toStringAsFixed(2)} Cr";
    } else if (amount >= 100000) {
      return "${(amount / 100000).toStringAsFixed(2)} Lakh";
    } else if (amount >= 1000) {
      return "${(amount / 1000).toStringAsFixed(2)} Thousand";
    } else {
      return amount.toStringAsFixed(0);
    }
  }


  void _calculatePriceDetails() {
    final totalPrice = double.tryParse(_plotPriceController.text);
    final gaj = double.tryParse(_currentPlotSizeValue ?? '');

    if (gaj != null && gaj > 0) {
      final sqft = gaj * 9;

      setState(() {
        _plotGaj = gaj;
        _plotSqft = sqft;

        if (totalPrice != null) {
          _pricePerGaj = totalPrice / gaj;
          _pricePerSqft = totalPrice / sqft;
          _priceUnit = formatShortIndian(totalPrice);
        }
      });

      // 🔥 IMPORTANT — recalc dimension if front already filled
      _recalculateDimensions();
    }
  }

  void _recalculateDimensions() {
    if (_plotSqft == null || _plotSqft! <= 0) return;
    if (_frontValue == null || _frontValue! <= 0) return;

    final side = _plotSqft! / _frontValue!;

    setState(() {
      _sideValue = side;

      // 🔥 AUTO FILL SIDE CONTROLLER
      _sideSizeController.text = side.toStringAsFixed(2);

      // 🔥 AUTO SELECT CUSTOM FOR SIDE
      _selectedSideSize = 'Custom';
    });
  }

  // Images
  XFile? single_image;
  // Constants
  static const List<double> _plotSizeValuesInGaj = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500];
  static const List<String> _frontSizeOptions = [
    '20 ft', '25 ft', '30 ft', '35 ft', '40 ft', '45 ft', '50 ft', '60 ft', '70 ft', '80 ft', 'Custom'
  ];
  // static const List<String> _sideSizeOptions = [
  //   '20 ft', '25 ft', '30 ft', '35 ft', '40 ft', '45 ft', '50 ft', '60 ft', '70 ft', '80 ft', 'Custom'
  // ];
  static const List<String> _roadSizeOptions = [
    '10 ft', '15 ft', '20 ft', '25 ft', '30 ft', '35 ft', '40 ft', '50 ft', '60 ft', '80 ft', '100 ft', 'Custom'
  ];
  static const List<String> _ageOptions = ['1 year', '2 years', '3 years', '4 years', '5 years'];
  static const List<String> _plotStatusOptions = [
    'Register', 'GPA', 'Lal Dara', 'Power of Attorney', 'Loan'
  ];
  static const List<String> _propertyChainOptions = ['Yes', 'No'];
  static const List<String> _propertyRentOptions = ['Available for Rent', 'Not for Rent'];
  static const List<String> _plotOpenOptions = ['1 Side', '2 Side', '3 Side', '4 Side'];
  static const List<String> _yesNoOptions = ['Yes', 'No'];

  bool _isGettingLocation = false;
  bool _isUploading = false;

  static const Color _primaryColor = Color(0xFF2D5BFF);
  static const Color _secondaryColor = Color(0xFF6C63FF);
  static const Color _accentColor = Color(0xFF00D4AA);
  static const Color _textColorConst = Color(0xFF2D3748);

  static const double _conversionFactor = 9.0;

  List<String> get _plotSizeOptions =>
      [..._plotSizeValuesInGaj.map((v) => '${v.toStringAsFixed(0)} gaj'), 'Custom'];

  String? get _currentPlotSizeValue {
    if (_selectedPlotSize == 'Custom' && _plotSizeController.text.isNotEmpty) {
      return _plotSizeController.text;
    } else if (_selectedPlotSize != null && _selectedPlotSize != 'Custom') {
      return _selectedPlotSize!.split(' ').first;
    }
    return null;
  }

  String get _convertedSqftValue {
    if (_currentPlotSizeValue != null) {
      final gaj = double.tryParse(_currentPlotSizeValue!) ?? 0;
      return (_conversionFactor * gaj).toStringAsFixed(0);
    }
    return '0';
  }

  static const String _apiUrl =
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/update_plot_api.php";


  static String _stripUnits(String? s) => (s ?? '').replaceAll(RegExp(r'[^0-9.]'), '').trim();

  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) _showSnackBar('Location permission denied', Colors.red);
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      if (mounted) _showSnackBar('Location permanently denied. Enable from settings.', Colors.red);
      return false;
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    final ok = await _handleLocationPermission();
    if (!ok) return;
    setState(() => _isGettingLocation = true);
    try {
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      final placemark = placemarks.first;
      final address = [
        placemark.street,
        placemark.subLocality,
        placemark.locality,
        placemark.administrativeArea,
        placemark.postalCode
      ].where((e) => (e ?? '').trim().isNotEmpty).join(', ');
      if (mounted) {
        setState(() {
          _latitudeController.text = position.latitude.toStringAsFixed(6);
          _longitudeController.text = position.longitude.toStringAsFixed(6);
          _currentLocationController.text = address;
        });
        _showSnackBar('Location fetched successfully', _accentColor);
      }
    } catch (e) {
      if (mounted) _showSnackBar('Could not get location: $e', Colors.red);
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  Future<void> _updateProperty() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill all required fields', Colors.red);
      return;
    }

    if (_isUploading) return;

    setState(() => _isUploading = true);
    _showLoadingDialog('Updating Property...');

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedName = prefs.getString('name') ?? '';
      final savedNumber = prefs.getString('number') ?? '';

      final request = http.MultipartRequest(
        'POST',
        Uri.parse(_apiUrl),
      );

      request.fields['id'] = widget.propertyId.toString();

      request.fields.addAll({
        'plot_size': _stripUnits(_currentPlotSizeValue ?? ''),
        'plot_front_size': _stripUnits(_frontSizeController.text),
        'plot_side_size': _stripUnits(_sideSizeController.text),
        'road_size': _stripUnits(
          _selectedRoadSize == 'Custom'
              ? _roadSizeController.text
              : _selectedRoadSize,
        ),
        'plot_open': _selectedPlotOpen ?? '',
        'age_of_property': _selectedAge ?? '',
        'water_connection': _selectedWaterConnection ?? '',
        'electric_price': _selectedElectricMeter ?? '',
        'plot_price': _stripUnits(_plotPriceController.text),
        'plot_status': _selectedPlotStatus ?? '',
        'property_chain': _selectedPropertyChain ?? '',
        'field_address': _fieldAddressController.text.trim(),
        'main_address': _mainAddressController.text.trim(),
        'current_location': _currentLocationController.text.trim(),
        'longitude': _longitudeController.text.trim(),
        'latitude': _latitudeController.text.trim(),
        'fieldworkar_name': savedName,
        'fieldworkar_number': savedNumber,
        'property_rent': _selectedPropertyRent ?? '',
        'Description': _DescriptionController.text.trim(),
      });

      // Image only if changed
      if (single_image != null) {
        request.files.add(
          await _createMultipartFile(
            'single_image',
            single_image!.path,
          ),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      _hideLoadingDialog();

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 'success') {
          _showSnackBar("Property Updated Successfully!", Colors.green);
          Navigator.pop(context, true);
        } else {
          _showErrorDialog("Update Failed", data['message'] ?? 'Server error');
        }
      } else {
        _showErrorDialog("Update Failed", "Server error");
      }
    } catch (e) {
      _hideLoadingDialog();
      _showSnackBar("Update error: $e", Colors.red);
    }

    if (mounted) {
      setState(() => _isUploading = false);
    }
  }

  Future<http.MultipartFile> _createMultipartFile(String fieldName, String filePath) async {
    final filename = path.basename(filePath);
    final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
    final parts = mimeType.split('/');
    return await http.MultipartFile.fromPath(
      fieldName,
      filePath,
      filename: filename,
      contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'octet-stream'),
    );
  }

  Future<void> _saveFieldworkerNumber() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('number', _fieldworkerNumberController.text.trim());
    } catch (_) {}
  }

  Future<void> _fetchPlotProperties() async {
    try {
      await http.get(Uri.parse('https://your-api.com/plots'));
    } catch (_) {}
  }

  void _showSnackBar(String message, Color backgroundColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: backgroundColor),
    );
  }

  void _showLoadingDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }

  void _hideLoadingDialog() {
    if (!mounted) return;
    final nav = Navigator.of(context, rootNavigator: true);
    if (nav.canPop()) nav.pop();
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(color: Colors.red)),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK')),
        ],
      ),
    );
  }

  Future<void> _pickSingleImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (image != null && mounted) setState(() => single_image = image);
    } catch (_) {}
  }

  Future<void> _takePhoto() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (image != null && mounted) setState(() => single_image = image);
    } catch (_) {}
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 8.0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:Image.asset(AppImages.transparent,height: 40,),
        centerTitle: true,
        iconTheme: IconThemeData(color:Colors.white),
        ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: padding,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(isDark),
                const SizedBox(height: 24),
                _buildImageUploadSection(isDark),
                const SizedBox(height: 20),
                _buildPlotSizeSection(isDark),
                const SizedBox(height: 20),
                _buildDimensionsSection(isDark),
                const SizedBox(height: 20),
                _buildRoadAndOpenSection(isDark),
                const SizedBox(height: 20),
                _buildAgeSection(isDark),
                const SizedBox(height: 20),
                _buildUtilitiesSection(isDark),
                const SizedBox(height: 20),
                _buildPriceAndAddressSection(isDark),
                const SizedBox(height: 20),
                _buildDescriptionSection(isDark),
                const SizedBox(height: 20),
                _buildLocationSection(isDark),
                const SizedBox(height: 20),
                _buildPlotStatusSection(isDark),
                const SizedBox(height: 20),
                _buildPropertyChainSection(isDark),
                const SizedBox(height: 20),
                _buildPropertyRentSection(isDark),
                const SizedBox(height: 30),
                _buildSubmitButton(isDark),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.scatter_plot, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'Update Plot',
                    style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Fill all details to showcase your property',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Container(
                  height: 4,
                  width: 230,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Property Image',
      icon: Icons.photo_library,
      child: Column(
        children: [
          GestureDetector(
            onTap: _pickSingleImage,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: single_image != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  File(single_image!.path),
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              )
                  : (widget.propertyData.singleImageUrl != null &&
                  widget.propertyData.singleImageUrl!.isNotEmpty)
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  widget.propertyData.singleImageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Text("Image Not Found On Server"),
                    );
                  },
                ),
              )
                  : const Center(
                child: Text("Tap to Select Cover Image"),
              ),

            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 55,
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_primaryColor, _secondaryColor],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: _takePhoto,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.camera_alt, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Take Photo",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }




  Widget _buildImageActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDanger = false,
    required bool isDark,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDanger
                ? Colors.red.withOpacity(isDark ? 0.2 : 0.05)
                : _primaryColor.withOpacity(isDark ? 0.2 : 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDanger
                  ? Colors.red.withOpacity(isDark ? 0.4 : 0.2)
                  : _primaryColor.withOpacity(isDark ? 0.4 : 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 16, color: isDanger ? Colors.red : _primaryColor),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDanger ? Colors.red : _primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildPlotSizeSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor =
    isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    final bool isCustom = _selectedPlotSize == 'Custom';

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Price & Plot Size (Gaj)',
      icon: Icons.aspect_ratio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const SizedBox(height: 12),

          /// PRICE
          TextFormField(
            controller: _plotPriceController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Enter Plot Price',
              icon: Icons.money,
              suffixText: _priceUnit,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _calculatePriceDetails(),
            validator: (v) =>
            v == null || v.isEmpty ? 'Please enter plot price' : null,
          ),

          const SizedBox(height: 12),

          /// PLOT SIZE DROPDOWN
          DropdownButtonFormField<String>(
            value: _plotSizeOptions.contains(_selectedPlotSize)
                ? _selectedPlotSize
                : null,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Select Plot Size (Gaj)',
              icon: Icons.space_dashboard,
              textColor: textColor,
              secondaryTextColor:
              isCustom ? Colors.orange : secondaryTextColor,
            ).copyWith(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                    color: isCustom ? Colors.orange : _primaryColor,
                    width: 2),
              ),
            ),
            items: _plotSizeOptions
                .map((v) => DropdownMenuItem(
              value: v,
              child: Text(
                v,
                style: TextStyle(
                  color: v == 'Custom'
                      ? Colors.orange
                      : textColor,
                ),
              ),
            ))
                .toList(),
            onChanged: (v) {
              setState(() {
                _selectedPlotSize = v;
              });
              _calculatePriceDetails();
            },
            validator: (v) =>
            v == null || v.isEmpty ? 'Please select plot size' : null,
          ),

          /// CUSTOM SIZE
          if (isCustom) ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _plotSizeController,
              decoration: _inputDecoration(
                isDark: isDark,
                label: 'Enter Custom Size (Gaj)',
                icon: Icons.edit,
                textColor: textColor,
                secondaryTextColor: Colors.orange,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => _calculatePriceDetails(),
              validator: (value) =>
              value == null || value.isEmpty
                  ? 'Please enter plot size'
                  : null,
            ),
          ],

          /// AREA DISPLAY
          if (_plotSqft != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Total Area: ${_plotSqft!.toStringAsFixed(2)} Sqft",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],

          /// PRICE BREAKDOWN
          if (_pricePerGaj != null && _pricePerSqft != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text("₹ ${_pricePerGaj!.toStringAsFixed(0)} per Gaj"),
                  Text("₹ ${_pricePerSqft!.toStringAsFixed(0)} per Sqft"),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildDimensionsSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor =
    isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Plot Dimensions',
      icon: Icons.straighten,
      child: Column(
        children: [

          /// 🔹 LENGTH (MANUAL ONLY)
          TextFormField(
            controller: _frontSizeController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Length (Front) in ft',
              icon: Icons.straighten,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final val = double.tryParse(value);
              if (val != null && val > 0) {
                _frontValue = val;
                _recalculateDimensions();
              }
            },
            validator: (v) =>
            v == null || v.isEmpty ? 'Please enter length' : null,
          ),

          const SizedBox(height: 16),

          /// 🔹 BREADTH (AUTO + FIELD SHOW)
          TextFormField(
            controller: _sideSizeController,
            readOnly: true,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Breadth (Auto Calculated)',
              icon: Icons.square_foot,
              textColor: textColor,
              secondaryTextColor: Colors.orange,
            ),
          ),

          /// 🔹 AREA DISPLAY
          if (_frontValue != null &&
              _sideValue != null &&
              _plotSqft != null) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "Total Area: ${_plotSqft!.toStringAsFixed(2)} Sqft\n"
                    "(${_frontValue!.toStringAsFixed(2)} × ${_sideValue!.toStringAsFixed(2)})",
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }


  Widget _buildFrontField({
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    final bool isCustom = _selectedFrontSize == 'Custom';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedFrontSize,
          decoration: _inputDecoration(
            isDark: isDark,
            label: 'Front Size',
            icon: Icons.straighten,
            textColor: textColor,
            secondaryTextColor:
            isCustom ? Colors.orange : secondaryTextColor,
          ).copyWith(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: isCustom ? Colors.orange : _primaryColor,
                  width: 2),
            ),
          ),
          items: _frontSizeOptions
              .map((v) => DropdownMenuItem(
            value: v,
            child: Text(
              v,
              style: TextStyle(
                color: v == 'Custom'
                    ? Colors.orange
                    : textColor,
              ),
            ),
          ))
              .toList(),
          onChanged: (v) {
            setState(() {
              _selectedFrontSize = v;

              if (v != null && v != 'Custom') {
                final val =
                double.tryParse(v.replaceAll(' ft', '').trim());
                if (val != null) {
                  _frontValue = val;
                  _recalculateDimensions();
                }
              }
            });
          },
          validator: (v) =>
          v == null || v.isEmpty ? 'Please select front size' : null,
        ),

        if (isCustom) ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: _frontSizeController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Custom Front (ft)',
              textColor: textColor,
              secondaryTextColor: Colors.orange,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final val = double.tryParse(value);
              if (val != null) {
                _frontValue = val;
                _recalculateDimensions();
              }
            },
          ),
        ],
      ],
    );
  }



  Widget _buildRoadAndOpenSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Road & Plot Open',
      icon: Icons.aod,
      child: Column(
        children: [
          _CustomDropdown<String>(
            value: _selectedRoadSize,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Road Size',
              icon: Icons.aod,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            items: _roadSizeOptions
                .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
                .toList(),
            onChanged: (v) => setState(() => _selectedRoadSize = v),
            validator: (v) => v == null || v.isEmpty ? 'Please select road size' : null,
          ),
          if (_selectedRoadSize == 'Custom') ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _roadSizeController,
              decoration: _inputDecoration(
                isDark: isDark,
                label: 'Enter Custom Road Size (ft)',
                icon: Icons.edit,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              keyboardType: TextInputType.number,
              validator: (v) => _selectedRoadSize == 'Custom' && (v == null || v.isEmpty)
                  ? 'Please enter road size'
                  : null,
            ),
          ],
          const SizedBox(height: 12),
          _CustomDropdown<String>(
            value: _selectedPlotOpen,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Plot Open Sides',
              icon: Icons.open_in_full,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            items: _plotOpenOptions
                .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
                .toList(),
            onChanged: (v) => setState(() => _selectedPlotOpen = v),
            validator: (v) => v == null || v.isEmpty ? 'Please select plot open sides' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildAgeSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Age of Property',
      icon: Icons.calendar_today,
      child: _CustomDropdown<String>(
        value: _selectedAge,
        decoration: _inputDecoration(
          isDark: isDark,
          label: 'Select Property Age',
          icon: Icons.timelapse,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
        ),
        items: _ageOptions
            .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
            .toList(),
        onChanged: (v) => setState(() => _selectedAge = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select property age' : null,
      ),
    );
  }

  Widget _buildUtilitiesSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Utilities',
      icon: Icons.build,
      child: Column(
        children: [
          _CustomDropdown<String>(
            value: _selectedWaterConnection,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Water Connection',
              icon: Icons.water_drop,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            items: _yesNoOptions
                .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
                .toList(),
            onChanged: (v) => setState(() => _selectedWaterConnection = v),
            validator: (v) => v == null || v.isEmpty ? 'Please select water connection' : null,
          ),
          const SizedBox(height: 12),
          _CustomDropdown<String>(
            value: _selectedElectricMeter,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Electric Meter',
              icon: Icons.electrical_services,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            items: _yesNoOptions
                .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
                .toList(),
            onChanged: (v) => setState(() => _selectedElectricMeter = v),
            validator: (v) => v == null || v.isEmpty ? 'Please select electric meter' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPriceAndAddressSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Addresses',
      icon: Icons.attach_money,
      child: Column(
        children: [
          const SizedBox(height: 12),
          TextFormField(
            controller: _fieldAddressController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Field Address (where visited)',
              icon: Icons.location_on,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.streetAddress,
            maxLines: 2,
            validator: (v) => v == null || v.isEmpty ? 'Please enter field address' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _mainAddressController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Main Address / Property address',
              icon: Icons.home,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.streetAddress,
            maxLines: 3,
            validator: (v) => v == null || v.isEmpty ? 'Please enter main address' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor =
    isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Property Description',
      icon: Icons.description,
      child: TextFormField(
        controller: _DescriptionController,
        maxLines: 5,
        decoration: _inputDecoration(
          isDark: isDark,
          label: 'Enter Property Description',
          icon: Icons.edit_note,
          textColor: textColor,
          secondaryTextColor: secondaryTextColor,
        ),
        validator: (value) =>
        value == null || value.isEmpty
            ? 'Please enter property description'
            : null,
      ),
    );
  }


  Widget _buildLocationSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Location',
      icon: Icons.my_location,
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 400) {
                return Column(
                  children: [
                    TextFormField(
                      controller: _currentLocationController,
                      style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                      decoration: InputDecoration(
                        labelText: 'Property Location',
                        labelStyle: TextStyle(color: secondaryTextColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey.withOpacity(0.2)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _primaryColor),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey.withOpacity(0.2)),
                        ),
                        prefixIcon: Icon(Icons.map_rounded, color: _primaryColor),
                        hintText: 'Enter complete address',
                        hintStyle: TextStyle(color: secondaryTextColor),
                        suffixIcon: _isGettingLocation
                            ? Container(
                          width: 20,
                          height: 20,
                          padding: const EdgeInsets.all(2),
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(_primaryColor),
                          ),
                        )
                            : IconButton(
                          icon: Icon(Icons.my_location_rounded, color: _primaryColor),
                          onPressed: _getCurrentLocation,
                        ),
                        filled: true,
                        fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
                      ),
                      maxLines: 2,
                      validator: (value) => (value == null || value.isEmpty) ? 'Please enter location' : null,
                    ),
                  ],
                );
              } else {
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _currentLocationController,
                        decoration: _inputDecoration(
                          isDark: isDark,
                          label: 'Current Location',
                          icon: Icons.place,
                          textColor: textColor,
                          secondaryTextColor: secondaryTextColor,
                        ),
                        readOnly: true,
                        maxLines: 2,
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      height: 60,
                      child: ElevatedButton(
                        onPressed: _isGettingLocation ? null : _getCurrentLocation,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: _isGettingLocation
                            ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                        )
                            : const Icon(Icons.my_location, color: Colors.white),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPlotStatusSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Plot Status',
      icon: Icons.description,
      child: _CustomDropdown<String>(
        value: _selectedPlotStatus,
        decoration: _inputDecoration(
          isDark: isDark,
          label: 'Select Plot Status',
          icon: Icons.assignment,
          textColor: textColor,
          secondaryTextColor: isDark ? Colors.white70 : _textColorConst.withOpacity(0.6),
        ),
        items: _plotStatusOptions
            .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
            .toList(),
        onChanged: (v) => setState(() => _selectedPlotStatus = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select plot status' : null,
      ),
    );
  }

  Widget _buildPropertyChainSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Property Chain',
      icon: Icons.link,
      child: _CustomDropdown<String>(
        value: _selectedPropertyChain,
        decoration: _inputDecoration(
          isDark: isDark,
          label: 'Property Chain Available?',
          icon: Icons.chair,
          textColor: textColor,
          secondaryTextColor: isDark ? Colors.white70 : _textColorConst.withOpacity(0.6),
        ),
        items: _propertyChainOptions
            .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
            .toList(),
        onChanged: (v) => setState(() => _selectedPropertyChain = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select property chain' : null,
      ),
    );
  }

  Widget _buildPropertyRentSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Property Rent',
      icon: Icons.business_center,
      child: _CustomDropdown<String>(
        value: _selectedPropertyRent,
        decoration: _inputDecoration(
          isDark: isDark,
          label: 'Rent Availability',
          icon: Icons.bento,
          textColor: textColor,
          secondaryTextColor: isDark ? Colors.white70 : _textColorConst.withOpacity(0.6),
        ),
        items: _propertyRentOptions
            .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
            .toList(),
        onChanged: (v) => setState(() => _selectedPropertyRent = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select rent option' : null,
      ),
    );
  }
  Widget _buildSubmitButton(bool isDark) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_primaryColor, _secondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: _primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: _isUploading ? null : _updateProperty,
          child: Stack(
            alignment: Alignment.center,
            children: [

              /// CENTER TEXT
              const Text(
                'Update Property',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: Colors.white,
                ),
              ),

              /// RIGHT ICON
              Positioned(
                right: 20,
                child: const Icon(
                  Icons.touch_app,
                  size: 22,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required bool isDark,
    required Color cardColor,
    required String title,
    required IconData icon,
    required Widget child,
  }) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _IconContainer(icon: icon),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : _textColorConst,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required bool isDark,
    required String label,
    IconData? icon,
    String? suffixText,
    required Color textColor,
    required Color secondaryTextColor,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: secondaryTextColor, fontSize: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey[400]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: isDark ? Colors.grey[600]! : Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _primaryColor, width: 2),
      ),
      prefixIcon: icon != null
          ? Padding(
        padding: const EdgeInsets.only(left: 12, right: 8),
        child: Icon(icon, color: secondaryTextColor, size: 20),
      )
          : null,
      suffixText: suffixText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
    );
  }

  Widget _IconContainer({required IconData icon, Color color = _primaryColor}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }
}

class _CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final InputDecoration decoration;
  final String? Function(T?)? validator;

  const _CustomDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
    required this.decoration,
    this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: items.any((item) => item.value == value) ? value : null,
      decoration: decoration,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
    );
  }
}