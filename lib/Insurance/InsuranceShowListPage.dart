import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Insurance Form Screen.dart';
import 'InsuranceDetail.dart';
import 'insurance_ui_kit.dart';
import '../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';

// **2026-10-22 migration**: the Add form (`Insurance Form Screen.dart`)
// and the DB-first vehicle lookup (`insurance_ui_kit.dart`) have been on
// this NEW table/backend since the 2026-10-22 realignment -- this list
// screen (and the Detail/Update screens, which share this constant via
// their own imports) were still pointed at the OLD table's base URL,
// which is why newly-added records showed up mostly blank: they exist
// only in the new table, never in the old one. See
// "Vehicle_Info_API_Insurance_Redesign_Spec.md" §15 for the full note.
const String insuranceBaseUrl =
    "https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/";

/// One row of the gallery (`car_images`) on the new table --
/// `multiple_image_update_api.php` (2026-10-23) confirmed each image has
/// its own server-side id, so the response shape is `{id, car_images}`
/// objects, not plain path strings as an earlier pass assumed -- the
/// path's own key, confusingly, is ALSO `car_images` (confirmed by a
/// real sample 2026-10-23), not `image`/`path` as first guessed, which
/// is why the gallery showed broken/blank images until this was fixed.
/// The `id` is what the Update form needs to target a specific existing
/// image with that API's `update`/`delete` actions; `path` is the raw
/// relative path as returned (resolve to a URL via
/// `InsuranceModel._buildUrl`/`carImagesForEdit`, same as every other
/// document field on this model).
class InsuranceCarImage {
  final int? id;
  final String path;

  const InsuranceCarImage({required this.id, required this.path});

  factory InsuranceCarImage.fromJson(dynamic e) {
    if (e is Map) {
      final rawId = e['id'] ?? e['image_id'];
      final id = rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '');
      // Confirmed 2026-10-23 by a real sample: each element's path key
      // is literally `car_images` again (same name as the array itself) --
      // {"id": 3, "car_images": "insurance_uploads/<hash>.jpg"} -- which is
      // why this was showing broken/blank gallery images before: none of
      // the other guessed key names matched, so `path` fell through to ''.
      final path = (e['car_images'] ?? e['image'] ?? e['path'] ?? e['car_image'] ?? e['file'] ?? '').toString();
      return InsuranceCarImage(id: id, path: path);
    }
    // Defensive fallback for a legacy/bare-string row (shouldn't happen
    // on the new table per the confirmed `{id, image}` shape, but keeps
    // a stray plain string displayable rather than crashing) -- with no
    // id, it simply can't be targeted by update/delete (see doc note).
    return InsuranceCarImage(id: null, path: e.toString());
  }
}

class InsuranceModel {
  final int id;
  final String? name;
  final String? number;
  final String? vehicleNumber;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? nextRenewDate;
  final String? aadharFront;
  final String? aadharBack;
  final String? rcFront;
  final String? rcBack;
  final String? oldPolicyDocument;
  final String? dlImg; // Driving License photo -- DL_img (added 2026-10-23)
  final String? newPolicyDocument; // new_policy_docement (added 2026-10-23)
  final String? emailId;
  final String? claim;
  final String? fuelType;
  final String? carPhoto;
  final String? registrationDate;
  final String? pollutionDate;
  final String? pollutionYesNo;     // ✅ NEW
  final String? pollutionPhoto;     // ✅ NEW
  final String? nomineeName;
  final String? nomineeRelation;
  final String? nomineeAge;
  final String? maritalStatus;
  final String? vehicle_category;
  final String? vehicleType;
  final String? current_dates;
  final String? pan_card_photo;

