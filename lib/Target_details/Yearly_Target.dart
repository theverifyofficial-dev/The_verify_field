import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Target_Widget.dart';
import 'Yearly_Tab/Agreement_External.dart';
import 'Yearly_Tab/Book_Buy.dart';
import 'Yearly_Tab/Book_Rent.dart';
import 'Yearly_Tab/Building.dart';
import 'Yearly_Tab/Police_verification.dart';

class YearlyTargetScreen extends StatefulWidget {
  const YearlyTargetScreen({super.key});

  @override
  State<YearlyTargetScreen> createState() => _YearlyTargetScreenState();
}

class _YearlyTargetScreenState extends State<YearlyTargetScreen> {
  bool loading = true;
  String? fieldWorkerNumber;

  int bookRentDone = 0;
  int bookBuyDone = 0;
  int agreementExternalDone = 0;
  int policeVerificationDone = 0;
  int buildingDone = 0;
  int commercialDone = 0;
  int liveRentDone = 0;
  int liveBuyDone = 0;

  final Map<String, int> yearlyTargets = {
    "Book Rent": 60,
    "Book Buy": 4,
    "Agreement External": 180,
    "Police Verification": 180,
    "Building": 250,
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
      _fetchBookYearly(),
      _fetchAgreementYearly(),
      _fetchPoliceYearly(),
      _fetchBuildingYearly(),
      _fetchLiveYearly(),
      _fetchCommercialYearly(),
    ]);

    setState(() => loading = false);
  }



  Future<void> _fetchBookYearly() async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_yearly_show.php?field_workar_number=$fieldWorkerNumber");

    print("Number from shared: $fieldWorkerNumber");

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Book Yearly API Error");

    final list = jsonDecode(res.body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      bookRentDone = int.tryParse(list[0]["rent_count"].toString()) ?? 0;
      bookBuyDone = int.tryParse(list[0]["buy_count"].toString()) ?? 0;
    }
  }




  Future<void> _fetchLiveYearly() async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/live_yearly_show.php?field_workar_number=$fieldWorkerNumber");

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Live Yearly API Error");

    final list = jsonDecode(res.body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      liveRentDone =
          int.tryParse(list[0]["total_live_rent_flat"].toString()) ?? 0;
      liveBuyDone = 0;
    }
  }

  // ================= AGREEMENT =================



  Future<void> _fetchAgreementYearly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_yearly_show.php?Fieldwarkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Agreement Yearly API Error");

    final decoded = jsonDecode(res.body);

    // ✅ TOTAL COUNT
    agreementExternalDone =
        int.tryParse(decoded["total_agreement"].toString()) ?? 0;

    // ✅ AGREEMENT LIST (IF YOU NEED)
    final List list = decoded["data"] ?? [];

    print("TOTAL AGREEMENT: $agreementExternalDone");
    print("LIST LENGTH: ${list.length}");

    setState(() {});
  }


  //================= POLICE =================



  Future<void> _fetchPoliceYearly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_yearly.php?Fieldwarkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Police Yearly API Error");

    final decoded = jsonDecode(res.body);

    // ✅ COUNT ROOT LEVEL SE LO
    policeVerificationDone =
        int.tryParse(decoded["total_police_verification"].toString()) ?? 0;

    // ✅ AGAR LIST BHI CHAHIYE
    final List list = decoded["data"] ?? [];

    print("POLICE COUNT: $policeVerificationDone");
    print("LIST LEN: ${list.length}");

    setState(() {});
  }


  // ================= COMMERCIAL =================



  Future<void> _fetchCommercialYearly() async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/commercial_yearly.php?field_workar_number=$fieldWorkerNumber");

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Commercial Yearly API Error");

    final list = jsonDecode(res.body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      commercialDone =
          int.tryParse(list[0]["total_commercial"].toString()) ?? 0;
    }
  }

  // ================= BUILDING YEARLY =================

  Future<void> _fetchBuildingYearly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/building_data_yearly.php?fieldworkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Building Yearly API Error");

    final json = jsonDecode(res.body);
    final list = json["data"] as List? ?? [];

    if (list.isNotEmpty) {
      buildingDone  =
          int.tryParse(list[0]["total_yearly_buildings"].toString()) ?? 0;
    }
  }


  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yearly Targets")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : targetGrid([
        TargetCard("Book Rent", bookRentDone,
            yearlyTargets["Book Rent"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => YearlyBookrentScreen()))),
        TargetCard("Book Buy", bookBuyDone,
            yearlyTargets["Book Buy"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => YearlyBookBuyScreen()))),
        TargetCard("Agreement External", agreementExternalDone,
            yearlyTargets["Agreement External"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => AgreementYearlyScreen()))),
        TargetCard("Police Verification", policeVerificationDone,
            yearlyTargets["Police Verification"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => YearlyPoliceVerificationScreen()))),
        TargetCard("Building", buildingDone,
            yearlyTargets["Building"]!,
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => YearlyBuildingScreen()))),
      ]),
    );
  }
}

