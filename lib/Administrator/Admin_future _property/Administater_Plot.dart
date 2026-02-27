// PlotListPage (Responsive: Matched building tab UI exactly - search bar, filter buttons (All, Sale, Rent, Open), stats row (plot count only), cards with images (no live badge), title (mainAddress), detail rows (Location, Plot Size, Price, Status, Address) using _DetailRow with bold values, Plot ID at bottom right, count no badge, missing fields; dynamic sizing via MediaQuery/clamp; left column: image only (no total), right: title + details; ensured no overflow)
import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Future_Property_OwnerDetails_section/Plot_detail.dart' hide PlotPropertyData;
import 'Administater_Show_Plot.dart';
import 'Administater_Under_Plot.dart';

class Show_Administater_Plot extends StatefulWidget {
  final String? plotId;
  final bool fromNotification;

  const Show_Administater_Plot({
    super.key,
    this.plotId,
    this.fromNotification = false,
  });

  @override
  State<Show_Administater_Plot> createState() => Show_Administater_PlotState();
}

class Show_Administater_PlotState extends State<Show_Administater_Plot> {

  bool _isLoading = true;
  String _location = '';
  String _post = '';

  @override
  void initState() {
    super.initState();

    if (widget.fromNotification && widget.plotId != null) {
      print("🔥 Highlight plotId: ${widget.plotId}");
    }
      for (final fw in fieldWorkers) {
      _horizontalControllers[fw['id']!] = ScrollController();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  List<Map<String, String>> fieldWorkers = [
    {"name": "Sumit Kasaniya", "id": "9711775300"},
    {"name": "Ravi Kumar", "id": "9711275300"},
    {"name": "Faizan Khan", "id": "9971172204"},
    {"name": "Manish", "id": "8130209217"},
    {"name": "Abhay", "id": "9675383184"},
  ];

  Map<String, List<PlotPropertyData>> _groupedPlotData = {};
  final Map<String, ScrollController> _horizontalControllers = {};

  Future<void> _loadAllPlots() async {
    setState(() => _isLoading = true);

    for (final fw in fieldWorkers) {
      final plots = await PlotPropertyApi.fetchForFieldworker(fw['id']!);
      _groupedPlotData[fw['id']!] = plots;
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
      await PlotPropertyApi.fetchForFieldworker(fw['id']!);
      _groupedPlotData[fw['id']!] = data;
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
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

  Widget _buildPlotSection(String name, String id, List<PlotPropertyData> plots) {
    final sortedPlots = List<PlotPropertyData>.from(plots)
      ..sort((a, b) => b.id.compareTo(a.id));

    if (sortedPlots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  "No plots found for this field worker.",
                  style: TextStyle(color: Colors.grey, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Administater_show_Plot(number: id),
                    ),
                  );
                 },
                child: const Text(
                  'See All →',
                  style: TextStyle(
                      color: Colors.red, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 420,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: sortedPlots.length,
            itemBuilder: (context, i) {
              final plot = sortedPlots[i];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          Administater_Under_Plot(propertyData: plot,),
                    ),
                  );
                },
                  child:
                SizedBox(
                width: 340,
                child: _buildPlotCard(plot, sortedPlots.length - i),
                ),
              );
            },
          ),
        ),
      ],
    );
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
    return Scaffold(
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
          onRefresh: _fetchAndUpdateData,
          child: ListView(
            children: _groupedPlotData.entries.map((entry) {
              final worker = fieldWorkers.firstWhere(
                    (fw) => fw['id'] == entry.key,
              );

              return _buildPlotSection(
                worker['name']!,
                entry.key,
                entry.value,
              );
            }).toList(),
          ),
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
                ),
              ),

              SizedBox(height: isTablet ? 16 : 12),
            ],
          ),
        ),
      ],
    );
  }
  Widget _buildPlotCard(PlotPropertyData property, int displayIndex) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDark = theme.brightness == Brightness.dark;

    final images = _buildMultipleImages(property);

    final double cardPadding = (screenWidth * 0.03).clamp(8.0, 20.0);
    final double titleFontSize = isTablet ? 20 : 16;
    final double detailFontSize = isTablet ? 14 : 13;
    final double imageH = (screenHeight * 0.29).clamp(150.0, 250.0);
    final double multiH = imageH * 0.8;

    // Missing fields logic
    final Map<String, dynamic> fields = {
      "Plot Size": property.plotSize,
      "Plot Price": property.plotPrice,
      "Plot Status": property.plotStatus,
      "Field Address": property.fieldAddress,
      "Main Address": property.mainAddress,
      "Location": property.currentLocation,
    };

    final missingFields = fields.entries
        .where((e) =>
    e.value == null ||
        (e.value is String && e.value.toString().trim().isEmpty))
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
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT IMAGE
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

                      // RIGHT DETAILS
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              property.mainAddress ??
                                  property.fieldAddress ??
                                  property.currentLocation ??
                                  "No Title",
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 12),

                            if ((property.currentLocation ?? "").isNotEmpty)
                              _DetailRow(
                                icon: Icons.location_on,
                                label: "Location",
                                value: property.currentLocation!,
                                theme: theme,
                                getIconColor: _getIconColor,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),

                            if ((property.plotSize ?? "").isNotEmpty)
                              _DetailRow(
                                icon: Icons.square_foot,
                                label: "Plot Size",
                                value: property.plotSize!,
                                theme: theme,
                                getIconColor: _getIconColor,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),

                            if ((property.plotPrice ?? "").isNotEmpty)
                              _DetailRow(
                                icon: Icons.attach_money,
                                label: "Price",
                                value: property.plotPrice!,
                                theme: theme,
                                getIconColor: _getIconColor,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),

                            if ((property.plotStatus ?? "").isNotEmpty)
                              _DetailRow(
                                icon: Icons.info,
                                label: "Status",
                                value: property.plotStatus!,
                                theme: theme,
                                getIconColor: _getIconColor,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: _DetailRow(
                                icon: Icons.badge,
                                label: "Plot ID",
                                value: property.id.toString(),
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
                ),

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
                    ),
                  ),
              ],
            ),
          ),

          // COUNT BADGE
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