import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../Add_Rented_Flat/FieldWorker_Booking_Page.dart';
import '../../constant.dart';
import 'AdministatorFieldWorkerBookingPage.dart';
import 'Administator_Complete_Payment.dart';
import 'Administator_Pending_Flat.dart';

class AdministatorAddRentedFlatTabbar extends StatefulWidget {
  const AdministatorAddRentedFlatTabbar({super.key});

  @override
  State<AdministatorAddRentedFlatTabbar> createState() => _AdministatorAddRentedFlatTabbarState();
}

class _AdministatorAddRentedFlatTabbarState extends State<AdministatorAddRentedFlatTabbar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<String> _tabs = ["Booking", "Pending", "Complete"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        ),        // centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.only(left: 16,right: 16,top: 8 ),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.only(topLeft:Radius.circular(25),topRight:Radius.circular(25)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              dividerColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                  fontSize: 14, fontWeight: FontWeight.bold),
              tabs: _tabs.map((tab) => Padding(
                padding: const EdgeInsets.only(left: 8.0,right: 8),
                child: Tab(text: tab),
              )).toList(),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: TabBarView(
          key: ValueKey<int>(_selectedIndex),
          controller: _tabController,
          children: [
            AdministatiorFieldWorkerBookingPage(),
            AdministatiorFieldWorkerPendingFlats(),
            AdministatiorFieldWorkerCompleteFlats()
          ],
        ),
      ),
    );
  }
}
