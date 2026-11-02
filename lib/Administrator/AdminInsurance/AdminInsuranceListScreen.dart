  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/AdminInsurance/Admin_insurance_list.dart';
  import '../../Insurance/InsuranceDetail.dart';
  import '../../main.dart';
  import '../Administrator_HomeScreen.dart';
  import '../SubAdmin/SubAdminAccountant_Home.dart';
  import '../../Field_Workers/field_worker_directory.dart';
  import '../../Insurance/insurance_ui_kit.dart';

  // 2026-10-23 fix: this screen's `fetchInsuranceByWorker` calls the NEW
  // table's endpoint (`show_api_fieldworkar_number.php`, see below), so
  // image paths it returns (e.g. `car_photo: "insurance_uploads/<hash>.jpg"`)
  // must be resolved against the NEW table's base URL -- the OLD table's
  // base URL this constant previously held would have produced a broken
  // image link for every photo on this screen, same root cause as the
  // blank name/number/vehicle-number fields fixed alongside this.
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
    final String? vehicleType;
    final String? carPhoto;

    final String? registrationDate;
    final String? pollutionDate;

    final String? pollutionYesNo;     // ✅ NEW
    final String? pollutionPhoto;     // ✅ NEW

    final String? nomineeName;
    final String? nomineeRelation;
    final String? nomineeAge;

    final String? maritalStatus;

    final String? expiryDate;         // ✅ NEW
    final String? current_dates;    // ✅ NEW (created date)

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
      this.expiryDate,
      this.current_dates,
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
        // Matches `InsuranceShowListPage.dart`'s `fromJson` for this same
        // endpoint.
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
        vehicleType: json['vehicle_type'],
        carPhoto: json['car_photo'],

        registrationDate: json['Ragistaion_Date'],
        pollutionDate: json['Pollution_date'],

        pollutionYesNo: json['polution_yes_no'],   // ✅ NEW
        pollutionPhoto: json['polution_photo'],    // ✅ NEW

        nomineeName: json['Nominie_name'],
        nomineeRelation: json['Nominie_relation'],
        nomineeAge: json['Nominie_age'],

        maritalStatus: json['Marital_status'],

        expiryDate: json['expiry_date'],           // ✅ NEW
        current_dates: json['current_dates'] ?? json['created_at'] ?? json['createdAt'],
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

  class AdminInsuranceListScreen extends StatefulWidget {

    final bool fromNotification;
    final String? notificationType;

    const AdminInsuranceListScreen({
      super.key,
      this.fromNotification = false,
      this.notificationType,
    });

    @override
    State<AdminInsuranceListScreen> createState() => _AdminInsuranceListScreenState();
  }

  class _AdminInsuranceListScreenState extends State<AdminInsuranceListScreen> {

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
      loadAllWorkers();
      loadUserName();
    }

    // Loaded from FieldWorkerDirectory in loadAllWorkers below -- every
    // role now sees the full dynamically-fetched roster (the old
    // location->worker allow-list only ever covered 3 of the real
    // roster's workers anyway).
    List<Map<String, String>> fieldWorkers = [];
    bool isLoading = true;

    Map<String, List<InsuranceModel>> workerData = {};

    String? userName;
    String? userNumber;
    String? userStoredFAadharCard;
    String? userStoredLocation;

    Future<void> loadUserName() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('name');
      final storedNumber = prefs.getString('number');
      final storedLocation = prefs.getString('location') ?? '';

      final storedFAadharCard = prefs.getString('post');

      if (mounted) {
        setState(() {

          userName = storedName;
          userNumber = storedNumber;
          userStoredFAadharCard = storedFAadharCard;
          userStoredLocation = storedLocation;
        });
      }
    }

    Future<void> loadAllWorkers() async {
      await FieldWorkerDirectory.instance.load();
      fieldWorkers = FieldWorkerDirectory.instance.asMaps;

      for (var worker in fieldWorkers) {

        final records =
        await fetchInsuranceByWorker(worker['id']!);

        workerData[worker['name']!] = records;
      }

      if (mounted) {
        setState(() => isLoading = false);
      }
    }

    Future<List<InsuranceModel>> fetchInsuranceByWorker(String number) async {
      try {
        final response = await http.get(
          Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/insurance/"
                "show_api_fieldworkar_number.php?Fieldworkar_number=$number",
          ),
        );

        debugPrint("Worker $number → ${response.body}");

        final decoded = jsonDecode(response.body);

        if (decoded['status'] == true || decoded['status'] == 'success') {

          final List data = decoded['data'];

          return data
              .map((e) => InsuranceModel.fromJson(e))
              .toList();
        }

      } catch (e) {
        debugPrint("Worker Error → $e");
      }

      return [];
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: InsColors.bg,
        appBar: AppBar(
          backgroundColor: InsColors.surface,
          foregroundColor: InsColors.textPrimary,
          surfaceTintColor: InsColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            onPressed: () {
              /// ✅ OPENED FROM NOTIFICATION
              if (widget.fromNotification) {
                if (widget.notificationType == "NEW_INSURANCE_ADMIN") {
                  navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    AdministratorHome_Screen.route,
                    (route) => false,
                  );
                  return;
                }

                if (widget.notificationType == "NEW_INSURANCE_SUBADMIN") {
                  navigatorKey.currentState?.pushNamedAndRemoveUntil(
                    SubAdminHomeScreen.route,
                    (route) => false,
                  );
                  return;
                }
              }

              /// ✅ NORMAL BEHAVIOUR
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "Insurance Records",
            style: TextStyle(fontWeight: FontWeight.w700, color: InsColors.textPrimary),
          ),
          elevation: 0,
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: InsColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Every role sees the full dynamically-fetched roster now.
                  children: fieldWorkers.map((worker) {
                    final workerName = worker['name']!;
                    final data = workerData[workerName] ?? [];

                    if (data.isEmpty) return _buildEmptyState(workerName);

                    return _workerSection(
                      workerName: workerName,
                      data: data,
                    );
                  }).toList(),
                ),
              ),
      );
    }

    Widget _buildEmptyState(String workerName) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "No data for $workerName",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: InsColors.textMuted,
              ),
            ),
          ],
        ),
      );
    }

    Widget _workerSection({
      required String workerName,
      required List<InsuranceModel> data,
    }) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// 🔹 Worker Name (Left)
              Text(
                workerName,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: InsColors.textPrimary,
                ),
              ),

              /// 🔹 View All (Right)
              TextButton(
                onPressed: () {
                  final worker = fieldWorkers.firstWhere(
                    (w) => w['name'] == workerName,
                  );

                  final workerNumber = worker['id'];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminListInsurance(
                        fieldWorkerNumber: workerNumber!,
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "View All",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: InsColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  data.length,
                  (index) => _insuranceMiniCard(data[index]),
                ),
              ),
            ),
          ),

          const SizedBox(height: 22),
        ],
      );
    }

    // Vehicle model name shown on the card in place of the old "Via
    // Registry" badge (same unification as the other two List screens,
    // doc §25/§26) -- prefers the specific model, falls back to the
    // manufacturer name, truncated for card-layout safety.
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
      // 2026-10-23: raised from 28 to 60 chars -- the model name now gets
      // its own full-width row on this screen's card (see
      // `modelNameFullWidth` on `InsuranceListCard`), so it has far more
      // room than when it shared a `Wrap` with the missing-field count.
      // The Text widget itself still ellipsizes as a last resort, so this
      // cap is just a sane upper bound, not the only thing preventing
      // overflow.
      return label.length > 60 ? '${label.substring(0, 60).trim()}\u2026' : label;
    }

    Widget _insuranceMiniCard(InsuranceModel item) {
      final missingFields = _missingFieldsFor(item);
      final screenWidth = MediaQuery.of(context).size.width;
      // Clamped so the card still scales with screen width (responsive)
      // without ever getting unreasonably narrow on a small phone or
      // absurdly wide on a tablet. 2026-10-23: widened from 0.72/240-340
      // to 0.86/300-420 per the user's "increase the width of the card"
      // request -- the wider card is also what gives the model-name row
      // and the Expires/remaining-days row below enough room to show
      // their full text on one line instead of ellipsizing as often.
      final cardWidth = (screenWidth * 0.86).clamp(300.0, 420.0);

      return SizedBox(
        width: cardWidth,
        child: Padding(
          padding: const EdgeInsets.only(right: 14),
          child: InsuranceListCard(
            id: item.id,
            name: item.name,
            vehicleNumber: item.vehicleNumber,
            carPhotoUrl: item.carPhotoUrl,
            missingCount: missingFields.length,
            vehicleModelLabel: _vehicleModelLabel(item),
            insuranceUpto: item.insuranceUpto,
            // 2026-10-23 request, specific to this screen's card only
            // (the other two List screens keep the original fuller
            // card): just the remaining-days count, no status word; no
            // "Expires: " prefix on the date line; and the model name on
            // its own full-width row instead of sharing space with the
            // missing-field count.
            compactExpiryLabel: true,
            showExpiresPrefix: false,
            modelNameFullWidth: true,
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
          ),
        ),
      );
    }
  }
