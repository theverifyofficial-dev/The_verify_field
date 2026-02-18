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
      body: CustomScrollView(
        slivers: [

          /// 🔥 IMAGE HEADER
          SliverAppBar(
            backgroundColor: Colors.black,
            expandedHeight: 260,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 38,
                  width: 38,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 6,
                        color: Colors.black.withOpacity(.25),
                      )
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                    size: 22,
                  ),
                ),
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${book.propertyPhoto}",
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

                  /// ✅ TITLE + PRICE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          book.apartmentName,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          formatMoney(book.askingPrice),
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
                    book.locations,
                    style: const TextStyle(color: Colors.grey),
                  ),

                  const SizedBox(height: 22),

                  /// 🔥 BASIC INFO
                  _section(context, "Basic Info", [
                    _row("Type", book.buyRent),
                    _row("Commercial / Residential", book.residenceCommercial),
                    _row("Property Type", book.typeOfProperty),
                    _row("BHK", book.bhk),
                    _row("Flat No.", book.flatNumber),
                  ]),

                  /// 🔥 PROPERTY DETAILS
                  _section(context, "Property Details", [
                    _row("Floor", book.floor),
                    _row("Total Floor", book.totalFloor),
                    _row("Balcony", book.balcony),
                    _row("Square Fit", book.squareFit),
                    _row("Age of Property", book.ageOfProperty),
                    _row("Furnished", book.furnishedUnfurnished),
                  ]),

                  /// 🔥 FACILITIES
                  _section(context, "Facilities", [
                    _row("Parking", book.parking),
                    _row("Meter", book.meter),
                    _row("Maintenance",(book.maintenance)),
                    _row("Facility", book.facility),
                    _row("Kitchen", book.kitchen),
                    _row("Bathroom", book.bathroom),
                    _row("Lift", book.lift),
                  ]),

                  /// 🔥 DISTANCES
                  _section(context, "Distances", [
                    _row("Road Size", book.roadSize),
                    _row("Metro Distance", book.metroDistance),
                    _row("Highway Distance", book.highwayDistance),
                    _row("Main Market", book.mainMarketDistance),
                  ]),

                  /// 🔥 PRICING
                  _section(context, "Pricing", [
                    _row("Show Price", formatMoney(book.showPrice)),
                    _row("Last Price", formatMoney(book.lastPrice)),
                    _row("Asking Price", formatMoney(book.askingPrice)),
                  ]),

                  /// 🔥 PAYMENT DETAILS
                  _section(context, "Payment Details", [
                    _row("Rent", formatMoney(book.rent)),
                    _row("Security", formatMoney(book.security)),
                    _row("Commission", formatMoney(book.commission)),
                    _row("Extra Expense", formatMoney(book.extraExpense)),
                    _row("Advance Payment", formatMoney(book.advancePayment)),
                    _row("Total Balance", formatMoney(book.totalBalance)),
                  ]),

                  /// 🔥 BOOKING INFO
                  _section(context, "Booking Info", [
                    _row("Booking Date", formatDate(book.bookingDate)),
                    _row("Booking Time", book.bookingTime),
                    _row("Second Amount", formatMoney(book.secondAmount)),
                    _row("Final Amount", formatMoney(book.finalAmount)),
                    _row("Second Payment Status",
                        book.statusSecondPayment ?? "-"),
                    _row("Final Payment Status",
                        book.statusFinalPayment ?? "-"),
                    _row("Remaining Balance Key",
                        book.remainingBalanceKey ?? "-"),
                  ]),

                  /// 🔥 CONTACT
                  _section(context, "Contact", [
                    _row("Owner Name", book.ownerName),
                    _row("Owner Mobile", book.ownerNumber),
                    _row("Caretaker Name", book.careTakerName),
                    _row("Caretaker Mobile", book.careTakerNumber),
                  ]),

                  /// 🔥 LEGAL
                  _section(context, "Legal Details", [
                    _row("Registry / GPA", book.registryAndGpa),
                    _row("Loan", book.loan),
                  ]),

                  /// 🔥 FIELD WORKER
                  _section(context, "Field Worker", [
                    _row("Name", book.fieldWorkerName),
                    _row("Number", book.fieldWorkerNumber),
                    _row("Address", book.fieldWorkerAddress),
                    _row("Current Location",
                        book.fieldWorkerCurrentLocation),
                  ]),

                  /// 🔥 LOCATION
                  _section(context, "Location", [
                    _row("Latitude", book.latitude),
                    _row("Longitude", book.longitude),
                    _row("Video Link", book.videoLink),
                  ]),

                  /// 🔥 META
                  _section(context,"", [
                    _row("Sub ID", book.subId.toString()),
                    _row("Source ID", book.sourceId),
                  ]),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
Widget _section(BuildContext context, String title, List<Widget> children) {
  final theme = Theme.of(context);

  return Container(
    margin: const EdgeInsets.only(bottom: 18),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: theme.brightness == Brightness.dark
          ? []
          : [
        BoxShadow(
          blurRadius: 8,
          color: Colors.black.withOpacity(.06),
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
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
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: Text(
            title,
            style:  TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
        ),
        Expanded(
          flex: 6,
          child: Text(
            value.isEmpty ? "-" : value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    ),
  );
}

