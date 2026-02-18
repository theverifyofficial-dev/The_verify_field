import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

import 'Target_Under_Details_/Yearly_police_verification.dart';

/// =======================
/// MODEL
/// =======================
String safe(dynamic v) {
  if (v == null) return "-";

  final value = v.toString().trim();

  if (value.isEmpty) return "-";
  if (value.toLowerCase() == "null") return "-";

  return value;
}

String safeDate(dynamic val) {
  if (val == null) return "-";

  if (val is String) return val;

  if (val is Map && val['date'] != null) {
    return val['date'].toString();
  }

  return "-";
}

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
  final String agreementPrice;
  final String policeVerificationPdf;

  // DATES
  final String currentDate;
  final String shiftingDate;

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
    required this.agreementPrice,
    required this.policeVerificationPdf,
    required this.currentDate,
    required this.shiftingDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
  });

  factory PoliceyearlyModel.fromJson(Map<String, dynamic> json) {
    return PoliceyearlyModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      // OWNER
      ownerName: safe(json['owner_name']),
      ownerRelation: safe(json['owner_relation']),
      ownerRelationPerson: safe(json['relation_person_name_owner']),
      ownerAddress: safe(json['parmanent_addresss_owner']),
      ownerMobile: safe(json['owner_mobile_no']),
      ownerAadhar: safe(json['owner_addhar_no']),
      ownerAadharFront: safe(json['owner_aadhar_front']),
      ownerAadharBack: safe(json['owner_aadhar_back']),

      // TENANT
      tenantName: safe(json['tenant_name']),
      tenantRelation: safe(json['tenant_relation']),
      tenantRelationPerson: safe(json['relation_person_name_tenant']),
      tenantAddress: safe(json['permanent_address_tenant']),
      tenantMobile: safe(json['tenant_mobile_no']),
      tenantAadhar: safe(json['tenant_addhar_no']),
      tenantAadharFront: safe(json['tenant_aadhar_front']),
      tenantAadharBack: safe(json['tenant_aadhar_back']),
      tenantImage: safe(json['tenant_image']),

      // PROPERTY
      rentedAddress: safe(json['rented_address']),
      bhk: safe(json['Bhk']),
      floor: safe(json['floor']),
      parking: safe(json['parking']),
      furniture: safe(json['furniture']),

      // AGREEMENT
      agreementType: safe(json['agreement_type']),
      agreementPrice: safe(json['agreement_price']),
      policeVerificationPdf: safe(json['police_verification_pdf']),

      // DATES
      currentDate: safeDate(json['current_dates']),
      shiftingDate: safeDate(json['shifting_date']),

      // FIELD WORKER
      fieldWorkerName: safe(json['Fieldwarkarname']),
      fieldWorkerNumber: safe(json['Fieldwarkarnumber']),
    );
  }
}

Future<List<PoliceyearlyModel>> fetchPoliceYearly(String number) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_yearly.php?Fieldwarkarnumber=$number",
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

class YearlyPoliceVerification extends StatefulWidget {
  final String number;
  const YearlyPoliceVerification({super.key,required this.number});

  @override
  State<YearlyPoliceVerification> createState() =>
      _YearlyPoliceVerificationScreenState();
}

class _YearlyPoliceVerificationScreenState
    extends State<YearlyPoliceVerification> {
  late Future<List<PoliceyearlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchPoliceYearly(widget.number);
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
              final v = list[i];

              return
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PoliceVerificationDetailScreen(p: v,)));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withOpacity(.05),
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// ✅ IMAGE + BADGE
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Stack(
                          children: [

                            Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${v.tenantImage}",
                              height: 190,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 190,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),

                            /// ✅ BADGE (CONSISTENT WITH OTHER SCREENS)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFF59E0B),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  v.agreementType,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontFamily: "PoppinsMedium",
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            /// ✅ ADDRESS (PRIMARY DATA)
                            Text(
                              v.rentedAddress,
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold,
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),

                            const SizedBox(height: 10),

                            /// ✅ RENT SNAPSHOT
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Agreement Price",
                                  style: TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: 12,
                                    color: theme.brightness == Brightness.dark
                                        ? Colors.white70
                                        : Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "₹${v.agreementPrice}",
                                  style: TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ),
                              ],
                            ),


                            const SizedBox(height: 12),

                            /// ✅ TENANT + WORKER (META DATA)
                            Text(
                              "Tenant: ${v.tenantName}",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "PoppinsMedium",
                                color: theme.brightness == Brightness.dark
                                    ? Colors.white70
                                    : Colors.grey.shade700,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Row(
                              children: [
                                const Icon(Icons.person, size: 15, color: Colors.grey),
                                const SizedBox(width: 6),
                                Text(
                                  "Field Worker: ${v.fieldWorkerName}",
                                  style: const TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
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
