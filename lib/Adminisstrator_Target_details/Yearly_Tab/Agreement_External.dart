import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';

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

/// =======================
/// API CALL
/// =======================
Future<List<Agreement>> fetchAgreements(String num) async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_yearly_show.php?Fieldwarkarnumber=$num",
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

/// =======================
/// UI SCREEN
/// =======================
class AgreementYearly extends StatelessWidget {
  final String num;
  const AgreementYearly({super.key,required this.num});

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
        future: fetchAgreements(num),
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

              return GestureDetector(
                onTap: (){
              Navigator.push(
                  context, MaterialPageRoute(
                  builder: (_)=> AgreementExternalDetail(agreement: a,),
                ),
              );
                },
                  child:
                  Container(
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
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey,
                                  height: 190,
                                  width: double.infinity,
                                ),
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
                                  _iconInfo(Icons.bed, a.bhk,context),
                                  _divider(),
                                  _iconInfo(Icons.layers, a.floor,context),
                                  _divider(),
                                  _iconInfo(Icons.local_parking, a.parking,context),
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
}

/// INFO ITEM

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
Widget _iconInfo(IconData icon, String text,BuildContext context) {
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
class _DocBtn extends StatelessWidget {
  final String title;
  final String path;

  const _DocBtn(this.title, this.path);

  @override
  Widget build(BuildContext context) {
    if (path.isEmpty) return const SizedBox();

    return OutlinedButton.icon(
      icon: const Icon(Icons.picture_as_pdf, size: 16),
      label: Text(title, style: const TextStyle(fontSize: 12)),
      onPressed: () {
        final url =
            "https://verifyserve.social/Second%20PHP%20FILE/$path";
        // yahan tum url_launcher ya PDF viewer open kara sakte ho
        debugPrint("OPEN: $url");
      },
    );
  }
}

