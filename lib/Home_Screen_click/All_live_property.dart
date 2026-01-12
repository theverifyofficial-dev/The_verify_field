import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';

import '../Propert_verigication_Document/Show_tenant.dart';
import '../add_properties_firstpage.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_New_Property.dart';
import 'Add_RealEstate.dart';
import 'Add_image_under_property.dart';
import 'All_view_details.dart';
import 'Commercial_property_Filter.dart';
import 'Filter_Options.dart';
import 'New_Real_Estate.dart';
import 'View_All_Details.dart';

class AllLiveProperty extends StatefulWidget {
  const AllLiveProperty({super.key});

  @override
  State<AllLiveProperty> createState() => _AllLiveProperty();
}

class _AllLiveProperty extends State<AllLiveProperty> {

  List<NewRealEstateShowDateModel> _allProperties = [];
  List<NewRealEstateShowDateModel> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _number = '';
  int propertyCount = 0;
  String? selectedLabel;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();

    final baseList = applyRoleBasedFilter(_allProperties);


    final filtered = baseList.where((item) {
      final values = [
        item.pId?.toString(),
        item.locations,
        item.ownerName,
        item.ownerNumber,
        item.careTakerName,
        item.careTakerNumber,
        item.buyRent,
        item.apartmentAddress,
        item.fieldWorkerAddress,
        item.fieldWorkerName,
        item.fieldWorkerNumber,
        item.bhk?.toString(),
        item.floor?.toString(),
        item.typeOfProperty,
        item.flatNumber?.toString(),
        item.sId?.toString(),
        item.sourceId?.toString(),
        item.showPrice?.toString(),
      ];

      return values.any(
            (v) => v != null && v.toLowerCase().contains(query),
      );
    }).toList();


