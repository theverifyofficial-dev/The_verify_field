import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/constant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Commercial_detail.dart';

class EditCommercialForm extends StatefulWidget {
  final int propertyId;
  final  CommercialPropertyData propertyData;

  const EditCommercialForm({
    super.key,
    required this.propertyId,
    required this.propertyData,

  });

  @override
  _EditCommercialFormState createState() => _EditCommercialFormState();
}

class _EditCommercialFormState extends State<EditCommercialForm> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();

  String? _selectedlisting_type;
  String? _selectedPropertyType;
  String? _selectedParkingType;
  String? _selectedWarehouseType;
  String? _selecteddimmensions;
  String? _selectedTotalFloors;

  TextEditingController _locationController = TextEditingController();
  TextEditingController _availableFromController = TextEditingController();
  TextEditingController _builtupAreaController = TextEditingController();
  TextEditingController _carpetAreaController = TextEditingController();
  TextEditingController _sellingHeightController = TextEditingController();
  TextEditingController _sellingWidthController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _DescriptionController = TextEditingController();

  List<String> _selectedAmenities = [];

  // Image variables
  XFile? _singleImage;

  // Location variables
  bool _isGettingLocation = false;
  String _currentAddress = '';
  double? _latitude;
  double? _longitude;
  String? _existingImage;
  bool _isImageDeleted = false;

  // Dropdown options
  List<String> listingTypes = ['Rent', 'Sell'];
  List<String> propertyTypes = [
    'Office',
    'Retail Shop',
    'Showroom',
    'Plot',
    'Warehouse',
    'Other'
  ];
  List<String> parkingTypes = ['Public', 'Private', 'Both', 'None'];
  List<String> warehouseTypes = [
    'Small (<1000 sq ft)',
    'Medium (1000-5000 sq ft)',
    'Large (5000-10000 sq ft)',
    'Very Large (>10000 sq ft)'
  ];
  List<String> rentMeterTypes = [
    'Per Sq Ft/Month',
    'Per Sq Ft/Year',
    'Total Monthly Rent',
    'Total Yearly Rent'
  ];
  List<String> totalFloors = ['Ground', '1', '2', '3', '4', '5', '6+'];
  List<String> amenities = [
    'Water Storage',
    'Power Backup',
    'Security',
    'Parking',
    'Lift',
    'Air Conditioning',
    'Fire Safety',
    'Internet Ready'
  ];


  @override
  void initState() {
    super.initState();

    /// ⭐ IMAGE
    final img = widget.propertyData.image_;
    if (img != null && img.trim().isNotEmpty) {
      _existingImage = img.trim();
    }
    /// ⭐ AUTOFILL DATA (IMPORTANT — OUTSIDE IF)
    _selectedlisting_type = widget.propertyData.listing_type;
    _selectedPropertyType = widget.propertyData.property_type;
    _selectedParkingType = widget.propertyData.parking_faciltiy;
    _selectedTotalFloors = widget.propertyData.total_floor;
    _locationController.text = widget.propertyData.location_;
    _availableFromController.text = widget.propertyData.avaible_date;
    _builtupAreaController.text = widget.propertyData.build_up_area;
    _carpetAreaController.text = widget.propertyData.carpet_area;
    _sellingHeightController.text = widget.propertyData.height_;
    _sellingWidthController.text = widget.propertyData.width_;
    _priceController.text = widget.propertyData.price;
    _DescriptionController.text = widget.propertyData.Description;
    _selectedAmenities = widget.propertyData.amenites_;
    _latitude = double.tryParse(widget.propertyData.latitude);
    _longitude = double.tryParse(widget.propertyData.longitude);
    _currentAddress = widget.propertyData.current_location;

    print("EDIT DATA => ${widget.propertyData.toMap()}");
  }

  // Premium Color Scheme
  final Color primaryColor = Color(0xFF2D5BFF);
  final Color secondaryColor = Color(0xFF6C63FF);
  final Color accentColor = Color(0xFF00D4AA);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    final Color backgroundColor = isDarkMode ? Color(0xFF121212) : Color(
        0xFFF8FAFF);
    final Color cardColor = isDarkMode ? Colors.white12 : Colors.white;
    final Color textColor = isDarkMode ? Colors.white : Color(0xFF2D3748);
    final Color secondaryTextColor = isDarkMode ? Colors.white70 : Color(
        0xFF2D3748).withOpacity(0.6);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title:Image.asset(AppImages.transparent,height: 40,),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPremiumHeader(isDarkMode),
                SizedBox(height: 32),
                _buildImageUploadSection(isDarkMode, cardColor, textColor),
                SizedBox(height: 20),
                _buildpriceSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildListingTypeSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildLocationSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildPropertyTypeSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildAvailableFromSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildAreaSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildDimensionsSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildFloorAndParkingSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildWarehouseSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 20),
                _buildAmenitiesSection(isDarkMode, cardColor, textColor),
                SizedBox(height: 20),
                _buildDescriptionSection(
                    isDarkMode, cardColor, textColor, secondaryTextColor),
                SizedBox(height: 40),
                _buildPremiumSubmitButton(),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Location Details', Icons.location_on_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: _locationController,
                  style: TextStyle(
                      color: textColor, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    labelText: 'Property Location',
                    labelStyle: TextStyle(color: secondaryTextColor),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: isDarkMode ? Colors.grey[600]! : Colors.grey
                              .withOpacity(0.2)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: primaryColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: isDarkMode ? Colors.grey[600]! : Colors.grey
                              .withOpacity(0.2)),
                    ),
                    prefixIcon: Icon(Icons.map_rounded, color: primaryColor),
                    hintText: 'Enter complete address',
                    hintStyle: TextStyle(color: secondaryTextColor),
                    suffixIcon: _isGettingLocation
                        ? Container(
                      width: 20,
                      height: 20,
                      padding: EdgeInsets.all(2),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    )
                        : IconButton(
                      icon: Icon(
                          Icons.my_location_rounded, color: primaryColor),
                      onPressed: _getCurrentLocation,
                    ),
                    filled: true,
                    fillColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                  ),
                  maxLines: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12),
                if (_currentAddress.isNotEmpty || _latitude != null) ...[
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(isDarkMode ? 0.2 : 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: accentColor.withOpacity(
                          isDarkMode ? 0.4 : 0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle_rounded, size: 16,
                            color: accentColor),
                        SizedBox(width: 8),
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
                                ),
                              if (_latitude != null && _longitude != null)
                                Text(
                                  'Lat: ${_latitude!.toStringAsFixed(
                                      6)}, Lng: ${_longitude!.toStringAsFixed(
                                      6)}',
                                  style: TextStyle(
                                    color: accentColor.withOpacity(0.9),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                          child: Icon(Icons.close_rounded, size: 16,
                              color: accentColor),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8),
                ],
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(isDarkMode ? 0.2 : 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 14,
                          color: Colors.blue),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tap the location icon to automatically detect your current address',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
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

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 20),
      );

      setState(() {
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      try {
        List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
        );

        if (placemarks.isNotEmpty) {
          Placemark placemark = placemarks.first;
          String address = [
            placemark.street,
            placemark.subLocality,
            placemark.locality,
            placemark.administrativeArea,
            placemark.postalCode,
            placemark.country
          ].where((part) => part != null && part!.isNotEmpty).join(', ');

          setState(() {
            _locationController.text = address;
            _currentAddress = address;
            _isGettingLocation = false;
          });
          _showSuccessSnackbar('Location detected successfully!');
        } else {
          setState(() {
            _locationController.text =
            '${position.latitude.toStringAsFixed(6)}, ${position.longitude
                .toStringAsFixed(6)}';
            _currentAddress =
            'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position
                .longitude.toStringAsFixed(6)}';
            _isGettingLocation = false;
          });
          _showSuccessSnackbar('Location detected (coordinates).');
        }
      } catch (geocodingError) {
        setState(() {
          _locationController.text =
          '${position.latitude.toStringAsFixed(6)}, ${position.longitude
              .toStringAsFixed(6)}';
          _currentAddress =
          'Lat: ${position.latitude.toStringAsFixed(6)}, Lng: ${position
              .longitude.toStringAsFixed(6)}';
          _isGettingLocation = false;
        });
        print('Geocoding error: $geocodingError');
        _showSuccessSnackbar('Location detected (coordinates).');
      }
    } catch (e) {
      print('Error getting location: $e');
      setState(() {
        _isGettingLocation = false;
      });
      _showErrorDialog(
          'Failed to get location. Please check GPS, permissions, and internet.');
    }
  }

  void _deleteImage() {
    setState(() {
      _singleImage = null;
      _existingImage = null;
      _isImageDeleted = true;
    });
  }
  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Camera"),
              onTap: () {
                Navigator.pop(context);
                _takePhoto();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text("Gallery"),
              onTap: () {
                Navigator.pop(context);
                _pickSingleImage();
              },
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildImagePreview() {
    if (_singleImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.file(File(_singleImage!.path), fit: BoxFit.cover),
      );
    }

    if (_existingImage != null &&
        _existingImage!.isNotEmpty &&
        !_isImageDeleted) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:Image.network(
          _existingImage!,
          fit: BoxFit.cover,
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Center(child: CircularProgressIndicator());
          },
          errorBuilder: (_, __, ___) {
            print("BROKEN IMAGE => $_existingImage");
            return Icon(Icons.broken_image);
          },
        )
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt, size: 28),
          SizedBox(height: 4),
          Text("Add Cover Photo"),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection(bool isDarkMode, Color cardColor, Color textColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: _buildSectionHeader('Property Images', Icons.photo, textColor),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showImagePickerSheet,
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryColor, width: 1.5),
                    ),
                    child: _buildImagePreview(),
                  ),
                ),

                if (_singleImage != null || _existingImage != null)
                  Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Row(
                      children: [
                        _buildImageActionButton(
                          icon: Icons.camera_alt,
                          label: "Camera",
                          onTap: _takePhoto,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(width: 8),
                        _buildImageActionButton(
                          icon: Icons.photo,
                          label: "Gallery",
                          onTap: _pickSingleImage,
                          isDarkMode: isDarkMode,
                        ),
                        SizedBox(width: 8),
                        _buildImageActionButton(
                          icon: Icons.delete,
                          label: "Delete",
                          isDanger: true,
                          onTap: _deleteImage,
                          isDarkMode: isDarkMode,
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 16),
              ],
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
    required bool isDarkMode,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isDanger
                ? Colors.red.withOpacity(isDarkMode ? 0.2 : 0.05)
                : primaryColor.withOpacity(isDarkMode ? 0.2 : 0.05),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isDanger
                  ? Colors.red.withOpacity(isDarkMode ? 0.4 : 0.2)
                  : primaryColor.withOpacity(isDarkMode ? 0.4 : 0.2),
            ),
          ),
          child: Column(
            children: [
              Icon(icon,
                  size: 16,
                  color: isDanger ? Colors.red : primaryColor),
              SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDanger ? Colors.red : primaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Description', Icons.description_sharp, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: _DescriptionController,
                  maxLines: 3,
                  style: TextStyle(color: textColor),
                  decoration: _buildInputDecoration(
                    isDarkMode: isDarkMode,
                    label: 'Description',
                    icon: Icons.description,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPremiumHeader(bool isDarkMode) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 25,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
                Icons.business_center_rounded, size: 32, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Commercial Property',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'List your premium commercial space',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    letterSpacing: 0.3,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                    height: 2,
                    width: 198,
                    decoration: BoxDecoration(
                        color: Colors.amber[400],
                        borderRadius: BorderRadius.circular(2)
                    )
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(
      {required bool isDarkMode, required Color cardColor, required Widget child}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color textColor) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
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
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required bool isDarkMode,
    required String label,
    required IconData icon,
    required Color textColor,
    required Color secondaryTextColor,
    String? suffixText,
  }) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: secondaryTextColor),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey.withOpacity(
                0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
            color: isDarkMode ? Colors.grey[600]! : Colors.grey.withOpacity(
                0.2)),
      ),
      prefixIcon: Icon(icon, color: primaryColor),
      suffixText: suffixText,
      filled: true,
      fillColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
    );
  }

  Future<void> _pickSingleImage() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _singleImage = image;
        _existingImage = null;
        _isImageDeleted = false;
      });
    }
  }

  Future<void> _takePhoto() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _singleImage = image;
        _existingImage = null;
        _isImageDeleted = false;
      });
    }
  }

  String formatIndianAmount(String value) {
    if (value.isEmpty) return '';

    double amount = double.tryParse(value.replaceAll(',', '')) ?? 0;

    if (amount >= 10000000) {
      return "${(amount / 10000000).toStringAsFixed(2)} Cr";
    } else if (amount >= 100000) {
      return "${(amount / 100000).toStringAsFixed(2)} Lakh";
    } else if (amount >= 1000) {
      return "${(amount / 1000).toStringAsFixed(2)} K";
    } else {
      return amount.toStringAsFixed(0);
    }
  }


  Widget _buildpriceSection(bool isDarkMode,
      Color cardColor,
      Color textColor,
      Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Pricing Details', Icons.currency_rupee_rounded, textColor),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor, fontWeight: FontWeight.w500),

                  onChanged: (val){
                    setState(() {}); // live update
                  },

                  decoration: _buildInputDecoration(
                    isDarkMode: isDarkMode,
                    label: 'Price',
                    icon: Icons.currency_rupee_rounded,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor,
                  ).copyWith(
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Center(
                        widthFactor: 1,
                        child: Text(
                          formatIndianAmount(_priceController.text),
                          style: TextStyle(
                            color: Colors.green, // 🔥 GREEN COLOR
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter price';
                    }
                    return null;
                  },
                ),


                SizedBox(height: 16),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }


  Widget _buildListingTypeSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Listing Type', Icons.sell_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDarkMode ? Colors.grey[600]! : Colors.grey
                        .withOpacity(0.2)),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedlisting_type,
                decoration: InputDecoration(
                  labelText: 'Rent or Sell?',
                  labelStyle: TextStyle(color: secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  prefixIcon: Icon(
                      Icons.business_center_rounded, color: primaryColor),
                  filled: true,
                  fillColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                ),
                dropdownColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                items: listingTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: textColor)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedlisting_type = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select listing type';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPropertyTypeSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Property Type', Icons.category_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDarkMode ? Colors.grey[600]! : Colors.grey
                        .withOpacity(0.2)),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedPropertyType,
                decoration: InputDecoration(
                  labelText: 'Type of Property',
                  labelStyle: TextStyle(color: secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  prefixIcon: Icon(
                      Icons.real_estate_agent_rounded, color: primaryColor),
                  filled: true,
                  fillColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                ),
                dropdownColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                items: propertyTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: textColor)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPropertyType = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select property type';
                  }
                  return null;
                },
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAvailableFromSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Availability', Icons.calendar_month_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: TextFormField(
              controller: _availableFromController,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              decoration: _buildInputDecoration(
                isDarkMode: isDarkMode,
                label: 'Available From Date',
                icon: Icons.date_range_rounded,
                textColor: textColor,
                secondaryTextColor: secondaryTextColor,
              ),
              readOnly: true,
              onTap: () {
                _selectAvailableFromDate();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select available date';
                }
                return null;
              },
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAreaSection(bool isDarkMode, Color cardColor, Color textColor,
      Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Area Details', Icons.aspect_ratio_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _builtupAreaController,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500),
                    decoration: _buildInputDecoration(
                      isDarkMode: isDarkMode,
                      label: 'Built-up Area',
                      icon: Icons.square_foot_rounded,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      suffixText: 'sq ft',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _carpetAreaController,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500),
                    decoration: _buildInputDecoration(
                      isDarkMode: isDarkMode,
                      label: 'Carpet Area',
                      icon: Icons.carpenter_rounded,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      suffixText: 'sq ft',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDimensionsSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Dimensions', Icons.straighten_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _sellingHeightController,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500),
                    decoration: _buildInputDecoration(
                      isDarkMode: isDarkMode,
                      label: 'Height',
                      icon: Icons.height_rounded,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      suffixText: 'ft',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _sellingWidthController,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500),
                    decoration: _buildInputDecoration(
                      isDarkMode: isDarkMode,
                      label: 'Width',
                      icon: Icons.width_full_rounded,
                      textColor: textColor,
                      secondaryTextColor: secondaryTextColor,
                      suffixText: 'ft',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFloorAndParkingSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Building Details', Icons.layers_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDarkMode ? Colors.grey[600]! : Colors.grey
                            .withOpacity(0.2)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedTotalFloors,
                    decoration: InputDecoration(
                      labelText: 'Total Floors',
                      labelStyle: TextStyle(color: secondaryTextColor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      prefixIcon: Icon(
                          Icons.stairs_rounded, color: primaryColor),
                      filled: true,
                      fillColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                    ),
                    dropdownColor: isDarkMode ? Color(0xFF1E1E1E) : Colors
                        .white,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500),
                    items: totalFloors.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTotalFloors = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: isDarkMode ? Colors.grey[600]! : Colors.grey
                            .withOpacity(0.2)),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedParkingType,
                    decoration: InputDecoration(
                      labelText: 'Parking Facility',
                      labelStyle: TextStyle(color: secondaryTextColor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      prefixIcon: Icon(
                          Icons.local_parking_rounded, color: primaryColor),
                      filled: true,
                      fillColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                    ),
                    dropdownColor: isDarkMode ? Color(0xFF1E1E1E) : Colors
                        .white,
                    style: TextStyle(
                        color: textColor, fontWeight: FontWeight.w500),
                    items: parkingTypes.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(color: textColor)),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedParkingType = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildWarehouseSection(bool isDarkMode, Color cardColor,
      Color textColor, Color secondaryTextColor) {
    if (_selectedPropertyType != 'Warehouse') return SizedBox();

    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Warehouse Details', Icons.warehouse_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isDarkMode ? Colors.grey[600]! : Colors.grey
                        .withOpacity(0.2)),
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedWarehouseType,
                decoration: InputDecoration(
                  labelText: 'Warehouse Size Category',
                  labelStyle: TextStyle(color: secondaryTextColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  prefixIcon: Icon(
                      Icons.space_dashboard_rounded, color: primaryColor),
                  filled: true,
                  fillColor: isDarkMode ? Color(0xFF2A2A2A) : Colors.white,
                ),
                dropdownColor: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
                items: warehouseTypes.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(color: textColor)),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedWarehouseType = newValue;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(bool isDarkMode, Color cardColor,
      Color textColor) {
    return _buildPremiumCard(
      isDarkMode: isDarkMode,
      cardColor: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
              'Amenities', Icons.emoji_transportation_rounded, textColor),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select available amenities:',
                  style: TextStyle(
                    color: textColor.withOpacity(0.8),
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: amenities.map((amenity) {
                    bool isSelected = _selectedAmenities.contains(amenity);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            _selectedAmenities.remove(amenity);
                          } else {
                            _selectedAmenities.add(amenity);
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor.withOpacity(
                              isDarkMode ? 0.2 : 0.1) : (isDarkMode ? Colors
                              .grey[800]! : Colors.grey.withOpacity(0.1)),
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(
                            color: isSelected ? primaryColor : (isDarkMode
                                ? Colors.grey[600]!
                                : Colors.grey.withOpacity(0.3)),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isSelected ? Icons.check_circle_rounded : Icons
                                  .radio_button_unchecked_rounded,
                              size: 16,
                              color: isSelected ? primaryColor : (isDarkMode
                                  ? Colors.grey[400]!
                                  : Colors.grey),
                            ),
                            SizedBox(width: 6),
                            Text(
                              amenity,
                              style: TextStyle(
                                color: isSelected ? primaryColor : textColor
                                    .withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildPremiumSubmitButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor, secondaryColor],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: () async {
            if (_formKey.currentState!.validate()) {
              await _submitForm();
            }
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                    Icons.touch_app, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Text(
                  'Update Commercial ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectAvailableFromDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        final bool isDarkMode = Theme
            .of(context)
            .brightness == Brightness.dark;
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              surface: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              onSurface: isDarkMode ? Colors.white : Colors.black,
            ),
            dialogBackgroundColor: isDarkMode ? Color(0xFF1E1E1E) : Colors
                .white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _availableFromController.text =
            DateFormat('MMMM dd, yyyy').format(picked);
      });
    }
  }

  // UPDATED SUBMIT FORM METHOD
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final prefs = await SharedPreferences.getInstance();
    final savedName = prefs.getString('name') ?? '';
    final savedNumber = prefs.getString('number') ?? '';

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      var uri = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/update_api_commercial.php");

      var request = http.MultipartRequest("POST", uri);

      // 🔥 ID (IMPORTANT)
      request.fields['id'] = widget.propertyId.toString();

      // 🔥 TEXT FIELDS
      request.fields['listing_type'] = _selectedlisting_type ?? '';
      request.fields['location_'] = _locationController.text;
      request.fields['current_location'] =
      _currentAddress.isEmpty ? _locationController.text : _currentAddress;
      request.fields['property_type'] = _selectedPropertyType ?? '';
      request.fields['avaible_date'] = _availableFromController.text;
      request.fields['build_up_area'] = _builtupAreaController.text;
      request.fields['carpet_area'] = _carpetAreaController.text;
      request.fields['dimmensions_'] =
      "${_sellingHeightController.text}x${_sellingWidthController.text}";
      request.fields['height_'] = _sellingHeightController.text;
      request.fields['width_'] = _sellingWidthController.text;
      request.fields['total_floor'] = _selectedTotalFloors ?? '';
      request.fields['parking_faciltiy'] = _selectedParkingType ?? '';
      request.fields['amenites_'] = _selectedAmenities.join(",");
      request.fields['field_workar_name'] = savedName;
      request.fields['field_workar_number'] = savedNumber;
      request.fields['longitude'] = _longitude?.toString() ?? '';
      request.fields['latitude'] = _latitude?.toString() ?? '';
      request.fields['Description'] = _DescriptionController.text;
      request.fields['price'] = _priceController.text;

      // 🔥 IMAGE (optional update)
      if (_singleImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image_',
          _singleImage!.path,
          filename: _singleImage!.name,
        ));
      }

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      Navigator.of(context, rootNavigator: true).pop();

      var data = jsonDecode(respStr);

      if (response.statusCode == 200 && data['status'] == 'success') {
        _showSuccessSnackbar("Property updated successfully");
        Navigator.pop(context, true);
      } else {
        _showErrorDialog(data['message'] ?? "Update failed");
      }
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
      _showErrorDialog("Update error: $e");
    }
  }


  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: accentColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showErrorDialog(String message) {
    final bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDarkMode ? Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 50, color: Colors.red),
                SizedBox(height: 16),
                Text(
                  'Error',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Color(0xFF2D3748),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Color(0xFF2D3748)
                        .withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetForm() {
    _formKey.currentState!.reset();
    setState(() {
      _selectedlisting_type = null;
      _selectedPropertyType = null;
      _selectedParkingType = null;
      _selectedWarehouseType = null;
      _selectedTotalFloors = null;
      _selectedAmenities.clear();
      _locationController.clear();
      _availableFromController.clear();
      _builtupAreaController.clear();
      _carpetAreaController.clear();
      _sellingHeightController.clear();
      _sellingWidthController.clear();
      _singleImage = null;
      _currentAddress = '';
      _latitude = null;
      _longitude = null;
      _priceController.clear();
      _DescriptionController.clear();
    });
  }

  @override
  void dispose() {
    _locationController.dispose();
    _availableFromController.dispose();
    _builtupAreaController.dispose();
    _carpetAreaController.dispose();
    _sellingHeightController.dispose();
    _sellingWidthController.dispose();
    _priceController.dispose();
    _DescriptionController.dispose();
    super.dispose();
  }
}