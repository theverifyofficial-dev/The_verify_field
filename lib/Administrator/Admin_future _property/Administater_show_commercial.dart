import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:verify_feild_worker/Administrator/Admin_future%20_property/Administater_under_commercial.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

import '../../Controller/Commercial_controller.dart';


class Administater_Commercial extends StatefulWidget {
  final String number;
  const Administater_Commercial({super.key, required this.number});

  @override
  State<Administater_Commercial> createState() => Administater_CommercialState();
}

class Administater_CommercialState extends State<Administater_Commercial> {
  late CommercialPropertyController controller;
  late ScrollController _scrollController;
  bool _initialized = false;

  // Search
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadController();
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

  // ===================== LOAD CONTROLLER =====================
  // ✅ Yahan SharedPreferences nahi — number widget se aata hai
  Future<void> _loadController() async {
    controller = CommercialPropertyController(widget.number);
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
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Image.asset(AppImages.transparent, height: 40),
          centerTitle: true,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final screenWidth  = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet     = screenWidth > 600;

    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black,
              iconTheme: const IconThemeData(color: Colors.white),
              title: Image.asset(AppImages.transparent, height: 40),
              centerTitle: true,
            ),
            body: _buildCommercialTab(
              isTablet: isTablet,
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
          ),
        );
      },
    );
  }

  // ===================== MAIN TAB =====================
  Widget _buildCommercialTab({
    required bool isTablet,
    required double screenWidth,
    required double screenHeight,
  }) {
    final theme   = Theme.of(context);
    final cs      = theme.colorScheme;
    final isDark  = theme.brightness == Brightness.dark;
    final topPadding = isTablet ? 24.0 : 16.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(topPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= SEARCH BAR =================
              _buildSearchBar(isDark, isTablet),

              SizedBox(height: isTablet ? 16 : 12),

              // ================= FILTER BUTTONS =================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'All', 'Rent', 'Sell', 'Office',
                    'Retail shop', 'Warehouse', 'Missing Fields',
                  ].map((label) {
                    final isSelected = controller.selectedLabel == label;
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 6 : 4),
                      child: ElevatedButton(
                        onPressed: controller.isLoading
                            ? null
                            : () => controller.applyFilter(label),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          isSelected ? Colors.blue : Colors.grey[300],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: FontWeight.w800,
                            fontSize: isTablet ? 14 : 12,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

              SizedBox(height: isTablet ? 14 : 10),

              // ================= INFO CHIP =================
              if (controller.count > 0)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 16 : 12,
                          vertical: isTablet ? 10 : 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: isDark ? Colors.transparent : Colors.grey,
                            width: 1.5,
                          ),
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle_outline,
                                size: 20, color: Colors.green),
                            SizedBox(width: isTablet ? 8 : 6),
                            Text(
                              "${controller.totalRecords} commercial properties found",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: isTablet ? 16 : 14,
                                color: isDark ? Colors.white : Colors.black,
                              ),
                            ),
                            SizedBox(width: isTablet ? 8 : 6),
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                controller.refresh();
                              },
                              child: Icon(Icons.close,
                                  size: isTablet ? 20 : 18, color: Colors.grey),
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

        // ================= LOADING =================
        if (controller.isLoading)
          const Expanded(
            child: Center(child: CircularProgressIndicator()),
          )

        // ================= EMPTY =================
        else if (controller.count == 0)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off,
                      size: isTablet ? 80 : 60, color: Colors.grey[400]),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    "No commercial properties found",
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: isTablet ? 10 : 8),
                  Text(
                    "Try a different search term",
                    style: TextStyle(
                        fontSize: isTablet ? 16 : 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          )

        // ================= LIST =================
        else
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 16),
              itemCount: controller.properties.length + 1, // +1 for pagination loader
              itemBuilder: (context, index) {

                // ===== PAGINATION LOADER at bottom =====
                if (index == controller.properties.length) {
                  if (controller.isPaginationLoading) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox(height: 20);
                }

                final property    = controller.properties[index];
                final displayIndex = controller.properties.length - index;

                final List<String> images = _buildMultipleImages(property);

                final double cardPadding    = (screenWidth * 0.03).clamp(8.0, 20.0);
                final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
                final double titleFontSize  = isTablet ? 20 : 16;
                final double detailFontSize = isTablet ? 14 : 13;
                final double imageH  = (screenHeight * 0.29).clamp(150.0, 250.0);
                final double multiH  = imageH * 0.8;

                final Widget imageSection = _buildImageSection(
                  images: images,
                  cs: cs,
                  theme: theme,
                  imageHeight: imageH,
                  multiImgHeight: multiH,
                  isTablet: isTablet,
                );

                // Detail rows
                final List<Widget> detailRows = [];
                if ((property.location_ ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.location_on, label: 'Location',
                    value: property.location_!, theme: theme,
                    getIconColor: _getIconColor, fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                detailRows.add(_DetailRow(
                  icon: Icons.handshake_outlined, label: '',
                  value: property.listing_type ?? 'N/A', theme: theme,
                  getIconColor: _getIconColor, fontSize: detailFontSize,
                  fontWeight: FontWeight.bold,
                ));
                detailRows.add(_DetailRow(
                  icon: Icons.apartment, label: '',
                  value: property.property_type ?? 'N/A', theme: theme,
                  getIconColor: _getIconColor, fontSize: detailFontSize,
                  fontWeight: FontWeight.bold,
                ));
                if ((property.build_up_area ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.square_foot, label: 'Area',
                    value: property.build_up_area!, theme: theme,
                    getIconColor: _getIconColor, fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.price ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.attach_money, label: 'Rent',
                    value: property.price!, theme: theme,
                    getIconColor: _getIconColor, fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.total_floor ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.layers, label: 'Floors',
                    value: property.total_floor!, theme: theme,
                    getIconColor: _getIconColor, fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }

                final Widget commercialDetail = _DetailRow(
                  icon: Icons.numbers, label: 'Commercial ID',
                  value: property.id?.toString() ?? 'N/A', theme: theme,
                  getIconColor: _getIconColor, maxLines: 1,
                  fontSize: detailFontSize, fontWeight: FontWeight.bold,
                );

                final Widget leftColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [imageSection],
                );

                final Widget rightColumn = Padding(
                  padding: EdgeInsets.only(top: isTablet ? 24.0 : 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.location_ ?? property.current_location ?? 'No Title',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, fontSize: titleFontSize,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      ...detailRows,
                      const Spacer(),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                            width: double.infinity, child: commercialDetail),
                      ),
                    ],
                  ),
                );

                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            Administater_CommercialUnderProperty(
                              property: property,
                            ),
                      ),
                    ).then((_) => controller.refresh());
                  },
                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin, vertical: 4),
                    elevation: isDark ? 0 : 6,
                    color: theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: theme.dividerColor),
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(cardPadding),
                          child: Column(
                            children: [
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(flex: 2, child: leftColumn),
                                    SizedBox(width: isTablet ? 20 : 16),
                                    Expanded(flex: 3, child: rightColumn),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Count badge
                        Positioned(
                          top: 8, right: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: cs.primary.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '$displayIndex',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  // ===================== SEARCH BAR =====================
  Widget _buildSearchBar(bool isDark, bool isTablet) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.grey[100]!, Colors.grey[50]!],
          ),
        ),
        child: TextField(
          controller: _searchController,
          style: TextStyle(
            color: Colors.black87,
            fontSize: isTablet ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            hintText: 'Search commercial properties...',
            hintStyle: TextStyle(
                color: Colors.grey.shade600, fontSize: isTablet ? 18 : 16),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12),
              child: Icon(Icons.search_rounded,
                  color: Colors.grey.shade700, size: isTablet ? 28 : 24),
            ),
            suffixIcon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _searchController.text.isNotEmpty
                  ? IconButton(
                key: const ValueKey('clear'),
                icon: Icon(Icons.close_rounded,
                    color: Colors.grey.shade700, size: isTablet ? 24 : 22),
                onPressed: () {
                  _searchController.clear();
                  controller.refresh();
                },
              )
                  : const SizedBox(key: ValueKey('empty')),
            ),
            filled: true,
            fillColor: Colors.transparent,
            contentPadding: EdgeInsets.symmetric(
              vertical: isTablet ? 20 : 16,
              horizontal: isTablet ? 20 : 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.blueGrey.withOpacity(0.3), width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                  color: Colors.blueAccent.withOpacity(0.8), width: 1.5),
            ),
          ),
          onChanged: _onSearchChanged,
        ),
      ),
    );
  }

  // ===================== IMAGE SECTION =====================
  Widget _buildImageSection({
    required List<String> images,
    required ColorScheme cs,
    required ThemeData theme,
    required double imageHeight,
    required double multiImgHeight,
    required bool isTablet,
  }) {
    if (images.isEmpty) {
      return Container(
        height: imageHeight,
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.storefront, size: 90, color: Colors.grey),
      );
    }

    if (images.length == 1) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: imageHeight,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: images.first,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator()),
            errorWidget: (_, __, ___) =>
                Icon(Icons.broken_image, color: cs.error, size: 70),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: multiImgHeight,
          child: Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: images[0], fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(
                        child: SizedBox(height: 30, width: 30,
                            child: CircularProgressIndicator(strokeWidth: 2))),
                    errorWidget: (_, __, ___) =>
                        Icon(Icons.broken_image, color: cs.error, size: 50),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: images[1], fit: BoxFit.cover,
                        placeholder: (_, __) => const Center(
                            child: SizedBox(height: 30, width: 30,
                                child: CircularProgressIndicator(strokeWidth: 2))),
                        errorWidget: (_, __, ___) =>
                            Icon(Icons.broken_image, color: cs.error, size: 50),
                      ),
                      if (images.length > 2)
                        Positioned(
                          bottom: 4, right: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text('+${images.length - 2}',
                                style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text('${images.length} ${images.length == 1 ? 'Image' : 'Images'}',
            style: theme.textTheme.bodySmall?.copyWith(
                color: cs.primary, fontWeight: FontWeight.w600)),
      ],
    );
  }

  // ===================== HELPERS =====================
  Color _getIconColor(IconData icon, ThemeData theme) {
    switch (icon) {
      case Icons.location_on:     return Colors.red;
      case Icons.square_foot:     return Colors.orange;
      case Icons.attach_money:    return Colors.green;
      case Icons.apartment:       return Colors.blue;
      case Icons.layers:          return Colors.teal;
      case Icons.numbers:         return Colors.cyan;
      case Icons.handshake_outlined: return Colors.orangeAccent;
      default:                    return theme.colorScheme.primary;
    }
  }

  List<String> _buildMultipleImages(CommercialPropertyData p) {
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

// ===================== DETAIL ROW WIDGET =====================
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color Function(IconData, ThemeData) getIconColor;
  final int maxLines;
  final double? fontSize;
  final FontWeight? fontWeight;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    required this.getIconColor,
    this.maxLines = 1,
    this.fontSize,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: getIconColor(icon, theme)),
          const SizedBox(width: 6),
          Expanded(
            child: RichText(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.2,
                  color: cs.onSurface.withOpacity(0.70),
                  fontSize: fontSize ?? 13,
                ),
                children: [
                  if (label.isNotEmpty)
                    TextSpan(
                      text: '$label: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.8),
                        fontSize: fontSize ?? 13,
                      ),
                    ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: fontWeight ?? FontWeight.normal,
                      color: cs.onSurface.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}