import 'package:flutter/material.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import '../../../Administrator/imagepreviewscreen.dart';
import '../Monthly_police_verification.dart';

class PoliceMonthlyDetailScreen extends StatelessWidget {
  final PoliceMonthlyModel v;

  const PoliceMonthlyDetailScreen({super.key, required this.v});

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";

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
        title: const Text("Police Verification Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 TENANT IMAGE HEADER
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                img(v.tenantImage),
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 ADDRESS + TYPE
            Text(
              v.rentedAddress,
              style: TextStyle(
                fontSize: 18,
                fontFamily: "PoppinsBold",
                color: textColor,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              v.agreementType,
              style: TextStyle(
                fontSize: 13,
                color: subText,
              ),
            ),

            const SizedBox(height: 22),

            /// 🔥 TENANT DETAILS
            _section("Tenant Details", [
              _row("Name", v.tenantName),
              _row("Relation", v.tenantRelation),
              _row("Relation Person", v.tenantRelationName),
              _row("Address", v.tenantAddress),
              _row("Mobile", v.tenantMobile),
              _row("Aadhar", v.tenantAadhar),
            ], cardColor),

            /// 🔥 OWNER DETAILS
            _section("Owner Details", [
              _row("Name", v.ownerName),
              _row("Relation", v.ownerRelation),
              _row("Relation Person", v.ownerRelationName),
              _row("Address", v.ownerAddress),
              _row("Mobile", v.ownerMobile),
              _row("Aadhar", v.ownerAadhar),
            ], cardColor),

            /// 🔥 PROPERTY DETAILS
            _section("Property Info", [
              _row("Rented Address", v.rentedAddress),
              _row("BHK", v.bhk),
              _row("Floor", v.floor),
              _row("Parking", v.parking),
              _row("Monthly Rent", "₹${v.monthlyRent}"),
              _row("Security", "₹${v.security}"),
              _row("Meter", v.meter),
              _row("Maintenance", v.maintaince),
              _row("Furniture", v.furniture),
            ], cardColor),

            /// 🔥 FIELD WORKER
            _section("Field Worker", [
              _row("Name", v.fieldWorkerName),
              _row("Number", v.fieldWorkerNumber),
            ], cardColor),

            /// 🔥 COMPANY DETAILS
            _section("Company Details", [
              _row("Company Name", v.companyName),
              _row("GST No", v.gstNo),
              _row("PAN No", v.panNo),
            ], cardColor),

            /// 🔥 PAYMENT DETAILS
            _section("Charges", [
              _row("Agreement Price", "₹${v.agreementPrice}"),
              _row("Notary Price", "₹${v.notaryPrice}"),
            ], cardColor),

            /// 🔥 REMINDER
            _section("Reminder", [
              _row(
                "Reminder Sent",
                v.renewalReminderSent == 1 ? "Yes" : "No",
              ),
              _row("Sent On", v.renewalReminderSentOn),
            ], cardColor),

            /// 🔥 DOCUMENTS
            _imageSection(
              "Owner Aadhar",
              v.ownerAadharFront,
              v.ownerAadharBack,
              cardColor,
              context,
            ),

            _imageSection(
              "Tenant Aadhar",
              v.tenantAadharFront,
              v.tenantAadharBack,
              cardColor,
              context,
            ),

            /// 🔥 PDFs / Images
            _section("Documents", [
              _row("Police Verification PDF", v.policeVerificationPdf),
              _row("Agreement PDF", v.agreementPdf),
              _row("Notary Image", v.notaryImg),
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
          Text(title,
              style: const TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 14,
              )),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  /// ✅ CLEAN ROW
  Widget _row(String title, String? value) {
    final v = value == null || value.isEmpty ? "—" : value;

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
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              v,
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
      String? front,
      String? back,
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
          Text(title,
              style: const TextStyle(fontFamily: "PoppinsBold")),
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

  Widget _docImage(String? path, BuildContext context) {
    if (path == null || path.isEmpty) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.image_not_supported),
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
