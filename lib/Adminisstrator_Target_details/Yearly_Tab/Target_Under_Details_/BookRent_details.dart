import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Custom_Widget/constant.dart';
import '../../Monthly_Tab/Book_Rent.dart';
import '../Book_Rent.dart';


class BookRentDetailScreen extends StatelessWidget {
  final yearlyBookRentModel b;

  const BookRentDetailScreen({super.key, required this.b});


  Future<List<yearlyBookRentModel>> fetchBookedRent() async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_yearly_show.php?field_workar_number=$num",
    );

    final res = await http.get(url);

    if (res.statusCode != 200) {
      throw Exception("Yearly Book API Error");
    }

    final decoded = jsonDecode(res.body);

    if (decoded["status"] != true) return [];

    final List list = decoded["data"] ?? [];

    return list.map((e) => yearlyBookRentModel.fromJson(e)).toList();
  }

  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      appBar: AppBar(
        backgroundColor: Colors.black,
          iconTheme: IconThemeData(color: Colors.white),
          title: Image.asset(AppImages.transparent,height: 40,),
          centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.propertyPhoto}",
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            row("Apartment Name", b.apartmentName),
            row("Address", b.apartmentAddress),
            row("Location", b.locations),
            row("Flat No", b.flatNumber),
            row("Type", b.typeOfProperty),
            row("Buy / Rent", b.buyRent),
            row("Commercial / Residential", b.residenceCommercial),
            row("BHK", b.bhk),
            row("Floor", b.floor),
            row("Total Floor", b.totalFloor),
            row("Balcony", b.balcony),
            row("Area (sqft)", b.squareFit),
            row("Age of Property", b.ageOfProperty),
            row("Furnished", b.furnishedUnfurnished),

            const Divider(),
            row("Parking", b.parking),
            row("Meter", b.meter),
            row("Maintenance", b.maintaince),
            row("Facility", b.facility),
            row("Kitchen", b.kitchen),
            row("Bathroom", b.bathroom),
            row("Lift", b.lift),

            const Divider(),
            row("Road Size", b.roadSize),
            row("Metro Distance", b.metroDistance),
            row("Highway Distance", b.highwayDistance),
            row("Market Distance", b.mainMarketDistance),

            const Divider(),
            row("Show Price", "₹${b.showPrice}"),
            row("Last Price", "₹${b.lastPrice}"),
            row("Asking Price", "₹${b.askingPrice}"),

            const Divider(),
            row("Rent", "₹${b.rent}"),
            row("Security", "₹${b.security}"),
            row("Commission", "₹${b.commission}"),
            row("Extra Expense", "₹${b.extraExpense}"),
            row("Advance Payment", "₹${b.advancePayment}"),
            row("Total Balance", "₹${b.totalBalance}"),

            const Divider(),
            row("Booking Date", b.bookingDate),
            row("Booking Time", b.bookingTime),
            row("Second Amount", b.secondAmount),
            row("Final Amount", b.finalAmount),

            const Divider(),
            row("Owner Name", b.ownerName),
            row("Owner Mobile", b.ownerNumber),
            row("Caretaker Name", b.caretakerName),
            row("Caretaker Mobile", b.caretakerNumber),

            const Divider(),
            row("Registry / GPA", b.registryAndGpa),
            row("Loan", b.loan),

            const Divider(),
            row("Field Worker Name", b.fieldWorkerName),
            row("Field Worker Number", b.fieldWorkerNumber),
            row("Field Worker Address", b.fieldworkerAddress),

            const Divider(),
            row("Latitude", b.latitude),
            row("Longitude", b.longitude),
            row("Video Link", b.videoLink),

            const Divider(),
            row("Source ID", b.sourceId),
            const Divider(),

          ],
        ),
      ),
    );
  }
}
Widget row(String t, String v) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 6,
          child: Text(v.isEmpty ? "-" : v),
        ),
      ],
    ),
  );
}

