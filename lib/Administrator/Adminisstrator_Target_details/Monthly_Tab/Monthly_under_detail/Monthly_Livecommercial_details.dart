import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      appBar: AppBar(title: const Text("Commercial Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${widget.c.image}",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 12),

            row("Property", widget.c.apartmentAddress),
            row("Locality", widget.c.localityList),
            row("BHK", widget.c.bhk),
            row("Floor", widget.c.floor),
            row("Total Floor", widget.c.totalFloor),
            row("Balcony", widget.c.balcony),
            row("Square Fit", widget.c.squareFit),
            row("Parking", widget.c.parking),
            row("Meter", widget.c.meter),
            row("Facility", widget.c.facility),

            const Divider(),

            row("Owner", widget.c.ownerName),
            row("Owner No", widget.c.ownerNumber),
            row("Caretaker", widget.c.caretakerName),
            row("Caretaker No", widget.c.caretakerNumber),

            const Divider(),

            row("Metro", widget.c.metroDistance),
            row("Highway", widget.c.highwayDistance),
            row("Market", widget.c.mainMarketDistance),

            const Divider(),

            row("Registry", widget.c.registryAndGpa),
            row("Loan", widget.c.loan),

            const Divider(),

            row("Field Worker", widget.c.fieldWorkerName),
            row("Target Date", widget.c.dateForTarget),
          ],
        ),
      ),
    );
  }
}
