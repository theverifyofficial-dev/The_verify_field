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
import '../../Custom_Widget/Crop.dart';
import '../../Custom_Widget/Custom_backbutton.dart';
import 'package:http_parser/http_parser.dart';
import '../../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Dashboard_screen.dart';



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
      propertyAddressForFieldworkar: json["property_address_for_fieldworkar"] ?? "",
      place: json["place"] ?? "",
      flats: (json["flats"] as List).map((e) => FlatSuggestion.fromJson(e)).toList(),
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

class DirectorBlock {
  String? id; // 🔥 (for update case)

  final name = TextEditingController();
  final mobile = TextEditingController();
  final aadhaar = TextEditingController();
  final address = TextEditingController();
  final relationPerson = TextEditingController();
  final gstNo = TextEditingController();
  final panNo = TextEditingController();

  bool includePoliceVerification = false;

  String relation = 'S/O';

  File? aadhaarFront;
  File? aadhaarBack;
  File? photo;
  File? gstPhoto;
  File? panPhoto;

  String? aadhaarFrontUrl;
  String? aadhaarBackUrl;
  String? photoUrl;
  String? gstPhotoUrl;
  String? panPhotoUrl;

}

class CommercialWizardPage extends StatefulWidget {
  final String? agreementId;
  final RewardStatus rewardStatus;


  const CommercialWizardPage({Key? key, this.agreementId,required this.rewardStatus}) : super(key: key);

  @override
  State<CommercialWizardPage> createState() => _CommercialWizardPageState();
}

