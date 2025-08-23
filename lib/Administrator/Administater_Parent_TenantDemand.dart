import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../Police_Verification/Tenant_Details.dart';
import '../Tenant_Details_Demand/Show_TenantDemands.dart';
import '../constant.dart';
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
                  Tab(text: 'New Demands'),
                  Tab(text: 'Pending '),
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
