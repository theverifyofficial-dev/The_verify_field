import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Propert_verigication_Document/Show_tenant.dart';
import '../SocialMediaHandler/VideoSubmitPage.dart';
import '../add_properties_firstpage.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_New_Property.dart';
import 'Add_RealEstate.dart';
import 'Add_image_under_property.dart';
import 'Commercial_property_Filter.dart';
import 'Filter_Options.dart';
import 'View_All_Details.dart';

class NewRealEstateShowDateModel {
  final int? pId;
  final int? sId; // subid
  final String? sourceId; // NEW
  final String? propertyPhoto;
  final String? locations;
  final String? flatNumber;
  final String? buyRent;
  final String? residenceCommercial; // NEW
  final String? apartmentName;       // NEW
  final String? apartmentAddress;
  final String? typeOfProperty;
  final String? bhk;
  final String? showPrice;
  final String? lastPrice;
  final String? askingPrice;
  final String? floor;
  final String? totalFloor;
  final String? balcony;
  final String? squarefit;
  final String? maintance;
  final String? parking;
  final String? ageOfProperty;
  final String? fieldWorkerAddress;
  final String? roadSize;
  final String? metroDistance;
  final String? highwayDistance;
  final String? mainMarketDistance;
  final String? meter;
  final String? ownerName;
  final String? ownerNumber;
  final String? currentDates;
  final String? availableDate;
  final String? kitchen;
  final String? bathroom;
  final String? lift;
  final String? facility;
  final String? furnishedUnfurnished;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? liveUnlive; // NEW
  final String? registryAndGpa;
  final String? loan;
  final String? longitude;
  final String? latitude;
  final String? fieldWorkerCurrentLocation;
  final String? careTakerName;
  final String? careTakerNumber;
  final String? video;
  final String? videoStatus;        // NEW
  final String? dateForTarget;      // NEW
  final String? videoUpdatedAt;     // NEW

  NewRealEstateShowDateModel({
    this.pId,
    this.sId,
    this.sourceId,
    this.propertyPhoto,
    this.locations,
    this.flatNumber,
    this.buyRent,
    this.residenceCommercial,
    this.apartmentName,
    this.apartmentAddress,
    this.typeOfProperty,
    this.bhk,
    this.showPrice,
    this.lastPrice,
    this.askingPrice,
    this.floor,
    this.totalFloor,
    this.balcony,
    this.squarefit,
    this.maintance,
    this.parking,
    this.ageOfProperty,
    this.fieldWorkerAddress,
    this.roadSize,
    this.metroDistance,
    this.highwayDistance,
    this.mainMarketDistance,
    this.meter,
    this.ownerName,
    this.ownerNumber,
    this.currentDates,
    this.availableDate,
    this.kitchen,
    this.bathroom,
    this.lift,
    this.facility,
    this.furnishedUnfurnished,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.liveUnlive,
    this.registryAndGpa,
    this.loan,
    this.longitude,
    this.latitude,
    this.fieldWorkerCurrentLocation,
    this.careTakerName,
    this.careTakerNumber,
    this.video,
    this.videoStatus,
    this.dateForTarget,
    this.videoUpdatedAt,
  });
// tiny helpers so backend shenanigans don't break you
  static int? _asInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  static String? _asStr(dynamic v) {
    if (v == null) return null;

    final str = v.toString().trim();

    if (str.isEmpty) return null;
    if (str.toLowerCase() == "null") return null; // FIX: treat "null" as null

    return str;
  }


