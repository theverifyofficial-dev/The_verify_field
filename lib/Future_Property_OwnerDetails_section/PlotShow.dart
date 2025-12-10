// PlotListPage (Responsive: Matched building tab UI exactly - search bar, filter buttons (All, Sale, Rent, Open), stats row (plot count only), cards with images (no live badge), title (mainAddress), detail rows (Location, Plot Size, Price, Status, Address) using _DetailRow with bold values, Plot ID at bottom right, count no badge, missing fields; dynamic sizing via MediaQuery/clamp; left column: image only (no total), right: title + details; ensured no overflow)
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; // for XFile
import 'package:intl/intl.dart'; // If needed for future dates

class PlotListPage extends StatefulWidget {
  const PlotListPage({super.key, this.fieldworkerNumber = '11'});
  final String fieldworkerNumber;
  @override
  State<PlotListPage> createState() => _PlotListPageState();
}

class _PlotListPageState extends State<PlotListPage> {
  List<PlotProperty> _allPlots = [];
  List<PlotProperty> _filteredPlots = [];
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
      final plots = await PlotPropertyApi.fetchForFieldworker(widget.fieldworkerNumber);
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
      List<PlotProperty> searchOn = selectedLabel.isEmpty ? _allPlots : _filteredPlots;
      List<PlotProperty> filtered;
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
              (item.fieldworkerName ?? '').toLowerCase().contains(query) ||
              (item.fieldworkerNumber ?? '').toLowerCase().contains(query);
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
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: Scaffold(
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _buildPlotsTab(isTablet: isTablet, screenWidth: screenWidth, screenHeight: screenHeight),
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
                      padding: EdgeInsets.symmetric(horizontal: isTablet ? 6 : 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedLabel = label;
                          });

                          _searchController.clear();
                          _debounce?.cancel();

                          List<PlotProperty> filtered = [];

