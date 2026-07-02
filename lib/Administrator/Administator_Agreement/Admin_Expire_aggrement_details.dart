import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';
import 'package:http/http.dart' as http;
import '../../model/Expire_Agreement.dart';

class ExpireAgreementDetailPage extends StatefulWidget {
  final ExpireAgreementData data;

  const ExpireAgreementDetailPage({super.key, required this.data});

  static const String _baseUrl =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/';

  // Theme Colors
  static const Color kPurple       = Color(0xFF6A1B9A);
  static const Color kPurpleAccent = Color(0xFF9C27B0);
  static const Color kPurpleLight  = Color(0xFFF3E5F5);
  static const Color kPurpleBorder = Color(0xFFE1BEE7);
  static const Color kGreen        = Color(0xFF2E7D32);
  static const Color kGreenLight   = Color(0xFFE8F5E9);
  static const Color kWhite        = Colors.white;
  static const Color kDarkText     = Color(0xFF1A1A2E);

  @override
  State<ExpireAgreementDetailPage> createState() =>
      _ExpireAgreementDetailPageState();
}

class _ExpireAgreementDetailPageState
    extends State<ExpireAgreementDetailPage> {

  // ── Renewal Bottom Sheet Controllers ──────────────────────────────────────
  final TextEditingController _renewalRentController = TextEditingController();
  final TextEditingController _renewalDateController = TextEditingController();
  bool _isRenewalSubmitting = false;

  final bool isDark = false;

  @override
  void dispose() {
    _renewalRentController.dispose();
    _renewalDateController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  String _formatDate(AgreementDate? d) {
    if (d == null) return '—';
    final dt = d.date;
    return '${dt.day.toString().padLeft(2, '0')}-'
        '${dt.month.toString().padLeft(2, '0')}-'
        '${dt.year}';
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _openImageViewer(BuildContext context, String url, String label) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => _ImageViewerDialog(url: url, label: label),
    );
  }

  // ── 10% Rent Calculation ──────────────────────────────────────────────────
  double _calculateIncreasedRent() {
    final currentRent = double.tryParse(widget.data.monthlyRent) ?? 0.0;
    return currentRent + (currentRent * 10 / 100);
  }

  //── Submit API — uses renewal fields ─────────────────────────────────────
  Future<void> _submitRenewal({
    required String rent,
    required String date,
  }) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(
          color: ExpireAgreementDetailPage.kPurple,
        ),
      ),
    );

    try {
      final uri = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement.php",
      );

      final request = http.MultipartRequest("POST", uri);

      final Map<String, String> fields = {
        "owner_name":                  widget.data.ownerName,
        "owner_relation":              widget.data.ownerRelation,
        "relation_person_name_owner":  widget.data.relationPersonNameOwner,
        "parmanent_addresss_owner":    widget.data.parmanentAddresssOwner,
        "owner_mobile_no":             widget.data.ownerMobileNo,
        "owner_addhar_no":             widget.data.ownerAddharNo,
        "tenant_name":                 widget.data.tenantName,
        "tenant_relation":             widget.data.tenantRelation,
        "relation_person_name_tenant": widget.data.relationPersonNameTenant,
        "permanent_address_tenant":    widget.data.permanentAddressTenant,
        "tenant_mobile_no":            widget.data.tenantMobileNo,
        "tenant_addhar_no":            widget.data.tenantAddharNo,
        "is_Police":                   widget.data.isPolice ?? '',
        "Bhk":                         widget.data.bhk,
        "floor":                       widget.data.floor,
        "rented_address":              widget.data.rentedAddress,
        "securitys":                   widget.data.security,
        "installment_security_amount": widget.data.installmentSecurityAmount,
        "meter":                       widget.data.meter,
        "custom_meter_unit":           widget.data.customMeterUnit,
        "shifting_date":               _formatDate(widget.data.shiftingDate),
        "maintaince":                  widget.data.maintaince,
        "custom_maintenance_charge":   widget.data.customMaintenanceCharge,
        "parking":                     widget.data.parking,
        "Fieldwarkarname":             widget.data.fieldWorkerName,
        "Fieldwarkarnumber":           widget.data.fieldWorkerNumber,
        "property_id":                 widget.data.id.toString(),
        "agreement_price":             widget.data.agreementPrice ?? '',
        "notary_price":                widget.data.notaryPrice ?? '',
        "is_agreement_hide":           widget.data.isAgreementHide,
        "agreement_type":              "Renewal Agreement",
        // ✅ Controllers ki jagah saved parameters use karo
        "monthly_rent":  rent,
        "current_dates": date,
      };

      request.fields.addAll(fields);

      void attachUrl(String key, String url) {
        if (url.isNotEmpty) {
          final filename = url.contains("/agreement/")
              ? url.split("/agreement/").last
              : url;
          request.fields[key] = filename;
        }
      }

      attachUrl("owner_aadhar_front",  widget.data.ownerAadharFront);
      attachUrl("owner_aadhar_back",   widget.data.ownerAadharBack);
      attachUrl("tenant_aadhar_front", widget.data.tenantAadharFront);
      attachUrl("tenant_aadhar_back",  widget.data.tenantAadharBack);
      attachUrl("tenant_image",        widget.data.tenantImage);
      attachUrl("agreement_pdf",       widget.data.agreementPdf);

      // Debug
      print("=== FIELDS SENT ===");
      request.fields.forEach((k, v) => print("  $k: $v"));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      if (mounted) Navigator.of(context, rootNavigator: true).pop();

      if (response.statusCode == 200 &&
          response.body.toLowerCase().contains("success")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Renewal successfully submitted!"),
            backgroundColor: ExpireAgreementDetailPage.kGreen,
            duration: Duration(seconds: 2),
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) Navigator.of(context).pop();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed: ${response.statusCode}\n${response.body}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ── Renewal  Sheet ──────────────────────────────────────────────────
  void _openRenewalBottomSheet() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // Auto-fill 10% increased rent
    final increasedRent = _calculateIncreasedRent();
    _renewalRentController.text = increasedRent.toStringAsFixed(0);

    // Auto-fill today's date
    final now = DateTime.now();
    _renewalDateController.text =
    '${now.day.toString().padLeft(2, '0')}-'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.year}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(sheetContext)
                    .viewInsets
                    .bottom,
              ),
              decoration:  BoxDecoration(
                color: isDark? Colors.black: Colors.white,
                borderRadius:
               const BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Handle bar
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                  
                        // Title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: ExpireAgreementDetailPage.kPurpleLight,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.autorenew,
                                  color: ExpireAgreementDetailPage.kPurple,
                                  size: 22),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Renewal Agreement',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: isDark? ExpireAgreementDetailPage.kWhite: ExpireAgreementDetailPage.kDarkText),
                                ),
                                 Text(
                                  'Fields update kar ke submit karein',
                                  style:
                                  TextStyle(fontSize: 12, color: isDark? Colors.grey: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                  
                        // 10% info banner
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: ExpireAgreementDetailPage.kGreenLight,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: ExpireAgreementDetailPage.kGreen
                                  .withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.trending_up,
                                  color: ExpireAgreementDetailPage.kGreen,
                                  size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  '10% increase applied: ₹${widget.data
                                      .monthlyRent} → ₹${increasedRent
                                      .toStringAsFixed(0)}',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      color: ExpireAgreementDetailPage.kGreen,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),
                  
                        // Monthly Rent Field
                         Text(
                          'Monthly Rent (₹)',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark? ExpireAgreementDetailPage.kWhite: ExpireAgreementDetailPage.kDarkText),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _renewalRentController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                           color: ExpireAgreementDetailPage.kPurple,// text color,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter monthly rent',
                            prefixIcon: const Icon(
                                Icons.account_balance_wallet_outlined,
                                color:  ExpireAgreementDetailPage.kPurple),
                            suffixIcon: const Icon(
                                Icons.currency_rupee,
                                color: Colors.purple,
                                size: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color:
                                    ExpireAgreementDetailPage.kPurpleBorder)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: ExpireAgreementDetailPage.kPurple,
                                    width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color:
                                    ExpireAgreementDetailPage.kPurpleBorder)),
                            filled: true,
                            fillColor: ExpireAgreementDetailPage.kPurpleLight,
                          ),
                        ),
                        const SizedBox(height: 16),
                  
                        // Current Date Field
                        Text(
                          'Current Date',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? ExpireAgreementDetailPage.kWhite
                                  : ExpireAgreementDetailPage.kDarkText),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _renewalDateController,
                          style: const TextStyle(
                            color: ExpireAgreementDetailPage.kPurple,// text color
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          readOnly: true,
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: sheetContext,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              builder: (ctx, child) =>
                                  Theme(
                                    data: Theme.of(ctx).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: ExpireAgreementDetailPage.kPurple,
                                      ),
                                    ),
                                    child: child!,
                                  ),
                            );
                            if (picked != null) {
                              setSheetState(() {
                                _renewalDateController.text =
                                '${picked.day.toString().padLeft(2, '0')}-'
                                    '${picked.month.toString().padLeft(2, '0')}-'
                                    '${picked.year}';
                              });
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Select date',
                            prefixIcon: const Icon(
                                Icons.calendar_today_outlined,
                                color: ExpireAgreementDetailPage.kPurple),
                            suffixIcon: const Icon(
                                Icons.edit_calendar_outlined,
                                color: Colors.purple,
                                size: 18),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color:
                                    ExpireAgreementDetailPage.kPurpleBorder)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color: ExpireAgreementDetailPage.kPurple,
                                    width: 2)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                    color:
                                    ExpireAgreementDetailPage.kPurpleBorder)),
                            filled: true,
                            fillColor: ExpireAgreementDetailPage.kPurpleLight,
                          ),
                        ),
                        const SizedBox(height: 24),
                  
                        // Submit Button
                        // ElevatedButton.icon(
                        //   // Submit Button ke onPressed mein yeh changes karo:
                        //   onPressed: _isRenewalSubmitting
                        //       ? null
                        //       : () async {
                        //     // Validation
                        //     if (_renewalRentController.text.trim().isEmpty ||
                        //         _renewalDateController.text.trim().isEmpty) {
                        //       ScaffoldMessenger.of(sheetContext).showSnackBar(
                        //         const SnackBar(content: Text('Sabhi fields fill karein!')),
                        //       );
                        //       return;
                        //     }
                        //
                        //     // ✅ FIX: Pehle values save karo local variables mein
                        //     final savedRent = _renewalRentController.text.trim();
                        //     final savedDate = _renewalDateController.text.trim();
                        //
                        //     setSheetState(() => _isRenewalSubmitting = true);
                        //
                        //     // Sheet band karo
                        //     Navigator.pop(sheetContext);
                        //
                        //     // ✅ Saved values pass karo
                        //     await _submitRenewal(rent: savedRent, date: savedDate);
                        //
                        //     if (mounted) {
                        //       setState(() => _isRenewalSubmitting = false);
                        //     }
                        //   },
                        //   icon: _isRenewalSubmitting
                        //       ? const SizedBox(
                        //     width: 18,
                        //     height: 18,
                        //     child: CircularProgressIndicator(
                        //         strokeWidth: 2, color: Colors.white),
                        //   )
                        //       : const Icon(Icons.check_circle_outline,
                        //       color: Colors.white),
                        //   label: Text(
                        //     _isRenewalSubmitting
                        //         ? 'Submitting...'
                        //         : 'Submit Renewal',
                        //     style: const TextStyle(
                        //         fontSize: 15,
                        //         fontWeight: FontWeight.w700,
                        //         color: Colors.white),
                        //   ),
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor:
                        //     ExpireAgreementDetailPage.kPurple,
                        //     minimumSize: const Size(double.infinity, 52),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12)),
                        //     elevation: 0,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,
              color: ExpireAgreementDetailPage.kWhite),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
     //bottomNavigationBar: _buildBottomButton(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderSection(),
            _buildImageGallery(),
            const SizedBox(height: 12),
            _buildRentSecurityRow(),
            const SizedBox(height: 12),
            _buildAddressCard(),
            const SizedBox(height: 12),
            _buildOwnerCard(),
            const SizedBox(height: 12),
            _buildTenantCard(),
            const SizedBox(height: 12),
            _buildDatesBanner(),
            const SizedBox(height: 12),
            _buildDocumentsSection(),
            const SizedBox(height: 12),
            _buildFieldWorkerCard(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  // ── 1. Header ─────────────────────────────────────────────────────────────
  Widget _buildHeaderSection() {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Container(
      color: isDark
          ? ExpireAgreementDetailPage.kDarkText
          : ExpireAgreementDetailPage.kWhite,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Property ID: -${widget.data.id}',
                style: TextStyle(
                    fontSize: 12,
                    color: isDark
                        ? Colors.grey.shade100
                        : Colors.grey.shade900),
              ),
              const SizedBox(height: 2),
              Text(
                widget.data.agreementType,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: ExpireAgreementDetailPage.kPurple,
                ),
              ),
            ],
          ),
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: ExpireAgreementDetailPage.kGreenLight,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children:  [
                Icon(Icons.circle,
                    color: ExpireAgreementDetailPage.kGreen, size: 7),
                SizedBox(width: 5),
                Text(
                  'ACTIVE',
                  style: TextStyle(
                    color: ExpireAgreementDetailPage.kGreen,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 2. Image Gallery ──────────────────────────────────────────────────────
  Widget _buildImageGallery() {
    final ownerImages = [
      widget.data.ownerAadharFront,
      widget.data.ownerAadharBack,
    ].where((e) => e.isNotEmpty).toList();

    final tenantImages = [
      widget.data.tenantAadharFront,
      widget.data.tenantAadharBack,
    ].where((e) => e.isNotEmpty).toList();

    if (ownerImages.isEmpty && tenantImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          if (ownerImages.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                decoration: BoxDecoration(
                    color: ExpireAgreementDetailPage.kPurple,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Owner Aadhar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: ownerImages
                  .asMap()
                  .entries
                  .map((entry) {
                final label = entry.key == 0 ? 'Front' : 'Back';
                final url =
                    '${ExpireAgreementDetailPage._baseUrl}${entry.value}';
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: entry.key < ownerImages.length - 1 ? 8 : 0),
                    child: _ImageThumbnail(
                      url: url,
                      label: label,
                      onTap: () =>
                          _openImageViewer(context, url, label),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (ownerImages.isNotEmpty && tenantImages.isNotEmpty)
            const SizedBox(height: 14),
          if (tenantImages.isNotEmpty) ...[
            Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: ExpireAgreementDetailPage.kPurple,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Tenant Aadhar',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: tenantImages
                  .asMap()
                  .entries
                  .map((entry) {
                final label = entry.key == 0 ? 'Front' : 'Back';
                final url =
                    '${ExpireAgreementDetailPage._baseUrl}${entry.value}';
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right:
                        entry.key < tenantImages.length - 1 ? 8 : 0),
                    child: _ImageThumbnail(
                      url: url,
                      label: label,
                      onTap: () =>
                          _openImageViewer(context, url, label),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  // ── 3. Rent + Security ────────────────────────────────────────────────────
  Widget _buildRentSecurityRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          Expanded(
            child: _InfoCard(
              icon: Icons.account_balance_wallet_outlined,
              iconColor: ExpireAgreementDetailPage.kPurple,
              label: 'MONTHLY RENT',
              value: '₹${widget.data.monthlyRent}',
              valueColor: ExpireAgreementDetailPage.kGreen,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _InfoCard(
              icon: Icons.shield_outlined,
              iconColor: ExpireAgreementDetailPage.kPurple,
              label: 'SECURITY',
              value: '₹${widget.data.security}',
              valueColor: ExpireAgreementDetailPage.kGreen,
            ),
          ),
        ],
      ),
    );
  }

  // ── 4. Address Card ───────────────────────────────────────────────────────
  Widget _buildAddressCard() {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: ExpireAgreementDetailPage.kPurpleLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.location_on_outlined,
                    color: ExpireAgreementDetailPage.kPurple, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('RENTED ADDRESS',
                        style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? Colors.black
                                : Colors.grey.shade900,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.8)),
                    const SizedBox(height: 3),
                    Text(
                      widget.data.rentedAddress.trim(),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ExpireAgreementDetailPage.kDarkText),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(
              color: isDark ? Colors.black : Colors.grey.shade500,
              height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              _MetaChip(
                  label: 'TYPE',
                  value: widget.data.bhk.isNotEmpty
                      ? widget.data.bhk
                      : widget.data.agreementType),
              _MetaChip(
                  label: 'FLOOR',
                  value: widget.data.floor.isNotEmpty
                      ? widget.data.floor
                      : '—'),
              _MetaChip(
                label: 'MAINTENANCE',
                value: widget.data.maintaince.isNotEmpty
                    ? widget.data.maintaince[0].toUpperCase() +
                    widget.data.maintaince.substring(1)
                    : '—',
                valueColor: ExpireAgreementDetailPage.kGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── 5. Owner Card ─────────────────────────────────────────────────────────
  Widget _buildOwnerCard() {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Owner Details',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ExpireAgreementDetailPage.kDarkText)),
              Icon(Icons.shield_outlined,
                  color: ExpireAgreementDetailPage.kPurpleAccent, size: 22),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _AvatarImage(
                imageUrl: widget.data.ownerAadharFront.isNotEmpty
                    ? '${ExpireAgreementDetailPage._baseUrl}${widget.data
                    .ownerAadharFront}'
                    : null,
                initials: widget.data.ownerName
                    .trim()
                    .isNotEmpty
                    ? widget.data.ownerName.trim()[0]
                    : 'O',
                bgColor: ExpireAgreementDetailPage.kPurpleAccent,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _toTitleCase(widget.data.ownerName.trim()),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ExpireAgreementDetailPage.kDarkText),
                  ),
                  Text(
                    '${widget.data.ownerRelation} ${_toTitleCase(
                        widget.data.relationPersonNameOwner.trim())}',
                    style:
                    TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(widget.data.ownerMobileNo,
                          style: const TextStyle(
                              fontSize: 13,
                              color: ExpireAgreementDetailPage.kPurple,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
              color: isDark ? Colors.black : Colors.grey.shade500,
              height: 1),
          const SizedBox(height: 8),
          Text('PERMANENT ADDRESS',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text(
            widget.data.parmanentAddresssOwner.trim(),
            style: const TextStyle(
                fontSize: 13,
                color: ExpireAgreementDetailPage.kDarkText),
          ),
        ],
      ),
    );
  }

  // ── 6. Tenant Card ────────────────────────────────────────────────────────
  Widget _buildTenantCard() {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tenant Details',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ExpireAgreementDetailPage.kDarkText)),
              Icon(Icons.person_outline, color: Colors.purple, size: 22),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              _AvatarImage(
                imageUrl: widget.data.tenantAadharFront.isNotEmpty
                    ? '${ExpireAgreementDetailPage._baseUrl}${widget.data
                    .tenantAadharFront}'
                    : null,
                initials: widget.data.tenantName
                    .trim()
                    .isNotEmpty
                    ? widget.data.tenantName.trim()[0]
                    : 'T',
                bgColor: ExpireAgreementDetailPage.kPurple,
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _toTitleCase(widget.data.tenantName.trim()),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: ExpireAgreementDetailPage.kDarkText),
                  ),
                  Text(
                    '${widget.data.tenantRelation} ${_toTitleCase(
                        widget.data.relationPersonNameTenant.trim())}',
                    style:
                    TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.phone_outlined,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(widget.data.tenantMobileNo,
                          style: const TextStyle(
                              fontSize: 13,
                              color: ExpireAgreementDetailPage.kPurple,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(
              color: isDark ? Colors.black : Colors.grey.shade500,
              height: 1),
          const SizedBox(height: 8),
          Text('PERMANENT ADDRESS',
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text(
            widget.data.permanentAddressTenant.trim(),
            style: const TextStyle(
                fontSize: 13,
                color: ExpireAgreementDetailPage.kDarkText),
          ),
        ],
      ),
    );
  }

  // ── 7. Dates Banner ───────────────────────────────────────────────────────
  Widget _buildDatesBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              ExpireAgreementDetailPage.kPurple,
              ExpireAgreementDetailPage.kPurpleAccent
            ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SHIFTING DATE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.purple.shade100,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _formatDate(widget.data.shiftingDate),
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.purple.shade300,
            ),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RENEWAL DUE',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.purple.shade100,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            _formatDate(widget.data.renewalDate),
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.history,
                        color: Colors.white,
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  // ── 8. Documents ──────────────────────────────────────────────────────────
  Widget _buildDocumentsSection() {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 10),
            child: Text('Documents',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: isDark
                        ? ExpireAgreementDetailPage.kWhite
                        : ExpireAgreementDetailPage.kPurple)),
          ),
          if (widget.data.agreementPdf.isNotEmpty)
            _DocRow(
              icon: Icons.picture_as_pdf,
              iconColor: Colors.red.shade400,
              fileName: 'Agreement_Main.pdf',
              onTap: () =>
                  _launchUrl(
                      '${ExpireAgreementDetailPage._baseUrl}${widget.data
                          .agreementPdf}'),
            ),
          if (widget.data.policeVerificationPdf.isNotEmpty)
            _DocRow(
              icon: Icons.verified_user_outlined,
              iconColor: ExpireAgreementDetailPage.kPurple,
              fileName: 'Police_Verification.pdf',
              onTap: () =>
                  _launchUrl(
                      '${ExpireAgreementDetailPage._baseUrl}${widget.data
                          .policeVerificationPdf}'),
            ),
        ],
      ),
    );
  }

  // ── 9. Field Worker ───────────────────────────────────────────────────────
  Widget _buildFieldWorkerCard() {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: ExpireAgreementDetailPage.kWhite,
          borderRadius: BorderRadius.circular(14),
          border:
          Border.all(color: ExpireAgreementDetailPage.kPurpleBorder),
        ),
        padding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: ExpireAgreementDetailPage.kPurpleLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.people_alt_outlined,
                  color: ExpireAgreementDetailPage.kPurple),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ASSIGNED FIELD WORKER',
                      style: TextStyle(
                          fontSize: 10,
                          color: isDark
                              ? Colors.black
                              : Colors.grey.shade900,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 2),
                  Text(
                    widget.data.fieldWorkerName,
                    style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: ExpireAgreementDetailPage.kDarkText),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () =>
                  _launchUrl('tel:${widget.data.fieldWorkerNumber}'),
              child: Row(
                children: [
                  const Icon(Icons.phone_outlined,
                      color: ExpireAgreementDetailPage.kPurple, size: 18),
                  const SizedBox(width: 5),
                  Text(
                    widget.data.fieldWorkerNumber,
                    style: const TextStyle(
                        fontSize: 14,
                        color: ExpireAgreementDetailPage.kPurple,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── 10. Bottom Button — ✅ Fixed: calls _openRenewalBottomSheet ───────────
  // Widget _buildBottomButton() {
  //   final isDark = Theme
  //       .of(context)
  //       .brightness == Brightness.dark;
  //   return Container(
  //     padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
  //     color: isDark
  //         ? ExpireAgreementDetailPage.kDarkText
  //         : Colors.white,
  //     child: ElevatedButton.icon(
  //       onPressed: _openRenewalBottomSheet, // ✅ Fixed
  //       icon: const Icon(Icons.autorenew,
  //           color: ExpireAgreementDetailPage.kWhite, size: 20),
  //       label: const Text(
  //         'Renewal Agreement',
  //         style: TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w700,
  //             color: ExpireAgreementDetailPage.kWhite),
  //       ),
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: ExpireAgreementDetailPage.kPurple,
  //         minimumSize: const Size(double.infinity, 52),
  //         shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(12)),
  //         elevation: 0,
  //       ),
  //     ),
  //   );
  // }

  String _toTitleCase(String s) {
    if (s.isEmpty) return s;
    return s
        .toLowerCase()
        .split(' ')
        .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }

  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}

// ── Reusable Widgets ──────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final Widget child;
  const _SectionCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1BEE7)),
      ),
      child: child,
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1BEE7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 22),
          const SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade900,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: valueColor ?? const Color(0xFF1A1A2E))),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _MetaChip(
      {required this.label, required this.value, this.valueColor});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: valueColor ?? const Color(0xFF1A1A2E))),
        ],
      ),
    );
  }
}

