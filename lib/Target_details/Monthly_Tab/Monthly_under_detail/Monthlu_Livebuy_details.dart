import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Monthly_LiveBuy.dart';

Future<List<LiveMonthlyBuyModel>> fetchLiveMonthlyBuy() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/live_monthly_show.php?field_workar_number=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Live Monthly API Error");
  }

  final decoded = jsonDecode(res.body);

  if (decoded['status'] != true) return [];

  final List list = decoded['data'] ?? [];

  final buyOnly = list.where((e) => e['Buy_Rent'] == 'Buy').toList();

  return buyOnly.map((e) => LiveMonthlyBuyModel.fromJson(e)).toList();
}

class LiveMonthlyBuyDetailScreen extends StatelessWidget {
  final LiveMonthlyBuyModel p;

  const LiveMonthlyBuyDetailScreen({super.key, required this.p});

  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(flex: 4, child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 6, child: Text(v)),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,

      body: CustomScrollView(
        slivers: [

          /// 🔥 MODERN IMAGE HEADER
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: Colors.black,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const BackButton(color: Colors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.image}",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey),
              ),
            ),
          ),

          /// 🔥 CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// 🔥 TITLE + PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          ('₹ '+p.askingPrice),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "${p.locations} • ${p.localityList}",
                    style: TextStyle(fontSize: 13, color: subText),
                  ),

                  const SizedBox(height: 24),

                  /// ✅ BASIC INFO
                  _section("Basic Info", [
                    _row("Property Address", p.apartmentAddress),
                    _row("Flat No", p.flatNumber),
                    _row("Type", p.typeOfProperty),
                    _row("Category", p.residenceCommercial),
                    _row("Listing Type", p.buyRent),
                  ], cardColor, textColor),

                  /// ✅ PROPERTY DETAILS
                  _section("Property Details", [
                    _row("BHK", p.bhk),
                    _row("Floor", p.floor),
                    _row("Total Floor", p.totalFloor),
                    _row("Balcony", p.balcony),
                    _row("Square Fit", p.squareFit),
                    _row("Age", p.ageOfProperty),
                    _row("Parking", p.parking),
                  ], cardColor, textColor),

                  /// ✅ PRICING
                  _section("Pricing", [
                    _row("Show Price", ('₹ '+p.showPrice)),
                    _row("Last Price", ('₹ '+p.lastPrice)),
                    _row("Asking Price", ('₹ '+p.askingPrice)),
                    _row("Maintenance", p.maintaince),
                    _row("Meter", p.meter),
                  ], cardColor, textColor),

                  /// ✅ FACILITIES
                  _section("Facilities", [
                    _row("Facility", p.facility),
                    _row("Furnished", p.furnishedUnfurnished),
                  ], cardColor, textColor),

                  /// ✅ DISTANCES
                  _section("Distances", [
                    _row("Metro", p.metroDistance),
                    _row("Highway", p.highwayDistance),
                    _row("Market", p.mainMarketDistance),
                    _row("Road Size", p.roadSize),
                  ], cardColor, textColor),

                  /// ✅ CONTACT
                  _section("Contact", [
                    _row("Owner", p.ownerName),
                    _row("Owner Mobile", p.ownerNumber),
                    _row("Caretaker", p.caretakerName),
                    _row("Caretaker Mobile", p.caretakerNumber),
                  ], cardColor, textColor),

                  /// ✅ LEGAL
                  _section("Legal Details", [
                    _row("Registry / GPA", p.registryAndGpa),
                    _row("Loan", p.loan),
                  ], cardColor, textColor),

                  /// ✅ FIELD WORKER
                  _section("Field Worker", [
                    _row("Name", p.fieldWorkerName),
                    _row("Number", p.fieldWorkerNumber),
                    _row("Address", p.fieldworkerAddress),
                    _row("Live Status", p.liveUnlive),
                  ], cardColor, textColor),

                  /// ✅ LOCATION
                  _section("Location", [
                    _row("Latitude", p.latitude),
                    _row("Longitude", p.longitude),
                  ], cardColor, textColor),

                  /// ✅ OTHER
                  _section("Other Details", [
                    _row("Video Link", p.videoLink),
                    _row("Current Date",formatDate( p.currentDates)),
                    _row("Available Date", formatDate(p.availableDate)),
                    _row("Target Date",formatDate( p.dateForTarget)),
                    _row("Source ID", p.sourceId),
                  ], cardColor, textColor),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _section(String title, List<Widget> children,
      Color cardColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }
  String formatDate(String raw) {
    if (raw.isEmpty) return "—";

    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(raw));
    } catch (e) {
      return raw;
    }
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.isEmpty ? "—" : value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

}

