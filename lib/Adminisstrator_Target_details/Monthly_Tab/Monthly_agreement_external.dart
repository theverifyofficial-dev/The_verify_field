import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

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


Future<List<AgreementMonthlyModel>> fetchAgreementMonthly(String number) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_monthly_show.php?Fieldwarkarnumber=${number}",
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
class MonthlyAgreementExternal extends StatefulWidget {
  final String number;

  const MonthlyAgreementExternal({super.key, required this.number});

  @override
  State<MonthlyAgreementExternal> createState() =>
      _MonthlyAgreementExternalState();
}

class _MonthlyAgreementExternalState extends State<MonthlyAgreementExternal> {
  late Future<List<AgreementMonthlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchAgreementMonthly(widget.number);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      /// ✅ HEADER
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          "Active Agreements",
          style: TextStyle(
            color: Colors.white,
              fontFamily: "PoppinsMedium",
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      /// ✅ BODY
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
            padding: const EdgeInsets.all(16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final a = list[i];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AgreementMonthlyDetailScreen(a: a),
                    ),
                  );
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

                      /// ✅ IMAGE
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                        child: Stack(
                          children: [
                            Image.network(
                              "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${a.tenantImage}",
                              height: 190,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),

                            /// ✅ BADGE
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  a.agreementType,
                                  style: const TextStyle(
                                    fontSize: 12,
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

                            /// ✅ ADDRESS
                            Text(
                              a.rentedAddress,
                              style:  TextStyle(
                                fontSize: 16,
                                color: theme.brightness==Brightness.dark?Colors.white:Colors.black87,

                                fontFamily: "PoppinsMedium",
                                fontWeight: FontWeight.bold,
                              ),

                            ),

                            const SizedBox(height: 10),

                            /// ✅ INFO ROW
                            Row(
                              children: [
                                _iconInfo(Icons.bed, a.bhk),
                                _divider(),
                                _iconInfo(Icons.layers, a.floor),
                                _divider(),
                                _iconInfo(Icons.local_parking, a.parking),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// ✅ RENT
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text(
                                  "Monthly Rent",
                                  style: TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: 12,
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "₹${a.monthlyRent}",
                                  style:  TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: 16,
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            /// ✅ SECURITY
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Text(
                                  "Security Deposit",
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontFamily: "PoppinsMedium",
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade600,
                                  ),
                                ),
                                Text(
                                  "₹${a.security}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: "PoppinsMedium",
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade600,

                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// ✅ FIELD WORKER
                            Row(
                              children: [
                                 Icon(Icons.person,
                                    size: 16,
                                   color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade600,
                                 ),
                                const SizedBox(width: 6),
                                Text(
                                  "Field Worker: ${a.fieldWorkerName}",
                                  style:  TextStyle(
                                    fontFamily: "PoppinsMedium",
                                    fontSize: 12,
                                    color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade600,
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

  /// ICON + TEXT
  Widget _iconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFFEF4444)),
        const SizedBox(width: 4),
        Text(
          text,
          style:  TextStyle(fontSize: 11, fontFamily: "PoppinsMedium",
              color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.black87,

              fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 14,
      width: 1,
      color: Colors.grey.shade300,
    );
  }
}

