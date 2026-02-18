import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

import 'Monthly_under_detail/Police_Monthly_Detail.dart';

/// =======================
/// MODEL
/// =======================
class PoliceMonthlyModel {

  final int id;
  // OWNER
  final String ownerName;
  final String ownerRelation;
  final String ownerRelationName;
  final String ownerAddress;
  final String ownerMobile;
  final String ownerAadhar;

  // TENANT
  final String tenantName;
  final String tenantRelation;
  final String tenantRelationName;
  final String tenantAddress;
  final String tenantMobile;
  final String tenantAadhar;

  // PROPERTY
  final String rentedAddress;
  final String monthlyRent;
  final String security;
  final String meter;
  final String maintaince;
  final String bhk;
  final String floor;
  final String parking;

  // IMAGES & DOCS
  final String ownerAadharFront;
  final String ownerAadharBack;
  final String tenantAadharFront;
  final String tenantAadharBack;
  final String tenantImage;
  final String policeVerificationPdf;
  final String agreementPdf;
  final String notaryImg;

  // OTHER
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String agreementType;

  final String companyName;
  final String gstNo;
  final String panNo;
  final String panPhoto;
  final String furniture;

  final int renewalReminderSent;
  final String renewalReminderSentOn;

  final String agreementPrice;
  final String notaryPrice;

  PoliceMonthlyModel({
    required this.id,
    required this.ownerName,
    required this.ownerRelation,
    required this.ownerRelationName,
    required this.ownerAddress,
    required this.ownerMobile,
    required this.ownerAadhar,
    required this.tenantName,
    required this.tenantRelation,
    required this.tenantRelationName,
    required this.tenantAddress,
    required this.tenantMobile,
    required this.tenantAadhar,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.security,
    required this.meter,
    required this.maintaince,
    required this.bhk,
    required this.floor,
    required this.parking,
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    required this.tenantImage,
    required this.policeVerificationPdf,
    required this.agreementPdf,
    required this.notaryImg,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.agreementType,
    required this.companyName,
    required this.gstNo,
    required this.panNo,
    required this.panPhoto,
    required this.furniture,
    required this.renewalReminderSent,
    required this.renewalReminderSentOn,
    required this.agreementPrice,
    required this.notaryPrice,
  });

  factory PoliceMonthlyModel.fromJson(Map<String, dynamic> json) {
    return PoliceMonthlyModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      ownerName: json['owner_name']?.toString() ?? '',
      ownerRelation: json['owner_relation']?.toString() ?? '',
      ownerRelationName: json['relation_person_name_owner']?.toString() ?? '',
      ownerAddress: json['parmanent_addresss_owner']?.toString() ?? '',
      ownerMobile: json['owner_mobile_no']?.toString() ?? '',
      ownerAadhar: json['owner_addhar_no']?.toString() ?? '',

      tenantName: json['tenant_name']?.toString() ?? '',
      tenantRelation: json['tenant_relation']?.toString() ?? '',
      tenantRelationName: json['relation_person_name_tenant']?.toString() ?? '',
      tenantAddress: json['permanent_address_tenant']?.toString() ?? '',
      tenantMobile: json['tenant_mobile_no']?.toString() ?? '',
      tenantAadhar: json['tenant_addhar_no']?.toString() ?? '',

      rentedAddress: json['rented_address']?.toString() ?? '',
      monthlyRent: json['monthly_rent']?.toString() ?? '',
      security: json['securitys']?.toString() ?? '',
      meter: json['meter']?.toString() ?? '',
      maintaince: json['maintaince']?.toString() ?? '',
      bhk: json['Bhk']?.toString() ?? '',
      floor: json['floor']?.toString() ?? '',
      parking: json['parking']?.toString() ?? '',

      ownerAadharFront: json['owner_aadhar_front']?.toString() ?? '',
      ownerAadharBack: json['owner_aadhar_back']?.toString() ?? '',
      tenantAadharFront: json['tenant_aadhar_front']?.toString() ?? '',
      tenantAadharBack: json['tenant_aadhar_back']?.toString() ?? '',
      tenantImage: json['tenant_image']?.toString() ?? '',

      policeVerificationPdf: json['police_verification_pdf']?.toString() ?? '',
      agreementPdf: json['agreement_pdf']?.toString() ?? '',
      notaryImg: json['notry_img']?.toString() ?? '',

      fieldWorkerName: json['Fieldwarkarname']?.toString() ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber']?.toString() ?? '',

      agreementType: json['agreement_type']?.toString() ?? 'Police Verification',

      companyName: json['company_name']?.toString() ?? '',
      gstNo: json['gst_no']?.toString() ?? '',
      panNo: json['pan_no']?.toString() ?? '',
      panPhoto: json['pan_photo']?.toString() ?? '',
      furniture: json['furniture']?.toString() ?? '',

      renewalReminderSent:
      int.tryParse(json['renewal_reminder_sent']?.toString() ?? '0') ?? 0,
      renewalReminderSentOn:
      json['renewal_reminder_sent_on']?.toString() ?? '',

      agreementPrice: json['agreement_price']?.toString() ?? '',
      notaryPrice: json['notary_price']?.toString() ?? '',
    );
  }
}


/// =======================
/// API FETCH
/// =======================
Future<List<PoliceMonthlyModel>> fetchPoliceMonthly(String number) async {
  print(number);
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_monthly.php?Fieldwarkarnumber=${number}",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Police Monthly API Error");
  }

  final decoded = json.decode(res.body);
  print(res.body);

  final List list = decoded['data'] ?? [];

  return list.map((e) => PoliceMonthlyModel.fromJson(e)).toList();
}

/// =======================
/// UI SCREEN
/// =======================
class MonthlyPoliceVerification extends StatefulWidget {
  final String number;
  const MonthlyPoliceVerification({super.key, required this.number});

  @override
  State<MonthlyPoliceVerification> createState() =>
      _MonthlyPoliceVerificationScreenState();
}

class _MonthlyPoliceVerificationScreenState
    extends State<MonthlyPoliceVerification> {
  late Future<List<PoliceMonthlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchPoliceMonthly(widget.number);
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
      body: FutureBuilder<List<PoliceMonthlyModel>>(
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PoliceMonthlyDetailScreen(v: v),
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
  Widget _iconInfo(IconData icon, String text) {
    final safe = text.isEmpty ? "-" : text;

    return Row(
      children: [
        Icon(icon, size: 16, color: Color(0xFFF59E0B)),
        const SizedBox(width: 4),
        Text(
          safe,
          style: TextStyle(
            fontSize: 11,
            fontFamily: "PoppinsMedium",
            fontWeight: FontWeight.w600,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ],
    );
  }

}
