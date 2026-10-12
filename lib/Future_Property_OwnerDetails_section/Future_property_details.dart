import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Future_Property_OwnerDetails_section/Owner_Call/All_contact.dart';
import '../Custom_Widget/property_preview.dart';
import '../model/future_detailpage_model.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Add_FutureProperty_Images.dart';
import 'Duplicate_Property.dart';
import 'Update_future_building.dart' hide FutureProperty2;
import 'add_flat_form.dart';
import 'New_Update/under_flats_infutureproperty.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Future_Property_details extends StatefulWidget {
  final String idd;
  Future_Property_details({super.key, required this.idd});
  @override
  State<Future_Property_details> createState() => _Future_Property_detailsState();
}
class _Future_Property_detailsState extends State<Future_Property_details> {

  late Future<List<Ground>> flatsFuture;
  late Future<List<FutureProperty2>> propertyFuture;
  late Future<List<DocumentMainModel_F>> imagesFuture;
  String? _networkImageUrl;
  String userRole = '';
  bool isFieldWorker = false;
  int _totalFloors = 1;

  String _flatFilter = 'All';


  @override
  void initState() {
    super.initState();

    _loadUserRole();
    _loadAll();
  }

  Future<void> _loadUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('post') ?? '';

    if (!mounted) return;

    setState(() {
      userRole = role.trim().toLowerCase();

      isFieldWorker =
          userRole == 'fieldworkar' ||
              userRole == 'fieldworker' ||
              userRole == 'field worker' ||
              userRole == 'field_worker';
    });

