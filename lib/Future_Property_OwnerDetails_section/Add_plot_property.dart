import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/constant.dart';
import 'plot_detail.dart'; // PlotPropertyData model

class PropertyListingPage extends StatefulWidget {
  const PropertyListingPage({super.key});

  @override
  State<PropertyListingPage> createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
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

  @override
  void initState() {
    super.initState();
    _controllers = [
      _plotSizeController,
      _frontSizeController,
      _sideSizeController,
      _roadSizeController,
      _plotPriceController,
      _fieldAddressController,
      _mainAddressController,
      _currentLocationController,
      _longitudeController,
      _latitudeController,
      _fieldworkerNameController,
      _fieldworkerNumberController,
    ];
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

  // Images
  XFile? _singleImage;
  List<XFile> _selectedImages = [];

  // Constants
  static const List<double> _plotSizeValuesInGaj = [50, 100, 150, 200, 250, 300, 350, 400, 450, 500];
  static const List<String> _frontSizeOptions = [
    '20 ft', '25 ft', '30 ft', '35 ft', '40 ft', '45 ft', '50 ft', '60 ft', '70 ft', '80 ft', 'Custom'
  ];
  static const List<String> _sideSizeOptions = [
    '20 ft', '25 ft', '30 ft', '35 ft', '40 ft', '45 ft', '50 ft', '60 ft', '70 ft', '80 ft', 'Custom'
  ];
  static const List<String> _roadSizeOptions = [
    '10 ft', '15 ft', '20 ft', '25 ft', '30 ft', '35 ft', '40 ft', '50 ft', '60 ft', '80 ft', '100 ft', 'Custom'
  ];
  static const List<String> _ageOptions = ['1 year', '2 years', '3 years', '4 years', '5 years'];
  static const List<String> _plotStatusOptions = ['Register', 'GPA', 'Lal Dara', 'Power of Attorney', 'Loan'];
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

  static const String _apiUrl = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/plot_add_api.php";

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
        placemark.locality,
        placemark.administrativeArea,
        placemark.country,
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

  PlotPropertyData _buildLocalPropertyData() {
    final onlyNum = _stripUnits;
    return PlotPropertyData(
      plotSize: _currentPlotSizeValue ?? '',
      plotPrice: _plotPriceController.text.trim(),
      fieldAddress: _fieldAddressController.text.trim(),
      mainAddress: _mainAddressController.text.trim(),
      plotFrontSize: onlyNum(_selectedFrontSize == 'Custom'
          ? _frontSizeController.text
          : (_selectedFrontSize ?? '')),
      plotSideSize: onlyNum(_selectedSideSize == 'Custom'
          ? _sideSizeController.text
          : (_selectedSideSize ?? '')),
      roadSize: onlyNum(_selectedRoadSize == 'Custom'
          ? _roadSizeController.text
          : (_selectedRoadSize ?? '')),
      plotOpen: _selectedPlotOpen ?? '',
      ageOfProperty: _selectedAge ?? '',
      waterConnection: _selectedWaterConnection ?? '',
      electricPrice: _selectedElectricMeter ?? '',
      plotStatus: _selectedPlotStatus ?? '',
      propertyChain: _selectedPropertyChain ?? '',
      currentLocation: _currentLocationController.text.trim(),
      longitude: _longitudeController.text.trim(),
      latitude: _latitudeController.text.trim(),
      fieldworkarName: _fieldworkerNameController.text.trim(),
      fieldworkarNumber: _fieldworkerNumberController.text.trim(),
      propertyRent: _selectedPropertyRent ?? '',
      singleImage: _singleImage,
      // ✅ Now supported as dynamic (XFile?)
      selectedImages: _selectedImages, // List<XFile>
    );
  }

  Future<void> _uploadProperty() async {
    if (_singleImage == null && _selectedImages.isEmpty) {
      _showSnackBar('Please add at least one image (main or additional).', Colors.red);
      return;
    }
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('Please fill all required fields', Colors.red);
      return;
    }

    _showLoadingDialog('Uploading Property...');
    setState(() => _isUploading = true);
    try {
      final uri = Uri.parse(_apiUrl);
      final request = http.MultipartRequest('POST', uri);

      final plotFront = _selectedFrontSize == 'Custom' ? _frontSizeController.text.trim() : (_selectedFrontSize ?? '');
      final plotSide = _selectedSideSize == 'Custom' ? _sideSizeController.text.trim() : (_selectedSideSize ?? '');
      final road = _selectedRoadSize == 'Custom' ? _roadSizeController.text.trim() : (_selectedRoadSize ?? '');

      final requiredFields = <String, String>{
        'plot_size': _stripUnits(_currentPlotSizeValue),
        'plot_price': _stripUnits(_plotPriceController.text.trim()),
        'field_address': _fieldAddressController.text.trim(),
        'main_address': _mainAddressController.text.trim(),
      };

      final optionalFields = <String, String>{
        'plot_front_size': _stripUnits(plotFront),
        'plot_side_size': _stripUnits(plotSide),
        'road_size': _stripUnits(road),
        'plot_open': _selectedPlotOpen ?? '',
        'age_of_property': _selectedAge ?? '',
        'water_connection': _selectedWaterConnection ?? '',
        'electric_price': _selectedElectricMeter ?? '',
        'electric_meter': _selectedElectricMeter ?? '',
        'plot_status': _selectedPlotStatus ?? '',
        'property_chain': _selectedPropertyChain ?? '',
        'current_location': _currentLocationController.text.trim(),
        'longitude': _longitudeController.text.trim(),
        'latitude': _latitudeController.text.trim(),
        'fieldworkar_name': _fieldworkerNameController.text.trim(),
        'fieldworkar_number': _fieldworkerNumberController.text.trim(),
        'property_rent': _selectedPropertyRent ?? '',
      }..removeWhere((_, v) => v.trim().isEmpty);

      request.fields.addAll(requiredFields);
      request.fields.addAll(optionalFields);

      if (_singleImage != null) {
        final multipartFile = await _createMultipartFile('single_image', _singleImage!.path);
        request.files.add(multipartFile);
      }

      for (final image in _selectedImages) {
        final multipartFile = await _createMultipartFile('images[]', image.path);
        request.files.add(multipartFile);
      }

      final streamedResponse = await request.send().timeout(const Duration(seconds: 45));
      final response = await http.Response.fromStream(streamedResponse);

      if (!mounted) return;
      _hideLoadingDialog();

      if (response.statusCode == 200) {
        _buildLocalPropertyData();
        await _saveFieldworkerNumber();
        if (mounted) {
          Navigator.pop(context); // close the form screen
          _showSnackBar('Property uploaded successfully!', Colors.green);
          _fetchPlotProperties();
        }
      } else {
        _showErrorDialog('Upload Failed (${response.statusCode})', response.body.isNotEmpty ? response.body : 'No response body');
      }
    } catch (e) {
      if (mounted) {
        _hideLoadingDialog();
        _showSnackBar('Error uploading: $e', Colors.red);
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
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
      if (image != null && mounted) setState(() => _singleImage = image);
    } catch (_) {}
  }

  Future<void> _pickMultipleImages() async {
    try {
      final images = await _imagePicker.pickMultiImage(
        maxWidth: 1200,
        maxHeight: 1200,
        imageQuality: 80,
      );
      if (images.isNotEmpty && mounted) setState(() => _selectedImages.addAll(images));
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
      if (image != null && mounted) setState(() => _singleImage = image);
    } catch (_) {}
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: 8.0);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: _primaryColor,
        title: Image.asset(AppImages.transparent,height: 40),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : _textColorConst),
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
                _buildLocationAndFieldworkerSection(isDark),
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
                  'Add Plot',
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
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    final int totalImages = (_singleImage != null ? 1 : 0) + _selectedImages.length;

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Property Images',
      icon: Icons.photo_library,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.transparent],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 10),
              if (totalImages > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _accentColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$totalImages images',
                    style: TextStyle(
                      color: _accentColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickSingleImage,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: _singleImage == null
                                  ? (isDark ? Colors.grey[600]! : Colors.grey.withOpacity(0.3))
                                  : _primaryColor,
                              width: _singleImage == null ? 1 : 2,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: _singleImage == null
                                ? (isDark ? const Color(0xFF2A2A2A) : Colors.grey.withOpacity(0.03))
                                : _primaryColor.withOpacity(0.02),
                          ),
                          child: _singleImage == null
                              ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.camera_alt_rounded,
                                  size: 24, color: isDark ? Colors.grey[500] : Colors.grey),
                              const SizedBox(height: 4),
                              Text(
                                'Cover Photo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          )
                              : Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(_singleImage!.path),
                                  width: double.infinity,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                bottom: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'Main',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: _pickMultipleImages,
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isDark ? Colors.grey[600]! : Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(10),
                            color: isDark ? const Color(0xFF2A2A2A) : Colors.grey.withOpacity(0.02),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.collections_rounded,
                                  size: 28, color: isDark ? Colors.grey[500] : Colors.grey.withOpacity(0.6)),
                              const SizedBox(height: 4),
                              Text(
                                _selectedImages.isEmpty ? 'Add More' : '+${_selectedImages.length}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDark ? Colors.grey[400] : Colors.grey,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              if (_selectedImages.isNotEmpty)
                                Text(
                                  'photos',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: isDark ? Colors.grey[500] : Colors.grey.withOpacity(0.6),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildImageActionButton(
                      icon: Icons.camera_alt_rounded,
                      label: 'Take Photo',
                      onTap: _takePhoto,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    _buildImageActionButton(
                      icon: Icons.photo_library_rounded,
                      label: 'From Gallery',
                      onTap: _pickMultipleImages,
                      isDark: isDark,
                    ),
                    const SizedBox(width: 8),
                    if (_selectedImages.isNotEmpty)
                      _buildImageActionButton(
                        icon: Icons.delete_outline_rounded,
                        label: 'Clear All',
                        onTap: _clearAllImages,
                        isDanger: true,
                        isDark: isDark,
                      ),
                  ],
                ),
                if (_selectedImages.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _selectedImages.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(right: 6),
                          width: 60,
                          height: 60,
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.file(
                                  File(_selectedImages[index].path),
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 2,
                                right: 2,
                                child: GestureDetector(
                                  onTap: () => _removeImage(index),
                                  child: Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close_rounded, size: 10, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
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
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Plot Size (Gaj)',
      icon: Icons.aspect_ratio,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1E3A5F), const Color(0xFF2D5B8F)]
                    : [const Color(0xFFE8F4FD), const Color(0xFFF0F9FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: _primaryColor, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Enter plot size in Gaj, it will be automatically converted to Sq Ft',
                    style: TextStyle(
                      color: _primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _CustomDropdown<String>(
            value: _selectedPlotSize,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Select Plot Size (Gaj)',
              icon: Icons.space_dashboard,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            items: _plotSizeOptions
                .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
                .toList(),
            onChanged: (v) => setState(() => _selectedPlotSize = v),
            validator: (v) => v == null || v.isEmpty ? 'Please select plot size' : null,
          ),
          if (_selectedPlotSize == 'Custom') ...[
            const SizedBox(height: 12),
            TextFormField(
              controller: _plotSizeController,
              decoration: _inputDecoration(
                isDark: isDark,
                label: 'Enter Custom Size (Gaj)',
                icon: Icons.edit,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              keyboardType: TextInputType.number,
              onChanged: (_) => setState(() {}),
              validator: (value) => _selectedPlotSize == 'Custom' && (value == null || value.isEmpty)
                  ? 'Please enter plot size'
                  : null,
            ),
          ],
          if (_currentPlotSizeValue != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]
                      : [const Color(0xFFE8F5E8), const Color(0xFFF0F9F0)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? Colors.green[700]! : Colors.green[100]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Size in Sq Ft:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.green[300] : Colors.green[800],
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '1 Gaj = 9 Sq Ft',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.green[200] : Colors.green[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.green[800] : Colors.green[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: isDark ? Colors.green[600]! : Colors.green[200]!),
                      ),
                      child: Text(
                        '$_convertedSqftValue sqft',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.green[100] : Colors.green[800],
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
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
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Plot Dimensions',
      icon: Icons.straighten,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 400) {
            return Column(
              children: [
                _buildDimensionField(
                  isDark: isDark,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  label: 'Front Size',
                  selectedValue: _selectedFrontSize,
                  options: _frontSizeOptions,
                  onChanged: (v) => setState(() => _selectedFrontSize = v),
                  controller: _frontSizeController,
                  validator: (v) => v == null || v.isEmpty ? 'Please select front size' : null,
                ),
                const SizedBox(height: 16),
                _buildDimensionField(
                  isDark: isDark,
                  textColor: textColor,
                  secondaryTextColor: secondaryTextColor,
                  label: 'Side Size',
                  selectedValue: _selectedSideSize,
                  options: _sideSizeOptions,
                  onChanged: (v) => setState(() => _selectedSideSize = v),
                  controller: _sideSizeController,
                  validator: (v) => v == null || v.isEmpty ? 'Please select side size' : null,
                ),
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                  child: _buildDimensionField(
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    label: 'Front Size',
                    selectedValue: _selectedFrontSize,
                    options: _frontSizeOptions,
                    onChanged: (v) => setState(() => _selectedFrontSize = v),
                    controller: _frontSizeController,
                    validator: (v) => v == null || v.isEmpty ? 'Please select front size' : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDimensionField(
                    isDark: isDark,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                    label: 'Side Size',
                    selectedValue: _selectedSideSize,
                    options: _sideSizeOptions,
                    onChanged: (v) => setState(() => _selectedSideSize = v),
                    controller: _sideSizeController,
                    validator: (v) => v == null || v.isEmpty ? 'Please select side size' : null,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDimensionField({
    required bool isDark,
    required Color textColor,
    required Color secondaryTextColor,
    required String label,
    required String? selectedValue,
    required List<String> options,
    required void Function(String? v) onChanged,
    required TextEditingController controller,
    required String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CustomDropdown<String>(
          value: selectedValue,
          decoration: _inputDecoration(
            isDark: isDark,
            label: label,
            icon: Icons.straighten,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
          items: options
              .map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: textColor, fontSize: 14))))
              .toList(),
          onChanged: onChanged,
          validator: validator,
        ),
        if (selectedValue == 'Custom') ...[
          const SizedBox(height: 12),
          TextFormField(
            controller: controller,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Custom ${label == 'Front Size' ? 'Front' : 'Side'} (ft)',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.number,
            validator: (value) => selectedValue == 'Custom' && (value == null || value.isEmpty)
                ? 'Please enter ${label.toLowerCase()} size'
                : null,
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
      title: 'Price & Addresses',
      icon: Icons.attach_money,
      child: Column(
        children: [
          TextFormField(
            controller: _plotPriceController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Enter Plot Price',
              icon: Icons.money,
              suffixText: 'INR',
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'Please enter plot price' : null,
          ),
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

  Widget _buildLocationAndFieldworkerSection(bool isDark) {
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : _textColorConst;
    final secondaryTextColor = isDark ? Colors.white70 : _textColorConst.withOpacity(0.6);

    return _sectionCard(
      isDark: isDark,
      cardColor: cardColor,
      title: 'Location & Fieldworker',
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
          const SizedBox(height: 12),
          TextFormField(
            controller: _fieldworkerNameController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Fieldworker Name',
              icon: Icons.person,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _fieldworkerNumberController,
            decoration: _inputDecoration(
              isDark: isDark,
              label: 'Fieldworker Number',
              icon: Icons.phone,
              textColor: textColor,
              secondaryTextColor: secondaryTextColor,
            ),
            keyboardType: TextInputType.phone,
            validator: (v) => v == null || v.trim().isEmpty ? 'Please enter fieldworker number' : null,
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
          onTap: _isUploading ? null : _uploadProperty,
          child: const Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, size: 22, color: Colors.white),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Submit Property Listing',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
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
      value: value,
      decoration: decoration,
      items: items,
      onChanged: onChanged,
      validator: validator,
      isExpanded: true,
    );
  }
}