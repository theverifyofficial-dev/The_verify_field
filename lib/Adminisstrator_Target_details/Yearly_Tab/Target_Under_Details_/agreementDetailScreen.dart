import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../Target_details/Monthly_Tab/Monthly_under_detail/Agreement_Monthly_Detail.dart';
import '../Agreement_External.dart';

class AgreementExternalDetail extends StatelessWidget {
  final Agreement agreement;

  const AgreementExternalDetail({super.key, required this.agreement});

  static final Color primary = Color(0xFFEF4444);
  static const String font = "PoppinsMedium";

  /// ================= SAFE HELPERS =================

  String safe(dynamic v, {String fallback = "-"}) {
    if (v == null) return fallback;

    final value = v.toString().trim();

    if (value.isEmpty) return fallback;
    if (value.toLowerCase() == "null") return fallback;

    return value;
  }

  String safeMoney(dynamic v) {
    final value = safe(v);
    if (value == "-") return "-";
    return "₹$value";
  }

  /// ================= THEME HELPERS =================

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

  /// ================= URL ACTION =================

  Future<void> openLink(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBg(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// ================= APP BAR =================
          SliverAppBar(
            backgroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new,
                  color: primary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: Text(
              "AGREEMENT REPORT",
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
                color: primary,
              ),
            ),
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ================= HERO IMAGE =================
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      img(safe(agreement.tenantImage, fallback: "")),
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 260,
                        color: Colors.black12,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ================= OWNER =================
                  _section("OWNER INFORMATION", context),
                  _card(context, [
                    _row(context, "Owner Name", agreement.ownerName, highlight: true),
                    _row(context, "Relation", agreement.ownerRelation),
                    _row(context, "Relation Person", agreement.ownerRelationPerson),
                    _row(context, "Mobile", agreement.ownerMobile),
                    _row(context, "Aadhar", agreement.ownerAadhar),
                    const Divider(height: 22),
                    _row(context, "Address", agreement.ownerAddress),
                  ]),

                  /// ================= TENANT =================
                  _section("TENANT INFORMATION", context),
                  _card(context, [
                    _row(context, "Tenant Name", agreement.tenantName, highlight: true),
                    _row(context, "Relation", agreement.tenantRelation),
                    _row(context, "Relation Person", agreement.tenantRelationPerson),
                    _row(context, "Mobile", agreement.tenantMobile),
                    _row(context, "Aadhar", agreement.tenantAadhar),
                    const Divider(height: 22),
                    _row(context, "Address", agreement.tenantAddress),
                  ]),

                  /// ================= PROPERTY =================
                  _section("PROPERTY DETAILS", context),
                  _card(context, [
                    _row(context, "Rented Address", agreement.rentedAddress, highlight: true),
                    _row(context, "BHK", agreement.bhk),
                    _row(context, "Floor", agreement.floor),
                    _row(context, "Parking", agreement.parking),
                    _row(context, "Furniture", agreement.furniture),
                    _row(context, "Meter", agreement.meter),
                    _row(context, "Maintenance", agreement.maintenance),
                  ]),

                  /// ================= FINANCIAL =================
                  _section("FINANCIAL STRUCTURE", context),
                  _card(context, [
                    _row(context, "Monthly Rent", safeMoney(agreement.monthlyRent), isBold: true),
                    _row(context, "Security Deposit", safeMoney(agreement.security)),
                    _row(context, "Installment Security", safeMoney(agreement.installmentSecurity)),
                    const Divider(height: 22),
                    _row(context, "Custom Meter Unit", safeMoney(agreement.customMeterUnit)),
                    _row(context, "Custom Maintenance", safeMoney(agreement.customMaintenanceCharge)),
                  ]),

                  /// ================= AGREEMENT =================
                  _section("AGREEMENT DETAILS", context),
                  _card(context, [
                    _row(context, "Agreement Type", agreement.agreementType, highlight: true),
                    _row(context, "Agreement Price", safeMoney(agreement.agreementPrice)),
                    _row(context, "Notary Price", agreement.notaryPrice),
                    _row(context, "Agreement PDF", agreement.agreementPdf),
                    _row(context, "Police Verification PDF", agreement.policeVerificationPdf),
                  ]),

                  /// ================= DATES =================
                  _section("DATES & TRACKING", context),
                  _card(context, [
                    _row(context, "Shifting Date", formatDate(agreement.shiftingDate), highlight: true),
                    _row(context, "Renewal Reminder Sent",
                        agreement.renewalReminderSent ? "Yes" : "No"),
                    _row(context, "Reminder Date", agreement.renewalReminderDate),
                  ]),

                  /// ================= COMPANY =================
                  if (agreement.companyName != null &&
                      agreement.companyName!.isNotEmpty) ...[
                    _section("COMPANY INFORMATION", context),
                    _card(context, [
                      _row(context, "Company Name", agreement.companyName),
                      _row(context, "GST", agreement.gstNo),
                      _row(context, "PAN", agreement.panNo),
                    ]),
                  ],

                  /// ================= FIELD WORKER =================
                  _section("FIELD WORKER TRACE", context),
                  _card(context, [
                    _row(context, "Name", agreement.fieldWorkerName, highlight: true),
                    _row(context, "Contact", agreement.fieldWorkerNumber),
                  ]),

                  /// ================= DOCUMENTS =================
                  _section("DOCUMENT VERIFICATION", context),
                  _documents(),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= DOCUMENT GRID =================

  Widget _documents() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _doc(agreement.ownerAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _doc(agreement.ownerAadharBack)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _doc(agreement.tenantAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _doc(agreement.tenantAadharBack)),
          ],
        ),
      ],
    );
  }

  Widget _doc(String path) {
    final imagePath = safe(path, fallback: "");

    if (imagePath.isEmpty) {
      return Container(
        height: 110,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.black12,
        ),
        child: const Icon(Icons.image_not_supported),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        img(imagePath),
        height: 110,
        fit: BoxFit.cover,
      ),
    );
  }

  /// ================= CARD =================

  Widget _card(BuildContext context, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: getCard(context),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(children: children),
    );
  }

  /// ================= DATA ROW =================

  Widget _row(BuildContext context, String t, dynamic v,
      {bool isBold = false, bool highlight = false}) {
    final value = safe(v);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              t,
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                color: getSub(context),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: highlight ? primary : getText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SECTION LABEL =================

  Widget _section(String t, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        t,
        style: TextStyle(
          fontFamily: font,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
