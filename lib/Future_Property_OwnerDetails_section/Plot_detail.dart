import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/New_Update/Edit_plot_image.dart';
import 'New_Update/Edit_Plot.dart';

class PlotPropertyData {
  final int id;
  final String plotSize;
  final String plotFrontSize;
  final String plotSideSize;
  final String roadSize;
  final String plotOpen;
  final String ageOfProperty;
  final String waterConnection;
  final String electricPrice;
  final String plotPrice;
  final String plotStatus;
  final String propertyChain;
  final String fieldAddress;
  final String mainAddress;
  final String currentLocation;
  final String longitude;
  final String latitude;
  final String fieldworkarName;
  final String fieldworkarNumber;
  final String propertyRent;
  final String Description;

  // 🔹 Upload ke liye
  final XFile? singleImage;
  final List<XFile> selectedImages;

  // 🔹 Display ke liye
  final String? singleImageUrl;
  final List<String> imageUrls;

  PlotPropertyData({
    required this.id,
    required this.plotSize,
    required this.plotFrontSize,
    required this.plotSideSize,
    required this.roadSize,
    required this.plotOpen,
    required this.ageOfProperty,
    required this.waterConnection,
    required this.electricPrice,
    required this.plotPrice,
    required this.plotStatus,
    required this.propertyChain,
    required this.fieldAddress,
    required this.mainAddress,
    required this.currentLocation,
    required this.longitude,
    required this.latitude,
    required this.fieldworkarName,
    required this.fieldworkarNumber,
    required this.propertyRent,
    required this.Description,
    this.singleImage,
    this.selectedImages = const [],
    this.singleImageUrl,
    this.imageUrls = const [],
  });

  // ================= FROM JSON (FETCH) =================

  factory PlotPropertyData.fromJson(Map<String, dynamic> json) {
    const baseUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/";

    return PlotPropertyData(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,

      plotSize: json['plot_size']?.toString() ?? '',
      plotFrontSize: json['plot_front_size']?.toString() ?? '',
      plotSideSize: json['plot_side_size']?.toString() ?? '',
      roadSize: json['road_size']?.toString() ?? '',
      plotOpen: json['plot_open']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      waterConnection: json['water_connection']?.toString() ?? '',
      electricPrice: json['electric_price']?.toString() ?? '',
      plotPrice: json['plot_price']?.toString() ?? '',
      plotStatus: json['plot_status']?.toString() ?? '',
      propertyChain: json['property_chain']?.toString() ?? '',
      fieldAddress: json['field_address']?.toString() ?? '',
      mainAddress: json['main_address']?.toString() ?? '',
      currentLocation: json['current_location']?.toString() ?? '',
      longitude: json['longitude']?.toString() ?? '',
      latitude: json['latitude']?.toString() ?? '',
      fieldworkarName: json['fieldworkar_name']?.toString() ?? '',
      fieldworkarNumber: json['fieldworkar_number']?.toString() ?? '',
      propertyRent: json['property_rent']?.toString() ?? '',
      Description: json['Description']?.toString() ?? '',

      // ✅ Single Image
      singleImageUrl: json['single_image'] != null &&
          json['single_image']
              .toString()
              .isNotEmpty
          ? baseUrl + json['single_image']
          : null,

      // ✅ Multiple Images
      imageUrls: json['images'] == null
          ? []
          : json['images'] is List
          ? (json['images'] as List)
          .where((e) =>
      e != null && e
          .toString()
          .isNotEmpty)
          .map((e) => baseUrl + e.toString().trim())
          .toList()
          : json['images']
          .toString()
          .isNotEmpty
          ? json['images']
          .toString()
          .split(RegExp(r'[;,]'))
          .where((e) => e.isNotEmpty)
          .map((e) => baseUrl + e.trim())
          .toList()
          : [],
    );
  }

        // ================= TO MAP (OPTIONAL) =================

