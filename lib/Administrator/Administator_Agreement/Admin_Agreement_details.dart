import 'dart:convert';
import 'dart:io';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:http/http.dart' as http;
import '../../Custom_Widget/Custom_backbutton.dart';
import '../../Custom_Widget/constant.dart';
import '../../Rent Agreement/Dashboard_screen.dart';
import '../../Rent Agreement/Forms/Agreement_Form.dart';
import '../../Rent Agreement/Forms/Commercial_Form.dart';
import '../../Rent Agreement/Forms/External_Form.dart';
import '../../Rent Agreement/Forms/Furnished_form.dart';
import '../../Rent Agreement/Forms/Renewal_form.dart';
import '../../Rent Agreement/Forms/Verification_form.dart';
import '../../model/Additional_agreement_tenants.dart';
import '../imagepreviewscreen.dart';
import 'Admin_dashboard.dart';

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
  "Agreement Details": const _SectionTheme(
    titleBg: const Color(0xFF7C3AED),
    titleText: Colors.white,
    borderColor: const Color(0xFF7C3AED),
    cardBg: const Color(0xFFF5F0FF),
    icon: Icons.description_outlined,
  ),
  "Owner Details": const _SectionTheme(
    titleBg: const Color(0xFF0F766E),
    titleText: Colors.white,
    borderColor: const Color(0xFF0F766E),
    cardBg: const Color(0xFFE6FFFA),
    icon: Icons.person_outlined,
  ),
  "Tenant Details": const _SectionTheme(
    titleBg: const Color(0xFF1D4ED8),
    titleText: Colors.white,
    borderColor: const Color(0xFF1D4ED8),
    cardBg: const Color(0xFFEFF6FF),
    icon: Icons.people_outlined,
  ),
  "Director Details": const _SectionTheme(
    titleBg: const Color(0xFF1D4ED8),
    titleText: Colors.white,
    borderColor: const Color(0xFF1D4ED8),
    cardBg: const Color(0xFFEFF6FF),
    icon: Icons.business_center_outlined,
  ),
  "Additional Tenant": const _SectionTheme(
    titleBg: const Color(0xFFC2410C),
    titleText: Colors.white,
    borderColor: const Color(0xFFC2410C),
    cardBg: const Color(0xFFFFF7ED),
    icon: Icons.group_add_outlined,
  ),
  "Additional Director": const _SectionTheme(
    titleBg: const Color(0xFFC2410C),
    titleText: Colors.white,
    borderColor: const Color(0xFFC2410C),
    cardBg: const Color(0xFFFFF7ED),
    icon: Icons.group_add_outlined,
  ),
  "Field Worker": const _SectionTheme(
    titleBg: const Color(0xFFB45309),
    titleText: Colors.white,
    borderColor: const Color(0xFFB45309),
    cardBg: const Color(0xFFFFFBEB),
    icon: Icons.engineering_outlined,
  ),
  // "Property Residential Address": const _SectionTheme(
  //   titleBg: const Color(0xFF0369A1),
  //   titleText: Colors.white,
  //   borderColor: const Color(0xFF0369A1),
  //   cardBg: const Color(0xFFE0F2FE),
  //   icon: Icons.location_on_outlined,
  // ),
  "Documents": const _SectionTheme(
    titleBg: const Color(0xFF065F46),
    titleText: Colors.white,
    borderColor: const Color(0xFF065F46),
    cardBg: const Color(0xFFECFDF5),
    icon: Icons.folder_copy_outlined,
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
};

// ─── Main Widget ──────────────────────────────────────────────────────────────
class AdminAgreementDetails extends StatefulWidget {
  final String agreementId;
  const AdminAgreementDetails({super.key, required this.agreementId});

  @override
  State<AdminAgreementDetails> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AdminAgreementDetails> {
  Map<String, dynamic>? agreement;
  bool isLoading = true;
  File? pdfFile;
  List<AdditionalTenant> additionalTenants = [];
  Widget? propertyCard;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // ── Network ────────────────────────────────────────────────────────────────

  Future<void> _loadAllData() async {
    setState(() => isLoading = true);
    await Future.wait([
      _fetchAgreementDetail(),
      fetchAdditionalTenants(widget.agreementId),
    ]);
    setState(() => isLoading = false);
  }

  Future<void> _fetchAgreementDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=${widget.agreementId}"));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["status"] == "success" && decoded["count"] > 0) {
          setState(() => agreement = decoded["data"][0]);
          fetchPropertyCard();
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
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

  Future<void> fetchPropertyCard() async {
    final propertyId = agreement?["property_id"];
    if (propertyId == null || propertyId.isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/display_api_base_on_flat_id.php"),
        body: {"P_id": propertyId},
      );
      if (response.statusCode == 200) {
        final j = jsonDecode(response.body);
        if (j['status'] == "success") {
          setState(() => propertyCard = _buildPropertyCard(j['data']));
        }
      }
    } catch (e) {
      AppLogger.api("⚠️ Furniture parse error: $e");
      debugPrint("Property error: $e");
    }
  }