                          if (label == 'All') {
                            filtered = List.from(_allPlots);
                          } else if (label == 'Sale' || label == 'Rent') {
                            filtered = _allPlots.where((item) {
                              final status = (item.plotStatus ?? '').toLowerCase();
                              final rent = (item.propertyRent ?? '').toLowerCase();
                              return status.contains(label.toLowerCase()) || rent.contains(label.toLowerCase());
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
                final screenHeight = MediaQuery.of(context).size.height;
                final screenWidth = MediaQuery.of(context).size.width;
                final isSmallScreen = screenWidth < 400;

                final images = _buildMultipleImages(property);

                final double cardPadding = (screenWidth * 0.03).clamp(8.0, 20.0);
                final double horizontalMargin = (screenWidth * 0.0).clamp(0.5, 0.8);
                final double titleFontSize = isTablet ? 20 : 16;
                final double detailFontSize = isTablet ? 14 : 13;
                final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
                final double multiH = imageH * 0.8;

                // Calculate missing fields
                bool _isNullOrEmpty(String? value) => value == null || value.trim().isEmpty;

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
                  "Fieldworker Name": property.fieldworkerName,
                  "Fieldworker Number": property.fieldworkerNumber,
                  "Property Rent": property.propertyRent,
                };

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

                final Widget plotDetail = _DetailRow(
                  icon: Icons.badge,
                  label: 'Plot ID',
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
                        property.mainAddress ?? property.fieldAddress ?? property.currentLocation ?? 'No Title',
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
                      id: property.id ?? 0,
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
                      fieldworkerName: property.fieldworkerName,
                      fieldworkerNumber: property.fieldworkerNumber,
                      propertyRent: property.propertyRent,
                      singleImage: images.isNotEmpty ? images.first : null,
                      selectedImages: images,
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlotPropertyDisplayPage(propertyData: data),
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
                                      style: theme.textTheme.bodySmall?.copyWith(
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
    required List<XFile> images,
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
            imageUrl: images.first.path,
            fit: BoxFit.cover,
            placeholder: (_, __) => const Center(
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
                      imageUrl: images[0].path,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => const Center(
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
                            imageUrl: images[1].path,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                            ),
                            errorWidget: (_, __, ___) =>
                                Icon(Icons.broken_image, color: cs.error, size: 50),
                          ),
                          if (images.length > 2)
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
  List<XFile> _buildMultipleImages(PlotProperty p) {
    final List<XFile> imgs = [];
    final baseUri =
    Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/');
    if (p.multipleImages != null && p.multipleImages!.isNotEmpty) {
      imgs.addAll(
        p.multipleImages!.map((name) {
          if (name.startsWith('http')) return XFile(name);
          return XFile(baseUri.resolve(name).toString());
        }),
      );
    }
    final single = p.imageUrl();
    if (single != null && imgs.isEmpty) {
      imgs.add(XFile(single));
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

/// ----------------- MODEL & API (unchanged, minor style cleanups) -----------------
class PlotProperty {
  final int? id;
  final String? plotSize;
  final String? plotFrontSize;
  final String? plotSideSize;
  final String? roadSize;
  final String? plotOpen;
  final String? ageOfProperty;
  final String? waterConnection;
  final String? electricPrice;
  final String? plotPrice;
  final String? plotStatus;
  final String? singleImage;
  final List<String>? multipleImages;
  final String? propertyChain;
  final String? fieldAddress;
  final String? mainAddress;
  final String? currentLocation;
  final String? longitude;
  final String? latitude;
  final String? fieldworkerName;
  final String? fieldworkerNumber;
  final String? propertyRent;

  PlotProperty({
    this.id,
    this.plotSize,
    this.plotFrontSize,
    this.plotSideSize,
    this.roadSize,
    this.plotOpen,
    this.ageOfProperty,
    this.waterConnection,
    this.electricPrice,
    this.plotPrice,
    this.plotStatus,
    this.singleImage,
    this.multipleImages,
    this.propertyChain,
    this.fieldAddress,
    this.mainAddress,
    this.currentLocation,
    this.longitude,
    this.latitude,
    this.fieldworkerName,
    this.fieldworkerNumber,
    this.propertyRent,
  });

  factory PlotProperty.fromJson(Map<String, dynamic> json) => PlotProperty(
    id: _toInt(json['id']),
    plotSize: json['plot_size'] as String?,
    plotFrontSize: json['plot_front_size'] as String?,
    plotSideSize: json['plot_side_size'] as String?,
    roadSize: json['road_size'] as String?,
    plotOpen: json['plot_open'] as String?,
    ageOfProperty: json['age_of_property'] as String?,
    waterConnection: json['water_connection'] as String?,
    electricPrice: json['electric_price'] as String?,
    plotPrice: json['plot_price'] as String?,
    plotStatus: json['plot_status'] as String?,
    singleImage: json['single_image'] as String?,
    multipleImages: (json['images'] is List)
        ? (json['images'] as List<dynamic>).map((e) => e.toString()).toList()
        : null,
    propertyChain: json['property_chain'] as String?,
    fieldAddress: json['field_address'] as String?,
    mainAddress: json['main_address'] as String?,
    currentLocation: json['current_location'] as String?,
    longitude: json['longitude'] as String?,
    latitude: json['latitude'] as String?,
    fieldworkerName: json['fieldworkar_name'] as String?,
    fieldworkerNumber: json['fieldworkar_number'] as String?,
    propertyRent: json['property_rent'] as String?,
  );

  static int? _toInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    return int.tryParse(v.toString());
  }

  String? imageUrl({String? baseUrl}) {
    if (singleImage == null || singleImage!.isEmpty) return null;
    if (singleImage!.startsWith('http')) return singleImage;
    final base =
        baseUrl ?? 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/';
    return Uri.parse(base).resolve(singleImage!).toString();
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

  static Future<List<PlotProperty>> fetchForFieldworker(
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
          .map((e) => PlotProperty.fromJson(e as Map<String, dynamic>))
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

/// Data class for passing property details to display page
class PlotPropertyData {
  final int id;
  final String? plotSize;
  final String? plotPrice;
  final String? fieldAddress;
  final String? mainAddress;
  final String? plotFrontSize;
  final String? plotSideSize;
  final String? roadSize;
  final String? plotOpen;
  final String? ageOfProperty;
  final String? waterConnection;
  final String? electricPrice;
  final String? plotStatus;
  final String? propertyChain;
  final String? currentLocation;
  final String? longitude;
  final String? latitude;
  final String? fieldworkerName;
  final String? fieldworkerNumber;
  final String? propertyRent;
  final XFile? singleImage;
  final List<XFile>? selectedImages;

  const PlotPropertyData({
    required this.id,
    this.plotSize,
    this.plotPrice,
    this.fieldAddress,
    this.mainAddress,
    this.plotFrontSize,
    this.plotSideSize,
    this.roadSize,
    this.plotOpen,
    this.ageOfProperty,
    this.waterConnection,
    this.electricPrice,
    this.plotStatus,
    this.propertyChain,
    this.currentLocation,
    this.longitude,
    this.latitude,
    this.fieldworkerName,
    this.fieldworkerNumber,
    this.propertyRent,
    this.singleImage,
    this.selectedImages,
  });
}

/// Detail display page
class PlotPropertyDisplayPage extends StatelessWidget {
  final PlotPropertyData propertyData;
  const PlotPropertyDisplayPage({super.key, required this.propertyData});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(propertyData.mainAddress ?? 'Plot Details'),
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Images section
            if (propertyData.selectedImages != null && propertyData.selectedImages!.isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: propertyData.selectedImages!.length,
                  itemBuilder: (context, imgIndex) {
                    final img = propertyData.selectedImages![imgIndex];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: SizedBox(
                          width: 200,
                          child: CachedNetworkImage(
                            imageUrl: img.path,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            else if (propertyData.singleImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: propertyData.singleImage!.path,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            // Details
            _DetailRow(
              icon: Icons.badge,
              label: 'Plot ID',
              value: propertyData.id.toString(),
              theme: theme,
              getIconColor: (icon, theme) => cs.primary,
            ),
            if (propertyData.mainAddress != null)
              _DetailRow(
                icon: Icons.home,
                label: 'Main Address',
                value: propertyData.mainAddress!,
                theme: theme,
                getIconColor: (icon, theme) => Colors.brown,
              ),
            if (propertyData.currentLocation != null)
              _DetailRow(
                icon: Icons.location_on,
                label: 'Current Location',
                value: propertyData.currentLocation!,
                theme: theme,
                getIconColor: (icon, theme) => Colors.blue,
              ),
            if (propertyData.plotSize != null)
              _DetailRow(
                icon: Icons.square_foot,
                label: 'Plot Size',
                value: propertyData.plotSize!,
                theme: theme,
                getIconColor: (icon, theme) => Colors.orange,
              ),
            if (propertyData.plotPrice != null)
              _DetailRow(
                icon: Icons.attach_money,
                label: 'Price',
                value: propertyData.plotPrice!,
                theme: theme,
                getIconColor: (icon, theme) => Colors.green,
              ),
            if (propertyData.plotStatus != null)
              _DetailRow(
                icon: Icons.info,
                label: 'Status',
                value: propertyData.plotStatus!,
                theme: theme,
                getIconColor: (icon, theme) => cs.primary,
              ),
            if (propertyData.fieldAddress != null)
              _DetailRow(
                icon: Icons.directions,
                label: 'Field Address',
                value: propertyData.fieldAddress!,
                theme: theme,
                getIconColor: (icon, theme) => Colors.indigo,
              ),
            if (propertyData.propertyRent != null)
              _DetailRow(
                icon: Icons.home,
                label: 'Rent',
                value: propertyData.propertyRent!,
                theme: theme,
                getIconColor: (icon, theme) => Colors.brown,
              ),
            const SizedBox(height: 16),
            // Additional fields
            Text(
              'Additional Details:',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (propertyData.plotFrontSize != null) Text('Front Size: ${propertyData.plotFrontSize}'),
            if (propertyData.plotSideSize != null) Text('Side Size: ${propertyData.plotSideSize}'),
            if (propertyData.roadSize != null) Text('Road Size: ${propertyData.roadSize}'),
            if (propertyData.ageOfProperty != null) Text('Age: ${propertyData.ageOfProperty}'),
            if (propertyData.waterConnection != null) Text('Water: ${propertyData.waterConnection}'),
            if (propertyData.electricPrice != null) Text('Electric: ${propertyData.electricPrice}'),
            if (propertyData.propertyChain != null) Text('Chain: ${propertyData.propertyChain}'),
            if (propertyData.longitude != null || propertyData.latitude != null)
              Text('Location: ${propertyData.longitude ?? ''}, ${propertyData.latitude ?? ''}'),
            if (propertyData.fieldworkerName != null) Text('Fieldworker: ${propertyData.fieldworkerName}'),
            if (propertyData.fieldworkerNumber != null) Text('Number: ${propertyData.fieldworkerNumber}'),
          ],
        ),
      ),
    );
  }
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