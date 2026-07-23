import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/app_images.dart';
import 'All_view_details.dart';
import 'New_Real_Estate.dart';

class AllLiveProperty extends StatefulWidget {
  const AllLiveProperty({super.key});

  @override
  State<AllLiveProperty> createState() => _AllLiveProperty();
}

class _AllLiveProperty extends State<AllLiveProperty> {

  List<NewRealEstateShowDateModel> _allProperties = [];
  List<NewRealEstateShowDateModel> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();

  bool _filterNoVideo = false;
  bool _filterIncompleteData = false;

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

  void _applyFilters() {
    final query = _searchController.text.toLowerCase().trim();
    var list = applyRoleBasedFilter(_allProperties);

    if (_filterNoVideo) {
      list = list.where((p) => _blank(p.video)).toList();
    }

    if (_filterIncompleteData) {
      list = list.where((p) => _missingFieldsFor(p).isNotEmpty).toList();
    }

    if (query.isNotEmpty) {
      list = list.where((item) {
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
        return values.any((v) => v != null && v.toLowerCase().contains(query));
      }).toList();
    }

    setState(() {
      _filteredProperties = list;
      propertyCount = list.length;
    });
  }

  Future<List<NewRealEstateShowDateModel>> fetchData(String number) async {
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate_for_website/show_api_main_realestate_all_data.php?all=1",
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
      listResponse = const [];
    }

    int _asInt(dynamic v) =>
        v is int ? v : (int.tryParse(v?.toString() ?? "0") ?? 0);

    listResponse.sort((a, b) => _asInt(b['P_id']).compareTo(_asInt(a['P_id'])));

    return listResponse
        .map((data) => NewRealEstateShowDateModel.fromJson(data))
        .toList();
  }

  List<String> _missingFieldsFor(NewRealEstateShowDateModel property) {
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
    return fields.entries
        .where((e) => _blank(e.value))
        .map((e) => e.key)
        .toList();
  }

  @override
  void initState() {
    super.initState();

    _searchController.addListener(_applyFilters);
    _loaduserdata();
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
      _allProperties = data;
      _isLoading = false;
      _applyFilters();
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
    final theme = Theme.of(context);
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

          Builder(builder: (context) {
            final base = applyRoleBasedFilter(_allProperties);
            final noVideoCount = base.where((p) => _blank(p.video)).length;
            final incompleteCount = base.where((p) => _missingFieldsFor(p).isNotEmpty).length;
            final anyFilterActive = _filterNoVideo || _filterIncompleteData;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        Icon(Icons.tune_rounded, size: 14, color: theme.hintColor),
                        const SizedBox(width: 4),
                        Text(
                          'FILTERS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: theme.hintColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        _FilterToggleChip(
                          label: 'No Video',
                          count: noVideoCount,
                          icon: Icons.videocam_off_rounded,
                          color: Colors.redAccent,
                          selected: _filterNoVideo,
                          onTap: () {
                            setState(() => _filterNoVideo = !_filterNoVideo);
                            _applyFilters();
                          },
                        ),
                        const SizedBox(width: 10),
                        _FilterToggleChip(
                          label: 'Empty Data',
                          count: incompleteCount,
                          icon: Icons.warning_rounded,
                          color: Colors.orange,
                          selected: _filterIncompleteData,
                          onTap: () {
                            setState(() => _filterIncompleteData = !_filterIncompleteData);
                            _applyFilters();
                          },
                        ),
                        if (anyFilterActive) ...[
                          const SizedBox(width: 10),
                          Container(height: 24, width: 1, color: theme.dividerColor),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterNoVideo = false;
                                _filterIncompleteData = false;
                              });
                              _applyFilters();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.surfaceVariant.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.close_rounded, size: 14, color: theme.hintColor),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Clear',
                                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: theme.hintColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 4),


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

          const SizedBox(height: 4),

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



                  final missingFields = _missingFieldsFor(property);
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
            imageUrl: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/$imageUrl",
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

class _FilterToggleChip extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _FilterToggleChip({
    required this.label,
    required this.count,
    required this.icon,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: selected ? color : (isDark ? theme.colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? color : color.withOpacity(0.4),
            width: 1.4,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ]
              : [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: selected ? Colors.white : color,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : theme.textTheme.bodyMedium?.color,
                letterSpacing: 0.1,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: selected ? Colors.white.withOpacity(0.25) : color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w800,
                    color: selected ? Colors.white : color,
                  ),
                ),
              ),
            ],
          ],
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
