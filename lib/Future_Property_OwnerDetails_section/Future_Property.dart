// frontpage_futureproperty_with_tabs.dart (Responsive: Added MediaQuery-based dynamic sizing for card padding, margins, image heights, and font sizes based on screen width/height; used clamp for bounds; adjusted flex and spacings for tablets (>600px) vs phones; ensured no overflow on small screens)
// FIXED: Added automatic refresh of property statuses after returning from details page (Future_Property_details) to ensure live/unlive updates reflect immediately in the list (e.g., when marking flats as live, the badge and filters now update correctly without manual pull-to-refresh).
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_commercial_property.dart';
import 'Add_futureProperty.dart';
import 'Add_plot_property.dart';
import 'Commercial_detail.dart';
import 'Future_property_details.dart';
import 'package:intl/intl.dart';
import 'PlotShow.dart';
import 'Plot_detail.dart';
import 'commercialShow.dart';

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

  factory Catid.FromJson(Map<String, dynamic> json) {
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

// ✅ ADDED: PlotPropertyData class (with fromJson for API mapping - adjust keys if API response differs)
class PlotPropertyData {
  final int id;
  String? plotStatus;
  String? plotPrice;
  String? mainAddress;
  String? currentLocation;
  String? plotSize;
  String? roadSize;
  String? plotOpen;
  String? waterConnection;
  String? electricPrice;
  String? propertyChain;
  String? plotFrontSize;
  String? plotSideSize;
  String? ageOfProperty;
  String? propertyRent;
  String? fieldworkarName;
  String? fieldworkarNumber;
  XFile? singleImage;
  List<XFile> selectedImages = [];

  PlotPropertyData({
    required this.id,
    this.plotStatus,
    this.plotPrice,
    this.mainAddress,
    this.currentLocation,
    this.plotSize,
    this.roadSize,
    this.plotOpen,
    this.waterConnection,
    this.electricPrice,
    this.propertyChain,
    this.plotFrontSize,
    this.plotSideSize,
    this.ageOfProperty,
    this.propertyRent,
    this.fieldworkarName,
    this.fieldworkarNumber,
    this.singleImage,
    List<XFile>? selectedImages,
  }) : selectedImages = selectedImages ?? [];

  factory PlotPropertyData.fromJson(Map<String, dynamic> json) {
    // Map JSON keys to fields - adjust keys based on actual API response (e.g., check console logs)
    // Example: assuming keys like 'plot_status', 'plot_price', etc. Update as per your API.
    return PlotPropertyData(
      id: json['id'] ?? 0,
      plotStatus: json['plot_status'] ?? json['plotStatus'],
      plotPrice: json['plot_price'] ?? json['plotPrice'],
      mainAddress: json['main_address'] ?? json['mainAddress'],
      currentLocation: json['current_location'] ?? json['currentLocation'],
      plotSize: json['plot_size'] ?? json['plotSize'],
      roadSize: json['road_size'] ?? json['roadSize'],
      plotOpen: json['plot_open'] ?? json['plotOpen'],
      waterConnection: json['water_connection'] ?? json['waterConnection'],
      electricPrice: json['electric_price'] ?? json['electricPrice'],
      propertyChain: json['property_chain'] ?? json['propertyChain'],
      plotFrontSize: json['plot_front_size'] ?? json['plotFrontSize'],
      plotSideSize: json['plot_side_size'] ?? json['plotSideSize'],
      ageOfProperty: json['age_of_property'] ?? json['ageOfProperty'],
      propertyRent: json['property_rent'] ?? json['propertyRent'],
      fieldworkarName: json['fieldworkar_name'] ?? json['fieldworkarName'],
      fieldworkarNumber: json['fieldworkar_number'] ?? json['fieldworkarNumber'],
      // For images: If API returns URL strings, convert to XFile (or handle as String if needed)
      singleImage: json['single_image'] != null ? XFile(json['single_image']) : null,
      selectedImages: (json['selected_images'] as List<dynamic>?)?.map((img) => XFile(img.toString())).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'plot_status': plotStatus,
      'plot_price': plotPrice,
      'main_address': mainAddress,
      'current_location': currentLocation,
      'plot_size': plotSize,
      'road_size': roadSize,
      'plot_open': plotOpen,
      'water_connection': waterConnection,
      'electric_price': electricPrice,
      'property_chain': propertyChain,
      'plot_front_size': plotFrontSize,
      'plot_side_size': plotSideSize,
      'age_of_property': ageOfProperty,
      'property_rent': propertyRent,
      'fieldworkar_name': fieldworkarName,
      'fieldworkar_number': fieldworkarNumber,
      'single_image': singleImage?.path,
      'selected_images': selectedImages.map((img) => img.path).toList(),
    };
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

class FrontPage_FutureProperty extends StatefulWidget {
  const FrontPage_FutureProperty({super.key});

  @override
  State<FrontPage_FutureProperty> createState() => _FrontPage_FuturePropertyState();
}

class _FrontPage_FuturePropertyState extends State<FrontPage_FutureProperty>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;

  String _number = '';
  String _SUbid = '';

  List<Catid> _allProperties = [];
  List<Catid> _filteredProperties = [];
  Map<int, Map<String, dynamic>> _propertyStatuses = {};
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String selectedLabel = '';
  int propertyCount = 0;
  int? totalFlats;
  bool isLoading = true;
  int bookFlats = 0;
  int liveFlats = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(_onSearchChanged);

    _loaduserdata().then((_) {
      _refreshProperties();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();

      List<Catid> searchOn = selectedLabel.isEmpty ? _allProperties : _filteredProperties;
      List<Catid> filtered;

      if (query.isEmpty) {
        filtered = List.from(searchOn);
      } else {
        filtered = searchOn.where((item) {
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

  Future<Map<String, dynamic>> fetchPropertyStatus(int subid) async {
    try {
      final response1 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/check_live_flat_in_main_realesate?subid=$subid&live_unlive=Flat"));

      final response2 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=$subid"));

      final response3 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=$subid"));

      String loggValue1 = "Loading...";
      String loggValue2 = "Loading...";
      Color statusColor = Colors.grey;
      int liveCount = 0;

      if (response1.statusCode == 200) {
        final body = jsonDecode(response1.body);
        if (body is List && body.isNotEmpty) {
          final logg = body[0]['logg'];
          loggValue1 = logg.toString();
          statusColor = (logg == 0) ? Colors.red : Colors.green;
        }
      }

      if (response2.statusCode == 200) {
        final body = jsonDecode(response2.body);
        if (body is List && body.isNotEmpty) {
          final logg = body[0]['logg'];
          loggValue2 = logg.toString();
        }
      }

      if (response3.statusCode == 200) {
        final body3 = jsonDecode(response3.body);
        if (body3 is List && body3.isNotEmpty) {
          for (var item in body3) {
            if (item['live_unlive'] == 'Live') {
              liveCount = (item['logs'] as num?)?.toInt() ?? 0;
              break;
            }
          }
        }
      }

      return {
        "loggValue1": loggValue1,
        "loggValue2": loggValue2,
        "statusColor": statusColor,
        "liveCount": liveCount,
      };
    } catch (e) {
      return {
        "loggValue1": "Error",
        "loggValue2": "Error",
        "statusColor": Colors.grey,
        "liveCount": 0,
      };
    }
  }

  Future<void> fetchAllStatuses() async {
    if (_allProperties.isEmpty) return;

    final futures = _allProperties.map((p) => fetchPropertyStatus(p.id));
    final List<Map<String, dynamic>> results = await Future.wait(futures);

    for (int i = 0; i < _allProperties.length; i++) {
      _propertyStatuses[_allProperties[i].id] = results[i];
    }

    if (mounted) setState(() {});
  }

  Future<void> _fetchAndFilterProperties() async {
    setState(() {
      _isLoading = true;
    });

    print("FIELDWORKER NUMBER: $_number");

    try {
      var url = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=$_number",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("API Response Body: ${response.body}");

        List<dynamic> listResponse = json.decode(response.body);

        listResponse.sort((a, b) => b['id'].compareTo(a['id']));

        _allProperties = listResponse
            .map((data) => Catid.FromJson(data))
            .toList();

        _filteredProperties = _allProperties;

        setState(() {
          _isLoading = false;
        });
      } else {
        throw Exception('Unexpected error occurred!');
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshProperties() async {
    _propertyStatuses.clear();
    await _fetchAndFilterProperties();
    await fetchAllStatuses();
    await fetchFlatsStatus();
    await fetchTotalFlats();
    if (mounted) {
      setState(() {
        _filteredProperties = _allProperties;
        propertyCount = _allProperties.length;
      });
    }
  }

  Future<void> fetchFlatsStatus() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=${_number}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as List<dynamic>;

        int book = 0;
        int live = 0;

        for (var item in data) {
          if (item['live_unlive'] == "Book") {
            book = item['subid'] ?? 0;
          } else if (item['live_unlive'] == "Live") {
            live = item['subid'] ?? 0;
          }
        }

        if (mounted) {
          setState(() {
            bookFlats = book;
            liveFlats = live;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            bookFlats = 0;
            liveFlats = 0;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error fetching flats status: $e");
      if (mounted) {
        setState(() {
          bookFlats = 0;
          liveFlats = 0;
          isLoading = false;
        });
      }
    }
  }

  Future<void> fetchTotalFlats() async {
    try {
      final url = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=${_number}',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final subid = data.isNotEmpty ? data[0]['subid'] : 0;

        if (mounted) {
          setState(() {
            totalFlats = subid;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            totalFlats = 0;
            isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          totalFlats = 0;
          isLoading = false;
        });
      }
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
    required List<XFile> images,
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
            imageUrl: images.first.path,
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
                      imageUrl: images[0].path,
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
                            imageUrl: images[1].path,
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

  List<XFile> _buildMultipleImages(Catid p) {
    final List<XFile> imgs = [];
    final baseUri = Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/');

    if (p.images != null && p.images!.isNotEmpty) {
      imgs.add(XFile(baseUri.resolve(p.images!).toString()));
    }

    return imgs;
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final appBarImageHeight = (screenHeight * 0.1).clamp(40.0, 70.0);

    return RefreshIndicator(
      onRefresh: _refreshProperties,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          surfaceTintColor: Colors.black,
          backgroundColor: Colors.black,
          title: Image.asset(AppImages.verify, height: appBarImageHeight),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
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
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(56),
          //   child: Container(
          //     color: Colors.black,
          //     child: TabBar(
          //       controller: _tabController,
          //       indicatorColor: Colors.white,
          //       labelColor: Colors.white,
          //       unselectedLabelColor: Colors.white70,
          //       tabs: const [
          //         Tab(text: 'Buildings'),
          //         // Tab(text: 'Plots'),
          //         // Tab(text: 'Commercial'),
          //       ],
          //     ),
          //   ),
          // ),
          // bottom: PreferredSize(
          //   preferredSize: const Size.fromHeight(56),
          //   child: Container(
          //     color: Colors.black,
          //     child: TabBar(
          //       controller: _tabController,
          //       indicatorColor: Colors.white,
          //       labelColor: Colors.white,
          //       unselectedLabelColor: Colors.white70,
          //       tabs: const [
          //         Tab(text: 'Buildings'),
          //         Tab(text: 'Plots'),
          //         Tab(text: 'Commercial'),
          //       ],
          //     ),
          //   ),
          // ),
        ),
        body: _isLoading
            ? Center(child: Lottie.asset(AppImages.loadingHand, height: screenHeight * 0.5))
            :             _buildBuildingsTab(isTablet: isTablet, screenWidth: screenWidth),



        // TabBarView(
        //   controller: _tabController,
        //   children: [
        //     // TAB 1: Buildings
        //     _buildBuildingsTab(isTablet: isTablet, screenWidth: screenWidth),
        //
        //     // TAB 2: Plots
        //     PlotListPage(fieldworkerNumber: _number),
        //     // TAB 3: Commercial
        //     CommercialListPage(fieldWorkerNumber: _number),
        //   ],
        // ),
            // // TAB 2: Plots
            // PlotListPage(fieldworkerNumber: _number),
            // // TAB 3: Commercial
            // CommercialListPage(fieldWorkerNumber: _number),

      floatingActionButton: FloatingActionButton.extended(
      onPressed: _showAddOptionsDialog,
      icon: const Icon(Icons.add, color: Colors.white),
      label: Text("Add Forms", style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: isTablet ? 16 : 14,
      )),
      backgroundColor: Colors.blue,
      elevation: 4,
    ),

    ),


    );
  }

  // Buildings tab ke liye UI
  Widget _buildBuildingsTab({
    required bool isTablet,
    required double screenWidth,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final topPadding = isTablet ? 24.0 : 16.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(topPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search properties...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: isTablet ? 18 : 16
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade700,
                            size: isTablet ? 28 : 24
                        ),
                      ),
                      suffixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _searchController.text.isNotEmpty
                            ? IconButton(
                          key: const ValueKey('clear'),
                          icon: Icon(
                              Icons.close_rounded,
                              color: Colors.grey.shade700,
                              size: isTablet ? 24 : 22
                          ),
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
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isTablet ? 20 : 16,
                        horizontal: isTablet ? 20 : 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.blueGrey.withOpacity(0.3),
                            width: 1
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.blueAccent.withOpacity(0.8),
                            width: 1.5
                        ),
                      ),
                    ),
                    onChanged: (_) {}, // Listener handles debounced search
                  ),
                ),
              ),

              SizedBox(height: isTablet ? 16 : 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'Rent',
                    'Buy',
                    'Commercial',
                    'Missing Field',
                    'Live',
                    'Unlive',
                    'Empty Building',
                  ]
                      .map((label) {
                    final isSelected = label == selectedLabel;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 6 : 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedLabel = label;
                          });

                          _searchController.clear();
                          _debounce?.cancel();

                          List<Catid> filtered = [];

                          if (label == 'Missing Field') {
                            filtered = _allProperties.where((item) {
                              return (item.images == null ||
                                  item.images!.trim().isEmpty) ||
                                  (item.ownerName == null ||
                                      item.ownerName!.trim().isEmpty) ||
                                  (item.ownerNumber == null ||
                                      item.ownerNumber!.trim().isEmpty) ||
                                  (item.caretakerName == null ||
                                      item.caretakerName!.trim().isEmpty) ||
                                  (item.caretakerNumber == null ||
                                      item.caretakerNumber!.trim().isEmpty) ||
                                  (item.place == null ||
                                      item.place!.trim().isEmpty) ||
                                  (item.buyRent == null ||
                                      item.buyRent!.trim().isEmpty) ||
                                  (item.propertyNameAddress == null ||
                                      item.propertyNameAddress!
                                          .trim()
                                          .isEmpty) ||
                                  (item.propertyAddressForFieldworker == null ||
                                      item.propertyAddressForFieldworker!
                                          .trim()
                                          .isEmpty) ||
                                  (item.ownerVehicleNumber == null ||
                                      item.ownerVehicleNumber!
                                          .trim()
                                          .isEmpty) ||
                                  (item.yourAddress == null ||
                                      item.yourAddress!.trim().isEmpty) ||
                                  (item.fieldWorkerName == null ||
                                      item.fieldWorkerName!.trim().isEmpty) ||
                                  (item.fieldWorkerNumber == null ||
                                      item.fieldWorkerNumber!.trim().isEmpty) ||
                                  (item.currentDate == null ||
                                      item.currentDate!.trim().isEmpty) ||
                                  (item.longitude == null ||
                                      item.longitude!.trim().isEmpty) ||
                                  (item.latitude == null ||
                                      item.latitude!.trim().isEmpty) ||
                                  (item.roadSize == null ||
                                      item.roadSize!.trim().isEmpty) ||
                                  (item.metroDistance == null ||
                                      item.metroDistance!.trim().isEmpty) ||
                                  (item.metroName == null ||
                                      item.metroName!.trim().isEmpty) ||
                                  (item.mainMarketDistance == null ||
                                      item.mainMarketDistance!
                                          .trim()
                                          .isEmpty) ||
                                  (item.ageOfProperty == null ||
                                      item.ageOfProperty!.trim().isEmpty) ||
                                  (item.lift == null ||
                                      item.lift!.trim().isEmpty) ||
                                  (item.parking == null ||
                                      item.parking!.trim().isEmpty) ||
                                  (item.totalFloor == null ||
                                      item.totalFloor!.trim().isEmpty) ||
                                  (item.residenceCommercial == null ||
                                      item.residenceCommercial!
                                          .trim()
                                          .isEmpty) ||
                                  (item.facility == null ||
                                      item.facility!.trim().isEmpty);
                            }).toList();
                          } else if (label == 'Empty Building') {
                            filtered = _allProperties.where((item) {
                              final status = _propertyStatuses[item.id];
                              return status != null && status["loggValue2"] == "0";
                            }).toList();
                          } else if (label == 'Rent' || label == 'Buy' ||
                              label == 'Commercial') {
                            filtered = _allProperties.where((item) {
                              if (label == 'Commercial') {
                                final value = (item.residenceCommercial ?? '')
                                    .toLowerCase();
                                return value == 'commercial';
                              } else {
                                final value = (item.buyRent ?? '')
                                    .toLowerCase();
                                return value == label.toLowerCase();
                              }
                            }).toList();
                          } else if (label == 'Live' || label == 'Unlive') {
                            filtered = _allProperties.where((item) {
                              final status = _propertyStatuses[item.id];
                              final liveCount = status?['liveCount'] ?? 0;
                              final anyLive = liveCount > 0;
                              return (label == 'Live' && anyLive) ||
                                  (label == 'Unlive' && !anyLive);
                            }).toList();
                          }

                          setState(() {
                            _filteredProperties = filtered;
                            propertyCount = filtered.length;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w800,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: isTablet ? 14 : 10),

              if (propertyCount > 0)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 16 : 12,
                            vertical: isTablet ? 10 : 8
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isDark ? Colors.transparent : Colors.grey,
                              width: 1.5
                          ),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20,
                                color: Colors.green),
                            SizedBox(width: isTablet ? 8 : 6),
                            Text(
                              "$propertyCount building found",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.black),
                            ),
                            SizedBox(width: isTablet ? 8 : 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  selectedLabel = '';
                                  _filteredProperties = _allProperties;
                                  propertyCount = _allProperties.length;
                                });
                              },
                              child: Icon(
                                  Icons.close,
                                  size: isTablet ? 20 : 18,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isTablet ? 8 : 6),
                      if (!isLoading) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 16 : 12,
                              vertical: isTablet ? 10 : 8
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Total Flats: ${totalFlats ?? 0}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isTablet ? 16 : 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: isTablet ? 8 : 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 16 : 12,
                                  vertical: isTablet ? 10 : 8
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Live Flats: $liveFlats",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isTablet ? 16 : 14),
                              ),
                            ),
                            SizedBox(width: isTablet ? 8 : 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: isTablet ? 16 : 12,
                                  vertical: isTablet ? 10 : 8
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "Rent Out: $bookFlats",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: isTablet ? 16 : 14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

            ],
          ),
        ),
        if (_filteredProperties.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.search_off,
                      size: isTablet ? 80 : 60,
                      color: Colors.grey[400]
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    "No properties found",
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isTablet ? 10 : 8),
                  Text(
                    "Try a different search term",
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
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
                final isSmallScreen = screenWidth < 400;

                final status = _propertyStatuses[property.id] ?? {
                  "loggValue1": "Loading...",
                  "loggValue2": "Loading...",
                  "statusColor": Colors.grey,
                  "liveCount": 0,
                };

                final images = _buildMultipleImages(property);

                final double cardPadding = (screenWidth * 0.03).clamp(8.0, 20.0);
                final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
                final double titleFontSize = isTablet ? 20 : 16; // Increased from 12 to 16 for phones
                final double detailFontSize = isTablet ? 14 : 13;
                final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
                final double multiH = imageH * 0.8;

                // Calculate missing fields
                bool _isNullOrEmpty(String? value) => value == null || value.trim().isEmpty;

                final Map<String, dynamic> fields = {
                  "Images": property.images,
                  "Owner Name": property.ownerName,
                  "Owner Number": property.ownerNumber,
                  "Caretaker Name": property.caretakerName,
                  "Caretaker Number": property.caretakerNumber,
                  "Place": property.place,
                  "Buy/Rent": property.buyRent,
                  "Property Name/Address": property.propertyNameAddress,
                  "Property Address (Fieldworker)": property.propertyAddressForFieldworker,
                  "Owner Vehicle Number": property.ownerVehicleNumber,
                  "Your Address": property.yourAddress,
                  "Field Worker Name": property.fieldWorkerName,
                  "Field Worker Number": property.fieldWorkerNumber,
                  "Current Date": property.currentDate,
                  "Longitude": property.longitude,
                  "Latitude": property.latitude,
                  "Road Size": property.roadSize,
                  "Metro Distance": property.metroDistance,
                  "Metro Name": property.metroName,
                  "Main Market Distance": property.mainMarketDistance,
                  "Age of Property": property.ageOfProperty,
                  "Lift": property.lift,
                  "Parking": property.parking,
                  "Total Floor": property.totalFloor,
                  "Residence/Commercial": property.residenceCommercial,
                  "Facility": property.facility,
                };

                final missingFields = fields.entries
                    .where((entry) {
                  final value = entry.value;
                  if (value == null) return true;
                  if (value is String && value.trim().isEmpty) return true;
                  return false;
                })
                    .map((entry) => entry.key)
                    .toList();

                final hasMissingFields = missingFields.isNotEmpty;

                final String loggValue2 = status['loggValue2'] ?? 'N/A';

                final Widget totalDetail = _DetailRow(
                  icon: Icons.format_list_numbered,
                  label: 'Total Flats',
                  value: loggValue2 == 'Loading...' || loggValue2 == 'Error' ? 'N/A' : loggValue2,
                  theme: theme,
                  getIconColor: _getIconColor,
                  maxLines: 1
                  ,
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
                  icon: Icons.access_time,
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
                            Future_Property_details(
                              idd: property.id.toString(),
                            ),
                      ),
                    );
                    // FIXED: Refresh properties and statuses after returning from details page to update live/unlive badges and filters immediately
                    await _refreshProperties();
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
    );
  }

  Future<void> _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
      _SUbid = prefs.getString('id_future') ?? '';
    });
  }

  void _showAddOptionsDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isTablet = screenWidth > 600;
        return DraggableScrollableSheet(
          initialChildSize: isTablet ? 0.4 : 0.52,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          builder: (_, controller) {
            return Container(
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .brightness == Brightness.dark ? Colors.grey[900] : Colors
                    .white,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: isTablet ? 50 : 42,
                      height: isTablet ? 6 : 5,
                      decoration: BoxDecoration(
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? Colors.grey[700]
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    'Form options',
                    style: TextStyle(
                        fontSize: isTablet ? 22 : 18,
                        fontWeight: FontWeight.bold,
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark ? Colors.white : Colors
                            .black
                    ),
                  ),
                  SizedBox(height: isTablet ? 10 : 8),
                  Text(
                      'Choose one of the options below to add a new forms.',
                      style: TextStyle(
                        color: Theme
                            .of(context)
                            .brightness == Brightness.dark
                            ? Colors.grey[300]
                            : Colors.grey[800],
                        fontSize: isTablet ? 16 : 14,
                      )
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Expanded(
                    child: ListView(
                      controller: controller,
                      children: [
                        _buildOptionTile(
                          icon: Icons.apartment,
                          title: 'Add Building',
                          subtitle: 'Add a new residential building',
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => const Add_FutureProperty())).then((_) {
                              _refreshProperties();
                            });
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        // _buildOptionTile(
                        //   icon: Icons.landscape,
                        //   title: 'Add Plot',
                        //   subtitle: 'Add a new plot record',
                        //   onTap: () async {
                        //     Navigator.of(context).pop();
                        //     final result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) =>  PropertyListingPage(),
                        //       ),
                        //     );
                            // if (result != null) {
                            //   ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(
                            //         content: Text(
                            //             'Plot added',
                            //             style: TextStyle(fontSize: isTablet ? 16 : 14)
                            //         ),
                            //         backgroundColor: Colors.green
                            //     ),
                            //   );
                            // }
                        //   },
                        //   isTablet: isTablet,
                        // ),
                        //SizedBox(height: isTablet ? 12 : 8),
                        // _buildOptionTile(
                        //   icon: Icons.storefront,
                        //   title: 'Add Commercial',
                        //   subtitle: 'Add a commercial property',
                        //   onTap: () async {
                        //     Navigator.of(context).pop();
                        //     final result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>  CommercialPropertyForm()
                        //       ),
                        //     );
                        //     if (result != null) {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //             content: Text(
                        //                 'Commercial added',
                        //                 style: TextStyle(fontSize: isTablet ? 16 : 14)
                        //             ),
                        //             backgroundColor: Colors.green
                        //         ),
                        //       );
                        //     }
                        //   },
                        //   isTablet: isTablet,
                        // ),
                        // _buildOptionTile(
                        //   icon: Icons.landscape,
                        //   title: 'Add Plot',
                        //   subtitle: 'Add a new plot record',
                        //   onTap: () async {
                        //     Navigator.of(context).pop();
                        //     final result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) =>  PropertyListingPage(),
                        //       ),
                        //     );
                        //     if (result != null) {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //             content: Text(
                        //                 'Plot added',
                        //                 style: TextStyle(fontSize: isTablet ? 16 : 14)
                        //             ),
                        //             backgroundColor: Colors.green
                        //         ),
                        //       );
                        //     }
                        //   },
                        //   isTablet: isTablet,
                        // ),
                        // SizedBox(height: isTablet ? 12 : 8),
                        // _buildOptionTile(
                        //   icon: Icons.storefront,
                        //   title: 'Add Commercial',
                        //   subtitle: 'Add a commercial property',
                        //   onTap: () async {
                        //     Navigator.of(context).pop();
                        //     final result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //           builder: (context) =>  CommercialPropertyForm()
                        //       ),
                        //     );
                        //     if (result != null) {
                        //       ScaffoldMessenger.of(context).showSnackBar(
                        //         SnackBar(
                        //             content: Text(
                        //                 'Commercial added',
                        //                 style: TextStyle(fontSize: isTablet ? 16 : 14)
                        //             ),
                        //             backgroundColor: Colors.green
                        //         ),
                        //       );
                        //     }
                        //   },
                        //   isTablet: isTablet,
                        // ),
                        SizedBox(height: isTablet ? 16 : 12),
                        ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: isTablet ? 16 : 14,
                              ),
                            ),)
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    required bool isTablet,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Theme
                .of(context)
                .brightness == Brightness.dark ? Colors.grey[800] : Colors.grey
                .shade100,
          ),
          padding: EdgeInsets.all(isTablet ? 12 : 8),
          child: Icon(
              icon,
              size: isTablet ? 32 : 28,
              color: Colors.black87
          ),
        ),
        title: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 18 : 16
            )
        ),
        subtitle: subtitle != null ? Text(
          subtitle,
          style: TextStyle(fontSize: isTablet ? 15 : 14),
        ) : null,
        trailing: Icon(
            Icons.arrow_forward_ios,
            size: isTablet ? 18 : 16
        ),
      ),
    );
  }
}
//
// // frontpage_futureproperty_with_tabs.dart (Responsive: Added MediaQuery-based dynamic sizing for card padding, margins, image heights, and font sizes based on screen width/height; used clamp for bounds; adjusted flex and spacings for tablets (>600px) vs phones; ensured no overflow on small screens)
// // FIXED: Added automatic refresh of property statuses after returning from details page (Future_Property_details) to ensure live/unlive updates reflect immediately in the list (e.g., when marking flats as live, the badge and filters now update correctly without manual pull-to-refresh).
// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';
// import '../ui_decoration_tools/app_images.dart';
// import 'Add_commercial_property.dart';
// import 'Add_futureProperty.dart';
// import 'Add_plot_property.dart';
// import 'Commercial_detail.dart';
// import 'Future_property_details.dart';
// import 'package:intl/intl.dart';
// import 'PlotShow.dart';
// import 'Plot_detail.dart';
// import 'commercialShow.dart';
//
// class Catid {
//   final int id;
//   final String? images;
//   final String? ownerName;
//   final String? ownerNumber;
//   final String? caretakerName;
//   final String? caretakerNumber;
//   final String? place;
//   final String? buyRent;
//   final String? typeOfProperty;
//   final String? selectBhk;
//   final String? floorNumber;
//   final String? squareFeet;
//   final String? propertyNameAddress;
//   final String? buildingInformationFacilities;
//   final String? propertyAddressForFieldworker;
//   final String? ownerVehicleNumber;
//   final String? yourAddress;
//   final String? fieldWorkerName;
//   final String? fieldWorkerNumber;
//   final String? currentDate;
//   final String? longitude;
//   final String? latitude;
//   final String? roadSize;
//   final String? metroDistance;
//   final String? metroName;
//   final String? mainMarketDistance;
//   final String? ageOfProperty;
//   final String? lift;
//   final String? parking;
//   final String? totalFloor;
//   final String? residenceCommercial;
//   final String? facility;
//
//   Catid({
//     required this.id,
//     required this.images,
//     required this.ownerName,
//     required this.ownerNumber,
//     required this.caretakerName,
//     required this.caretakerNumber,
//     required this.place,
//     required this.buyRent,
//     required this.typeOfProperty,
//     required this.selectBhk,
//     required this.floorNumber,
//     required this.squareFeet,
//     required this.propertyNameAddress,
//     required this.buildingInformationFacilities,
//     required this.propertyAddressForFieldworker,
//     required this.ownerVehicleNumber,
//     required this.yourAddress,
//     required this.fieldWorkerName,
//     required this.fieldWorkerNumber,
//     required this.currentDate,
//     required this.longitude,
//     required this.latitude,
//     required this.roadSize,
//     required this.metroDistance,
//     required this.metroName,
//     required this.mainMarketDistance,
//     required this.ageOfProperty,
//     required this.lift,
//     required this.parking,
//     required this.totalFloor,
//     required this.residenceCommercial,
//     required this.facility,
//   });
//
//   factory Catid.FromJson(Map<String, dynamic> json) {
//     return Catid(
//       id: json['id'] is int
//           ? json['id']
//           : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
//       images: json['images'],
//       ownerName: json['ownername'],
//       ownerNumber: json['ownernumber'],
//       caretakerName: json['caretakername'],
//       caretakerNumber: json['caretakernumber'],
//       place: json['place'],
//       buyRent: json['buy_rent'],
//       typeOfProperty: json['typeofproperty'],
//       selectBhk: json['select_bhk'],
//       floorNumber: json['floor_number'],
//       squareFeet: json['sqyare_feet'],
//       propertyNameAddress: json['propertyname_address'],
//       buildingInformationFacilities: json['building_information_facilitys'],
//       propertyAddressForFieldworker: json['property_address_for_fieldworkar'],
//       ownerVehicleNumber: json['owner_vehical_number'],
//       yourAddress: json['your_address'],
//       fieldWorkerName: json['fieldworkarname'],
//       fieldWorkerNumber: json['fieldworkarnumber'],
//       currentDate: json['current_date_'],
//       longitude: json['longitude'],
//       latitude: json['latitude'],
//       roadSize: json['Road_Size'],
//       metroDistance: json['metro_distance'],
//       metroName: json['metro_name'],
//       mainMarketDistance: json['main_market_distance'],
//       ageOfProperty: json['age_of_property'],
//       lift: json['lift'],
//       parking: json['parking'],
//       totalFloor: json['total_floor'],
//       residenceCommercial: json['Residence_commercial'],
//       facility: json['facility'],
//     );
//   }
// }
//
// // ✅ ADDED: PlotPropertyData class (with fromJson for API mapping - adjust keys if API response differs)
// class PlotPropertyData {
//   final int id;
//   String? plotStatus;
//   String? plotPrice;
//   String? mainAddress;
//   String? currentLocation;
//   String? plotSize;
//   String? roadSize;
//   String? plotOpen;
//   String? waterConnection;
//   String? electricPrice;
//   String? propertyChain;
//   String? plotFrontSize;
//   String? plotSideSize;
//   String? ageOfProperty;
//   String? propertyRent;
//   String? fieldworkarName;
//   String? fieldworkarNumber;
//   XFile? singleImage;
//   List<XFile> selectedImages = [];
//
//   PlotPropertyData({
//     required this.id,
//     this.plotStatus,
//     this.plotPrice,
//     this.mainAddress,
//     this.currentLocation,
//     this.plotSize,
//     this.roadSize,
//     this.plotOpen,
//     this.waterConnection,
//     this.electricPrice,
//     this.propertyChain,
//     this.plotFrontSize,
//     this.plotSideSize,
//     this.ageOfProperty,
//     this.propertyRent,
//     this.fieldworkarName,
//     this.fieldworkarNumber,
//     this.singleImage,
//     List<XFile>? selectedImages,
//   }) : selectedImages = selectedImages ?? [];
//
//   factory PlotPropertyData.fromJson(Map<String, dynamic> json) {
//     // Map JSON keys to fields - adjust keys based on actual API response (e.g., check console logs)
//     // Example: assuming keys like 'plot_status', 'plot_price', etc. Update as per your API.
//     return PlotPropertyData(
//       id: json['id'] ?? 0,
//       plotStatus: json['plot_status'] ?? json['plotStatus'],
//       plotPrice: json['plot_price'] ?? json['plotPrice'],
//       mainAddress: json['main_address'] ?? json['mainAddress'],
//       currentLocation: json['current_location'] ?? json['currentLocation'],
//       plotSize: json['plot_size'] ?? json['plotSize'],
//       roadSize: json['road_size'] ?? json['roadSize'],
//       plotOpen: json['plot_open'] ?? json['plotOpen'],
//       waterConnection: json['water_connection'] ?? json['waterConnection'],
//       electricPrice: json['electric_price'] ?? json['electricPrice'],
//       propertyChain: json['property_chain'] ?? json['propertyChain'],
//       plotFrontSize: json['plot_front_size'] ?? json['plotFrontSize'],
//       plotSideSize: json['plot_side_size'] ?? json['plotSideSize'],
//       ageOfProperty: json['age_of_property'] ?? json['ageOfProperty'],
//       propertyRent: json['property_rent'] ?? json['propertyRent'],
//       fieldworkarName: json['fieldworkar_name'] ?? json['fieldworkarName'],
//       fieldworkarNumber: json['fieldworkar_number'] ?? json['fieldworkarNumber'],
//       // For images: If API returns URL strings, convert to XFile (or handle as String if needed)
//       singleImage: json['single_image'] != null ? XFile(json['single_image']) : null,
//       selectedImages: (json['selected_images'] as List<dynamic>?)?.map((img) => XFile(img.toString())).toList() ?? [],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'plot_status': plotStatus,
//       'plot_price': plotPrice,
//       'main_address': mainAddress,
//       'current_location': currentLocation,
//       'plot_size': plotSize,
//       'road_size': roadSize,
//       'plot_open': plotOpen,
//       'water_connection': waterConnection,
//       'electric_price': electricPrice,
//       'property_chain': propertyChain,
//       'plot_front_size': plotFrontSize,
//       'plot_side_size': plotSideSize,
//       'age_of_property': ageOfProperty,
//       'property_rent': propertyRent,
//       'fieldworkar_name': fieldworkarName,
//       'fieldworkar_number': fieldworkarNumber,
//       'single_image': singleImage?.path,
//       'selected_images': selectedImages.map((img) => img.path).toList(),
//     };
//   }
// }
//
// class _DetailRow extends StatelessWidget {
//   final IconData icon;
//   final String label;
//   final String value;
//   final ThemeData theme;
//   final Color Function(IconData, ThemeData) getIconColor;
//   final int maxLines;
//   final double? fontSize; // Added for responsive font sizing
//   final FontWeight? fontWeight; // Optional for value highlighting
//
//   const _DetailRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//     required this.theme,
//     required this.getIconColor,
//     this.maxLines = 1,
//     this.fontSize,
//     this.fontWeight,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final cs = theme.colorScheme;
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 10.0), // Increased bottom padding for more space between rows
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             icon,
//             size: 16,
//             color: getIconColor(icon, theme),
//           ),
//           const SizedBox(width: 6),
//           Expanded(
//             child: RichText(
//               maxLines: maxLines,
//               overflow: TextOverflow.ellipsis,
//               text: TextSpan(
//                 style: theme.textTheme.bodyMedium?.copyWith(
//                   height: 1.2,
//                   color: cs.onSurface.withOpacity(0.70),
//                   fontSize: fontSize ?? 13,
//                 ),
//                 children: [
//                   if (label.isNotEmpty)
//                     TextSpan(
//                       text: '$label: ',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w600,
//                         color: cs.onSurface.withOpacity(0.8),
//                         fontSize: fontSize ?? 13,
//                       ),
//                     ),
//                   TextSpan(
//                     text: value,
//                     style: TextStyle(
//                       fontWeight: fontWeight ?? FontWeight.normal, // Apply fontWeight if provided
//                       color: cs.onSurface.withOpacity(0.9), // Slightly darker for value
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class FrontPage_FutureProperty extends StatefulWidget {
//   const FrontPage_FutureProperty({super.key});
//
//   @override
//   State<FrontPage_FutureProperty> createState() => _FrontPage_FuturePropertyState();
// }
//
// class _FrontPage_FuturePropertyState extends State<FrontPage_FutureProperty>
//     with SingleTickerProviderStateMixin {
//
//   late TabController _tabController;
//
//   String _number = '';
//   String _SUbid = '';
//
//   List<Catid> _allProperties = [];
//   List<Catid> _filteredProperties = [];
//   Map<int, Map<String, dynamic>> _propertyStatuses = {};
//   bool _isLoading = true;
//   TextEditingController _searchController = TextEditingController();
//   Timer? _debounce;
//
//   String selectedLabel = '';
//   int propertyCount = 0;
//   int? totalFlats;
//   bool isLoading = true;
//   int bookFlats = 0;
//   int liveFlats = 0;
//   int _currentPage = 1;
//   final int _limit = 10;
//   bool _isFetchingMore = false;
//   bool _hasMoreData = true;
//   int _totalPages = 1;
//
//
//   final ScrollController _scrollController = ScrollController();
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     _searchController.addListener(_onSearchChanged);
//     _scrollController.addListener(_onScroll);
//
//
//     _loaduserdata().then((_) {
//       _refreshProperties();
//     });
//   }
//
//
//
//
//   @override
//   void dispose() {
//     _tabController.dispose();
//     _searchController.dispose();
//     _scrollController.dispose();
//
//     _debounce?.cancel();
//     super.dispose();
//   }
//
//   void _onSearchChanged() {
//     if (_debounce?.isActive ?? false) _debounce!.cancel();
//
//     _debounce = Timer(const Duration(milliseconds: 400), () {
//       String query = _searchController.text.toLowerCase().trim();
//
//       List<Catid> searchOn = selectedLabel.isEmpty ? _allProperties : _filteredProperties;
//       List<Catid> filtered;
//
//       if (query.isEmpty) {
//         filtered = List.from(searchOn);
//       } else {
//         filtered = searchOn.where((item) {
//           return (item.id.toString()).toLowerCase().contains(query) ||
//               (item.ownerName ?? '').toLowerCase().contains(query) ||
//               (item.caretakerName ?? '').toLowerCase().contains(query) ||
//               (item.place ?? '').toLowerCase().contains(query) ||
//               (item.buyRent ?? '').toLowerCase().contains(query) ||
//               (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
//               (item.selectBhk ?? '').toLowerCase().contains(query) ||
//               (item.floorNumber ?? '').toLowerCase().contains(query) ||
//               (item.squareFeet ?? '').toLowerCase().contains(query) ||
//               (item.propertyNameAddress ?? '').toLowerCase().contains(query) ||
//               (item.residenceCommercial ?? '').toLowerCase().contains(query) ||
//               (item.ownerNumber ?? '').toLowerCase().contains(query) ||
//               (item.ownerVehicleNumber ?? '').toLowerCase().contains(query) ||
//               (item.buildingInformationFacilities ?? '').toLowerCase().contains(query) ||
//               (item.propertyAddressForFieldworker ?? '').toLowerCase().contains(query) ||
//               (item.yourAddress ?? '').toLowerCase().contains(query) ||
//               (item.fieldWorkerName ?? '').toLowerCase().contains(query) ||
//               (item.fieldWorkerNumber ?? '').toLowerCase().contains(query) ||
//               (item.currentDate ?? '').toLowerCase().contains(query) ||
//               (item.longitude ?? '').toLowerCase().contains(query) ||
//               (item.latitude ?? '').toLowerCase().contains(query) ||
//               (item.roadSize ?? '').toLowerCase().contains(query) ||
//               (item.metroDistance ?? '').toLowerCase().contains(query) ||
//               (item.metroName ?? '').toLowerCase().contains(query) ||
//               (item.mainMarketDistance ?? '').toLowerCase().contains(query) ||
//               (item.ageOfProperty ?? '').toLowerCase().contains(query) ||
//               (item.lift ?? '').toLowerCase().contains(query) ||
//               (item.parking ?? '').toLowerCase().contains(query) ||
//               (item.totalFloor ?? '').toLowerCase().contains(query) ||
//               (item.facility ?? '').toLowerCase().contains(query);
//         }).toList();
//       }
//
//       setState(() {
//         _filteredProperties = filtered;
//         propertyCount = filtered.length;
//       });
//     });
//   }
//
//   void _onScroll() {
//     if (_scrollController.position.pixels >=
//         _scrollController.position.maxScrollExtent - 200 &&
//         !_isFetchingMore &&
//         _hasMoreData) {
//       _fetchMoreProperties();
//     }
//   }
//
//   Future<Map<String, dynamic>> fetchPropertyStatus(int subid) async {
//     try {
//       final response1 = await http.get(Uri.parse(
//           "https://verifyserve.social/WebService4.asmx/check_live_flat_in_main_realesate?subid=$subid&live_unlive=Flat"));
//
//       final response2 = await http.get(Uri.parse(
//           "https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=$subid"));
//
//       final response3 = await http.get(Uri.parse(
//           "https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=$subid"));
//
//       String loggValue1 = "Loading...";
//       String loggValue2 = "Loading...";
//       Color statusColor = Colors.grey;
//       int liveCount = 0;
//
//       if (response1.statusCode == 200) {
//         final body = jsonDecode(response1.body);
//         if (body is List && body.isNotEmpty) {
//           final logg = body[0]['logg'];
//           loggValue1 = logg.toString();
//           statusColor = (logg == 0) ? Colors.red : Colors.green;
//         }
//       }
//
//       if (response2.statusCode == 200) {
//         final body = jsonDecode(response2.body);
//         if (body is List && body.isNotEmpty) {
//           final logg = body[0]['logg'];
//           loggValue2 = logg.toString();
//         }
//       }
//
//       if (response3.statusCode == 200) {
//         final body3 = jsonDecode(response3.body);
//         if (body3 is List && body3.isNotEmpty) {
//           for (var item in body3) {
//             if (item['live_unlive'] == 'Live') {
//               liveCount = (item['logs'] as num?)?.toInt() ?? 0;
//               break;
//             }
//           }
//         }
//       }
//
//       return {
//         "loggValue1": loggValue1,
//         "loggValue2": loggValue2,
//         "statusColor": statusColor,
//         "liveCount": liveCount,
//       };
//     } catch (e) {
//       return {
//         "loggValue1": "Error",
//         "loggValue2": "Error",
//         "statusColor": Colors.grey,
//         "liveCount": 0,
//       };
//     }
//   }
//
//   Future<void> fetchAllStatuses() async {
//     if (_allProperties.isEmpty) return;
//
//     final futures = _allProperties.map((p) => fetchPropertyStatus(p.id));
//     final List<Map<String, dynamic>> results = await Future.wait(futures);
//
//     for (int i = 0; i < _allProperties.length; i++) {
//       _propertyStatuses[_allProperties[i].id] = results[i];
//     }
//
//     if (mounted) setState(() {});
//   }
//
//   Future<void> _fetchMoreProperties({bool isRefresh = false}) async {
//     if (_isFetchingMore) return;
//     if (!_hasMoreData) return;
//
//     if (_number.isEmpty) {
//       debugPrint("Fieldworker number missing");
//       setState(() => _isFetchingMore = false);
//       return;
//     }
//
//     if (isRefresh) {
//       _currentPage = 1;
//       _hasMoreData = true;
//       _allProperties.clear();
//       _propertyStatuses.clear();
//     }
//
//     setState(() => _isFetchingMore = true);
//
//     try {
//       final url = Uri.parse(
//         "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/"
//             "display_future_property_base_on_fieldworkar_number.php"
//             "?fieldworkarnumber=$_number&page=$_currentPage&limit=$_limit",
//       );
//
//       final response = await http.get(url);
//
//       print(url);
//
//       if (response.statusCode == 200) {
//         final Map<String, dynamic> decoded =
//         jsonDecode(response.body) as Map<String, dynamic>;
//
//         // ✅ Read pagination info
//         final pagination = decoded['pagination'] ?? {};
//         _totalPages = int.tryParse(
//           pagination['total_pages']?.toString() ?? '1',
//         ) ??
//             1;
//
//         // ✅ Read actual list
//         final List listData = decoded['data'] ?? [];
//
//         if (listData.isEmpty) {
//           _hasMoreData = false;
//         } else {
//           final newItems =
//           listData.map((e) => Catid.FromJson(e)).toList();
//
//           _allProperties.addAll(newItems);
//           _filteredProperties = List.from(_allProperties);
//
//           await fetchAllStatuses();
//
//           _currentPage++;
//
//           if (_currentPage > _totalPages) {
//             _hasMoreData = false;
//           }
//         }
//       }
//     } catch (e) {
//       debugPrint("Pagination error: $e");
//     }
//
//     setState(() => _isFetchingMore = false);
//   }
//
//   Future<void> _refreshProperties() async {
//     setState(() {
//       _isLoading = true;
//     });
//
//     _propertyStatuses.clear();
//
//     await _fetchMoreProperties(isRefresh: true);
//     await fetchAllStatuses();
//     await fetchFlatsStatus();
//     await fetchTotalFlats();
//
//     if (mounted) {
//       setState(() {
//         _filteredProperties = _allProperties;
//         propertyCount = _allProperties.length;
//         _isLoading = false; // ✅ THIS WAS MISSING
//       });
//     }
//   }
//
//   Future<void> fetchFlatsStatus() async {
//     try {
//       final url = Uri.parse(
//         'https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=${_number}',
//       );
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body) as List<dynamic>;
//
//         int book = 0;
//         int live = 0;
//
//         for (var item in data) {
//           if (item['live_unlive'] == "Book") {
//             book = item['subid'] ?? 0;
//           } else if (item['live_unlive'] == "Live") {
//             live = item['subid'] ?? 0;
//           }
//         }
//
//         if (mounted) {
//           setState(() {
//             bookFlats = book;
//             liveFlats = live;
//             isLoading = false;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             bookFlats = 0;
//             liveFlats = 0;
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       print("Error fetching flats status: $e");
//       if (mounted) {
//         setState(() {
//           bookFlats = 0;
//           liveFlats = 0;
//           isLoading = false;
//         });
//       }
//     }
//   }
//
//   Future<void> fetchTotalFlats() async {
//     try {
//       final url = Uri.parse(
//         'https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=${_number}',
//       );
//       final response = await http.get(url);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final subid = data.isNotEmpty ? data[0]['subid'] : 0;
//
//         if (mounted) {
//           setState(() {
//             totalFlats = subid;
//             isLoading = false;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             totalFlats = 0;
//             isLoading = false;
//           });
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() {
//           totalFlats = 0;
//           isLoading = false;
//         });
//       }
//       print("Error fetching total flats: $e");
//     }
//   }
//
//   String formatDate(String s) {
//     if (s.isEmpty) return '-';
//     try {
//       final dt = DateFormat('yyyy-MM-dd ').parse(s);
//       return DateFormat('dd MMM yyyy,').format(dt);
//     } catch (_) {
//       try {
//         final dt2 = DateTime.parse(s);
//         return DateFormat('dd MMM yyyy,').format(dt2);
//       } catch (_) {
//         return s;
//       }
//     }
//   }
//
//   Color _getIconColor(IconData icon, ThemeData theme) {
//     final cs = theme.colorScheme;
//     switch (icon) {
//       case Icons.location_on:
//         return Colors.red;
//       case Icons.square_foot:
//         return Colors.orange;
//       case Icons.handshake_outlined:
//         return Colors.orangeAccent;
//       case Icons.apartment:
//         return Colors.blue;
//       case Icons.layers:
//         return Colors.teal;
//       case Icons.format_list_numbered:
//         return Colors.indigo;
//       case Icons.date_range:
//         return Colors.purple;
//       case Icons.home:
//         return Colors.brown;
//       case Icons.numbers:
//         return Colors.cyan;
//       default:
//         return cs.primary;
//     }
//   }
//
//   Widget _buildImageSection({
//     required List<XFile> images,
//     required ColorScheme cs,
//     required ThemeData theme,
//     required Map<String, dynamic> status,
//     required double imageHeight,
//     required double multiImgHeight,
//     required bool isTablet,
//   }) {
//     final int liveCount = status['liveCount'] ?? 0;
//     final Color liveColor = liveCount > 0 ? Colors.green : Colors.red;
//     final String liveLabel = liveCount > 0 ? "Live: $liveCount" : "Unlive: 0";
//
//     Widget imageWidget;
//     if (images.isEmpty) {
//       imageWidget = Container(
//         height: imageHeight,
//         decoration: BoxDecoration(
//           color: cs.surfaceVariant,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: const Icon(
//           Icons.apartment,
//           size: 90,
//           color: Colors.grey,
//         ),
//       );
//     } else if (images.length == 1) {
//       imageWidget = ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: SizedBox(
//           height: imageHeight,
//           width: double.infinity,
//           child: CachedNetworkImage(
//             imageUrl: images.first.path,
//             fit: BoxFit.cover,
//             placeholder: (_, __) => const Center(
//               child: SizedBox(
//                 height: 50,
//                 width: 50,
//                 child: CircularProgressIndicator(strokeWidth: 2),
//               ),
//             ),
//             errorWidget: (_, __, ___) =>
//                 Icon(Icons.broken_image, color: cs.error, size: 90),
//           ),
//         ),
//       );
//     } else {
//       imageWidget = Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             height: multiImgHeight,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(8),
//                     child: CachedNetworkImage(
//                       imageUrl: images[0].path,
//                       fit: BoxFit.cover,
//                       placeholder: (_, __) => const Center(
//                         child: SizedBox(
//                           height: 30,
//                           width: 30,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         ),
//                       ),
//                       errorWidget: (_, __, ___) =>
//                           Icon(Icons.broken_image, color: cs.error, size: 50),
//                     ),
//                   ),
//                 ),
//                 if (images.length > 1) ...[
//                   const SizedBox(width: 4),
//                   Expanded(
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           CachedNetworkImage(
//                             imageUrl: images[1].path,
//                             fit: BoxFit.cover,
//                             placeholder: (_, __) => const Center(
//                               child: SizedBox(
//                                 height: 30,
//                                 width: 30,
//                                 child: CircularProgressIndicator(strokeWidth: 2),
//                               ),
//                             ),
//                             errorWidget: (_, __, ___) =>
//                                 Icon(Icons.broken_image, color: cs.error, size: 50),
//                           ),
//                           if (images.length > 2)
//                             Positioned(
//                               bottom: 4,
//                               right: 4,
//                               child: Container(
//                                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                                 decoration: BoxDecoration(
//                                   color: Colors.black54,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Text(
//                                   '+${images.length - 2}',
//                                   style: theme.textTheme.labelSmall?.copyWith(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           ),
//           const SizedBox(height: 6),
//           Text(
//             '${images.length} ${images.length == 1 ? 'Image' : 'Images'}',
//             style: theme.textTheme.bodySmall?.copyWith(
//               color: cs.primary,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ],
//       );
//     }
//
//     return Stack(
//       children: [
//         imageWidget,
//         Positioned(
//           top: 4,
//           right: 4,
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//             decoration: BoxDecoration(
//               color: liveColor.withOpacity(0.8),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: Text(
//               liveLabel,
//               style: theme.textTheme.labelSmall?.copyWith(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   List<XFile> _buildMultipleImages(Catid p) {
//     final List<XFile> imgs = [];
//     final baseUri = Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/');
//
//     if (p.images != null && p.images!.isNotEmpty) {
//       imgs.add(XFile(baseUri.resolve(p.images!).toString()));
//     }
//
//     return imgs;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isTablet = screenWidth > 600;
//     final appBarImageHeight = (screenHeight * 0.1).clamp(40.0, 70.0);
//
//     return RefreshIndicator(
//       onRefresh: _refreshProperties,
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           surfaceTintColor: Colors.black,
//           backgroundColor: Colors.black,
//           title: Image.asset(AppImages.verify, height: appBarImageHeight),
//           leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Row(
//               children: [
//                 SizedBox(width: 3),
//                 Icon(
//                   PhosphorIcons.caret_left_bold,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//               ],
//             ),
//           ),
//           // bottom: PreferredSize(
//           //   preferredSize: const Size.fromHeight(56),
//           //   child: Container(
//           //     color: Colors.black,
//           //     child: TabBar(
//           //       controller: _tabController,
//           //       indicatorColor: Colors.white,
//           //       labelColor: Colors.white,
//           //       unselectedLabelColor: Colors.white70,
//           //       tabs: const [
//           //         Tab(text: 'Buildings'),
//           //         // Tab(text: 'Plots'),
//           //         // Tab(text: 'Commercial'),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//           // bottom: PreferredSize(
//           //   preferredSize: const Size.fromHeight(56),
//           //   child: Container(
//           //     color: Colors.black,
//           //     child: TabBar(
//           //       controller: _tabController,
//           //       indicatorColor: Colors.white,
//           //       labelColor: Colors.white,
//           //       unselectedLabelColor: Colors.white70,
//           //       tabs: const [
//           //         Tab(text: 'Buildings'),
//           //         Tab(text: 'Plots'),
//           //         Tab(text: 'Commercial'),
//           //       ],
//           //     ),
//           //   ),
//           // ),
//         ),
//         body: _isLoading
//             ? Center(child: Lottie.asset(AppImages.loadingHand, height: screenHeight * 0.5))
//             :             _buildBuildingsTab(isTablet: isTablet, screenWidth: screenWidth),
//
//
//
//         // TabBarView(
//         //   controller: _tabController,
//         //   children: [
//         //     // TAB 1: Buildings
//         //     _buildBuildingsTab(isTablet: isTablet, screenWidth: screenWidth),
//         //
//         //     // TAB 2: Plots
//         //     PlotListPage(fieldworkerNumber: _number),
//         //     // TAB 3: Commercial
//         //     CommercialListPage(fieldWorkerNumber: _number),
//         //   ],
//         // ),
//         // // TAB 2: Plots
//         // PlotListPage(fieldworkerNumber: _number),
//         // // TAB 3: Commercial
//         // CommercialListPage(fieldWorkerNumber: _number),
//
//         floatingActionButton: FloatingActionButton.extended(
//           onPressed: _showAddOptionsDialog,
//           icon: const Icon(Icons.add, color: Colors.white),
//           label: Text("Add Forms", style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//             fontSize: isTablet ? 16 : 14,
//           )),
//           backgroundColor: Colors.blue,
//           elevation: 4,
//         ),
//
//       ),
//
//
//     );
//   }
//
//   // Buildings tab ke liye UI
//   Widget _buildBuildingsTab({
//     required bool isTablet,
//     required double screenWidth,
//   }) {
//     final theme = Theme.of(context);
//     final cs = theme.colorScheme;
//     final isDark = theme.brightness == Brightness.dark;
//     final topPadding = isTablet ? 24.0 : 16.0;
//
//     return Column(
//       children: [
//         Padding(
//           padding: EdgeInsets.all(topPadding),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Material(
//                 elevation: 4,
//                 borderRadius: BorderRadius.circular(12),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   curve: Curves.easeInOut,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     gradient: LinearGradient(
//                       colors: [Colors.grey[100]!, Colors.grey[50]!],
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.2),
//                         blurRadius: 10,
//                         spreadRadius: 2,
//                         offset: const Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: TextField(
//                     controller: _searchController,
//                     style: TextStyle(
//                       color: Colors.black87,
//                       fontSize: isTablet ? 18 : 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                     decoration: InputDecoration(
//                       hintText: 'Search properties...',
//                       hintStyle: TextStyle(
//                           color: Colors.grey.shade600,
//                           fontSize: isTablet ? 18 : 16
//                       ),
//                       prefixIcon: Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Icon(
//                             Icons.search_rounded,
//                             color: Colors.grey.shade700,
//                             size: isTablet ? 28 : 24
//                         ),
//                       ),
//                       suffixIcon: AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 200),
//                         child: _searchController.text.isNotEmpty
//                             ? IconButton(
//                           key: const ValueKey('clear'),
//                           icon: Icon(
//                               Icons.close_rounded,
//                               color: Colors.grey.shade700,
//                               size: isTablet ? 24 : 22
//                           ),
//                           onPressed: () {
//                             _searchController.clear();
//                             selectedLabel = '';
//                             _filteredProperties = _allProperties;
//                             propertyCount = _allProperties.length;
//                             setState(() {});
//                           },
//                         )
//                             : const SizedBox(key: ValueKey('empty')),
//                       ),
//                       filled: true,
//                       fillColor: Colors.transparent,
//                       contentPadding: EdgeInsets.symmetric(
//                         vertical: isTablet ? 20 : 16,
//                         horizontal: isTablet ? 20 : 16,
//                       ),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                             color: Colors.blueGrey.withOpacity(0.3),
//                             width: 1
//                         ),
//                       ),
//                       focusedBorder: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide(
//                             color: Colors.blueAccent.withOpacity(0.8),
//                             width: 1.5
//                         ),
//                       ),
//                     ),
//                     onChanged: (_) {}, // Listener handles debounced search
//                   ),
//                 ),
//               ),
//
//               SizedBox(height: isTablet ? 16 : 12),
//
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     'Rent',
//                     'Buy',
//                     'Commercial',
//                     'Missing Field',
//                     'Live',
//                     'Unlive',
//                     'Empty Building',
//                   ]
//                       .map((label) {
//                     final isSelected = label == selectedLabel;
//                     return Padding(
//                       padding: EdgeInsets.symmetric(horizontal: isTablet ? 6 : 4),
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             selectedLabel = label;
//                           });
//
//                           _searchController.clear();
//                           _debounce?.cancel();
//
//                           List<Catid> filtered = [];
//
//                           if (label == 'Missing Field') {
//                             filtered = _allProperties.where((item) {
//                               return (item.images == null ||
//                                   item.images!.trim().isEmpty) ||
//                                   (item.ownerName == null ||
//                                       item.ownerName!.trim().isEmpty) ||
//                                   (item.ownerNumber == null ||
//                                       item.ownerNumber!.trim().isEmpty) ||
//                                   (item.caretakerName == null ||
//                                       item.caretakerName!.trim().isEmpty) ||
//                                   (item.caretakerNumber == null ||
//                                       item.caretakerNumber!.trim().isEmpty) ||
//                                   (item.place == null ||
//                                       item.place!.trim().isEmpty) ||
//                                   (item.buyRent == null ||
//                                       item.buyRent!.trim().isEmpty) ||
//                                   (item.propertyNameAddress == null ||
//                                       item.propertyNameAddress!
//                                           .trim()
//                                           .isEmpty) ||
//                                   (item.propertyAddressForFieldworker == null ||
//                                       item.propertyAddressForFieldworker!
//                                           .trim()
//                                           .isEmpty) ||
//                                   (item.ownerVehicleNumber == null ||
//                                       item.ownerVehicleNumber!
//                                           .trim()
//                                           .isEmpty) ||
//                                   (item.yourAddress == null ||
//                                       item.yourAddress!.trim().isEmpty) ||
//                                   (item.fieldWorkerName == null ||
//                                       item.fieldWorkerName!.trim().isEmpty) ||
//                                   (item.fieldWorkerNumber == null ||
//                                       item.fieldWorkerNumber!.trim().isEmpty) ||
//                                   (item.currentDate == null ||
//                                       item.currentDate!.trim().isEmpty) ||
//                                   (item.longitude == null ||
//                                       item.longitude!.trim().isEmpty) ||
//                                   (item.latitude == null ||
//                                       item.latitude!.trim().isEmpty) ||
//                                   (item.roadSize == null ||
//                                       item.roadSize!.trim().isEmpty) ||
//                                   (item.metroDistance == null ||
//                                       item.metroDistance!.trim().isEmpty) ||
//                                   (item.metroName == null ||
//                                       item.metroName!.trim().isEmpty) ||
//                                   (item.mainMarketDistance == null ||
//                                       item.mainMarketDistance!
//                                           .trim()
//                                           .isEmpty) ||
//                                   (item.ageOfProperty == null ||
//                                       item.ageOfProperty!.trim().isEmpty) ||
//                                   (item.lift == null ||
//                                       item.lift!.trim().isEmpty) ||
//                                   (item.parking == null ||
//                                       item.parking!.trim().isEmpty) ||
//                                   (item.totalFloor == null ||
//                                       item.totalFloor!.trim().isEmpty) ||
//                                   (item.residenceCommercial == null ||
//                                       item.residenceCommercial!
//                                           .trim()
//                                           .isEmpty) ||
//                                   (item.facility == null ||
//                                       item.facility!.trim().isEmpty);
//                             }).toList();
//                           } else if (label == 'Empty Building') {
//                             filtered = _allProperties.where((item) {
//                               final status = _propertyStatuses[item.id];
//                               return status != null && status["loggValue2"] == "0";
//                             }).toList();
//                           } else if (label == 'Rent' || label == 'Buy' ||
//                               label == 'Commercial') {
//                             filtered = _allProperties.where((item) {
//                               if (label == 'Commercial') {
//                                 final value = (item.residenceCommercial ?? '')
//                                     .toLowerCase();
//                                 return value == 'commercial';
//                               } else {
//                                 final value = (item.buyRent ?? '')
//                                     .toLowerCase();
//                                 return value == label.toLowerCase();
//                               }
//                             }).toList();
//                           } else if (label == 'Live' || label == 'Unlive') {
//                             filtered = _allProperties.where((item) {
//                               final status = _propertyStatuses[item.id];
//                               final liveCount = status?['liveCount'] ?? 0;
//                               final anyLive = liveCount > 0;
//                               return (label == 'Live' && anyLive) ||
//                                   (label == 'Unlive' && !anyLive);
//                             }).toList();
//                           }
//
//                           setState(() {
//                             _filteredProperties = filtered;
//                             propertyCount = filtered.length;
//                           });
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                         child: Text(
//                           label,
//                           style: TextStyle(
//                             color: isSelected ? Colors.white : Colors.black87,
//                             fontWeight: FontWeight.w800,
//                             fontSize: isTablet ? 14 : 12,
//                           ),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//               SizedBox(height: isTablet ? 14 : 10),
//
//               if (propertyCount > 0)
//                 SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                             horizontal: isTablet ? 16 : 12,
//                             vertical: isTablet ? 10 : 8
//                         ),
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                               color: isDark ? Colors.transparent : Colors.grey,
//                               width: 1.5
//                           ),
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             const Icon(Icons.check_circle_outline, size: 20,
//                                 color: Colors.green),
//                             SizedBox(width: isTablet ? 8 : 6),
//                             Text(
//                               "$propertyCount building found",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: isTablet ? 16 : 14,
//                                   color: Colors.black),
//                             ),
//                             SizedBox(width: isTablet ? 8 : 6),
//                             GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _searchController.clear();
//                                   selectedLabel = '';
//                                   _filteredProperties = _allProperties;
//                                   propertyCount = _allProperties.length;
//                                 });
//                               },
//                               child: Icon(
//                                   Icons.close,
//                                   size: isTablet ? 20 : 18,
//                                   color: Colors.grey
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       SizedBox(width: isTablet ? 8 : 6),
//                       if (!isLoading) ...[
//                         Container(
//                           padding: EdgeInsets.symmetric(
//                               horizontal: isTablet ? 16 : 12,
//                               vertical: isTablet ? 10 : 8
//                           ),
//                           decoration: BoxDecoration(
//                             color: Colors.blue.withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           child: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 "Total Flats: ${totalFlats ?? 0}",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: isTablet ? 16 : 14),
//                               ),
//                             ],
//                           ),
//                         ),
//                         SizedBox(width: isTablet ? 8 : 6),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: [
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: isTablet ? 16 : 12,
//                                   vertical: isTablet ? 10 : 8
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 "Live Flats: $liveFlats",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: isTablet ? 16 : 14),
//                               ),
//                             ),
//                             SizedBox(width: isTablet ? 8 : 6),
//                             Container(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: isTablet ? 16 : 12,
//                                   vertical: isTablet ? 10 : 8
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.blue.withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                               child: Text(
//                                 "Rent Out: $bookFlats",
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w500,
//                                     fontSize: isTablet ? 16 : 14),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ],
//                   ),
//                 ),
//
//             ],
//           ),
//         ),
//         if (_filteredProperties.isEmpty)
//           Expanded(
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(
//                       Icons.search_off,
//                       size: isTablet ? 80 : 60,
//                       color: Colors.grey[400]
//                   ),
//                   SizedBox(height: isTablet ? 20 : 16),
//                   Text(
//                     "No properties found",
//                     style: TextStyle(
//                       fontSize: isTablet ? 22 : 18,
//                       color: Colors.grey[600],
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   SizedBox(height: isTablet ? 10 : 8),
//                   Text(
//                     "Try a different search term",
//                     style: TextStyle(
//                       fontSize: isTablet ? 16 : 14,
//                       color: Colors.grey[500],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           )
//         else
//           Expanded(
//             child: ListView.builder(
//               controller: _scrollController,
//               padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
//               itemCount: _filteredProperties.length + (_isFetchingMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == _filteredProperties.length) {
//                   return const Padding(
//                     padding: EdgeInsets.symmetric(vertical: 24),
//                     child: Center(child: CircularProgressIndicator()),
//                   );
//                 }
//                 final property = _filteredProperties[index];
//                 final displayIndex = _filteredProperties.length - index;
//                 final theme = Theme.of(context);
//                 final cs = theme.colorScheme;
//                 final isDark = theme.brightness == Brightness.dark;
//                 final screenHeight = MediaQuery.of(context).size.height;
//                 final screenWidth = MediaQuery.of(context).size.width;
//                 final isSmallScreen = screenWidth < 400;
//
//                 final status = _propertyStatuses[property.id] ?? {
//                   "loggValue1": "Loading...",
//                   "loggValue2": "Loading...",
//                   "statusColor": Colors.grey,
//                   "liveCount": 0,
//                 };
//
//                 final images = _buildMultipleImages(property);
//
//                 final double cardPadding = (screenWidth * 0.03).clamp(8.0, 20.0);
//                 final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
//                 final double titleFontSize = isTablet ? 20 : 16; // Increased from 12 to 16 for phones
//                 final double detailFontSize = isTablet ? 14 : 13;
//                 final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
//                 final double multiH = imageH * 0.8;
//
//                 // Calculate missing fields
//                 bool _isNullOrEmpty(String? value) => value == null || value.trim().isEmpty;
//
//                 final Map<String, dynamic> fields = {
//                   "Images": property.images,
//                   "Owner Name": property.ownerName,
//                   "Owner Number": property.ownerNumber,
//                   "Caretaker Name": property.caretakerName,
//                   "Caretaker Number": property.caretakerNumber,
//                   "Place": property.place,
//                   "Buy/Rent": property.buyRent,
//                   "Property Name/Address": property.propertyNameAddress,
//                   "Property Address (Fieldworker)": property.propertyAddressForFieldworker,
//                   "Owner Vehicle Number": property.ownerVehicleNumber,
//                   "Your Address": property.yourAddress,
//                   "Field Worker Name": property.fieldWorkerName,
//                   "Field Worker Number": property.fieldWorkerNumber,
//                   "Current Date": property.currentDate,
//                   "Longitude": property.longitude,
//                   "Latitude": property.latitude,
//                   "Road Size": property.roadSize,
//                   "Metro Distance": property.metroDistance,
//                   "Metro Name": property.metroName,
//                   "Main Market Distance": property.mainMarketDistance,
//                   "Age of Property": property.ageOfProperty,
//                   "Lift": property.lift,
//                   "Parking": property.parking,
//                   "Total Floor": property.totalFloor,
//                   "Residence/Commercial": property.residenceCommercial,
//                   "Facility": property.facility,
//                 };
//
//                 final missingFields = fields.entries
//                     .where((entry) {
//                   final value = entry.value;
//                   if (value == null) return true;
//                   if (value is String && value.trim().isEmpty) return true;
//                   return false;
//                 })
//                     .map((entry) => entry.key)
//                     .toList();
//
//                 final hasMissingFields = missingFields.isNotEmpty;
//
//                 final String loggValue2 = status['loggValue2'] ?? 'N/A';
//
//                 final Widget totalDetail = _DetailRow(
//                   icon: Icons.format_list_numbered,
//                   label: 'Total Flats',
//                   value: loggValue2 == 'Loading...' || loggValue2 == 'Error' ? 'N/A' : loggValue2,
//                   theme: theme,
//                   getIconColor: _getIconColor,
//                   maxLines: 1
//                   ,
//                   fontSize: detailFontSize,
//                   fontWeight: FontWeight.bold,
//                 );
//
//                 final Widget buildingDetail = _DetailRow(
//                   icon: Icons.numbers,
//                   label: 'Building ID',
//                   value: property.id.toString(),
//                   theme: theme,
//                   getIconColor: _getIconColor,
//                   maxLines: 1,
//                   fontSize: detailFontSize,
//                   fontWeight: FontWeight.bold,
//                 );
//
//                 final Widget imageSection = _buildImageSection(
//                   images: images,
//                   cs: cs,
//                   theme: theme,
//                   status: status,
//                   imageHeight: imageH,
//                   multiImgHeight: multiH,
//                   isTablet: isTablet,
//                 );
//
//                 // Priority detail rows: location, buy/rent, residence/commercial, added (removed Building ID)
//                 final List<Widget> detailRows = [];
//                 if ((property.place ?? '').isNotEmpty) {
//                   detailRows.add(_DetailRow(
//                     icon: Icons.location_on,
//                     label: 'Location',
//                     value: property.place!,
//                     theme: theme,
//                     getIconColor: _getIconColor,
//                     fontSize: detailFontSize,
//                     fontWeight: FontWeight.bold,
//                   ));
//                 }
//                 detailRows.add(_DetailRow(
//                   icon: Icons.handshake_outlined,
//                   label: '',
//                   value: property.buyRent ?? 'N/A',
//                   theme: theme,
//                   getIconColor: _getIconColor,
//                   fontSize: detailFontSize,
//                   fontWeight: FontWeight.bold,
//                 ));
//                 detailRows.add(_DetailRow(
//                   icon: Icons.apartment,
//                   label: '',
//                   value: property.residenceCommercial ?? 'N/A',
//                   theme: theme,
//                   getIconColor: _getIconColor,
//                   fontSize: detailFontSize,
//                   fontWeight: FontWeight.bold,
//                 ));
//                 detailRows.add(_DetailRow(
//                   icon: Icons.real_estate_agent_outlined,
//                   label: 'Age',
//                   value: property.ageOfProperty ?? 'N/A',
//                   theme: theme,
//                   getIconColor: _getIconColor,
//                   maxLines: 2,
//                   fontSize: detailFontSize,
//                   fontWeight: FontWeight.bold,
//                 ));
//                 detailRows.add(_DetailRow(
//                   icon: Icons.access_time,
//                   label: 'Date',
//                   value: formatDate(property.currentDate ?? ''),
//                   theme: theme,
//                   getIconColor: _getIconColor,
//                   maxLines: 2,
//                   fontSize: detailFontSize,
//                   fontWeight: FontWeight.bold,
//                 ));
//
//
//                 final Widget leftColumn = Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     imageSection,
//                     SizedBox(height: isTablet ? 20 : 12),
//                     totalDetail,
//                   ],
//                 );
//
//                 final Widget rightColumn = Padding(
//                   padding: EdgeInsets.only(top: isTablet ? 24.0 : 20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         property.propertyAddressForFieldworker ?? property.propertyNameAddress ?? property.place ?? 'No Title',
//                         style: theme.textTheme.titleMedium?.copyWith(
//                           fontWeight: FontWeight.bold,
//                           fontSize: titleFontSize,
//                         ),
//                         maxLines: 3,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: isTablet ? 16 : 12),
//                       // Render detail rows
//                       ...detailRows,
//                       const Spacer(),
//                       // Shift Building ID to the right
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: SizedBox(
//                           width: double.infinity,
//                           child: buildingDetail,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//
//                 return GestureDetector(
//                   onTap: () async {
//                     await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             Future_Property_details(
//                               idd: property.id.toString(),
//                             ),
//                       ),
//                     );
//                     // FIXED: Refresh properties and statuses after returning from details page to update live/unlive badges and filters immediately
//                     await _refreshProperties();
//                   },
//                   child: Card(
//                     margin: EdgeInsets.symmetric(
//                         horizontal: horizontalMargin,
//                         vertical: 4
//                     ),
//                     elevation: isDark ? 0 : 6,
//                     color: theme.cardColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(16),
//                       side: BorderSide(color: theme.dividerColor),
//                     ),
//                     child: Stack(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.all(cardPadding),
//                           child: Column(
//                             children: [
//                               IntrinsicHeight(
//                                 child: Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       flex: isTablet ? 2 : 2,
//                                       child: leftColumn,
//                                     ),
//                                     SizedBox(width: isTablet ? 20 : 16),
//                                     Expanded(
//                                       flex: isTablet ? 3 : 3,
//                                       child: rightColumn,
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               if (hasMissingFields)
//                                 Padding(
//                                   padding: const EdgeInsets.only(top: 8.0),
//                                   child: Container(
//                                     width: double.infinity,
//                                     padding: EdgeInsets.all(isTablet ? 8 : 6),
//                                     decoration: BoxDecoration(
//                                       color: cs.errorContainer,
//                                       borderRadius: BorderRadius.circular(8),
//                                       border: Border.all(color: cs.error),
//                                     ),
//                                     child: Text(
//                                       "⚠ Missing: ${missingFields.join(', ')}",
//                                       textAlign: TextAlign.center,
//                                       style: theme.textTheme.bodySmall?.copyWith(
//                                         color: cs.error,
//                                         fontWeight: FontWeight.w600,
//                                         fontSize: detailFontSize,
//                                       ),
//                                       maxLines: 4,
//                                       overflow: TextOverflow.ellipsis,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                         // Top right count number badge
//                         Positioned(
//                           top: 8,
//                           right: 8,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                             decoration: BoxDecoration(
//                               color: cs.primary.withOpacity(0.8),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Text(
//                               '$displayIndex',
//                               style: theme.textTheme.bodySmall?.copyWith(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 12,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//       ],
//     );
//   }
//
//   Future<void> _loaduserdata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _number = prefs.getString('number') ?? '';
//       _SUbid = prefs.getString('id_future') ?? '';
//     });
//   }
//
//   void _showAddOptionsDialog() {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         final screenWidth = MediaQuery.of(context).size.width;
//         final isTablet = screenWidth > 600;
//         return DraggableScrollableSheet(
//           initialChildSize: isTablet ? 0.4 : 0.52,
//           minChildSize: 0.25,
//           maxChildSize: 0.9,
//           builder: (_, controller) {
//             return Container(
//               padding: EdgeInsets.all(isTablet ? 24 : 16),
//               decoration: BoxDecoration(
//                 color: Theme
//                     .of(context)
//                     .brightness == Brightness.dark ? Colors.grey[900] : Colors
//                     .white,
//                 borderRadius: const BorderRadius.vertical(
//                     top: Radius.circular(20)),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Center(
//                     child: Container(
//                       width: isTablet ? 50 : 42,
//                       height: isTablet ? 6 : 5,
//                       decoration: BoxDecoration(
//                         color: Theme
//                             .of(context)
//                             .brightness == Brightness.dark
//                             ? Colors.grey[700]
//                             : Colors.grey[300],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: isTablet ? 20 : 16),
//                   Text(
//                     'Form options',
//                     style: TextStyle(
//                         fontSize: isTablet ? 22 : 18,
//                         fontWeight: FontWeight.bold,
//                         color: Theme
//                             .of(context)
//                             .brightness == Brightness.dark ? Colors.white : Colors
//                             .black
//                     ),
//                   ),
//                   SizedBox(height: isTablet ? 10 : 8),
//                   Text(
//                       'Choose one of the options below to add a new forms.',
//                       style: TextStyle(
//                         color: Theme
//                             .of(context)
//                             .brightness == Brightness.dark
//                             ? Colors.grey[300]
//                             : Colors.grey[800],
//                         fontSize: isTablet ? 16 : 14,
//                       )
//                   ),
//                   SizedBox(height: isTablet ? 20 : 16),
//                   Expanded(
//                     child: ListView(
//                       controller: controller,
//                       children: [
//                         _buildOptionTile(
//                           icon: Icons.apartment,
//                           title: 'Add Building',
//                           subtitle: 'Add a new residential building',
//                           onTap: () {
//                             Navigator.of(context).pop();
//                             Navigator.push(context, MaterialPageRoute(
//                                 builder: (context) => const Add_FutureProperty())).then((_) {
//                               _refreshProperties();
//                             });
//                           },
//                           isTablet: isTablet,
//                         ),
//                         SizedBox(height: isTablet ? 12 : 8),
//                         // _buildOptionTile(
//                         //   icon: Icons.landscape,
//                         //   title: 'Add Plot',
//                         //   subtitle: 'Add a new plot record',
//                         //   onTap: () async {
//                         //     Navigator.of(context).pop();
//                         //     final result = await Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //         builder: (context) =>  PropertyListingPage(),
//                         //       ),
//                         //     );
//                         // if (result != null) {
//                         //   ScaffoldMessenger.of(context).showSnackBar(
//                         //     SnackBar(
//                         //         content: Text(
//                         //             'Plot added',
//                         //             style: TextStyle(fontSize: isTablet ? 16 : 14)
//                         //         ),
//                         //         backgroundColor: Colors.green
//                         //     ),
//                         //   );
//                         // }
//                         //   },
//                         //   isTablet: isTablet,
//                         // ),
//                         //SizedBox(height: isTablet ? 12 : 8),
//                         // _buildOptionTile(
//                         //   icon: Icons.storefront,
//                         //   title: 'Add Commercial',
//                         //   subtitle: 'Add a commercial property',
//                         //   onTap: () async {
//                         //     Navigator.of(context).pop();
//                         //     final result = await Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //           builder: (context) =>  CommercialPropertyForm()
//                         //       ),
//                         //     );
//                         //     if (result != null) {
//                         //       ScaffoldMessenger.of(context).showSnackBar(
//                         //         SnackBar(
//                         //             content: Text(
//                         //                 'Commercial added',
//                         //                 style: TextStyle(fontSize: isTablet ? 16 : 14)
//                         //             ),
//                         //             backgroundColor: Colors.green
//                         //         ),
//                         //       );
//                         //     }
//                         //   },
//                         //   isTablet: isTablet,
//                         // ),
//                         // _buildOptionTile(
//                         //   icon: Icons.landscape,
//                         //   title: 'Add Plot',
//                         //   subtitle: 'Add a new plot record',
//                         //   onTap: () async {
//                         //     Navigator.of(context).pop();
//                         //     final result = await Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //         builder: (context) =>  PropertyListingPage(),
//                         //       ),
//                         //     );
//                         //     if (result != null) {
//                         //       ScaffoldMessenger.of(context).showSnackBar(
//                         //         SnackBar(
//                         //             content: Text(
//                         //                 'Plot added',
//                         //                 style: TextStyle(fontSize: isTablet ? 16 : 14)
//                         //             ),
//                         //             backgroundColor: Colors.green
//                         //         ),
//                         //       );
//                         //     }
//                         //   },
//                         //   isTablet: isTablet,
//                         // ),
//                         // SizedBox(height: isTablet ? 12 : 8),
//                         // _buildOptionTile(
//                         //   icon: Icons.storefront,
//                         //   title: 'Add Commercial',
//                         //   subtitle: 'Add a commercial property',
//                         //   onTap: () async {
//                         //     Navigator.of(context).pop();
//                         //     final result = await Navigator.push(
//                         //       context,
//                         //       MaterialPageRoute(
//                         //           builder: (context) =>  CommercialPropertyForm()
//                         //       ),
//                         //     );
//                         //     if (result != null) {
//                         //       ScaffoldMessenger.of(context).showSnackBar(
//                         //         SnackBar(
//                         //             content: Text(
//                         //                 'Commercial added',
//                         //                 style: TextStyle(fontSize: isTablet ? 16 : 14)
//                         //             ),
//                         //             backgroundColor: Colors.green
//                         //         ),
//                         //       );
//                         //     }
//                         //   },
//                         //   isTablet: isTablet,
//                         // ),
//                         SizedBox(height: isTablet ? 16 : 12),
//                         ElevatedButton(
//                           onPressed: () => Navigator.of(context).pop(),
//                           child: Text(
//                             'Cancel',
//                             style: TextStyle(
//                               fontSize: isTablet ? 16 : 14,
//                             ),
//                           ),)
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Widget _buildOptionTile({
//     required IconData icon,
//     required String title,
//     String? subtitle,
//     required VoidCallback onTap,
//     required bool isTablet,
//   }) {
//     return Card(
//       elevation: 3,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: ListTile(
//         onTap: onTap,
//         leading: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(10),
//             color: Theme
//                 .of(context)
//                 .brightness == Brightness.dark ? Colors.grey[800] : Colors.grey
//                 .shade100,
//           ),
//           padding: EdgeInsets.all(isTablet ? 12 : 8),
//           child: Icon(
//               icon,
//               size: isTablet ? 32 : 28,
//               color: Colors.black87
//           ),
//         ),
//         title: Text(
//             title,
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: isTablet ? 18 : 16
//             )
//         ),
//         subtitle: subtitle != null ? Text(
//           subtitle,
//           style: TextStyle(fontSize: isTablet ? 15 : 14),
//         ) : null,
//         trailing: Icon(
//             Icons.arrow_forward_ios,
//             size: isTablet ? 18 : 16
//         ),
//       ),
//     );
//   }
// }