  Map<String, String> toFieldsMap() {
    return {
      'plot_size': plotSize,
      'plot_front_size': plotFrontSize,
      'plot_side_size': plotSideSize,
      'road_size': roadSize,
      'plot_open': plotOpen,
      'age_of_property': ageOfProperty,
      'water_connection': waterConnection,
      'electric_price': electricPrice,
      'plot_price': plotPrice,
      'plot_status': plotStatus,
      'property_chain': propertyChain,
      'field_address': fieldAddress,
      'main_address': mainAddress,
      'current_location': currentLocation,
      'longitude': longitude,
      'latitude': latitude,
      'fieldworkar_name': fieldworkarName,
      'fieldworkar_number': fieldworkarNumber,
      'property_rent': propertyRent,
      'Description': Description,
    };
  }
}

// ------------------ SERVICE ------------------
class PropertyService {
  static const String _host = 'verifyserve.social';
  static const String _path =
      'Second PHP FILE/main_realestate/plot_form_show_api_for_feildworkar.php';

  static Future<List<PlotPropertyData>> fetchPlotsForFieldworker(
      String fieldworkarNumber) async {
    final clean = fieldworkarNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) {
      throw Exception('Fieldworker number is empty');
    }

    // Safe URI: spaces in "Second PHP FILE" will be %20 encoded automatically
    final uri = Uri.https(
      _host,
      _path,
      {'fieldworkar_number': clean}, // <-- correct param name
    );

