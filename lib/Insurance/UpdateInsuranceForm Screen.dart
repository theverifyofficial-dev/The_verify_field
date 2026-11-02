import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'InsuranceShowListPage.dart';
import '../utilities/heic_converter.dart';
import 'insurance_ui_kit.dart';

/// Update Insurance -- redesigned 2026-10-16 into a clean, sectioned
/// light-theme layout (per request: "the Update form also uses a clean,
/// sectioned layout so users can add these details later without
/// friction"). Unlike the Add form, this is NOT a forced step-by-step
/// wizard -- everything is editable on one scrollable page, grouped into
/// cards, since the whole point of deferring fields here is that the
/// user can fill in as much or as little as they want, in any order,
/// without being walked through steps again.
///
/// Holds every field the old Add/Update forms had between them: the
/// fields now required at creation (Full Name, Phone, Vehicle Number,
/// Policy Number, Insurance Provider, Policy Type) stay required there,
/// and everything the new Add form deferred (Email, Vehicle
/// Category/Type/Fuel, Nominee details, Claim/Pollution status, Policy
/// Expiry Date) lives in its own section below, all optional. The Policy
/// Expiry Date field existed before as a plain, unvalidated text field
/// with no date picker ever wired to it -- it now actually opens one.
/// All documents remain optional, with the same "upload / preview /
/// remove" pattern as the Add form, pre-filled from whatever the server
/// already has on file.
///
/// **2026-10-23:** Full Name and Primary Phone Number are no longer
/// editable here -- removed from both the UI and the submit request's
/// controller-driven fields -- since these identify the vehicle's owner
/// and shouldn't be changed after the record is created. `_submitForm()`
/// still sends `OWNER_NAME`/`MOBILE_NO` on every update, straight from
/// `widget.item` rather than a controller, same "send the existing
/// value so it's never blanked out" pattern `vehicleNumber` already
/// used below. Two new fields were added in their place: the person's
/// name for each alternate contact number (`extra_name`/`calling_name`,
/// alongside the existing `extra_number`/`calling_number`).
class UpdateInsuranceFormScreen extends StatefulWidget {
  final InsuranceModel item;

  const UpdateInsuranceFormScreen({super.key, required this.item});

  @override
  State<UpdateInsuranceFormScreen> createState() => _UpdateInsuranceFormScreenState();
}

