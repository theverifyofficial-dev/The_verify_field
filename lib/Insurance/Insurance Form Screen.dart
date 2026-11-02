import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/heic_converter.dart';
import 'insurance_ui_kit.dart';

/// Add Insurance -- redesigned 2026-10-21 into a fetch-first flow around
/// the paid "RTO Sarthi" Vehicle Info API: Step 1 is now "Vehicle Lookup"
/// (Vehicle Number + Fetch Details), which ALWAYS checks our own DB first
/// and only spends the paid API call when the plate isn't already on
/// file -- but as of the **2026-10-22 correction**, that fetch-first
/// decision is made SERVER-SIDE, in a single call to one lookup endpoint
/// (see `vehicleLookupEndpointPath` in insurance_ui_kit.dart -- still a
/// confirmed-temporary placeholder path the user will replace). The real
/// insert endpoint (`insert_insurance.php`, under the "Second PHP
/// FILE/insurance/" path) is confirmed and already wired up below via
/// `insertEndpointPath`; the real update endpoint
/// (`update_insurance_api.php`, keyed by `id`) was confirmed 2026-10-22
/// and is now wired up via `updateEndpointPath` too.
/// See the project doc "Vehicle_Info_API_Insurance_Redesign_Spec.md" for
/// the full design and its "2026-10-22 correction" section for exactly
/// what changed from the original assumed two-endpoint contract.
///
/// Previous (2026-10-16/17) history retained below for context: this was
/// a 3-step wizard (Policy Holder Details -> Policy Information ->
/// Documents) with Full Name/Phone/Vehicle Number as the only required
/// fields. That step order is now inverted -- Vehicle Number comes
/// first, since what the lookup returns determines whether Full
/// Name/Phone even need to be typed by hand.
class InsuranceFormScreen extends StatefulWidget {
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  // 2026-10-29: set when this form was opened via "Add Vehicle" from a
  // Future Property Building or Flat Detail page -- locks the linkage
  // so the field worker can't change which building/flat the new
  // insurance record gets attached to. lockedBuildingId alone means a
  // building-level vehicle (no flat); both set means a flat-level
  // vehicle. Both null (the normal "Add Insurance" FAB flow) means no
  // linkage at all, unchanged from before this feature existed.
  final String? lockedBuildingId;
  final String? lockedFlatId;

  const InsuranceFormScreen({
    super.key,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    this.lockedBuildingId,
    this.lockedFlatId,
  });

  @override
  State<InsuranceFormScreen> createState() => _InsuranceFormScreenState();
}

class _StepMeta {
  final String title;
  final IconData icon;
  const _StepMeta(this.title, this.icon);
}

class _InsuranceFormScreenState extends State<InsuranceFormScreen> {
  // **2026-10-22 correction**: the real backend lives at a NEW location
  // the user shared directly from a live endpoint -- a different path and
  // field-naming convention than originally assumed (see
  // "Vehicle_Info_API_Insurance_Redesign_Spec.md" §11 for the full history).
  // `insertEndpointPath` is confirmed, real, and final. `lookupEndpointPath`
  // (from `insurance_ui_kit.dart`) is still a TEMPORARY PLACEHOLDER --
  // do not treat it as correct. `updateEndpointPath` is now confirmed
  // real too (2026-10-22), same endpoint the Update form uses, keyed by
  // `id` (sent below).
  static const String insuranceBaseUrl =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/';
  static const String insertEndpointPath = 'insert_insurance.php'; // REAL, confirmed 2026-10-22
  static const String updateEndpointPath = 'update_insurance_api.php'; // REAL, confirmed 2026-10-22

  static const List<_StepMeta> _steps = [
    _StepMeta('Vehicle Lookup', Icons.search_rounded),
    _StepMeta('Policy Holder Details', Icons.person_outline_rounded),
    _StepMeta('Documents', Icons.folder_open_outlined),
  ];

  int _stepIndex = 0;
  bool _isLoading = false;
  bool _restoredDraft = false;

  final _formKey = GlobalKey<FormState>();

  // Step 0 -- Vehicle Lookup (required)
  final vehicleNumberController = TextEditingController();
  VehicleFetchStatus _fetchStatus = VehicleFetchStatus.idle;
  Map<String, dynamic>? _record; // DB row (foundInternal) or API `data` object (foundExternal)
  String? _fetchMessage;

