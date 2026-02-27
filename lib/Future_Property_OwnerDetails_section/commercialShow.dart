import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // for XFile
import 'Commercial_detail.dart';

class CommercialListPage extends StatefulWidget {
  const CommercialListPage({super.key,
    this.fieldWorkerNumber = '11'});
  final String fieldWorkerNumber;
  @override
  State<CommercialListPage> createState() => _CommercialListPageState();
}

class _CommercialListPageState extends State<CommercialListPage> {
  List<CommercialPropertyData> _allProperties = [];
  List<CommercialPropertyData> _filteredProperties = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String selectedLabel = '';
  int propertyCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadProperties();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadProperties() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final properties = await CommercialApi.fetch(widget.fieldWorkerNumber);
      setState(() {
        _allProperties = properties;
        _filteredProperties = properties;
        propertyCount = properties.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading commercial properties: $e')),
        );
      }
    }
  }

  Future<void> _refreshProperties() async {
    await _loadProperties();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();

      List<CommercialPropertyData> searchOn =
      selectedLabel.isEmpty ? _allProperties : _filteredProperties;

      List<CommercialPropertyData> filtered;

      if (query.isEmpty) {
        filtered = List.from(searchOn);
      } else {
        filtered = searchOn.where((item) {
          return
            (item.listing_type ?? '').toLowerCase().contains(query) ||
                (item.location_ ?? '').toLowerCase().contains(query) ||
                (item.current_location ?? '').toLowerCase().contains(query) ||
                (item.property_type ?? '').toLowerCase().contains(query) ||
                (item.build_up_area ?? '').toLowerCase().contains(query) ||
                (item.carpet_area ?? '').toLowerCase().contains(query) ||
                (item.price ?? '').toLowerCase().contains(query) ||
                (item.total_floor ?? '').toLowerCase().contains(query) ||
                (item.parking_faciltiy ?? '').toLowerCase().contains(query) ||
                (item.amenites_.join(', ').toLowerCase().contains(query)) ||
                (item.field_workar_name ?? '').toLowerCase().contains(query) ||
                (item.field_workar_number ?? '').toLowerCase().contains(
                    query) ||
                (item.Description ?? '').toLowerCase().contains(query) ||
                (item.width_ ?? '').toLowerCase().contains(query) ||
                (item.height_ ?? '').toLowerCase().contains(query);
        }).toList();
      }

      setState(() {
        _filteredProperties = filtered;
        propertyCount = filtered.length;
      });
    });
  }


  Color _getIconColor(IconData icon, ThemeData theme) {
    final cs = theme.colorScheme;
    switch (icon) {
      case Icons.location_on:
        return Colors.red;
      case Icons.square_foot:
        return Colors.orange;
      case Icons.attach_money:
        return Colors.green;
      case Icons.apartment:
        return Colors.blue;
      case Icons.layers:
        return Colors.teal;
      case Icons.numbers:
        return Colors.cyan;
      case Icons.handshake_outlined:
        return Colors.orangeAccent;
      default:
        return cs.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final isTablet = screenWidth > 600;
    return RefreshIndicator(
      onRefresh: _refreshProperties,
      child: Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildCommercialTab(isTablet: isTablet,
            screenWidth: screenWidth,
            screenHeight: screenHeight),
      ),
    );
  }

  // Commercial tab ke liye UI (matched to buildings tab structure)
  Widget _buildCommercialTab({
    required bool isTablet,
    required double screenWidth,
    required double screenHeight,
  }) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final topPadding = isTablet ? 24.0 : 16.0;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(topPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search commercial properties...',
                      hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: isTablet ? 18 : 16
                      ),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                            Icons.search_rounded,
                            color: Colors.grey.shade700,
                            size: isTablet ? 28 : 24
                        ),
                      ),
                      suffixIcon: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _searchController.text.isNotEmpty
                            ? IconButton(
                          key: const ValueKey('clear'),
                          icon: Icon(
                              Icons.close_rounded,
                              color: Colors.grey.shade700,
                              size: isTablet ? 24 : 22
                          ),
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
                            color: Colors.blueGrey.withOpacity(0.3),
                            width: 1
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.blueAccent.withOpacity(0.8),
                            width: 1.5
                        ),
                      ),
                    ),
                    onChanged: (_) {}, // Listener handles debounced search
                  ),
                ),
              ),

              SizedBox(height: isTablet ? 16 : 12),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    'All',
                    'Rent',
                    'Sell',
                    'Office',
                    'Retail shop',
                    'Warehouse',
                    'Plot',
                  ]
                      .map((label) {
                    final isSelected = label == selectedLabel;
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: isTablet
                          ? 6
                          : 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedLabel = label;
                          });

                          _searchController.clear();
                          _debounce?.cancel();

                          List<CommercialPropertyData> filtered = [];

                          if (label == 'All') {
                            filtered = List.from(_allProperties);
                          } else if (label == 'Rent' || label == 'Sell') {
                            filtered = _allProperties.where((item) {
                              final value = (item.listing_type ?? '')
                                  .toLowerCase();
                              return value == label.toLowerCase();
                            }).toList();
                          } else {
                            filtered = _allProperties.where((item) {
                              final value = (item.property_type ?? '')
                                  .toLowerCase();
                              return value == label.toLowerCase();
                            }).toList();
                          }

                          setState(() {
                            _filteredProperties = filtered;
                            propertyCount = filtered.length;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSelected ? Colors.blue : Colors
                              .grey[300],
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

              if (propertyCount > 0)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: isTablet ? 16 : 12,
                            vertical: isTablet ? 10 : 8
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: isDark ? Colors.transparent : Colors.grey,
                              width: 1.5
                          ),
                          color: isDark ? Colors.grey[800] : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20,
                                color: Colors.green),
                            SizedBox(width: isTablet ? 8 : 6),
                            Text(
                              "$propertyCount commercial properties found",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: isTablet ? 16 : 14,
                                  color: isDark ? Colors.white : Colors.black),
                            ),
                            SizedBox(width: isTablet ? 8 : 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  selectedLabel = '';
                                  _filteredProperties = _allProperties;
                                  propertyCount = _allProperties.length;
                                });
                              },
                              child: Icon(
                                  Icons.close,
                                  size: isTablet ? 20 : 18,
                                  color: Colors.grey
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: isTablet ? 8 : 6),
                    ],
                  ),
                ),

            ],
          ),
        ),
        if (_filteredProperties.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      Icons.search_off,
                      size: isTablet ? 80 : 60,
                      color: Colors.grey[400]
                  ),
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
                      fontSize: isTablet ? 16 : 14,
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
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16),
              itemCount: _filteredProperties.length,
              itemBuilder: (context, index) {
                final property = _filteredProperties[index];
                final displayIndex = _filteredProperties.length - index;
                final theme = Theme.of(context);
                final cs = theme.colorScheme;
                final isDark = theme.brightness == Brightness.dark;
                final screenHeight = MediaQuery
                    .of(context)
                    .size
                    .height;
                final screenWidth = MediaQuery
                    .of(context)
                    .size
                    .width;

                final List<String> images = _buildMultipleImages(property);

                final double cardPadding = (screenWidth * 0.03).clamp(
                    8.0, 20.0);
                final double horizontalMargin = (screenWidth * 0.0).clamp(
                    0.5, 0.8);
                final double titleFontSize = isTablet ? 20 : 16;
                final double detailFontSize = isTablet ? 14 : 13;
                final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
                final double multiH = imageH * 0.8;

                final Widget commercialDetail = _DetailRow(
                  icon: Icons.numbers,
                  label: 'Commercial ID',
                  value: property.id?.toString() ?? 'N/A',
                  theme: theme,
                  getIconColor: _getIconColor,
                  maxLines: 1,
                  fontSize: detailFontSize,
                  fontWeight: FontWeight.bold,
                );

                final Widget imageSection = _buildImageSection(
                  images: images,
                  cs: cs,
                  theme: theme,
                  imageHeight: imageH,
                  multiImgHeight: multiH,
                  isTablet: isTablet,
                );

                // Priority detail rows: location, listing type, property type, area, rent, floors
                final List<Widget> detailRows = [];
                if ((property.location_ ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.location_on,
                    label: 'Location',
                    value: property.location_!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                detailRows.add(_DetailRow(
                  icon: Icons.handshake_outlined,
                  label: '',
                  value: property.listing_type ?? 'N/A',
                  theme: theme,
                  getIconColor: _getIconColor,
                  fontSize: detailFontSize,
                  fontWeight: FontWeight.bold,
                ));
                detailRows.add(_DetailRow(
                  icon: Icons.apartment,
                  label: '',
                  value: property.property_type ?? 'N/A',
                  theme: theme,
                  getIconColor: _getIconColor,
                  fontSize: detailFontSize,
                  fontWeight: FontWeight.bold,
                ));
                if ((property.build_up_area ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.square_foot,
                    label: 'Area',
                    value: property.build_up_area!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.price ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.attach_money,
                    label: 'Rent',
                    value: property.price!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.total_floor ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.layers,
                    label: 'Floors',
                    value: property.total_floor!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }

                final Widget leftColumn = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    imageSection,
                  ],
                );

                final Widget rightColumn = Padding(
                  padding: EdgeInsets.only(top: isTablet ? 24.0 : 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.location_ ?? property.current_location ??
                            'No Title',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isTablet ? 16 : 12),
                      // Render detail rows
                      ...detailRows,
                      const Spacer(),
                      // Shift Commercial ID to the right
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: double.infinity,
                          child: commercialDetail,
                        ),
                      ),
                    ],
                  ),
                );

                return GestureDetector(
                  onTap: () {
                    final imagesList = _buildMultipleImages(property);

                    final data = CommercialPropertyData(
                      listing_type: property.listing_type,
                      property_type: property.property_type,
                      parking_faciltiy: property.parking_faciltiy,
                      total_floor: property.total_floor,
                      location_: property.location_ ?? '',
                      current_location: property.current_location ?? '',
                      avaible_date: property.avaible_date ?? '',
                      build_up_area: property.build_up_area ?? '',
                      carpet_area: property.carpet_area ?? '',
                      dimmensions_: property.dimmensions_ ?? '',
                      height_: property.height_ ?? '',
                      width_: property.width_ ?? '',
                      price: property.price ?? '',
                      Description: property.Description ?? '',

                      field_workar_name: property.field_workar_name ?? '',
                      field_workar_number: property.field_workar_number ?? '',

                      /// ✅ SAFE AMENITIES FIX
                      amenites_: property.amenites_,

                      /// ✅ IMAGE FIX
                      image_: imagesList.isNotEmpty ? imagesList.first : null,
                      images: imagesList,
                      id: 0,
                      latitude: '',
                      longitude: '',
                    );

                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            CommercialUnderProperty(property: property,

                            ),
                      ),
                    );
                  },

                  child: Card(
                    margin: EdgeInsets.symmetric(
                        horizontal: horizontalMargin,
                        vertical: 4
                    ),
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
                                    Expanded(
                                      flex: isTablet ? 2 : 2,
                                      child: leftColumn,
                                    ),
                                    SizedBox(width: isTablet ? 20 : 16),
                                    Expanded(
                                      flex: isTablet ? 3 : 3,
                                      child: rightColumn,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Top right count number badge
                        Positioned(
                          top: 8,
                          right: 8,
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

  Widget _buildImageSection({
    required List<String> images,
    required ColorScheme cs,
    required ThemeData theme,
    required double imageHeight,
    required double multiImgHeight,
    required bool isTablet,
  }) {
    Widget imageWidget;
    if (images.isEmpty) {
      imageWidget = Container(
        height: imageHeight,
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.storefront,
          size: 90,
          color: Colors.grey,
        ),
      );
    } else if (images.length == 1) {
      imageWidget = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
            height: imageHeight,
            width: double.infinity,
            child:
            CachedNetworkImage(
              imageUrl: images.first,
              fit: BoxFit.cover,
              placeholder: (_, __) =>
              const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (_, __, ___) =>
                  Icon(Icons.broken_image, color: cs.error, size: 70),
            )

        ),
      );
    } else {
      imageWidget = Column(
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
                      imageUrl: images[0],
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                      const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (_, __, ___) =>
                          Icon(Icons.broken_image, color: cs.error, size: 50),
                    ),
                  ),
                ),
                if (images.length > 1) ...[
                  const SizedBox(width: 4),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            imageUrl: images[1],
                            fit: BoxFit.cover,
                            placeholder: (_, __) =>
                            const Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) =>
                                Icon(Icons.broken_image, color: cs.error,
                                    size: 50),
                          ),
                          if (images.length > 2)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  '+${images.length - 2}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${images.length} ${images.length == 1 ? 'Image' : 'Images'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: cs.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      );
    }

    return Stack(
      children: [
        imageWidget,
        // No live badge for commercial
      ],
    );
  }

  // Fallback logic: use single image
  List<String> _buildMultipleImages(CommercialPropertyData p) {
    final List<String> imgs = [];

    if (p.image_ != null && p.image_!.trim().isNotEmpty) {
      imgs.add(p.image_!);
    }

    if (p.images.isNotEmpty) {
      imgs.addAll(p.images);
    }

    return imgs;
  }
}


  class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color Function(IconData, ThemeData) getIconColor;
  final int maxLines;
  final double? fontSize; // Added for responsive font sizing
  final FontWeight? fontWeight; // Optional for value highlighting

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
      padding: const EdgeInsets.only(bottom: 10.0), // Increased bottom padding for more space between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: getIconColor(icon, theme),
          ),
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
                      fontWeight: fontWeight ?? FontWeight.normal, // Apply fontWeight if provided
                      color: cs.onSurface.withOpacity(0.9), // Slightly darker for value
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
class CommercialApi {
  static Uri endpoint(String fieldWorkerNumber) {
    final base = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_api_commercial_property.php';
    return Uri.parse(base).replace(
      queryParameters: {'field_workar_number': fieldWorkerNumber},
    );
  }

  static Future<List<CommercialPropertyData>> fetch(
      String fieldWorkerNumber, {
        Duration timeout = const Duration(seconds: 30),
      }) async {
    final uri = endpoint(fieldWorkerNumber);
    final response = await http.get(uri, headers: {'accept': 'application/json'}).timeout(timeout);

    if (response.statusCode != 200) {
      final preview = response.body.length > 200
          ? '${response.body.substring(0, 200)}...'
          : response.body;
      throw HttpException(
        'HTTP ${response.statusCode}: ${response.reasonPhrase}\n$preview',
        uri: uri,
      );
    }

    final decoded = json.decode(response.body);
    if (decoded is Map && decoded['success'] == true && decoded['data'] is List) {
      final List list = decoded['data'];
      return list
          .map((e) => CommercialPropertyData.fromJson(e as Map<String, dynamic>))
          .toList()
          .reversed
          .toList();
    }
    return [];
  }
}

class HttpException implements Exception {
  final String message;
  final Uri? uri;
  HttpException(this.message, {this.uri});
  @override
  String toString() => message;
}