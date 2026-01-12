import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 6, child: Text(v)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Police Verification Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// TENANT IMAGE
            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${p.tenantImage}",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),

            row("Agreement Type", p.agreementType),
            row("Current Date", p.currentDate),

            const Divider(),
            row("Rented Address", p.rentedAddress),
            row("BHK", p.bhk),
            row("Floor", p.floor),
            row("Parking", p.parking),
            row("Furniture", p.furniture),

            const Divider(),
            row("Tenant Name", p.tenantName),
            row("Tenant Relation", p.tenantRelation),
            row("Tenant Relation Person", p.tenantRelationPerson),
            row("Tenant Address", p.tenantAddress),
            row("Tenant Mobile", p.tenantMobile),
            row("Tenant Aadhar", p.tenantAadhar),

            const Divider(),
            row("Owner Name", p.ownerName),
            row("Owner Relation", p.ownerRelation),
            row("Owner Relation Person", p.ownerRelationPerson),
            row("Owner Address", p.ownerAddress),
            row("Owner Mobile", p.ownerMobile),
            row("Owner Aadhar", p.ownerAadhar),

            const Divider(),
            row("Field Worker Name", p.fieldWorkerName),
            row("Field Worker Number", p.fieldWorkerNumber),

            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Owner Aadhar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(child: Image.network(img(p.ownerAadharFront))),
                const SizedBox(width: 6),
                Expanded(child: Image.network(img(p.ownerAadharBack))),
              ],
            ),

            const SizedBox(height: 10),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Tenant Aadhar",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(child: Image.network(img(p.tenantAadharFront))),
                const SizedBox(width: 6),
                Expanded(child: Image.network(img(p.tenantAadharBack))),
              ],
            ),

            const SizedBox(height: 10),
            if (p.policeVerificationPdf.isNotEmpty)
              row("Police Verification PDF", p.policeVerificationPdf),

          ],
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
