import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../constant.dart';
import 'Feedback_Tenanant_Demand.dart';
import 'Feild_Accpte_TenantDemand.dart';

class Accept_Feedback_Parent_Page extends StatefulWidget {
  const Accept_Feedback_Parent_Page({super.key});

  @override
  State<Accept_Feedback_Parent_Page> createState() => _Accept_Feedback_Parent_PageState();
}

class _Accept_Feedback_Parent_PageState extends State<Accept_Feedback_Parent_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,


      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5,),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              padding: EdgeInsets.all(3),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.grey),
              child: TabBar(
                indicator: BoxDecoration(
                  color: Colors.red[500],
                  borderRadius: BorderRadius.circular(10),
                ),
                // ignore: prefer_const_literals_to_create_immutables
                tabs: [
                  Tab(text: 'Accept Demand'),
                  Tab(text: 'Your FeedBacks'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                Persnol_Assignd_Tenant_details(),
                Feedback_demand()
              ]),
            )
          ],
        ),
      ),
    );
  }
}
