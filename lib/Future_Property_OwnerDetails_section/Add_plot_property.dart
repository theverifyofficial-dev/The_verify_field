import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'plot_detail.dart'; // ✅ Display screen + model

class PropertyListingPage extends StatefulWidget {
  @override
  _PropertyListingPageState createState() => _PropertyListingPageState();
}

class _PropertyListingPageState extends State<PropertyListingPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  // Controllers
  final TextEditingController customPlotSizeController = TextEditingController();
  final TextEditingController customFrontSizeController = TextEditingController();
  final TextEditingController customSideSizeController = TextEditingController();
  final TextEditingController customRoadSizeController = TextEditingController();
  final TextEditingController plotPriceController = TextEditingController();
  final TextEditingController fieldAddressController = TextEditingController();
  final TextEditingController mainAddressController = TextEditingController();

  // Location + fieldworker
  final TextEditingController currentLocationController = TextEditingController();
  final TextEditingController longitudeController = TextEditingController();
  final TextEditingController latitudeController = TextEditingController();
  final TextEditingController fieldworkerNameController = TextEditingController();
  final TextEditingController fieldworkerNumberController = TextEditingController();

  // Dropdown values
  String? selectedPlotSize;
  String? selectedFrontSize;
  String? selectedSideSize;
  String? selectedRoadSize;
  String? selectedAge;
  String? selectedPlotStatus;
  String? selectedPropertyChain;
  String? selectedPropertyRent;
  String? selectedPlotOpen;
  String? selectedWaterConnection;
  String? selectedElectricMeter;

  // Images
  List<XFile> _selectedImages = [];
  XFile? _singleImage;

  // Options
  final List<double> plotSizeValuesInGaj = [50,100,150,200,250,300,350,400,450,500];
  final List<String> frontSizeOptions = ['20 ft','25 ft','30 ft','35 ft','40 ft','45 ft','50 ft','60 ft','70 ft','80 ft','Custom'];
  final List<String> sideSizeOptions  = ['20 ft','25 ft','30 ft','35 ft','40 ft','45 ft','50 ft','60 ft','70 ft','80 ft','Custom'];
  final List<String> roadSizeOptions  = ['10 ft','15 ft','20 ft','25 ft','30 ft','35 ft','40 ft','50 ft','60 ft','80 ft','100 ft','Custom'];
  final List<String> ageOptions = ['1 year','2 years','3 years','4 years','5 years'];
  final List<String> plotStatusOptions = ['Register','GPA','Lal Dara','Power of Attorney','Loan'];
  final List<String> propertyChainOptions = ['Yes','No'];
  final List<String> propertyRentOptions = ['Available for Rent','Not for Rent'];
  final List<String> plotOpenOptions = ['1 Side','2 Side','3 Side','4 Side'];
  final List<String> yesNoOptions = ['Yes','No'];

  bool _isGettingLocation = false;

  // Theme colors
  final Color primaryColor = const Color(0xFF2D5BFF);
  final Color secondaryColor = const Color(0xFF6C63FF);
  final Color accentColor = const Color(0xFF00D4AA);
  final Color textColorConst = const Color(0xFF2D3748);

  // Conversion
  double get _conversionFactor => 9.0;
  double _convertGajToSqft(double gaj) => gaj * _conversionFactor;

  List<String> get plotSizeOptions => plotSizeValuesInGaj.map((v) => '${v.toStringAsFixed(0)} gaj').toList()..add('Custom');

  String? get _currentPlotSizeValue {
    if (selectedPlotSize == 'Custom' && customPlotSizeController.text.isNotEmpty) {
      return customPlotSizeController.text;
    } else if (selectedPlotSize != null && selectedPlotSize != 'Custom') {
      return selectedPlotSize!.split(' ').first;
    }
    return null;
  }

  String get _convertedSqftValue {
    if (_currentPlotSizeValue != null) {
      final gaj = double.tryParse(_currentPlotSizeValue!) ?? 0;
      return _convertGajToSqft(gaj).toStringAsFixed(0);
    }
    return '0';
  }

  // ✅ Correct upload endpoint (space-encoded folder)
  final String apiUrl = "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/plot_add_api.php";

  // Location
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permanently denied. Enable from settings.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentLocation() async {
    final ok = await _handleLocationPermission();
    if (!ok) return;
    setState(() => _isGettingLocation = true);
    try {
      final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      final placemarks = await placemarkFromCoordinates(pos.latitude, pos.longitude);
      final p = placemarks.first;
      final address = [
        p.street, p.locality, p.administrativeArea, p.country
      ].where((e) => (e ?? '').toString().trim().isNotEmpty).join(', ');

      setState(() {
        latitudeController.text = pos.latitude.toStringAsFixed(6);
        longitudeController.text = pos.longitude.toStringAsFixed(6);
        currentLocationController.text = address;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: const Text('Location fetched successfully'), backgroundColor: accentColor));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not get location: $e'), backgroundColor: Colors.red));
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  // (Optional) after add
  Future<void> _fetchPlotProperties() async {
    try { await http.get(Uri.parse('https://your-api.com/plots')); } catch (_) {}
  }

  // Build local model for instant display
  PlotPropertyData _buildLocalPropertyData() {
    String onlyNum(String s) => s.replaceAll(RegExp(r'[^0-9.]'), '');

    return PlotPropertyData(
      plotSize: (_currentPlotSizeValue ?? ''),
      plotPrice: plotPriceController.text.trim(),
      fieldAddress: fieldAddressController.text.trim(),
      mainAddress: mainAddressController.text.trim(),
      plotFrontSize: onlyNum(selectedFrontSize == 'Custom' ? customFrontSizeController.text : (selectedFrontSize ?? '')),
      plotSideSize:  onlyNum(selectedSideSize  == 'Custom' ? customSideSizeController.text  : (selectedSideSize  ?? '')),
      roadSize:      onlyNum(selectedRoadSize  == 'Custom' ? customRoadSizeController.text  : (selectedRoadSize  ?? '')),
      plotOpen: selectedPlotOpen ?? '',
      ageOfProperty: selectedAge ?? '',
      waterConnection: selectedWaterConnection ?? '',
      electricPrice: selectedElectricMeter ?? '',
      plotStatus: selectedPlotStatus ?? '',
      propertyChain: selectedPropertyChain ?? '',
      currentLocation: currentLocationController.text.trim(),
      longitude: longitudeController.text.trim(),
      latitude: latitudeController.text.trim(),
      fieldworkarName: fieldworkerNameController.text.trim(),   // model uses "workar"
      fieldworkarNumber: fieldworkerNumberController.text.trim(),
      propertyRent: selectedPropertyRent ?? '',
      singleImage: _singleImage,
      selectedImages: List<XFile>.from(_selectedImages),
    );
  }

  // Upload
  Future<void> uploadProperty() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields'), backgroundColor: Colors.red));
      return;
    }
    if (_singleImage == null && _selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please add at least one image (main or additional).')));
      return;
    }

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent, elevation: 0,
        content: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(primaryColor)),
              const SizedBox(height: 16),
              Text('Uploading Property...', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : textColorConst)),
            ]),
          ),
        ),
      ),
    );

    try {
      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);

      String stripUnits(String? s) => (s ?? '').replaceAll(RegExp(r'[^0-9.]'), '').trim();

      final String plotFront = (selectedFrontSize == 'Custom' ? customFrontSizeController.text : (selectedFrontSize ?? '')).trim();
      final String plotSide  = (selectedSideSize  == 'Custom' ? customSideSizeController.text  : (selectedSideSize  ?? '')).trim();
      final String roadSize  = (selectedRoadSize  == 'Custom' ? customRoadSizeController.text  : (selectedRoadSize  ?? '')).trim();

      final String plotOpen = selectedPlotOpen ?? '';
      final String ageProp = selectedAge ?? '';
      final String waterConn = selectedWaterConnection ?? '';
      final String electricYN = selectedElectricMeter ?? '';
      final String plotStatus = selectedPlotStatus ?? '';
      final String propertyChain = selectedPropertyChain ?? '';
      final String propertyRent = selectedPropertyRent ?? '';

      String plotSizeValue = (selectedPlotSize == 'Custom') ? customPlotSizeController.text.trim() : (selectedPlotSize?.split(' ').first ?? '');
      final String plotPriceValue = plotPriceController.text.trim();

      final String fieldAddress = fieldAddressController.text.trim();
      final String mainAddress  = mainAddressController.text.trim();

      final String currentLocation = currentLocationController.text.trim();
      final String longitude = longitudeController.text.trim();
      final String latitude  = latitudeController.text.trim();
      final String fieldworkerName = fieldworkerNameController.text.trim();
      final String fieldworkerNumber = fieldworkerNumberController.text.trim();

      // Required
      final Map<String, String> requiredFields = {
        'plot_size': stripUnits(plotSizeValue),
        'plot_price': stripUnits(plotPriceValue),
        'field_address': fieldAddress,
        'main_address': mainAddress,
      };

      // Optional (match server spelling: fieldworkar_*)
      final Map<String, String> optionalFields = {
        'plot_front_size': stripUnits(plotFront),
        'plot_side_size': stripUnits(plotSide),
        'road_size': stripUnits(roadSize),
        'plot_open': plotOpen,
        'age_of_property': ageProp,
        'water_connection': waterConn,
        // send both variants for safety:
        'electric_price': electricYN,
        'electric_meter': electricYN,
        'plot_status': plotStatus,
        'property_chain': propertyChain,
        'current_location': currentLocation,
        'longitude': longitude,
        'latitude': latitude,
        'fieldworkar_name': fieldworkerName,
        'fieldworkar_number': fieldworkerNumber,
        'property_rent': propertyRent,
      };
      optionalFields.removeWhere((k, v) => v.trim().isEmpty);

      request.fields.addAll(requiredFields);
      request.fields.addAll(optionalFields);

      // single image
      if (_singleImage != null && _singleImage!.path.isNotEmpty) {
        final filePath = _singleImage!.path;
        final filename = path.basename(filePath);
        final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
        final parts = mimeType.split('/');
        final multipart = await http.MultipartFile.fromPath(
          'single_image', filePath,
          filename: filename,
          contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'octet-stream'),
        );
        request.files.add(multipart);
      }

      // multiple images
      if (_selectedImages.isNotEmpty) {
        for (final f in _selectedImages) {
          if (f.path.isEmpty) continue;
          final filePath = f.path;
          final filename = path.basename(filePath);
          final mimeType = lookupMimeType(filePath) ?? 'application/octet-stream';
          final parts = mimeType.split('/');
          final multipart = await http.MultipartFile.fromPath(
            'images[]', filePath,
            filename: filename,
            contentType: MediaType(parts[0], parts.length > 1 ? parts[1] : 'octet-stream'),
          );
          request.files.add(multipart);
        }
      }

      final streamed = await request.send().timeout(const Duration(seconds: 30));
      final resp = await http.Response.fromStream(streamed);

      // close loader
      try { if (mounted) Navigator.of(context).pop(); } catch (_) {}
      if (resp.statusCode == 200) {
        final localData = _buildLocalPropertyData();

        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('number', fieldworkerNumberController.text.trim());
        } catch (_) {}

        // ✅ Close dialog and go back (don’t open new page)
        if (mounted) {
          Navigator.pop(context); // closes the current form screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Property uploaded successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }

        await _fetchPlotProperties(); // optional refresh if you're showing list
      } else {
        final raw = resp.body;
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('Upload Failed (${resp.statusCode})', style: const TextStyle(color: Colors.red)),
            content: SingleChildScrollView(child: Text(raw.isNotEmpty ? raw : 'No response body')),
            actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
          ),
        );
      }

    } catch (e) {
      try { if (mounted) Navigator.of(context).pop(); } catch (_) {}
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error uploading: $e'), backgroundColor: Colors.red));
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF8FAFF);
    final card = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final text = isDark ? Colors.white : textColorConst;
    final text2 = isDark ? Colors.white70 : textColorConst.withOpacity(0.6);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: const Text('List Property', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        elevation: 0, centerTitle: true,
        iconTheme: IconThemeData(color: isDark ? Colors.white : text),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _buildHeader(isDark),
            const SizedBox(height: 24),
            _buildImageUploadSection(isDark, card, text),
            const SizedBox(height: 20),
            _buildPlotSizeSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildDimensionsSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildRoadAndOpenSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildAgeSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildUtilitiesSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildPriceAndAddressSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildLocationAndFieldworkerSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildPlotStatusSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildPropertyChainSection(isDark, card, text, text2),
            const SizedBox(height: 20),
            _buildPropertyRentSection(isDark, card, text, text2),
            const SizedBox(height: 30),
            _buildSubmitButton(),
          ]),
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.real_estate_agent, size: 28, color: Colors.white),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('List Your Property', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5)),
              SizedBox(height: 4),
              Text('Fill all details to showcase your property', style: TextStyle(fontSize: 14, color: Colors.white70)),
            ]),
          ),
        ]),
        const SizedBox(height: 16),
        Container(height: 4, width: 60, decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(2))),
      ]),
    );
  }

  Widget _buildImageUploadSection(bool isDark, Color cardColor, Color textColor) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: cardColor, title: 'Property Images', icon: Icons.photo_library,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Main Image', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickSingleImage,
          child: Container(
            width: double.infinity, height: 160,
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? Colors.grey[600]! : Colors.grey[300]!, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: _singleImage == null
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.add_photo_alternate, size: 48, color: isDark ? Colors.grey[500] : Colors.grey[400]),
              const SizedBox(height: 12),
              Text('Tap to add main image', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500)),
            ])
                : ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(children: [
                Image.file(File(_singleImage!.path), width: double.infinity, height: 160, fit: BoxFit.cover),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                )
              ]),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Additional Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _pickMultipleImages,
          child: Container(
            width: double.infinity, padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: isDark ? Colors.grey[600]! : Colors.grey[300]!, width: 2),
              borderRadius: BorderRadius.circular(12),
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 2))],
            ),
            child: Column(children: [
              Icon(Icons.photo_library, size: 42, color: isDark ? Colors.grey[500] : Colors.grey[400]),
              const SizedBox(height: 12),
              Text('Tap to add multiple images', style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600], fontWeight: FontWeight.w500)),
              if (_selectedImages.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(20)),
                  child: Text('${_selectedImages.length} images selected', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                )
              ]
            ]),
          ),
        ),
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text('Selected Images:', style: TextStyle(fontWeight: FontWeight.w600, color: textColor)),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) => Container(
                margin: const EdgeInsets.only(right: 12),
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? Colors.grey[600]! : Colors.grey[300]!),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Stack(children: [
                    Image.file(File(_selectedImages[index].path), width: 100, height: 100, fit: BoxFit.cover),
                    Positioned(
                      top: 4, right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(12)),
                        child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),
        ],
      ]),
    );
  }

  Widget _buildPlotSizeSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Plot Size (Gaj)', icon: Icons.aspect_ratio,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: isDark ? [const Color(0xFF1E3A5F), const Color(0xFF2D5B8F)] : [const Color(0xFFE8F4FD), const Color(0xFFF0F9FF)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: primaryColor.withOpacity(0.3)),
          ),
          child: Row(children: [
            Icon(Icons.info_outline, color: primaryColor, size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text('Enter plot size in Gaj, it will be automatically converted to Sq Ft', style: TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.w500))),
          ]),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedPlotSize,
          decoration: _inputDec(isDarkMode: isDark, label: 'Select Plot Size (Gaj)', icon: Icons.space_dashboard, textColor: text, secondaryTextColor: text2),
          items: plotSizeOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(fontSize: 15, color: text)))).toList(),
          onChanged: (v) => setState(() => selectedPlotSize = v),
          validator: (v) => v == null || v.isEmpty ? 'Please select plot size' : null,
        ),
        if (selectedPlotSize == 'Custom') ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: customPlotSizeController,
            decoration: _inputDec(isDarkMode: isDark, label: 'Enter Custom Size (Gaj)', icon: Icons.edit, textColor: text, secondaryTextColor: text2),
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            validator: (value) => selectedPlotSize == 'Custom' && (value == null || value.isEmpty) ? 'Please enter plot size' : null,
          ),
        ],
        if (_currentPlotSizeValue != null) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: isDark ? [const Color(0xFF1B5E20), const Color(0xFF2E7D32)] : [const Color(0xFFE8F5E8), const Color(0xFFF0F9F0)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.green[700]! : Colors.green[100]!),
            ),
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Size in Sq Ft:', style: TextStyle(fontWeight: FontWeight.w600, color: isDark ? Colors.green[300] : Colors.green[800], fontSize: 15)),
                const SizedBox(height: 6),
                Text('1 Gaj = 9 Sq Ft', style: TextStyle(fontSize: 13, color: isDark ? Colors.green[200] : Colors.green[600])),
              ]),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: isDark ? Colors.green[800] : Colors.green[50], borderRadius: BorderRadius.circular(20), border: Border.all(color: isDark ? Colors.green[600]! : Colors.green[200]!)),
                child: Text('${_convertedSqftValue} sqft', style: TextStyle(fontWeight: FontWeight.bold, color: isDark ? Colors.green[100] : Colors.green[800], fontSize: 16)),
              ),
            ]),
          ),
        ],
      ]),
    );
  }

  Widget _buildDimensionsSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Plot Dimensions', icon: Icons.straighten,
      child: Column(children: [
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DropdownButtonFormField<String>(
              value: selectedFrontSize,
              decoration: _inputDec(isDarkMode: isDark, label: 'Front Size', icon: Icons.width_wide, textColor: text, secondaryTextColor: text2),
              items: frontSizeOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
              onChanged: (v) => setState(() => selectedFrontSize = v),
            ),
            if (selectedFrontSize == 'Custom') const SizedBox(height: 12),
            if (selectedFrontSize == 'Custom')
              TextFormField(controller: customFrontSizeController, decoration: _inputDec(isDarkMode: isDark, label: 'Custom Front (ft)', textColor: text, secondaryTextColor: text2), keyboardType: TextInputType.number),
          ])),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DropdownButtonFormField<String>(
              value: selectedSideSize,
              decoration: _inputDec(isDarkMode: isDark, label: 'Side Size', icon: Icons.height, textColor: text, secondaryTextColor: text2),
              items: sideSizeOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
              onChanged: (v) => setState(() => selectedSideSize = v),
            ),
            if (selectedSideSize == 'Custom') const SizedBox(height: 12),
            if (selectedSideSize == 'Custom')
              TextFormField(controller: customSideSizeController, decoration: _inputDec(isDarkMode: isDark, label: 'Custom Side (ft)', textColor: text, secondaryTextColor: text2), keyboardType: TextInputType.number),
          ])),
        ])
      ]),
    );
  }

  Widget _buildRoadAndOpenSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Road & Plot Open', icon: Icons.aod,
      child: Column(children: [
        DropdownButtonFormField<String>(
          value: selectedRoadSize,
          decoration: _inputDec(isDarkMode: isDark, label: 'Road Size', icon: Icons.aod, textColor: text, secondaryTextColor: text2),
          items: roadSizeOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
          onChanged: (v) => setState(() => selectedRoadSize = v),
          validator: (v) => v == null || v.isEmpty ? 'Please select road size' : null,
        ),
        if (selectedRoadSize == 'Custom') const SizedBox(height: 16),
        if (selectedRoadSize == 'Custom')
          TextFormField(
            controller: customRoadSizeController,
            decoration: _inputDec(isDarkMode: isDark, label: 'Enter Custom Road Size (ft)', icon: Icons.edit, textColor: text, secondaryTextColor: text2),
            keyboardType: TextInputType.number,
            validator: (v) => selectedRoadSize == 'Custom' && (v == null || v.isEmpty) ? 'Please enter road size' : null,
          ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedPlotOpen,
          decoration: _inputDec(isDarkMode: isDark, label: 'Plot Open Sides', icon: Icons.open_in_full, textColor: text, secondaryTextColor: text2),
          items: plotOpenOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
          onChanged: (v) => setState(() => selectedPlotOpen = v),
          validator: (v) => v == null || v.isEmpty ? 'Please select plot open sides' : null,
        ),
      ]),
    );
  }

  Widget _buildAgeSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Age of Property', icon: Icons.calendar_today,
      child: DropdownButtonFormField<String>(
        value: selectedAge,
        decoration: _inputDec(isDarkMode: isDark, label: 'Select Property Age', icon: Icons.timelapse, textColor: text, secondaryTextColor: text2),
        items: ageOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
        onChanged: (v) => setState(() => selectedAge = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select property age' : null,
      ),
    );
  }

  Widget _buildUtilitiesSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Utilities', icon: Icons.build,
      child: Column(children: [
        DropdownButtonFormField<String>(
          value: selectedWaterConnection,
          decoration: _inputDec(isDarkMode: isDark, label: 'Water Connection', icon: Icons.water_drop, textColor: text, secondaryTextColor: text2),
          items: yesNoOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
          onChanged: (v) => setState(() => selectedWaterConnection = v),
          validator: (v) => v == null || v.isEmpty ? 'Please select water connection' : null,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedElectricMeter,
          decoration: _inputDec(isDarkMode: isDark, label: 'Electric Meter', icon: Icons.electrical_services, textColor: text, secondaryTextColor: text2),
          items: yesNoOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
          onChanged: (v) => setState(() => selectedElectricMeter = v),
          validator: (v) => v == null || v.isEmpty ? 'Please select electric meter' : null,
        ),
      ]),
    );
  }

  Widget _buildPriceAndAddressSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Price & Addresses', icon: Icons.attach_money,
      child: Column(children: [
        TextFormField(
          controller: plotPriceController,
          decoration: _inputDec(isDarkMode: isDark, label: 'Enter Plot Price', icon: Icons.money, suffixText: 'INR', textColor: text, secondaryTextColor: text2),
          keyboardType: TextInputType.number,
          validator: (v) => v == null || v.isEmpty ? 'Please enter plot price' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: fieldAddressController,
          decoration: _inputDec(isDarkMode: isDark, label: 'Field Address (where visited)', icon: Icons.location_on, textColor: text, secondaryTextColor: text2),
          keyboardType: TextInputType.streetAddress,
          validator: (v) => v == null || v.isEmpty ? 'Please enter field address' : null,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: mainAddressController,
          decoration: _inputDec(isDarkMode: isDark, label: 'Main Address / Property address', icon: Icons.home, textColor: text, secondaryTextColor: text2),
          keyboardType: TextInputType.streetAddress,
          validator: (v) => v == null || v.isEmpty ? 'Please enter main address' : null,
        ),
      ]),
    );
  }

  Widget _buildLocationAndFieldworkerSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Location & Fieldworker', icon: Icons.my_location,
      child: Column(children: [
        Row(children: [
          Expanded(
            child: TextFormField(
              controller: currentLocationController,
              decoration: _inputDec(isDarkMode: isDark, label: 'Current Location', icon: Icons.place, textColor: text, secondaryTextColor: text2),
              readOnly: true, maxLines: 2,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: _isGettingLocation ? null : _getCurrentLocation,
              style: ElevatedButton.styleFrom(backgroundColor: primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), padding: const EdgeInsets.symmetric(horizontal: 16)),
              child: _isGettingLocation
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
                  : const Icon(Icons.my_location, color: Colors.white),
            ),
          ),
        ]),
        const SizedBox(height: 12),
        TextFormField(
          controller: fieldworkerNameController,
          decoration: _inputDec(isDarkMode: isDark, label: 'Fieldworker Name', icon: Icons.person, textColor: text, secondaryTextColor: text2),
          keyboardType: TextInputType.text,
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: fieldworkerNumberController,
          decoration: _inputDec(isDarkMode: isDark, label: 'Fieldworker Number', icon: Icons.phone, textColor: text, secondaryTextColor: text2),
          keyboardType: TextInputType.phone,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'Please enter fieldworker number' : null,
        ),
      ]),
    );
  }

  Widget _buildPlotStatusSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Plot Status', icon: Icons.description,
      child: DropdownButtonFormField<String>(
        value: selectedPlotStatus,
        decoration: _inputDec(isDarkMode: isDark, label: 'Select Plot Status', icon: Icons.assignment, textColor: text, secondaryTextColor: text2),
        items: plotStatusOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
        onChanged: (v) => setState(() => selectedPlotStatus = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select plot status' : null,
      ),
    );
  }

  Widget _buildPropertyChainSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Property Chain', icon: Icons.link,
      child: DropdownButtonFormField<String>(
        value: selectedPropertyChain,
        decoration: _inputDec(isDarkMode: isDark, label: 'Property Chain Available?', icon: Icons.chair, textColor: text, secondaryTextColor: text2),
        items: propertyChainOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
        onChanged: (v) => setState(() => selectedPropertyChain = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select property chain' : null,
      ),
    );
  }

  Widget _buildPropertyRentSection(bool isDark, Color card, Color text, Color text2) {
    return _sectionCard(
      isDarkMode: isDark, cardColor: card, title: 'Property Rent', icon: Icons.business_center,
      child: DropdownButtonFormField<String>(
        value: selectedPropertyRent,
        decoration: _inputDec(isDarkMode: isDark, label: 'Rent Availability', icon: Icons.bento, textColor: text, secondaryTextColor: text2),
        items: propertyRentOptions.map((v) => DropdownMenuItem(value: v, child: Text(v, style: TextStyle(color: text)))).toList(),
        onChanged: (v) => setState(() => selectedPropertyRent = v),
        validator: (v) => v == null || v.isEmpty ? 'Please select rent option' : null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity, height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [primaryColor, secondaryColor], begin: Alignment.centerLeft, end: Alignment.centerRight),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: primaryColor.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              await uploadProperty();

            } else {
              ScaffoldMessenger.of(context).
              showSnackBar(const SnackBar(
                  content: Text('Please fill all required fields'),
                  backgroundColor: Colors.red));
            }
          },
          child: const Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.check_circle, size: 22, color: Colors.white),
              SizedBox(width: 12),
              Text('Submit Property Listing', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Colors.white)),
            ]),
          ),
        ),
      ),
    );
  }

  // Shared UI
  Widget _sectionCard({required bool isDarkMode, required Color cardColor, required String title, required IconData icon, required Widget child}) {
    return Container(
      width: double.infinity, margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor, borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: primaryColor, size: 20),
            ),
            const SizedBox(width: 12),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: isDarkMode ? Colors.white : textColorConst)),
          ]),
          const SizedBox(height: 16),
          child,
        ]),
      ),
    );
  }

  InputDecoration _inputDec({required bool isDarkMode, required String label, IconData? icon, String? suffixText, required Color textColor, required Color secondaryTextColor}) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: secondaryTextColor),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: isDarkMode ? Colors.grey[600]! : Colors.grey[400]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: primaryColor, width: 2)),
      prefixIcon: icon != null ? Icon(icon, color: secondaryTextColor) : null,
      suffixText: suffixText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      filled: true,
      fillColor: isDarkMode ? const Color(0xFF2A2A2A) : Colors.white,
    );
  }

  // Image pickers
  Future<void> _pickSingleImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery, maxWidth: 1200, maxHeight: 1200, imageQuality: 80);
      if (image != null) setState(() => _singleImage = image);
    } catch (_) {}
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(maxWidth: 1200, maxHeight: 1200, imageQuality: 80);
      if (images.isNotEmpty) setState(() => _selectedImages.addAll(images));
    } catch (_) {}
  }

  @override
  void dispose() {
    customPlotSizeController.dispose();
    customFrontSizeController.dispose();
    customSideSizeController.dispose();
    customRoadSizeController.dispose();
    plotPriceController.dispose();
    fieldAddressController.dispose();
    mainAddressController.dispose();
    currentLocationController.dispose();
    longitudeController.dispose();
    latitudeController.dispose();
    fieldworkerNameController.dispose();
    fieldworkerNumberController.dispose();
    super.dispose();
  }
}
