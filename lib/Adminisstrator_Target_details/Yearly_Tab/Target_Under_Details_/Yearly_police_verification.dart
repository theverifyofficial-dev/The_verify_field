import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_under_detail/Agreement_Monthly_Detail.dart';

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

  static final Color primary = Color(0xFFF59E0B);
  static const String font = "PoppinsMedium";

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

          /// ✅ APP BAR
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
              "POLICE VERIFICATION REPORT",
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: primary,
              ),
            ),
          ),

          /// ✅ CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// HERO IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      img(p.tenantImage),
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 260,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ================= META =================
                  _section("VERIFICATION METADATA", context),
                  _card(context, [
                    _row(context, "Agreement Type", p.agreementType, highlight: true),
                    _row(context, "Shifting Date", formatDate(p.shiftingDate)),
                    _row(context, "Field Worker", p.fieldWorkerName),
                    _row(context, "Worker Number", p.fieldWorkerNumber),
                  ]),

                  /// ================= PROPERTY =================
                  _section("PROPERTY INFORMATION", context),
                  _card(context, [
                    _row(context, "Rented Address", p.rentedAddress, highlight: true),
                    _row(context, "BHK", p.bhk),
                    _row(context, "Floor", p.floor),
                    _row(context, "Parking", p.parking),
                    _row(context, "Furniture", p.furniture),
                  ]),

                  /// ================= TENANT =================
                  _section("TENANT DETAILS", context),
                  _card(context, [
                    _row(context, "Tenant Name", p.tenantName, highlight: true),
                    _row(context, "Relation", p.tenantRelation),
                    _row(context, "Relation Person", p.tenantRelationPerson),
                    _row(context, "Mobile", p.tenantMobile),
                    _row(context, "Aadhar", p.tenantAadhar),
                    const Divider(height: 22),
                    _row(context, "Address", p.tenantAddress),
                  ]),

                  /// ================= OWNER =================
                  _section("OWNER DETAILS", context),
                  _card(context, [
                    _row(context, "Owner Name", p.ownerName, highlight: true),
                    _row(context, "Relation", p.ownerRelation),
                    _row(context, "Relation Person", p.ownerRelationPerson),
                    _row(context, "Mobile", p.ownerMobile),
                    _row(context, "Aadhar", p.ownerAadhar),
                    const Divider(height: 22),
                    _row(context, "Address", p.ownerAddress),
                  ]),

                  /// ================= DOCUMENTS =================
                  _section("DOCUMENT VERIFICATION", context),
                  _documents(),

                  const SizedBox(height: 12),

                  if (p.policeVerificationPdf.isNotEmpty)
                    _card(context, [
                      _row(context, "Police Verification PDF",
                          p.policeVerificationPdf, highlight: true),
                    ]),

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
            Expanded(child: _doc(p.ownerAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _doc(p.ownerAadharBack)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _doc(p.tenantAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _doc(p.tenantAadharBack)),
          ],
        ),
      ],
    );
  }

  Widget _doc(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(img(path), height: 110, fit: BoxFit.cover),
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

  /// ================= ROW =================
  Widget _row(BuildContext context, String t, String? v,
      {bool highlight = false}) {
    final value = (v == null || v.isEmpty || v == "null") ? "-" : v;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(t,
                style: TextStyle(fontFamily: font, fontSize: 12, color: getSub(context))),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                fontWeight: FontWeight.w600,
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
