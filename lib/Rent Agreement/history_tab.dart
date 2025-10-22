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
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context, true);

          },
          child: const Row(
            children: [
              SizedBox(
                width: 3,
              ),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          GestureDetector(
            onTap: () {
              _launchURL();
            },
            child: Row(
              children: [
                const Icon(
                  PhosphorIcons.share,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab, // Full width of tab
                tabs: const [
                  Tab(text: 'Pending'),
                  Tab(text: 'Accepted'),
                  Tab(text: 'Agreement'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(children: [
                RequestAgreementsPage(),
                AcceptAgreement(),
                AllAgreement(),
              ]),
            )
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // 👉 Navigate to Add Agreements page
              Navigator.push(context, MaterialPageRoute(builder: (context) => AgreementDashboard()));
            },
            icon: const Icon(Icons.add_circle, color: Colors.white),
            label: const Text(
              "Add Agreements",
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

}
