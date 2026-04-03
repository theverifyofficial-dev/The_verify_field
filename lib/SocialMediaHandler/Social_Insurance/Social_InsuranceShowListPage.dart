import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import 'Social_InsuranceDetail.dart';
import 'Social_Pdf_quotations/Social_Pdf_quotation.dart';

const String insuranceBaseUrl =
    "https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/insurance_details/";

class SocialInsuranceModel {
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
  final String? pollutionYesNo;
  final String? pollutionPhoto;
  final String? nomineeName;
  final String? nomineeRelation;
  final String? nomineeAge;
  final String? maritalStatus;
  final String? vehicle_category;
  final String? vehicleType;
  final String? current_dates;
  final String? pan_card_photo;
  final String? cotation1;
  final String? cotation2;
  final String? cotation3;
  final String? cotation4;

  SocialInsuranceModel({
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
    this.cotation1,
    this.cotation2,
    this.cotation3,
    this.cotation4,
  });

  factory SocialInsuranceModel.fromJson(Map<String, dynamic> json) {
    return SocialInsuranceModel(
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
      carPhoto: json['car_photo'],
      registrationDate: json['Ragistaion_Date'],
      pollutionDate: json['Pollution_date'],
      pollutionYesNo: json['polution_yes_no'],
      pollutionPhoto: json['polution_photo'],
      nomineeName: json['Nominie_name'],
      nomineeRelation: json['Nominie_relation'],
      nomineeAge: json['Nominie_age'],
      maritalStatus: json['Marital_status'],
      vehicle_category: json['vehicle_category'],
      vehicleType: json['vehicle_type'],
      current_dates: json['current_dates'],
      pan_card_photo: json['pan_card_photo'],
      cotation1: json['cotation_1'],
      cotation2: json['cotation_2'],
      cotation3: json['cotation_3'],
      cotation4: json['cotation_4'],
    );
  }

  String? get carPhotoUrl => _buildUrl(carPhoto);
  String? get aadharFrontUrl => _buildUrl(aadharFront);
  String? get aadharBackUrl => _buildUrl(aadharBack);
  String? get rcFrontUrl => _buildUrl(rcFront);
  String? get rcBackUrl => _buildUrl(rcBack);
  String? get oldPolicyUrl => _buildUrl(oldPolicyDocument);
  String? get panCardPhotoUrl => _buildUrl(pan_card_photo);
  String? get pollutionPhotoUrl => _buildUrl(pollutionPhoto);

