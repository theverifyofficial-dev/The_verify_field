import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Details_quotations.dart';

// ─── MODEL ───────────────────────────────────────────────────────────────────
class SocialInsuranceProject {
  final int id;
  final String name;
  final String number;
  final String vehicleNumber;
  final String fieldworkerName;
  final String fieldworkerNumber;
  final String? nextRenewDate;
  final String? aadharFront;
  final String? aadharBack;
  final String? rcFront;
  final String? rcBack;
  final String? oldPolicyDoc;
  final String emailId;
  final String claim;
  final String petrolDiesel;
  final String vehicleType;
  final String? carPhoto;
  final String? panCardPhoto;
  final String? pollutionPhoto;
  final String nomineName;
  final String nomineRelation;
  final String nomineAge;
  final String maritalStatus;
  final String vehicleCategory;
  final String currentDates;
  final String pollutionYesNo;

  SocialInsuranceProject.fromJson(Map<String, dynamic> j)
      : id = j['id'],
        name = j['name_'] ?? '',
        number = j['number'] ?? '',
        vehicleNumber = j['vehicle_number'] ?? '',
        fieldworkerName = j['fieldworkar_name'] ?? '',
        fieldworkerNumber = j['fieldworkar_number'] ?? '',
        nextRenewDate = j['next_renew_date'],
        aadharFront = j['Aadhar_front'],
        aadharBack = j['Aadhar_back'],
        rcFront = j['Rc_front'],
        rcBack = j['Rc_back'],
        oldPolicyDoc = j['old_policy_docement'],
        emailId = j['email_id'] ?? '',
        claim = j['claim'] ?? '',
        petrolDiesel = j['petrol_desiel'] ?? '',
        vehicleType = j['vehicle_type'] ?? '',
        carPhoto = j['car_photo'],
        panCardPhoto = j['pan_card_photo'],
        pollutionPhoto = j['polution_photo'],
        nomineName = j['Nominie_name'] ?? '',
        nomineRelation = j['Nominie_relation'] ?? '',
        nomineAge = j['Nominie_age'] ?? '',
        maritalStatus = j['Marital_status'] ?? '',
        vehicleCategory = j['vehicle_category'] ?? '',
        currentDates = j['current_dates'] ?? '',
        pollutionYesNo = j['polution_yes_no'] ?? '';
}

// ─── QUOTATION MODEL ──────────────────────────────────────────────────────────
class QuotationItem {
  final int id;
  final String vehicleValue;
  final String price;
  final String companyName;
  final String title;
  final String logo;
  final String pdfFile;
  final String subId;

  QuotationItem.fromJson(Map<String, dynamic> j)
      : id = j['id'] is int ? j['id'] : int.tryParse(j['id'].toString()) ?? 0,
        vehicleValue = j['vehicle_value']?.toString() ?? '',
        price = j['Price']?.toString() ?? '',
        companyName = j['company_name'] ?? '',
        title = j['tittle'] ?? '',
        logo = j['logo'] ?? '',
        pdfFile = j['pdf_file'] ?? '',
        subId = j['subid']?.toString() ?? '';
}

// ─── API SERVICE ─────────────────────────────────────────────────────────────
const String _baseUrl =
    'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/';

const String _uploadsBase =
    'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/';

const String _updateQuotationUrl =
    'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/update_api_new_cotaion.php';

String imgUrl(String path) {
  if (path.isEmpty) return '';
  if (path.startsWith('http')) return path;
  return '${_uploadsBase}$path';
}

String quotationLogoUrl(String filename) {
  if (filename.isEmpty) return '';
  if (filename.startsWith('http')) return filename;
  return '${_uploadsBase}insurance_uploads/$filename';
}

String quotationPdfUrl(String filename) {
  if (filename.isEmpty) return '';
  if (filename.startsWith('http')) return filename;
  return '${_uploadsBase}insurance_uploads/$filename';
}

