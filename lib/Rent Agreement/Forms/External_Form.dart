import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Rent%20Agreement/history_tab.dart';
import '../../AppLogger.dart';
import '../../Custom_Widget/Custom_backbutton.dart';
import 'package:http_parser/http_parser.dart';

import '../../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Dashboard_screen.dart';

class ExtraTenant {
  String? id;
  final formKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final relationPerson = TextEditingController();
  final address = TextEditingController();
  final mobile = TextEditingController();
  final aadhaar = TextEditingController();
  bool includePoliceVerification = false;
  String relation = 'S/O';
  File? aadhaarFront;
  File? aadhaarBack;
  File? photo;
  String? aadhaarFrontUrl;
  String? aadhaarBackUrl;
  String? photoUrl;
}

class BuildingSuggestion {
  final int id;
  final String ownerName;
  final String place;
  final String propertyAddressForFieldworkar;
  final List<FlatSuggestion> flats;

  BuildingSuggestion({
    required this.id,
    required this.ownerName,
    required this.place,
    required this.flats,
    required this.propertyAddressForFieldworkar,
  });

  factory BuildingSuggestion.fromJson(Map<String, dynamic> json) {
    return BuildingSuggestion(
      id: json["id"],
      ownerName: json["ownername"] ?? "",
      propertyAddressForFieldworkar:
      json["property_address_for_fieldworkar"] ?? "",
      place: json["place"] ?? "",
      flats: (json["flats"] as List)
          .map((e) => FlatSuggestion.fromJson(e))
          .toList(),
    );
  }
}

class FlatSuggestion {
  final String id;
  final String bhk;
  final String price;
  final String floor;
  final String address;
  final String fieldworkarAddress;

  FlatSuggestion({
    required this.id,
    required this.bhk,
    required this.price,
    required this.floor,
    required this.address,
    required this.fieldworkarAddress,
  });

  factory FlatSuggestion.fromJson(Map<String, dynamic> json) {
    return FlatSuggestion(
      id: json["P_id"].toString(),
      bhk: json["Bhk"] ?? "",
      price: json["show_Price"] ?? "",
      floor: json["Floor_"] ?? "",
      address: json["Apartment_Address"] ?? "",
      fieldworkarAddress: json["fieldworkar_address"] ?? "",
    );
  }
}

class ExternalWizardPage extends StatefulWidget {
  final String? agreementId;
  final RewardStatus rewardStatus;
  const ExternalWizardPage({Key? key, this.agreementId,required this.rewardStatus}) : super(key: key);

  @override
  State<ExternalWizardPage> createState() => _ExternalWizardPageState();
}

class _ExternalWizardPageState extends State<ExternalWizardPage> with TickerProviderStateMixin {

  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool isAgreementHide = false;
  bool isPropertyFetched = false;
  List<ExtraTenant> tenants = [];

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

  Map<String, dynamic>? fetchedData;

  final _propertyFormKey = GlobalKey<FormState>();
  final propertyID = TextEditingController();
  final Address = TextEditingController();
  final rentAmount = TextEditingController();
  final Bhk = TextEditingController();
  final floor = TextEditingController();

  final securityAmount = TextEditingController();
  bool securityInstallment = false;
  final installmentAmount = TextEditingController();

  final Agreement_price = TextEditingController();
  String AgreementAmountInWords = '';
  String Notary_price = '10 rupees';

  String meterInfo = 'As per Govt. Unit';
  final customUnitAmount = TextEditingController();
  DateTime? shiftingDate;
  String maintenance = 'Including';
  String parking = 'Car';
  final customMaintanceAmount = TextEditingController();

  static const String kStaticBasePath =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/";



  static const kAppGradient = LinearGradient(
    colors: [Color(0xFF4CA1FF), Color(0xFF00D4FF)], // Blue → Cyan
  );

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



