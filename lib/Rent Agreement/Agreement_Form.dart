import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Custom_Widget/Custom_backbutton.dart';
import 'package:http_parser/http_parser.dart';

class RentalWizardPage extends StatefulWidget {
  const RentalWizardPage({super.key});

  @override
  State<RentalWizardPage> createState() => _RentalWizardPageState();
}

class _RentalWizardPageState extends State<RentalWizardPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Form keys & controllers
  final _ownerFormKey = GlobalKey<FormState>();
  final ownerName = TextEditingController();
  String ownerRelation = 'S/O';
  final ownerRelationPerson = TextEditingController();
  final ownerAddress = TextEditingController();
  final ownerMobile = TextEditingController();
  final ownerAadhaar = TextEditingController();
  File? ownerAadhaarFront;
  File? ownerAadhaarBack;
  File? agreementPdf;

  final _tenantFormKey = GlobalKey<FormState>();
  final tenantName = TextEditingController();
  String tenantRelation = 'S/O';
  final tenantRelationPerson = TextEditingController();
  final tenantAddress = TextEditingController();
  final tenantMobile = TextEditingController();
  final tenantAadhaar = TextEditingController();
  File? tenantAadhaarFront;
  File? tenantAadhaarBack;
  File? tenantImage;

  final _propertyFormKey = GlobalKey<FormState>();
  final bhkWithAddress = TextEditingController();
  final rentAmount = TextEditingController();
  final securityAmount = TextEditingController();
  bool securityInstallment = false;
  final installmentAmount = TextEditingController();
  String meterInfo = 'As per Govt. Unit';
  final customUnitAmount = TextEditingController();
  final propertyID = TextEditingController();
  DateTime? shiftingDate;
  String maintenance = 'Including';
  String parking = 'Car';
  final customMaintanceAmount = TextEditingController();


  final ImagePicker _picker = ImagePicker();

  // animations
  late final AnimationController _fabController;



  String convertToWords(int number) {
    if (number == 0) return 'Zero';

    final ones = ['', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'];
    final teens = ['Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'];
    final tens = ['', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'];

    String twoDigits(int n) {
      if (n < 10) return ones[n];
      if (n < 20) return teens[n - 10];
      return '${tens[n ~/ 10]} ${ones[n % 10]}'.trim();
    }

    String threeDigits(int n) {
      int hundred = n ~/ 100;
      int rest = n % 100;
      String result = '';
      if (hundred > 0) result += '${ones[hundred]} Hundred ';
      if (rest > 0) result += twoDigits(rest);
      return result.trim();
    }

    List<String> parts = [];

    int lakh = number ~/ 100000;
    number %= 100000;
    if (lakh > 0) parts.add('${twoDigits(lakh)} Lakh');

    int thousand = number ~/ 1000;
    number %= 1000;
    if (thousand > 0) parts.add('${twoDigits(thousand)} Thousand');

    if (number > 0) parts.add(threeDigits(number));

    return parts.join(' ').trim();
  }


  String rentAmountInWords = '';
  String securityAmountInWords = '';
  String installmentAmountInWords = '';
  String customUnitAmountInWords = '';
  String customMaintanceAmountInWords = '';
  String _number = '';
  String _name = '';
  bool _userLoaded = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    _fabController.dispose();
    _pageController.dispose();
    ownerName.dispose();
    ownerRelationPerson.dispose();
    ownerAddress.dispose();
    ownerMobile.dispose();
    ownerAadhaar.dispose();
    tenantName.dispose();
    tenantRelationPerson.dispose();
    tenantAddress.dispose();
    tenantMobile.dispose();
    tenantAadhaar.dispose();
    bhkWithAddress.dispose();
    rentAmount.dispose();
    securityAmount.dispose();
    installmentAmount.dispose();
    customUnitAmount.dispose();
    super.dispose();
  }

  // ---------- Image picker ----------
  Future<void> _pickImage(String which) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;
    setState(() {
      switch (which) {
        case 'ownerFront':
          ownerAadhaarFront = File(picked.path);
          break;
        case 'ownerBack':
          ownerAadhaarBack = File(picked.path);
          break;
        case 'tenantFront':
          tenantAadhaarFront = File(picked.path);
          break;
        case 'tenantBack':
          tenantAadhaarBack = File(picked.path);
          break;

        case 'tenantImage':
          tenantImage = File(picked.path);
          break;
      }
    });
  }

  // ---------- Auto-fetch demo (replace with real API) ----------
  // Future<void> _autoFetchUser({required String query, required bool isOwner}) async {
  //   if (query.trim().isEmpty) return;
  //   Fluttertoast.showToast(msg: 'Fetching...'); // micro-feedback
  //   await Future.delayed(const Duration(milliseconds: 650));
  //   // Fake result for demo
  //   final fake = {
  //     'name': isOwner ? 'OM PRAKASH GUPTA' : 'RAVI KUMAR',
  //     'relationPerson': isOwner ? 'RAM PRASAD' : 'SURESH KUMAR',
  //     'address': isOwner ? 'H.NO 12, SECTOR 5, GURUGRAM' : 'FLAT 101, BLOCK B, NEW DELHI',
  //     'mobile': isOwner ? '9123456789' : '9988776655',
  //     'aadhaar': isOwner ? '122223341232' : '998877654556',
  //   };
  //
  //   setState(() {
  //     if (isOwner) {
  //       ownerName.text = fake['name']!;
  //       ownerRelationPerson.text = fake['relationPerson']!;
  //       ownerAddress.text = fake['address']!;
  //       ownerMobile.text = fake['mobile']!;
  //       ownerAadhaar.text = fake['aadhaar']!;
  //     } else {
  //       tenantName.text = fake['name']!;
  //       tenantRelationPerson.text = fake['relationPerson']!;
  //       tenantAddress.text = fake['address']!;
  //       tenantMobile.text = fake['mobile']!;
  //       tenantAadhaar.text = fake['aadhaar']!;
  //     }
  //   });
  //   Fluttertoast.showToast(msg: 'Auto-filled (demo)');
  // }

  // ---------- Navigation ----------
  void _goNext() {
    bool valid = false;
    if (_currentStep == 0) {
      valid = _ownerFormKey.currentState?.validate() == true && ownerAadhaarFront != null && ownerAadhaarBack != null;
      if (!valid && (ownerAadhaarFront == null || ownerAadhaarBack == null)) {
        Fluttertoast.showToast(msg: 'Please upload Owner Aadhaar images');
      }
    } else if (_currentStep == 1) {
      valid = _tenantFormKey.currentState?.validate() == true && tenantAadhaarFront != null && tenantAadhaarBack != null;
      if (!valid && (tenantAadhaarFront == null || tenantAadhaarBack == null)) {
        Fluttertoast.showToast(msg: 'Please upload Tenant Aadhaar images');
      }
    } else if (_currentStep == 2) {
      valid = _propertyFormKey.currentState?.validate() == true && shiftingDate != null;
      if (!valid && shiftingDate == null) Fluttertoast.showToast(msg: 'Please select shifting date');
    } else {
      valid = true;
    }

    if (valid) {
      if (_currentStep < 3) {
        setState(() => _currentStep++);
        _pageController.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
      }
    } else {
      Fluttertoast.showToast(msg: 'Complete required fields');
    }
  }

  void _goPrevious() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  void _jumpToStep(int step) {
    if (step <= _currentStep) {
      setState(() {
        _currentStep = step;
        _pageController.jumpToPage(step);
      });
    }
  }

  Future<void> _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _number = prefs.getString('number') ?? '';
  }



  Future<void> _submitAll() async {
    print("🔹 _submitAll called");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    // Ensure user data is loaded
    await _loaduserdata();
    print("Loaded Name: $_name, Number: $_number");

    try {
      _showToast('Uploading...');
      print("⏳ Uploading...");

      final uri = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreement.php");
      final request = http.MultipartRequest("POST", uri);

      // 🔹 Prepare text fields as JSON
      final Map<String, dynamic> textFields = {
        "owner_name": ownerName.text,
        "owner_relation": ownerRelation,
        "relation_person_name_owner": ownerRelationPerson.text,
        "parmanent_addresss_owner": ownerAddress.text,
        "owner_mobile_no": ownerMobile.text,
        "owner_addhar_no": ownerAadhaar.text,
        "tenant_name": tenantName.text,
        "tenant_relation": tenantRelation,
        "relation_person_name_tenant": tenantRelationPerson.text,
        "permanent_address_tenant": tenantAddress.text,
        "tenant_mobile_no": tenantMobile.text,
        "tenant_addhar_no": tenantAadhaar.text,
        "rented_address": bhkWithAddress.text,
        "monthly_rent": rentAmount.text,
        "securitys": securityAmount.text,
        "installment_security_amount": installmentAmount.text,
        "meter": meterInfo,
        "custom_meter_unit": customUnitAmount.text,
        "shifting_date": shiftingDate?.toIso8601String() ?? "",
        "maintaince": maintenance,
        "custom_maintenance_charge": customMaintanceAmount.text,
        "parking": parking,
        "current_dates": DateTime.now().toIso8601String(),
        "Fieldwarkarname": _name.isNotEmpty ? _name : '',
        "Fieldwarkarnumber": _number.isNotEmpty ? _number : '',
        "property_id": propertyID.text,
      };

      textFields.forEach((key, value) {
        request.fields[key] = value?.toString() ?? "";
      });

      print("✅ JSON Fields added");

      // 🔹 Add files (if they exist)
      Future<void> addFileSafe(String key, File? file, {String? filename, MediaType? type}) async {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(
            key,
            file.path,
            contentType: type,
            filename: filename ?? file.path.split("/").last,
          ));
          print("✅ File added: $key");
        }
      }

      await addFileSafe("owner_aadhar_front", ownerAadhaarFront, filename: "owner_aadhar_front.jpg");
      await addFileSafe("owner_aadhar_back", ownerAadhaarBack, filename: "owner_aadhar_back.jpg");
      await addFileSafe("tenant_aadhar_front", tenantAadhaarFront, filename: "tenant_aadhaar_front.jpg");
      await addFileSafe("tenant_aadhar_back", tenantAadhaarBack, filename: "tenant_aadhaar_back.jpg");
      await addFileSafe("agreement_pdf", agreementPdf, filename: "agreement.pdf", type: MediaType("application", "pdf"));
      await addFileSafe("tenant_image", tenantImage, filename: "tenant_image.jpg");

      print("📦 Fields ready: ${request.fields}");
      print("📎 Files ready: ${request.files.map((f) => f.filename).toList()}");

      // 🔹 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 Server responded with status: ${response.statusCode}");
      print("📄 Response body: ${response.body}");

      if (response.statusCode == 200 &&
          response.body.toLowerCase().contains("success")) {
        _showToast('Submitted successfully!');
        print("✅ Submission successful");
        Navigator.pop(context);
      } else {
        _showToast('Submit failed (${response.statusCode})');
        print("❌ Submission failed");
      }
    } catch (e) {
      _showToast('Submit error: $e');
      print("🔥 Exception during submit: $e");
    } finally {
      Navigator.pop(context); // remove loader
    }
  }


  Future<void> _addFile(
      http.MultipartRequest request,
      String field,
      File? file, {
        String? filename,
        MediaType? type,
      }) async {
    if (file == null) return;

    File? compressedFile = file;

    // Compress only if image
    final ext = p.extension(file.path).toLowerCase();
    if ([".jpg", ".jpeg", ".png"].contains(ext)) {
      final c = await _compressImage(file);
      if (c != null) compressedFile = c;
    }

    request.files.add(await http.MultipartFile.fromPath(
      field,
      compressedFile.path,
      filename: filename ?? p.basename(file.path),
      contentType: type,
    ));
  }


  Future<File?> _compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath = p.join(
      dir.path,
      "${DateTime.now().millisecondsSinceEpoch}.jpg",
    );

    final XFile? compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 70, // adjust quality (0–100)
    );

    if (compressed == null) return null;

    return File(compressed.path); // ✅ convert XFile → File
  }