  // Vehicle Info API (RTO Sarthi) -- real backend field names (2026-10-22)
  final String? rtoOwnerName;
  final String? rtoFatherName;
  final String? rtoPresentAddress;
  final String? rtoPermanentAddress;
  final String? rtoMobileNo;
  final String? rtoOwnerEmail;
  final String? rtoOwnerSerialNo;
  final String? rtoCurrentAddStateName;
  final String? rtoCurrentAddDistrictCode;
  final String? rtoCurrentAddPincode;
  final String? chasiNo;
  final String? engineNo;
  final String? makerDesc;
  final String? makerModel;
  final String? bodyTypeDesc;
  final String? rtoVehicleClass;
  final String? rtoVehicleCategory;
  final String? rtoIsCommercial;
  final String? fuelDesc;
  final String? vehicleColor;
  final String? manuMonthYr;
  final String? rtoVehicleSurrenderedToDealer;
  final String? regnNo;
  final String? regnDt;
  final String? regnUpto;
  final String? registeredAt;
  final String? stateCd;
  final String? rtoCd;
  final String? rcNpNo;
  final String? fitUpto;
  final String? taxUpto;
  final String? rtoStatus;
  final String? statusAsOn;
  final String? insuranceComp;
  final String? policyNo;
  final String? insPolicyNo;
  final String? insuranceUpto;
  final String? pucUpto;
  final String? puccUpto;
  final String? puccNo;
  final String? permitNo;
  final String? permitIssueDate;
  final String? financerDetails;
  final String? seatingCapacity;
  final String? sleeperCapacity;
  final String? standingCapacity;
  final String? unladenWeight;
  final String? ladenWeight;
  final String? wheelbase;
  final String? noOfCylinders;
  final String? cubicCapacity;
  final String? fuelNorms;
  final String? blacklistStatus;
  final String? nocDetails;
  final List<InsuranceCarImage>? carImages; // gallery rows (id + raw relative path) from the new table's `car_images` list

  // New table columns (2026-10-22) -- manually filled by the field worker
  // on the Add form, same as name/number/email.
  final String? extraNumber;
  final String? callingNumber;
  // The person's name for each alternate contact number above --
  // `extra_name`/`calling_name` (2026-10-23, new API params; manually
  // typed by the field worker, same as the numbers themselves).
  final String? extraName;
  final String? callingName;

  // 2026-10-29: building/flat linkage (Add Vehicle from a Building/Flat
  // Detail page). Nullable -- a building-level vehicle has buildingId
  // set and flatId null; a flat-level vehicle has both set.
  final String? buildingId;
  final String? flatId;

