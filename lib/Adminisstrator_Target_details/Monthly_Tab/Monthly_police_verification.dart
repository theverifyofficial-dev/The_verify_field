import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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
Future<List<PoliceMonthlyModel>> fetchPoliceMonthly() async {
  final prefs = await SharedPreferences.getInstance();
  final FNumber = prefs.getString('number') ?? "";
  print(FNumber);
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_monthly.php?Fieldwarkarnumber=$FNumber",
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
class MonthlyPoliceVerificationScreen extends StatefulWidget {
  const MonthlyPoliceVerificationScreen({super.key});

  @override
  State<MonthlyPoliceVerificationScreen> createState() =>
      _MonthlyPoliceVerificationScreenState();
}

class _MonthlyPoliceVerificationScreenState
    extends State<MonthlyPoliceVerificationScreen> {
  late Future<List<PoliceMonthlyModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchPoliceMonthly();
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

                final isDark = Theme.of(context).brightness == Brightness.dark;

                final cardColor =
                isDark ? const Color(0xFF1A1A1A) : Colors.white;

                final textColor =
                isDark ? Colors.white : Colors.black;

                final subText =
                isDark ? Colors.grey.shade400 : Colors.grey.shade600;

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
                      color: cardColor,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: isDark
                          ? []
                          : [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.black.withOpacity(.08),
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        /// 🔥 IMAGE SECTION
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(22),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${v.tenantImage}",
                                height: 210,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              /// 🔥 GRADIENT OVERLAY
                              Container(
                                height: 210,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black.withOpacity(.55),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),

                              /// 🔥 POLICE TAG
                              Positioned(
                                bottom: 14,
                                left: 14,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Text(
                                    v.agreementType,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontFamily: "PoppinsBold",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// 🔥 CONTENT
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 🔥 ADDRESS
                              Text(
                                v.rentedAddress,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "PoppinsBold",
                                  color: textColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              const SizedBox(height: 6),

                              /// 🔥 OWNER / TENANT STRIP
                              Text(
                                "${v.ownerName}  •  ${v.tenantName}",
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: subText,
                                ),
                              ),

                              const SizedBox(height: 14),

                              /// 🔥 PROPERTY INFO PILLS
                              Row(
                                children: [
                                  _pill(Icons.home, v.bhk),
                                  const SizedBox(width: 10),
                                  _pill(Icons.layers, v.floor),
                                  const SizedBox(width: 10),
                                  _pill(Icons.local_parking, v.parking),
                                ],
                              ),

                              const SizedBox(height: 14),


                              Row(
                                children: [
                                  /// 🔥 RENT STRIP
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.black26
                                            : const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Monthly Rent",
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: subText,
                                            ),
                                          ),
                                          Text(
                                            "₹${v.monthlyRent}",
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontFamily: "PoppinsBold",
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  /// 🔥 SECURITY STRIP
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? Colors.black26
                                            : const Color(0xFFF5F7FA),
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "Security Deposit",
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: subText,
                                            ),
                                          ),
                                          Text(
                                            "₹${v.security}",
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontFamily: "PoppinsBold",
                                              color: textColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              const SizedBox(height: 12),

                              /// 🔥 FIELD WORKER
                              Text(
                                "Field Worker • ${v.fieldWorkerName}",
                                style: TextStyle(
                                  fontSize: 11.5,
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
              }
          );
        },
      ),
    );
  }
}
Widget _pill(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(.06),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14),
        const SizedBox(width: 4),
        Text(
          text.isEmpty ? "-" : text,
          style: const TextStyle(fontSize: 11.5),
        ),
      ],
    ),
  );
}
