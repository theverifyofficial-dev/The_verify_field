import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Controller/Commercial_controller.dart';
import 'Commercial_detail.dart';

class CommercialListPage extends StatefulWidget {
  final String fieldWorkerNumber;
  
  const CommercialListPage({
    super.key,
    required this.fieldWorkerNumber});

  @override
  State<CommercialListPage> createState() => _CommercialListPageState();
}

class _CommercialListPageState extends State<CommercialListPage> {
  late CommercialPropertyController controller;
  late ScrollController _scrollController;
  String _number = '';
  bool _initialized = false;

  // Search
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadUser();
  }

  // ===================== SCROLL PAGINATION =====================
  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!controller.isPaginationLoading &&
          controller.hasMore &&
          !controller.isLoading) {
        controller.loadMore();
      }
    }
  }

  // ===================== LOAD USER =====================
  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';

    controller = CommercialPropertyController(_number);
    await controller.initialize();

    if (mounted) {
      setState(() => _initialized = true);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ===================== SEARCH DEBOUNCE =====================
  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      controller.searchBuilding(query);
    });
  }

  // ===================== BUILD =====================
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

                // ================= SEARCH BAR =================
                _buildSearchBar(isDark),

                const SizedBox(height: 12),

                // ================= FILTER BUTTONS =================
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _filterButton("All"),
                      _filterButton("Rent"),
                      _filterButton("Sell"),
                      _filterButton("Office"),
                      _filterButton("Retail shop"),
                      _filterButton("Warehouse"),
                      _filterButton("Missing Fields"),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // ================= INFO CHIP =================
                if (controller.count > 0)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _infoChip("${controller.totalRecords} properties found"),
                      ],
                    ),
                  ),

                const SizedBox(height: 20),

                // ================= LOADING STATE =================
                if (controller.isLoading)
                  const Center(child: CircularProgressIndicator()),

                // ================= EMPTY STATE =================
                if (!controller.isLoading && controller.count == 0)
                  _buildEmptyState(),

                // ================= PROPERTY CARDS =================
                if (!controller.isLoading)
                  ...controller.properties.map((property) {
                    return _buildPropertyCard(property);
                  }).toList(),

                // ================= PAGINATION LOADER =================
                if (controller.isPaginationLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===================== SEARCH BAR =====================
  Widget _buildSearchBar(bool isDark) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: TextField(
        controller: _searchController,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          hintText: 'Search commercial properties...',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search_rounded, color: Colors.grey.shade600),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.close_rounded, color: Colors.grey.shade600),
            onPressed: () {
              _searchController.clear();
              controller.refresh();
            },
          )
              : null,
          filled: true,
          fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade50,
          contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            BorderSide(color: Colors.blueGrey.withOpacity(0.3), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
            BorderSide(color: Colors.blueAccent.withOpacity(0.8), width: 1.5),
          ),
        ),
        onChanged: _onSearchChanged,
      ),
    );
  }

  // ===================== INFO CHIP =====================
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

  // ===================== FILTER BUTTON =====================
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
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

  // ===================== EMPTY STATE =====================
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              "No commercial properties found",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Try a different filter or search term",
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== PROPERTY CARD =====================
  Widget _buildPropertyCard(CommercialPropertyData property) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Build image list
    final List<String> images = _buildImageList(property);

    // Missing fields check
    bool isEmpty(String? value) =>
        value == null || value.trim().isEmpty || value.trim().toLowerCase() == 'n/a';

    final Map<String, String?> fields = {
      'Location': property.location_,
      'Listing Type': property.listing_type,
      'Property Type': property.property_type,
      'Area': property.build_up_area,
      'Price': property.price,
      'Parking': property.parking_faciltiy,
      'Total Floor': property.total_floor,
      'Description': property.Description,
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
                CommercialUnderProperty(property: property),
          ),
        );
        controller.refresh();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: isDark
              ? []
              : [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Column(
          children: [

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ===== IMAGE =====
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: images.isEmpty
                          ? Container(
                        height: 200,
                        width: 140,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.storefront,
                            size: 60, color: Colors.grey),
                      )
                          : CachedNetworkImage(
                        imageUrl: images.first,
                        height: 200,
                        width: 140,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          height: 200,
                          width: 140,
                          color: Colors.grey.shade200,
                          child: const Center(
                              child: CircularProgressIndicator()),
                        ),
                        errorWidget: (_, __, ___) => Container(
                          height: 200,
                          width: 140,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image,
                              size: 50, color: Colors.grey),
                        ),
                      ),
                    ),

                    // Image count badge
                    if (images.length > 1)
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+${images.length - 1}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(width: 14),

                // ===== DETAILS =====
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.location_ ??
                            property.current_location ??
                            "No Title",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if ((property.listing_type ?? '').isNotEmpty)
                        Text("🤝 ${property.listing_type}"),
                      const SizedBox(height: 4),
                      if ((property.property_type ?? '').isNotEmpty)
                        Text("🏢 ${property.property_type}"),
                      const SizedBox(height: 4),
                      if ((property.build_up_area ?? '').isNotEmpty)
                        Text("📐 Area: ${property.build_up_area}"),
                      const SizedBox(height: 4),
                      if ((property.price ?? '').isNotEmpty)
                        Text("💰 ${property.price}"),
                      const SizedBox(height: 4),
                      if ((property.total_floor ?? '').isNotEmpty)
                        Text("🏗 Floors: ${property.total_floor}"),
                      const SizedBox(height: 4),
                      if ((property.parking_faciltiy ?? '').isNotEmpty)
                        Text("🅿 Parking: ${property.parking_faciltiy}"),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ===== FOOTER ROW =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Commercial ID: ${property.id ?? '-'}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                      fontSize: 12),
                ),
                if ((property.avaible_date ?? '').isNotEmpty)
                  Text(
                    "Available: ${property.avaible_date}",
                    style: const TextStyle(
                        fontStyle: FontStyle.italic, fontSize: 12),
                  ),
              ],
            ),

            // ===== MISSING FIELDS =====
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
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.warning_amber_rounded,
                        color: Colors.yellow, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "⚠ Missing: ${missingFields.join(', ')}",
                        style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===================== IMAGE LIST HELPER =====================
  List<String> _buildImageList(CommercialPropertyData p) {
    final List<String> imgs = [];
    if (p.image_ != null && p.image_!.trim().isNotEmpty) {
      imgs.add(p.image_!);
    }
    if (p.images.isNotEmpty) {
      for (final img in p.images) {
        if (!imgs.contains(img)) imgs.add(img);
      }
    }
    return imgs;
  }
}