Future<SocialInsuranceProject> fetchProject(int id) async {
  final uri = Uri.parse(
      '${_baseUrl}insurance_details/show_api_for_details_page.php?id=$id');
  final res = await http.get(uri);
  if (res.statusCode != 200) throw Exception('Server error ${res.statusCode}');
  final json = jsonDecode(res.body);
  if (json['status'] != 'success' || (json['data'] as List).isEmpty) {
    throw Exception('No data found');
  }
  return SocialInsuranceProject.fromJson(json['data'][0]);
}

Future<List<QuotationItem>> fetchQuotations(int subId) async {
  final uri = Uri.parse(
      '${_baseUrl}insurance_details/show_api_for_new_cataion.php?subid=$subId');
  final res = await http.get(uri);
  if (res.statusCode != 200) throw Exception('Server error ${res.statusCode}');
  final json = jsonDecode(res.body);
  if (json['success'] != true) return [];
  return (json['data'] as List)
      .map((e) => QuotationItem.fromJson(e))
      .toList();
}

// ─── UPDATE QUOTATION API ─────────────────────────────────────────────────────
// oldLogoName / oldPdfName = existing filename from DB (used when user doesn't
// pick a new file — so server keeps the old file untouched).
Future<void> updateQuotation({
  required String id,
  required String vehicleValue,
  required String price,
  required String companyName,
  required String title,
  required String subId,
  required String oldLogoName,   // ← existing logo filename
  required String oldPdfName,    // ← existing pdf filename
  File? logoFile,                // ← new logo (optional)
  File? pdfFile,                 // ← new pdf  (optional)
}) async {
  final request = http.MultipartRequest('POST', Uri.parse(_updateQuotationUrl));

  // ── Always send all text fields ──
  request.fields['id']            = id;
  request.fields['vehicle_value'] = vehicleValue;
  request.fields['Price']         = price;   // capital P (DB field)
  request.fields['price']         = price;   // lowercase  (fallback)
  request.fields['company_name']  = companyName;
  request.fields['tittle']        = title;
  request.fields['subid']         = subId;

  // ── Logo: send new file OR keep old filename ──
  if (logoFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath('logo', logoFile.path),
    );
  } else {
    // Send old filename so server doesn't null it out
    request.fields['logo'] = oldLogoName;
  }

  // ── PDF: send new file OR keep old filename ──
  if (pdfFile != null) {
    request.files.add(
      await http.MultipartFile.fromPath('pdf_file', pdfFile.path),
    );
  } else {
    // Send old filename so server doesn't null it out
    request.fields['pdf_file'] = oldPdfName;
  }

  final streamed = await request.send();
  final res = await http.Response.fromStream(streamed);

  if (res.statusCode != 200) {
    throw Exception('Server error ${res.statusCode}');
  }

  final body = res.body;
  debugPrint('📡 Update response: $body');

  final json = jsonDecode(body);
  final isSuccess = json['success'] == true ||
      json['success'] == 'true' ||
      json['status'] == 'success';
  if (!isSuccess) {
    throw Exception(json['message'] ?? 'Update failed');
  }
}

// ─── THEME COLORS ─────────────────────────────────────────────────────────────
class AppColors {
  final Color teal;
  final Color tealLight;
  final Color accent;
  final Color accentLight;
  final Color red;
  final Color redLight;
  final Color bg;
  final Color card;
  final Color text;
  final Color muted;
  final Color border;
  final Color green;
  final Color greenBg;
  final Color shadow;
  final Color orange;

  const AppColors._({
    required this.teal,
    required this.tealLight,
    required this.accent,
    required this.accentLight,
    required this.red,
    required this.redLight,
    required this.bg,
    required this.card,
    required this.text,
    required this.muted,
    required this.border,
    required this.green,
    required this.greenBg,
    required this.shadow,
    required this.orange,
  });

