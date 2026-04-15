import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../AppLogger.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image/image.dart' as img;
import '../../../Custom_Widget/Custom_backbutton.dart';
import '../../../model/Additional_agreement_tenants.dart';
import '../../imagepreviewscreen.dart';
import '../PDFs/Commercial_PDF.dart';
import '../PDFs/PDF.dart';
import '../PDFs/furnished pdf.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

// ─── Custom Clause Model ──────────────────────────────────────────────────────
class CustomClause {
  final TextEditingController titleCtrl;
  final TextEditingController subtitleCtrl;

  CustomClause()
      : titleCtrl = TextEditingController(),
        subtitleCtrl = TextEditingController();

  void dispose() {
    titleCtrl.dispose();
    subtitleCtrl.dispose();
  }

  Map<String, String> toMap() => {
    'title': titleCtrl.text.trim(),
    'subtitle': subtitleCtrl.text.trim(),
  };
}

// ─── Section color themes ─────────────────────────────────────────────────────
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

// ─── Field icons ──────────────────────────────────────────────────────────────
final Map<String, IconData> _fieldIcons = {
  'BHK': Icons.home_outlined,
  'Sqft': Icons.square_foot,
  'Floor': Icons.layers_outlined,
  'Rented Address': Icons.location_on_outlined,
  'Property Address': Icons.location_on_outlined,
  'Monthly Rent': Icons.currency_rupee,
  'Security': Icons.lock_outlined,
  'Installment Security': Icons.savings_outlined,
  'Meter': Icons.electric_meter_outlined,
  'Custom Unit': Icons.tune_outlined,
  'Maintenance': Icons.build_circle_outlined,
  'Maintenance Amount': Icons.build_circle_outlined,
  'Parking': Icons.local_parking_outlined,
  'Shifting Date': Icons.calendar_today_outlined,
  'Agreement Price': Icons.receipt_long_outlined,
  'Notary Amount': Icons.verified_outlined,
  'Owner Name': Icons.person_outlined,
  'Tenant Name': Icons.person_outlined,
  'Director Name': Icons.person_outlined,
  'Relation': Icons.group_outlined,
  'Address': Icons.location_on_outlined,
  'Mobile': Icons.phone_outlined,
  'Aadhar': Icons.badge_outlined,
  'Aadhaar': Icons.badge_outlined,
  'Company Name': Icons.business_outlined,
  'DOC Type': Icons.description_outlined,
  'DOC Number': Icons.numbers_outlined,
  'PAN Number': Icons.credit_card_outlined,
  'Name': Icons.engineering_outlined,
  'Number': Icons.phone_outlined,
};

// ─── Main Widget ──────────────────────────────────────────────────────────────
class AcceptedDetails extends StatefulWidget {
  final String agreementId;
  const AcceptedDetails({super.key, required this.agreementId});

  @override
  State<AcceptedDetails> createState() => _AcceptedDetailsState();
}

class _AcceptedDetailsState extends State<AcceptedDetails> {
  // ── State ──────────────────────────────────────────────────────────────────
  Map<String, dynamic>? agreement;
  bool isLoading = true;
  File? pdfFile;
  bool pdfGenerated = false;
  File? policeVerificationFile;
  File? notaryImageFile;
  File? gstPhoto;
  File? panPhoto;
  List<AdditionalTenant> additionalTenants = [];
  Widget? propertyCard;
  bool isCompressing = false;
  String compressedSizeText = "";
  final List<CustomClause> _customClauses = [];