  InsuranceModel({
    required this.id,
    this.name,
    this.number,
    this.vehicleNumber,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.nextRenewDate,
    this.aadharFront,
    this.aadharBack,
    this.rcFront,
    this.rcBack,
    this.oldPolicyDocument,
    this.dlImg,
    this.newPolicyDocument,
    this.emailId,
    this.claim,
    this.fuelType,
    this.vehicleType,
    this.carPhoto,
    this.registrationDate,
    this.pollutionDate,
    this.pollutionYesNo,
    this.pollutionPhoto,
    this.nomineeName,
    this.nomineeRelation,
    this.nomineeAge,
    this.maritalStatus,
    this.current_dates,
    this.pan_card_photo,
    this.vehicle_category,
    this.rtoOwnerName,
    this.rtoFatherName,
    this.rtoPresentAddress,
    this.rtoPermanentAddress,
    this.rtoMobileNo,
    this.rtoOwnerEmail,
    this.rtoOwnerSerialNo,
    this.rtoCurrentAddStateName,
    this.rtoCurrentAddDistrictCode,
    this.rtoCurrentAddPincode,
    this.chasiNo,
    this.engineNo,
    this.makerDesc,
    this.makerModel,
    this.bodyTypeDesc,
    this.rtoVehicleClass,
    this.rtoVehicleCategory,
    this.rtoIsCommercial,
    this.fuelDesc,
    this.vehicleColor,
    this.manuMonthYr,
    this.rtoVehicleSurrenderedToDealer,
    this.regnNo,
    this.regnDt,
    this.regnUpto,
    this.registeredAt,
    this.stateCd,
    this.rtoCd,
    this.rcNpNo,
    this.fitUpto,
    this.taxUpto,
    this.rtoStatus,
    this.statusAsOn,
    this.insuranceComp,
    this.policyNo,
    this.insPolicyNo,
    this.insuranceUpto,
    this.pucUpto,
    this.puccUpto,
    this.puccNo,
    this.permitNo,
    this.permitIssueDate,
    this.financerDetails,
    this.seatingCapacity,
    this.sleeperCapacity,
    this.standingCapacity,
    this.unladenWeight,
    this.ladenWeight,
    this.wheelbase,
    this.noOfCylinders,
    this.cubicCapacity,
    this.fuelNorms,
    this.blacklistStatus,
    this.nocDetails,
    this.carImages,
    this.extraNumber,
    this.callingNumber,
    this.extraName,
    this.callingName,
    this.buildingId,
    this.flatId,
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      // `name`/`number`/`email` are never separate columns on the new
      // table -- the field worker fills them manually on the Add form and
      // they're submitted (and stored) AS the RTO fields `OWNER_NAME`,
      // `MOBILE_NO`, `owner_email` directly (see `Insurance Form
      // Screen.dart`'s `_submitForm`) -- so that's what's read back here
      // too, instead of the old table's separate `name_`/`number`/
      // `email_id` columns, which this new table doesn't have.
      id: json['id'] ?? 0,
      name: json['OWNER_NAME'],
      number: json['MOBILE_NO'],
      vehicleNumber: json['vehicleNumber'],
      fieldWorkerName: json['Fieldworkar_name'],
      fieldWorkerNumber: json['Fieldworkar_number'],
      nextRenewDate: json['next_renew_date'],
      aadharFront: json['Aadhar_front'],
      aadharBack: json['Aadhar_back'],
      rcFront: json['Rc_front'],
      rcBack: json['Rc_back'],
      oldPolicyDocument: json['old_policy_docement'],
      dlImg: json['DL_img'],
      newPolicyDocument: json['new_policy_docement'],
      emailId: json['owner_email'],
      claim: json['claim'],
      fuelType: json['petrol_desiel'],
      carPhoto: json['car_photo'],
      registrationDate: json['Ragistaion_Date'],
      pollutionDate: json['Pollution_date'],
      pollutionYesNo: json['polution_yes_no'],   // ✅ NEW
      pollutionPhoto: json['polution_photo'],    // ✅ NEW
      nomineeName: json['Nominie_name'],
      nomineeRelation: json['Nominie_relation'],
      nomineeAge: json['Nominie_age'],
      maritalStatus: json['Marital_status'],
      vehicle_category: json['vehicle_category'],
      vehicleType: json['vehicle_type'],
      // **2026-10-22**: the new table's confirmed JSON sample never
      // showed a `current_dates` key, which is why the List card's
      // "Created: ..." line was rendering blank -- falling back to
      // the common Laravel-style `created_at`/`createdAt` names this
      // backend uses elsewhere (see OwnerCallHistory/BuildingHistory
      // models) in case the new table actually returns one of those.
      current_dates: json['current_dates'] ?? json['created_at'] ?? json['createdAt'],
      pan_card_photo: json['pan_card_photo'],
      rtoOwnerName: json['OWNER_NAME'],
      rtoFatherName: json['F_NAME'],
      rtoPresentAddress: json['PRESENT_ADDRESS'],
      rtoPermanentAddress: json['PERMANENT_ADDRESS'],
      rtoMobileNo: json['MOBILE_NO'],
      rtoOwnerEmail: json['owner_email'],
      rtoOwnerSerialNo: json['OWNER_SERIAL_NO'],
      rtoCurrentAddStateName: json['CURRENTADD_STATENAME'],
      rtoCurrentAddDistrictCode: json['CURRENTADD_DISTRICTCODE'],
      rtoCurrentAddPincode: json['CURRENTADD_PINCODE'],
      chasiNo: json['CHASI_NO'],
      engineNo: json['ENG_NO'],
      makerDesc: json['MAKER_DESC'],
      makerModel: json['MAKER_MODEL'],
      bodyTypeDesc: json['BODY_TYPE_DESC'],
      rtoVehicleClass: json['VEHICLE_CLASS'],
      rtoVehicleCategory: json['VEHICLE_CATEGORY'],
      rtoIsCommercial: json['IS_COMMERCIAL'],
      fuelDesc: json['FUEL_DESC'],
      vehicleColor: json['COLOR'],
      manuMonthYr: json['MANU_MONTH_YR'],
      rtoVehicleSurrenderedToDealer: json['VEHICLE_SURRENDERED_TO_DEALER'],
      regnNo: json['REGN_NO'],
      regnDt: json['REGN_DT'],
      regnUpto: json['REGN_UPTO'],
      registeredAt: json['REGISTERED_AT'],
      stateCd: json['STATE_CD'],
      rtoCd: json['RTO_CD'],
      rcNpNo: json['RC_NP_NO'],
      fitUpto: json['FIT_UPTO'],
      taxUpto: json['TAX_UPTO'],
      rtoStatus: json['STATUS'],
      statusAsOn: json['STATUS_AS_ON'],
      insuranceComp: json['INSURANCE_COMP'],
      policyNo: json['POLICY_NO'],
      insPolicyNo: json['INS_POLICY_NO'],
      insuranceUpto: json['INSURANCE_UPTO'],
      pucUpto: json['PUC_UPTO'],
      puccUpto: json['PUCC_UPTO'],
      puccNo: json['PUCC_NO'],
      permitNo: json['PERMIT_NO'],
      permitIssueDate: json['PERMIT_ISSUE_DATE'],
      financerDetails: json['FINANCER_DETAILS'],
      seatingCapacity: json['SEATING_CAPACITY'],
      sleeperCapacity: json['SLEEPER_CAPACITY'],
      standingCapacity: json['STANDING_CAPACITY'],
      unladenWeight: json['UNLADEN_WEIGHT'],
      ladenWeight: json['LADEN_WEIGHT'],
      wheelbase: json['WHEELBASE'],
      noOfCylinders: json['NO_OF_CYLINDERS'],
      cubicCapacity: json['CUBIC_CAPACITY'],
      fuelNorms: json['FUEL_NORMS'],
      blacklistStatus: json['BLACKLIST_STATUS'],
      nocDetails: json['NOC_DETAILS'],
      carImages: (json['car_images'] as List?)?.map((e) => InsuranceCarImage.fromJson(e)).toList(),
      extraNumber: json['extra_number'],
      callingNumber: json['calling_number'],
      extraName: json['extra_name'],
      callingName: json['calling_name'],
      // 2026-10-29: exact response key casing unconfirmed against a real
      // sample -- assumed to match the two given query-param names
      // ("Building_id"/"Flat_id") since this backend often echoes the
      // same casing it was given. toString() defensively handles either
      // an int or a string coming back. See the project doc's open
      // questions if this needs correcting later.
      buildingId: (json['Building_id'] ?? json['building_id'])?.toString(),
      flatId: (json['Flat_id'] ?? json['flat_id'])?.toString(),
    );
  }

