import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Target_details/Monthly_Tab/Monthly_under_detail/Agreement_Monthly_Detail.dart';
import '../../../Custom_Widget/constant.dart';
import '../../Monthly_Tab/Book_Rent.dart';
import '../Book_Rent.dart';


class BookRentDetailScreen extends StatelessWidget {
  final yearlyBookRentModel b;

  const BookRentDetailScreen({super.key, required this.b});

  static const Color accent = Color(0xFF6366F1);
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            /// ✅ HERO IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Image.network(
                img(b.propertyPhoto),
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 24),

            /// ✅ PROPERTY OVERVIEW
            _label("PROPERTY OVERVIEW"),
            _card(context, children: [
              _row(context, "Type", b.buyRent, highlight: true),
              _row(context, "Commercial / Residential", b.residenceCommercial),
              _row(context, "Address", b.apartmentAddress),
              _row(context, "Location", b.locations),
              _row(context, "Flat No.", b.flatNumber),
              _row(context, "Property Type", b.typeOfProperty),
              _row(context, "BHK", b.bhk),
              _row(context, "Registry / GPA", b.registryAndGpa, highlight: true),
              _row(context, "Loan", b.loan),
            ]),

            /// ✅ SPECIFICATIONS
            _label("PROPERTY SPECIFICATIONS"),
            _card(context, children: [
              _row(context, "Floor", "${b.floor}/${b.totalFloor}"),
              _row(context, "Balcony", b.balcony),
              _row(context, "Square Fit", b.squareFit, isBold: true),
              _row(context, "Age of Property", b.ageOfProperty),
              _row(context, "Furnished", b.furnishedUnfurnished),
            ]),

            /// ✅ FEATURES
            _label("Facilities & UTILITIES"),
            _card(context, children: [
              _row(context, "Furniture", b.apartmentName, highlight: true),

              _row(context, "Parking", b.parking),
              _row(context, "Meter", b.meter),
              _row(context, "Maintenance", b.maintaince),
              _row(context, "Facility", b.facility,),
              _row(context, "Kitchen", b.kitchen),
              _row(context, "Bathroom", b.bathroom),
              _row(context, "Lift", b.lift),
              _row(context, "Road Size", b.roadSize),
              _row(context, "Metro Distance", b.highwayDistance),
              _row(context, "Main Market", b.mainMarketDistance),
            ]),


            /// ✅ PRICING
            _label("PRICING HISTORY"),
            _card(context, children: [
              _row(context, "Show Price", "₹${b.showPrice}"),
              _row(context, "Last Price", "₹${b.lastPrice}"),
              _row(context, "Asking Price", "₹${b.askingPrice}", highlight: true),
            ]),

            /// ✅ FINANCIALS
            _label("BOOKING FINANCIALS"),
            _card(context, children: [
              _row(context, "Rent", "₹${b.rent}", highlight: true),
              _row(context, "Security", "₹${b.security}"),
              _row(context, "Commission", "₹${b.commission}"),
              _row(context, "Extra Expense", "₹${b.extraExpense}"),
              const Divider(height: 24),
              _row(context, "Advance Payment", "₹${b.advancePayment}"),
              _row(context, "Total Balance", "₹${b.totalBalance}", isBold: true),
            ]),

            /// ✅ TIMELINE
            _label("BOOKING TIMELINE"),
            _card(context, children: [
              _row(context, "Booking Date", formatDate(b.bookingDate), highlight: true),
              _row(context, "Booking Time", b.bookingTime),
              _row(context, "Second Amount", b.secondAmount),
              _row(context, "Final Amount", b.finalAmount),

            ]),

            /// ✅ STAKEHOLDERS
            _label("STAKEHOLDERS"),
            _card(context, children: [
              _row(context, "Owner Name", b.ownerName, highlight: true),
              _row(context, "Owner Mobile", b.ownerNumber),

            ]),

            /// ✅ META DATA
            _label("FIELD WORKER DETAIL"),
            _card(context, children: [

              _row(context, "Field Worker", b.fieldWorkerName),
              _row(context, "Worker Number", b.fieldWorkerNumber),
              const Divider(height: 24),

              _row(context, "Source ID", b.sourceId),
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
      child: Row(
        children: [
          Text(
            t,
            style: const TextStyle(
              fontFamily: font,
              fontSize: 10,
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
        ],
      ),
    );
  }
}

