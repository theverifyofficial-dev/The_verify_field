import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/constant.dart';

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
/// =======================
/// API FETCH
/// =======================
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
              final b = list[i];

              return
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PoliceVerificationDetailScreen(p: b,)));
                },
                  child:
                Container(
                margin: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: theme.brightness == Brightness.dark
                      ? []
                      : [
                    BoxShadow(
                      blurRadius: 8,
                      color: Colors.black.withOpacity(.08),
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// IMAGE
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16)),
                      child: Image.network(
                        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${b.tenantImage}",
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 190,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// TAG
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(.20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Police Verification",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// ADDRESS
                          Text(
                            b.rentedAddress,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 4),

                          /// OWNER / TENANT
                          Text(
                            "Owner: ${b.ownerName} | Tenant: ${b.tenantName}",
                            style: theme.textTheme.bodySmall,
                          ),

                          const SizedBox(height: 10),

                          /// INFO ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoItem(Icons.home, b.bhk),
                              _InfoItem(Icons.layers, b.floor),
                              _InfoItem(Icons.local_parking, b.parking),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// MOBILE
                          Text(
                            "Owner: ${b.ownerMobile} | Tenant: ${b.tenantMobile}",
                            style: theme.textTheme.bodySmall,
                          ),

                          const SizedBox(height: 6),

                          /// FIELD WORKER
                          Text(
                            "Field Worker: ${b.fieldWorkerName}",
                            style: const TextStyle(
                                fontSize: 12, color: Colors.grey),
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
