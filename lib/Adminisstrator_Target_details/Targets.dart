import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/ui_decoration_tools/app_images.dart';
import '../../Target_details/Monthly_Tab/Monthly_police_verification.dart';
import '../Target_details/history_target.dart';
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
  int ovFlat = 0;


  int ovBuildingWithFlat = 0;
  int ovBuildingWithoutFlat = 0;
  int ovBuildingTotal = 0;// 👈 NEW (optional)
}

/* ================= STATE ================= */

class _TargetState extends State<Target> {
  bool isMonthly = true;
  bool loading = true;
  String? error;
  String? userRole;
  String? userLocation;
  DateTime? periodStart;
  DateTime? periodEnd;


  final List<Map<String, String>> allUsers = [
    {"name": "Sumit", "number": "9711775300", "location": "Sultanpur"},
    {"name": "Ravi Kumar", "number": "9711275300", "location": "Sultanpur"},
    {"name": "Faizan Khan", "number": "9971172204", "location": "Sultanpur"},
    // {"name": "avjit", "number": "11", "location": "Sultanpur"},
    // {"name": "Manish", "number": "8130209217", "location": "Rajpur Khurd"},
    // {"name": "Abhay", "number": "9675383184", "location": "Rajpur Khurd"},
  ];

  List<Map<String, String>> users = []; // filtered list
  void _openBuildingCalculator(UserCounts d) {
    final int target = yearlyTargets["Building"]!;
    final int done = d.ovBuildingWithFlat;
    final int remaining = (target - done).clamp(0, target);

    final int totalBuildings = d.ovBuildingTotal;
    final int emptyBuildings = d.ovBuildingWithoutFlat;
    final int buildingsWithFlat = d.ovBuildingWithFlat;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,   // ✅ IMPORTANT
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.40,
          maxChildSize: 0.90,
          builder: (context, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),

              /// ✅ SCROLL FIX
              child: ListView(
                controller: controller,
                children: [

                  /// HEADER
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(.12),
                        ),
                        child: const Icon(
                          Icons.calculate_outlined,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "Building Target Intelligence",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "PoppinsBold",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: isDark
                          ? Colors.white.withOpacity(.04)
                          : Colors.grey.shade100,
                    ),
                    child: Row(
                      children: [
                        Expanded(child: _miniStat("Total", totalBuildings)),
                        Expanded(child: _miniStat("Without Flats", emptyBuildings)),
                        Expanded(child: _miniStat("With Flats", buildingsWithFlat)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 13),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                          const Color(0xFF1E3A8A), // deep blue
                          const Color(0xFF2563EB),
                        ]
                            : [
                          const Color(0xFF3B82F6),
                          const Color(0xFF135BEC),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        /// ICON BADGE
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.18),
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "YEARLY TARGET",
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                  color: Colors.white70,
                                  fontFamily: "PoppinsBold",
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                "$target Buildings",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: "PoppinsBold",
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// OPTIONAL KPI STYLE
                        Text(
                          "🎯",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(.9),
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 13),
                  _calcTile("Per Week", remaining, 52, done, target),
                  _calcTile("Per Month", remaining, 12, done, target),
                  _calcTile("3 Month Pace", remaining, 4, done, target),
                  _calcTile("6 Month Pace", remaining, 2, done, target),
                  _calcTile("8 Month Pace", remaining, 1.5, done, target),
                  _calcTile("10 Month Pace", remaining, 1.2, done, target),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget _calcTile(
      String label,
      int remaining,
      double divisor,
      int done,
      int target,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double raw = remaining / divisor;
    final int required = raw.ceil();

    final Color accent = const Color(0xFF3B82F6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark
            ? Colors.white.withOpacity(.05)
            : Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔝 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "PoppinsBold",
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                "$required Buildings",
                style:  TextStyle(
                  fontSize: 13,
                  fontFamily: "PoppinsBold",
                  color: accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),



          /// ✅ SIMPLE INSTRUCTION
          Text(
            "Complete $required buildings every $label to reach your target.",
            style: TextStyle(
              fontSize: 11.5,
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),

          const SizedBox(height: 8),

          /// ✅ REMAINING
          Text(
            "Remaining: $remaining Buildings",
            style: TextStyle(
              fontSize: 11,
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, int value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        /// VALUE (Primary Focus)
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontFamily: "PoppinsBold",
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(height: 4),

        /// LABEL (Secondary)
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontFamily: "PoppinsMedium",
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }



  /// ===== TARGETS =====
  final Map<String, int> monthlyTargets = {
    "Book Rent": 4,
    "Live Rent": 15,
    "Live Buy": 5,
    "Agreement External": 20,
    "Police Verification": 20,
    "Commercial": 5,
  };

  final Map<String, int> yearlyTargets = {
    "Book Rent": 60,
    "Book Buy": 4,
    "Agreement External": 300,
    "Police Verification": 300,
    "Commercial": 60,
    "Building": 250,
  };

  /// ===== USER DATA =====
  final Map<String, UserCounts> userData = {};

  @override
  void initState() {
    super.initState();
    _loadUserAndFilter();
  }
  int totalBuildings = 0;
  int buildingsWithFlat = 0;
  int emptyBuildings = 0;
  Future<void> _fetchOverviewBuildingDetail(String number) async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/building_over_view.php?fieldworkarnumber=$number",
    );

    final res = await http.get(uri);

    if (res.statusCode != 200) return;

    final decoded = jsonDecode(res.body);
    final data = decoded["data"] ?? {};

    final counts = userData[number]!;

    counts.ovBuildingTotal =
        int.tryParse(data["total_building"].toString()) ?? 0;

    counts.ovBuildingWithFlat =
        int.tryParse(data["building_with_flat"].toString()) ?? 0;

    counts.ovBuildingWithoutFlat =
        int.tryParse(data["building_without_flat"].toString()) ?? 0;

    if (mounted) setState(() {});   // ✅ FORCE UI REFRESH
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

      if (activeTab == "Monthly" && users.isNotEmpty) {
        await _fetchMonthlyPeriod(); // ✅ PERIOD FETCHED ONCE
      }

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
            _fetchOverviewBuildingDetail(num)
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

  Future<void> _fetchMonthlyPeriod() async {
    for (final u in users) {
      final number = u["number"]!;
      print("📡 Trying period from $number");

      final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/book_monthly_show.php?field_workar_number=$number",
      );

      final res = await http.get(uri);
      if (res.statusCode != 200) continue;

      final decoded = jsonDecode(res.body);
      final List list = decoded["data"] ?? [];

      if (list.isNotEmpty) {
        periodStart = DateTime.tryParse(
          list[0]["period_start"]["date"],
        );
        periodEnd = DateTime.tryParse(
          list[0]["period_end"]["date"],
        );

        print("✅ Period FOUND from $number");
        return; // 🔥 STOP once found
      }
    }

    print("❌ Period not found for any user");
  }



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
  String _formatDate(DateTime? date) {
    if (date == null) return "--";
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Widget _buildPeriodBanner(bool isDark) {
    if (periodStart == null || periodEnd == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
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
      ),
    );
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
        surfaceTintColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Image.asset(AppImages.transparent, height: 40),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          _buildTabs(isDark),
          if (activeTab == "Monthly")
            _buildPeriodBanner(isDark),
          const SizedBox(height: 10),

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
        color: isDark
            ? Colors.white.withOpacity(0.06)
            : Colors.grey.shade200,

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

  Widget _tabButton(String text, bool isDark) {
    final bool active = activeTab == text;

    final Color accent = const Color(0xFF135BEC); // Primary Blue

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!active) {
            setState(() => activeTab = text);
            _loadAll();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: active
                ? accent
                : Colors.transparent,

            borderRadius: BorderRadius.circular(28),

          ),
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 260),
              style: TextStyle(
                fontSize: 13,
                fontFamily: active?"PoppinsBold":"PoppinsMedium",

                fontWeight: FontWeight.w600,
                color: active
                    ? Colors.white
                    : (isDark ? Colors.white60 : Colors.black54),
              ),
              child: Text(text),
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

        /// 🔥 HEADER
        Row(
          children: [

            /// Worker Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: "PoppinsBold",
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    number,
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "PoppinsMedium",
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),

            /// 🔥 HISTORY BUTTON
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TargetHistoryScreen(number: number),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark
                      ? Colors.white.withOpacity(0.08)
                      : Colors.grey.shade100,
                ),
                child: Icon(
                  Icons.history,
                  size: 20,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        activeTab == "Overview"
            ? GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.15,
          children: cards,
        )
            : Column(
          children: cards
              .map((card) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: card,
          ))
              .toList(),
        ),

      ],
    );
  }

  List<Widget> _monthlyCards(String number) {
    final d = userData[number]!;

    return [

      TargetMetricCard(
        title: "Book Rent",
        done: d.bookRent,
        total: monthlyTargets["Book Rent"]!,
        icon: metricIcon("Book Rent"),
        color: metricColor("Book Rent"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonthlyBookRent(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Live Rent",
        done: d.liveRent,
        total: monthlyTargets["Live Rent"]!,
        icon: metricIcon("Live Rent"),
        color: metricColor("Live Rent"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonthlyLiveRent(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Live Buy",
        done: d.liveBuy,
        total: monthlyTargets["Live Buy"]!,
        icon: metricIcon("Live Buy"),
        color: metricColor("Live Buy"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonthlyLiveBuy(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Agreement",
        done: d.agreement,
        total: monthlyTargets["Agreement External"]!,
        icon: metricIcon("Agreement"),
        color: metricColor("Agreement"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonthlyAgreementExternal(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Police",
        done: d.police,
        total: monthlyTargets["Police Verification"]!,
        icon: metricIcon("Police"),
        color: metricColor("Police"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonthlyPoliceVerification(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Commercial",
        done: d.commercial,
        total: monthlyTargets["Commercial"]!,
        icon: metricIcon("Commercial"),
        color: metricColor("Commercial"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MonthlyCommercial(number: number),
          ),
        ),
      ),
    ];
  }

  List<Widget> _yearlyCards(String number) {
    final d = userData[number]!;

    return [

      TargetMetricCard(
        title: "Book Rent",
        done: d.bookRent,
        total: yearlyTargets["Book Rent"]!,
        icon: metricIcon("Book Rent"),
        color: metricColor("Book Rent"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => YearlyBookrent(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Book Buy",
        done: d.bookBuy,
        total: yearlyTargets["Book Buy"]!,
        icon: metricIcon("Book Buy"),
        color: metricColor("Book Buy"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => YearlyBookBuy(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Agreement",
        done: d.agreement,
        total: yearlyTargets["Agreement External"]!,
        icon: metricIcon("Agreement"),
        color: metricColor("Agreement"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AgreementYearly(num: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Police",
        done: d.police,
        total: yearlyTargets["Police Verification"]!,
        icon: metricIcon("Police"),
        color: metricColor("Police"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => YearlyPoliceVerification(number: number),
          ),
        ),
      ),

      TargetMetricCard(
        title: "Building",
        done: d.building,
        total: yearlyTargets["Building"]!,
        icon: metricIcon("Building"),
        color: metricColor("Building"),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => YearlyBuilding(number: number),
          ),
        ),
      ),
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
      TargetsCard(
        "Building Calculation",
        d.ovBuildingWithFlat,
        onTap: () => _openBuildingCalculator(d),
      ),
    ];

    // // ✅ Only show Flat if count > 0
    // if (d.ovFlat > 0) {
    //   cards.add(TargetsCard("Flat", d.ovFlat));
    // }

    return cards;
  }
}



IconData metricIcon(String title) {
  final t = title.toLowerCase();

  if (t.contains("book rent")) return Icons.bookmark_border;
  if (t.contains("live rent")) return Icons.sensors;
  if (t.contains("live buy")) return Icons.sell_outlined;
  if (t.contains("agreement")) return Icons.gavel_outlined;
  if (t.contains("police")) return Icons.shield_outlined;
  if (t.contains("commercial")) return Icons.business_center_outlined;
  if (t.contains("building")) return Icons.domain_outlined;

  return Icons.analytics_outlined;
}

Color metricColor(String title) {
  final t = title.toLowerCase();

  if (t.contains("agreement")) return const Color(0xFFEF4444);
  if (t.contains("book rent")) return const Color(0xFF6366F1);
  if (t.contains("police")) return const Color(0xFFF59E0B);
  if (t.contains("commercial")) return const Color(0xFF06B6D4);
  if (t.contains("buy")) return const Color(0xFFA855F7);
  if (t.contains("rent")) return const Color(0xFF22C55E);
  if (t.contains("building")) return const Color(0xFF22C55E);

  return const Color(0xFF135BEC);
}

class TargetMetricCard extends StatelessWidget {
  final String title;
  final int done;
  final int total;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const TargetMetricCard({
    super.key,
    required this.title,
    required this.done,
    required this.total,
    required this.icon,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final percent = total == 0 ? 0.0 : (done / total).clamp(0.0, 1.0);
    final remain = (total - done).clamp(0, total);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? Colors.black87
              : Colors.white,

          borderRadius: BorderRadius.circular(18),

          border: Border.all(
            color: isDark
                ? const Color(0xFF2A3142)
                : Colors.grey.shade200,
          ),

          boxShadow: [
            /// Soft depth
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),

            /// Subtle glow tint
            BoxShadow(
              color: color.withOpacity(isDark ? .01: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 TOP SECTION
            Row(
              children: [

                /// Icon Bubble
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 20, color: color),
                ),

                const SizedBox(width: 12),

                /// Title + Remain
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontFamily: "PoppinsMedium",
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Remain: $remain",
                        style: TextStyle(
                          fontFamily: "PoppinsMedium",

                          fontSize: 10.5,
                          color: isDark
                              ? Colors.white
                              : Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Done/Total
                Text(
                  "$done / $total",
                  style: TextStyle(
                    fontSize: 12.5,
                    fontFamily: "PoppinsBold",
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            /// 🔥 PROGRESS BAR
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [

                  /// Background Track
                  Container(
                    height: 7,
                    width: double.infinity,
                    color: isDark
                        ? Colors.white10
                        : Colors.black12,
                  ),

                  /// Progress Fill
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOutCubic,
                    height: 7,
                    width: MediaQuery.of(context).size.width * percent,
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            /// 🔥 FOOTER KPI LABEL
            Row(
              children: [
                Text(
                  "Completion",
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: "PoppinsBold",
                    color: isDark
                        ? Colors.white70
                        : Colors.black38,
                  ),
                ),
                const Spacer(),
                Text(
                  "${(percent * 100).toInt()}%",
                  style: TextStyle(
                    fontSize: 10.5,
                    fontFamily: "PoppinsBold",
                    fontWeight: FontWeight.w600,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accent = _colorByTitle(title);

    final remain = (total - done).clamp(0, total); // 🔥 safety

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: accent.withOpacity(0.10),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: accent.withOpacity(0.25),
          ),
        ),
        child: Stack(
          children: [

            /// 🔥 BIG FADED ICON
            Positioned(
              right: -6,
              bottom: -6,
              child: Icon(
                _iconByTitle(title),
                size: 70,
                color: accent.withOpacity(isDark ? 0.10 : 0.18),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Row(
                  children: [
                    Text(
                      title.toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        fontFamily: "PoppinsBold",

                        fontWeight: FontWeight.bold,
                        color: accent,
                      ),
                    ),
                    const Spacer(),

                    Text(
                      "Remain: $remain",
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: "PoppinsBold",
                        fontWeight: FontWeight.w600,
                        color: isDark?Colors.white:Colors.black87, // 🔥 highlight
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                /// 🔥 DONE NUMBER
                Text(
                  done.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 4),

                /// 🔥 KPI ROW (Target + Remain)
                Row(
                  children: [

                    Text(
                      "Target: $total",
                      style: TextStyle(
                        fontSize: 11,
                        fontFamily: "PoppinsBold",

                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? Colors.grey.shade200
                            : Colors.grey.shade800,
                      ),
                    ),


                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ ICON LOGIC
  IconData _iconByTitle(String title) {
    final t = title.trim().toLowerCase();

    if (t.contains("book rent")) return Icons.real_estate_agent_outlined;
    if (t.contains("live rent")) return Icons.key_outlined;
    if (t.contains("live buy")) return Icons.sell_outlined;
    if (t.contains("commercial")) return Icons.business_center_outlined;
    if (t.contains("police")) return Icons.shield_outlined;
    if (t.contains("agreement")) return Icons.gavel_outlined;
    if (t.contains("building")) return Icons.location_city_outlined;

    return Icons.analytics_outlined;
  }

  /// ✅ COLOR LOGIC
  Color _colorByTitle(String title) {
    final t = title.trim().toLowerCase();

    switch (t) {
      case "agreement":
        return const Color(0xFFEF4444);

      case "buildings":
      case "building calculation":
        return const Color(0xFF22C55E);

      case "total flats":
        return const Color(0xFF6366F1);

      case "live flats":
        return const Color(0xFF06B6D4);

      case "unlive flats":
        return const Color(0xFFF59E0B);

      default:
        return const Color(0xFF22C55E); // ✅ NO MORE BLUE
    }
  }
}

class TargetsCard extends StatelessWidget {
  final String title;
  final int count;
  final VoidCallback? onTap;

  const TargetsCard(
      this.title,
      this.count, {
        super.key,
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color accent = _colorByTitle(title);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),

          /// 🔥 Adaptive Background
          color: isDark
              ?  Colors.black54
              : Colors.white,

          border: Border.all(
            color: isDark
                ? Colors.white10
                : Colors.grey.shade200,
          ),

          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withOpacity(0.35)
                  : Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),

            /// Subtle Accent Glow
            BoxShadow(
              color: accent.withOpacity(isDark ? 0.02 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),

        child: Stack(
          children: [

            /// 🔥 BIG FADED ICON
            Positioned(
              right: -6,
              bottom: -6,
              child: Icon(
                _iconByTitle(title),
                size: 64,
                color: accent.withOpacity(isDark ? 0.5 : 0.18),
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// TITLE
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 1.1,
                    fontFamily: "PoppinsBold",
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),

                const SizedBox(height: 10),

                /// 🔥 MAIN NUMBER
                Text(
                  count.toString().padLeft(2, '0'),
                  style: TextStyle(
                    fontSize: 26,
                    fontFamily: "PoppinsBold",
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black,
                  ),
                ),

                const SizedBox(height: 2),

                /// SUBTEXT
                Text(
                  "Total Records",
                  style: TextStyle(
                    fontSize: 10,
                    fontFamily: "PoppinsMedium",
                    color: isDark
                        ? Colors.white60
                        : Colors.black45,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ ICON LOGIC
  IconData _iconByTitle(String title) {
    final t = title.toLowerCase();

    if (t.contains("agreement")) return Icons.gavel_outlined;

    if (t.contains("building")) return Icons.location_city_outlined;

    if (t.contains("total flat")) return Icons.apartment_outlined;

    if (t.contains("live flat")) return Icons.check_circle_outline;

    if (t.contains("unlive flat")) return Icons.pending_actions_outlined;

    if (t.contains("flat")) return Icons.layers_outlined;

    if (t.contains("live")) return Icons.sensors;

    if (t.contains("police")) return Icons.shield_outlined;

    return Icons.analytics_outlined;
  }


  /// ✅ COLOR LOGIC
  Color _colorByTitle(String title) {
    final t = title.toLowerCase();

    if (t.contains("agreement")) return const Color(0xFFEF4444); // 🔴 Red

    if (t.contains("building")) return const Color(0xFF3B82F6); // 🔵 Blue

    if (t.contains("total flat")) return const Color(0xFF8B5CF6); // 🟣 Purple

    if (t.contains("live flat")) return const Color(0xFF10B981); // 🟢 Emerald

    if (t.contains("unlive flat")) return const Color(0xFFF59E0B); // 🟠 Amber

    if (t.contains("flat")) return const Color(0xFF6366F1); // 🟦 Indigo

    if (t.contains("live")) return const Color(0xFF06B6D4); // 💎 Cyan

    if (t.contains("police")) return const Color(0xFFF97316); // 🟧 Orange

    return const Color(0xFF135BEC); // Primary
  }

}

