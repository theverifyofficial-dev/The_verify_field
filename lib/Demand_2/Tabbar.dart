import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:verify_feild_worker/Demand_2/Costumer_demand.dart';
import '../ui_decoration_tools/app_images.dart';
import 'Accepted_field.dart';
import 'Disclosed_demand.dart';

class Tabbar extends StatefulWidget {
  const Tabbar({super.key});

  @override
  State<Tabbar> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<Tabbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA), // 🔥 LIGHT BG

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black, // ✅ KEEP BLACK
        title: Image.asset(AppImages.verify, height: 70),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            PhosphorIcons.caret_left_bold,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),

      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [

            const SizedBox(height: 12),

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

            /// 🔥 TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  CostumerDemand(),
                  AcceptedField(),
                  DisclosedDemand(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}