  @override
  void initState() {
    super.initState();
    loadUserName();
    final discounted = widget.rewardStatus.isDiscounted;
    final defaultPrice = discounted ? 100 : 150;
    Agreement_price.text = defaultPrice.toString();
    AgreementAmountInWords = convertToWords(defaultPrice);

    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    if (widget.agreementId != null) {
      _fetchAgreementDetails(widget.agreementId!);
    }

    if (tenants.isEmpty) {
      tenants.add(ExtraTenant());
    }
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
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=$id");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded["status"] == "success" && decoded["data"] != null && decoded["data"].isNotEmpty) {
        final data = decoded["data"][0]; // 👈 Get first record

        AppLogger.api("✅ Parsed Agreement Data: $data");

        setState(() {
          // 🔹 Owner
          ownerName.text = data["owner_name"] ?? "";
          ownerRelation = data["owner_relation"] ?? "S/O";
          ownerRelationPerson.text = data["relation_person_name_owner"] ?? "";
          ownerAddress.text = data["parmanent_addresss_owner"] ?? "";
          ownerMobile.text = data["owner_mobile_no"] ?? "";
          ownerAadhaar.text = data["owner_addhar_no"] ?? "";



          // 🔹 Tenant (FIRST TENANT)
          if (tenants.isEmpty) {
            tenants.add(ExtraTenant());
          }

          final firstTenant = tenants[0];

          firstTenant.name.text = data["tenant_name"] ?? "";
          firstTenant.relation = data["tenant_relation"] ?? "S/O";
          firstTenant.relationPerson.text =
              data["relation_person_name_tenant"] ?? "";
          firstTenant.address.text =
              data["permanent_address_tenant"] ?? "";
          firstTenant.mobile.text =
              data["tenant_mobile_no"] ?? "";
          firstTenant.aadhaar.text =
              data["tenant_addhar_no"] ?? "";

          firstTenant.includePoliceVerification =
              data["is_Police"] == "true" || data["is_Police"] == "1";

          // 🔹 Agreement
          propertyID.text = data["property_id"]?.toString() ?? "";
          Bhk.text = data["Bhk"] ?? "";
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
          Notary_price = data["notary_price"] ?? "10 rupees";

          // 🔹 Police verification (IMPORTANT)


          shiftingDate = (data["shifting_date"] != null && data["shifting_date"].toString().isNotEmpty)
              ? DateTime.tryParse(data["shifting_date"])
              : null;

          // 🔹 Documents
          ownerAadharFrontUrl = data["owner_aadhar_front"] ?? "";
          ownerAadharBackUrl  = data["owner_aadhar_back"] ?? "";
          isAgreementHide = data["is_agreement_hide"] == "1";

          firstTenant.aadhaarFrontUrl =
              data["tenant_aadhar_front"] ?? "";
          firstTenant.aadhaarBackUrl =
              data["tenant_aadhar_back"] ?? "";
          firstTenant.photoUrl =
              data["tenant_image"] ?? "";

        });
        await _fetchAdditionalTenants(id);

        // 🔁 Recalculate agreement price AFTER state restore
        updateAgreementPrice();
      } else {
        AppLogger.api("⚠️ No agreement data found");
      }
    } else {
      AppLogger.api("❌ Failed to load agreement details: ${response.body}");
    }
  }

  Future<void> _fetchAdditionalTenants(String agreementId) async {
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/show_api_for_addtional_tenant.php?agreement_id=$agreementId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded["success"] == true && decoded["data"] != null) {
        final List list = decoded["data"];

        setState(() {
          // 🔥 Remove all previously added additional tenants
          if (tenants.length > 1) {
            tenants.removeWhere((t) => t != tenants.first);
          }

          for (var e in list) {
            final t = ExtraTenant();

            t.id = e["id"].toString();
            t.name.text = e["tenant_name"] ?? "";
            t.mobile.text = e["tenant_mobile"] ?? "";
            t.aadhaar.text = e["tenant_aadhar_no"] ?? "";
            t.address.text = e["tenant_address"] ?? "";
            t.relation = e["tenant_relation"] ?? "S/O";
            t.relationPerson.text = e["relation_person_name_tenant"] ?? "";

            t.aadhaarFrontUrl = e["tenant_aadhar_front"] ?? "";
            t.aadhaarBackUrl = e["tenant_aadhar_back"] ?? "";
            t.photoUrl = e["tenant_photo"] ?? "";

            t.includePoliceVerification =
                e["police_verification_for_addtional_tenant"] == "true" || e["police_verification_for_addtional_tenant"] == "1";

            tenants.add(t);
          }
        });
      }
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
    for (final t in tenants) {
      t.name.dispose();
      t.mobile.dispose();
      t.aadhaar.dispose();
      t.address.dispose();
      t.relationPerson.dispose();
    }
    Bhk.dispose();
    floor.dispose();
    Address.dispose();
    rentAmount.dispose();
    securityAmount.dispose();
    Agreement_price.dispose();
    installmentAmount.dispose();
    customUnitAmount.dispose();
    super.dispose();
  }

  Future<void> _pickImage(String which) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
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

    // 🔍 OCR scan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              SizedBox(height: 14),
              Text('Scanning Aadhaar card...', style: TextStyle(fontSize: 14)),
            ]),
          ),
        ),
      ),
    );

    try {
      final rawText = await _recognizeTextNative(picked.path);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (rawText != null && rawText.trim().isNotEmpty) {
        final parsed = _parseAadhaarText(rawText);
        await _applyOcrResult(ocr: parsed, fillOwner: true);
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      _showScanErrorDialog('Scan Failed', 'Could not process image.\n\nError: $e');
    }
  }

  int getBaseNotaryAmount(String value, bool discounted) {
    if (!discounted) {
      switch (value) {
        case '10 rupees': return 150;
        case '20 rupees': return 170;
        case '50 rupees': return 200;
        case '100 rupees': return 250;
        default: return 150;
      }
    }

    // 🎯 DISCOUNTED
    switch (value) {
      case '10 rupees': return 100;
      case '20 rupees': return 120;
      case '50 rupees': return 150;
      case '100 rupees': return 200;
      default: return 100;
    }
  }

  void updateAgreementPrice() {
    final discounted = widget.rewardStatus.isDiscounted;

    final notaryAmount =
    getBaseNotaryAmount(Notary_price, discounted);

    // 🔥 COUNT tenants with police verification
    final policeCount = tenants
        .where((t) => t.includePoliceVerification)
        .length;

    final policeChargePerTenant = discounted ? 40 : 50;

    final totalPoliceCharge = policeCount * policeChargePerTenant;

    final total = notaryAmount + totalPoliceCharge;

    Agreement_price.text = total.toString();
    AgreementAmountInWords = convertToWords(total);

    setState(() {});
  }

  void _goNext() {
    switch (_currentStep) {
      case 0:
        _validateOwnerStep();
        break;

      case 1:
        _validateTenantStep();
        break;

      case 2:
        _validatePropertyStep();
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

  void _validatePropertyStep() {

    if (!_propertyFormKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please correct Property form Fields");
      return;
    }

    if (shiftingDate == null) {
      Fluttertoast.showToast(msg: "Select shifting date");
      return;
    }

    if (rentAmount.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Enter monthly rent amount");
      return;
    }

    if (securityAmount.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Enter security deposit amount");
      return;
    }

    if (meterInfo.startsWith("Custom") &&
        customUnitAmount.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Enter custom meter unit amount");
      return;
    }

    if (maintenance.startsWith("Excluding") &&
        customMaintanceAmount.text.trim().isEmpty) {
      Fluttertoast.showToast(msg: "Enter maintenance charge amount");
      return;
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
  }) async {
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

      // 🔥 Fetched data map
      final fetched = {
        'Name': data['name'] ?? '',
        'Mobile': data['mobile_number'] ?? '',
        'Aadhaar': data['addhar_number'] ?? '',
        'Address': data['addresss'] ?? '',
        'Relation': data['relation'] ?? 'S/O',
        'RelationPerson': data['relation_person_name'] ?? '',
      };

      // 🔥 Existing data map
      final existing = fillOwner
          ? {
        'Name': ownerName.text,
        'Mobile': ownerMobile.text,
        'Aadhaar': ownerAadhaar.text,
        'Address': ownerAddress.text,
        'Relation': ownerRelation,
        'RelationPerson': ownerRelationPerson.text,
      }
          : tenantIndex != null
          ? {
        'Name': tenants[tenantIndex].name.text,
        'Mobile': tenants[tenantIndex].mobile.text,
        'Aadhaar': tenants[tenantIndex].aadhaar.text,
        'Address': tenants[tenantIndex].address.text,
        'Relation': tenants[tenantIndex].relation,
        'RelationPerson': tenants[tenantIndex].relationPerson.text,
      }
          : <String, String>{};

      // 🔥 Conflict keys — Mobile EXCLUDE, dono non-empty aur alag
      final conflictKeys = fetched.entries
          .where((e) {
        if (e.key == 'Mobile') return false; // Mobile pe conflict nahi
        final newVal = e.value.trim();
        final oldVal = (existing[e.key] ?? '').trim();
        return newVal.isNotEmpty &&
            oldVal.isNotEmpty &&
            newVal.toLowerCase() != oldVal.toLowerCase();
      })
          .map((e) => e.key)
          .toList();

      // 🔥 Non-conflict fields directly fill karo
      setState(() {
        if (fillOwner) {
          fetched.forEach((key, newVal) {
            if (newVal.isEmpty) return;
            final oldVal = (existing[key] ?? '').trim();
            // Mobile freely fill, baaki conflict pe skip
            if (key != 'Mobile' &&
                oldVal.isNotEmpty &&
                oldVal.toLowerCase() != newVal.toLowerCase()) return;
            if (key == 'Name') ownerName.text = newVal.toUpperCase();
            if (key == 'Mobile') ownerMobile.text = newVal;
            if (key == 'Aadhaar') ownerAadhaar.text = newVal;
            if (key == 'Address') ownerAddress.text = newVal.toUpperCase();
            if (key == 'Relation') ownerRelation = newVal;
            if (key == 'RelationPerson')
              ownerRelationPerson.text = newVal.toUpperCase();
          });
          ownerAadharFrontUrl = data['addhar_front'] ?? '';
          ownerAadharBackUrl = data['addhar_back'] ?? '';
          ownerAadhaarFront = null;
          ownerAadhaarBack = null;
        } else if (tenantIndex != null &&
            tenantIndex >= 0 &&
            tenantIndex < tenants.length) {
          final d = tenants[tenantIndex];
          fetched.forEach((key, newVal) {
            if (newVal.isEmpty) return;
            final oldVal = (existing[key] ?? '').trim();
            // Mobile freely fill, baaki conflict pe skip
            if (key != 'Mobile' &&
                oldVal.isNotEmpty &&
                oldVal.toLowerCase() != newVal.toLowerCase()) return;
            if (key == 'Name') d.name.text = newVal.toUpperCase();
            if (key == 'Mobile') d.mobile.text = newVal;
            if (key == 'Aadhaar') d.aadhaar.text = newVal;
            if (key == 'Address') d.address.text = newVal.toUpperCase();
            if (key == 'Relation') d.relation = newVal;
            if (key == 'RelationPerson')
              d.relationPerson.text = newVal.toUpperCase();
          });
          d.aadhaarFrontUrl = data['addhar_front'];
          d.aadhaarBackUrl = data['addhar_back'];
          d.photoUrl = data['selfie'];
          d.aadhaarFront = null;
          d.aadhaarBack = null;
          d.photo = null;
        }
      });

      // 🔥 Conflict fields ke liye POPUP
      if (conflictKeys.isNotEmpty) {
        final choice = {
          for (var key in conflictKeys) key: 'fetched'
        };

        final selected = await showDialog<Map<String, String>>(
          context: context,
          builder: (ctx) {
            return StatefulBuilder(
              builder: (ctx, setS) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  title: const Text("Select Data"),
                  content: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Some fields have different data — select which one to keep:",
                          style:
                          TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 12),
                        ...conflictKeys.map((key) {
                          final oldVal = existing[key] ?? '';
                          final newVal = fetched[key] ?? '';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(key,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              const SizedBox(height: 6),
                              Row(children: [
                                // 🔵 Old Data
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>
                                        setS(() => choice[key] = 'old'),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          minHeight: 60),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: choice[key] == 'old'
                                            ? Colors.blue.withOpacity(0.8)
                                            : Colors.grey.shade200,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Old Data',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: choice[key] == 'old'
                                                  ? Colors.white70
                                                  : Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            oldVal.isNotEmpty
                                                ? oldVal
                                                : 'No Data',
                                            style: TextStyle(
                                              color: choice[key] == 'old'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                // 🟢 New Data
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setS(
                                            () => choice[key] = 'fetched'),
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          minHeight: 60),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: choice[key] == 'fetched'
                                            ? Colors.green.withOpacity(0.8)
                                            : Colors.grey.shade200,
                                        borderRadius:
                                        BorderRadius.circular(8),
                                        border: Border.all(
                                            color: Colors.grey),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'New Data',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color:
                                              choice[key] == 'fetched'
                                                  ? Colors.white70
                                                  : Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            newVal.isNotEmpty
                                                ? newVal
                                                : 'No Data',
                                            style: TextStyle(
                                              color:
                                              choice[key] == 'fetched'
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                              const SizedBox(height: 12),
                            ],
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, null),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        final result = <String, String>{};
                        for (var key in conflictKeys) {
                          result[key] = choice[key] == 'old'
                              ? existing[key] ?? ''
                              : fetched[key] ?? '';
                        }
                        Navigator.pop(ctx, result);
                      },
                      child: const Text("Apply"),
                    ),
                  ],
                );
              },
            );
          },
        );

        // 🔥 Popup se selected values apply karo
        if (selected != null && mounted) {
          setState(() {
            if (fillOwner) {
              if (selected['Name']?.isNotEmpty == true)
                ownerName.text = selected['Name']!.toUpperCase();
              if (selected['Mobile']?.isNotEmpty == true)
                ownerMobile.text = selected['Mobile']!;
              if (selected['Aadhaar']?.isNotEmpty == true)
                ownerAadhaar.text = selected['Aadhaar']!;
              if (selected['Address']?.isNotEmpty == true)
                ownerAddress.text = selected['Address']!.toUpperCase();
              if (selected['Relation']?.isNotEmpty == true)
                ownerRelation = selected['Relation']!;
              if (selected['RelationPerson']?.isNotEmpty == true)
                ownerRelationPerson.text =
                    selected['RelationPerson']!.toUpperCase();
            } else if (tenantIndex != null &&
                tenantIndex < tenants.length) {
              final t = tenants[tenantIndex];
              if (selected['Name']?.isNotEmpty == true)
                t.name.text = selected['Name']!.toUpperCase();
              if (selected['Mobile']?.isNotEmpty == true)
                t.mobile.text = selected['Mobile']!;
              if (selected['Aadhaar']?.isNotEmpty == true)
                t.aadhaar.text = selected['Aadhaar']!;
              if (selected['Address']?.isNotEmpty == true)
                t.address.text = selected['Address']!.toUpperCase();
              if (selected['Relation']?.isNotEmpty == true)
                t.relation = selected['Relation']!;
              if (selected['RelationPerson']?.isNotEmpty == true)
                t.relationPerson.text =
                    selected['RelationPerson']!.toUpperCase();
            }
          });
          _showToast('Fields updated successfully!');
        }
      }

      // 🔥 Background mein images download karo
      if (fillOwner) {
        if (ownerAadharFrontUrl != null && ownerAadharFrontUrl!.isNotEmpty) {
          downloadAndConvertToFile(ownerAadharFrontUrl).then((file) {
            if (file != null && mounted)
              setState(() => ownerAadhaarFront = file);
          });
        }
        if (ownerAadharBackUrl != null && ownerAadharBackUrl!.isNotEmpty) {
          downloadAndConvertToFile(ownerAadharBackUrl).then((file) {
            if (file != null && mounted)
              setState(() => ownerAadhaarBack = file);
          });
        }
      } else if (tenantIndex != null &&
          tenantIndex >= 0 &&
          tenantIndex < tenants.length) {
        final d = tenants[tenantIndex];
        if (d.aadhaarFrontUrl != null && d.aadhaarFrontUrl!.isNotEmpty) {
          downloadAndConvertToFile(d.aadhaarFrontUrl).then((file) {
            if (file != null && mounted)
              setState(() => d.aadhaarFront = file);
          });
        }
        if (d.aadhaarBackUrl != null && d.aadhaarBackUrl!.isNotEmpty) {
          downloadAndConvertToFile(d.aadhaarBackUrl).then((file) {
            if (file != null && mounted)
              setState(() => d.aadhaarBack = file);
          });
        }
        if (d.photoUrl != null && d.photoUrl!.isNotEmpty) {
          downloadAndConvertToFile(d.photoUrl).then((file) {
            if (file != null && mounted) setState(() => d.photo = file);
          });
        }
      }

      if (fillOwner) {
        AppLogger.api("✅ Auto-fetch filled for OWNER");
      } else if (tenantIndex != null) {
        AppLogger.api("✅ Auto-fetch filled for TENANT #${tenantIndex + 1}");
      }
    } catch (e) {
      print("🔥 Exception: $e");
      _showToast("Error: $e");
    }
  }


  Future<void> _pickTenantDoc(int index, bool isFront) async {
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    setState(() {
      if (isFront) {
        tenants[index].aadhaarFront = File(picked.path);
      } else {
        tenants[index].aadhaarBack = File(picked.path);
      }
    });

    // 🔍 OCR scan
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(),
              SizedBox(height: 14),
              Text('Scanning Aadhaar card...', style: TextStyle(fontSize: 14)),
            ]),
          ),
        ),
      ),
    );

    try {
      final rawText = await _recognizeTextNative(picked.path);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (rawText != null && rawText.trim().isNotEmpty) {
        final parsed = _parseAadhaarText(rawText);
        await _applyOcrResult(ocr: parsed, fillOwner: false, tenantIndex: index);
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      _showScanErrorDialog('Scan Failed', 'Could not process image.\n\nError: $e');
    }
  }

  Future<void> _pickTenantPhoto(int index) async {
    final picked = await _picker.pickImage(
        source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;

    setState(() {
      tenants[index].photo = File(picked.path);
    });
  }

  // ── OCR ──────────────────────────────────────────────────────────────────
  static const _ocrChannel = MethodChannel('com.verify.app/ocr');

  Future<String?> _recognizeTextNative(String imagePath) async {
    try {
      final String? result = await _ocrChannel.invokeMethod(
        'recognizeText',
        {'imagePath': imagePath},
      );
      return result;
    } on PlatformException catch (e) {
      print('OCR PlatformException: ${e.message}');
      rethrow;
    }
  }

  String _titleCase(String s) => s.toLowerCase().split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}')
      .join(' ');

  String cleanAddress(String raw) {
    String text = raw;
    text = text.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
    text = text.replaceAll(RegExp(r"[^a-zA-Z0-9,\-\./ ]"), '');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.replaceAll(RegExp(r'\s*-\s*'), '-');
    text = text.replaceAll(RegExp(r',+'), ',');
    text = text.replaceAll(RegExp(r'\s*,\s*'), ', ');
    final parts = text.split(', ');
    final seen = <String>{};
    final unique = <String>[];
    for (var part in parts) {
      final key = part.trim().toLowerCase();
      if (key.isNotEmpty && !seen.contains(key)) {
        seen.add(key);
        unique.add(part.trim());
      }
    }
    return unique.join(', ').trim();
  }

  Map<String, String?> _parseAadhaarText(String fullText) {
    final result = <String, String?>{
      'aadhaarNumber': null,
      'name': null,
      'address': null,
      'mobile': null,
    };

    final lines = fullText
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // 1. Aadhaar Number
    final aadhaarRegex = RegExp(r'\b(\d{4}\s?\d{4}\s?\d{4})\b');
    for (final line in lines) {
      final m = aadhaarRegex.firstMatch(line);
      if (m != null) {
        result['aadhaarNumber'] = m.group(1)!.replaceAll(' ', '');
        break;
      }
    }

    // 2. Name
    final skipKw = RegExp(
        r'(Government|India|INDIA|Aadhaar|UIDAI|DOB|Date|Male|Female|Address|VID|Enrollment|Download|www|\.in|\.com|\d{4})',
        caseSensitive: false);

    String? foundName;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].toLowerCase().startsWith('name') && i + 1 < lines.length) {
        final next = lines[i + 1];
        if (!skipKw.hasMatch(next) && next.length > 2) {
          foundName = _titleCase(next);
          break;
        }
      }
    }
    if (foundName == null) {
      for (final line in lines) {
        if (skipKw.hasMatch(line)) continue;
        if (RegExp(r'^[A-Za-z\s\.]+$').hasMatch(line) &&
            line.split(' ').length >= 2 &&
            line.length >= 5 &&
            line.length <= 60) {
          foundName = _titleCase(line);
          break;
        }
      }
    }
    result['name'] = foundName;

    // 3. Address
    List<String> addressLines = [];
    bool start = false;
    for (final line in lines) {
      final lower = line.toLowerCase();
      if (lower.contains('s/o') || lower.contains('d/o') ||
          lower.contains('w/o') || lower.contains('c/o')) {
        start = true;
        addressLines.add(line.trim());
        continue;
      }
      if (!start) continue;
      if (lower.contains('uidai') || lower.contains('unique identification') ||
          lower.contains('government') || lower.contains('india') ||
          lower.contains('aadhaar') || lower.contains('www')) continue;
      if (aadhaarRegex.hasMatch(line)) break;
      if (line.length < 6) continue;
      addressLines.add(line.trim());
      if (addressLines.length == 5) break;
    }

    if (addressLines.isNotEmpty) {
      String combined = addressLines.join(' ');
      combined = combined.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
      combined = combined.replaceAll(RegExp(r"[^a-zA-Z0-9,\-\./ ]"), '');
      combined = combined.replaceAll(RegExp(r'\s+'), ' ');
      combined = combined.replaceAll(RegExp(r'\s*-\s*'), '-');
      combined = combined.replaceAll(RegExp(r',+'), ',');
      combined = combined.replaceAll(RegExp(r'\s*,\s*'), ', ');
      final parts = combined.split(', ');
      final seen = <String>{};
      final unique = <String>[];
      for (var part in parts) {
        final key = part.trim().toLowerCase();
        if (key.isNotEmpty && !seen.contains(key)) {
          seen.add(key);
          unique.add(part.trim());
        }
      }
      result['address'] = unique.join(', ');
    }

    // 4. Mobile
    final mobileRegex = RegExp(r'\b([6-9]\d{9})\b');
    for (final line in lines) {
      final m = mobileRegex.firstMatch(line);
      if (m != null) {
        result['mobile'] = m.group(1);
        break;
      }
    }

    print('✅ OCR Parsed: $result');
    return result;
  }

  void _showScanErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Text(message,
            style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _applyOcrResult({
    required Map<String, String?> ocr,
    required bool fillOwner,
    int? tenantIndex,
  }) async {
    final aadhaar = ocr['aadhaarNumber'];
    final name    = ocr['name'];
    final address = ocr['address'];
    final mobile  = ocr['mobile'];

    if (aadhaar == null && name == null && address == null && mobile == null) {
      _showScanErrorDialog('Scan Unsuccessful',
          'Unable to read Aadhaar card clearly.\n\nPlease ensure:\n• Card is straight\n• Good lighting\n• Full card visible');
      return;
    }

    // 🔥 Existing data map
    final existing = fillOwner
        ? {
      'Name': ownerName.text,
      'Mobile': ownerMobile.text,
      'Aadhaar': ownerAadhaar.text,
      'Address': ownerAddress.text,
    }
        : {
      'Name': tenants[tenantIndex!].name.text,
      'Mobile': tenants[tenantIndex].mobile.text,
      'Aadhaar': tenants[tenantIndex].aadhaar.text,
      'Address': tenants[tenantIndex].address.text,
    };

    final scanned = {
      'Name': name ?? '',
      'Mobile': mobile ?? '',
      'Aadhaar': aadhaar ?? '',
      'Address': address ?? '',
    };

    // 🔥 Step 1: Empty fields directly fill karo
    setState(() {
      for (var key in scanned.keys) {
        final newVal = scanned[key]?.trim() ?? '';
        final oldVal = (existing[key] ?? '').trim();
        if (newVal.isEmpty) continue;
        if (oldVal.isNotEmpty && oldVal.toLowerCase() != newVal.toLowerCase()) continue;
        if (fillOwner) {
          if (key == 'Name') ownerName.text = newVal.toUpperCase();
          if (key == 'Mobile') ownerMobile.text = newVal;
          if (key == 'Aadhaar') ownerAadhaar.text = newVal;
          if (key == 'Address') ownerAddress.text = newVal.toUpperCase();
        } else if (tenantIndex != null && tenantIndex < tenants.length) {
          final t = tenants[tenantIndex];
          if (key == 'Name') t.name.text = newVal.toUpperCase();
          if (key == 'Mobile') t.mobile.text = newVal;
          if (key == 'Aadhaar') t.aadhaar.text = newVal;
          if (key == 'Address') t.address.text = newVal.toUpperCase();
        }
      }
    });

    // 🔥 Step 2: Conflict keys dhundho
    final conflictKeys = scanned.entries
        .where((e) {
      final newVal = e.value.trim();
      final oldVal = (existing[e.key] ?? '').trim();
      return newVal.isNotEmpty &&
          oldVal.isNotEmpty &&
          newVal.toLowerCase() != oldVal.toLowerCase();
    })
        .map((e) => e.key)
        .toList();

    if (conflictKeys.isEmpty) return;

    // 🔥 Step 3: Conflict popup
    final choice = {for (var key in conflictKeys) key: 'scanned'};

    final selected = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setS) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              title: const Text("Select Data"),
              content: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Some fields have different data — select which one to keep:",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 12),
                    ...conflictKeys.map((key) {
                      final oldVal = existing[key] ?? '';
                      final newVal = scanned[key] ?? '';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(key,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13)),
                          const SizedBox(height: 6),
                          Row(children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setS(() => choice[key] = 'old'),
                                child: Container(
                                  constraints:
                                  const BoxConstraints(minHeight: 60),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: choice[key] == 'old'
                                        ? Colors.blue.withOpacity(0.8)
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('Old Data',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: choice[key] == 'old'
                                                  ? Colors.white70
                                                  : Colors.grey)),
                                      const SizedBox(height: 2),
                                      Text(
                                        oldVal.isNotEmpty ? oldVal : 'No Data',
                                        style: TextStyle(
                                            color: choice[key] == 'old'
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    setS(() => choice[key] = 'scanned'),
                                child: Container(
                                  constraints:
                                  const BoxConstraints(minHeight: 60),
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: choice[key] == 'scanned'
                                        ? Colors.green.withOpacity(0.8)
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text('New Data',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: choice[key] == 'scanned'
                                                  ? Colors.white70
                                                  : Colors.grey)),
                                      const SizedBox(height: 2),
                                      Text(
                                        newVal.isNotEmpty ? newVal : 'No Data',
                                        style: TextStyle(
                                            color: choice[key] == 'scanned'
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 12),
                        ],
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, null),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    final result = <String, String>{};
                    for (var key in conflictKeys) {
                      result[key] = choice[key] == 'old'
                          ? existing[key] ?? ''
                          : scanned[key] ?? '';
                    }
                    Navigator.pop(ctx, result);
                  },
                  child: const Text("Apply"),
                ),
              ],
            );
          },
        );
      },
    );

    if (selected == null) return;

    // 🔥 Step 4: Apply selected values
    setState(() {
      if (fillOwner) {
        if (selected['Name']?.isNotEmpty == true)
          ownerName.text = selected['Name']!.toUpperCase();
        if (selected['Mobile']?.isNotEmpty == true)
          ownerMobile.text = selected['Mobile']!;
        if (selected['Aadhaar']?.isNotEmpty == true)
          ownerAadhaar.text = selected['Aadhaar']!;
        if (selected['Address']?.isNotEmpty == true)
          ownerAddress.text = selected['Address']!.toUpperCase();
      } else if (tenantIndex != null && tenantIndex < tenants.length) {
        final t = tenants[tenantIndex];
        if (selected['Name']?.isNotEmpty == true)
          t.name.text = selected['Name']!.toUpperCase();
        if (selected['Mobile']?.isNotEmpty == true)
          t.mobile.text = selected['Mobile']!;
        if (selected['Aadhaar']?.isNotEmpty == true)
          t.aadhaar.text = selected['Aadhaar']!;
        if (selected['Address']?.isNotEmpty == true)
          t.address.text = selected['Address']!.toUpperCase();
      }
    });

    _showToast('Fields updated successfully!');
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

      request.fields['additional_tenants[$idx][police_verification_for_addtional_tenant]'] =
      t.includePoliceVerification ? "true" : "false";

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
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement.php",
      );
      final request = http.MultipartRequest("POST", uri);

      final firstTenant = tenants[0];

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
        "is_Police": firstTenant.includePoliceVerification.toString(),
        "Bhk": Bhk.text,
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
        "agreement_price": Agreement_price.text ?? "--",
        "notary_price": Notary_price ?? '10 rupees',
        "is_agreement_hide": isAgreementHide ? "1" : "0",
        "agreement_type": "External Rental Agreement",
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
          request.fields[key] = existingUrl!.split("/agreement/").last;

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

    await _loaduserdata();
    print("Loaded Name: $_name, Number: $_number");

    try {
      _showToast('Updating...');
      print("⏳ Updating...");

      final uri = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement_update.php",
      );
      final request = http.MultipartRequest("POST", uri);

      final firstTenant = tenants[0];


      final Map<String, dynamic> textFields = {
        "id": widget.agreementId,
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
        "is_Police": firstTenant.includePoliceVerification.toString(),
        "Bhk": Bhk.text,
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
        "agreement_price": Agreement_price.text,
        "notary_price": Notary_price ?? '10 rupees',
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
      labelStyle: TextStyle(color: Colors.black),
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
    void Function(String)? onChanged,
    bool readOnly = false,
    bool enabled = true,
    bool showInWords = false,
  }) {
    return StatefulBuilder(
      builder: (context, setState) {
        final isEmpty = controller.text.trim().isEmpty;

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
                        color: isEmpty
                            ? Colors.red.withOpacity(0.25)
                            : Theme.of(context).colorScheme.primary.withOpacity(0.14),
                        blurRadius: 14,
                        spreadRadius: 1,
                      )
                    ]
                        : null,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextFormField(
                    controller: controller,
                    keyboardType: keyboard,
                    textCapitalization: TextCapitalization.characters,
                    validator: validator,
                    onFieldSubmitted: onFieldSubmitted,
                    inputFormatters: inputFormatters,
                    readOnly: readOnly,
                    enabled: enabled,
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: label,
                      labelStyle: TextStyle(
                        // 🔥 label bhi red jab empty
                        color: isEmpty ? Colors.red.shade700 : Colors.black,
                        fontWeight: isEmpty ? FontWeight.w600 : FontWeight.normal,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      filled: true,
                      // 🔥 background bhi halka red jab empty
                      fillColor: isEmpty
                          ? Colors.red.shade50
                          : Colors.grey.shade50,

                      // 🔥 Border: red when empty, normal when filled
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isEmpty ? Colors.red.shade400 : Colors.grey.shade400,
                          width: isEmpty ? 1.8 : 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isEmpty ? Colors.red.shade600 : Colors.black,
                          width: 1.8,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.red.shade700, width: 1.8),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: Colors.red.shade700, width: 2),
                      ),
                      errorMaxLines: 2,
                      errorStyle: const TextStyle(
                        color: Color(0xFFB00020),
                        fontWeight: FontWeight.w600,
                      ),
                      // 🔥 suffix icon: red X when empty, green check when filled
                      suffixIcon: isEmpty
                          ? Icon(Icons.warning_amber_rounded,
                          color: Colors.red.shade400, size: 20)
                          : const Icon(Icons.check_circle_outline,
                          color: Colors.green, size: 20),
                    ),
                    onChanged: (v) {
                      setState(() {}); // rebuild for color update
                      if (onChanged != null) onChanged(v);
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

  // 🔥 Full screen image viewer
  void _showImageFullScreen({File? file, String? url}) {
    if (file == null && (url == null || url.isEmpty)) return;

    final imageWidget = file != null
        ? Image.file(file, fit: BoxFit.contain)
        : Image.network(
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$url',
      fit: BoxFit.contain,
      loadingBuilder: (_, child, progress) => progress == null
          ? child
          : const Center(
          child: CircularProgressIndicator(color: Colors.white)),
      errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white, size: 60)),
    );

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.92),
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 5.0,
                  child: imageWidget,
                ),
              ),
              Positioned(
                top: 48,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: Colors.black54, shape: BoxShape.circle),
                    child:
                    const Icon(Icons.close, color: Colors.white, size: 24),
                  ),
                ),
              ),
              Positioned(
                bottom: 32,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(
                    'Tap anywhere to close • Pinch to zoom',
                    style: TextStyle(color: Colors.white60, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _aadhaarImageCard({
    required String label,
    required File? file,
    required String? url,
    required VoidCallback onUpload,
    IconData placeholderIcon = Icons.add_a_photo_outlined,
  }) {
    final hasImage = file != null || (url != null && url.isNotEmpty);
    const baseUrl =
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/';

    Widget imageContent;
    if (file != null) {
      imageContent = Stack(fit: StackFit.expand, children: [
        Image.file(file, fit: BoxFit.cover),
        Positioned(top: 8, right: 8, child: _zoomBadge()),
      ]);
    } else if (url != null && url.isNotEmpty) {
      imageContent = Stack(fit: StackFit.expand, children: [
        Image.network(
          '$baseUrl$url',
          fit: BoxFit.cover,
          loadingBuilder: (_, child, p) => p == null
              ? child
              : const Center(
              child: CircularProgressIndicator(strokeWidth: 2)),
          errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.broken_image, color: Colors.grey, size: 40)),
        ),
        Positioned(top: 8, right: 8, child: _zoomBadge()),
      ]);
    } else {
      imageContent =
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(placeholderIcon, color: Colors.grey, size: 32),
            const SizedBox(height: 6),
            const Text('Tap to upload',
                style: TextStyle(fontSize: 11, color: Colors.grey)),
          ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.black54)),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: hasImage
              ? () => _showImageFullScreen(file: file, url: url)
              : onUpload,
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              border: Border.all(
                color: hasImage ? Colors.green.shade400 : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: imageContent,
            ),
          ),
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.upload_file, color: Colors.white, size: 16),
            label: Text(
              hasImage ? 'Change' : 'Upload',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black87,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _zoomBadge() => Container(
    padding: const EdgeInsets.all(5),
    decoration:
    const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
    child: const Icon(Icons.zoom_in, color: Colors.white, size: 16),
  );

  Widget _imageTile({File? file, String? url, required String hint}) {
    final hasImage = file != null || (url != null && url.isNotEmpty);
    return GestureDetector(
      onTap: hasImage ? () => _showImageFullScreen(file: file, url: url) : null,
      child: Container(
        width: 120,
        height: 72,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey.shade200,
          border: hasImage
              ? Border.all(color: Colors.green.shade400, width: 1.5)
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: file != null
              ? Stack(fit: StackFit.expand, children: [
            Image.file(file, fit: BoxFit.cover),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.zoom_in,
                    color: Colors.white, size: 14),
              ),
            ),
          ])
              : (url != null && url.isNotEmpty)
              ? Stack(fit: StackFit.expand, children: [
            Image.network(
              'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$url',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Center(
                  child: Text('Error',
                      style: TextStyle(fontSize: 12))),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Colors.black54, shape: BoxShape.circle),
                child: const Icon(Icons.zoom_in,
                    color: Colors.white, size: 14),
              ),
            ),
          ])
              : Center(
              child: Text(hint,
                  style: const TextStyle(
                      fontSize: 12, color: Colors.black))),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('External Agreement', style: const TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600)),
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
    final stepLabels = ['Owner', 'Tenant', 'Property', 'Preview'];
    final stepIcons = [Icons.person, Icons.person_outline, Icons.home, Icons.preview];

    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 94,
            child: LayoutBuilder(builder: (context, constraints) {
              final gap = (constraints.maxWidth - 64) / (stepLabels.length - 1);

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

        // ── HEADER ──
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text('Owner Details',
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
          ),
          Container(
            decoration: BoxDecoration(
              gradient:  LinearGradient(
                  colors: [
                    Colors.blue.shade700,
                    Colors.blue,
                  ]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton.icon(
              onPressed: () async {
                final a = ownerAadhaar.text.trim();
                final m = ownerMobile.text.trim();
                if (a.isEmpty && m.isEmpty) {
                  _showToast('Please enter Aadhaar or Mobile number first');
                  return;
                }
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => const Center(
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 14),
                          Text('Fetching owner details...'),
                        ]),
                      ),
                    ),
                  ),
                );
                await _fetchUserData(
                    fillOwner: true,
                    aadhaar: a.isNotEmpty ? a : null,
                    mobile: a.isEmpty ? m : null);
                if (mounted) {
                  Navigator.of(context, rootNavigator: true).pop();
                  setState(() {});
                }
              },
              icon: const Icon(Icons.search, color: Colors.white),
              label: const Text('Auto Fetch',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent),
            ),
          ),
        ]),

        const SizedBox(height: 16),

        // ── AADHAAR IMAGES ──
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.badge_outlined, size: 18, color: Colors.black54),
              const SizedBox(width: 6),
              const Text('Owner Aadhaar Documents',
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.black87)),
              const Spacer(),
              if (ownerAadhaarFront != null ||
                  (ownerAadharFrontUrl?.isNotEmpty ?? false))
                const Icon(Icons.check_circle, color: Colors.green, size: 18),
            ]),
            const SizedBox(height: 14),

            // ── FRONT & BACK side by side ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _aadhaarImageCard(
                    label: 'Aadhaar Front',
                    file: ownerAadhaarFront,
                    url: ownerAadharFrontUrl,
                    onUpload: () => _pickImage('ownerFront'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _aadhaarImageCard(
                    label: 'Aadhaar Back',
                    file: ownerAadhaarBack,
                    url: ownerAadharBackUrl,
                    onUpload: () => _pickImage('ownerBack'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),
            Text(
              'Enter Aadhaar or Mobile number above and tap Auto Fetch to fill details automatically.',
              style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                  fontStyle: FontStyle.italic),
            ),
          ]),
        ),

        const SizedBox(height: 16),

        // ── FORM FIELDS ──
        Form(
          key: _ownerFormKey,
          child: Column(children: [
            Row(children: [
              Expanded(
                child: _glowTextField(
                  controller: ownerMobile,
                  label: 'Mobile No',
                  keyboard: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v))
                      return 'Enter valid 10-digit mobile';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _glowTextField(
                  controller: ownerAadhaar,
                  label: 'Aadhaar / VID No',
                  keyboard: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(16),
                  ],
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Required';
                    final d = v.trim();
                    if (!RegExp(r'^\d{12}$').hasMatch(d) &&
                        !RegExp(r'^\d{16}$').hasMatch(d))
                      return 'Enter valid 12-digit Aadhaar or 16-digit VID';
                    return null;
                  },
                ),
              ),
            ]),
            const SizedBox(height: 14),
            _glowTextField(
                controller: ownerName,
                label: 'Owner Full Name',
                validator: (v) =>
                (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: ownerRelation,
                  items: const ['S/O', 'D/O', 'W/O', 'C/O']
                      .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,
                          style:
                          const TextStyle(color: Colors.black))))
                      .toList(),
                  onChanged: (v) =>
                      setState(() => ownerRelation = v ?? 'S/O'),
                  decoration: _fieldDecoration('Relation').copyWith(
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                        const BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black, width: 1.5)),
                  ),
                  iconEnabledColor: Colors.black,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _glowTextField(
                    controller: ownerRelationPerson,
                    label: 'Person Name',
                    validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Required' : null),
              ),
            ]),
            const SizedBox(height: 12),
            _glowTextField(
                controller: ownerAddress,
                label: 'Permanent Address',
                validator: (v) =>
                (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
          ]),
        ),
      ]),
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

                    // ── HEADER ──
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Tenant ${index + 1} Details',
                            style: const TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        Wrap(
                          spacing: 8,
                          children: [

                            // AUTO FETCH BUTTON
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.blue.shade700,
                                    Colors.blue,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final a = tenants[index].aadhaar.text.trim();
                                  final m = tenants[index].mobile.text.trim();
                                  if (a.isEmpty && m.isEmpty) {
                                    _showToast('Enter Aadhaar or Mobile number first');
                                    return;
                                  }
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (_) => const Center(
                                      child: Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(height: 14),
                                              Text('Fetching tenant details...'),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                  await _fetchUserData(
                                    fillOwner: false,
                                    aadhaar: a.isNotEmpty ? a : null,
                                    mobile: a.isEmpty ? m : null,
                                    tenantIndex: index,
                                  );
                                  if (mounted) {
                                    Navigator.of(context, rootNavigator: true).pop();
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(Icons.search,
                                    color: Colors.white, size: 18),
                                label: const Text('Auto Fetch',
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                ),
                              ),
                            ),

                            // DELETE BUTTON
                            if (index > 0 &&
                                (widget.agreementId == null ||
                                    tenants[index].id == null))
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() => tenants.removeAt(index));
                                  updateAgreementPrice();
                                },
                              ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // ── AADHAAR IMAGES ──
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            const Icon(Icons.badge_outlined,
                                size: 18, color: Colors.black54),
                            const SizedBox(width: 6),
                            Text(
                              'Tenant ${index + 1} Documents',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: Colors.black87),
                            ),
                            const Spacer(),
                            if (tenants[index].aadhaarFront != null ||
                                (tenants[index].aadhaarFrontUrl?.isNotEmpty ?? false))
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 18),
                          ]),
                          const SizedBox(height: 14),

                          // FRONT + BACK + PHOTO side by side
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: _aadhaarImageCard(
                                  label: 'Aadhaar Front',
                                  file: tenants[index].aadhaarFront,
                                  url: tenants[index].aadhaarFrontUrl,
                                  onUpload: () => _pickTenantDoc(index, true),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _aadhaarImageCard(
                                  label: 'Aadhaar Back',
                                  file: tenants[index].aadhaarBack,
                                  url: tenants[index].aadhaarBackUrl,
                                  onUpload: () => _pickTenantDoc(index, false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _aadhaarImageCard(
                                  label: 'Photo',
                                  file: tenants[index].photo,
                                  url: tenants[index].photoUrl,
                                  onUpload: () => _pickTenantPhoto(index),
                                  placeholderIcon: Icons.person_outline,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),
                          Text(
                            'Upload Aadhaar images — OCR will auto-fill fields below.',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── FORM FIELDS ──
                    Column(
                      children: [
                        Row(children: [
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
                                if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v))
                                  return 'Enter valid 10-digit mobile';
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
                                    !RegExp(r'^\d{16}$').hasMatch(v))
                                  return 'Enter valid Aadhaar / VID';
                                return null;
                              },
                            ),
                          ),
                        ]),

                        const SizedBox(height: 12),

                        _glowTextField(
                          controller: tenants[index].name,
                          label: 'Tenant Full Name',
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),

                        const SizedBox(height: 12),

                        Row(children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: tenants[index].relation,
                              items: const ['S/O', 'D/O', 'W/O', 'C/O']
                                  .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e,
                                      style: const TextStyle(
                                          color: Colors.black))))
                                  .toList(),
                              onChanged: (v) => setState(
                                      () => tenants[index].relation = v ?? 'S/O'),
                              decoration: _fieldDecoration('Relation').copyWith(
                                labelStyle:
                                const TextStyle(color: Colors.black),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide:
                                    const BorderSide(color: Colors.black)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Colors.black, width: 1.5)),
                              ),
                              dropdownColor: Colors.white,
                              iconEnabledColor: Colors.black,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _glowTextField(
                              controller: tenants[index].relationPerson,
                              label: 'Person Name',
                              validator: (v) =>
                              (v == null || v.trim().isEmpty) ? 'Required' : null,
                            ),
                          ),
                        ]),

                        const SizedBox(height: 12),

                        _glowTextField(
                          controller: tenants[index].address,
                          label: 'Permanent Address',
                          validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                        ),

                        const SizedBox(height: 16),

                        // Police Verification
                        Container(
                          decoration: BoxDecoration(
                            color: tenants[index].includePoliceVerification
                                ? Colors.red.shade50
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: tenants[index].includePoliceVerification
                                  ? Colors.red.shade200
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: CheckboxListTile(
                            value: tenants[index].includePoliceVerification,
                            onChanged: (v) {
                              setState(() {
                                tenants[index].includePoliceVerification =
                                    v ?? false;
                              });
                              updateAgreementPrice();
                            },
                            title: const Text(
                              'Include Police Verification',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black),
                            ),
                            subtitle: Text(
                              widget.rewardStatus.isDiscounted
                                  ? 'Adds ₹40 to agreement price (Discounted)'
                                  : 'Adds ₹50 to agreement price',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black54),
                            ),
                            activeColor: Colors.redAccent,
                            checkColor: Colors.white,
                            side: const BorderSide(
                                color: Colors.black54, width: 1.5),
                          ),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

        // ── ADD TENANT BUTTON ──
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              setState(() => tenants.add(ExtraTenant()));
              updateAgreementPrice();
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade700,
                    Colors.red.shade600,
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, color: Colors.white),
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
  String? userName;
  String? userNumber;
  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');

    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
      });
    }
  }

  Future<void> fetchPropertyDetails() async {
    final propertyId = propertyID.text.trim();
    if (propertyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Property ID first")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/display_api_base_on_flat_id.php"),
        body: {"P_id": propertyId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == "success") {
          final data = json['data'];

          setState(() {
            fetchedData = data;
            isPropertyFetched = true;
            Bhk.text = data['Bhk'] ?? '';
            floor.text = data['Floor_'] ?? '';
            Address.text =
            "Flat-${data['Flat_number'] ?? ''}  ${data['Apartment_Address'] ?? ''}";
            rentAmount.text = data['show_Price'] ?? "";
            meterInfo = data['meter'] == "Govt"
                ? "As per Govt. Unit"
                : "Custom Unit (Enter Amount)";
            parking =
            (data['parking'].toString().toLowerCase().contains("bike"))
                ? "Bike"
                : (data['parking']
                .toString()
                .toLowerCase()
                .contains("car"))
                ? "Car"
                : (data['parking']
                .toString()
                .toLowerCase()
                .contains("both"))
                ? "Both"
                : "No";
            maintenance = (data['maintance']
                .toString()
                .toLowerCase()
                .contains("include"))
                ? "Including"
                : "Excluding";
          });
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

  void _resetProperty() {
    setState(() {
      fetchedData = null;
      isPropertyFetched = false;
      Bhk.clear();
      floor.clear();
      Address.clear();
      rentAmount.clear();
      meterInfo = 'As per Govt. Unit';
      parking = 'Car';
      maintenance = 'Including';
      customUnitAmount.clear();
      customMaintanceAmount.clear();
    });
  }

  List<BuildingSuggestion> buildingSuggestions = [];
  bool isSuggestionLoading = false;

  Future<void> fetchBuildingSuggestions(String mobile) async {
    setState(() {
      buildingSuggestions = [];
      isSuggestionLoading = true;
    });

    try {
      final uri = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/building_data_for_agreement.php?mobile_number=$mobile&fieldworker_number=$userNumber",
      );

      final res = await http.get(uri);
      print("🏢 Building API status: ${res.statusCode}");

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);
        final status = decoded["status"];
        final isSuccess =
            status == true || status == "true" || status == 1 || status == "1";

        if (isSuccess && decoded["buildings"] != null) {
          final List list = decoded["buildings"];
          setState(() {
            buildingSuggestions =
                list.map((e) => BuildingSuggestion.fromJson(e)).toList();
          });
        }
      }
    } catch (e) {
      print("❌ Building fetch error: $e");
    } finally {
      setState(() => isSuggestionLoading = false);
    }
  }

  Future<void> _showBuildingSuggestions(String mobile) async {
    if (mobile.length < 10) {
      _showToast("Enter valid mobile number");
      return;
    }

    setState(() {
      buildingSuggestions = [];
      isSuggestionLoading = true;
    });

    await fetchBuildingSuggestions(mobile);

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.75,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // DRAG HANDLE
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white24 : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text("Select Property",
                      style: TextStyle(
                          fontSize: 20,
                          fontFamily: "PoppinsMedium",
                          color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 4),
                  Text("Mobile: $mobile",
                      style: TextStyle(
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.grey)),
                  const SizedBox(height: 10),
                  Divider(
                      color: isDark ? Colors.white10 : Colors.grey.shade300),

                  // LIST
                  Expanded(
                    child: buildingSuggestions.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off,
                              size: 48,
                              color: isDark
                                  ? Colors.white30
                                  : Colors.grey.shade400),
                          const SizedBox(height: 12),
                          Text(
                              "No property found for this number",
                              style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  color: isDark
                                      ? Colors.white60
                                      : Colors.grey)),
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () async {
                              setSheetState(() {});
                              await fetchBuildingSuggestions(mobile);
                              setSheetState(() {});
                            },
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                        : ListView.builder(
                      itemCount: buildingSuggestions.length,
                      itemBuilder: (context, idx) {
                        final building = buildingSuggestions[idx];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF1F2937)
                                : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: isDark
                                    ? Colors.white10
                                    : Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // BUILDING HEADER
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            Future_Property_details(
                                                idd: building.id
                                                    .toString()),
                                      ));
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isDark
                                        ? const Color(0xFF7F1D1D)
                                        : Colors.red.shade50,
                                    borderRadius:
                                    const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  child: Row(children: [
                                    const Icon(Icons.apartment,
                                        color: Color(0xFFEF4444)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "Owner: ${building.ownerName}",
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: isDark
                                                        ? Colors.white54
                                                        : Colors.black54)),
                                            const SizedBox(height: 2),
                                            Text(
                                                building
                                                    .propertyAddressForFieldworkar,
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w600,
                                                    color: isDark
                                                        ? Colors.white
                                                        : Colors.black87)),
                                          ],
                                        )),
                                    Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                        children: [
                                          Text("ID: ${building.id}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight:
                                                  FontWeight.w700,
                                                  color: isDark
                                                      ? Colors.white70
                                                      : Colors.black87)),
                                          Text(
                                              "${building.flats.length} flat(s)",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: isDark
                                                      ? Colors.white38
                                                      : Colors.grey)),
                                        ]),
                                  ]),
                                ),
                              ),

                              // FLATS
                              if (building.flats.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text("No flats listed",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.white38
                                              : Colors.grey)),
                                )
                              else
                                Column(
                                  children: building.flats.map((flat) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          Bhk.text = flat.bhk;
                                          floor.text = flat.floor;
                                          Address.text = flat.address;
                                          propertyID.text = flat.id;
                                        });
                                        Navigator.pop(context);
                                        _showToast(
                                            'Property selected: ${flat.bhk}, Floor ${flat.floor}');
                                      },
                                      child: Container(
                                        padding:
                                        const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 12),
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: isDark
                                                      ? Colors.white10
                                                      : Colors.grey
                                                      .shade200)),
                                        ),
                                        child: Row(children: [
                                          Container(
                                            padding: const EdgeInsets
                                                .symmetric(
                                                horizontal: 10,
                                                vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                  0xFFEF4444)
                                                  .withOpacity(.15),
                                              borderRadius:
                                              BorderRadius.circular(
                                                  8),
                                            ),
                                            child: Text(flat.bhk,
                                                style: const TextStyle(
                                                    fontSize: 11,
                                                    color: Color(
                                                        0xFFEF4444),
                                                    fontWeight:
                                                    FontWeight.w600)),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text("₹${flat.price}",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                          FontWeight.w600,
                                                          color: isDark
                                                              ? Colors.white
                                                              : Colors
                                                              .black)),
                                                  Text(
                                                      "Floor ${flat.floor}  •  ${flat.fieldworkarAddress}",
                                                      style: TextStyle(
                                                          fontSize: 11,
                                                          color: isDark
                                                              ? Colors.white54
                                                              : Colors.grey)),
                                                ],
                                              )),
                                          Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                    "Flat ID: ${flat.id}",
                                                    style: TextStyle(
                                                        fontSize: 11,
                                                        color: isDark
                                                            ? Colors
                                                            .white54
                                                            : Colors
                                                            .grey)),
                                                const SizedBox(height: 2),
                                                Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                      color: Colors
                                                          .green.shade100,
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(
                                                          6)),
                                                  child: const Text(
                                                      "Tap to select",
                                                      style: TextStyle(
                                                          fontSize: 10,
                                                          color: Colors
                                                              .green,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600)),
                                                ),
                                              ]),
                                        ]),
                                      ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _propertyStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        if (fetchedData != null) _propertyCard(fetchedData!),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Property Details',
                style: TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black)),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // AUTO FETCH BUTTON
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD50000), Color(0xFFB71C1C)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  if (isPropertyFetched) {
                    _resetProperty();
                  } else {
                    fetchPropertyDetails();
                  }
                },
                icon: Icon(
                  isPropertyFetched ? Icons.refresh : Icons.search,
                  color: Colors.white,
                ),
                label: Text(
                  isPropertyFetched ? 'Change' : 'Auto Fetch',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),

            // SUGGESTION BUTTON
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1D4ED8), Color(0xFF2563EB)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  String mobile = ownerMobile.text;
                  if (mobile.isEmpty && tenants.isNotEmpty) {
                    mobile = tenants[0].mobile.text;
                  }
                  if (mobile.isEmpty) {
                    _showToast("Enter mobile number first");
                    return;
                  }
                  _showBuildingSuggestions(mobile);
                },
                icon: const Icon(Icons.apartment, color: Colors.white),
                label: const Text('Suggestion',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
              ),
            ),
          ],
        ),

        Form(
          key: _propertyFormKey,
          child: Column(children: [
            _glowTextField(
                controller: propertyID,
                keyboard: TextInputType.number,
                label: 'Property ID',
                validator: (v) =>
                (v?.trim().isEmpty ?? true) ? 'Required' : null),
            Row(children: [
              Expanded(
                  child: _glowTextField(
                      controller: Bhk,
                      label: 'BHK',
                      readOnly: isPropertyFetched,
                      validator: (v) =>
                      (v?.trim().isEmpty ?? true) ? 'Required' : null)),
              const SizedBox(width: 12),
              Expanded(
                  child: _glowTextField(
                      controller: floor,
                      label: 'Floor',
                      readOnly: isPropertyFetched,
                      validator: (v) =>
                      (v?.trim().isEmpty ?? true) ? 'Required' : null)),
            ]),
            _glowTextField(
                controller: Address,
                label: 'Rented Address',
                readOnly: isPropertyFetched,
                validator: (v) =>
                (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 10),

            Row(children: [
              Expanded(
                  child: _glowTextField(
                    controller: rentAmount,
                    label: 'Monthly Rent (INR)',
                    keyboard: TextInputType.number,
                    showInWords: true,
                    readOnly: isPropertyFetched,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6)
                    ],
                    onChanged: (v) {
                      setState(() {
                        rentAmountInWords = convertToWords(
                            int.tryParse(v.replaceAll(',', '')) ?? 0);
                      });
                    },
                    validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Required' : null,
                  )),
              const SizedBox(width: 12),
              Expanded(
                  child: _glowTextField(
                    controller: securityAmount,
                    label: 'Security Amount (INR)',
                    keyboard: TextInputType.number,
                    showInWords: true,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6)
                    ],
                    onChanged: (v) {
                      setState(() {
                        securityAmountInWords = convertToWords(
                            int.tryParse(v.replaceAll(',', '')) ?? 0);
                      });
                    },
                    validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Required' : null,
                  )),
            ]),

            const SizedBox(height: 8),
            CheckboxListTile(
              value: securityInstallment,
              onChanged: (v) =>
                  setState(() => securityInstallment = v ?? false),
              title: const Text('Pay security in installments?',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600)),
              activeColor: Colors.redAccent,
              checkColor: Colors.white,
              side: const BorderSide(color: Colors.black54, width: 1.5),
            ),

            if (securityInstallment)
              _glowTextField(
                controller: installmentAmount,
                label: 'Installment Amount (INR)',
                keyboard: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                showInWords: true,
                onChanged: (v) {
                  setState(() {
                    installmentAmountInWords = convertToWords(
                        int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                },
                validator: (v) {
                  if (securityInstallment &&
                      (v == null || v.trim().isEmpty)) return 'Required';
                  return null;
                },
              ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: meterInfo,
              items: const ['As per Govt. Unit', 'Custom Unit (Enter Amount)']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) =>
                  setState(() => meterInfo = v ?? 'As per Govt. Unit'),
              decoration: _fieldDecoration('Meter Info'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: Colors.black,
            ),

            if (meterInfo.startsWith('Custom'))
              _glowTextField(
                controller: customUnitAmount,
                label: 'Custom Unit Amount (INR)',
                keyboard: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                showInWords: true,
                onChanged: (v) {
                  setState(() {
                    customUnitAmountInWords = convertToWords(
                        int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                },
                validator: (v) {
                  if (meterInfo.startsWith('Custom') &&
                      (v == null || v.trim().isEmpty)) return 'Required';
                  return null;
                },
              ),

            const SizedBox(height: 6),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                shiftingDate == null
                    ? 'Select Shifting Date'
                    : 'Shifting: ${shiftingDate!.toLocal().toString().split(' ')[0]}',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: shiftingDate == null
                      ? FontWeight.w500
                      : FontWeight.w700,
                ),
              ),
              trailing: const Icon(Icons.calendar_today, color: Colors.red),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) setState(() => shiftingDate = picked);
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: parking,
              items: const ['Car', 'Bike', 'Both', 'No']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => parking = v ?? 'Car'),
              decoration: _fieldDecoration('Parking'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: Colors.black,
            ),

            DropdownButtonFormField<String>(
              value: maintenance,
              items: const ['Including', 'Excluding']
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => maintenance = v ?? 'Including'),
              decoration: _fieldDecoration('Maintenance'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black),
              iconEnabledColor: Colors.black,
            ),

            if (maintenance.startsWith('Excluding'))
              _glowTextField(
                controller: customMaintanceAmount,
                label: 'Custom Maintenance Amount (INR)',
                keyboard: TextInputType.number,
                showInWords: true,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6)
                ],
                onChanged: (v) {
                  setState(() {
                    customMaintanceAmountInWords = convertToWords(
                        int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                },
                validator: (v) {
                  if (maintenance.startsWith('Excluding') &&
                      (v == null || v.trim().isEmpty)) return 'Required';
                  return null;
                },
              ),

            const SizedBox(height: 12),

            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: Notary_price,
                  items: const [
                    '10 rupees',
                    '20 rupees',
                    '50 rupees',
                    '100 rupees'
                  ]
                      .map((e) => DropdownMenuItem(
                      value: e,
                      child: Text(e,
                          style:
                          const TextStyle(color: Colors.black))))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      Notary_price = v ?? '10 rupees';
                      updateAgreementPrice();
                    });
                  },
                  decoration: _fieldDecoration('Notary price').copyWith(
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Colors.black, width: 1.5)),
                  ),
                  iconEnabledColor: Colors.black,
                  dropdownColor: Colors.white,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _agreementPriceBox(
                  amount: int.tryParse(Agreement_price.text) ?? 0,
                  amountInWords: AgreementAmountInWords,
                ),
              ),
            ]),
          ]),
        ),
      ]),
    );
  }

  Widget _previewStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Preview', style: const TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700,color: Colors.black)),
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

                /// Photo
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
        const SizedBox(height: 12),
        _sectionCard(title: '*Property', children: [
          _kv('Property ID', propertyID.text),
          _kv('BHK', Bhk.text),
          _kv('Floor', floor.text),
          _kv('Address', Address.text),
          _kv('Notary Price', Notary_price),
          _kv('Agreement price', '${Agreement_price.text} (${AgreementAmountInWords})'),
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
          Row(children: [const Spacer(), TextButton(onPressed: () => _jumpToStep(2),style: TextButton.styleFrom(
            foregroundColor: Colors.red, // text color
          ), child: const Text('Edit'))])
        ]),

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

  Widget _propertyCard(Map<String, dynamic> data) {
    final String imageUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black.withOpacity(0.15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("₹${data['show_Price'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent)),
                    Text(data['Bhk'] ?? "",
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.black)),
                    Text("Floor: ${data['Floor_'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black54)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Name: ${data['field_warkar_name'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    Text("Location: ${data['locations'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Meter: ${data['meter'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    Text("Parking: ${data['parking'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Maintenance: ${data['maintance'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    Text("Flat: ${data['Flat_number'] ?? "--"}",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [SizedBox(width: 140, child: Text('$k:', style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black))), Expanded(child: Text(v,style: TextStyle(color: Colors.black),))]),
    );
  }

  Widget _agreementPriceBox({
    required int amount,
    required String amountInWords,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black, width: 1.2),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Agreement Price',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '₹ $amount',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
        ],
      ),
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