class _UpdateInsuranceFormScreenState extends State<UpdateInsuranceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  bool isLoading = false;

  // **2026-10-22 migration + trim**: moved to the new table's backend
  // (same one the Add form and DB-first lookup already use -- see
  // "Vehicle_Info_API_Insurance_Redesign_Spec.md" §15), and trimmed down
  // to only the fields the field worker actually fills in by hand on the
  // Add form: Email, the two alternate-contact number/name pairs, and
  // Documents (2026-10-23: Name/Phone removed from this list -- see the
  // class doc comment above). Everything else this form used to collect
  // (Vehicle Number, Nominee details, Marital Status, Claim, Pollution
  // Yes/No, Policy Expiry Date, Vehicle Category/Type/Fuel) either isn't
  // a manually-entered field on the Add form at all, or is sourced from
  // the RTO lookup instead -- none of it belongs on an "edit what I
  // typed" form.
  //
  // `updateEndpointPath` confirmed 2026-10-22: real endpoint on the new
  // table's backend, takes the record's `id` (already sent below).
  static const String insuranceBaseUrl =
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/';
  static const String updateEndpointPath = 'update_insurance_api.php';

  // **2026-10-23**: the gallery (`car_images`) lives in its own separate
  // table on the backend -- `update_insurance_api.php` above can never
  // touch it, which is why adding/removing additional photos silently
  // did nothing. This dedicated, action-based endpoint is the real one
  // for that table: `action=add` (+ `sub_id`, one or more `car_images[]`
  // files) to add new photos to this record; `action=update` (+
  // `image_id`, a single `car_images` file) to replace one existing
  // photo in place; `action=delete` (+ `image_id`) to remove one.
  static const String multipleImageEndpointPath = 'multiple_image_update_api.php';

  // Insurance Yearly Documents -- a separate table/endpoint (2026-11-02)
  // for per-year claim/insured-value/document records a vehicle can
  // accumulate over time (one entry per renewal year, say). The user
  // gave this exact field list: vehicleNumber, policy_year,
  // claim_details, insured_value, pollution_pdf, old_policy_pdf,
  // insurance_pdf -- sent as one multipart POST per entry, same pattern
  // `insert_insurance.php`/`multiple_image_update_api.php` already use.
  // INSERT-ONLY: no GET/list capability was confirmed for this endpoint
  // (the user explicitly said to build it insert-only rather than guess
  // at a listing shape), so entries saved via `_saveYearlyDocument()`
  // below are only ever shown for the rest of THIS screen's lifetime --
  // `yearlyDocEntries` is in-memory only and starts empty again every
  // time this form is reopened. See the project doc's open questions.
  static const String yearlyDocumentEndpointPath = 'Insurance%20yearly%20documents%20api.php';

  // Owner Email -- manually filled on the Add form. Full Name and
  // Primary Phone Number used to live here too (as `nameController`/
  // `numberController`) -- removed 2026-10-23, see the class doc comment.
  final emailController = TextEditingController();

  // Nominee & additional details -- new table columns (2026-10-22), also
  // manually filled on the Add form, so they belong here too.
  final nomineeNameController = TextEditingController();
  final nomineeRelationController = TextEditingController();
  final nomineeAgeController = TextEditingController();
  final extraNumberController = TextEditingController();
  final callingNumberController = TextEditingController();
  // The person's name for each alternate contact number above --
  // `extra_name`/`calling_name` (2026-10-23, new API params).
  final extraNameController = TextEditingController();
  final callingNameController = TextEditingController();
  // 2026-10-29, Building/Flat insurance-linking feature: editable here so
  // a vehicle's property link can be corrected or added after creation,
  // same "optional, manually typed" treatment as every other field in
  // this Contact Details section.
  final buildingIdController = TextEditingController();
  final flatIdController = TextEditingController();
  String _claim = 'No';
  String? _maritalStatus;

  // Documents (optional) -- newly-picked local files, if any
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

  // Insurance Yearly Documents (2026-11-02) -- the sub-form that builds
  // one new entry at a time; `yearlyDocEntries` only ever holds entries
  // saved during this screen's current lifetime (see the endpoint-
  // constant comment above for why nothing is fetched back on open).
  final yearlyPolicyYearController = TextEditingController();
  final yearlyClaimDetailsController = TextEditingController();
  final yearlyInsuredValueController = TextEditingController();
  File? yearlyPollutionPdf;
  File? yearlyOldPolicyPdf;
  File? yearlyInsurancePdf;
  bool isSavingYearlyDoc = false;
  final List<_YearlyDocEntry> yearlyDocEntries = [];

  // Existing, already-uploaded gallery images (each with its own
  // server-side id, per InsuranceCarImage -- see
  // `multiple_image_update_api.php`'s note above). `deleteImageIds` and
  // `replaceImages` are applied via that API on Save, not immediately on
  // tap, so the user can still back out before hitting Save.
  List<InsuranceCarImage> serverImages = [];
  final Set<int> deleteImageIds = {};
  final Map<int, File> replaceImages = {};

  @override
  void initState() {
    super.initState();
    _prefillFromItem();
    _fetchMultipleImages();
  }

  @override
  void dispose() {
    emailController.dispose();
    nomineeNameController.dispose();
    nomineeRelationController.dispose();
    nomineeAgeController.dispose();
    extraNumberController.dispose();
    callingNumberController.dispose();
    extraNameController.dispose();
    callingNameController.dispose();
    buildingIdController.dispose();
    flatIdController.dispose();
    yearlyPolicyYearController.dispose();
    yearlyClaimDetailsController.dispose();
    yearlyInsuredValueController.dispose();
    super.dispose();
  }

  void _prefillFromItem() {
    final item = widget.item;
    emailController.text = item.emailId ?? '';
    nomineeNameController.text = item.nomineeName ?? '';
    nomineeRelationController.text = item.nomineeRelation ?? '';
    nomineeAgeController.text = item.nomineeAge ?? '';
    extraNumberController.text = item.extraNumber ?? '';
    callingNumberController.text = item.callingNumber ?? '';
    extraNameController.text = item.extraName ?? '';
    callingNameController.text = item.callingName ?? '';
    buildingIdController.text = item.buildingId ?? '';
    flatIdController.text = item.flatId ?? '';
    _claim = (item.claim == null || item.claim!.trim().isEmpty) ? 'No' : item.claim!;
    _maritalStatus = (item.maritalStatus == null || item.maritalStatus!.trim().isEmpty) ? null : item.maritalStatus;
  }

  /// **2026-10-22**: the new table's detail/list responses already
  /// return `car_images` directly on the record -- no separate "multiple
  /// images" endpoint exists on this backend (same note as
  /// `InsuranceDetail.dart`'s own migration), so this reads off
  /// `widget.item` instead of making a network call to an endpoint that
  /// belongs to the old table.
  void _fetchMultipleImages() {
    serverImages = widget.item.carImagesForEdit;
    if (mounted) setState(() {});
  }

  // 2026-11-02: every single-document tile now offers Camera/Gallery/
  // Browse Files (PDF) via the shared `pickInsuranceDocument()` sheet,
  // instead of always opening the Gallery picker directly.
  Future<void> _pickSingle(void Function(File) assign) async {
    final picked = await pickInsuranceDocument(context);
    if (picked != null && mounted) setState(() => assign(picked));
  }

  Future<void> _pickMultiple() async {
    final pickedFiles = await HeicConverter.pickMultiImage(picker, imageQuality: 75);
    if (pickedFiles.isNotEmpty && mounted) {
      setState(() => carMultipleImages.addAll(pickedFiles.map((e) => File(e.path))));
    }
  }

  /// Queues a replacement for one existing gallery image (`action=update`
  /// on Save). Only possible when the image actually has a server id --
  /// see `InsuranceCarImage`'s doc comment for when it might not. A
  /// pending delete for the same image is cleared since the two actions
  /// contradict each other.
  Future<void> _replaceExistingImage(InsuranceCarImage image) async {
    final id = image.id;
    if (id == null) return;
    final picked = await HeicConverter.pickImage(picker, source: ImageSource.gallery, imageQuality: 75);
    if (picked != null && mounted) {
      setState(() {
        replaceImages[id] = File(picked.path);
        deleteImageIds.remove(id);
      });
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$insuranceBaseUrl$updateEndpointPath'),
      );

      request.fields['id'] = widget.item.id.toString();
      // Full Name and Primary Phone Number are no longer editable on
      // this form (2026-10-23) -- same "keep sending whatever the record
      // already has so this update can never blank it out server-side"
      // reasoning `vehicleNumber` below already uses.
      request.fields['OWNER_NAME'] = widget.item.name ?? '';
      request.fields['MOBILE_NO'] = widget.item.number ?? '';
      request.fields['owner_email'] = emailController.text.trim();
      // Vehicle number isn't editable on this trimmed form (changing the
      // plate here would desync it from the RTO record already fetched
      // for it) -- keep sending whatever the record already has so this
      // update can never blank it out server-side.
      request.fields['vehicleNumber'] = widget.item.vehicleNumber ?? '';
      request.fields['Fieldworkar_name'] = widget.item.fieldWorkerName ?? '';
      request.fields['Fieldworkar_number'] = widget.item.fieldWorkerNumber ?? '';
      request.fields['claim'] = _claim;
      request.fields['Nominie_name'] = nomineeNameController.text.trim();
      request.fields['Nominie_relation'] = nomineeRelationController.text.trim();
      request.fields['Nominie_age'] = nomineeAgeController.text.trim();
      request.fields['Marital_status'] = _maritalStatus ?? '';
      request.fields['extra_number'] = extraNumberController.text.trim();
      request.fields['calling_number'] = callingNumberController.text.trim();
      request.fields['extra_name'] = extraNameController.text.trim();
      request.fields['calling_name'] = callingNameController.text.trim();
      request.fields['Building_id'] = buildingIdController.text.trim();
      request.fields['Flat_id'] = flatIdController.text.trim();

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

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      debugPrint('INSURANCE UPDATE RESPONSE (${response.statusCode}): $responseBody');

      if (response.statusCode == 200) {
        final addOk = await _addNewImages();
        final deleteOk = await _deleteQueuedImages();
        final replaceOk = await _replaceQueuedImages();
        if (!mounted) return;
        final imagesOk = addOk && deleteOk && replaceOk;
        _showSnack(imagesOk
            ? 'Updated successfully'
            : 'Updated, but one or more photo changes failed -- please retry those.');
        Navigator.pop(context, true);
      } else {
        _showSnack('Update failed (status ${response.statusCode}). Please try again.');
      }
    } catch (e) {
      _showSnack('Error: $e');
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  /// `action=add` -- one POST carrying every newly-picked local file at
  /// once (the API's `car_images[]` accepts more than one), keyed to
  /// this record via `sub_id`. No-ops if nothing was picked.
  Future<bool> _addNewImages() async {
    if (carMultipleImages.isEmpty) return true;
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$insuranceBaseUrl$multipleImageEndpointPath'));
      request.fields['action'] = 'add';
      request.fields['sub_id'] = widget.item.id.toString();
      for (final image in carMultipleImages) {
        request.files.add(await http.MultipartFile.fromPath('car_images[]', image.path));
      }
      final response = await request.send();
      debugPrint('IMAGE ADD RESPONSE (${response.statusCode})');
      return response.statusCode == 200;
    } catch (e) {
      debugPrint('Image add error: $e');
      return false;
    }
  }

  /// `action=delete` -- one POST per queued `image_id` (the API takes a
  /// single id, not a batch). No-ops if nothing was queued.
  Future<bool> _deleteQueuedImages() async {
    if (deleteImageIds.isEmpty) return true;
    var allOk = true;
    for (final id in deleteImageIds) {
      try {
        final request = http.MultipartRequest('POST', Uri.parse('$insuranceBaseUrl$multipleImageEndpointPath'));
        request.fields['action'] = 'delete';
        request.fields['image_id'] = id.toString();
        final response = await request.send();
        debugPrint('IMAGE DELETE RESPONSE ($id, ${response.statusCode})');
        if (response.statusCode != 200) allOk = false;
      } catch (e) {
        debugPrint('Image delete error ($id): $e');
        allOk = false;
      }
    }
    return allOk;
  }

  /// `action=update` -- one POST per queued replacement, each with its
  /// own `image_id` and a single (non-array) `car_images` file. No-ops
  /// if nothing was queued.
  Future<bool> _replaceQueuedImages() async {
    if (replaceImages.isEmpty) return true;
    var allOk = true;
    for (final entry in replaceImages.entries) {
      try {
        final request = http.MultipartRequest('POST', Uri.parse('$insuranceBaseUrl$multipleImageEndpointPath'));
        request.fields['action'] = 'update';
        request.fields['image_id'] = entry.key.toString();
        request.files.add(await http.MultipartFile.fromPath('car_images', entry.value.path));
        final response = await request.send();
        debugPrint('IMAGE UPDATE RESPONSE (${entry.key}, ${response.statusCode})');
        if (response.statusCode != 200) allOk = false;
      } catch (e) {
        debugPrint('Image update error (${entry.key}): $e');
        allOk = false;
      }
    }
    return allOk;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InsColors.bg,
      appBar: AppBar(
        backgroundColor: InsColors.surface,
        foregroundColor: InsColors.textPrimary,
        elevation: 0.5,
        title: const Text('Update Insurance', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
            children: [
              InsSectionCard(
                title: 'Contact Details',
                icon: Icons.person_outline_rounded,
                children: [
                  InsTextField(
                    label: 'Owner Email',
                    controller: emailController,
                    required: false,
                    keyboardType: TextInputType.emailAddress,
                    hint: 'owner@example.com',
                    validator: insEmailValidator,
                  ),
                  // Order per 2026-10-23 request: Calling Person (name,
                  // then number) first, then Alternate Person (name, then
                  // number) -- `callingNumber`/`callingName` map to the
                  // "Calling Person" pair, `extraNumber`/`extraName` to
                  // the "Alternate Person" pair.
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
                ],
              ),
              InsSectionCard(
                title: 'Property Linkage',
                icon: Icons.apartment_outlined,
                subtitle: 'Optional',
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InsTextField(
                          label: 'Building ID',
                          controller: buildingIdController,
                          required: false,
                          hint: 'Building id, if any',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: InsTextField(
                          label: 'Flat ID',
                          controller: flatIdController,
                          required: false,
                          hint: 'Flat id, if any',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
              _buildDocumentsSection(),
              _buildYearlyDocumentsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
          child: ElevatedButton(
            onPressed: isLoading ? null : _submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: InsColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15.5)),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentsSection() {
    final item = widget.item;
    return InsSectionCard(
      title: 'Documents',
      icon: Icons.folder_open_outlined,
      subtitle: 'Optional · tap to upload, tap the X to remove',
      children: [
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: [
            DocumentUploadTile(
              label: 'Vehicle Photo',
              file: carPhoto,
              existingUrl: item.carPhotoUrl,
              onPick: () => _pickSingle((f) => carPhoto = f),
              onRemove: () => setState(() => carPhoto = null),
            ),
            DocumentUploadTile(
              label: 'RC Front',
              file: rcFront,
              existingUrl: item.rcFrontUrl,
              onPick: () => _pickSingle((f) => rcFront = f),
              onRemove: () => setState(() => rcFront = null),
            ),
            DocumentUploadTile(
              label: 'RC Back',
              file: rcBack,
              existingUrl: item.rcBackUrl,
              onPick: () => _pickSingle((f) => rcBack = f),
              onRemove: () => setState(() => rcBack = null),
            ),
            DocumentUploadTile(
              label: 'Aadhar Front',
              file: aadharFront,
              existingUrl: item.aadharFrontUrl,
              onPick: () => _pickSingle((f) => aadharFront = f),
              onRemove: () => setState(() => aadharFront = null),
            ),
            DocumentUploadTile(
              label: 'Aadhar Back',
              file: aadharBack,
              existingUrl: item.aadharBackUrl,
              onPick: () => _pickSingle((f) => aadharBack = f),
              onRemove: () => setState(() => aadharBack = null),
            ),
            DocumentUploadTile(
              label: 'PAN Card',
              file: panCardPhoto,
              existingUrl: item.panCardPhotoUrl,
              onPick: () => _pickSingle((f) => panCardPhoto = f),
              onRemove: () => setState(() => panCardPhoto = null),
            ),
            DocumentUploadTile(
              label: 'Old Policy',
              file: oldPolicy,
              existingUrl: item.oldPolicyUrl,
              onPick: () => _pickSingle((f) => oldPolicy = f),
              onRemove: () => setState(() => oldPolicy = null),
            ),
            DocumentUploadTile(
              label: 'Driving License',
              file: dlImg,
              existingUrl: item.dlImgUrl,
              onPick: () => _pickSingle((f) => dlImg = f),
              onRemove: () => setState(() => dlImg = null),
            ),
            DocumentUploadTile(
              label: 'New Policy',
              file: newPolicy,
              existingUrl: item.newPolicyDocumentUrl,
              onPick: () => _pickSingle((f) => newPolicy = f),
              onRemove: () => setState(() => newPolicy = null),
            ),
            DocumentUploadTile(
              label: 'Pollution Photo',
              file: pollutionPhoto,
              existingUrl: item.pollutionPhotoUrl,
              onPick: () => _pickSingle((f) => pollutionPhoto = f),
              onRemove: () => setState(() => pollutionPhoto = null),
            ),
          ],
        ),
        const SizedBox(height: 14),
        const Text('Additional Photos', style: TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 13.5)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // Already-uploaded gallery images -- each goes through the
            // dedicated action-based image API on Save, not immediately
            // on tap, so the user can still back out before saving:
            // tapping the photo itself queues a replacement
            // (`action=update`, only possible when the image has a
            // server id -- see InsuranceCarImage), tapping the X queues
            // a deletion (`action=delete`) and clears any pending
            // replacement for the same image.
            ...serverImages.where((img) => !deleteImageIds.contains(img.id)).map((img) {
              final pendingReplacement = img.id != null ? replaceImages[img.id] : null;
              return Stack(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(10),
                    onTap: img.id == null ? null : () => _replaceExistingImage(img),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: pendingReplacement != null
                          ? Image.file(pendingReplacement, width: 72, height: 72, fit: BoxFit.cover)
                          : Image.network(
                              img.path,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                width: 72,
                                height: 72,
                                color: InsColors.bg,
                                child: const Icon(Icons.broken_image_outlined, color: InsColors.textMuted),
                              ),
                            ),
                    ),
                  ),
                  if (img.id != null)
                    Positioned(
                      top: -4,
                      right: -4,
                      child: InkWell(
                        onTap: () => setState(() {
                          deleteImageIds.add(img.id!);
                          replaceImages.remove(img.id);
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(color: InsColors.error, shape: BoxShape.circle),
                          child: const Icon(Icons.close_rounded, color: Colors.white, size: 13),
                        ),
                      ),
                    ),
                ],
              );
            }),
            ...carMultipleImages.asMap().entries.map((entry) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(entry.value, width: 72, height: 72, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: -4,
                      right: -4,
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

  // ------------------------------------------------------------------
  // Insurance Yearly Documents (2026-11-02)
  // ------------------------------------------------------------------

  Future<void> _pickYearlyDoc(void Function(File) assign) async {
    final picked = await pickInsuranceDocument(context);
    if (picked != null && mounted) setState(() => assign(picked));
  }

  /// Posts one Yearly Documents entry immediately (its own action,
  /// independent of the main "Save Changes" button below, per the
  /// user's explicit choice) to the dedicated endpoint, then appends it
  /// to the in-memory `yearlyDocEntries` list and clears the sub-form so
  /// another entry can be started right away. Requires at least a
  /// Policy Year -- everything else on this entry (claim details,
  /// insured value, the three PDFs) is optional, same "optional unless
  /// stated otherwise" convention every other field on this form uses.
  Future<void> _saveYearlyDocument() async {
    final year = yearlyPolicyYearController.text.trim();
    if (year.isEmpty) {
      _showSnack('Please enter the policy year before saving.');
      return;
    }
    setState(() => isSavingYearlyDoc = true);
    try {
      final request = http.MultipartRequest('POST', Uri.parse('$insuranceBaseUrl$yearlyDocumentEndpointPath'));
      request.fields['vehicleNumber'] = widget.item.vehicleNumber ?? '';
      request.fields['policy_year'] = year;
      request.fields['claim_details'] = yearlyClaimDetailsController.text.trim();
      request.fields['insured_value'] = yearlyInsuredValueController.text.trim();
      if (yearlyPollutionPdf != null) {
        request.files.add(await http.MultipartFile.fromPath('pollution_pdf', yearlyPollutionPdf!.path));
      }
      if (yearlyOldPolicyPdf != null) {
        request.files.add(await http.MultipartFile.fromPath('old_policy_pdf', yearlyOldPolicyPdf!.path));
      }
      if (yearlyInsurancePdf != null) {
        request.files.add(await http.MultipartFile.fromPath('insurance_pdf', yearlyInsurancePdf!.path));
      }
      final response = await request.send();
      debugPrint('YEARLY DOC SAVE RESPONSE (${response.statusCode})');
      if (response.statusCode == 200) {
        setState(() {
          yearlyDocEntries.add(_YearlyDocEntry(
            policyYear: year,
            claimDetails: yearlyClaimDetailsController.text.trim(),
            insuredValue: yearlyInsuredValueController.text.trim(),
            hasPollutionPdf: yearlyPollutionPdf != null,
            hasOldPolicyPdf: yearlyOldPolicyPdf != null,
            hasInsurancePdf: yearlyInsurancePdf != null,
          ));
          yearlyPolicyYearController.clear();
          yearlyClaimDetailsController.clear();
          yearlyInsuredValueController.clear();
          yearlyPollutionPdf = null;
          yearlyOldPolicyPdf = null;
          yearlyInsurancePdf = null;
        });
        _showSnack('Yearly document saved.');
      } else {
        _showSnack('Save failed (status ${response.statusCode}). Please try again.');
      }
    } catch (e) {
      _showSnack('Error: $e');
    } finally {
      if (mounted) setState(() => isSavingYearlyDoc = false);
    }
  }

  Widget _buildYearlyDocumentsSection() {
    String _docsSummary(_YearlyDocEntry e) {
      final names = <String>[
        if (e.hasPollutionPdf) 'Pollution',
        if (e.hasOldPolicyPdf) 'Old Policy',
        if (e.hasInsurancePdf) 'Insurance',
      ];
      return names.isEmpty ? 'No documents attached' : 'Docs: ${names.join(', ')}';
    }

    return InsSectionCard(
      title: 'Yearly Documents',
      icon: Icons.event_note_outlined,
      subtitle: 'Optional \u00b7 saved separately, per year',
      children: [
        if (yearlyDocEntries.isNotEmpty) ...[
          ...yearlyDocEntries.map((e) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: InsColors.bg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: InsColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.check_circle_rounded, color: InsColors.success, size: 16),
                        const SizedBox(width: 6),
                        Text('Policy Year ${e.policyYear}', style: const TextStyle(color: InsColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 12.5)),
                      ],
                    ),
                    if (e.claimDetails.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('Claim: ${e.claimDetails}', style: const TextStyle(color: InsColors.textSecondary, fontSize: 11.5)),
                      ),
                    if (e.insuredValue.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text('Insured Value: ${e.insuredValue}', style: const TextStyle(color: InsColors.textSecondary, fontSize: 11.5)),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(_docsSummary(e), style: const TextStyle(color: InsColors.textMuted, fontSize: 10.5)),
                    ),
                  ],
                ),
              )),
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Saved this session \u2014 reopening this form won't show these again (no fetch endpoint yet).",
              style: TextStyle(color: InsColors.textMuted, fontSize: 10, fontStyle: FontStyle.italic),
            ),
          ),
        ],
        InsTextField(
          label: 'Policy Year',
          controller: yearlyPolicyYearController,
          required: false,
          keyboardType: TextInputType.number,
          maxLength: 4,
          hint: 'e.g. 2026',
        ),
        InsTextField(
          label: 'Claim Details',
          controller: yearlyClaimDetailsController,
          required: false,
          maxLines: 3,
          hint: 'Describe any claim made this year, if any',
        ),
        InsTextField(
          label: 'Insured Value',
          controller: yearlyInsuredValueController,
          required: false,
          keyboardType: TextInputType.number,
          hint: 'Insured Declared Value (IDV)',
        ),
        const SizedBox(height: 4),
        // 2026-11-02 fix: a 3-column, 0.82-aspect-ratio grid gave each
        // DocumentUploadTile roughly half the height the proven-safe
        // 9-tile Documents grid above gives it (crossAxisCount: 2,
        // childAspectRatio: 0.95) -- not enough room for its empty-state
        // Column (icon + up to 2-line label + "Tap to upload" + subtitle),
        // causing a real RenderFlex "overflowed by 24 pixels on the
        // bottom" at insurance_ui_kit.dart:1548 (DocumentUploadTile's
        // empty-state Column). Matched to that exact safe configuration
        // instead -- 2 columns, same aspect ratio -- so the third tile
        // simply wraps to its own row.
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.95,
          children: [
            DocumentUploadTile(
              label: 'Pollution PDF',
              file: yearlyPollutionPdf,
              subtitle: 'Photo or PDF',
              onPick: () => _pickYearlyDoc((f) => yearlyPollutionPdf = f),
              onRemove: () => setState(() => yearlyPollutionPdf = null),
            ),
            DocumentUploadTile(
              label: 'Old Policy PDF',
              file: yearlyOldPolicyPdf,
              subtitle: 'Photo or PDF',
              onPick: () => _pickYearlyDoc((f) => yearlyOldPolicyPdf = f),
              onRemove: () => setState(() => yearlyOldPolicyPdf = null),
            ),
            DocumentUploadTile(
              label: 'Insurance PDF',
              file: yearlyInsurancePdf,
              subtitle: 'Photo or PDF',
              onPick: () => _pickYearlyDoc((f) => yearlyInsurancePdf = f),
              onRemove: () => setState(() => yearlyInsurancePdf = null),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: isSavingYearlyDoc ? null : _saveYearlyDocument,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: InsColors.primary),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: isSavingYearlyDoc
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Add Yearly Document', style: TextStyle(color: InsColors.primary, fontWeight: FontWeight.w700)),
          ),
        ),
      ],
    );
  }
}

/// One Yearly Documents entry already saved to the backend this session
/// (2026-11-02) -- display-only summary of what was POSTed, since the
/// endpoint is insert-only and nothing is fetched back to repopulate
/// this list on a fresh open of the form. See `yearlyDocumentEndpointPath`'s
/// doc comment above for the full rationale.
class _YearlyDocEntry {
  final String policyYear;
  final String claimDetails;
  final String insuredValue;
  final bool hasPollutionPdf;
  final bool hasOldPolicyPdf;
  final bool hasInsurancePdf;

  _YearlyDocEntry({
    required this.policyYear,
    required this.claimDetails,
    required this.insuredValue,
    required this.hasPollutionPdf,
    required this.hasOldPolicyPdf,
    required this.hasInsurancePdf,
  });
}
