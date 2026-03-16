import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Future_property_controller.dart';
import 'Future_property_details.dart';

class FrontPage_FutureProperty extends StatefulWidget {
  const FrontPage_FutureProperty({super.key});

  @override
  State<FrontPage_FutureProperty> createState() =>
      _FrontPage_FuturePropertyState();
}

class _FrontPage_FuturePropertyState
    extends State<FrontPage_FutureProperty> {

  late FuturePropertyController controller;
  String _number = '';
  bool _initialized = false;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _loadUser();
  }
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {

      if (!controller.isPaginationLoading &&
          controller.hasMore &&
          !controller.isLoading) {

        controller.loadMore(); // 👈 clean method
      }
    }
  }


  late ScrollController _scrollController;

  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';

    controller = FuturePropertyController(_number);
    await controller.initialize();

    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Scaffold(
          backgroundColor: isDark ? Colors.black : Colors.white,
          body: RefreshIndicator(
            onRefresh: controller.refresh,
            child: ListView(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              children: [

                /// ================= FILTER BUTTONS =================
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterButton("All"),
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

                const SizedBox(height: 10),

                /// ================= INFO CHIPS =================
                if (controller.count > 0)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _infoChip("${controller.totalRecords} building found"),
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
                ...controller.properties.map((property) {
                  return _buildingCard(property);
                }).toList(),

                if (controller.isPaginationLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),

                if (controller.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ================= INFO CHIP =================
  Widget _infoChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey),
        color: Colors.white,
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.black87,
          fontFamily: "PoppinsMedium",
        ),
      ),
    );
  }

  /// ================= FILTER BUTTON =================
  Widget _filterButton(String label) {
    final bool isSelected = controller.selectedLabel == label;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: controller.isLoading
            ? null
            : () {
          controller.applyFilter(label);
        },
        style: ElevatedButton.styleFrom(
          elevation: isSelected ? 3 : 0,
          backgroundColor:
          isSelected ? Colors.blue : Colors.grey.shade300,
          foregroundColor:
          isSelected ? Colors.white : Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontFamily: "PoppinsMedium",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildingCard(Catid property) {

    final status =
        controller.statuses[property.id] ?? {"liveCount": 0, "totalFlats": 0};

    final int liveCount = status["liveCount"] ?? 0;
    final int totalFlats = status["totalFlats"] ?? 0;

    const baseUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/";

    final imageUrl =
    (property.images != null && property.images!.isNotEmpty)
        ? baseUrl + property.images!
        : "";

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
            builder: (context) =>
                Future_Property_details(idd: property.id.toString()),
          ),
        );
        controller.refresh();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.grey.shade900
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: imageUrl.isEmpty
                          ? Container(
                        height: 200,
                        width: 140,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.apartment,
                            size: 60, color: Colors.grey),
                      )
                          : CachedNetworkImage(
                        imageUrl: imageUrl,
                        height: 200,
                        width: 140,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Positioned(
                      top: 8,
                      left: 8,
                      child: controller.isStatusLoading
                          ? const SizedBox.shrink()
                          : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: liveCount > 0
                              ? Colors.green
                              : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          liveCount > 0
                              ? "Live: $liveCount"
                              : "Unlive: 0",
                          style: const TextStyle(
                              fontSize: 11,
                              fontFamily: "PoppinsMedium",
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.propertyNameAddress ?? "No Title",
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text("📍 ${property.place ?? '-'}"),
                      const SizedBox(height: 6),
                      Text("🤝 ${property.buyRent ?? '-'}"),
                      const SizedBox(height: 6),
                      Text("🏢 ${property.residenceCommercial ?? '-'}"),
                      const SizedBox(height: 6),
                      Text("🏷 Age: ${property.ageOfProperty ?? '-'}"),
                      const SizedBox(height: 6),
                      Text("📋 Total Flats: $totalFlats"),
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
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      fontSize: 12),
                ),
                Text(
                  "Added: ${property.currentDate ?? '-'}",
                  style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12),
                ),
              ],
            ),

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
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}