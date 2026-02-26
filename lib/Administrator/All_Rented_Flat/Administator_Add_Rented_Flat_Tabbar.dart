import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../Custom_Widget/build_count.dart';
import '../../Custom_Widget/constant.dart';
import '../SubAdmin/SubAdminAccountant_Home.dart';
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
  int bookingCount = 0;
  int pendingCount = 0;
  int completeCount = 0;


  @override
  void initState() {
    super.initState();

    fetchPaymentCounts();

    _tabController = TabController(length: 3, vsync: this);
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

  Future<void> fetchPaymentCounts() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://verifyserve.social/Second%20PHP%20FILE/Payment/all_payment_count_for_admin.php',
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true) {
          final data = decoded["data"];

          setState(() {
            bookingCount = data[0][0]["BookingCount"] ?? 0;
            pendingCount = data[1][0]["pendingCount"] ?? 0;
            completeCount = data[2][0]["finalCount"] ?? 0;
          });
        }
      }

    } catch (e) {
      print("Count error: $e");
    }
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
            if (widget.fromNotification) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                SubAdminHomeScreen.route,
                    (route) => false,
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          child: const Icon(
            PhosphorIcons.caret_left_bold,
            color: Colors.white,
            size: 30,
          ),
        ),

        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white70,
                labelStyle: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
                tabs: [
                  buildTab("Booking", bookingCount),
                  buildTab("Pending", pendingCount),
                  buildTab("Complete", completeCount),
                ],
              ),
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