// Centralized toast function with proper parameters
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

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.12),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.06) : Colors.white.withOpacity(0.08), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 8))],
          ),
          child: child,
        ),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }

  Widget _glowTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboard,
    String? Function(String?)? validator,
    void Function(String)? onFieldSubmitted,
    List<TextInputFormatter>? inputFormatters,
    void Function(String)? onChanged,  // <- add this

    bool showInWords = false, // ✅ define default here
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Focus(
              child: Builder(builder: (contextField) {
                final hasFocus = Focus.of(contextField).hasPrimaryFocus;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    boxShadow: hasFocus
                        ? [
                      BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.14),
                          blurRadius: 14,
                          spreadRadius: 1)
                    ]
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: keyboard,
                    textCapitalization: TextCapitalization.characters, // <-- make all letters uppercase
                    validator: validator,
                    onFieldSubmitted: onFieldSubmitted,
                    inputFormatters: inputFormatters,
                    decoration: InputDecoration(labelText: label),
                    onChanged: (v) {
                      if (showInWords) setState(() {});
                      if (onChanged != null) onChanged(v);  // forward to caller
                    },

                  ),
                );
              }),
            ),
            if (showInWords && controller.text.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4, left: 8),
                child: Text(
                  convertToWords(
                      int.tryParse(controller.text.replaceAll(',', '')) ?? 0),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        );
      },
    );
  }


  // small image tile
  Widget _imageTile(File? f, String hint) {
    return Container(
      width: 120,
      height: 72,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade200),
      child: f == null
          ? Center(child: Text(hint, style: const TextStyle(fontSize: 12)))
          : ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.file(f, fit: BoxFit.cover)),
    );
  }

  // ---------- Build UI ----------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Rental Agreement', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: SquareBackButton(),
        ),
      ),
      body: Stack(
        children: [
          // Background gradient & subtle shapes
          Positioned.fill(child: _buildBackground(isDark)),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 18),
                // Fancy top stepper (icons + progress)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    children: [
                      _fancyStepHeader(),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(padding: const EdgeInsets.all(18), child: _ownerStep()),
                      SingleChildScrollView(padding: const EdgeInsets.all(18), child: _tenantStep()),
                      SingleChildScrollView(padding: const EdgeInsets.all(18), child: _propertyStep()),
                      SingleChildScrollView(padding: const EdgeInsets.all(18), child: _previewStep()),
                    ],
                  ),
                ),

                // bottom controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white24,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _goPrevious,
                          icon: const Icon(Icons.arrow_back_rounded),
                          label: const Text('Back'),
                        ),
                      const Spacer(),
                      ElevatedGradientButton(
                        text: _currentStep == 3 ? 'Submit' : 'Next',
                        icon: _currentStep == 3 ? Icons.cloud_upload : Icons.arrow_forward,
                        onPressed:
                        _currentStep == 3 ?


                        _submitAll : _goNext,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(colors: [Color(0xFF07102B), Color(0xFF0B0C14)])
            : const LinearGradient(colors: [Color(0xFFE6F0FF), Color(0xFFFAFAFF)]),
      ),
      child: Stack(children: [
        // soft glowing blobs
        Positioned(top: -80, left: -40, child: _glowCircle(220, Colors.purpleAccent.withOpacity(isDark ? 0.14 : 0.14))),
        Positioned(bottom: -120, right: -40, child: _glowCircle(280, Colors.tealAccent.withOpacity(isDark ? 0.08 : 0.08))),
        // faint grid or pattern could be added here
      ]),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color, color.withOpacity(0.02)])),
    );
  }

  Widget _fancyStepHeader() {
    final stepLabels = ['Owner', 'Tenant', 'Property', 'Preview'];
    final stepIcons = [Icons.person, Icons.person_outline, Icons.home, Icons.preview];
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 94,
            child: LayoutBuilder(builder: (context, constraints) {
              final gap = (constraints.maxWidth - 64) / (stepLabels.length - 1);
              return Stack(children: [
                Positioned(top: 46, left: 32, right: 5, child: Container(height: 5, decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(6)))),

                // progress overlay
                Positioned(
                  top: 46,
                  left: 32,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    height: 6,
                    width: gap * _currentStep,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(colors: [Color(0xFF4CA1FF), Color(0xFF8A5CFF)]),
                    ),
                  ),
                ),

                ...List.generate(stepLabels.length, (i) {
                  final left = 0 + gap * i;
                  final isActive = i == _currentStep;
                  final isDone = i < _currentStep;
                  return Positioned(
                    left: left,
                    top: 0,
                    child: GestureDetector(
                      onTap: () => _jumpToStep(i),
                      child: Column(children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 350),
                          width: isActive ? 56 : 48,
                          height: isActive ? 56 : 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: isDone || isActive
                                ? const LinearGradient(colors: [Color(0xFF4CA1FF), Color(0xFF8A5CFF)])
                                : null,
                            color: isDone || isActive ? null : Colors.transparent,
                            border: Border.all(color: isActive ? const Color(0xFF8A5CFF) : Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.grey, width: 1.4),
                            boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 18, offset: const Offset(0, 6))] : null,
                          ),
                          child: Center(child: isDone ? const Icon(Icons.check, color: Colors.white) : Icon(stepIcons[i], color: isActive ? Colors.white : Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.grey,)),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(width: 84, child: Text(stepLabels[i], textAlign: TextAlign.center, style: TextStyle(color: i == _currentStep ?  Colors.purple: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white
                            : Colors.black, fontSize: 12))),
                      ]),
                    ),
                  );
                }),
              ]);
            }),
          ),
        ),
      ],
    );
  }

  Widget _ownerStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Owner Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Form(
          key: _ownerFormKey,
          child: Column(children: [
            _glowTextField(controller: ownerName, label: 'Owner Full Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: ownerRelation,
                  items: const ['S/O', 'D/O', 'W/O'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => ownerRelation = v ?? 'S/O'),
                  decoration: _fieldDecoration('Relation'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: ownerRelationPerson, label: 'Person Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
            ]),
            const SizedBox(height: 12),
            _glowTextField(controller: ownerAddress, label: 'Permanent Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _glowTextField(controller: ownerMobile, label: 'Mobile No', keyboard: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,       // only numbers
                  LengthLimitingTextInputFormatter(10),         // max 10 digits
                ],
                validator: (v) {

                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) return 'Enter valid 10-digit mobile';

                  return null;
                },

                // onFieldSubmitted: (val) => _autoFetchUser(query: val, isOwner: true)
              )
              ),
              const SizedBox(width: 12),

              Expanded(child: _glowTextField(controller: ownerAadhaar, label: 'Aadhaar No', keyboard: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,       // only numbers
                  LengthLimitingTextInputFormatter(12),         // max 12 digits
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!RegExp(r'^\d{12}$').hasMatch(v)) return 'Enter valid 12-digit Aadhaar';
                  return null;

                },

                // onFieldSubmitted: (val) => _autoFetchUser(query: val, isOwner: true)
              )),
            ]),
            const SizedBox(height: 14),
            Column(children: [
              Row(
                children: [
                  _imageTile(ownerAadhaarFront, 'Front'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('ownerFront'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Front')),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  _imageTile(ownerAadhaarBack, 'Back'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('ownerBack'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Back')),
                ],
              ),
            ]),
            // const SizedBox(height: 12),
            // // Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () => _autoFetchUser(query: ownerMobile.text.isNotEmpty ? ownerMobile.text : ownerAadhaar.text, isOwner: true), icon: const Icon(Icons.search), label: const Text('Auto fetch'))),
          ]),
        ),
      ]),
    );
  }

  Widget _tenantStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Tenant Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Form(
          key: _tenantFormKey,
          child: Column(children: [
            _glowTextField(controller: tenantName, label: 'Tenant Full Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: tenantRelation,
                  items: const ['S/O', 'D/O', 'W/O'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => tenantRelation = v ?? 'S/O'),
                  decoration: _fieldDecoration('Relation'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: tenantRelationPerson, label: 'Person Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
            ]),
            const SizedBox(height: 12),
            _glowTextField(controller: tenantAddress, label: 'Permanent Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: _glowTextField(controller: tenantMobile, label: 'Mobile No', keyboard: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,       // only numbers
                  LengthLimitingTextInputFormatter(10),         // max 10 digits
                ],
                validator: (v) {

                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) return 'Enter valid 10-digit mobile';

                  return null;
                },

                // onFieldSubmitted: (val) => _autoFetchUser(query: val, isOwner: true)
              )
              ),
              const SizedBox(width: 12),

              Expanded(child: _glowTextField(controller: tenantAadhaar, label: 'Aadhaar No', keyboard: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,       // only numbers
                  LengthLimitingTextInputFormatter(12),         // max 12 digits
                ],
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (!RegExp(r'^\d{12}$').hasMatch(v)) return 'Enter valid 12-digit Aadhaar';
                  return null;

                },

                // onFieldSubmitted: (val) => _autoFetchUser(query: val, isOwner: true)
              )),
            ]),
            const SizedBox(height: 14),

            Column(children: [
              Row(
                children: [
                  _imageTile(tenantAadhaarFront, 'Front'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantFront'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Front')),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  _imageTile(tenantAadhaarBack, 'Back'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantBack'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Back')),
                ],
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  _imageTile(tenantImage, 'Tenant Photo'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantImage'), icon: const Icon(Icons.upload_file), label: const Text('Upload Photo')),
                ],
              ),
            ]),

            const SizedBox(height: 12),
            // Align(alignment: Alignment.centerRight, child: TextButton.icon(onPressed: () => _autoFetchUser(query: tenantMobile.text.isNotEmpty ? tenantMobile.text : tenantAadhaar.text, isOwner: false), icon: const Icon(Icons.search), label: const Text('Auto fetch'))),
          ]),
        ),
      ]),
    );
  }


  Widget _propertyStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Rented Property Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
        const SizedBox(height: 12),
        Form(
          key: _propertyFormKey,
          child: Column(children: [
            _glowTextField(controller: propertyID, label: 'Property ID', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),

            _glowTextField(controller: bhkWithAddress, label: 'BHK with Rented Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            Row(children: [
              Expanded(child: _glowTextField(controller: rentAmount, label: 'Monthly Rent (INR)', keyboard: TextInputType.number,  showInWords: true,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                  onChanged: (v) {
                    setState(() {
                      rentAmountInWords = convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                    });
                  },
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: securityAmount, label: 'Security Amount (INR)',        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                keyboard: TextInputType.number,  showInWords: true,onChanged: (v) {
                  setState(() {
                    securityAmountInWords = convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                }, validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,)),
            ]),
            const SizedBox(height: 8),
            CheckboxListTile(value: securityInstallment, onChanged: (v) => setState(() => securityInstallment = v ?? false), title: const Text('Pay security in installments?')),
            if (securityInstallment) _glowTextField(controller: installmentAmount, label: 'Installment Amount (INR)', keyboard: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                showInWords: true,onChanged: (v) {
                  setState(() {
                    installmentAmountInWords = convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                }, validator: (v) {
                  if (securityInstallment && (v == null || v.trim().isEmpty)) return 'Required';
                  return null;
                }),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: meterInfo, items: const ['As per Govt. Unit', 'Custom Unit (Enter Amount)'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => meterInfo = v ?? 'As per Govt. Unit'), decoration: _fieldDecoration('Meter Info')),
            if (meterInfo.startsWith('Custom')) _glowTextField(controller: customUnitAmount, label: 'Custom Unit Amount (INR)', keyboard: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                showInWords: true,onChanged: (v) {
                  setState(() {
                    customUnitAmountInWords = convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                }, validator: (v) {
                  if (meterInfo.startsWith('Custom') && (v == null || v.trim().isEmpty)) return 'Required';
                  return null;
                }),
            const SizedBox(height: 12),
            ListTile(contentPadding: EdgeInsets.zero, title: Text(shiftingDate == null ? 'Select Shifting Date' : 'Shifting: ${shiftingDate!.toLocal().toString().split(' ')[0]}'), trailing: const Icon(Icons.calendar_today), onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
              if (picked != null) setState(() => shiftingDate = picked);
            }),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: parking, items: const ['Car', 'Bike','No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => parking = v ?? 'Car'), decoration: _fieldDecoration('Parking')),

            DropdownButtonFormField<String>(value: maintenance, items: const ['Including', 'Excluding'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => maintenance = v ?? 'Including'), decoration: _fieldDecoration('Maintenance')),
            if (maintenance.startsWith('Excluding'))
              _glowTextField(
                controller: customMaintanceAmount,
                label: 'Custom Maintenance Amount (INR)',
                keyboard: TextInputType.number,
                showInWords: true,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
                onChanged: (v) {
                  setState(() {
                    customMaintanceAmountInWords = convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                },
                validator: (v) {
                  if (maintenance.startsWith('Excluding') && (v == null || v.trim().isEmpty)) return 'Required';
                  return null;
                },
              ),
            const SizedBox(height: 12),
            const Text('Tip: These values will appear in the final agreement preview.'),
          ]
          ),
        ),
      ]),
    );
  }

  Widget _previewStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Preview', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
          Row(children: [
            IconButton(onPressed: () {
              // _jumpToStep(0); //Currently, not important!!
            }, icon: const Icon(Icons.edit)),
          ])
        ]),
        const SizedBox(height: 12),
        _sectionCard(title: '*Owner', children: [
          _kv('Name', ownerName.text),
          _kv('Relation', ownerRelation),
          _kv('Relation Person', ownerRelationPerson.text),
          _kv('Mobile', ownerMobile.text),
          _kv('Aadhaar', ownerAadhaar.text),
          _kv('Address', ownerAddress.text),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Aadhaar Images'),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            _imageTile(ownerAadhaarFront, 'Front'),
            const SizedBox(width: 8),
            _imageTile(ownerAadhaarBack, 'Back'),
            const Spacer(),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => _jumpToStep(0), child: const Text('Edit')),
            ],
          )

        ]),
        const SizedBox(height: 12),
        _sectionCard(title: '*Tenant', children: [
          _kv('Name', tenantName.text),
          _kv('Relation', tenantRelation),
          _kv('Relation Person', tenantRelationPerson.text),
          _kv('Mobile', tenantMobile.text),
          _kv('Aadhaar', tenantAadhaar.text),
          _kv('Address', tenantAddress.text),
          const SizedBox(height: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aadhaar Images'),
              const SizedBox(height: 8),
              Row(children: [
                _imageTile(tenantAadhaarFront, 'Front'),
                const SizedBox(width: 8),
                _imageTile(tenantAadhaarBack, 'Back'),
                const Spacer(),
              ]),
              const SizedBox(height: 8),
              Text('Tenant Photo'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _imageTile(tenantImage, 'Tenant Photo'),
                  const SizedBox(width: 100),
                  TextButton(onPressed: () => _jumpToStep(1), child: const Text('Edit'))
                ],
              ),
            ],
          )
        ]),
        const SizedBox(height: 12),
        _sectionCard(title: '*Property', children: [
          _kv('BHK & Address', bhkWithAddress.text),
          _kv('Rent', '${rentAmount.text} (${rentAmountInWords})'),
          _kv('Security', '${securityAmount.text} (${securityAmountInWords})'),
          if (securityInstallment) _kv('Installment', '${installmentAmount.text} (${installmentAmountInWords})'),
          _kv('Meter Info', meterInfo),
          if (meterInfo.startsWith('Custom')) _kv('Custom Unit', '${customUnitAmount.text} (${customUnitAmountInWords})'),
          _kv('Shifting', shiftingDate == null ? '' : shiftingDate!.toLocal().toString().split(' ')[0]),
          _kv('Maintenance', maintenance),
          if (maintenance.startsWith('Excluding')) _kv('Maintenance', '${customMaintanceAmount.text} (${customMaintanceAmountInWords})'),

          const SizedBox(height: 8),
          Row(children: [const Spacer(), TextButton(onPressed: () => _jumpToStep(2), child: const Text('Edit'))])
        ]),
        const SizedBox(height: 12),
        Text('* IMPORTANT : When you tap Submit we send data & uploaded Aadhaar images to server for Approval from the Admin.',style: TextStyle(color: Colors.red),),
      ]),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        _glassContainer(child: Column(children: children), padding: const EdgeInsets.all(14)),
      ]),
    );
  }

  Widget _kv(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [SizedBox(width: 140, child: Text('$k:', style: const TextStyle(fontWeight: FontWeight.w600))), Expanded(child: Text(v))]),
    );
  }
}

class ElevatedGradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const ElevatedGradientButton({required this.text, required this.icon, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF4CA1FF), Color(0xFF8A5CFF)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}
