import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ui_decoration_tools/constant.dart';
import 'Add_futureProperty.dart';
import 'Future_property_details.dart';

class Catid {
  final int id;
  final String Building_Address;
  final String Building_Location;
  final String Building_image;
  final String Longitude;
  final String Latitude;
  final String Building_information;
  final String Ownername;
  final String Owner_number;
  final String Caretaker_name;
  final String Caretaker_number;
  final String vehicleNo;
  final String property_address_for_fieldworkar;
  final String date;

  Catid({
    required this.id,
    required this.Building_Address,
    required this.Building_Location,
    required this.Building_image,
    required this.Longitude,
    required this.Latitude,
    required this.Building_information,
    required this.Ownername,
    required this.Owner_number,
    required this.Caretaker_name,
    required this.Caretaker_number,
    required this.vehicleNo,
    required this.property_address_for_fieldworkar,
    required this.date,
  });

  factory Catid.FromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['id'] ?? 0,
      Building_Address: json['propertyname_address'] ?? "",
      Building_Location: json['place'] ?? "",
      Building_image: json['images'] ?? "",
      Longitude: json['longitude'] ?? "",
      Latitude: json['latitude'] ?? "",
      Building_information: json['building_information_facilitys'] ?? "",
      Ownername: json['ownername'] ?? "",
      Owner_number: json['ownernumber'] ?? "",
      Caretaker_name: json['caretakername'] ?? "",
      Caretaker_number: json['caretakernumber'] ?? "",
      vehicleNo: json['owner_vehical_number'] ?? "",
      property_address_for_fieldworkar: json['property_address_for_fieldworkar'] ?? "",
      date: json['current_date_'] ?? "",
    );
  }
}


class FrontPage_FutureProperty extends StatefulWidget {
  const FrontPage_FutureProperty({super.key});

  @override
  State<FrontPage_FutureProperty> createState() => _FrontPage_FuturePropertyState();
}

class _FrontPage_FuturePropertyState extends State<FrontPage_FutureProperty> {

  String _number = '';
  String _SUbid = '';

