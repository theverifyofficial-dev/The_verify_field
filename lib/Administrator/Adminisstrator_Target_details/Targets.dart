import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import '../../Target_details/Monthly_Tab/Book_Rent.dart';
import '../../Target_details/Monthly_Tab/Live_Commercial.dart';
import '../../Target_details/Monthly_Tab/Monthly_LiveBuy.dart';
import '../../Target_details/Monthly_Tab/Monthly_LiveRent.dart';
import '../../Target_details/Monthly_Tab/Monthly_agreement_external.dart';
import '../../Target_details/Monthly_Tab/Monthly_police_verification.dart';
import '../../Target_details/Yearly_Tab/Agreement_External.dart';
import '../../Target_details/Yearly_Tab/Book_Buy.dart';
import '../../Target_details/Yearly_Tab/Book_Rent.dart';
import '../../Target_details/Yearly_Tab/Building.dart';
import '../../Target_details/Yearly_Tab/Police_verification.dart';
import 'Monthly_Tab/Book_Rent.dart';
import 'Monthly_Tab/Live_Commercial.dart';
import 'Monthly_Tab/Monthly_LiveBuy.dart';
import 'Monthly_Tab/Monthly_LiveRent.dart';
import 'Monthly_Tab/Monthly_agreement_external.dart';
import 'Monthly_Tab/Monthly_police_verification.dart';
import 'Yearly_Tab/Agreement_External.dart';
import 'Yearly_Tab/Book_Buy.dart';
import 'Yearly_Tab/Book_Rent.dart';
import 'Yearly_Tab/Building.dart';
import 'Yearly_Tab/Police_verification.dart';

class Target extends StatefulWidget {
  const Target({super.key});
  @override
  State<Target> createState() => _TargetState();
}
/* ================= USER DATA MODEL ================= */
class UserCounts {
  int bookRent = 0;
  int bookBuy = 0;
  int liveRent = 0;
  int liveBuy = 0;
  int agreement = 0;
  int police = 0;
  int commercial = 0;
  int building = 0;
 //--------Overview---------
  int ovAgreement = 0;
  int ovBuilding = 0;
  int ovTotalFlats = 0;
  int ovLiveFlats = 0;
  int ovUnLiveFlats = 0; // Book
  int ovFlat = 0;        // 👈 NEW (optional)
}

/* ================= STATE ================= */

class _TargetState extends State<Target> {
  bool isMonthly = true;
  bool loading = true;
  String? error;
  String? userRole;
  String? userLocation;


  final List<Map<String, String>> allUsers = [
    {"name": "Sumit", "number": "9711775300", "location": "Sultanpur"},
    {"name": "Ravi Kumar", "number": "9711275300", "location": "Sultanpur"},
    {"name": "Faizan Khan", "number": "9971172204", "location": "Sultanpur"},
    {"name": "Manish", "number": "8130209217", "location": "Rajpur Khurd"},
    {"name": "Abhay", "number": "9675383184", "location": "Rajpur Khurd"},
  ];

  List<Map<String, String>> users = []; // filtered list



  /// ===== TARGETS =====
  final Map<String, int> monthlyTargets = {
    "Book Rent": 4,
    "Live Rent": 15,
    "Live Buy": 5,
    "Agreement External": 10,
    "Police Verification": 10,
    "Commercial": 5,
  };

  final Map<String, int> yearlyTargets = {
    "Book Rent": 60,
    "Book Buy": 4,
    "Agreement External": 180,
    "Police Verification": 180,
    "Commercial": 60,
    "Building": 250,
  };

  /// ===== USER DATA =====
  final Map<String, UserCounts> userData = {}; // key = mobile number

  @override
  void initState() {
    super.initState();
    _loadUserAndFilter();

  }

  Future<void> _loadUserAndFilter() async {
    final prefs = await SharedPreferences.getInstance();

    userRole = prefs.getString("post");
    userLocation = prefs.getString("location");

    _filterUsersByRole();
    await _loadAll(); // 🔥 load data immediately
  }


  void _filterUsersByRole() {
    if (userRole == "Administrator") {
      users = List.from(allUsers);
    } else {
      final loc = (userLocation ?? "").trim().toLowerCase();

      users = allUsers.where((u) {
        final uLoc = (u["location"] ?? "").trim().toLowerCase();
        return uLoc == loc;
      }).toList();
    }
  }

  String  activeTab = "Overview"; // Monthly | Overview | Yearly

  /* ================= LOAD ALL USERS ================= */

