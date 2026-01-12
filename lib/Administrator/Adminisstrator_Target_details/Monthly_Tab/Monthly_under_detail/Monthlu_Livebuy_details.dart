import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    return Scaffold(
      appBar: AppBar(title: const Text("Live Buy Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${p.image}",
              height: 230,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 12),

            row("Property Name", p.apartmentName),
            row("Property Address", p.apartmentAddress),
            row("Locality", p.localityList),
            row("Location", p.locations),
            row("Flat No", p.flatNumber),
            row("Type", p.typeOfProperty),
            row("Buy / Rent", p.buyRent),
            row("Residence / Commercial", p.residenceCommercial),

            const Divider(),

            row("BHK", p.bhk),
            row("Floor", p.floor),
            row("Total Floor", p.totalFloor),
            row("Balcony", p.balcony),
            row("Square Fit", p.squareFit),
            row("Age of Property", p.ageOfProperty),

            const Divider(),

            row("Show Price", p.showPrice),
            row("Last Price", p.lastPrice),
            row("Asking Price", p.askingPrice),
            row("Maintenance", p.maintaince),
            row("Meter", p.meter),

            const Divider(),

            row("Parking", p.parking),
            row("Facility", p.facility),
            row("Furnished", p.furnishedUnfurnished),

            const Divider(),

            row("Road Size", p.roadSize),
            row("Metro Distance", p.metroDistance),
            row("Highway Distance", p.highwayDistance),
            row("Market Distance", p.mainMarketDistance),

            const Divider(),

            row("Owner Name", p.ownerName),
            row("Owner Mobile", p.ownerNumber),
            row("Caretaker Name", p.caretakerName),
            row("Caretaker Mobile", p.caretakerNumber),

            const Divider(),

            row("Field Worker", p.fieldWorkerName),
            row("Worker Number", p.fieldWorkerNumber),
            row("Worker Address", p.fieldworkerAddress),
            row("Live Status", p.liveUnlive),

            const Divider(),

            row("Registry / GPA", p.registryAndGpa),
            row("Loan", p.loan),

            const Divider(),

            row("Longitude", p.longitude),
            row("Latitude", p.latitude),
            row("Video Link", p.videoLink),

            const Divider(),

            row("Current Date", p.currentDates),
            row("Available Date", p.availableDate),
            row("Target Date", p.dateForTarget),
            row("Source ID", p.sourceId),

          ],
        ),
      ),
    );
  }
}

