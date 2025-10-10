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


class CommercialWizardPage extends StatefulWidget {
  final String? agreementId;
  const CommercialWizardPage({Key? key, this.agreementId}) : super(key: key);

  @override
  State<CommercialWizardPage> createState() => _CommercialWizardPageState();
}

class _CommercialWizardPageState extends State<CommercialWizardPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;

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
  final DirectorName = TextEditingController();
  String DirectorRelation = 'S/O';
  final DirectorRelationPerson = TextEditingController();
  final DirectorAddress = TextEditingController();
  final CompanyName = TextEditingController();
  final PanCard = TextEditingController();
  final GST_no = TextEditingController();
  final DirectorMobile = TextEditingController();
  final DirectorAadhaar = TextEditingController();
  File? DirectorAadhaarFront;
  File? DirectorAadhaarBack;
  File? DirectorImage;
  File? GST_;
  File? PanCard_;
  Map<String, dynamic>? fetchedData;


  final _propertyFormKey = GlobalKey<FormState>();
  final Address = TextEditingController();
  final rentAmount = TextEditingController();
  final Sqft = TextEditingController();
  final floor = TextEditingController();

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

  String baseUrl1 = "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/";
  String baseUrl2 = "https://theverify.in/";


  final ImagePicker _picker = ImagePicker();

  // animations
  late final AnimationController _fabController;

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
  String? GstImageUrl;
  String? PanCardUrl;


  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    if (widget.agreementId != null) {
      _fetchAgreementDetails(widget.agreementId!);
    }
  }

  String resolveUrl(String? url) {
    if (url == null || url.isEmpty) return "";

    // If the API already sent full URL
    if (url.startsWith("http")) return url;

    // If the path contains "uploads/", use baseUrl2
    if (url.contains("uploads/")) {
      return "$baseUrl2$url";
    }

    // Otherwise, assume it's from the verifyserve.social system
    return "$baseUrl1$url";
  }


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


  Future<void> _fetchAgreementDetails(String id) async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=$id");

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

          // 🔹 Director
          DirectorName.text = data["tenant_name"] ?? "";
          DirectorRelation = data["tenant_relation"] ?? "S/O";
          DirectorRelationPerson.text = data["relation_person_name_tenant"] ?? "";
          DirectorAddress.text = data["permanent_address_tenant"] ?? "";
          DirectorMobile.text = data["tenant_mobile_no"] ?? "";
          DirectorAadhaar.text = data["tenant_addhar_no"] ?? "";

          // 🔹 Agreement
          propertyID.text = data["property_id"]?.toString() ?? "";
          Sqft.text = data["Sqft"] ?? "";
          floor.text = data["floor"] ?? "";
          Address.text = data["rented_address"] ?? "";
          rentAmount.text = data["monthly_rent"]?.toString() ?? "";
          securityAmount.text = data["securitys"]?.toString() ?? "";
          installmentAmount.text = data["installment_security_amount"]?.toString() ?? "";

          meterInfo = data["meter"] ?? "As per Govt. Unit";
          customUnitAmount.text = data["custom_meter_unit"] ?? "";
          maintenance = data["maintaince"] ?? "Including";
          customMaintanceAmount.text = data["custom_maintenance_charge"]?.toString() ?? "";
          parking = data["parking"] ?? "Car";

          shiftingDate = (data["shifting_date"] != null && data["shifting_date"].toString().isNotEmpty)
              ? DateTime.tryParse(data["shifting_date"])
              : null;
          // 🔹 Documents
          ownerAadharFrontUrl = data["owner_aadhar_front"] ?? "";
          ownerAadharBackUrl  = data["owner_aadhar_back"] ?? "";
          tenantAadharFrontUrl = data["tenant_aadhar_front"] ?? "";
          tenantAadharBackUrl  = data["tenant_aadhar_back"] ?? "";
          tenantPhotoUrl       = data["tenant_image"] ?? "";
          GstImageUrl     =  data["GST_img"] ?? "";
          PanCardUrl     =  data["pan_photo"] ?? "";
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
    DirectorName.dispose();
    DirectorRelationPerson.dispose();
    DirectorAddress.dispose();
    DirectorMobile.dispose();
    DirectorAadhaar.dispose();
    Sqft.dispose();
    floor.dispose();
    Address.dispose();
    rentAmount.dispose();
    securityAmount.dispose();
    installmentAmount.dispose();
    customUnitAmount.dispose();
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
        case 'tenantFront':
          DirectorAadhaarFront = File(picked.path);
          break;
        case 'tenantBack':
          DirectorAadhaarBack = File(picked.path);
          break;
        case 'GSTImage':
          GST_ = File(picked.path);
          break;

        case 'PanCardImage':
          PanCard_ = File(picked.path);
          break;
        case 'tenantImage':
          DirectorImage = File(picked.path);
          break;
      }
    });
  }

  void _goNext() {
    bool valid = false;

    if (_currentStep == 0) {
      // Owner step: either file OR URL must exist
      valid = _ownerFormKey.currentState?.validate() == true &&
          ((ownerAadhaarFront != null || ownerAadharFrontUrl != null) &&
              (ownerAadhaarBack != null || ownerAadharBackUrl != null));

      if (!valid) {
        Fluttertoast.showToast(msg: 'Please upload Owner Aadhaar images');
      }

    } else if (_currentStep == 1) {
      // Tenant step: either file OR URL must exist
      valid = _tenantFormKey.currentState?.validate() == true &&
          ((DirectorAadhaarFront != null || tenantAadharFrontUrl != null) &&
              (DirectorAadhaarBack != null || tenantAadharBackUrl != null));

      if (!valid) {
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

  String? _buildUrl(String? path) {
    if (path?.isNotEmpty ?? false) return "https://theverify.in/$path";
    return null;
  }

  Future<void> _fetchUserData({
    required bool isOwner,                // true for owner, false for tenant
    required String? aadhaar,             // value in the Aadhaar field
    required String? mobile,              // value in the mobile field
  }) async {
    String query;
    String paramKey;
    bool searchedByAadhaar;

    if (aadhaar?.trim().isNotEmpty ?? false) {
      query = aadhaar!.trim();
      paramKey = isOwner ? "owner_addhar_no" : "tenant_addhar_no";
      searchedByAadhaar = true;
    } else if (mobile?.trim().isNotEmpty ?? false) {
      query = mobile!.trim();
      paramKey = isOwner ? "owner_mobile_no" : "tenant_mobile_no";
      searchedByAadhaar = false;
    } else {
      _showToast("Enter Aadhaar or Mobile to fetch ${isOwner ? 'owner' : 'tenant'} data");
      return;
    }

    try {
      final uri = Uri.parse(
        isOwner
            ? "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_data_by_owner_addharnumber.php"
            : "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_data_by_tenant_addhar_number.php",
      );

      final response = await http.post(uri, body: {paramKey: query});
      print("📩 API Response: ${response.body}");

      if (response.statusCode != 200) {
        return _showToast("${response.statusCode} Not Found");
      }

      final decoded = jsonDecode(response.body);
      if (decoded['status'] != 'success' || decoded['data'] == null) {
        return _showToast("No data found");
      }

      final rawData = decoded['data'];
      if (rawData is! List || rawData.isEmpty) {
        return _showToast("No data found");
      }

      final data = rawData[0];

      setState(() {
        if (isOwner) {
          ownerName.text = data['owner_name'] ?? '';
          ownerRelation = data['owner_relation'] ?? 'S/O';
          ownerRelationPerson.text = data['relation_person_name_owner'] ?? '';
          ownerAddress.text = data['parmanent_addresss_owner'] ?? '';

          // Only update opposite field
          if (searchedByAadhaar) {
            ownerMobile.text = data['owner_mobile_no'] ?? '';
          } else {
            ownerAadhaar.text = data['owner_addhar_no'] ?? '';
          }

          ownerAadharFrontUrl = _buildUrl(data['owner_aadhar_front']);
          ownerAadharBackUrl = _buildUrl(data['owner_aadhar_back']);
        } else {
          DirectorName.text = data['tenant_name'] ?? '';
          DirectorRelation = data['tenant_relation'] ?? 'S/O';
          DirectorRelationPerson.text = data['relation_person_name_tenant'] ?? '';
          DirectorAddress.text = data['permanent_address_tenant'] ?? '';

          if (searchedByAadhaar) {
            DirectorMobile.text = data['tenant_mobile_no'] ?? '';
          } else {
            DirectorAadhaar.text = data['tenant_addhar_no'] ?? '';
          }

          tenantAadharFrontUrl = _buildUrl(data['tenant_aadhar_front']);
          tenantAadharBackUrl = _buildUrl(data['tenant_aadhar_back']);
          tenantPhotoUrl = _buildUrl(data['tenant_image']);
          PanCardUrl  = _buildUrl(data['pan_photot']);
        }
      });

      print("✅ ${isOwner ? 'Owner' : 'Tenant'} data loaded successfully");
    } catch (e) {
      print("🔥 Exception while fetching ${isOwner ? 'owner' : 'tenant'}: $e");
      _showToast("Error: $e");
    }
  }

  /// Wrappers for owner/tenant
  _fetchOwnerData() {
    _fetchUserData(
      isOwner: true,
      aadhaar: ownerAadhaar.text,
      mobile: ownerMobile.text,
    );
  }

  _fetchTenantData() {
    _fetchUserData(
      isOwner: false,
      aadhaar: DirectorAadhaar.text,
      mobile: DirectorMobile.text,
    );
  }

  Future<void> _submitAll() async {
    print("🔹 _submitAll called");

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
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreement.php",
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
        "tenant_name": DirectorName.text,
        "tenant_relation": DirectorRelation ?? '',
        "relation_person_name_tenant": DirectorRelationPerson.text,
        "permanent_address_tenant": DirectorAddress.text,
        "tenant_mobile_no": DirectorMobile.text,
        "tenant_addhar_no": DirectorAadhaar.text,
        "Sqft": Sqft.text,
        "floor": floor.text,
        "company_name": CompanyName.text,
        "rented_address": Address.text,
        "gst_no": GST_no.text,
        "pan_no": PanCard.text,

        "monthly_rent": rentAmount.text,
        "securitys": securityAmount.text,
        "installment_security_amount": installmentAmount.text,
        "meter": meterInfo ?? '',
        "custom_meter_unit": customUnitAmount.text,
        "shifting_date": shiftingDate?.toIso8601String() ?? '',
        "maintaince": maintenance ?? '',
        "custom_maintenance_charge": customMaintanceAmount.text,
        "parking": parking ?? '',
        "current_dates": DateTime.now().toIso8601String(),
        "Fieldwarkarname": _name.isNotEmpty ? _name : '',
        "Fieldwarkarnumber": _number.isNotEmpty ? _number : '',
        "property_id": propertyID.text,
        "agreement_type": "Commercial Agreement",
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
            RegExp(r"^https?:\/\/(theverify\.in|verifyserve\.social)\/(Second%20PHP%20FILE\/main_application\/agreement\/)?"),
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
      await attachFileOrUrl("tenant_aadhar_front", DirectorAadhaarFront, tenantAadharFrontUrl,
          filename: "tenant_aadhaar_front.jpg");
      await attachFileOrUrl("tenant_aadhar_back", DirectorAadhaarBack, tenantAadharBackUrl,
          filename: "tenant_aadhaar_back.jpg");
      await attachFileOrUrl("pan_photo", PanCard_, tenantPhotoUrl,
          filename: "PanCard.jpg");
      await attachFileOrUrl("gst_photo", GST_, GstImageUrl,
          filename: "GST.jpg");
      await attachFileOrUrl("tenant_image", DirectorImage, tenantPhotoUrl,
          filename: "tenant_image.jpg");
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

  Future<void> _updateAll() async {
    print("🔹 _updateAll called");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    await _loaduserdata();
    print("Loaded Name: $_name, Number: $_number");

    try {
      _showToast('Updating...');
      print("⏳ Updating...");

      final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreement_update.php",
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
        "tenant_name": DirectorName.text,
        "tenant_relation": DirectorRelation ?? '',
        "relation_person_name_tenant": DirectorRelationPerson.text,
        "permanent_address_tenant": DirectorAddress.text,
        "tenant_mobile_no": DirectorMobile.text,
        "tenant_addhar_no": DirectorAadhaar.text,
        "Bhk": Sqft.text,
        "floor": floor.text,
        "rented_address": Address.text,
        "monthly_rent": rentAmount.text,
        "securitys": securityAmount.text,
        "installment_security_amount": installmentAmount.text,
        "meter": meterInfo ?? '',
        "custom_meter_unit": customUnitAmount.text,
        "shifting_date": shiftingDate?.toIso8601String() ?? '',
        "maintaince": maintenance ?? '',
        "custom_maintenance_charge": customMaintanceAmount.text,
        "parking": parking ?? '',
        "current_dates": DateTime.now().toIso8601String(),
        "Fieldwarkarname": _name.isNotEmpty ? _name : '',
        "Fieldwarkarnumber": _number.isNotEmpty ? _number : '',
        "property_id": propertyID.text,
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
            RegExp(r"^https?:\/\/(theverify\.in|verifyserve\.social)\/(Second%20PHP%20FILE\/main_application\/agreement\/)?"),
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
      await attachFileOrUrl("tenant_aadhar_front", DirectorAadhaarFront, tenantAadharFrontUrl,
          filename: "tenant_aadhaar_front.jpg");
      await attachFileOrUrl("tenant_aadhar_back", DirectorAadhaarBack, tenantAadharBackUrl,
          filename: "tenant_aadhaar_back.jpg");
      await attachFileOrUrl("tenant_image", DirectorImage, tenantPhotoUrl,
          filename: "tenant_image.jpg");
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
                    decoration: InputDecoration(labelText: label,  errorMaxLines: 2,),
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
          resolveUrl(url),
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Center(
            child: Text('Error', style: TextStyle(fontSize: 12)),
          ),
        )
            : Center(child: Text(hint, style: const TextStyle(fontSize: 12,color: Colors.black))),
      ),
    );
  }



  // ---------- Build UI ----------
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    print('Agreement ID  : ${widget.agreementId}');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Commercial Agreement', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
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
                        text: _currentStep == 3
                            ? (widget.agreementId != null ? 'Update' : 'Submit')
                            : 'Next',
                        icon: _currentStep == 3
                            ? Icons.cloud_upload
                            : Icons.arrow_forward,
                        onPressed: _currentStep == 3
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

  Widget _propertyCard(Map<String, dynamic> data) {
    final String imageUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Property Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Text("No Image",
                      style: TextStyle(color: Colors.black54)),
                );
              },
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BHK + Floor
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "₹${data['show_Price'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    Text(
                      data['Bhk'] ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['Floor_'] ?? "--",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price + Meter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "Name: ${data['field_warkar_name'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),

                    Text(
                      "Location: ${data['locations'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 10),

                // // Availability
                // Text(
                //   "Available from: ${data['available_date']?.toString().split('T')[0] ?? "--"}",
                //   style: const TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Meter: ${data['meter'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),

                    Text(
                      "Parking: ${data['parking'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Maintenance
                Text(
                  "Maintenance: ${data['maintance'] ?? "--"}",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Future<void> fetchPropertyDetails() async {
    final propertyId = propertyID.text.trim();  // propertyID is your controller
    if (propertyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Property ID first")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_api_base_on_flat_id.php"),
        body: {"P_id": propertyId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == "success") {
          final data = json['data'];

          setState(() {
            fetchedData = data;
            Sqft.text = data['Sqft'] ?? '';
            floor.text = data['Floor_'] ?? '';
            Address.text = data['Apartment_Address'] ?? '';
            rentAmount.text = data['show_Price'] ?? "";
            meterInfo = data['meter'] == "Govt" ? "As per Govt. Unit" : "Custom Unit (Enter Amount)";
            parking = (data['parking'].toString().toLowerCase().contains("bike"))
                ? "Bike"
                : (data['parking'].toString().toLowerCase().contains("car"))
                ? "Car"
                : (data['parking'].toString().toLowerCase().contains("both")) ?
            "Both"
                : "No";
            maintenance = (data['maintance'].toString().toLowerCase().contains("include"))
                ? "Including"
                : "Excluding";
          }
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(json['message'] ?? "Property not found")),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch property details")),
      );
    }
  }

  Widget _buildBackground(bool isDark) {
    const kGoldDark1 = Color(0xFF1B1300);
    const kGoldDark2 = Color(0xFF0D0A00);
    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
          colors: [kGoldDark1, kGoldDark2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(
          colors: [Color(0xFFFFF9E6), Color(0xFFFFFAF0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -80,
            left: -40,
            child: _glowCircle(220, Colors.amberAccent.withOpacity(isDark ? 0.14 : 0.16)),
          ),
          Positioned(
            bottom: -120,
            right: -40,
            child: _glowCircle(280, Colors.orangeAccent.withOpacity(isDark ? 0.08 : 0.1)),
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
          colors: [color, color.withOpacity(0.02)],
        ),
      ),
    );
  }

  Widget _fancyStepHeader() {
    final stepLabels = ['Owner', 'Director', 'Property', 'Preview'];
    final stepIcons = [Icons.person, Icons.person_outline, Icons.home, Icons.preview];

    const kGoldGradient = LinearGradient(
      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
    );

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 94,
            child: LayoutBuilder(builder: (context, constraints) {
              final gap = (constraints.maxWidth - 64) / (stepLabels.length - 1);

              return Stack(children: [
                // Grey base line
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
                Positioned(
                  top: 50,
                  left: 32,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 450),
                    height: 6,
                    width: gap * _currentStep,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: kGoldGradient,
                    ),
                  ),
                ),
                ...List.generate(stepLabels.length, (i) {
                  final left = gap * i;
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
                            gradient: isDone || isActive ? kGoldGradient : null,
                            color: isDone || isActive ? null : Colors.transparent,
                            border: Border.all(
                              color: isActive
                                  ? const Color(0xFFFFD700)
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
                                  ? const Color(0xFFFFC107)
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Owner Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _fetchOwnerData(),
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  'Auto fetch',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  backgroundColor: Colors.amber.shade700, // needed for gradient
                ),
              ),
            ),
          ],
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
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';

                        final digits = v.trim();
                        if (!RegExp(r'^\d{12}$').hasMatch(digits) && !RegExp(r'^\d{16}$').hasMatch(digits)) {
                          return 'Enter valid 12-digit Aadhaar or 16-digit VID';
                        }

                        return null;
                      },
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
                      items: const ['S/O', 'D/O', 'W/O','C/O'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
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
          ]),
        ),
      ]),
    );
  }

  Widget _tenantStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Director Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _fetchTenantData(),
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  'Auto fetch',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  backgroundColor: Colors.amber.shade700, // needed for gradient
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Form(
          key: _tenantFormKey,
          child: Column(children: [
            Row(
                children: [
                  Expanded(child: _glowTextField(controller: DirectorMobile, label: 'Mobile No', keyboard: TextInputType.phone,
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
                      controller: DirectorAadhaar,
                      label: 'Aadhaar/VID No',
                      keyboard: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,  // only numbers
                        LengthLimitingTextInputFormatter(16),    // max 16 digits
                      ],
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Required';

                        final digits = v.trim();
                        if (!RegExp(r'^\d{12}$').hasMatch(digits) && !RegExp(r'^\d{16}$').hasMatch(digits)) {
                          return 'Enter valid 12-digit Aadhaar or 16-digit VID';
                        }

                        return null;
                      },
                    ),
                  ),
                ]),
            const SizedBox(height: 14),
            _glowTextField(controller: DirectorName, label: 'Director Full Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: DirectorRelation,
                  items: const ['S/O', 'D/O', 'W/O','C/O'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (v) => setState(() => DirectorRelation = v ?? 'S/O'),
                  decoration: _fieldDecoration('Relation'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: DirectorRelationPerson, label: 'Person Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
            ]),
            const SizedBox(height: 12),
            _glowTextField(controller: CompanyName, label: 'Company Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            _glowTextField(controller: DirectorAddress, label: 'Permanent Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),

            Row(
                children: [
              Expanded(
                child:  _glowTextField(controller: GST_no, label: 'GST no.',

                  inputFormatters: [
                    LengthLimitingTextInputFormatter(15),         // max 15 digits
                  ],
                  validator: (v) {

                    if (v == null || v.trim().isEmpty) return 'Required';

                    // if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$').hasMatch(v)) return 'Enter valid 15-character Number';

                    return null;
                  },
                )
              ),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: PanCard, label: 'PanCard no.',
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10), // max 10 characters (A-Z + 0-9)
                ],
                // validator: (v) {
                //
                //   if (v == null || v.trim().isEmpty) return 'Required';
                //
                //   // if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(v)) return 'Enter valid 10-digit PanCard';
                //
                //   return null;
                // },

              ),
              ),
            ]),
            const SizedBox(height: 12),
            Column(
                children: [
              Row(
                children: [
                  _imageTile(file: DirectorAadhaarFront, url: tenantAadharFrontUrl, hint: 'Front'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantFront'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Front')),
                ],
              ),

              const SizedBox(height: 16),
              Row(
                children: [
                  _imageTile(file: DirectorAadhaarBack, url: tenantAadharBackUrl, hint: 'Back'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantBack'), icon: const Icon(Icons.upload_file), label: const Text('Aadhaar Back')),
                ],
              ),
              const SizedBox(height: 16),
                  Row(
                    children: [
                      _imageTile(file: GST_, url: GstImageUrl, hint: 'GST Image'),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(onPressed: () => _pickImage('GSTImage'), icon: const Icon(Icons.upload_file), label: const Text('GST Image')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _imageTile(file: PanCard_, url: PanCardUrl, hint: 'PanCard'),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(onPressed: () => _pickImage('PanCardImage'), icon: const Icon(Icons.upload_file), label: const Text('PanCard Photo')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                children: [
                  _imageTile(file: DirectorImage, url: tenantPhotoUrl, hint: 'Director Photo'),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(onPressed: () => _pickImage('tenantImage'), icon: const Icon(Icons.upload_file), label: const Text('Upload Photo')),
                ],
              ),
            ]),

            const SizedBox(height: 12),
          ]),
        ),

      ]),
    );
  }

  Widget _propertyStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        if (fetchedData != null) _propertyCard(fetchedData!), // Card appears only after fetch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Property Details', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => fetchPropertyDetails(),
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text(
                  'Auto fetch',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  backgroundColor: Colors.amber.shade700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Form(
          key: _propertyFormKey,
          child: Column(children: [
            _glowTextField(controller: propertyID,keyboard: TextInputType.number, label: 'Property ID', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            Row(
                children: [
                  Expanded(
                      child: _glowTextField(controller: Sqft, label: 'Sqft', keyboard: TextInputType.number, validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
                  const SizedBox(width: 12),
                  Expanded(
                      child: _glowTextField(controller: floor, label: 'Floor', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
                ]
            ),
            _glowTextField(controller: Address, label: 'Rented Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            Row(
                children: [
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
            DropdownButtonFormField<String>(value: parking, items: const ['Car', 'Bike','Both','No'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (v) => setState(() => parking = v ?? 'Car'), decoration: _fieldDecoration('Parking')),

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
            _imageTile(file: ownerAadhaarFront, url: ownerAadharFrontUrl, hint: 'Front'),
            const SizedBox(width: 8),
            _imageTile(file: ownerAadhaarBack, url: ownerAadharBackUrl, hint: 'Back'),
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
        _sectionCard(title: '*Director', children: [
          _kv('Name', DirectorName.text),
          _kv('Relation', DirectorRelation),
          _kv('Relation Person', DirectorRelationPerson.text),
          _kv('Mobile', DirectorMobile.text),
          _kv('Aadhaar', DirectorAadhaar.text),
          _kv('Company', CompanyName.text),
          _kv('Address', DirectorAddress.text),
          _kv('GST no.', GST_no.text),
          _kv('PanCard', PanCard.text),

          const SizedBox(height: 8),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Aadhaar Images'),
              const SizedBox(height: 8),
              Row(
                  children: [
                _imageTile(file: DirectorAadhaarFront, url: tenantAadharFrontUrl, hint: 'Front'),
                const SizedBox(width: 8),
                _imageTile(file: DirectorAadhaarBack, url: tenantAadharBackUrl, hint: 'Back'),
                const Spacer(),
              ]),
              const SizedBox(height: 8),
              Text('PanCard & Director Photo'),
              const SizedBox(height: 8),
              Row(
                children: [
                  _imageTile(file: PanCard_, url: PanCardUrl, hint: 'Director Photo'),
                  const SizedBox(width: 8),
                  _imageTile(file: DirectorImage, url: tenantPhotoUrl, hint: 'Director Photo'),
                ],
              ),
              const SizedBox(height: 8),
              Text('GST Photo'),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _imageTile(file: GST_, url: GstImageUrl, hint: 'GST Photo'),
                  const SizedBox(width: 8),
                  TextButton(onPressed: () => _jumpToStep(1), child: const Text('Edit')),
                ],
              )

            ],
          )
        ]),
        const SizedBox(height: 12),
        _sectionCard(title: '*Property', children: [
          _kv('Property ID', propertyID.text),
          _kv('Sqft', Sqft.text),
          _kv('Floor', floor.text),
          _kv('Address', Address.text),
          _kv('Rent', '${rentAmount.text} (${rentAmountInWords})'),
          _kv('Security', '${securityAmount.text} (${securityAmountInWords})'),
          if (securityInstallment) _kv('Installment', '${installmentAmount.text} (${installmentAmountInWords})'),
          _kv('Meter Info', meterInfo),
          if (meterInfo.startsWith('Custom')) _kv('Custom Unit', '${customUnitAmount.text} (${customUnitAmountInWords})'),
          _kv('Shifting', shiftingDate == null ? '' : shiftingDate!.toLocal().toString().split(' ')[0]),
          _kv('Parking', parking),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFFB8860B), // rich golden brown for headings
            ),
          ),
          const SizedBox(height: 8),
          _glassContainer(
            child: Column(children: children),
            padding: const EdgeInsets.all(14),
          ),
        ],
      ),
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

  const ElevatedGradientButton({
    required this.text,
    required this.icon,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // Gold → Amber
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(4,4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
