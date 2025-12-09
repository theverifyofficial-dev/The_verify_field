import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Home_Screen_click/Commercial_property_Filter.dart';
import '../../Home_Screen_click/Filter_Options.dart';
import '../../ui_decoration_tools/app_images.dart';
import '../Administrator_HomeScreen.dart';
import 'Future_Property_Details.dart';
import 'See_All_Futureproperty.dart';
import 'package:intl/intl.dart';

class Catid {
  final int id;
  final String? images;
  final String? ownerName;
  final String? ownerNumber;
  final String? caretakerName;
  final String? caretakerNumber;
  final String? place;
  final String? buyRent;
  final String? typeOfProperty;
  final String? selectBhk;
  final String? floorNumber;
  final String? squareFeet;
  final String? propertyNameAddress;
  final String? buildingInformationFacilities;
  final String? propertyAddressForFieldworker;
  final String? ownerVehicleNumber;
  final String? yourAddress;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? currentDate;
  final String? longitude;
  final String? latitude;
  final String? roadSize;
  final String? metroDistance;
  final String? metroName;
  final String? mainMarketDistance;
  final String? ageOfProperty;
  final String? lift;
  final String? parking;
  final String? totalFloor;
  final String? residenceCommercial;
  final String? facility;

  Catid({
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
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
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
    required this.residenceCommercial,
    required this.facility,
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['id'] ?? 0,
      images: json['images'],
      ownerName: json['ownername'],
      ownerNumber: json['ownernumber'],
      caretakerName: json['caretakername'],
      caretakerNumber: json['caretakernumber'],
      place: json['place'],
      buyRent: json['buy_rent'],
      typeOfProperty: json['typeofproperty'],
      selectBhk: json['select_bhk'],
      floorNumber: json['floor_number'],
      squareFeet: json['sqyare_feet'],
      propertyNameAddress: json['propertyname_address'],
      buildingInformationFacilities: json['building_information_facilitys'],
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'],
      ownerVehicleNumber: json['owner_vehical_number'],
      yourAddress: json['your_address'],
      fieldWorkerName: json['fieldworkarname'],
      fieldWorkerNumber: json['fieldworkarnumber'],
      currentDate: json['current_date_'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      metroName: json['metro_name'],
      mainMarketDistance: json['main_market_distance'],
      ageOfProperty: json['age_of_property'],
      lift: json['lift'],
      parking: json['parking'],
      totalFloor: json['total_floor'],
      residenceCommercial: json['Residence_commercial'],
      facility: json['facility'],
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

class ADministaterShow_FutureProperty extends StatefulWidget {
  final bool fromNotification;
  final String? buildingId;

  const ADministaterShow_FutureProperty({
    super.key,
    this.fromNotification = false,
    this.buildingId,
  });

  @override
  State<ADministaterShow_FutureProperty> createState() => _ADministaterShow_FuturePropertyState();

}

class _ADministaterShow_FuturePropertyState
    extends State<ADministaterShow_FutureProperty> {
  final Map<String, GlobalKey> _cardKeys = {};
  final Map<String, ScrollController> _horizontalControllers = {};
  String? _highlightedBuildingId;
  bool _isLoading = true;
  String _number = '';
  String _location = '';
  String _post = '';


  List<Map<String, String>> fieldWorkers = [
    {"name": "Sumit", "id": "9711775300"},
    {"name": "Ravi", "id": "9711275300"},
    {"name": "Faizan", "id": "9971172204"},
    {"name": "Manish", "id": "8130209217"},
    {"name": "Abhay", "id": "9675383184"},
  ];

  Map<String, List<Catid>> _groupedData = {};
  final Map<int, int> _liveCountMap = {}; // subid -> live count
  final Map<int, String> _totalFlatsMap = {}; // subid -> total flats count as String

  @override
  void initState() {
    super.initState();

    // Empty list for each field worker
    for (var fw in fieldWorkers) {
      _groupedData[fw['name']!] = [];
      _horizontalControllers[fw['id']!] = ScrollController();
    }

    _loadUserData();
    _fetchAndUpdateData();

    // Notification listeners
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      final buildingId = message.data['building_id'];
      if (buildingId != null) _handleNotification(buildingId.toString());
    });

    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        final buildingId = message.data['building_id'];
        if (buildingId != null) _handleNotification(buildingId.toString());
      }
    });

