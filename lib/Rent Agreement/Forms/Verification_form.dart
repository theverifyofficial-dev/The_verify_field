import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Rent%20Agreement/history_tab.dart';
import '../../Custom_Widget/Custom_backbutton.dart';
import 'package:http_parser/http_parser.dart';

import '../Dashboard_screen.dart';


class TenantBlock {
  String? id; // 🔥 (for update case)

  final formKey = GlobalKey<FormState>(); // 🔥 ADD THIS

  final name = TextEditingController();
  final relationPerson = TextEditingController();
  final address = TextEditingController();
  final mobile = TextEditingController();
  final aadhaar = TextEditingController();

  String relation = 'S/O';

  File? aadhaarFront;
  File? aadhaarBack;
  File? photo;

  String? aadhaarFrontUrl;
  String? aadhaarBackUrl;
  String? photoUrl;
}

class VerificationWizardPage extends StatefulWidget {
  final String? agreementId;
  final RewardStatus rewardStatus;

  const VerificationWizardPage({Key? key, this.agreementId,required this.rewardStatus}) : super(key: key);

  @override
  State<VerificationWizardPage> createState() => _RentalWizardPageState();
}

class _RentalWizardPageState extends State<VerificationWizardPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  bool isAgreementHide = false; // 🔐 privacy toggle


  // Form keys & controllers
  final _ownerFormKey = GlobalKey<FormState>();
  final ownerName = TextEditingController();
  String ownerRelation = 'S/O';
  final ownerRelationPerson = TextEditingController();
  final ownerAddress = TextEditingController();
  final propertyAddress = TextEditingController();
  final ownerMobile = TextEditingController();
  final ownerAadhaar = TextEditingController();
  File? ownerAadhaarFront;
  File? ownerAadhaarBack;
  File? agreementPdf;
  final _tenantFormKey = GlobalKey<FormState>();

  List<TenantBlock> tenants = [TenantBlock()];

  Map<String, dynamic>? fetchedData;



  static const kAppGradient = LinearGradient(
    colors: [Color(0xFF4CA1FF), Color(0xFF00D4FF)], // Blue → Cyan
  );

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


  String? ownerAadharFrontUrl;
  String? ownerAadharBackUrl;
  String? tenantAadharFrontUrl;
  String? tenantAadharBackUrl;
  String? tenantPhotoUrl;



  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    if (widget.agreementId != null) {
      _fetchAgreementDetails(widget.agreementId!);
    }
  }

  Future<void> _fetchAgreementDetails(String id) async {
    final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=$id");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded["status"] == "success" && decoded["data"] != null && decoded["data"].isNotEmpty) {
        final data = decoded["data"][0]; // 👈 Get first record

        debugPrint("✅ Parsed Agreement Data: $data");

        setState(() {
          // 🔹 Owner
          ownerName.text = data["owner_name"] ?? "";
          ownerRelation = data["owner_relation"] ?? "S/O";
          ownerRelationPerson.text = data["relation_person_name_owner"] ?? "";
          ownerAddress.text = data["parmanent_addresss_owner"] ?? "";
          ownerMobile.text = data["owner_mobile_no"] ?? "";
          ownerAadhaar.text = data["owner_addhar_no"] ?? "";
          propertyAddress.text = data["rented_address"] ?? "";

          // 🔹 Tenant
          final d = tenants[0];

          d.name.text = data["tenant_name"] ?? "";
          d.relation = data["tenant_relation"] ?? "S/O";
          d.relationPerson.text = data["relation_person_name_tenant"] ?? "";
          d.address.text = data["permanent_address_tenant"] ?? "";
          d.mobile.text = data["tenant_mobile_no"] ?? "";
          d.aadhaar.text = data["tenant_addhar_no"] ?? "";

          d.aadhaarFrontUrl = data["tenant_aadhar_front"] ?? "";
          d.aadhaarBackUrl  = data["tenant_aadhar_back"] ?? "";
          d.photoUrl        = data["tenant_image"] ?? "";

          // 🔹 Documents
          ownerAadharFrontUrl = data["owner_aadhar_front"] ?? "";
          ownerAadharBackUrl  = data["owner_aadhar_back"] ?? "";
          tenantAadharFrontUrl = data["tenant_aadhar_front"] ?? "";
          tenantAadharBackUrl  = data["tenant_aadhar_back"] ?? "";
          tenantPhotoUrl       = data["tenant_image"] ?? "";
          isAgreementHide = data["is_agreement_hide"] == "1";
        });
      } else {
        debugPrint("⚠️ No agreement data found");
      }
    } else {
      debugPrint("❌ Failed to load agreement details: ${response.body}");
    }
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
    for (final d in tenants) {
      d.name.dispose();
      d.mobile.dispose();
      d.aadhaar.dispose();
      d.address.dispose();
      d.relationPerson.dispose();
    }
    super.dispose();
  }

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
      }
    });
  }

  Future<void> _pickTenantDoc(int index, bool isFront) async {
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    setState(() {
      if (isFront) {
        tenants[index].aadhaarFront = File(picked.path);
      } else {
        tenants[index].aadhaarBack = File(picked.path);
      }
    });
  }

  Future<void> _pickTenantPhoto(int index) async {
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    setState(() {
      tenants[index].photo = File(picked.path);
    });
  }

  void _goNext() {
    switch (_currentStep) {
      case 0:
        _validateOwnerStep();
        break;

      case 1:
        _validateTenantStep();
        break;

      default:
        break;
    }
  }

  void _validateOwnerStep() {
    final isValid = _ownerFormKey.currentState?.validate() ?? false;
    if (!isValid) return;

    if (ownerAadhaarFront == null &&
        (ownerAadharFrontUrl == null || ownerAadharFrontUrl!.isEmpty)) {
      _showToast("Upload Owner Aadhaar Front");
      return;
    }

    if (ownerAadhaarBack == null &&
        (ownerAadharBackUrl == null || ownerAadharBackUrl!.isEmpty)) {
      _showToast("Upload Owner Aadhaar Back");
      return;
    }

    _moveNext();
  }

  void _validateTenantStep() {
    if (tenants.isEmpty) {
      _showToast("Add at least one tenant");
      return;
    }

    for (int i = 0; i < tenants.length; i++) {
      final tenant = tenants[i];

      final isValid = tenant.formKey.currentState?.validate() ?? false;
      if (!isValid) {
        _showToast("Fix Fields in Tenant ${i + 1}");
        return;
      }

      if (tenant.aadhaarFront == null &&
          (tenant.aadhaarFrontUrl == null ||
              tenant.aadhaarFrontUrl!.isEmpty)) {
        _showToast("Upload Aadhaar Front for Tenant ${i + 1}");
        return;
      }

      if (tenant.aadhaarBack == null &&
          (tenant.aadhaarBackUrl == null ||
              tenant.aadhaarBackUrl!.isEmpty)) {
        _showToast("Upload Aadhaar Back for Tenant ${i + 1}");
        return;
      }

      if (tenant.photo == null &&
          (tenant.photoUrl == null ||
              tenant.photoUrl!.isEmpty)) {
        _showToast("Upload Photo for Tenant ${i + 1}");
        return;
      }
    }

    _moveNext();
  }

  void _moveNext() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
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

  Future<void> _fetchUserData({
    required bool fillOwner,
    required String? aadhaar,
    required String? mobile,
    int? tenantIndex,

  })
  async {
    String queryKey;
    String queryValue;

    if (aadhaar?.trim().isNotEmpty ?? false) {
      queryKey = "aadhaar";
      queryValue = aadhaar!.trim();
    } else if (mobile?.trim().isNotEmpty ?? false) {
      queryKey = "mobile";
      queryValue = mobile!.trim();
    } else {
      _showToast("Enter Aadhaar or Mobile number");
      return;
    }

    try {
      final uri = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/"
            "display_owner_and_tenant_addhar_document.php?$queryKey=$queryValue",
      );

      final response = await http.get(uri);
      print("📩 API Response: ${response.body}");

      if (response.statusCode != 200) {
        _showToast("${response.statusCode} Error");
        return;
      }

      final decoded = jsonDecode(response.body);

      if (decoded['success'] != true || decoded['data'] == null) {
        _showToast("No data found");
        return;
      }

      final data = decoded['data'];

      setState(() {
        if (fillOwner) {
          // ✅ Fill OWNER section
          ownerName.text = data['name'] ?? '';
          ownerRelation = data['relation'] ?? 'S/O';
          ownerRelationPerson.text =
              data['relation_person_name'] ?? '';
          ownerAddress.text = data['addresss'] ?? '';
          ownerMobile.text = data['mobile_number'] ?? '';
          ownerAadhaar.text = data['addhar_number'] ?? '';


          // 🔥 Convert auto-fetched URLs into real Files
          if (ownerAadharFrontUrl != null && ownerAadharFrontUrl!.isNotEmpty) {
            downloadAndConvertToFile(ownerAadharFrontUrl).then((file) {
              if (file != null) {
                setState(() {
                  ownerAadhaarFront = file;
                });
              }
            });
          }

          if (ownerAadharBackUrl != null && ownerAadharBackUrl!.isNotEmpty) {
            downloadAndConvertToFile(ownerAadharBackUrl).then((file) {
              if (file != null) {
                setState(() {
                  ownerAadhaarBack = file;
                });
              }
            });
          }

          ownerAadharFrontUrl = data['addhar_front'];
          ownerAadharBackUrl  = data['addhar_back'];

        } else if (tenantIndex != null &&
            tenantIndex >= 0 &&
            tenantIndex < tenants.length) {

          final d = tenants[tenantIndex];

          d.name.text = data['name'] ?? '';
          d.mobile.text = data['mobile_number'] ?? '';
          d.aadhaar.text = data['addhar_number'] ?? '';
          d.address.text = data['addresss'] ?? '';
          d.relation = data['relation'] ?? 'S/O';
          d.relationPerson.text = data['relation_person_name'] ?? '';

          d.aadhaarFrontUrl = data['addhar_front'];
          d.aadhaarBackUrl  = data['addhar_back'];
          d.photoUrl        = data['selfie'];

          // 🔥 Convert auto-fetched URLs into real Files
          if (d.aadhaarFrontUrl != null && d.aadhaarFrontUrl!.isNotEmpty) {
            downloadAndConvertToFile(d.aadhaarFrontUrl).then((file) {
              if (file != null) {
                setState(() {
                  d.aadhaarFront = file;
                });
              }
            });
          }

          if (d.aadhaarBackUrl != null && d.aadhaarBackUrl!.isNotEmpty) {
            downloadAndConvertToFile(d.aadhaarBackUrl).then((file) {
              if (file != null) {
                setState(() {
                  d.aadhaarBack = file;
                });
              }
            });
          }

          if (d.photoUrl != null && d.photoUrl!.isNotEmpty) {
            downloadAndConvertToFile(d.photoUrl).then((file) {
              if (file != null) {
                setState(() {
                  d.photo = file;
                });
              }
            });
          }

        }
      });

      print("✅ Data filled into ${fillOwner ? 'OWNER' : 'TENANT'} section");
    } catch (e) {
      print("🔥 Exception: $e");
      _showToast("Error: $e");
    }
  }

  Future<File?> downloadAndConvertToFile(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) return null;

    try {
      final fullUrl =
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$relativePath";

      final response = await http.get(Uri.parse(fullUrl));

      if (response.statusCode == 200) {
        final tempDir = await Directory.systemTemp.createTemp();
        final file = File("${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) {
      print("Download error: $e");
    }

    return null;
  }


  Future<void> _submitAll() async {
    print("🔹 _submitAll called");

    final firstTenant = tenants[0];

    int basePrice = widget.rewardStatus.isDiscounted ? 40 : 50;
    int totalPrice = tenants.length * basePrice;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await _loaduserdata();
    print("Loaded Name: $_name, Number: $_number");

    try {
      _showToast('Uploading...');
      print("⏳ Uploading...");

      final uri = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement.php",
      );
      final request = http.MultipartRequest("POST", uri);

      // 🔹 Prepare text fields (safe null handling)
      final Map<String, dynamic> textFields = {
        "owner_name": ownerName.text,
        "owner_relation": ownerRelation ?? '',
        "relation_person_name_owner": ownerRelationPerson.text,
        "parmanent_addresss_owner": ownerAddress.text,
        "owner_mobile_no": ownerMobile.text,
        "owner_addhar_no": ownerAadhaar.text,
        "tenant_name": firstTenant.name.text,
        "tenant_relation": firstTenant.relation,
        "relation_person_name_tenant": firstTenant.relationPerson.text,
        "permanent_address_tenant": firstTenant.address.text,
        "tenant_mobile_no": firstTenant.mobile.text,
        "tenant_addhar_no": firstTenant.aadhaar.text,
        "rented_address": propertyAddress.text,
        "Fieldwarkarname": _name.isNotEmpty ? _name : '',
        "Fieldwarkarnumber": _number.isNotEmpty ? _number : '',
        "is_agreement_hide": isAgreementHide ? "1" : "0",
        "agreement_price": totalPrice.toString(),
        "agreement_type": "Police Verification",
      };

      request.fields.addAll(textFields.map((k, v) => MapEntry(k, (v ?? '').toString())));
      print("✅ Text fields added");
      print("🔎 Final Fields: ${request.fields}");

      // 🔹 Helper to attach files or preserve existing URLs
      Future<void> attachFileOrUrl(
          String key,
          File? file,
          String? existingUrl, {
            String? filename,
            MediaType? type,
          }) async {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(
            key,
            file.path,
            contentType: type,
            filename: filename ?? file.path.split("/").last,
          ));
          print("✅ File added: $key (${file.path})");
        } else if (existingUrl != null && existingUrl.isNotEmpty) {
          final relativePath = existingUrl.replaceAll(
            RegExp(r"^https?:\/\/verifyrealestateandservices\.in\/(Second%20PHP%20FILE\/main_application\/agreement\/)?"),
            "",
          );
          request.fields[key] = relativePath;
          print("🔄 Preserved existing $key: $relativePath (from $existingUrl)");
        }
      }

      // 🔹 Attach files or preserve URLs
      await attachFileOrUrl("owner_aadhar_front", ownerAadhaarFront, ownerAadharFrontUrl,
          filename: "owner_aadhar_front.jpg");
      await attachFileOrUrl("owner_aadhar_back", ownerAadhaarBack, ownerAadharBackUrl,
          filename: "owner_aadhar_back.jpg");
      await attachFileOrUrl(
        "tenant_aadhar_front",
        firstTenant.aadhaarFront,
        firstTenant.aadhaarFrontUrl,
      );

      await attachFileOrUrl(
        "tenant_aadhar_back",
        firstTenant.aadhaarBack,
        firstTenant.aadhaarBackUrl,
      );

      await attachFileOrUrl(
        "tenant_image",
        firstTenant.photo,
        firstTenant.photoUrl,
      );

      await _attachAdditionalTenants(request);
      await attachFileOrUrl("agreement_pdf", agreementPdf, null,
          filename: "agreement.pdf", type: MediaType("application", "pdf"));

      print("📦 Files ready: ${request.files.map((f) => f.filename).toList()}");

      // 🔹 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 Server responded with status: ${response.statusCode}");
      print("📄 Response body: ${response.body}");

      if (response.statusCode == 200 && response.body.toLowerCase().contains("success")) {
        print("✅ Submission successful");

        // Close loader
        Navigator.of(context, rootNavigator: true).pop();

        // Show short SnackBar, then navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Submitted successfully!"),
            duration: const Duration(seconds: 1), // short duration
          ),
        ).closed.then((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HistoryTab()),
          );
        });

      } else {
        _showToast('Submit failed (${response.statusCode})');
        print("❌ Submission failed: ${response.body}");
      }
    } catch (e) {
      _showToast('Submit error: $e');
      print("🔥 Exception during submit: $e");
    }
  }

  Future<void> _updateAll() async   {
    print("🔹 _updateAll called");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    final firstTenant = tenants[0];

    int basePrice = widget.rewardStatus.isDiscounted ? 40 : 50;
    int totalPrice = tenants.length * basePrice;


    await _loaduserdata();
    print("Loaded Name: $_name, Number: $_number");

    try {
      _showToast('Updating...');
      print("⏳ Updating...");

      final uri = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement_update.php",
      );
      final request = http.MultipartRequest("POST", uri);

      final Map<String, dynamic> textFields = {
        "id": widget.agreementId,
        "owner_name": ownerName.text,
        "owner_relation": ownerRelation ?? '',
        "relation_person_name_owner": ownerRelationPerson.text,
        "parmanent_addresss_owner": ownerAddress.text,
        "owner_mobile_no": ownerMobile.text,
        "owner_addhar_no": ownerAadhaar.text, // confirm spelling with backend
        "tenant_name": firstTenant.name.text,
        "tenant_relation": firstTenant.relation,
        "relation_person_name_tenant": firstTenant.relationPerson.text,
        "permanent_address_tenant": firstTenant.address.text,
        "tenant_mobile_no": firstTenant.mobile.text,
        "tenant_addhar_no": firstTenant.aadhaar.text,
        "current_dates": DateTime.now().toIso8601String(),
        "rented_address": propertyAddress.text,
        "Fieldwarkarname": _name.isNotEmpty ? _name : '',
        "Fieldwarkarnumber": _number.isNotEmpty ? _number : '',
        "agreement_price": totalPrice.toString(),
        "is_agreement_hide": isAgreementHide ? "1" : "0",
      };

      request.fields.addAll(textFields.map((k, v) => MapEntry(k, (v ?? '').toString())));
      print("✅ Text fields added");
      print("🔎 Final Fields: ${request.fields}");

      // 🔹 Helper to attach files or preserve existing URLs
      Future<void> attachFileOrUrl(
          String key,
          File? file,
          String? existingUrl, {
            String? filename,
            MediaType? type,
          }) async {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(
            key,
            file.path,
            contentType: type,
            filename: filename ?? file.path.split("/").last,
          ));
          print("✅ File added: $key (${file.path})");
        } else if (existingUrl != null && existingUrl.isNotEmpty) {
          final relativePath = existingUrl.replaceAll(
            RegExp(r"^https?:\/\/verifyrealestateandservices\.in\/(Second%20PHP%20FILE\/main_application\/agreement\/)?"),
            "",
          );
          request.fields[key] = relativePath;
          print("🔄 Preserved existing $key: $relativePath (from $existingUrl)");
        }
      }

      // 🔹 Attach files or preserve URLs
      await attachFileOrUrl("owner_aadhar_front", ownerAadhaarFront, ownerAadharFrontUrl,
          filename: "owner_aadhar_front.jpg");
      await attachFileOrUrl("owner_aadhar_back", ownerAadhaarBack, ownerAadharBackUrl,
          filename: "owner_aadhar_back.jpg");
      await attachFileOrUrl(
        "tenant_aadhar_front",
        firstTenant.aadhaarFront,
        firstTenant.aadhaarFrontUrl,
      );

      await attachFileOrUrl(
        "tenant_aadhar_back",
        firstTenant.aadhaarBack,
        firstTenant.aadhaarBackUrl,
      );

      await attachFileOrUrl(
        "tenant_image",
        firstTenant.photo,
        firstTenant.photoUrl,
      );

      await _attachAdditionalTenants(request);

      await attachFileOrUrl("agreement_pdf", agreementPdf, null,
          filename: "agreement.pdf", type: MediaType("application", "pdf"));

      print("📦 Files ready: ${request.files.map((f) => f.filename).toList()}");

      // 🔹 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 Server responded with status: ${response.statusCode}");
      print("📄 Response body: ${response.body}");

      if (response.statusCode == 200 && response.body.toLowerCase().contains("success")) {

        print("✅ Submission successful");

        // Close loader
        Navigator.of(context, rootNavigator: true).pop();

        // Show short SnackBar, then navigate
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text("Updated successfully!"),
            duration: const Duration(seconds: 1),
          ),
        ).closed.then((_) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => HistoryTab()),
          );
        }
        );
      }

      else {
        _showToast('Submit failed (${response.statusCode})');
        print("❌ Resubmission failed: ${response.body}");
      }
    } catch (e) {
      _showToast('Submit error: $e');
      print("🔥 Exception during submit: $e");
    }
  }

  Future<void> _attachAdditionalTenants(http.MultipartRequest request) async {
    if (tenants.length <= 1) return;

    for (int i = 1; i < tenants.length; i++) {
      final t = tenants[i];
      final idx = i - 1;

      // 🔥 CASE 2 — Existing Tenant UPDATE
      if (t.id != null && t.id!.isNotEmpty) {
        request.fields['additional_tenants[$idx][id]'] = t.id!;
      }

      // 🔥 Common fields (update + insert)
      request.fields['additional_tenants[$idx][tenant_name]'] = t.name.text;
      request.fields['additional_tenants[$idx][tenant_relation]'] = t.relation;
      request.fields['additional_tenants[$idx][relation_person_name_tenant]'] =
          t.relationPerson.text;
      request.fields['additional_tenants[$idx][tenant_mobile]'] = t.mobile.text;
      request.fields['additional_tenants[$idx][tenant_aadhar_no]'] =
          t.aadhaar.text;
      request.fields['additional_tenants[$idx][tenant_address]'] =
          t.address.text;

      // 🔥 FILES
      if (t.aadhaarFront != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_tenants[$idx][tenant_aadhar_front]',
          t.aadhaarFront!.path,
        ));
      }

      if (t.aadhaarBack != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_tenants[$idx][tenant_aadhar_back]',
          t.aadhaarBack!.path,
        ));
      }

      if (t.photo != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'additional_tenants[$idx][tenant_photo]',
          t.photo!.path,
        ));
      }
    }
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

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
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
                    style: const TextStyle(
                      color: Colors.black, // ✅ make entered text visible (white on black)
                    ),
                    decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(
                      color: Colors.black, // ✅ label text color
                    ),  errorMaxLines: 2,
                      errorStyle: const TextStyle(
                        color: Color(0xFFB00020), // 🔥 darker red
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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

  Widget _imageTile({File? file, String? url, required String hint}) {
    return Container(
      width: 120,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade200,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: file != null
            ? Image.file(file, fit: BoxFit.cover)
            : (url != null && url.isNotEmpty)
            ? Image.network(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$url',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Text('Error', style: TextStyle(fontSize: 12)),
          ),
        )
            : Center(child: Text(hint, style: const TextStyle(fontSize: 12,color: Colors.black))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print('Agreement ID  : ${widget.agreementId}');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Police verification', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
                if (widget.rewardStatus.isDiscounted)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00C853), Color(0xFF64DD17)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.celebration, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "🎉 Congratulations! Discount applied.\n"
                                  "You completed ${widget.rewardStatus.totalAgreements} agreements this month.",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SingleChildScrollView(padding: const EdgeInsets.all(18), child: _ownerStep()),
                      SingleChildScrollView(padding: const EdgeInsets.all(18), child: _tenantStep()),
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
                        text: _currentStep == 2
                            ? (widget.agreementId != null ? 'Update' : 'Submit')
                            : 'Next',
                        icon: _currentStep == 2
                            ? Icons.cloud_upload
                            : Icons.arrow_forward,
                        onPressed: _currentStep == 2
                            ? () {
                          if (widget.agreementId != null) {
                            _updateAll(); // ✅ Update mode
                          } else {
                            _submitAll(); // ✅ New submission
                          }
                        }
                            : _goNext,
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
            ? const LinearGradient(
          colors: [
            Color(0xFF0A1938), // Deep navy
            Color(0xFF0E1330), // Midnight indigo
            Color(0xFF05080F), // Blackish blue base
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(
          colors: [
            Color(0xFFDCE9FF), // soft sky
            Color(0xFFBFD4FF), // mild blue
            Color(0xFFE6F0FF), // base tone
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Top glow — rich blue radiance
          Positioned(
            top: -100,
            left: -50,
            child: _glowCircle(
              250,
              isDark
                  ? Colors.indigoAccent.withOpacity(0.22)
                  : Colors.blueAccent.withOpacity(0.18),
            ),
          ),

          // Bottom glow — cyan shimmer
          Positioned(
            bottom: -120,
            right: -60,
            child: _glowCircle(
              320,
              isDark
                  ? Colors.cyanAccent.withOpacity(0.20)
                  : Colors.lightBlueAccent.withOpacity(0.20),
            ),
          ),

          // Center glow — luminous pulse
          Positioned(
            top: 200,
            right: 100,
            child: _glowCircle(
              180,
              isDark
                  ? Colors.deepPurpleAccent.withOpacity(0.12)
                  : Colors.indigoAccent.withOpacity(0.10),
            ),
          ),
        ],
      ),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.5), // stronger center light
            color.withOpacity(0.05), // soft edge diffusion
            Colors.transparent, // natural fade out
          ],
          stops: const [0.0, 0.5, 1.0],
          center: Alignment.center,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.25),
            blurRadius: size * 0.4,
            spreadRadius: size * 0.1,
          ),
        ],
      ),
    );
  }

  Widget _fancyStepHeader() {
    final stepLabels = ['Owner', 'Tenant', 'Preview'];
    final stepIcons = [Icons.person, Icons.person_outline, Icons.home, Icons.preview];

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 94,
            child: LayoutBuilder(builder: (context, constraints) {
              final gap = (constraints.maxWidth - 74) / (stepLabels.length - 1);

              return Stack(
                  children: [
                    Positioned(
                      top: 50,
                      left: 32,
                      right: 5,
                      child: Container(
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),

                    // ✅ Progress overlay with Blue → Cyan
                    Positioned(
                      top: 50,
                      left: 32,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 450),
                        height: 6,
                        width: gap * _currentStep,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          gradient: kAppGradient,
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
                                gradient: isDone || isActive ? kAppGradient : null,
                                color: isDone || isActive ? null : Colors.transparent,
                                border: Border.all(
                                  color: isActive
                                      ? const Color(0xFF00D4FF)
                                      : Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.grey,
                                  width: 1.4,
                                ),
                                boxShadow: isActive
                                    ? [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.18),
                                    blurRadius: 18,
                                    offset: const Offset(0, 6),
                                  )
                                ]
                                    : null,
                              ),
                              child: Center(
                                child: isDone
                                    ? const Icon(Icons.check, color: Colors.white)
                                    : Icon(
                                  stepIcons[i],
                                  color: isActive
                                      ? Colors.white
                                      : Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.grey,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: 84,
                              child: Text(
                                stepLabels[i],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: i == _currentStep
                                      ? Colors.cyan
                                      : Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 12,
                                ),
                              ),
                            ),
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

          Text('Property Residential Address', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.black)),

          const SizedBox(height: 12),
          _glowTextField(controller: propertyAddress, label: 'Residential Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
          const SizedBox(height: 12),

          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Owner Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.black)),

                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.cyan, Colors.blue],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _fetchUserData(
                        fillOwner: true,
                        aadhaar: ownerAadhaar.text,
                        mobile: ownerMobile.text,
                      );
                    },
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text(
                      'Auto fetch',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // remove default shadow
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ]
          ),

          const SizedBox(height: 12),
          Form(
            key: _ownerFormKey,
            child: Column(children: [
              Row(
                  children: [
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

                    Expanded(
                      child: _glowTextField(
                        controller: ownerAadhaar,
                        label: 'Aadhaar/VID No',
                        keyboard: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,  // only numbers
                          LengthLimitingTextInputFormatter(16),    // max 16 digits
                        ],
                      ),
                    ),
                  ]),
              const SizedBox(height: 14),
              _glowTextField(controller: ownerName, label: 'Owner Full Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
              const SizedBox(height: 12),
              Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: ownerRelation,
                        items: const ['S/O', 'D/O', 'W/O', 'C/O']
                            .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: TextStyle(color: Colors.black), // ✅ dropdown text black
                          ),
                        ))
                            .toList(),
                        onChanged: (v) => setState(() => ownerRelation = v ?? 'S/O'),
                        decoration: _fieldDecoration('Relation').copyWith(
                          labelStyle: const TextStyle(color: Colors.black), // ✅ label text black
                          hintStyle: const TextStyle(color: Colors.black54), // ✅ hint text dark gray
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black), // ✅ border black
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.black, width: 1.5),
                          ),
                        ),
                        iconEnabledColor: Colors.black, // ✅ dropdown arrow black
                        dropdownColor: Colors.white, // ✅ menu background white (good contrast)
                        style: const TextStyle(color: Colors.black), // ✅ selected text black
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: _glowTextField(controller: ownerRelationPerson, label: 'Person Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
                  ]),
              const SizedBox(height: 12),
              _glowTextField(controller: ownerAddress, label: 'Permanent Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
              const SizedBox(height: 12),
              Column(children: [
                Row(
                  children: [
                    _imageTile(file: ownerAadhaarFront, url: ownerAadharFrontUrl, hint: 'Front'),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(onPressed: () => _pickImage('ownerFront'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Front')),
                  ],
                ),

                const SizedBox(height: 16),
                Row(
                  children: [
                    _imageTile(file: ownerAadhaarBack, url: ownerAadharBackUrl, hint: 'Back'),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(onPressed: () => _pickImage('ownerBack'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Back')),
                  ],
                ),
              ]),
              const SizedBox(height: 12),
            ]
            ),
          ),
        ]
        )
    );
  }

  Widget _tenantStep() {
    return Column(
      children: [


        for (int index = 0; index < tenants.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _glassContainer(
              child: Form(
                  key: tenants[index].formKey,
                  autovalidateMode: AutovalidateMode.disabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// HEADER
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Tenant ${index + 1} Details',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 8,
                            children: [

                              /// AUTO FETCH
                              ElevatedButton.icon(
                                onPressed: () {
                                  _fetchUserData(
                                    fillOwner: false,
                                    aadhaar: tenants[index].aadhaar.text,
                                    mobile: tenants[index].mobile.text,
                                    tenantIndex: index,
                                  );
                                },
                                icon: const Icon(Icons.search,
                                    color: Colors.white, size: 18),
                                label: const Text('Auto fetch'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),

                              if (index > 0 &&
                                  (widget.agreementId == null || tenants[index].id == null))
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    setState(() => tenants.removeAt(index));
                                  },
                                )

                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// FORM FIELDS
                      Column(
                        children: [

                          Row(
                            children: [
                              Expanded(
                                child: _glowTextField(
                                  controller: tenants[index].mobile,
                                  label: 'Mobile No',
                                  keyboard: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(10),
                                  ],

                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Required';
                                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) {
                                      return 'Enter valid 10-digit mobile';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _glowTextField(
                                  controller: tenants[index].aadhaar,
                                  label: 'Aadhaar / VID No',
                                  keyboard: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(16),
                                  ],
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Required';
                                    if (!RegExp(r'^\d{12}$').hasMatch(v) &&
                                        !RegExp(r'^\d{16}$').hasMatch(v)) {
                                      return 'Enter valid Aadhaar / VID';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          _glowTextField(
                            controller: tenants[index].name,
                            label: 'Tenant Full Name',
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                          ),

                          const SizedBox(height: 12),

                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: tenants[index].relation,
                                  items: const ['S/O', 'D/O', 'W/O', 'C/O']
                                      .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e,
                                        style: const TextStyle(
                                            color: Colors.black)),
                                  ))
                                      .toList(),
                                  onChanged: (v) => setState(() {
                                    tenants[index].relation = v ?? 'S/O';
                                  }),
                                  decoration:
                                  _fieldDecoration('Relation').copyWith(
                                    labelStyle: const TextStyle(
                                        color: Colors.black),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.black),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                      borderSide: const BorderSide(
                                          color: Colors.black,
                                          width: 1.5),
                                    ),
                                  ),
                                  dropdownColor: Colors.white,
                                  iconEnabledColor: Colors.black,
                                  style: const TextStyle(
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _glowTextField(
                                  controller:
                                  tenants[index].relationPerson,
                                  label: 'Person Name',
                                  validator: (v) =>
                                  (v == null || v.trim().isEmpty) ? 'Required' : null,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          _glowTextField(
                            controller: tenants[index].address,
                            label: 'Permanent Address',
                            validator: (v) =>
                            (v == null || v.trim().isEmpty) ? 'Required' : null,
                          ),

                          const SizedBox(height: 16),

                          /// Aadhaar Front
                          Row(
                            children: [
                              _imageTile(
                                file: tenants[index].aadhaarFront,
                                url: tenants[index].aadhaarFrontUrl,
                                hint: 'Aadhaar Front',
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _pickTenantDoc(index, true),

                                icon: const Icon(Icons.upload_file),
                                label: const Text('Aadhaar Front'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // button color
                                  foregroundColor: Colors.white, // ripple color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // optional: rounded corners
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// Aadhaar Back
                          Row(
                            children: [
                              _imageTile(
                                file: tenants[index].aadhaarBack,
                                url: tenants[index].aadhaarBackUrl,
                                hint: 'Aadhaar Back',
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _pickTenantDoc(index, false),
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Aadhaar Back'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // button color
                                  foregroundColor: Colors.white, // ripple color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // optional: rounded corners
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// Tenant Photo
                          Row(
                            children: [
                              _imageTile(
                                file: tenants[index].photo,
                                url: tenants[index].photoUrl,
                                hint: 'Tenant Photo',
                              ),
                              const SizedBox(width: 12),
                              ElevatedButton.icon(
                                onPressed: () =>
                                    _pickTenantPhoto(index),
                                icon: const Icon(Icons.upload_file),
                                label: const Text('Upload Photo'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black, // button color
                                  foregroundColor: Colors.white, // ripple color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12), // optional: rounded corners
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),
                        ],
                      ),
                    ],
                  )),
            ),
          ),

        /// ADD TENANT BUTTON (BOTTOM)
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              setState(() => tenants.add(TenantBlock()));
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient:  LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue.shade700,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Add Tenant',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _previewStep() {
    int basePrice = widget.rewardStatus.isDiscounted ? 40 : 50;
    int totalPrice = tenants.length * basePrice;
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Preview', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700,color: Colors.black)),
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
              Text('Aadhaar Images',style: TextStyle(color: Colors.black),),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            _imageTile(file: ownerAadhaarFront, url: ownerAadharFrontUrl, hint: 'Front'),
            const SizedBox(width: 8),
            _imageTile(file: ownerAadhaarBack, url: ownerAadharBackUrl, hint: 'Back'),
            const Spacer(),
          ]),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => _jumpToStep(0),style: TextButton.styleFrom(
                foregroundColor: Colors.red, // text color
              ), child: const Text('Edit',)),
            ],
          )

        ]),
        const SizedBox(height: 12),
        _sectionCard(
          title: '* Tenants',
          children: List.generate(tenants.length, (index) {
            final d = tenants[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tenant ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 6),

                _kv('Name', d.name.text),
                _kv('Relation', d.relation),
                _kv('Relation Person', d.relationPerson.text),
                _kv('Mobile', d.mobile.text),
                _kv('Aadhaar', d.aadhaar.text),
                _kv('Address', d.address.text),


                const SizedBox(height: 12),
                const Divider(),
              ],
            );
          }),
        ),

        const SizedBox(height: 8),

        _sectionCard(
          title: '*Tenants Documents',
          children: List.generate(tenants.length, (index) {
            final d = tenants[index];

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tenant ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),

                /// Aadhaar
                const Text('Tenant Aadhaar',style: TextStyle(color: Colors.black),),
                const SizedBox(height: 6),
                Row(
                  children: [
                    _imageTile(
                      file: d.aadhaarFront,
                      url: d.aadhaarFrontUrl,
                      hint: 'Front',
                    ),
                    const SizedBox(width: 8),
                    _imageTile(
                      file: d.aadhaarBack,
                      url: d.aadhaarBackUrl,
                      hint: 'Back',
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Poto
                const Text('Tenant Photo',style: TextStyle(color: Colors.black),),
                const SizedBox(height: 6),
                _imageTile(
                  file: d.photo,
                  url: d.photoUrl,
                  hint: 'Photo',
                ),

                const SizedBox(height: 16),
                const Divider(),
              ],
            );
          }),
        ),



        Row(
          children: [
            const SizedBox(width: 15),
            Text('Total cost will be: ₹$totalPrice',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),),
          ],
        ),

        const SizedBox(height: 12),


        CheckboxListTile(
          value: isAgreementHide,
          onChanged: (v) {
            setState(() {
              isAgreementHide = v ?? false;
            });
          },
          title: const Text(
            'Hide Aadhaar',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          subtitle: const Text(
            'Aadhaar images & number will be hidden in agreement PDF',
            style: TextStyle(fontSize: 12,color: Colors.black),
          ),
          activeColor: Colors.redAccent,
          checkColor: Colors.white,
        ),

        const SizedBox(height: 12),
        Text('* IMPORTANT : When you tap Submit we send data & uploaded Aadhaar images to server for Approval from the Admin.',style: TextStyle(color: Colors.red),),
      ]),
    );
  }
  Widget _kv(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [SizedBox(width: 140, child: Text('$k:', style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black))), Expanded(child: Text(v,style: TextStyle(color: Colors.black),))]),
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700,color: Colors.black)),
        const SizedBox(height: 8),
        _glassContainer(child: Column(children: children), padding: const EdgeInsets.all(14)),
      ]),
    );
  }

}

class ElevatedGradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const ElevatedGradientButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  static const kAppGradient = LinearGradient(
    colors: [Color(0xFF4CA1FF), Color(0xFF00D4FF)], // Blue → Cyan
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: kAppGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.18),
              blurRadius: 16,
              offset: const Offset(0, 8),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}