  factory NewRealEstateShowDateModel.fromJson(Map<String, dynamic> json) {
    return NewRealEstateShowDateModel(
      pId: _asInt(json['P_id']),
      sId: _asInt(json['subid']),
      sourceId: _asStr(json['source_id']),
      propertyPhoto: _asStr(json['property_photo']),
      locations: _asStr(json['locations']),
      flatNumber: _asStr(json['Flat_number']),
      buyRent: _asStr(json['Buy_Rent']),
      residenceCommercial: _asStr(json['Residence_Commercial']),
      apartmentName: _asStr(json['Apartment_name']),
      apartmentAddress: _asStr(json['Apartment_Address']),
      typeOfProperty: _asStr(json['Typeofproperty']),
      bhk: _asStr(json['Bhk']),
      showPrice: _asStr(json['show_Price']),
      lastPrice: _asStr(json['Last_Price']),
      askingPrice: _asStr(json['asking_price']),
      floor: _asStr(json['Floor_']),
      totalFloor: _asStr(json['Total_floor']),
      balcony: _asStr(json['Balcony']),
      squarefit: _asStr(json['squarefit']),
      maintance: _asStr(json['maintance']),
      parking: _asStr(json['parking']),
      ageOfProperty: _asStr(json['age_of_property']),
      fieldWorkerAddress: _asStr(json['fieldworkar_address']),
      roadSize: _asStr(json['Road_Size']),
      metroDistance: _asStr(json['metro_distance']),
      highwayDistance: _asStr(json['highway_distance']),
      mainMarketDistance: _asStr(json['main_market_distance']),
      meter: _asStr(json['meter']),
      ownerName: _asStr(json['owner_name']),
      ownerNumber: _asStr(json['owner_number']),
      currentDates: _asStr(json['current_dates']),
      availableDate: _asStr(json['available_date']),
      kitchen: _asStr(json['kitchen']),
      bathroom: _asStr(json['bathroom']),
      lift: _asStr(json['lift']),
      facility: _asStr(json['Facility']),
      furnishedUnfurnished: _asStr(json['furnished_unfurnished']),
      fieldWorkerName: _asStr(json['field_warkar_name']),
      fieldWorkerNumber: _asStr(json['field_workar_number']),
      liveUnlive: _asStr(json['live_unlive']),
      registryAndGpa: _asStr(json['registry_and_gpa']),
      loan: _asStr(json['loan']),
      longitude: _asStr(json['Longitude']),
      latitude: _asStr(json['Latitude']),
      fieldWorkerCurrentLocation: _asStr(json['field_worker_current_location']),
      careTakerName: _asStr(json['care_taker_name']),
      careTakerNumber: _asStr(json['care_taker_number']),
      video: _asStr(json['video_link']),
      videoStatus: _asStr(json['video_status']),
      dateForTarget: _asStr(json['date_for_target']),

      // 🔥 FIXED HERE
      videoUpdatedAt: _asStr(json['video_updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'P_id': pId,
      'subid': sId,
      'source_id': sourceId,
      'property_photo': propertyPhoto,
      'locations': locations,
      'Flat_number': flatNumber,
      'Buy_Rent': buyRent,
      'Residence_Commercial': residenceCommercial,
      'Apartment_name': apartmentName,
      'Apartment_Address': apartmentAddress,
      'Typeofproperty': typeOfProperty,
      'Bhk': bhk,
      'show_Price': showPrice,
      'Last_Price': lastPrice,
      'asking_price': askingPrice,
      'Floor_': floor,
      'Total_floor': totalFloor,
      'Balcony': balcony,
      'squarefit': squarefit,
      'maintance': maintance,
      'parking': parking,
      'age_of_property': ageOfProperty,
      'fieldworkar_address': fieldWorkerAddress,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'highway_distance': highwayDistance,
      'main_market_distance': mainMarketDistance,
      'meter': meter,
      'owner_name': ownerName,
      'owner_number': ownerNumber,
      'current_dates': currentDates,
      'available_date': availableDate,
      'kitchen': kitchen,
      'bathroom': bathroom,
      'lift': lift,
      'Facility': facility,
      'furnished_unfurnished': furnishedUnfurnished,
      'field_warkar_name': fieldWorkerName,
      'field_workar_number': fieldWorkerNumber,
      'live_unlive': liveUnlive,
      'registry_and_gpa': registryAndGpa,
      'loan': loan,
      'Longitude': longitude,
      'Latitude': latitude,
      'field_worker_current_location': fieldWorkerCurrentLocation,
      'care_taker_name': careTakerName,
      'care_taker_number': careTakerNumber,
      'video_link': video,

      'video_status': videoStatus,
      'date_for_target': dateForTarget,
      'video_updated_at': videoUpdatedAt,

    };
  }
}

class Show_New_Real_Estate extends StatefulWidget {
  final String? highlightPropertyId;

  const Show_New_Real_Estate({super.key, this.highlightPropertyId});

  @override
  State<Show_New_Real_Estate> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<Show_New_Real_Estate> {
  List<NewRealEstateShowDateModel> _allProperties = [];
  List<NewRealEstateShowDateModel> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _number = '';
  String _name = '';
  String _aadhar = '';
  int propertyCount = 0;
  String? selectedLabel;
  final ScrollController _scrollController = ScrollController();

  Map<int, String> submittedStatus = {};

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> saveStatus(int id, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("video_status_$id", status);
  }

  Future<String?> loadStatus(int id) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("video_status_$id");
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase().trim();
    final filtered = _allProperties.where((item) {
      final values = [
        item.pId?.toString(),
        item.locations,
        item.apartmentAddress,
        item.typeOfProperty,
        item.bhk,
        item.showPrice,
        item.floor,
        item.totalFloor,
        item.balcony,
        item.squarefit,
        item.maintance,
        item.parking,
        item.kitchen,
        item.bathroom,
        item.facility,
        item.furnishedUnfurnished,
        item.buyRent,
        item.longitude,
        item.latitude,
        item.propertyPhoto,
        item.ageOfProperty,
        item.registryAndGpa,
        item.loan,
        item.flatNumber,
        item.currentDates,
        item.availableDate,
        item.ownerName,
        item.ownerNumber,
        item.fieldWorkerName,
        item.fieldWorkerNumber,
        item.careTakerName,
        item.careTakerNumber,
      ];
      return values.any((v) => v != null && v.toString().toLowerCase().contains(query));
    }).toList();

    setState(() {
      _filteredProperties = filtered;
      propertyCount = filtered.length;
    });
  }

  Future<List<NewRealEstateShowDateModel>> fetchData(String number) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_mainrealestate_by_fieldworkar.php"
          "?field_workar_number=$number&live_unlive=Live",
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

    int _asInt(dynamic v) => v is int ? v : (int.tryParse(v?.toString() ?? "0") ?? 0);
    listResponse.sort((a, b) => _asInt(b['P_id']).compareTo(_asInt(a['P_id'])));

    return listResponse.map((data) => NewRealEstateShowDateModel.fromJson(data)).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata();
  }

  Future<void> _loaduserdata() async {
    final prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _number = prefs.getString('number') ?? '';
    _aadhar = prefs.getString('post') ?? '';

    await _fetchProperties();

    for (var property in _allProperties) {
      final saved = await loadStatus(property.pId ?? 0);
      if (saved != null) {
        submittedStatus[property.pId ?? 0] = saved;
      }
    }
  }

  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData(_number);
      setState(() {
        _allProperties = data;
        _filteredProperties = data;
        _isLoading = false;
      });

      for (var property in _allProperties) {
        final saved = await loadStatus(property.pId ?? 0);
        if (saved != null) submittedStatus[property.pId ?? 0] = saved;
      }

      if (widget.highlightPropertyId != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          int index = _filteredProperties.indexWhere(
                (item) => item.pId.toString() == widget.highlightPropertyId,
          );
          if (index != -1) {
            _scrollController.animateTo(
              index * MediaQuery.of(context).size.height * 0.80,
              duration: const Duration(milliseconds: 700),
              curve: Curves.easeOut,
            );
          }
        });
      }
    } catch (e) {
      print("Error: $e");
      setState(() => _isLoading = false);
    }
  }

  void _setSearchText(String label, String text) {
    setState(() {
      selectedLabel = label;
      _searchController.text = text;
      _searchController.selection = TextSelection.fromPosition(
        TextPosition(offset: _searchController.text.length),
      );
    });
  }

  bool get _isSearchActive => _searchController.text.trim().isNotEmpty || selectedLabel != null;

  // ====================== CARD HELPERS ======================

  bool _blank(String? s) => s == null || s.trim().isEmpty;

  Color _getIconColor(IconData icon, ThemeData theme) {
    final cs = theme.colorScheme;
    switch (icon) {
      case Icons.location_on: return Colors.red;
      case Icons.currency_rupee: return Colors.green;
      case Icons.king_bed: return Colors.pink;
      case Icons.layers: return Colors.teal;
      case Icons.apartment: return Colors.blue;
      case Icons.format_list_numbered: return Colors.indigo;
      case Icons.numbers: return Colors.cyan;
      case Icons.person: return Colors.deepPurple;
      default: return cs.primary;
    }
  }

  Widget _buildImageSection({
    required String? imageUrl,
    required ColorScheme cs,
    required ThemeData theme,
    required double imageHeight,
  }) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        height: imageHeight,
        decoration: BoxDecoration(color: cs.surfaceVariant, borderRadius: BorderRadius.circular(12)),
        child: const Icon(Icons.apartment, size: 90, color: Colors.grey),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: imageHeight,
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/$imageUrl",
          fit: BoxFit.cover,
          placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
          errorWidget: (_, __, ___) => Icon(Icons.broken_image, color: cs.error, size: 90),
        ),
      ),
    );
  }

  Widget _buildCard(NewRealEstateShowDateModel property, List<String> missingFields, bool hasMissingFields) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
      imageHeight: imageH,
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

    if (!_blank(property.locations)) {
      detailRows.add(_DetailRow(icon: Icons.location_on, label: '', value: property.locations!, theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    }
    detailRows.add(_DetailRow(icon: Icons.currency_rupee, label: '', value: '₹${property.showPrice ?? 'N/A'}', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    detailRows.add(_DetailRow(icon: Icons.currency_rupee, label: '', value: '${property.buyRent ?? 'N/A'}', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    detailRows.add(_DetailRow(icon: Icons.king_bed, label: '', value: property.bhk ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    detailRows.add(_DetailRow(icon: Icons.layers, label: '', value: property.floor ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    detailRows.add(_DetailRow(icon: Icons.apartment, label: '', value: property.typeOfProperty ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    detailRows.add(_DetailRow(icon: Icons.format_list_numbered, label: 'Flat No', value: property.flatNumber ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));

    if (property.sId != null && property.sId != 0) {
      detailRows.add(_DetailRow(icon: Icons.numbers, label: 'Building ID', value: property.sId.toString(), theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    }
    detailRows.add(_DetailRow(icon: Icons.numbers, label: 'Building Flat ID', value: property.sourceId ?? 'N/A', theme: theme, getIconColor: _getIconColor, fontSize: detailFontSize, fontWeight: FontWeight.bold));
    // Video Status Button
    Widget? videoStatusButton;
    if (!_blank(property.videoStatus)) {
      String st = (property.videoStatus ?? "").trim().toLowerCase();
      Color btnColor = Colors.red;
      IconData btnIcon = Icons.error_outline;
      String btnText = "Pending";

      if (st == "video submitted") { btnColor = Colors.green; btnIcon = Icons.check_circle; btnText = "Video Submitted"; }
      else if (st == "video requested by editor") { btnColor = Colors.blue; btnText = property.videoStatus!; }
      else if (st == "video recived and editing started") { btnColor = Colors.orange; btnText = property.videoStatus!; }
      else if (st == "video uploaded") { btnColor = Colors.purple; btnIcon = Icons.check_circle; btnText = property.videoStatus!; }
      else if (st.isEmpty) { btnText = "Pending"; }

      videoStatusButton = Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: InkWell(
          onTap: () async {
            bool isPending = st.isEmpty;
            bool isEditingStarted = st == "video recived and editing started";
            bool isUploaded = st == "video uploaded";

            if (isEditingStarted || isUploaded) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Editing already started")));
              await Navigator.push(context, MaterialPageRoute(builder: (_) => SubmitVideoPage(propertyId: property.pId ?? 0, status: st, action: "view_only", userName: _name, userRole: "fieldworker")));
              return;
            }

            String actionToSend = st == "video requested by editor" ? "fieldworker_reply" : "submit_video";
            String displayStatus = isPending ? "Pending" : property.videoStatus!;

            final result = await Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SubmitVideoPage(propertyId: property.pId ?? 0, status: displayStatus, action: actionToSend, userName: _name, userRole: "fieldworker")),
            );
            if (result == true) _fetchProperties();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: btnColor, borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(btnIcon, color: Colors.white, size: 18),
                const SizedBox(width: 6),
                Text(btnText, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      );
    }

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
            MaterialPageRoute(builder: (context) => View_Details(id: property.pId ?? 0)),
          );
        },
        child: Card(
          elevation: isDarkMode ? 0 : 4,
          color: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.dividerColor.withOpacity(0.5)),
          ),
          child: Padding(
            padding: EdgeInsets.all(cardPadding),
            child: Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: isSmallScreen ? 1 : (isTablet ? 2 : 2), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [imageSection, const SizedBox(height: 6), livePropertyIdRow])),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: isSmallScreen ? 1 : (isTablet ? 3 : 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              property.apartmentAddress ?? property.fieldWorkerAddress ?? property.locations ?? 'No Title',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, fontSize: titleFontSize),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            ...detailRows,
                            if (videoStatusButton != null) videoStatusButton,
                            const Spacer(),
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
                      decoration: BoxDecoration(color: cs.errorContainer, borderRadius: BorderRadius.circular(6), border: Border.all(color: cs.error)),
                      child: Text(
                        "⚠ Missing: ${missingFields.join(', ')}",
                        style: theme.textTheme.bodySmall?.copyWith(color: cs.error, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(child: Image.asset(AppImages.loader, height: 50))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.clear_rounded), onPressed: () => _searchController.clear())
                    : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.4),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withOpacity(0.3))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5)),
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          // Filter buttons (Rent, Buy, Commercial) - same as before
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Rent', 'Buy', 'Commercial'].map((label) {
                  final bool isSelected = label == selectedLabel;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ElevatedButton(
                      onPressed: () => _setSearchText(label, label),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          if (propertyCount > 0 && _isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                    const SizedBox(width: 6),
                    Text("$propertyCount properties found"),
                    const SizedBox(width: 6),
                    InkWell(onTap: () {
                      setState(() {
                        _searchController.clear();
                        selectedLabel = null;
                        _filteredProperties = _allProperties;
                        propertyCount = 0;
                      });
                    }, child: const Icon(Icons.close, size: 18)),
                  ],
                ),
              ),
            ),
          _filteredProperties.isEmpty
              ? const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No properties found", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  Text("Try a different search term", style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          )
              : Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchProperties,
              child: ListView.builder(
                controller: _scrollController,
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

                  final missingFields = fields.entries.where((e) => _blank(e.value)).map((e) => e.key).toList();
                  final hasMissingFields = missingFields.isNotEmpty;

                  return _buildCard(property, missingFields, hasMissingFields);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Detail Row Widget (same as before)
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color Function(IconData, ThemeData) getIconColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.getIconColor,
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
          Icon(icon, size: 14, color: getIconColor(icon, theme)),
          const SizedBox(width: 4),
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.1, color: cs.onSurface.withOpacity(0.7), fontSize: fontSize ?? 12),
                children: [
                  if (label.isNotEmpty)
                    TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: value, style: TextStyle(fontWeight: fontWeight ?? FontWeight.normal, color: cs.onSurface.withOpacity(0.9))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}