    // Scroll to building if from notification
    if (widget.buildingId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotification(widget.buildingId!);
      });
    }
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
      _location = prefs.getString('location') ?? '';
      _post = prefs.getString('post') ?? '';

    });

    print("===== SHARED PREF DATA LOADED =====");
    print("Number: $_number");
    print("Location: $_location");
    print("Post: $_post");
    print("===================================");
  }


  Future<List<Catid>> _fetchDataByNumber(String number) async {
    final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=$number");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic decoded = json.decode(response.body);
        List listData = decoded is List
            ? decoded
            : (decoded['data'] ?? decoded['Table'] ?? []);
        listData.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
        return listData.map((e) => Catid.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<void> _fetchAndUpdateData() async {
    setState(() => _isLoading = true);

    Map<String, List<Catid>> grouped = {};
    for (var fw in fieldWorkers) {
      final data = await _fetchDataByNumber(fw['id']!);
      grouped[fw['name']!] = data;
    }

    setState(() {
      _groupedData = grouped;
      _isLoading = false;
    });

    await _prefetchAllPropertyData();

    // Scroll to highlighted if exists
    if (_highlightedBuildingId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlighted();
      });
    }
  }

  Future<void> _prefetchAllPropertyData() async {
    final allProperties = _groupedData.values.expand((list) => list).toList();
    if (allProperties.isEmpty) return;
    final futures = allProperties.map((p) async {
      try {
        // Fetch total flats
        final response2 = await http.get(Uri.parse(
          'https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=${p.id}',
        ));
        String totalStr = "0";
        if (response2.statusCode == 200) {
          final body = jsonDecode(response2.body);
          if (body is List && body.isNotEmpty) {
            totalStr = body[0]['logg'].toString();
          }
        }
        _totalFlatsMap[p.id] = totalStr;
        // Fetch live count
        final response3 = await http.get(Uri.parse(
          'https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=${p.id}',
        ));
        int liveC = 0;
        if (response3.statusCode == 200) {
          final body3 = jsonDecode(response3.body);
          if (body3 is List && body3.isNotEmpty) {
            for (var item in body3) {
              if (item['live_unlive'] == 'Live') {
                liveC = (item['logs'] as num?)?.toInt() ?? 0;
                break;
              }
            }
          }
        }
        _liveCountMap[p.id] = liveC;
      } catch (_) {
        _totalFlatsMap[p.id] = "0";
        _liveCountMap[p.id] = 0;
      }
    }).toList();
    await Future.wait(futures);
    if (mounted) setState(() {});
  }

  Future<void> _handleNotification(String buildingId) async {
    setState(() {
      _highlightedBuildingId = buildingId;
    });

    // Fetch latest data
    await _fetchAndUpdateData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToHighlighted();
    });
  }

  Future<void> _scrollToHighlighted() async {
    if (_highlightedBuildingId == null) return;
    final key = _cardKeys[_highlightedBuildingId!];
    if (key != null && key.currentContext != null) {
      await Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }

  bool _blank(String? s) => s == null || s.trim().isEmpty;

  List<String> _missingFieldsFor(Catid i) {
    final m = <String>[];
    final checks = <String, String?>{
      "Image": i.images,
      "Owner Name": i.ownerName,
      "Owner Number": i.ownerNumber,
      "Caretaker Name": i.caretakerName,
      "Caretaker Number": i.caretakerNumber,
      "Place": i.place,
      "Buy/Rent": i.buyRent,
      "Type of Property": i.typeOfProperty,
      "BHK": i.selectBhk,
      "Floor Number": i.floorNumber,
      "Square Feet": i.squareFeet,
      "Property Name/Address": i.propertyNameAddress,
      "Building Facilities": i.buildingInformationFacilities,
      "Address (Fieldworker)": i.propertyAddressForFieldworker,
      "Owner Vehicle Number": i.ownerVehicleNumber,
      "Your Address": i.yourAddress,
      "Field Worker Name": i.fieldWorkerName,
      "Field Worker Number": i.fieldWorkerNumber,
      "Current Date": i.currentDate,
      "Longitude": i.longitude,
      "Latitude": i.latitude,
      "Road Size": i.roadSize,
      "Metro Distance": i.metroDistance,
      "Metro Name": i.metroName,
      "Main Market Distance": i.mainMarketDistance,
      "Age of Property": i.ageOfProperty,
      "Lift": i.lift,
      "Parking": i.parking,
      "Total Floor": i.totalFloor,
      "Residence/Commercial": i.residenceCommercial,
      "Facility": i.facility,
    };
    checks.forEach((k, v) { if (_blank(v)) m.add(k); });
    return m;
  }

  bool _hasMissing(Catid i) => _missingFieldsFor(i).isNotEmpty;

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
      default:
        return cs.primary;
    }
  }

  Widget _buildImageSection({
    required List<String> images,
    required ColorScheme cs,
    required ThemeData theme,
    required Map<String, dynamic> status,
    required double imageHeight,
    required double multiImgHeight,
    required bool isTablet,
  }) {
    final int liveCount = status['liveCount'] ?? 0;
    final Color liveColor = liveCount > 0 ? Colors.green : Colors.red;
    final String liveLabel = liveCount > 0 ? "Live: $liveCount" : "Unlive: 0";

    Widget imageWidget;
    if (images.isEmpty) {
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
    } else if (images.length == 1) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: images.first,
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
    } else {
      imageWidget = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: multiImgHeight,
            child: Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: images[0],
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) =>
                          Icon(Icons.broken_image, color: cs.error, size: 50),
                    ),
                  ),
                ),
                if (images.length > 1) ...[
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: images[1],
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) =>
                                Icon(Icons.broken_image, color: cs.error, size: 50),
                          ),
                          if (images.length > 2)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '+${images.length - 2}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4), // Reduced height for less space
          Text(
            '${images.length} ${images.length == 1 ? 'Image' : 'Images'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        imageWidget,
        Positioned(
          top: 4,
          right: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: liveColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              liveLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<String> _buildMultipleImages(Catid p) {
    final List<String> imgs = [];
    if (p.images != null && p.images!.isNotEmpty) {
      imgs.add('https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${p.images}');
    }
    return imgs;
  }

  Widget _buildCard(Catid property, int displayIndex, bool isDarkMode) {
    final bool isHighlighted = _highlightedBuildingId == property.id.toString();
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenWidth < 400;

    final status = {
      "loggValue2": _totalFlatsMap[property.id] ?? '0',
      "liveCount": _liveCountMap[property.id] ?? 0,
    };

    final images = _buildMultipleImages(property);

    final double cardPadding = (screenWidth * 0.02).clamp(6.0, 16.0); // Reduced padding for compact
    final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
    final double titleFontSize = isTablet ? 18 : 14; // Adjusted for compact
    final double detailFontSize = isTablet ? 13 : 12; // Smaller for less space
    final double imageH = (screenHeight * 0.22).clamp(120.0, 200.0); // Reduced height
    final double multiH = imageH * 0.8;

    // Calculate missing fields
    final missingFields = _missingFieldsFor(property);
    final hasMissingFields = missingFields.isNotEmpty;

    final Object loggValue2 = status['loggValue2'] ?? 'N/A';

    final Widget totalDetail = _DetailRow(
      icon: Icons.format_list_numbered,
      label: 'Total Flats',
      value: '$loggValue2',
      theme: theme,
      getIconColor: _getIconColor,
      maxLines: 1,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    );

    final Widget buildingDetail = _DetailRow(
      icon: Icons.numbers,
      label: 'Building ID',
      value: property.id.toString(),
      theme: theme,
      getIconColor: _getIconColor,
      maxLines: 1,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    );

    final Widget imageSection = _buildImageSection(
      images: images,
      cs: cs,
      theme: theme,
      status: status,
      imageHeight: imageH,
      multiImgHeight: multiH,
      isTablet: isTablet,
    );

    // Priority detail rows: location, buy/rent, residence/commercial, added (removed Building ID)
    final List<Widget> detailRows = [];
    if ((property.place ?? '').isNotEmpty) {
      detailRows.add(_DetailRow(
        icon: Icons.location_on,
        label: 'Location',
        value: property.place!,
        theme: theme,
        getIconColor: _getIconColor,
        fontSize: detailFontSize,
        fontWeight: FontWeight.bold,
      ));
    }
    detailRows.add(_DetailRow(
      icon: Icons.handshake_outlined,
      label: '',
      value: property.buyRent ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.apartment,
      label: '',
      value: property.residenceCommercial ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.real_estate_agent_outlined,
      label: 'Age',
      value: property.ageOfProperty ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      maxLines: 2,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.date_range,
      label: 'Date',
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
        totalDetail,
      ],
    );

    final Widget rightColumn = Padding(
      padding: EdgeInsets.only(top: isTablet ? 16.0 : 12.0), // Reduced top padding
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.propertyAddressForFieldworker ?? property.propertyNameAddress ?? property.place ?? 'No Title',
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
          // Shift Building ID to the right
          Align(
            alignment: Alignment.centerRight,
            child: SizedBox(
              width: double.infinity,
              child: buildingDetail,
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
                    Administater_Future_Property_details(buildingId: property.id.toString()))),
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
                    if (hasMissingFields)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0), // Reduced top padding
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isTablet ? 6 : 4), // Reduced padding
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(6), // Smaller radius
                            border: Border.all(color: cs.error),
                          ),
                          child: Text(
                            "⚠ Missing: ${missingFields.join(', ')}",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.error,
                              fontWeight: FontWeight.w600,
                              fontSize: detailFontSize - 1, // Smaller font
                            ),
                            maxLines: 2, // Reduced lines
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              // Top right count number badge
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), // Reduced padding
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(8), // Smaller radius
                  ),
                  child: Text(
                    '$displayIndex',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 10, // Smaller font
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
              Text(workerName,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => SeeAll_FutureProperty(number: workerId)),
                  ),
                  child: const Text("See All",
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
                border: Border.all(color: Colors.redAccent)),
            child: const Center(
              child: Text("No Properties Found",
                  style: TextStyle(fontSize: 14, color: Colors.redAccent)), // Smaller font
            ),
          )
        else
          SizedBox(
            height: 300, // Reduced overall height for compact cards
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 30),
        ),

      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
              return name == "manish" || name == "abhay" || name == "abhey";
            }

            return false;
          })
              .map((fw) {
            final props = _groupedData[fw['name']] ?? [];
            return _buildFieldWorkerSection(props, fw['id']!, fw['name']!);
          })
              .toList(),
        ),
      ),

    );
  }
}