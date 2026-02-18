import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

// Import your screens
import '../Adminisstrator_Target_details/Monthly_Tab/Monthly_police_verification.dart';
import 'Monthly_Tab/Book_Rent.dart';
import 'Monthly_Tab/Live_Commercial.dart';
import 'Monthly_Tab/Monthly_LiveBuy.dart';
import 'Monthly_Tab/Monthly_LiveRent.dart';
import 'Monthly_Tab/Monthly_agreement_external.dart';
import 'history_target.dart';

class MonthlyTargetScreen extends StatefulWidget {
  const MonthlyTargetScreen({super.key});

  @override
  State<MonthlyTargetScreen> createState() => _MonthlyTargetScreenState();
}

class _MonthlyTargetScreenState extends State<MonthlyTargetScreen> {
  bool loading = true;
  String? fieldWorkerNumber;
  ThemeMode _themeMode = ThemeMode.system;
  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

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
    "Agreement": 20,
    "Police Verification": 20,
    "Live Rent": 15,
    "Live Buy": 5,
  };

  @override
  void initState() {
    super.initState();
    _load();
    _getThemeMode();
  }

  Future<void> _getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final theme = prefs.getString('theme_mode');
    if (theme == 'dark') {
      _themeMode = ThemeMode.dark;
    } else if (theme == 'light') {
      _themeMode = ThemeMode.light;
    } else {
      _themeMode = ThemeMode.system;
    }
    setState(() {});
  }

  // Keep your existing API methods (unchanged)
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
    if (res.statusCode != 200) throw Exception("Book Monthly API Error");

    final list = jsonDecode(res.body)["data"] as List? ?? [];
    if (list.isNotEmpty) {
      bookRentDone = int.tryParse(list[0]["rent_count"].toString()) ?? 0;
      bookBuyDone = int.tryParse(list[0]["buy_count"].toString()) ?? 0;

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
    if (res.statusCode != 200) throw Exception("Live Monthly API Error");

    final decoded = jsonDecode(res.body);

    if (decoded["counts"] != null) {
      liveRentDone = int.tryParse(decoded["counts"]["rent_count"].toString()) ?? 0;
      liveBuyDone = int.tryParse(decoded["counts"]["buy_count"].toString()) ?? 0;
    } else {
      liveRentDone = int.tryParse(decoded["rent_count"]?.toString() ?? '0') ?? 0;
      liveBuyDone = int.tryParse(decoded["buy_count"]?.toString() ?? '0') ?? 0;
    }

    setState(() {});
  }

  Future<void> _fetchAgreementMonthly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/count_api_for_all_agreement_with_reword_monthly.php?Fieldwarkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception("Agreement Monthly API Error");

    final decoded = jsonDecode(res.body);

    if (decoded["counts"] != null) {
      agreementExternalDone = int.tryParse(decoded["counts"]["total_agreement"].toString()) ?? 0;
    } else {
      agreementExternalDone = int.tryParse(decoded["total_agreement"].toString()) ?? 0;
    }

    setState(() {});
  }

  Future<void> _fetchPoliceMonthly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/police_verification_monthly.php?Fieldwarkarnumber=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception("Police Monthly API Error");

    final decoded = jsonDecode(res.body);

    if (decoded["counts"] != null) {
      policeVerificationDone = int.tryParse(decoded["counts"]["total_police_verification"].toString()) ?? 0;
    } else {
      policeVerificationDone = int.tryParse(decoded["total_police_verification"].toString()) ?? 0;
    }

    setState(() {});
  }

  Future<void> _fetchCommercialMonthly() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/commercial_month.php?field_workar_number=$fieldWorkerNumber",
    );

    final res = await http.get(uri);
    if (res.statusCode != 200) throw Exception("Commercial Monthly API Error");

    final decoded = jsonDecode(res.body);

    commercialDone = int.tryParse(decoded["counts"]["total_commercial"].toString()) ?? 0;
    setState(() {});
  }

  String _getPeriodText() {
    if (periodStart == null || periodEnd == null) {
      return DateFormat('MMMM yyyy').format(DateTime.now());
    }
    return '${DateFormat('dd MMM').format(periodStart!)} - ${DateFormat('dd MMM yyyy').format(periodEnd!)}';
  }

  Widget _buildModernTargetCard({
    required String title,
    required int completed,
    required int target,
    required VoidCallback onTap,
    required IconData icon,
    required Color primaryColor,
    required Color secondaryColor,
  }) {
    final double progress =
    target == 0 ? 0 : (completed / target).clamp(0.0, 1.0);
    final int percent = (progress * 100).round();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).brightness==Brightness.dark?Color(0xFF161B18):Colors.grey.shade200, // 🔥 HTML card-dark
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔝 TOP ROW
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// LEFT SIDE
                Row(
                  children: [
                    Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: primaryColor, size: 26),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style:  TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey.shade800,
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
                                fontFamily: "PoppinsBold",

                                color: Theme.of(context).brightness==Brightness.dark?Colors.white.withOpacity(0.3):Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                /// 🔵 BIG CIRCULAR INDICATOR (HTML SIZE)
                SizedBox(
                  height: 80, // 🔥 bigger like your HTML (size-14 / size-16)
                  width: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      /// background ring
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          value: 1,
                          strokeWidth: 6, // 🔥 thicker
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(
                         Theme.of(context).brightness==Brightness.dark?Colors.white.withOpacity(0.08):Colors.grey.shade300,


                          ),
                        ),
                      ),

                      /// progress ring
                      SizedBox(
                        height: 55,
                        width: 55,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 6,
                          strokeCap: StrokeCap.round,
                          backgroundColor: Colors.transparent,
                          valueColor: AlwaysStoppedAnimation(primaryColor),
                        ),
                      ),

                      /// percentage text
                      Text(
                        "$percent%",
                        style:  TextStyle(
                          fontSize: 14, // 🔥 bigger text
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness==Brightness.dark?Colors.white.withOpacity(0.5):Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// 🔻 BOTTOM LINE INDICATOR (HTML STYLE)
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
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: progress,
                backgroundColor:
                Theme.of(context).brightness==Brightness.dark?Colors.white.withOpacity(0.08):Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation(primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSummary() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF121212) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDarkMode ? Colors.white12 : Colors.black12,
        ),
      ),
      child: Row(
        children: [
          /// LEFT : PERIOD INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Period',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode
                        ? Colors.grey.shade500
                        : Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _getPeriodText(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT : HISTORY BUTTON
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TargetHistoryScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode ? Colors.white12 : Colors.black12,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.history,
                    size: 16,
                    color: isDarkMode
                        ? Colors.grey.shade300
                        : Colors.grey.shade700,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDarkMode
                          ? Colors.grey.shade300
                          : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(

        backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade50,
        surfaceTintColor: isDarkMode ? Colors.black : Colors.grey.shade50,

        title: Text(
          'Monthly Targets',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.grey.shade50,
      body: loading
          ? _buildLoadingScreen()
          : Column(
        children: [
          _buildTopSummary(),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildModernTargetCard(
                  title: 'Book Rent',
                  completed: bookRentDone,
                  target: monthlyTargets['Book Rent']!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MonthlyBookRentScreen()),
                  ),
                  icon: Icons.book_rounded,
                  primaryColor: const Color(0xFF3B82F6), // 🔵 accent-blue
                  secondaryColor: const Color(0xFF3B82F6),
                ),

                _buildModernTargetCard(
                  title: 'Live Commercial',
                  completed: commercialDone,
                  target: monthlyTargets['Live Commercial']!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MonthlyCommercialScreen()),
                  ),
                  icon: Icons.store_mall_directory_rounded,
                  primaryColor: const Color(0xFFF59E0B), // 🟠 accent-orange
                  secondaryColor: const Color(0xFFF59E0B),
                ),

                _buildModernTargetCard(
                  title: 'Agreement',
                  completed: agreementExternalDone,
                  target: monthlyTargets['Agreement']!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MonthlyAgreementExternalScreen()),
                  ),
                  icon: Icons.description_rounded,
                  primaryColor: const Color(0xFF36E27B), // 🟢 primary
                  secondaryColor: const Color(0xFF36E27B),
                ),

                _buildModernTargetCard(
                  title: 'Police Verification',
                  completed: policeVerificationDone,
                  target: monthlyTargets['Police Verification']!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MonthlyPoliceVerificationScreen()),
                  ),
                  icon: Icons.verified_user_rounded,
                  primaryColor: const Color(0xFFEF4444), // 🔴 accent-red
                  secondaryColor: const Color(0xFFEF4444),
                ),

                _buildModernTargetCard(
                  title: 'Live Rent',
                  completed: liveRentDone,
                  target: monthlyTargets['Live Rent']!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MonthlyLiveRentScreen()),
                  ),
                  icon: Icons.home_work_rounded,
                  primaryColor: const Color(0xFFA855F7), // 🟣 accent-purple
                  secondaryColor: const Color(0xFFA855F7),
                ),

                _buildModernTargetCard(
                  title: 'Live Buy',
                  completed: liveBuyDone,
                  target: monthlyTargets['Live Buy']!,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => MonthlyLiveBuyScreen()),
                  ),
                  icon: Icons.shopping_bag_rounded,
                  primaryColor: const Color(0xFF36E27B), // 🟢 primary again
                  secondaryColor: const Color(0xFF36E27B),
                ),
              ],
            ),
          ),



      ],
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: isDarkMode ? Colors.white : Colors.blue,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Loading Targets...',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }
}