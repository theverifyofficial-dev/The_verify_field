import 'package:flutter/material.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import '../Monthly_police_verification.dart';

class PoliceMonthlyDetailScreen extends StatelessWidget {
  final PoliceMonthlyModel v;

  const PoliceMonthlyDetailScreen({super.key, required this.v});

  static final Color primaryPurple = Color(0xFFF59E0B);
  static const String myFont = 'PoppinsMedium';

  // Theme Helpers
  Color getBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white10
          : const Color(0xFFF2F2F7);

  Color getCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black87
          : Colors.white;

  Color getText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : const Color(0xFF1C1C1E);

  Color getSub(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white60
          : Colors.black54;

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$path";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBg(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// APP BAR
          SliverAppBar(
            backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: primaryPurple, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              "POLICE VERIFICATION REPORT",
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: primaryPurple,
              ),
            ),
          ),

          /// CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HERO IMAGE
                  _hero(),

                  const SizedBox(height: 24),

                  _sectionLabel("AGREEMENT OVERVIEW"),
                  _overviewCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("TENANT PROFILE"),
                  _tenantCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("OWNER PROFILE"),
                  _ownerCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("PROPERTY STRUCTURE"),
                  _propertyCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("WORKER & COMPANY TRACE"),
                  _workerCompanyCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("FINANCIAL FOOTPRINT"),
                  _financialCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("REMINDER & STATUS"),
                  _reminderCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("VERIFICATION DOCUMENTS"),
                  _documents(),

                  const SizedBox(height: 20),

                  _sectionLabel("ATTACHMENTS"),
                  _attachmentsCard(context),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ---------------- HERO ----------------
  Widget _hero() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.network(
        img(v.tenantImage),
        height: 260,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  /// ---------------- CARDS ----------------

  Widget _overviewCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Agreement Type", v.agreementType, highlight: true),
    ],
  );

  Widget _tenantCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Tenant Name", v.tenantName),
      _dataRow(context, "Tenant Relation", v.tenantRelation),
      _dataRow(context, "Relation Person", v.tenantRelationName),
      _dataRow(context, "Tenant Address", v.tenantAddress),
      _dataRow(context, "Tenant Mobile", v.tenantMobile),
      _dataRow(context, "Tenant Aadhar", v.tenantAadhar),
    ],
  );

  Widget _ownerCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Owner Name", v.ownerName),
      _dataRow(context, "Owner Relation", v.ownerRelation),
      _dataRow(context, "Relation Person", v.ownerRelationName),
      _dataRow(context, "Owner Address", v.ownerAddress),
      _dataRow(context, "Owner Mobile", v.ownerMobile),
      _dataRow(context, "Owner Aadhar", v.ownerAadhar),
    ],
  );

  Widget _propertyCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Rented Address", v.rentedAddress),
      _dataRow(context, "BHK", v.bhk),
      _dataRow(context, "Floor", v.floor),
      _dataRow(context, "Parking", v.parking),
      _dataRow(context, "Furniture", v.furniture),
      const Divider(height: 22),
      _dataRow(context, "Monthly Rent", "₹${v.monthlyRent}", isBold: true),
      _dataRow(context, "Security", "₹${v.security}"),
      _dataRow(context, "Maintenance", "₹${v.maintaince}"),
      _dataRow(context, "Meter", v.meter),
    ],
  );

  Widget _workerCompanyCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Field Worker", v.fieldWorkerName, highlight: true),
      _dataRow(context, "Worker Number", v.fieldWorkerNumber),
      const Divider(height: 22),
      _dataRow(context, "Company Name", v.companyName),
      _dataRow(context, "GST No", v.gstNo),
      _dataRow(context, "PAN No", v.panNo),
    ],
  );

  Widget _financialCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Agreement Price", "₹${v.agreementPrice}"),
      _dataRow(context, "Notary Price", "₹${v.notaryPrice}"),
    ],
  );

  Widget _reminderCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Reminder Sent",
          v.renewalReminderSent == 1 ? "Yes" : "No",
          highlight: true),
      _dataRow(context, "Reminder Date", v.renewalReminderSentOn),
    ],
  );

  Widget _attachmentsCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Police Verification PDF", v.policeVerificationPdf),
      _dataRow(context, "Agreement PDF", v.agreementPdf),
      _dataRow(context, "Notary Image", v.notaryImg),
    ],
  );

  /// ---------------- DOCUMENTS ----------------
  Widget _documents() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _doc(v.ownerAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _doc(v.ownerAadharBack)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _doc(v.tenantAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _doc(v.tenantAadharBack)),
          ],
        ),
      ],
    );
  }

  Widget _doc(String? path) {
    if (path == null || path.isEmpty) {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.grey.withOpacity(.2),
        ),
        child: const Center(child: Text("No Image")),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        img(path),
        height: 110,
        fit: BoxFit.cover,
      ),
    );
  }

  /// ---------------- REUSABLE ----------------
  Widget _card(BuildContext context, {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: getCard(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _dataRow(BuildContext context, String t, String? v,
      {bool isBold = false, bool highlight = false}) {
    final value = (v == null || v.isEmpty) ? "-" : v;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(t,
                style: TextStyle(
                    fontFamily: myFont, fontSize: 12, color: getSub(context))),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: highlight ? primaryPurple : getText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String t) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Text(
      t,
      style: TextStyle(
        fontFamily: myFont,
        fontSize: 10,
        fontWeight: FontWeight.bold,
        color: primaryPurple,
        letterSpacing: 1.2,
      ),
    ),
  );
}