  static AppColors of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? _dark : _light;
  }

  static const _light = AppColors._(
    teal: Color(0xFF0D7A6E),
    tealLight: Color(0xFFE6F4F1),
    accent: Color(0xFF3461FF),
    accentLight: Color(0xFFEEF2FF),
    red: Color(0xFFE84040),
    redLight: Color(0xFFFFF0F0),
    bg: Color(0xFFEEF3F7),
    card: Color(0xFFFFFFFF),
    text: Color(0xFF1A1A2E),
    muted: Color(0xFF8A8FA8),
    border: Color(0xFFE8ECF4),
    green: Color(0xFF22C55E),
    greenBg: Color(0xFFDCFCE7),
    shadow: Color(0x0E000000),
    orange: Color(0xFFFF8000),
  );

  static const _dark = AppColors._(
    teal: Color(0xFF2BBFB0),
    tealLight: Color(0xFF0D2E2B),
    accent: Color(0xFF6B8FFF),
    accentLight: Color(0xFF0D1A3A),
    red: Color(0xFFFF6B6B),
    redLight: Color(0xFF2D1515),
    bg: Color(0xFF0F1117),
    card: Color(0xFF1A1D27),
    text: Color(0xFFE8EAF0),
    muted: Color(0xFF5A5F7A),
    border: Color(0xFF252836),
    green: Color(0xFF34D36A),
    greenBg: Color(0xFF0D2A1A),
    shadow: Color(0x33000000),
    orange: Color(0xFFFF8000),
  );
}

// ─── MAIN SCREEN ─────────────────────────────────────────────────────────────
class Social_PdfQuotation extends StatefulWidget {
  final int projectId;
  const Social_PdfQuotation({super.key, required this.projectId});

  @override
  State<Social_PdfQuotation> createState() => _Social_PdfQuotationState();
}

class _Social_PdfQuotationState extends State<Social_PdfQuotation> {
  late Future<SocialInsuranceProject> _future;
  late Future<List<QuotationItem>> _quotationFuture;

  @override
  void initState() {
    super.initState();
    _future = fetchProject(widget.projectId);
    _quotationFuture = fetchQuotations(widget.projectId);
  }

  void _refresh() {
    setState(() {
      _future = fetchProject(widget.projectId);
      _quotationFuture = fetchQuotations(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: c.shadow,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: c.bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.arrow_back_rounded, size: 20, color: c.text),
          ),
        ),
        title: Image.asset(AppImages.transparent, height: 40),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                SocialInsurancePlansScreen(Id: widget.projectId.toString()),
          ),
        ),
        backgroundColor: c.accent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      backgroundColor: c.bg,
      body: FutureBuilder<SocialInsuranceProject>(
        future: _future,
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: c.teal),
                  const SizedBox(height: 16),
                  Image.asset(AppImages.loader, height: 40),
                ],
              ),
            );
          }
          if (snap.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: c.redLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: c.red.withOpacity(.3)),
                  ),
                  child: Text(
                    '⚠️ ${snap.error}',
                    style: TextStyle(color: c.red, fontSize: 13),
                  ),
                ),
              ),
            );
          }
          return _ProjectBody(
            project: snap.data!,
            quotationFuture: _quotationFuture,
            onRefresh: _refresh,
          );
        },
      ),
    );
  }
}

// ─── BODY ─────────────────────────────────────────────────────────────────────
class _ProjectBody extends StatelessWidget {
  final SocialInsuranceProject project;
  final Future<List<QuotationItem>> quotationFuture;
  final VoidCallback onRefresh;
  const _ProjectBody({
    required this.project,
    required this.quotationFuture,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 100),
      children: [
        _MainCard(project: project),
        const SizedBox(height: 16),
        _QuotationsSection(
          quotationFuture: quotationFuture,
          onRefresh: onRefresh,
        ),
      ],
    );
  }
}

