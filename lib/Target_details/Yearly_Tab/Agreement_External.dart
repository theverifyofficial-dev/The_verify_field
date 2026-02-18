import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

import '../../Administrator/imagepreviewscreen.dart';
import 'Target_Under_Details_/agreementDetailScreen.dart';

/// =======================
/// MODEL
/// =======================
class Agreement {
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
  final String meter;
  final String maintenance;

  // RENT
  final String monthlyRent;
  final String security;
  final String installmentSecurity;
  final String customMeterUnit;
  final String customMaintenanceCharge;

  // AGREEMENT
  final String agreementType;
  final String agreementPrice;
  final String notaryPrice;
  final String agreementPdf;
  final String notaryImage;
  final String policeVerificationPdf;

  // DATES
  final String shiftingDate;
  final String currentDate;

  // FIELD WORKER
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  // COMPANY
  final String? companyName;
  final String? gstNo;
  final String? panNo;
  final String? panPhoto;

  // REMINDER
  final bool renewalReminderSent;
  final String? renewalReminderDate;

  Agreement({
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
    required this.meter,
    required this.maintenance,

    required this.monthlyRent,
    required this.security,
    required this.installmentSecurity,
    required this.customMeterUnit,
    required this.customMaintenanceCharge,

    required this.agreementType,
    required this.agreementPrice,
    required this.notaryPrice,
    required this.agreementPdf,
    required this.notaryImage,
    required this.policeVerificationPdf,

    required this.shiftingDate,
    required this.currentDate,

    required this.fieldWorkerName,
    required this.fieldWorkerNumber,

    this.companyName,
    this.gstNo,
    this.panNo,
    this.panPhoto,

    required this.renewalReminderSent,
    this.renewalReminderDate,
  });

  /// ✅ SAFE DATE PARSER
  static String _parseDate(dynamic val) {
    if (val == null) return '';
    if (val is String) return val;
    if (val is Map && val['date'] != null) return val['date'].toString();
    return '';
  }

  factory Agreement.fromJson(Map<String, dynamic> json) {
    return Agreement(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      // OWNER
      ownerName: json['owner_name'] ?? '',
      ownerRelation: json['owner_relation'] ?? '',
      ownerRelationPerson: json['relation_person_name_owner'] ?? '',
      ownerAddress: json['parmanent_addresss_owner'] ?? '',
      ownerMobile: json['owner_mobile_no'] ?? '',
      ownerAadhar: json['owner_addhar_no'] ?? '',
      ownerAadharFront: json['owner_aadhar_front'] ?? '',
      ownerAadharBack: json['owner_aadhar_back'] ?? '',

      // TENANT
      tenantName: json['tenant_name'] ?? '',
      tenantRelation: json['tenant_relation'] ?? '',
      tenantRelationPerson: json['relation_person_name_tenant'] ?? '',
      tenantAddress: json['permanent_address_tenant'] ?? '',
      tenantMobile: json['tenant_mobile_no'] ?? '',
      tenantAadhar: json['tenant_addhar_no'] ?? '',
      tenantAadharFront: json['tenant_aadhar_front'] ?? '',
      tenantAadharBack: json['tenant_aadhar_back'] ?? '',
      tenantImage: json['tenant_image'] ?? '',

      // PROPERTY
      rentedAddress: json['rented_address'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      parking: json['parking'] ?? '',
      furniture: json['furniture'] ?? '',
      meter: json['meter'] ?? '',
      maintenance: json['maintaince'] ?? '',

      // RENT
      monthlyRent: json['monthly_rent'] ?? '',
      security: json['securitys'] ?? '',
      installmentSecurity: json['installment_security_amount'] ?? '',
      customMeterUnit: json['custom_meter_unit'] ?? '',
      customMaintenanceCharge: json['custom_maintenance_charge'] ?? '',

      // AGREEMENT
      agreementType: json['agreement_type'] ?? '',
      agreementPrice: json['agreement_price'] ?? '',
      notaryPrice: json['notary_price'] ?? '',
      agreementPdf: json['agreement_pdf'] ?? '',
      notaryImage: json['notry_img'] ?? '',
      policeVerificationPdf: json['police_verification_pdf'] ?? '',

      // DATES
      shiftingDate: _parseDate(json['shifting_date']),
      currentDate: _parseDate(json['current_dates']),

      // FIELD WORKER
      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',

      // COMPANY
      companyName: json['company_name'],
      gstNo: json['gst_no'],
      panNo: json['pan_no'],
      panPhoto: json['pan_photo'],

      // REMINDER
      renewalReminderSent: (json['renewal_reminder_sent'] ?? 0) == 1,
      renewalReminderDate: json['renewal_reminder_sent_on'],
    );
  }
}

Future<List<Agreement>> fetchAgreements() async {
  final prefs = await SharedPreferences.getInstance();
  final FNumber = prefs.getString('number') ?? "";
  print(FNumber);
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_yearly_show.php?Fieldwarkarnumber=$FNumber",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Server Error");
  }

  final decoded = json.decode(res.body);

  if (decoded['status'] != true) {
    throw Exception("API Status False");
  }

  final List list = decoded['data'] ?? [];

  return list.map((e) => Agreement.fromJson(e)).toList();
}

class AgreementYearlyScreen extends StatelessWidget {
  const AgreementYearlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),

      /// 🔥 SAME AS BUILDING UI
      body: FutureBuilder<List<Agreement>>(
        future: fetchAgreements(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: Image.asset(AppImages.loader, height: 40),
            );
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
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade800;
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AgreementExternalDetail(agreement: a),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF171717)
                        : Colors.white,
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
                              "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${a.tenantImage}",
                              height: 230,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 210,
                                width: double.infinity,
                                color: Colors.grey.shade300,
                                child: const Icon(Icons.image_not_supported),
                              ),
                            ),
                          ),

                          /// AGREEMENT TYPE BADGE
                          Positioned(
                            top: 14,
                            left: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(.95),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                a.agreementType,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "PoppinsBold",
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          /// RENT BADGE
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(.95),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${indianCurrency(a.monthlyRent)}",
                                style: const TextStyle(
                                  fontFamily: "PoppinsBold",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
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
                              a.rentedAddress.isEmpty ? "No Address" : a.rentedAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: "PoppinsBold",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// BHK / FLOOR / PARKING
                            Row(
                              children: [
                                _modernChip(Icons.home, a.bhk, subText),
                                _modernChip(Icons.layers, a.floor, subText),
                                _modernChip(Icons.local_parking, a.parking, subText),
                              ],
                            ),

                            const SizedBox(height: 12),

                            /// RENT + SECURITY
                            Text(
                              "Security: ${indianCurrency(a.security)}",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Poppins",
                                fontSize: 13,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 6),

                            /// OWNER
                            Text(
                              "Owner: ${a.ownerName}",
                              style: TextStyle(
                                fontFamily: "PoppinsMedium",
                                fontSize: 13,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// SHIFTING DATE
                            Text(
                              "Shift: ${a.shiftingDate}",
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: subText,
                              ),
                            ),

                            const SizedBox(height: 10),

                            /// FIELD WORKER
                            Text(
                              "Field Worker: ${a.fieldWorkerName}",
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
  if (text.isEmpty) return const SizedBox();

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
String indianCurrency(String value) {
  final amount = int.tryParse(value) ?? 0;

  final formatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  return formatter.format(amount);
}


