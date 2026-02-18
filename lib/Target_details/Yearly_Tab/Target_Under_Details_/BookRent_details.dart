import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../Custom_Widget/constant.dart';
import '../../Monthly_Tab/Book_Rent.dart';
import '../Book_Rent.dart';


class BookRentDetailScreen extends StatelessWidget {
  final yearlyBookRentModel b;

  const BookRentDetailScreen({super.key, required this.b});

  /// ✅ INDIAN MONEY FORMAT
  String formatIndianCurrency(String value) {
    if (value.isEmpty) return "₹0";

    final number = double.tryParse(value) ?? 0;

    final formatter = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    );

    return formatter.format(number);
  }

  /// ✅ DATE FORMAT
  String formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty || rawDate == "null") {
      return "—";
    }

    try {
      final date = DateTime.parse(rawDate);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (e) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark ? const Color(0xFF0F0F0F) : const Color(0xFFF5F7FA);
    final cardColor = isDark ? const Color(0xFF1A1A1A) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade600;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 PROPERTY IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${b.propertyPhoto}",
                height: 230,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 18),

            /// 🔥 TITLE + LOCATION
            Text(
              b.apartmentName,
              style: TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 20,
                color: textColor,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              b.locations,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 13,
                color: subText,
              ),
            ),

            const SizedBox(height: 22),

            /// 🔥 BASIC INFO
            _section("Basic Info", [
              _row("Address", b.apartmentAddress),
              _row("Flat No", b.flatNumber),
              _row("Type", b.typeOfProperty),
              _row("Buy / Rent", b.buyRent),
              _row("Commercial / Residential", b.residenceCommercial),
            ], cardColor, textColor),

            /// 🔥 PROPERTY DETAILS
            _section("Property Details", [
              _row("BHK", b.bhk),
              _row("Floor", b.floor),
              _row("Total Floor", b.totalFloor),
              _row("Balcony", b.balcony),
              _row("Area (sqft)", b.squareFit),
              _row("Age of Property", b.ageOfProperty),
              _row("Furnished", b.furnishedUnfurnished),
            ], cardColor, textColor),

            /// 🔥 FACILITIES
            _section("Facilities", [
              _row("Parking", b.parking),
              _row("Meter", b.meter),
              _row("Maintenance", b.maintaince),
              _row("Facility", b.facility),
              _row("Kitchen", b.kitchen),
              _row("Bathroom", b.bathroom),
              _row("Lift", b.lift),
            ], cardColor, textColor),

            /// 🔥 DISTANCES
            _section("Distances", [
              _row("Road Size", b.roadSize),
              _row("Metro Distance", b.apartmentName),
              _row("Highway Distance", b.highwayDistance),
              _row("Market Distance", b.mainMarketDistance),
            ], cardColor, textColor),

            /// 🔥 PRICING
            _section("Pricing", [
              _row("Show Price", formatIndianCurrency(b.showPrice)),
              _row("Last Price", formatIndianCurrency(b.lastPrice)),
              _row("Asking Price", formatIndianCurrency(b.askingPrice)),
            ], cardColor, textColor),

            /// 🔥 FINANCIAL DETAILS
            _section("Financial Details", [
              _row("Rent", formatIndianCurrency(b.rent)),
              _row("Security", formatIndianCurrency(b.security)),
              _row("Commission", formatIndianCurrency(b.commission)),
              _row("Extra Expense", formatIndianCurrency(b.extraExpense)),
              _row("Advance Payment", formatIndianCurrency(b.advancePayment)),
              _row("Total Balance", formatIndianCurrency(b.totalBalance)),
            ], cardColor, textColor),

            /// 🔥 BOOKING INFO
            _section("Booking Info", [
              _row("Booking Date", formatDate(b.bookingDate)),
              _row("Booking Time", b.bookingTime),
              _row("Second Amount", formatIndianCurrency(b.secondAmount)),
              _row("Final Amount", formatIndianCurrency(b.finalAmount)),
            ], cardColor, textColor),

            /// 🔥 CONTACT
            _section("Contact", [
              _row("Owner Name", b.ownerName),
              _row("Owner Mobile", b.ownerNumber),
              _row("Caretaker Name", b.caretakerName),
              _row("Caretaker Mobile", b.caretakerNumber),
            ], cardColor, textColor),

            /// 🔥 LEGAL
            _section("Legal", [
              _row("Registry / GPA", b.registryAndGpa),
              _row("Loan", b.loan),
            ], cardColor, textColor),

            /// 🔥 FIELD WORKER
            _section("Field Worker", [
              _row("Name", b.fieldWorkerName),
              _row("Number", b.fieldWorkerNumber),
              _row("Address", b.fieldworkerAddress),
            ], cardColor, textColor),

            /// 🔥 LOCATION DATA
            _section("Location Data", [
              _row("Latitude", b.latitude),
              _row("Longitude", b.longitude),
              _row("Video Link", b.videoLink),
              _row("Source ID", b.sourceId),
            ], cardColor, textColor),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  /// ✅ SECTION CARD
  Widget _section(String title, List<Widget> children, Color cardColor, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: "PoppinsBold",
              fontSize: 15,
              color: textColor,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  /// ✅ PREMIUM ROW
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: "PoppinsMedium",
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              value.isEmpty ? "—" : value,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 13.5,
              ),
            ),
          ),
        ],
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

