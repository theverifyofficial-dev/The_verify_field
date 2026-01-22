import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../Custom_Widget/constant.dart';
import '../Administater_Realestate_Details.dart';
import 'package:intl/intl.dart';

class SeeALLModel {
  final int id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeOfProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squareFit;
  final String maintance;
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
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final int subid;
  final String? sourceId; // NEW, nullable

  const SeeALLModel({
    required this.id,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeOfProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squareFit,
    required this.maintance,
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
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subid,
    this.sourceId, // NEW

  });

  factory SeeALLModel.fromJson(Map<String, dynamic> json) {
    return SeeALLModel(
      id: json['P_id'] is int
          ? json['P_id']
          : int.tryParse(json['P_id']?.toString() ?? '0') ?? 0,
      propertyPhoto: json['property_photo']?.toString() ?? '',
      locations: json['locations']?.toString() ?? '',
      flatNumber: json['Flat_number']?.toString() ?? '',
      buyRent: json['Buy_Rent']?.toString() ?? '',
      residenceCommercial: json['Residence_Commercial']?.toString() ?? '',
      apartmentName: json['Apartment_name']?.toString() ?? '',
      apartmentAddress: json['Apartment_Address']?.toString() ?? '',
      typeOfProperty: json['Typeofproperty']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      showPrice: json['show_Price']?.toString() ?? '',
      lastPrice: json['Last_Price']?.toString() ?? '',
      askingPrice: json['asking_price']?.toString() ?? '',
      floor: json['Floor_']?.toString() ?? '',
      totalFloor: json['Total_floor']?.toString() ?? '',
      balcony: json['Balcony']?.toString() ?? '',
      squareFit: json['squarefit']?.toString() ?? '',
      maintance: json['maintance']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',
      ageOfProperty: json['age_of_property']?.toString() ?? '',
      fieldWorkerAddress: json['fieldworkar_address']?.toString() ?? '',
      roadSize: json['Road_Size']?.toString() ?? '',
      metroDistance: json['metro_distance']?.toString() ?? '',
      highwayDistance: json['highway_distance']?.toString() ?? '',
      mainMarketDistance: json['main_market_distance']?.toString() ?? '',
      meter: json['meter']?.toString() ?? '',
      ownerName: json['owner_name']?.toString() ?? '',
      ownerNumber: json['owner_number']?.toString() ?? '',
      currentDates: json['current_dates']?.toString() ?? '',
      availableDate: json['available_date']?.toString() ?? '',
      kitchen: json['kitchen']?.toString() ?? '',
      bathroom: json['bathroom']?.toString() ?? '',
      lift: json['lift']?.toString() ?? '',
      facility: json['Facility']?.toString() ?? '',
      furnishedUnfurnished: json['furnished_unfurnished']?.toString() ?? '',
      fieldWorkerName: json['field_warkar_name']?.toString() ?? '',
      liveUnlive: json['live_unlive']?.toString() ?? '',
      fieldWorkerNumber: json['field_workar_number']?.toString() ?? '',
      registryAndGpa: json['registry_and_gpa']?.toString() ?? '',
      loan: json['loan']?.toString() ?? '',
      longitude: json['Longitude']?.toString() ?? '',
      latitude: json['Latitude']?.toString() ?? '',
      videoLink: json['video_link']?.toString() ?? '',
      fieldWorkerCurrentLocation:
      json['field_worker_current_location']?.toString() ?? '',
      careTakerName: json['care_taker_name']?.toString() ?? '',
      careTakerNumber: json['care_taker_number']?.toString() ?? '',
      sourceId: json['source_id']?.toString(), // NEW

      subid: json['subid'] is int
          ? json['subid']
          : int.tryParse(json['subid']?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "P_id": id,
      "property_photo": propertyPhoto,
      "locations": locations,
      "Flat_number": flatNumber,
      "Buy_Rent": buyRent,
      "Residence_Commercial": residenceCommercial,
      "Apartment_name": apartmentName,
      "Apartment_Address": apartmentAddress,
      "Typeofproperty": typeOfProperty,
      "Bhk": bhk,
      "show_Price": showPrice,
      "Last_Price": lastPrice,
      "asking_price": askingPrice,
      "Floor_": floor,
      "Total_floor": totalFloor,
      "Balcony": balcony,
      "squarefit": squareFit,
      "maintance": maintance,
      "parking": parking,
      "age_of_property": ageOfProperty,
      "fieldworkar_address": fieldWorkerAddress,
      "Road_Size": roadSize,
      "metro_distance": metroDistance,
      "highway_distance": highwayDistance,
      "main_market_distance": mainMarketDistance,
      "meter": meter,
      "owner_name": ownerName,
      "owner_number": ownerNumber,
      "current_dates": currentDates,
      "available_date": availableDate,
      "kitchen": kitchen,
      "bathroom": bathroom,
      "lift": lift,
      "Facility": facility,
      "furnished_unfurnished": furnishedUnfurnished,
      "field_warkar_name": fieldWorkerName,
      "live_unlive": liveUnlive,
      "field_workar_number": fieldWorkerNumber,
      "registry_and_gpa": registryAndGpa,
      "loan": loan,
      "Longitude": longitude,
      "Latitude": latitude,
      "video_link": videoLink,
      "field_worker_current_location": fieldWorkerCurrentLocation,
      "care_taker_name": careTakerName,
      "care_taker_number": careTakerNumber,
      "subid": subid,
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

class See_All_Realestate extends StatefulWidget {
  String id;
  See_All_Realestate({super.key, required this.id});

  @override
  State<See_All_Realestate> createState() => _See_All_RealestateState();
}

class _See_All_RealestateState extends State<See_All_Realestate> {

  Future<void> _loadData() async {
    try {
      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
            "?field_workar_number=${widget.id}" /* &live_unlive=Live */ ,
      );

      final resp = await http.get(url);
      if (resp.statusCode != 200) {
        debugPrint("HTTP ${resp.statusCode}: ${resp.body}");
        return;
      }

      final decoded = json.decode(resp.body);

      // --- unwrap payloads: {success,data} or .asmx {"d":"[...]"}
      dynamic payload;
      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        payload = decoded['data'];
      } else if (decoded is Map<String, dynamic> && decoded.containsKey('d')) {
        final d = decoded['d'];
        try {
          payload = d is String ? json.decode(d) : d;
        } catch (_) {
          payload = d;
        }
      } else {
        payload = decoded;
      }

      // --- normalize to List<Map<String,dynamic>>
      List<Map<String, dynamic>> list;
      if (payload is List) {
        list = payload.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      } else if (payload is Map) {
        list = [Map<String, dynamic>.from(payload)];
      } else {
        list = const [];
      }

      // --- newest first by P_id (even if it comes as string)
      int asInt(dynamic v) => v is int ? v : (int.tryParse(v?.toString() ?? '') ?? 0);
      list.sort((a, b) => asInt(b['P_id']).compareTo(asInt(a['P_id'])));

      final items = list.map((m) => SeeALLModel.fromJson(m)).toList();

      if (!mounted) return;
      setState(() {
        _allData = items;
        _filteredData = List<SeeALLModel>.from(_allData);
      });
    } catch (e) {
      debugPrint("fetchData error: $e");
    }
  }
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return "-";
    try {
      DateTime date = DateTime.parse(dateString); // expects yyyy-MM-dd or full ISO format
      return DateFormat('dd/MMM/yyyy').format(date); // Example: 29-08-2025
    } catch (e) {
      return dateString; // fallback if parsing fails
    }
  }
  TextEditingController _searchController = TextEditingController();
  List<SeeALLModel> _allData = [];   // full fetched data
  List<SeeALLModel> _filteredData = []; // filtered list
  final Map<int, int> _liveCountMap = {}; // subid -> live count
  final Map<int, String> _totalFlatsMap = {}; // subid -> total flats count as String

  @override
  void initState() {
    super.initState();
    _loadData();
    // _prefetchAllPropertyData(); // Commented out as it fetches live/unlive data
  }

  // Future<void> _prefetchAllPropertyData() async { // Commented out entire method
  //   final allProperties = _allData;
  //   if (allProperties.isEmpty) return;
  //   final uniqueSubids = <int>{};
  //   for (var p in allProperties) {
  //     uniqueSubids.add(p.subid);
  //   }
  //   final futures = uniqueSubids.map((sid) async {
  //     try {
  //       // Fetch total flats
  //       final response2 = await http.get(Uri.parse(
  //         'https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=$sid',
  //       ));
  //       String totalStr = "0";
  //       if (response2.statusCode == 200) {
  //         final body = jsonDecode(response2.body);
  //         if (body is List && body.isNotEmpty) {
  //           totalStr = body[0]['logg'].toString();
  //         }
  //       }
  //       _totalFlatsMap[sid] = totalStr;
  //       // Fetch live count
  //       final response3 = await http.get(Uri.parse(
  //         'https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=$sid',
  //       ));
  //       int liveC = 0;
  //       if (response3.statusCode == 200) {
  //         final body3 = jsonDecode(response3.body);
  //         if (body3 is List && body3.isNotEmpty) {
  //           for (var item in body3) {
  //             if (item['live_unlive'] == 'Live') {
  //               liveC = (item['logs'] as num?)?.toInt() ?? 0;
  //               break;
  //             }
  //           }
  //         }
  //       }
  //       _liveCountMap[sid] = liveC;
  //     } catch (_) {
  //       _totalFlatsMap[sid] = "0";
  //       _liveCountMap[sid] = 0;
  //     }
  //   }).toList();
  //   await Future.wait(futures);
  //   if (mounted) setState(() {});
  // }

  bool _blank(String? s) => s == null || s.trim().isEmpty;

  List<String> _missingFieldsFor(SeeALLModel i) {
    final m = <String>[];
    final checks = <String, String?>{
      "Photo": i.propertyPhoto,
      "Location": i.locations,
      "Flat Number": i.flatNumber,
      "Buy/Rent": i.buyRent,
      "Residence/Commercial": i.residenceCommercial,
      "Apartment Address": i.apartmentAddress,
      "Owner Name": i.ownerName,
      "Owner Number": i.ownerNumber,
      "Available Date": i.availableDate,
      "Caretaker Name": i.careTakerName,
      "Caretaker Number": i.careTakerNumber,
    };
    checks.forEach((k, v) { if (_blank(v)) m.add(k); });
    return m;
  }

  bool _hasMissing(SeeALLModel i) => _missingFieldsFor(i).isNotEmpty;

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

  Widget _buildImageSection({
    required List<String> images,
    required ColorScheme cs,
    required ThemeData theme,
    required Map<String, dynamic> status,
    required double imageHeight,
    required double multiImgHeight,
    required bool isTablet,
  }) {
    // final int liveCount = status['liveCount'] ?? 0; // Commented out
    // final Color liveColor = liveCount > 0 ? Colors.green : Colors.red; // Commented out
    // final String liveLabel = liveCount > 0 ? "Live: $liveCount" : "Unlive: 0"; // Commented out

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
      ],
    );
  }

  List<String> _buildMultipleImages(SeeALLModel p) {
    final List<String> imgs = [];
    if (p.propertyPhoto != null && p.propertyPhoto.isNotEmpty) {
      imgs.add('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.propertyPhoto}');
    }
    return imgs;
  }

  Widget _buildCard(SeeALLModel property, int displayIndex, bool isDarkMode) {
    final bool isHighlighted = false; // No highlighting in this screen
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isSmallScreen = screenWidth < 400;

    final status = {
      "loggValue2": _totalFlatsMap[property.subid] ?? '0',
      // "liveCount": _liveCountMap[property.subid] ?? 0, // Commented out
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

    final Widget flatIdDetail = _DetailRow(
      icon: Icons.format_list_numbered,
      label: 'Property iD',
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
      images: images,
      cs: cs,
      theme: theme,
      status: status,
      imageHeight: imageH,
      multiImgHeight: multiH,
      isTablet: isTablet,
    );

    // Priority detail rows based on user request
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
      icon: Icons.handshake_outlined,
      label: '',
      value: property.buyRent ?? 'N/A',
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
      value: formatDate(property.currentDates ?? ''),
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
      padding: EdgeInsets.only(top: isTablet ? 16.0 : 12.0), // Reduced top padding
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

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // Adjusted for vertical list
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

  void _searchData(String query) {
    final input = query.toLowerCase();

    final results = _allData.where((item) {
      // Convert whole object into a big searchable string
      final combined = [
        item.id.toString(),
        item.propertyPhoto,
        item.locations,
        item.flatNumber,
        item.buyRent,
        item.residenceCommercial,
        item.apartmentName,
        item.apartmentAddress,
        item.typeOfProperty,
        item.bhk,
        item.showPrice,
        item.lastPrice,
        item.askingPrice,
        item.floor,
        item.totalFloor,
        item.balcony,
        item.squareFit,
        item.maintance,
        item.parking,
        item.ageOfProperty,
        item.fieldWorkerAddress,
        item.roadSize,
        item.metroDistance,
        item.highwayDistance,
        item.mainMarketDistance,
        item.meter,
        item.ownerName,
        item.ownerNumber,
        item.currentDates,
        item.availableDate,
        item.kitchen,
        item.bathroom,
        item.lift,
        item.facility,
        item.furnishedUnfurnished,
        item.fieldWorkerName,
        item.liveUnlive,
        item.fieldWorkerNumber,
        item.registryAndGpa,
        item.loan,
        item.longitude,
        item.latitude,
        item.videoLink,
        item.fieldWorkerCurrentLocation,
        item.careTakerName,
        item.careTakerNumber,
        item.subid.toString(),
      ].join(" ").toLowerCase();

      return combined.contains(input);
    }).toList();

    setState(() {
      _filteredData = results;
    });
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // backgroundColor: Colors.black,
        appBar: AppBar(
          surfaceTintColor: Colors.black,
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Image.asset(AppImages.verify, height: 75),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Row(
              children: [
                SizedBox(
                  width: 3,
                ),
                Icon(
                  PhosphorIcons.caret_left_bold,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          // actions:  [
          //   GestureDetector(
          //     onTap: () {
          //       // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> MyHomePage()));
          //     },
          //     child: const Icon(
          //       PhosphorIcons.image,
          //       color: Colors.black,
          //       size: 30,
          //     ),
          //   ),
          //   const SizedBox(
          //     width: 20,
          //   ),
          // ],
        ),

        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search property...",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: _searchData, // call search on typing
              ),
            ),
            if (_searchController.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Results found: ${_filteredData.length}",
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ),

            // Now ListView.builder will use _filteredData
            Expanded(
              child: ListView.builder(

                itemCount: _filteredData.length,
                itemBuilder: (context, index) {
                  final item = _filteredData[index];
                  int displayIndex = _filteredData.length - index;
                  return _buildCard(item, displayIndex, isDarkMode);
                },
              ),
            ),
          ],
        )


    );
  }


