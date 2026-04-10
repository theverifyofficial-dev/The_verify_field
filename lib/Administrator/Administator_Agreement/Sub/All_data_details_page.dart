import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import '../../../model/Additional_agreement_tenants.dart';
import '../../imagepreviewscreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../PDFs/Commercial_PDF.dart';
import '../PDFs/PDF.dart';
import '../PDFs/furnished pdf.dart';

// ─────────────────────────────────────────────
//  Color theme per section
// ─────────────────────────────────────────────
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
  "Agreement Details": _SectionTheme(
    titleBg: const Color(0xFF7C3AED),
    titleText: Colors.white,
    borderColor: const Color(0xFF7C3AED),
    cardBg: const Color(0xFFF5F0FF),
    icon: Icons.description_outlined,
  ),
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
  "Field Worker": _SectionTheme(
    titleBg: const Color(0xFFB45309),
    titleText: Colors.white,
    borderColor: const Color(0xFFB45309),
    cardBg: const Color(0xFFFFFBEB),
    icon: Icons.engineering_outlined,
  ),
  "Property Address": _SectionTheme(
    titleBg: const Color(0xFF0369A1),
    titleText: Colors.white,
    borderColor: const Color(0xFF0369A1),
    cardBg: const Color(0xFFE0F2FE),
    icon: Icons.location_on_outlined,
  ),
};

final  Map<String, IconData> _fieldIcons = {
  // Agreement fields
  'BHK': Icons.home_outlined,
  'Floor': Icons.layers_outlined,
  'Rented Address': Icons.location_on_outlined,
  'Monthly Rent': Icons.currency_rupee,
  'Security': Icons.lock_outlined,
  'Installment Security': Icons.savings_outlined,
  'Meter': Icons.electric_meter_outlined,
  'Custom Unit': Icons.tune_outlined,
  'Maintenance': Icons.build_circle_outlined,
  'Parking': Icons.local_parking_outlined,
  'Shifting Date': Icons.calendar_today_outlined,
  'Agreement Price': Icons.receipt_long_outlined,
  'Notary Amount': Icons.verified_outlined,

  // Owner / Tenant / Director fields
  'Owner Name': Icons.person_outlined,
  'Tenant Name': Icons.person_outlined,
  'Director Name': Icons.person_outlined,
  'Relation': Icons.group_outlined,
  'Address': Icons.location_on_outlined,
  'Mobile': Icons.phone_outlined,
  'Aadhar': Icons.badge_outlined,
  'Company Name': Icons.business_outlined,
  'DOC Type': Icons.description_outlined,
  'DOC Number': Icons.numbers_outlined,
  'PAN Number': Icons.credit_card_outlined,

  // Field Worker
  'Name': Icons.engineering_outlined,
  'Number': Icons.phone_outlined,
};

// ─────────────────────────────────────────────
//  Main Page
// ─────────────────────────────────────────────
class AllDataDetailsPage extends StatefulWidget {
  final String agreementId;
  const AllDataDetailsPage({super.key, required this.agreementId});

