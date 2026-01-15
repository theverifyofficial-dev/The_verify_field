import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../ui_decoration_tools/app_images.dart';
import '../Administrator_HomeScreen.dart';
import 'Future_Property_Details.dart';
import 'See_All_Futureproperty.dart';

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
    this.images,
    this.ownerName,
    this.ownerNumber,
    this.caretakerName,
    this.caretakerNumber,
    this.place,
    this.buyRent,
    this.typeOfProperty,
    this.selectBhk,
    this.floorNumber,
    this.squareFeet,
    this.propertyNameAddress,
    this.buildingInformationFacilities,
    this.propertyAddressForFieldworker,
    this.ownerVehicleNumber,
    this.yourAddress,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.currentDate,
    this.longitude,
    this.latitude,
    this.roadSize,
    this.metroDistance,
    this.metroName,
    this.mainMarketDistance,
    this.ageOfProperty,
    this.lift,
    this.parking,
    this.totalFloor,
    this.residenceCommercial,
    this.facility,
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
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: getIconColor(icon, theme)),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.2,
                  color: cs.onSurface.withOpacity(0.70),
                  fontSize: fontSize ?? 13,
                ),
                children: [
                  if (label.isNotEmpty)
                    TextSpan(
                      text: '$label: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.8),
                        fontSize: fontSize ?? 13,
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
    {"name": "Sumit Kasaniya", "id": "9711775300"},
    {"name": "Ravi Kumar", "id": "9711275300"},
    {"name": "Faizan Khan", "id": "9971172204"},
    {"name": "Manish", "id": "8130209217"},
    {"name": "Abhay", "id": "9675383184"},
  ];

  final Map<int, int> _liveCountMap = {};
  final Map<int, String> _totalFlatsMap = {};


  Map<String, List<Catid>> _groupedData = {};


  @override
  void initState() {
    super.initState();

    // Controllers init
    for (final fw in fieldWorkers) {
      _horizontalControllers[fw['id']!] = ScrollController();
      _groupedData[fw['id']!] = [];
    }

    // Starting mein loading true (UI mein spinner dikhega fresh run pe)
    _isLoading = true;

    // Post frame callback mein load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }


  Future<void> _initializeData() async {
    await _loadUserData();  // Pehle location aur post load hone do

    if (!mounted) return;

    // Ab location/post guaranteed filled hain
    await _fetchAndUpdateData();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _location = prefs.getString('location') ?? '';
    _post = prefs.getString('post') ?? '';
  }

  Future<List<Catid>> _fetchDataByNumber(String number) async {
    final url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=$number");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic decoded = json.decode(response.body);
        List listData = decoded is List ? decoded : (decoded['data'] ?? decoded['Table'] ?? []);
        listData.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
        return listData.map((e) => Catid.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Fetch error for $number: $e");
    }
    return [];
  }

  Future<void> _fetchAndUpdateData() async {
    if (_location.isEmpty || _post.isEmpty) return;

    setState(() => _isLoading = true);

    final loc = _location.toLowerCase();
    final isAdmin = _post.toLowerCase() == "administrator";

    List<Map<String, String>> allowedWorkers = [];

    if (isAdmin) {
      allowedWorkers = fieldWorkers;
    } else if (loc.contains("sultanpur")) {
      allowedWorkers = fieldWorkers.where((fw) =>
      fw['name']!.toLowerCase().contains("sumit") ||
          fw['name']!.toLowerCase().contains("ravi") ||
          fw['name']!.toLowerCase().contains("faizan")
      ).toList();
    } else if (loc.contains("rajpur") ||
        loc.contains("chhattarpur") ||
        loc.contains("chattar") ||
        loc.contains("chhattar")) {
      allowedWorkers = fieldWorkers.where((fw) =>
      fw['name']!.toLowerCase().contains("manish") ||
          fw['name']!.toLowerCase().contains("abhay")
      ).toList();
    }

    for (final fw in allowedWorkers) {
      final data = await _fetchDataByNumber(fw['id']!);
      _groupedData[fw['id']!] = data;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }




  Future<void> _prefetchAllPropertyData() async {
    final allProperties = _groupedData.values.expand((list) => list).toList();
    if (allProperties.isEmpty) return;

    final futures = allProperties.map((p) async {
      try {
        final resp1 = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=${p.id}'));
        if (resp1.statusCode == 200) {
          final body = jsonDecode(resp1.body);
          if (body is List && body.isNotEmpty) {
            _totalFlatsMap[p.id] = body[0]['logg'].toString();
          }
        }

        final resp2 = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=${p.id}'));
        if (resp2.statusCode == 200) {
          final body = jsonDecode(resp2.body);
          if (body is List) {
            for (var item in body) {
              if (item['live_unlive'] == 'Live') {
                _liveCountMap[p.id] = (item['logs'] as num?)?.toInt() ?? 0;
                break;
              }
            }
          }
        }
      } catch (_) {}
    });

    await Future.wait(futures);
    if (mounted) setState(() {});
  }

  Future<void> _handleNotification(String buildingId) async {
    setState(() => _highlightedBuildingId = buildingId);
    await _fetchAndUpdateData();
  }

  Future<void> _scrollToHighlighted() async {
    if (_highlightedBuildingId == null) return;
    final key = _cardKeys[_highlightedBuildingId!];
    if (key?.currentContext != null) {
      await Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  String formatDate(String s) {
    if (s.isEmpty) return '-';
    try {
      final dt = DateFormat('yyyy-MM-dd ').parse(s);
      return DateFormat('dd MMM yyyy').format(dt);
    } catch (_) {
      try {
        return DateFormat('dd MMM yyyy').format(DateTime.parse(s));
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
      case Icons.real_estate_agent_outlined:
        return Colors.brown;
      default:
        return cs.primary;
    }
  }

  List<String> _buildMultipleImages(Catid p) {
    final List<String> imgs = [];
    if (p.images != null && p.images!.trim().isNotEmpty) {
      final base = 'https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/';
      imgs.add('$base${p.images!.trim()}');
    }
    return imgs;
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
      // "Type of Property": i.typeOfProperty,
      // "BHK": i.selectBhk,
      // "Floor Number": i.floorNumber,
      // "Square Feet": i.squareFeet,
      "Property Name/Address": i.propertyNameAddress,
      // "Building Facilities": i.buildingInformationFacilities,
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
    checks.forEach((k, v) {
      if (_blank(v)) m.add(k);
    });
    return m;
  }

  Widget _buildImageSection({
    required List<String> images,
    required ColorScheme cs,
    required ThemeData theme,
    required Map<String, dynamic> status,
    required double imageHeight,
    required double multiImgHeight,
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
        child: const Icon(Icons.apartment, size: 90, color: Colors.grey),
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
            placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (_, __, ___) => Icon(Icons.broken_image, color: cs.error, size: 90),
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
                      placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      errorWidget: (_, __, ___) => Icon(Icons.broken_image, color: cs.error, size: 50),
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
                            placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            errorWidget: (_, __, ___) => Icon(Icons.broken_image, color: cs.error, size: 50),
                          ),
                          if (images.length > 2)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                                child: Text('+${images.length - 2}', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
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
          const SizedBox(height: 6),
          Text('${images.length} ${images.length == 1 ? 'Image' : 'Images'}',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.primary, fontWeight: FontWeight.w600)),
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
            decoration: BoxDecoration(color: liveColor.withOpacity(0.8), borderRadius: BorderRadius.circular(10)),
            child: Text(liveLabel, style: theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Catid property, int displayIndex) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    final status = {
      "liveCount": _liveCountMap[property.id] ?? 0,
      "loggValue2": _totalFlatsMap[property.id] ?? '0',
    };

    final images = _buildMultipleImages(property);
    final double cardPadding = (size.width * 0.03).clamp(8.0, 20.0);
    final double titleFontSize = isTablet ? 20 : 16;
    final double detailFontSize = isTablet ? 14 : 13;
    final double imageH = (size.height * 0.29).clamp(150.0, 250.0);
    final double multiH = imageH * 0.8;

    final missingFields = _missingFieldsFor(property);
    final hasMissingFields = missingFields.isNotEmpty;

    final Widget imageSection = _buildImageSection(
      images: images,
      cs: cs,
      theme: theme,
      status: status,
      imageHeight: imageH,
      multiImgHeight: multiH,
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
    detailRows.addAll([
      _DetailRow(icon: Icons.handshake_outlined, label: '', value: property.buyRent ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold),
      _DetailRow(icon: Icons.apartment, label: '', value: property.residenceCommercial ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold),
      _DetailRow(icon: Icons.real_estate_agent_outlined, label: 'Age', value: property.ageOfProperty ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold),
      _DetailRow(icon: Icons.date_range, label: 'Date', value: formatDate(property.currentDate ?? ''), theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold),
    ]);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Administater_Future_Property_details(buildingId: property.id.toString()),
          ),
        );
      },
      child: Card(
        key: _cardKeys[property.id.toString()] ??= GlobalKey(),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        elevation: isDark ? 0 : 6,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor),
        ),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          imageSection,
                          const SizedBox(height: 12),
                          _DetailRow(
                            icon: Icons.format_list_numbered,
                            label: 'Total Flats',
                            value: status['loggValue2'].toString(),
                            theme: theme,
                            getIconColor: _getIconColor,
                            fontSize: detailFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 22),
                              Text(
                                property.propertyAddressForFieldworker ?? property.propertyNameAddress ?? property.place ?? 'No Title',
                                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: titleFontSize),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              ...detailRows,
                              const SizedBox(height: 14),
                              Align(
                                alignment: Alignment.centerRight,
                                child: _DetailRow(
                                  icon: Icons.numbers,
                                  label: 'Building ID',
                                  value: property.id.toString(),
                                  theme: theme,
                                  getIconColor: _getIconColor,
                                  fontSize: detailFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: cs.primary.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 6, offset: const Offset(0, 3))],
                              ),
                              child: Text('$displayIndex', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasMissingFields)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: cs.errorContainer, borderRadius: BorderRadius.circular(8), border: Border.all(color: cs.error)),
                    child: Text(
                      "⚠ Missing: ${missingFields.join(', ')}",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(color: cs.error, fontWeight: FontWeight.w600, fontSize: detailFontSize),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String name, String id, List<Catid> properties) {
    final sortedProperties = List<Catid>.from(properties)..sort((a, b) => b.id.compareTo(a.id));

    if (sortedProperties.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  "No future properties found for this field worker.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SeeAll_FutureProperty(number: id))),
                child: const Text('See All →', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 420,
          child: ListView.builder(
            controller: _horizontalControllers[id],
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: sortedProperties.length,
            itemBuilder: (context, i) {
              final property = sortedProperties[i];
              _cardKeys[property.id.toString()] ??= GlobalKey();
              return SizedBox(
                width: 340,
                child: _buildCard(property, sortedProperties.length - i),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = _location.toLowerCase();
    final post = _post.toLowerCase();
    final isAdmin = post == "administrator";

    final List<Map<String, String>> workersToShow = isAdmin
        ? fieldWorkers
        : fieldWorkers.where((fw) {
      final nameLower = fw['name']!.toLowerCase();
      if (loc.contains("sultanpur")) {
        return nameLower.contains("sumit") ||
            nameLower.contains("ravi") ||
            nameLower.contains("faizan");
      }
      if (loc.contains("rajpur") ||
          loc.contains("chhattarpur") ||
          loc.contains("chattar")) {
        return nameLower.contains("manish") ||   // <-- Yahan "return" add kar do
            nameLower.contains("abhay");
      }
      return false;
    }).toList();

    final bool hasAccess = workersToShow.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Image.asset(AppImages.transparent, height: 40),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.blue))
          : RefreshIndicator(
        onRefresh: _fetchAndUpdateData,
        child: hasAccess
            ? ListView(
          children: workersToShow.map((fw) {
            final props = _groupedData[fw['id']] ?? [];
            return _buildSection(fw['name']!, fw['id']!, props);

          }).toList(),
        )
            : ListView(
          children: [
            const SizedBox(height: 200),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.warning, size: 60, color: Colors.orange),
                  const SizedBox(height: 20),
                  Text(
                    "No access to any field worker data.",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Location: $_location\nPost: $_post\n\nContact Administrator.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _horizontalControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }
}