import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';

import '../../Add_Rented_Flat/FieldWorker_Booking_Page.dart';
import '../../Custom_Widget/constant.dart';
import 'AdministatorFieldWorkerBookingPage.dart';
import 'Administator_Complete_Payment.dart';
import 'Administator_Pending_Flat.dart';

class AdministatorAddRentedFlatTabbar extends StatefulWidget {
  static const administaterAddRentedFlatTabbar = "/AdministatorAddRentedFlatTabbar";

  final bool fromNotification;
  final String? flatId;
  final int tabIndex;

  const AdministatorAddRentedFlatTabbar({
    super.key,
    this.fromNotification = false,
    this.flatId,
    this.tabIndex = 0,
  });

  @override
  State<AdministatorAddRentedFlatTabbar> createState() => _AdministatorAddRentedFlatTabbarState();
}

class _AdministatorAddRentedFlatTabbarState extends State<AdministatorAddRentedFlatTabbar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

  final List<String> _tabs = ["Booking", "Pending", "Complete"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: _tabs.length, vsync: this);

    // 🔥 Set tab automatically if opened from notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _tabController.animateTo(widget.tabIndex);
    });

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
        elevation: 0,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
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

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(color: Colors.white),
              dividerColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold,
              ),
              tabs: _tabs
                  .map((tab) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Tab(text: tab),
              ))
                  .toList(),
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
            AdministatiorFieldWorkerCompleteFlats(),
          ],
        ),
      ),
    );
  }
}




