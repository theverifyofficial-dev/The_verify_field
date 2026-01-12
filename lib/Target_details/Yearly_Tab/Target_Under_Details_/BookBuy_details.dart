import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constant.dart';
import '../Book_Buy.dart';

Future<List<BookModel>> fetchYearlyBooked() async {
  final url = Uri.parse(
    "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_yearly_show.php?field_workar_number=11",
  );

  final res = await http.get(url);

  if (res.statusCode != 200) {
    throw Exception("Yearly Book API Error");
  }

  final decoded = jsonDecode(res.body);
  final List list = decoded['data'] ?? [];

  return list
      .map((e) => BookModel.fromJson(e))
      .toList();
}

class YearlyBookDetailScreen extends StatelessWidget {
  final BookModel book;

  const YearlyBookDetailScreen({super.key, required this.book});

  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold))),
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
          title:Image.asset(AppImages.transparent,height: 40,),
      centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${book.propertyPhoto}",
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            row("Type", book.buyRent),
            row("Commercial / Residential", book.residenceCommercial),
            row("Property Name", book.apartmentName),
            row("Address", book.apartmentAddress),
            row("Location", book.locations),
            row("Flat No.", book.flatNumber),
            row("Property Type", book.typeOfProperty),
            row("BHK", book.bhk),
            row("Floor", book.floor),
            row("Total Floor", book.totalFloor),
            row("Balcony", book.balcony),
            row("Square Fit", book.squareFit),
            row("Age of Property", book.ageOfProperty),
            row("Furnished", book.furnishedUnfurnished),

            const Divider(),
            row("Parking", book.parking),
            row("Meter", book.meter),
            row("Maintenance", book.maintenance),
            row("Facility", book.facility),
            row("Kitchen", book.kitchen),
            row("Bathroom", book.bathroom),
            row("Lift", book.lift),

            const Divider(),
            row("Road Size", book.roadSize),
            row("Metro Distance", book.metroDistance),
            row("Highway Distance", book.highwayDistance),
            row("Main Market", book.mainMarketDistance),

            const Divider(),
            row("Owner Name", book.ownerName),
            row("Owner Mobile", book.ownerNumber),
            row("Caretaker Name", book.careTakerName),
            row("Caretaker Mobile", book.careTakerNumber),

            const Divider(),
            row("Show Price", "₹${book.showPrice}"),
            row("Last Price", "₹${book.lastPrice}"),
            row("Asking Price", "₹${book.askingPrice}"),

            const Divider(),
            row("Rent", "₹${book.rent}"),
            row("Security", "₹${book.security}"),
            row("Commission", "₹${book.commission}"),
            row("Extra Expense", "₹${book.extraExpense}"),
            row("Advance Payment", "₹${book.advancePayment}"),
            row("Total Balance", "₹${book.totalBalance}"),

            const Divider(),
            row("Booking Date", book.bookingDate),
            row("Booking Time", book.bookingTime),
            row("Second Amount", book.secondAmount),
            row("Final Amount", book.finalAmount),
            row("Second Payment Status", book.statusSecondPayment ?? "-"),
            row("Final Payment Status", book.statusFinalPayment ?? "-"),
            row("Remaining Balance Key", book.remainingBalanceKey ?? "-"),

            const Divider(),
            row("Registry / GPA", book.registryAndGpa),
            row("Loan", book.loan),

            const Divider(),
            row("Field Worker Name", book.fieldWorkerName),
            row("Field Worker Number", book.fieldWorkerNumber),
            row("Field Worker Address", book.fieldWorkerAddress),
            row("Current Location", book.fieldWorkerCurrentLocation),

            const Divider(),
            row("Latitude", book.latitude),
            row("Longitude", book.longitude),
            row("Video Link", book.videoLink),

            const Divider(),
            row("Sub ID", book.subId.toString()),
            row("Source ID", book.sourceId),

          ],
        ),
      ),
    );
  }
}
Widget row(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          flex: 6,
          child: Text(value.isEmpty ? "-" : value),
        ),
      ],
    ),
  );
}