  // Step 1 -- Policy Holder Details (required)
  final nameController = TextEditingController();
  final numberController = TextEditingController();
  // Owner email -- entered manually by the field worker (2026-10-22); the
  // backend returns `owner_email` on an existing record too, but it is
  // never auto-filled from a lookup, by the user's explicit request.
  final emailController = TextEditingController();

  // Nominee & additional details -- new columns on the table (2026-10-22),
  // all manually typed/picked by the field worker, same as Name/Phone/Email.
  final nomineeNameController = TextEditingController();
  final nomineeRelationController = TextEditingController();
  final nomineeAgeController = TextEditingController();
  final extraNumberController = TextEditingController();
  final callingNumberController = TextEditingController();
  // The person's name for each alternate contact number above --
  // `extra_name`/`calling_name` (2026-10-23, new API params).
  final extraNameController = TextEditingController();
  final callingNameController = TextEditingController();
  String _claim = 'No'; // Yes/No, same pattern as the old form's claim field
  String? _maritalStatus;

  // Quota counters from the paid API's own `usage` object, if this
  // lookup actually spent a paid call -- shown via a small popup next to
  // the "Fetched from Vehicle Registry" badge (2026-10-22).
  RtoApiUsage? _usage;

  // Step 2 -- Documents (all optional)
  final picker = ImagePicker();
  File? carPhoto;
  File? rcFront;
  File? rcBack;
  File? aadharFront;
  File? aadharBack;
  File? panCardPhoto;
  File? oldPolicy;
  File? dlImg;
  File? newPolicy;
  File? pollutionPhoto;
  List<File> carMultipleImages = [];

  String get _draftKey => 'insurance_draft_${widget.fieldWorkerNumber}';

  bool get _vehicleNumberLocked =>
      _fetchStatus != VehicleFetchStatus.idle && _fetchStatus != VehicleFetchStatus.error;

  bool get _lookupResolved => const {
        VehicleFetchStatus.foundInternal,
        VehicleFetchStatus.foundExternal,
        VehicleFetchStatus.quotaExhausted,
        VehicleFetchStatus.notFoundExternal,
      }.contains(_fetchStatus);

  @override
  void initState() {
    super.initState();
    _maybeOfferDraftRestore();
  }

  @override
  void dispose() {
    vehicleNumberController.dispose();
    nameController.dispose();
    numberController.dispose();
    emailController.dispose();
    nomineeNameController.dispose();
    nomineeRelationController.dispose();
    nomineeAgeController.dispose();
    extraNumberController.dispose();
    callingNumberController.dispose();
    extraNameController.dispose();
    callingNameController.dispose();
    super.dispose();
  }

  // ------------------------------------------------------------------
  // Draft save/restore -- "Save-as-draft capability between steps".
  // Only text fields are persisted (SharedPreferences can't hold picked
  // `File`s across app restarts, and the vehicle-lookup result is live
  // server data, not something safe to freeze-dry) -- a restored draft
  // always resumes at Step 0 with lookup state reset to idle, so the
  // field worker re-runs "Fetch Details" rather than the form showing
  // Step 2/3 content for a lookup that never actually happened this
  // session. This is a deliberate, flagged limitation, not an oversight.
  // ------------------------------------------------------------------

  Map<String, dynamic> _draftJson() => {
        'name': nameController.text,
        'number': numberController.text,
        'email': emailController.text,
        'vehicleNumber': vehicleNumberController.text,
        'nomineeName': nomineeNameController.text,
        'nomineeRelation': nomineeRelationController.text,
        'nomineeAge': nomineeAgeController.text,
        'extraNumber': extraNumberController.text,
        'callingNumber': callingNumberController.text,
        'extraName': extraNameController.text,
        'callingName': callingNameController.text,
        'claim': _claim,
        'maritalStatus': _maritalStatus,
      };

