import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../Custom_Widget/constant.dart';
import '../Book_Rent.dart';

class MonthlyBookRentDetailScreen extends StatefulWidget {
  final BookRentMonthlyModel b;

  const MonthlyBookRentDetailScreen({super.key, required this.b});

  @override
  State<MonthlyBookRentDetailScreen> createState() =>
      _MonthlyBookRentDetailScreenState();
}

class _MonthlyBookRentDetailScreenState
    extends State<MonthlyBookRentDetailScreen> {

  /// ✅ INDIAN MONEY FORMAT
  String formatMoney(String value) {
    if (value.isEmpty) return "₹0";

    final number = double.tryParse(value) ?? 0;

    return NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(number);
  }

  /// ✅ SAFE DATE FORMAT
  String formatDate(String? raw) {
    if (raw == null || raw.isEmpty || raw == "null") return "—";

    try {
      final date = DateTime.parse(raw);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (_) {
      return raw;
    }
  }

  Widget row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              t,
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 12,
                color: Theme.of(context).brightness==Brightness.dark?Colors.grey:Colors.black45,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              v.isEmpty ? "—" : v,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget section(String title, List<Widget> children) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: "PoppinsBold",
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor =
    isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 36),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [

            /// 🔥 IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${widget.b.propertyPhoto}",
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 220,
                  color: Colors.grey,
                ),
              ),
            ),

            const SizedBox(height: 18),

            /// ✅ BASIC INFO
            section("Basic Info", [
              row("Apartment Address", widget.b.apartmentAddress),
              row("Location", widget.b.locations),
              row("Flat No", widget.b.flatNumber),
              row("Type", widget.b.typeOfProperty),
              row("Buy / Rent", widget.b.buyRent),
              row("Residence / Commercial", widget.b.residenceCommercial),
            ]),

            /// ✅ PROPERTY DETAILS
            section("Property Details", [
              row("BHK", widget.b.bhk),
              row("Floor", widget.b.floor),
              row("Total Floor", widget.b.totalFloor),
              row("Balcony", widget.b.balcony),
              row("Square Fit", widget.b.squareFit),
              row("Parking", widget.b.parking),
              row("Age", widget.b.ageOfProperty),
            ]),

            /// ✅ PRICING
            section("Pricing", [
              row("Show Price", formatMoney(widget.b.showPrice)),
              row("Last Price", formatMoney(widget.b.lastPrice)),
              row("Asking Price", formatMoney(widget.b.askingPrice)),
              row("Rent", formatMoney(widget.b.rent)),
              row("Security", formatMoney(widget.b.security)),
            ]),

            /// ✅ FACILITIES
            section("Facilities", [
              row("Kitchen", widget.b.kitchen),
              row("Bathroom", widget.b.bathroom),
              row("Lift", widget.b.lift),
              row("Furnished", widget.b.furnishedUnfurnished),
              row("Facility", widget.b.facility),
            ]),

            /// ✅ CONTACT
            section("Contact", [
              row("Owner", widget.b.ownerName),
              row("Owner Mobile", widget.b.ownerNumber),
              row("Caretaker", widget.b.caretakerName),
              row("Caretaker Mobile", widget.b.caretakerNumber),
            ]),

            /// ✅ STATUS
            section("Status", [
              row("Current Date", formatDate(widget.b.currentDates)),
              row("Available Date", formatDate(widget.b.availableDate)),
              row("Live Status", widget.b.liveUnlive),
              row("Video Link", widget.b.videoLink),
            ]),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