  /// ================= IMAGE URL HELPERS =================

  String? get carPhotoUrl => _buildUrl(carPhoto);
  String? get aadharFrontUrl => _buildUrl(aadharFront);
  String? get aadharBackUrl => _buildUrl(aadharBack);
  String? get rcFrontUrl => _buildUrl(rcFront);
  String? get rcBackUrl => _buildUrl(rcBack);
  String? get oldPolicyUrl => _buildUrl(oldPolicyDocument);
  String? get dlImgUrl => _buildUrl(dlImg);
  String? get newPolicyDocumentUrl => _buildUrl(newPolicyDocument);

  /// True when this record is linked to a building (building-level OR
  /// flat-level vehicle -- flat-level vehicles always carry their
  /// parent's buildingId too, per the Add Vehicle flow).
  bool get hasBuildingLink =>
      buildingId != null && buildingId!.trim().isNotEmpty && buildingId!.trim() != '0';

  /// True only for a flat-level vehicle.
  bool get hasFlatLink =>
      flatId != null && flatId!.trim().isNotEmpty && flatId!.trim() != '0';
  String? get panCardPhotoUrl => _buildUrl(pan_card_photo); // ✅ PAN added
  String? get pollutionPhotoUrl => _buildUrl(pollutionPhoto); // ✅ NEW

