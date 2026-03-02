
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Future_property_controller.dart';
import '../Custom_Widget/constant.dart';
import 'Add_commercial_property.dart';
import 'Add_futureProperty.dart';
import 'Add_plot_property.dart';
import 'Future_property_details.dart';
import 'PlotShow.dart';
import 'commercialShow.dart';

class FrontPage_FutureProperty extends StatefulWidget {
  const FrontPage_FutureProperty({super.key});

  @override
  State<FrontPage_FutureProperty> createState() =>
      _FrontPage_FuturePropertyState();
}

class _FrontPage_FuturePropertyState
    extends State<FrontPage_FutureProperty>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {

  late TabController _tabController;
  late FuturePropertyController controller;

  @override
  bool get wantKeepAlive => true;

  String _number = '';
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUser();
  }

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';

    controller = FuturePropertyController(_number);
    await controller.initialize();

    setState(() {
      _initialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: _showAddOptionsDialog,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Add Forms",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            backgroundColor: Colors.blue,
          ),

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
            bottom: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              tabs: const [
                Tab(text: 'Buildings'),
                Tab(text: 'Plots'),
                Tab(text: 'Commercial'),
              ],
            ),
          ),
          body: controller.isLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
            controller: _tabController,
            children: [
              BuildingsTab(controller: controller),
              PlotListPage(fieldworkerNumber: _number),
              CommercialListPage(fieldWorkerNumber: _number),
            ],
          ),
        );
      },
    );
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
                                builder: (context) => const Add_FutureProperty()));
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        _buildOptionTile(
                          icon: Icons.landscape,
                          title: 'Add Plot',
                          subtitle: 'Add a new plot record',
                          onTap: () async {
                            Navigator.of(context).pop();
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>  PropertyListingPage(),
                              ),
                            );
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Plot added',
                                        style: TextStyle(fontSize: isTablet ? 16 : 14)
                                    ),
                                    backgroundColor: Colors.green
                                ),
                              );
                            }
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),
                        _buildOptionTile(
                          icon: Icons.storefront,
                          title: 'Add Commercial',
                          subtitle: 'Add a commercial property',
                          onTap: () async {
                            Navigator.of(context).pop();
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  CommercialPropertyForm()
                              ),
                            );
                            if (result != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Commercial added',
                                        style: TextStyle(fontSize: isTablet ? 16 : 14)
                                    ),
                                    backgroundColor: Colors.green
                                ),
                              );
                            }
                          },
                          isTablet: isTablet,
                        ),
                        SizedBox(height: isTablet ? 16 : 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,   // button color
                            foregroundColor: Colors.black,   // text color
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            'Cancel',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                        )
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
      color: Theme
          .of(context)
          .brightness == Brightness.dark ? Colors.grey[800] : Colors
          .white,
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

class BuildingsTab extends StatefulWidget {
  final FuturePropertyController controller;

  const BuildingsTab({super.key, required this.controller});

  @override
  State<BuildingsTab> createState() => _BuildingsTabState();
}

class _BuildingsTabState extends State<BuildingsTab> {
  final TextEditingController _searchController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return RefreshIndicator(
      onRefresh: controller.refresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          /// ================= SEARCH =================
          Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: _searchController,
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: 'Search properties...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    _searchController.clear();
                    controller.search('');
                    setState(() {});
                  },
                )
                    : null,
                filled: true,
                fillColor:
                isDark ? Colors.grey[900] : Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          /// ================= FILTERS =================
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _filterButton("Rent"),
                _filterButton("Buy"),
                _filterButton("Commercial"),
                _filterButton("Missing Field"),
                _filterButton("Live"),
                _filterButton("Unlive"),
                _filterButton("Empty Building"),
              ],
            ),
          ),

          const SizedBox(height: 12),

          /// ================= INFO SECTION =================
          if (controller.count > 0)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _infoChip("${controller.count} building found"),
                  const SizedBox(width: 8),
                  _infoChip("Total Flats: ${controller.totalFlats}"),
                  const SizedBox(width: 8),
                  _infoChip("Live Flats: ${controller.liveFlats}"),
                  const SizedBox(width: 8),
                  _infoChip("Rent Out: ${controller.bookFlats}"),
                ],
              ),
            ),

          const SizedBox(height: 20),

          /// ================= BUILDINGS =================
          ...controller.properties.asMap().entries.map((entry) {
            final index = entry.key;
            final property = entry.value;
            final status =
                controller.statuses[property.id] ?? {"liveCount": 0};

            return BuildingCard(
              property: property,
              status: status,
              displayIndex:
              controller.properties.length - index,
              isStatusLoading: controller.isStatusLoading,

            );
          }).toList(),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  /// ================= FILTER BUTTON =================
  Widget _filterButton(String label) {
    final controller = widget.controller;
    final bool isSelected = controller.selectedLabel == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: () {
          controller.applyFilter(label);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black87,
          elevation: isSelected ? 4 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500,color: Colors.black87),
      ),
    );
  }
}