  @override
  State<AllDataDetailsPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AllDataDetailsPage> {

  Map<String, dynamic>? agreement;
  bool isLoading = true;
  File? pdfFile;
  List<AdditionalTenant> additionalTenants = [];
  bool pdfGenerated = false;
  Widget? propertyCard;

  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  // ── Network calls ──────────────────────────

  Future<void> fetchPropertyCard() async {
    final propertyId = agreement?["property_id"];
    if (propertyId == null || propertyId.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Property ID not found")));
      return;
    }
    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/display_api_base_on_flat_id.php"),
        body: {"P_id": propertyId},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == "success") {
          setState(() => propertyCard = _propertyCard(json['data']));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(json['message'] ?? "Property not found")));
        }
      }
    } catch (e) {
      debugPrint("Error: $e");
    }
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
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/show_api_addional_tenant_final.php?agreement_id=$agreementId");
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
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/detail_page_main_agreement.php?id=${widget.agreementId}"));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["success"] == true &&
            decoded["data"] != null &&
            decoded["data"].isNotEmpty) {
          setState(() {
            agreement = Map<String, dynamic>.from(decoded["data"][0]);
            isLoading = false;
          });
          fetchPropertyCard();
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _handleGeneratePdf() async {
    if (agreement == null) return;
    final String type = (agreement!['agreement_type'] ?? '').toString().trim();
    setState(() => isLoading = true);
    try {
      File file;
      if (type == "Furnished Agreement") {
        file = await generateFurnishedAgreementPdf(agreement!);
      } else if (type == "Commercial Agreement") {
        file = await generateCommercialAgreementPdf(agreement!);
      } else {
        file = await generateAgreementPdf(agreement!);
      }
      setState(() {
        pdfFile = file;
        pdfGenerated = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: Colors.redAccent));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickAndUploadPoliceVerification() async {
    final result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      await _uploadDocument(File(result.files.single.path!),
          type: "police_verification_pdf");
    }
  }

  Future<void> _pickAndUploadNotaryImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SizedBox(
        height: 160,
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text("Choose Image Source",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.camera_alt, size: 28),
                  label: const Text("Camera"),
                  onPressed: () async {
                    Navigator.pop(context);
                    final picked = await ImagePicker()
                        .pickImage(source: ImageSource.camera, imageQuality: 90);
                    if (picked == null) return;
                    File original = File(picked.path);
                    XFile? compressedX =
                    await FlutterImageCompress.compressAndGetFile(
                      original.path,
                      "${original.path}_c1.jpg",
                      quality: 20,
                      minWidth: 800,
                      minHeight: 800,
                    );
                    if (compressedX == null) return;
                    File finalFile = File(compressedX.path);
                    int quality = 20;
                    while (await finalFile.length() > 150 * 1024 && quality > 5) {
                      quality -= 5;
                      XFile? retryX =
                      await FlutterImageCompress.compressAndGetFile(
                        finalFile.path,
                        "${finalFile.path}_retry.jpg",
                        quality: quality,
                      );
                      if (retryX == null) break;
                      finalFile = File(retryX.path);
                    }
                    await _uploadDocument(finalFile, type: "notry_img");
                  },
                ),
                TextButton.icon(
                  icon: const Icon(Icons.photo, size: 28),
                  label: const Text("Gallery"),
                  onPressed: () async {
                    Navigator.pop(context);
                    final picked = await ImagePicker().pickImage(
                        source: ImageSource.gallery, imageQuality: 90);
                    if (picked != null) {
                      await _uploadDocument(File(picked.path),
                          type: "notry_img");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadDocument(File file, {required String type}) async {
    if (!mounted) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));
    try {
      final request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/update_notry_and_police_verification.php"),
      );
      request.fields["id"] = widget.agreementId;
      if (type == "notry_img") {
        request.files
            .add(await http.MultipartFile.fromPath("notry_img", file.path));
      } else if (type == "police_verification_pdf") {
        request.files.add(await http.MultipartFile.fromPath(
            "police_verification_pdf", file.path));
      }
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(responseBody);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(data["message"] ?? "Upload successful"),
              backgroundColor: Colors.green));
          _fetchAgreementDetail();
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Response: $responseBody"),
              backgroundColor: Colors.orange));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Upload failed: ${response.statusCode}"),
            backgroundColor: Colors.redAccent));
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Error: $e"), backgroundColor: Colors.redAccent));
      }
    }
  }

  Future<void> _updatePaymentOfficeStatus(
      {int? payment, int? officeReceived}) async {
    try {
      final body = {"id": widget.agreementId};
      if (payment != null) {
        body["payment"] = payment.toString();
        body["payment_at"] = DateTime.now().toIso8601String();
      }
      if (officeReceived != null) {
        body["office_received"] = officeReceived.toString();
        body["office_received_at"] = DateTime.now().toIso8601String();
      }
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/update_payment_field.php"),
        body: body,
      );
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded["status"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Status updated successfully"),
              backgroundColor: Colors.green));
          _fetchAgreementDetail();
        } else {
          throw decoded["message"];
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Update failed: $e"),
          backgroundColor: Colors.redAccent));
    }
  }

  // ── Helpers ───────────────────────────────

  String? _formatDate(dynamic shiftingDate) {
    if (shiftingDate == null) return "";
    if (shiftingDate is Map && shiftingDate["date"] != null) {
      try {
        return DateTime.parse(shiftingDate["date"])
            .toLocal()
            .toString()
            .split(" ")[0];
      } catch (e) {
        return shiftingDate["date"].toString();
      }
    }
    if (shiftingDate is String && shiftingDate.isNotEmpty) return shiftingDate;
    return "";
  }

  _launchURL(String pdfUrl) async {
    final Uri url = Uri.parse(pdfUrl);
    if (!await launchUrl(url)) throw Exception('Could not launch $url');
  }

  // ── Reusable widgets ───────────────────────

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
              offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(iconData, size: 14, color: Colors.grey[600]),
          // Text('$k',
          //   style: TextStyle(
          //       fontSize: 13,
          //       fontWeight: FontWeight.w100,
          //       color: isDark ? Colors.black87 : Colors.black87),
          // ),
          const SizedBox(width: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w100,
                  color: isDark ? Colors.black87 : Colors.black87),
              softWrap: true),

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

  void _showDocumentActionSheet({
    required String title,
    required VoidCallback onView,
    required VoidCallback onUpdate,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, -4))
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 18),
                decoration: BoxDecoration(
                    color: Colors.grey.shade500,
                    borderRadius: BorderRadius.circular(10)),
              ),
              Row(
                children: [
                  const Icon(Icons.description, size: 26),
                  const SizedBox(width: 12),
                  Expanded(
                      child: Text(title,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                      child: _actionButton(
                          icon: Icons.visibility_outlined,
                          label: "View",
                          color: Colors.blue,
                          onTap: () {
                            Navigator.pop(context);
                            onView();
                          })),
                  const SizedBox(width: 16),
                  Expanded(
                      child: _actionButton(
                          icon: Icons.edit_outlined,
                          label: "Update",
                          color: Colors.orange,
                          onTap: () {
                            Navigator.pop(context);
                            onUpdate();
                          })),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  // ── Build ──────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool isPolice =
        agreement?["agreement_type"] == "Police Verification";
    final withPolice =
        agreement?['is_Police']?.toString() == "true";
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bool paymentDone = agreement?["payment"]?.toString() == "1";
    final bool officeReceived =
        agreement?["office_received"]?.toString() == "1";

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (agreement == null) {
      return const Scaffold(body: Center(child: Text("No details found")));
    }

    final D_or_T = agreement?["agreement_type"] == "Commercial Agreement"
        ? "Director"
        : "Tenant";

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 70),
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
            const SizedBox(height: 10),

            // ── Status cards ──
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statusCard(
                    title: "Payment Status",
                    value: paymentDone ? "Paid" : "Pending",
                    isPositive: paymentDone,
                    dateTime: agreement?["payment_at"]),
                _statusCard(
                    title: "Office Received",
                    value: officeReceived ? "Delivered" : "Not Delivered",
                    isPositive: officeReceived,
                    dateTime: agreement?["office_received_at"]),
              ],
            ),


            const SizedBox(height: 20),

            // ── Police note ──
            if (withPolice)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent)),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Colors.redAccent),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Note: Police verification must be created by Admin for this agreement.',
                        style: TextStyle(
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            if (propertyCard != null) propertyCard!,

            // ── Horizontal cards ──
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agreement Details card
                  if (!isPolice)
                    _buildCard(
                      title: "Agreement Details",
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _kvCompact("BHK", agreement?["Bhk"] ?? "", Icons.home),
                            ),
                            Expanded(
                              child: _kvCompact("Floor", agreement?["floor"] ?? "", Icons.layers),
                            ),
                          ],
                        ),

                        _hk("Rented Address", agreement?["rented_address"]),
                        _kvAmount("Monthly Rent", agreement?["monthly_rent"]),
                        _kCompact("Maintenance", agreement?["maintaince"]),
                        _vkCompact("Security", agreement?["securitys"]),
                        _vkCompact("Installment Security",
                            agreement?["installment_security_amount"]),
                        _kv(
                            "Meter", agreement?["meter"]),
                        _vAmount(
                            "Custom Unit", agreement?["custom_meter_unit"]),
                        _kv("Parking", agreement?["parking"]),
                        _kvHighlight("Shifting Date", _formatDate(agreement?["shifting_date"]) ?? ""),
                        _furnitureList(agreement!['furniture']),
                        const Divider(height: 20),
                        // Cost section inside card
                        Row(
                          children: [
                            Expanded(
                              child: _hkCompact("Agreement Price", agreement?["agreement_price"] ?? "", Icons.home),
                            ),
                            Expanded(
                              child: _hkCompact("Notary", agreement?["notary_price"] ?? "", Icons.layers),
                            ),
                          ],
                        ),
                      ],
                    ),

                  // Owner Details card
                  Column(
                    children: [
                      _buildCard(
                        title: "Owner Details",
                        children: [
                          _kvRow("Owner Name", agreement?["owner_name"],
                              "Relation", "${agreement?["owner_relation"] ?? ""} ${agreement?["relation_person_name_owner"] ?? ""}"),
                          _kvFull("Address", agreement?["parmanent_addresss_owner"]),
                          _kvRow("Mobile", agreement?["owner_mobile_no"],
                              "Aadhar", agreement?["owner_addhar_no"]),
                          const SizedBox(height: 8),
                          Row(children: [
                            _docImage(agreement?["owner_aadhar_front"]),
                            _docImage(agreement?["owner_aadhar_back"]),
                          ]),
                        ],
                      ),
                    ],
                  ),

                  // Tenant / Director card
                  Column(
                    children: [
                      _buildCard(
                        title: "$D_or_T Details",
                        children: [
                          _kvRow("$D_or_T Name", agreement?["tenant_name"],
                              "Relation", "${agreement?["tenant_relation"] ?? ""} ${agreement?["relation_person_name_tenant"] ?? ""}"),
                          _kvFull("Address", agreement?["permanent_address_tenant"]),
                          _kvRow("Mobile", agreement?["tenant_mobile_no"],
                              "Aadhar", agreement?["tenant_addhar_no"]),

                          if (agreement!["agreement_type"] == "Commercial Agreement") ...[
                            const Divider(),
                            _kvRow("Company Name", agreement!["company_name"],
                                "DOC Type", agreement!["gst_type"]),
                            _kvRow("DOC Number", agreement!["gst_no"],
                                "PAN Number", agreement!["pan_no"]),
                            const SizedBox(height: 8),
                            Row(children: [
                              _docImage(agreement?["gst_photo"]),
                              _docImage(agreement?["pan_photo"]),
                            ]),
                          ],

                          const SizedBox(height: 8),
                          Row(children: [
                            _docImage(agreement?["tenant_aadhar_front"]),
                            _docImage(agreement?["tenant_aadhar_back"]),
                            _docImage(agreement?["tenant_image"]),
                          ]),
                        ],
                      ),
                    ],
                  ),

