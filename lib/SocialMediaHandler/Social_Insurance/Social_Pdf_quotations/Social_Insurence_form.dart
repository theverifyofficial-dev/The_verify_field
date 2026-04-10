import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../Custom_Widget/constant.dart';
import 'Details_quotations.dart';

class Social_InsuranceForm extends StatefulWidget {
  final SocialInsurancePlan plan;
  final String subid;

  const Social_InsuranceForm({
    super.key,
    required this.plan,
    required this.subid,
  });

  @override
  State<Social_InsuranceForm> createState() => _Social_InsuranceFormState();
}

class _Social_InsuranceFormState extends State<Social_InsuranceForm> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleValueController = TextEditingController();
  final _premiumPriceController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _titleController = TextEditingController();

  File? _vehicleImage;
  File? _pdfFile;          // ← PDF file
  String? _pdfFileName;    // ← PDF display name
  bool _isSubmitting = false;
  String? _networkLogoUrl;  // existing logo filename (e.g. "abc.png"), NOT full URL
  String? _existingLogoFilename; // ← sirf filename store karo, URL nahi

  static const String _apiUrl =
      'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/new_cotaion.php';

  static const String _logoBaseUrl =
      'https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/insurance_uploads/';

  @override
  void dispose() {
    _vehicleValueController.dispose();
    _premiumPriceController.dispose();
    _companyNameController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    final p = widget.plan;
    if (p != null) {
      _companyNameController.text = p.companyName;
      _titleController.text = p.title;
      if (p.logo.isNotEmpty) {
        _existingLogoFilename = p.logo;           // ← sirf "abc.png" store karo
        _networkLogoUrl = _logoBaseUrl + p.logo;  // ← display ke liye full URL
      }
    }
  }

  // ── Theme Helpers ─────────────────────────────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _scaffoldBg =>
      _isDark ? const Color(0xFF0D0F14) : const Color(0xFFF7F9FB);
  Color get _cardBg =>
      _isDark ? const Color(0xFF1C1F28) : Colors.white;
  Color get _primaryText =>
      _isDark ? const Color(0xFFE8EAF0) : const Color(0xFF191C1E);
  Color get _secondaryText =>
      _isDark ? const Color(0xFF9A9CAA) : const Color(0xFF434654);
  Color get _hintText =>
      _isDark ? const Color(0xFF555870) : const Color(0xFFADB5BD);
  Color get _iconColor =>
      _isDark ? const Color(0xFF737A99) : const Color(0xFF737685);
  Color get _borderColor =>
      _isDark ? const Color(0xFF2C2F3E) : const Color(0xFFC3C6D6).withAlpha(102);
  Color get _accentBlue =>
      _isDark ? const Color(0xFF4D8AFF) : const Color(0xFF003D9B);
  Color get _focusedBorderColor =>
      _isDark ? const Color(0xFF4D8AFF) : const Color(0xFF003D9B);
  Color get _labelColor =>
      _isDark ? const Color(0xFF9A9CAA) : const Color(0xFF434654);

  // ── Image Picker ──────────────────────────────────────────────
  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() => _vehicleImage = File(picked.path));
      }
    } catch (e) {
      _showSnackBar('Could not pick image: $e', isError: true);
    }
  }

  // ── PDF Picker ────────────────────────────────────────────────
  Future<void> _pickPdf() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() {
          _pdfFile = File(result.files.single.path!);
          _pdfFileName = result.files.single.name;
        });
      }
    } catch (e) {
      _showSnackBar('Could not pick PDF: $e', isError: true);
    }
  }

  // ── API Call ──────────────────────────────────────────────────
  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    if (_vehicleImage == null && _existingLogoFilename == null) {
      _showSnackBar('Please select a logo image.', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final request = http.MultipartRequest('POST', Uri.parse(_apiUrl));

      // Fields
      request.fields['vehicle_value'] = _vehicleValueController.text.trim();
      request.fields['price']         = _premiumPriceController.text.trim();
      request.fields['company_name']  = _companyNameController.text.trim();
      request.fields['tittle']        = _titleController.text.trim();
      request.fields['subid']         = widget.subid;

      // 🔥 LOGO HANDLING
      if (_vehicleImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('logo', _vehicleImage!.path),
        );
      } else if (_existingLogoFilename != null) {
        request.fields['existing_logo'] = _existingLogoFilename!;
      }

      // PDF (optional)
      if (_pdfFile != null) {
        request.files.add(
          await http.MultipartFile.fromPath('pdf_file', _pdfFile!.path),
        );
      }

      final response = await http.Response.fromStream(await request.send());

      if (!mounted) return;

      final jsonResponse = jsonDecode(response.body);

      if (response.statusCode == 200 && jsonResponse['success'] == true) {
        _showSnackBar('✅ Submitted successfully');
        _clearForm();
        Navigator.pop(context, true); 
      } else {
        _showSnackBar(
          '❌ ${jsonResponse['message'] ?? "Something went wrong"}',
          isError: true,
        );
      }

    } catch (e) {
      _showSnackBar('Error: $e', isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
  
  void _clearForm() {
    _vehicleValueController.clear();
    _premiumPriceController.clear();
    _companyNameController.clear();
    _titleController.clear();
    setState(() {
      _vehicleImage = null;
      _networkLogoUrl = null;
      _existingLogoFilename = null;
      _pdfFile = null;
      _pdfFileName = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? const Color(0xFFBA1A1A) : _accentBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // BUILD
  // ══════════════════════════════════════════════════════════════
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _scaffoldBg,
      extendBody: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: _isDark ? const Color(0xFF0D0F14) : Colors.black,
      elevation: 0,
      title: Image.asset(AppImages.transparent, height: 40),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.white),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: _isDark
              ? const Color(0xFF2C2F3E)
              : const Color(0xFFC3C6D6).withAlpha(51),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Heading ──────────────────────────────────────────
            Text(
              'Insurance\nForm',
              style: TextStyle(
                fontFamily: 'Manrope',
                fontSize: 38,
                fontWeight: FontWeight.w800,
                color: _primaryText,
                height: 1.1,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: _accentBlue,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 36),

            // ── Vehicle Value ─────────────────────────────────────
            _buildLabel('Vehicle Value'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _vehicleValueController,
              keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
              style: TextStyle(color: _primaryText),
              decoration: _inputDecoration(
                prefixText: '₹ ',
                hintText: '0.00',
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter vehicle value' : null,
            ),
            const SizedBox(height: 14),

            // ── Annual Premium ────────────────────────────────────
            _buildLabel('Annual Premium Price'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _premiumPriceController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: _primaryText),
              decoration: _inputDecoration(
                prefixIcon:
                Icon(Icons.payments_outlined, color: _iconColor, size: 20),
                hintText: 'Enter amount',
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter premium price' : null,
            ),
            const SizedBox(height: 14),

            // ── Company Name ──────────────────────────────────────
            _buildLabel('Insurance Company Name'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyNameController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: _primaryText),
              decoration: _inputDecoration(
                prefixIcon:
                Icon(Icons.business_outlined, color: _iconColor, size: 20),
                hintText: 'Enter company name',
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter company name' : null,
            ),
            const SizedBox(height: 14),

            // ── Title ─────────────────────────────────────────────
            _buildLabel('Title'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleController,
              keyboardType: TextInputType.text,
              style: TextStyle(color: _primaryText),
              decoration: _inputDecoration(
                prefixIcon:
                Icon(Icons.title_outlined, color: _iconColor, size: 20),
                hintText: 'Enter title',
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Enter title' : null,
            ),
            const SizedBox(height: 14),

            // ── Logo Picker ───────────────────────────────────────
            _buildLabel('Company Logo'),
            const SizedBox(height: 8),
            _buildImagePicker(),
            const SizedBox(height: 14),

            // ── PDF Picker ────────────────────────────────────────
            _buildLabel('Policy PDF (Optional)'),
            const SizedBox(height: 8),
            _buildPdfPicker(),
            const SizedBox(height: 32),

            // ── Submit ────────────────────────────────────────────
            _buildSubmitButton(),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Logo Picker Widget ────────────────────────────────────────
  Widget _buildImagePicker() {
    final bool hasLocalImage = _vehicleImage != null;
    final bool hasNetworkImage = _networkLogoUrl != null;
    final bool hasAnyImage = hasLocalImage || hasNetworkImage;

    return GestureDetector(
      onTap: _isSubmitting ? null : _pickImage,
      child: Container(
        width: double.infinity,
        height: 130,
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasAnyImage ? _accentBlue : _borderColor,
            width: hasAnyImage ? 2 : 1,
          ),
        ),
        child: hasAnyImage
            ? ClipRRect(
          borderRadius: BorderRadius.circular(11),
          child: Stack(
            fit: StackFit.expand,
            children: [
              hasLocalImage
                  ? Image.file(_vehicleImage!, fit: BoxFit.cover)
                  : Image.network(
                _networkLogoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Center(
                  child: Icon(Icons.broken_image,
                      color: _iconColor, size: 40),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: _isSubmitting
                      ? null
                      : () => setState(() {
                    _vehicleImage = null;
                    _networkLogoUrl = null;
                    _existingLogoFilename = null; // ← yeh bhi clear
                  }),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFBA1A1A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 14),
                  ),
                ),
              ),
            ],
          ),
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_upload_outlined,
                color: _accentBlue, size: 32),
            const SizedBox(height: 8),
            Text(
              'Tap to upload logo',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: _accentBlue,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'PNG, JPG supported',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: _iconColor.withAlpha(204),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── PDF Picker Widget ─────────────────────────────────────────
  Widget _buildPdfPicker() {
    final bool hasPdf = _pdfFile != null;

    return GestureDetector(
      onTap: _isSubmitting ? null : _pickPdf,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        decoration: BoxDecoration(
          color: _cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasPdf ? _accentBlue : _borderColor,
            width: hasPdf ? 2 : 1,
          ),
        ),
        child: hasPdf
            ? Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _accentBlue.withAlpha(26),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.picture_as_pdf_rounded,
                  color: _accentBlue, size: 26),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _pdfFileName ?? 'document.pdf',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _primaryText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Tap to change',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      color: _iconColor,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: _isSubmitting
                  ? null
                  : () => setState(() {
                _pdfFile = null;
                _pdfFileName = null;
              }),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Color(0xFFBA1A1A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close,
                    color: Colors.white, size: 14),
              ),
            ),
          ],
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.upload_file_outlined,
                color: _accentBlue, size: 28),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tap to upload PDF',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _accentBlue,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'PDF files only',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: _iconColor.withAlpha(204),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: _labelColor,
        letterSpacing: 1.4,
      ),
    );
  }

  InputDecoration _inputDecoration({
    Widget? prefixIcon,
    String? prefixText,
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: _hintText, fontSize: 14),
      prefixIcon: prefixIcon,
      prefixText: prefixText,
      prefixStyle: TextStyle(
        color: _iconColor,
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      filled: true,
      fillColor: _cardBg,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: _focusedBorderColor, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 2),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: _isDark
                ? [const Color(0xFF1A3A7A), const Color(0xFF2255BB)]
                : [const Color(0xFF003D9B), const Color(0xFF0052CC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(99),
          boxShadow: [
            BoxShadow(
              color: _accentBlue.withAlpha(77),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isSubmitting ? null : _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: const StadiumBorder(),
          ),
          child: _isSubmitting
              ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: Colors.white,
            ),
          )
              : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Submit',
                style: TextStyle(
                  fontFamily: 'Manrope',
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}