    setState(() {
      _filteredProperties = filtered;
      propertyCount = filtered.length;
    });
  }

  Future<List<NewRealEstateShowDateModel>> fetchData(String number) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate_for_website/show_api_main_realestate_all_data.php?all=1",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("HTTP ${response.statusCode}: ${response.body}");
    }

    final decoded = json.decode(response.body);

    final raw = decoded is Map<String, dynamic> ? decoded['data'] : decoded;

    final List<Map<String, dynamic>> listResponse;
    if (raw is List) {
      listResponse = raw.map((e) => Map<String, dynamic>.from(e)).toList();
    } else if (raw is Map) {
      listResponse = [Map<String, dynamic>.from(raw)];
    } else {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate_for_website/show_api_main_realestate_all_data.php?all=1",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
      );
      listResponse = const [];
    }

    int _asInt(dynamic v) =>
        v is int ? v : (int.tryParse(v?.toString() ?? "0") ?? 0);

    listResponse.sort((a, b) => _asInt(b['P_id']).compareTo(_asInt(a['P_id'])));

    return listResponse
        .map((data) => NewRealEstateShowDateModel.fromJson(data))
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_onSearchChanged);
    _loaduserdata(); // ONLY THIS
  }

  final Map<String, List<String>> fieldWorkersByLocation = {
    "sultanpur": [
      "ravi kumar",
      "faizan khan",
      "sumit",
    ],
    "chhattarpur_group": [
      "abhay",
      "manish",
    ],
  };

  String _name = '';
  String _location = '';
  String _aadhar = '';
  Future<void> _loaduserdata() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';
    _name = prefs.getString('name') ?? '';
    _location = prefs.getString('location') ?? '';
    _aadhar = prefs.getString('post') ?? '';
    print("Loaded Name: $_name");
    print("Loaded Number: $_number");
    print("Loaded location: $_location");
    print("Loaded Aadhar: $_aadhar");
    await _fetchProperties();
  }

  bool get isAdmin => _aadhar.toLowerCase() == "admin";
  bool get isSubAdmin => !isAdmin;


  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);

    try {
      final data = await fetchData(_number);

      final filtered = applyRoleBasedFilter(data);


      setState(() {
        _allProperties = data;
        _filteredProperties = filtered;
        propertyCount = filtered.length;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData("");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  List<NewRealEstateShowDateModel> applyRoleBasedFilter(
      List<NewRealEstateShowDateModel> list,
      ) {
    // 🔥 ADMIN → SEE EVERYTHING
    if (isAdmin) return list;

    // 🔥 SUB ADMIN RULES
    return list.where((p) {
      final location = (p.locations ?? '').toLowerCase();
      final worker = (p.fieldWorkerName ?? '').toLowerCase();

      // 🟢 SULTANPUR → ALL FIELD WORKERS
      if (location.contains("sultanpur")) {
        return true;
      }

      // 🔵 OTHER LOCATIONS → ONLY ABHAY & MANISH
      return worker.contains("abhay") || worker.contains("manish");
    }).toList();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: Image.asset(AppImages.loader, height: 50,))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              keyboardType: TextInputType.visiblePassword,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search properties',
                hintStyle: TextStyle(
                  color: Theme.of(context).hintColor,
                  fontSize: 16,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.8),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(
                    Icons.clear_rounded,
                    color: Theme.of(context).iconTheme.color?.withOpacity(0.6),
                  ),
                  onPressed: () => _searchController.clear(),
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 1.5,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          // if (propertyCount > 0 && _isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "Total : $propertyCount",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ],
              ),
            ),
          _filteredProperties.isEmpty
              ? Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    "No properties found",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Try a different search term",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
              : Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchProperties,
              child: ListView.builder(
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = _filteredProperties[index];

                  final Map<String, String?> fields = {
                    "Images": property.propertyPhoto,
                    "Owner Name": property.ownerName,
                    "Owner Number": property.ownerNumber,
                    "Caretaker Name": property.careTakerName,
                    "Caretaker Number": property.careTakerNumber,
                    "Place": property.locations,
                    "Buy/Rent": property.buyRent,
                    "Property Name/Address": property.apartmentAddress,
                    "Property Address (Fieldworker)": property.fieldWorkerAddress,
                    "Field Worker Name": property.fieldWorkerName,
                    "Field Worker Number": property.fieldWorkerNumber,
                    "Current Date": property.currentDates,
                    "Longitude": property.longitude,
                    "Latitude": property.latitude,
                    "Road Size": property.roadSize,
                    "Metro Distance": property.metroDistance,
                    "Metro Name": property.highwayDistance,
                    "Main Market Distance": property.mainMarketDistance,
                    "Age of Property": property.ageOfProperty,
                    "Lift": property.lift,
                    "Parking": property.parking,
                    "Total Floor": property.totalFloor,
                    "Residence/Commercial": property.typeOfProperty,
                    "Facility": property.facility,
                    "Video": property.video,
                  };

                  final missingFields = fields.entries
                      .where((entry) => _blank(entry.value))
                      .map((entry) => entry.key)
                      .toList();

                  final hasMissingFields = missingFields.isNotEmpty;

                  return _buildCard(property, missingFields, hasMissingFields, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _blank(String? s) => s == null || s.trim().isEmpty;

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
      case Icons.king_bed:
        return Colors.pink;
      case Icons.real_estate_agent_outlined:
        return Colors.amber;
      case Icons.currency_rupee:
        return Colors.green;
      case Icons.person:
        return Colors.deepPurple;
      case Icons.room:
        return Colors.teal;
      default:
        return cs.primary;
    }
  }

  Widget _buildImageSection({
    required String? imageUrl,
    required ColorScheme cs,
    required ThemeData theme,
    required String? buyRent,
    required double imageHeight,
    required bool isTablet,
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

  Widget _buildCard(NewRealEstateShowDateModel property, List<String> missingFields, bool hasMissingFields, BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenWidth < 400;
    final isDarkMode = theme.brightness == Brightness.dark;

    final double cardPadding = (screenWidth * 0.02).clamp(6.0, 16.0);
    final double titleFontSize = isTablet ? 18 : 14;
    final double detailFontSize = isTablet ? 13 : 12;
    final double imageH = (screenHeight * 0.28).clamp(150.0, 250.0);

    final Widget imageSection = _buildImageSection(
      imageUrl: property.propertyPhoto,
      cs: cs,
      theme: theme,
      buyRent: property.buyRent,
      imageHeight: imageH,
      isTablet: isTablet,
    );

    final Widget livePropertyIdRow = _DetailRow(
      icon: Icons.numbers,
      label: 'Live Property ID',
      value: property.pId?.toString() ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    );

    final List<Widget> detailRows = [];

    if ((property.locations ?? '').isNotEmpty) {
      detailRows.add(_DetailRow(
        icon: Icons.location_on,
        label: '',
        value: property.locations!,
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
      icon: Icons.king_bed,
      label: '',
      value: property.bhk?.toString() ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    detailRows.add(_DetailRow(
      icon: Icons.layers,
      label: '',
      value: property.floor?.toString() ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    detailRows.add(_DetailRow(
      icon: Icons.apartment,
      label: '',
      value: property.typeOfProperty ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    detailRows.add(_DetailRow(
      icon: Icons.format_list_numbered,
      label: 'Flat No',
      value: property.flatNumber?.toString() ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    detailRows.add(_DetailRow(
      icon: Icons.numbers,
      label: 'Building ID',
      value: property.sId?.toString() ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    detailRows.add(_DetailRow(
      icon: Icons.numbers,
      label: 'Building Flat ID',
      value: property.sourceId?.toString() ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    detailRows.add(_DetailRow(
      icon: Icons.person,
      label: 'Added By',
      value: property.fieldWorkerName ?? 'N/A',
      theme: theme,
      getIconColor: _getIconColor,
      fontSize: detailFontSize,
      fontWeight: FontWeight.bold,
    ));

    final Widget leftColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        imageSection,
        SizedBox(height: isTablet ? 8 : 6),
        livePropertyIdRow,
        SizedBox(height: isTablet ? 12 : 8),
      ],
    );

    final Widget rightColumn = Padding(
      padding: EdgeInsets.only(top: isTablet ? 16.0 : 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.apartmentAddress ?? property.fieldWorkerAddress ?? property.locations ?? 'No Title',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: isTablet ? 12 : 8),
          ...detailRows,
          const Spacer(),
        ],
      ),
    );

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: GestureDetector(
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setInt('id_Building', property.pId ?? 0);
          prefs.setString('id_Longitude', property.longitude ?? '');
          prefs.setString('id_Latitude', property.latitude ?? '');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AllViewDetails(id: property.pId ?? 0),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.zero,
          elevation: isDarkMode ? 0 : 4,
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
                            flex: isSmallScreen ? 1 : (isTablet ? 2 : 2),
                            child: leftColumn,
                          ),
                          SizedBox(width: isTablet ? 16 : 12),
                          Expanded(
                            flex: isSmallScreen ? 1 : (isTablet ? 3 : 3),
                            child: rightColumn,
                          ),
                        ],
                      ),
                    ),
                    if (hasMissingFields)
                      Padding(
                        padding: const EdgeInsets.only(top: 6.0),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(isTablet ? 6 : 4),
                          decoration: BoxDecoration(
                            color: cs.errorContainer,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: cs.error),
                          ),
                          child: Text(
                            "⚠ Missing: ${missingFields.join(', ')}",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: cs.error,
                              fontWeight: FontWeight.w600,
                              fontSize: detailFontSize - 1,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 14,
            color: getIconColor(icon, theme),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.1,
                  color: cs.onSurface.withOpacity(0.70),
                  fontSize: fontSize ?? 12,
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

Widget _buildFeatureItem({
  required BuildContext context,
  required String text,
  required Color borderColor,
  IconData? icon,
  Color? backgroundColor,
  Color? textColor,
  Color? shadowColor,
}) {
  final width = MediaQuery.of(context).size.width;

  double fontSize = width < 350 ? 10 : (width < 500 ? 12 : 14);
  double horizontalPadding = width < 350 ? 8 : (width < 500 ? 12 : 14);
  double verticalPadding = width < 350 ? 6 : (width < 500 ? 8 : 12);
  double iconSize = width < 350 ? 14 : (width < 500 ? 16 : 18);

  return Container(
    padding: EdgeInsets.symmetric(
      horizontal: horizontalPadding,
      vertical: verticalPadding,
    ),
    margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.transparent,
      border: Border.all(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? borderColor).withOpacity(0.10),
          blurRadius: 6,
          spreadRadius: 2,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: iconSize,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : (textColor ?? Colors.black),
          ),
          const SizedBox(width: 4),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            fontFamily: "Poppins",
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : (textColor ?? Colors.black),
          ),
        ),
      ],
    ),
  );
}