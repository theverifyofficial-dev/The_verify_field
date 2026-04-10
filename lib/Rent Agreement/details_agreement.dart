import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:gal/gal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Administrator/imagepreviewscreen.dart';

import '../AppLogger.dart';
import '../Custom_Widget/Custom_backbutton.dart';
import '../Custom_Widget/constant.dart';
import '../model/Additional_agreement_tenants.dart';
import 'Dashboard_screen.dart';
import 'Forms/Agreement_Form.dart';
import 'Forms/Commercial_Form.dart';
import 'Forms/External_Form.dart';
import 'Forms/Furnished_form.dart';
import 'Forms/Renewal_form.dart';
import 'Forms/Verification_form.dart';

// ─── Section Theme Map (exact copy from AdminAgreementDetails) ────────────────
class _SectionTheme {
  final Color titleBg;
  final Color titleText;
  final Color borderColor;
  final Color cardBg;
  final IconData icon;

  const _SectionTheme({
    required this.titleBg,
    required this.titleText,
    required this.borderColor,
    required this.cardBg,
    required this.icon,
  });
}

final Map<String, _SectionTheme> _sectionThemes = {
  "Owner Details": _SectionTheme(
    titleBg: const Color(0xFF0F766E),
    titleText: Colors.white,
    borderColor: const Color(0xFF0F766E),
    cardBg: const Color(0xFFE6FFFA),
    icon: Icons.person_outlined,
  ),
  "Tenant Details": _SectionTheme(
    titleBg: const Color(0xFF1D4ED8),
    titleText: Colors.white,
    borderColor: const Color(0xFF1D4ED8),
    cardBg: const Color(0xFFEFF6FF),
    icon: Icons.people_outlined,
  ),
  "Director Details": _SectionTheme(
    titleBg: const Color(0xFF1D4ED8),
    titleText: Colors.white,
    borderColor: const Color(0xFF1D4ED8),
    cardBg: const Color(0xFFEFF6FF),
    icon: Icons.business_center_outlined,
  ),
  "Additional Tenant": _SectionTheme(
    titleBg: const Color(0xFFC2410C),
    titleText: Colors.white,
    borderColor: const Color(0xFFC2410C),
    cardBg: const Color(0xFFFFF7ED),
    icon: Icons.group_add_outlined,
  ),
  "Additional Director": _SectionTheme(
    titleBg: const Color(0xFFC2410C),
    titleText: Colors.white,
    borderColor: const Color(0xFFC2410C),
    cardBg: const Color(0xFFFFF7ED),
    icon: Icons.group_add_outlined,
  ),
  "Property Residential Address": _SectionTheme(
    titleBg: const Color(0xFF0369A1),
    titleText: Colors.white,
    borderColor: const Color(0xFF0369A1),
    cardBg: const Color(0xFFE0F2FE),
    icon: Icons.location_on_outlined,
  ),
  "Agreement Status": _SectionTheme(
    titleBg: const Color(0xFF374151),
    titleText: Colors.white,
    borderColor: const Color(0xFF374151),
    cardBg: const Color(0xFFF9FAFB),
    icon: Icons.flag_outlined,
  ),
  "Documents": _SectionTheme(
    titleBg: const Color(0xFF065F46),
    titleText: Colors.white,
    borderColor: const Color(0xFF065F46),
    cardBg: const Color(0xFFECFDF5),
    icon: Icons.folder_copy_outlined,
  ),
  "Property Details": _SectionTheme(
    titleBg: const Color(0xFF0369A1),
    titleText: Colors.white,
    borderColor: const Color(0xFF0369A1),
    cardBg: const Color(0xFFE0F2FE),
    icon: Icons.apartment_outlined,
  ),
};

