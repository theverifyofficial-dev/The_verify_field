import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_under_detail/Agreement_Monthly_Detail.dart';
import '../../../Custom_Widget/constant.dart';
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

  static const Color accent = Color(0xFFA855F7);
  static const String font = "PoppinsMedium";

  Color getBg(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.black
          : const Color(0xFFF5F5F7);

  Color getCard(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white10
          : Colors.white;

  Color getText(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white
          : Colors.black87;

  Color getSub(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
          ? Colors.white60
          : Colors.black54;

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/$path";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getBg(context),

      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ✅ HERO IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                img(book.propertyPhoto),
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            /// ✅ PROPERTY OVERVIEW
            _label("PROPERTY OVERVIEW"),
            _card(context, children: [
              _row(context, "Type", book.buyRent, highlight: true),
              _row(context, "Commercial / Residential", book.residenceCommercial),
              _row(context, "Address", book.apartmentAddress),
              _row(context, "Location", book.locations),
              _row(context, "Flat No.", book.flatNumber),
              _row(context, "Property Type", book.typeOfProperty),
              _row(context, "BHK", book.bhk),
              _row(context, "Registry / GPA", book.registryAndGpa, highlight: true),
              _row(context, "Loan", book.loan),
            ]),

            /// ✅ SPECIFICATIONS
            _label("PROPERTY SPECIFICATIONS"),
            _card(context, children: [
              _row(context, "Floor", "${book.floor}/${book.totalFloor}"),
              _row(context, "Balcony", book.balcony),
              _row(context, "Square Fit", book.squareFit, isBold: true),
              _row(context, "Age of Property", book.ageOfProperty),
              _row(context, "Furnished", book.furnishedUnfurnished),
            ]),

            /// ✅ FEATURES
            _label("Facilities & UTILITIES"),
            _card(context, children: [
              _row(context, "Furniture", book.apartmentName, highlight: true),

              _row(context, "Parking", book.parking),
              _row(context, "Meter", book.meter),
              _row(context, "Maintenance", book.maintenance),
              _row(context, "Facility", book.facility,),
              _row(context, "Kitchen", book.kitchen),
              _row(context, "Bathroom", book.bathroom),
              _row(context, "Lift", book.lift),
              _row(context, "Road Size", book.roadSize),
              _row(context, "Metro Distance", book.highwayDistance),
              _row(context, "Main Market", book.mainMarketDistance),
            ]),


            /// ✅ PRICING
            _label("PRICING HISTORY"),
            _card(context, children: [
              _row(context, "Show Price", "₹${book.showPrice}"),
              _row(context, "Last Price", "₹${book.lastPrice}"),
              _row(context, "Asking Price", "₹${book.askingPrice}", highlight: true),
            ]),

            /// ✅ FINANCIALS
            _label("BOOKING FINANCIALS"),
            _card(context, children: [
              _row(context, "Rent", "₹${book.rent}", highlight: true),
              _row(context, "Security", "₹${book.security}"),
              _row(context, "Commission", "₹${book.commission}"),
              _row(context, "Extra Expense", "₹${book.extraExpense}"),
              const Divider(height: 24),
              _row(context, "Advance Payment", "₹${book.advancePayment}"),
              _row(context, "Total Balance", "₹${book.totalBalance}", isBold: true),
            ]),

            /// ✅ TIMELINE
            _label("BOOKING TIMELINE"),
            _card(context, children: [
              _row(context, "Booking Date", formatDate(book.bookingDate), highlight: true),
              _row(context, "Booking Time", book.bookingTime),
              _row(context, "Second Amount", book.secondAmount),
              _row(context, "Final Amount", book.finalAmount),
              _row(context, "Second Payment", book.statusSecondPayment ?? "-"),
              _row(context, "Final Payment", book.statusFinalPayment ?? "-"),
            ]),

            /// ✅ STAKEHOLDERS
            _label("STAKEHOLDERS"),
            _card(context, children: [
              _row(context, "Owner Name", book.ownerName, highlight: true),
              _row(context, "Owner Mobile", book.ownerNumber),
              const Divider(height: 24),
              _row(context, "Caretaker Name", book.careTakerName),
              _row(context, "Caretaker Mobile", book.careTakerNumber),
            ]),

            /// ✅ META DATA
            _label("FIELD WORKER DETAIL"),
            _card(context, children: [

              _row(context, "Field Worker", book.fieldWorkerName),
              _row(context, "Worker Number", book.fieldWorkerNumber),
              const Divider(height: 24),

              _row(context, "Source ID", book.sourceId),
            ]),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// ✅ CARD
  Widget _card(BuildContext context, {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.only(bottom: 18),
      decoration: BoxDecoration(
        color: getCard(context),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(children: children),
    );
  }

  /// ✅ ROW
  Widget _row(BuildContext context, String t, String? v,
      {bool highlight = false, bool isBold = false}) {

    final value = (v == null || v.isEmpty || v == "null") ? "-" : v;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(t,
              style: TextStyle(fontFamily: font, fontSize: 12, color: getSub(context))),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                color: highlight ? accent : getText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ LABEL
  Widget _label(String t) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          t,
          style: const TextStyle(
            fontFamily: font,
            fontSize: 10,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
            color: accent,
          ),
        ),
      ),
    );
  }
}