// ─── QUOTATIONS SECTION ───────────────────────────────────────────────────────
class _QuotationsSection extends StatelessWidget {
  final Future<List<QuotationItem>> quotationFuture;
  final VoidCallback onRefresh;
  const _QuotationsSection({
    required this.quotationFuture,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return FutureBuilder<List<QuotationItem>>(
      future: quotationFuture,
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: CircularProgressIndicator(color: c.teal, strokeWidth: 2),
            ),
          );
        }
        if (snap.hasError) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.redLight,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: c.red.withOpacity(.3)),
            ),
            child: Text('⚠️ ${snap.error}',
                style: TextStyle(color: c.red, fontSize: 13)),
          );
        }
        final items = snap.data ?? [];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Section header ──
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    color: c.teal,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Insurance Quotations',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: c.text,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: c.tealLight,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${items.length} Plans',
                    style: TextStyle(
                      color: c.teal,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (items.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: c.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(Icons.description_outlined,
                        size: 40, color: c.muted.withOpacity(.4)),
                    const SizedBox(height: 8),
                    Text('No quotations yet',
                        style: TextStyle(color: c.muted, fontSize: 13)),
                  ],
                ),
              )
            else
              ...items.map(
                    (q) => _QuotationCard(item: q, onRefresh: onRefresh),
              ),
          ],
        );
      },
    );
  }
}

// ─── QUOTATION CARD ───────────────────────────────────────────────────────────
class _QuotationCard extends StatelessWidget {
  final QuotationItem item;
  final VoidCallback onRefresh;
  const _QuotationCard({required this.item, required this.onRefresh});

