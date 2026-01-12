import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/constant.dart';

import 'Monthly_under_detail/Agreement_Monthly_Detail.dart';


class AgreementMonthlyModel {
  final int id;

  // OWNER
  final String ownerName;
  final String ownerRelation;
  final String relationPersonOwner;
  final String ownerAddress;
  final String ownerMobile;
  final String ownerAadhar;

  // TENANT
  final String tenantName;
  final String tenantRelation;
  final String relationPersonTenant;
  final String tenantAddress;
  final String tenantMobile;
  final String tenantAadhar;

  // PROPERTY
  final String rentedAddress;
  final String bhk;
  final String floor;
  final String parking;

  // RENT
  final String monthlyRent;
  final String security;
  final String meter;
  final String maintenance;

  // IMAGES
  final String ownerAadharFront;
  final String ownerAadharBack;
  final String tenantAadharFront;
  final String tenantAadharBack;
  final String tenantImage;

  // DOCS
  final String agreementPdf;
  final String policeVerificationPdf;

  // OTHER
  final String agreementType;
  final String agreementPrice;
  final String notaryPrice;
  final String fieldWorkerName;
  final String shiftingDate;

  AgreementMonthlyModel({
    required this.id,
    required this.ownerName,
    required this.ownerRelation,
    required this.relationPersonOwner,
    required this.ownerAddress,
    required this.ownerMobile,
    required this.ownerAadhar,
    required this.tenantName,
    required this.tenantRelation,
    required this.relationPersonTenant,
    required this.tenantAddress,
    required this.tenantMobile,
    required this.tenantAadhar,
    required this.rentedAddress,
    required this.bhk,
    required this.floor,
    required this.parking,
    required this.monthlyRent,
    required this.security,
    required this.meter,
    required this.maintenance,
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    required this.tenantImage,
    required this.agreementPdf,
    required this.policeVerificationPdf,
    required this.agreementType,
    required this.agreementPrice,
    required this.notaryPrice,
    required this.fieldWorkerName,
    required this.shiftingDate,
  });

  factory AgreementMonthlyModel.fromJson(Map<String, dynamic> json) {
    return AgreementMonthlyModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      ownerName: json['owner_name']?.toString() ?? '',
      ownerRelation: json['owner_relation']?.toString() ?? '',
      relationPersonOwner: json['relation_person_name_owner']?.toString() ?? '',
      ownerAddress: json['parmanent_addresss_owner']?.toString() ?? '',
      ownerMobile: json['owner_mobile_no']?.toString() ?? '',
      ownerAadhar: json['owner_addhar_no']?.toString() ?? '',

      tenantName: json['tenant_name']?.toString() ?? '',
      tenantRelation: json['tenant_relation']?.toString() ?? '',
      relationPersonTenant: json['relation_person_name_tenant']?.toString() ?? '',
      tenantAddress: json['permanent_address_tenant']?.toString() ?? '',
      tenantMobile: json['tenant_mobile_no']?.toString() ?? '',
      tenantAadhar: json['tenant_addhar_no']?.toString() ?? '',

      rentedAddress: json['rented_address']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      floor: json['floor']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',

      monthlyRent: json['monthly_rent']?.toString() ?? '',
      security: json['securitys']?.toString() ?? '',
      meter: json['meter']?.toString() ?? '',
      maintenance: json['maintaince']?.toString() ?? '',

      ownerAadharFront: json['owner_aadhar_front']?.toString() ?? '',
      ownerAadharBack: json['owner_aadhar_back']?.toString() ?? '',
      tenantAadharFront: json['tenant_aadhar_front']?.toString() ?? '',
      tenantAadharBack: json['tenant_aadhar_back']?.toString() ?? '',
      tenantImage: json['tenant_image']?.toString() ?? '',

      agreementPdf: json['agreement_pdf']?.toString() ?? '',
      policeVerificationPdf: json['police_verification_pdf']?.toString() ?? '',

      agreementType: json['agreement_type']?.toString() ?? '',
      agreementPrice: json['agreement_price']?.toString() ?? '',
      notaryPrice: json['notary_price']?.toString() ?? '',

      fieldWorkerName: json['Fieldwarkarname']?.toString() ?? '',
      shiftingDate: json['shifting_date']?['date']?.toString() ?? '',
    );
  }
}

/// =======================
/// API FETCH
/// =======================
Future<List<AgreementMonthlyModel>> fetchAgreementMonthly() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_monthly_show.php?Fieldwarkarnumber=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Agreement Monthly API Error");
  }

  final decoded = json.decode(res.body);
  print(res.body);

  final List list = decoded['data'] ?? [];

  return list.map((e) => AgreementMonthlyModel.fromJson(e)).toList();
}

/// =======================
/// UI SCREEN (SAME STYLE)
/// =======================
class MonthlyAgreementExternalScreen extends StatefulWidget {
  const MonthlyAgreementExternalScreen({super.key});

  @override
  State<MonthlyAgreementExternalScreen> createState() =>
      _MonthlyAgreementExternalScreenState();
}

class _MonthlyAgreementExternalScreenState
    extends State<MonthlyAgreementExternalScreen> {
  late Future<List<AgreementMonthlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchAgreementMonthly();
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
      body: FutureBuilder<List<AgreementMonthlyModel>>(
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
            return const Center(child: Text("No Agreements Found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final a = list[i];

              return
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AgreementMonthlyDetailScreen(a: a,)));
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
                        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${a.tenantImage}",
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
                              color: Colors.orange.withOpacity(.20),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              a.agreementType,
                              style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// ADDRESS
                          Text(
                            a.rentedAddress,
                            style: theme.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 6),

                          /// INFO ROW
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _InfoItem(Icons.home, a.bhk),
                              _InfoItem(Icons.layers, a.floor),
                              _InfoItem(Icons.local_parking, a.parking),
                            ],
                          ),

                          const SizedBox(height: 8),

                          /// RENT + SECURITY
                          Text(
                            "Rent: ₹${a.monthlyRent} | Security: ₹${a.security}",
                            style: theme.textTheme.bodySmall,
                          ),

                          const SizedBox(height: 6),

                          /// FIELD WORKER
                          Text(
                            "Field Worker: ${a.fieldWorkerName}",
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
