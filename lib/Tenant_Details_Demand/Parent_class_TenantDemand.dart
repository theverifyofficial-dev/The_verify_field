import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import 'ALl_Demands.dart';
import 'Assigned_Tenant_Demand.dart';
import '../Police_Verification/Tenant_Details.dart';
import '../constant.dart';
import 'Feild_Accpte_TenantDemand.dart';
import 'Perant_Class_Accpte_Demand.dart';
import 'Show_TenantDemands.dart';
import 'filter/TenantDemand_filter.dart';

class parent_TenandDemand extends StatefulWidget {
  const parent_TenandDemand({super.key});

  @override
  State<parent_TenandDemand> createState() => _parent_TenandDemandState();
}

class _parent_TenandDemandState extends State<parent_TenandDemand> {

  void _showBottomSheet(BuildContext context) {

    List<String> timing = [
      "Residential",
      "Plots",
      "Commercial",
    ];
    ValueNotifier<int> timingIndex = ValueNotifier(0);

    String displayedData = "Press a button to display data";

    void updateData(String newData) {
      setState(() {
        displayedData = newData;
      });
    }

    showModalBottomSheet(
      backgroundColor: Colors.black,
      context: context,
      builder: (BuildContext context) {
        return  DefaultTabController(
          length: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 5,right: 5,top: 0, bottom: 5),
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
                      Tab(text: 'Filter'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(children: [
                    TenantDemand_Filter(),
                  ]),
                )
              ],
            ),
          ),
        );
      },
    );
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
        // actions:  [
        //   GestureDetector(
        //     onTap: () {
        //       //Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Accept_Feedback_Parent_Page()));
        //       _showBottomSheet(context);
        //     },
        //     child: const Icon(
        //       PhosphorIcons.airplane_light,
        //       color: Colors.white,
        //       size: 30,
        //     ),
        //   ),
        //   const SizedBox(
        //     width: 20,
        //   ),
        // ],
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
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab, // Full width of tab
                tabs: const [
                  Tab(text: 'New Demands'),
                  Tab(text: 'Pending'),
                  Tab(text: 'Your Demands'),
                ],
              ),
            ),

            Expanded(
              child: TabBarView(children: [
                Assignd_Tenant_details(),
                Persnol_Assignd_Tenant_details(),
                Tenant_demands(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
