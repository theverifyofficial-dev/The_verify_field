import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import '../Administrator/Adminisstrator_Target_details/Monthly_Tab/Monthly_police_verification.dart';
import 'Monthly_Tab/Book_Rent.dart';
import 'Monthly_Tab/Live_Commercial.dart';
import 'Monthly_Tab/Monthly_LiveBuy.dart';
import 'Monthly_Tab/Monthly_LiveRent.dart';
import 'Monthly_Tab/Monthly_agreement_external.dart';
import 'Yearly_Tab/Agreement_External.dart';
import 'Yearly_Tab/Book_Buy.dart';
import 'Yearly_Tab/Book_Rent.dart';
import 'Yearly_Tab/Building.dart';
import 'Yearly_Tab/Police_verification.dart';

class TargetScreen extends StatefulWidget {
  const TargetScreen({super.key});

  @override
  State<TargetScreen> createState() => _TargetScreenState();
}

class _TargetScreenState extends State<TargetScreen> {
  bool isMonthly = true;
  bool loading = true;
  String? error;

  final String fieldWorkerNumber = "11";

  // ================= TARGETS =================

  final Map<String, int> monthlyTargets = {
    "Book Rent": 4,
    "Book Buy": 5,
    "Live Rent": 15,
    "Live Buy": 5,
    "Agreement External": 10,
    "Police Verification": 10,
    "Commercial": 5,
  };

  final Map<String, int> yearlyTargets = {
    "Book Rent": 60,
    "Book Buy": 4,
    "Live Rent": 100,
    "Live Buy": 60,
    "Agreement External": 180,
    "Police Verification": 180,
    "Commercial": 60,
    "Building": 250,
  };

  // ================= DONE COUNTS =================

  int bookRentDone = 0;
  int bookBuyDone = 0;
  int liveRentDone = 0;
  int liveBuyDone = 0;
  int agreementExternalDone = 0;
  int policeVerificationDone = 0;
  int commercialDone = 0;
  int buildingYearlyDone = 0;


  @override
  void initState() {
    super.initState();
    _loadAll();
  }

  // ================= LOAD ALL =================

