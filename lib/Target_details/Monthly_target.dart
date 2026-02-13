import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../Adminisstrator_Target_details/Monthly_Tab/Monthly_police_verification.dart';
import 'Monthly_Tab/Book_Rent.dart';
import 'Monthly_Tab/Live_Commercial.dart';
import 'Monthly_Tab/Monthly_LiveBuy.dart';
import 'Monthly_Tab/Monthly_LiveRent.dart';
import 'Monthly_Tab/Monthly_agreement_external.dart';
import 'Target_Widget.dart';

class MonthlyTargetScreen extends StatefulWidget {
  const MonthlyTargetScreen({super.key});

  @override
  State<MonthlyTargetScreen> createState() => _MonthlyTargetScreenState();
}

class _MonthlyTargetScreenState extends State<MonthlyTargetScreen> {
  bool loading = true;
  String? fieldWorkerNumber;

  int bookRentDone = 0;
  int bookBuyDone = 0;
  int liveRentDone = 0;
  int liveBuyDone = 0;
  int agreementExternalDone = 0;
  int policeVerificationDone = 0;
  int commercialDone = 0;

  DateTime? periodStart;
  DateTime? periodEnd;

  final Map<String, int> monthlyTargets = {
    "Book Rent": 4,
    "Live Commercial": 5,
    "Agreement External": 10,
    "Police Verification": 10,
    "Live Rent": 15,
    "Live Buy": 5,
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    fieldWorkerNumber = prefs.getString('number');

    await Future.wait([
      _fetchBookMonthly(),
      _fetchLiveMonthly(),
      _fetchAgreementMonthly(),
      _fetchPoliceMonthly(),
      _fetchCommercialMonthly(),
    ]);

    setState(() => loading = false);
  }

  Future<void> _fetchBookMonthly() async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_monthly_show.php?field_workar_number=$fieldWorkerNumber");

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Book Monthly API Error");

    final list = jsonDecode(res.body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      bookRentDone = int.tryParse(list[0]["rent_count"].toString()) ?? 0;
      bookBuyDone = int.tryParse(list[0]["buy_count"].toString()) ?? 0;
      // ✅ PERIOD DATES
      periodStart = DateTime.tryParse(
        list[0]["period_start"]["date"],
      );

      periodEnd = DateTime.tryParse(
        list[0]["period_end"]["date"],
      );
    }
  }
  Future<void> _fetchLiveMonthly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/live_monthly_show.php?field_workar_number=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Live Monthly API Error");
    }

    final decoded = jsonDecode(res.body);
    print(res.body); // 👈 dekhne ke liye

    if (decoded["counts"] != null) {
      liveRentDone = int.tryParse(
        decoded["counts"]["rent_count"].toString(),
      ) ??
          0;

      liveBuyDone = int.tryParse(
        decoded["counts"]["buy_count"].toString(),
      ) ??
          0;
    } else {
      // backup safety
      liveRentDone = int.tryParse(decoded["rent_count"]?.toString() ?? '0') ?? 0;
      liveBuyDone = int.tryParse(decoded["buy_count"]?.toString() ?? '0') ?? 0;
    }

    final List list = decoded["data"] ?? [];

    print("LIVE RENT COUNT: $liveRentDone");
    print("LIVE BUY COUNT: $liveBuyDone");
    print("DATA LEN: ${list.length}");

    setState(() {});
  }
  Future<void> _fetchAgreementMonthly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_monthly_show.php?Fieldwarkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Agreement Monthly API Error");
    }

    final decoded = jsonDecode(res.body);

    // ✅ SAFE: dono structure handle karega
    if (decoded["counts"] != null) {
      agreementExternalDone = int.tryParse(
        decoded["counts"]["total_agreement"].toString(),
      ) ??
          0;
    } else {
      agreementExternalDone = int.tryParse(
        decoded["total_agreement"].toString(),
      ) ??
          0;
    }

    final List list = decoded["data"] ?? [];

    print("AGREEMENT MONTHLY COUNT: $agreementExternalDone");
    print("DATA LEN: ${list.length}");

    setState(() {});
  }
  Future<void> _fetchPoliceMonthly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_monthly.php?Fieldwarkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Police Monthly API Error");
    }

    final decoded = jsonDecode(res.body);

    // ✅ TRY BOTH POSSIBLE STRUCTURES (SAFE)
    if (decoded["counts"] != null) {
      policeVerificationDone = int.tryParse(
        decoded["counts"]["total_police_verification"].toString(),
      ) ??
          0;
    } else {
      policeVerificationDone = int.tryParse(
        decoded["total_police_verification"].toString(),
      ) ??
          0;
    }

    final List list = decoded["data"] ?? [];

    print("POLICE MONTHLY COUNT: $policeVerificationDone");
    print("DATA LEN: ${list.length}");

    setState(() {});
  }
  Future<void> _fetchCommercialMonthly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/commercial_month.php?field_workar_number=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception("Commercial Monthly API Error");
    }

    final decoded = jsonDecode(res.body);

    // ✅ COUNT ROOT → counts SE LO
    commercialDone = int.tryParse(
      decoded["counts"]["total_commercial"].toString(),
    ) ??
        0;

    // (optional) agar list bhi chahiye
    final List list = decoded["data"] ?? [];

    print("COMMERCIAL COUNT: $commercialDone");
    print("DATA LEN: ${list.length}");

    setState(() {});
  }

  Widget _buildPeriodBanner(bool isDark) {
    if (periodStart == null || periodEnd == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Period",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
          Text(
            "${_formatDate(periodStart)}  →  ${_formatDate(periodEnd)}",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "--";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }


// 🔥 KEEP YOUR EXISTING MONTHLY API METHODS AS-IS

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Monthly Targets")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : targetGrid([
        TargetCard("Book Rent", bookRentDone, monthlyTargets["Book Rent"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MonthlyBookRentScreen()))),
        TargetCard("Live Commercial", commercialDone,
            monthlyTargets["Live Commercial"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MonthlyCommercialScreen()))),
        TargetCard("Agreement External", agreementExternalDone,
            monthlyTargets["Agreement External"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MonthlyAgreementExternalScreen()))),
        TargetCard("Police Verification", policeVerificationDone,
            monthlyTargets["Police Verification"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MonthlyPoliceVerificationScreen()))),
        TargetCard("Live Rent", liveRentDone,
            monthlyTargets["Live Rent"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MonthlyLiveRentScreen()))),
        TargetCard("Live Buy", liveBuyDone,
            monthlyTargets["Live Buy"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => MonthlyLiveBuyScreen()))),
      ]),
    );
  }
}

