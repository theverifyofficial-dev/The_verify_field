import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

import '../Book_Rent.dart';

Future<List<BookRentMonthlyModel>> fetchMonthlyBookRent() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_monthly_show.php?field_workar_number=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Monthly Book Rent API Error");
  }

  final decoded = jsonDecode(res.body);

  if (decoded['status'] != true) return [];

  final List list = decoded['data'] ?? [];

  return list.map((e) => BookRentMonthlyModel.fromJson(e)).toList();
}
class MonthlyBookRentDetailScreen extends StatefulWidget {
  final BookRentMonthlyModel b;

  const MonthlyBookRentDetailScreen({super.key, required this.b});

  @override
  State<MonthlyBookRentDetailScreen> createState() => _MonthlyBookRentDetailScreenState();
}

class _MonthlyBookRentDetailScreenState extends State<MonthlyBookRentDetailScreen> {
  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              flex: 4,
              child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 6, child: Text(v)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Image.asset(AppImages.transparent, height: 40),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [

            /// IMAGE
            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${widget.b.propertyPhoto}",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 220,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported),
              ),
            ),

            const SizedBox(height: 12),

            row("Apartment Name", widget.b.apartmentName),
            row("Apartment Address", widget.b.apartmentAddress),
            row("Location", widget.b.locations),
            row("Flat No", widget.b.flatNumber),
            row("Type", widget.b.typeOfProperty),
            row("Buy / Rent", widget.b.buyRent),
            row("Residence / Commercial", widget.b.residenceCommercial),

            const Divider(),

            row("BHK", widget.b.bhk),
            row("Floor", widget.b.floor),
            row("Total Floor", widget.b.totalFloor),
            row("Balcony", widget.b.balcony),
            row("Square Fit", widget.b.squareFit),
            row("Parking", widget.b.parking),
            row("Age of Property", widget.b.ageOfProperty),

            const Divider(),

            row("Show Price", widget.b.showPrice),
            row("Last Price", widget.b.lastPrice),
            row("Asking Price", widget.b.askingPrice),
            row("Meter", widget.b.meter),
            row("Maintenance", widget.b.maintaince),

            const Divider(),

            row("Road Size", widget.b.roadSize),
            row("Metro Distance", widget.b.metroDistance),
            row("Highway Distance", widget.b.highwayDistance),
            row("Market Distance", widget.b.mainMarketDistance),

            const Divider(),

            row("Kitchen", widget.b.kitchen),
            row("Bathroom", widget.b.bathroom),
            row("Lift", widget.b.lift),
            row("Furnished", widget.b.furnishedUnfurnished),
            row("Facility", widget.b.facility),

            const Divider(),

            row("Owner Name", widget.b.ownerName),
            row("Owner Mobile", widget.b.ownerNumber),
            row("Caretaker Name", widget.b.caretakerName),
            row("Caretaker Mobile", widget.b.caretakerNumber),

            const Divider(),

            row("Field Worker", widget.b.fieldWorkerName),
            row("Field Worker No", widget.b.fieldWorkerNumber),
            row("Worker Address", widget.b.fieldworkerAddress),

            const Divider(),

            row("Registry / GPA", widget.b.registryAndGpa),
            row("Loan", widget.b.loan),
            row("Longitude", widget.b.longitude),
            row("Latitude", widget.b.latitude),

            const Divider(),

            row("Current Date", widget.b.currentDates),
            row("Available Date", widget.b.availableDate),
            row("Live Status", widget.b.liveUnlive),

            const Divider(),

            row("Video Link", widget.b.videoLink),

          ],
        ),
      ),
    );
  }
}
