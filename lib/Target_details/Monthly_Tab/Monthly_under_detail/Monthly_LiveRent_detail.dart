import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    return Scaffold(
      appBar: AppBar(title: const Text("Live Rent Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.image}",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 10),

            row("Apartment Name", b.apartmentName),
            row("Apartment Address", b.apartmentAddress),
            row("Location", b.locations),
            row("Locality", b.localityList),

            const Divider(),

            row("Type", b.typeOfProperty),
            row("BHK", b.bhk),
            row("Floor", b.floor),
            row("Total Floor", b.totalFloor),
            row("Balcony", b.balcony),
            row("Square Fit", b.squareFit),
            row("Parking", b.parking),

            const Divider(),

            row("Show Price", b.showPrice),
            row("Last Price", b.lastPrice),
            row("Asking Price", b.askingPrice),
            row("Meter", b.meter),
            row("Maintenance", b.maintaince),

            const Divider(),

            row("Furnished", b.furnishedUnfurnished),
            row("Kitchen", b.kitchen),
            row("Bathroom", b.bathroom),
            row("Lift", b.lift),
            row("Facility", b.facility),

            const Divider(),

            row("Owner Name", b.ownerName),
            row("Owner Mobile", b.ownerNumber),
            row("Caretaker Name", b.caretakerName),
            row("Caretaker Mobile", b.caretakerNumber),

            const Divider(),

            row("Metro Distance", b.metroDistance),
            row("Highway Distance", b.highwayDistance),
            row("Market Distance", b.mainMarketDistance),
            row("Road Size", b.roadSize),

            const Divider(),

            row("Age of Property", b.ageOfProperty),
            row("Registry/GPA", b.registryAndGpa),
            row("Loan", b.loan),

            const Divider(),

            row("Field Worker", b.fieldWorkerName),
            row("Field Worker No", b.fieldWorkerNumber),
            row("Live Status", b.liveUnlive),

            const Divider(),

            row("Booking Source ID", b.sourceId),
            row("Target Date", b.dateForTarget),
            row("Current Date", b.currentDates),
            row("Available Date", b.availableDate),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}