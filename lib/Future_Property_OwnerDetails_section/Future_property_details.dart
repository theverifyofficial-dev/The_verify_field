import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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

  @override
  void initState() {
    super.initState();
    _loadAll();
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
      final floor = flat.floor.trim();
      grouped.putIfAbsent(floor, () => []).add(flat);
    }

    return grouped;
  }

  Future<List<Ground>> fetchAllFlats() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_building_flat.php?subid=${widget.idd}",
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
      "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/show_api_for_details_page.php?id=${widget.idd}",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('API Error: ${response.statusCode}');
    }

    final decoded = json.decode(response.body);
    List listResponse = [];

    if (decoded is List) {
      listResponse = decoded;
    }
    else if (decoded is Map<String, dynamic>) {
      if (decoded['data'] is List) {
        listResponse = decoded['data'];
      }
      else if (decoded['Table'] is List) {
        listResponse = decoded['Table'];
      }
      else {
        throw Exception("No list found in API response");
      }
    }

    listResponse.sort(
          (a, b) => (b['id'] ?? '').toString().compareTo((a['id'] ?? '').toString()),
    );

    return listResponse
        .map((e) => FutureProperty2.fromJson(e))
        .toList();
  }

  Future<List<DocumentMainModel_F>> fetchCarouselData() async {
    final response = await http.get(Uri.parse('https://verifyserve.social/WebService4.asmx/display_future_property_multiple_images?subid=${widget.idd}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((item) {
        return DocumentMainModel_F(
          dimage: item['img'],
        );
      }).toList();
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FuturePropertyFileUploadPage(
            idd: widget.idd,
          ),
        ),
      );
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
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: _refreshAllData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildCustomHeader(isDarkMode),

            SliverToBoxAdapter(
              child: FutureBuilder<List<Ground>>(
                future: flatsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoadingCard(isDarkMode);
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  final grouped = groupFlatsByFloor(snapshot.data!);

                  return Column(
                    children: grouped.entries.map((entry) {
                      return _buildFloorContentSection(
                        entry.key,
                        entry.value,
                        isDarkMode,
                      );
                    }).toList(),
                  );
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
                icon: Icon(
                  PhosphorIcons.caret_left_bold,
                  color: Colors.white ,
                  size: 30,weight: 50,
                ),
                padding: const EdgeInsets.all(8),
                constraints: const BoxConstraints(),
              ),
              // ),
              const Spacer(),
              Image.asset(AppImages.transparent,height: 45,),
              const Spacer(),
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
              //),
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
          } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
            return Container(
              height: 180,
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.white : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDarkMode ? 0.3 : 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_library, size: 50, color: isDarkMode ? Colors.black87 : Colors.grey[400]),
                  const SizedBox(height: 8),
                  Text(
                    "No Images Available",
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.black87 : Colors.grey[600],
                    ),
                  ),
                ],
              ),
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
                                  ImageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
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
                                imageUrl: "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/${item.dimage}",
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

  Widget _buildFloorContentSection(String floorName, List<Ground> flats, bool isDarkMode) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = (screenWidth - 48) * 0.65; // Responsive width: 65% of available space minus margins
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floor Header
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue[600],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    floorName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${flats.length} flats",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Flats Horizontal List - Responsive height based on card width
          SizedBox(
            height: cardWidth * 1.2, // Approximate aspect ratio for better responsiveness
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: flats.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildFlatCard(flats[index], isDarkMode, cardWidth),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  // Individual Flat Card - Responsive width and unique key for images
  Widget _buildFlatCard(Ground flat, bool isDarkMode, double cardWidth) {
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
      child: SizedBox(
        width: cardWidth,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Flat Image - Expanded flex
              Expanded(
                flex: 2,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        key: ValueKey('${flat.id}_${flat.propertyPhoto}'),
                        imageUrl: flat.propertyPhoto.isNotEmpty
                            ? "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${flat.propertyPhoto}"
                            : "",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: Colors.grey[200],
                          child: const Center(child: CircularProgressIndicator()),
                        ),
                        errorWidget: (context, error, stackTrace) => Container(
                          color: Colors.grey[200],
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.home_outlined, size: 40, color: Colors.grey),
                              SizedBox(height: 4),
                              Text("No Image",
                                  style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      top: 8,
                      left: 8,
                      child:
                      Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.green)
                          ),
                          child: Text(
                            flat.live,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),

                    // 🔥 DUPLICATE BUTTON
                    Positioned(
                      top: 8,
                      right: 8,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return DuplicateFutureProperty(id: flat.id.toString(), building_id: widget.idd,);
                          }));
                          // 👉 Duplicate logic here
                          print("Duplicate flat id: ${flat.id}");
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.white)
                          ),
                          child: const Text(
                            "Duplicate",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Flat Details - Expanded flex
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child:
                            Text(
                              "${flat.bhk} • ${flat.typeOfProperty}",
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (flat.flatNumber.isNotEmpty)
                            Text(
                              "Flat ${flat.flatNumber}",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                          Text(
                            flat.locations.isNotEmpty ? flat.locations : "No location",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.blue[100]!),
                            ),
                            child: Text(
                              flat.buyRent.isNotEmpty ? flat.buyRent : "N/A",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue[700],
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          Text(
                           " ${flat.id}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),


                          Text(
                            "₹${flat.showPrice.isNotEmpty ? flat.showPrice : "0"}",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Building Details Section
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
                  // Section Header
                  Row(
                    children: [
                      Icon(Icons.business, color: Colors.blue, size: 20),
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
  // Specifications Section - Improved with dynamic grid and better overflow
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
                childAspectRatio: 2.5, // Adjusted for better fit and less overflow
              ),
              itemCount: specifications.length,
              itemBuilder: (context, index) {
                final spec = specifications[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(spec["icon"] as IconData, size: 18, color: Colors.blue),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              spec["label"] as String,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              spec["value"] as String,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
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
  // Location Section
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
              Icon(
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
                        builder: (_) => AllContact(
                          buildingId: data.id,
                          ownerName: data.ownerName,
                          ownerNumber: data.ownerNumber,
                        ),
                      ),
                    );
                  },
                  child: const Text("Calling section"),
                ),
              ),

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
                  child: const Text("Add New Flat"),
                ),
              ),
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