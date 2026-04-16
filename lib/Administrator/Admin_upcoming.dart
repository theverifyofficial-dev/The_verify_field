import 'dart:async';
import 'dart:convert';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/upcoming_model.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Admin_upcoming_details.dart';


class AdminUpcoming extends StatefulWidget {
  const AdminUpcoming({super.key});

  @override
  State<AdminUpcoming> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<AdminUpcoming> {

  List<Upcoming_model> _allProperties = [];
  List<Upcoming_model> _filteredProperties = [];
  TextEditingController _searchController = TextEditingController();

  bool _isLoading = true;
  String _number = '';
  String _FAadharCard = '';
  String _location = '';
  String _name = '';
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
    final query = _searchController.text.toLowerCase();
    final filtered = _allProperties.where((item) {
      return (item.locations ?? '').toLowerCase().contains(query) ||
          (item.apartmentAddress ?? '').toLowerCase().contains(query) ||
          (item.pId ?? '').toString().toLowerCase().contains(query) ||
          (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
          (item.bhk ?? '').toLowerCase().contains(query) ||
          (item.showPrice ?? '').toLowerCase().contains(query) ||
          (item.floor ?? '').toLowerCase().contains(query) ||
          (item.totalFloor ?? '').toLowerCase().contains(query) ||
          (item.balcony ?? '').toLowerCase().contains(query) ||
          (item.squarefit ?? '').toLowerCase().contains(query) ||
          (item.maintance ?? '').toLowerCase().contains(query) ||
          (item.parking ?? '').toLowerCase().contains(query) ||
          (item.kitchen ?? '').toLowerCase().contains(query) ||
          (item.bathroom ?? '').toLowerCase().contains(query) ||
          (item.facility ?? '').toLowerCase().contains(query) ||
          (item.furnishedUnfurnished ?? '').toLowerCase().contains(query) ||
          (item.buyRent ?? '').toLowerCase().contains(query) ||
          (item.longitude ?? '').toLowerCase().contains(query) ||
          (item.latitude ?? '').toLowerCase().contains(query) ||
          (item.propertyPhoto ?? '').toLowerCase().contains(query) ||
          (item.ageOfProperty ?? '').toLowerCase().contains(query) ||
          (item.registryAndGpa ?? '').toLowerCase().contains(query) ||
          (item.loan ?? '').toLowerCase().contains(query) ||
          (item.flatNumber ?? '').toLowerCase().contains(query) ||
          (item.currentDates ?? '').toLowerCase().contains(query) ||
          (item.availableDate ?? '').toLowerCase().contains(query) ||
          (item.ownerName ?? '').toLowerCase().contains(query) ||
          (item.ownerNumber ?? '').toLowerCase().contains(query) ||
          (item.fieldWorkerName ?? '').toLowerCase().contains(query) ||
          (item.fieldWorkerNumber ?? '').toLowerCase().contains(query) ||
          (item.careTakerName ?? '').toLowerCase().contains(query) ||
          (item.careTakerNumber ?? '').toLowerCase().contains(query);
    }).toList();

    setState(() {
      _filteredProperties = filtered;
      propertyCount = filtered.length;
    });
  }
  Future<void> _fetchProperties() async {
    setState(() => _isLoading = true);

    try {
      final data = await fetchData(_number);

      // 🔥 Only Sub Admin should apply location filtering
      List<Upcoming_model> finalList;

      if (_FAadharCard.trim() == "Administrator") {
        finalList = data; // No location restriction
      } else {
        finalList = _applyCustomLocationFilter(data);
      }

      setState(() {
        _allProperties = finalList;
        _filteredProperties = finalList;
        _isLoading = false;
      });
    } catch (e) {
      // print("❌ Error: $e");
      setState(() => _isLoading = false);
    }
  }
  List<Upcoming_model> _applyCustomLocationFilter(List<Upcoming_model> list) {
    String loc = _location.trim().toLowerCase();

    if (loc == "sultanpur") {
      return list.where((item) =>
      (item.locations ?? "").trim().toLowerCase() == "sultanpur"
      ).toList();
    }

    if (loc == "rajpur khurd" || loc == "chhattarpur") {
      return list.where((item) {
        final itemLoc = (item.locations ?? "").trim().toLowerCase();
        return itemLoc == "rajpur khurd" || itemLoc == "chhattarpur";
      }).toList();
    }

    return list;
  }
  Future<List<Upcoming_model>> fetchData(String number) async {
    String finalLocation = "";

    // 🔥 ADMIN MODE → No location restriction
    if (_FAadharCard.trim() == "Administrator") {
      final url = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/upcoming_show_api_for_subadmin.php"
      );

      // print("🚀 Admin Mode URL: $url");

      final response = await http.get(url);
      return _parsePropertyData(response);
    }

    // 🔥 SUB ADMIN MODE → Use location
    final loc = _location.trim().toLowerCase();

    if (loc == "sultanpur") {
      finalLocation = "SultanPur";
    } else if (loc == "rajpur khurd" || loc == "chhattarpur") {
      finalLocation = "Rajpur Khurd,ChhattarPur";
    } else {
      finalLocation = _location;
    }

    final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/upcoming_show_api_for_subadmin.php?locations=$finalLocation"
    );

