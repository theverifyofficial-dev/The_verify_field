import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
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
  State<AdministatorAddRentedFlatTabbar> createState() =>
      _AdministatorAddRentedFlatTabbarState();
}

class _AdministatorAddRentedFlatTabbarState
    extends State<AdministatorAddRentedFlatTabbar>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late final TabController _tabController;

  final List<String> _tabs = const ["Booking", "Pending", "Complete"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(

      length: _tabs.length,
      vsync: this,
      initialIndex: widget.tabIndex.clamp(0, _tabs.length - 1),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleBack() {
    if (widget.fromNotification) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        "/Home_Screen",
            (route) => false,
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: IconButton(
          icon: const Icon(
            PhosphorIcons.caret_left_bold,
            color: Colors.white,
            size: 30,
          ),
          onPressed: _handleBack,
        ),
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
              physics: const ClampingScrollPhysics(),
              controller: _tabController,
              indicator: const BoxDecoration(color: Colors.white),
              dividerColor: Colors.transparent,

              // ✅ COLORS
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,

              // ✅ TEXT STYLES
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                fontFamily: "Poppins", // optional
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                fontFamily: "Poppins", // optional
              ),

              tabs: _tabs.map((e) => Tab(text: e)).toList(),
            ),
          ),
        ),
      ),

      body: AnimatedBuilder(
        animation: _tabController,
        builder: (context, _) {
          return IndexedStack(
            index: _tabController.index,
            children: const [
              AdministatiorFieldWorkerBookingPage(),
              AdministatiorFieldWorkerPendingFlats(),
              AdministatiorFieldWorkerCompleteFlats(),
            ],
          );
        },
      ),
    );
  }
}
