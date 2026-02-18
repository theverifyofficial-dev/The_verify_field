import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Target_details/Yearly_Tab/Book_Rent.dart';

import '../../../Administrator/imagepreviewscreen.dart';
import '../Police_verification.dart';

Future<List<PoliceyearlyModel>> fetchPoliceYearly() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_yearly.php?Fieldwarkarnumber=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Police Yearly API Error");
  }

  final decoded = jsonDecode(res.body);

  if (decoded['status'] != true) return [];

  final List list = decoded['data'] ?? [];

  return list.map((e) => PoliceyearlyModel.fromJson(e)).toList();
}

class PoliceVerificationDetailScreen extends StatelessWidget {
  final PoliceyearlyModel p;

  const PoliceVerificationDetailScreen({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Verification Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 TENANT IMAGE (HEADER STYLE)
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewScreen(
                        imageUrl:
                        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${p.tenantImage}",
                      ),
                    ),
                  );
                },
                child: Image.network(
                  "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${p.tenantImage}",
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 TOP SUMMARY
            Text(
              p.rentedAddress,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "PoppinsBold",
                color: textColor,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Agreement: ${p.agreementType}",
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Poppins",
                color: subText,
              ),
            ),
            const SizedBox(height: 4),

            Text(
              "Filled Date: ${formatDate(p.currentDate)}",
              style: TextStyle(
                fontSize: 13,
                fontFamily: "Poppins",
                color: subText,
              ),
            ),
            const SizedBox(height: 22),

            /// 🔥 PROPERTY INFO
            _section("Property Info", [
              _row("BHK", p.bhk),
              _row("Floor", p.floor),
              _row("Parking", p.parking),
              _row("Furniture", p.furniture),
            ], cardColor),

            /// 🔥 TENANT INFO
            _section("Tenant Details", [
              _row("Name", p.tenantName),
              _row("Relation", p.tenantRelation),
              _row("Relation Person", p.tenantRelationPerson),
              _row("Address", p.tenantAddress),
              _row("Mobile", p.tenantMobile),
              _row("Aadhar", p.tenantAadhar),
            ], cardColor),

            /// 🔥 OWNER INFO
            _section("Owner Details", [
              _row("Name", p.ownerName),
              _row("Relation", p.ownerRelation),
              _row("Relation Person", p.ownerRelationPerson),
              _row("Address", p.ownerAddress),
              _row("Mobile", p.ownerMobile),
              _row("Aadhar", p.ownerAadhar),
            ], cardColor),

            /// 🔥 FIELD WORKER
            _section("Field Worker", [
              _row("Name", p.fieldWorkerName),
              _row("Number", p.fieldWorkerNumber),
            ], cardColor),

            /// 🔥 OWNER AADHAR
            _imageSection(
              "Owner Aadhar",
              p.ownerAadharFront,
              p.ownerAadharBack,
              cardColor,
              context,
            ),

            /// 🔥 TENANT AADHAR
            _imageSection(
              "Tenant Aadhar",
              p.tenantAadharFront,
              p.tenantAadharBack,
              cardColor,
              context,
            ),

            /// 🔥 PDF (if exists)
            if (p.policeVerificationPdf.isNotEmpty)
              _section("Documents", [
                _row("Police Verification PDF", p.policeVerificationPdf),
              ], cardColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// ✅ SECTION CARD
  Widget _section(String title, List<Widget> children, Color cardColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "PoppinsBold",
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  /// ✅ CLEAN ROW
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontFamily: "PoppinsMedium",
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.isEmpty ? "—" : value,
              style: const TextStyle(
                fontSize: 13.5,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ IMAGE SECTION
  Widget _imageSection(
      String title,
      String front,
      String back,
      Color cardColor,
      BuildContext context,
      ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontFamily: "PoppinsBold")),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _docImage(front, context)),
              const SizedBox(width: 10),
              Expanded(child: _docImage(back, context)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _docImage(String path, BuildContext context) {
    if (path.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
      );
    }

    final url =
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImagePreviewScreen(imageUrl: url),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          url,
          height: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
Widget row(String t, String v) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 6,
          child: Text(v.isEmpty ? "-" : v),
        ),
      ],
    ),
  );
}
String img(String path) =>
    "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";
