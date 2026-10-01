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
import '../Dashboard_screen.dart';


class TenantBlock {
  final formKey = GlobalKey<FormState>();
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

  const VerificationWizardPage({Key? key, this.agreementId, required this.rewardStatus}) : super(key: key);

  @override
  State<VerificationWizardPage> createState() => _VerificationWizardPageState();
}

class _VerificationWizardPageState extends State<VerificationWizardPage> with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  bool isAgreementHide = false;

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

  final TenantBlock tenant = TenantBlock();

  static const kAppGradient = LinearGradient(
    colors: [Color(0xFF4CA1FF), Color(0xFF00D4FF)],
  );

  final ImagePicker _picker = ImagePicker();
  late final AnimationController _fabController;

  String _number = '';
  String _name = '';

  String? ownerAadharFrontUrl;
  String? ownerAadharBackUrl;

  // ── OCR ───────────────────────────────────────────────────────────────────
  static const _ocrChannel = MethodChannel('com.verify.app/ocr');

  Future<String?> _recognizeTextNative(String imagePath) async {
    try {
      return await _ocrChannel.invokeMethod('recognizeText', {'imagePath': imagePath});
    } on PlatformException catch (e) {
      print('OCR error: ${e.message}');
      rethrow;
    }
  }

  String _titleCase(String s) => s.toLowerCase().split(' ')
      .map((w) => w.isEmpty ? w : '${w[0].toUpperCase()}${w.substring(1)}').join(' ');

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
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
        content: Text(message, style: const TextStyle(fontSize: 14, height: 1.5)),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade700, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
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
  }) async {
    final aadhaar = ocr['aadhaarNumber'];
    final name = ocr['name'];
    final address = ocr['address'];
    final mobile = ocr['mobile'];

    if (aadhaar == null && name == null && address == null && mobile == null) {
      _showScanErrorDialog('Scan Unsuccessful',
          'Unable to read Aadhaar card clearly.\n\nPlease ensure:\n• Card is straight\n• Good lighting\n• Full card visible');
      return;
    }

    final existing = fillOwner
        ? {'Name': ownerName.text, 'Mobile': ownerMobile.text, 'Aadhaar': ownerAadhaar.text, 'Address': ownerAddress.text}
        : {'Name': tenant.name.text, 'Mobile': tenant.mobile.text, 'Aadhaar': tenant.aadhaar.text, 'Address': tenant.address.text};
    final scanned = {'Name': name ?? '', 'Mobile': mobile ?? '', 'Aadhaar': aadhaar ?? '', 'Address': address ?? ''};

    setState(() {
      for (var key in scanned.keys) {
        final nv = scanned[key]?.trim() ?? '';
        final ov = (existing[key] ?? '').trim();
        if (nv.isEmpty) continue;
        if (ov.isNotEmpty && ov.toLowerCase() != nv.toLowerCase()) continue;
        if (fillOwner) {
          if (key == 'Name') ownerName.text = nv.toUpperCase();
          if (key == 'Mobile') ownerMobile.text = nv;
          if (key == 'Aadhaar') ownerAadhaar.text = nv;
          if (key == 'Address') ownerAddress.text = nv.toUpperCase();
        } else {
          if (key == 'Name') tenant.name.text = nv.toUpperCase();
          if (key == 'Mobile') tenant.mobile.text = nv;
          if (key == 'Aadhaar') tenant.aadhaar.text = nv;
          if (key == 'Address') tenant.address.text = nv.toUpperCase();
        }
      }
    });

    final conflictKeys = scanned.entries.where((e) {
      final nv = e.value.trim();
      final ov = (existing[e.key] ?? '').trim();
      return nv.isNotEmpty && ov.isNotEmpty && nv.toLowerCase() != ov.toLowerCase();
    }).map((e) => e.key).toList();

    if (conflictKeys.isEmpty) return;

    final choice = {for (var k in conflictKeys) k: 'scanned'};
    final selected = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setS) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Select Data"),
          content: SingleChildScrollView(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Some fields have different data — select which one to keep:", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              ...conflictKeys.map((key) {
                final ov = existing[key] ?? '';
                final nv = scanned[key] ?? '';
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(child: GestureDetector(
                        onTap: () => setS(() => choice[key] = 'old'),
                        child: Container(
                            constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: choice[key] == 'old' ? Colors.blue.withOpacity(0.8) : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('Old Data', style: TextStyle(fontSize: 10, color: choice[key] == 'old' ? Colors.white70 : Colors.grey)),
                              const SizedBox(height: 2),
                              Text(ov.isNotEmpty ? ov : 'No Data', style: TextStyle(color: choice[key] == 'old' ? Colors.white : Colors.black, fontSize: 13)),
                            ])))),
                    const SizedBox(width: 8),
                    Expanded(child: GestureDetector(
                        onTap: () => setS(() => choice[key] = 'scanned'),
                        child: Container(
                            constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: choice[key] == 'scanned' ? Colors.green.withOpacity(0.8) : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text('New Data', style: TextStyle(fontSize: 10, color: choice[key] == 'scanned' ? Colors.white70 : Colors.grey)),
                              const SizedBox(height: 2),
                              Text(nv.isNotEmpty ? nv : 'No Data', style: TextStyle(color: choice[key] == 'scanned' ? Colors.white : Colors.black, fontSize: 13)),
                            ])))),
                  ]),
                  const SizedBox(height: 12),
                ]);
              }).toList(),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, null), child: const Text("Cancel")),
            ElevatedButton(onPressed: () {
              final result = <String, String>{};
              for (var k in conflictKeys) result[k] = choice[k] == 'old' ? existing[k] ?? '' : scanned[k] ?? '';
              Navigator.pop(ctx, result);
            }, child: const Text("Apply")),
          ],
        ),
      ),
    );

    if (selected == null) return;
    setState(() {
      if (fillOwner) {
        if (selected['Name']?.isNotEmpty == true) ownerName.text = selected['Name']!.toUpperCase();
        if (selected['Mobile']?.isNotEmpty == true) ownerMobile.text = selected['Mobile']!;
        if (selected['Aadhaar']?.isNotEmpty == true) ownerAadhaar.text = selected['Aadhaar']!;
        if (selected['Address']?.isNotEmpty == true) ownerAddress.text = selected['Address']!.toUpperCase();
      } else {
        if (selected['Name']?.isNotEmpty == true) tenant.name.text = selected['Name']!.toUpperCase();
        if (selected['Mobile']?.isNotEmpty == true) tenant.mobile.text = selected['Mobile']!;
        if (selected['Aadhaar']?.isNotEmpty == true) tenant.aadhaar.text = selected['Aadhaar']!;
        if (selected['Address']?.isNotEmpty == true) tenant.address.text = selected['Address']!.toUpperCase();
      }
    });
    _showToast('Fields updated successfully!');
  }

  // ── Image UI Helpers ──────────────────────────────────────────────────────
  void _showImageFullScreen({File? file, String? url}) {
    if (file == null && (url == null || url.isEmpty)) return;
    final imageWidget = file != null
        ? Image.file(file, fit: BoxFit.contain)
        : Image.network(
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$url',
        fit: BoxFit.contain,
        loadingBuilder: (_, child, p) => p == null ? child : const Center(child: CircularProgressIndicator(color: Colors.white)),
        errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.white, size: 60)));
    showDialog(
      context: context, barrierColor: Colors.black.withOpacity(0.92),
      builder: (_) => GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(children: [
            Center(child: InteractiveViewer(minScale: 0.5, maxScale: 5.0, child: imageWidget)),
            Positioned(top: 48, right: 16,
                child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 24)))),
            Positioned(bottom: 32, left: 0, right: 0,
                child: Center(child: Text('Tap anywhere to close • Pinch to zoom', style: TextStyle(color: Colors.white60, fontSize: 12)))),
          ]),
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
  })
  {
    final hasImage = file != null || (url != null && url.isNotEmpty);
    const baseUrl = 'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/';
    Widget imageContent;
    if (file != null) {
      imageContent = Stack(fit: StackFit.expand, children: [
        Image.file(file, fit: BoxFit.cover),
        Positioned(top: 8, right: 8, child: _zoomBadge()),
      ]);
    } else if (url != null && url.isNotEmpty) {
      imageContent = Stack(fit: StackFit.expand, children: [
        Image.network('$baseUrl$url', fit: BoxFit.cover,
            loadingBuilder: (_, child, p) => p == null ? child : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            errorBuilder: (_, __, ___) => const Center(child: Icon(Icons.broken_image, color: Colors.grey, size: 40))),
        Positioned(top: 8, right: 8, child: _zoomBadge()),
      ]);
    } else {
      imageContent = Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(placeholderIcon, color: Colors.grey, size: 32),
        const SizedBox(height: 6),
        const Text('Tap to upload', style: TextStyle(fontSize: 11, color: Colors.grey)),
      ]);
    }
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54)),
      const SizedBox(height: 6),
      GestureDetector(
        onTap: hasImage ? () => _showImageFullScreen(file: file, url: url) : onUpload,
        child: Container(
            width: double.infinity, height: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.grey.shade200,
                border: Border.all(color: hasImage ? Colors.green.shade400 : Colors.grey.shade400, width: 2)),
            child: ClipRRect(borderRadius: BorderRadius.circular(10), child: imageContent)),
      ),
      const SizedBox(height: 6),
      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
            onPressed: onUpload,
            icon: const Icon(Icons.upload_file, color: Colors.white, size: 16),
            label: Text(hasImage ? 'Change' : 'Upload', style: const TextStyle(color: Colors.white, fontSize: 12)),
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 10))),
      ),
    ]);
  }

  Widget _zoomBadge() => Container(
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
      child: const Icon(Icons.zoom_in, color: Colors.white, size: 16));

  Future<void> _pickImage(String which) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (picked == null) return;
    final croppedFile = await cropImage(
      context,
      picked.path,
    );
    if (croppedFile == null) return;
    setState(() {
      switch (which) {
        case 'ownerFront': ownerAadhaarFront = croppedFile; break;
        case 'ownerBack': ownerAadhaarBack = croppedFile; break;
      }
    });
    showDialog(context: context, barrierDismissible: false,
        builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(), SizedBox(height: 14), Text('Scanning Aadhaar card...'),
            ])))));
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

  Future<void> _pickTenantDoc(bool isFront) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (picked == null) return;
    final croppedFile = await cropImage(context, picked.path);
    if (croppedFile == null) return;

    setState(() {
      if (isFront) tenant.aadhaarFront = croppedFile;
      else tenant.aadhaarBack = croppedFile;
    });

    showDialog(context: context, barrierDismissible: false,
        builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              CircularProgressIndicator(), SizedBox(height: 14), Text('Scanning Aadhaar card...'),
            ])))));
    try {
      final rawText = await _recognizeTextNative(croppedFile.path);
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      if (rawText != null && rawText.trim().isNotEmpty) {
        await _applyOcrResult(ocr: _parseAadhaarText(rawText), fillOwner: false);
        if (mounted) setState(() {});
      }
    } catch (e) {
      if (mounted) Navigator.of(context, rootNavigator: true).pop();
      _showScanErrorDialog('Scan Failed', 'Could not process image.\n\nError: $e');
    }
  }

  Future<void> _pickTenantPhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      maxHeight: 1600,
      imageQuality: 80,
    );
    if (picked == null) return;
    final croppedFile = await cropImage(context, picked.path);
    if (croppedFile == null) return;
    setState(() => tenant.photo = croppedFile);
  }

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    if (widget.agreementId != null) _fetchAgreementDetails(widget.agreementId!);
  }

  Future<void> _fetchAgreementDetails(String id) async {
    final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=$id");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded["status"] == "success" && decoded["data"] != null && decoded["data"].isNotEmpty) {
        final data = decoded["data"][0];
        AppLogger.api("✅ Parsed Agreement Data: $data");
        setState(() {
          ownerName.text = data["owner_name"] ?? "";
          ownerRelation = data["owner_relation"] ?? "S/O";
          ownerRelationPerson.text = data["relation_person_name_owner"] ?? "";
          ownerAddress.text = data["parmanent_addresss_owner"] ?? "";
          ownerMobile.text = data["owner_mobile_no"] ?? "";
          ownerAadhaar.text = data["owner_addhar_no"] ?? "";
          propertyAddress.text = data["rented_address"] ?? "";
          final d = tenant;
          d.name.text = data["tenant_name"] ?? "";
          d.relation = data["tenant_relation"] ?? "S/O";
          d.relationPerson.text = data["relation_person_name_tenant"] ?? "";
          d.address.text = data["permanent_address_tenant"] ?? "";
          d.mobile.text = data["tenant_mobile_no"] ?? "";
          d.aadhaar.text = data["tenant_addhar_no"] ?? "";
          d.aadhaarFrontUrl = data["tenant_aadhar_front"] ?? "";
          d.aadhaarBackUrl = data["tenant_aadhar_back"] ?? "";
          d.photoUrl = data["tenant_image"] ?? "";
          ownerAadharFrontUrl = data["owner_aadhar_front"] ?? "";
          ownerAadharBackUrl = data["owner_aadhar_back"] ?? "";
          isAgreementHide = data["is_agreement_hide"] == "1";
        });
      } else {
        AppLogger.api("⚠️ No agreement data found");
      }
    } else {
      AppLogger.api("❌ Failed to load agreement details: ${response.body}");
    }
  }

  @override
  void dispose() {
    _fabController.dispose(); _pageController.dispose();
    ownerName.dispose(); ownerRelationPerson.dispose(); ownerAddress.dispose();
    ownerMobile.dispose(); ownerAadhaar.dispose(); propertyAddress.dispose();
    tenant.name.dispose();
    tenant.mobile.dispose();
    tenant.aadhaar.dispose();
    tenant.address.dispose();
    tenant.relationPerson.dispose();
    super.dispose();
  }

  void _goNext() {
    switch (_currentStep) {
      case 0: _validateOwnerStep(); break;
      case 1: _validateTenantStep(); break;
      default: break;
    }
  }

  void _validateOwnerStep() {
    final isValid = _ownerFormKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (ownerAadhaarFront == null && (ownerAadharFrontUrl == null || ownerAadharFrontUrl!.isEmpty)) {
      _showToast("Upload Owner Aadhaar Front"); return;
    }
    if (ownerAadhaarBack == null && (ownerAadharBackUrl == null || ownerAadharBackUrl!.isEmpty)) {
      _showToast("Upload Owner Aadhaar Back"); return;
    }
    _moveNext();
  }

  void _validateTenantStep() {
    final isValid = tenant.formKey.currentState?.validate() ?? false;
    if (!isValid) { _showToast("Fix Tenant Fields"); return; }
    if (tenant.aadhaarFront == null && (tenant.aadhaarFrontUrl == null || tenant.aadhaarFrontUrl!.isEmpty)) {
      _showToast("Upload Tenant Aadhaar Front"); return;
    }
    if (tenant.aadhaarBack == null && (tenant.aadhaarBackUrl == null || tenant.aadhaarBackUrl!.isEmpty)) {
      _showToast("Upload Tenant Aadhaar Back"); return;
    }
    if (tenant.photo == null && (tenant.photoUrl == null || tenant.photoUrl!.isEmpty)) {
      _showToast("Upload Tenant Photo"); return;
    }
    _moveNext();
  }

  void _moveNext() {
    if (_currentStep < 3) {
      setState(() => _currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 450), curve: Curves.easeInOut);
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
      setState(() { _currentStep = step; _pageController.jumpToPage(step); });
    }
  }

  Future<void> _loaduserdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _name = prefs.getString('name') ?? '';
    _number = prefs.getString('number') ?? '';
  }

  Future<void> _fetchUserData({required bool fillOwner, required String? aadhaar, required String? mobile}) async {
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
      if (response.statusCode != 200) { _showToast("${response.statusCode} Error"); return; }
      final decoded = jsonDecode(response.body);
      if (decoded['success'] != true || decoded['data'] == null) { _showToast("No data found"); return; }
      final data = decoded['data'];

      final fetched = {
        'Name': (data['name'] ?? '') as String,
        'Mobile': (data['mobile_number'] ?? '') as String,
        'Aadhaar': (data['addhar_number'] ?? '') as String,
        'Address': (data['addresss'] ?? '') as String,
        'Relation': (data['relation'] ?? 'S/O') as String,
        'RelationPerson': (data['relation_person_name'] ?? '') as String,
      };
      final existing = fillOwner
          ? {'Name': ownerName.text, 'Mobile': ownerMobile.text, 'Aadhaar': ownerAadhaar.text, 'Address': ownerAddress.text, 'Relation': ownerRelation, 'RelationPerson': ownerRelationPerson.text}
          : {'Name': tenant.name.text, 'Mobile': tenant.mobile.text, 'Aadhaar': tenant.aadhaar.text, 'Address': tenant.address.text, 'Relation': tenant.relation, 'RelationPerson': tenant.relationPerson.text};

      final conflictKeys = fetched.entries.where((e) {
        if (e.key == 'Mobile') return false;
        final nv = e.value.trim();
        final ov = (existing[e.key] ?? '').trim();
        return nv.isNotEmpty && ov.isNotEmpty && nv.toLowerCase() != ov.toLowerCase();
      }).map((e) => e.key).toList();

      setState(() {
        fetched.forEach((key, newVal) {
          if (newVal.isEmpty) return;
          final oldVal = (existing[key] ?? '').trim();
          if (key != 'Mobile' && oldVal.isNotEmpty && oldVal.toLowerCase() != newVal.toLowerCase()) return;
          if (fillOwner) {
            if (key == 'Name') ownerName.text = newVal.toUpperCase();
            if (key == 'Mobile') ownerMobile.text = newVal;
            if (key == 'Aadhaar') ownerAadhaar.text = newVal;
            if (key == 'Address') ownerAddress.text = newVal.toUpperCase();
            if (key == 'Relation') ownerRelation = newVal;
            if (key == 'RelationPerson') ownerRelationPerson.text = newVal.toUpperCase();
          } else {
            if (key == 'Name') tenant.name.text = newVal.toUpperCase();
            if (key == 'Mobile') tenant.mobile.text = newVal;
            if (key == 'Aadhaar') tenant.aadhaar.text = newVal;
            if (key == 'Address') tenant.address.text = newVal.toUpperCase();
            if (key == 'Relation') tenant.relation = newVal;
            if (key == 'RelationPerson') tenant.relationPerson.text = newVal.toUpperCase();
          }
        });
        if (fillOwner) {
          ownerAadharFrontUrl = data['addhar_front'] ?? '';
          ownerAadharBackUrl = data['addhar_back'] ?? '';
        } else {
          tenant.aadhaarFrontUrl = data['addhar_front'];
          tenant.aadhaarBackUrl = data['addhar_back'];
          tenant.photoUrl = data['selfie'];
        }
      });

      if (conflictKeys.isNotEmpty) {
        final choice = {for (var k in conflictKeys) k: 'fetched'};
        final selected = await showDialog<Map<String, String>>(
          context: context,
          builder: (ctx) => StatefulBuilder(builder: (ctx, setS) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text("Select Data"),
            content: SingleChildScrollView(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Some fields have different data — select which one to keep:", style: TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 12),
              ...conflictKeys.map((key) {
                final ov = existing[key] ?? '';
                final nv = fetched[key] ?? '';
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  Row(children: [
                    Expanded(child: GestureDetector(onTap: () => setS(() => choice[key] = 'old'), child: Container(
                      constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: choice[key] == 'old' ? Colors.blue.withOpacity(0.8) : Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Old Data', style: TextStyle(fontSize: 10, color: choice[key] == 'old' ? Colors.white70 : Colors.grey)),
                        const SizedBox(height: 2), Text(ov.isNotEmpty ? ov : 'No Data', style: TextStyle(color: choice[key] == 'old' ? Colors.white : Colors.black, fontSize: 13)),
                      ])))),
                    const SizedBox(width: 8),
                    Expanded(child: GestureDetector(onTap: () => setS(() => choice[key] = 'fetched'), child: Container(
                      constraints: const BoxConstraints(minHeight: 60), padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: choice[key] == 'fetched' ? Colors.green.withOpacity(0.8) : Colors.grey.shade200, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('New Data', style: TextStyle(fontSize: 10, color: choice[key] == 'fetched' ? Colors.white70 : Colors.grey)),
                        const SizedBox(height: 2), Text(nv.isNotEmpty ? nv : 'No Data', style: TextStyle(color: choice[key] == 'fetched' ? Colors.white : Colors.black, fontSize: 13)),
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
                for (var k in conflictKeys) result[k] = choice[k] == 'old' ? existing[k] ?? '' : fetched[k] ?? '';
                Navigator.pop(ctx, result);
              }, child: const Text("Apply")),
            ],
          )),
        );
        if (selected != null && mounted) {
          setState(() {
            if (fillOwner) {
              if (selected['Name']?.isNotEmpty == true) ownerName.text = selected['Name']!.toUpperCase();
              if (selected['Mobile']?.isNotEmpty == true) ownerMobile.text = selected['Mobile']!;
              if (selected['Aadhaar']?.isNotEmpty == true) ownerAadhaar.text = selected['Aadhaar']!;
              if (selected['Address']?.isNotEmpty == true) ownerAddress.text = selected['Address']!.toUpperCase();
              if (selected['Relation']?.isNotEmpty == true) ownerRelation = selected['Relation']!;
              if (selected['RelationPerson']?.isNotEmpty == true) ownerRelationPerson.text = selected['RelationPerson']!.toUpperCase();
            } else {
              if (selected['Name']?.isNotEmpty == true) tenant.name.text = selected['Name']!.toUpperCase();
              if (selected['Mobile']?.isNotEmpty == true) tenant.mobile.text = selected['Mobile']!;
              if (selected['Aadhaar']?.isNotEmpty == true) tenant.aadhaar.text = selected['Aadhaar']!;
              if (selected['Address']?.isNotEmpty == true) tenant.address.text = selected['Address']!.toUpperCase();
              if (selected['Relation']?.isNotEmpty == true) tenant.relation = selected['Relation']!;
              if (selected['RelationPerson']?.isNotEmpty == true) tenant.relationPerson.text = selected['RelationPerson']!.toUpperCase();
            }
          });
          _showToast('Fields updated successfully!');
        }
      }
    } catch (e) {
      print("🔥 Exception: $e");
      _showToast("Error: $e");
    }
  }

  Future<File?> downloadAndConvertToFile(String? relativePath) async {
    if (relativePath == null || relativePath.isEmpty) return null;
    try {
      final fullUrl = "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$relativePath";
      final response = await http.get(Uri.parse(fullUrl));
      if (response.statusCode == 200) {
        final tempDir = await Directory.systemTemp.createTemp();
        final file = File("${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg");
        await file.writeAsBytes(response.bodyBytes);
        return file;
      }
    } catch (e) { print("Download error: $e"); }
    return null;
  }

  Future<void> _submitAll() async {
    final int totalPrice = widget.rewardStatus.isDiscounted ? 40 : 50;
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    await _loaduserdata();
    try {
      _showToast('Uploading...');
      final uri = Uri.parse("https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement.php");
      final request = http.MultipartRequest("POST", uri);
      final Map<String, dynamic> textFields = {
        "owner_name": ownerName.text, "owner_relation": ownerRelation,
        "relation_person_name_owner": ownerRelationPerson.text, "parmanent_addresss_owner": ownerAddress.text,
        "owner_mobile_no": ownerMobile.text, "owner_addhar_no": ownerAadhaar.text,
        "tenant_name": tenant.name.text, "tenant_relation": tenant.relation,
        "relation_person_name_tenant": tenant.relationPerson.text, "permanent_address_tenant": tenant.address.text,
        "tenant_mobile_no": tenant.mobile.text, "tenant_addhar_no": tenant.aadhaar.text,
        "rented_address": propertyAddress.text, "Fieldwarkarname": _name,
        "Fieldwarkarnumber": _number, "is_agreement_hide": isAgreementHide ? "1" : "0",
        "agreement_price": totalPrice.toString(), "agreement_type": "Police Verification",
      };
      request.fields.addAll(textFields.map((k, v) => MapEntry(k, (v ?? '').toString())));

      Future<void> attachFileOrUrl(String key, File? file, String? existingUrl, {String? filename, MediaType? type}) async {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(key, file.path, contentType: type, filename: filename ?? file.path.split("/").last));
        } else if (existingUrl != null && existingUrl.isNotEmpty) {
          final relativePath = existingUrl.replaceAll(RegExp(r"^https?:\/\/verifyrealestateandservices\.in\/(Second%20PHP%20FILE\/main_application\/agreement\/)?"), "");
          request.fields[key] = relativePath;
        }
      }

      await attachFileOrUrl("owner_aadhar_front", ownerAadhaarFront, ownerAadharFrontUrl, filename: "owner_aadhar_front.jpg");
      await attachFileOrUrl("owner_aadhar_back", ownerAadhaarBack, ownerAadharBackUrl, filename: "owner_aadhar_back.jpg");
      await attachFileOrUrl("tenant_aadhar_front", tenant.aadhaarFront, tenant.aadhaarFrontUrl);
      await attachFileOrUrl("tenant_aadhar_back", tenant.aadhaarBack, tenant.aadhaarBackUrl);
      await attachFileOrUrl("tenant_image", tenant.photo, tenant.photoUrl);
      await attachFileOrUrl("agreement_pdf", agreementPdf, null, filename: "agreement.pdf", type: MediaType("application", "pdf"));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 && response.body.toLowerCase().contains("success")) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Submitted successfully!"), duration: Duration(seconds: 1)))
            .closed.then((_) { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HistoryTab())); });
      } else { _showToast('Submit failed (${response.statusCode})'); }
    } catch (e) { _showToast('Submit error: $e'); }
  }

  Future<void> _updateAll() async {
    showDialog(context: context, barrierDismissible: false, builder: (_) => const Center(child: CircularProgressIndicator()));
    final int totalPrice = widget.rewardStatus.isDiscounted ? 40 : 50;
    await _loaduserdata();
    try {
      _showToast('Updating...');
      final uri = Uri.parse("https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/agreement_update.php");
      final request = http.MultipartRequest("POST", uri);
      final Map<String, dynamic> textFields = {
        "id": widget.agreementId, "owner_name": ownerName.text, "owner_relation": ownerRelation,
        "relation_person_name_owner": ownerRelationPerson.text, "parmanent_addresss_owner": ownerAddress.text,
        "owner_mobile_no": ownerMobile.text, "owner_addhar_no": ownerAadhaar.text,
        "tenant_name": tenant.name.text, "tenant_relation": tenant.relation,
        "relation_person_name_tenant": tenant.relationPerson.text, "permanent_address_tenant": tenant.address.text,
        "tenant_mobile_no": tenant.mobile.text, "tenant_addhar_no": tenant.aadhaar.text,
        "current_dates": DateTime.now().toIso8601String(), "rented_address": propertyAddress.text,
        "agreement_price": totalPrice.toString(), "is_agreement_hide": isAgreementHide ? "1" : "0",
      };
      request.fields.addAll(textFields.map((k, v) => MapEntry(k, (v ?? '').toString())));

      Future<void> attachFileOrUrl(String key, File? file, String? existingUrl, {String? filename, MediaType? type}) async {
        if (file != null) {
          request.files.add(await http.MultipartFile.fromPath(key, file.path, contentType: type, filename: filename ?? file.path.split("/").last));
        } else if (existingUrl != null && existingUrl.isNotEmpty) {
          final relativePath = existingUrl.replaceAll(RegExp(r"^https?:\/\/verifyrealestateandservices\.in\/(Second%20PHP%20FILE\/main_application\/agreement\/)?"), "");
          request.fields[key] = relativePath;
        }
      }

      await attachFileOrUrl("owner_aadhar_front", ownerAadhaarFront, ownerAadharFrontUrl, filename: "owner_aadhar_front.jpg");
      await attachFileOrUrl("owner_aadhar_back", ownerAadhaarBack, ownerAadharBackUrl, filename: "owner_aadhar_back.jpg");
      await attachFileOrUrl("tenant_aadhar_front", tenant.aadhaarFront, tenant.aadhaarFrontUrl);
      await attachFileOrUrl("tenant_aadhar_back", tenant.aadhaarBack, tenant.aadhaarBackUrl);
      await attachFileOrUrl("tenant_image", tenant.photo, tenant.photoUrl);
      await attachFileOrUrl("agreement_pdf", agreementPdf, null, filename: "agreement.pdf", type: MediaType("application", "pdf"));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200 && response.body.toLowerCase().contains("success")) {
        Navigator.of(context, rootNavigator: true).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Updated successfully!"), duration: Duration(seconds: 1)))
            .closed.then((_) { Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HistoryTab())); });
      } else { _showToast('Submit failed (${response.statusCode})'); }
    } catch (e) { _showToast('Submit error: $e'); }
  }

  void _showToast(String message) {
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.black87, textColor: Colors.white, fontSize: 16.0);
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
            padding: padding ?? const EdgeInsets.all(18),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 20, offset: const Offset(0, 8))]),
            child: child),
      ),
    );
  }

  InputDecoration _fieldDecoration(String label) {
    return InputDecoration(
        labelText: label, floatingLabelBehavior: FloatingLabelBehavior.auto, isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none));
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
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Focus(child: Builder(builder: (contextField) {
            final hasFocus = Focus.of(contextField).hasPrimaryFocus;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                  boxShadow: hasFocus
                      ? [BoxShadow(
                      color: isEmpty
                          ? Colors.red.withOpacity(0.25)
                          : Theme.of(context).colorScheme.primary.withOpacity(0.14),
                      blurRadius: 14, spreadRadius: 1)]
                      : null,
                  borderRadius: BorderRadius.circular(12)),
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
                    color: isEmpty ? Colors.red.shade700 : Colors.black,
                    fontWeight: isEmpty ? FontWeight.w600 : FontWeight.normal,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  filled: true,
                  fillColor: isEmpty ? Colors.red.shade50 : Colors.grey.shade50,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: isEmpty ? Colors.red.shade400 : Colors.grey.shade400,
                          width: isEmpty ? 1.8 : 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                          color: isEmpty ? Colors.red.shade600 : Colors.black,
                          width: 1.8)),
                  errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade700, width: 1.8)),
                  focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.red.shade700, width: 2)),
                  errorMaxLines: 2,
                  errorStyle: const TextStyle(color: Color(0xFFB00020), fontWeight: FontWeight.w600),
                  suffixIcon: isEmpty
                      ? Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 20)
                      : const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                ),
                onChanged: (v) {
                  setState(() {});
                  if (onChanged != null) onChanged(v);
                },
              ),
            );
          })),
          if (showInWords && controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 8),
              child: Text(
                  convertToWords(int.tryParse(controller.text.replaceAll(',', '')) ?? 0),
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ),
        ]);
      },
    );
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

  Widget _imageTile({File? file, String? url, required String hint}) {
    return Container(
        width: 120, height: 72,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade200),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: file != null ? Image.file(file, fit: BoxFit.cover)
                : (url != null && url.isNotEmpty)
                ? Image.network('https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/$url',
                fit: BoxFit.cover, errorBuilder: (_, __, ___) => const Center(child: Text('Error', style: TextStyle(fontSize: 12))))
                : Center(child: Text(hint, style: const TextStyle(fontSize: 12, color: Colors.black)))));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0, backgroundColor: Colors.transparent,
            title: const Text('Police verification', style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.w600)),
            centerTitle: true,
            leading: Padding(padding: const EdgeInsets.all(10), child: SquareBackButton())),
        body: Stack(children: [
          Positioned.fill(child: _buildBackground(isDark)),
          SafeArea(child: Column(children: [
            const SizedBox(height: 18),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(children: [_fancyStepHeader(), const SizedBox(height: 10)])),
            if (widget.rewardStatus.isDiscounted)
              Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFF00C853), Color(0xFF64DD17)]),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.green.withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))]),
                      child: Row(children: [
                        const Icon(Icons.celebration, color: Colors.white), const SizedBox(width: 8),
                        Expanded(child: Text(
                            "🎉 Congratulations! Discount applied.\nYou completed ${widget.rewardStatus.totalAgreements} agreements this month.",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                      ]))),
            Expanded(child: PageView(
                controller: _pageController, physics: const NeverScrollableScrollPhysics(),
                children: [
                  SingleChildScrollView(padding: const EdgeInsets.all(18), child: _ownerStep()),
                  SingleChildScrollView(padding: const EdgeInsets.all(18), child: _tenantStep()),
                  SingleChildScrollView(padding: const EdgeInsets.all(18), child: _previewStep()),
                ])),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                child: Row(children: [
                  if (_currentStep > 0)
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.white24, foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        onPressed: _goPrevious,
                        icon: const Icon(Icons.arrow_back_rounded), label: const Text('Back')),
                  const Spacer(),
                  ElevatedGradientButton(
                      text: _currentStep == 2 ? (widget.agreementId != null ? 'Update' : 'Submit') : 'Next',
                      icon: _currentStep == 2 ? Icons.cloud_upload : Icons.arrow_forward,
                      onPressed: _currentStep == 2 ? () { widget.agreementId != null ? _updateAll() : _submitAll(); } : _goNext),
                ])),
          ])),
        ]));
  }

  Widget _buildBackground(bool isDark) {
    return Container(
        decoration: BoxDecoration(
            gradient: isDark
                ? const LinearGradient(colors: [Color(0xFF0A1938), Color(0xFF0E1330), Color(0xFF05080F)], begin: Alignment.topLeft, end: Alignment.bottomRight)
                : const LinearGradient(colors: [Color(0xFFDCE9FF), Color(0xFFBFD4FF), Color(0xFFE6F0FF)], begin: Alignment.topLeft, end: Alignment.bottomRight)),
        child: Stack(children: [
          Positioned(top: -100, left: -50, child: _glowCircle(250, isDark ? Colors.indigoAccent.withOpacity(0.22) : Colors.blueAccent.withOpacity(0.18))),
          Positioned(bottom: -120, right: -60, child: _glowCircle(320, isDark ? Colors.cyanAccent.withOpacity(0.20) : Colors.lightBlueAccent.withOpacity(0.20))),
          Positioned(top: 200, right: 100, child: _glowCircle(180, isDark ? Colors.deepPurpleAccent.withOpacity(0.12) : Colors.indigoAccent.withOpacity(0.10))),
        ]));
  }

  Widget _glowCircle(double size, Color color) {
    return Container(
        width: size, height: size,
        decoration: BoxDecoration(shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color.withOpacity(0.5), color.withOpacity(0.05), Colors.transparent], stops: const [0.0, 0.5, 1.0]),
            boxShadow: [BoxShadow(color: color.withOpacity(0.25), blurRadius: size * 0.4, spreadRadius: size * 0.1)]));
  }

  Widget _fancyStepHeader() {
    final stepLabels = ['Owner', 'Tenant', 'Preview'];
    final stepIcons = [Icons.person, Icons.person_outline, Icons.preview];
    return Row(children: [Expanded(child: SizedBox(height: 94,
        child: LayoutBuilder(builder: (context, constraints) {
          final gap = (constraints.maxWidth - 74) / (stepLabels.length - 1);
          return Stack(children: [
            Positioned(top: 50, left: 32, right: 5,
                child: Container(height: 5, decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(6)))),
            Positioned(top: 50, left: 32,
                child: AnimatedContainer(duration: const Duration(milliseconds: 450), height: 6, width: gap * _currentStep,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), gradient: kAppGradient))),
            ...List.generate(stepLabels.length, (i) {
              final left = gap * i; final isActive = i == _currentStep; final isDone = i < _currentStep;
              return Positioned(left: left, top: 0,
                  child: GestureDetector(onTap: () => _jumpToStep(i),
                      child: Column(children: [
                        AnimatedContainer(duration: const Duration(milliseconds: 350), width: isActive ? 56 : 48, height: isActive ? 56 : 48,
                            decoration: BoxDecoration(shape: BoxShape.circle,
                                gradient: isDone || isActive ? kAppGradient : null,
                                color: isDone || isActive ? null : Colors.transparent,
                                border: Border.all(color: isActive ? const Color(0xFF00D4FF) : Colors.grey, width: 1.4),
                                boxShadow: isActive ? [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 18, offset: const Offset(0, 6))] : null),
                            child: Center(child: isDone ? const Icon(Icons.check, color: Colors.white)
                                : Icon(stepIcons[i], color: isActive ? Colors.white : Colors.grey))),
                        const SizedBox(height: 8),
                        SizedBox(width: 84, child: Text(stepLabels[i], textAlign: TextAlign.center,
                            style: TextStyle(color: i == _currentStep ? Colors.cyan : Colors.black, fontSize: 12))),
                      ])));
            }),
          ]);
        })))]);
  }

  // ── OWNER STEP ─────────────────────────────────────────────────────────────
  Widget _ownerStep() {
    return _glassContainer(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('Property Residential Address', style: TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
      const Text('Property ka Address', style: TextStyle(fontSize: 11, color: Colors.black54)),
      const SizedBox(height: 12),
      _glowTextField(controller: propertyAddress, label: 'Residential Address', validator: (v) => (v?.trim().isEmpty ?? true) ? 'Required' : null),
      const SizedBox(height: 16),

      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Owner Details', style: const TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
            const Text('Malik ki Jaankari', style: TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        )),
        Container(
          decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Colors.cyan, Colors.blue], begin: Alignment.centerLeft, end: Alignment.centerRight),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))]),
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
              label: const Text('Auto Fetch', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(elevation: 0, backgroundColor: Colors.transparent, shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
        ),
      ]),
      const SizedBox(height: 16),

      // ── OWNER AADHAAR IMAGES CARD ──
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
          Text('Enter Aadhaar or Mobile above and tap Auto Fetch to fill details automatically.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
        ]),
      ),
      const SizedBox(height: 16),

      Form(key: _ownerFormKey, child: Column(children: [
        Row(children: [
          Expanded(child: _glowTextField(controller: ownerMobile, label: 'Mobile No', keyboard: TextInputType.phone,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
              validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) return 'Enter valid 10-digit mobile'; return null; })),
          const SizedBox(width: 12),
          Expanded(child: _glowTextField(controller: ownerAadhaar, label: 'Aadhaar/VID No', keyboard: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)])),
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
      ])),
    ]));
  }

  // ── TENANT STEP ────────────────────────────────────────────────────────────
  Widget _tenantStep() {
    return _glassContainer(
      child: Form(
        key: tenant.formKey,
        autovalidateMode: AutovalidateMode.disabled,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Tenant Details', style: TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
              Text('Kirayedar ki Jaankari', style: TextStyle(fontSize: 11, color: Colors.black54)),
            ])),
            Container(
              decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.blue.shade700, Colors.blue.shade500]), borderRadius: BorderRadius.circular(12)),
              child: ElevatedButton.icon(
                  onPressed: () async {
                    final a = tenant.aadhaar.text.trim();
                    final m = tenant.mobile.text.trim();
                    if (a.isEmpty && m.isEmpty) { _showToast('Enter Aadhaar or Mobile number first'); return; }
                    showDialog(context: context, barrierDismissible: false,
                        builder: (_) => const Center(child: Card(child: Padding(padding: EdgeInsets.all(24),
                            child: Column(mainAxisSize: MainAxisSize.min, children: [CircularProgressIndicator(), SizedBox(height: 14), Text('Fetching tenant details...')])))));
                    await _fetchUserData(fillOwner: false, aadhaar: a.isNotEmpty ? a : null, mobile: a.isEmpty ? m : null);
                    if (mounted) { Navigator.of(context, rootNavigator: true).pop(); setState(() {}); }
                  },
                  icon: const Icon(Icons.search, color: Colors.white, size: 18),
                  label: const Text('Auto Fetch', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent)),
            ),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: _glowTextField(controller: tenant.mobile, label: 'Mobile No', keyboard: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; if (!RegExp(r'^[6-9]\d{9}$').hasMatch(v)) return 'Enter valid 10-digit mobile'; return null; })),
            const SizedBox(width: 12),
            Expanded(child: _glowTextField(controller: tenant.aadhaar, label: 'Aadhaar / VID No', keyboard: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(16)],
                validator: (v) { if (v == null || v.trim().isEmpty) return 'Required'; if (!RegExp(r'^\d{12}$').hasMatch(v) && !RegExp(r'^\d{16}$').hasMatch(v)) return 'Enter valid Aadhaar / VID'; return null; })),
          ]),
          const SizedBox(height: 12),
          _glowTextField(controller: tenant.name, label: 'Tenant Full Name', validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: DropdownButtonFormField<String>(
                value: tenant.relation,
                items: const ['S/O', 'D/O', 'W/O', 'C/O'].map((e) => DropdownMenuItem(value: e, child: Text(e, style: TextStyle(color: Colors.black)))).toList(),
                onChanged: (v) => setState(() => tenant.relation = v ?? 'S/O'),
                decoration: _fieldDecoration('Relation').copyWith(
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1.5))),
                dropdownColor: Colors.white, iconEnabledColor: Colors.black, style: const TextStyle(color: Colors.black))),
            const SizedBox(width: 12),
            Expanded(child: _glowTextField(controller: tenant.relationPerson, label: 'Person Name', validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null)),
          ]),
          const SizedBox(height: 12),
          _glowTextField(controller: tenant.address, label: 'Permanent Address', validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade300)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                const Icon(Icons.badge_outlined, size: 18, color: Colors.black54), const SizedBox(width: 6),
                const Text('Tenant Documents', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.black87)),
                const Spacer(),
                if (tenant.aadhaarFront != null || (tenant.aadhaarFrontUrl?.isNotEmpty ?? false)) const Icon(Icons.check_circle, color: Colors.green, size: 18),
              ]),
              const SizedBox(height: 14),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(child: _aadhaarImageCard(label: 'Aadhaar Front', file: tenant.aadhaarFront, url: tenant.aadhaarFrontUrl, onUpload: () => _pickTenantDoc(true))),
                const SizedBox(width: 8),
                Expanded(child: _aadhaarImageCard(label: 'Aadhaar Back', file: tenant.aadhaarBack, url: tenant.aadhaarBackUrl, onUpload: () => _pickTenantDoc(false))),
                const SizedBox(width: 8),
                Expanded(child: _aadhaarImageCard(label: 'Photo', file: tenant.photo, url: tenant.photoUrl, onUpload: _pickTenantPhoto, placeholderIcon: Icons.person_outline)),
              ]),
              const SizedBox(height: 8),
              Text('Upload Aadhaar images — OCR will auto-fill fields above.', style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
            ]),
          ),
        ]),
      ),
    );
  }

  // ── PREVIEW STEP ───────────────────────────────────────────────────────────
  Widget _previewStep() {
    final int totalPrice = widget.rewardStatus.isDiscounted ? 40 : 50;
    return _glassContainer(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Preview', style: TextStyle(fontFamily: "Poppins", fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black)),
          Text('Jaanch Kar Jama Karein', style: TextStyle(fontSize: 11, color: Colors.black54)),
        ]),
        IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
      ]),
      const SizedBox(height: 12),
      _sectionCard(title: '*Owner', children: [
        _kv('Name', ownerName.text), _kv('Relation', ownerRelation),
        _kv('Relation Person', ownerRelationPerson.text), _kv('Mobile', ownerMobile.text),
        _kv('Aadhaar', ownerAadhaar.text), _kv('Address', ownerAddress.text),
        const SizedBox(height: 8),
        const Text('Aadhaar Images', style: TextStyle(color: Colors.black)),
        const SizedBox(height: 8),
        Row(children: [
          _imageTile(file: ownerAadhaarFront, url: ownerAadharFrontUrl, hint: 'Front'),
          const SizedBox(width: 8), _imageTile(file: ownerAadhaarBack, url: ownerAadharBackUrl, hint: 'Back'), const Spacer(),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => _jumpToStep(0), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Edit')),
        ]),
      ]),
      const SizedBox(height: 12),
      _sectionCard(title: '* Tenant', children: [
        _kv('Name', tenant.name.text), _kv('Relation', tenant.relation),
        _kv('Relation Person', tenant.relationPerson.text), _kv('Mobile', tenant.mobile.text),
        _kv('Aadhaar', tenant.aadhaar.text), _kv('Address', tenant.address.text),
        const SizedBox(height: 12), const Divider(),
        const Text('Tenant Documents', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black)), const SizedBox(height: 8),
        Wrap(
          spacing: 10,
            children: [
          _imageTile(file: tenant.aadhaarFront, url: tenant.aadhaarFrontUrl, hint: 'Front'), const SizedBox(width: 8),
          _imageTile(file: tenant.aadhaarBack, url: tenant.aadhaarBackUrl, hint: 'Back'), const SizedBox(width: 8),
          _imageTile(file: tenant.photo, url: tenant.photoUrl, hint: 'Photo'),
        ]),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          TextButton(onPressed: () => _jumpToStep(1), style: TextButton.styleFrom(foregroundColor: Colors.red), child: const Text('Edit')),
        ]),
      ]),
      Row(children: [
        const SizedBox(width: 15),
        Text('Total cost will be: ₹$totalPrice', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w700)),
      ]),
      const SizedBox(height: 12),
      CheckboxListTile(
          value: isAgreementHide, onChanged: (v) => setState(() => isAgreementHide = v ?? false),
          title: const Text('Hide Aadhaar', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          subtitle: const Text('Aadhaar images & number will be hidden in agreement PDF', style: TextStyle(fontSize: 12, color: Colors.black)),
          activeColor: Colors.redAccent, checkColor: Colors.white),
      const SizedBox(height: 12),
      const Text('* IMPORTANT : When you tap Submit we send data & uploaded Aadhaar images to server for Approval from the Admin.', style: TextStyle(color: Colors.red)),
    ]));
  }

  Widget _kv(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          SizedBox(width: 140, child: Text('$k:', style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black))),
          Expanded(child: Text(v, style: const TextStyle(color: Colors.black))),
        ]));
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Padding(padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black)),
          const SizedBox(height: 8),
          _glassContainer(child: Column(children: children), padding: const EdgeInsets.all(14)),
        ]));
  }
}

class ElevatedGradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const ElevatedGradientButton({required this.text, required this.icon, required this.onPressed, super.key});

  static const kAppGradient = LinearGradient(colors: [Color(0xFF4CA1FF), Color(0xFF00D4FF)]);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            height: 48,
            decoration: BoxDecoration(
                gradient: kAppGradient, borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 8))]),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(icon, color: Colors.white), const SizedBox(width: 12),
              Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ])));
  }
}
