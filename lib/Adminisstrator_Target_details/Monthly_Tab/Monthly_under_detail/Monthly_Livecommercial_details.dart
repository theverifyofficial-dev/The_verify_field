import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Target_details/Yearly_Tab/Book_Rent.dart';

import '../Live_Commercial.dart';

class MonthluCommercialDetailScreen extends StatefulWidget {
  final MonthlyCommercialModel c;

  const MonthluCommercialDetailScreen({super.key, required this.c});

  @override
  State<MonthluCommercialDetailScreen> createState() =>
      _MonthluCommercialDetailScreenState();
}

class _MonthluCommercialDetailScreenState
    extends State<MonthluCommercialDetailScreen> {

  static final Color primaryPurple = Color(0xFF06B6D4);
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
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/$path";

  MonthlyCommercialModel get c => widget.c;

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
              "COMMERCIAL PROPERTY REPORT",
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

                  _hero(),

                  const SizedBox(height: 24),

                  _sectionLabel("PROPERTY OVERVIEW"),
                  _overviewCard(),

                  const SizedBox(height: 20),

                  _sectionLabel("STRUCTURAL SPECIFICATIONS"),
                  _specCard(),

                  const SizedBox(height: 20),

                  _sectionLabel("CONTACT & STAKEHOLDERS"),
                  _contactCard(),

                  const SizedBox(height: 20),

                  _sectionLabel("LOCATION INTELLIGENCE"),
                  _locationCard(),

                  const SizedBox(height: 20),

                  _sectionLabel("LEGAL & FINANCIAL STATUS"),
                  _legalCard(),

                  const SizedBox(height: 20),

                  _sectionLabel("WORKER & TARGET TRACE"),
                  _metaCard(),

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
        img(c.image),
        height: 260,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  /// ---------------- CARDS ----------------

  Widget _overviewCard() => _card(children: [
    _dataRow("Property", c.apartmentAddress, highlight: true),
    _dataRow("Locality", c.localityList),
  ]);

  Widget _specCard() => _card(children: [
    _dataRow("BHK", c.bhk),
    _dataRow("Floor", c.floor),
    _dataRow("Total Floor", c.totalFloor),
    _dataRow("Balcony", c.balcony),
    _dataRow("Square Fit", c.squareFit, isBold: true),
    const Divider(height: 22),
    _dataRow("Parking", c.parking),
    _dataRow("Meter", c.meter),
    _dataRow("Facility", c.facility),
  ]);

  Widget _contactCard() => _card(children: [
    _dataRow("Owner", c.ownerName, highlight: true),
    _dataRow("Owner No", c.ownerNumber),
    const Divider(height: 22),
    _dataRow("Caretaker", c.caretakerName),
    _dataRow("Caretaker No", c.caretakerNumber),
  ]);

  Widget _locationCard() => _card(children: [
    _dataRow("Metro Distance", c.metroDistance),
    _dataRow("Highway Distance", c.highwayDistance),
    _dataRow("Market Distance", c.mainMarketDistance),
  ]);

  Widget _legalCard() => _card(children: [
    _dataRow("Registry / GPA", c.registryAndGpa, highlight: true),
    _dataRow("Loan Status", c.loan),
  ]);

  Widget _metaCard() => _card(children: [
    _dataRow("Field Worker", c.fieldWorkerName, highlight: true),
    _dataRow("Target Date", formatDate(c.dateForTarget)),
  ]);

  /// ---------------- REUSABLE ----------------

  Widget _card({required List<Widget> children}) {
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

  Widget _dataRow(String t, String? v,
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
