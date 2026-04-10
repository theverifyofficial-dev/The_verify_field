import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
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

// ─────────────────────────────────────────────
//  Section color themes
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

// ─────────────────────────────────────────────
//  Field icons
// ─────────────────────────────────────────────
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

// ─────────────────────────────────────────────
//  Main Widget
// ─────────────────────────────────────────────
class AcceptedDetails extends StatefulWidget {
  final String agreementId;
  const AcceptedDetails({super.key, required this.agreementId});

  @override
  State<AcceptedDetails> createState() => _AcceptedDetailsState();
}

class _AcceptedDetailsState extends State<AcceptedDetails> {
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
      final Uint8List bytes = await file.readAsBytes();
      img.Image? image = img.decodeImage(bytes);
      if (image == null) return file;
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
      return compressed;
    } catch (e) {
      debugPrint("compressImageTo150KB error: $e");
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
        "parmanent_addresss_owner":
        agreement?["parmanent_addresss_owner"] ?? "",
        "owner_mobile_no": agreement?["owner_mobile_no"] ?? "",
        "owner_addhar_no": agreement?["owner_addhar_no"] ?? "",
        "tenant_name": agreement?["tenant_name"] ?? "",
        "tenant_relation": agreement?["tenant_relation"] ?? "",
        "relation_person_name_tenant":
        agreement?["relation_person_name_tenant"] ?? "",
        "permanent_address_tenant":
        agreement?["permanent_address_tenant"] ?? "",
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
        final resp = await http.get(Uri.parse(url));
        if (resp.statusCode != 200) return null;
        final file = File("${Directory.systemTemp.path}/$name");
        return file.writeAsBytes(resp.bodyBytes);
      }

      final ownerFront = await downloadIfNeeded(
          agreement?["owner_aadhar_front"], "owner_front.jpg");
      final ownerBack = await downloadIfNeeded(
          agreement?["owner_aadhar_back"], "owner_back.jpg");
      final tenantFront = await downloadIfNeeded(
          agreement?["tenant_aadhar_front"], "tenant_front.jpg");
      final tenantBack = await downloadIfNeeded(
          agreement?["tenant_aadhar_back"], "tenant_back.jpg");
      final tenantImg = await downloadIfNeeded(
          agreement?["tenant_image"], "tenant_img.jpg");

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
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Upload Police Verification PDF")));
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
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Submitted successfully!")));
        Navigator.pop(context); // close loading dialog
        Navigator.pop(context, true); // go back
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Submit failed (${response.statusCode})")));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      // Only pop the dialog if it is still showing (guard against double-pop)
      if (mounted) {
        try {
          Navigator.of(context, rootNavigator: true).pop();
        } catch (_) {}
      }
    }
  }

  // ── PDF ────────────────────────────────────────────────────────────────────

  Future<void> _handleGeneratePdf() async {
    if (agreement == null) return;
    final String type = (agreement!['agreement_type'] ?? '').toString().trim();
    setState(() => isLoading = true);
    try {
      final File file;
      if (type == "Furnished Agreement") {
        file = await generateFurnishedAgreementPdf(agreement!);
      } else if (type == "Commercial Agreement" ||
          type == "External Commercial Agreement") {
        file = await generateCommercialAgreementPdf(agreement!);
      } else {
        file = await generateAgreementPdf(agreement!);
      }
      setState(() {
        pdfFile = file;
        pdfGenerated = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.redAccent));
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  //  UI Helpers
  // ─────────────────────────────────────────────────────────────────────────

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
          border:
          Border.all(color: borderColor.withOpacity(0.4), width: 1.2),
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
  Widget _hkCompact(String k, dynamic v, IconData iconData) {
    final iconData = _fieldIcons[k] ?? Icons.currency_rupee;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
    return  Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        Icon(iconData, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text('$k:', style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w600,
            color: isDark ? Colors.black87 : Colors.grey[600])),
        SizedBox(width: 6,),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
                colors: [Color(0xFF16A34A), Color(0xFF15803D)]),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(
                color: const Color(0xFF16A34A).withOpacity(0.25),
                blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child:
          Text(
            value,
            style:  TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w100,
              color: isDark ? Colors.white : Colors.white,
            ),
          ),)
      ],
    );
  }
  // Standard key-value row
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
            child: Icon(icon, size: 16,
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

  // Two fields side by side
  Widget _kvRow(String k1, dynamic v1, [String? k2, dynamic v2]) {
    if (k2 == null) return _kv(k1, v1);
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

  // Full-width field (for addresses)
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
              Icon(icon, size: 12,
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

  // Single field used inside _kvRow
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
        Text(
          value.isEmpty ? "—" : value,
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.black87 : Colors.black87),
        ),
      ],
    );
  }

  // Compact KV with icon (for BHK/Floor side by side)
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
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.black87 : Colors.grey[600])),
      ],
    );
  }

  // Amount chip with green gradient
  Widget _kvAmount(String k, dynamic v) {
    final raw = v?.toString().trim() ?? "";
    final icon = _fieldIcons[k] ?? Icons.currency_rupee;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final Widget leading = Padding(
      padding: const EdgeInsets.only(top: 1, right: 8),
      child: Icon(icon, size: 16,
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
                      color: isDark ? Colors.black87 : Colors.grey[600])),
            ),
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
                    color: isDark ? Colors.black87 : Colors.grey[600])),
          ),
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

  // Highlighted date row
  Widget _kvHighlight(String k, dynamic v) {
    final value = v?.toString().trim() ?? "";
    if (value.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding:
      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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

  // Furniture chips
  Widget _furnitureList(dynamic furnitureData) {
    if (furnitureData == null ||
        furnitureData.toString().trim().isEmpty) {
      return const SizedBox.shrink();
    }
    Map<String, dynamic> furnitureMap = {};
    try {
      if (furnitureData is String) {
        furnitureMap = Map<String, dynamic>.from(json.decode(furnitureData));
      } else if (furnitureData is Map<String, dynamic>) {
        furnitureMap = furnitureData;
      }
    } catch (e) {
      debugPrint("Furniture parse error: $e");
    }
    if (furnitureMap.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Furnished Items:',
              style:
              TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
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

  // Document thumbnail
  Widget _docImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return const SizedBox.shrink();
    final fullUrl =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$imageUrl';
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) =>
                  ImagePreviewScreen(imageUrl: fullUrl))),
      child: Container(
        width: 80,
        height: 90,
        margin: const EdgeInsets.only(right: 12, top: 6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            fullUrl,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image,
                  color: Colors.red, size: 30),
            ),
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
  //  Build
  // ─────────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final bool isPolice =
        agreement?["agreement_type"] == "Police Verification";
    final bool withPolice =
        agreement?['is_Police']?.toString() == "true";

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
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 7),
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

            // Police note
            if (withPolice) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.redAccent)),
                child: const Row(children: [
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
                ]),
              ),
              const SizedBox(height: 16),
            ],

            // Horizontal scrolling cards
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Agreement + Owner stacked
                  if (!isPolice)
                    Column(
                      children: [
                        SizedBox(
                          width: 380,
                          child: _sectionCard(
                            title: "Agreement Details",
                            children: [
                              // BHK + Floor compact row
                              Row(
                                children: [
                                  Expanded(
                                    child: _kvCompact(
                                        "BHK",
                                        agreement?["Bhk"] ?? "",
                                        Icons.home),
                                  ),
                                  Expanded(
                                    child: _kvCompact(
                                        "Floor",
                                        agreement?["floor"] ?? "",
                                        Icons.layers),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              _kv("Sqft", agreement?["Sqft"]),
                              _kv("Rented Address",
                                  agreement?["rented_address"]),
                              _kvAmount(
                                  "Monthly Rent",
                                  agreement?["monthly_rent"] != null
                                      ? "₹${agreement?["monthly_rent"]}"
                                      : ""),
                              _kvAmount(
                                  "Security",
                                  agreement?["securitys"] != null
                                      ? "₹${agreement?["securitys"]}"
                                      : ""),
                              _kvAmount(
                                  "Installment Security",
                                  agreement?["installment_security_amount"] !=
                                      null
                                      ? "₹${agreement?["installment_security_amount"]}"
                                      : ""),
                              _kv("Meter", agreement?["meter"]),
                              _kv("Custom Unit",
                                  agreement?["custom_meter_unit"]),
                              _kv("Maintenance",
                                  agreement?["maintaince"]),
                              if (agreement?["maintaince"] == "Excluding")
                                _kv(
                                    "Maintenance Amount",
                                    agreement?[
                                    "custom_maintenance_charge"]),
                              _kv("Parking", agreement?["parking"]),
                              _kvHighlight("Shifting Date",
                                  _formatDate(agreement?["shifting_date"])),

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

                              _furnitureList(agreement!['furniture']),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: 380,
                          child: _sectionCard(
                            title: "Owner Details",
                            children: [
                              _kvRow("Owner Name", agreement?["owner_name"],
                                  "Relation", "${agreement?["owner_relation"] ?? ""} ${agreement?["relation_person_name_owner"] ?? ""}"),
                              _kvFull("Address", agreement?["parmanent_addresss_owner"]),
                              _kvRow("Mobile", agreement?["owner_mobile_no"],
                                  "Aadhar", agreement?["owner_addhar_no"]),
                              const SizedBox(height: 8),
                              Row(children: [
                                _docImage(
                                    agreement?["owner_aadhar_front"]),
                                _docImage(
                                    agreement?["owner_aadhar_back"]),
                              ]),
                            ],
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(width: 12),

                  // Tenant / Director card
                  SizedBox(
                    width: 380,
                    child: _sectionCard(
                      title: "$D_or_T Details",
                      children: [
                        _kvRow("$D_or_T Name", agreement?["tenant_name"],
                            "Relation",
                            "${agreement?["tenant_relation"] ?? ""} ${agreement?["relation_person_name_tenant"] ?? ""}"),
                        _kvFull("Address",
                            agreement?["permanent_address_tenant"]),
                        _kvRow("Mobile", agreement?["tenant_mobile_no"],
                        "Aadhar", agreement?["tenant_addhar_no"]),

                        if (agreement!["agreement_type"] ==
                            "Commercial Agreement") ...[
                          const Divider(height: 20),
                          _kv("Company Name",
                              agreement!["company_name"]),
                          _kv("DOC Type", agreement!["gst_type"]),
                          _kv("DOC Number", agreement!["gst_no"]),
                          _kv("PAN Number", agreement!["pan_no"]),
                        ],

                        const SizedBox(height: 8),
                        Wrap(spacing: 8, children: [
                          _docImage(
                              agreement?["tenant_aadhar_front"]),
                          _docImage(
                              agreement?["tenant_aadhar_back"]),
                          _docImage(agreement?["tenant_image"]),
                          if (agreement!["agreement_type"] ==
                              "Commercial Agreement") ...[
                            _docImage(agreement?["gst_photo"]),
                            _docImage(agreement?["pan_photo"]),
                          ],
                        ]),

                        // Additional tenants
                        if (additionalTenants.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          ...additionalTenants
                              .asMap()
                              .entries
                              .map((entry) {
                            final t = entry.value;
                            final idx = entry.key;
                            return Padding(
                              padding:
                              const EdgeInsets.only(bottom: 14),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF7ED),
                                  borderRadius:
                                  BorderRadius.circular(12),
                                  border: Border.all(
                                      color: const Color(0xFFC2410C)
                                          .withOpacity(0.4),
                                      width: 1.2),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      padding:
                                      const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFC2410C),
                                        borderRadius:
                                        BorderRadius.vertical(
                                            top: Radius.circular(
                                                11)),
                                      ),
                                      child: Row(children: [
                                        const Icon(
                                            Icons.group_add_outlined,
                                            size: 16,
                                            color: Colors.white),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Additional $D_or_T ${idx + 2}",
                                          style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight:
                                              FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      ]),
                                    ),
                                    Padding(
                                      padding:
                                      const EdgeInsets.all(14),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          _kvRow("$D_or_T Name", t.name,
                                              "Relation", "${t.relation} ${t.relation_name}"),
                                        _kvFull("Address", agreement?["permanent_address_tenant"]),
                                          _kvRow("Mobile", t.mobile,
                                              "Aadhar", t.aadhaar),
                                          const SizedBox(height: 8),
                                          Wrap(children: [
                                            _docImage(t.front),
                                            _docImage(t.back),
                                            _docImage(t.photo),
                                          ]),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Police address
            if (isPolice)
              _sectionCard(title: "Property Address", children: [
                _kv("Property Address", agreement?["rented_address"]),
              ]),

            // Field Worker
            _sectionCard(title: "Field Worker", children: [
              _kv("Name", agreement?["Fieldwarkarname"]),
              _kv("Number", agreement?["Fieldwarkarnumber"]),
            ]),

            const SizedBox(height: 20),

            // Police Verification file preview
            if (policeVerificationFile != null) ...[
              _glassContainer(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf,
                      color: Colors.orange),
                  title: Text(
                      policeVerificationFile!.path.split('/').last),
                  subtitle:
                  const Text("Police Verification File"),
                  onTap: () async =>
                  await OpenFilex.open(policeVerificationFile!.path),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Notary image preview
            if (!isPolice && notaryImageFile != null) ...[
              _glassContainer(
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(notaryImageFile!,
                          height: 160,
                          width: 160,
                          fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 8),
                    if (isCompressing) const CircularProgressIndicator(),
                    if (!isCompressing &&
                        compressedSizeText.isNotEmpty)
                      Text(compressedSizeText,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green)),
                    const SizedBox(height: 4),
                    const Text("Notary Image",
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],

            // PDF preview
            if (!isPolice && pdfFile != null) ...[
              _glassContainer(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf,
                      color: Colors.red),
                  title: Text(pdfFile!.path.split('/').last),
                  subtitle: const Text("Tap to open"),
                  onTap: () async =>
                  await OpenFilex.open(pdfFile!.path),
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Upload buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF111827),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(children: [
                Expanded(
                  child: _pillButton(
                    label: policeVerificationFile == null
                        ? "Add P. Verification"
                        : "P. Verification ✓",
                    icon: Icons.verified_user_outlined,
                    colors: policeVerificationFile == null
                        ? [
                      const Color(0xFF6B7280),
                      const Color(0xFF4B5563)
                    ]
                        : [
                      const Color(0xFFF59E0B),
                      const Color(0xFFD97706)
                    ],
                    onPressed: () async {
                      final result = await FilePicker.platform
                          .pickFiles(type: FileType.any);
                      if (result != null &&
                          result.files.single.path != null) {
                        setState(() => policeVerificationFile =
                            File(result.files.single.path!));
                      }
                    },
                  ),
                ),
                if (!isPolice) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pillButton(
                      label: notaryImageFile == null
                          ? "Add Notary"
                          : "Notary ✓",
                      icon: Icons.edit_document,
                      colors: notaryImageFile == null
                          ? [
                        const Color(0xFF6B7280),
                        const Color(0xFF4B5563)
                      ]
                          : [
                        const Color(0xFFEF4444),
                        const Color(0xFFDC2626)
                      ],
                      onPressed: _showNotaryPicker,
                    ),
                  ),
                ],
              ]),
            ),

            const SizedBox(height: 12),

            // Generate PDF + Done/Submit buttons
            if (!isPolice) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(children: [
                  Expanded(
                    child: _pillButton(
                      label: pdfGenerated
                          ? "PDF Generated ✓"
                          : "Generate\nAgreement",
                      icon: Icons.picture_as_pdf_outlined,
                      colors: pdfGenerated
                          ? [
                        const Color(0xFF16A34A),
                        const Color(0xFF15803D)
                      ]
                          : [
                        const Color(0xFF4ADE80),
                        const Color(0xFF22C55E)
                      ],
                      textColor: pdfGenerated
                          ? Colors.white
                          : const Color(0xFF14532D),
                      iconColor: pdfGenerated
                          ? Colors.white
                          : const Color(0xFF14532D),
                      onPressed:
                      pdfGenerated ? null : _handleGeneratePdf,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _pillButton(
                      label: "Done\n& Submit",
                      icon: Icons.check_circle_outline,
                      colors: pdfGenerated
                          ? [
                        const Color(0xFF16A34A),
                        const Color(0xFF15803D)
                      ]
                          : [
                        Colors.grey.shade600,
                        Colors.grey.shade700
                      ],
                      onPressed: pdfGenerated ? _submitAll : null,
                    ),
                  ),
                ]),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF111827),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: _pillButton(
                  label: "Done & Submit",
                  icon: Icons.check_circle_outline,
                  colors: const [
                    Color(0xFF16A34A),
                    Color(0xFF15803D)
                  ],
                  onPressed: _submitAll,
                ),
              ),
            ],

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ── Notary image picker ────────────────────────────────────────────────────

  void _showNotaryPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => SizedBox(
        height: 160,
        child: Column(children: [
          const SizedBox(height: 10),
          const Text("Choose Image Source",
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
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

  Widget _buildCard(
      {required String title, required List<Widget> children}) {
    return Container(
      width: 400,
      margin: const EdgeInsets.only(right: 20),
      child: _sectionCard(title: title, children: children),
    );
  }

  // ── Property Card ──────────────────────────────────────────────────────────

  Widget _buildPropertyCard(Map<String, dynamic> data) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final String imageUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";
    final Color textSecondary =
    isDark ? Colors.grey[300]! : Colors.grey[700]!;
    final Color textMuted =
    isDark ? Colors.grey[400]! : Colors.grey[600]!;


    return Card(
      color: isDark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius:
            const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                    height: 200,
                    color: Colors.grey[200],
                    alignment: Alignment.center,
                    child: const Text("No Image",
                        style:
                        TextStyle(color: Colors.black54)))),
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
                            color: isDark
                                ? Colors.white
                                : Colors.black87)),
                    Text(data['Floor_'] ?? "--",
                        style: TextStyle(
                            fontSize: 14, color: textMuted)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name: ${data['field_warkar_name'] ?? '--'}",
                        style: TextStyle(
                            fontSize: 14, color: textSecondary)),
                    Text(
                        "Location: ${data['locations'] ?? '--'}",
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
                    Text(
                        "Maintenance: ${data['maintance'] ?? '--'}",
                        style: TextStyle(
                            fontSize: 15, color: textSecondary)),
                    Text(
                        "ID: ${agreement?["property_id"] ?? '--'}",
                        style: TextStyle(
                            fontSize: 15, color: textMuted)),
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