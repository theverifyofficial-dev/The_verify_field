// PlotListPage (Responsive: Matched building tab UI exactly - search bar, filter buttons (All, Sale, Rent, Open), stats row (plot count only), cards with images (no live badge), title (mainAddress), detail rows (Location, Plot Size, Price, Status, Address) using _DetailRow with bold values, Plot ID at bottom right, count no badge, missing fields; dynamic sizing via MediaQuery/clamp; left column: image only (no total), right: title + details; ensured no overflow)
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Plot_detail.dart';


class PlotListPage extends StatefulWidget {
  const PlotListPage({super.key, this.fieldworkerNumber = '11'});
  final String fieldworkerNumber;
  @override
  State<PlotListPage> createState() => _PlotListPageState();
}

class _PlotListPageState extends State<PlotListPage> {
  List<PlotPropertyData> _allPlots = [];
  List<PlotPropertyData> _filteredPlots = [];
  bool _isLoading = true;
  TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String selectedLabel = '';
  int propertyCount = 0;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadPlots();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadPlots() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final plots = await PlotPropertyApi.fetchForFieldworker(
          widget.fieldworkerNumber);
      setState(() {
        _allPlots = plots;
        _filteredPlots = plots;
        propertyCount = plots.length;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading plots: $e')),
        );
      }
    }
  }

  Future<void> _refreshData() async {
    await _loadPlots();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      String query = _searchController.text.toLowerCase().trim();
      List<PlotPropertyData> searchOn = selectedLabel.isEmpty
          ? _allPlots
          : _filteredPlots;
      List<PlotPropertyData> filtered;
      if (query.isEmpty) {
        filtered = List.from(searchOn);
      } else {
        filtered = searchOn.where((item) {
          return (item.id?.toString() ?? '').toLowerCase().contains(query) ||
              (item.plotStatus ?? '').toLowerCase().contains(query) ||
              (item.mainAddress ?? '').toLowerCase().contains(query) ||
              (item.currentLocation ?? '').toLowerCase().contains(query) ||
              (item.plotSize ?? '').toLowerCase().contains(query) ||
              (item.plotPrice ?? '').toLowerCase().contains(query) ||
              (item.fieldAddress ?? '').toLowerCase().contains(query) ||
              (item.roadSize ?? '').toLowerCase().contains(query) ||
              (item.propertyRent ?? '').toLowerCase().contains(query) ||
              (item.fieldworkarName ?? '').toLowerCase().contains(query) ||
              (item.fieldworkarNumber ?? '').toLowerCase().contains(query);
        }).toList();
      }
      setState(() {
        _filteredPlots = filtered;
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
      case Icons.info:
        return Colors.indigo;
      case Icons.home:
        return Colors.brown;
      case Icons.badge:
        return Colors.cyan;
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
      onRefresh: _refreshData,
      child: Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildPlotsTab(isTablet: isTablet,
            screenWidth: screenWidth,
            screenHeight: screenHeight),
      ),
    );
  }

  // Plots tab ke liye UI (matched to buildings tab structure)
  Widget _buildPlotsTab({
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
                      hintText: 'Search plots...',
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
                            _filteredPlots = _allPlots;
                            propertyCount = _allPlots.length;
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
                    'Sale',
                    'Rent',
                    'Open',
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

                          List<PlotPropertyData> filtered = [];

                          if (label == 'All') {
                            filtered = List.from(_allPlots);
                          } else if (label == 'Sale' || label == 'Rent') {
                            filtered = _allPlots.where((item) {
                              final status = (item.plotStatus ?? '')
                                  .toLowerCase();
                              final rent = (item.propertyRent ?? '')
                                  .toLowerCase();
                              return status.contains(label.toLowerCase()) ||
                                  rent.contains(label.toLowerCase());
                            }).toList();
                          } else if (label == 'Open') {
                            filtered = _allPlots.where((item) {
                              final open = (item.plotOpen ?? '').toLowerCase();
                              return open.contains('open');
                            }).toList();
                          }

                          setState(() {
                            _filteredPlots = filtered;
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Icon(Icons.check_circle_outline, size: 20,
                                color: Colors.green),
                            SizedBox(width: isTablet ? 8 : 6),
                            Text(
                              "$propertyCount plots found",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: isTablet ? 16 : 14,
                                  color: Colors.black),
                            ),
                            SizedBox(width: isTablet ? 8 : 6),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _searchController.clear();
                                  selectedLabel = '';
                                  _filteredPlots = _allPlots;
                                  propertyCount = _allPlots.length;
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
        if (_filteredPlots.isEmpty)
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
                    "No plots found",
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
              itemCount: _filteredPlots.length,
              itemBuilder: (context, index) {
                final property = _filteredPlots[index];
                final displayIndex = _filteredPlots.length - index;
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
                final isSmallScreen = screenWidth < 400;

                final images = _buildMultipleImages(property);

                final double cardPadding = (screenWidth * 0.03).clamp(
                    8.0, 20.0);
                final double horizontalMargin = (screenWidth * 0.0).clamp(
                    0.5, 0.8);
                final double titleFontSize = isTablet ? 20 : 16;
                final double detailFontSize = isTablet ? 14 : 13;
                final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
                final double multiH = imageH * 0.8;

                // Calculate missing fields
                bool _isNullOrEmpty(String? value) =>
                    value == null || value
                        .trim()
                        .isEmpty;

                final Map<String, dynamic> fields = {
                  "Plot Size": property.plotSize,
                  "Plot Front Size": property.plotFrontSize,
                  "Plot Side Size": property.plotSideSize,
                  "Road Size": property.roadSize,
                  "Plot Open": property.plotOpen,
                  "Age of Property": property.ageOfProperty,
                  "Water Connection": property.waterConnection,
                  "Electric Price": property.electricPrice,
                  "Plot Price": property.plotPrice,
                  "Plot Status": property.plotStatus,
                  "Property Chain": property.propertyChain,
                  "Field Address": property.fieldAddress,
                  "Main Address": property.mainAddress,
                  "Current Location": property.currentLocation,
                  "Longitude": property.longitude,
                  "Latitude": property.latitude,
                  "Fieldworker Name": property.fieldworkarName,
                  "Fieldworker Number": property.fieldworkarNumber,
                  "Property Rent": property.propertyRent,
                };

                final missingFields = fields.entries
                    .where((entry) {
                  final value = entry.value;
                  if (value == null) return true;
                  if (value is String && value
                      .trim()
                      .isEmpty) return true;
                  return false;
                })
                    .map((entry) => entry.key)
                    .toList();

                final hasMissingFields = missingFields.isNotEmpty;

                final Widget plotDetail = _DetailRow(
                  icon: Icons.badge,
                  label: 'Plot ID',
                  value: property.id.toString() ?? 'N/A',
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

                // Priority detail rows: location, plot size, price, status, address (no buy/rent/residence/age/date for plots)
                final List<Widget> detailRows = [];
                if ((property.currentLocation ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.location_on,
                    label: 'Location',
                    value: property.currentLocation!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.plotSize ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.square_foot,
                    label: 'Plot Size',
                    value: property.plotSize!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.plotPrice ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.attach_money,
                    label: 'Price',
                    value: property.plotPrice!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.plotStatus ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.info,
                    label: 'Status',
                    value: property.plotStatus!,
                    theme: theme,
                    getIconColor: _getIconColor,
                    fontSize: detailFontSize,
                    fontWeight: FontWeight.bold,
                  ));
                }
                if ((property.fieldAddress ?? '').isNotEmpty) {
                  detailRows.add(_DetailRow(
                    icon: Icons.home,
                    label: 'Address',
                    value: property.fieldAddress!,
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
                    // No total flats for plots, so empty space or omit
                  ],
                );

                final Widget rightColumn = Padding(
                  padding: EdgeInsets.only(top: isTablet ? 24.0 : 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        property.mainAddress ?? property.fieldAddress ??
                            property.currentLocation ?? 'No Title',
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
                      // Shift Plot ID to the right
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          width: double.infinity,
                          child: plotDetail,
                        ),
                      ),
                    ],
                  ),
                );

                return GestureDetector(
                  onTap: () {
                    final data = PlotPropertyData(
                      id: property.id,
                      plotSize: property.plotSize,
                      plotPrice: property.plotPrice,
                      fieldAddress: property.fieldAddress,
                      mainAddress: property.mainAddress,
                      plotFrontSize: property.plotFrontSize,
                      plotSideSize: property.plotSideSize,
                      roadSize: property.roadSize,
                      plotOpen: property.plotOpen,
                      ageOfProperty: property.ageOfProperty,
                      waterConnection: property.waterConnection,
                      electricPrice: property.electricPrice,
                      plotStatus: property.plotStatus,
                      propertyChain: property.propertyChain,
                      currentLocation: property.currentLocation,
                      longitude: property.longitude,
                      latitude: property.latitude,
                      fieldworkarNumber: property.fieldworkarNumber,
                      fieldworkarName: property.fieldworkarName,
                      propertyRent: property.propertyRent,
                      singleImageUrl: property.singleImageUrl,
                      imageUrls: property.imageUrls,
                      Description: property.Description,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            PlotPropertyDisplayPage(propertyData: data),
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
                              if (hasMissingFields)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.all(isTablet ? 8 : 6),
                                    decoration: BoxDecoration(
                                      color: cs.errorContainer,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: cs.error),
                                    ),
                                    child: Text(
                                      "⚠ Missing: ${missingFields.join(', ')}",
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                        color: cs.error,
                                        fontWeight: FontWeight.w600,
                                        fontSize: detailFontSize,
                                      ),
                                      maxLines: 5,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
          Icons.landscape,
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
          child: CachedNetworkImage(
            imageUrl: images.first,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
            const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            errorWidget: (_, __, ___) =>
                Icon(Icons.broken_image, color: cs.error, size: 90),
          ),
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
        // No live badge for plots
      ],
    );
  }

  // Fallback logic: use `images` array if API provides; else fallback to single_image
  List<String> _buildMultipleImages(PlotPropertyData p) {
    final List<String> imgs = [];

    // ✅ Add single image first
    if (p.singleImageUrl != null &&
        p.singleImageUrl!.isNotEmpty) {
      imgs.add(p.singleImageUrl!);
    }

    // ✅ Add multiple images
    if (p.imageUrls.isNotEmpty) {
      imgs.addAll(p.imageUrls);
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


class PlotPropertyApi {
  static Uri endpointForFieldworker(String fieldworkerNumber) {
    final base =
        'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/plot_form_show_api_for_feildworkar.php';
    return Uri.parse(base).replace(
      queryParameters: {'fieldworkar_number': fieldworkerNumber},
    );
  }

  static Future<List<PlotPropertyData>> fetchForFieldworker(
      String fieldworkerNumber, {
        Duration timeout = const Duration(seconds: 30),
      }) async {
    final uri = endpointForFieldworker(fieldworkerNumber);
    final response =
    await http.get(uri, headers: {'accept': 'application/json'}).timeout(timeout);
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
          .map((e) => PlotPropertyData.fromJson(e as Map<String, dynamic>))
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

/// NOTE: ThemeSwitcher is provided from your MyApp (InheritedWidget).
class ThemeSwitcher extends InheritedWidget {
  final ThemeMode themeMode;
  final VoidCallback toggleTheme;
  const ThemeSwitcher({
    required this.themeMode,
    required this.toggleTheme,
    required Widget child,
    super.key,
  }) : super(child: child);

  static ThemeSwitcher? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>();

  @override
  bool updateShouldNotify(covariant ThemeSwitcher oldWidget) =>
      oldWidget.themeMode != themeMode;
}