  Future<void> _loadAll() async {
    setState(() {
      loading = true;
      error = null;
    });

    try {
      userData.clear();

      final List<Future> allFutures = [];

      for (final u in users) {
        final String num = u["number"]!;
        userData[num] = UserCounts();

        if (activeTab == "Monthly") {
          allFutures.addAll([
            _fetchBookMonthly(num),
            _fetchLiveMonthly(num),
            _fetchAgreementMonthly(num),
            _fetchPoliceMonthly(num),
            _fetchCommercialMonthly(num),
          ]);
        } else if (activeTab == "Yearly") {
          allFutures.addAll([
            _fetchBookYearly(num),
            _fetchAgreementYearly(num),
            _fetchPoliceYearly(num),
            _fetchCommercialYearly(num),
            _fetchBuildingYearly(num),
          ]);
        } else {
          allFutures.addAll([
            _fetchOverviewAgreement(num),
            _fetchOverviewBuilding(num),
            _fetchOverviewTotalFlats(num),
            _fetchOverviewLiveAndUnLiveFlats(num),
          ]);
        }
      }

      await Future.wait(allFutures); // 🔥 ALL APIs PARALLEL
    } catch (e) {
      error = e.toString();
    }

    setState(() => loading = false);
  }




  Future<void> _fetchOverviewAgreement(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target/show_tatal_agreement.php?Fieldwarkarnumber=$number");

    final j = jsonDecode((await http.get(uri)).body);
    userData[number]!.ovAgreement =
        int.tryParse(j["data"]?["logg"]?.toString() ?? "0") ?? 0;
  }


  Future<void> _fetchOverviewBuilding(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target/count_api_for_building.php?fieldworkarnumber=$number");

    final j = jsonDecode((await http.get(uri)).body);
    userData[number]!.ovBuilding =
        int.tryParse(j["data"]?["logg"]?.toString() ?? "0") ?? 0;
  }

  Future<void> _fetchOverviewTotalFlats(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=$number");

    final res = await http.get(uri);

    final decoded = jsonDecode(res.body);

    if (decoded is List && decoded.isNotEmpty) {
      userData[number]!.ovTotalFlats =
          int.tryParse(decoded[0]["subid"].toString()) ?? 0;
    } else {
      userData[number]!.ovTotalFlats = 0;
    }
  }


  Future<void> _fetchOverviewLiveAndUnLiveFlats(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=$number");

    final res = await http.get(uri);
    final decoded = jsonDecode(res.body);

    int live = 0;
    int book = 0;
    int flat = 0;

    if (decoded is List) {
      for (final item in decoded) {
        final type = item["live_unlive"]?.toString().toLowerCase();
        final count = int.tryParse(item["subid"].toString()) ?? 0;

        if (type == "live") {
          live = count;
        } else if (type == "book") {
          book = count;
        } else if (type == "flat") {
          flat = count;
        }
      }
    }

    userData[number]!.ovLiveFlats = live;
    userData[number]!.ovUnLiveFlats = book;
    userData[number]!.ovFlat = flat; // optional
  }



  /* ================= APIs (MONTHLY) ================= */