  /// Plain resolved URLs, no ids -- for read-only display (the Detail
  /// page's gallery, which never edits/deletes a specific image).
  List<String> get carImageUrls =>
      (carImages ?? const []).map((img) => _buildUrl(img.path)).whereType<String>().toList();

  /// Resolved URLs WITH each image's server id preserved -- for the
  /// Update form, which needs the id to call `multiple_image_update_api.php`'s
  /// `update`/`delete` actions on one specific existing image. An image
  /// whose id came back null (the legacy fallback in
  /// `InsuranceCarImage.fromJson`) still appears here so it's visible,
  /// just with `id == null` -- the Update form disables replace/delete
  /// for those since the API has nothing to target.
  List<InsuranceCarImage> get carImagesForEdit => (carImages ?? const [])
      .map((img) => InsuranceCarImage(id: img.id, path: _buildUrl(img.path) ?? img.path))
      .toList();

  String? _buildUrl(String? path) {
    if (path == null || path.isEmpty) return null;

    if (path.startsWith("http")) return path;

    return insuranceBaseUrl + path;
  }

  Map<String, dynamic> toVehicleInfoMap() => {
    'OWNER_NAME': rtoOwnerName,
    'F_NAME': rtoFatherName,
    'PRESENT_ADDRESS': rtoPresentAddress,
    'PERMANENT_ADDRESS': rtoPermanentAddress,
    'MOBILE_NO': rtoMobileNo,
    'owner_email': rtoOwnerEmail,
    'OWNER_SERIAL_NO': rtoOwnerSerialNo,
    'CURRENTADD_STATENAME': rtoCurrentAddStateName,
    'CURRENTADD_DISTRICTCODE': rtoCurrentAddDistrictCode,
    'CURRENTADD_PINCODE': rtoCurrentAddPincode,
    'CHASI_NO': chasiNo,
    'ENG_NO': engineNo,
    'MAKER_DESC': makerDesc,
    'MAKER_MODEL': makerModel,
    'BODY_TYPE_DESC': bodyTypeDesc,
    'VEHICLE_CLASS': rtoVehicleClass,
    'VEHICLE_CATEGORY': rtoVehicleCategory,
    'IS_COMMERCIAL': rtoIsCommercial,
    'FUEL_DESC': fuelDesc,
    'COLOR': vehicleColor,
    'MANU_MONTH_YR': manuMonthYr,
    'VEHICLE_SURRENDERED_TO_DEALER': rtoVehicleSurrenderedToDealer,
    'REGN_NO': regnNo,
    'REGN_DT': regnDt,
    'REGN_UPTO': regnUpto,
    'REGISTERED_AT': registeredAt,
    'STATE_CD': stateCd,
    'RTO_CD': rtoCd,
    'RC_NP_NO': rcNpNo,
    'FIT_UPTO': fitUpto,
    'TAX_UPTO': taxUpto,
    'STATUS': rtoStatus,
    'STATUS_AS_ON': statusAsOn,
    'INSURANCE_COMP': insuranceComp,
    'POLICY_NO': policyNo,
    'INS_POLICY_NO': insPolicyNo,
    'INSURANCE_UPTO': insuranceUpto,
    'PUC_UPTO': pucUpto,
    'PUCC_UPTO': puccUpto,
    'PUCC_NO': puccNo,
    'PERMIT_NO': permitNo,
    'PERMIT_ISSUE_DATE': permitIssueDate,
    'FINANCER_DETAILS': financerDetails,
    'SEATING_CAPACITY': seatingCapacity,
    'SLEEPER_CAPACITY': sleeperCapacity,
    'STANDING_CAPACITY': standingCapacity,
    'UNLADEN_WEIGHT': unladenWeight,
    'LADEN_WEIGHT': ladenWeight,
    'WHEELBASE': wheelbase,
    'NO_OF_CYLINDERS': noOfCylinders,
    'CUBIC_CAPACITY': cubicCapacity,
    'FUEL_NORMS': fuelNorms,
    'BLACKLIST_STATUS': blacklistStatus,
    'NOC_DETAILS': nocDetails,
  };

