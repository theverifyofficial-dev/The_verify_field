import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../Police_Verification/Tenant_Details.dart';
import '../Tenant_Details_Demand/Show_TenantDemands.dart';
import '../Custom_Widget/constant.dart';
import 'Add_Assign_Tenant_Demand/Show_Unexpected_Demand.dart';
import 'Administater_TenanDemand.dart';
import 'Administrator_main_tenantdemand.dart';

class Administater_parent_TenandDemand extends StatefulWidget {
  const Administater_parent_TenandDemand({super.key});

  @override
  State<Administater_parent_TenandDemand> createState() => _Administater_parent_TenandDemandState();
}

class _Administater_parent_TenandDemandState extends State<Administater_parent_TenandDemand> {
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
             // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Administater_Assignd_Tenant_details()));
            },
            child: const Icon(
              PhosphorIcons.bounding_box,
              color: Colors.black,
              size: 30,
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
                Administater_Assignd_Tenant_details(),
                AdmiinistaterAssignd_Tenant_details(),
                Administrator_Tenant_demands(),
              ]),
            )
          ],
        ),
      ),

    );
  }
}