    late http.Response resp;
    try {
      resp = await http
          .get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        },
      )
          .timeout(const Duration(seconds: 20));
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on HttpException catch (e) {
      throw Exception('HTTP exception: $e');
    }

    if (resp.statusCode != 200) {
      final body = resp.body;
      final preview = body.substring(0, body.length < 400 ? body.length : 400);
      throw Exception('Server error ${resp.statusCode}. URL: $uri\n$preview');
    }

    Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = json.decode(resp.body.trim()) as Map<String, dynamic>;
    } catch (e) {
      final body = resp.body;
      final preview = body.substring(0, body.length < 400 ? body.length : 400);
      throw Exception('Invalid JSON from server. URL: $uri\nError: $e\nBody (first 400): $preview');
    }

    if (jsonResponse['success'] != true) {
      final msg = (jsonResponse['message'] ?? 'Unknown server message').toString();
      throw Exception('API success=false. Message: $msg');
    }

    final data = jsonResponse['data'];
    if (data is! List) {
      throw Exception('API returned unexpected shape for "data".');
    }

    return data
        .map<PlotPropertyData>(
            (e) => PlotPropertyData.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

// ------------------ DISPLAY PAGE ------------------
class PlotPropertyDisplayPage extends StatefulWidget {
  final PlotPropertyData? propertyData;
  final String? fieldworkarNumber;

  const PlotPropertyDisplayPage({
    Key? key,
    this.propertyData,
    this.fieldworkarNumber,
  }) : super(key: key);

  @override
  State<PlotPropertyDisplayPage> createState() =>
      _PlotPropertyDisplayPageState();
}

class _PlotPropertyDisplayPageState
    extends State<PlotPropertyDisplayPage> {

  List<String> _multipleImages = [];
  bool _isImageLoading = true;
  bool _isExpanded = false;
  bool isExpandedDesc = false;

  PlotPropertyData? _currentData;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _currentData = widget.propertyData;
    _fetchMultipleImages();
  }


  Future<void> _fetchMultipleImages() async {
    if (_currentData == null || _currentData!.id == 0) {
      setState(() {
        _isImageLoading = false;
      });
      return;
    }

    final url =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_plot_multiple_image.php?sub_id=${_currentData!.id}";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData['success'] == true) {

          List imagesData = jsonData['data'] ?? [];

          List<String> images = imagesData.map<String>((e) {
            return "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${e['p_image']}";
          }).toList();

          setState(() {
            _multipleImages = images;
            _isImageLoading = false;
          });

        } else {
          setState(() {
            _isImageLoading = false;
          });
        }
      } else {
        setState(() {
          _isImageLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isImageLoading = false;
      });
    }
  }

  Future<void> _refreshProperty() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final data = await PropertyService.fetchPlotsForFieldworker(
        _currentData!.fieldworkarNumber,
      );

      final updated = data.firstWhere(
            (e) => e.id == _currentData!.id,
        orElse: () => _currentData!,
      );

      setState(() {
        _currentData = updated;
        _isLoading = false;
      });

      _fetchMultipleImages();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<String> get _allImages {
    final imgs = <String>[];

    if (_currentData!.singleImageUrl != null &&
        _currentData!.singleImageUrl!.isNotEmpty) {
      imgs.add(_currentData!.singleImageUrl!);
    }

    imgs.addAll(_multipleImages); // ⭐ IMPORTANT FIX
    return imgs;
  }

  void _showSingleImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.contain,
                  errorWidget: (_, __, ___) => Icon(
                    Icons.broken_image,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  openMap() async {
    final lat = _currentData!.latitude;
    final lng = _currentData!.longitude;
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    await launchUrl(Uri.parse(url));
  }

  openWhatsapp() async {
    final phone = _currentData!.fieldworkarNumber;
    await launchUrl(Uri.parse("https://wa.me/$phone"));
  }

  String maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String first = number.substring(0, 3);
    String last = number.substring(number.length - 4);
    return "$first****$last";
  }

  /// ⭐ FIXED FULLSCREEN GALLERY
  openGallery(List<String> allImages, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: PhotoViewGallery.builder(
            itemCount: allImages.length,
            pageController: PageController(initialPage: index),
            builder: (context, i) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(allImages[i]), // ⭐ fix
              );
            },
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final horizontalPadding =
    isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding =
    isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight =
        screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight =
        screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale =
    isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);

    if (_currentData == null) {
      return const Scaffold(
        body: Center(child: Text("No Data")),
      );
    }
    final images = _allImages;


    Widget buildResponsiveInfoGrid(
        List<Widget> infoRows) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          if (screenWidth > 350) {
            final half = (infoRows.length / 2).ceil();
            final leftColumn = infoRows.sublist(0, half);
            final rightColumn =
            infoRows.length > half ? infoRows.sublist(half) : <Widget>[];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: leftColumn,
                  ),
                ),
                SizedBox(
                    width:
                    MediaQuery.of(context).size.width < 360
                        ? 8.0
                        : 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: rightColumn,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: infoRows,
            );
          }
        },
      );
    }

    Widget buildInfoRow(IconData icon, Color iconColor, String title,
        String value) {
      if (value.isEmpty || value == "null" || value == "0") {
        return const SizedBox.shrink();
      }

      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;

      final Color cardColor = Colors.white;
      final Color borderColor =
      isDarkMode ? Colors.grey.shade700.withOpacity(0.2) : Colors.grey.shade200;
      final Color titleColor =
      isDarkMode ? Colors.black87 : Colors.grey.shade700;
      final Color valueColor = isDarkMode ? Colors.black87 : Colors.black87;
      final Color iconBg = iconColor.withOpacity(0.10);

      return Container(
        margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
        padding: EdgeInsets.symmetric(
            horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: isDarkMode
              ? [const BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon,
                  size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
            ),
            SizedBox(width: isSmallScreen ? 6.0 : 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 11.0,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11.0 : 12.0,
                      fontWeight: FontWeight.w500,
                      color: valueColor,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    void showCallConfirmationDialog(
        String role, String name, String number) {
      bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Call $role',
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black)),
          content: Text(
              'Do you really want to call ${name.isNotEmpty ? name : role}?',
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black)),
          backgroundColor:
          isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No',
                  style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                await FlutterPhoneDirectCaller.callNumber(number);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    Widget buildContactCard(String role, String name, String number,
        {Color? bgColor}) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      Color cardColor = bgColor ?? Colors.blue;
      String maskedNumber = maskPhoneNumber(number);

      return Container(
        margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cardColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: isSmallScreen ? 32.0 : 36.0,
                    height: isSmallScreen ? 32.0 : 36.0,
                    decoration: BoxDecoration(
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      role == "OWNER"
                          ? Icons.person
                          : role == "CARETAKER"
                          ? Icons.support_agent
                          : role == "FIELD WORKER"
                          ? Icons.engineering
                          : role == "TENANT"
                          ? Icons.people
                          : Icons.person,
                      color: Colors.white,
                      size: isSmallScreen ? 16.0 : 18.0,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10.0 : 11.0,
                            fontWeight: FontWeight.w600,
                            color: cardColor,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                        Text(
                          name.isNotEmpty ? name : "Not Available",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13.0 : 14.0,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.black : Colors.black87,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 6.0 : 8.0),
              if (number.isNotEmpty)
                GestureDetector(
                  onTap: () =>
                      showCallConfirmationDialog(role, name, number),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: isSmallScreen ? 6.0 : 8.0),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: cardColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            maskedNumber,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18.0 : 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => openWhatsapp(),
                              child: Icon(PhosphorIcons.whatsapp_logo_bold,
                                  color: Colors.green,
                                  size: isSmallScreen ? 20.0 : 24.0),
                            ),
                            SizedBox(
                                width: isSmallScreen ? 12.0 : 16.0),
                            Icon(Icons.call,
                                color: cardColor,
                                size: isSmallScreen ? 20.0 : 24.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: isSmallScreen ? 6.0 : 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      "Not Available",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11.0 : 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    Future<void> openMap() async {
      final lat = double.tryParse(_currentData!.latitude);
      final lng = double.tryParse(_currentData!.longitude);

      if (lat == null || lng == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid location")),
        );
        return;
      }

      final Uri mapUrl =
      Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

      if (!await launchUrl(
        mapUrl,
        mode: LaunchMode.externalApplication,
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open map")),
        );
      }
    }

    Widget buildLocationCard(String currentLocation) {
      final mapUrlText =
          "https://maps.google.com/?q=${_currentData!.latitude},${_currentData!.longitude}";

      final lat = double.tryParse(_currentData!.latitude);
      final lng = double.tryParse(_currentData!.longitude);
      final bool hasMap = lat != null && lng != null && lat != 0 && lng != 0;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.location_on, color: Colors.white),
            ),
            const SizedBox(width: 10),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CURRENT LOCATION",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),

                  /// ⭐ URL LINK
                  GestureDetector(
                    onTap: openMap,
                    child: Text(
                      mapUrlText,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationThickness: 2, // ⭐ better underline
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.link,
              size: 16,
              color: hasMap ? Colors.black : Colors.grey,
            )
          ],
        ),
      );
    }


    Widget buildDescriptionCard(String desc) {
      if (desc.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "DESCRIPTION",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// ⭐ DESCRIPTION TEXT
            Text(
              desc,
              maxLines: isExpandedDesc ? null : 2, // ⭐ IMPORTANT
              overflow: isExpandedDesc
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis, // ⭐ IMPORTANT
              style: const TextStyle(color: Colors.black87),
            ),

            /// ⭐ READ MORE BUTTON
            if (desc.length > 80)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpandedDesc = !isExpandedDesc;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    isExpandedDesc ? "Read less" : "Read more",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget buildAmenitiesCard(List<String> amenities) {
      if (amenities.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, // ⭐ ALWAYS WHITE
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "AMENITIES",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // ⭐ FIX
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// ⭐ CHIPS
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: amenities
                  .map(
                    (e) => Chip(
                  label: Text(
                    e.trim(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),// ⭐ FIX
                  ),
                  backgroundColor: Colors.green.withOpacity(0.1), // ⭐ FIX
                  side: BorderSide(color: Colors.green.withOpacity(0.3)),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      );
    }

    Widget buildContactSection() {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.contact_phone, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "CONTACT",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // ⭐ FIX
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            buildContactCard(
              "FIELD WORKER",
              _currentData!.fieldworkarName,
              _currentData!.fieldworkarNumber,
              bgColor: Colors.blue,
            ),
          ],
        ),
      );
    }

    Widget buildTwoColumnInfo(List<Widget> rows)  {
      final half = (rows.length / 2).ceil();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Column(children: rows.sublist(0, half))),
            const SizedBox(width: 10),
            Expanded(child: Column(children: rows.sublist(half))),
          ],
        ),
      );
    }

    final infoRows = [
      buildInfoRow(Icons.square_foot, Colors.teal, "Plot Size", _currentData!.plotSize),
      buildInfoRow(Icons.open_with, Colors.indigo, "Front Size", _currentData!.plotFrontSize),
      buildInfoRow(Icons.swap_horiz, Colors.indigo, "Side Size", _currentData!.plotSideSize),
      buildInfoRow(Icons.alt_route, Colors.brown, "Road Size", _currentData!.roadSize),
      buildInfoRow(Icons.water_drop, Colors.blue, "Water Connection", _currentData!.waterConnection),
      buildInfoRow(Icons.wb_sunny, Colors.orange, "Plot Open", _currentData!.plotOpen),
      buildInfoRow(Icons.electric_bolt, Colors.purple, "Electric", _currentData!.electricPrice),
      buildInfoRow(Icons.calendar_today, Colors.black54, "Age Of Property", _currentData!.ageOfProperty),
      buildInfoRow(Icons.scatter_plot, Colors.black54, "Plot Status", _currentData!.plotStatus),
    ];

    String formatIndianPrice(String price) {
      if (price.isEmpty) return "";

      final num? value = num.tryParse(price.replaceAll(",", ""));
      if (value == null) return price;

      if (value >= 10000000) {
        return "${(value / 10000000).toStringAsFixed(2)} Cr";
      } else if (value >= 100000) {
        return "${(value / 100000).toStringAsFixed(2)} Lakh";
      } else if (value >= 1000) {
        return "${(value / 1000).toStringAsFixed(2)} K";
      } else {
        return value.toString();
      }
    }

    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: RefreshIndicator(
          onRefresh: _refreshProperty, // ⭐ refresh function
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // ⭐ IMPORTANTSingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                if (_currentData!.singleImageUrl != null && _currentData!.singleImageUrl!.isNotEmpty)
                  GestureDetector(
                    onTap: () => _showSingleImage(_currentData!.singleImageUrl!),
                    child: CachedNetworkImage(
                      imageUrl: "${_currentData!.singleImageUrl}?v=${DateTime.now().millisecondsSinceEpoch}",
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) {
                        print("BROKEN HEADER IMAGE => ${_currentData!.singleImageUrl}");
                        return Container(
                          height: 260,
                          color: Colors.grey,
                          child: Icon(Icons.image_not_supported),
                        );
                      },
                    ),
                  ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: CircleAvatar(
                    radius: isSmallScreen ? 20 : 22,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: Colors.white,
                        size: isSmallScreen ? 22 : 24,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),

                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 16,
                  child: CircleAvatar(
                    radius: isSmallScreen ? 20 : 22,
                    backgroundColor: Colors.black.withOpacity(0.6),
                    child: PopupMenuButton<String>(
                      padding: EdgeInsets.zero,
                      splashRadius: 22,
                      offset: const Offset(0, 45),
                      icon: Icon(
                        Icons.more_vert,
                        color: Colors.white,
                        size: isSmallScreen ? 22 : 24,
                      ),
                      onSelected: (value) async {
                        if (value == 'Edit Plot') {
                          if (_currentData != null) {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditPlotform(
                                  propertyId: _currentData!.id,
                                  propertyData: _currentData!,
                                ),
                              ),
                            );
                            if (result == true) await _refreshProperty();
                          }
                        }

                        if (value == 'Add Plot Images') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditPlotImage(
                                sub_id: _currentData!.id.toString(),
                              ),
                            ),
                          ).then((value) async {
                            if (value == true) await _refreshProperty();
                          });
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'Edit Plot', child: Text('Edit Plot')),
                        PopupMenuItem(value: 'Add Plot Images', child: Text('Add Plot Images')),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _currentData!.propertyRent ?? "",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                  "₹ ${formatIndianPrice(_currentData!.plotPrice)}",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  SizedBox(height: 4),
                  Text(_currentData!.currentLocation, style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),

            /// ⭐ MULTIPLE IMAGE GALLERY
        if (_multipleImages.isEmpty)
          const Text("No Images Found")
        else
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _multipleImages.length,
              itemBuilder: (context, i) {
                return GestureDetector(
                  onTap: () => openGallery(
                    _allImages,
                    i + (_currentData!.singleImageUrl != null ? 1 : 0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: CachedNetworkImage(
                      imageUrl:
                      "${_multipleImages[i]}?v=${DateTime.now().millisecondsSinceEpoch}",
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
            const SizedBox(height: 20),

            buildTwoColumnInfo(infoRows),

            buildDescriptionCard(_currentData!.Description),

            buildLocationCard(_currentData!.currentLocation),

            buildContactSection(),

            const SizedBox(height: 20),

        ]),
      ),
        ),
    );
  }
}