  bool get hasRtoVehicleInfo =>
      (chasiNo?.trim().isNotEmpty ?? false) ||
      (regnNo?.trim().isNotEmpty ?? false) ||
      (rtoOwnerName?.trim().isNotEmpty ?? false);
}

class InsuranceResponse {
  final String status;
  final int count;
  final List<InsuranceModel> data;

  InsuranceResponse({
    required this.status,
    required this.count,
    required this.data,
  });

  factory InsuranceResponse.fromJson(Map<String, dynamic> json) {
    return InsuranceResponse(
      status: json['status'],
      count: json['count'],
      data: (json['data'] as List)
          .map((e) => InsuranceModel.fromJson(e))
          .toList(),
    );
  }
}

/// Field-worker's own Insurance list -- redesigned 2026-10-16 into the
/// same light theme as the Add/Update forms (`insurance_ui_kit.dart`),
/// replacing the old gold/indigo "premium" look. Behavior kept the same
/// as before (client-side search by name/vehicle number/ID, same fetch
/// endpoint, same navigation targets) except:
/// - `_missingFieldsFor` now checks the 6 fields that are ACTUALLY
///   required since the form redesign (Full Name, Phone, Vehicle
///   Number, Policy Number, Insurance Provider, Policy Type) instead of
///   the old list, which flagged now-optional fields (email, nominee
///   details, pollution status) as "missing" -- that stopped being
///   accurate once those fields moved to the Update form as optional.
/// - The "Quotations" pill (which navigated to the PDF Quotations
///   screen, not `InsuranceDetailScreen`) is removed (2026-10-23):
///   tapping a card still opens `InsuranceDetailScreen`, same as
///   before -- it was the only extra tap target on the card, and any
///   field worker could use it to pull up another agent's quotation
///   history for a plate they merely typed in or guessed. It is
///   replaced with a colour-coded active/near-to-expire/expired badge
///   computed from `INSURANCE_UPTO`, and a matching
///   `InsuranceStatusFilterBar` row of tabs sits below the search field
///   so the list can be narrowed by that same status.
class InsuranceListScreen extends StatefulWidget {
  final String? fieldWorkerNumber;
  final String? fieldWorkerName;

  const InsuranceListScreen({
    super.key,
    this.fieldWorkerNumber,
    this.fieldWorkerName,
  });

  @override
  State<InsuranceListScreen> createState() => _InsuranceListScreenState();
}

class _InsuranceListScreenState extends State<InsuranceListScreen> {
  final TextEditingController searchController = TextEditingController();
  List<InsuranceModel> insuranceList = [];
  List<InsuranceModel> filteredList = [];
  bool isLoading = true;
  // null means "All" -- see InsuranceStatusFilterBar.
  InsuranceExpiryStatus? _statusFilter;