  Future<void> _loadAll() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      if (isMonthly) {
        await Future.wait([
          _fetchBookMonthly(),
          _fetchLiveMonthly(),
          _fetchAgreementMonthly(),
          _fetchPoliceMonthly(),
          _fetchCommercialMonthly(),
        ]);
      }
      else {
        await Future.wait([
          _fetchBookYearly(),
          _fetchLiveYearly(),
          _fetchAgreementYearly(),
          _fetchPoliceYearly(),
          _fetchCommercialYearly(),
          _fetchBuildingYearly(),
        ]);
      }
    } catch (e) {
      error = e.toString();
    }

    setState(() => loading = false);
  }

  // ================= BOOK =================

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
    }
  }

  Future<void> _fetchBookYearly() async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_yearly_show.php?field_workar_number=$fieldWorkerNumber");

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Book Yearly API Error");

    final list = jsonDecode(res.body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      bookRentDone = int.tryParse(list[0]["rent_count"].toString()) ?? 0;
      bookBuyDone = int.tryParse(list[0]["buy_count"].toString()) ?? 0;
    }
  }

  // ================= LIVE =================

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
      buildingYearlyDone =
          int.tryParse(list[0]["total_yearly_buildings"].toString()) ?? 0;
    }
  }


  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Image.asset(AppImages.transparent, height: 40),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildTabs(isDark),
          const SizedBox(height: 12),

          if (loading)
             Expanded(
              child: Center(
                child:
                  Image.asset(AppImages.loader,height: 80,
                    fit: BoxFit.contain,
                  ),
              ),
            )

          else if (error != null)
            Expanded(
              child: Center(
                child: Text(error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red)),
              ),
            )
          else
            Expanded(child: isMonthly ? _buildMonthlyGrid() : _buildYearlyGrid()),
        ],
      ),
    );
  }

  // ================= GRIDS =================

  Widget _buildMonthlyGrid() {
    return _grid([
      TargetCard(
          "Book Rent",
          bookRentDone,
          monthlyTargets
          ["Book Rent"]!,
          onTap:(){
            Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => MonthlyBookRentScreen()));
        }
      ),
      TargetCard(
          "Live Commercial",
          commercialDone,
          monthlyTargets
          ["Commercial"]!,
          onTap:(){
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => MonthlyCommercialScreen()));
          }
      ),
      TargetCard(
          "Agreement External",
          agreementExternalDone,
          monthlyTargets
          ["Agreement External"]!,
        onTap: (){
            Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => MonthlyAgreementExternalScreen()));
        },
      ),
      TargetCard(
          "Police Verification",
          policeVerificationDone,
          monthlyTargets
          ["Police Verification"]!,
        onTap: (){
            Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => MonthlyPoliceVerificationScreen()));
        },
      ),
      TargetCard(
          "Live Rent",
          liveRentDone,
          monthlyTargets
          ["Live Rent"]!,
        onTap: (){
            Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => MonthlyLiveRentScreen()));
        },
      ),
      TargetCard(
          "Live Buy",
          liveBuyDone,
          monthlyTargets
          ["Live Buy"]!,
        onTap: (){
            Navigator.push(
                context, MaterialPageRoute(
              builder: (context) => MonthlyLiveBuyScreen()));
        },
      ),
    ]);
  }

  Widget _buildYearlyGrid() {
    return _grid([
      TargetCard(
          "Book Rent",
          bookRentDone,
          yearlyTargets
          ["Book Rent"]!,
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => YearlyBookrentScreen()));
        },),
      TargetCard(
          "Book Buy",
          bookBuyDone,
          yearlyTargets
          ["Book Buy"]!,
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => YearlyBookBuyScreen()));
        },),
      TargetCard(
          "Agreement External",
          agreementExternalDone,
          yearlyTargets
          ["Agreement External"]!,
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => AgreementYearlyScreen()));
        },),
      TargetCard(
          "Police Verification",
          policeVerificationDone,
          yearlyTargets
          ["Police Verification"]!,
        onTap: (){
          Navigator.push(
              context, MaterialPageRoute(
              builder: (context) => YearlyPoliceVerificationScreen()));
        },),
      TargetCard(
          "Building",
          buildingYearlyDone,
          yearlyTargets
          ["Building"]!,
      onTap: (){
            Navigator.push(
                context, MaterialPageRoute(
                builder: (context) => YearlyBuildingScreen()));
      },),
    ]);
  }

  Widget _grid(List<Widget> children) {
    return GridView.count(
      padding: const EdgeInsets.all(14),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 1.05,
      children: children,
    );
  }

  // ================= TABS =================

  Widget _buildTabs(bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF1F5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tabButton("Monthly", isMonthly, isDark, () {
            if (!isMonthly) {
              setState(() => isMonthly = true);
              _loadAll();
            }
          }),
          _tabButton("Yearly", !isMonthly, isDark, () {
            if (isMonthly) {
              setState(() => isMonthly = false);
              _loadAll();
            }
          }),
        ],
      ),
    );
  }

  Widget _tabButton(
      String text, bool active, bool isDark, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? (isDark ? const Color(0xFF334155) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: active
                    ? (isDark ? Colors.white : Colors.black)
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ================= CARD =================

class TargetCard extends StatelessWidget {
  final String title;
  final int done;
  final int total;
  final VoidCallback? onTap;

  const TargetCard(
  this.title,
  this.done,
  this.total, {
  super.key,
  this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : done / total;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final shadow = isDark ? Colors.black45 : Colors.black12;
    final color = _colorByTitle(title);

    return
      GestureDetector(
        onTap: onTap,
        child:Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: shadow, blurRadius: 10, offset: const Offset(0, 6))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Expanded(
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w600)),
          ),
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
                color: color.withOpacity(0.15), shape: BoxShape.circle),
            child:
            Icon(_iconByTitle(title), size: 24, color: color),
          )
        ]),
        const Spacer(),
        RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: "$done",
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black)),
              TextSpan(
                  text: " / $total",
                  style:
                  TextStyle(color: isDark ? Colors.white54 : Colors.grey)),
            ])),
        const SizedBox(height: 10),
        ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
                minHeight: 10,
                value: percent,
                backgroundColor:
                isDark ? Colors.white10 : Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(color))),
        const SizedBox(height: 6),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("${(percent * 100).toInt()}% Done",
              style:
              TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
          Text("${total - done} Left",
              style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.grey)),
        ])
      ]),
        ),
    );
  }

  IconData _iconByTitle(String title) {
    if (title.contains("Rent")) return Icons.home_rounded;
    if (title.contains("Buy")) return Icons.currency_rupee_rounded;
    if (title.contains("Commercial")) return Icons.store_rounded;
    if (title.contains("Police")) return Icons.verified_user_rounded;
    if (title.contains("Agreement")) return Icons.description_rounded;
    return Icons.flag_rounded;
  }

  Color _colorByTitle(String title) {
    if (title.contains("Rent")) return const Color(0xFF22C55E);
    if (title.contains("Buy")) return const Color(0xFFA855F7);
    if (title.contains("Commercial")) return const Color(0xFF06B6D4);
    if (title.contains("Police")) return const Color(0xFFF97316);
    if (title.contains("Agreement")) return const Color(0xFFEF4444);
    return Colors.blue;
  }
}