  List<Catid> _allProperties = [];
  List<Catid> _filteredProperties = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  String selectedLabel = '';
  int propertyCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loaduserdata().then((_) {
      _fetchAndFilterProperties();
    });
  }
  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }


  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();

      List<Catid> filtered;

      if (query.isEmpty) {
        filtered = List.from(_allProperties);
        selectedLabel = ''; // optional
      } else {
        filtered = _allProperties.where((item) {
          return item.Building_Address.toLowerCase().contains(query) ||
              item.Building_Location.toLowerCase().contains(query) ||
              item.Building_image.toLowerCase().contains(query) ||
              item.Longitude.toLowerCase().contains(query) ||
              item.Latitude.toLowerCase().contains(query) ||
              item.Building_information.toLowerCase().contains(query) ||
              item.Ownername.toLowerCase().contains(query) ||
              item.Owner_number.toLowerCase().contains(query) ||
              item.Caretaker_name.toLowerCase().contains(query) ||
              item.Caretaker_number.toLowerCase().contains(query) ||
              item.property_address_for_fieldworkar.toLowerCase().contains(query) ||
              item.date.toLowerCase().contains(query);
        }).toList();
      }

      setState(() {
        _filteredProperties = filtered;
        propertyCount = filtered.length;
      });
    });
  }

  Future<void> _fetchAndFilterProperties() async {
    setState(() {
      _isLoading = true;
    });
    print("FIELDWORKER NUMBER: $_number");

    try {
      var url = Uri.parse("https://verifyserve.social/WebService4.asmx/show_futureproperty_by_fieldworkarnumber?fieldworkarnumber=$_number");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print("API Response Body: ${response.body}");
        List listResponse = json.decode(response.body);
        listResponse.sort((a, b) => b['id'].compareTo(a['id']));
        _allProperties = listResponse.map((data) => Catid.FromJson(data)).toList();

        _filteredProperties = _allProperties; // show all initially

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

  bool get _isSearchActive {
    return _searchController.text.trim().isNotEmpty || selectedLabel.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
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

      body: _isLoading
          ?  Center(child: Lottie.asset(AppImages.loadingHand, height: 400),)
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Box
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
                              propertyCount = 0;
                              FocusScope.of(context).unfocus();
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
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueGrey.withOpacity(0.3), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueAccent.withOpacity(0.8), width: 1.5),
                        ),
                      ),
                      onChanged: (value) {
                        _onSearchChanged();
                        setState(() {});
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Buttons
                Row(
                  children: ['Rent', 'Sell', 'Commercial'].map((label) {
                    final isSelected = label == selectedLabel;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              selectedLabel = label;
                              _searchController.text = label;
                              _onSearchChanged();
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          child: Text(
                            label,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w800,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 10),

                // Property Count
                if (propertyCount > 0 && _isSearchActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 20, color: Colors.green),
                        const SizedBox(width: 6),
                        Text(
                          "$propertyCount properties found",
                          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _searchController.clear();
                              selectedLabel = '';
                              _filteredProperties = _allProperties;
                              propertyCount = 0;
                            });
                          },
                          child: const Icon(Icons.close, size: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          // No results message
          if (_filteredProperties.isEmpty)
            Expanded(
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
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filteredProperties.length,
                itemBuilder: (context, index) {
                  final property = _filteredProperties[index];
                  final displayIndex = _filteredProperties.length - index; // ✅ reverse order
                  return FutureBuilder<http.Response>(
                    future: http.get(Uri.parse(
                        "https://verifyserve.social/WebService4.asmx/Count_api_flat_under_future_property_by_cctv?CCTV=${property.id}")),
                    builder: (context, snapshot) {
                      bool isRedDot = false;
                      if (snapshot.hasData) {
                        try {
                          final body = jsonDecode(snapshot.data!.body);
                          isRedDot = body is List &&
                              body.isNotEmpty &&
                              body[0]['logg'] == 0;
                        } catch (_) {}
                      }

                      return PropertyCard(
                        displayIndex: displayIndex,   // ✅ pass here
                        property: property,
                        isRedDot: isRedDot,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Future_Property_details(
                                idd: property.id.toString(),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Add_FutureProperty()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Building"),
        backgroundColor: Colors.blue, // Or your primary color
        elevation: 4,
      ),

    );
  }

  Future<void> _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
      _SUbid = prefs.getString('id_future') ?? '';
    });
  }


}
class PropertyCard extends StatelessWidget {
  final dynamic property;
  final bool isRedDot;
  final VoidCallback onTap;
  final int displayIndex;   // ✅ new

  const PropertyCard({
    Key? key,
    required this.property,
    required this.isRedDot,
    required this.onTap,
    required this.displayIndex,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    bool hasMissingFields = [
      property.Building_information,
      property.Ownername,
      property.Owner_number,
      property.Caretaker_name,
      property.Caretaker_number,
      property.vehicleNo,
    ].any((field) => field.trim().isEmpty);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Column(
          children: [
            // Image with overlay and status dot
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: CachedNetworkImage(
                    imageUrl:
                    "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.Building_image}",
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.fill,
                    placeholder: (context, url) => Center(
                      child: Image.asset(AppImages.loader, height: 50),
                    ),
                    errorWidget: (context, error, stackTrace) => Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                // Status Dot
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: isRedDot ? Colors.red : Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // BHK + Buy/Rent
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.location_on, size: 20, color: Colors.grey[600]),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.Building_Location,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: isDark ? Colors.grey[300] : Colors.grey[700],
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 12),

                  // Owner Info
                  // Wrap(
                  //   spacing: 10,
                  //   runSpacing: 6,
                  //   children: [
                  //     _infoChip("Owner", property.Ownername, isDark),
                  //     _infoChip("Contact", property.Owner_number, isDark),
                  //     _infoChip("Caretaker", property.Caretaker_name, isDark),
                  //     _infoChip("Caretaker No", property.Caretaker_number, isDark),
                  //   ],
                  // ),

                  const SizedBox(height: 12),

                  // Property Address
                  Text(
                    "Field Worker Address:",
                    style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.property_address_for_fieldworkar,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),
                  //
                  // if (hasMissingFields)
                  //   Container(
                  //     width: double.infinity,
                  //     margin: const EdgeInsets.only(top: 8, bottom: 8),
                  //     padding: const EdgeInsets.all(10),
                  //     decoration: BoxDecoration(
                  //       color: Colors.red.shade100,
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //     child: Row(
                  //       children: [
                  //         const Icon(Icons.warning_amber_rounded,
                  //             color: Colors.red, size: 20),
                  //         const SizedBox(width: 8),
                  //         Expanded(
                  //           child: Text(
                  //             "Some fields are missing. Please update the building details.",
                  //             style: TextStyle(
                  //               color: Colors.red.shade800,
                  //               fontSize: 13,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  const SizedBox(height: 12),

                  // Property ID
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Property No. ${displayIndex}" /*+abc.data![len].Building_Name.toUpperCase()*/,
                        style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white : Colors.black87,
                            fontWeight: FontWeight
                                .w500,
                            letterSpacing: 0.5
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.blueGrey[800] : Colors.blueGrey[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "ID: ${property.id}",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark ? Colors.white70 : Colors.blueGrey[700],
                            ),
                          ),
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
    );
  }

  Widget _infoChip(String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? Colors.white12 : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "$label: ",
            style: TextStyle(
              fontFamily: "PoppinsBold",
              fontSize: 12,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? Colors.grey[300] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}