  String? _buildUrl(String? path) {
    if (path == null || path.isEmpty) return null;
    if (path.startsWith("http")) return path;
    return insuranceBaseUrl + path;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class social_InsuranceListScreen extends StatefulWidget {
  /// ✅ FIX: Dono required — caller ko pass karna ZARURI hai
  final String fieldWorkerNumber;
  final String fieldWorkerName;

  const social_InsuranceListScreen({
    super.key,
    required this.fieldWorkerNumber,
    required this.fieldWorkerName,
  });

  @override
  State<social_InsuranceListScreen> createState() =>
      _social_InsuranceListScreenState();
}

class _social_InsuranceListScreenState
    extends State<social_InsuranceListScreen> {
  // ── State ──────────────────────────────────────────────────────────────────
  bool isLoading = true;
  List<SocialInsuranceModel> insuranceList = [];
  List<SocialInsuranceModel> filteredList = [];
  final TextEditingController searchController = TextEditingController();

  // ── Lifecycle ──────────────────────────────────────────────────────────────
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

  // ── Search filter ──────────────────────────────────────────────────────────
  void _filterList() {
    final query = searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        filteredList = insuranceList;
        return;
      }
      filteredList = insuranceList.where((item) {
        final name = item.name?.toLowerCase() ?? '';
        final vehicle = item.vehicleNumber?.toLowerCase() ?? '';
        final number = item.number?.toLowerCase() ?? '';
        final id = item.id.toString();
        return name.contains(query) ||
            vehicle.contains(query) ||
            number.contains(query) ||
            id.contains(query);
      }).toList();
    });
  }

  // ── Missing fields check ───────────────────────────────────────────────────
  bool _blank(String? v) => v == null || v.trim().isEmpty;

  List<String> _missingFieldsFor(SocialInsuranceModel i) {
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

  // ── API ────────────────────────────────────────────────────────────────────
  Future<void> fetchInsurance() async {
    setState(() => isLoading = true);
    try {
      /// ✅ FIX: widget.fieldWorkerNumber — ab yeh HAMESHA sahi number hoga
      final url = Uri.parse(
        "https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/"
            "insurance_details/show_insurance_api_base_on_fieldwoakr_number.php"
            "?fieldworkar_number=${widget.fieldWorkerNumber}",
      );

      debugPrint("📡 Fetching insurance for: ${widget.fieldWorkerNumber}");

      final response = await http.get(url);
      final decoded = jsonDecode(response.body);

      if (decoded['status'] == "success") {
        final List raw = decoded['data'] ?? [];
        insuranceList = raw
            .map((e) => SocialInsuranceModel.fromJson(e))
            .toList();

        // ✅ Latest ID pehle
        insuranceList.sort((a, b) => b.id.compareTo(a.id));

        filteredList = insuranceList;
        debugPrint("✅ Loaded ${insuranceList.length} records");
      } else {
        insuranceList = [];
        filteredList = [];
        debugPrint("⚠️ API returned: ${decoded['status']}");
      }
    } catch (e) {
      debugPrint("❌ Fetch error: $e");
      insuranceList = [];
      filteredList = [];
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> refreshInsurance() => fetchInsurance();

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF050202) : Colors.grey.shade100,

      // ── FAB ──────────────────────────────────────────────────────────────
      // floatingActionButton: GestureDetector(
      //   onTap: () {
      //     // ✅ FIX: widget.fieldWorkerName / Number directly use karo
      //     // Agar list mein data hai toh wahan se bhi le sakte ho
      //     final workerName = insuranceList.isNotEmpty
      //         ? (insuranceList.first.fieldWorkerName ?? widget.fieldWorkerName)
      //         : widget.fieldWorkerName;
      //     final workerNumber = insuranceList.isNotEmpty
      //         ? (insuranceList.first.fieldWorkerNumber ??
      //         widget.fieldWorkerNumber)
      //         : widget.fieldWorkerNumber;
      //
      //     debugPrint("------ NAVIGATION DATA ------");
      //     debugPrint("Worker Name: $workerName");
      //     debugPrint("Worker Number: $workerNumber");
      //     debugPrint("-----------------------------");
      //
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => InsuranceFormScreen(
      //           fieldWorkerName: workerName,
      //           fieldWorkerNumber: workerNumber,
      //         ),
      //       ),
      //     ).then((_) => refreshInsurance());
      //   },
      //   child: Container(
      //     height: 58,
      //     padding: const EdgeInsets.symmetric(horizontal: 22),
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(30),
      //       gradient: const LinearGradient(
      //         begin: Alignment.topLeft,
      //         end: Alignment.bottomRight,
      //         colors: [Color(0xFFE6C47A), Color(0xFFD4AF37)],
      //       ),
      //       boxShadow: [
      //         BoxShadow(
      //           color: Colors.black.withOpacity(0.25),
      //           blurRadius: 14,
      //           offset: const Offset(0, 6),
      //         )
      //       ],
      //     ),
      //     child: const Row(
      //       mainAxisSize: MainAxisSize.min,
      //       children: [
      //         Icon(Icons.add_rounded, color: Colors.black, size: 28),
      //         SizedBox(width: 10),
      //         Text(
      //           "Add Insurance",
      //           style: TextStyle(
      //             fontSize: 15,
      //             fontFamily: "PoppinsBold",
      //             color: Colors.black,
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      // ── Body ─────────────────────────────────────────────────────────────
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          // ✅ FIX: widget.fieldWorkerName header mein pass kiya
          _premiumHeader(isDark, widget.fieldWorkerName),

          // Count row
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Records: ${filteredList.length}",
                  style: const TextStyle(
                    fontFamily: "PoppinsBold",
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: RefreshIndicator(
              onRefresh: refreshInsurance,
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
                        fontFamily: "PoppinsMedium",
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
                  return _insuranceCard(
                      filteredList[index], isDark, context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HEADER  ✅ FIX: workerName parameter add kiya
  // ─────────────────────────────────────────────────────────────────────────
  Widget _premiumHeader(bool isDark, String workerName) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF071A35), Color(0xFF0B2548)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back + Logo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 18),
                ),
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 23,
                  backgroundImage: AssetImage(AppImages.logo),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          const Text(
            "CONCIERGE SERVICE",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 11,
              letterSpacing: 2,
              fontFamily: "PoppinsMedium",
            ),
          ),

          const SizedBox(height: 4),

          Text(
            "My Insurances",
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontFamily: "PoppinsBold",
            ),
          ),

          const SizedBox(height: 15),

          // Search bar
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A3458),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(fontFamily: "PoppinsMedium", fontSize: 14),
              decoration: InputDecoration(
                hintText: "Search by name, vehicle, number, ID...",
                hintStyle:
                TextStyle(color: Colors.grey.shade500, fontSize: 13),
                prefixIcon: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(Icons.search_rounded,
                      color: Colors.grey.shade600, size: 22),
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => searchController.clear(),
                )
                    : null,
                filled: true,
                fillColor: Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF1A1A1A)
                    : Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 18),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                      color: Color(0xFF4F46E5), width: 1.5),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // CARD (unchanged logic, small cleanup)
  // ─────────────────────────────────────────────────────────────────────────
  Widget _insuranceCard(
      SocialInsuranceModel item, bool isDark, BuildContext context) {
    final missingFields = _missingFieldsFor(item);
    final hasMissingFields = missingFields.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Social_InsuranceDetailScreen(insuranceId: item.id),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
            colors: [Color(0xFF111111), Color(0xFF1C1C1C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : const LinearGradient(
              colors: [Colors.white, Color(0xFFF7F9FC)]),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
              color: const Color(0xFF4F46E5).withOpacity(.15), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.12),
              blurRadius: 28,
              spreadRadius: 2,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Vehicle image ────────────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(28)),
                  child: item.carPhotoUrl != null
                      ? Image.network(
                    item.carPhotoUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _noImageBox(),
                  )
                      : _noImageBox(),
                ),
                // Gradient overlay
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(28)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(.25)
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                // ID badge
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "ID ${item.id}",
                      style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontFamily: "PoppinsBold"),
                    ),
                  ),
                ),
                // Vehicle category badge
                Positioned(
                  bottom: 5,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4F46E5), Color(0xFF3B82F6)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      (_blank(item.vehicle_category))
                          ? "Category Missing"
                          : item.vehicle_category!,
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "PoppinsBold",
                        color: _blank(item.vehicle_category)
                            ? Colors.red.shade200
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ── Content ──────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          item.name ?? "Unknown Owner",
                          style: const TextStyle(
                              fontSize: 20,
                              fontFamily: "PoppinsBold",
                              fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _blank(item.fuelType)
                            ? "Fuel Missing"
                            : item.fuelType!,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: "PoppinsBold",
                          color: _blank(item.fuelType)
                              ? Colors.red
                              : Colors.amber,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    item.vehicleNumber ?? "",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : Colors.grey.shade800,
                      fontFamily: "PoppinsMedium",
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Renewal date
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "RENEWAL DATE",
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey.shade500,
                                fontFamily: "PoppinsMedium"),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formatExpiryDate(item.nextRenewDate),
                            style: const TextStyle(
                                fontSize: 15, fontFamily: "PoppinsBold"),
                          ),
                        ],
                      ),
                      // View Details button
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  Social_PdfQuotation(projectId: item.id),
                            ),
                          );
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 6),
                          backgroundColor: isDark
                              ? Colors.white.withOpacity(.08)
                              : const Color(0xFF4F46E5).withOpacity(.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white.withOpacity(.15)
                                  : const Color(0xFF4F46E5).withOpacity(.3),
                              width: 1,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.remove_red_eye_outlined,
                                size: 13,
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF4F46E5)),
                            const SizedBox(width: 5),
                            Text(
                              "View Details",
                              style: TextStyle(
                                fontSize: 11,
                                fontFamily: "PoppinsBold",
                                color: isDark
                                    ? Colors.white70
                                    : const Color(0xFF4F46E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  // Missing fields warning
                  if (hasMissingFields)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: Colors.red.withOpacity(.5)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.warning_amber_rounded,
                                color: Colors.red, size: 18),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Missing: ${missingFields.join(', ')}",
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _noImageBox() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey.shade300,
      child: const Icon(Icons.directions_car, size: 50, color: Colors.grey),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper
// ─────────────────────────────────────────────────────────────────────────────
String formatExpiryDate(String? rawDate) {
  if (rawDate == null || rawDate.isEmpty) return "Not Available";
  try {
    final parsed = DateFormat("dd-MM-yyyy").parse(rawDate);
    return DateFormat("dd MMM yyyy").format(parsed);
  } catch (_) {
    return rawDate;
  }
}