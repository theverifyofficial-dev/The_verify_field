import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;


import '../Custom_Widget/Custom_backbutton.dart';


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
  DateTime? shiftingDate;
  String maintenance = 'Including';

  final ImagePicker _picker = ImagePicker();

  // animations
  late final AnimationController _fabController;

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

  Future<void> _submitAll() async {
    if (!_ownerFormKey.currentState!.validate() ||
        !_tenantFormKey.currentState!.validate() ||
        !_propertyFormKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: 'Please complete all required fields.');
      return;
    }
    if (ownerAadhaarFront == null || ownerAadhaarBack == null ||
        tenantAadhaarFront == null || tenantAadhaarBack == null) {
      Fluttertoast.showToast(msg: 'Upload all Aadhaar images before submitting');
      return;
    }

    Fluttertoast.showToast(msg: 'Uploading...');

    try {
      var uri = Uri.parse("https://theverify.in/insert.php");
      var request = http.MultipartRequest("POST", uri);

      // 📝 Text fields
      request.fields.addAll({
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
        "custom_maintenance_charge": "",

        "current_dates": DateTime.now().toIso8601String(),
        "Fieldwarkarname": "",         // 🔹 fill if available
        "Fieldwarkarnumber": "",       // 🔹 fill if available
        "property_id": "",             // 🔹 fill if available
      });

      // 📎 File uploads (if available)
      if (ownerAadhaarFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "owner_aadhar_front",
          ownerAadhaarFront!.path,
          filename: "owner_a_front.jpg",
        ));
      }

      if (ownerAadhaarBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "owner_aadhar_back",
          ownerAadhaarBack!.path,
          filename: "owner_a_back.jpg",
        ));
      }


      if (tenantAadhaarFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "tenant_aadhar_front",
          tenantAadhaarFront!.path,
          filename: "tenant_a_front.jpg",
        ));
      }

      if (tenantAadhaarBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "tenant_aadhar_back",
          tenantAadhaarBack!.path,
          filename: "tenant_a_back.jpg",
        ));
      }

      // Optional: tenant photo
      if (tenantImage != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "tenant_image",
          tenantImage!.path,
          filename: "tenant_photo.jpg",
        ));
      }

      // Optional: agreement pdf
      if (agreementPdf != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "agreement_pdf",
          agreementPdf!.path,
          filename: "agreement.pdf",
        ));
      }

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Submitted successfully!');
        print("✅ Response: ${response.body}");
      } else {
        Fluttertoast.showToast(msg: 'Submit failed (${response.statusCode})');
        print("❌ Error: ${response.body}");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Submit error: $e');
      print("⚠️ Exception: $e");
    }
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

  Widget _glowTextField({required TextEditingController controller, required String label, TextInputType? keyboard, String? Function(String?)? validator, void Function(String)? onFieldSubmitted,  List<TextInputFormatter>? inputFormatters, // ✅ Add this
  }) {
    return Focus(
      child: Builder(builder: (contextField) {
        final hasFocus = Focus.of(contextField).hasPrimaryFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            boxShadow: hasFocus ? [BoxShadow(color: Theme.of(context).colorScheme.primary.withOpacity(0.14), blurRadius: 14, spreadRadius: 1)] : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboard,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            inputFormatters: inputFormatters,       // ✅ important
            decoration: _fieldDecoration(label),
          ),
        );
      }),
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
                  ElevatedButton.icon(onPressed: () => _pickImage('ownerFront'), icon: const Icon(Icons.upload_file), label: const Text('Upload Front')),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  _imageTile(ownerAadhaarBack, 'Back'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('ownerBack'), icon: const Icon(Icons.upload_file), label: const Text('Upload Back')),
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
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantFront'), icon: const Icon(Icons.upload_file), label: const Text('Upload Front')),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  _imageTile(tenantAadhaarBack, 'Back'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantBack'), icon: const Icon(Icons.upload_file), label: const Text('Upload Back')),
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
            _glowTextField(controller: bhkWithAddress, label: 'BHK with Rented Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            Row(children: [
              Expanded(child: _glowTextField(controller: rentAmount, label: 'Monthly Rent (INR)', keyboard: TextInputType.number, validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: securityAmount, label: 'Security Amount (INR)', keyboard: TextInputType.number, validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
            ]),
            const SizedBox(height: 8),
            CheckboxListTile(value: securityInstallment, onChanged: (v) => setState(() => securityInstallment = v ?? false), title: const Text('Pay security in installments?')),
            if (securityInstallment) _glowTextField(controller: installmentAmount, label: 'Installment Amount (INR)', keyboard: TextInputType.number, validator: (v) {
              if (securityInstallment && (v == null || v.trim().isEmpty)) return 'Required';
              return null;
            }),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: meterInfo, items: const ['As per Govt. Unit', 'Custom Unit (Enter Amount)'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => meterInfo = v ?? 'As per Govt. Unit'), decoration: _fieldDecoration('Meter Info')),
            if (meterInfo.startsWith('Custom')) _glowTextField(controller: customUnitAmount, label: 'Custom Unit Amount (INR)', keyboard: TextInputType.number, validator: (v) {
              if (meterInfo.startsWith('Custom') && (v == null || v.trim().isEmpty)) return 'Required';
              return null;
            }),
            const SizedBox(height: 12),
            ListTile(contentPadding: EdgeInsets.zero, title: Text(shiftingDate == null ? 'Select Shifting Date' : 'Shifting: ${shiftingDate!.toLocal().toString().split(' ')[0]}'), trailing: const Icon(Icons.calendar_today), onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(2000), lastDate: DateTime(2100));
              if (picked != null) setState(() => shiftingDate = picked);
            }),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(value: maintenance, items: const ['Including', 'Excluding'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => maintenance = v ?? 'Including'), decoration: _fieldDecoration('Maintenance')),
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
            IconButton(onPressed: () => _jumpToStep(0), icon: const Icon(Icons.edit)),
          ])
        ]),
        const SizedBox(height: 12),
        _sectionCard(title: 'Owner', children: [
          _kv('Name', ownerName.text),
          _kv('Relation', ownerRelation),
          _kv('Relation Person', ownerRelationPerson.text),
          _kv('Mobile', ownerMobile.text),
          _kv('Aadhaar', ownerAadhaar.text),
          _kv('Address', ownerAddress.text),
          const SizedBox(height: 8),
          Row(children: [
            _imageTile(ownerAadhaarFront, 'Front'),
            const SizedBox(width: 8),
            _imageTile(ownerAadhaarBack, 'Back'),
            const Spacer(),
          ]),
          Row(
            children: [
              TextButton(onPressed: () => _jumpToStep(0), child: const Text('Edit')),
            ],
          )

        ]),
        const SizedBox(height: 12),
        _sectionCard(title: 'Tenant', children: [
          _kv('Name', tenantName.text),
          _kv('Relation', tenantRelation),
          _kv('Relation Person', tenantRelationPerson.text),
          _kv('Mobile', tenantMobile.text),
          _kv('Aadhaar', tenantAadhaar.text),
          _kv('Address', tenantAddress.text),
          const SizedBox(height: 8),
          Row(children: [
            _imageTile(tenantAadhaarFront, 'Front'),
            const SizedBox(width: 8),
            _imageTile(tenantAadhaarBack, 'Back'),
            const Spacer(),
            TextButton(onPressed: () => _jumpToStep(1), child: const Text('Edit'))
          ])
        ]),
        const SizedBox(height: 12),
        _sectionCard(title: 'Property', children: [
          _kv('BHK & Address', bhkWithAddress.text),
          _kv('Rent', rentAmount.text),
          _kv('Security', securityAmount.text),
          if (securityInstallment) _kv('Installment', installmentAmount.text),
          _kv('Meter Info', meterInfo),
          if (meterInfo.startsWith('Custom')) _kv('Custom Unit', customUnitAmount.text),
          _kv('Shifting', shiftingDate == null ? '' : shiftingDate!.toLocal().toString().split(' ')[0]),
          _kv('Maintenance', maintenance),
          const SizedBox(height: 8),
          Row(children: [const Spacer(), TextButton(onPressed: () => _jumpToStep(2), child: const Text('Edit'))])
        ]),
        const SizedBox(height: 12),
        const Text('When you tap Generate / Submit we send data + uploaded Aadhaar images to server. You will receive a PDF link once processed.'),
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
