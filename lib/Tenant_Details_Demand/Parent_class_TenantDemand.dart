import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../Home_Screen_click/Commercial_property_Filter.dart';
import '../Home_Screen_click/Filter_Options.dart';
import 'ALl_Demands.dart';
import 'Assigned_Tenant_Demand.dart';
import '../Police_Verification/Tenant_Details.dart';
import '../Custom_Widget/constant.dart';
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
                PhosphorIconsRegular.caretLeft,
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

            const Expanded(
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
