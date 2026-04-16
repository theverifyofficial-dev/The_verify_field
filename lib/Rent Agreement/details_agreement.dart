import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:gal/gal.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart' hide AppImages;

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

// ─── Section Theme Map ────────────────────────────────────────────────────────
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
  "Agreement Details": _SectionTheme(
    titleBg: const Color(0xFF7C3AED),
    titleText: Colors.white,
    borderColor: const Color(0xFF7C3AED),
    cardBg: const Color(0xFFF5F0FF),
    icon: Icons.description_outlined,
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
  // ── State ──────────────────────────────────────────────────────────────────
  Map<String, dynamic>? agreement;
  bool isLoading = true;
  List<AdditionalTenant> additionalTenants = [];

  // ── Lifecycle ──────────────────────────────────────────────────────────────
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

  // ── Network ────────────────────────────────────────────────────────────────
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

  // ── Design helpers ─────────────────────────────────────────────────────────
  Color get _ink => Theme.of(context).brightness == Brightness.dark
      ? Colors.white
      : Colors.black87;

  Color get _stroke =>
      Theme.of(context).dividerColor.withOpacity(.22);

  Color _statusColor(String s) {
    final t = s.toLowerCase();
    if (t.contains('rejected')) return Colors.redAccent;
    if (t.contains('resubmit') || t.contains('approved')) return Colors.greenAccent;
    if (t.contains('pending')) return Colors.orangeAccent;
    return Theme.of(context).colorScheme.secondary;
  }

  Widget _badge(String text, {IconData? icon, Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = color?.withOpacity(isDark ? .18 : .12) ??
        (isDark
            ? Colors.white.withOpacity(.06)
            : Colors.black.withOpacity(.06));
    final Color fg = color != null
        ? (color.computeLuminance() < 0.35 ? Colors.white : Colors.black87)
        : (isDark ? Colors.white : Colors.black87);
    final Color brd = color?.withOpacity(.28) ?? _stroke;

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

  Widget _diagonalRibbon(bool show, String text) {
    if (!show) return const SizedBox.shrink();
    return Positioned(
      top: 12,
      left: -32,
      child: Transform.rotate(
        angle: -0.785398,
        child: Container(
          width: 170,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.redAccent.shade200, Colors.red.shade700]),
            boxShadow: [
              BoxShadow(
                  color: Colors.redAccent.withOpacity(.3),
                  blurRadius: 6,
                  offset: const Offset(2, 2))
            ],
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: Text(
            text.toUpperCase(),
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2),
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

  Future<void> _navigateToEditForm(
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

  // ─────────────────────────────────────────────────────────────────────────
  //  UI Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Themed section card (uses _sectionThemes map for colors/icons)
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
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: visibleChildren,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fixed-width card for horizontal scroll layout
  Widget _buildCard(
      {required String title, required List<Widget> children}) {
    return Container(
      width: 380,
      margin: const EdgeInsets.only(right: 20),
      child: _sectionCard(title: title, children: children),
    );
  }

  Widget _kv(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
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
            child: Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: isDark ? Colors.black : Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _hk(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$k:',
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: isDark ? Colors.black87 : Colors.grey[600])),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: isDark ? Colors.black : Colors.black87),
                    softWrap: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vkCompact(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
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
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF42cbf5), Colors.white]),
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
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _vAmount(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
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
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFFf071c7), Colors.white]),
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
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }

  Widget _kCompact(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
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
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Color(0xFF42cbf5), Color(0xFFb471f0)]),
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
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _kvAmount(String k, dynamic v) {
    final raw = v?.toString().trim() ?? "";
    final icon = _fieldIcons[k] ?? Icons.currency_rupee;
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                  colors: [Color(0xFF55f2c0), Color(0xFFFFFFFF)]),
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
                    color: Colors.black,
                    letterSpacing: 0.3)),
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

  Widget _kvFull(String k, dynamic v) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final icon = _fieldIcons[k] ?? Icons.label_outline;
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
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
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: isDark ? Colors.black87 : Colors.grey[900])),
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
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: isDark ? Colors.black87 : Colors.black87)),
      ],
    );
  }

  Widget _kvCompact(String k, dynamic v, IconData iconData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsetsDirectional.only(end: 15, bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[200] : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isDark ? Colors.grey[400]! : Colors.grey[300]!,
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 👈 important
        children: [
          Icon(iconData, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 6),

          /// ✅ FIXED PART
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.black87 : Colors.black87,
              ),
             maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
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
                colors: [Color(0xFFeff542), Color(0xFFf59342)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF16A34A).withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ],
          ),
          child:
          Text(value,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: Colors.black)),
        ),
      ],
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
          colors: [Color(0xFFeb2f2f), Color(0xFFFFFFFF)],
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
          const Icon(Icons.calendar_today, size: 18, color: Colors.black),
          const SizedBox(width: 8),
          Text('$k:',
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(width: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
        ],
      ),
    );
  }

  Widget _furnitureList(dynamic furnitureData) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    if (furnitureData == null || furnitureData.toString().trim().isEmpty)
      return const SizedBox.shrink();
    Map<String, dynamic> furnitureMap = {};
    try {
      if (furnitureData is String)
        furnitureMap = Map<String, dynamic>.from(json.decode(furnitureData));
      else if (furnitureData is Map<String, dynamic>)
        furnitureMap = furnitureData;
    } catch (e) {
      AppLogger.api("⚠️ Furniture parse error: $e");
    }
    if (furnitureMap.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Furnished Items:',
              style:
              TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
                  color: isDark ? Colors.black87 : Colors.grey[800])),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: furnitureMap.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border:
                  Border.all(color: Colors.green.shade600, width: 1),
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
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ImagePreviewScreen(
                  imageUrl:
                  'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$imageUrl'))),
      child: Container(
        width: 80,
        height: 90,
        margin: const EdgeInsets.only(right: 12, top: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$imageUrl",
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
        ),
      ),
    );
  }

  // Police notice banner (with tenants list)
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
                  color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(
              child: CircularProgressIndicator(color: Color(0xFF7C3AED))));
    }
    if (agreement == null) {
      return const Scaffold(body: Center(child: Text("No details found")));
    }

    final a = agreement!;
    final bool withPolice = a['is_Police']?.toString() == "true";
    final bool isPolice = a["agreement_type"] == "Police Verification";
    final bool isCom = a["agreement_type"] == "Commercial Agreement";
    final String D_or_T = isCom ? "Director" : "Tenant";
    final bool isRejected =
    (a['status']?.toString().toLowerCase().contains('reject') ?? false);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Compute which tenants need police verification
    final List<int> policeTenants = [];
    if (a['is_Police']?.toString().toLowerCase() == "true") {
      policeTenants.add(1);
    }
    for (int i = 0; i < additionalTenants.length; i++) {
      final value = (additionalTenants[i].policeVerification ?? "")
          .toString()
          .toLowerCase()
          .trim();
      if (value == "true" || value == "1") {
        policeTenants.add(i + 2);
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 70),
        centerTitle: true,
        surfaceTintColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Agreement type badge ──────────────────────────────────
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

                const SizedBox(height: 10),

                // ── Police notices ────────────────────────────────────────
                if (policeTenants.isNotEmpty) ...[
                  _buildPoliceNotice(policeTenants),
                  const SizedBox(height: 10),
                ],

                // ── Status section ────────────────────────────────────────
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
                                  borderRadius: BorderRadius.circular(10)),
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

                // ── Horizontally scrollable section cards ─────────────────
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                                      "Floor", a["floor"] ?? "", Icons.layers),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            _kv("Rented Address", a["rented_address"]),
                            _kvAmount(
                                "Monthly Rent", "₹${a["monthly_rent"] ?? ""}"),
                            _kCompact("Maintenance", a["maintaince"]),
                            _vkCompact("Security", "₹${a["securitys"] ?? ""}"),
                            _kv("Meter Type", a["meter"]),
                            _kv("Custom Unit", a["custom_meter_unit"]),

                            if (a["maintaince"] == "Excluding")
                              _kv("Maintenance Amount",
                                  a["custom_maintenance_charge"]),
                            _kv("Parking", a["parking"]),
                            _kvHighlight(
                              "Shifting Date",
                              a["shifting_date"]
                                  ?.toString()
                                  .split("T")[0] ??
                                  "",
                            ),
                            _furnitureList(a['furniture']),

                            const Divider(height: 20),

                            Row(
                              children: [
                                Expanded(
                                  child: _hkCompact(
                                      "Cost",
                                      agreement?["agreement_price"] ?? "",
                                      Icons.receipt_long_outlined),
                                ),
                                Expanded(
                                  child: _hkCompact(
                                      "Notary",
                                      agreement?["notary_price"] ?? "",
                                      Icons.verified_outlined),
                                ),
                              ],
                            ),
                          ],
                        ),

                      // Owner Details
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

                      // Tenant / Director Details
                      _buildCard(
                        title: "$D_or_T Details",
                        children: [
                          _kvRow(
                              "$D_or_T Name",
                              a["tenant_name"],
                              "Relation",
                              "${a["tenant_relation"] ?? ""} ${a["relation_person_name_tenant"] ?? ""}"),
                          _kvFull("Address", a["permanent_address_tenant"]),
                          _kvRow("Mobile", a["tenant_mobile_no"], "Aadhar",
                              a["tenant_addhar_no"]),

                          if (isCom) ...[
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

                          // Additional tenants
                          if (additionalTenants.isNotEmpty) ...[
                            const Divider(height: 24),
                            Text("Additional $D_or_T",
                                style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFC2410C))),
                            const SizedBox(height: 10),
                            ...List.generate(additionalTenants.length, (index) {
                              final t = additionalTenants[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF7ED),
                                    borderRadius: BorderRadius.circular(10),
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
                                      _kvRow("Mobile", t.mobile, "Aadhaar",
                                          t.aadhaar),
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

                // ── Police residential address ────────────────────────────
                if (isPolice)
                  _sectionCard(
                    title: "Property Residential Address",
                    children: [
                      _kv("Property Address", a["rented_address"]),
                    ],
                  ),

                const SizedBox(height: 30),
              ],
            ),
          ),

          // Rejected ribbon overlay
          if (isRejected) _diagonalRibbon(true, 'REJECTED'),
        ],
      ),
    );
  }
}