  Future<void> _openPdf(BuildContext context, AppColors c) async {
    final url = quotationPdfUrl(item.pdfFile);
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not open file'),
            backgroundColor: c.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _openUpdateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UpdateQuotationSheet(
        item: item,
        onSuccess: onRefresh,
      ),
    );
  }

  String _formatAmount(String raw) {
    final n = double.tryParse(raw);
    if (n == null) return raw;
    if (n >= 10000000) return '₹${(n / 10000000).toStringAsFixed(2)} Cr';
    if (n >= 100000) return '₹${(n / 100000).toStringAsFixed(2)} L';
    if (n >= 1000) return '₹${(n / 1000).toStringAsFixed(1)}K';
    return '₹$raw';
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final logoUrl = quotationLogoUrl(item.logo);
    final isPdf = item.pdfFile.toLowerCase().endsWith('.pdf');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: c.shadow, blurRadius: 12, offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          // ── Top section ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Company logo
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: c.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: c.border, width: 1),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: logoUrl.isNotEmpty
                      ? Image.network(
                    logoUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.business_rounded,
                      color: c.muted,
                      size: 28,
                    ),
                  )
                      : Icon(Icons.business_rounded,
                      color: c.muted, size: 28),
                ),
                const SizedBox(width: 12),

                // Company info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.companyName.replaceAll('_', ' '),
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: c.text,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 11,
                          color: c.muted,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // ── UPDATE ICON BUTTON ──
                GestureDetector(
                  onTap: () => _openUpdateSheet(context),
                  child: Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: c.tealLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      size: 17,
                      color: c.teal,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Divider ──
          Divider(height: 1, color: c.border),

          // ── Price + Value row ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Vehicle value
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VEHICLE VALUE',
                        style: TextStyle(
                          fontSize: 9,
                          color: c.muted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .08,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatAmount(item.vehicleValue),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: c.teal,
                        ),
                      ),
                    ],
                  ),
                ),

                // Vertical separator
                Container(
                  width: 1,
                  height: 36,
                  color: c.border,
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                ),

                // Premium price
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PREMIUM',
                        style: TextStyle(
                          fontSize: 9,
                          color: c.muted,
                          fontWeight: FontWeight.w700,
                          letterSpacing: .08,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatAmount(item.price),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: c.accent,
                        ),
                      ),
                    ],
                  ),
                ),

                // Open PDF button
                GestureDetector(
                  onTap: () => _openPdf(context, c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isPdf ? c.redLight : c.accentLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPdf
                              ? Icons.picture_as_pdf_rounded
                              : Icons.description_rounded,
                          size: 16,
                          color: isPdf ? c.red : c.accent,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'View',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isPdf ? c.red : c.accent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── UPDATE QUOTATION BOTTOM SHEET ───────────────────────────────────────────
class _UpdateQuotationSheet extends StatefulWidget {
  final QuotationItem item;
  final VoidCallback onSuccess;

  const _UpdateQuotationSheet({
    required this.item,
    required this.onSuccess,
  });

  @override
  State<_UpdateQuotationSheet> createState() => _UpdateQuotationSheetState();
}

class _UpdateQuotationSheetState extends State<_UpdateQuotationSheet> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _vehicleValueCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _companyNameCtrl;
  late TextEditingController _titleCtrl;

  File? _newLogoFile;
  File? _newPdfFile;
  String? _newLogoFileName;
  String? _newPdfFileName;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // ── Autofill existing values ──
    _vehicleValueCtrl =
        TextEditingController(text: widget.item.vehicleValue);
    _priceCtrl = TextEditingController(text: widget.item.price);
    _companyNameCtrl =
        TextEditingController(text: widget.item.companyName);
    _titleCtrl = TextEditingController(text: widget.item.title);
  }

  @override
  void dispose() {
    _vehicleValueCtrl.dispose();
    _priceCtrl.dispose();
    _companyNameCtrl.dispose();
    _titleCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );
    if (result == null || result.files.single.path == null) return;
    setState(() {
      _newLogoFile = File(result.files.single.path!);
      _newLogoFileName = result.files.single.name;
    });
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: false,
    );
    if (result == null || result.files.single.path == null) return;
    setState(() {
      _newPdfFile = File(result.files.single.path!);
      _newPdfFileName = result.files.single.name;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      await updateQuotation(
        id: widget.item.id.toString(),
        vehicleValue: _vehicleValueCtrl.text.trim(),
        price: _priceCtrl.text.trim(),
        companyName: _companyNameCtrl.text.trim(),
        title: _titleCtrl.text.trim(),
        subId: widget.item.subId,
        oldLogoName: widget.item.logo,
        oldPdfName: widget.item.pdfFile,
        logoFile: _newLogoFile,
        pdfFile: _newPdfFile,
      );

      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess();
        final c = AppColors.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Quotation updated successfully!'),
            backgroundColor: c.green,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        final c = AppColors.of(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Update failed: $e'),
            backgroundColor: c.red,
            behavior: SnackBarBehavior.floating,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(20, 0, 20, bottom + 24),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Handle bar ──
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12, bottom: 20),
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: c.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // ── Header ──
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: c.tealLight,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.edit, color: c.teal, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Text(
                        'Update Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: c.text,
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                  SizedBox(width: 120),
                  Text(
                    'ID: ${widget.item.id}',
                    style:
                    TextStyle(fontSize: 16, color: c.orange),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Vehicle Value ──
              _SheetLabel(label: 'Vehicle Value', c: c),
              const SizedBox(height: 6),
              _SheetTextField(
                controller: _vehicleValueCtrl,
                hint: 'e.g. 500000',
                keyboardType: TextInputType.number,
                prefix: Icons.directions_car_rounded,
                c: c,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // ── Premium Price ──
              _SheetLabel(label: 'Premium Price', c: c),
              const SizedBox(height: 6),
              _SheetTextField(
                controller: _priceCtrl,
                hint: 'e.g. 12000',
                keyboardType: TextInputType.number,
                prefix: Icons.currency_rupee_rounded,
                c: c,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // ── Company Name ──
              _SheetLabel(label: 'Company Name', c: c),
              const SizedBox(height: 6),
              _SheetTextField(
                controller: _companyNameCtrl,
                hint: 'e.g. HDFC ERGO',
                prefix: Icons.business_rounded,
                c: c,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // ── Plan Title ──
              _SheetLabel(label: 'Plan Title', c: c),
              const SizedBox(height: 6),
              _SheetTextField(
                controller: _titleCtrl,
                hint: 'e.g. Comprehensive Plan',
                prefix: Icons.label_rounded,
                c: c,
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 20),

              // ── File pickers row ──
              Row(
                children: [
                  // Logo picker
                  Expanded(
                    child: _FilePicker(
                      label: 'Logo',
                      fileName: _newLogoFileName ?? widget.item.logo,
                      isNew: _newLogoFileName != null,
                      icon: Icons.image_rounded,
                      color: c.accent,
                      bgColor: c.accentLight,
                      onTap: _pickLogo,
                      c: c,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // PDF picker
                  Expanded(
                    child: _FilePicker(
                      label: 'PDF File',
                      fileName: _newPdfFileName ?? widget.item.pdfFile,
                      isNew: _newPdfFileName != null,
                      icon: Icons.picture_as_pdf_rounded,
                      color: c.red,
                      bgColor: c.redLight,
                      onTap: _pickPdf,
                      c: c,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Submit button ──
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.teal,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: c.teal.withOpacity(.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                      : const Text(
                    'Update Quotation',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── SHEET HELPER WIDGETS ─────────────────────────────────────────────────────

class _SheetLabel extends StatelessWidget {
  final String label;
  final AppColors c;
  const _SheetLabel({required this.label, required this.c});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: c.muted,
        color: Colors.white70,
        letterSpacing: .2,
      ),
    );
  }
}

class _SheetTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData prefix;
  final AppColors c;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _SheetTextField({
    required this.controller,
    required this.hint,
    required this.prefix,
    required this.c,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: c.text,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: c.muted, fontSize: 13),
        prefixIcon: Icon(prefix, color: c.muted, size: 18),
        filled: true,
        fillColor: c.bg,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.teal, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: c.red, width: 1.5),
        ),
      ),
    );
  }
}

class _FilePicker extends StatelessWidget {
  final String label;
  final String fileName;
  final bool isNew;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;
  final AppColors c;

  const _FilePicker({
    required this.label,
    required this.fileName,
    required this.isNew,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.onTap,
    required this.c,
  });

  @override
  Widget build(BuildContext context) {
    final displayName = fileName.isNotEmpty
        ? fileName.split('/').last.split('\\').last
        : 'Not selected';
    final hasFile = fileName.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isNew ? bgColor : c.bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isNew ? color.withOpacity(.4) : c.border,
            width: 1.2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: isNew ? color : c.muted),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isNew ? color : c.muted,
                  ),
                ),
                const Spacer(),
                if (isNew)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: color.withOpacity(.15),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: color),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              hasFile ? displayName : 'Tap to select',
              style: TextStyle(
                fontSize: 11,
                color: hasFile ? c.text : c.muted,
                fontWeight:
                hasFile ? FontWeight.w600 : FontWeight.w400,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── MAIN CARD ────────────────────────────────────────────────────────────────
class _MainCard extends StatefulWidget {
  final SocialInsuranceProject project;
  const _MainCard({required this.project});

  @override
  State<_MainCard> createState() => _MainCardState();
}

class _MainCardState extends State<_MainCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;
  late AnimationController _animController;
  late Animation<double> _expandAnim;
  late Animation<double> _rotateAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _expandAnim =
        CurvedAnimation(parent: _animController, curve: Curves.easeInOut);
    _rotateAnim = Tween<double>(begin: 0, end: 0.5).animate(_expandAnim);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _animController.forward() : _animController.reverse();
  }

  String _monthName(int m) => [
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ][m];

  @override
  Widget build(BuildContext context) {
    final p = widget.project;
    final c = AppColors.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final photoSize = screenWidth < 360 ? 64.0 : 80.0;

    String dateLabel = '—';
    if (p.currentDates.isNotEmpty) {
      try {
        final dt = DateTime.parse(p.currentDates);
        dateLabel = '${dt.day} ${_monthName(dt.month)} ${dt.year}';
      } catch (_) {}
    }

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vehicle photo
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: photoSize,
                  height: photoSize,
                  color: c.tealLight,
                  child: p.carPhoto != null && p.carPhoto!.isNotEmpty
                      ? Image.network(
                    imgUrl(p.carPhoto!),
                    fit: BoxFit.cover,
                    loadingBuilder: (ctx, child, progress) =>
                    progress == null
                        ? child
                        : Center(
                      child: CircularProgressIndicator(
                          color: c.teal, strokeWidth: 2),
                    ),
                    errorBuilder: (_, __, ___) => Icon(
                        Icons.directions_car_rounded,
                        color: c.teal,
                        size: 36),
                  )
                      : Icon(Icons.directions_car_rounded,
                      color: c.teal, size: 36),
                ),
              ),
              const SizedBox(width: 14),

              // ID + Vehicle number
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REFERENCE ID',
                      style: TextStyle(
                        fontSize: 10,
                        color: c.muted,
                        fontWeight: FontWeight.w800,
                        letterSpacing: .08,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'ID- ${p.id}',
                      style: TextStyle(
                        fontSize: screenWidth < 360 ? 18 : 22,
                        fontWeight: FontWeight.w800,
                        color: c.teal,
                        letterSpacing: -0.5,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: c.bg,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: c.border, width: 1.2),
                      ),
                      child: Text(
                        p.vehicleNumber.toUpperCase(),
                        style: TextStyle(
                          fontSize: screenWidth < 360 ? 11 : 13,
                          fontWeight: FontWeight.w700,
                          color: c.text,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Expand toggle
              GestureDetector(
                onTap: _toggle,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: _expanded ? c.teal : c.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: RotationTransition(
                    turns: _rotateAnim,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: _expanded ? Colors.white : c.muted,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Expandable details ──
          SizeTransition(
            sizeFactor: _expandAnim,
            axisAlignment: -1,
            child: FadeTransition(
              opacity: _expandAnim,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _Divider(),
                  Row(
                    children: [
                      Expanded(
                        child: _MetaItem(
                          label: 'Date Created',
                          value: dateLabel,
                          icon: Icons.calendar_today_rounded,
                        ),
                      ),
                      Expanded(
                        child: _MetaItem(
                          label: 'Pollution',
                          value: p.pollutionYesNo,
                        ),
                      ),
                    ],
                  ),
                  const _Divider(),
                  Text(
                    'Summary',
                    style: TextStyle(
                        fontSize: 11,
                        color: c.muted,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${p.vehicleCategory} ${p.vehicleType} • ${p.petrolDiesel} • '
                        'Claim: ${p.claim} • Pollution: ${p.pollutionYesNo}',
                    style:
                    TextStyle(fontSize: 13, color: c.muted, height: 1.6),
                  ),
                  const SizedBox(height: 10),
                  _InfoGrid(items: [
                    _InfoItem(label: 'Name', value: p.name),
                    _InfoItem(label: 'Phone', value: p.number),
                    _InfoItem(label: 'Email', value: p.emailId, small: true),
                    _InfoItem(label: 'Nominee', value: p.nomineName),
                    _InfoItem(label: 'Relation', value: p.nomineRelation),
                    _InfoItem(
                      label: 'Vehicle Type & Category',
                      value: '${p.vehicleType}  •  ${p.vehicleCategory}',
                      fullWidth: true,
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── INFO GRID ────────────────────────────────────────────────────────────────
class _InfoGrid extends StatelessWidget {
  final List<_InfoItem> items;
  const _InfoGrid({required this.items});

  @override
  Widget build(BuildContext context) {
    final fullW = items.where((e) => e.fullWidth).toList();
    final grid = items.where((e) => !e.fullWidth).toList();
    return Column(
      children: [
        for (int i = 0; i < grid.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              children: [
                Expanded(child: _InfoChip(item: grid[i])),
                const SizedBox(width: 10),
                if (i + 1 < grid.length)
                  Expanded(child: _InfoChip(item: grid[i + 1]))
                else
                  const Expanded(child: SizedBox()),
              ],
            ),
          ),
        for (final item in fullW)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _InfoChip(item: item, fullWidth: true),
          ),
      ],
    );
  }
}

class _InfoItem {
  final String label, value;
  final bool fullWidth, small;
  const _InfoItem({
    required this.label,
    required this.value,
    this.fullWidth = false,
    this.small = false,
  });
}

class _InfoChip extends StatelessWidget {
  final _InfoItem item;
  final bool fullWidth;
  const _InfoChip({required this.item, this.fullWidth = false});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: c.bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.label.toUpperCase(),
            style: TextStyle(
              fontSize: 9,
              color: c.muted,
              fontWeight: FontWeight.w700,
              letterSpacing: .08,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            item.value.isNotEmpty ? item.value : '—',
            style: TextStyle(
              fontSize: item.small ? 11 : 13,
              fontWeight: FontWeight.w600,
              color: c.text,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── COUNTDOWN DIALOG ─────────────────────────────────────────────────────────
class _CountdownDialog extends StatefulWidget {
  final String fileName;
  final VoidCallback onConfirmed;
  final VoidCallback onCancelled;

  const _CountdownDialog({
    required this.fileName,
    required this.onConfirmed,
    required this.onCancelled,
  });

  @override
  State<_CountdownDialog> createState() => _CountdownDialogState();
}

class _CountdownDialogState extends State<_CountdownDialog>
    with SingleTickerProviderStateMixin {
  int _seconds = 3;
  late AnimationController _animController;
  bool _cancelled = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _startCountdown();
  }

  void _startCountdown() async {
    for (int i = 3; i >= 1; i--) {
      if (!mounted || _cancelled) return;
      setState(() => _seconds = i);
      _animController.forward(from: 0);
      await Future.delayed(const Duration(seconds: 1));
    }
    if (mounted && !_cancelled) widget.onConfirmed();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: c.card,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 90,
              height: 90,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: CircularProgressIndicator(
                        value: 1.0, strokeWidth: 5, color: c.border),
                  ),
                  SizedBox(
                    width: 90,
                    height: 90,
                    child: AnimatedBuilder(
                      animation: _animController,
                      builder: (_, __) => CircularProgressIndicator(
                        value: 1.0 - _animController.value,
                        strokeWidth: 5,
                        color: c.accent,
                        strokeCap: StrokeCap.round,
                      ),
                    ),
                  ),
                  Text(
                    '$_seconds',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: c.accent,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'PDF will be updated',
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w800, color: c.text),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: c.accentLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.picture_as_pdf_rounded,
                      color: c.accent, size: 16),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      widget.fileName,
                      style: TextStyle(
                        color: c.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Update will start in $_seconds second${_seconds == 1 ? '' : 's'}.\nYou can still cancel.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: c.muted, height: 1.5),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  _cancelled = true;
                  widget.onCancelled();
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: c.accent,
                  side: BorderSide(color: c.accent, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── SHARED WIDGETS ───────────────────────────────────────────────────────────
class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Container(
      decoration: BoxDecoration(
        color: c.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: c.shadow, blurRadius: 12, offset: const Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: child,
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Divider(color: c.border, height: 1),
    );
  }
}

class _MetaItem extends StatelessWidget {
  final String label, value;
  final IconData? icon;
  const _MetaItem({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    final c = AppColors.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              fontSize: 11, color: c.muted, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: c.muted),
              const SizedBox(width: 5),
            ],
            Flexible(
              child: Text(
                value,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.text),
              ),
            ),
          ],
        ),
      ],
    );
  }
}