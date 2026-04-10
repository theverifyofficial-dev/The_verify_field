import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../../model/future_property_model.dart';
import '../../ui_decoration_tools/app_images.dart';
import 'Future_Property_Details.dart';


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
      padding: const EdgeInsets.only(bottom: 10.0), // Increased bottom padding for more space between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: getIconColor(icon, theme),
          ),
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
                        fontFamily: "PoppinsMedium",
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.8),
                        fontSize: fontSize ?? 13,
                      ),
                    ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontFamily: "PoppinsMedium",
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

class SeeAll_FutureProperty extends StatefulWidget {
  final String number;
  final String? subId;
  final String? flatId;
  final String? fwName;
  final String? highlightFlatId;
  const SeeAll_FutureProperty({
    super.key,
    required this.number,
    this.subId,
    this.flatId,
    this.fwName,
    this.highlightFlatId,
  });
  @override
  State<SeeAll_FutureProperty> createState() => _SeeAll_FuturePropertyState();
}

class _SeeAll_FuturePropertyState extends State<SeeAll_FutureProperty> {
  String? _highlightedId;

  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  int? totalFlats;
  int liveFlats = 0;
  int bookFlats = 0;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isFetchingMore = false;
  final ScrollController _scrollController = ScrollController();
  String selectedLabel = 'All';
  List<PropertyModel> _searchResults = [];
  bool _isSearching = false;

  int totalRecordsFromApi = 0;
  List<PropertyModel> _properties = [];

