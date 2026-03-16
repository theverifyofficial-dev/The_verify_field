import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../Custom_Widget/constant.dart';
import '../../Insurance/InsuranceDetail.dart';

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
      current_dates: json['current_dates'],
      pan_card_photo: json['pan_card_photo'],
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
  final String fieldWorkerNumber;

  const AdminListInsurance({
    super.key,
    required this.fieldWorkerNumber,
  });

  @override
  State<AdminListInsurance> createState() => _AdminListInsuranceState();
}

class _AdminListInsuranceState extends State<AdminListInsurance> {



  TextEditingController searchController = TextEditingController();
  List<InsuranceModel> filteredList = [];

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

  void _filterList() {
    final query = searchController.text.toLowerCase().trim();

    setState(() {
      if (query.isEmpty) {
        filteredList = insuranceList;
        return;
      }

      filteredList = insuranceList.where((item) {
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
          "https://verifyrealestateandservices.in/PHP_Files/insurance_insert_api/"
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
        filteredList = insuranceList;

        calculateMissingFields();
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

      // appBar: AppBar(
      //   backgroundColor:
      //   isDark ? const Color(0xFF050202)
      //       : Colors.grey.shade100,
      //
      //   surfaceTintColor: Colors.transparent, // 🔥 important
      //   scrolledUnderElevation: 0, // 🔥 important
      //
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     "Insurance Records",
      //     style: TextStyle(fontFamily: "PoppinsBold"),
      //   ),
      //   elevation: 0,
      // ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
          children: [

          /// HEADER
          _premiumHeader(isDark),

      /// 📊 COUNT SECTION
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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

            Text(
              "Showing: ${filteredList.length}",
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),

          ],
        ),
      ),

      /// 📄 LIST
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
              final item = filteredList[index];
              return _insuranceCard(item, isDark, context);
            },
          ),
        ),
      ),
        ]
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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

  Widget _premiumHeader(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF071A35),
            Color(0xFF0B2548),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(40),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔙 BACK BUTTON + PROFILE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// BACK BUTTON
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),

              /// PROFILE
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

          /// TITLE
          const Text(
            "CONCIERGE SERVICE",
            style: TextStyle(
              color: Colors.amber,
              fontSize: 11,
              letterSpacing: 2,
              fontFamily: "PoppinsMedium",
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "My Insurances",
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontFamily: "PoppinsBold",
            ),
          ),

          const SizedBox(height: 15),

          /// SEARCH BAR
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A3458),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1A3458),
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                controller: searchController,
                style: const TextStyle(
                  fontFamily: "PoppinsMedium",
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 13,
                  ),

                  prefixIcon: Container(
                    padding: const EdgeInsets.all(12),
                    child: Icon(
                      Icons.search_rounded,
                      color: Colors.grey.shade600,
                      size: 22,
                    ),
                  ),

                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                    icon: const Icon(Icons.close_rounded),
                    onPressed: () {
                      searchController.clear();
                    },
                  )
                      : null,

                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1A1A1A)
                      : Colors.white,

                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 18),

                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300,
                    ),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color(0xFF4F46E5),
                      width: 1.5,
                    ),
                  ),

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ PREMIUM INSURANCE CARD
  Widget _insuranceCard(InsuranceModel item, bool isDark, BuildContext context) {

    final missingFields = _missingFieldsFor(item);
    final hasMissingFields = missingFields.isNotEmpty;

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
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
            colors: [
              Color(0xFF111111),
              Color(0xFF1C1C1C),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
              : const LinearGradient(
            colors: [
              Colors.white,
              Color(0xFFF7F9FC),
            ],
          ),
          borderRadius: BorderRadius.circular(28),

          /// 🔥 Border Highlight
          border: Border.all(
            color: const Color(0xFF4F46E5).withOpacity(.15),
            width: 1,
          ),

          /// 🔥 Strong Elevation Shadow
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

            /// 🚗 IMAGE AREA
            Stack(
              children: [

                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(28),
                  ),
                  child: item.carPhotoUrl != null
                      ? Image.network(
                    item.carPhotoUrl!,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 200,
                    width: double.infinity,
                    color: Colors.grey.shade300,
                    child: const Icon(
                      Icons.directions_car,
                      size: 50,
                    ),
                  ),
                ),

                /// 🔥 IMAGE DARK OVERLAY
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(28),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(.25),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),

                /// ID BADGE
                Positioned(
                  top: 14,
                  right: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFF4F46E5),
                          Color(0xFF3B82F6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "ID ${item.id}",
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: "PoppinsBold",
                      ),
                    ),
                  ),
                ),
              ],
            ),

            /// CONTENT
            Padding(
              padding: const EdgeInsets.all(20),
              child:
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      /// NAME
                      Expanded(
                        child: Text(
                          item.name ?? "Unknown Owner",
                          style: const TextStyle(
                            fontSize: 20,
                            fontFamily: "PoppinsBold",
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// VEHICLE CATEGORY BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: (item.vehicle_category == null || item.vehicle_category!.trim().isEmpty)
                              ? Colors.red.withOpacity(.12)        // 🔴 Empty category
                              : const Color(0xFF4F46E5).withOpacity(.12), // 🟣 Normal
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          (item.vehicle_category == null || item.vehicle_category!.trim().isEmpty)
                              ? "Vehicle Category Empty"
                              : item.vehicle_category!,
                          style: TextStyle(
                            fontSize: 11,
                            fontFamily: "PoppinsBold",
                            color: (item.vehicle_category == null || item.vehicle_category!.trim().isEmpty)
                                ? Colors.red
                                : const Color(0xFF4F46E5),
                          ),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 4),

                  /// VEHICLE NUMBER
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

                      /// RENEW DATE
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            "RENEWAL DATE",
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              fontFamily: "PoppinsMedium",
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            formatExpiryDate(item.nextRenewDate),
                            style: const TextStyle(
                              fontSize: 15,
                              fontFamily: "PoppinsBold",
                            ),
                          ),
                        ],
                      ),

                      /// FUEL BADGE
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "Fuel: ${item.fuelType ?? "-"}",
                          style: const TextStyle(
                            fontSize: 11,
                            fontFamily: "PoppinsBold",
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
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
                            color: Colors.red.withOpacity(.5),
                          ),
                        ),
                        child: Row(
                          children: [

                            const Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 18,
                            ),

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