  // ── Lifecycle ──────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _loadAllData();
  }

  @override
  void dispose() {
    for (final c in _customClauses) {
      c.dispose();
    }
    super.dispose();
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

  Future<void> fetchAdditionalTenants(String agreementId) async {
    final url = Uri.parse(
        "http://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/show_api_addional_tenant_accept.php?agreement_id=$agreementId");
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
    if (propertyId == null || propertyId.toString().isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/display_api_base_on_flat_id.php"),
        body: {"P_id": propertyId.toString()},
      );
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        if (json['status'] == "success") {
          setState(() => propertyCard = _buildPropertyCard(json['data']));
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(json['message'] ?? "Property not found")));
          }
        }
      }
    } catch (e) {
      debugPrint("fetchPropertyCard error: $e");
    }
  }

  Future<void> _fetchAgreementDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/details_api_for_accect_agreement.php?id=${widget.agreementId}"));
      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["success"] == true &&
            decoded["data"] != null &&
            (decoded["data"] as List).isNotEmpty) {
          setState(() {
            agreement = Map<String, dynamic>.from(decoded["data"][0]);
          });
          fetchPropertyCard();
        }
      }
    } catch (e) {
      debugPrint("_fetchAgreementDetail error: $e");
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────
  String _formatDate(dynamic shiftingDate) {
    if (shiftingDate == null) return "";
    try {
      DateTime date;
      if (shiftingDate is Map && shiftingDate["date"] != null) {
        date = DateTime.parse(shiftingDate["date"]);
      } else if (shiftingDate is String && shiftingDate.isNotEmpty) {
        date = DateTime.parse(shiftingDate);
      } else {
        return "";
      }
      return DateFormat('dd MMM yyyy').format(date.toLocal());
    } catch (_) {
      return "";
    }
  }

  Future<File> compressImageTo150KB(File file) async {
    try {
      final int originalKB = file.lengthSync() ~/ 1024;
      AppLogger.api("📸 BEFORE Compress: $originalKB KB");

      final Uint8List bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        AppLogger.api("❌ Could not decode image");
        return file;
      }

      int quality = 90;
      int width = image.width;
      File compressed = file;

      while (true) {
        final img.Image resized = img.copyResize(image, width: width);
        final List<int> jpgBytes = img.encodeJpg(resized, quality: quality);
        final File temp =
        File("${file.path}_${DateTime.now().millisecondsSinceEpoch}.jpg");
        await temp.writeAsBytes(jpgBytes);
        final int sizeKB = temp.lengthSync() ~/ 1024;
        AppLogger.api("🔄 Width=$width | Quality=$quality | Size=$sizeKB KB");

        if (sizeKB <= 150) {
          compressed = temp;
          break;
        }
        quality -= 10;
        width = (width * 0.85).toInt();
        if (quality < 10 || width < 300) {
          compressed = temp;
          break;
        }
      }

      AppLogger.api("📦 AFTER Compress: ${compressed.lengthSync() ~/ 1024} KB");
      return compressed;
    } catch (e) {
      AppLogger.api("❌ Compress Error: $e");
      return file;
    }
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _submitAll() async {
    if (agreement == null) return;
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final uri = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/insert.php");
      final request = http.MultipartRequest('POST', uri);
      request.headers['Accept'] = 'application/json';
      final bool isPolice =
          agreement?["agreement_type"] == "Police Verification";

      final fields = <String, String>{
        "accept_delete_id": widget.agreementId,
        "owner_name": agreement?["owner_name"] ?? "",
        "owner_relation": agreement?["owner_relation"] ?? "",
        "relation_person_name_owner":
        agreement?["relation_person_name_owner"] ?? "",
        "parmanent_addresss_owner": agreement?["parmanent_addresss_owner"] ?? "",
        "owner_mobile_no": agreement?["owner_mobile_no"] ?? "",
        "owner_addhar_no": agreement?["owner_addhar_no"] ?? "",
        "tenant_name": agreement?["tenant_name"] ?? "",
        "tenant_relation": agreement?["tenant_relation"] ?? "",
        "relation_person_name_tenant":
        agreement?["relation_person_name_tenant"] ?? "",
        "permanent_address_tenant": agreement?["permanent_address_tenant"] ?? "",
        "tenant_mobile_no": agreement?["tenant_mobile_no"] ?? "",
        "tenant_addhar_no": agreement?["tenant_addhar_no"] ?? "",
        "Bhk": agreement?["Bhk"] ?? "",
        "floor": agreement?["floor"] ?? "",
        "rented_address": agreement?["rented_address"] ?? "",
        "monthly_rent": agreement?["monthly_rent"] ?? "",
        "securitys": agreement?["securitys"] ?? "",
        "installment_security_amount":
        agreement?["installment_security_amount"] ?? "",
        "meter": agreement?["meter"] ?? "",
        "custom_meter_unit": agreement?["custom_meter_unit"] ?? "",
        "shifting_date": agreement?["shifting_date"]?.toString() ?? "",
        "maintaince": agreement?["maintaince"] ?? "",
        "custom_maintenance_charge":
        agreement?["custom_maintenance_charge"] ?? "",
        "parking": agreement?["parking"] ?? "",
        "current_dates": DateTime.now().toIso8601String(),
        "Fieldwarkarname": agreement?["Fieldwarkarname"] ?? "",
        "Fieldwarkarnumber": agreement?["Fieldwarkarnumber"] ?? "",
        "property_id": agreement?["property_id"] ?? "",
        "agreement_type": agreement?["agreement_type"] ?? "",
        if (agreement?["agreement_type"] == "Commercial Agreement") ...{
          "company_name": agreement?["company_name"] ?? "",
          "gst_type": agreement?["gst_type"] ?? "",
          "gst_no": agreement?["gst_no"] ?? "",
          "pan_no": agreement?["pan_no"] ?? "",
          "Sqft": agreement?["Sqft"] ?? "",
        },
        "furniture": agreement?["furniture"] ?? "",
        "agreement_price": agreement?["agreement_price"] ?? "",
        "notary_price": agreement?["notary_price"] ?? "",
        "is_Police": agreement?["is_Police"] ?? "",
      };

      fields.forEach((k, v) {
        if (v.trim().isNotEmpty) request.fields[k] = v.trim();
      });

      Future<void> attachFile(String key, File? file) async {
        if (file == null) return;
        final mime = lookupMimeType(file.path) ?? "application/octet-stream";
        final parts = mime.split("/");
        request.files.add(await http.MultipartFile.fromPath(
          key,
          file.path,
          contentType: MediaType(parts[0], parts[1]),
        ));
      }

      Future<File?> downloadIfNeeded(String? imgPath, String name) async {
        if (imgPath == null || imgPath.isEmpty) return null;
        final url =
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$imgPath";
        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) return null;
        final file = File("${Directory.systemTemp.path}/$name");
        return file.writeAsBytes(response.bodyBytes);
      }

      final ownerFront = await downloadIfNeeded(
          agreement?["owner_aadhar_front"], "owner_front.jpg");
      final ownerBack = await downloadIfNeeded(
          agreement?["owner_aadhar_back"], "owner_back.jpg");
      final tenantFront = await downloadIfNeeded(
          agreement?["tenant_aadhar_front"], "tenant_front.jpg");
      final tenantBack = await downloadIfNeeded(
          agreement?["tenant_aadhar_back"], "tenant_back.jpg");
      final tenantImg =
      await downloadIfNeeded(agreement?["tenant_image"], "tenant_img.jpg");

      if (agreement?["agreement_type"] == "Commercial Agreement") {
        gstPhoto =
        await downloadIfNeeded(agreement?["gst_photo"], "gst_photo.jpg");
        panPhoto =
        await downloadIfNeeded(agreement?["pan_photo"], "pan_photo.jpg");
        await attachFile("gst_photo", gstPhoto);
        await attachFile("pan_photo", panPhoto);
      }

      if (isPolice) {
        if (policeVerificationFile == null) {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Upload Police Verification PDF")),
            );
          }
          return;
        }
        await attachFile("police_verification_pdf", policeVerificationFile);
        await attachFile("owner_aadhar_front", ownerFront);
        await attachFile("owner_aadhar_back", ownerBack);
        await attachFile("tenant_aadhar_front", tenantFront);
        await attachFile("tenant_aadhar_back", tenantBack);
        await attachFile("tenant_image", tenantImg);
      } else {
        await attachFile("police_verification_pdf", policeVerificationFile);
        await attachFile("notry_img", notaryImageFile);
        await attachFile("agreement_pdf", pdfFile);
        await attachFile("owner_aadhar_front", ownerFront);
        await attachFile("owner_aadhar_back", ownerBack);
        await attachFile("tenant_aadhar_front", tenantFront);
        await attachFile("tenant_aadhar_back", tenantBack);
        await attachFile("tenant_image", tenantImg);
      }

      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (!mounted) return;

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Submitted successfully!")));
        Navigator.pop(context); // close loading dialog
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submit failed (${response.statusCode})")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {}
      }
    }
  }

  // ── PDF Generation ─────────────────────────────────────────────────────────
  Future<void> _handleGeneratePdf() async {
    if (agreement == null) return;

    final String type = (agreement!['agreement_type'] ?? '').toString().trim();
    setState(() => isLoading = true);
    try {
      final List<Map<String, String>> clausesData =
      _customClauses.map((c) => c.toMap()).toList();

      AppLogger.api('🧾 [PDF] Total custom clauses: ${clausesData.length}');

      final File file;
      if (type == "Furnished Agreement") {
        file = await generateFurnishedAgreementPdf(agreement!);
      } else if (type == "Commercial Agreement" ||
          type == "External Commercial Agreement") {
        file = await generateCommercialAgreementPdf(agreement!);
      } else {
        file = await generateAgreementPdf(
          agreement!,
          customClauses: clausesData,
        );
      }

      setState(() {
        pdfFile = file;
        pdfGenerated = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: Colors.redAccent,
        ));
      }
      AppLogger.api("PDF Generation Error: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ── Notary picker ──────────────────────────────────────────────────────────
  void _showNotaryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SizedBox(
        height: 160,
        child: Column(children: [
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
                  final picked = await ImagePicker().pickImage(
                      source: ImageSource.camera, imageQuality: 90);
                  if (picked != null) {
                    setState(() => isCompressing = true);
                    final File f =
                    await compressImageTo150KB(File(picked.path));
                    final int sizeKB = f.lengthSync() ~/ 1024;
                    setState(() {
                      notaryImageFile = f;
                      isCompressing = false;
                      compressedSizeText = "Size: ${sizeKB}KB";
                    });
                  }
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
                    setState(() => isCompressing = true);
                    final File f =
                    await compressImageTo150KB(File(picked.path));
                    final int sizeKB = f.lengthSync() ~/ 1024;
                    setState(() {
                      notaryImageFile = f;
                      isCompressing = false;
                      compressedSizeText = "Size: ${sizeKB}KB";
                    });
                  }
                },
              ),
            ],
          ),
        ]),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  UI Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Glass container (plain white card)
  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: const Color(0xFFC2410C)
                .withOpacity(0.3), width: 1.2),
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

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85, // 🔥 responsive
      margin: const EdgeInsets.only(right: 20),
      child: _sectionCard(title: title, children: children),
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

  // Pill-shaped button
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
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: borderColor == null
                ? LinearGradient(
              colors: isDisabled
                  ? [
                Colors.grey.shade600,
                Colors.grey.shade700
              ]
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
                  offset: const Offset(0, 4))
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
                      height: 1.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Section builders
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildMainTopSections(String D_or_T) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (agreement!["agreement_type"] != "Police Verification")
            Column(
              children: [
                SizedBox(width: 400, child: _buildAgreementCard()),
                SizedBox(width: 400, child: _buildOwnerCard()),
              ],
            ),
          const SizedBox(width: 20),
          SizedBox(width: 400, child: _buildTenantCard(D_or_T)),
        ],
      ),
    );
  }

  Widget _buildAgreementCard() {
    final bool isCommercial =
        agreement?["agreement_type"] == "Commercial Agreement";
    return _buildCard(
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
              child: _hkCompact("Cost", agreement?["agreement_price"] ?? "", Icons.home),
            ),
            Expanded(
              child: _hkCompact("Notary", agreement?["notary_price"] ?? "", Icons.layers),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOwnerCard() {
    return _sectionCard(
      title: "Owner Details",
      children: [
        _kvRow("Owner Name", agreement?["owner_name"], "Relation",
            "${agreement?["owner_relation"] ?? ""} ${agreement?["relation_person_name_owner"] ?? ""}"),
        _kvFull("Address", agreement?["parmanent_addresss_owner"]),
        _kvRow("Mobile", agreement?["owner_mobile_no"], "Aadhar",
            agreement?["owner_addhar_no"]),
        const SizedBox(height: 8),
        Row(children: [
          _docImage(agreement?["owner_aadhar_front"]),
          _docImage(agreement?["owner_aadhar_back"]),
        ]),
      ],
    );
  }

  Widget _buildTenantCard(String D_or_T) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark; // ← ADD
    return _sectionCard(
      title: "$D_or_T Details",
      children: [
        _kvRow("$D_or_T Name", agreement?["tenant_name"],
        "Relation",
            "${agreement?["tenant_relation"] ?? ""} ${agreement?["relation_person_name_tenant"] ?? ""}"),
        _kvFull("Address", agreement?["permanent_address_tenant"]),
        _kvRow("Mobile", agreement?["tenant_mobile_no"],
        "Aadhar", agreement?["tenant_addhar_no"]),
        if (agreement!["agreement_type"] == "Commercial Agreement") ...[
          const Divider(),
          _kvRow("Company Name", agreement!["company_name"],
          "DOC Type", agreement!["gst_type"]),
          _kvRow("DOC Number", agreement!["gst_no"],
          "PAN Number", agreement!["pan_no"]),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          children: [
            _docImage(agreement?["tenant_aadhar_front"]),
            _docImage(agreement?["tenant_aadhar_back"]),
            _docImage(agreement?["tenant_image"]),
            if (agreement!["agreement_type"] == "Commercial Agreement") ...[
              _docImage(agreement?["gst_photo"]),
              _docImage(agreement?["pan_photo"]),
            ],
          ],
        ),

    if (additionalTenants.isNotEmpty) ...[
      const Divider(height: 24),
      Text("Additional $D_or_T",
          style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFFC2410C))), // ← white in dark
      const SizedBox(height: 10),
      ...List.generate(additionalTenants.length, (index) {
        final t = additionalTenants[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _glassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("$D_or_T ${index + 2}",
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                       color: Color(0xFFC2410C))), // ← fix
                const SizedBox(height: 8),
                _kvRow("Name", t.name, "Relation", "${t.relation} ${t.relation_name}"),
                _kvFull("Address", t.address),
                _kvRow("Mobile", t.mobile, "Aadhaar", t.aadhaar),
                const SizedBox(height: 8),
                Wrap(children: [
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

  // ─── Custom Clauses UI ────────────────────────────────────────────────────
  Widget _buildCustomClausesSection() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.playlist_add_rounded,
                color: Colors.indigo, size: 22),
            const SizedBox(width: 8),
            const Expanded(
              child: Text("Add Custom Clauses",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            GestureDetector(
              onTap: () => setState(() => _customClauses.add(CustomClause())),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: const Row(
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 18),
                    SizedBox(width: 4),
                    Text("Add",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (_customClauses.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[850] : Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.indigo.shade100, width: 1),
            ),
            child: Column(
              children: [
                Icon(Icons.note_add_outlined,
                    color: Colors.indigo.shade200, size: 36),
                const SizedBox(height: 8),
                Text(
                  "No custom clauses added yet.\nTap + Add to insert one.",
                  textAlign: TextAlign.center,
                  style:
                  TextStyle(color: Colors.indigo.shade300, fontSize: 13),
                ),
              ],
            ),
          )
        else
          ...List.generate(_customClauses.length,
                  (index) => _buildClauseCard(index, _customClauses[index], isDark)),
      ],
    );
  }

  Widget _buildClauseCard(int index, CustomClause clause, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: isDark ? Colors.indigo.shade700 : Colors.indigo.shade200,
            width: 1.2),
        boxShadow: [
          BoxShadow(
              color: Colors.indigo.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(6)),
                child: Text("Clause ${index + 1}",
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 12)),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() {
                  _customClauses[index].dispose();
                  _customClauses.removeAt(index);
                }),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: const Icon(Icons.delete_outline,
                      color: Colors.red, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _clauseFieldLabel("Title  (Bold in PDF)", isDark),
          const SizedBox(height: 6),
          _clauseTextField(clause.titleCtrl, "e.g. Pet Policy", isDark,
              maxLines: 1,
              bold: true),
          const SizedBox(height: 10),
          _clauseFieldLabel("Subtitle  (Normal text in PDF)", isDark),
          const SizedBox(height: 6),
          _clauseTextField(clause.subtitleCtrl,
              "e.g. No pets allowed without written permission...", isDark),
        ],
      ),
    );
  }

  Text _clauseFieldLabel(String label, bool isDark) => Text(label,
      style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.grey[300] : Colors.grey[700]));

  Widget _clauseTextField(
      TextEditingController ctrl,
      String hint,
      bool isDark, {
        int maxLines = 3,
        bool bold = false,
      }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: TextStyle(
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          fontSize: bold ? 14 : 13),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[400]),
        filled: true,
        fillColor: isDark ? Colors.grey[850] : Colors.grey.shade50,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.indigo.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.indigo, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
              color: isDark ? Colors.grey[600]! : Colors.grey.shade300),
        ),
      ),
    );
  }

  // ── Property Card ──────────────────────────────────────────────────────────
  Widget _buildPropertyCard(Map<String, dynamic> data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";
    final Color textPrimary = isDark ? Colors.white : Colors.black87;
    final Color textSecondary =
    isDark ? Colors.grey[400]! : Colors.grey[700]!;

    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      shape:
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
                child: Text("No Image",
                    style: TextStyle(color: textSecondary)),
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
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.greenAccent.shade200
                                : Colors.green)),
                    Text(data['Bhk'] ?? "",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: textPrimary)),
                    Text(data['Floor_'] ?? "--",
                        style:
                        TextStyle(fontSize: 14, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name: ${data['field_warkar_name'] ?? '--'}",
                        style:
                        TextStyle(fontSize: 14, color: textSecondary)),
                    Text("Location: ${data['locations'] ?? '--'}",
                        style:
                        TextStyle(fontSize: 14, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Meter: ${data['meter'] ?? '--'}",
                        style:
                        TextStyle(fontSize: 14, color: textSecondary)),
                    Text("Parking: ${data['parking'] ?? '--'}",
                        style:
                        TextStyle(fontSize: 15, color: textSecondary)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maintenance: ${data['maintance'] ?? '--'}",
                        style:
                        TextStyle(fontSize: 15, color: textSecondary)),
                    Text("ID: ${agreement?["property_id"] ?? '--'}",
                        style:
                        TextStyle(fontSize: 15, color: textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  Build
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }
    if (agreement == null) {
      return const Scaffold(body: Center(child: Text("No details found")));
    }

    final bool isPolice =
        agreement?["agreement_type"] == "Police Verification";
    final bool withPolice =
        agreement?['is_Police']?.toString() == "true";
    final String D_or_T =
    agreement?["agreement_type"] == "Commercial Agreement"
        ? "Director"
        : "Tenant";

    // Compute police tenants
    final List<int> policeTenants = [];
    if (agreement?['is_Police']?.toString().toLowerCase() == "true") {
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Agreement type badge
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

            // Property card
            if (propertyCard != null) propertyCard!,

            // Main scrollable cards
            _buildMainTopSections(D_or_T),

            const SizedBox(height: 20),

            if (policeTenants.isNotEmpty)
              _buildPoliceNotice(policeTenants),

            const SizedBox(height: 20),

            if (isPolice)
              _sectionCard(
                title: "Property Residential Address",
                children: [
                  _kv("Property Address", agreement!["rented_address"]),
                ],
              ),

            _sectionCard(
              title: "Field Worker",
              children: [
                _kv("Name", agreement?["Fieldwarkarname"]),
                _kv("Number", agreement?["Fieldwarkarnumber"]),
              ],
            ),

            const SizedBox(height: 24),

            // Custom clauses (only for non-police)
            if (!isPolice) ...[
              _buildCustomClausesSection(),
              const SizedBox(height: 24),
            ],

            // Upload buttons
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final result = await FilePicker.platform
                            .pickFiles(type: FileType.any);
                        if (result != null &&
                            result.files.single.path != null) {
                          setState(() => policeVerificationFile =
                              File(result.files.single.path!));
                        }
                      },
                      icon: const Icon(Icons.upload_sharp,
                          color: Colors.white),
                      label: const Text("P. Verification",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                if (!isPolice)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 8),
                      child: ElevatedButton.icon(
                        onPressed: _showNotaryPicker,
                        icon: const Icon(Icons.upload_sharp,
                            color: Colors.white),
                        label: const Text("Notary",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding:
                          const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            // const SizedBox(height: 30),

            // Uploaded file previews
            if (policeVerificationFile != null)
              _glassContainer(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf,
                      color: Colors.orange),
                  title:
                  Text(policeVerificationFile!.path.split('/').last),
                  subtitle: const Text("Police Verification File"),
                  onTap: () async =>
                  await OpenFilex.open(policeVerificationFile!.path),
                ),
              ),

            //const SizedBox(height: 20),

            if (!isPolice && notaryImageFile != null)
              _glassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(notaryImageFile!,
                          height: 160, width: 160, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    if (isCompressing)
                      const Center(
                          child: Padding(
                              padding: EdgeInsets.all(10),
                              child: CircularProgressIndicator())),
                    if (!isCompressing && compressedSizeText.isNotEmpty)
                      Center(
                        child: Text(compressedSizeText,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green)),
                      ),
                    const Text("Notary Image",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
              ),

            //const SizedBox(height: 20),

            if (!isPolice && pdfFile != null)
              _glassContainer(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf,
                      color: Colors.red),
                  title: Text(pdfFile!.path.split('/').last),
                  subtitle: const Text("Tap to open"),
                  onTap: () async => await OpenFilex.open(pdfFile!.path),
                ),
              ),

            const SizedBox(height: 20),

            // Generate PDF button
            if (!isPolice)
              GenerateAgreementButton(onGenerate: _handleGeneratePdf),

            const SizedBox(height: 16),

            // Done button
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: isPolice
                    ? _submitAll
                    : (pdfGenerated ? _submitAll : null),
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text("Done",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPolice
                      ? Colors.green
                      : (pdfGenerated ? Colors.green : Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Helper Widgets ───────────────────────────────────────────────────────────

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

class GenerateAgreementButton extends StatefulWidget {
  final Future<void> Function() onGenerate;
  const GenerateAgreementButton({super.key, required this.onGenerate});

  @override
  State<GenerateAgreementButton> createState() =>
      _GenerateAgreementButtonState();
}

class _GenerateAgreementButtonState extends State<GenerateAgreementButton> {
  bool _isLoading = false;
  int _countdown = 0;
  Timer? _timer;

  Future<void> _startCountdown() async {
    setState(() {
      _isLoading = true;
      _countdown = 5;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
      } else {
        setState(() => _countdown--);
      }
    });
    await widget.onGenerate();
    _timer?.cancel();
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _startCountdown,
        icon: _isLoading
            ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                color: Colors.white, strokeWidth: 2))
            : const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: Text(
          _isLoading ? 'Generating ($_countdown s)...' : 'Generate Agreement',
          style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}