import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Custom_Widget/Custom_backbutton.dart';

/// Professional UI facelift only. Your texts, labels, and data flow are unchanged.
class AgreementDetailPage extends StatefulWidget {
  final String agreementId;
  const AgreementDetailPage({super.key, required this.agreementId});

  @override
  State<AgreementDetailPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AgreementDetailPage> {
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

  // ====== LOOK & FEEL HELPERS (design only) ======
  Color get _panel => Theme.of(context).colorScheme.surface;
  Color get _ink => Theme.of(context).colorScheme.onSurface;
  Color get _muted => _ink.withOpacity(.68);
  Color get _stroke => Theme.of(context).dividerColor.withOpacity(.22);

  double _labelWidth(BoxConstraints c) {
    final w = c.maxWidth;
    if (w < 360) return 110;
    if (w < 480) return 130;
    if (w < 700) return 150;
    return 180;
  }

  Widget _badge(String text, {IconData? icon, Color? color}) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Neutral base (no primary)
    final Color baseBg  = Colors.white;
    final Color baseFg  = cs.onSurfaceVariant;
    final Color baseBrd = cs.outlineVariant;

    // If a custom color is provided, use it softly; otherwise stay neutral.
    final bool accented = color != null;
    final Color ac = color ?? const Color(0x00000000);

    // Pick foreground that stays readable on any custom color.
    Color _autoFg(Color bg) =>
        bg.computeLuminance() < 0.35 ? Colors.white : Colors.black87;

    final Color bg  = accented
        ? ac.withOpacity(isDark ? .22 : .14)
        : (isDark ? baseBg.withOpacity(.30) : baseBg.withOpacity(.85));

    final Color fg  = accented ? _autoFg(ac) : baseFg;
    final Color brd = accented ? ac.withOpacity(.35)
        : baseBrd.withOpacity(isDark ? .55 : .65);

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
        Text(text, style: TextStyle(color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black, fontWeight: FontWeight.w700)),
      ]),
    );
  }

  Widget _sectionCard({
    required String title,
    required List<Widget> children,
    IconData icon = Icons.folder_open_outlined,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: _panel,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _stroke),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // header
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Row(children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Theme.of(context).brightness==Brightness.dark?Colors.blue.shade100:Colors.blueAccent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title, // same text preserved
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
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
    if ((path).toString().trim().isEmpty) return const SizedBox.shrink();
    final full = "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";
    return GestureDetector(
      onTap: () => showDialog(
        context: context,
        builder: (_) => Dialog(
          clipBehavior: Clip.hardEdge,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: InteractiveViewer(
            child: Image.network(full, fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const SizedBox(height: 200, child: Center(child: Icon(Icons.broken_image, color: Colors.red)))),
          ),
        ),
      ),
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
          errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.red)),
          loadingBuilder: (c, w, p) => p == null
              ? w
              : Container(
            color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(.45),
            child: const Center(child: SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))),
          ),
        ),
      ),
    );
  }

  Widget _detailRow({required String label, required String value, bool isImage = false}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(builder: (context, c) {
      final lw = _labelWidth(c);
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: lw,
            child: Text(
              "$label:", // same label text preserved
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
              value, // same value shown
              style: TextStyle(color: _ink, height: 1.35),
            ),
          ),
        ]),
      );
    });
  }

  Color _statusColor(String s) {
    final t = s.toLowerCase();
    if (t.contains('rejected')) return Colors.red;
    if (t.contains('resubmit') || t.contains('approved')) return Colors.green;
    if (t.contains('pending')) return Colors.orange;
    return Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final a = agreement;
    final bool hasGST = (a?['gst_photo']?.toString().trim().isNotEmpty ?? false);
    final bool hasPAN = (a?['pan_photo']?.toString().trim().isNotEmpty ?? false);
    final bool isDirector = hasGST || hasPAN;
    final String personLabel = isDirector ? 'Director' : 'Tenant';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          '${a?["agreement_type"] ?? "Agreement"} Details', // same title text
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700,color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          if (a != null && (a['status']?.toString().isNotEmpty ?? false))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: _statusColor(a['status'].toString()).withOpacity(.12),
                    border: Border.all(color: _statusColor(a['status'].toString()).withOpacity(.3)),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(children: [
                    Icon(Icons.verified_outlined, size: 16, color: _statusColor(a['status'].toString())),
                    const SizedBox(width: 6),
                    Text(a['status'].toString(), style: TextStyle(color: _statusColor(a['status'].toString()), fontWeight: FontWeight.w700)),
                  ]),
                ),
              ),
            )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: Theme.of(context).brightness == Brightness.dark
            // dark mode: soft blacks
                ? const [
              Color(0xFF000000), // pure black
              Color(0xFF0A0A0A), // deep gray-black
              Color(0xFF1C1C1C), // smoky edge
            ]
            // light mode: light grays with black tint
                : const [
              Color(0xFFF5F5F5),
              Color(0xFFEAEAEA),
              Color(0xFFD6D6D6),
            ],
            stops: const [0.0, 0.55, 1.0],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : a == null
            ? const Center(child: Text("No details found"))
            : LayoutBuilder(builder: (context, constraints) {
          return Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1000),
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Wrap(spacing: 10, runSpacing: 10, children: [
                    if ((a['agreement_type'] ?? '').toString().isNotEmpty)
                      _badge(a['agreement_type'].toString(), icon: Icons.description_outlined),
                    if ((a['Bhk'] ?? '').toString().isNotEmpty) _badge('${a['Bhk']}', icon: Icons.home_outlined),
                    if ((a['monthly_rent'] ?? '').toString().isNotEmpty)
                      _badge('₹${a['monthly_rent']} rent ', icon: Icons.attach_money),
                    if ((a['securitys'] ?? '').toString().isNotEmpty)
                      _badge('₹${a['securitys']} security', icon: Icons.lock_outline),
                  ]),
                  const SizedBox(height: 16),

                  _sectionCard(
                    title: "Field Worker", // unchanged
                    icon: Icons.handyman_outlined,
                    children: [
                      _detailRow(label: "Name", value: a['Fieldwarkarname'] ?? ''),
                      _detailRow(label: "Number", value: a['Fieldwarkarnumber'] ?? ''),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Keep your original horizontal 3-card layout idea but styled
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 340,
                          child: _sectionCard(
                            title: "Owner Details", // unchanged
                            icon: Icons.person_outline,
                            children: [
                              _detailRow(label: "Owner Name", value: a['owner_name'] ?? ''),
                              _detailRow(
                                label: "Relation",
                                value: "${a['owner_relation'] ?? ''} ${a['relation_person_name_owner'] ?? ''}",
                              ),
                              _detailRow(label: "Address", value: a['parmanent_addresss_owner'] ?? ''),
                              _detailRow(label: "Mobile", value: a['owner_mobile_no'] ?? ''),
                              _detailRow(label: "Aadhar", value: a['owner_addhar_no'] ?? ''),
                              _detailRow(label: "Owner Aadhaar Front", value: a['owner_aadhar_front'] ?? '', isImage: true),
                              _detailRow(label: "Owner Aadhaar Back", value: a['owner_aadhar_back'] ?? '', isImage: true),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 340,
                          child: _sectionCard(
                            title: a['agreement_type'] == 'Commercial Agreement' ? 'Director Details' : 'Tenant Details',
                            icon: Icons.verified_user_outlined,
                            children: [
                              _detailRow(
                                label: a['agreement_type'] == 'Commercial Agreement' ? 'Director Name' : 'Tenant Name',
                                value: a['tenant_name'] ?? '',
                              ),
                              _detailRow(
                                label: "Relation",
                                value: "${a['tenant_relation'] ?? ''} ${a['relation_person_name_tenant'] ?? ''}",
                              ),
                              _detailRow(label: "Address", value: a['permanent_address_tenant'] ?? ''),
                              _detailRow(label: "Mobile", value: a['tenant_mobile_no'] ?? ''),
                              _detailRow(label: "Aadhar", value: a['tenant_addhar_no'] ?? ''),
                              if (a['agreement_type'] == 'Commercial Agreement') ...[
                                const Divider(),
                                _detailRow(label: "Company Name", value: a['company_name'] ?? ''),
                                _detailRow(label: "GST Number", value: a['gst_no'] ?? ''),
                                _detailRow(label: "PAN Number", value: a['pan_no'] ?? ''),
                              ],
                              Wrap(children: [
                                _detailRow(
                                  label: "$personLabel Aadhaar Front",
                                  value: a['tenant_aadhar_front'] ?? '',
                                  isImage: true,
                                ),
                                _detailRow(
                                  label: "$personLabel Aadhaar Back",
                                  value: a['tenant_aadhar_back'] ?? '',
                                  isImage: true,
                                ),
                                _detailRow(
                                  label: "$personLabel Photo",
                                  value: a['tenant_image'] ?? '',
                                  isImage: true,
                                ),
                                if (isDirector) ...[
                                  _detailRow(label: "GST Photo", value: a['gst_photo'] ?? '', isImage: true),
                                  _detailRow(label: "PAN Photo", value: a['pan_photo'] ?? '', isImage: true),
                                ],
                              ]),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 340,
                          child: _sectionCard(
                            title: "Agreement Details", // unchanged
                            icon: Icons.assignment_outlined,
                            children: [
                              _detailRow(label: "Property", value: a['property_id']?.toString() ?? ''),
                              _detailRow(label: "BHK", value: a['Bhk']?.toString() ?? ''),
                              _detailRow(label: "Floor", value: a['floor']?.toString() ?? ''),
                              _detailRow(label: "Rented Address", value: a['rented_address'] ?? ''),
                              _detailRow(label: "Monthly Rent", value: a['monthly_rent'] != null ? '₹${a['monthly_rent']}' : ''),
                              _detailRow(label: "Security", value: a['securitys'] != null ? '₹${a['securitys']}' : ''),
                              _detailRow(label: "Installment Security", value: a['installment_security_amount'] != null ? '₹${a['installment_security_amount']}' : ''),
                              _detailRow(label: "Meter", value: a['meter']?.toString() ?? ''),
                              _detailRow(label: "Custom Unit", value: a['custom_meter_unit'] ?? ''),
                              _detailRow(label: "Maintenance", value: a['maintaince'] ?? ''),
                              _detailRow(label: "Parking", value: a['parking'] ?? ''),
                              _detailRow(
                                label: "Shifting Date",
                                value: a['shifting_date']?.toString().contains('T') == true
                                    ? a['shifting_date'].toString().split('T')[0]
                                    : (a['shifting_date']?.toString() ?? ''),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (a['status'] != null)
                    _sectionCard(
                      title: "Agreement Status", // unchanged
                      icon: Icons.flag_outlined,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: _statusColor(a['status'].toString()).withOpacity(.08),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _statusColor(a['status'].toString()).withOpacity(.25)),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Column(children: [
                            _detailRow(label: "Status", value: a['status']?.toString() ?? ''),
                            _detailRow(label: "Reason", value: a['messages']?.toString() ?? ''),
                          ]),
                        ),
                      ],
                    ),

                  const SizedBox(height: 30),
                ]),
              ),
            ),
          );
        }),
      ),
    );
  }
}
