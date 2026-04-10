import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:verify_feild_worker/SocialMediaHandler/Social_Insurance/Social_InsuranceShowListPage.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

import '../Social_InsuranceDetail.dart';


class _InsDetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;
  final Color iconColor;
  final int maxLines;
  final double fontSize;
  final FontWeight fontWeight;

  const _InsDetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
    this.iconColor = Colors.blue,
    this.maxLines = 2,
    this.fontSize = 13,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    final cs = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 15, color: iconColor),
          const SizedBox(width: 5),
          Expanded(
            child: RichText(
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.3,
                  color: cs.onSurface.withOpacity(0.70),
                  fontSize: fontSize,
                ),
                children: [
                  if (label.isNotEmpty)
                    TextSpan(
                      text: '$label: ',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: cs.onSurface.withOpacity(0.85),
                        fontSize: fontSize,
                      ),
                    ),
                  TextSpan(
                    text: value,
                    style: TextStyle(
                      fontWeight: fontWeight,
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

// ─────────────────────────────────────────────
// Main Page
// ─────────────────────────────────────────────
class Social_Insurance_handle extends StatefulWidget {
  const Social_Insurance_handle({super.key});

  @override
  State<Social_Insurance_handle> createState() =>
      _Social_Insurance_handleState();
}

class _Social_Insurance_handleState
    extends State<Social_Insurance_handle> {
  // ── Field workers (same as Future Property page) ──────────────────────────
  final List<Map<String, String>> fieldWorkers = [
    {"name": "Sumit Kasaniya", "id": "9711775300"},
    {"name": "Ravi Kumar", "id": "9711275300"},
    {"name": "Faizan Khan", "id": "9971172204"},
    // {"name": "Abhay", "id": "9675383184"},
  ];

  // ── State ─────────────────────────────────────────────────────────────────
  Map<String, List<SocialInsuranceModel>> _groupedData = {};
  final Map<String, ScrollController> _horizontalControllers = {};
  bool _isLoading = true;
  String _location = '';
  String _post = '';

  // ── Lifecycle ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    for (final fw in fieldWorkers) {
      _horizontalControllers[fw['id']!] = ScrollController();
      _groupedData[fw['id']!] = [];
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _initializeData());
  }

  Future<void> _initializeData() async {
    await _loadUserData();
    if (!mounted) return;
    await _fetchAndUpdateData();
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _location = prefs.getString('location') ?? '';
    _post = prefs.getString('post') ?? '';
  }

  // ── API fetch ─────────────────────────────────────────────────────────────
  Future<List<SocialInsuranceModel>> _fetchByNumber(String number) async {
    final url = Uri.parse(
        'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/show_insurance_api_base_on_fieldwoakr_number.php?fieldworkar_number=$number');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        List listData = [];
        if (decoded is Map && decoded['data'] is List) {
          listData = decoded['data'];
        } else if (decoded is List) {
          listData = decoded;
        }
        listData.sort((a, b) => (b['id'] ?? 0).compareTo(a['id'] ?? 0));
        return listData.map((e) => SocialInsuranceModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint("Insurance fetch error for $number: $e");
    }
    return [];
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
      allowedWorkers = fieldWorkers
          .where((fw) =>
      fw['name']!.toLowerCase().contains("sumit") ||
          fw['name']!.toLowerCase().contains("ravi") ||
          fw['name']!.toLowerCase().contains("faizan"))
          .toList();
    } else if (loc.contains("rajpur") ||
        loc.contains("chhattarpur") ||
        loc.contains("chattar")) {
      allowedWorkers = fieldWorkers
          .where((fw) =>
      fw['name']!.toLowerCase().contains("manish") ||
          fw['name']!.toLowerCase().contains("abhay"))
          .toList();
    }

    for (final fw in allowedWorkers) {
      final data = await _fetchByNumber(fw['id']!);
      _groupedData[fw['id']!] = data;
    }

    if (mounted) setState(() => _isLoading = false);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _formatDate(String? s) {
    if (s == null || s.trim().isEmpty) return '-';
    try {
      return DateFormat('dd MMM yyyy').format(DateTime.parse(s));
    } catch (_) {
      return s;
    }
  }

  bool _blank(String? s) => s == null || s.trim().isEmpty;

  Color _vehicleTypeColor(String? type) {
    switch ((type ?? '').toLowerCase()) {
      case '2 wheeler':
        return Colors.green;
      case '3 wheeler':
        return Colors.orange;
      case '4 wheeler':
        return Colors.blue;
      case '6 wheeler':
      case '8 wheeler':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  // ── Card Builder ──────────────────────────────────────────────────────────
  Widget _buildCard(SocialInsuranceModel ins, int displayIndex) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    final double cardPadding = (size.width * 0.03).clamp(8.0, 20.0);
    final double titleFontSize = isTablet ? 18 : 15;
    final double detailFontSize = isTablet ? 14 : 12.5;
    final double imageH = (size.height * 0.25).clamp(130.0, 220.0);

    // Vehicle image
    Widget vehicleImage;
    if (ins.carPhotoUrl != null) {
      vehicleImage = ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: imageH,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: ins.carPhotoUrl!,
            fit: BoxFit.cover,
            placeholder: (_, __) =>
            const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorWidget: (_, __, ___) =>
                Icon(Icons.directions_car, color: cs.error, size: 70),
          ),
        ),
      );
    } else {
      vehicleImage = Container(
        height: imageH,
        decoration: BoxDecoration(
          color: cs.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child:
        Icon(Icons.directions_car_outlined, size: 70, color: Colors.grey),
      );
    }

    // Claim badge
    final bool hasClaim = (ins.claim ?? '').toLowerCase() == 'yes';

    // Missing check (basic important fields)
    final List<String> missing = [];
    final checks = <String, String?>{
      'Car Photo': ins.carPhoto,
      'Aadhar Front': ins.aadharFront,
      'RC Front': ins.rcFront,
      'Old Policy': ins.oldPolicyDocument,
      'PAN Card': ins.pan_card_photo,
      'Vehicle No': ins.vehicleNumber,
      'Name': ins.name,
      'Number': ins.number,
      'Vehicle Type': ins.vehicleType,
      'Fuel Type': ins.fuelType,
      'Category': ins.vehicle_category,
    };
    checks.forEach((k, v) {
      if (_blank(v)) missing.add(k);
    });

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                Social_InsuranceDetailScreen(
                    insuranceId: ins.id)),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        elevation: isDark ? 0 : 6,
        color: theme.cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.dividerColor),
        ),
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Left column: image + docs count ───────────────
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              vehicleImage,
                              // Claim badge
                              Positioned(
                                top: 4,
                                left: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: hasClaim
                                        ? Colors.red.withOpacity(0.85)
                                        : Colors.green.withOpacity(0.85),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    hasClaim ? 'Claim: Yes' : 'Claim: No',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              // Vehicle type chip
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _vehicleTypeColor(ins.vehicleType)
                                        .withOpacity(0.9),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    ins.vehicleType ?? '-',
                                    style: theme.textTheme.labelSmall?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Cotations count
                       //   _buildCotationBadges(ins, theme, cs),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ── Right column: details ──────────────────────────
                    Expanded(
                      flex: 4,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 22),
                              // Owner name as title
                              Text(
                                ins.name ?? 'No Name',
                                style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: titleFontSize),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              _InsDetailRow(
                                icon: Icons.directions_car,
                                label: 'Vehicle No',
                                value: ins.vehicleNumber ?? 'N/A',
                                theme: theme,
                                iconColor: Colors.blue,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              // _InsDetailRow(
                              //   icon: Icons.phone,
                              //   label: 'Number',
                              //   value: ins.number ?? 'N/A',
                              //   theme: theme,
                              //   iconColor: Colors.green,
                              //   fontSize: detailFontSize,
                              //   fontWeight: FontWeight.bold,
                              // ),
                              _InsDetailRow(
                                icon: Icons.local_gas_station,
                                label: 'Fuel',
                                value: ins.fuelType ?? 'N/A',
                                theme: theme,
                                iconColor: Colors.orange,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              _InsDetailRow(
                                icon: Icons.business_center,
                                label: 'Category',
                                value: ins.vehicle_category ?? 'N/A',
                                theme: theme,
                                iconColor: Colors.purple,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              _InsDetailRow(
                                icon: Icons.recycling,
                                label: 'Pollution',
                                value: ins.pollutionYesNo ?? 'N/A',
                                theme: theme,
                                iconColor: Colors.teal,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              _InsDetailRow(
                                icon: Icons.calendar_today,
                                label: 'Date',
                                value: _formatDate(ins.current_dates),
                                theme: theme,
                                iconColor: Colors.indigo,
                                fontSize: detailFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                               const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: _InsDetailRow(
                                  icon: Icons.numbers,
                                  label: 'ID',
                                  value: ins.id.toString(),
                                  theme: theme,
                                  iconColor: Colors.cyan,
                                  fontSize: detailFontSize,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Index badge (top-right)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 4),
                              decoration: BoxDecoration(
                                color: cs.primary.withOpacity(0.95),
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 6,
                                      offset: const Offset(0, 3))
                                ],
                              ),
                              child: Text(
                                '$displayIndex',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Missing fields warning
              if (missing.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: cs.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: cs.error)),
                    child: Text(
                      "⚠ Missing: ${missing.join(', ')}",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                          color: cs.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget _buildCotationBadges(
  //     SocialInsuranceModel ins, ThemeData theme, ColorScheme cs) {
  //   final cotations = [ins.cotation1, ins.cotation2, ins.cotation3, ins.cotation4];
  //   final count = cotations.where((c) => c != null && c.isNotEmpty).length;
  //
  //   return Row(
  //     children: [
  //       Icon(Icons.description_outlined,
  //           size: 14,
  //           color: count > 0 ? Colors.green : Colors.grey),
  //       const SizedBox(width: 4),
  //       Text(
  //         '$count Quotation${count == 1 ? '' : 's'}',
  //         style: theme.textTheme.bodySmall?.copyWith(
  //           color: count > 0 ? Colors.green : Colors.grey,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       // ),Text(
  //       //   '$count Quotation${count == 1 ? '' : 's'}',
  //       //   style: theme.textTheme.bodySmall?.copyWith(
  //       //     color: count > 0 ? Colors.green : Colors.grey,
  //       //     fontWeight: FontWeight.w600,
  //       //   ),
  //        ),
  //     ],
  //   );
  // }

  // ── Section Builder (same structure as Future Property) ───────────────────
  Widget _buildSection(
      String name, String id, List<SocialInsuranceModel> records) {
    final sorted = List<SocialInsuranceModel>.from(records)
      ..sort((a, b) => b.id.compareTo(a.id));

    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
              child: Center(
                child: Text(
                  "No insurance records found for this field worker.",
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${sorted.length} Records',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500)),
                ],
              ),
              // TODO: Hook up "See All" to Insurance See-All Page
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => social_InsuranceListScreen(
                        fieldWorkerNumber: id,
                        fieldWorkerName: id,)),
                  );
                },
                child: const Text('See All →',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
            // ✅ SAHI TARIKA — SingleChildScrollView + IntrinsicHeight
            SingleChildScrollView(
            controller: _horizontalControllers[id],
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: IntrinsicHeight(
    child: Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: List.generate(sorted.length, (i) {
    return SizedBox(
    width: 340,
    child: _buildCard(sorted[i], sorted.length - i),
    );
    },
    ),
    ),
    ),
            )],

    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final loc = _location.toLowerCase();
    final post = _post.toLowerCase();
    final isAdmin = post == "administrator";

    final List<Map<String, String>> workersToShow = isAdmin
        ? fieldWorkers
        : fieldWorkers.where((fw) {
      final n = fw['name']!.toLowerCase();
      if (loc.contains("sultanpur")) {
        return n.contains("sumit") ||
            n.contains("ravi") ||
            n.contains("faizan") ||
      n.contains("avjit");
      }
      if (loc.contains("rajpur") ||
          loc.contains("chhattarpur") ||
          loc.contains("chattar")) {
        return n.contains("manish") || n.contains("abhay");
      }
      return false;
    }).toList();

    final bool hasAccess = workersToShow.isNotEmpty;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF050202) : Colors.grey.shade100,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.transparent,height: 40,),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
          child: CircularProgressIndicator(color: Colors.blue))
          : RefreshIndicator(
        onRefresh: _fetchAndUpdateData,
        child: hasAccess
            ? ListView(
          children: workersToShow.map((fw) {
            final records = _groupedData[fw['id']] ?? [];
            return _buildSection(fw['name']!, fw['id']!, records);
          }).toList(),
        )
            : ListView(
          children: [
            const SizedBox(height: 200),
            Center(
              child: Column(
                children: [
                  const Icon(Icons.warning,
                      size: 60, color: Colors.orange),
                  const SizedBox(height: 20),
                  const Text(
                    "No access to any field worker data.",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "Location: $_location\nPost: $_post\n\nContact Administrator.",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _horizontalControllers.values.forEach((c) => c.dispose());
    super.dispose();
  }
}