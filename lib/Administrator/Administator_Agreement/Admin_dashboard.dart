import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Dashboard/Dashoard.dart';
import 'package:verify_feild_worker/Rent%20Agreement/details_agreement.dart';
import '../../constant.dart';
import 'Sub/Admin_accepted.dart';
import 'Sub/All_data.dart';
import 'Sub/Admin_pending.dart';
import 'Vew_Agreement_details.dart';

enum AppBarMenuOption {
  _launchURL,
  viewDetail, launchUrl,
}


class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _parent_TenandDemandState();
}

class _parent_TenandDemandState extends State<AdminDashboard> {


  _launchURL() async {
    final Uri url = Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/fetch_data.php');
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
            Navigator.pop(context);
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
      PopupMenuButton<AppBarMenuOption>(
      icon: const Icon(Icons.more_vert, color: Colors.white),

      onSelected: (value) {
        if (value == AppBarMenuOption._launchURL) {
          _launchURL(); // ✅ YOUR URL FUNCTION
        }

        if (value == AppBarMenuOption.viewDetail) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>  AgreementYearlyDetail(),
            ),
          );
        }
      },

      itemBuilder: (context) => const [
        PopupMenuItem(
          value: AppBarMenuOption._launchURL,
          child: Row(
            children: [
              Icon(Icons.open_in_browser, size: 18),
              SizedBox(width: 10),
              Text("Launch URL"),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppBarMenuOption.viewDetail,
          child: Row(
            children: [
              Icon(Icons.info_outline, size: 18),
              SizedBox(width: 10),
              Text("View Detail"),
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
                  color: Colors.green,
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
                  Tab(text: 'All Agreement'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(children: [
                AdminPending(),
                AdminAccepted(), // same Page for Admin & Field Worker.
                AllData(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