  Future<void> _saveDraft({bool silent = false}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_draftKey, jsonEncode(_draftJson()));
    if (!silent && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Draft saved')),
      );
    }
  }

  Future<void> _clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  Future<void> _maybeOfferDraftRestore() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_draftKey);
    if (saved == null || !mounted) return;
    final shouldRestore = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: InsColors.surface,
        surfaceTintColor: InsColors.surface,
        title: const Text(
          'Resume saved draft?',
          style: TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'You have an unfinished Insurance form saved on this device. Resume where you left off?',
          style: TextStyle(color: InsColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Start fresh', style: TextStyle(color: InsColors.textSecondary, fontWeight: FontWeight.w600)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Resume', style: TextStyle(color: InsColors.primary, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (shouldRestore != true) {
      await _clearDraft();
      return;
    }
    try {
      final data = jsonDecode(saved) as Map<String, dynamic>;
      nameController.text = data['name'] ?? '';
      numberController.text = data['number'] ?? '';
      emailController.text = data['email'] ?? '';
      vehicleNumberController.text = data['vehicleNumber'] ?? '';
      nomineeNameController.text = data['nomineeName'] ?? '';
      nomineeRelationController.text = data['nomineeRelation'] ?? '';
      nomineeAgeController.text = data['nomineeAge'] ?? '';
      extraNumberController.text = data['extraNumber'] ?? '';
      callingNumberController.text = data['callingNumber'] ?? '';
      extraNameController.text = data['extraName'] ?? '';
      callingNameController.text = data['callingName'] ?? '';
      _claim = data['claim'] ?? 'No';
      _maritalStatus = data['maritalStatus'];
      _stepIndex = 0; // always resume at the lookup step -- see comment above
      _restoredDraft = true;
      if (mounted) setState(() {});
    } catch (_) {
      // Corrupt/old-shape draft -- ignore rather than crash the form.
    }
  }

  // ------------------------------------------------------------------
  // Vehicle lookup -- the fetch-first flow itself
  // ------------------------------------------------------------------

  Future<void> _onFetchDetailsTapped() async {
    final vno = vehicleNumberController.text.trim();
    if (vno.length < 6) {
      _showSnack('Enter a valid vehicle number');
      return;
    }
    setState(() {
      _fetchStatus = VehicleFetchStatus.checkingInternal; // DB-first check reinstated 2026-10-22
      _fetchMessage = null;
      _record = null;
      _usage = null;
    });

    final result = await fetchVehicleDetails(
      baseUrl: insuranceBaseUrl,
      vehicleNumber: vno,
      fieldWorkerNumber: widget.fieldWorkerNumber,
    );

    if (!mounted) return;
    setState(() {
      _fetchStatus = result.status;
      _record = result.record;
      _fetchMessage = result.message;
      _usage = result.usage;
    });

    // Prefill Policy Holder Details from whatever we now know, without
    // clobbering anything the field worker may have already typed. The
    // real backend uses the same OWNER_NAME/MOBILE_NO schema whether the
    // record already existed or was just fetched, so both outcomes
    // prefill identically now.
    if (result.record != null &&
        (result.status == VehicleFetchStatus.foundInternal || result.status == VehicleFetchStatus.foundExternal)) {
      final ownerName = normalizeRtoValue(result.record!['OWNER_NAME'], InsFieldFormat.text);
      final mobile = normalizeRtoValue(result.record!['MOBILE_NO'], InsFieldFormat.text);
      if (ownerName.isNotEmpty && nameController.text.trim().isEmpty) {
        nameController.text = ownerName;
      }
      if (mobile.isNotEmpty && numberController.text.trim().isEmpty) {
        numberController.text = mobile.replaceAll(RegExp(r'[^0-9]'), '');
      }
    }
  }

  void _resetLookup() {
    setState(() {
      _fetchStatus = VehicleFetchStatus.idle;
      _record = null;
      _fetchMessage = null;
      _usage = null;
    });
  }

  // ------------------------------------------------------------------
  // Step validation + navigation
  // ------------------------------------------------------------------

  bool _validateStep(int step) {
    if (step == 0) {
      if (!_lookupResolved) {
        _showSnack('Tap "Fetch Details" first.');
        return false;
      }
      if (_fetchStatus == VehicleFetchStatus.foundInternal) {
        // **2026-10-22**: "I want the vehicle entry is just be once" --
        // a vehicle already on file stops the wizard here; the only way
        // forward is a different plate, not continuing to re-enter it.
        _showSnack('This vehicle is already registered. Try a different vehicle number.');
        return false;
      }
      return true;
    }
    if (step == 1) {
      final formValid = _formKey.currentState?.validate() ?? true;
      if (!formValid) {
        _showSnack('Please fix the highlighted field(s) before continuing.');
        return false;
      }
      return true;
    }
    return true; // Step 3 (Documents) is entirely optional.
  }

  void _onNextPressed() {
    if (!_validateStep(_stepIndex)) return;
    final isLast = _stepIndex == _steps.length - 1;
    if (isLast) {
      _submitForm();
    } else {
      setState(() => _stepIndex++);
      _saveDraft(silent: true);
    }
  }

  void _onBackPressed() => setState(() => _stepIndex--);

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // ------------------------------------------------------------------
  // Document pickers
  // ------------------------------------------------------------------

  // 2026-11-02: every single-document tile now offers Camera/Gallery/
  // Browse Files (PDF) via the shared `pickInsuranceDocument()` sheet,
  // instead of always opening the Gallery picker directly.
  Future<void> _pickSingle(void Function(File) assign) async {
    final picked = await pickInsuranceDocument(context);
    if (picked != null) {
      setState(() => assign(picked));
    }
  }

  Future<void> _pickMultiple() async {
    final pickedFiles = await HeicConverter.pickMultiImage(picker, imageQuality: 75);
    if (pickedFiles.isNotEmpty) {
      setState(() => carMultipleImages.addAll(pickedFiles.map((e) => File(e.path))));
    }
  }

  // ------------------------------------------------------------------
  // Submit -- routes to a different endpoint depending on what the
  // Step 0 lookup found, so an already-existing plate is always
  // updated in place rather than ever creating a second row for it.
  // ------------------------------------------------------------------

  void _addVehicleInfoFields(http.MultipartRequest request, Map<String, dynamic>? record) {
    for (final section in vehicleInfoSections) {
      for (final f in section.fields) {
        request.fields[f.apiKey] = (record?[f.apiKey] ?? '').toString();
      }
    }
  }

  /// Nominee + a few other new table columns (2026-10-22) -- all manually
  /// typed/picked by the field worker, same as Name/Phone/Email, so they
  /// go on every submit exactly like those do (never sourced from a
  /// lookup record, since the RTO registry has no concept of a nominee).
  void _addNomineeFields(http.MultipartRequest request) {
    request.fields['claim'] = _claim;
    request.fields['Nominie_name'] = nomineeNameController.text.trim();
    request.fields['Nominie_relation'] = nomineeRelationController.text.trim();
    request.fields['Nominie_age'] = nomineeAgeController.text.trim();
    request.fields['Marital_status'] = _maritalStatus ?? '';
    request.fields['extra_number'] = extraNumberController.text.trim();
    request.fields['calling_number'] = callingNumberController.text.trim();
    request.fields['extra_name'] = extraNameController.text.trim();
    request.fields['calling_name'] = callingNameController.text.trim();
  }

  Future<void> _addDocumentFiles(http.MultipartRequest request) async {
    Future<void> addFile(String field, File? file) async {
      if (file == null) return;
      request.files.add(await http.MultipartFile.fromPath(field, file.path));
    }

    await addFile('car_photo', carPhoto);
    await addFile('Rc_front', rcFront);
    await addFile('Rc_back', rcBack);
    await addFile('Aadhar_front', aadharFront);
    await addFile('Aadhar_back', aadharBack);
    await addFile('pan_card_photo', panCardPhoto);
    await addFile('old_policy_docement', oldPolicy);
    await addFile('DL_img', dlImg);
    await addFile('new_policy_docement', newPolicy);
    await addFile('polution_photo', pollutionPhoto);
    for (final image in carMultipleImages) {
      request.files.add(await http.MultipartFile.fromPath('car_images[]', image.path));
    }
  }

  Future<void> _submitForm() async {
    setState(() => _isLoading = true);
    try {
      final http.MultipartRequest request;
      // **2026-10-22 note**: the wizard's Step 0 footer now blocks any
      // further progress once `_fetchStatus == foundInternal` (see
      // `_buildFooter()`'s `blockedAsDuplicate` branch -- "a vehicle can
      // only be added once"), so this branch can no longer actually be
      // reached from the UI. Left in place rather than removed, since
      // it's harmless and still correct if that guard is ever relaxed.
      final bool isUpdatingExisting = _fetchStatus == VehicleFetchStatus.foundInternal && _record != null;

      if (isUpdatingExisting) {
        // The plate already has a record -- update it in place rather than
        // creating a duplicate row for the same vehicle. Every field this
        // trimmed form doesn't show is sourced from the record the lookup
        // already returned (not left blank), so updating just Name/Phone/
        // Documents here can never wipe out the rest of that record's data
        // -- same precaution as the Update form's own submit logic.
        request = http.MultipartRequest('POST', Uri.parse('$insuranceBaseUrl' '$updateEndpointPath'));
        final r = _record!;
        _addVehicleInfoFields(request, r);
        request.fields['id'] = (r['id'] ?? '').toString();
        request.fields['vehicleNumber'] = vehicleNumberController.text.trim();
        request.fields['OWNER_NAME'] = nameController.text.trim();
        request.fields['MOBILE_NO'] = numberController.text.trim();
        request.fields['owner_email'] = emailController.text.trim();
        request.fields['Fieldworkar_name'] = widget.fieldWorkerName;
        request.fields['Fieldworkar_number'] = widget.fieldWorkerNumber;
        _addNomineeFields(request);
      } else {
        // New record -- either populated from the paid API (foundExternal)
        // or fully manual (quotaExhausted / notFoundExternal). Every
        // curated Vehicle Info field `insert_insurance.php` accepts is
        // sent (blank when there's no fetched record), so a manual-entry
        // submission and an API-populated one hit the exact same endpoint
        // with the exact same field set -- the backend tells them apart
        // by which fields actually came back non-blank, since there's no
        // separate `data_source` column in the real schema.
        request = http.MultipartRequest('POST', Uri.parse('$insuranceBaseUrl' '$insertEndpointPath'));
        _addVehicleInfoFields(request, _record);
        request.fields['vehicleNumber'] = vehicleNumberController.text.trim();
        request.fields['OWNER_NAME'] = nameController.text.trim();
        request.fields['MOBILE_NO'] = numberController.text.trim();
        request.fields['owner_email'] = emailController.text.trim();
        request.fields['Fieldworkar_name'] = widget.fieldWorkerName;
        request.fields['Fieldworkar_number'] = widget.fieldWorkerNumber;
        _addNomineeFields(request);
      }

      // 2026-10-29: Building/Flat linkage, if this form was opened via
      // "Add Vehicle" from a Building/Flat Detail page. Sent on both
      // branches above (new insert AND the dead-but-harmless update
      // branch) since a locked linkage should stick regardless of which
      // path a submit takes.
      if (widget.lockedBuildingId != null && widget.lockedBuildingId!.isNotEmpty) {
        request.fields['Building_id'] = widget.lockedBuildingId!;
      }
      if (widget.lockedFlatId != null && widget.lockedFlatId!.isNotEmpty) {
        request.fields['Flat_id'] = widget.lockedFlatId!;
      }

      await _addDocumentFiles(request);

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      debugPrint('INSURANCE ADD RESPONSE (${response.statusCode}): $responseBody');

      if (response.statusCode == 200) {
        await _clearDraft();
        if (!mounted) return;
        _showSnack(isUpdatingExisting ? 'Record updated successfully' : 'Insurance details submitted successfully');
        Navigator.pop(context, true);
      } else {
        _showSnack('Submission failed (status ${response.statusCode}). Please try again.');
      }
    } catch (e) {
      debugPrint('INSURANCE ADD ERROR: $e');
      _showSnack('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ------------------------------------------------------------------
  // UI
  // ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final step = _steps[_stepIndex];
    return Scaffold(
      backgroundColor: InsColors.bg,
      appBar: AppBar(
        backgroundColor: InsColors.surface,
        foregroundColor: InsColors.textPrimary,
        elevation: 0.5,
        title: const Text('Add Insurance', style: TextStyle(fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => _saveDraft(),
            child: const Text('Save Draft', style: TextStyle(color: InsColors.primary, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
          child: Column(
            children: [
              StepProgressBar(currentStep: _stepIndex, stepTitles: _steps.map((s) => s.title).toList()),
              const SizedBox(height: 16),
              if (widget.lockedBuildingId != null && widget.lockedBuildingId!.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(color: InsColors.primary.withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 16, color: InsColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          (widget.lockedFlatId != null && widget.lockedFlatId!.isNotEmpty)
                              ? 'Linked to Flat #${widget.lockedFlatId} · Building #${widget.lockedBuildingId}'
                              : 'Linked to Building #${widget.lockedBuildingId}',
                          style: const TextStyle(color: InsColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              if (_restoredDraft && _stepIndex == 0)
                Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(color: InsColors.successBg, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle_outline, size: 16, color: InsColors.success),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text('Resumed from your saved draft -- tap Fetch Details to continue.', style: TextStyle(color: InsColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(color: InsColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              alignment: Alignment.center,
                              child: Icon(step.icon, size: 18, color: InsColors.primary),
                            ),
                            const SizedBox(width: 10),
                            Text(step.title, style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildStepContent(),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_stepIndex) {
      case 0:
        return _buildVehicleLookupStep();
      case 1:
        return _buildPolicyHolderStep();
      default:
        return _buildDocumentsStep();
    }
  }

  // **2026-10-22**: a dedicated read-only "Saved Field Worker Details"
  // card and a "View Full Record" detail-page link used to live here for
  // the `foundInternal` case -- both removed per the user's explicit
  // instruction: any field worker can type in an arbitrary plate, so
  // surfacing another agent's full record (or even just their contact/
  // nominee details) to whoever happens to try that plate number is a
  // data-exposure risk, not a convenience. `foundInternal` now shows
  // only the summary header card (see `_buildLookupStatusContent()`).

  Widget _buildVehicleLookupStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InsTextField(
          label: 'Vehicle Number',
          controller: vehicleNumberController,
          required: true,
          readOnly: _vehicleNumberLocked,
          hint: 'e.g. DL01AB1234',
          textCapitalization: TextCapitalization.characters,
          inputFormatters: [UpperCaseTextFormatter()],
          validator: (v) => (v == null || v.trim().length < 6) ? 'Enter a valid vehicle number' : null,
          suffixIcon: _vehicleNumberLocked
              ? IconButton(
                  icon: const Icon(Icons.edit_rounded, size: 18, color: InsColors.textSecondary),
                  onPressed: _resetLookup,
                  tooltip: 'Change vehicle number',
                )
              : null,
        ),
        const SizedBox(height: 4),
        if (!_vehicleNumberLocked)
          const Text(
            'We check our own records first -- the paid vehicle registry lookup only runs if this vehicle isn\'t already on file.',
            style: TextStyle(color: InsColors.textSecondary, fontSize: 12.5),
          ),
        const SizedBox(height: 14),
        _buildLookupStatusContent(),
      ],
    );
  }

  Widget _buildLookupStatusContent() {
    switch (_fetchStatus) {
      case VehicleFetchStatus.idle:
      case VehicleFetchStatus.error:
        if (_fetchStatus == VehicleFetchStatus.error) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: InsColors.errorBg, borderRadius: BorderRadius.circular(10)),
            child: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: InsColors.error, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _fetchMessage ?? 'Could not reach the vehicle registry.',
                    style: const TextStyle(color: InsColors.error, fontSize: 12.5, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();

      case VehicleFetchStatus.checkingInternal:
      case VehicleFetchStatus.checkingExternal:
        return Row(
          children: [
            const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: InsColors.primary)),
            const SizedBox(width: 10),
            Text(
              _fetchStatus == VehicleFetchStatus.checkingInternal ? 'Checking our records...' : 'Checking vehicle registry...',
              style: const TextStyle(color: InsColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ],
        );

      case VehicleFetchStatus.foundInternal:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: InsColors.warningBg, borderRadius: BorderRadius.circular(10)),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: InsColors.warning, size: 18),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'This vehicle is already registered. A vehicle can only be added once.',
                      style: TextStyle(color: InsColors.warning, fontSize: 12.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            // **2026-10-22**: only the summary header card -- no full
            // record, no navigation to the Detail page. Any field worker
            // can type in any plate, so letting that reveal the full
            // record (owner contact info, nominee details, documents --
            // everything) would hand out another agent's data to anyone
            // who happens to know or guess the plate number.
            if (_record != null) InsVehicleHeaderCard(record: _record!),
          ],
        );

      case VehicleFetchStatus.foundExternal:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const InsBadge(label: 'Fetched from Vehicle Registry', tone: InsBadgeTone.success, icon: Icons.verified_rounded),
                if (_usage != null && _usage!.hasAny) ...[
                  const SizedBox(width: 8),
                  RtoUsageIconButton(usage: _usage!),
                ],
              ],
            ),
            const SizedBox(height: 14),
            if (_record != null) buildVehicleInfoSectionsRow(_record!, isFromApiPayload: true),
          ],
        );

      case VehicleFetchStatus.quotaExhausted:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: InsColors.warningBg, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              const Icon(Icons.hourglass_bottom_rounded, color: InsColors.warning, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _fetchMessage ?? 'Daily lookup limit reached -- you can still save this record manually.',
                  style: const TextStyle(color: InsColors.warning, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );

      case VehicleFetchStatus.notFoundExternal:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: InsColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: InsColors.border)),
          child: Row(
            children: [
              const Icon(Icons.search_off_rounded, color: InsColors.textSecondary, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _fetchMessage ?? 'Not found in the vehicle registry either -- enter details manually.',
                  style: const TextStyle(color: InsColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _buildPolicyHolderStep() {
    final showBanner = _fetchStatus == VehicleFetchStatus.foundInternal || _fetchStatus == VehicleFetchStatus.foundExternal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showBanner)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              _fetchStatus == VehicleFetchStatus.foundInternal
                  ? 'Prefilled from our existing record -- edit if anything has changed.'
                  : 'Prefilled from the vehicle registry -- edit if anything looks wrong.',
              style: const TextStyle(color: InsColors.textSecondary, fontSize: 12.5),
            ),
          ),
        InsTextField(label: 'Full Name', controller: nameController, required: true, hint: 'e.g. Ramesh Kumar', validator: insRequired),
        InsTextField(
          label: 'Primary Phone Number',
          controller: numberController,
          required: true,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          hint: '10-digit mobile number',
          validator: insPhoneValidator,
        ),
        InsTextField(
          label: 'Owner Email',
          controller: emailController,
          required: false,
          keyboardType: TextInputType.emailAddress,
          hint: 'owner@example.com',
          validator: insEmailValidator,
        ),
        // Order per 2026-10-23 request: Calling Person (name, then
        // number) first, then Alternate Person (name, then number) --
        // `callingNumber`/`callingName` map to the "Calling Person" pair,
        // `extraNumber`/`extraName` to the "Alternate Person" pair.
        InsTextField(
          label: 'Calling Person Name',
          controller: callingNameController,
          required: false,
          hint: 'Name of the best person to call',
        ),
        InsTextField(
          label: 'Calling Person Number',
          controller: callingNumberController,
          required: false,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          hint: 'Best number to call on',
        ),
        InsTextField(
          label: 'Alternate Person Name',
          controller: extraNameController,
          required: false,
          hint: 'Name of the person on the alternate number',
        ),
        InsTextField(
          label: 'Alternate Person Number',
          controller: extraNumberController,
          required: false,
          keyboardType: TextInputType.phone,
          maxLength: 10,
          hint: 'An alternate contact number',
        ),
        const SizedBox(height: 4),
        InsSectionCard(
          title: 'Nominee Details',
          icon: Icons.family_restroom_rounded,
          subtitle: 'Optional',
          children: [
            InsYesNoRow(label: 'Insurance Claim?', value: _claim, onChanged: (v) => setState(() => _claim = v)),
            const SizedBox(height: 4),
            InsTextField(label: 'Nominee Name', controller: nomineeNameController, hint: 'e.g. Sita Devi'),
            InsTextField(label: 'Nominee Relation', controller: nomineeRelationController, hint: 'e.g. Spouse, Son, Daughter'),
            InsTextField(
              label: 'Nominee Age',
              controller: nomineeAgeController,
              keyboardType: TextInputType.number,
              maxLength: 3,
              hint: 'Age in years',
            ),
            InsDropdownField(
              label: 'Marital Status',
              value: _maritalStatus,
              items: const ['Married', 'Unmarried', 'Divorced', 'Widowed'],
              onChanged: (v) => setState(() => _maritalStatus = v),
              hint: 'Select marital status',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDocumentsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12),
          child: Text(
            'All documents below are optional. You can add or update them later from the Update form.',
            style: TextStyle(color: InsColors.textSecondary, fontSize: 12.5),
          ),
        ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: [
            DocumentUploadTile(label: 'Vehicle Photo', file: carPhoto, onPick: () => _pickSingle((f) => carPhoto = f), onRemove: () => setState(() => carPhoto = null)),
            DocumentUploadTile(label: 'RC Front', file: rcFront, onPick: () => _pickSingle((f) => rcFront = f), onRemove: () => setState(() => rcFront = null)),
            DocumentUploadTile(label: 'RC Back', file: rcBack, onPick: () => _pickSingle((f) => rcBack = f), onRemove: () => setState(() => rcBack = null)),
            DocumentUploadTile(label: 'Aadhar Front', file: aadharFront, onPick: () => _pickSingle((f) => aadharFront = f), onRemove: () => setState(() => aadharFront = null)),
            DocumentUploadTile(label: 'Aadhar Back', file: aadharBack, onPick: () => _pickSingle((f) => aadharBack = f), onRemove: () => setState(() => aadharBack = null)),
            DocumentUploadTile(label: 'PAN Card', file: panCardPhoto, onPick: () => _pickSingle((f) => panCardPhoto = f), onRemove: () => setState(() => panCardPhoto = null)),
            DocumentUploadTile(label: 'Old Policy', file: oldPolicy, onPick: () => _pickSingle((f) => oldPolicy = f), onRemove: () => setState(() => oldPolicy = null)),
            DocumentUploadTile(label: 'Driving License', file: dlImg, onPick: () => _pickSingle((f) => dlImg = f), onRemove: () => setState(() => dlImg = null)),
            DocumentUploadTile(label: 'New Policy', file: newPolicy, onPick: () => _pickSingle((f) => newPolicy = f), onRemove: () => setState(() => newPolicy = null)),
            DocumentUploadTile(label: 'Pollution Photo', file: pollutionPhoto, onPick: () => _pickSingle((f) => pollutionPhoto = f), onRemove: () => setState(() => pollutionPhoto = null)),
          ],
        ),
        const SizedBox(height: 14),
        const Text('Additional Photos', style: TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13.5)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...carMultipleImages.asMap().entries.map((entry) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(entry.value, width: 72, height: 72, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: () => setState(() => carMultipleImages.removeAt(entry.key)),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: InsColors.error, shape: BoxShape.circle),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 13),
                        ),
                      ),
                    ),
                  ],
                )),
            InkWell(
              onTap: _pickMultiple,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: InsColors.bg, borderRadius: BorderRadius.circular(10), border: Border.all(color: InsColors.border)),
                child: const Icon(Icons.add_rounded, color: InsColors.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    final isLast = _stepIndex == _steps.length - 1;
    final onStep0WaitingForFetch = _stepIndex == 0 && !_lookupResolved;
    final isFetching = _fetchStatus == VehicleFetchStatus.checkingInternal || _fetchStatus == VehicleFetchStatus.checkingExternal;
    final blockedAsDuplicate = _stepIndex == 0 && _fetchStatus == VehicleFetchStatus.foundInternal;

    if (blockedAsDuplicate) {
      // **2026-10-22**: the wizard stops here for an already-registered
      // vehicle -- no Next/Submit, and (per the user's explicit request)
      // no navigation to the full record either, since any field worker
      // could otherwise type in an arbitrary plate and read another
      // agent's complete record. The only way forward is a different plate.
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(
          onPressed: _isLoading ? null : _resetLookup,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: const BorderSide(color: InsColors.border),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Try Another Vehicle', style: TextStyle(color: InsColors.textSecondary, fontWeight: FontWeight.w700)),
        ),
      );
    }

    String primaryLabel;
    VoidCallback? primaryAction;
    if (onStep0WaitingForFetch) {
      primaryLabel = _fetchStatus == VehicleFetchStatus.error ? 'Retry' : 'Fetch Details';
      primaryAction = (_isLoading || isFetching) ? null : _onFetchDetailsTapped;
    } else {
      primaryLabel = isLast ? 'Submit' : 'Next';
      primaryAction = (_isLoading || isFetching) ? null : _onNextPressed;
    }

    return Row(
      children: [
        if (_stepIndex > 0) ...[
          Expanded(
            child: OutlinedButton(
              onPressed: _isLoading ? null : _onBackPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: InsColors.border),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Back', style: TextStyle(color: InsColors.textSecondary, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(width: 12),
        ],
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: primaryAction,
            style: ElevatedButton.styleFrom(
              backgroundColor: InsColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: (_isLoading || isFetching)
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : Text(primaryLabel, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.5)),
          ),
        ),
      ],
    );
  }
}