  @override
  void initState() {
    super.initState();

    selectedLabel = "All";
    _highlightedId = widget.highlightFlatId;
    _searchController.addListener(_onSearchChanged);

    _scrollController.addListener(() {
      if (_isSearching) return;

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _fetchNextPage();
      }
    });
    fetchData(reset: true).then((_) => _scrollToHighlighted());
    fetchTotalFlats();
    fetchFlatsStatus();
    print("Widget number: ${widget.number}");
  }

  void _scrollToHighlighted() {
    if (_highlightedId == null) return;

    final index = _properties.indexWhere(
          (p) => p.id.toString() == _highlightedId,
    );

    print("🔍 Highlight index: $index for id: $_highlightedId");

    if (index == -1) return;

    final double itemHeight = 450.0; // fixed height better hai

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // 👈 ADD THIS
      _scrollController.animateTo(
        index * itemHeight,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOut,
      );

      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _highlightedId = null);
      });
    });
  }

  Future<void> fetchData({bool reset = false}) async {
    if (_isFetchingMore) return;
    if (!_hasMore && !reset) return;

    if (reset) {
      _currentPage = 1;
      _hasMore = true;
      _properties.clear();
    }

    setState(() {
      _isFetchingMore = true;
      if (reset) _isLoading = true;
    });

    String getFilterKey(String label) {
      switch (label) {
        case 'All':
          return 'all';
        case 'Buy':
          return 'buy';
        case 'Rent':
          return 'rent';
        case 'Commercial':
          return 'commercial';
        case 'Live':
          return 'live';
        case 'Unlive':
          return 'unlive';
        case 'Missing Field':
          return 'missing';
        case 'Empty Building':
          return 'empty';
        default:
          return 'all';
      }
    }

    final filterParam = getFilterKey(selectedLabel);

    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/future_property_pagination.php"
          "?fieldworkarnumber=${widget.number}"
          "&filter=$filterParam"
          "&page=$_currentPage"
          "&limit=10",
    );

    // print("📡 PAGINATION API CALL:");
    // print(url.toString());

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      if (body["pagination"] != null) {
        totalRecordsFromApi =
            body["pagination"]["total_records"] ?? 0;
      }

      if (body["status"] == "success") {
        List data = body["data"];

        final newItems =
        data.map<PropertyModel>((e) => PropertyModel.FromJson(e)).toList();

        setState(() {
          _properties.addAll(newItems);
          _currentPage++;
          _hasMore = newItems.isNotEmpty;
        });
      }
    }

    setState(() {
      _isFetchingMore = false;
      _isLoading = false;
    });
  }

  Future<void> _fetchNextPage() async {
    await fetchData();
  }


  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    _debounce?.cancel();

    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      final query = _searchController.text.trim();

      if (query.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchResults.clear();
        });

        await fetchData(reset: true);
        return;
      }

      setState(() {
        _isSearching = true;
        _isLoading = true;
      });

      final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/search_in_future_builing.php"
            "?fieldworkarnumber=${widget.number}"
            "&search=$query",
      );

      // print("🔎 SEARCH API CALL:");
      // print(url.toString());

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body["status"] == "success") {
          final List data = body["data"];

          setState(() {
            _searchResults =
                data.map<PropertyModel>((e) => PropertyModel.FromJson(e)).toList();

            totalRecordsFromApi = body["total_results"] ?? data.length;
          });
        }
      }

      setState(() {
        _isLoading = false;
      });
    });
  }

  bool _blank(String? s) => s == null || s.trim().isEmpty;

  List<String> _missingFieldsFor(PropertyModel i) {
    final m = <String>[];
    final checks = <String, String?>{
      "Image": i.images,
      "Owner Name": i.ownerName,
      "Owner Number": i.ownerNumber,
      "Caretaker Name": i.caretakerName,
      "Caretaker Number": i.caretakerNumber,
      "Place": i.place,
      "Buy/Rent": i.buyRent,
      "Property Name/Address": i.propertyNameAddress,
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

  bool _hasMissing(PropertyModel i) => _missingFieldsFor(i).isNotEmpty;
  bool _statsLoading = true;

  Future<void> fetchFlatsStatus() async {
    try {
      final url = Uri.parse(
        'https://verifyrealestateandservices.in/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=${widget.number}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        int book = 0;
        int live = 0;

        if (data is List) {
          for (var item in data) {
            if (item['live_unlive'] == "Book") {
              book = int.tryParse(item['subid'].toString()) ?? 0;
            } else if (item['live_unlive'] == "Live") {
              live = int.tryParse(item['subid'].toString()) ?? 0;
            }
          }
        }

        if (mounted) {
          setState(() {
            bookFlats = book;
            liveFlats = live;
            _statsLoading = false; // 🔥 IMPORTANT
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _statsLoading = false;
        });
      }
    }
  }
  Future<void> fetchTotalFlats() async {
    try {
      final url = Uri.parse(
        'https://verifyrealestateandservices.in/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=${widget.number}',
      );

      final response = await http.get(url);
      // print("TotalFlats Response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        int total = 0;

        if (data is List && data.isNotEmpty) {
          total = int.tryParse(data[0]['subid'].toString()) ?? 0;
        }

        setState(() {
          totalFlats = total;
          _statsLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching total flats: $e");
      setState(() {
        _statsLoading = false;
      });
    }
  }

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
    required PropertyModel property,
    required List<String> images,
    required ColorScheme cs,
    required ThemeData theme,
    required double imageHeight,
    required double multiImgHeight,
    required bool isTablet,
  }) {
    final int liveCount = property.liveFlats ?? 0;
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
          const SizedBox(height: 6),
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

  List<String> _buildMultipleImages(PropertyModel p) {
    final List<String> imgs = [];
    if (p.images != null && p.images!.isNotEmpty) {
      imgs.add('https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${p.images}');
    }
    return imgs;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final screenHeight = size.height;
    final screenWidth = size.width;
    return Scaffold(
        body:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,bottom: 16,top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔍 Search TextField
                  Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                          colors: [Colors.grey[100]!, Colors.grey[50]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 10,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: const TextStyle(
                          fontFamily: "PoppinsMedium",
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search properties...',
                          hintStyle: TextStyle(
                              fontFamily: "PoppinsMedium",
                              color: Colors.grey.shade600, fontSize: 16),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Icon(Icons.search_rounded, color: Colors.grey.shade700, size: 24),
                          ),
                          suffixIcon: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _searchController.text.isNotEmpty
                                ? IconButton(
                              key: const ValueKey('clear'),
                              icon: Icon(Icons.close_rounded, color: Colors.grey.shade700, size: 22),
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _isSearching = false;
                                  _searchResults.clear();
                                });
                              },
                            )
                                : const SizedBox(key: ValueKey('empty')),
                          ),
                          filled: true,
                          fillColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (_) {},
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 🔘 Filter Buttons Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ['All','Buy','Rent','Commercial','Live','Unlive','Missing Field','Empty Building']
                          .map((label) {
                        final isSelected = label == selectedLabel;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (selectedLabel == label) return;
                              setState(() {
                                selectedLabel = label;
                                _currentPage = 1;
                                _hasMore = true;
                                _properties.clear();
                              });
                              await fetchData();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (totalRecordsFromApi > 0)
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Theme.of(context).brightness==Brightness.dark?Colors.transparent: Colors.grey,width: 1.5),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                                const SizedBox(width: 6),
                                Text(
                                  "$totalRecordsFromApi building found",
                                  style: const TextStyle(
                                      fontFamily: "PoppinsMedium",
                                      fontWeight: FontWeight.w500, fontSize: 14, color: Colors.black),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () async {
                                    _searchController.clear();
                                    selectedLabel = "All";
                                    await fetchData(reset: true);
                                  },
                                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          _statsLoading
                              ? const SizedBox.shrink()
                              : Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  "Total Flats: ${totalFlats ?? 0}",
                                  style: const TextStyle(
                                      fontFamily: "PoppinsMedium",
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          _statsLoading
                              ? const SizedBox.shrink()
                              : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Live Flats: $liveFlats",
                                      style: TextStyle(
                                          fontFamily: "PoppinsMedium",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Rent Out: $bookFlats",
                                      style: const TextStyle(
                                          fontFamily: "PoppinsMedium",
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            // 📌 Property List
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : (_isSearching ? _searchResults : _properties).isEmpty
                  ? const Center(
                child: Text(
                  "No Building Found!",
                  style: TextStyle(
                    fontFamily: "PoppinsMedium",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
                  : ListView.builder(
                controller: _scrollController,
                itemCount: (_isSearching ? _searchResults.length : _properties.length) +
                    (_isFetchingMore && !_isSearching ? 1 : 0),
                itemBuilder: (context, index) {
                  final currentList = _isSearching ? _searchResults : _properties;

                  if (!_isSearching && index == _properties.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  final property = currentList[index];

                  // ✅ HIGHLIGHT CHECK
                  final bool isHighlighted =
                      _highlightedId != null &&
                          property.id.toString() == _highlightedId;

                  final displayIndex = _properties.length - index;
                  final theme = Theme.of(context);
                  final cs = theme.colorScheme;
                  final isDark = theme.brightness == Brightness.dark;
                  final screenHeight = MediaQuery.of(context).size.height;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final images = _buildMultipleImages(property);
                  final double cardPadding = (screenWidth * 0.03).clamp(8.0, 20.0);
                  final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
                  final double titleFontSize = isTablet ? 20 : 16;
                  final double detailFontSize = isTablet ? 14 : 13;
                  final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
                  final double multiH = imageH * 0.8;
                  final missingFields = _missingFieldsFor(property);
                  final hasMissingFields = missingFields.isNotEmpty;
                  final loggValue2 = property.totalFlats;

                  final Widget totalDetail = _DetailRow(
                    icon: Icons.format_list_numbered,
                    label: 'Total Flats',
                    value: '${property.totalFlats}',
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
                    property: property,
                    images: images,
                    cs: cs,
                    theme: theme,
                    imageHeight: imageH,
                    multiImgHeight: multiH,
                    isTablet: isTablet,
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
                      SizedBox(height: isTablet ? 20 : 12),
                      totalDetail,
                    ],
                  );
                  final Widget rightColumn = Padding(
                    padding: EdgeInsets.only(top: isTablet ? 24.0 : 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          property.propertyAddressForFieldworker ?? property.propertyNameAddress ?? property.place ?? 'No Title',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: titleFontSize,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        ...detailRows,
                        const Spacer(),
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

                  // ✅ AnimatedContainer wraps Card for highlight effect
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    margin: EdgeInsets.symmetric(horizontal: horizontalMargin, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: isHighlighted
                          ? Border.all(color: Colors.amber, width: 2.5)
                          : null,
                      boxShadow: isHighlighted
                          ? [BoxShadow(color: Colors.amber.withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]
                          : [],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Administater_Future_Property_details(
                              buildingId: property.id.toString(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        margin: EdgeInsets.zero, // ✅ margin AnimatedContainer mein hai
                        elevation: isDark ? 0 : 6,
                        color: theme.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
                                          flex: isTablet ? 2 : 2,
                                          child: leftColumn,
                                        ),
                                        SizedBox(width: isTablet ? 20 : 16),
                                        Expanded(
                                          flex: isTablet ? 3 : 3,
                                          child: rightColumn,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (hasMissingFields)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.all(isTablet ? 8 : 6),
                                        decoration: BoxDecoration(
                                          color: cs.errorContainer,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: cs.error),
                                        ),
                                        child: Text(
                                          "⚠ Missing: ${missingFields.join(', ')}",
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: cs.error,
                                            fontWeight: FontWeight.w600,
                                            fontSize: detailFontSize,
                                          ),
                                          maxLines: 4,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: cs.primary.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '$displayIndex',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        )
    );
  }
}