import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../../ui_decoration_tools/app_images.dart';
import 'Future_Property_Details.dart';

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
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.8),
                        fontSize: fontSize ?? 13,
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

class SeeAll_FutureProperty extends StatefulWidget {
  final String number;
  const SeeAll_FutureProperty({super.key, required this.number});

  @override
  State<SeeAll_FutureProperty> createState() => _SeeAll_FuturePropertyState();
}

class _SeeAll_FuturePropertyState extends State<SeeAll_FutureProperty> {
  String _number = '';
  final Map<int, int> _liveCountMap = {}; // subid -> live count
  final Map<int, String> _totalFlatsMap = {}; // subid -> total flats count as String
  bool _prefetching = false;
  List<Catid> _allProperties = [];
  List<Catid> _filteredProperties = [];
  Timer? _debounce;
  final TextEditingController _searchController = TextEditingController();
  String selectedLabel = '';
  int propertyCount = 0;
  bool _isLoading = true;
  bool isLoading = true;
  int? totalFlats;
  int liveFlats = 0;
  int bookFlats = 0;
  bool _prefetchingEmpty = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata(); // this is cheap
    // Boot once: fetch data + counters in parallel,
    // but keep loader on screen for at least 2 seconds.
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // start both: a 2s delay and your real fetches
    final minSplash = Future.delayed(const Duration(seconds: 2));
    final dataFetch = fetchData().then((_) => _prefetchAllPropertyData());
    // wait for both to complete
    await Future.wait([minSplash, dataFetch, fetchTotalFlats(), fetchFlatsStatus()]);
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _prefetchAllPropertyData() async {
    if (_allProperties.isEmpty) return;
    final futures = _allProperties.map((p) async {
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

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();
      List<Catid> filtered;
      if (query.isEmpty) {
        filtered = List.from(_allProperties);
        selectedLabel = ''; // optional reset
      } else {
        // 🔍 Normal search
        filtered = _allProperties.where((item) {
          return (item.id.toString()).toLowerCase().contains(query) ||
              (item.ownerName ?? '').toLowerCase().contains(query) ||
              (item.caretakerName ?? '').toLowerCase().contains(query) ||
              (item.place ?? '').toLowerCase().contains(query) ||
              (item.buyRent ?? '').toLowerCase().contains(query) ||
              (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
              (item.selectBhk ?? '').toLowerCase().contains(query) ||
              (item.floorNumber ?? '').toLowerCase().contains(query) ||
              (item.squareFeet ?? '').toLowerCase().contains(query) ||
              (item.propertyNameAddress ?? '').toLowerCase().contains(query) ||
              (item.residenceCommercial ?? '').toLowerCase().contains(query) ||
              (item.ownerNumber ?? '').toLowerCase().contains(query) ||
              (item.ownerVehicleNumber ?? '').toLowerCase().contains(query) ||
              (item.buildingInformationFacilities ?? '').toLowerCase().contains(query) ||
              (item.propertyAddressForFieldworker ?? '').toLowerCase().contains(query) ||
              (item.yourAddress ?? '').toLowerCase().contains(query) ||
              (item.fieldWorkerName ?? '').toLowerCase().contains(query) ||
              (item.fieldWorkerNumber ?? '').toLowerCase().contains(query) ||
              (item.currentDate ?? '').toLowerCase().contains(query) ||
              (item.longitude ?? '').toLowerCase().contains(query) ||
              (item.latitude ?? '').toLowerCase().contains(query) ||
              (item.roadSize ?? '').toLowerCase().contains(query) ||
              (item.metroDistance ?? '').toLowerCase().contains(query) ||
              (item.metroName ?? '').toLowerCase().contains(query) ||
              (item.mainMarketDistance ?? '').toLowerCase().contains(query) ||
              (item.ageOfProperty ?? '').toLowerCase().contains(query) ||
              (item.lift ?? '').toLowerCase().contains(query) ||
              (item.parking ?? '').toLowerCase().contains(query) ||
              (item.totalFloor ?? '').toLowerCase().contains(query) ||
              (item.facility ?? '').toLowerCase().contains(query);
        }).toList();
      }
      setState(() {
        _filteredProperties = filtered;
        propertyCount = filtered.length;
      });
    });
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

  // ✅ Fetch API only once
  Future<void> fetchData() async {
    try {
      final url = Uri.parse(
          "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=${widget.number}");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        List listResponse = json.decode(response.body);
        listResponse.sort((a, b) => b['id'].compareTo(a['id']));
        setState(() {
          _allProperties = listResponse.map((data) => Catid.fromJson(data)).toList();
          _filteredProperties = _allProperties;
          propertyCount = _allProperties.length;
          _isLoading = false;
        });
      } else {
        throw Exception("Unexpected error occurred!");
      }
    } catch (e) {
      debugPrint("API Error: $e");
      setState(() => _isLoading = false);
    }
  }

  Future<void> fetchFlatsStatus() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=${widget.number}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;
        int book = 0;
        int live = 0;
        for (var item in data) {
          if (item['live_unlive'] == "Book") {
            book = (item['logs'] as num?)?.toInt() ?? 0;
          } else if (item['live_unlive'] == "Live") {
            live = (item['logs'] as num?)?.toInt() ?? 0;
          }
        }
        setState(() {
          bookFlats = book;
          liveFlats = live;
          isLoading = false;
        });
      } else {
        setState(() {
          bookFlats = 0;
          liveFlats = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching flats status: $e");
      setState(() {
        bookFlats = 0;
        liveFlats = 0;
        isLoading = false;
      });
    }
  }

  Future<void> fetchTotalFlats() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=${widget.number}',
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // API returns a list, take the first element's logg
        final logg = data.isNotEmpty ? (data[0]['logg'] as num?)?.toInt() : 0;
        setState(() {
          totalFlats = logg;
          isLoading = false;
        });
      } else {
        setState(() {
          totalFlats = 0;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        totalFlats = 0;
        isLoading = false;
      });
      print("Error fetching total flats: $e");
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

  List<String> _buildMultipleImages(Catid p) {
    final List<String> imgs = [];
    if (p.images != null && p.images!.isNotEmpty) {
      imgs.add('https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${p.images}');
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
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          surfaceTintColor: Colors.black,
          title: Image.asset(AppImages.verify, height: 75),
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Row(
              children: [
                SizedBox(width: 3),
                Icon(
                  PhosphorIcons.caret_left_bold,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ),
        body: _isLoading
            ? Center(child: Lottie.asset(AppImages.loadingHand, height: 400),)
            :
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
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
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search properties...',
                          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
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
                                selectedLabel = '';
                                _filteredProperties = _allProperties;
                                propertyCount = _allProperties.length;
                                setState(() {});
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
                        // ✅ Complete search + filter logic
                        onChanged: (_) {}, // Use listener for debounced search
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // 🔘 Filter Buttons Row
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: ['Buy', 'Rent', 'Commercial', 'Live', 'Unlive', 'Empty Field','Empty Building']
                          .map((label) {
                        final isSelected = label == selectedLabel;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Toggle off
                              if (selectedLabel == label) {
                                setState(() {
                                  selectedLabel = '';
                                  _searchController.clear();
                                  _filteredProperties = List.from(_allProperties);
                                  propertyCount = _filteredProperties.length;
                                });
                                return;
                              }
                              // If Live/Unlive is requested, make sure we have the cache first.
                              if (label == 'Live' || label == 'Unlive') {
                                if (_prefetching) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Fetching live status… try again in a moment')),
                                  );
                                  return;
                                }
                                if (_liveCountMap.isEmpty) {
                                  setState(() => _prefetching = true);
                                  await _prefetchAllPropertyData();
                                  if (!mounted) return;
                                  setState(() => _prefetching = false);
                                }
                              }
                              List<Catid> filtered = List.from(_allProperties);
                              switch (label) {
                                case 'Commercial':
                                  filtered = filtered
                                      .where((item) =>
                                  (item.residenceCommercial?.toLowerCase() ?? '') ==
                                      'commercial')
                                      .toList();
                                  break;
                                case 'Buy':
                                case 'Rent':
                                  filtered = filtered
                                      .where((item) =>
                                  (item.buyRent?.toLowerCase() ?? '') ==
                                      label.toLowerCase())
                                      .toList();
                                  break;
                                case 'Live':
                                // Only items explicitly marked live in the cache
                                  filtered = filtered
                                      .where((item) => (_liveCountMap[item.id] ?? 0) > 0)
                                      .toList();
                                  break;
                                case 'Unlive':
                                // Everything not explicitly live (false or null)
                                  filtered = filtered
                                      .where((item) => (_liveCountMap[item.id] ?? 0) == 0)
                                      .toList();
                                  break;
                                case 'Empty Field':
                                  filtered = _allProperties.where(_hasMissing).toList();
                                  break;
                                case 'Empty Building':
                                  if (_prefetchingEmpty) {
                                    debugPrint('Checking empty buildings… try again');
                                    break;
                                  }
                                  if (_totalFlatsMap.isEmpty) {
                                    setState(() => _prefetchingEmpty = true);
                                    await _prefetchAllPropertyData();
                                    if (!mounted) return;
                                    setState(() => _prefetchingEmpty = false);
                                  }
                                  filtered = filtered.where((item) {
                                    return (_totalFlatsMap[item.id] ?? '0') == '0';
                                  }).toList();
                                  break;
                                default:
                                  break;
                              }
                              setState(() {
                                selectedLabel = label;
                                // DO NOT write the label into the search box (it triggers onChanged and wipes your filter)
                                // _searchController.text = label; <-- removed on purpose
                                _filteredProperties = filtered;
                                propertyCount = filtered.length;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                              shape:
                              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
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
                  // ✅ Property count pill
                  if (propertyCount > 0)
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
                                  "$propertyCount building found",
                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14,color: Colors.black),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _searchController.clear();
                                      selectedLabel = '';
                                      _filteredProperties = _allProperties;
                                      propertyCount = _allProperties.length; // ✅ reset to total
                                    });
                                  },
                                  child: const Icon(Icons.close, size: 18, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          isLoading
                              ? const SizedBox.shrink()
                              : Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
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
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          isLoading
                              ? const SizedBox.shrink()
                              : Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              // Live Flats Container
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Live Flats: $liveFlats",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 6),
                              // Book Flats Container
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      "Rent Out: $bookFlats",
                                      style: const TextStyle(
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
                  : _filteredProperties.isEmpty
                  ? const Center(
                child: Text(
                  "No Building Found!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
              )
                  : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = _filteredProperties[index];
                  final displayIndex = _filteredProperties.length - index;
                  final theme = Theme.of(context);
                  final cs = theme.colorScheme;
                  final isDark = theme.brightness == Brightness.dark;
                  final screenHeight = MediaQuery.of(context).size.height;
                  final screenWidth = MediaQuery.of(context).size.width;
                  final status = {
                    "loggValue2": _totalFlatsMap[property.id] ?? '0',
                    "liveCount": _liveCountMap[property.id] ?? 0,
                  };
                  final images = _buildMultipleImages(property);
                  final double cardPadding = (screenWidth * 0.03).clamp(8.0, 20.0);
                  final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
                  final double titleFontSize = isTablet ? 20 : 16; // Increased from 12 to 16 for phones
                  final double detailFontSize = isTablet ? 14 : 13;
                  final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
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
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              Administater_Future_Property_details(
                                buildingId: property.id.toString(),
                              ),
                        ),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: horizontalMargin,
                          vertical: 4
                      ),
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
                          // Top right count number badge
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
                  );
                },
              ),
            ),
          ],
        )
    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }
}