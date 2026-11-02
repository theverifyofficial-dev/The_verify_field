import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Custom_Widget/constant.dart';
import '../../Insurance/InsuranceDetail.dart';
import '../../Insurance/insurance_ui_kit.dart';

// 2026-10-23 fix: `fetchInsurance()` below calls the NEW table's
// endpoint, so image paths it returns (e.g. `car_photo`) must resolve
// against the NEW table's base URL, not the old one. Same fix as §26.
const String insuranceBaseUrl =
    "https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/";

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
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) {
    return InsuranceModel(
      id: json['id'] ?? 0,
      // 2026-10-23 fix: this endpoint (`show_api_fieldworkar_number.php`,
      // the new table) has no separate `name_`/`number`/`vehicle_number`
      // columns -- the field worker's typed name/phone are stored AS the
      // RTO fields `OWNER_NAME`/`MOBILE_NO` directly, and the vehicle
      // number key is camelCase `vehicleNumber`, not `vehicle_number`.
      // Same fix as `InsuranceShowListPage.dart`/`AdminInsuranceListScreen.dart`
      // for this same endpoint (see doc §26).
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
    );
  }

  /// ================= IMAGE URL HELPERS =================

  String? get carPhotoUrl => _buildUrl(carPhoto);
  String? get aadharFrontUrl => _buildUrl(aadharFront);
  String? get aadharBackUrl => _buildUrl(aadharBack);
  String? get rcFrontUrl => _buildUrl(rcFront);
  String? get rcBackUrl => _buildUrl(rcBack);
  String? get oldPolicyUrl => _buildUrl(oldPolicyDocument);
  String? get panCardPhotoUrl => _buildUrl(pan_card_photo); // ✅ PAN added
  String? get pollutionPhotoUrl => _buildUrl(pollutionPhoto); // ✅ NEW

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

class AdminListInsurance extends StatefulWidget {
  final String? fieldWorkerNumber;

  const AdminListInsurance({
    super.key,
     this.fieldWorkerNumber,
  });

  @override
  State<AdminListInsurance> createState() => _AdminListInsuranceState();
}

class _AdminListInsuranceState extends State<AdminListInsurance> {



  TextEditingController searchController = TextEditingController();
  List<InsuranceModel> filteredList = [];
  // null means "All" -- see InsuranceStatusFilterBar.
  InsuranceExpiryStatus? _statusFilter;

  int totalMissingFields = 0;
  bool isLoading = true;
  List<InsuranceModel> insuranceList = [];

  bool _blank(String? v) {
    return v == null || v.trim().isEmpty;
  }

  List<String> _missingFieldsFor(InsuranceModel i) {
    final m = <String>[];

    final checks = <String, String?>{
      "Customer Name": i.name,
      "Customer Number": i.number,
      "Vehicle Number": i.vehicleNumber,
      "Vehicle Type": i.vehicleType,
      "Fuel Type": i.fuelType,
      "Email": i.emailId,
      "Nominee Name": i.nomineeName,
      "Nominee Relation": i.nomineeRelation,
      "Nominee Age": i.nomineeAge,
      "Field Worker Name": i.fieldWorkerName,
      "Field Worker Number": i.fieldWorkerNumber,
      "Car Photo": i.carPhoto,
      "Pollution Status": i.pollutionYesNo,
    };

    checks.forEach((k, v) {
      if (_blank(v)) m.add(k);
    });

    return m;
  }

  @override
  void initState() {
    super.initState();
    fetchInsurance();
    searchController.addListener(_filterList);
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

        final name = item.name?.toLowerCase() ?? "";
        final vehicle = item.vehicleNumber?.toLowerCase() ?? "";
        final number = item.number?.toLowerCase() ?? "";
        final id = item.id.toString();   // 👈 ID added

        return name.contains(query) ||
            vehicle.contains(query) ||
            number.contains(query) ||
            id.contains(query);          // 👈 ID search enabled
      }).toList();
    });
  }

  void calculateMissingFields() {
    totalMissingFields = 0;

    for (var item in insuranceList) {
      if (item.vehicleNumber == null || item.vehicleNumber!.isEmpty) totalMissingFields++;
      if (item.vehicleType == null || item.vehicleType!.isEmpty) totalMissingFields++;
      if (item.number == null || item.number!.isEmpty) totalMissingFields++;
      if (item.emailId == null || item.emailId!.isEmpty) totalMissingFields++;
      if (item.nomineeName == null || item.nomineeName!.isEmpty) totalMissingFields++;
      if (item.name == null || item.name!.isEmpty) totalMissingFields++;
      if (item.carPhoto == null || item.carPhoto!.isEmpty) totalMissingFields++;
    }
  }



  Future<void> fetchInsurance() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/"
              "show_api_fieldworkar_number.php?Fieldworkar_number=${widget.fieldWorkerNumber}",),
      );

      final decoded = jsonDecode(response.body);

      debugPrint("RESPONSE: ${response.body}");

      if (decoded['status'] == true || decoded['status'] == 'success') {
        insuranceList = (decoded['data'] as List)
            .map((e) => InsuranceModel.fromJson(e))
            .toList();

        calculateMissingFields();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

    _applyFilters();
    if (mounted) {
      setState(() => isLoading = false);
    }
  }

  Future<void> refreshInsurance() async {
    setState(() => isLoading = true);

    await fetchInsurance();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: InsColors.bg,
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: InsColors.primary))
          : Column(
              children: [
                _header(context),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Records: ${filteredList.length}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: InsColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshInsurance,
                    color: InsColors.primary,
                    child: filteredList.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: const [
                              SizedBox(height: 200),
                              Center(
                                child: Text(
                                  "No Insurance Records Found",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: InsColors.textMuted,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(16),
                            itemCount: filteredList.length,
                            itemBuilder: (context, index) {
                              final item = filteredList[index];
                              return _insuranceCard(item, context);
                            },
                          ),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Widget _header(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 56, 16, 18),
      decoration: const BoxDecoration(
        color: InsColors.surface,
        border: Border(bottom: BorderSide(color: InsColors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: InsColors.bg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: InsColors.textPrimary,
                    size: 16,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                "Field Worker Insurances",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: InsColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          InsSearchField(
            controller: searchController,
            onClear: () => searchController.clear(),
          ),
          const SizedBox(height: 12),
          InsuranceStatusFilterBar(
            selected: _statusFilter,
            onChanged: (status) {
              setState(() => _statusFilter = status);
              _applyFilters();
            },
          ),
        ],
      ),
    );
  }

  /// ✅ INSURANCE CARD
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

  Widget _insuranceCard(InsuranceModel item, BuildContext context) {
    final missingFields = _missingFieldsFor(item);
    return InsuranceListCard(
      id: item.id,
      name: item.name,
      vehicleNumber: item.vehicleNumber,
      carPhotoUrl: item.carPhotoUrl,
      missingCount: missingFields.length,
      vehicleModelLabel: _vehicleModelLabel(item),
      insuranceUpto: item.insuranceUpto,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => InsuranceDetailScreen(
              insuranceId: item.id,
            ),
          ),
        );
      },
    );
  }
}

