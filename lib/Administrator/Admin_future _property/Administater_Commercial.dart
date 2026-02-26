import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/Admin_future%20_property/Administater_under_commercial.dart';
import 'Administater_show_commercial.dart';

class Show_Aministater_Commercial extends StatefulWidget {

  final String? commercialId;
  final bool fromNotification;
  final String fieldWorkerNumber;

  const Show_Aministater_Commercial({
    super.key,
    this.commercialId,
    this.fromNotification = false,
    this.fieldWorkerNumber = '11',
  });

  @override
  State<Show_Aministater_Commercial> createState() => Show_Aministater_CommercialState();
}

class Show_Aministater_CommercialState extends State<Show_Aministater_Commercial> {

  bool _isLoading = true;
  String _location = '';
  String _post = '';

  final List<Map<String, String>> fieldWorkers = [
    {"name": "Sumit Kasaniya", "id": "9711775300"},
    {"name": "Ravi Kumar", "id": "9711275300"},
    {"name": "Faizan Khan", "id": "9971172204"},
    {"name": "Manish", "id": "8130209217"},
    {"name": "Abhay", "id": "9675383184"},
  ];

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


  final Map<String, List<CommercialPropertyData>> _groupedData = {};
  final Map<String, ScrollController> _horizontalControllers = {};

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadUserData();  // Pehle location aur post load hone do

    if (!mounted) return;