// Helper widget for feature chips
  Widget _buildFeatureChip({
    required BuildContext context,
    required String text,
    required Color color,
    required IconData icon,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color getAdaptiveColor(Color lightColor, Color darkColor) {
      return isDarkMode ? darkColor : lightColor;
    }

    final adaptiveColor = color is MaterialColor
        ? getAdaptiveColor(color[600]!, color[300]!)
        : getAdaptiveColor(color, color.withOpacity(0.8));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: adaptiveColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: adaptiveColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: adaptiveColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: adaptiveColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for info items
  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String value,
    required Color color,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    Color getAdaptiveColor(Color lightColor, Color darkColor) {
      return isDarkMode ? darkColor : lightColor;
    }

    final adaptiveColor = color is MaterialColor
        ? getAdaptiveColor(color[300]!, color[300]!)
        : getAdaptiveColor(color, color.withOpacity(0.9));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: adaptiveColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: adaptiveColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: adaptiveColor,
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: adaptiveColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

// Helper widget for ID badges
  Widget _buildIdBadge({
    required BuildContext context,
    required String label,
    required String value,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final badgeColor = isDarkMode ? Colors.grey[700]! : Colors.grey[200]!;
    final textColor = isDarkMode ? Colors.grey[300]! : Colors.grey[800]!;
    final labelColor = isDarkMode ? Colors.grey[400]! : Colors.grey[600]!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: badgeColor.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'PoppinsBold',
              fontSize: 15,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}