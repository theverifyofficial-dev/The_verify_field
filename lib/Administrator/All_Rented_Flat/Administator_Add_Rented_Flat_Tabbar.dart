import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import '../../Custom_Widget/constant.dart';
import 'AdministatorFieldWorkerBookingPage.dart';
import 'Administator_Complete_Payment.dart';
import 'Administator_Pending_Flat.dart';

class AdministatorAddRentedFlatTabbar extends StatefulWidget {
  const AdministatorAddRentedFlatTabbar({super.key});

  @override
  State<AdministatorAddRentedFlatTabbar> createState() =>
      _AdministatorAddRentedFlatTabbarState();
}

class _AdministatorAddRentedFlatTabbarState
    extends State<AdministatorAddRentedFlatTabbar>
    with SingleTickerProviderStateMixin {

  late final TabController _tabController;

  final List<String> _tabs = const ["Booking", "Pending", "Complete"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(
      length: _tabs.length,
      vsync: this, // ✅ REQUIRED
    );
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
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              physics: const ClampingScrollPhysics(),
              indicator: const BoxDecoration(color: Colors.white),
              dividerColor: Colors.transparent,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins",
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins",
              ),
              tabs: _tabs.map((e) => Tab(text: e)).toList(),
            ),
          ),
        ),
      ),

      /// ✅ NORMAL TAB SCROLLING
      body: TabBarView(
        controller: _tabController,
        physics: const ClampingScrollPhysics(),
        children: const [
          AdministatiorFieldWorkerBookingPage(),
          AdministatiorFieldWorkerPendingFlats(),
          AdministatiorFieldWorkerCompleteFlats(),
        ],
      ),
    );
  }
}