// Additional Tenant / Director card
                  if (additionalTenants.isNotEmpty)
                    Column(
                      children: [
                        _buildCard(
                          title: "Additional $D_or_T",
                          children: additionalTenants.map((t) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _kvRow("$D_or_T Name", t.name,
                                    "Relation", "${t.relation} ${t.relation_name}"),
                                _kvFull("Address", agreement?["permanent_address_tenant"]),
                                _kvRow("Mobile", t.mobile,
                                    "Aadhar", t.aadhaar),
                                const SizedBox(height: 6),
                                Row(children: [
                                  _docImage(t.front),
                                  _docImage(t.back),
                                  _docImage(t.photo),
                                ]),
                                const Divider(),
                              ],
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            // ── Police address ──
            if (isPolice)
              _sectionCard(
                title: "Property Address",
                children: [
                  _kv("Rented Address", agreement?["rented_address"]),
                ],
              ),

            // ── Field Worker ──
            _sectionCard(
              title: "Field Worker",
              children: [
                _kv("Name", agreement!["Fieldwarkarname"]),
                _kv("Number", agreement!["Fieldwarkarnumber"]),
              ],
            ),

            const SizedBox(height: 20),

            // ── PDF tile ──
            if (!isPolice && pdfFile != null) ...[
              _glassContainer(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(pdfFile!.path.split('/').last),
                  subtitle: const Text("Tap to open"),
                  onTap: () async => await OpenFilex.open(pdfFile!.path),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // ── Police & Notary buttons ──
            Row(
              children: [
                Expanded(
                  child: _pillButton(
                    label: (agreement?["police_verification_pdf"] == null ||
                        agreement!["police_verification_pdf"].toString().isEmpty)
                        ? 'Add P. Verification'
                        : 'View P. Verification',
                    icon: Icons.verified_user_outlined,
                    colors: (agreement?["police_verification_pdf"] == null ||
                        agreement!["police_verification_pdf"].toString().isEmpty)
                        ? [const Color(0xFF6B7280), const Color(0xFF4B5563)]
                        : [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                    onPressed: () {
                      final pdf = agreement?["police_verification_pdf"];
                      if (pdf == null || pdf.toString().isEmpty) {
                        _pickAndUploadPoliceVerification();
                      } else {
                        _showDocumentActionSheet(
                          title: "Police Verification",
                          onView: () => _launchURL(
                              'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$pdf'),
                          onUpdate: _pickAndUploadPoliceVerification,
                        );
                      }
                    },
                  ),
                ),
                if (!isPolice) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pillButton(
                      label: (agreement?["notry_img"] == null ||
                          agreement!["notry_img"].toString().isEmpty)
                          ? 'Add Notary'
                          : 'View Notary',
                      icon: Icons.edit_document,
                      colors: (agreement?["notry_img"] == null ||
                          agreement!["notry_img"].toString().isEmpty)
                          ? [const Color(0xFF6B7280), const Color(0xFF4B5563)]
                          : [const Color(0xFFEF4444), const Color(0xFFDC2626)],
                      onPressed: () {
                        final notary = agreement?["notry_img"];
                        if (notary == null || notary.toString().isEmpty) {
                          _pickAndUploadNotaryImage();
                        } else {
                          _showDocumentActionSheet(
                            title: "Notary Document",
                            onView: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ImagePreviewScreen(
                                        imageUrl:
                                        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$notary'))),
                            onUpdate: _pickAndUploadNotaryImage,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // ── Payment & Office buttons ──
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
                      label: paymentDone ? "Payment Done" : "Mark Payment",
                      icon: paymentDone
                          ? Icons.check_circle_outline
                          : Icons.payment_outlined,
                      colors: paymentDone
                          ? [const Color(0xFF16A34A), const Color(0xFF15803D)]
                          : [const Color(0xFFF97316), const Color(0xFFEA580C)],
                      onPressed: paymentDone
                          ? null
                          : () => _updatePaymentOfficeStatus(payment: 1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pillButton(
                      label: officeReceived ? "Office Received" : "Mark Received",
                      icon: officeReceived
                          ? Icons.check_circle_outline
                          : Icons.store_outlined,
                      colors: officeReceived
                          ? [const Color(0xFF16A34A), const Color(0xFF15803D)]
                          : [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
                      onPressed: officeReceived
                          ? null
                          : () => _updatePaymentOfficeStatus(officeReceived: 1),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── View Agreement + Generate PDF ──
            if (!isPolice)
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
                        label: "View\nAgreement",
                        icon: Icons.remove_red_eye_outlined,
                        colors: const [Color(0xFF1F2937), Color(0xFF374151)],
                        textColor: const Color(0xFF60A5FA),
                        iconColor: const Color(0xFF60A5FA),
                        borderColor: const Color(0xFF374151),
                        onPressed: () => _launchURL(
                            'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/${agreement?["agreement_pdf"]}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _pillButton(
                        label: "Generate\nPDF",
                        icon: Icons.picture_as_pdf_outlined,
                        colors: const [Color(0xFF4ADE80), Color(0xFF22C55E)],
                        textColor: const Color(0xFF14532D),
                        iconColor: const Color(0xFF14532D),
                        onPressed: _handleGeneratePdf,
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

  // ── Cost row widget (inside Agreement Details card) ──────────────────────

  // ── Property Card ─────────────────────────────────────────────────────────
  Widget _propertyCard(Map<String, dynamic> data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";

    final Color textPrimary = isDark ? Colors.white : Colors.black87;
    final Color textSecondary = isDark ? Colors.grey[300]! : Colors.grey[700]!;
    final Color textMuted = isDark ? Colors.grey[400]! : Colors.grey[600]!;

    return Card(
      color: isDark ? Colors.white : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 200,
                color: Colors.grey[200],
                alignment: Alignment.center,
                child: const Text("No Image",
                    style: TextStyle(color: Colors.black54)),
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
                        style: TextStyle(fontSize: 14, color: textMuted)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name: ${data['field_warkar_name'] ?? '--'}",
                        style: TextStyle(fontSize: 14, color: textSecondary)),
                    Text("Location: ${data['locations'] ?? '--'}",
                        style: TextStyle(fontSize: 14, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Meter: ${data['meter'] ?? '--'}",
                        style: TextStyle(fontSize: 14, color: textSecondary)),
                    Text("Parking: ${data['parking'] ?? '--'}",
                        style: TextStyle(fontSize: 15, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maintenance: ${data['maintance'] ?? '--'}",
                        style: TextStyle(fontSize: 15, color: textSecondary)),
                    Text("ID: ${agreement?["property_id"] ?? '--'}",
                        style: TextStyle(fontSize: 15, color: textMuted)),
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

// ─────────────────────────────────────────────
//  Top-level helpers (same file)
// ─────────────────────────────────────────────

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
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white)),
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

Widget _actionButton({
  required IconData icon,
  required String label,
  required Color color,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(label,
              style: TextStyle(fontWeight: FontWeight.w600, color: color)),
        ],
      ),
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
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}