class BuildingCard extends StatelessWidget {
  final Catid property;
  final Map<String, dynamic> status;
  final int displayIndex;
  final bool isStatusLoading;


  const BuildingCard({
    super.key,
    required this.property,
    required this.status,
    required this.displayIndex,
    required this.isStatusLoading,

  });

  @override
  Widget build(BuildContext context) {
    final liveCount = status["liveCount"];
    final totalFlats = status["totalFlats"];
    const baseUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/";

    final imageUrl = (property.images != null &&
        property.images!.isNotEmpty)
        ? baseUrl + property.images!
        : "";

    /// ================= MISSING FIELD CHECK =================
    bool isEmpty(String? value) =>
        value == null || value.trim().isEmpty;

    final Map<String, String?> fields = {
      "Images": property.images,
      "Owner Name": property.ownerName,
      "Owner Number": property.ownerNumber,
      "Caretaker Name": property.caretakerName,
      "Caretaker Number": property.caretakerNumber,
      "Place": property.place,
      "Buy/Rent": property.buyRent,
      "Property Address": property.propertyNameAddress,
      "Field Worker Name": property.fieldWorkerName,
      "Field Worker Number": property.fieldWorkerNumber,
      "Longitude": property.longitude,
      "Latitude": property.latitude,
      "Road Size": property.roadSize,
      "Age of Property": property.ageOfProperty,
      "Lift": property.lift,
      "Parking": property.parking,
      "Total Floor": property.totalFloor,
      "Residence/Commercial": property.residenceCommercial,
    };

    final missingFields = fields.entries
        .where((e) => isEmpty(e.value))
        .map((e) => e.key)
        .toList();

    final hasMissing = missingFields.isNotEmpty;

    return GestureDetector(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Future_Property_details(
                idd: property.id.toString(),
              ),
            ),
          );

          // Refresh after coming back
          final controller =
              context.findAncestorStateOfType<_FrontPage_FuturePropertyState>()
                  ?.controller;

          controller?.refresh();
        },
        child: Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade700),
      ),
      child: Column(
        children: [

          /// TOP SECTION
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// IMAGE
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: imageUrl.isEmpty
                        ? Container(
                      height: 200,
                      width: 140,
                      color: Colors.grey.shade800,
                      child: const Icon(Icons.apartment,
                          size: 60, color: Colors.grey),
                    )
                        : CachedNetworkImage(
                      imageUrl: imageUrl,
                      height: 200,
                      width: 140,
                      fit: BoxFit.cover,
                      memCacheWidth: 600,
                      memCacheHeight: 600,
                    ),
                  ),

                  Positioned(
                    top: 8,
                    left: 8,
                    child: isStatusLoading
                        ? const SizedBox.shrink()
                        : Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (liveCount ?? 0) > 0
                            ? Colors.green
                            : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        (liveCount ?? 0) > 0
                            ? "Live: $liveCount"
                            : "Unlive: 0",
                        style: const TextStyle(
                            fontSize: 11,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 14),

              /// DETAILS
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      property.propertyNameAddress ?? "No Title",
                      style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text("📍 Location: ${property.place ?? '-'}",
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text("🤝 ${property.buyRent ?? '-'}",
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text("🏢 ${property.residenceCommercial ?? '-'}",
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 6),
                    Text("🏷 Age: ${property.ageOfProperty ?? '-'}",
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 6),
                Text(
                  "📋 Total Flats: ${totalFlats ?? 0}",
                  style: const TextStyle(color: Colors.white),
                ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Building ID: ${property.id}",
                style: const TextStyle(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,fontSize: 12),
              ),

              Text("Added Date: ${property.currentDate ?? '-'}",
                  style: const TextStyle(color: Colors.white,fontStyle: FontStyle.italic,fontSize: 12)),
            ],
          ),

          /// ================= MISSING FIELD BANNER =================
          if (hasMissing) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.red),
              ),
              child: Text(
                "⚠ Missing: ${missingFields.join(', ')}",
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                    fontSize: 12),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    ));
  }
}