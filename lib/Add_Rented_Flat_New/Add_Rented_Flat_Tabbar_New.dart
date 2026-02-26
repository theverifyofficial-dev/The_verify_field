import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Custom_Widget/build_count.dart';
import '../Custom_Widget/constant.dart';
import 'NewDesginFieldWorkerPendingFlatsNew.dart';
import 'NewDesgin_FieldWorker_Booking_Page_New.dart';
import 'NewDesgin_FieldWorker_Complete_Page_New.dart';

class AddRentedFlatTabbarNew extends StatefulWidget {
  final int tabIndex;
  final String? propertyId;

  const AddRentedFlatTabbarNew({super.key, this.tabIndex = 0, this.propertyId,});

  @override
  State<AddRentedFlatTabbarNew> createState() => _AddRentedFlatTabbarNewState();
}

class _AddRentedFlatTabbarNewState extends State<AddRentedFlatTabbarNew>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int bookingCount = 0;
  int pendingCount = 0;
  int completeCount = 0;
  String? mobileNumber;

  final List<String> _tabs = ["Booking", "Pending", "Complete"];

  @override
  void initState() {
    super.initState();
    fetchPaymentCounts();
    _loadMobileNumber();
    _tabController = TabController(
      length: _tabs.length,
      vsync: this,
      initialIndex: widget.tabIndex,
    );
  }

  @override
  void didUpdateWidget(covariant AddRentedFlatTabbarNew oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.tabIndex != widget.tabIndex) {
      _tabController.animateTo(widget.tabIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString("number");
    if (mobileNumber != null) {
      fetchPaymentCounts();
    }
  }

  Future<void> fetchPaymentCounts() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://verifyserve.social/Second%20PHP%20FILE/Payment/all_payment_count_for_fieldworkar.php?field_workar_number=$mobileNumber',
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
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                "/Home_Screen",
                    (route) => false,
              );
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
      body: TabBarView(
        controller: _tabController,
        children: [
          NewDesginFieldWorkerBookingPageNew(),
          NewDesginFieldWorkerPendingFlatsNew(),
          NewDesignFieldWorkerCompleteFlatsNew(),
        ],
      ),
    );
  }
}