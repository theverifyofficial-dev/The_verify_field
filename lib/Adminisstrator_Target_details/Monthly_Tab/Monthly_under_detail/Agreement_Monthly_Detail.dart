import 'package:flutter/material.dart';
import 'package:verify_feild_worker/Target_details/Yearly_Tab/Book_Rent.dart';
import '../Monthly_agreement_external.dart';

class AgreementMonthlyDetailScreen extends StatelessWidget {
  final AgreementMonthlyModel a;

  const AgreementMonthlyDetailScreen({super.key, required this.a});

  static final Color primaryPurple = Color(0xFFEF4444);
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
              "AGREEMENT REPORT",
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
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
                  _buildHero(context),

                  const SizedBox(height: 24),

                  _sectionLabel("PARTIES INFORMATION"),
                  _buildPartiesCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("PROPERTY DETAILS"),
                  _buildPropertyCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("FINANCIAL STRUCTURE"),
                  _buildFinancialCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("AGREEMENT METADATA"),
                  _buildMetaCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("VERIFICATION DOCUMENTS"),
                  _buildDocuments(context),

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
  Widget _buildHero(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(img(a.tenantImage)),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// ---------------- PARTIES ----------------
  Widget _buildPartiesCard(BuildContext context) {
    return _card(
      context,
      children: [
        _dataRow(context, "Agreement Type", a.agreementType, highlight: true),
        _dataRow(context, "Tenant", a.tenantName),
        _dataRow(context, "Tenant Mobile", a.tenantMobile),
        const Divider(height: 22),
        _dataRow(context, "Owner", a.ownerName),
        _dataRow(context, "Owner Mobile", a.ownerMobile),
      ],
    );
  }

  /// ---------------- PROPERTY ----------------
  Widget _buildPropertyCard(BuildContext context) {
    return _card(
      context,
      children: [
        _dataRow(context, "Address", a.rentedAddress),
        _dataRow(context, "BHK", a.bhk),
        _dataRow(context, "Floor", a.floor),
        _dataRow(context, "Parking", a.parking),
      ],
    );
  }

  /// ---------------- FINANCIAL ----------------
  Widget _buildFinancialCard(BuildContext context) {
    return _card(
      context,
      children: [
        _dataRow(context, "Monthly Rent", "₹${a.monthlyRent}", isBold: true),
        _dataRow(context, "Security", "₹${a.security}"),
        _dataRow(context, "Maintenance", "${a.maintenance}"),
        _dataRow(context, "Meter", a.meter),
        const Divider(height: 22),
        _dataRow(context, "Agreement Price", "₹${a.agreementPrice}"),
        _dataRow(context, "Notary Price", "₹${a.notaryPrice}"),
      ],
    );
  }

  /// ---------------- META ----------------
  Widget _buildMetaCard(BuildContext context) {
    return _card(
      context,
      children: [
        _dataRow(context, "Shifting Date", formatDate(a.shiftingDate)),
        _dataRow(context, "Field Worker", a.fieldWorkerName, highlight: true),
      ],
    );
  }

  /// ---------------- DOCUMENTS ----------------
  Widget _buildDocuments(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _docImage(a.ownerAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _docImage(a.ownerAadharBack)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: _docImage(a.tenantAadharFront)),
            const SizedBox(width: 8),
            Expanded(child: _docImage(a.tenantAadharBack)),
          ],
        ),
      ],
    );
  }

  Widget _docImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Image.network(
        img(path),
        height: 110,
        fit: BoxFit.cover,
      ),
    );
  }

  /// ---------------- REUSABLE CARD ----------------
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

  /// ---------------- DATA ROW ----------------
  Widget _dataRow(BuildContext context, String t, String? v,
      {bool isBold = false, bool highlight = false}) {
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
            flex: 3,
            child: Text(
              v ?? "N/A",
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

  /// ---------------- SECTION LABEL ----------------
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
