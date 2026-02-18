import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../Target_details/Monthly_Tab/Monthly_LiveBuy.dart';

class LiveMonthlyBuyDetailScreen extends StatelessWidget {
  final LiveMonthlyBuyModel p;

  const LiveMonthlyBuyDetailScreen({super.key, required this.p});

  static final Color primaryPurple = Color(0xFFA855F7);
  static const String myFont = 'PoppinsMedium';

  // Helper getters for dynamic styling
  Color getBg(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? Colors.white10 : const Color(0xFFF2F2F7);

  Color getCard(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ?  Colors.black87 : Colors.white;

  Color getText(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? Colors.white : const Color(0xFF1C1C1E);

  Color getSub(BuildContext context) => Theme.of(context).brightness == Brightness.dark
      ? Colors.white60 : Colors.black54;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBg(context),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(context),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHero(context),
                      const SizedBox(height: 24),

                      _sectionLabel("VALUATION & PRICING"),
                      _buildValuationCard(context),

                      const SizedBox(height: 24),
                      _sectionLabel("PROPERTY SPECIFICATIONS"),
                      _buildTechnicalGrid(context),

                      const SizedBox(height: 24),
                      _sectionLabel("INFRASTRUCTURE & AREA"),
                      _buildConnectivityHub(context),

                      const SizedBox(height: 24),
                      _sectionLabel("VERIFICATION & LEGAL"),
                      _buildLegalAuditCard(context),

                      const SizedBox(height: 24),
                      _sectionLabel("METADATA & TRACE"),
                      _buildSystemMetaCard(context),

                      const SizedBox(height: 120), // Padding for FAB
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white,
      surfaceTintColor:  Theme.of(context).brightness==Brightness.dark?Colors.black:Colors.white,
      pinned: true, elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios_new, color: primaryPurple, size: 20),
        onPressed: () => Navigator.pop(context),
      ),
      centerTitle: true,
      title: Text("PROPERTY REPORT",
          style: TextStyle(fontFamily: myFont, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: primaryPurple)),
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.image}"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.9)]),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _badge(p.buyRent ?? "N/A", Colors.white),
            ]),
            const SizedBox(height: 10),
            Text(p.furnishedUnfurnished ?? "", style: TextStyle(fontFamily: myFont, color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on,
                    color: Colors.white70,
                    size: 15),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    p.locations,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(
                      color: Colors.white70,
                      fontFamily:
                      "PoppinsMedium",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- 3. Valuation Card ---
  Widget _buildValuationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: getCard(context), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _dataRow(context, "Asking Price", "₹${p.askingPrice}", isBold: true, highlight: true),
          _dataRow(context, "Market Price", "₹${p.showPrice}"),
          _dataRow(context, "Last Price", "₹${p.lastPrice}"),
          const Divider(height: 24, thickness: 0.5),
          _dataRow(context, "Maintenance", p.maintaince ?? "N/A"),
          _dataRow(context, "Meter Type", p.meter ?? "N/A"),
        ],
      ),
    );
  }

  // --- 4. Specs Grid ---
  Widget _buildTechnicalGrid(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: getCard(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [

          Row(
            children: [
              Expanded(child: _gridItem(context, Icons.home, "Type", p.typeOfProperty)),
              const SizedBox(width: 12),
              Expanded(child: _gridItem(context, Icons.bed, "BHK", p.bhk)),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(child: _gridItem(context, Icons.layers, "Floor", "${p.floor}/${p.totalFloor}")),
              const SizedBox(width: 12),
              Expanded(child: _gridItem(context, Icons.square_foot, "Area", p.squareFit)),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(child: _gridItem(context, Icons.balcony, "Balcony", p.balcony)),
              const SizedBox(width: 12),
              Expanded(child: _gridItem(context, Icons.chair, "Furnished", p.furnishedUnfurnished)),
            ],
          ),
        ],
      ),
    );
  }


  // --- 5. Connectivity ---
  Widget _buildConnectivityHub(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: getCard(context), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _dataRow(context, "Locality", p.localityList),
          _dataRow(context, "Metro Distance", "${p.highwayDistance}"),
          _dataRow(context, "Market Distance", "${p.mainMarketDistance}"),
          _dataRow(context, "Road Size", p.roadSize ?? "N/A"),
          _dataRow(context, "Facility", p.facility ?? "Basic"),
        ],
      ),
    );
  }
  // --- 7. Legal Card ---
  Widget _buildLegalAuditCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: getCard(context), borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          _dataRow(context, "Property Age", "${p.ageOfProperty}"),
          _dataRow(context, "Registry/GPA", p.registryAndGpa ?? "N/A"),
          _dataRow(context, "Loan Status", p.loan ?? "N/A"),
          const Divider(height: 24),
          _dataRow(context, "Field Worker", p.fieldWorkerName),
          _dataRow(context, "Worker No", p.fieldWorkerNumber),
          _dataRow(context, "Worker Address", p.fieldworkerAddress),
        ],
      ),
    );
  }

  // --- 8. System Meta ---
  Widget _buildSystemMetaCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: getCard(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: primaryPurple.withOpacity(0.1))
      ),
      child: Column(
        children: [
          _dataRow(context, "Source Id", p.sourceId),
          _dataRow(context, "Available From", formatDate(p.availableDate)),
          _dataRow(context, "Target Date", formatDate(p.dateForTarget)),
          _dataRow(context, "Logged Date", formatDate(p.currentDates)),
          _dataRow(context, "Video Link", p.videoLink, highlight: true),
        ],
      ),
    );
  }
  String formatDate(String rawDate) {
    if (rawDate.isEmpty) return "";

    try {
      final date = DateTime.parse(rawDate);

      return DateFormat("dd MMM yyyy").format(date);

      // Other options:
      // DateFormat("dd/MM/yyyy")
      // DateFormat("EEE, dd MMM")
      // DateFormat("dd MMM, hh:mm a")

    } catch (e) {
      return rawDate; // fallback
    }
  }

  // --- Style Helpers ---

  Widget _sectionLabel(String t) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 10),
    child: Text(t, style: TextStyle(fontFamily: myFont, fontSize: 10, fontWeight: FontWeight.bold, color: primaryPurple, letterSpacing: 1.2)),
  );

  Widget _dataRow(BuildContext context, String t, String? v, {bool isBold = false, bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child: Text(t, style: TextStyle(fontFamily: myFont, color: getSub(context), fontSize: 12))),
          Expanded(
            flex: 2,
            child: Text(v ?? "N/A",
                style: TextStyle(fontFamily: myFont, color: highlight ? primaryPurple : getText(context), fontSize: 12, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          ),
        ],
      ),
    );
  }

  Widget _gridItem(BuildContext context, IconData i, String l, String? v) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: primaryPurple.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
          child: Icon(i, size: 14, color: primaryPurple),
        ),
        const SizedBox(width: 8),
        Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(l, style: TextStyle(fontFamily: myFont, fontSize: 10, color: getSub(context))),
          Text(v ?? "N/A", style: TextStyle(fontFamily: myFont, fontSize: 14, fontWeight: FontWeight.w600, color: getText(context))),
        ]),
      ],
    );
  }

  Widget _contactCard(BuildContext context, String role, String? name, String? phone, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: getCard(context), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Icon(icon, color: primaryPurple, size: 24),
          const SizedBox(width: 12),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(role, style:  TextStyle(fontFamily: myFont, fontSize: 9, fontWeight: FontWeight.bold, color: primaryPurple)),
            Text(name ?? "N/A", style: TextStyle(fontFamily: myFont, fontSize: 14, fontWeight: FontWeight.bold, color: getText(context))),
            Text(phone ?? "N/A", style: TextStyle(fontFamily: myFont, fontSize: 12, color: getSub(context))),
          ]),
          const Spacer(),
          CircleAvatar(
            backgroundColor: Colors.white70.withOpacity(0.1),
            child: const Icon(Icons.call, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _badge(String t, Color c) => Container(
    padding: const EdgeInsets.symmetric(
        horizontal: 14, vertical: 6),
    decoration: BoxDecoration(
      color:primaryPurple.withOpacity(.85),
      borderRadius: BorderRadius.circular(30),
    ),    child: Text(t, style: TextStyle(fontFamily: myFont, color: c, fontSize: 13, fontWeight: FontWeight.bold)),
  );

}