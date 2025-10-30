import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Rent%20Agreement/Dashboard_screen.dart';
import 'package:verify_feild_worker/Rent%20Agreement/history_agreement/All_agreement.dart';
import 'package:verify_feild_worker/Rent%20Agreement/history_agreement/request_agreement.dart';

import '../constant.dart';
import 'history_agreement/Accept_agreement.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _parent_TenandDemandState();
}

class _parent_TenandDemandState extends State<HistoryTab> {
  _launchURL() async {
    final Uri url = Uri.parse('https://theverify.in/example.html');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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

      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const SizedBox(height: 8),
            // --- 🔹 TabBar Container with Subtle Glow ---
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade600, Colors.blue.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.4),
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
                children: [
                  RequestAgreementsPage(),
                  AcceptAgreement(),
                  AllAgreement(),
                ],
              ),
            ),
          ],
        ),
      ),

      // --- 🔹 Bottom Add Button with Neon Edge ---
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent.shade400, Colors.blue.shade700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
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