final Map<String, IconData> _fieldIcons = {
  'Owner Name': Icons.person_outlined,
  'Tenant Name': Icons.person_outlined,
  'Director Name': Icons.person_outlined,
  'Name': Icons.engineering_outlined,
  'Number': Icons.phone_outlined,
  'Relation': Icons.group_outlined,
  'Address': Icons.location_on_outlined,
  'Mobile': Icons.phone_outlined,
  'Aadhar': Icons.badge_outlined,
  'Aadhaar': Icons.badge_outlined,
  'Property': Icons.home_work_outlined,
  'BHK': Icons.home_outlined,
  'Sqft': Icons.square_foot_outlined,
  'Floor': Icons.layers_outlined,
  'Rented Address': Icons.location_on_outlined,
  'Property Address': Icons.location_on_outlined,
  'Monthly Rent': Icons.currency_rupee,
  'Security': Icons.lock_outlined,
  'Installment Security': Icons.savings_outlined,
  'Meter': Icons.electric_meter_outlined,
  'Custom Unit': Icons.tune_outlined,
  'Maintenance': Icons.build_circle_outlined,
  'Maintenance Amount': Icons.calculate_outlined,
  'Parking': Icons.local_parking_outlined,
  'Shifting Date': Icons.calendar_today_outlined,
  'Agreement Price': Icons.receipt_long_outlined,
  'Notary Amount': Icons.verified_outlined,
  'Company Name': Icons.business_outlined,
  'Document Type': Icons.description_outlined,
  'Document Number': Icons.numbers_outlined,
  'PAN Number': Icons.credit_card_outlined,
  'Status': Icons.flag_outlined,
  'Reason': Icons.message_outlined,
  'Property ID': Icons.tag_outlined,
  'Meter Type': Icons.electric_meter_outlined,
};

// ─── Main Widget ──────────────────────────────────────────────────────────────
class AgreementDetailPage extends StatefulWidget {
  final bool fromNotification;
  final String agreementId;

  const AgreementDetailPage({
    super.key,
    this.fromNotification = false,
    required this.agreementId,
  });

