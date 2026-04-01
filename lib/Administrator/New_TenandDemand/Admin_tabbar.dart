import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../Custom_Widget/constant.dart';
import 'Accepted_demand.dart';
import 'Admin_disclose.dart';
import 'Tenant_demand.dart';


class AdminTabbar extends StatefulWidget {
  const AdminTabbar({super.key});

  @override
  State<AdminTabbar> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<AdminTabbar> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0, // Make sure there's no shadow
        surfaceTintColor: Colors.black,
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
        length: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔥 MODERN TAB BAR
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),

              child: TabBar(
                dividerColor: Colors.transparent, // 🔥 REMOVE BLACK LINE
                indicator: BoxDecoration(
                  color: const Color(0xFFDC2626), // 🔴 RED
                  borderRadius: BorderRadius.circular(10),
                ),

                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
                indicatorSize: TabBarIndicatorSize.tab, // Full width of tab


                tabs: const [
                  Tab(text: 'New'),
                  Tab(text: 'Accepted'),
                  Tab(text: 'Closed'),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TabBarView(children: [
                TenantDemand(),
                AcceptedDemand(),
                AdminDisclosedDemand(),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
