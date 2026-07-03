import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Custom_Widget/build_count.dart';
import '../../Custom_Widget/constant.dart';
import '../../Rent Agreement/Renewal_Agreement.dart';
import '../Administrator_HomeScreen.dart';
import 'Admin_Expire_agreement.dart';
import 'Admin_Renewal_Agreement.dart';
import 'Sub/Admin_accepted.dart';
import 'Sub/All_data.dart';
import 'Sub/Admin_pending.dart';
import 'customer_data.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// enum AppBarMenuOption {
//   _launchURL,
//   viewDetail, launchUrl,
// }

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _parent_TenandDemandState();
}

class _parent_TenandDemandState extends State<AdminDashboard> {

  @override
  void initState() {
    super.initState();
    fetchAgreementCount();
  }

  Future<void> fetchAgreementCount() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/all_agreement_count.php',
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true) {
          final data = decoded["data"];

          setState(() {
            pendingCount = data[0][0]["PreviewCount"] ?? 0;
            acceptedCount = data[1][0]["AcceptCount"] ?? 0;
            allCount = data[2][0]["AgreementCount"] ?? 0;
            isLoadingCount = false;
          });
        }
      }
    } catch (e) {
      isLoadingCount = false;
    }
  }

  int allCount = 0;
  int acceptedCount = 0;
  int pendingCount = 0;
  bool isLoadingCount = true;

  _launchURL() async {
    final Uri url = Uri.parse('https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/fetch_data.php');
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
        title: Image.asset(AppImages.verify, height: 70),
        leading: InkWell(
            onTap: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => AdministratorHome_Screen()),
                );
              }
            },
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
        actions:  [
          // PopupMenuButton<AppBarMenuOption>(
          //   icon: const Icon(Icons.more_vert, color: Colors.white),
          //
          //   onSelected: (value) {
          //     if (value == AppBarMenuOption._launchURL) {
          //       _launchURL(); // ✅ YOUR URL FUNCTION
          //     }
          //
          //     if (value == AppBarMenuOption.viewDetail) {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(
          //           builder: (_) =>  const AgreementCustomer(),
          //         ),
          //       );
          //     }
          //   },
          //
          //   itemBuilder: (context) => const [
          //     PopupMenuItem(
          //       value: AppBarMenuOption._launchURL,
          //       child: Row(
          //         children: [
          //           Icon(Icons.open_in_browser, size: 18),
          //           SizedBox(width: 10),
          //           Text("Launch URL"),
          //         ],
          //       ),
          //     ),
          //     PopupMenuItem(
          //       value: AppBarMenuOption.viewDetail,
          //       child: Row(
          //         children: [
          //           Icon(Icons.info_outline, size: 18),
          //           SizedBox(width: 10),
          //           Text("View Detail"),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),
          PopupMenuButton<String>(
            icon: const Icon(
                Icons.more_vert,
                color: Colors.white, size: 28),
            color: const Color(0xFF1E1E2E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            offset: const Offset(0, 50),
            onSelected: (value) {
              switch (value) {
                // case 'renewal':
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => const AdminDocumentsScreen(fieldWorkerNumber: "")),
                //   );
                //   break;
                case 'launch':
                  _launchURL();
                  break;
                // case 'expire':
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => const AdminExpireAgreementScreen(fieldWorkerNumber: '')),
                //   );
                //   break;
                case 'View':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AgreementCustomer()),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              // ── Tab 1: Renewal Agreement ──────────────────────────────
              const PopupMenuItem<String>(
                value: 'renewal',
                child: Row(
                  children: const [
                    Icon(PhosphorIcons.arrow_right, color: Color(0xFF4ADE80), size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Renewal Agreement',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ───────────────────────────────────────────────
              const PopupMenuDivider(height: 1),
              // ── Tab 3: Expire Agreement ───────────────────────────────
              const PopupMenuItem<String>(
                value: 'expire',
                child: Row(
                  children: const [
                    Icon(PhosphorIcons.prohibit, color: Color(0xFFF87171), size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Expire Agreement',
                      style: TextStyle(
                        color: Color(0xFFF87171),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const PopupMenuDivider(height: 1),

              // ── Tab 2: Launch URL ─────────────────────────────────────
              const PopupMenuItem<String>(
                value: 'launch',
                child: Row(
                  children: const [
                    Icon(PhosphorIcons.share, color: Color(0xFF60A5FA), size: 20),
                    SizedBox(width: 12),
                    Text(
                      'Launch URL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Divider ───────────────────────────────────────────────
              const PopupMenuDivider(height: 1),

              // ── Tab 3: Expire Agreement ───────────────────────────────
              const PopupMenuItem<String>(
                value: 'View',
                child: Row(
                  children: const [
                    Icon(PhosphorIcons.file_doc, color: Color(0xFFAC06F4), size: 20),
                    SizedBox(width: 12),
                    Text(
                      'View Details',
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab, // Full width of tab
                tabs: [
                  buildTab('Final', allCount),
                  buildTab('Accepted', acceptedCount),
                  buildTab('Pending', pendingCount),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(children: [
                AllData(),
                AdminAccepted(),
                AdminPending(),
              ]
              ),
            )
          ],
        ),
      ),
    );
  }

}