  @override
  State<AgreementDetailPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AgreementDetailPage>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? agreement;
  bool isLoading = true;
  List<AdditionalTenant> additionalTenants = [];

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _fetchAgreementDetail(),
      fetchAdditionalTenants(widget.agreementId),
    ]);
    setState(() => isLoading = false);
  }

  Future<void> fetchAdditionalTenants(String agreementId) async {
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/show_api_for_addtional_tenant.php?agreement_id=$agreementId",
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded["success"] == true) {
        setState(() {
          additionalTenants = (decoded["data"] as List)
              .map((e) => AdditionalTenant.fromJson(e))
              .toList();
        });
      }
    }
  }

  Future<void> _fetchAgreementDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=${widget.agreementId}"));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        AppLogger.api("🔹 API Response: $decoded");
        if (decoded["status"] == "success" && decoded["count"] > 0) {
          setState(() => agreement = decoded["data"][0]);
        }
      }
    } catch (e) {
      AppLogger.api("Error: $e");
    }
  }


  // ====== Design helpers (kept and expanded) ======
  Color get _panel => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF121212)
      : Colors.white;
  Color get _ink => Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;
  Color get _muted => _ink.withOpacity(.68);
  Color get _stroke => Theme.of(context).dividerColor.withOpacity(.22);

  double _labelWidth(BoxConstraints c) {
    final w = c.maxWidth;
    if (w < 360) return 110;
    if (w < 480) return 130;
    if (w < 700) return 150;
    return 180;
  }

  Color _statusColor(String s) {
    final t = s.toLowerCase();
    if (t.contains('rejected')) return Colors.redAccent;
    if (t.contains('resubmit') || t.contains('approved')) return Colors.greenAccent;
    if (t.contains('pending')) return Colors.orangeAccent;
    return Theme.of(context).colorScheme.secondary;
  }

  Widget _badge(String text, {IconData? icon, Color? color}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final Color bg = color?.withOpacity(isDark ? .18 : .12) ??
        (isDark ? Colors.white.withOpacity(.06) : Colors.black.withOpacity(.06));
    final Color fg = color != null ? (color.computeLuminance() < 0.35 ? Colors.white : Colors.black87) : (isDark ? Colors.white : Colors.black87);
    final Color brd = color?.withOpacity(.28) ?? (_stroke);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        border: Border.all(color: brd),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: fg),
          const SizedBox(width: 6),
        ],
        Text(text, style: TextStyle(color: fg, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
    IconData icon = Icons.folder_open_outlined,
    Color? accent,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _stroke),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(isDark ? .45 : .06), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (accent ?? Colors.green).withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Theme.of(context).brightness == Brightness.dark ? Colors.green.shade100 : Colors.green.shade800),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 8),
          ]),
        ),
        Divider(height: 1, color: _stroke),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: children),
        ),
      ]),
    );
  }

  Widget _imageThumb(String path) {
    if ((path ?? '').toString().trim().isEmpty) return const SizedBox.shrink();

    final full =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$path";

    Future<void> _downloadImage() async {
      try {
        // Ask permission for photos/storage
        if (await Permission.photos.request().isDenied &&
            await Permission.storage.request().isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission denied")),
          );
          return;
        }

        // Download the image
        final response = await http.get(Uri.parse(full));
        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Failed to download image")),
          );
          return;
        }

        // Write bytes to a temporary file
        final tempDir = await getTemporaryDirectory();
        final fileName =
            "verifyserve_${DateTime.now().millisecondsSinceEpoch}.jpg";
        final filePath = "${tempDir.path}/$fileName";
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Save directly to system gallery using gal
        await Gal.putImage(filePath, album: "VerifyServe");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Image saved to phone gallery"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        AppLogger.api("Error saving image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error saving image")),
        );
      }
    }

    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              InteractiveViewer(
                child: Image.network(
                  full,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(
                    height: 200,
                    child: Center(
                      child: Icon(Icons.broken_image, color: Colors.red),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: FloatingActionButton.extended(
                  onPressed: (){
                    _downloadImage();
                    Navigator.pop(context);
                  },
                  backgroundColor: Colors.green.shade600,
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: const Text("Save", style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
      onLongPress: _downloadImage, // 👈 long press also downloads directly
      child: Container(
        width: 120,
        height: 92,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _stroke),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.network(
          full,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
          const Center(child: Icon(Icons.broken_image, color: Colors.red)),
          loadingBuilder: (c, w, p) => p == null
              ? w
              : Container(
            color: Theme.of(context)
                .colorScheme
                .surfaceVariant
                .withOpacity(.45),
            child: const Center(
              child: SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow({required String label, required String value, bool isImage = false}) {
    if ((value ?? '').toString().trim().isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(builder: (context, c) {
      final lw = _labelWidth(c);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: lw,
            child: Text(
              "$label:",
              style: TextStyle(fontWeight: FontWeight.w700, color: _muted),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: isImage
                ? _imageThumb(value)
                : SelectableText(
              (value ?? '').toString(),
              style: TextStyle(color: _ink, height: 1.35),
            ),
          ),
        ]),
      );
    });
  }

  Widget _diagonalRibbon(bool show, String text) {
    if (!show) return const SizedBox.shrink();
    return Positioned(
      top: 12,
      left: -32,
      child: Transform.rotate(
        angle: -0.785398, // -45°
        child: Container(
          width: 170,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.redAccent.shade200, Colors.red.shade700]),
            boxShadow: [BoxShadow(color: Colors.redAccent.withOpacity(.3), blurRadius: 6, offset: const Offset(2, 2))],
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, letterSpacing: 1.2),
          ),
        ),
      ),
    );
  }

  Future<RewardStatus> fetchRewardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString("number");
    if (number == null || number.isEmpty) {
      return RewardStatus(totalAgreements: 0, isDiscounted: false);
    }
    final res = await http.get(Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Target_New_2026/count_api_for_all_agreement_with_reword.php?Fieldwarkarnumber=$number"));
    final data = jsonDecode(res.body);
    if (data["status"] == true) {
      final total = int.tryParse(data["total_agreement"].toString()) ?? 0;
      return RewardStatus(totalAgreements: total, isDiscounted: total > 20);
    }
    return RewardStatus(totalAgreements: 0, isDiscounted: false);
  }

  void _navigateToEditForm(
      BuildContext context, Map<String, dynamic> agreement) async {
    final String type =
    (agreement['agreement_type'] ?? '').toString().toLowerCase();
    final String id =
    (agreement['id'] ?? agreement['agreement_id'] ?? '').toString();
    final reward = await fetchRewardStatus();
    Widget? page;
    if (type.contains("rental agreement")) {
      page = RentalWizardPage(agreementId: id, rewardStatus: reward);
    } else if (type.contains("external rental agreement")) {
      page = ExternalWizardPage(agreementId: id, rewardStatus: reward);
    } else if (type.contains("commercial agreement")) {
      page = CommercialWizardPage(agreementId: id, rewardStatus: reward);
    } else if (type.contains("furnished agreement")) {
      page = FurnishedForm(agreementId: id, rewardStatus: reward);
    } else if (type.contains("renewal agreement")) {
      page = RenewalForm(agreementId: id, rewardStatus: reward);
    } else if (type.contains("police verification")) {
      page = VerificationWizardPage(agreementId: id, rewardStatus: reward);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                "Unknown agreement type: ${agreement['agreement_type']}")),
      );
      return;
    }
    if (page != null) {
      await Navigator.push(
          context, MaterialPageRoute(builder: (_) => page!));
      _fetchAgreementDetail();
    }
  }

  // ── UI Helpers (same as AdminAgreementDetails) ────────────────────────────

  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = _sectionThemes[title];

    final visibleChildren =
    children.where((c) => c is! SizedBox || (c.height ?? 0) > 0).toList();
    if (visibleChildren.isEmpty) return const SizedBox.shrink();

    final titleBg = theme?.titleBg ?? const Color(0xFF4CA1FF);
    final titleText = theme?.titleText ?? Colors.white;
    final borderColor = theme?.borderColor ?? const Color(0xFF4CA1FF);
    final cardBg = isDark ? Colors.white : (theme?.cardBg ?? Colors.white);
    final icon = theme?.icon ?? Icons.info_outline;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor.withOpacity(0.4), width: 1.2),
          boxShadow: isDark
              ? []
              : [
            BoxShadow(
                color: borderColor.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title bar
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: titleBg,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(13)),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: titleText),
                  const SizedBox(width: 8),
                  Text(title,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: titleText,
                          letterSpacing: 0.2)),
                ],
              ),
            ),
            // Body
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: visibleChildren),
            ),
          ],
        ),
      ),
    );
  }

  Widget _kv(String k, String? v) {
    if (v == null || v.trim().isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final icon = _fieldIcons[k] ?? Icons.label_outline;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1, right: 8),
            child: Icon(icon,
                size: 16,
                color: isDark ? Colors.grey[900] : Colors.grey[500]),
          ),
          SizedBox(
            width: 130,
            child: Text('$k:',
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: isDark ? Colors.black87 : Colors.grey[600])),
          ),
          Expanded(
            child: Text(v,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: isDark ? Colors.black : Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _kvRow(String k1, dynamic v1, String k2, dynamic v2) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: _kvSingle(k1, v1)),
          const SizedBox(width: 4),
          Expanded(child: _kvSingle(k2, v2)),
        ],
      ),
    );
  }

  Widget _kvSingle(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final icon = _fieldIcons[k] ?? Icons.label_outline;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 12, color: Colors.black87),
            const SizedBox(width: 4),
            Text(k,
                style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.black87 : Colors.black87)),
          ],
        ),
        const SizedBox(height: 2),
        Text(value.isEmpty ? "—" : value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.black87 : Colors.black87)),
      ],
    );
  }

  Widget _kvFull(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final icon = _fieldIcons[k] ?? Icons.label_outline;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon,
                  size: 12,
                  color: isDark ? Colors.black87 : Colors.grey[900]),
              const SizedBox(width: 4),
              Text(k,
                  style: TextStyle(
                      fontSize: 11,
                      color: isDark ? Colors.black87 : Colors.grey[900])),
            ],
          ),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.black87 : Colors.grey[900])),
        ],
      ),
    );
  }

  Widget _kvHighlight(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFF7C3AED).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, size: 16, color: Colors.white),
          const SizedBox(width: 8),
          Text('$k:',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Colors.white70)),
          const SizedBox(width: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white)),
        ],
      ),
    );
  }

  Widget _kvAmount(String k, String? v) {
    final raw = v?.toString().trim() ?? "";
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final icon = _fieldIcons[k] ?? Icons.currency_rupee;

    Widget leading = Padding(
      padding: const EdgeInsets.only(top: 1, right: 8),
      child: Icon(icon,
          size: 16,
          color: isDark ? Colors.grey[900] : Colors.grey[500]),
    );

    if (raw.isEmpty || raw == 'Not Added') {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            leading,
            SizedBox(
                width: 130,
                child: Text('$k:',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color:
                        isDark ? Colors.black87 : Colors.grey[600]))),
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const Text('Not Added',
                  style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic)),
            ),
          ],
        ),
      );
    }

    final amount = raw.replaceAll('₹', '').trim();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          leading,
          SizedBox(
              width: 130,
              child: Text('$k:',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: isDark ? Colors.black87 : Colors.grey[600]))),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF16A34A), Color(0xFF15803D)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF16A34A).withOpacity(0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Text('₹ $amount',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.3)),
          ),
        ],
      ),
    );
  }

  Widget _kvCompact(String k, dynamic v, IconData iconData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(iconData, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text('$k:',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.black87 : Colors.grey[600])),
        const SizedBox(width: 6),
        Text(value,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
                color: isDark ? Colors.black87 : Colors.grey[600])),
      ],
    );
  }

  Widget _hkCompact(String k, dynamic v, IconData iconData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(iconData, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text('$k:',
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.black87 : Colors.grey[600])),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF16A34A), Color(0xFF15803D)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF16A34A).withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child: Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w100,
                  color: Colors.white)),
        ),
      ],
    );
  }

  Widget _furnitureList(dynamic furnitureData) {
    if (furnitureData == null || furnitureData.toString().trim().isEmpty)
      return const SizedBox.shrink();
    Map<String, dynamic> furnitureMap = {};
    try {
      if (furnitureData is String)
        furnitureMap = Map<String, dynamic>.from(json.decode(furnitureData));
      else if (furnitureData is Map<String, dynamic>)
        furnitureMap = furnitureData;
    } catch (e) {
      debugPrint("⚠️ Furniture parse error: $e");
    }
    if (furnitureMap.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Furnished Items:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: furnitureMap.entries.map((e) {
              return Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade600, width: 1),
                ),
                child: Text("${e.key} (${e.value})",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Colors.black87)),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _docImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();
    final full =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$imageUrl';

    Future<void> downloadImage() async {
      try {
        if (await Permission.photos.request().isDenied &&
            await Permission.storage.request().isDenied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission denied")),
          );
          return;
        }
        final response = await http.get(Uri.parse(full));
        if (response.statusCode != 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("❌ Failed to download image")),
          );
          return;
        }
        final tempDir = await getTemporaryDirectory();
        final fileName =
            "verifyserve_${DateTime.now().millisecondsSinceEpoch}.jpg";
        final filePath = "${tempDir.path}/$fileName";
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        await Gal.putImage(filePath, album: "VerifyServe");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Image saved to phone gallery"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } catch (e) {
        debugPrint("Error saving image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Error saving image")),
        );
      }
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ImagePreviewScreen(imageUrl: full),
        ),
      ),
      onLongPress: downloadImage, // ✅ Long press to save
      child: Container(
        width: 80,
        height: 90,
        margin: const EdgeInsets.only(right: 12, top: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            full,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.red, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: 400,
      margin: const EdgeInsets.only(right: 20),
      child: _sectionCard(title: title, children: children),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(
              child: CircularProgressIndicator(
                  color: Color(0xFF7C3AED))));
    }
    if (agreement == null) {
      return const Scaffold(
          body: Center(child: Text("No details found")));
    }

    final a = agreement!;
    final bool withPolice = a['is_Police']?.toString() == "true";
    final bool isPolice = a["agreement_type"] == "Police Verification";
    final bool isCom = a["agreement_type"] == "Commercial Agreement";
    final String D_or_T = isCom ? "Director" : "Tenant";
    final bool isRejected =
    (a['status']?.toString().toLowerCase().contains('reject') ?? false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
            AppImages.verify, height: 70),
        centerTitle: true,
        surfaceTintColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: pageGradient),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 90, 16, 24),
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildMainContent(a, D_or_T, personLabel, isDirector, isRejected, withPolice),
                      _diagonalRibbon(isRejected, 'REJECTED'),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMainContent(
      Map<String, dynamic> a,
      String D_or_T,
      String personLabel,
      bool isDirector,
      bool isRejected,
      bool withPolice,
      ) {

    List<int> policeTenants = [];

// 🔹 Main tenant (Tenant 1)
    final mainPolice =
        agreement?['is_Police']?.toString().toLowerCase() == "true";

    if (mainPolice) {
      policeTenants.add(1);
    }

// 🔹 Additional tenants (Tenant 2,3...)
    for (int i = 0; i < additionalTenants.length; i++) {
      final t = additionalTenants[i];

      final value = (t.policeVerification ?? "")
          .toString()
          .toLowerCase()
          .trim();

      if (value == "true" || value == "1") {
        policeTenants.add(i + 2); // because main = 1
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.black.withOpacity(.45)
            : Colors.white.withOpacity(.95),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.22),
            blurRadius: 30,
            offset: const Offset(0, 12),
          )
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          if (policeTenants.isNotEmpty)
            _buildPoliceNotice(policeTenants),

          const SizedBox(height: 20),

          _buildBadges(a),

          const SizedBox(height: 20),

          if (a['agreement_type'] != "Police Verification")
            if (a['status'] != null)
              _buildStatusCard(a, isRejected),

          const SizedBox(height: 20),

          _buildDetailSections(a, D_or_T, personLabel, isDirector),

        ],
      ),
    );
  }

  Widget _buildPoliceNotice(List<int> tenants) {
    final tenantText = tenants.join(', ');

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Colors.redAccent),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Police verification required for Tenant(s): $tenantText',
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Agreement type badge — same purple→pink as AdminAgreementDetails ──
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${a["agreement_type"] ?? ""} Details',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3),
              ),
            ),

            const SizedBox(height: 8),

            // ── Police notice ──
            if (withPolice) _buildPoliceNotice(),

            const SizedBox(height: 12),

            // ── Status section (if not police) ──
            if (!isPolice && a['status'] != null)
              _sectionCard(
                title: "Agreement Status",
                children: [
                  _kv("Status", a['status']?.toString()),
                  _kv("Reason", a['messages']?.toString()),
                  if (isRejected) ...[
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? Colors.red.shade700
                              : Colors.red.shade500,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding:
                          const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () =>
                            _navigateToEditForm(context, a),
                        icon: const Icon(Icons.edit, size: 18),
                        label: const Text("Edit & Resubmit",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3)),
                      ),
                    ),
                  ],
                ],
              ),

            const SizedBox(height: 8),

            // ── Horizontal section cards (same as AdminAgreementDetails) ──
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                 // Agreement Details
                  if (!isPolice)
                    _buildCard(
                      title: "Agreement Details",
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _kvCompact(
                                isCom ? "Sqft" : "BHK",
                                isCom
                                    ? (a["Sqft"] ?? "")
                                    : (a["Bhk"] ?? ""),
                                Icons.home,
                              ),
                            ),
                            Expanded(
                              child: _kvCompact(
                                "Floor",
                                a["floor"] ?? "",
                                Icons.layers,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _kv("Rented Address", a["rented_address"]),
                        _kvAmount("Monthly Rent",
                            "₹${a["monthly_rent"] ?? ""}"),
                        _kvAmount(
                            "Security", "₹${a["securitys"] ?? ""}"),
                        // _kvAmount("Installment Security",
                        //     "₹${a["installment_security_amount"] ?? ""}"),
                        _kv("Meter Type", a["meter"]),
                        _kv("Custom Unit", a["custom_meter_unit"]),
                        _kv("Maintenance", a["maintaince"]),
                        if (a["maintaince"] == "Excluding")
                          _kv("Maintenance Amount",
                              a["custom_maintenance_charge"]),
                        _kv("Parking", a["parking"]),
                        _kvHighlight(
                            "Shifting Date",
                            a["shifting_date"]
                                ?.toString()
                                .split("T")[0] ??
                                ""),
                        _furnitureList(a['furniture']),
                       // const Divider(height: 20),
                       //  Row(
                       //    children: [
                       //      Expanded(
                       //          child: _hkCompact(
                       //              "Agreement Price",
                       //              a["agreement_price"] ?? "",
                       //              Icons.receipt_long_outlined)),
                       //      Expanded(
                       //          child: _hkCompact(
                       //              "Notary",
                       //              a["notary_price"] ?? "",
                       //              Icons.verified_outlined)),
                       //    ],
                       //  ),
                      ],
                    ),

                 SizedBox(height: 16),

                  //Owner Details
                  _buildCard(
                    title: "Owner Details",
                    children: [
                      _kvRow(
                          "Owner Name",
                          a["owner_name"],
                          "Relation",
                          "${a["owner_relation"] ?? ""} ${a["relation_person_name_owner"] ?? ""}"),
                      _kvFull("Address", a["parmanent_addresss_owner"]),
                      _kvRow("Mobile", a["owner_mobile_no"], "Aadhar",
                          a["owner_addhar_no"]),
                      const SizedBox(height: 8),
                      Row(children: [
                        _docImage(a["owner_aadhar_front"]),
                        _docImage(a["owner_aadhar_back"]),
                      ]),
                    ],
                  ),

                 SizedBox(height: 16),

                  // Tenant / Director Details
                  _buildCard(
                    title: "$D_or_T Details",
                    children: [
                      _kvRow(
                          "$D_or_T Name",
                          a["tenant_name"],
                          "Relation",
                          "${a["tenant_relation"] ?? ""} ${a["relation_person_name_tenant"] ?? ""}"),
                      _kvFull(
                          "Address", a["permanent_address_tenant"]),
                      _kvRow("Mobile", a["tenant_mobile_no"], "Aadhar",
                          a["tenant_addhar_no"]),

                      if (a["agreement_type"] ==
                          "Commercial Agreement") ...[
                        const Divider(height: 20),
                        const Text("Company Details",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D4ED8))),
                        const SizedBox(height: 8),
                        _kvRow("Company Name", a["company_name"],
                            "DOC Type", a["gst_type"]),
                        _kvRow("DOC Number", a["gst_no"], "PAN Number",
                            a["pan_no"]),
                        const SizedBox(height: 8),
                        Row(children: [
                          _docImage(a["gst_photo"]),
                          _docImage(a["pan_photo"]),
                        ]),
                      ],

                      const SizedBox(height: 8),
                      Row(children: [
                        _docImage(a["tenant_aadhar_front"]),
                        _docImage(a["tenant_aadhar_back"]),
                        _docImage(a["tenant_image"]),
                      ]),

                      // Additional tenants inside same card
                      if (additionalTenants.isNotEmpty) ...[
                        const Divider(height: 24),
                        Text("Additional $D_or_T",
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFC2410C))),
                        const SizedBox(height: 10),
                        ...List.generate(additionalTenants.length,
                                (index) {
                              final t = additionalTenants[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7ED),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    border: Border.all(
                                        color: const Color(0xFFC2410C)
                                            .withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("$D_or_T ${index + 2}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12,
                                              color: Color(0xFFC2410C))),
                                      const SizedBox(height: 8),
                                      _kvRow(
                                          "$D_or_T Name",
                                          t.name,
                                          "Relation",
                                          "${t.relation} ${t.relation_name}"),
                                      _kvFull("Address", t.address),
                                      _kvRow("Mobile", t.mobile,
                                          "Aadhaar", t.aadhaar),
                                      const SizedBox(height: 6),
                                      Row(children: [
                                        _docImage(t.front),
                                        _docImage(t.back),
                                        _docImage(t.photo),
                                      ]),
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ],
                    ],
                  ),
                ],
              ),
            ),
              if (additionalTenants.isNotEmpty)
                _buildAdditionalTenants(D_or_T),
            ],
          ),
        ),

        /// PROPERTY
        SizedBox(
          width: 320,
          child: _sectionCard(
            title: "Property Details",
            icon: Icons.apartment_outlined,
            children: [
              _detailRow(
                  label: "Property ID",
                  value: a['property_id']?.toString() ?? ''),
              _detailRow(
                  label: "BHK",
                  value: a['Bhk']?.toString() ?? ''),
              _detailRow(
                  label: "Floor",
                  value: a['floor']?.toString() ?? ''),
              _detailRow(
                  label: "Rented Address",
                  value: a['rented_address'] ?? ''),
              _detailRow(
                  label: "Cost",
                  value: a['agreement_price'] ?? ''),
              _detailRow(
                  label: "Meter Type",
                  value: a['meter'] ?? ''),
              _detailRow(
                  label: "Maintenance",
                  value: a['maintaince'] ?? ''),
              _detailRow(
                  label: "Parking",
                  value: a['parking'] ?? ''),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalTenants(String D_or_T) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(
          "Additional $D_or_T",
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),

        ...List.generate(additionalTenants.length, (index) {
          final t = additionalTenants[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _stroke),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$D_or_T ${index + 2}",
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                _detailRow(label: "Name", value: t.name),
                _detailRow(label: "Relation", value: t.relation),
                _detailRow(label: "Person name", value: t.relation_name),
                _detailRow(label: "Mobile", value: t.mobile),
                _detailRow(label: "Aadhaar", value: t.aadhaar),
                _detailRow(label: "Address", value: t.address),

                Wrap(
                  children: [
                    _detailRow(
                        label: "Aadhaar Front",
                        value: t.front,
                        isImage: true),
                    _detailRow(
                        label: "Aadhaar Back",
                        value: t.back,
                        isImage: true),
                    _detailRow(
                        label: "Photo",
                        value: t.photo,
                        isImage: true),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

            // ── Police address ──
            // if (isPolice)
            //   _sectionCard(
            //     title: "Property Residential Address",
            //     children: [
            //       _kv("Property Address", a["rented_address"]),
            //     ],
            //   ),

            // ── Property Details ──
            // if (!isPolice)
            //   _sectionCard(
            //     title: "Property Details",
            //     children: [
            //       _kvRow("BHK", a["Bhk"], "Floor", a["floor"]),
            //       const SizedBox(height: 4),
            //       _kv("Property id", a["property_id"]),
            //       _kv("Rented Address", a["rented_address"]),
            //       _kv("Meter Type", a["meter"]),
            //       _kv("Maintenance", a["maintaince"]),
            //       _kv("Parking", a["parking"]),
            //     ],
            //   ),
            //
            // const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── Sub-widgets ────────────────────────────────────────────────────────────

  Widget _buildPoliceNotice() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Row(
        children: const [
          Icon(Icons.info_outline, color: Colors.redAccent),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Note: Police verification must be created by Admin for this agreement.',
              style: TextStyle(
                  color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}