    // Ab location/post guaranteed filled hain
    await _fetchAndUpdateData();

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _fetchAndUpdateData() async {
    if (_location.isEmpty || _post.isEmpty) return;

    setState(() => _isLoading = true);

    final loc = _location.toLowerCase();
    final isAdmin = _post.toLowerCase() == "administrator";

    List<Map<String, String>> allowedWorkers = [];

    if (isAdmin) {
      allowedWorkers = fieldWorkers;
    } else if (loc.contains("sultanpur")) {
      allowedWorkers = fieldWorkers.where((fw) =>
      fw['name']!.toLowerCase().contains("sumit") ||
          fw['name']!.toLowerCase().contains("ravi") ||
          fw['name']!.toLowerCase().contains("faizan")
      ).toList();
    } else if (loc.contains("rajpur") ||
        loc.contains("chhattarpur") ||
        loc.contains("chattar") ||
        loc.contains("chhattar")) {
      allowedWorkers = fieldWorkers.where((fw) =>
      fw['name']!.toLowerCase().contains("manish") ||
          fw['name']!.toLowerCase().contains("abhay")
      ).toList();
    }

    for (final fw in allowedWorkers) {
      final data =
      await CommercialApi.fetch(fw['id']!);
      _groupedData[fw['id']!] = data;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }


  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _location = prefs.getString('location') ?? '';
    _post = prefs.getString('post') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchAndUpdateData();
        },
        child: _isLoading
            ? ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 400),
            Center(child: CircularProgressIndicator()),
          ],
        )
            : ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: _groupedData.entries.map((entry) {
            final worker = fieldWorkers.firstWhere(
                  (fw) => fw['id'] == entry.key,
            );

            return _buildSection(
              worker['name']!,
              entry.key,
              entry.value,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSection(
      String name,
      String id,
      List<CommercialPropertyData> property,
      ) {
    final sorted = List<CommercialPropertyData>.from(property)
      ..sort((a, b) => (b.id ?? 0).compareTo(a.id ?? 0));

    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const Center(
              child: Text(
                "No commercial properties found.",
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// HEADER ROW WITH SEE ALL BUTTON
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Text(
                name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Administater_Commercial(number: id,
                      ),
                    ),
                  );
                },
                child: const Text(
                  "See All →",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        /// HORIZONTAL LIST
        SizedBox(
          height: 430,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final property = sorted[index];
              final displayIndex = sorted.length - index;

              return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            Administater_CommercialUnderProperty(property: property),
                      ),
                    );
                  },
                  child:SizedBox(
                width: 340,
                child: _buildCommercialCard(property, displayIndex),
              ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCommercialCard(CommercialPropertyData property,
      int displayIndex,) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    final screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final isTablet = screenWidth > 600;
    final isDark = theme.brightness == Brightness.dark;

    final images = _buildMultipleImages(property);

    final double cardPadding = (screenWidth * 0.03).clamp(8.0, 20.0);
    final double titleFontSize = isTablet ? 20 : 16;
    final double detailFontSize = isTablet ? 14 : 13;
    final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
    final double multiH = imageH * 0.8;

    // 🔴 Missing Fields Logic
    final Map<String, dynamic> fields = {
      "Location": property.location_,
      "Listing Type": property.listing_type,
      "Property Type": property.property_type,
      "Area": property.build_up_area,
      "Price": property.price,
      "Total Floors": property.total_floor,
      "Fieldworker Name": property.field_workar_name,
      "Fieldworker Number": property.field_workar_number,
    };

    final missingFields = fields.entries
        .where((e) =>
    e.value == null ||
        (e.value is String && e.value
            .toString()
            .trim()
            .isEmpty))
        .map((e) => e.key)
        .toList();

    final hasMissingFields = missingFields.isNotEmpty;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// LEFT IMAGE
                    Expanded(
                      flex: 2,
                      child: _buildImageSection(
                        images: images,
                        cs: cs,
                        theme: theme,
                        imageHeight: imageH,
                        multiImgHeight: multiH,
                        isTablet: isTablet,
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// RIGHT DETAILS
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.location_ ??
                                property.current_location ??
                                "No Title",
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: titleFontSize,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 12),

                          _DetailRow(
                            icon: Icons.location_on,
                            label: "Location",
                            value: property.location_ ?? "N/A",
                            theme: theme,
                            getIconColor: _getIconColor,
                            fontSize: detailFontSize,
                            fontWeight: FontWeight.bold,
                          ),

                          _DetailRow(
                            icon: Icons.handshake_outlined,
                            label: "",
                            value: property.listing_type ?? "N/A",
                            theme: theme,
                            getIconColor: _getIconColor,
                            fontSize: detailFontSize,
                            fontWeight: FontWeight.bold,
                          ),

                          _DetailRow(
                            icon: Icons.apartment,
                            label: "",
                            value: property.property_type ?? "N/A",
                            theme: theme,
                            getIconColor: _getIconColor,
                            fontSize: detailFontSize,
                            fontWeight: FontWeight.bold,
                          ),

                          if ((property.build_up_area ?? "").isNotEmpty)
                            _DetailRow(
                              icon: Icons.square_foot,
                              label: "Area",
                              value: property.build_up_area!,
                              theme: theme,
                              getIconColor: _getIconColor,
                              fontSize: detailFontSize,
                              fontWeight: FontWeight.bold,
                            ),

                          if ((property.price ?? "").isNotEmpty)
                            _DetailRow(
                              icon: Icons.attach_money,
                              label: "Price",
                              value: property.price!,
                              theme: theme,
                              getIconColor: _getIconColor,
                              fontSize: detailFontSize,
                              fontWeight: FontWeight.bold,
                            ),

                          const SizedBox(height: 8),

                          Align(
                            alignment: Alignment.centerRight,
                            child: _DetailRow(
                              icon: Icons.numbers,
                              label: "Commercial ID",
                              value: property.id?.toString() ?? "N/A",
                              theme: theme,
                              getIconColor: _getIconColor,
                              fontSize: detailFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                /// 🔴 Missing Fields Box
                if (hasMissingFields)
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: cs.errorContainer,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: cs.error),
                    ),
                    child: Text(
                      "⚠ Missing: ${missingFields.join(', ')}",
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: cs.error,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),

          /// COUNT BADGE
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: cs.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "$displayIndex",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
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
  static Uri endpoint(String number) {
  final base = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_api_commercial_property.php';
  return Uri.parse(base).replace(
  queryParameters: {'field_workar_number': number},
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