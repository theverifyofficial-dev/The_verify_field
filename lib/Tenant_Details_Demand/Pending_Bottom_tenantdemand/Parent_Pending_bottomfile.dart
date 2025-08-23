import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../constant.dart';
import 'Demand_FullFilled.dart';
import 'Pending_monthend.dart';

class parent_bottom_Pending extends StatefulWidget {
  const parent_bottom_Pending({super.key});

  @override
  State<parent_bottom_Pending> createState() => _parent_bottom_PendingState();
}

class _parent_bottom_PendingState extends State<parent_bottom_Pending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  Tab(text: 'Pending a Month'),
                  Tab(text: 'Demand Fullfilled'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(children: [
                Pending_monthend(),
                Fullfilled_demand()
              ]),
            )
          ],
        ),
      ),
    );
  }
}
