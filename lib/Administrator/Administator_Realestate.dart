import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';
import '../Home_Screen_click/Add_RealEstate.dart';
import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_Assign_Tenant_Demand/See_All_Realestate.dart';
import 'Administater_Realestate_Details.dart';

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
  final String? sourceId; // NEW, nullable

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
    this.sourceId, // NEW
  });

  static String _s(dynamic v) => v?.toString() ?? '';
  static int _i(dynamic v) => int.tryParse(v?.toString() ?? '') ?? 0;

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: _i(json['P_id']),
      propertyPhoto: _s(json['property_photo']),
      locations: _s(json['locations']),
      flatNumber: _s(json['Flat_number']),
      buyRent: _s(json['Buy_Rent']),
      residenceCommercial: _s(json['Residence_Commercial']),
      apartmentName: _s(json['Apartment_name']),
      apartmentAddress: _s(json['Apartment_Address']),
      typeofProperty: _s(json['Typeofproperty']),
      bhk: _s(json['Bhk']),
      showPrice: _s(json['show_Price']),
      lastPrice: _s(json['Last_Price']),
      askingPrice: _s(json['asking_price']),
      floor: _s(json['Floor_']),
      totalFloor: _s(json['Total_floor']),
      balcony: _s(json['Balcony']),
      squarefit: _s(json['squarefit']),
      maintenance: _s(json['maintance']),
      parking: _s(json['parking']),
      ageOfProperty: _s(json['age_of_property']),
      fieldWorkerAddress: _s(json['fieldworkar_address']),
      roadSize: _s(json['Road_Size']),
      metroDistance: _s(json['metro_distance']),
      highwayDistance: _s(json['highway_distance']),
      mainMarketDistance: _s(json['main_market_distance']),
      meter: _s(json['meter']),
      ownerName: _s(json['owner_name']),
      ownerNumber: _s(json['owner_number']),
      currentDate: _s(json['current_dates']),
      // your API sometimes sends ISO datetime; we keep it as raw string
      availableDate: _s(json['available_date']),
      kitchen: _s(json['kitchen']),
      bathroom: _s(json['bathroom']),
      lift: _s(json['lift']),
      facility: _s(json['Facility']),
      furnishing: _s(json['furnished_unfurnished']),
      fieldWorkerName: _s(json['field_warkar_name']),
      liveUnlive: _s(json['live_unlive']),
      fieldWorkerNumber: _s(json['field_workar_number']),
      registryAndGpa: _s(json['registry_and_gpa']),
      loan: _s(json['loan']),
      fieldWorkerCurrentLocation: _s(json['field_worker_current_location']),
      caretakerName: _s(json['care_taker_name']),
      caretakerNumber: _s(json['care_taker_number']),
      longitude: _s(json['Longitude']),
      latitude: _s(json['Latitude']),
      videoLink: _s(json['video_link']),
      subid: _i(json['subid']),
      sourceId: json['source_id']?.toString(), // NEW
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color Function(IconData, ThemeData) getIconColor;
  final int maxLines;
  final double? fontSize; // Added for responsive font sizing
  final FontWeight? fontWeight; // Optional for value highlighting

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.getIconColor,
    this.maxLines = 1,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0), // Reduced bottom padding to minimize space
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 14, // Slightly smaller icon for compact layout
            color: getIconColor(icon, theme),
          ),
          const SizedBox(width: 4), // Reduced width
          Expanded(
            child: RichText(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.1, // Tighter line height
                  color: cs.onSurface.withOpacity(0.70),
                  fontSize: fontSize ?? 12, // Slightly smaller font
                ),
                children: [
                  if (label.isNotEmpty)
                    TextSpan(
                      text: '$label: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.8),
                        fontSize: fontSize ?? 12,
                      ),
                    ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: fontWeight ?? FontWeight.normal, // Apply fontWeight if provided
                      color: cs.onSurface.withOpacity(0.9), // Slightly darker for value
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ADministaterShow_realestete extends StatefulWidget {
  static const administaterShowRealEstate = "/administater_show_realestate";
  final bool fromNotification;
  final String? flatId;

  const ADministaterShow_realestete({
    super.key,
    this.fromNotification = false,
    this.flatId,
  });

  @override
  State<ADministaterShow_realestete> createState() => _ADministaterShow_realesteteState();
}

class _ADministaterShow_realesteteState extends State<ADministaterShow_realestete>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _number = '';
  String _location = '';
  String _post = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // ---- Shared helpers ----
  List<Map<String, dynamic>> _normalizeList(dynamic raw) {
    if (raw is List) {
      return raw.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } else if (raw is Map) {
      return [Map<String, dynamic>.from(raw)];
    }
    return const <Map<String, dynamic>>[];
  }

  dynamic _unwrapBody(dynamic decoded) {
    // Handle { success: true, data: [...] }
    if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
      return decoded['data'];
    }
    // Handle .asmx pattern: { "d": "[{...}]" } or { "d": {...} }
    if (decoded is Map<String, dynamic> && decoded.containsKey('d')) {
      final d = decoded['d'];
      try {
        return d is String ? json.decode(d) : d;
      } catch (_) {
        return d; // if not decodable, return as-is
      }
    }
    // Otherwise assume the decoded JSON is already the payload
    return decoded;
  }

  void _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _name = prefs.getString('name') ?? '';
      _number = prefs.getString('number') ?? '';
      _location = prefs.getString('location') ?? '';
      _post = prefs.getString('post') ?? '';
    });
    print("===== SHARED PREF DATA LOADED =====");
    print("Name: $_name");
    print("Number: $_number");
    print("Location: $_location");
    print("Post: $_post");
    print("===================================");
  }

  Future<List<Catid>> _fetchCommon(Uri url) async {
    final resp = await http.get(url).timeout(const Duration(seconds: 10)); // Added timeout
    if (resp.statusCode != 200) {
      throw Exception("HTTP ${resp.statusCode}: ${resp.body}");
    }
    final decoded = json.decode(resp.body);
    final payload = _unwrapBody(decoded);
    final list = _normalizeList(payload);
    // Newest first by P_id if present
    int asInt(dynamic v) => v is int ? v : (int.tryParse(v?.toString() ?? '') ?? 0);
    list.sort((a, b) => asInt(b['P_id']).compareTo(asInt(a['P_id'])));
    return list.map((e) => Catid.fromJson(e)).toList();
  }

  List<Map<String, String>> fieldWorkers = [
    {"name": "Sumit", "id": "9711775300"},
    {"name": "Ravi", "id": "9711275300"},
    {"name": "Faizan", "id": "9971172204"},
    {"name": "Manish", "id": "8130209217"},
    {"name": "Abhey", "id": "9675383184"},
  ];

  Map<String, List<Catid>> _groupedData = {};
  final Map<int, String> _totalFlatsMap = {}; // subid -> total flats count as String
  String? _highlightedFlatId;
  final Map<String, GlobalKey> _cardKeys = {};
  final Map<String, ScrollController> _horizontalControllers = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    // Empty list for each field worker
    for (var fw in fieldWorkers) {
      _groupedData[fw['name']!] = [];
      _horizontalControllers[fw['id']!] = ScrollController();
    }
    _loadUserData();
    _fetchAndUpdateData();
    // Scroll to flat if from notification
    if (widget.flatId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotification(widget.flatId!);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    for (var controller in _horizontalControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchAndUpdateData() async {
    setState(() => _isLoading = true);
    Map<String, List<Catid>> grouped = {};
    List<Future<void>> futures = [];
    for (var fw in fieldWorkers) {
      final number = fw['id']!;
      Uri url;
      if (number == '8130209217' || number == '9675383184') {
        // Fallback to PHP endpoint for Manish and Abhey to fetch all properties
        url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php?field_workar_number=$number",
        );
      } else {
        url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php?field_workar_number=$number",
        );
      }
      futures.add(
        _fetchCommon(url).then((data) {
          // Added logging for debugging
          print("Fetched ${data.length} properties for ${fw['name']} (${fw['id']}): ${data.isNotEmpty ? data.first.id : 'EMPTY'}");
          grouped[fw['name']!] = data;
        }).catchError((error) {
          print("Error fetching for ${fw['name']}: $error");
          grouped[fw['name']!] = [];
        }),
      );
    }
    await Future.wait(futures);
    if (mounted) {
      setState(() {
        _groupedData = grouped;
        _isLoading = false;
      });
      _animationController.forward(); // Start fade in animation
    }
    await _prefetchAllPropertyData();
    // Scroll to highlighted if exists
    if (_highlightedFlatId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlighted();
      });
    }
  }

  Future<void> _prefetchAllPropertyData() async {
    final allProperties = _groupedData.values.expand((list) => list).toList();
    if (allProperties.isEmpty) return;
    final uniqueSubids = <int>{};
    for (var p in allProperties) {
      uniqueSubids.add(p.subid);
    }
    final futures = uniqueSubids.map((sid) async {
      try {
        // Fetch total flats
        final response2 = await http.get(Uri.parse(
          'https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=$sid',
        )).timeout(const Duration(seconds: 5)); // Added timeout
        String totalStr = "0";
        if (response2.statusCode == 200) {
          final body = jsonDecode(response2.body);
          if (body is List && body.isNotEmpty) {
            totalStr = body[0]['logg'].toString();
          }
        }
        if (mounted) _totalFlatsMap[sid] = totalStr;
      } catch (_) {
        if (mounted) _totalFlatsMap[sid] = "0";
      }
    }).toList();
    await Future.wait(futures);
    if (mounted) setState(() {});
  }

  Future<void> _handleNotification(String flatId) async {
    setState(() {
      _highlightedFlatId = flatId;
    });
    // Fetch latest data
    await _fetchAndUpdateData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToHighlighted();
    });
  }

  Future<void> _scrollToHighlighted() async {
    if (_highlightedFlatId == null) return;
    final key = _cardKeys[_highlightedFlatId!];
    if (key != null && key.currentContext != null) {
      await Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _blank(String? s) => s == null || s.trim().isEmpty;

  // List<String> _missingFieldsFor(Catid i) {
  // final m = <String>[];
  // final checks = <String, String?>{
  // "Photo": i.propertyPhoto,
  // "Location": i.locations,
  // "Flat Number": i.flatNumber,
  // "Buy/Rent": i.buyRent,
  // "Residence/Commercial": i.residenceCommercial,
  // "Apartment Address": i.apartmentAddress,
  // "BHK": i.bhk,
  // "Floor": i.floor,
  // "Sqft": i.squarefit,
  // "Owner Name": i.ownerName,
  // "Owner Number": i.ownerNumber,
  // "Available Date": i.availableDate,
  // "Caretaker Name": i.caretakerName,
  // "Caretaker Number": i.caretakerNumber,
  // };
  // checks.forEach((k, v) { if (_blank(v)) m.add(k); });
  // return m;
  // }
  // bool _hasMissing(Catid i) => _missingFieldsFor(i).isNotEmpty;

  String formatDate(String s) {
    if (s.isEmpty) return '-';
    try {
      final dt = DateFormat('yyyy-MM-dd ').parse(s);
      return DateFormat('dd MMM yyyy,').format(dt);
    } catch (_) {
      try {
        final dt2 = DateTime.parse(s);
        return DateFormat('dd MMM yyyy,').format(dt2);
      } catch (_) {
        return s;
      }
    }
  }

  Color _getIconColor(IconData icon, ThemeData theme) {
    final cs = theme.colorScheme;
    switch (icon) {
      case Icons.location_on:
        return Colors.red;
      case Icons.square_foot:
        return Colors.orange;
      case Icons.handshake_outlined:
        return Colors.orangeAccent;
      case Icons.apartment:
        return Colors.blue;
      case Icons.layers:
        return Colors.teal;
      case Icons.format_list_numbered:
        return Colors.indigo;
      case Icons.date_range:
        return Colors.purple;
      case Icons.home:
        return Colors.brown;
      case Icons.numbers:
        return Colors.cyan;
      case Icons.currency_rupee:
        return Colors.green;
      case Icons.bed:
        return Colors.pink;
      case Icons.stairs:
        return Colors.deepPurple;
      default:
        return cs.primary;
    }
  }

  Color _getPropertyTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'rent':
        return Colors.green;
      case 'buy':
        return Colors.blueAccent;
      case 'lease':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }


  Widget _buildImageSection({
    required String? imageUrl,
    required ColorScheme cs,
    required ThemeData theme,
    required String? buyRent,
    required double imageHeight,
    required bool isTablet,
    required double multiImgHeight,
    required status,
    required images,

  }) {
    // Compute badge text and color
    String badgeText = '';
    Color badgeColor = Colors.grey;

    if (buyRent != null && buyRent.trim().isNotEmpty) {
      final lower = buyRent.toLowerCase().trim();
      switch (lower) {
        case 'rent':
          badgeText = 'Rent';
          badgeColor = Colors.green;
          break;
        case 'buy':
        case 'sale':
          badgeText = 'Buy';
          badgeColor = Colors.blueAccent;
          break;
        case 'lease':
          badgeText = 'Lease';
          badgeColor = Colors.purple;
          break;
        default:
          badgeText = buyRent.toUpperCase();
          badgeColor = _getPropertyTypeColor(buyRent);
      }
    }

    Widget imageWidget;
    if (imageUrl == null || imageUrl.isEmpty) {
      imageWidget = Container(
        height: imageHeight,
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.apartment,
          size: 90,
          color: Colors.grey,
        ),
      );
    } else {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/$imageUrl",
            fit: BoxFit.cover,
            placeholder: (_, __) => const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) =>
                Icon(Icons.broken_image, color: cs.error, size: 90),
          ),
        ),
      );
    }

    if (badgeText.isEmpty) {
      return imageWidget;
    }

    return Stack(
      children: [
        imageWidget,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badgeText,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }


    List<String> _buildMultipleImages(Catid p) {
    final List<String> imgs = [];
    if (p.propertyPhoto != null && p.propertyPhoto.isNotEmpty) {
      imgs.add('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.propertyPhoto}');
    }
    return imgs;
  }

  Widget _buildCard(Catid property, int displayIndex, bool isDarkMode) {
    final bool isHighlighted = _highlightedFlatId == property.id.toString();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenWidth < 400;
    final status = {
      "loggValue2": _totalFlatsMap[property.subid] ?? '0',
    };
    final images = _buildMultipleImages(property);
    final double cardPadding = (screenWidth * 0.02).clamp(6.0, 16.0); // Reduced padding for compact
    final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
    final double titleFontSize = isTablet ? 18 : 14; // Adjusted for compact
    final double detailFontSize = isTablet ? 13 : 12; // Smaller for less space
    final double imageH = (screenHeight * 0.28).clamp(150.0, 250.0); // Increased height to make image taller
    final double multiH = imageH * 0.8;

    // Calculate missing fields
    // final missingFields = _missingFieldsFor(property);
    // final hasMissingFields = missingFields.isNotEmpty;

    final Object loggValue2 = status['loggValue2'] ?? 'N/A';
    final Widget flatIdDetail = _DetailRow(
      icon: Icons.format_list_numbered,
      label: 'Property ID',
      value: property.id.toString(),
      theme: theme,
      getIconColor: _getIconColor,
      maxLines: 1,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    );
    final Widget buildingDetail = _DetailRow(
      icon: Icons.numbers,
      label: 'Building ID',
      value: property.subid.toString(),
      theme: theme,
      getIconColor: _getIconColor,
      maxLines: 1,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    );

    final Widget imageSection = _buildImageSection(
      images: property.propertyPhoto,
      cs: cs,
      theme: theme,
      imageHeight: imageH,
      multiImgHeight: multiH,
      isTablet: isTablet,
      imageUrl: '${property.propertyPhoto ?? ''}',
      buyRent: property.buyRent,
      status: status,
    );
    // Priority detail rows based on user request
    final List<Widget> detailRows = [];
    if ((property.locations ?? '').isNotEmpty) {
      detailRows.add(_DetailRow(
        icon: Icons.location_on,
        label: '',
        value: property.locations,
        theme: theme,
        getIconColor: _getIconColor,
        fontSize: detailFontSize,
        fontWeight: FontWeight.bold,
      ));
    }
    detailRows.add(_DetailRow(
      icon: Icons.currency_rupee,
      label: '',
      value: '₹${property.showPrice ?? 'N/A'}',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.bedroom_parent,
      label: '',
      value: '${property.bhk ?? 'N/A'}',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.stairs,
      label: '',
      value: property.floor ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.numbers,
      label: 'Flat No.',
      value: property.flatNumber ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.date_range,
      label: 'Added',
      value: formatDate(property.currentDate ?? ''),
      theme: theme,
      getIconColor: _getIconColor,
      maxLines: 2,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    final Widget leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageSection,
        SizedBox(height: isTablet ? 12 : 8), // Reduced spacing
        flatIdDetail,
      ],
    );
    final Widget rightColumn = Padding(
      padding: EdgeInsets.only(top: isTablet ? 28.0 : 24.0), // Increased top padding to avoid overlap with badge
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.apartmentAddress ?? property.apartmentName ?? property.locations ?? 'No Title',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
            ),
            maxLines: 2, // Reduced lines for compact
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isTablet ? 12 : 8), // Reduced height
          // Render detail rows
          ...detailRows,
          const Spacer(),
          // Shift Building ID and Flat ID to the right
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  buildingDetail,
                ],
              ),
            ),
          ),
        ],
      ),
    );
    // Ensure GlobalKey exists
    _cardKeys[property.id.toString()] ??= GlobalKey();
    return Container(
      key: _cardKeys[property.id.toString()],
      width: 350,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Reduced vertical margin
      child: GestureDetector(
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) =>
                    Administater_View_Details(idd: property.id.toString()))),
        child: Card(
          margin: EdgeInsets.zero, // No extra margin inside
          elevation: isDarkMode ? 0 : 4, // Reduced elevation for flatter look
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Slightly smaller radius
            side: BorderSide(color: theme.dividerColor),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  children: [
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: isSmallScreen ? 1 : (isTablet ? 2 : 2), // Adjust flex for small screens
                            child: leftColumn,
                          ),
                          SizedBox(width: isTablet ? 16 : 12), // Responsive width
                          Expanded(
                            flex: isSmallScreen ? 1 : (isTablet ? 3 : 3), // Adjust flex
                            child: rightColumn,
                          ),
                        ],
                      ),
                    ),
                    // if (hasMissingFields)
                    // Padding(
                    // padding: const EdgeInsets.only(top: 6.0), // Reduced top padding
                    // child: Container(
                    // width: double.infinity,
                    // padding: EdgeInsets.all(isTablet ? 6 : 4), // Reduced padding
                    // decoration: BoxDecoration(
                    // color: cs.errorContainer,
                    // borderRadius: BorderRadius.circular(6), // Smaller radius
                    // border: Border.all(color: cs.error),
                    // ),
                    // child: Text(
                    // "⚠ Missing: ${missingFields.join(', ')}",
                    // textAlign: TextAlign.center,
                    // style: theme.textTheme.bodySmall?.copyWith(
                    // color: cs.error,
                    // fontWeight: FontWeight.w600,
                    // fontSize: detailFontSize - 1, // Smaller font
                    // ),
                    // maxLines: 2, // Reduced lines
                    // overflow: TextOverflow.ellipsis,
                    // ),
                    // ),
                    // ),
                  ],
                ),
              ),
              // Top right count number badge
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Increased padding for bigger size
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8), // Smaller radius
                  ),
                  child: Text(
                    '$displayIndex',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14, // Increased font size
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldWorkerSection(List<Catid> data, String workerId, String workerName) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);  // NEW: Grab theme for consistent access
    final ScrollController controller = _horizontalControllers[workerId]!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                workerName,
                style: theme.textTheme.headlineSmall?.copyWith(  // Use textTheme for semantic sizing
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,  // Dynamic: white-ish in dark, black-ish in light
                  fontSize: 20,  // Override if needed; headlineSmall is ~20 by default
                ) ?? const TextStyle(  // Fallback if textTheme is null
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,  // Safe fallback, but theme will override
                ),
              ),
              GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => See_All_Realestate(id: workerId)),
                  ),
                  child: const Text("View All",
                      style: TextStyle(fontSize: 16, color: Colors.red))),
            ],
          ),
        ),
        if (data.isEmpty)
          Container(
            height: 150, // Reduced height
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), // Reduced margin
            decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(12), // Smaller radius
                border: Border.all(color: Colors.orange)),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 40),
                  SizedBox(height: 8),
                  Text("No Live Properties\n(Contact backend to update)",
                      style: TextStyle(fontSize: 14, color: Colors.orange),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 320, // Slightly increased height to accommodate taller image
            child: ListView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              itemBuilder: (context, index) {
                final displayIndex = data.length - index; // calculate display index
                return _buildCard(data[index], displayIndex, isDarkMode); // pass displayIndex
              },
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = _location.trim().toLowerCase();
    final post = _post.trim().toLowerCase();
    bool isSubAdmin = post == "sub administrator";
    bool isAdmin = post == "administrator";
    final Widget content = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: fieldWorkers
            .where((fw) {
          final name = fw['name']!.toLowerCase();
          // ADMIN → SHOW EVERYONE
          if (isAdmin) return true;
          // SUB-ADMIN → FILTER BY LOCATION
          if (loc.contains("sultanpur")) {
            return name == "sumit" || name == "ravi" || name == "faizan";
          }
          if (loc.contains("rajpur") || loc.contains("chhattar")) {
            return name == "manish" || name == "abhey";
          }
          return false;
        }).map((fw) {
          final props = _groupedData[fw['name']] ?? [];
          return _buildFieldWorkerSection(props, fw['id']!, fw['name']!);
        }).toList(),
      ),
    );
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : FadeTransition(
          opacity: _fadeAnimation,
          child: content,
        ),
      ),
    );
  }

  void _launchDialer(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunch(launchUri.toString())) {
      await launch(launchUri.toString());
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }
}