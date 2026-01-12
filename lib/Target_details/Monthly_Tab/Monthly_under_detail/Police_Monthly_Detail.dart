import 'package:flutter/material.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import '../Monthly_police_verification.dart';

class PoliceMonthlyDetailScreen extends StatelessWidget {
  final PoliceMonthlyModel v;

  const PoliceMonthlyDetailScreen({super.key, required this.v});

  Widget row(String t, String? v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(t,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 6, child: Text(v == null || v.isEmpty ? "-" : v)),
        ],
      ),
    );
  }

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";

  Widget docImg(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        height: 120,
        color: Colors.grey[300],
        child: const Center(child: Text("No Image")),
      );
    }
    return Image.network(
      img(path),
      height: 120,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        height: 120,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// TENANT IMAGE
            Image.network(
              img(v.tenantImage),
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

            row("Agreement Type", v.agreementType),

            const Divider(),

            /// ===== TENANT DETAILS =====
            row("Tenant Name", v.tenantName),
            row("Tenant Relation", v.tenantRelation),
            row("Relation Person", v.tenantRelationName),
            row("Tenant Address", v.tenantAddress),
            row("Tenant Mobile", v.tenantMobile),
            row("Tenant Aadhar", v.tenantAadhar),

            const Divider(),

            /// ===== OWNER DETAILS =====
            row("Owner Name", v.ownerName),
            row("Owner Relation", v.ownerRelation),
            row("Relation Person", v.ownerRelationName),
            row("Owner Address", v.ownerAddress),
            row("Owner Mobile", v.ownerMobile),
            row("Owner Aadhar", v.ownerAadhar),

            const Divider(),

            /// ===== PROPERTY DETAILS =====
            row("Rented Address", v.rentedAddress),
            row("BHK", v.bhk),
            row("Floor", v.floor),
            row("Parking", v.parking),
            row("Monthly Rent", v.monthlyRent),
            row("Security", v.security),
            row("Meter", v.meter),
            row("Maintenance", v.maintaince),
            row("Furniture", v.furniture),

            const Divider(),

            /// ===== FIELD WORKER =====
            row("Field Worker Name", v.fieldWorkerName),
            row("Field Worker Number", v.fieldWorkerNumber),

            const Divider(),

            /// ===== COMPANY DETAILS =====
            row("Company Name", v.companyName),
            row("GST No", v.gstNo),
            row("PAN No", v.panNo),

            const Divider(),

            /// ===== PAYMENT DETAILS =====
            row("Agreement Price", v.agreementPrice),
            row("Notary Price", v.notaryPrice),

            const Divider(),

            /// ===== REMINDER =====
            row("Renewal Reminder Sent",
                v.renewalReminderSent == 1 ? "Yes" : "No"),
            row("Reminder Sent On", v.renewalReminderSentOn),

            const Divider(),

            /// ===== DOCUMENTS =====
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Documents",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(child: docImg(v.ownerAadharFront)),
                const SizedBox(width: 6),
                Expanded(child: docImg(v.ownerAadharBack)),
              ],
            ),

            const SizedBox(height: 6),

            Row(
              children: [
                Expanded(child: docImg(v.tenantAadharFront)),
                const SizedBox(width: 6),
                Expanded(child: docImg(v.tenantAadharBack)),
              ],
            ),

            const SizedBox(height: 10),

            row("Police Verification PDF", v.policeVerificationPdf),
            row("Agreement PDF", v.agreementPdf),
            row("Notary Image", v.notaryImg),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
