import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Live_Commercial.dart';

Future<List<MonthlyCommercialModel>> fetchCommercialMonthly() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/commercial_month.php?field_workar_number=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Commercial Monthly API Error");
  }

  final decoded = jsonDecode(res.body);

  if (decoded['status'] != true) return [];

  final List list = decoded['data'] ?? [];

  return list.map((e) => MonthlyCommercialModel.fromJson(e)).toList();
}

class MonthluCommercialDetailScreen extends StatefulWidget {
  final MonthlyCommercialModel c;

  const MonthluCommercialDetailScreen({super.key, required this.c});

  @override
  State<MonthluCommercialDetailScreen> createState() => _MonthluCommercialDetailScreenState();
}

class _MonthluCommercialDetailScreenState extends State<MonthluCommercialDetailScreen> {
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;

    final c = widget.c;

    return Scaffold(
      backgroundColor: bgColor,

      body: CustomScrollView(
        slivers: [

          /// 🔥 IMAGE HEADER
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [

                  Image.network(
                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${c.image}",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey),
                  ),

                  /// DARK GRADIENT OVERLAY 😎
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(.65),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),

          /// 🔥 BODY
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// PROPERTY TITLE
                  Text(
                    c.apartmentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20,),
                  _section("Property Info", [
                    _row("Address", c.apartmentAddress),
                    _row("Locality", c.localityList),
                    _row("Type", c.buyRent),
                  ], cardColor),

                  _section("Property Details", [
                    _row("BHK", c.bhk),
                    _row("Floor", c.floor),
                    _row("Total Floor", c.totalFloor),
                    _row("Balcony", c.balcony),
                    _row("Square Fit", c.squareFit),
                    _row("Parking", c.parking),
                    _row("Meter", c.meter),
                    _row("Facility", c.facility),
                  ], cardColor),

                  _section("Pricing", [
                    _row("Show Price", formatMoney(c.showPrice)),
                    _row("Last Price", formatMoney(c.lastPrice)),
                    _row("Asking Price", formatMoney(c.askingPrice)),
                    _row("Maintenance", c.maintaince),
                  ], cardColor),

                  _section("Contact", [
                    _row("Owner", c.ownerName),
                    _row("Owner No", c.ownerNumber),
                    _row("Caretaker", c.caretakerName),
                    _row("Caretaker No", c.caretakerNumber),
                  ], cardColor),

                  _section("Distances", [
                    _row("Metro", c.metroDistance),
                    _row("Highway", c.highwayDistance),
                    _row("Market", c.mainMarketDistance),
                    _row("Road Size", c.roadSize),
                  ], cardColor),

                  _section("Legal & Other", [
                    _row("Registry", c.registryAndGpa),
                    _row("Loan", c.loan),
                    _row("Field Worker", c.fieldWorkerName),
                    _row("Target Date", formatDate(c.dateForTarget)),
                  ], cardColor),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  String formatMoney(String value) {
    if (value.isEmpty) return "₹0";

    final number = double.tryParse(value) ?? 0;

    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(number);
  }

  String formatDate(String raw) {
    if (raw.isEmpty) return "—";

    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(raw));
    } catch (e) {
      return raw;
    }
  }

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
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
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
            flex: 4,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? "—" : value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

}