class _CommercialWizardPageState extends State<CommercialWizardPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  String? selectedFloor;

  String gstType = 'GST';

  final List<String> gstTypes = [
    'GST',
    'MOA',
    'MOI',
    'COI',
    'TAN',
    'COO',
  ];

  final List<String> commercialFloors = [
    'Basement -2',
    'Basement -1',
    'Basement',
    'Ground',
    'Mezzanine',
    'First',
    'Second',
    'Third',
    'Fourth',
    'Fifth',
    'Sixth',
    'Seventh',
    'Eighth',
    'Terrace',
  ];

  bool isPropertyFetched = false;

  final List<DirectorBlock> directors = [];

  bool isAgreementHide = false; // 🔐 privacy toggle
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
  final CompanyName = TextEditingController();

  Map<String, dynamic>? fetchedData;

  final _propertyFormKey = GlobalKey<FormState>();
  final Address = TextEditingController();
  final rentAmount = TextEditingController();
  final Sqft = TextEditingController();

  final securityAmount = TextEditingController();
  bool securityInstallment = false;
  final installmentAmount = TextEditingController();
  String meterInfo = 'Commercial';
  final customUnitAmount = TextEditingController();
  final propertyID = TextEditingController();
  DateTime? shiftingDate;
  String maintenance = 'Including';
  String parking = 'Car';
  final customMaintanceAmount = TextEditingController();
  final Agreement_price = TextEditingController();
  String AgreementAmountInWords = '';
  String Notary_price = '10 rupees';
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
    if (directors.isEmpty) {
      directors.add(DirectorBlock());
    }

    final discounted = widget.rewardStatus.isDiscounted;
    final defaultPrice = discounted ? 100 : 150;
    Agreement_price.text = defaultPrice.toString();
    AgreementAmountInWords = convertToWords(defaultPrice);

    _fabController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 400));

    if (widget.agreementId != null) {
      _fetchAgreementDetails(widget.agreementId!);
    }
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

  List<BuildingSuggestion> buildingSuggestions = [];
  bool isSuggestionLoading = false;

  Future<void> fetchBuildingSuggestions(String mobile) async {

    final uri = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/building_data_for_agreement.php?mobile_number=$mobile&fieldworker_number=$userNumber",
    );

    final res = await http.get(uri);

    if (res.statusCode == 200) {

      final decoded = jsonDecode(res.body);
      print("userNumber $userNumber");
      print(res.statusCode);

      if (decoded["status"] == true) {

        final List list = decoded["buildings"];

        setState(() {
          buildingSuggestions =
              list.map((e) => BuildingSuggestion.fromJson(e)).toList();
        });

      }

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


          if (directors.isEmpty) {
            directors.add(DirectorBlock());
          }

          final d = directors[0];

          d.name.text = data["tenant_name"] ?? "";
          d.relation = data["tenant_relation"] ?? "S/O";
          d.relationPerson.text = data["relation_person_name_tenant"] ?? "";
          d.address.text = data["permanent_address_tenant"] ?? "";
          d.mobile.text = data["tenant_mobile_no"] ?? "";
          d.aadhaar.text = data["tenant_addhar_no"] ?? "";

          d.aadhaarFrontUrl = data["tenant_aadhar_front"] ?? "";
          d.aadhaarBackUrl  = data["tenant_aadhar_back"] ?? "";
          d.photoUrl        = data["tenant_image"] ?? "";
          d.includePoliceVerification =
              data["is_Police"] == "true" || data["is_Police"] == "1";

          d.gstNo.text = data["gst_no"] ?? "";
          d.panNo.text = data["pan_no"] ?? "";
          d.gstPhotoUrl = data["gst_photo"] ?? "";
          d.panPhotoUrl = data["pan_photo"] ?? "";

          CompanyName.text = data["company_name"] ?? "";
          gstType = data["gst_type"] ?? 'GST';


          // 🔹 Agreement
          propertyID.text = data["property_id"]?.toString() ?? "";
          Sqft.text = data["Sqft"] ?? "";
          final floorFromApi = data["floor"];
          if (commercialFloors.contains(floorFromApi)) {
            selectedFloor = floorFromApi;
          } else {
            selectedFloor = commercialFloors.first;
          }
          Address.text = data["rented_address"] ?? "";
          rentAmount.text = data["monthly_rent"]?.toString() ?? "";
          securityAmount.text = data["securitys"]?.toString() ?? "";
          installmentAmount.text = data["installment_security_amount"]?.toString() ?? "";

          meterInfo = data["meter"] ?? "Commercial";
          customUnitAmount.text = data["custom_meter_unit"] ?? "";
          maintenance = data["maintaince"] ?? "Including";
          customMaintanceAmount.text = data["custom_maintenance_charge"]?.toString() ?? "";
          parking = data["parking"] ?? "Car";
          Notary_price = data["notary_price"] ?? "10 rupees";

          // 🔹 Police verification (IMPORTANT)

          isAgreementHide = data["is_agreement_hide"] == "1";


          shiftingDate = (data["shifting_date"] != null && data["shifting_date"].toString().isNotEmpty)
              ? DateTime.tryParse(data["shifting_date"])
              : null;
          // 🔹 Documents
          ownerAadharFrontUrl = data["owner_aadhar_front"] ?? "";
          ownerAadharBackUrl  = data["owner_aadhar_back"] ?? "";

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
          if (directors.length > 1) {
            directors.removeRange(1, directors.length);
          }

          for (var e in list) {
            final t = DirectorBlock();

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

            directors.add(t);
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
    Sqft.dispose();
    Address.dispose();
    rentAmount.dispose();
    securityAmount.dispose();
    installmentAmount.dispose();
    customUnitAmount.dispose();
    Agreement_price.dispose();
    CompanyName.dispose();
    for (final d in directors) {
      d.name.dispose();
      d.mobile.dispose();
      d.aadhaar.dispose();
      d.address.dispose();
      d.relationPerson.dispose();
      d.gstNo.dispose();
      d.panNo.dispose();
    }
    super.dispose();
  }

  Future<void> _pickDirectorAadhaar(int index, bool isFront) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    final croppedFile = await cropImage(picked.path);

    if (croppedFile == null) return;

    setState(() {
      if (isFront) directors[index].aadhaarFront = croppedFile;
      else directors[index].aadhaarBack = croppedFile;
    });
    // OCR scan
    showDialog(context: context, barrierDismissible: false,
        builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 14), Text('Scanning Aadhaar card...')])))));
    try {
      final rawText =
      await _recognizeTextNative(croppedFile.path);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (rawText != null && rawText.trim().isNotEmpty) {
        await _applyOcrResult(ocr: _parseAadhaarText(rawText), fillOwner: false, directorIndex: index);
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      _showScanErrorDialog('Scan Failed', 'Could not process image.\n\nError: $e');
    }
  }

  Future<void> _pickDirectorPhoto(int index) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return;

    setState(() {
      directors[index].photo = File(picked.path);
    });
  }

  Future<void> _pickDirectorGST(int index) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked == null) return;

    setState(() {
      directors[index].gstPhoto = File(picked.path);
    });
  }

  Future<void> _pickDirectorPAN(int index) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    final croppedFile = await cropImage(picked.path);

    if (croppedFile == null) return;

    setState(() => directors[index].panPhoto = croppedFile);

    // 🔍 OCR scan for PAN number
    showDialog(context: context, barrierDismissible: false,
        builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(), SizedBox(height: 14),
              Text('Scanning PAN card...', style: TextStyle(fontSize: 14)),
            ])))));
    try {
      final rawText =
      await _recognizeTextNative(croppedFile.path);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (rawText != null && rawText.trim().isNotEmpty) {
        // PAN format: 5 letters + 4 digits + 1 letter (e.g. ABCDE1234F)
        final panRegex = RegExp(r'\b([A-Z]{5}[0-9]{4}[A-Z])\b');
        final match = panRegex.firstMatch(rawText.toUpperCase());
        if (match != null) {
          final panNumber = match.group(1)!;
          final existing = directors[index].panNo.text.trim();
          if (existing.isEmpty) {
            setState(() => directors[index].panNo.text = panNumber);
            _showToast('PAN number detected: $panNumber');
          } else if (existing.toUpperCase() != panNumber) {
            // Conflict popup
            final selected = await showDialog<String>(
                context: context,
                builder: (ctx) {
                  String choice = 'scanned';
                  return StatefulBuilder(builder: (ctx, setS) => AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: const Text("PAN Number"),
                    content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text("Select which PAN number to keep:", style: TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(height: 12),
                      Row(children: [
                        Expanded(child: GestureDetector(onTap: () => setS(() => choice = 'old'),
                            child: Container(constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: choice == 'old' ? Colors.blue.withOpacity(0.8) : Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Old Data', style: TextStyle(fontSize: 10, color: choice == 'old' ? Colors.white70 : Colors.grey)),
                                  const SizedBox(height: 2),
                                  Text(existing, style: TextStyle(color: choice == 'old' ? Colors.white : Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                                ])))),
                        const SizedBox(width: 8),
                        Expanded(child: GestureDetector(onTap: () => setS(() => choice = 'scanned'),
                            child: Container(constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(color: choice == 'scanned' ? Colors.green.withOpacity(0.8) : Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('Scanned', style: TextStyle(fontSize: 10, color: choice == 'scanned' ? Colors.white70 : Colors.grey)),
                                  const SizedBox(height: 2),
                                  Text(panNumber, style: TextStyle(color: choice == 'scanned' ? Colors.white : Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
                                ])))),
                      ]),
                    ]),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text("Cancel")),
                      ElevatedButton(onPressed: () => Navigator.pop(ctx, choice), child: const Text("Apply")),
                    ],
                  ));
                });
            if (selected != null) {
              setState(() => directors[index].panNo.text = selected == 'old' ? existing : panNumber);
              _showToast('PAN number updated!');
            }
          } else {
            _showToast('PAN number already correct: $panNumber');
          }
        } else {
          _showToast('PAN number not detected in image');
        }
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      _showToast('Scan failed: $e');
    }
  }


  // ── OCR ──────────────────────────────────────────────────────────────────
  static const _ocrChannel = MethodChannel('com.verify.app/ocr');

  Future<String?> _recognizeTextNative(String imagePath) async {
    try {
      final String? result = await _ocrChannel.invokeMethod('recognizeText', {'imagePath': imagePath});
      return result;
    } on PlatformException catch (e) {
      print('OCR error: ${e.message}'); rethrow;
    }
  }

  String _titleCase(String s) => s.toLowerCase().split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

  String cleanAddress(String raw) {
    String text = raw;
    text = text.replaceAll(RegExp(r'[^\x00-\x7F]'), '');
    text = text.replaceAll(RegExp(r"[^a-zA-Z0-9,\-\./ ]"), '');
    text = text.replaceAll(RegExp(r'\s+'), ' ');
    text = text.replaceAll(RegExp(r'\s*-\s*'), '-');
    text = text.replaceAll(RegExp(r',+'), ',');
    text = text.replaceAll(RegExp(r'\s*,\s*'), ', ');
    final parts = text.split(', ');
    final seen = <String>{}; final unique = <String>[];
    for (var part in parts) {
      final key = part.trim().toLowerCase();
      if (key.isNotEmpty && !seen.contains(key)) { seen.add(key); unique.add(part.trim()); }
    }
    return unique.join(', ').trim();
  }

  Map<String, String?> _parseAadhaarText(String fullText) {
    final result = <String, String?>{'aadhaarNumber': null, 'name': null, 'address': null, 'mobile': null};
    final lines = fullText.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
    final aadhaarRegex = RegExp(r'\b(\d{4}\s?\d{4}\s?\d{4})\b');
    for (final line in lines) {
      final m = aadhaarRegex.firstMatch(line);
      if (m != null) { result['aadhaarNumber'] = m.group(1)!.replaceAll(' ', ''); break; }
    }
    final skipKw = RegExp(r'(Government|India|INDIA|Aadhaar|UIDAI|DOB|Date|Male|Female|Address|VID|Enrollment|Download|www|\.in|\.com|\d{4})', caseSensitive: false);
    String? foundName;
    for (int i = 0; i < lines.length; i++) {
      if (lines[i].toLowerCase().startsWith('name') && i + 1 < lines.length) {
        final next = lines[i + 1];
        if (!skipKw.hasMatch(next) && next.length > 2) { foundName = _titleCase(next); break; }
      }
    }
    if (foundName == null) {
      for (final line in lines) {
        if (skipKw.hasMatch(line)) continue;
        if (RegExp(r'^[A-Za-z\s\.]+$').hasMatch(line) && line.split(' ').length >= 2 && line.length >= 5 && line.length <= 60) {
          foundName = _titleCase(line); break;
        }
      }
    }
    result['name'] = foundName;
    List<String> addressLines = []; bool start = false;
    for (final line in lines) {
      final lower = line.toLowerCase();
      if (lower.contains('s/o') || lower.contains('d/o') || lower.contains('w/o') || lower.contains('c/o')) {
        start = true; addressLines.add(line.trim()); continue;
      }
      if (!start) continue;
      if (lower.contains('uidai') || lower.contains('government') || lower.contains('india') || lower.contains('aadhaar') || lower.contains('www')) continue;
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
      final seen = <String>{}; final unique = <String>[];
      for (var part in parts) {
        final key = part.trim().toLowerCase();
        if (key.isNotEmpty && !seen.contains(key)) { seen.add(key); unique.add(part.trim()); }
      }
      result['address'] = unique.join(', ');
    }
    final mobileRegex = RegExp(r'\b([6-9]\d{9})\b');
    for (final line in lines) {
      final m = mobileRegex.firstMatch(line);
      if (m != null) { result['mobile'] = m.group(1); break; }
    }
    return result;
  }

  void _showScanErrorDialog(String title, String message) {
    showDialog(context: context, builder: (_) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      content: Text(message, style: const TextStyle(fontSize: 14, height: 1.5)),
      actions: [ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        onPressed: () => Navigator.pop(context),
        child: const Text('OK', style: TextStyle(color: Colors.white)),
      )],
    ));
  }

  Future<void> _applyOcrResult({
    required Map<String, String?> ocr,
    required bool fillOwner,
    int? directorIndex,
  }) async {
    final aadhaar = ocr['aadhaarNumber']; final name = ocr['name'];
    final address = ocr['address']; final mobile = ocr['mobile'];
    if (aadhaar == null && name == null && address == null && mobile == null) {
      _showScanErrorDialog('Scan Unsuccessful', 'Unable to read Aadhaar card clearly.\n\nPlease ensure:\n• Card is straight\n• Good lighting\n• Full card visible');
      return;
    }
    final existing = fillOwner
        ? { 'Name': ownerName.text, 'Mobile': ownerMobile.text, 'Aadhaar': ownerAadhaar.text, 'Address': ownerAddress.text }
        : { 'Name': directors[directorIndex!].name.text, 'Mobile': directors[directorIndex].mobile.text,
      'Aadhaar': directors[directorIndex].aadhaar.text, 'Address': directors[directorIndex].address.text };
    final scanned = { 'Name': name ?? '', 'Mobile': mobile ?? '', 'Aadhaar': aadhaar ?? '', 'Address': address ?? '' };
    setState(() {
      for (var key in scanned.keys) {
        final nv = scanned[key]?.trim() ?? ''; final ov = (existing[key] ?? '').trim();
        if (nv.isEmpty) continue;
        if (ov.isNotEmpty && ov.toLowerCase() != nv.toLowerCase()) continue;
        if (fillOwner) {
          if (key == 'Name') ownerName.text = nv.toUpperCase();
          if (key == 'Mobile') ownerMobile.text = nv;
          if (key == 'Aadhaar') ownerAadhaar.text = nv;
          if (key == 'Address') ownerAddress.text = nv.toUpperCase();
        } else if (directorIndex != null && directorIndex < directors.length) {
          final d = directors[directorIndex];
          if (key == 'Name') d.name.text = nv.toUpperCase();
          if (key == 'Mobile') d.mobile.text = nv;
          if (key == 'Aadhaar') d.aadhaar.text = nv;
          if (key == 'Address') d.address.text = nv.toUpperCase();
        }
      }
    });
    final conflictKeys = scanned.entries.where((e) {
      final nv = e.value.trim(); final ov = (existing[e.key] ?? '').trim();
      return nv.isNotEmpty && ov.isNotEmpty && nv.toLowerCase() != ov.toLowerCase();
    }).map((e) => e.key).toList();
    if (conflictKeys.isEmpty) return;
    final choice = { for (var k in conflictKeys) k: 'scanned' };
    final selected = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Select Data"),
        content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text("Some fields have different data — select which one to keep:", style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          ...conflictKeys.map((key) {
            final ov = existing[key] ?? ''; final nv = scanned[key] ?? '';
            return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 6),
              Row(children: [
                Expanded(child: GestureDetector(onTap: () => setS(() => choice[key] = 'old'),
                    child: Container(constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: choice[key] == 'old' ? Colors.blue.withOpacity(0.8) : Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('Old Data', style: TextStyle(fontSize: 10, color: choice[key] == 'old' ? Colors.white70 : Colors.grey)),
                          const SizedBox(height: 2),
                          Text(ov.isNotEmpty ? ov : 'No Data', style: TextStyle(color: choice[key] == 'old' ? Colors.white : Colors.black, fontSize: 13)),
                        ])))),
                const SizedBox(width: 8),
                Expanded(child: GestureDetector(onTap: () => setS(() => choice[key] = 'scanned'),
                    child: Container(constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(color: choice[key] == 'scanned' ? Colors.green.withOpacity(0.8) : Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('New Data', style: TextStyle(fontSize: 10, color: choice[key] == 'scanned' ? Colors.white70 : Colors.grey)),
                          const SizedBox(height: 2),
                          Text(nv.isNotEmpty ? nv : 'No Data', style: TextStyle(color: choice[key] == 'scanned' ? Colors.white : Colors.black, fontSize: 13)),
                        ])))),
              ]),
              const SizedBox(height: 12),
            ]);
          }).toList(),
        ])),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            final result = <String, String>{};
            for (var k in conflictKeys) result[k] = choice[k] == 'old' ? existing[k] ?? '' : scanned[k] ?? '';
            Navigator.pop(ctx, result);
          }, child: const Text("Apply")),
        ],
      )),
    );
    if (selected == null) return;
    setState(() {
      if (fillOwner) {
        if (selected['Name']?.isNotEmpty == true) ownerName.text = selected['Name']!.toUpperCase();
        if (selected['Mobile']?.isNotEmpty == true) ownerMobile.text = selected['Mobile']!;
        if (selected['Aadhaar']?.isNotEmpty == true) ownerAadhaar.text = selected['Aadhaar']!;
        if (selected['Address']?.isNotEmpty == true) ownerAddress.text = selected['Address']!.toUpperCase();
      } else if (directorIndex != null && directorIndex < directors.length) {
        final d = directors[directorIndex];
        if (selected['Name']?.isNotEmpty == true) d.name.text = selected['Name']!.toUpperCase();
        if (selected['Mobile']?.isNotEmpty == true) d.mobile.text = selected['Mobile']!;
        if (selected['Aadhaar']?.isNotEmpty == true) d.aadhaar.text = selected['Aadhaar']!;
        if (selected['Address']?.isNotEmpty == true) d.address.text = selected['Address']!.toUpperCase();
      }
    });
    _showToast('Fields updated successfully!');
  }

  // ── Image UI Helpers ──────────────────────────────────────────────────────
  void _showImageFullScreen({File? file, String? url}) {
    if (file == null && (url == null || url.isEmpty)) return;
    final imageWidget = file != null
        ? Image.file(file, fit: BoxFit.contain)
        : Image.network('https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$url',
        fit: BoxFit.contain,
        loadingBuilder: (_, child, p) => p == null ? child : const Center(child: CircularProgressIndicator(color: Colors.white)),
        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 60)));
    showDialog(context: context, barrierColor: Colors.black.withOpacity(0.92),
        builder: (_) => GestureDetector(onTap: () => Navigator.of(context).pop(),
            child: Scaffold(backgroundColor: Colors.transparent, body: Stack(children: [
              Center(child: InteractiveViewer(minScale: 0.5, maxScale: 5.0, child: imageWidget)),
              Positioned(top: 48, right: 16, child: GestureDetector(onTap: () => Navigator.of(context).pop(),
                  child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 24)))),
              Positioned(bottom: 32, left: 0, right: 0, child: Center(child: Text('Tap anywhere to close • Pinch to zoom', style: TextStyle(color: Colors.white60, fontSize: 12)))),
            ]))));
  }

  Widget _aadhaarImageCard({
    required String label, required File? file, required String? url,
    required VoidCallback onUpload, IconData placeholderIcon = Icons.add_a_photo_outlined,
  }) {
    final hasImage = file != null || (url != null && url.isNotEmpty);
    const baseUrl = 'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/';
    Widget imageContent;
    if (file != null) {
      imageContent = Stack(fit: StackFit.expand, children: [Image.file(file, fit: BoxFit.cover), Positioned(top: 8, right: 8, child: _zoomBadge())]);
    } else if (url != null && url.isNotEmpty) {
      imageContent = Stack(fit: StackFit.expand, children: [
        Image.network('$baseUrl$url', fit: BoxFit.cover,
            loadingBuilder: (_, child, p) => p == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40))),
        Positioned(top: 8, right: 8, child: _zoomBadge()),
      ]);
    } else {
      imageContent = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(placeholderIcon, color: Colors.grey, size: 32), const SizedBox(height: 6),
        const Text('Tap to upload', style: TextStyle(fontSize: 11, color: Colors.grey)),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
      const SizedBox(height: 6),
      GestureDetector(
          onTap: hasImage ? () => _showImageFullScreen(file: file, url: url) : onUpload,
          child: Container(width: double.infinity, height: 120,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey.shade200,
                  border: Border.all(color: hasImage ? Colors.green.shade400 : Colors.grey.shade400, width: 2)),
              child: ClipRRect(borderRadius: BorderRadius.circular(10), child: imageContent))),
      const SizedBox(height: 6),
      SizedBox(width: double.infinity, child: ElevatedButton.icon(
          onPressed: onUpload,
          icon: const Icon(Icons.upload_file, color: Colors.white, size: 16),
          label: Text(hasImage ? 'Change' : 'Upload', style: const TextStyle(color: Colors.white, fontSize: 12)),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black87, foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), padding: const EdgeInsets.symmetric(vertical: 10)))),
    ]);
  }

  Widget _zoomBadge() => Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: const Icon(Icons.zoom_in, color: Colors.white, size: 16));

  Future<void> _pickImage(String which) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    final croppedFile = await cropImage(picked.path);

    if (croppedFile == null) return;

    setState(() {
      switch (which) {
        case 'ownerFront': ownerAadhaarFront = croppedFile; break;
        case 'ownerBack': ownerAadhaarBack = croppedFile; break;
      }
    });
    // OCR scan
    showDialog(context: context, barrierDismissible: false,
        builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 14), Text('Scanning Aadhaar card...')])))));
    try {
      final rawText =
      await _recognizeTextNative(croppedFile.path);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (rawText != null && rawText.trim().isNotEmpty) {
        await _applyOcrResult(ocr: _parseAadhaarText(rawText), fillOwner: true);
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
    final policeCount = directors
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
        _validateDirectorStep();
        break;

      case 2:
        _validatePropertyStep();
        break;

      default:
        _moveNext();
    }
  }

  void _validateOwnerStep() {

    if (!_ownerFormKey.currentState!.validate()) {
      Fluttertoast.showToast(msg: "Please correct Owner form Fields");
      return;
    }

    if (ownerAadhaarFront == null &&
        (ownerAadharFrontUrl ?? '').isEmpty) {
      Fluttertoast.showToast(msg: "Upload Owner Aadhaar front image");
      return;
    }

    if (ownerAadhaarBack == null &&
        (ownerAadharBackUrl ?? '').isEmpty) {
      Fluttertoast.showToast(msg: "Upload Owner Aadhaar back image");
      return;
    }

    _moveNext();
  }

  void _validateDirectorStep() {

    if (directors.isEmpty) {
      Fluttertoast.showToast(msg: "Add at least one Director");
      return;
    }

    for (int i = 0; i < directors.length; i++) {

      final d = directors[i];
      final no = i + 1;

      final name = d.name.text.trim();
      final mobile = d.mobile.text.trim();
      final aadhaar = d.aadhaar.text.trim();
      final relationPerson = d.relationPerson.text.trim();
      final address = d.address.text.trim();

      // ---------- BASIC DETAILS ----------

      if (name.isEmpty) {
        Fluttertoast.showToast(msg: "Director $no full name is required");
        return;
      }

      if (!RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
        Fluttertoast.showToast(msg: "Enter valid 10-digit mobile for Director $no");
        return;
      }

      if (!RegExp(r'^\d{12}$').hasMatch(aadhaar) &&
          !RegExp(r'^\d{16}$').hasMatch(aadhaar)) {
        Fluttertoast.showToast(msg: "Enter valid Aadhaar/VID for Director $no");
        return;
      }

      if (relationPerson.isEmpty) {
        Fluttertoast.showToast(msg: "Relation person name required for Director $no");
        return;
      }

      if (address.isEmpty) {
        Fluttertoast.showToast(msg: "Permanent address required for Director $no");
        return;
      }

      // ---------- AADHAAR FILES ----------

      if (d.aadhaarFront == null &&
          (d.aadhaarFrontUrl ?? '').isEmpty) {
        Fluttertoast.showToast(msg: "Upload Aadhaar front for Director $no");
        return;
      }

      if (d.aadhaarBack == null &&
          (d.aadhaarBackUrl ?? '').isEmpty) {
        Fluttertoast.showToast(msg: "Upload Aadhaar back for Director $no");
        return;
      }

      // ---------- PHOTO ----------

      if (d.photo == null &&
          (d.photoUrl ?? '').isEmpty) {
        Fluttertoast.showToast(msg: "Upload photo for Director $no");
        return;
      }

      // ================= FIRST DIRECTOR (COMPANY VALIDATION) =================

      if (i == 0) {

        if (CompanyName.text.trim().isEmpty) {
          Fluttertoast.showToast(msg: "Company name is required");
          return;
        }

        final pan = d.panNo.text.trim().toUpperCase();

        if (pan.isEmpty) {
          Fluttertoast.showToast(msg: "PAN number is required");
          return;
        }


        if (d.panPhoto == null &&
            (d.panPhotoUrl ?? '').isEmpty) {
          Fluttertoast.showToast(msg: "Upload PAN card image");
          return;
        }
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
    int? directorIndex,
  }) async {
    String queryKey;
    String queryValue;

    if (aadhaar != null && aadhaar.trim().isNotEmpty) {
      queryKey = "aadhaar";
      queryValue = aadhaar.trim();
    } else if (mobile != null && mobile.trim().isNotEmpty) {
      queryKey = "mobile";
      queryValue = mobile.trim();
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
      AppLogger.api("📩 API Response: ${response.body}");

      if (response.statusCode != 200) {
        _showToast("Server error ${response.statusCode}");
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
          : directorIndex != null
          ? {
        'Name': directors[directorIndex].name.text,
        'Mobile': directors[directorIndex].mobile.text,
        'Aadhaar': directors[directorIndex].aadhaar.text,
        'Address': directors[directorIndex].address.text,
        'Relation': directors[directorIndex].relation,
        'RelationPerson': directors[directorIndex].relationPerson.text,
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
        } else if (directorIndex != null &&
            directorIndex >= 0 &&
            directorIndex < directors.length) {
          final d = directors[directorIndex];
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
            } else if (directorIndex != null &&
                directorIndex < directors.length) {
              final d = directors[directorIndex];
              if (selected['Name']?.isNotEmpty == true)
                d.name.text = selected['Name']!.toUpperCase();
              if (selected['Mobile']?.isNotEmpty == true)
                d.mobile.text = selected['Mobile']!;
              if (selected['Aadhaar']?.isNotEmpty == true)
                d.aadhaar.text = selected['Aadhaar']!;
              if (selected['Address']?.isNotEmpty == true)
                d.address.text = selected['Address']!.toUpperCase();
              if (selected['Relation']?.isNotEmpty == true)
                d.relation = selected['Relation']!;
              if (selected['RelationPerson']?.isNotEmpty == true)
                d.relationPerson.text =
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
      } else if (directorIndex != null &&
          directorIndex >= 0 &&
          directorIndex < directors.length) {
        final d = directors[directorIndex];
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
      } else if (directorIndex != null) {
        AppLogger.api("✅ Auto-fetch filled for DIRECTOR #${directorIndex + 1}");
      }
    } catch (e) {
      AppLogger.api("🔥 Fetch exception: $e");
      _showToast("Fetch failed");
    }
  }

  Future<void> _attachAdditionalTenants(http.MultipartRequest request) async {
    if (directors.length <= 1) return;

    for (int i = 1; i < directors.length; i++) {
      final t = directors[i];
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

  Future<void> _submitAll() async  {
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

      final firstDirector = directors[0];

      // 🔹 Prepare text fields (safe null handling)
      final Map<String, dynamic> textFields = {

        "owner_name": ownerName.text,
        "owner_relation": ownerRelation ?? '',
        "relation_person_name_owner": ownerRelationPerson.text,
        "parmanent_addresss_owner": ownerAddress.text,
        "owner_mobile_no": ownerMobile.text,
        "owner_addhar_no": ownerAadhaar.text,
        "tenant_name": firstDirector.name.text,
        "tenant_relation": firstDirector.relation,
        "relation_person_name_tenant": firstDirector.relationPerson.text,
        "permanent_address_tenant": firstDirector.address.text,
        "tenant_mobile_no": firstDirector.mobile.text,
        "tenant_addhar_no": firstDirector.aadhaar.text,
        "is_Police": firstDirector.includePoliceVerification.toString(),
        "Sqft": Sqft.text,
        "floor": selectedFloor ?? '',
        "company_name": CompanyName.text,
        "rented_address": Address.text,
        if (firstDirector.gstNo.text.trim().isNotEmpty)
          "gst_no": firstDirector.gstNo.text.trim(),

        if (firstDirector.panNo.text.trim().isNotEmpty)
          "pan_no": firstDirector.panNo.text.trim(),

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
        "gst_type": gstType,
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
        firstDirector.aadhaarFront,
        firstDirector.aadhaarFrontUrl,
        filename: "tenant_aadhar_front.jpg",
      );

      await attachFileOrUrl(
        "tenant_aadhar_back",
        firstDirector.aadhaarBack,
        firstDirector.aadhaarBackUrl,
        filename: "tenant_aadhar_back.jpg",
      );

      await attachFileOrUrl(
        "tenant_image",
        firstDirector.photo,
        firstDirector.photoUrl,
        filename: "tenant_image.jpg",
      );

      if (directors[0].gstPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "gst_photo",
          directors[0].gstPhoto!.path,
        ));
      } else if (directors[0].gstPhotoUrl != null &&
          directors[0].gstPhotoUrl!.isNotEmpty) {
        request.fields["gst_photo"] = directors[0].gstPhotoUrl!;
      } else {
        request.fields["gst_photo"] = "";
      }

      if (directors[0].panPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "pan_photo",
          directors[0].panPhoto!.path,
        ));
      } else if (directors[0].panPhotoUrl != null &&
          directors[0].panPhotoUrl!.isNotEmpty) {
        request.fields["pan_photo"] = directors[0].panPhotoUrl!;
      } else {
        request.fields["pan_photo"] = "";
      }


      print("📦 Files ready: ${request.files.map((f) => f.filename).toList()}");

      await _attachAdditionalTenants(request);

      // 🔹 Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 Server responded with status: ${response.statusCode}");
      print("📄 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded['success'] == true) {
          Navigator.of(context, rootNavigator: true).pop();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Submitted successfully!"),
              duration: Duration(seconds: 1),
            ),
          ).closed.then((_) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => HistoryTab()),
            );
          });

        }
        else {
          // Navigator.of(context, rootNavigator: true).pop();
          _showToast(decoded['message'] ?? "Submission failed");
          print("❌ Backend Error: ${decoded['message']}");
        }
      }
      else {
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
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement_update.php",
      );
      final request = http.MultipartRequest("POST", uri);

      final firstDirector = directors[0];

      final Map<String, dynamic> textFields = {
        "id": widget.agreementId,
        "owner_name": ownerName.text,
        "owner_relation": ownerRelation ?? '',
        "relation_person_name_owner": ownerRelationPerson.text,
        "parmanent_addresss_owner": ownerAddress.text,
        "owner_mobile_no": ownerMobile.text,
        "owner_addhar_no": ownerAadhaar.text, // confirm spelling with backend
        "tenant_name": firstDirector.name.text,
        "tenant_relation": firstDirector.relation,
        "relation_person_name_tenant": firstDirector.relationPerson.text,
        "permanent_address_tenant": firstDirector.address.text,
        "tenant_mobile_no": firstDirector.mobile.text,
        "tenant_addhar_no": firstDirector.aadhaar.text,
        "is_Police": firstDirector.includePoliceVerification.toString(),
        "company_name": CompanyName.text,

        if (firstDirector.gstNo.text.trim().isNotEmpty)
          "gst_no": firstDirector.gstNo.text.trim(),

        if (firstDirector.panNo.text.trim().isNotEmpty)
          "pan_no": firstDirector.panNo.text.trim(),

        "Sqft": Sqft.text,
        "floor": selectedFloor ?? '',
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
        "property_id": propertyID.text,
        "agreement_price": Agreement_price.text,
        "notary_price": Notary_price ?? '10 rupees',
        "gst_type": gstType,
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
        firstDirector.aadhaarFront,
        firstDirector.aadhaarFrontUrl,
        filename: "tenant_aadhar_front.jpg",
      );

      await attachFileOrUrl(
        "tenant_aadhar_back",
        firstDirector.aadhaarBack,
        firstDirector.aadhaarBackUrl,
        filename: "tenant_aadhar_back.jpg",
      );

      await attachFileOrUrl(
        "tenant_image",
        firstDirector.photo,
        firstDirector.photoUrl,
        filename: "tenant_image.jpg",
      );

      if (directors[0].gstPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "gst_photo",
          directors[0].gstPhoto!.path,
        ));
      } else if (directors[0].gstPhotoUrl != null &&
          directors[0].gstPhotoUrl!.isNotEmpty) {
        request.fields["gst_photo"] = directors[0].gstPhotoUrl!;
      } else {
        request.fields["gst_photo"] = "";
      }

      if (directors[0].panPhoto != null) {
        request.files.add(await http.MultipartFile.fromPath(
          "pan_photo",
          directors[0].panPhoto!.path,
        ));
      } else if (directors[0].panPhotoUrl != null &&
          directors[0].panPhotoUrl!.isNotEmpty) {
        request.fields["pan_photo"] = directors[0].panPhotoUrl!;
      } else {
        request.fields["pan_photo"] = "";
      }


      await attachFileOrUrl("agreement_pdf", agreementPdf, null,
          filename: "agreement.pdf", type: MediaType("application", "pdf"));

      print("📦 Files ready: ${request.files.map((f) => f.filename).toList()}");



      await _attachAdditionalTenants(request);

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
        Navigator.of(context, rootNavigator: true).pop();
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

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text('Commercial Agreement', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600)),
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

  Widget _propertyCard(Map<String, dynamic> data) {
    final String imageUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";

    return Card(
      color: Colors.white, // ✅ Always white background
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black.withOpacity(0.30),

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
                  child: const Text(
                    "No Image",
                    style: TextStyle(color: Colors.black54),
                  ),
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
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      data['Floor_'] ?? "--",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Name + Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name: ${data['field_warkar_name'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Location: ${data['locations'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Meter + Parking
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Meter: ${data['meter'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "Parking: ${data['parking'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Maintenance
                // 🧾 Maintenance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Maintenance: ${data['maintance'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),

                    Text(
                      "flat number: ${data['Flat_number'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                  ],
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
        Uri.parse("https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/display_api_base_on_flat_id.php"),
        body: {"P_id": propertyId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == "success") {
          final data = json['data'];

          setState(() {
            fetchedData = data;
            isPropertyFetched = true; // 🔒 lock fields
            Sqft.text = data['Sqft'] ?? '';
            Address.text = "Flat-${data['Flat_number'] ?? ''}  ${data['Apartment_Address'] ?? ''}";
            rentAmount.text = data['show_Price'] ?? "";
            meterInfo = data['meter'] == "Govt" ? "Commercial" : "Custom Unit (Enter Amount)";
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

            final apiFloor = data['Floor_']?.toString();

            if (commercialFloors.contains(apiFloor)) {
              selectedFloor = apiFloor;
            } else {
              selectedFloor = commercialFloors.first;
            }
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

  void _resetProperty() {
    setState(() {
      fetchedData = null;
      isPropertyFetched = false;

      Address.clear();
      rentAmount.clear();

      meterInfo = 'Commercial';
      parking = 'Car';
      maintenance = 'Including';

      customUnitAmount.clear();
      customMaintanceAmount.clear();
    });
  }

  Widget _buildBackground(bool isDark) {
    const kGoldDark1 = Color(0xFF1B1300);
    const kGoldDark2 = Color(0xFF0D0A00);

    // ✨ Rich golden tones for light theme
    const kGoldLight1 = Color(0xFFFFE7A0); // warm gold highlight
    const kGoldLight2 = Color(0xFFFFF2C2); // soft pale gold
    const kGoldLight3 = Color(0xFFFFFAE5); // cream gold base

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
          colors: [kGoldDark1, kGoldDark2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        )
            : const LinearGradient(
          colors: [kGoldLight1, kGoldLight2, kGoldLight3],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Top glow — soft golden beam
          Positioned(
            top: -80,
            left: -50,
            child: _glowCircle(
              280,
              isDark
                  ? Colors.amberAccent.withOpacity(0.20)
                  : Colors.amber.withOpacity(0.28),
            ),
          ),

          // Bottom glow — deeper orange-gold warmth
          Positioned(
            bottom: -100,
            right: -60,
            child: _glowCircle(
              320,
              isDark
                  ? Colors.deepOrangeAccent.withOpacity(0.18)
                  : Colors.orangeAccent.withOpacity(0.22),
            ),
          ),

          // Center soft glow — inner richness
          Positioned(
            top: 220,
            left: 100,
            child: _glowCircle(
              180,
              isDark
                  ? Colors.yellowAccent.withOpacity(0.12)
                  : Colors.amberAccent.withOpacity(0.15),
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(child: Text('Owner Details', style: TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black))),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.amber.shade800, Colors.amber.shade600]),
                borderRadius: BorderRadius.circular(12)),
            child: ElevatedButton.icon(
                onPressed: () async {
                  final a = ownerAadhaar.text.trim(); final m = ownerMobile.text.trim();
                  if (a.isEmpty && m.isEmpty) { _showToast('Please enter Aadhaar or Mobile number first'); return; }
                  showDialog(context: context, barrierDismissible: false,
                      builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
                          child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 14), Text('Fetching owner details...')])))));
                  await _fetchUserData(fillOwner: true, aadhaar: a.isNotEmpty ? a : null, mobile: a.isEmpty ? m : null);
                  if (mounted) { Navigator.of(context, rootNavigator: true).pop(); setState(() {}); }
                },
                icon: const Icon(Icons.search, color: Colors.white),
                label: const Text('Auto Fetch', style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent)),
          ),
        ]),
        const SizedBox(height: 16),
        // ── AADHAAR IMAGES upar ──
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade300)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Icon(Icons.badge_outlined, size: 18, color: Colors.black54), const SizedBox(width: 6),
              const Text('Owner Aadhaar Documents', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
              const Spacer(),
              if (ownerAadhaarFront != null || (ownerAadharFrontUrl?.isNotEmpty ?? false)) const Icon(Icons.check_circle, color: Colors.green, size: 18),
            ]),
            const SizedBox(height: 14),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _aadhaarImageCard(label: 'Aadhaar Front', file: ownerAadhaarFront, url: ownerAadharFrontUrl, onUpload: () => _pickImage('ownerFront'))),
              const SizedBox(width: 12),
              Expanded(child: _aadhaarImageCard(label: 'Aadhaar Back', file: ownerAadhaarBack, url: ownerAadharBackUrl, onUpload: () => _pickImage('ownerBack'))),
            ]),
            const SizedBox(height: 8),
            Text('Enter Aadhaar or Mobile number above and tap Auto Fetch to fill details automatically.',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
          ]),
        ),
        const SizedBox(height: 16),
        Form(
          key: _ownerFormKey,
          child: Column(children: [
            Row(children: [
              Expanded(child: _glowTextField(controller: ownerMobile, label: 'Mobile No', keyboard: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) return 'Enter valid 10-digit mobile'; return null; })),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: ownerAadhaar, label: 'Aadhaar/VID No', keyboard: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                  validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; final d = v.trim(); if (!RegExp(r'^\d{12}$').hasMatch(d) && !RegExp(r'^\d{16}$').hasMatch(d)) return 'Enter valid 12-digit Aadhaar or 16-digit VID'; return null; })),
            ]),
            const SizedBox(height: 14),
            _glowTextField(controller: ownerName, label: 'Owner Full Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: DropdownButtonFormField<String>(
                  value: ownerRelation,
                  items: const ['S/O', 'D/O', 'W/O', 'C/O'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(color: Colors.black)))).toList(),
                  onChanged: (v) => setState(() => ownerRelation = v ?? 'S/O'),
                  decoration: _fieldDecoration('Relation').copyWith(
                      labelStyle: const TextStyle(color: Colors.black),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1.5))),
                  iconEnabledColor: Colors.black, dropdownColor: Colors.white, style: const TextStyle(color: Colors.black))),
              const SizedBox(width: 12),
              Expanded(child: _glowTextField(controller: ownerRelationPerson, label: 'Person Name', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null)),
            ]),
            const SizedBox(height: 12),
            _glowTextField(controller: ownerAddress, label: 'Permanent Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 12),
          ]),
        ),
      ]),
    );
  }

  Widget _tenantStep() {
    return Column(
      children: [

        for (int index = 0; index < directors.length; index++)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _glassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HEADER
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          'Director ${index + 1} Details',
                          style: TextStyle(fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.amber.shade800, Colors.amber.shade600]),
                                borderRadius: BorderRadius.circular(12)),
                            child: ElevatedButton.icon(
                                onPressed: () async {
                                  final a = directors[index].aadhaar.text.trim();
                                  final m = directors[index].mobile.text.trim();
                                  if (a.isEmpty && m.isEmpty) { _showToast('Enter Aadhaar or Mobile number first'); return; }
                                  showDialog(context: context, barrierDismissible: false,
                                      builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
                                          child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 14), Text('Fetching director details...')])))));
                                  await _fetchUserData(fillOwner: false, aadhaar: a.isNotEmpty ? a : null, mobile: a.isEmpty ? m : null, directorIndex: index);
                                  if (mounted) { Navigator.of(context, rootNavigator: true).pop(); setState(() {}); }
                                },
                                icon: const Icon(Icons.search, color: Colors.white, size: 18),
                                label: const Text('Auto Fetch', style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent)),
                          ),
                          // 🔥 Show delete only when creating NEW agreement
                          if (index > 0 &&
                              (widget.agreementId == null || directors[index].id == null))
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() => directors.removeAt(index));
                                updateAgreementPrice(); // 🔥
                              },
                            )

                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// FORM
                  Column(
                    children: [

                      Row(
                        children: [
                          Expanded(
                            child: _glowTextField(
                              controller: directors[index].mobile,
                              label: 'Mobile No',
                              keyboard: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _glowTextField(
                              controller: directors[index].aadhaar,
                              label: 'Aadhaar / VID No',
                              keyboard: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _glowTextField(
                        controller: directors[index].name,
                        label: 'Director Full Name',
                      ),

                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child:  DropdownButtonFormField<String>(
                              value: directors[index].relation,
                              items: const ['S/O', 'D/O', 'W/O', 'C/O']
                                  .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e, style: const TextStyle(color: Colors.black)),
                              ))
                                  .toList(),
                              onChanged: (v) => setState(() {
                                directors[index].relation = v ?? 'S/O';
                              }),
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
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _glowTextField(
                              controller: directors[index].relationPerson,
                              label: 'Person Name',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      _glowTextField(
                        controller: directors[index].address,
                        label: 'Permanent Address',
                      ),

                      /// GST + PAN ONLY FOR FIRST DIRECTOR
                      if (index == 0) ...[
                        const SizedBox(height: 12),
                        _glowTextField(
                          controller: CompanyName,
                          label: 'Company Name',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: gstType,
                                items: gstTypes
                                    .map(
                                      (e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e, style: const TextStyle(color: Colors.black,fontWeight: FontWeight.w400,fontSize: 14)),
                                  ),
                                )
                                    .toList(),
                                onChanged: (v) {
                                  setState(() {
                                    gstType = v ?? 'GST Invoice';
                                  });
                                },
                                decoration: _fieldDecoration('DOC Type').copyWith(
                                  labelStyle: const TextStyle(color: Colors.black),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.black, width: 1.0),
                                  ),
                                ),
                                dropdownColor: Colors.white,
                                iconEnabledColor: Colors.black,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(child: _glowTextField(controller: directors[index].gstNo, label: 'Doc No')),

                          ],
                        ),

                        const SizedBox(height: 12),
                        _glowTextField(controller: directors[index].panNo, label: 'PAN Card No'),
                      ],


                      if (index == 0) ...[
                        const SizedBox(height: 16),
                        // GST IMAGE
                        Row(
                          children: [
                            _imageTile(
                              file: directors[index].gstPhoto,
                              url: directors[index].gstPhotoUrl,
                              hint: 'Doc Image',
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: () => _pickDirectorGST(index),
                              icon: const Icon(Icons.upload_file),
                              label: const Text('Doc Image'),
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

                        const SizedBox(height: 16),

                        // PAN IMAGE
                        Row(
                          children: [
                            _imageTile(
                              file: directors[index].panPhoto,
                              url: directors[index].panPhotoUrl,
                              hint: 'PAN Card',
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: ()  => _pickDirectorPAN(index),
                              icon: const Icon(Icons.upload_file),
                              label: const Text('PAN Card'),
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
                      ],


                      const SizedBox(height: 16),

                      // ── DIRECTOR DOCUMENTS CARD ──
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade300)),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Row(children: [
                            const Icon(Icons.badge_outlined, size: 18, color: Colors.black54), const SizedBox(width: 6),
                            Text('Director ${index + 1} Documents', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
                            const Spacer(),
                            if (directors[index].aadhaarFront != null || (directors[index].aadhaarFrontUrl?.isNotEmpty ?? false))
                              const Icon(Icons.check_circle, color: Colors.green, size: 18),
                          ]),
                          const SizedBox(height: 14),
                          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Expanded(child: _aadhaarImageCard(label: 'Aadhaar Front', file: directors[index].aadhaarFront, url: directors[index].aadhaarFrontUrl, onUpload: () => _pickDirectorAadhaar(index, true))),
                            const SizedBox(width: 8),
                            Expanded(child: _aadhaarImageCard(label: 'Aadhaar Back', file: directors[index].aadhaarBack, url: directors[index].aadhaarBackUrl, onUpload: () => _pickDirectorAadhaar(index, false))),
                            const SizedBox(width: 8),
                            Expanded(child: _aadhaarImageCard(label: 'Photo', file: directors[index].photo, url: directors[index].photoUrl, onUpload: () => _pickDirectorPhoto(index), placeholderIcon: Icons.person_outline)),
                          ]),
                          const SizedBox(height: 8),
                          Text('Upload Aadhaar images — OCR will auto-fill fields below.', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
                        ]),
                      ),
                      const SizedBox(height: 12),

                      CheckboxListTile(
                        value: directors[index].includePoliceVerification,
                        onChanged: (v) {
                          setState(() {
                            directors[index].includePoliceVerification = v ?? false;
                          });
                          updateAgreementPrice(); // 🔥 ADD THIS
                        },
                        title: const Text(
                          'Include Police Verification',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: const Text(
                          'Adds ₹50 to agreement price',
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),
                        activeColor: Colors.redAccent,
                      ),

                      const SizedBox(height: 12),                    ],
                  ),
                ],
              ),
            ),
          ),

        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            onTap: () {
              setState(() => directors.add(DirectorBlock()));
              Future.delayed(const Duration(milliseconds: 100), () {
                Scrollable.ensureVisible(context);
              });
              updateAgreementPrice(); // 🔥
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)], // gold → amber
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.35),
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
                    'Add Director',
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

  Widget _propertyStep() {
    return _glassContainer(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

        if (fetchedData != null) _propertyCard(fetchedData!), // Card appears only after fetch
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Property Details', style: TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700,color: Colors.black)),

          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                if (isPropertyFetched) {
                  _resetProperty(); // allow change
                } else {
                  fetchPropertyDetails(); // fetch property
                }
              },
              icon: Icon(
                isPropertyFetched ? Icons.refresh : Icons.search,
                color: Colors.white,
              ),
              label: Text(
                isPropertyFetched ? 'Change' : 'Auto Fetch',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colors.amber.shade700, // gradient visible
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF1D4ED8),
                    Color(0xFF2563EB),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ElevatedButton.icon(
                onPressed: () {

                  /// priority owner mobile → tenant mobile
                  String mobile = ownerMobile.text;

                  if (mobile.isEmpty && directors.isNotEmpty) {
                    mobile = directors[0].mobile.text;
                  }

                  if (mobile.isEmpty) {
                    _showToast("Enter mobile number first");
                    return;
                  }

                  _showBuildingSuggestions(mobile);

                },
                icon: const Icon(Icons.apartment, color: Colors.white),
                label: const Text(
                  'Suggestion',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
            _glowTextField(controller: propertyID,keyboard: TextInputType.number, label: 'Property ID', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
            const SizedBox(height: 6),
            Row(
                children: [
                  Expanded(
                      child: _glowTextField(controller: Sqft, label: 'Sqft', keyboard: TextInputType.number, validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,   readOnly: isPropertyFetched,
                      )),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: selectedFloor,
                      items: commercialFloors
                          .map(
                            (f) => DropdownMenuItem(
                          value: f,
                          child: Text(
                            f,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      )
                          .toList(),
                      onChanged: (v) => setState(() => selectedFloor = v),
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                      decoration: _fieldDecoration('Floor').copyWith(
                        labelStyle: const TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.black, width: 1.5),
                        ),
                      ),
                      dropdownColor: Colors.white,
                      iconEnabledColor: Colors.black,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ]
            ),
            _glowTextField(controller: Address, label: 'Rented Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null,   readOnly: isPropertyFetched,
            ),
            const SizedBox(height: 10),

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
            CheckboxListTile(
              value: securityInstallment,
              onChanged: (v) => setState(() => securityInstallment = v ?? false),
              title: const Text(
                'Pay security in installments?',
                style: TextStyle(color: Colors.black),
              ),
            ),

            if (securityInstallment)
              _glowTextField(
                controller: installmentAmount,
                label: 'Installment Amount (INR)',
                keyboard: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                showInWords: true,
                onChanged: (v) {
                  setState(() {
                    installmentAmountInWords =
                        convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                },
                validator: (v) {
                  if (securityInstallment && (v == null || v.trim().isEmpty))
                    return 'Required';
                  return null;
                },
              ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: meterInfo,
              items: const [
                'Commercial',
                'Custom Unit (Enter Amount)',
              ].map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ).toList(),
              onChanged: (v) => setState(() => meterInfo = v ?? 'Commercial'),
              decoration: _fieldDecoration('Meter Info').copyWith(
                labelStyle: const TextStyle(color: Colors.black),
              ),
              style: const TextStyle(color: Colors.black),
              dropdownColor: Colors.white,
              iconEnabledColor: Colors.black,
            ),

            if (meterInfo.startsWith('Custom'))
              _glowTextField(
                controller: customUnitAmount,
                label: 'Custom Unit Amount (INR)',
                keyboard: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                showInWords: true,
                onChanged: (v) {
                  setState(() {
                    customUnitAmountInWords =
                        convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                },
                validator: (v) {
                  if (meterInfo.startsWith('Custom') &&
                      (v == null || v.trim().isEmpty)) {
                    return 'Required';
                  }
                  return null;
                },
              ),

            const SizedBox(height: 12),

            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                shiftingDate == null
                    ? 'Select Shifting Date'
                    : 'Shifting: ${shiftingDate!.toLocal().toString().split(' ')[0]}',
                style: TextStyle(
                  color: shiftingDate == null ? Colors.black : Colors.yellow,
                  fontWeight:
                  shiftingDate == null ? FontWeight.w500 : FontWeight.w700,
                ),
              ),
              trailing: Icon(
                Icons.calendar_today,
                color: shiftingDate == null ? Colors.black87 : Colors.amber,
              ),
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
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: TextStyle(color: Colors.black)),
                ),
              )
                  .toList(),
              onChanged: (v) => setState(() => parking = v ?? 'Car'),
              decoration: _fieldDecoration('Parking'),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.white),
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
                  LengthLimitingTextInputFormatter(6),
                ],
                onChanged: (v) {
                  setState(() {
                    customMaintanceAmountInWords =
                        convertToWords(int.tryParse(v.replaceAll(',', '')) ?? 0);
                  });
                },
                validator: (v) {
                  if (maintenance.startsWith('Excluding') &&
                      (v == null || v.trim().isEmpty)) {
                    return 'Required';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 12),


            Row(
                children: [

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: Notary_price,
                      items: const [
                        '10 rupees',
                        '20 rupees',
                        '50 rupees',
                        '100 rupees'
                      ].map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(
                          e,
                          style: TextStyle(color: Colors.black), // ✅ dropdown text black
                        ),
                      ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          Notary_price = v ?? '10 rupees';
                          updateAgreementPrice();
                        });
                      },
                      decoration: _fieldDecoration('Notary price').copyWith(
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
                  Expanded(
                    child:
                    _agreementPriceBox(
                      amount: int.tryParse(Agreement_price.text) ?? 0,
                      amountInWords: AgreementAmountInWords,
                    ),

                  ),
                ]),
          ]
          ),
        ),
      ]),
    );
  }
  Future<void> _showBuildingSuggestions(String mobile) async {

    if (mobile.length < 10) {
      _showToast("Enter valid mobile number");
      return;
    }

    await fetchBuildingSuggestions(mobile);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111827) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),

          child: Column(
            children: [

              /// DRAG HANDLE
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                "Select Property",
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: "PoppinsMedium",
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                "Choose building & flat",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "PoppinsMedium",
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
              ),

              const SizedBox(height: 10),

              Divider(
                color: isDark ? Colors.white10 : Colors.grey.shade300,
              ),

              /// PROPERTY LIST
              Expanded(
                child: buildingSuggestions.isEmpty
                    ? Center(
                  child: Text(
                    "No Property Found On this Number",
                    style: TextStyle(
                      fontFamily: "PoppinsMedium",
                      color: isDark ? Colors.white60 : Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  itemCount: buildingSuggestions.length,
                  itemBuilder: (context, index) {

                    final building = buildingSuggestions[index];

                    return GestureDetector(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Future_Property_details(idd: building.id.toString()),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF1F2937)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isDark
                                ? Colors.white10
                                : Colors.grey.shade200,
                          ),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// BUILDING HEADER
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? const Color(0xFF7F1D1D)
                                    : Colors.red.shade50,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(16),
                                ),
                              ),
                              child: Row(
                                children: [

                                  const Icon(
                                    Icons.apartment,
                                    color: Color(0xFFEF4444),
                                  ),

                                  const SizedBox(width: 8),

                                  Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [



                                          Text(
                                            "Owner: ${building.ownerName}",
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontFamily: "PoppinsMedium",
                                              color: isDark ? Colors.white54 : Colors.black54,
                                            ),
                                          ),
                                          const SizedBox(height: 2),

                                          Text(
                                            building.propertyAddressForFieldworkar,
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "PoppinsMedium",
                                              color: isDark ? Colors.white : Colors.black87,
                                            ),
                                          ),


                                        ],
                                      )
                                  ),
                                  Text(
                                    "Building ID : "+building.id.toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "PoppinsMedium",
                                      color: isDark ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// FLATS
                            Column(
                              children: building.flats.map((flat) {

                                return InkWell(
                                  onTap: () {


                                    Address.text = flat.address;

                                    Navigator.pop(context);

                                  },

                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 12
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: isDark
                                              ? Colors.white10
                                              : Colors.grey.shade200,
                                        ),
                                      ),
                                    ),

                                    child: Row(
                                      children: [

                                        /// BHK BADGE
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFEF4444)
                                                .withOpacity(.15),
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            flat.bhk,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              fontFamily: "PoppinsMedium",
                                              color: Color(0xFFEF4444),
                                            ),
                                          ),
                                        ),

                                        const SizedBox(width: 10),

                                        /// DETAILS
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [

                                              Text(
                                                "₹${flat.price}",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "PoppinsMedium",
                                                  color: isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                                ),
                                              ),

                                              Text(
                                                "${flat.floor} • ${flat.fieldworkarAddress}",
                                                style: TextStyle(
                                                  fontSize: 11,
                                                  fontFamily: "PoppinsMedium",
                                                  color: isDark
                                                      ? Colors.white54
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Text(
                                          "Flat ID: ${flat.id}",
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontFamily: "PoppinsMedium",
                                            color: isDark
                                                ? Colors.white54
                                                : Colors.grey,
                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                );

                              }).toList(),
                            )

                          ],
                        ),
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
  }

  Widget _previewStep() {
    return _glassContainer(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Preview', style: TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700,color: Colors.black)),
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
                  foregroundColor: const Color(0xFFFFD700), // Pure gold
                ), child: const Text('Edit')),
              ],
            )

          ]),
          const SizedBox(height: 12),
          _sectionCard(
            title: '*Directors',
            children: List.generate(directors.length, (index) {
              final d = directors[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Director ${index + 1}',
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

                  if (index == 0) ...[
                    _kv('Company Name', CompanyName.text),
                    _kv('GST Type', gstType),
                    _kv('GST No.', d.gstNo.text),
                    _kv('PAN No.', d.panNo.text),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _imageTile(
                          file: d.gstPhoto,
                          url: d.gstPhotoUrl,
                          hint: 'GST',
                        ),
                        const SizedBox(width: 8),
                        _imageTile(
                          file: d.panPhoto,
                          url: d.panPhotoUrl,
                          hint: 'PAN',
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 12),
                  const Divider(),
                ],
              );
            }),
          ),



          const SizedBox(height: 8),

          _sectionCard(
            title: '*Directors Documents',
            children: List.generate(directors.length, (index) {
              final d = directors[index];

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Director ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),

                  /// Aadhaar
                  const Text('Director Aadhaar',style: TextStyle(color: Colors.black),),
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
                  const Text('Director Photo',style: TextStyle(color: Colors.black),),
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
            _kv('Sqft', Sqft.text),
            _kv('Floor', selectedFloor ?? ''),
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
            Row(children: [const Spacer(),
              TextButton(
                onPressed: () => _jumpToStep(2),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFFFFD700), // Pure gold
                ),
                child: const Text('Edit'),
              )
            ])
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
        ]
        )
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
      child: Row(children: [SizedBox(width: 140, child: Text('$k:', style: const TextStyle(fontWeight: FontWeight.w600,color: Colors.black))), Expanded(child: Text(v,style: TextStyle(color: Colors.black),))]),
    );
  }

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