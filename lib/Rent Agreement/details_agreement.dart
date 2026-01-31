import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:gal/gal.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';


import '../Custom_Widget/Custom_backbutton.dart';
import 'Dashboard_screen.dart';
import 'Forms/Agreement_Form.dart';
import 'Forms/Commercial_Form.dart';
import 'Forms/External_Form.dart';
import 'Forms/Furnished_form.dart';
import 'Forms/Renewal_form.dart';
import 'Forms/Verification_form.dart';

class AgreementDetailPage extends StatefulWidget  {
  final bool fromNotification;
  final String agreementId;
  const AgreementDetailPage({super.key,
    this.fromNotification = false,
    required this.agreementId});

  @override
  State<AgreementDetailPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AgreementDetailPage>  with SingleTickerProviderStateMixin {
  Map<String, dynamic>? agreement;
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    _fetchAgreementDetail();
  }



  Future<void> _fetchAgreementDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=${widget.agreementId}"));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        debugPrint("🔹 API Response: $decoded");
        if (decoded["status"] == "success" && decoded["count"] > 0) {
          setState(() {
            agreement = decoded["data"][0];
            isLoading = false;
          });
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
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";

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
        debugPrint("Error saving image: $e");
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

  // Optional diagonal ribbon used for rejected label
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

    final res = await http.get(
      Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/count_api_for_all_agreement_with_reword.php"
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
    final reward = await fetchRewardStatus();

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


  Widget _furnitureList(dynamic furnitureData) {
    if (furnitureData == null || furnitureData.toString().trim().isEmpty) {
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
      debugPrint("⚠️ Furniture parse error: $e");
    }

    if (furnitureMap.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Furnished Items:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87)
            ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: furnitureMap.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade700, width: 1),
                ),
                child: Text(
                  "${e.key} (${e.value})",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final a = agreement;
    final isLoadingLocal = isLoading;
    final bool hasGST = (a?['gst_photo']?.toString().trim().isNotEmpty ?? false);
    final bool hasPAN = (a?['pan_photo']?.toString().trim().isNotEmpty ?? false);
    final bool isDirector = hasGST || hasPAN;
    final String personLabel = isDirector ? 'Director' : 'Tenant';
    final isRejected = (a?['status']?.toString().toLowerCase().contains('reject') ?? false);
    final withPolice= a?['is_Police']?.toString() == "true";


    // Top-level gradient that matches card visuals (green -> black/white)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark ? [Colors.green.shade700, Colors.black] : [Colors.black, Colors.green.shade400],
    );

    return Scaffold(
      // custom app bar that uses the gradient ink
      appBar: AppBar(
        backgroundColor: isDark
            ? Colors.black
            : Colors.grey.shade100,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(children: [
            SquareBackButton(), // your existing widget
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '${a?["agreement_type"] ?? "Agreement"} Details',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
            ),
            const SizedBox(width: 8),
          ]),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(gradient: pageGradient),
        child: isLoadingLocal
            ? const Center(child: CircularProgressIndicator())
            : a == null
            ? const Center(child: Text("No details found"))
            : LayoutBuilder(builder: (context, constraints) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 90, 16, 24),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // Main content container (slightly translucent panel to read easily)
                    Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(.45) : Colors.white.withOpacity(.95),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.22), blurRadius: 30, offset: const Offset(0, 12))],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        // badges row
                        SizedBox(height: 20,),
                        if (withPolice)
                          Container(
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
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                        SizedBox(height: 20,),

                        Wrap(spacing: 10, runSpacing: 10, children: [
                          if ((a['agreement_type'] ?? '').toString().isNotEmpty) _badge(a['agreement_type'].toString(), icon: Icons.description_outlined),
                          if ((a['Bhk'] ?? '').toString().isNotEmpty) _badge('${a['Bhk']}', icon: Icons.home_outlined),
                          if ((a['monthly_rent'] ?? '').toString().isNotEmpty) _badge('₹${a['monthly_rent']} rent ',),
                          if ((a['securitys'] ?? '').toString().isNotEmpty) _badge('₹${a['securitys']} security', icon: Icons.lock_outline),
                        ]),

                        const SizedBox(height: 18),
                        if (agreement!["agreement_type"] != "Police Verification")
                          if (a['status'] != null)
                          _sectionCard(
                            title: "Agreement Status",
                            icon: Icons.flag_outlined,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: _statusColor(a['status'].toString()).withOpacity(.50),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: _statusColor(a['status'].toString()).withOpacity(.25)),
                                ),
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _detailRow(label: "Status", value: a['status']?.toString() ?? ''),
                                    _detailRow(label: "Reason", value: a['messages']?.toString() ?? ''),

                                    if (isRejected) ...[
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isDark ? Colors.red.shade700 : Colors.red.shade500,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            elevation: 6,
                                            padding: const EdgeInsets.symmetric(vertical: 12),
                                          ),
                                          onPressed: () => _navigateToEditForm(context, a),
                                          icon: const Icon(Icons.edit, size: 18),
                                          label: const Text(
                                            "Edit & Resubmit",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.3,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),


                        const SizedBox(height: 8),

                             SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                  width: 298,
                                  child:_sectionCard(
                                      title: "Owner Details",
                                      icon: Icons.person_outline,
                                      children: [
                                        _detailRow(label: "Owner Name", value: a['owner_name'] ?? ''),
                                        _detailRow(label: "Relation", value: "${a['owner_relation'] ?? ''} ${a['relation_person_name_owner'] ?? ''}"),
                                        _detailRow(label: "Address", value: a['parmanent_addresss_owner'] ?? ''),
                                        _detailRow(label: "Mobile", value: a['owner_mobile_no'] ?? ''),
                                        _detailRow(label: "Aadhar", value: a['owner_addhar_no'] ?? ''),
                                        Wrap(
                                          children: [
                                            _detailRow(label: "Aadhaar Front", value: a['owner_aadhar_front'] ?? '', isImage: true),
                                            _detailRow(label: "Aadhaar Back", value: a['owner_aadhar_back'] ?? '', isImage: true),
                                          ],
                                        ),
                                      ],
                                    ),
                                ),

                                    const SizedBox(width: 5),

                                    SizedBox(
                                      width: 298,
                                      child: _sectionCard(
                                        title: a['agreement_type'] == 'Commercial Agreement'
                                            ? 'Director Details'
                                            : 'Tenant Details',
                                        icon: Icons.verified_user_outlined,
                                        children: [
                                          _detailRow(
                                              label: a['agreement_type'] == 'Commercial Agreement'
                                                  ? 'Director Name'
                                                  : 'Tenant Name',
                                              value: a[' '] ?? ''),
                                          _detailRow(label: "Relation", value: "${a['tenant_relation'] ?? ''} ${a['relation_person_name_tenant'] ?? ''}"),
                                          _detailRow(label: "Address", value: a['permanent_address_tenant'] ?? ''),
                                          _detailRow(label: "Mobile", value: a['tenant_mobile_no'] ?? ''),
                                          _detailRow(label: "Aadhar", value: a['tenant_addhar_no'] ?? ''),
                                          if (a['agreement_type'] == 'Commercial Agreement') ...[
                                            const Divider(),
                                            _detailRow(label: "Company Name", value: a['company_name'] ?? ''),
                                            _detailRow(label: "GST Number", value: a['gst_no'] ?? ''),
                                            _detailRow(label: "PAN Number", value: a['pan_no'] ?? ''),
                                          ],
                                          Wrap(
                                            children: [
                                              _detailRow(label: "$personLabel Aadhaar Front", value: a['tenant_aadhar_front'] ?? '', isImage: true),
                                              _detailRow(label: "$personLabel Aadhaar Back", value: a['tenant_aadhar_back'] ?? '', isImage: true),
                                              _detailRow(label: "$personLabel Photo", value: a['tenant_image'] ?? '', isImage: true),
                                              if (isDirector) ...[
                                                _detailRow(label: "GST Photo", value: a['gst_photo'] ?? '', isImage: true),
                                                _detailRow(label: "PAN Photo", value: a['pan_photo'] ?? '', isImage: true),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    SizedBox(
                                      width: 280,
                                      child: Column(
                                        children: [
                                          _sectionCard(
                                            title: "Property Details",
                                            icon: Icons.apartment_outlined,
                                            children: [
                                              _detailRow(label: "Property ID", value: a['property_id']?.toString() ?? ''),
                                              _detailRow(label: "BHK", value: a['Bhk']?.toString() ?? ''),
                                              _detailRow(label: "Floor", value: a['floor']?.toString() ?? ''),
                                              _detailRow(label: "Rented Address", value: a['rented_address'] ?? ''),
                                              _detailRow(label: "Meter Type", value: a['meter']?.toString() ?? ''),
                                              _detailRow(label: "Maintenance", value: a['maintaince'] ?? ''),
                                              _detailRow(label: "Parking", value: a['parking'] ?? ''),

                                              _furnitureList(a['furniture']), // 👈 this line auto handles your furniture data

                                            ],
                                          ),
                                          // === Agreement Finance column ===
                                          if (agreement!["agreement_type"] != "Police Verification")
                                            _sectionCard(
                                            title: "Payment & Rent",
                                            icon: Icons.attach_money_outlined,
                                            children: [
                                              _detailRow(label: "Monthly Rent", value: a['monthly_rent'] != null ? '₹${a['monthly_rent']}' : ''),
                                              _detailRow(label: "Security", value: a['securitys'] != null ? '₹${a['securitys']}' : ''),
                                              _detailRow(label: "Installment Security", value: a['installment_security_amount'] != null ? '₹${a['installment_security_amount']}' : ''),
                                              _detailRow(
                                                label: "Shifting Date",
                                                value: a['shifting_date']?.toString().contains('T') == true
                                                    ? a['shifting_date'].toString().split('T')[0]
                                                    : (a['shifting_date']?.toString() ?? ''),
                                              ),

                                              _detailRow(label: "Agreement Price", value: a['agreement_price'] != null ? '₹${a['agreement_price']}' : ''),
                                              _detailRow(label: "Notary Amount", value: a['notary_price'] != null ? '₹${a['notary_price']}' : ''),


                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                    ),

                    _diagonalRibbon(isRejected, 'REJECTED'),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }


}
