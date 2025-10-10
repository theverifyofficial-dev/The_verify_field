import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
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

class SeeAll_FutureProperty extends StatefulWidget {
  final String id;
  const SeeAll_FutureProperty({super.key, required this.id});

  @override
  State<SeeAll_FutureProperty> createState() => _SeeAll_FuturePropertyState();
}

class _SeeAll_FuturePropertyState extends State<SeeAll_FutureProperty> {
  String _number = '';

  @override
  void initState() {
    super.initState();
    _loaduserdata();
    fetchData(); // loads data once
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  List<Catid> _allProperties = [];
  List<Catid> _filteredProperties = [];
  Timer? _debounce;
  TextEditingController _searchController = TextEditingController();
  String selectedLabel = '';
  int propertyCount = 0;
  bool _isLoading = true;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();

      List<Catid> filtered;

      if (query.isEmpty) {
        filtered = List.from(_allProperties);
        selectedLabel = ''; // optional reset
      } else if (query == "Missing Field") {
        // ✅ Show items if ANY field is null or empty (except ignored fields)
        filtered = _allProperties.where((item) {
          return (item.images == null || item.images!.trim().isEmpty) ||
              (item.ownerName == null || item.ownerName!.trim().isEmpty) ||
              (item.ownerNumber == null || item.ownerNumber!.trim().isEmpty) ||
              (item.caretakerName == null || item.caretakerName!.trim().isEmpty) ||
              (item.caretakerNumber == null || item.caretakerNumber!.trim().isEmpty) ||
              (item.place == null || item.place!.trim().isEmpty) ||
              (item.buyRent == null || item.buyRent!.trim().isEmpty) ||
              (item.propertyNameAddress == null || item.propertyNameAddress!.trim().isEmpty) ||
              (item.propertyAddressForFieldworker == null || item.propertyAddressForFieldworker!.trim().isEmpty) ||
              (item.ownerVehicleNumber == null || item.ownerVehicleNumber!.trim().isEmpty) ||
              (item.yourAddress == null || item.yourAddress!.trim().isEmpty) ||
              (item.fieldWorkerName == null || item.fieldWorkerName!.trim().isEmpty) ||
              (item.fieldWorkerNumber == null || item.fieldWorkerNumber!.trim().isEmpty) ||
              (item.currentDate == null || item.currentDate!.trim().isEmpty) ||
              (item.longitude == null || item.longitude!.trim().isEmpty) ||
              (item.latitude == null || item.latitude!.trim().isEmpty) ||
              (item.roadSize == null || item.roadSize!.trim().isEmpty) ||
              (item.metroDistance == null || item.metroDistance!.trim().isEmpty) ||
              (item.metroName == null || item.metroName!.trim().isEmpty) ||
              (item.mainMarketDistance == null || item.mainMarketDistance!.trim().isEmpty) ||
              (item.ageOfProperty == null || item.ageOfProperty!.trim().isEmpty) ||
              (item.lift == null || item.lift!.trim().isEmpty) ||
              (item.parking == null || item.parking!.trim().isEmpty) ||
              (item.totalFloor == null || item.totalFloor!.trim().isEmpty) ||
              (item.residenceCommercial == null || item.residenceCommercial!.trim().isEmpty) ||
              (item.facility == null || item.facility!.trim().isEmpty);
        }).toList();
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
              (item.ownerName ?? '').toLowerCase().contains(query) ||
              (item.ownerVehicleNumber?? '').toLowerCase().contains(query) ||
              (item.buildingInformationFacilities ?? '').toLowerCase().contains(query) ||
              (item.propertyAddressForFieldworker ?? '').toLowerCase().contains(query) ||
              (item.ownerVehicleNumber ?? '').toLowerCase().contains(query) ||
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
              (item.residenceCommercial ?? '').toLowerCase().contains(query) ||
              (item.facility ?? '').toLowerCase().contains(query);
        }).toList();
      }

      setState(() {
        _filteredProperties = filtered;
        propertyCount = filtered.length;
      });
    });
  }

  // ✅ Fetch API only once
  Future<void> fetchData() async {
    try {
      final url = Uri.parse(
          "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=${widget.id}");
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
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
          ?  Center(child: Lottie.asset(AppImages.loadingHand, height: 400),)
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
                      onChanged: (value) {
                        String query = value.toLowerCase();

                        List<Catid> filtered = _allProperties.where((item) {
                          return (item.propertyNameAddress?.toLowerCase().contains(query) ?? false) ||
                              (item.place?.toLowerCase().contains(query) ?? false) ||
                              (item.buyRent?.toLowerCase().contains(query) ?? false) ||
                              (item.ownerName?.toLowerCase().contains(query) ?? false) ||
                              (item.fieldWorkerName?.toLowerCase().contains(query) ?? false);
                        }).toList();

                        // Apply button filters if selected
                        if (selectedLabel == 'Missing Field') {
                          filtered = filtered.where((item) {
                            return (item.images == null || item.images!.trim().isEmpty) ||
                                (item.ownerName == null || item.ownerName!.trim().isEmpty) ||
                                (item.ownerNumber == null || item.ownerNumber!.trim().isEmpty) ||
                                (item.caretakerName == null || item.caretakerName!.trim().isEmpty);
                          }).toList();
                        } else if (selectedLabel == 'Rent' || selectedLabel == 'Buy' || selectedLabel == 'Commercial') {
                          filtered = filtered.where((item) {
                            if (selectedLabel == 'Commercial') {
                              return (item.residenceCommercial?.toLowerCase() ?? '') == 'commercial';
                            } else {
                              return (item.buyRent?.toLowerCase() ?? '') == selectedLabel.toLowerCase();
                            }
                          }).toList();
                        }

                        setState(() {
                          _filteredProperties = filtered;
                          propertyCount = filtered.length;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // 🔘 Filter Buttons Row

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      'Buy',
                      'Rent',
                      'Commercial',
                    ].map((label) {
                      final isSelected = label == selectedLabel;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (selectedLabel == label) {
                                // Unselect if tapped again
                                selectedLabel = '';
                                _searchController.clear();
                                _filteredProperties = _allProperties;
                              } else {
                                selectedLabel = label;

                                // 👇 Write selected label in the search box
                                _searchController.text = label;

                                List<Catid> filtered = _allProperties;

                                if (label == 'Commercial') {
                                  filtered = filtered.where((item) {
                                    return (item.residenceCommercial?.toLowerCase() ?? '') == 'commercial';
                                  }).toList();
                                } else {
                                  filtered = filtered.where((item) {
                                    return (item.buyRent?.toLowerCase() ?? '') == label.toLowerCase();
                                  }).toList();
                                }

                                _filteredProperties = filtered;
                              }
                              propertyCount = _filteredProperties.length;
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
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).brightness ==
                                    Brightness.dark
                                    ? Colors.transparent
                                    : Colors.grey,
                                width: 1.5),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.check_circle_outline,
                                  size: 20, color: Colors.green),
                              const SizedBox(width: 6),
                              Text(
                                "$propertyCount building found",
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                    color: Colors.black),
                              ),
                              const SizedBox(width: 6),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _searchController.clear();
                                    selectedLabel = '';
                                    _filteredProperties = _allProperties;
                                    propertyCount = _allProperties.length;
                                  });
                                },
                                child: const Icon(Icons.close,
                                    size: 18, color: Colors.grey),
                              ),
                            ],
                          ),
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
              itemCount: _filteredProperties.length,
              itemBuilder: (context, index) {
                final item = _filteredProperties[index];
                return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         Future_Property_details(idd: item.id.toString()),
                          //   ),
                          // );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Administater_Future_Property_details(
                                    buildingId: item.id.toString() ?? '',
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.images ?? ""}",
                                    fit: BoxFit.cover,
                                    width: size.width,
                                    placeholder: (context, url) =>
                                        Image.asset(AppImages.loader,),
                                    errorWidget: (context, error, stack) =>
                                        Image.asset(AppImages.imageNotFound),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Tags Row
                                Row(
                                  children: [
                                    _buildTag(item.selectBhk ?? "", Colors.red),
                                    const SizedBox(width: 10),
                                    _buildTag(item.buyRent ?? "", Colors.green),
                                    const SizedBox(width: 10),
                                    _buildTag(item.place ?? "", Colors.blue),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Icon(PhosphorIcons.push_pin,
                                        size: 12, color: Colors.red),
                                    SizedBox(width: 4),
                                    Text(
                                      "Property Address (Fieldworker)",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.propertyAddressForFieldworker ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildTag("Field Worker : ${item.fieldWorkerName}", Colors.purple),
                                    SizedBox(width: 4),
                                    _buildTag("ID: ${item.id}", Colors.orange),
                                  ],
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
/*GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         Future_Property_details(idd: item.id.toString()),
                          //   ),
                          // );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Administater_Future_Property_details(
                                    buildingId: item.id.toString() ?? '',
                                  ),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                    "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.images ?? ""}",
                                    fit: BoxFit.cover,
                                    width: size.width,
                                    placeholder: (context, url) =>
                                        Image.asset(AppImages.loading),
                                    errorWidget: (context, error, stack) =>
                                        Image.asset(AppImages.imageNotFound),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                // Tags Row
                                Row(
                                  children: [
                                    _buildTag(item.selectBhk ?? "", Colors.red),
                                    const SizedBox(width: 10),
                                    _buildTag(item.buyRent ?? "", Colors.green),
                                    const SizedBox(width: 10),
                                    _buildTag(item.place ?? "", Colors.blue),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: const [
                                    Icon(PhosphorIcons.push_pin,
                                        size: 12, color: Colors.red),
                                    SizedBox(width: 4),
                                    Text(
                                      "Property Address (Fieldworker)",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  item.propertyAddressForFieldworker ?? "",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    _buildTag("Field Worker : ${item.fieldWorkerName}", Colors.purple),
                                    SizedBox(width: 4),
                                    _buildTag("ID: ${item.id}", Colors.orange),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );*/
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: color),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 6,
            offset: const Offset(0, 0),
            blurStyle: BlurStyle.outer,
          ),
        ],
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _number = prefs.getString('number') ?? '';
    });
  }
}
