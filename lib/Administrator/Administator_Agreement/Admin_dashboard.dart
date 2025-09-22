import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../constant.dart';
import 'Sub/Admin_accepted.dart';
import 'Sub/All_data.dart';
import 'Sub/Admin_pending.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _parent_TenandDemandState();
}

class _parent_TenandDemandState extends State<AdminDashboard> {


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
