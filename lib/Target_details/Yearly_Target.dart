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
    "Agreement": 300,
    "Police Verification": 300,
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

  Future<void> _fetchAgreementYearly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/count_api_agreement_yealry_with_reward.php?Fieldwarkarnumber=$fieldWorkerNumber",
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

  Future<void> _fetchPoliceYearly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_yearly.php?Fieldwarkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200)
      throw Exception("Police Yearly API Error");

    final decoded = jsonDecode(res.body);

    policeVerificationDone =
        int.tryParse(decoded["total_police_verification"].toString()) ?? 0;

    final List list = decoded["data"] ?? [];

    print("POLICE COUNT: $policeVerificationDone");
    print("LIST LEN: ${list.length}");

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


  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final bgColor =
    isDark ? Colors.black : Colors.grey.shade50;

    return Scaffold(
      backgroundColor: bgColor,

      appBar: AppBar(
        backgroundColor:
        isDark ? Colors.black : Colors.grey.shade50,
        surfaceTintColor:
        isDark ? Colors.black : Colors.grey.shade50,

        title: Text(
          "Yearly Targets",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
      ),

      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _buildModernTargetCard(
            title: 'Book Rent',
            completed: bookRentDone,
            target: yearlyTargets['Book Rent']!,
            icon: Icons.book_rounded,
            primaryColor: const Color(0xFF3B82F6),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => YearlyBookrentScreen()),
            ),
          ),

          _buildModernTargetCard(
            title: 'Book Buy',
            completed: bookBuyDone,
            target: yearlyTargets['Book Buy']!,
            icon: Icons.shopping_bag_rounded,
            primaryColor: const Color(0xFF36E27B),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => YearlyBookBuyScreen()),
            ),
          ),

          _buildModernTargetCard(
            title: 'Agreement',
            completed: agreementExternalDone,
            target: yearlyTargets['Agreement']!,
            icon: Icons.description_rounded,
            primaryColor: const Color(0xFFA855F7),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => AgreementYearlyScreen()),
            ),
          ),

          _buildModernTargetCard(
            title: 'Police Verification',
            completed: policeVerificationDone,
            target: yearlyTargets['Police Verification']!,
            icon: Icons.verified_user_rounded,
            primaryColor: const Color(0xFFEF4444),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      YearlyPoliceVerificationScreen()),
            ),
          ),

          _buildModernTargetCard(
            title: 'Building',
            completed: buildingDone,
            target: yearlyTargets['Building']!,
            icon: Icons.apartment_rounded,
            primaryColor: const Color(0xFFF59E0B),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => YearlyBuildingScreen()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernTargetCard({
    required String title,
    required int completed,
    required int target,
    required VoidCallback onTap,
    required IconData icon,
    required Color primaryColor,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final double progress =
    target == 0 ? 0 : (completed / target).clamp(0.0, 1.0);

    final int percent = (progress * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark
              ? const Color(0xFF161B18)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.05)
                : Colors.grey.shade300,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔝 TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon,
                          color: primaryColor, size: 26),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color:
                            isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              "$completed",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              " / $target",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white.withOpacity(0.35)
                                    : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                /// 🔵 PROGRESS RING
                SizedBox(
                  height: 80,
                  width: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [

                      SizedBox(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 6,
                          valueColor: AlwaysStoppedAnimation(
                            isDark
                                ? Colors.white.withOpacity(0.08)
                                : Colors.grey.shade300,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          strokeCap: StrokeCap.round,
                          valueColor:
                          AlwaysStoppedAnimation(primaryColor),
                        ),
                      ),

                      Text(
                        "$percent%",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white.withOpacity(0.6)
                              : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Progress",
                  style: TextStyle(
                    fontSize: 11,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color:
                    Theme.of(context).brightness==Brightness.dark?Colors.white.withOpacity(0.5):Colors.grey.shade800,

                  ),
                ),
                Text(
                  "$percent%",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness==Brightness.dark?Colors.white.withOpacity(0.5):Colors.grey.shade800,

                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// 🔻 LINE INDICATOR
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: progress,
                backgroundColor: isDark
                    ? Colors.white.withOpacity(0.08)
                    : Colors.grey.shade300,
                valueColor:
                AlwaysStoppedAnimation(primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

}

