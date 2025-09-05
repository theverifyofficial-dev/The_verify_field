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
import 'package:intl/intl.dart';

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
        selectedLabel = ''; // optional reset
      } else {
        filtered = _allProperties.where((item) {
          return (item.id.toString()).toLowerCase().contains(query) ||
              // (item.images ?? '').toLowerCase().contains(query) ||
              (item.ownerName ?? '').toLowerCase().contains(query) ||
              // (item.ownerNumber ?? '').toLowerCase().contains(query) ||
              (item.caretakerName ?? '').toLowerCase().contains(query) ||
              // (item.caretakerNumber ?? '').toLowerCase().contains(query) ||
              (item.place ?? '').toLowerCase().contains(query) ||
              (item.buyRent ?? '').toLowerCase().contains(query) ||
              // (item.typeOfProperty ?? '').toLowerCase().contains(query) ||
              // (item.selectBhk ?? '').toLowerCase().contains(query) ||
              // (item.floorNumber ?? '').toLowerCase().contains(query) ||
              // (item.squareFeet ?? '').toLowerCase().contains(query) ||
              (item.propertyNameAddress ?? '').toLowerCase().contains(query) ||
              // (item.buildingInformationFacilities ?? '').toLowerCase().contains(query) ||
              (item.propertyAddressForFieldworker ?? '').toLowerCase().contains(query) ||
              (item.residenceCommercial ?? '').toLowerCase().contains(query);

          // (item.ownerVehicleNumber ?? '').toLowerCase().contains(query) ||
              // (item.yourAddress ?? '').toLowerCase().contains(query) ||
              // (item.fieldWorkerName ?? '').toLowerCase().contains(query) ||
              // (item.fieldWorkerNumber ?? '').toLowerCase().contains(query) ||
              // (item.currentDate ?? '').toLowerCase().contains(query) ||
              // (item.longitude ?? '').toLowerCase().contains(query) ||
              // (item.latitude ?? '').toLowerCase().contains(query) ||
              // (item.roadSize ?? '').toLowerCase().contains(query) ||
              // (item.metroDistance ?? '').toLowerCase().contains(query) ||
              // (item.metroName ?? '').toLowerCase().contains(query) ||
              // (item.mainMarketDistance ?? '').toLowerCase().contains(query) ||
              // (item.ageOfProperty ?? '').toLowerCase().contains(query) ||
              // (item.lift ?? '').toLowerCase().contains(query) ||
              // (item.parking ?? '').toLowerCase().contains(query) ||
              // (item.totalFloor ?? '').toLowerCase().contains(query) ||
              // (item.facility ?? '').toLowerCase().contains(query);
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
                  Color statusColor = Colors.grey;
                  String loggValue = "Loading...";
                  return FutureBuilder<http.Response>(
                    future: http.get(Uri.parse(
                        "https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=${property.id}")),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        try {
                          final body = jsonDecode(snapshot.data!.body);
                          if (body is List && body.isNotEmpty) {
                            final logg = body[0]['logg'];
                            loggValue = logg.toString();
                            statusColor = (logg == 0) ? Colors.red : Colors.green;
                          }
                        } catch (_) {
                          loggValue = "Error";
                          statusColor = Colors.grey;
                        }
                      } else if (snapshot.hasError) {
                        loggValue = "Error";
                        statusColor = Colors.grey;
                      }
                      return
                        PropertyCard(
                        displayIndex: displayIndex,   // ✅ pass here
                        property: property,
                        statusText: loggValue,     // ✅ pass status text
                        statusColor: statusColor,
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
  final String statusText;
  final Color statusColor;
  final VoidCallback onTap;
  final int displayIndex;

  const PropertyCard({
    Key? key,
    required this.property,
    required this.statusText,
    required this.statusColor,
    required this.onTap,
    required this.displayIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Utility check
    bool _isNullOrEmpty(String? value) =>
        value == null || value.trim().isEmpty;

    // Map all Catid fields with readable labels
    final Map<String, dynamic> fields = {
      "Images": property.images,
      "Owner Name": property.ownerName,
      "Owner Number": property.ownerNumber,
      "Caretaker Name": property.caretakerName,
      "Caretaker Number": property.caretakerNumber,
      "Place": property.place,
      "Buy/Rent": property.buyRent,
      "Property Name/Address": property.propertyNameAddress,
      "Property Address (Fieldworker)":
      property.propertyAddressForFieldworker,
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

    // Check for missing fields
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

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
          width: 1,
        ),
      ),
      elevation: 5,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Image with overlay + badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: CachedNetworkImage(
                    imageUrl:
                    "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${property.images}",
                    height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
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

                // // Status tag (Buy/Rent)
                // Positioned(
                //   top: 14,
                //   right: 14,
                //   child: Container(
                //     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //     decoration: BoxDecoration(
                //       color: statusColor,
                //       borderRadius: BorderRadius.circular(20),
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.black.withOpacity(0.2),
                //           blurRadius: 6,
                //           offset: const Offset(2, 2),
                //         ),
                //       ],
                //     ),
                //     child: Text(
                //       statusText,
                //       style: const TextStyle(
                //         color: Colors.white,
                //         fontWeight: FontWeight.w600,
                //         fontSize: 12,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),

            // 🔹 Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Wrap(
                        // alignment: WrapAlignment.spaceBetween, // equal spacing across row
                        spacing: 6,
                        runSpacing: 4,
                        children: [
                          _buildInfoChip(
                            context: context,
                            text: property.place,
                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.green.withOpacity(0.2)
                                : Colors.green.shade50,
                            textColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.green.shade800,
                            borderColor: Colors.green,
                          ),
                          _buildInfoChip(
                            context: context,

                            text: property.residenceCommercial,
                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.blue.withOpacity(0.2)
                                : Colors.blue.shade50,
                            textColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.blue.shade200
                                : Colors.blue.shade800,
                            borderColor: Colors.blue,
                          ),
                          _buildInfoChip(
                            context: context,

                            text: property.buyRent,
                            backgroundColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.orange.shade50,
                            textColor: Theme.of(context).brightness == Brightness.dark
                                ? Colors.orange.shade200
                                : Colors.orange.shade800,
                            borderColor: Colors.orange,
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Address
                  Text(
                    "Field Worker Address",
                    style: TextStyle(
                      fontFamily: "PoppinsBold",
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.propertyAddressForFieldworker,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      height: 1.3,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Address
                  // Text(
                  //   "Main Address",
                  //   style: TextStyle(
                  //     fontFamily: "PoppinsBold",
                  //     fontSize: 14,
                  //     color: isDark ? Colors.white : Colors.black87,
                  //   ),
                  // ),
                  // const SizedBox(height: 4),
                  // Text(
                  //   property.yourAddress,
                  //   style: TextStyle(
                  //     fontFamily: "Poppins",
                  //     fontSize: 13,
                  //     height: 1.3,
                  //     color: isDark ? Colors.grey[300] : Colors.grey[700],
                  //   ),
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  //
                  // const SizedBox(height: 14),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     Text(
                  //       "🏠 Building No. $displayIndex",
                  //       style: TextStyle(
                  //         fontSize: 13,
                  //         color: isDark ? Colors.white70 : Colors.black87,
                  //         fontWeight: FontWeight.w500,
                  //         letterSpacing: 0.3,
                  //       ),
                  //     ),
                  //   ],
                  // ),
                  // const SizedBox(height: 10),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    childAspectRatio: 3.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    children: [
                      _buildCompactDetailItem( "🏠 Building No.","$displayIndex",context),
                      _buildCompactDetailItem( "Add Flat ",statusText,context),
                    ],
                  ),

                  // const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Added: ${(() {
                          final s = property.currentDate?.toString() ?? '';
                          if (s.isEmpty) return '-';
                          try {

                            final dt = DateFormat('yyyy-MM-dd hh:mm a').parse(s);
                            return DateFormat('dd MMM yyyy, hh:mm a').format(dt);
                          } catch (_) {
                            try {
                              final dt2 = DateTime.parse(s);
                              return DateFormat('dd MMM yyyy, hh:mm a').format(dt2);
                            } catch (_) {
                              return s;
                            }
                          }
                        })()}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                        ),
                      ),
                      Text(
                        "ID: ${property.id}",
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Poppins",
                        ),
                      ),
                    ],
                  ),
                  // const SizedBox(height: 10),

                  // ⚠ Missing fields
                  if (hasMissingFields)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.redAccent, width: 1),
                      ),
                      child: Text(
                        "⚠ Missing fields: ${missingFields.join(", ")}",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.redAccent,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }

}
Widget _buildCompactDetailItem(String title, String value,BuildContext context) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), // more space
    decoration: BoxDecoration(
      color: Theme.of(context).brightness == Brightness.dark
          ? Colors.white12
          : Colors.white,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "$title: ",
          style: TextStyle(
            fontSize: 14, // bigger text
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color:
              Theme.of(context).brightness==Brightness.dark?
              Colors.white:
              Colors.black,
              // shadows: [
              //   Shadow(
              //     blurRadius: 1,
              //     // offset: Offset(2, 2),
              //     color: Theme.of(context).brightness == Brightness.dark
              //         ? Colors.amber
              //         : Colors.black87,
              //   )
              // ],
              fontSize: 15, // bigger text
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget _buildInfoChip({
  required String text,
  required Color borderColor,
  required BuildContext context,
  Color? backgroundColor,
  Color? textColor,
  Color? shadowColor,
}) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    margin: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: backgroundColor ?? Colors.transparent,
      border: Border.all(color: borderColor, width: 2),
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: (shadowColor ?? borderColor).withOpacity(0.3),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : (textColor ?? Colors.black),
      ),
    ),
  );
}