    debugPrint('USER ROLE: $userRole');
    debugPrint('IS FIELD WORKER: $isFieldWorker');
  }

  void _loadAll() {
    flatsFuture = fetchAllFlats();
    propertyFuture = fetchData();
    imagesFuture = fetchCarouselData();
  }

  Future<void> _refreshAllData() async {
    setState(() {
      _loadAll(); // reassign futures
    });
  }

  Map<String, List<Ground>> groupFlatsByFloor(List<Ground> flats) {
    final Map<String, List<Ground>> grouped = {};

    for (final flat in flats) {
      final floor = flat.floor.trim().isEmpty ? 'Unknown' : flat.floor.trim();
      grouped.putIfAbsent(floor, () => []).add(flat);
    }

    return grouped;
  }

  int? _numericFloor(String floor) {
    final value = floor.trim().toLowerCase();

    if (value.contains('ground') || value == 'g') {
      return 0;
    }

    final match = RegExp(r'\\d+').firstMatch(value);
    return match == null ? null : int.tryParse(match.group(0)!);
  }

  List<String> _orderedBuildingFloors(Map<String, List<Ground>> grouped) {
    // Show only floors that actually contain flats, ordered from the building's
    // highest floor down to the ground floor. This avoids empty floor sections.
    final populatedFloors = <String>[];

    for (int floor = _totalFloors; floor >= 0; floor--) {
      final label = floor == 0 ? 'Ground' : '$floor';
      final hasFlats = grouped.entries.any(
            (entry) => _numericFloor(entry.key) == floor,
      );

      if (hasFlats) {
        populatedFloors.add(label);
      }
    }

    // Preserve non-standard labels that contain flats, without duplicating
    // floors already included in the numeric/ground-floor ordering.
    for (final entry in grouped.entries) {
      final name = entry.key.trim();
      if (entry.value.isEmpty || _numericFloor(name) != null) continue;

      if (!populatedFloors.contains(name)) {
        populatedFloors.add(name);
      }
    }

    return populatedFloors;
  }

  List<Ground> _flatsForFloor(
      String floorName,
      Map<String, List<Ground>> grouped,
      ) {
    final targetFloor = _numericFloor(floorName);
    final result = <Ground>[];

    for (final entry in grouped.entries) {
      if (floorName == 'Unknown') {
        if (entry.key.toLowerCase() == 'unknown') result.addAll(entry.value);
        continue;
      }

      if (targetFloor != null && _numericFloor(entry.key) == targetFloor) {
        result.addAll(entry.value);
      } else if (targetFloor == null && entry.key == floorName) {
        result.addAll(entry.value);
      }
    }

    result.sort((a, b) => _flatDisplayName(a).compareTo(_flatDisplayName(b)));
    return result;
  }

  Widget _buildAllFloorSections(
      List<Ground> flats,
      bool isDarkMode,
      ) {
    final grouped = groupFlatsByFloor(flats);
    final floors = _orderedBuildingFloors(grouped);

    return Column(
      children: [
        _buildFlatsSummaryHeader(flats, grouped),
        ...floors.map(
              (floorName) => _buildFloorContentSection(
            floorName,
            _flatsForFloor(floorName, grouped),
            isDarkMode,
          ),
        ),
      ],
    );
  }

  Future<List<Ground>> fetchAllFlats() async {
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_building_flat.php?subid=${widget.idd}",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load flats");
    }

    final decoded = jsonDecode(response.body);

    final List list = decoded['data'] ?? [];
    return list.map((e) => Ground.fromJson(e)).toList();
  }

  Future<List<FutureProperty2>> fetchData() async {
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_for_details_page.php?id=${widget.idd}",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode}');
    }

    final decoded = json.decode(response.body);
    List<dynamic> listResponse = [];

    if (decoded is List) {
      listResponse = decoded;
    } else if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is List) {
        listResponse = decoded['data'];
      } else if (decoded['Table'] is List) {
        listResponse = decoded['Table'];
      } else {
        throw Exception("No list found in API response");
      }
    } else {
      throw Exception("Invalid API response format");
    }

    listResponse.sort(
          (a, b) => (b['id'] ?? '').toString().compareTo(
        (a['id'] ?? '').toString(),
      ),
    );

    final properties = listResponse
        .map((e) => FutureProperty2.fromJson(e))
        .toList();

    final totalFloorText = properties.isNotEmpty
        ? properties.first.totalFloor.toString().trim()
        : '1';
    final totalFloorMatch = RegExp(r'\d+').firstMatch(totalFloorText);
    final parsedTotalFloors = int.tryParse(totalFloorMatch?.group(0) ?? '') ?? 1;
    final resolvedTotalFloors =
    parsedTotalFloors > 0 ? parsedTotalFloors : 1;

    if (mounted && resolvedTotalFloors != _totalFloors) {
      setState(() {
        _totalFloors = resolvedTotalFloors;
      });
    } else {
      _totalFloors = resolvedTotalFloors;
    }

    debugPrint('BUILDING TOTAL FLOORS: $_totalFloors');

    return properties;
  }

  Future<List<DocumentMainModel_F>> fetchCarouselData() async {
    final response = await http.get(
      Uri.parse(
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_multiple_image_in_future_property.php?subid=${widget.idd}',
      ),
    );

    print("SUBID: ${widget.idd}");
    print("API RESPONSE: ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true) {
        final List data = decoded['data'];

        return data
            .map((item) => DocumentMainModel_F.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
  void _handleMenuItemClick(String value) async {
    print("You clicked: $value");
    if (value == 'Edit Building') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UpdateRealEstateProperty(
            propertyId: int.parse(widget.idd),
          ),
        ),
      );
    }
    if (value.toString() == 'Add Building Images') {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FuturePropertyFileUploadPage(
            idd: widget.idd,
          ),
        ),
      );
      if (mounted) {
        _refreshAllData();
      }
    }
  }
  void _showCallDialog(BuildContext context, String number, String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Call $type"),
        content: Text('Do you want to call $number?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              FlutterPhoneDirectCaller.callNumber(number);
            },
            child: Text("Yes"),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = false /* forced light theme */;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildCustomHeader(isDarkMode),

            // Building photos and the condensed address/type summary come
            // first, so a worker can confirm they're on the right building
            // before scrolling into the floor-by-floor flat list.

            SliverToBoxAdapter(
              child: FutureBuilder<List<Ground>>(
                future: flatsFuture,
                builder: (context, snapshot) {

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingCard(isDarkMode);
                  }

                  if (snapshot.hasError) {
                    return _buildErrorCard(isDarkMode);
                  }

                  final flats = snapshot.data ?? [];

                  if (flats.isEmpty) {
                    return _buildEmptyFlatsSection();
                  }

                  return _buildAllFloorSections(flats, isDarkMode);
                },
              ),
            ),

            _buildImageCarouselSection(isDarkMode),

            _buildPropertyOverviewSection(isDarkMode),


            _buildBuildingDetailsSection(isDarkMode),

            const SliverToBoxAdapter(child: SizedBox(height: 1)),
          ],
        ),
      ),
      bottomNavigationBar: _buildAddFlatsButton(isDarkMode),
    );
  }
  // Custom Header without AppBar (AppBar and name removed)
  SliverToBoxAdapter _buildCustomHeader(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color:  Colors.black ,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [

              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  PhosphorIconsRegular.caretLeft,
                  color: Colors.white ,
                  size: 30,weight: 50,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),

              const Spacer(),
              Image.asset(AppImages.transparent,height: 45,),
              const Spacer(),
              if (isFieldWorker)
                PopupMenuButton<String>(
                  onSelected: _handleMenuItemClick,
                  itemBuilder: (BuildContext context) {
                    return {
                      'Edit Building',
                      'Add Building Images',
                    }.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice, style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
                      );
                    }).toList();
                  },
                  icon: Icon(
                    Icons.more_vert,
                    color: Colors.white ,size: 30,
                  ),
                  padding: const EdgeInsets.all(8),
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
        ),
      ),
    );
  }
  // Image Carousel Section
  SliverToBoxAdapter _buildImageCarouselSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<DocumentMainModel_F>>(
        future: imagesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              height: 250,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: CircularProgressIndicator()),
            );
          } else {
            return Container(
              margin: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 250,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 4),
                    enableInfiniteScroll: true,
                    viewportFraction: 0.9,
                    aspectRatio: 16 / 9,
                  ),
                  items: snapshot.data!.map((item) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropertyPreview(
                                  ImageUrl: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                ),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                key: ValueKey(item.dimage), // Added unique key to force distinct caching
                                imageUrl: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: isDarkMode ? Colors.grey[200] : Colors.grey[200],
                                  child: const Center(child: CircularProgressIndicator()),
                                ),
                                errorWidget: (context, error, stackTrace) => Container(
                                  color: isDarkMode ? Colors.grey[200] : Colors.grey[200],
                                  child: const Icon(Icons.error, color: Colors.grey, size: 40),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            );
          }
        },
      ),
    );
  }
  // Property Overview Section
  SliverToBoxAdapter _buildPropertyOverviewSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<FutureProperty2>>(
        future: propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard(isDarkMode);
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildErrorCard(isDarkMode);
          } else {
            final property = snapshot.data![0];
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [



                  // Property Type Tags - Fixed overflow with Wrap
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (property.place.isNotEmpty) _buildChip(property.place, Colors.blue, isDarkMode),
                      if (property.residenceCommercial.isNotEmpty) _buildChip(property.residenceCommercial, Colors.green, isDarkMode),
                      if (property.buyRent.isNotEmpty) _buildChip(property.buyRent, Colors.orange, isDarkMode),
                    ].where((chip) => chip !=  null).toList(),
                  ),
                  const SizedBox(height: 16),
                  // Property Address - Fixed text overflow
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on, color: Colors.red[400], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          property.propertyNameAddress.isNotEmpty
                              ? property.propertyNameAddress
                              : "No address available",
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),


                    ],
                  ),
                  const SizedBox(height: 12),
                  // Quick Stats - Changed to Wrap for responsive layout on small devices
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        alignment: WrapAlignment.spaceAround,
                        children: [
                          _buildStatItem("Total Floors", property.totalFloor, Icons.stairs, isDarkMode),
                          _buildStatItem("Road Size", property.roadSize, Icons.aod, isDarkMode),
                          _buildStatItem("Age", property.ageOfProperty, Icons.calendar_today, isDarkMode),
                        ],
                      );
                    },
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  String _floorDisplayLabel(String floorName) {
    final value = floorName.trim();
    final lower = value.toLowerCase();

    if (lower.contains('ground') || lower == 'g') {
      return 'Ground floor';
    }

    final match = RegExp(r'\d+').firstMatch(value);

    if (match != null) {
      final number = int.parse(match.group(0)!);
      final suffix = (number % 100 >= 11 && number % 100 <= 13)
          ? 'th'
          : switch (number % 10) {
        1 => 'st',
        2 => 'nd',
        3 => 'rd',
        _ => 'th',
      };

      return '$number$suffix floor';
    }

    return '$value floor';
  }

  Widget _buildFloorContentSection(
      String floorName,
      List<Ground> flats,
      bool isDarkMode,
      )
  {
    final filteredFlats = flats.where(_matchesFlatFilter).toList();

    // Keep only floors that contain flats matching the active filter.
    if (filteredFlats.isEmpty) {
      return const SizedBox.shrink();
    }

    // Reserve a slot for adding a flat; the grid remains three columns wide.
    final requiredSlots = filteredFlats.length + 1;
    final itemCount = ((requiredSlots + 2) ~/ 3) * 3 < 3
        ? 3
        : ((requiredSlots + 2) ~/ 3) * 3;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EEE5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.black,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 76,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, left: 4),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _floorDisplayLabel(floorName),
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${filteredFlats.length} '
                        '${filteredFlats.length == 1 ? 'flat' : 'flats'}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: LayoutBuilder(
              builder: (context, gridConstraints) {
                // Adapt the number of columns to the actual available width.
                // Keep three columns on normal phones, use two on very narrow
                // layouts, and add a fourth on wider screens/tablets.
                final availableWidth = gridConstraints.maxWidth;
                final crossAxisCount = availableWidth < 245
                    ? 2
                    : availableWidth >= 480
                    ? 4
                    : 3;
                final cardWidth =
                    (availableWidth - (crossAxisCount - 1) * 5) / crossAxisCount;

                // Give cards enough vertical room for their text on narrow phones.
                // Wide layouts can use a slightly shorter card without clipping.
                final cardHeight = cardWidth < 105
                    ? 104.0
                    : cardWidth < 135
                    ? 96.0
                    : 88.0;

                final slotCount = filteredFlats.length + (isFieldWorker ? 1 : 0);
                final responsiveItemCount = slotCount == 0
                    ? filteredFlats.length
                    : ((slotCount + crossAxisCount - 1) ~/ crossAxisCount) * crossAxisCount;

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  itemCount: responsiveItemCount,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    mainAxisExtent: cardHeight,
                  ),
                  itemBuilder: (context, index) {
                    if (index < filteredFlats.length) {
                      return _buildBuildingFlatTile(filteredFlats[index], cardHeight);
                    }
                    if (isFieldWorker) {
                      return _buildAddFlatSlot(floorName, cardHeight);
                    }
                    return const SizedBox.shrink();
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddFlatSlot(String floorName, double height) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(9),
        onTap: isFieldWorker ? _openAddFlatForm : null,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.25),
            borderRadius: BorderRadius.circular(9),
            border: Border.all(
              color: const Color(0xFFD8D1C2),
              style: BorderStyle.solid,
            ),
          ),
          child: Center(
            child: Icon(
              Icons.add,
              size: 25,
              color: isFieldWorker ? Colors.grey.shade500 : Colors.transparent,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openAddFlatForm() async {
    if (!isFieldWorker) return;

    try {
      final properties = await propertyFuture;
      if (!mounted || properties.isEmpty) return;

      final data = properties.first;

      if (data.roadSize.isEmpty ||
          data.metroName.isEmpty ||
          data.metroDistance.isEmpty ||
          data.mainMarketDistance.isEmpty ||
          data.ageOfProperty.isEmpty ||
          data.lift.isEmpty ||
          data.parking.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please update property details first'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Add_Flatunder_futureproperty(
            id: widget.idd,
            Owner_name: data.ownerName,
            Owner_num: data.ownerNumber,
            Caretaker_name: data.caretakerName,
            Caretaker_num: data.caretakerNumber,
            market_dis: data.mainMarketDistance,
            metro_name: data.metroName,
            metro_dis: data.metroDistance,
            road_size: data.roadSize,
            age_property: data.ageOfProperty,
            apartment_address: data.propertyNameAddress,
            apartment_name: data.propertyNameAddress,
            field_address: data.propertyAddressForFieldworker,
            current_loc: data.currentDate,
            place: data.place,
            lift: data.lift,
            totalFloor: data.totalFloor,
            Residence_commercial: data.residenceCommercial,
            facility: data.facility,
            google_loc: data.place,
            locality_list: data.localityList,
            apartment: '',
          ),
        ),
      );

      if (mounted) {
        _refreshAllData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Unable to open Add Flat form: $e')),
        );
      }
    }
  }

  Color _getBuyRentBorderColor(Ground flat) {
    if (_matchesBuyRentFilter(flat, 'Buy')) {
      return Colors.blue;
    }
    if (_matchesBuyRentFilter(flat, 'Rent')) {
      return Colors.deepPurple;
    }
    return Colors.grey.shade300;
  }

  Widget _buildBuildingFlatTile(Ground flat, double height) {
    final statusColor = _getFlatStatusColor(flat);
    final buyRentBorderColor = _getBuyRentBorderColor(flat);
    final hasBuyRentType = _matchesBuyRentFilter(flat, 'Buy') ||
        _matchesBuyRentFilter(flat, 'Rent');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => underflat_futureproperty(
              id: '${flat.id}',
              Subid: '${flat.subid}',
            ),
          ),
        );
      },
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: hasBuyRentType
              ? buyRentBorderColor.withOpacity(0.045)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: buyRentBorderColor,
            width: hasBuyRentType ? 1.8 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _flatDisplayName(flat),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF202938),
                    ),
                  ),
                ),
                Icon(
                  _getFlatIcon(flat),
                  size: 11,
                  color: statusColor,
                ),
              ],
            ),
            Text(
              _flatTypeText(flat),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '₹${flat.showPrice.isNotEmpty ? flat.showPrice : '—'}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF202938),
              ),
            ),
            Row(
              children: [
                Icon(
                  _getStatusIcon(flat),
                  size: 11,
                  color: statusColor,
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    _getFlatStatus(flat),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8,
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (isFieldWorker)
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DuplicateFutureProperty(
                            id: flat.id.toString(),
                            building_id: widget.idd,
                          ),
                        ),
                      );
                    },
                    child: const Icon(
                      Icons.copy_outlined,
                      size: 11,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _shortFloorName(String floor) {
    final value = floor.trim();

    if (value.isEmpty) {
      return '?';
    }

    final lower = value.toLowerCase();

    if (lower.contains('ground')) {
      return 'G';
    }

    // Keep numeric floor names compact.
    final match = RegExp(r'\d+').firstMatch(value);

    if (match != null) {
      return match.group(0)!;
    }

    return value.length > 3
        ? value.substring(0, 3)
        : value;
  }

  String _flatDisplayName(Ground flat) {
    final number = flat.flatNumber.trim();

    if (number.isNotEmpty) {
      return number;
    }

    return flat.id.toString();
  }
  String _flatTypeText(Ground flat) {
    final bhk = flat.bhk.trim();
    final type = flat.buyRent.trim();

    if (bhk.isNotEmpty && type.isNotEmpty) {
      return '$bhk • $type';
    }

    if (bhk.isNotEmpty) {
      return bhk;
    }

    if (type.isNotEmpty) {
      return type;
    }

    return 'Property';
  }
  String _flatSecondaryInfo(Ground flat) {
    // Use location when available.
    if (flat.locations.trim().isNotEmpty) {
      return flat.locations.trim();
    }

    if (flat.buyRent.trim().isNotEmpty) {
      return flat.buyRent.trim();
    }

    return 'No additional details';
  }
  String _normalisedFlatStatus(Ground flat) {
    return flat.live.trim().toLowerCase();
  }
  String _getFlatStatus(Ground flat) {
    final value = _normalisedFlatStatus(flat);

    if (value.isEmpty) {
      return 'Status unavailable';
    }

    if (value.contains('book')) {
      return 'Booked';
    }

    if (value.contains('upcoming') ||
        value.contains('vacant') ||
        value.contains('available')) {
      return flat.live;
    }

    if (value.contains('live')) {
      return 'Listed on website';
    }

    return flat.live;
  }
  Color _getFlatStatusColor(Ground flat) {
    final value = _normalisedFlatStatus(flat);

    if (value.contains('book')) {
      return const Color(0xFFB8C2D3);
    }

    if (value.contains('upcoming') ||
        value.contains('vacant') ||
        value.contains('available')) {
      return const Color(0xFFE6A21A);
    }

    if (value.contains('live')) {
      return const Color(0xFF2FB879);
    }

    return const Color(0xFFB8C2D3);
  }
  IconData _getStatusIcon(Ground flat) {
    final value = _normalisedFlatStatus(flat);

    if (value.contains('book')) {
      return Icons.person_outline;
    }

    if (value.contains('upcoming') ||
        value.contains('vacant') ||
        value.contains('available')) {
      return Icons.schedule_outlined;
    }

    if (value.contains('live')) {
      return Icons.north_east;
    }

    return Icons.info_outline;
  }
  IconData _getFlatIcon(Ground flat) {
    final value = flat.typeOfProperty.trim().toLowerCase();

    if (value.contains('commercial') ||
        value.contains('shop') ||
        value.contains('office')) {
      return Icons.storefront_outlined;
    }

    if (value.contains('1')) {
      return Icons.home_work_outlined;
    }

    return Icons.home_outlined;
  }

  bool _matchesFlatFilter(Ground flat) {
    if (_flatFilter == 'All') {
      return true;
    }

    if (_flatFilter == 'Buy' || _flatFilter == 'Rent') {
      return _matchesBuyRentFilter(flat, _flatFilter);
    }

    final status = _normalisedFlatStatus(flat);

    switch (_flatFilter) {
      case 'Live':
        return status.contains('live');

      case 'Upcoming':
        return status.contains('upcoming') ||
            status.contains('vacant') ||
            status.contains('available');

      case 'Booked':
        return status.contains('book');

      default:
        return true;
    }
  }
  bool _matchesBuyRentFilter(Ground flat, String filter) {
    final value = flat.buyRent.trim().toLowerCase();
    if (filter == 'Rent') {
      return value.contains('rent');
    }
    if (filter == 'Buy') {
      // Some APIs label sale properties as "Sell" rather than "Buy".
      return value.contains('buy') || value.contains('sell') || value.contains('sale');
    }
    return true;
  }

  int _countFlatStatus(
      List<Ground> flats,
      String filter,
      ) {
    return flats.where((flat) {
      if (filter == 'All') {
        return true;
      }

      final status = _normalisedFlatStatus(flat);

      if (filter == 'Live') {
        return status.contains('live');
      }

      if (filter == 'Upcoming') {
        return status.contains('upcoming') ||
            status.contains('vacant') ||
            status.contains('available');
      }

      if (filter == 'Booked') {
        return status.contains('book');
      }

      return false;
    }).length;
  }

  Widget _buildFlatsSummaryHeader(
      List<Ground> flats,
      Map<String, List<Ground>> grouped,
      ) {
    final liveCount = _countFlatStatus(flats, 'Live');
    final upcomingCount = _countFlatStatus(flats, 'Upcoming');
    final bookedCount = _countFlatStatus(flats, 'Booked');
    final buyCount = flats.where((flat) => _matchesBuyRentFilter(flat, 'Buy')).length;
    final rentCount = flats.where((flat) => _matchesBuyRentFilter(flat, 'Rent')).length;

    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 5),
      padding: const EdgeInsets.fromLTRB(2, 2, 2, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ─────────────────────────────
          // TITLE
          // ─────────────────────────────
          Row(
            children: [

              const Text(
                'Flats',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF202938),
                ),
              ),

              const Spacer(),

              Text(
                '${flats.length} across ${grouped.length} floors',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 9),

          // ─────────────────────────────
          // FLOOR/STATUS BAR
          // ─────────────────────────────
          _buildFlatStatusBar(
            liveCount,
            upcomingCount,
            bookedCount,
          ),

          const SizedBox(height: 12),

          // ─────────────────────────────
          // MINI SUMMARY CARDS
          // ─────────────────────────────
          Row(
            children: [

              Expanded(
                child: _buildMiniFlatStat(
                  'Listed on website',
                  _getListedRent(flats),
                  'From live flats',
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: _buildMiniFlatStat(
                  'Next vacancy',
                  _getNextVacancy(flats),
                  'Upcoming',
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: _buildMiniFlatStat(
                  'Flats',
                  '${flats.length}',
                  'total flats',
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─────────────────────────────
          // FILTER CHIPS
          // ─────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFlatFilterChip('All', flats.length, Colors.indigo),
                const SizedBox(width: 6),
                _buildFlatFilterChip('Buy', buyCount, Colors.blue),
                const SizedBox(width: 6),
                _buildFlatFilterChip('Rent', rentCount, Colors.deepPurple),
                const SizedBox(width: 6),
                _buildFlatFilterChip('Live', liveCount, Colors.green),
                const SizedBox(width: 6),
                _buildFlatFilterChip('Upcoming', upcomingCount, Colors.orange),
                const SizedBox(width: 6),
                _buildFlatFilterChip('Booked', bookedCount, const Color(0xFFB9C3D5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFlatStatusBar(
      int liveCount,
      int upcomingCount,
      int bookedCount,
      ) {
    final total = liveCount + upcomingCount + bookedCount;

    if (total == 0) {
      return const SizedBox.shrink();
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: SizedBox(
        height: 7,
        child: Row(
          children: [
            if (liveCount > 0)
              Flexible(
                flex: liveCount,
                child: Container(
                  color: Colors.green.shade400,
                ),
              ),

            if (upcomingCount > 0)
              Flexible(
                flex: upcomingCount,
                child: Container(
                  color: Colors.orange.shade400,
                ),
              ),

            if (bookedCount > 0)
              Flexible(
                flex: bookedCount,
                child: Container(
                  color: const Color(0xFFB9C3D5),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniFlatStat(
      String title,
      String value,
      String subtitle,
      ) {
    return Container(
      height: 70,
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F5F8),
        borderRadius: BorderRadius.circular(11),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade500,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF202938),
            ),
          ),

          const Spacer(),

          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 9,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFlatFilterChip(
      String label,
      int count,
      Color color,
      ) {
    final selected = _flatFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _flatFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 7,
        ),
        decoration: BoxDecoration(
          color: selected
              ? color.withOpacity(0.08)
              : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected
                ? color
                : Colors.grey.shade300,
            width: selected ? 1.2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            if (label != 'All')
              Container(
                width: 7,
                height: 7,
                margin: const EdgeInsets.only(right: 5),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),

            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected
                    ? FontWeight.w600
                    : FontWeight.w500,
                color: selected
                    ? color
                    : const Color(0xFF4B5563),
              ),
            ),

            const SizedBox(width: 4),

            Text(
              '$count',
              style: TextStyle(
                fontSize: 10,
                color: selected
                    ? color
                    : Colors.grey.shade500,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
  String _getListedRent(List<Ground> flats) {
    for (final flat in flats) {
      final status = _normalisedFlatStatus(flat);

      if (status.contains('live') &&
          flat.showPrice.trim().isNotEmpty) {
        return '₹${flat.showPrice}';
      }
    }

    return '—';
  }
  String _getNextVacancy(List<Ground> flats) {
    for (final flat in flats) {
      final status = _normalisedFlatStatus(flat);

      if (status.contains('upcoming') ||
          status.contains('vacant') ||
          status.contains('available')) {
        return _flatDisplayName(flat).isNotEmpty
            ? 'Flat ${_flatDisplayName(flat)}'
            : 'Upcoming';
      }
    }

    return '—';
  }
  Widget _buildEmptyFlatsSection() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Column(
        children: [

          Icon(
            Icons.apartment_outlined,
            size: 36,
            color: Colors.grey.shade400,
          ),

          const SizedBox(height: 8),

          Text(
            'No flats added yet',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            'Add a flat to this building',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _buildBuildingDetailsSection(bool isDarkMode) {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<FutureProperty2>>(
        future: propertyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingCard(isDarkMode);
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return _buildErrorCard(isDarkMode);
          } else {
            final property = snapshot.data![0];
            return Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    children: [
                      Container(
                        width: 140,
                        height: 100,
                        child: _networkImageUrl != null && _networkImageUrl!.isNotEmpty
                            ? ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            _networkImageUrl!,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        )
                            : const Center(child: Text('', style: TextStyle(color: Colors.black))),
                      ),

                      const SizedBox(width: 20),

                      const Icon(Icons.business, color: Colors.blue, size: 20),
                      const SizedBox(width: 8),
                      const Text(
                        "Building Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Contact Information
                  _buildContactSection(property, isDarkMode),
                  const SizedBox(height: 20),
                  // Property Specifications - Fixed grid layout with better overflow handling
                  _buildSpecificationsSection(property, isDarkMode),
                  const SizedBox(height: 20),
                  // Location Information
                  _buildLocationSection(property, isDarkMode),
                ],
              ),
            );
          }
        },
      ),
    );
  }
  // Contact Section
  Widget _buildContactSection(FutureProperty2 property, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Information",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        // Owner Info
        if (property.ownerName.isNotEmpty || property.ownerNumber.isNotEmpty)
          _buildContactCard(
            "Owner",
            property.ownerName,
            property.ownerNumber,
            Icons.person,
            Colors.blue,
            isDarkMode,
          ),
        if (property.ownerName.isNotEmpty || property.ownerNumber.isNotEmpty)
          const SizedBox(height: 8),
        // Caretaker Info
        if (property.caretakerName.isNotEmpty || property.caretakerNumber.isNotEmpty)
          _buildContactCard(
            "Caretaker",
            property.caretakerName,
            property.caretakerNumber,
            Icons.support_agent,
            Colors.green,
            isDarkMode,
          ),
      ],
    );
  }
  // Contact Card
  Widget _buildContactCard(String title, String name, String number, IconData icon, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  name.isNotEmpty ? name : "Not available",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (number.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  GestureDetector(
                    onTap: () => _showCallDialog(context, number, title),
                    child: Text(
                      number,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.blue[600],
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (number.isNotEmpty)
            IconButton(
              onPressed: () => _showCallDialog(context, number, title),
              icon: Icon(Icons.phone, color: color, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildSpecificationsSection(FutureProperty2 property, bool isDarkMode) {
    final specifications = [
      {"icon": Icons.train, "label": "Metro Station", "value": property.metroName},
      {"icon": Icons.place, "label": "Metro Distance", "value": property.metroDistance},
      {"icon": Icons.shopping_cart, "label": "Market Distance", "value": property.mainMarketDistance},
      {"icon": Icons.calendar_month, "label": "Date & Time", "value": property.currentDate},
      {"icon": Icons.elevator, "label": "Lift", "value": property.lift},
      {"icon": Icons.local_parking, "label": "Parking", "value": property.parking},
      {"icon": Icons.shopping_cart, "label": "Locality", "value": property.localityList},
    ].where((spec) => (spec["value"] as String).isNotEmpty).toList();

    if (specifications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Text(
            "No specifications available",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Specifications",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),

        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.9,
              ),
              itemCount: specifications.length,
              itemBuilder: (context, index) {
                final spec = specifications[index];
                final label = spec["label"] as String;
                final value = spec["value"] as String;

                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        spec["icon"] as IconData,
                        size: 18,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 4),

                            if (label == "Date & Time") ...[
                              Builder(
                                builder: (_) {
                                  final parts = value.split(" ");

                                  String datePart =
                                  parts.isNotEmpty ? parts[0] : "";
                                  String timePart =
                                  parts.length > 1 ? parts[1] : "";
                                  String amPm =
                                  parts.length > 2 ? parts[2] : "";

                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        datePart,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        "$timePart $amPm",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ] else
                              Text(
                                value,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }


  Widget _buildLocationSection(FutureProperty2 property, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Location",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (property.propertyNameAddress.isNotEmpty)
                _buildLocationItem("Property Address", property.propertyNameAddress, isDarkMode),
              if (property.propertyNameAddress.isNotEmpty) const SizedBox(height: 8),
              if (property.propertyAddressForFieldworker.isNotEmpty)
                _buildLocationItem("Field Worker Address", property.propertyAddressForFieldworker, isDarkMode),
              if (property.propertyAddressForFieldworker.isNotEmpty) const SizedBox(height: 8),
              if (property.yourAddress.isNotEmpty)
                _buildLocationItem("Current Location", property.yourAddress, isDarkMode, isClickable: true),
            ],
          ),
        ),
      ],
    );
  }
  // Location Item
  Widget _buildLocationItem(String label, String value, bool isDarkMode, {bool isClickable = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (label == "Current Location")
              const Icon(
                Icons.location_on,
                color: Colors.red,
                size: 16,
              ),
            if (label == "Current Location") const SizedBox(width: 4),
            Expanded(
              child: isClickable
                  ? GestureDetector(
                onTap: () async {
                  final url = Uri.parse("https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(value)}");
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.blue,
                    fontWeight: FontWeight.w700, // Highlighted with bold
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              )
                  : Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w700, // Highlighted with bold
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ],
    );
  }
  // Add Flats Button
  Widget _buildAddFlatsButton(bool isDarkMode) {
    return FutureBuilder<List<FutureProperty2>>(
      future: propertyFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final data = snapshot.data!.first;
        _networkImageUrl = "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${data.images.isNotEmpty ? data.images : ''}";

        print(_networkImageUrl);
        return Container(
          margin: const EdgeInsets.all(16),
          child: Row(
            children: [
              /// CALL BUTTON
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AllContact(
                          buildingId: data.id,
                          ownerName: data.ownerName,
                          ownerNumber: data.ownerNumber,
                          buildingImage: _networkImageUrl,
                          buildingAddress: data.propertyAddressForFieldworker,
                          caretakerName: data.caretakerName,
                          caretakerNumber: data.caretakerNumber,
                        ),
                      ),
                    );
                  },
                  child: const Text("Calling section",style: TextStyle(color: Colors.white),),
                ),
              ),

              if (isFieldWorker) ...[
                const SizedBox(width: 12),

                /// ADD FLAT BUTTON
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      if (data.roadSize.isEmpty ||
                          data.metroName.isEmpty ||
                          data.metroDistance.isEmpty ||
                          data.mainMarketDistance.isEmpty ||
                          data.ageOfProperty.isEmpty ||
                          data.lift.isEmpty ||
                          data.parking.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("⚠ Please update property details first"),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => Add_Flatunder_futureproperty(
                            id: widget.idd,
                            Owner_name: data.ownerName,
                            Owner_num: data.ownerNumber,
                            Caretaker_name: data.caretakerName,
                            Caretaker_num: data.caretakerNumber,
                            market_dis: data.mainMarketDistance,
                            metro_name: data.metroName,
                            metro_dis: data.metroDistance,
                            road_size: data.roadSize,
                            age_property: data.ageOfProperty,
                            apartment_address: data.propertyNameAddress,
                            apartment_name: data.propertyNameAddress,
                            field_address: data.propertyAddressForFieldworker,
                            current_loc: data.currentDate,
                            place: data.place,
                            lift: data.lift,
                            totalFloor: data.totalFloor,
                            Residence_commercial: data.residenceCommercial,
                            facility: data.facility,
                            google_loc: data.place,
                            locality_list: data.localityList,
                            apartment: '',
                          ),
                        ),
                      );
                    },
                    child: const Text("Add New Flat",style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildChip(String text, Color color, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        children: [
          Icon(icon, size: 20, color: Colors.blue),
          const SizedBox(height: 4),
          Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
    );
  }

  Widget _buildErrorCard(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(Icons.error_outline, size: 40, color: Colors.grey[400]),
          const SizedBox(height: 8),
          Text(
            "Unable to load property details",
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

