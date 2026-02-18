import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../Monthly_LiveRent.dart';

Future<List<MonthlyLiveRentModel>> fetchLiveMonthlyRent() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/live_monthly_show.php?field_workar_number=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Live Monthly API Error");
  }

  final decoded = jsonDecode(res.body);

  final List list = decoded["data"] ?? [];

  /// ✅ ONLY RENT
  final rentOnly = list.where((e) => e["Buy_Rent"] == "Rent").toList();

  return rentOnly.map((e) => MonthlyLiveRentModel.fromJson(e)).toList();
}
class LiveMonthlyRentDetailScreen extends StatelessWidget {
  final MonthlyLiveRentModel b;

  const LiveMonthlyRentDetailScreen({super.key, required this.b});

  String formatIndianCurrency(String value) {
    if (value.isEmpty) return "₹0";

    final number = double.tryParse(value) ?? 0;

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return formatter.format(number);
  }

  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty || rawDate == "null") {
      return "—";
    }

    try {
      final date = DateTime.parse(rawDate);

      return DateFormat("dd MMM yyyy").format(date);
      // 10 Feb 2026
    } catch (e) {
      return rawDate; // fallback (never crash)
    }
  }

  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(child: Text(v)),
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

          /// 🔥 IMAGE HEADER (Safe & Clean)
          SliverAppBar(
            surfaceTintColor: Colors.black,
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.black,
            leading: Container(
              margin: EdgeInsets.only(left: 10,top: 5,bottom: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.black87,
              ),
                child:
                BackButton(color: Colors.white)),

            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.image}",
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          /// 🔥 BODY CONTENT
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// TITLE + PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${b.bhk} • ${b.typeOfProperty}",
                          style: TextStyle(
                            fontFamily: "PoppinsBold",
                            fontSize: 20,
                            color: textColor,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "₹  "+b.askingPrice,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "PoppinsBold",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    b.locations,
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 13,
                      color: subText,
                    ),
                  ),

                  const SizedBox(height: 24),

                  _section("Basic Info", [
                    _row("Apartment Address", b.apartmentAddress),
                    _row("Locality", b.localityList),
                  ], cardColor, textColor),

                  _section("Property Details", [
                    _row("Floor", b.floor),
                    _row("Total Floor", b.totalFloor),
                    _row("Balcony", b.balcony),
                    _row("Square Fit", b.squareFit),
                    _row("Parking", b.parking),
                  ], cardColor, textColor),

                  _section("Pricing", [

                    _row("Show Price", formatIndianCurrency(b.showPrice)),
                    _row("Last Price", formatIndianCurrency(b.lastPrice)),
                    _row("Asking Price", formatIndianCurrency(b.askingPrice)),
                    _row("Maintenance", b.maintaince),
                  ], cardColor, textColor),

                  _section("Facilities", [
                    _row("Furnishing", b.furnishedUnfurnished),
                    _row("Kitchen", b.kitchen),
                    _row("Bathroom", b.bathroom),
                    _row("Lift", b.lift),
                    _row("Facility", b.facility),
                    _row("Furnish/Unfurnish", b.apartmentName),

                  ], cardColor, textColor),

                  _section("Contact", [
                    _row("Owner Name", b.ownerName),
                    _row("Owner Mobile", b.ownerNumber),
                    _row("Caretaker Name", b.caretakerName),
                    _row("Caretaker Mobile", b.caretakerNumber),
                  ], cardColor, textColor),

                  _section("Distances", [
                    _row("Metro", b.metroDistance),
                    _row("Highway", b.highwayDistance),
                    _row("Market", b.mainMarketDistance),
                    _row("Road Size", b.roadSize),
                  ], cardColor, textColor),

                  _section("Other Details", [
                    _row("Age", b.ageOfProperty),
                    _row("Registry/GPA", b.registryAndGpa),
                    _row("Loan", b.loan),
                    _row("Field Worker", b.fieldWorkerName),
                    _row("Field Worker No", b.fieldWorkerNumber),
                    _row("Live Status", b.liveUnlive),
                    _row("Booking Source ID", b.sourceId),
                    _row("Target Date", formatDate(b.dateForTarget)),
                    _row("Current Date", formatDate(b.currentDates)),
                    _row("Available Date",formatDate(b.availableDate)),
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

  Widget _section(String title, List<Widget> children, Color cardColor, Color textColor) {
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
              fontFamily: "PoppinsBold",
              fontSize: 14,
              color: textColor,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
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
              style:  TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.isEmpty ? "—" : value,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

}