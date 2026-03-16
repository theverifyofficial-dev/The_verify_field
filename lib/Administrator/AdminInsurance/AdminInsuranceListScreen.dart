  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
  import 'package:intl/intl.dart';
  import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/AdminInsurance/Admin_insurance_list.dart';
  import '../../Insurance/InsuranceDetail.dart';
  import '../../main.dart';
  import '../Administrator_HomeScreen.dart';
  import '../SubAdmin/SubAdminAccountant_Home.dart';

  const String insuranceBaseUrl =
      "https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/";

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
    });

    factory InsuranceModel.fromJson(Map<String, dynamic> json) {
      return InsuranceModel(
        id: json['id'] ?? 0,
        name: json['name_'],
        number: json['number'],
        vehicleNumber: json['vehicle_number'],
        fieldWorkerName: json['fieldworkar_name'],
        fieldWorkerNumber: json['fieldworkar_number'],
        nextRenewDate: json['next_renew_date'],

        aadharFront: json['Aadhar_front'],
        aadharBack: json['Aadhar_back'],
        rcFront: json['Rc_front'],
        rcBack: json['Rc_back'],
        oldPolicyDocument: json['old_policy_docement'],

        emailId: json['email_id'],
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

    final Map<String, List<String>> locationWorkerMap = {
      "sultanpur": ["sumit", "ravi", "faizan","avjit"],
      "rajpur": ["manish", "abhey"],
      "chattarpur": ["manish", "abhey"],
    };

    String _normalizeLocation(String raw) {
      final loc = raw.toLowerCase();

      if (loc.contains("sultanpur")) return "sultanpur";
      if (loc.contains("rajpur")) return "rajpur";
      if (loc.contains("chattarpur")) return "chattarpur";

      return "unknown";
    }

    final List<Map<String, String>> fieldWorkers = [
      {"name": "Sumit", "id": "9711775300"},
      {"name": "Ravi", "id": "9711275300"},
      {"name": "Faizan", "id": "9971172204"},
      {"name": "Manish", "id": "8130209217"},
      {"name": "Abhey", "id": "9675383184"},
    ];
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
            "https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/"
                "insurance_details/show_insurance_api_base_on_fieldwoakr_number.php"
                "?fieldworkar_number=$number",
          ),
        );

        debugPrint("Worker $number → ${response.body}");

        final decoded = jsonDecode(response.body);

        if (decoded['status'] == "success") {

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
      final normalizedLoc = _normalizeLocation(userStoredLocation ?? "");
      final allowedWorkers = locationWorkerMap[normalizedLoc];

      final isAdmin =
          userStoredFAadharCard?.toLowerCase() == "administrator";

      final isSubAdmin =
          userStoredFAadharCard?.toLowerCase() == "sub administrator";

      final isDark = Theme
          .of(context)
          .brightness == Brightness.dark;

      return Scaffold(
        backgroundColor:
        isDark ? const Color(0xFF050202)
            : Colors.grey.shade100,

        appBar: AppBar(
          backgroundColor:
          isDark ? const Color(0xFF050202) : Colors.grey.shade100,
          surfaceTintColor:
          isDark ? const Color(0xFF050202) : Colors.grey.shade100,

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
            style: TextStyle(fontFamily: "PoppinsBold"),
          ),
          elevation: 0,
        ),

        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fieldWorkers
                .where((worker) {

              final workerName = worker['name']!.toLowerCase();

              if (isAdmin) return true;

              if (isSubAdmin && allowedWorkers != null) {
                return allowedWorkers.contains(workerName);
              }

              return false;
            })
                .map((worker) {

              final workerName = worker['name']!;
              final data = workerData[workerName] ?? [];

              if (data.isEmpty) return const SizedBox();

              return _workerSection(
                workerName: workerName,
                data: data,
                isDark: isDark,
              );

            }).toList(),
          ),
        ),
      );
    }

    Widget _buildEmptyState(bool isDark) {
      return Center(
        child: Text(
          "No Insurance Records Found",
          style: TextStyle(
            fontSize: 16,
            fontFamily: "PoppinsBold",
            color: isDark ? Colors.white70 : Colors.black54,
          ),
        ),
      );
    }

    Widget _workerSection({

      required String workerName,
      required List<InsuranceModel> data,
      required bool isDark,
    }) {
      final screenWidth = MediaQuery.of(context).size.width;

      return
        Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// 🔹 Worker Name (Left)
              Text(
                workerName,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: "PoppinsBold",
                  color: isDark ? Colors.white : Colors.black,
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
                    fontFamily: "PoppinsBold",
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// ✅ RESPONSIVE HEIGHT
          IntrinsicHeight(
            child: SizedBox(
              height: data.length > 2 ? 320 : 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return _insuranceMiniCard(data[index], isDark);
                },
              ),
            ),
          ),

          const SizedBox(height: 24),
        ],
      );
    }
    Widget _insuranceMiniCard(InsuranceModel item, bool isDark) {

      final missingFields = _missingFieldsFor(item);
      final hasMissingFields = missingFields.isNotEmpty;
      final screenWidth = MediaQuery.of(context).size.width;

      return GestureDetector(
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
        child: Container(
          width: screenWidth * 0.72,
          margin: const EdgeInsets.only(right: 16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),

            gradient: isDark
                ? const LinearGradient(
              colors: [
                Color(0xFF0F0F0F),
                Color(0xFF1A1A1A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )
                : const LinearGradient(
              colors: [Colors.white, Colors.white],
            ),

          ),

          child: Padding(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ✅ TOP ROW
                Row(
                  children: [

                    /// IMAGE
                    Container(
                      height: 54,
                      width: 54,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: Colors.indigo.withOpacity(.15),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: item.carPhotoUrl != null
                            ? Image.network(
                          item.carPhotoUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image),
                        )
                            : const Icon(Icons.car_rental,
                            color: Colors.indigo),
                      ),
                    ),

                    const SizedBox(width: 12),

                    /// NAME + NUMBER
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            item.name ?? "-",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 15,
                              fontFamily: "PoppinsBold",
                              color:
                              isDark ? Colors.white : Colors.black87,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            item.number ?? "-",
                            style: TextStyle(
                              fontSize: 11,
                              fontFamily: "PoppinsMedium",
                              color: isDark
                                  ? Colors.white54
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                /// ✅ DIVIDER
                Container(
                  height: 1,
                  color: isDark
                      ? Colors.white.withOpacity(.05)
                      : Colors.grey.shade200,
                ),

                const SizedBox(height: 14),

                /// ✅ INFO
                _modernInfo("Vehicle Number", item.vehicleNumber, isDark),
                const SizedBox(height: 6),

                _modernInfo("Vehicle Type", item.vehicleType, isDark),
                const SizedBox(height: 6),

                _modernInfo("ID", item.id.toString(), isDark),

                const SizedBox(height: 6),

                SizedBox(height: 12),

                /// ✅ BADGES
                Row(
                  children: [
                    _modernBadge("Claim", item.claim),
                    const SizedBox(width: 8),
                    _modernBadge("Pollution", item.pollutionYesNo),
                  ],
                ),
                if (hasMissingFields)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                      child: Text(
                        "⚠ Missing: ${missingFields.join(', ')}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      );
    }
    Widget _modernInfo(String label, String? value, bool isDark) {
      final missing = value == null || value.isEmpty;

      return Row(
        children: [

          Text(
            "$label: ",
            style: TextStyle(
              fontSize: 11,
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white38 : Colors.grey.shade700,
            ),
          ),
          SizedBox(width: 10,),
          Expanded(
            child: Text(
              missing ? "Not Available" : value!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontFamily: "PoppinsBold",
                fontStyle:
                missing ? FontStyle.italic : FontStyle.normal,
                color: missing
                    ? (isDark ? Colors.white30 : Colors.grey)
                    : (isDark ? Colors.white : Colors.black87),
              ),
            ),
          ),
        ],
      );
    }    /// ✅ EMPTY STATE
    Widget _modernBadge(String label, String? value) {
      final isYes = value == "Yes";
      final color = isYes ? Colors.green : Colors.redAccent;

      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: color.withOpacity(.12),
        ),
        child: Text(
          "$label: ${value ?? "No"}",
          style: TextStyle(
            fontSize: 10,
            fontFamily: "PoppinsBold",
            color: color,
          ),
        ),
      );
    }

  }
  String formatExpiryDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return "Not Available";

    try {
      final parsed = DateFormat("dd-MM-yyyy").parse(rawDate);

      return DateFormat("dd MMM yyyy").format(parsed);

      /// Example Output → 24 Feb 2026 😎
    } catch (e) {
      return rawDate; // fallback safety
    }
  }