    // print("🚀 Sub Admin Location URL: $url");

    final response = await http.get(url);
    return _parsePropertyData(response);
  }
  List<Upcoming_model> _parsePropertyData(http.Response response) {
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded is Map<String, dynamic> && decoded.containsKey('data')) {
        final List<dynamic> dataList = decoded['data'];

        dataList.sort((a, b) =>
        b['P_id'] != null && a['P_id'] != null
            ? b['P_id'].compareTo(a['P_id'])
            : 0
        );

        return dataList.map((e) => Upcoming_model.fromJson(e)).toList();
      } else {
        throw Exception("Invalid response structure");
      }
    } else {
      throw Exception("Server Error: ${response.statusCode}");
    }
  }


  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata();

    _loaduserdata().then((_) {
      _fetchInitialData();
    });
  }

  Future<void> _loaduserdata() async {
    final prefs = await SharedPreferences.getInstance();

    _name = prefs.getString('name') ?? '';
    _number = prefs.getString('number') ?? '';
    _FAadharCard = prefs.getString('FAadharCard') ?? '';
    _location = prefs.getString('location') ?? '';

    if (_FAadharCard.isEmpty) {
      _FAadharCard = prefs.getString('post') ?? '';
    }

    // print("🔥 ALL STORED KEYS: ${prefs.getKeys()}");
    // print("🔥 post: ${prefs.getString('post')}");
    // print("🔥 FAadharCard: $_FAadharCard");

    await _fetchProperties();
  }

  Future<void> _fetchInitialData() async {
    setState(() => _isLoading = true);
    try {
      final data = await fetchData("");
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      // print("❌ Error fetching data: $e");
      setState(() => _isLoading = false);
    }
  }

  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || selectedLabel!="";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
        surfaceTintColor: Colors.black,
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
      ),
      body:
      _isLoading
          ? Center(child: Image.asset(AppImages.loader,height: 50,))
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: 'Search Flats here',
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
          if (propertyCount > 0 && _isSearchActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                        const SizedBox(width: 6),
                        Text(
                          "$propertyCount properties found",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).textTheme.bodyLarge?.color,
                          ),
                        ),
                        const SizedBox(width: 6),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              selectedLabel = '';
                              _filteredProperties = _allProperties;
                              propertyCount = 0;
                            });
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Icon(Icons.close, size: 18, color: Colors.grey[600]),
                        ),
                      ],
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
                    "No Flats found",
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
                  return StreamBuilder<http.Response>(
                    stream: Stream.periodic(const Duration(seconds: 5))
                        .asyncMap((_) => http.get(Uri.parse(
                      "https://verifyrealestateandservices.in/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${_filteredProperties[index].pId??0}",
                    ))),
                    builder: (context, snapshot) {
                      bool isRedDot = false;

                      if (snapshot.hasData) {
                        try {
                          final body = jsonDecode(snapshot.data!.body);
                          isRedDot = body is List && body.isNotEmpty && body[0]['logg'] == 0;
                        } catch (_) {}
                      }

                      final Map<String, dynamic> fields = {
                        "Images": property.propertyPhoto,
                        "Owner Name": property.ownerName,
                        "Owner Number": property.ownerNumber,
                        "Caretaker Name": property.careTakerName,
                        "Caretaker Number": property.careTakerNumber,
                        "Place": property.locations,
                        "Buy/Rent": property.buyRent,
                        "Property Name/Address": property.apartmentAddress,
                        "Property Address (Fieldworker)":
                        property.fieldWorkerAddress,
                        // "Owner Vehicle Number": property.ownerVehicleNumber,
                        // "Your Address": property.fieldWorkerCurrentLocation,
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
                          .where((entry) {
                        final value = entry.value;
                        if (value == null) return true;
                        if (value is String && value.trim().isEmpty) return true;
                        return false;
                      })
                          .map((entry) => entry.key)
                          .toList();

                      final hasMissingFields = missingFields.isNotEmpty;
                      return Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setInt('id_Building', _filteredProperties[index].pId??0);
                                prefs.setString('id_Longitude', _filteredProperties[index].longitude.toString());
                                prefs.setString('id_Latitude', _filteredProperties[index].latitude.toString());
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminUpcomingDetails(id: _filteredProperties[index].pId??0),
                                  ),
                                );
                                // print(_filteredProperties[index].pId??0);
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),

                                child: Builder(
                                  builder: (context) {
                                    final isDark = Theme.of(context).brightness == Brightness.dark;

                                    final cardColor = isDark ? Colors.white : Colors.black;
                                    final textColor = isDark ? Colors.black : Colors.white;
                                    final subTextColor = isDark ? Colors.black54 : Colors.white70;

                                    return Card(
                                      elevation: 6,
                                      shadowColor: Colors.black45,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      color: cardColor,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [

                                          /// 🔹 TOP SECTION
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [

                                                /// 🔹 IMAGE
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: Stack(
                                                    children: [
                                                      Image.network(
                                                        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${_filteredProperties[index].propertyPhoto}",
                                                        height: 250,
                                                        width: 120,
                                                        fit: BoxFit.cover,
                                                      ),

                                                      Positioned(
                                                        top: 8,
                                                        left: 8,
                                                        child: Container(
                                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                          decoration: BoxDecoration(
                                                            color: (_filteredProperties[index].buyRent == "Rent")
                                                                ? Colors.green
                                                                : Colors.blue,
                                                            borderRadius: BorderRadius.circular(20),
                                                          ),
                                                          child: Text(
                                                            _filteredProperties[index].buyRent ?? "",
                                                            style: const TextStyle(
                                                              color: Colors.white,
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                const SizedBox(width: 12),

                                                /// 🔹 DETAILS
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [

                                                      Text(
                                                        _filteredProperties[index].apartmentAddress ?? "",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight: FontWeight.bold,
                                                          color: textColor,
                                                        ),
                                                      ),

                                                      const SizedBox(height: 6),

                                                      Row(
                                                        children: [
                                                          const Icon(Icons.location_on, size: 14, color: Colors.red),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            _filteredProperties[index].locations ?? "",
                                                            style: TextStyle(color: subTextColor),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 6),

                                                      Text(
                                                        "₹ ${_filteredProperties[index].showPrice ?? "-"}",
                                                        style: const TextStyle(
                                                          color: Colors.purple,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),

                                                      const SizedBox(height: 6),

                                                      Row(
                                                        children: [
                                                          const Icon(Icons.bed, size: 14, color: Colors.pink),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            "${_filteredProperties[index].bhk} BHK",
                                                            style: TextStyle(color: subTextColor),
                                                          ),

                                                          const SizedBox(width: 10),

                                                          const Icon(Icons.layers, size: 14, color: Colors.teal),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            "${_filteredProperties[index].floor} Floor",
                                                            style: TextStyle(color: subTextColor),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 6),

                                                      Row(
                                                        children: [
                                                          const Icon(Icons.apartment, size: 14, color: Colors.blue),
                                                          const SizedBox(width: 4),
                                                          Text(
                                                            _filteredProperties[index].typeOfProperty ?? "",
                                                            style: TextStyle(color: subTextColor),
                                                          ),
                                                        ],
                                                      ),

                                                      const SizedBox(height: 6),

                                                      Text(
                                                        "Flat No: ${_filteredProperties[index].flatNumber}",
                                                        style: TextStyle(color: subTextColor, fontSize: 12),
                                                      ),

                                                      Text(
                                                        "Building ID: ${_filteredProperties[index].pId}",
                                                        style: TextStyle(color: subTextColor, fontSize: 12),
                                                      ),

                                                      const SizedBox(height: 6),

                                                      Text(
                                                        "Added by: ${_filteredProperties[index].fieldWorkerName}",
                                                        style: TextStyle(color: subTextColor, fontSize: 12),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          /// 🔴 MISSING FIELD (FULL WIDTH)
                                          if (hasMissingFields)
                                            Container(
                                              width: double.infinity,
                                              margin: const EdgeInsets.all(10),
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                "⚠ Missing: ${missingFields.join(", ")}",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ]
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem({
    required BuildContext context,
    required String text,
    required Color borderColor,
    IconData? icon, // 👈 optional now
    Color? backgroundColor,
    Color? textColor,
    Color? shadowColor,
  }) {
    final width = MediaQuery.of(context).size.width;

    // Scale text, padding, and icon size relative to screen width
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
          if (icon != null) ...[ // 👈 only shows if passed
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

}
