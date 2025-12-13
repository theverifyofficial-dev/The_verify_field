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
  final double? fontSize;
  final FontWeight? fontWeight;

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
      padding: const EdgeInsets.only(bottom: 4.0), // Further reduced for compactness
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 12, // Smaller icon
            color: getIconColor(icon, theme),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodySmall?.copyWith( // Use bodySmall for smaller text
                  height: 1.1,
                  color: cs.onSurface.withOpacity(0.70),
                  fontSize: fontSize ?? 11,
                ),
                children: [
                  if (label.isNotEmpty)
                    TextSpan(
                      text: '$label: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.8),
                        fontSize: fontSize ?? 11,
                      ),
                    ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: fontWeight ?? FontWeight.normal,
                      color: cs.onSurface.withOpacity(0.9),
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

class _ADministaterShow_FuturePropertyState extends State<ADministaterShow_FutureProperty> {
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
  final Map<int, int> _liveCountMap = {};
  final Map<int, String> _totalFlatsMap = {};

  @override
  void initState() {
    super.initState();

    for (var fw in fieldWorkers) {
      _groupedData[fw['name']!] = [];
      _horizontalControllers[fw['id']!] = ScrollController();
    }

    _initializeData();

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

    if (widget.buildingId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleNotification(widget.buildingId!);
      });
    }
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    await _fetchAndUpdateData();

    if (_highlightedBuildingId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToHighlighted();
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

    final loc = _location.trim().toLowerCase();
    final post = _post.trim().toLowerCase();
    bool isSubAdmin = post == "sub administrator";
    bool isAdmin = post == "administrator";
    List<Map<String, String>> visibleWorkers = fieldWorkers.where((fw) {
      if (isAdmin) return true;
      final name = fw['name']!.toLowerCase();
      if (loc.contains("sultanpur")) {
        return name == "sumit" || name == "ravi" || name == "faizan";
      }
      if (loc.contains("rajpur") || loc.contains("chhattar")) {
        return name == "manish" || name == "abhay" || name == "abhey";
      }
      return false;
    }).toList();

    final workerFutures = visibleWorkers.map((fw) async {
      final data = await _fetchDataByNumber(fw['id']!);
      return MapEntry(fw['name']!, data);
    }).toList();

    final groupedEntries = await Future.wait(workerFutures);
    final Map<String, List<Catid>> grouped = Map<String, List<Catid>>.fromEntries(groupedEntries);

    for (var fw in fieldWorkers) {
      if (!grouped.containsKey(fw['name'])) {
        grouped[fw['name']!] = [];
      }
    }

    setState(() {
      _groupedData = grouped;
      _isLoading = false;
    });

    _prefetchAllPropertyData();
  }

  Future<void> _prefetchAllPropertyData() async {
    final allProperties = _groupedData.values.expand((list) => list).toList();
    if (allProperties.isEmpty) return;

    final futures = allProperties.map((p) async {
      try {
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
    required bool isSmallScreen,
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
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.apartment,
          size: isSmallScreen ? 60 : 80,
          color: Colors.grey,
        ),
      );
    } else if (images.length == 1) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: images.first,
            fit: BoxFit.cover,
            placeholder: (_, __) => Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) => Icon(Icons.broken_image, color: cs.error, size: isSmallScreen ? 60 : 80),
          ),
        ),
      );
    } else {
      imageWidget = Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: multiImgHeight,
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: CachedNetworkImage(
                        imageUrl: images[0],
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Center(
                          child: SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (_, __, ___) => Icon(Icons.broken_image, color: cs.error, size: isSmallScreen ? 40 : 50),
                      ),
                    ),
                  ),
                  if (images.length > 1) ...[
                    const SizedBox(width: 2),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            CachedNetworkImage(
                              imageUrl: images[1],
                              fit: BoxFit.cover,
                              placeholder: (_, __) => Center(
                                child: SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (_, __, ___) => Icon(Icons.broken_image, color: cs.error, size: isSmallScreen ? 40 : 50),
                            ),
                            if (images.length > 2)
                              Positioned(
                                bottom: 2,
                                right: 2,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '+${images.length - 2}',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
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
            const SizedBox(height: 2),
            Flexible(
              child: Text(
                '${images.length} ${images.length == 1 ? 'Image' : 'Images'}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Stack(
      children: [
        imageWidget,
        Positioned(
          top: 2,
          right: 2,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: liveColor.withOpacity(0.8),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              liveLabel,
              style: theme.textTheme.labelSmall?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
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

  Widget _buildCard(Catid property, int displayIndex, bool isDarkMode, BuildContext context) {
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

    final double cardPadding = (screenWidth * 0.015).clamp(4.0, 10.0);
    final double titleFontSize = isTablet ? 16 : (isSmallScreen ? 12 : 14);
    final double detailFontSize = isTablet ? 12 : (isSmallScreen ? 10 : 11);
    final double imageH = (screenHeight * 0.15).clamp(80.0, 150.0);
    final double multiH = imageH * 0.7;

    final missingFields = _missingFieldsFor(property);
    final hasMissingFields = missingFields.isNotEmpty;

    final Widget totalDetail = _DetailRow(
      icon: Icons.format_list_numbered,
      label: 'Total Flats',
      value: '${status['loggValue2']}',
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
      isSmallScreen: isSmallScreen,
    );

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
      maxLines: 1, // Reduced to 1 for compactness
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));
    detailRows.add(_DetailRow(
      icon: Icons.date_range,
      label: 'Date',
      value: formatDate(property.currentDate ?? ''),
      theme: theme,
      getIconColor: _getIconColor,
      maxLines: 1, // Reduced to 1
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    final Widget leftColumn = Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(child: imageSection),
          SizedBox(height: isSmallScreen ? 4 : 6),
          totalDetail,
        ],
      ),
    );

    final Widget rightColumn = Flexible(
      child: Padding(
        padding: EdgeInsets.only(top: isSmallScreen ? 4 : 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                property.propertyAddressForFieldworker ?? property.propertyNameAddress ?? property.place ?? 'No Title',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: titleFontSize,
                ),
                maxLines: isSmallScreen ? 1 : 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 6),
            ...detailRows,
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child: buildingDetail,
            ),
          ],
        ),
      ),
    );

    final double cardWidth = isTablet
        ? screenWidth * 0.45.clamp(300.0, 380.0)
        : screenWidth * 0.88.clamp(250.0, 340.0);

    _cardKeys[property.id.toString()] ??= GlobalKey();

    return Container(
      key: _cardKeys[property.id.toString()],
      width: cardWidth,
      margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 4 : 6, vertical: 4),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Administater_Future_Property_details(buildingId: property.id.toString()),
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: isDarkMode ? 0 : 2,
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
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
                            flex: isSmallScreen ? 1 : 1,
                            child: leftColumn,
                          ),
                          SizedBox(width: isSmallScreen ? 4 : 8),
                          Expanded(
                            flex: isSmallScreen ? 1 : 2,
                            child: rightColumn,
                          ),
                        ],
                      ),
                    ),
                    if (hasMissingFields)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isSmallScreen ? 3 : 4),
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: cs.error),
                          ),
                          child: Text(
                            "⚠ Missing: ${missingFields.take(3).join(', ')}${missingFields.length > 3 ? '...' : ''}",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.error,
                              fontWeight: FontWeight.w600,
                              fontSize: detailFontSize - 1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: cs.primary.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$displayIndex',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 9,
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

  Widget _buildFieldWorkerSection(List<Catid> data, String workerId, String workerName, BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 400;
    final ScrollController controller = _horizontalControllers[workerId]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 45, // Slightly reduced
          padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  workerName,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                    fontSize: isSmallScreen ? 16 : 18,
                  ) ?? TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SeeAll_FutureProperty(number: workerId),
                  ),
                ),
                child: Text(
                  "See All",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: isSmallScreen ? 12 : 14,
                    color: theme.colorScheme.error,
                    fontWeight: FontWeight.w600,
                  ) ?? TextStyle(fontSize: isSmallScreen ? 12 : 14, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        if (data.isEmpty)
          Container(
            height: isSmallScreen ? 200 : 220,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.error),
            ),
            child: Center(
              child: Text(
                "No Properties Found",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: isSmallScreen ? 12 : 13,
                  color: theme.colorScheme.error,
                ) ?? TextStyle(fontSize: isSmallScreen ? 12 : 13, color: Colors.redAccent),
              ),
            ),
          )
        else
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: controller,
            child: Row(
              children: List.generate(
                data.length,
                    (index) {
                  final displayIndex = data.length - index;
                  return _buildCard(data[index], displayIndex, isDarkMode, context);
                },
              ),
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
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Image.asset(AppImages.verify, height: 60), // Slightly reduced height
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 25), // Slightly smaller
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
            if (isAdmin) return true;
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
            return _buildFieldWorkerSection(props, fw['id']!, fw['name']!, context);
          })
              .toList(),
        ),
      ),
    );
  }
}