  Future<void> _fetchBookMonthly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_monthly_show.php?field_workar_number=$number");
    final list = jsonDecode((await http.get(uri)).body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      userData[number]!.bookRent =
          int.tryParse(list[0]["rent_count"].toString()) ?? 0;
      userData[number]!.bookBuy =
          int.tryParse(list[0]["buy_count"].toString()) ?? 0;
    }
  }

  Future<void> _fetchLiveMonthly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/live_monthly_show.php?field_workar_number=$number");
    final decoded = jsonDecode((await http.get(uri)).body);
    if (decoded["counts"] != null) {
      userData[number]!.liveRent =
          int.tryParse(decoded["counts"]["rent_count"].toString()) ?? 0;
      userData[number]!.liveBuy =
          int.tryParse(decoded["counts"]["buy_count"].toString()) ?? 0;
    }
  }

  Future<void> _fetchAgreementMonthly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_monthly_show.php?Fieldwarkarnumber=$number");
    final decoded = jsonDecode((await http.get(uri)).body);
    userData[number]!.agreement =
        int.tryParse(decoded["total_agreement"].toString()) ?? 0;
  }

  Future<void> _fetchPoliceMonthly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_monthly.php?Fieldwarkarnumber=$number");
    final decoded = jsonDecode((await http.get(uri)).body);
    userData[number]!.police =
        int.tryParse(decoded["total_police_verification"].toString()) ?? 0;
  }

  Future<void> _fetchCommercialMonthly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/commercial_month.php?field_workar_number=$number");
    final decoded = jsonDecode((await http.get(uri)).body);
    userData[number]!.commercial =
        int.tryParse(decoded["counts"]["total_commercial"].toString()) ?? 0;
  }

  /* ================= APIs (YEARLY) ================= */

  Future<void> _fetchBookYearly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_yearly_show.php?field_workar_number=$number");
    final list = jsonDecode((await http.get(uri)).body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      userData[number]!.bookRent =
          int.tryParse(list[0]["rent_count"].toString()) ?? 0;
      userData[number]!.bookBuy =
          int.tryParse(list[0]["buy_count"].toString()) ?? 0;
    }
  }

  Future<void> _fetchAgreementYearly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/agreement_external_yearly_show.php?Fieldwarkarnumber=$number");
    final decoded = jsonDecode((await http.get(uri)).body);
    userData[number]!.agreement =
        int.tryParse(decoded["total_agreement"].toString()) ?? 0;
  }

  Future<void> _fetchPoliceYearly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_yearly.php?Fieldwarkarnumber=$number");
    final decoded = jsonDecode((await http.get(uri)).body);
    userData[number]!.police =
        int.tryParse(decoded["total_police_verification"].toString()) ?? 0;
  }

  Future<void> _fetchCommercialYearly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/commercial_yearly.php?field_workar_number=$number");
    final list = jsonDecode((await http.get(uri)).body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      userData[number]!.commercial =
          int.tryParse(list[0]["total_commercial"].toString()) ?? 0;
    }
  }

  Future<void> _fetchBuildingYearly(String number) async {
    final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/building_data_yearly.php?fieldworkarnumber=$number");
    final json = jsonDecode((await http.get(uri)).body);
    final list = json["data"] as List? ?? [];
    if (list.isNotEmpty) {
      userData[number]!.building =
          int.tryParse(list[0]["total_yearly_buildings"].toString()) ?? 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildTabs(isDark),
          const SizedBox(height: 12),

          if (loading)
            Expanded(
              child: Center(
                child: Image.asset(AppImages.loader, height: 80),
              ),
            )
          else if (error != null)
            Expanded(
              child: Center(
                child: Text(error!,
                    style: const TextStyle(color: Colors.red)),
              ),
            )
          else
            Expanded(
              child: activeTab == "Monthly"
                  ? _buildMonthlyByUser()
                  : activeTab == "Yearly"
                  ? _buildYearlyByUser()
                  : _buildOverviewByUser(),
            ),

        ],
      ),
    );
  }

  /* ================= TABS ================= */
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
          _tabButton("Overview", isDark),
          _tabButton("Monthly", isDark),
          _tabButton("Yearly", isDark),
        ],
      ),
    );
  }

  Widget _tabButton(
      String text, bool isDark) {
    final active = activeTab == text;

          return Expanded(
            child: GestureDetector(
              onTap: () {
          if (activeTab != text) {
          setState(() => activeTab = text);
          _loadAll();
          }
          },
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

  /* ================= LIST BY USER ================= */

  Widget _buildMonthlyByUser() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u = users[i];
        return _userSection(
          u["name"]!,
          u["number"]!,
          _monthlyCards(u["number"]!),
        );
      },
    );
  }

  Widget _buildYearlyByUser() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u = users[i];
        return _userSection(
          u["name"]!,
          u["number"]!,
          _yearlyCards(u["number"]!),
        );
      },
    );
  }

  Widget _buildOverviewByUser() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: users.length,
      itemBuilder: (_, i) {
        final u = users[i];
        return _userSection(
          u["name"]!,
          u["number"]!,
          _overviewCards(u["number"]!),
        );
      },
    );
  }


  Widget _userSection(String name, String number, List<Widget> cards) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "$name • $number",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
        ),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.9,
          children: cards,
        ),
        const SizedBox(height: 16),
      ],
    );
  }


  List<Widget> _monthlyCards(String number) {
    final d = userData[number]!;
    return [
      TargetCard("Book Rent", d.bookRent, monthlyTargets["Book Rent"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => MonthlyBookRent(number: number,)))),
      TargetCard("Commercial", d.commercial, monthlyTargets["Commercial"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => MonthlyCommercial(number: number,)))),
      TargetCard("Agreement", d.agreement, monthlyTargets["Agreement External"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => MonthlyAgreementExternal(number: number)))),
      TargetCard("Police", d.police, monthlyTargets["Police Verification"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => MonthlyPoliceVerification(number: number,)))),
      TargetCard("Live Rent", d.liveRent, monthlyTargets["Live Rent"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => MonthlyLiveRent(number: number,)))),
      TargetCard("Live Buy", d.liveBuy, monthlyTargets["Live Buy"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => MonthlyLiveBuy(number: number,)))),
    ];
  }

  List<Widget> _yearlyCards(String number) {
    final d = userData[number]!;

    return [
      TargetCard("Book Rent", d.bookRent, yearlyTargets["Book Rent"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyBookrent(number: number,)))),
      TargetCard("Book Buy", d.bookBuy, yearlyTargets["Book Buy"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyBookBuy(number: number,)))),
      TargetCard("Agreement", d.agreement, yearlyTargets["Agreement External"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => AgreementYearly(num: number,)))),
      TargetCard("Police", d.police, yearlyTargets["Police Verification"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyPoliceVerification(number: number)))),
      TargetCard("Building", d.building, yearlyTargets["Building"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyBuilding(number: number)))),
    ];
  }

  List<Widget> _overviewCards(String number) {
    final d = userData[number]!;

    final List<Widget> cards = [
      TargetsCard("Agreement", d.ovAgreement),
      TargetsCard("Buildings", d.ovBuilding),
      TargetsCard("Total Flats", d.ovTotalFlats),
      TargetsCard("Live Flats", d.ovLiveFlats),
      TargetsCard("UnLive Flats", d.ovUnLiveFlats),
    ];

    // // ✅ Only show Flat if count > 0
    // if (d.ovFlat > 0) {
    //   cards.add(TargetsCard("Flat", d.ovFlat));
    // }

    return cards;
  }



  List<Widget> _OverviewCards(String number) {
    final d = userData[number]!;

    return [
      TargetCard("Book Rent", d.bookRent, yearlyTargets["Book Rent"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyBookrentScreen()))),
      TargetCard("Book Buy", d.bookBuy, yearlyTargets["Book Buy"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyBookBuyScreen()))),
      TargetCard("Agreement", d.agreement,
          yearlyTargets["Agreement External"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => AgreementYearlyScreen()))),
      TargetCard("Police", d.police,
          yearlyTargets["Police Verification"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyPoliceVerificationScreen()))),
      TargetCard("Building", d.building, yearlyTargets["Building"]!,
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (_) => YearlyBuildingScreen()))),
    ];
  }
}

