import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Rent%20Agreement/history_agreement/All_agreement.dart';
import 'package:verify_feild_worker/Rent%20Agreement/history_agreement/request_agreement.dart';

import '../Custom_Widget/constant.dart';
import '../Custom_Widget/marquee_style.dart';
import 'Dashboard_screen.dart';
import 'history_agreement/Accept_agreement.dart';

class HistoryTab extends StatefulWidget {
  final int defaultTabIndex;
  const HistoryTab({super.key, this.defaultTabIndex = 0});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  RewardStatus? _rewardStatus;
  bool _loadingReward = true;
  static const int monthlyTarget = 20;
  static const bool debugForceDiscount = false; // 🔥 TEMP ONLY

  @override
  void initState() {
    super.initState();
    _loadReward();
    _tabController = TabController(length: 3, vsync: this, initialIndex: widget.defaultTabIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  _launchURL() async {
    final Uri url = Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/fetch_data.php');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  Future<RewardStatus> fetchRewardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString("number");

    if (number == null || number.isEmpty) {
      return RewardStatus(totalAgreements: 0, isDiscounted: false);
    }

    final res = await http.get(
      Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/count_api_for_all_agreement_with_reword.php"
            "?Fieldwarkarnumber=$number",
      ),
    );

    final data = jsonDecode(res.body);

    if (data["status"] == true) {
      final total = int.tryParse(data["total_agreement"].toString()) ?? 0;

      return RewardStatus(
        totalAgreements: total,
        isDiscounted: debugForceDiscount || total >= monthlyTarget,
      );
    }

    return RewardStatus(totalAgreements: 0, isDiscounted: false);
  }


  Future<void> _loadReward() async {
    final reward = await fetchRewardStatus();

    if (!mounted) return;

    setState(() {
      _rewardStatus = reward;
      _loadingReward = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        surfaceTintColor: Colors.black,
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 5,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context, true),
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 30),
            ],
          ),
        ),
        actions: [
          GestureDetector(
            onTap: _launchURL,
            child: const Icon(PhosphorIcons.share, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 20),
        ],
      ),

      body:  Column(
          children: [
            const SizedBox(height: 8),
            // --- 🔹 TabBar Container with Subtle Glow ---
            if (!_loadingReward && _rewardStatus != null)
              _RewardBanner(reward: _rewardStatus!),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade600, Colors.green.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Accepted'),
                  Tab(text: 'Agreement'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  RequestAgreementsPage(),
                  AcceptAgreement(),
                  AllAgreement(),
                ],
              ),

            ),
          ],
        ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.greenAccent.shade400, Colors.green.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.greenAccent.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgreementDashboard()),
                );
              },
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              label: const Text(
                "Add Agreements",
                style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RewardBanner extends StatelessWidget {
  final RewardStatus reward;
  static const int target = 20;

  const _RewardBanner({required this.reward});

  @override
  Widget build(BuildContext context) {

    final unlocked = reward.isDiscounted;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: unlocked
              ? [Colors.green.shade700, Colors.greenAccent.shade400]
              : [Colors.grey.shade800, Colors.grey.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MovingText(
            text: unlocked
                ? "🎉 Congrats!! Target Achieved! Discount Active."
                : "${reward.totalAgreements} of $target monthly agreements completed!",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
