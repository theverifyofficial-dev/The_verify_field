import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../constant.dart';
import 'FieldWorkerPendingFlats.dart';
import 'FieldWorker_Booking_Page.dart';

class AddRentedFlatTabbar extends StatefulWidget {
  const AddRentedFlatTabbar({super.key});

  @override
  State<AddRentedFlatTabbar> createState() => _AddRentedFlatTabbarState();
}

class _AddRentedFlatTabbarState extends State<AddRentedFlatTabbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ["Booking", "Pending", "Complete"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- Complete Tab placeholder ---
  Widget _buildCompleteTab() {
    return Center(
      child: Text(
        "All completed flats and successful deals are here.",
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            PhosphorIcons.caret_left_bold,
            color: Colors.white,
            size: 30,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              labelStyle:
              const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              tabs: _tabs
                  .map((tab) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Tab(text: tab),
              ))
                  .toList(),
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          FieldWorkerBookingPage(),
          FieldWorkerPendingFlats(),
          _buildCompleteTab(),
        ],
      ),
    );
  }
}
