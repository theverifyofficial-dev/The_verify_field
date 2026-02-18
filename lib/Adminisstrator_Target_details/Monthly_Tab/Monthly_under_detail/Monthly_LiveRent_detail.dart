import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_under_detail/Agreement_Monthly_Detail.dart';
import '../Monthly_LiveRent.dart';

class LiveMonthlyRentDetailScreen extends StatelessWidget {
  final MonthlyLiveRentModel b;

  const LiveMonthlyRentDetailScreen({super.key, required this.b});

  static final Color primaryPurple = Color(0xFF22C55E);
  static const String myFont = "PoppinsMedium";

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
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/$path";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBg(context),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// ================= APP BAR =================
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
              "RENT PROPERTY REPORT",
              style: TextStyle(
                fontFamily: myFont,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.3,
                color: primaryPurple,
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

                  /// HERO IMAGE
                  _hero(),

                  const SizedBox(height: 24),

                  _sectionLabel("PRICING OVERVIEW"),
                  _pricingCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("PROPERTY OVERVIEW"),
                  _overviewCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("PROPERTY SPECIFICATIONS"),
                  _buildTechnicalGrid(context),

                  const SizedBox(height: 20),

                  _sectionLabel("INTERIOR & AMENITIES"),
                  _amenitiesCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("CONTACT & STAKEHOLDERS"),
                  _contactCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("LOCATION INTELLIGENCE"),
                  _distanceCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("LEGAL STATUS"),
                  _legalCard(context),

                  const SizedBox(height: 20),

                  _sectionLabel("WORKER & STATUS TRACE"),
                  _metaCard(context),

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
        img(b.image),
        height: 260,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
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
              Expanded(child: _gridItem(context, Icons.home, "Type", b.typeOfProperty)),
              const SizedBox(width: 12),
              Expanded(child: _gridItem(context, Icons.bed, "BHK", b.bhk)),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(child: _gridItem(context, Icons.layers, "Floor", "${b.floor}/${b.totalFloor}")),
              const SizedBox(width: 12),
              Expanded(child: _gridItem(context, Icons.square_foot, "Area", b.squareFit)),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(child: _gridItem(context, Icons.balcony, "Balcony", b.balcony)),
              const SizedBox(width: 12),
              Expanded(child: _gridItem(context, Icons.chair, "Furnished", b.furnishedUnfurnished)),
            ],
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

  /// ---------------- CARDS ----------------

  Widget _pricingCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Asking Price", "₹${b.askingPrice}",
          isBold: true, highlight: true),
      _dataRow(context, "Show Price", "₹${b.showPrice}"),
      _dataRow(context, "Last Price", "₹${b.lastPrice}"),
      const Divider(height: 22),
      _dataRow(context, "Maintenance", b.maintaince),
      _dataRow(context, "Meter", b.meter),
    ],
  );

  Widget _overviewCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Apartment", b.apartmentName, highlight: true),
      _dataRow(context, "Address", b.apartmentAddress),
      _dataRow(context, "Location", b.locations),
      _dataRow(context, "Locality", b.localityList),
    ],
  );

  Widget _specCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Type", b.typeOfProperty),
      _dataRow(context, "BHK", b.bhk),
      _dataRow(context, "Floor", b.floor),
      _dataRow(context, "Total Floor", b.totalFloor),
      _dataRow(context, "Balcony", b.balcony),
      _dataRow(context, "Square Fit", b.squareFit, isBold: true),
      _dataRow(context, "Parking", b.parking),
    ],
  );

  Widget _amenitiesCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Furnished", b.furnishedUnfurnished),
      _dataRow(context, "Kitchen", b.kitchen),
      _dataRow(context, "Bathroom", b.bathroom),
      _dataRow(context, "Lift", b.lift),
      _dataRow(context, "Facility", b.facility),
    ],
  );

  Widget _contactCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Owner", b.ownerName, highlight: true),
      _dataRow(context, "Owner Mobile", b.ownerNumber),
      const Divider(height: 22),
      _dataRow(context, "Caretaker", b.caretakerName),
      _dataRow(context, "Caretaker Mobile", b.caretakerNumber),
    ],
  );

  Widget _distanceCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Metro Distance", b.metroDistance),
      _dataRow(context, "Highway Distance", b.highwayDistance),
      _dataRow(context, "Market Distance", b.mainMarketDistance),
    ],
  );

  Widget _legalCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Property Age", b.ageOfProperty),
      _dataRow(context, "Registry / GPA", b.registryAndGpa, highlight: true),
      _dataRow(context, "Loan Status", b.loan),
    ],
  );

  Widget _metaCard(BuildContext context) => _card(
    context,
    children: [
      _dataRow(context, "Field Worker", b.fieldWorkerName, highlight: true),
      _dataRow(context, "Worker No", b.fieldWorkerNumber),
      _dataRow(context, "Live Status", b.liveUnlive),
      const Divider(height: 22),
      _dataRow(context, "Source ID", b.sourceId),
      _dataRow(context, "Target Date", formatDate(b.dateForTarget)),
      _dataRow(context, "Available Date", formatDate(b.availableDate)),
      _dataRow(context, "Current Date",formatDateTime(b.currentDates)),
    ],
  );
  String formatDateTime(String rawDate) {
    if (rawDate.isEmpty) return "-";

    try {
      final date = DateTime.parse(rawDate);

      return DateFormat("dd MMM yyyy • hh:mm a").format(date);

    } catch (e) {
      return rawDate;
    }
  }

  /// ---------------- REUSABLE ----------------

  Widget _card(BuildContext context, {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 12),
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
    final value = (v == null || v.isEmpty || v == "null") ? "-" : v;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t,
              style: TextStyle(
                  fontFamily: myFont, fontSize: 12, color: getSub(context))),
          Flexible(
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
    padding: const EdgeInsets.only(left: 4, bottom: 8),
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
