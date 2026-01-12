import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Monthly_agreement_external.dart';

Future<List<AgreementMonthlyModel>> fetchAgreementMonthly() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_monthly_show.php?Fieldwarkarnumber=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Agreement Monthly API Error");
  }

  final decoded = jsonDecode(res.body);

  if (decoded['status'] != true) return [];

  final List list = decoded['data'] ?? [];

  return list.map((e) => AgreementMonthlyModel.fromJson(e)).toList();
}

class AgreementMonthlyDetailScreen extends StatelessWidget {
  final AgreementMonthlyModel a;

  const AgreementMonthlyDetailScreen({super.key, required this.a});

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

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Agreement Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// TENANT IMAGE
            Image.network(
              img(a.tenantImage),
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),

            const SizedBox(height: 12),

            row("Agreement Type", a.agreementType),
            row("Tenant", a.tenantName),
            row("Tenant Mobile", a.tenantMobile),
            row("Owner", a.ownerName),
            row("Owner Mobile", a.ownerMobile),

            const Divider(),

            row("Address", a.rentedAddress),
            row("BHK", a.bhk),
            row("Floor", a.floor),
            row("Parking", a.parking),

            const Divider(),

            row("Monthly Rent", a.monthlyRent),
            row("Security", a.security),
            row("Maintenance", a.maintenance),
            row("Meter", a.meter),

            const Divider(),

            row("Agreement Price", a.agreementPrice),
            row("Notary Price", a.notaryPrice),
            row("Shifting Date", a.shiftingDate),

            const Divider(),

            row("Field Worker", a.fieldWorkerName),

            const SizedBox(height: 16),

            /// AADHAR IMAGES
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Documents", style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(child: Image.network(img(a.ownerAadharFront))),
                const SizedBox(width: 6),
                Expanded(child: Image.network(img(a.ownerAadharBack))),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(child: Image.network(img(a.tenantAadharFront))),
                const SizedBox(width: 6),
                Expanded(child: Image.network(img(a.tenantAadharBack))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
