import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../Home_Screen_click/All_live_property.dart';
import '../administrator/Administator_Realestate.dart';
import '../ui_decoration_tools/app_images.dart';


class AdminRealEstateTabbar extends StatefulWidget {
  const AdminRealEstateTabbar({super.key,
  });

  @override
  State<AdminRealEstateTabbar> createState() => _Show_New_Real_EstateState();
}

class _Show_New_Real_EstateState extends State<AdminRealEstateTabbar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
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
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
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
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(text: 'ALL Property'),
                  Tab(text: 'FieldWorkers'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  AllLiveProperty(),
                  ADministaterShow_realestete(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