  Future<void> _updateAgreementStatus(String action) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/shift_agreement.php"),
        body: {"id": widget.agreementId, "action": action},
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Agreement Accepted successfully"),
            backgroundColor: Color(0xFF16A34A),
          ));
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
                (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(decoded["message"] ?? "Failed to update"),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  Future<void> _updateAgreementStatusWithMessage(
      String action, String message) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/shift_agreement.php"),
        body: {
          "id": widget.agreementId,
          "action": action,
          "messages": message,
        },
      );
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Agreement Rejected Successfully"),
            backgroundColor: Color(0xFFEF4444),
          ));
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
                (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(decoded["message"] ?? "Failed to update"),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  void _showRejectDialog() {
    final TextEditingController messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1C1C26),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cancel_outlined, color: Color(0xFFEF4444)),
            SizedBox(width: 10),
            Text("Reject Agreement",
                style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Reason for rejection:",
                style: TextStyle(color: Color(0xFF9898B0), fontSize: 13)),
            const SizedBox(height: 10),
            TextField(
              controller: messageController,
              maxLines: 3,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Enter your message",
                hintStyle: const TextStyle(color: Color(0xFF5A5A72)),
                filled: true,
                fillColor: const Color(0xFF13131A),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2A2A38)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF2A2A38)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                ),
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: Color(0xFF9898B0))),
          ),
          GestureDetector(
            onTap: () async {
              final message = messageController.text.trim();
              if (message.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Message cannot be empty")),
                );
                return;
              }
              Navigator.pop(context);
              await _updateAgreementStatusWithMessage("reject", message);
            },
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text("Confirm",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }

  // ── UI Widgets ─────────────────────────────────────────────────────────────


  /// Glass container (plain white card)
  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900]!.withOpacity(0.85) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? Colors.grey[700]! : Colors.grey.shade200,
            width: 1),
        boxShadow: isDark
            ? []
            : [
          BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: child,
    );
  }

  /// Colored section card with gradient title bar
  Widget _sectionCard(
      {required String title, required List<Widget> children}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = _sectionThemes[title];

    final visibleChildren = children
        .where((c) => c is! SizedBox || (c.height ?? 0) > 0)
        .toList();
    if (visibleChildren.isEmpty) return const SizedBox.shrink();

    final titleBg = theme?.titleBg ?? const Color(0xFF4CA1FF);
    final titleText = theme?.titleText ?? Colors.white;
    final borderColor = theme?.borderColor ?? const Color(0xFF4CA1FF);
    final cardBg =
    isDark ? Colors.white : (theme?.cardBg ?? Colors.white);
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
            // ── Colored Title Bar ──
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
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: titleText,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            // ── Content ──
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
      debugPrint("⚠️ Furniture parse error: $e");
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

  /// Document thumbnail
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

  /// Card wrapper for horizontal scroll
  Widget _buildCard(
      {required String title, required List<Widget> children}) {
    return Container(
      width: 400,
      margin: const EdgeInsets.only(right: 20),
      child: _sectionCard(title: title, children: children),
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
                  color: Colors.redAccent, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Pill-shaped stylish button (image-style)
  Widget _pillButton({
    required String label,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback? onPressed,
    Color? textColor,
    Color? iconColor,
    Color? borderColor,
  }) {
    final isDisabled = onPressed == null;
    final resolvedTextColor = textColor ?? Colors.white;
    final resolvedIconColor = iconColor ?? Colors.white;

    return GestureDetector(
      onTap: isDisabled ? null : onPressed,
      child: AnimatedOpacity(
        opacity: isDisabled ? 0.5 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: borderColor == null
                ? LinearGradient(
              colors: isDisabled
                  ? [Colors.grey.shade600, Colors.grey.shade700]
                  : colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : null,
            color: borderColor != null ? colors[0] : null,
            borderRadius: BorderRadius.circular(50),
            border: borderColor != null
                ? Border.all(color: borderColor, width: 1.5)
                : null,
            boxShadow: isDisabled
                ? []
                : [
              BoxShadow(
                color: colors.last.withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: resolvedIconColor, size: 20),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: resolvedTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<RewardStatus> fetchRewardStatus(String number) async {

    if (number == null || number.isEmpty) {
      return RewardStatus(totalAgreements: 0, isDiscounted: false);
    }

    final res = await http.get(
      Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Target_New_2026/count_api_for_all_agreement_with_reword.php"
            "?Fieldwarkarnumber=$number",
      ),
    );

    final data = jsonDecode(res.body);

    if (data["status"] == true) {
      final total = int.tryParse(data["total_agreement"].toString()) ?? 0;

      return RewardStatus(
        totalAgreements: total,
        isDiscounted: total > 20,
      );
    }

    return RewardStatus(totalAgreements: 0, isDiscounted: false);
  }


  void _navigateToEditForm(BuildContext context, Map<String, dynamic> agreement) async {
    final String type = (agreement['agreement_type'] ?? '').toString().toLowerCase();
    final String id = (agreement['id'] ?? agreement['agreement_id'] ?? '').toString();
    final reward = await fetchRewardStatus(agreement['Fieldwarkarnumber']);

    Widget? page;

    if (type.contains("rental agreement")) {
      page = RentalWizardPage(agreementId: id,rewardStatus: reward);
    } else if (type.contains("external rental agreement")) {
      page = ExternalWizardPage(agreementId: id,rewardStatus: reward);
    } else if (type.contains("commercial agreement")) {
      page = CommercialWizardPage(agreementId: id,rewardStatus: reward);
    } else if (type.contains("furnished agreement")) {
      page = FurnishedForm(agreementId: id,rewardStatus: reward);
    } else if (type.contains("renewal agreement")) {
      page = RenewalForm(agreementId: id,rewardStatus: reward);
    } else if (type.contains("Police Verification")) {
      page = VerificationWizardPage(agreementId: id,rewardStatus: reward);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unknown agreement type: ${agreement['agreement_type']}")),
      );
      return;
    }

    if (page != null) {
      await Navigator.push(context, MaterialPageRoute(builder: (_) => page!));
      _fetchAgreementDetail(); // ✅ refresh once after return
    }
  }
  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final withPolice = agreement?['is_Police']?.toString() == "true";

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

    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    if (agreement == null) {
      return const Scaffold(
          body: Center(child: Text("No details found")));
    }

    final D_or_T = agreement?["agreement_type"] == "Commercial Agreement"
        ? "Director"
        : "Tenant";

    final bool isCom =
        agreement?["agreement_type"] == "Commercial Agreement"; // ← yeh add karo

    final bool isPolice =
        agreement?["agreement_type"] == "Police Verification";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(
            AppImages.verify, height: 70),
        centerTitle: true,
        surfaceTintColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Agreement type badge ──
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFFEC4899)]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${agreement?["agreement_type"] ?? ""} Details',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.3),
              ),
            ),

            const SizedBox(height: 16),

            if (withPolice) _buildPoliceNotice(policeTenants),

            const SizedBox(height: 12),

            // ── Property card ──
            if (propertyCard != null) propertyCard!,

            // ── Horizontal section cards ──
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agreement Details

                    _buildCard(
                      title: "Owner Details",
                      children: [
                        _kvRow("Owner Name", agreement?["owner_name"],
                            "Relation",
                            "${agreement?["owner_relation"] ?? ""} ${agreement?["relation_person_name_owner"] ?? ""}"),
                        _kvFull("Address",
                            agreement?["parmanent_addresss_owner"]),
                        _kvRow("Mobile", agreement?["owner_mobile_no"],
                            "Aadhar", agreement?["owner_addhar_no"]),
                      ],
                    ),

                    _buildCard(
                      title: "Agreement Details",
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _kvCompact(
                                isCom ? "Sqft" : "BHK",
                                isCom ? (agreement?["Sqft"] ?? "") : (agreement?["Bhk"] ?? ""),
                                Icons.home,
                              ),
                            ),
                            Expanded(
                              child: _kvCompact(
                                "Floor",
                                agreement?["floor"] ?? "",
                                Icons.layers,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        _kv("Rented Address", agreement?["rented_address"]),
                        _kvAmount("Monthly Rent",
                            "₹${agreement?["monthly_rent"] ?? ""}"),
                        _kvAmount("Security",
                            "₹${agreement?["securitys"] ?? ""}"),
                        _kvAmount("Installment Security",
                            "₹${agreement?["installment_security_amount"] ?? ""}"),
                        _kv("Meter", agreement?["meter"]),
                        _kv("Custom Unit", agreement?["custom_meter_unit"]),
                        _kv("Maintenance", agreement?["maintaince"]),
                        if (agreement?["maintaince"] == "Excluding")
                          _kv("Maintenance Amount",
                              agreement?["custom_maintenance_charge"]),
                        _kv("Parking", agreement?["parking"]),
                        _kvHighlight(
                            "Shifting Date",
                            agreement?["shifting_date"]
                                ?.toString()
                                .split("T")[0] ??
                                ""),
                        _furnitureList(agreement?['furniture']),
                        const Divider(height: 20),
                        Row(
                          children: [
                            Expanded(
                                child: _hkCompact(
                                    "Cost",
                                    agreement?["agreement_price"] ?? "",
                                    Icons.receipt_long_outlined)),
                            Expanded(
                                child: _hkCompact(
                                    "Notary",
                                    agreement?["notary_price"] ?? "",
                                    Icons.verified_outlined)),
                          ],
                        ),
                      ],
                    ),


                  // Tenant / Director Details
                  _buildCard(
                    title: "$D_or_T Details",
                    children: [
                      _kvRow("$D_or_T Name", agreement?["tenant_name"],
                          "Relation",
                          "${agreement?["tenant_relation"] ?? ""} ${agreement?["relation_person_name_tenant"] ?? ""}"),
                      _kvFull("Address",
                          agreement?["permanent_address_tenant"]),
                      _kvRow("Mobile", agreement?["tenant_mobile_no"],
                          "Aadhar", agreement?["tenant_addhar_no"]),

                      if (agreement?["agreement_type"] ==
                          "Commercial Agreement") ...[
                        const Divider(height: 20),
                        const Text("Company Details",
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1D4ED8))),
                        const SizedBox(height: 8),
                        _kvRow("Company Name", agreement?["company_name"],
                            "DOC Type", agreement?["gst_type"]),
                        _kvRow("DOC Number", agreement?["gst_no"],
                            "PAN Number", agreement?["pan_no"]),
                        const SizedBox(height: 8),
                        Row(children: [
                          _docImage(agreement?["gst_photo"]),
                          _docImage(agreement?["pan_photo"]),
                        ]),
                      ],

                      const SizedBox(height: 8),
                      // Row(children: [
                      //   _docImage(agreement?["tenant_aadhar_front"]),
                      //   _docImage(agreement?["tenant_aadhar_back"]),
                      //   _docImage(agreement?["tenant_image"]),
                      // ]),

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
                                padding:
                                const EdgeInsets.only(bottom: 14),
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
                                              color:
                                              Color(0xFFC2410C))),
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

            // // ── Police address ──
            // if (isPolice)
            //   _sectionCard(
            //     title: "Property Residential Address",
            //     children: [
            //       _kv("Property Address", agreement?["rented_address"]),
            //     ],
            //   ),

            // ── Field Worker ──
            _sectionCard(
              title: "Field Worker",
              children: [
                _kv("Name", agreement?["Fieldwarkarname"]),
                _kv("Number", agreement?["Fieldwarkarnumber"]),
              ],
            ),

            // ── Documents ──
            _sectionCard(
              title: "Documents",
              children: [
                if ((agreement?["owner_aadhar_front"] ?? "").isNotEmpty ||
                    (agreement?["owner_aadhar_back"] ?? "").isNotEmpty) ...[
                  const Text("Owner Documents",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0F766E))),
                  const SizedBox(height: 6),
                  Row(children: [
                    _docImage(agreement?["owner_aadhar_front"]),
                    _docImage(agreement?["owner_aadhar_back"]),
                  ]),
                  const SizedBox(height: 12),
                ],
                if ((agreement?["tenant_aadhar_front"] ?? "").isNotEmpty ||
                    (agreement?["tenant_aadhar_back"] ?? "").isNotEmpty ||
                    (agreement?["tenant_image"] ?? "").isNotEmpty) ...[
                  const Text("Tenant Documents",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1D4ED8))),
                  const SizedBox(height: 6),
                  Row(children: [
                    _docImage(agreement?["tenant_aadhar_front"]),
                    _docImage(agreement?["tenant_aadhar_back"]),
                    _docImage(agreement?["tenant_image"]),
                  ]),
                ],
                if (agreement?["agreement_type"] ==
                    "Commercial Agreement") ...[
                  const SizedBox(height: 12),
                  const Text("Company Documents",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7C3AED))),
                  const SizedBox(height: 6),
                  Row(children: [
                    _docImage(agreement?["gst_photo"]),
                    _docImage(agreement?["pan_photo"]),
                  ]),
                ],
              ],
            ),

            const SizedBox(height: 20),


            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  Colors.red.shade700,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => _navigateToEditForm(context, agreement!),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Update Agreement"),
              ),
            ),

            const SizedBox(height: 30),

            // ── Accept / Reject buttons ──
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _pillButton(
                      label: "Reject",
                      icon: Icons.close_rounded,
                      colors: const [
                        Color(0xFFEF4444),
                        Color(0xFFDC2626)
                      ],
                      onPressed: _showRejectDialog,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pillButton(
                      label: "Accept",
                      icon: Icons.check_rounded,
                      colors: const [
                        Color(0xFF16A34A),
                        Color(0xFF15803D)
                      ],
                      onPressed: () =>
                          _updateAgreementStatus("Accept"),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }



  Widget _buildPropertyCard(Map<String, dynamic> data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";

    final Color textPrimary = isDark ? Colors.white : Colors.black87;
    final Color textSecondary =
    isDark ? Colors.grey[300]! : Colors.grey[700]!;
    final Color textMuted = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                alignment: Alignment.center,
                child:
                Text("No Image", style: TextStyle(color: textMuted)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${data['show_Price'] ?? '--'}",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
                    Text(data['Bhk'] ?? "",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                    Text(data['Floor_'] ?? "--",
                        style:
                        TextStyle(fontSize: 14, color: textMuted)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name: ${data['field_warkar_name'] ?? '--'}",
                        style: TextStyle(
                            fontSize: 14, color: textSecondary)),
                    Text("Location: ${data['locations'] ?? '--'}",
                        style: TextStyle(
                            fontSize: 14, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Meter: ${data['meter'] ?? '--'}",
                        style: TextStyle(
                            fontSize: 14, color: textSecondary)),
                    Text("Parking: ${data['parking'] ?? '--'}",
                        style: TextStyle(
                            fontSize: 15, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maintenance: ${data['maintance'] ?? '--'}",
                        style: TextStyle(
                            fontSize: 15, color: textSecondary)),
                    Text(
                        "ID: ${agreement?["property_id"] ?? '--'}",
                        style:
                        TextStyle(fontSize: 15, color: textMuted)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Top-level helpers ────────────────────────────────────────────────────────

Widget _statusCard({
  required String title,
  required String value,
  required bool isPositive,
  String? dateTime,
}) {
  String formattedTime = "";
  if (dateTime != null && dateTime.isNotEmpty) {
    try {
      final dt = DateTime.parse(dateTime).toLocal();
      formattedTime =
      "${dt.day.toString().padLeft(2, '0')} ${_monthName(dt.month)} ${dt.year}, ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
    } catch (_) {}
  }
  return Container(
    constraints: const BoxConstraints(minWidth: 160),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.grey),
      color: const Color(0xFF1E1E2C).withOpacity(0.9),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white)),
        const SizedBox(height: 6),
        Text(value,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isPositive ? Colors.green : Colors.red)),
        if (formattedTime.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(formattedTime,
              style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white,
                  fontStyle: FontStyle.italic)),
        ],
      ],
    ),
  );
}

String _monthName(int month) {
  const months = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun",
    "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
  return months[month - 1];
}

class ElevatedGradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const ElevatedGradientButton(
  {required this.text,
  required this.icon,
  required this.onPressed,
  super.key});

  @override
  Widget build(BuildContext context) {
  return GestureDetector(
  onTap: onPressed,
  child: Container(
  height: 48,
  decoration: BoxDecoration(
  gradient: const LinearGradient(
  colors: [Color(0xFF4CA1FF), Color(0xFF8A5CFF)]),
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
  BoxShadow(
  color: Colors.black.withOpacity(0.18),
  blurRadius: 16,
  offset: const Offset(0, 8))
  ],
  ),
  padding: const EdgeInsets.symmetric(horizontal: 18),
  child: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  Icon(icon, color: Colors.white),
  const SizedBox(width: 12),
  Text(text,
  style: const TextStyle(
  color: Colors.white, fontWeight: FontWeight.w600)),
  ],
  ),
  ),
  );
  }
  }