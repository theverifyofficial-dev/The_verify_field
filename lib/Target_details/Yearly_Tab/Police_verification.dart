import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

import 'Target_Under_Details_/Yearly_police_verification.dart';

/// =======================
/// MODEL
/// =======================
class PoliceyearlyModel {
  final int id;
  // OWNER
  final String ownerName;
  final String ownerRelation;
  final String ownerRelationPerson;
  final String ownerAddress;
  final String ownerMobile;
  final String ownerAadhar;
  final String ownerAadharFront;
  final String ownerAadharBack;

  // TENANT
  final String tenantName;
  final String tenantRelation;
  final String tenantRelationPerson;
  final String tenantAddress;
  final String tenantMobile;
  final String tenantAadhar;
  final String tenantAadharFront;
  final String tenantAadharBack;
  final String tenantImage;

  // PROPERTY
  final String rentedAddress;
  final String bhk;
  final String floor;
  final String parking;
  final String furniture;

  // AGREEMENT
  final String agreementType;
  final String policeVerificationPdf;

  // DATES
  final String currentDate;

  // FIELD WORKER
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  PoliceyearlyModel({
    required this.id,
    required this.ownerName,
    required this.ownerRelation,
    required this.ownerRelationPerson,
    required this.ownerAddress,
    required this.ownerMobile,
    required this.ownerAadhar,
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantName,
    required this.tenantRelation,
    required this.tenantRelationPerson,
    required this.tenantAddress,
    required this.tenantMobile,
    required this.tenantAadhar,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    required this.tenantImage,
    required this.rentedAddress,
    required this.bhk,
    required this.floor,
    required this.parking,
    required this.furniture,
    required this.agreementType,
    required this.policeVerificationPdf,
    required this.currentDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
  });

  static String _parseDate(dynamic val) {
    if (val == null) return '';
    if (val is String) return val;
    if (val is Map && val['date'] != null) return val['date'].toString();
    return '';
  }

  factory PoliceyearlyModel.fromJson(Map<String, dynamic> json) {
    return PoliceyearlyModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      ownerName: json['owner_name']?.toString() ?? '',
      ownerRelation: json['owner_relation']?.toString() ?? '',
      ownerRelationPerson: json['relation_person_name_owner']?.toString() ?? '',
      ownerAddress: json['parmanent_addresss_owner']?.toString() ?? '',
      ownerMobile: json['owner_mobile_no']?.toString() ?? '',
      ownerAadhar: json['owner_addhar_no']?.toString() ?? '',
      ownerAadharFront: json['owner_aadhar_front']?.toString() ?? '',
      ownerAadharBack: json['owner_aadhar_back']?.toString() ?? '',
      tenantName: json['tenant_name']?.toString() ?? '',
      tenantRelation: json['tenant_relation']?.toString() ?? '',
      tenantRelationPerson: json['relation_person_name_tenant']?.toString() ?? '',
      tenantAddress: json['permanent_address_tenant']?.toString() ?? '',
      tenantMobile: json['tenant_mobile_no']?.toString() ?? '',
      tenantAadhar: json['tenant_addhar_no']?.toString() ?? '',
      tenantAadharFront: json['tenant_aadhar_front']?.toString() ?? '',
      tenantAadharBack: json['tenant_aadhar_back']?.toString() ?? '',
      tenantImage: json['tenant_image']?.toString() ?? '',
      rentedAddress: json['rented_address']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '-',
      floor: json['floor']?.toString() ?? '-',
      parking: json['parking']?.toString() ?? '-',
      furniture: json['furniture']?.toString() ?? '',

      agreementType: json['agreement_type']?.toString() ?? 'Police Verification',
      policeVerificationPdf: json['police_verification_pdf']?.toString() ?? '',

      currentDate: _parseDate(json['current_dates']),

      fieldWorkerName: json['Fieldwarkarname']?.toString() ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber']?.toString() ?? '',
    );
  }
}

Future<List<PoliceyearlyModel>> fetchPoliceYearly() async {
  final prefs = await SharedPreferences.getInstance();
  final FNumber = prefs.getString('number') ?? "";
  print(FNumber);
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_yearly.php?Fieldwarkarnumber=$FNumber",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Police Yearly API Error");
  }

  final decoded = json.decode(res.body);
  print(res.body);

  final List list = decoded['data'] ?? [];

  return list.map((e) => PoliceyearlyModel.fromJson(e)).toList();
}

class YearlyPoliceVerificationScreen extends StatefulWidget {
  const YearlyPoliceVerificationScreen({super.key});

  @override
  State<YearlyPoliceVerificationScreen> createState() =>
      _YearlyPoliceVerificationScreenState();
}

class _YearlyPoliceVerificationScreenState
    extends State<YearlyPoliceVerificationScreen> {
  late Future<List<PoliceyearlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchPoliceYearly();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: FutureBuilder<List<PoliceyearlyModel>>(
        future: futureData,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(child: Text("Error: ${snap.error}"));
          }

          final list = snap.data ?? [];

          if (list.isEmpty) {
            return const Center(child: Text("No Police Verification Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final b = list[i];
              final isDark = Theme.of(context).brightness == Brightness.dark;

              final cardBg = isDark ? const Color(0xFF171717) : Colors.white;
              final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade800;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PoliceVerificationDetailScreen(p: b),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ================= IMAGE =================
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                            child: Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${b.tenantImage}",
                              height: 210,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 210,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),

                          /// POLICE BADGE
                          Positioned(
                            top: 14,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(.95),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "Police Verification",
                                style: TextStyle(
                                  fontFamily: "PoppinsBold",
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          /// AGREEMENT TYPE
                          Positioned(
                            bottom: 14,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(.55),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                b.agreementType,
                                style: const TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// ================= DETAILS =================
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// ADDRESS
                            Text(
                              b.rentedAddress.isEmpty
                                  ? "No Address"
                                  : b.rentedAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "PoppinsBold",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// OWNER / TENANT
                            Text(
                              "Owner: ${b.ownerName}  •  Tenant: ${b.tenantName}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 13,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 12),

                            /// MODERN INFO CHIPS
                            Row(
                              children: [
                                _modernChip(Icons.home, b.bhk, subText),
                                _modernChip(Icons.layers, b.floor, subText),
                                _modernChip(Icons.local_parking, b.parking, subText),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// MOBILE
                            Text(
                              "Owner: ${b.ownerMobile}",
                              style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontSize: 13,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              "Tenant: ${b.tenantMobile}",
                              style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontSize: 13,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// FIELD WORKER
                            Text(
                              "Field Worker: ${b.fieldWorkerName}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: subText,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );

            },
          );
        },
      ),
    );
  }
}

Widget _modernChip(IconData icon, String text, Color color) {
  if (text.isEmpty || text == '-') return const SizedBox();

  return Container(
    margin: const EdgeInsets.only(right: 10),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: color.withOpacity(.08),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontFamily: "PoppinsMedium",
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    ),
  );
}

/// =======================
/// INFO ITEM
/// =======================
class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.iconTheme.color),
        const SizedBox(width: 4),
        Text(text, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
