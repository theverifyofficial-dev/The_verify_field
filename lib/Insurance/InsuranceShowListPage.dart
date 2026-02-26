import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:verify_feild_worker/Target_details/Yearly_Tab/Book_Rent.dart';
import 'Insurance Form Screen.dart';
import 'InsuranceDetail.dart';


const String insuranceBaseUrl =
    "https://verifyserve.social/PHP_Files/insurance_insert_api/insurance_details/";

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

class InsuranceListScreen extends StatefulWidget {
  final String fieldWorkerNumber;

  const InsuranceListScreen({
    super.key,
    required this.fieldWorkerNumber,
  });

  @override
  State<InsuranceListScreen> createState() => _InsuranceListScreenState();
}

class _InsuranceListScreenState extends State<InsuranceListScreen> {
  bool isLoading = true;
  List<InsuranceModel> insuranceList = [];

  @override
  void initState() {
    super.initState();
    fetchInsurance();
  }

  Future<void> fetchInsurance() async {
    try {
      final response = await http.get(
        Uri.parse(
          "https://verifyserve.social/PHP_Files/insurance_insert_api/"
              "insurance_details/show_insurance_api_base_on_fieldwoakr_number.php"
              "?fieldworkar_number=${widget.fieldWorkerNumber}",
        ),
      );

      final decoded = jsonDecode(response.body);

      debugPrint("RESPONSE: ${response.body}");

      if (decoded['status'] == "success") {
        insuranceList = (decoded['data'] as List)
            .map((e) => InsuranceModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      debugPrint("Error: $e");
    }

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
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF050202)
          : Colors.grey.shade100,

      appBar: AppBar(
        backgroundColor:
        isDark ? const Color(0xFF050202)
            : Colors.grey.shade100,
        automaticallyImplyLeading: false,
        title: const Text(
          "Insurance Records",
          style: TextStyle(fontFamily: "PoppinsBold"),
        ),
        elevation: 0,
      ),
      floatingActionButton: GestureDetector(
          onTap: () {

            if (insuranceList.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No worker data found")),
              );
              return;
            }

            final worker = insuranceList.first;
            print(worker.fieldWorkerName);
            print(worker.fieldWorkerNumber);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => InsuranceFormScreen(
                  fieldWorkerName: worker.fieldWorkerName ?? "",
                  fieldWorkerNumber: worker.fieldWorkerNumber ?? "",
                ),
              ),
            ).then((value) {

              refreshInsurance();

            });
            },
        child: Container(
          height: 58,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),

            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4F46E5),
                Color(0xFF3B82F6),
              ],
            ),

            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              )
            ],
          ),

          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [

              Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 28,
              ),

              SizedBox(width: 10),

              Text(
                "Add Insurance",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: "PoppinsBold",
                  color: Colors.white, // ✅ ALWAYS WHITE (important)
                ),
              ),
            ],
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : insuranceList.isEmpty
          ? _buildEmptyState(isDark)
          : RefreshIndicator(
            color: Colors.blue,
            onRefresh: refreshInsurance,
            child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: insuranceList.length,
            itemBuilder: (context, index) {
            final item = insuranceList[index];
            return _insuranceCard(item, isDark,context);
                    },
                  ),
          ),
    );
  }

  /// ✅ EMPTY STATE
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

  /// ✅ PREMIUM INSURANCE CARD
  Widget _insuranceCard(InsuranceModel item, bool isDark, BuildContext context) {
    final missingVehicle =
        item.vehicleNumber == null || item.vehicleNumber!.isEmpty;

    final missingType =
        item.vehicleType == null || item.vehicleType!.isEmpty;

    final missingExpiry =
        item.expiryDate == null || item.expiryDate!.isEmpty;

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
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: isDark
              ? const LinearGradient(
            colors: [
              Color(0xFF050505),
              Color(0xFF111111),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : const LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            children: [

              /// ✅ HEADER
              Row(
                children: [

                  /// IMAGE BLOCK
                  Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4F46E5),
                          Color(0xFF3B82F6),
                        ],
                      ),
                    ),
                    child: item.carPhotoUrl != null
                        ? ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.network(
                        item.carPhotoUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                        : const Icon(
                      Icons.description_rounded,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 14),

                  /// NAME + NUMBER
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          item.name ?? "-",
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: "PoppinsBold",
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          item.number ?? "-",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "PoppinsMedium",
                            color: isDark
                                ? Colors.white54
                                : Colors.grey.shade600,
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
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.shade200,
              ),

              const SizedBox(height: 18),

              /// ✅ INFO AREA 🔥🔥🔥
              Column(
                children: [

                  /// ROW 1 → VEHICLE + TYPE
                  Row(
                    children: [
                      Expanded(
                        child: _bigInfoBlock(
                          label: "Vehicle Number",
                          value: missingVehicle
                              ? "Not Available"
                              : item.vehicleNumber!,
                          isDark: isDark,
                          missing: missingVehicle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _bigInfoBlock(
                          label: "Type",
                          value: missingType
                              ? "Not Available"
                              : item.vehicleType!,
                          isDark: isDark,
                          missing: missingType,
                          alignEnd: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// ROW 2 → EXPIRY + BADGES
                  Row(
                    children: [

                      Expanded(
                        child: _bigInfoBlock(
                          label: "Expiry Date",
                          value: missingExpiry
                              ? "Not Available"
                              : formatExpiryDate(item.expiryDate),
                          isDark: isDark,
                          missing: missingExpiry,
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            _statusBadge(
                              label: "Claim",
                              value: item.claim ?? "No",
                            ),

                            const SizedBox(height: 6),

                            _statusBadge(
                              label: "Pollution",
                              value: item.pollutionYesNo ?? "No",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _bigInfoBlock({
    required String label,
    required String value,
    required bool isDark,
    required bool missing,
    bool alignEnd = false,
  }) {
    return Column(
      crossAxisAlignment:
      alignEnd ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [

        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontFamily: "PoppinsMedium",
            color: isDark ? Colors.white38 : Colors.grey,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontFamily: "PoppinsBold",
            fontStyle: missing ? FontStyle.italic : FontStyle.normal,
            color: missing
                ? (isDark ? Colors.white30 : Colors.grey)
                : (isDark ? Colors.white : Colors.black87),
          ),
        ),
      ],
    );
  }
  Widget _statusBadge({
    required String label,
    required String value,
  }) {
    final isYes = value == "Yes";

    final color = isYes ? Colors.green : Colors.redAccent;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "$label: $value",
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