/* ================= CARD ================= */

class TargetCard extends StatelessWidget {
  final String title;
  final int done;
  final int total;
  final VoidCallback? onTap;

  const TargetCard(this.title, this.done, this.total, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final percent = total == 0 ? 0.0 : done / total;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1F2937) : Colors.white;
    final shadow = isDark ? Colors.black45 : Colors.black12;
    final color = _colorByTitle(title);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(color: shadow, blurRadius: 10, offset: const Offset(0, 6))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                child: Icon(_iconByTitle(title), size: 24, color: color),
              )
            ]),
            const Spacer(),
            Text("$done / $total",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              minHeight: 8,
              value: percent,
              backgroundColor: isDark ? Colors.white10 : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconByTitle(String title) {
    if (title.contains("Rent"))
      return Icons.home_rounded;
    if (title.contains("Buy"))
      return Icons.currency_rupee_rounded;
    if (title.contains("Commercial"))
      return Icons.store_rounded;
    if (title.contains("Police"))
      return Icons.verified_user_rounded;
    if (title.contains("Agreement"))
      return Icons.description_rounded;
    return Icons.flag_rounded;
  }

  Color _colorByTitle(String title) {
    if (title.contains("Rent"))
      return const Color(0xFF22C55E);
    if (title.contains("Buy"))
      return const Color(0xFFA855F7);
    if (title.contains("Commercial"))
      return const Color(0xFF06B6D4);
    if (title.contains("Police"))
      return const Color(0xFFF97316);
    if (title.contains("Agreement"))
      return const Color(0xFFEF4444);
    return Colors.blue;
  }
}
/* ================= CARD ================= */

class TargetsCard extends StatelessWidget {
  final String title;
  final int count;

  const TargetsCard(this.title, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = _colorByTitle(title);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1F2937) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black45 : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black87,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(_iconByTitle(title), size: 22, color: color),
            )
          ]),
          const Spacer(),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text("Count", style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  IconData _iconByTitle(String title) {
    if (title.contains("Flat")) return Icons.apartment_rounded;
    if (title.contains("Building")) return Icons.business_rounded;
    if (title.contains("Agreement")) return Icons.description_rounded;
    return Icons.flag_rounded;
  }

  Color _colorByTitle(String title) {
    if (title.contains("Agreement")) return const Color(0xFFEF4444);
    if (title.contains("Building")) return const Color(0xFF06B6D4);
    if (title.contains("Flat")) return const Color(0xFF22C55E);
    return Colors.blue;
  }
}