  @override
  void initState() {
    super.initState();
    fetchInsurance();
    searchController.addListener(_filterList);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  bool _blank(String? v) => v == null || v.trim().isEmpty;

  List<String> _missingFieldsFor(InsuranceModel i) {
    final checks = <String, String?>{
      'Full Name': i.name,
      'Phone Number': i.number,
      'Vehicle Number': i.vehicleNumber,
    };
    return checks.entries.where((e) => _blank(e.value)).map((e) => e.key).toList();
  }

  void _filterList() => _applyFilters();

  /// Applies both the text search and the status-tab filter together,
  /// so narrowing by status doesn't lose the typed search query (and
  /// vice versa).
  void _applyFilters() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      filteredList = insuranceList.where((item) {
        if (_statusFilter != null && insuranceExpiryStatusFor(item.insuranceUpto) != _statusFilter) {
          return false;
        }
        if (query.isEmpty) return true;
        final name = item.name?.toLowerCase() ?? '';
        final vehicle = item.vehicleNumber?.toLowerCase() ?? '';
        final number = item.number?.toLowerCase() ?? '';
        final id = item.id.toString();
        return name.contains(query) || vehicle.contains(query) || number.contains(query) || id.contains(query);
      }).toList();
    });
  }

  Future<void> fetchInsurance() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          '${insuranceBaseUrl}show_api_fieldworkar_number.php?Fieldworkar_number=${widget.fieldWorkerNumber}'));
      final decoded = jsonDecode(response.body);
      if (decoded['status'] == true) {
        insuranceList = (decoded['data'] as List).map((e) => InsuranceModel.fromJson(e)).toList();
      }
    } catch (e) {
      debugPrint('Insurance list fetch error: $e');
    }
    if (mounted) setState(() => isLoading = false);
    _applyFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InsColors.bg,
      appBar: AppBar(
        backgroundColor: InsColors.surface,
        foregroundColor: InsColors.textPrimary,
        elevation: 0.5,
        title: const Text('My Insurances', style: TextStyle(fontWeight: FontWeight.w700)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: InsColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Insurance', style: TextStyle(fontWeight: FontWeight.w700)),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => InsuranceFormScreen(
                fieldWorkerName: widget.fieldWorkerName ?? '',
                fieldWorkerNumber: widget.fieldWorkerNumber ?? '',
              ),
            ),
          );
          fetchInsurance();
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Column(
            children: [
              InsSearchField(controller: searchController, onClear: () => searchController.clear()),
              const SizedBox(height: 10),
              InsuranceStatusFilterBar(
                selected: _statusFilter,
                onChanged: (status) {
                  setState(() => _statusFilter = status);
                  _applyFilters();
                },
              ),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Total Records: ${filteredList.length}',
                  style: const TextStyle(color: InsColors.textSecondary, fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator(color: InsColors.primary))
                    : filteredList.isEmpty
                        ? Center(
                            child: Text(
                              insuranceList.isEmpty ? 'No insurance records yet.' : 'No records match your search.',
                              style: const TextStyle(color: InsColors.textSecondary),
                            ),
                          )
                        : RefreshIndicator(
                            color: InsColors.primary,
                            onRefresh: fetchInsurance,
                            child: ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (context, index) => _buildCard(filteredList[index]),
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Vehicle model name shown on the list card in place of the old
  // "Via Registry" badge (2026-10-23 request). Prefers the specific
  // model (MAKER_MODEL, e.g. "THAR LX D AT 4WD 4S HT") and falls back
  // to the manufacturer name (MAKER_DESC) when no model is on file;
  // truncated so a long RTO description never breaks the card layout.
  String? _vehicleModelLabel(InsuranceModel item) {
    final model = item.makerModel?.trim();
    final maker = item.makerDesc?.trim();
    String? label;
    if (model != null && model.isNotEmpty) {
      label = model;
    } else if (maker != null && maker.isNotEmpty) {
      label = maker;
    }
    if (label == null || label.isEmpty) return null;
    return label.length > 28 ? '${label.substring(0, 28).trim()}\u2026' : label;
  }

  Widget _buildCard(InsuranceModel item) {
    final missing = _missingFieldsFor(item);
    return InsuranceListCard(
      id: item.id,
      name: item.name,
      vehicleNumber: item.vehicleNumber,
      carPhotoUrl: item.carPhotoUrl,
      missingCount: missing.length,
      vehicleModelLabel: _vehicleModelLabel(item),
      insuranceUpto: item.insuranceUpto,
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InsuranceDetailScreen(insuranceId: item.id)),
      ).then((_) => fetchInsurance()),
      // 2026-10-29, Building/Flat insurance-linking feature: "Go to
      // Building"/"Go to Flat" chips, shown only when this record actually
      // carries a linked id.
      onGoToBuilding: item.hasBuildingLink
          ? () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Future_Property_details(idd: item.buildingId!)),
              )
          : null,
      onGoToFlat: item.hasFlatLink
          ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => underflat_futureproperty(
                    id: item.flatId!,
                    Subid: '',
                    buildingId: item.buildingId,
                  ),
                ),
              )
          : null,
    );
  }
}