class _AvatarImage extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final Color? bgColor;

  const _AvatarImage(
      {this.imageUrl, required this.initials, this.bgColor});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 28,
      backgroundColor: bgColor ?? const Color(0xFF6A1B9A),
      backgroundImage:
      imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(initials,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white))
          : null,
    );
  }
}

class _DocRow extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String fileName;
  final VoidCallback onTap;

  const _DocRow({
    required this.icon,
    required this.iconColor,
    required this.fileName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE1BEE7)),
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(fileName,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF1A1A2E))),
            ),
            Icon(Icons.download_outlined,
                color: Colors.grey.shade500, size: 22),
          ],
        ),
      ),
    );
  }
}

class _NetImage extends StatelessWidget {
  final String url;
  const _NetImage(this.url);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) => Container(
        color: const Color(0xFFF3E5F5),
        child: const Icon(Icons.image_outlined,
            color: Color(0xFF9C27B0), size: 32),
      ),
    );
  }
}

class _ImageThumbnail extends StatelessWidget {
  final String url;
  final String label;
  final VoidCallback onTap;

  const _ImageThumbnail({
    required this.url,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border:
          Border.all(color: const Color(0xFFE1BEE7), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: const Color(0xFFF3E5F5),
                  child: const Icon(Icons.image_outlined,
                      color: Color(0xFF9C27B0), size: 32),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withOpacity(0.65),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Icon(Icons.zoom_in_rounded,
                          color: Colors.white, size: 16),
                    ],
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

class _ImageViewerDialog extends StatefulWidget {
  final String url;
  final String label;

  const _ImageViewerDialog({required this.url, required this.label});

  @override
  State<_ImageViewerDialog> createState() => _ImageViewerDialogState();
}

class _ImageViewerDialogState extends State<_ImageViewerDialog> {
  bool _downloading = false;

  Future<void> _downloadImage() async {
    setState(() => _downloading = true);
    try {
      final uri = Uri.parse(widget.url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } finally {
      if (mounted) setState(() => _downloading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _downloading ? null : _downloadImage,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A1B9A),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: _downloading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: Colors.white),
                  )
                      : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.download_rounded,
                          color: Colors.white, size: 16),
                      SizedBox(width: 5),
                      Text(
                        'Download',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.close,
                      color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4.0,
              child: Image.network(
                widget.url,
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (_, child, progress) {
                  if (progress == null) return child;
                  return SizedBox(
                    height: 260,
                    child: Center(
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                            : null,
                        color: const Color(0xFF6A1B9A),
                      ),
                    ),
                  );
                },
                errorBuilder: (_, __, ___) => Container(
                  height: 260,
                  color: const Color(0xFFF3E5F5),
                  child: const Center(
                    child: Icon(Icons.broken_image_outlined,
                        color: Color(0xFF9C27B0), size: 48),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pinch to zoom',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}