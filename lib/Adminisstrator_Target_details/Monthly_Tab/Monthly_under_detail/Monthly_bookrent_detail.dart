import 'package:flutter/material.dart';
import '../Book_Rent.dart';
import 'package:verify_feild_worker/Custom_Widget/constant.dart';

class MonthlyBookRentDetailScreen extends StatelessWidget {
  final BookRentMonthlyModel b;

  const MonthlyBookRentDetailScreen({super.key, required this.b});

  static const Color primary = Color(0xFF6366F1);
  static const String font = "PoppinsMedium";

  /// SAFE VALUE
  String safe(dynamic v, {String fallback = "-"}) {
    if (v == null) return fallback;
    final value = v.toString().trim();
    if (value.isEmpty || value.toLowerCase() == "null") return fallback;
    return value;
  }

  String img(String path) =>
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/$path";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color getBg() => theme.brightness == Brightness.dark
        ? Colors.white10
        : const Color(0xFFF2F2F7);

    Color getCard() => theme.brightness == Brightness.dark
        ? Colors.black87
        : Colors.white;

    Color getText() => theme.brightness == Brightness.dark
        ? Colors.white
        : const Color(0xFF1C1C1E);

    Color getSub() => theme.brightness == Brightness.dark
        ? Colors.white60
        : Colors.black54;

    return Scaffold(
      backgroundColor: getBg(),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [

          /// ================= APP BAR =================
          SliverAppBar(
            backgroundColor: theme.brightness == Brightness.dark
                ? Colors.black
                : Colors.white,
            pinned: true,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 20, color: primary),
              onPressed: () => Navigator.pop(context),
            ),
            centerTitle: true,
            title: const Text(
              "BOOKED RENT REPORT",
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: primary,
                letterSpacing: 1.2,
              ),
            ),
          ),

          /// ================= CONTENT =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  /// HERO IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Image.network(
                      img(safe(b.propertyPhoto, fallback: "")),
                      height: 260,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 260,
                        color: Colors.black12,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// ================= PROPERTY INFO =================
                  _section("PROPERTY INFO"),
                  _card(getCard(), [

                    _row("Location", b.locations,highlight: true),
                    _row("Address", b.apartmentAddress),
                    _row("Flat Number", b.flatNumber),
                    _row("Type", b.typeOfProperty),
                    _row("Category", b.residenceCommercial),
                    _row("Booking Date", b.bookingDate),
                    _row("Booking Time", b.bookingTime),
                    _row("Available Date", b.availableDate),

                  ], getSub(), getText()),

                  /// ================= STRUCTURE =================
                  _section("STRUCTURE"),
                  _card(getCard(), [
                    _row("BHK", b.bhk),
                    _row("Floor", b.floor),
                    _row("Total Floor", b.totalFloor),
                    _row("Balcony", b.balcony),
                    _row("Parking", b.parking),
                    _row("Square Fit", b.squareFit),
                    _row("Age", b.ageOfProperty),
                  ], getSub(), getText()),

                  /// ================= PRICING =================
                  _section("PRICING"),
                  _card(getCard(), [
                    _row("Show Price", "₹${safe(b.showPrice)}",
                        highlight: true),
                    _row("Last Price", "₹${safe(b.lastPrice)}"),
                    _row("Asking Price", "₹${safe(b.askingPrice)}"),
                    const Divider(height: 22),
                    _row("Rent", "₹${safe(b.rent)}", highlight: true),
                    _row("Security", "₹${safe(b.security)}"),
                    _row("Commission", "₹${safe(b.commission)}"),
                    _row("Extra Expense", "₹${safe(b.extraExpense)}"),
                    _row("Advance Payment", "₹${safe(b.advancePayment)}"),
                    _row("Total Balance", "₹${safe(b.totalBalance)}"),
                  ], getSub(), getText()),
                  /// ================= FEATURES =================
                  _section("FACILITY"),
                  _card(getCard(), [
                    _row("Furniture", b.apartmentName),
                    _row("Kitchen", b.kitchen),
                    _row("Bathroom", b.bathroom),
                    _row("Lift", b.lift),
                    _row("Furnished", b.furnishedUnfurnished),
                    _row("Facilities", b.facility),

                  ], getSub(), getText()),
                  /// ================= LOCATION =================
                  _section("LOCATION"),
                  _card(getCard(), [
                    _row("Road Size", b.roadSize),
                    _row("Metro Distance", b.highwayDistance),
                    _row("Market Distance", b.mainMarketDistance),

                  ], getSub(), getText()),



                  /// ================= CONTACT =================
                  _section("CONTACT"),
                  _card(getCard(), [
                    _row("Owner", b.ownerName, highlight: true),
                    _row("Owner Mobile", b.ownerNumber),
                    const Divider(height: 22),
                    _row("Caretaker", b.caretakerName),
                    _row("Caretaker Mobile", b.caretakerNumber),
                  ], getSub(), getText()),

                  /// ================= FIELD WORKER =================
                  _section("FIELD WORKER"),
                  _card(getCard(), [
                    _row("Field Worker", b.fieldWorkerName,
                        highlight: true),
                    _row("Worker Number", b.fieldWorkerNumber),
                    _row("Worker Address", b.fieldworkerAddress),
                  ], getSub(), getText()),

                  /// ================= META =================
                  _card(getCard(), [
                    _row("Registry / GPA", b.registryAndGpa),
                    _row("Loan", b.loan),
                    const Divider(height: 22),

                    _row("Second Amount", b.secondAmount),
                    _row("Final Amount", b.finalAmount),
                    const Divider(height: 22),
                    _row("Live Status", b.liveUnlive),
                    _row("Video Link", b.videoLink),
                    _row("Source ID", b.sourceId),
                  ], getSub(), getText()),

                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CARD =================
  Widget _card(Color color, List<Widget> children,
      Color subColor, Color textColor) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  /// ================= ROW =================
  Widget _row(String title, dynamic value, {bool highlight = false}) {
    final v = safe(value);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(title,
                style: const TextStyle(
                    fontFamily: font,
                    fontSize: 12,
                    color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              v,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontFamily: font,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: highlight ? primary : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= SECTION =================
  Widget _section(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Row(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: font,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: primary,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
