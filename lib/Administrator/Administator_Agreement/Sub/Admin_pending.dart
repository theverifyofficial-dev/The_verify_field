import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/acceptAgreement.dart';
import '../Admin_Agreement_details.dart';
import 'dart:ui';

class AdminPending extends StatefulWidget {
  const AdminPending({super.key});

  @override
  State<AdminPending> createState() => _AdminPendingState();
}

class _AdminPendingState extends State<AdminPending> {
  List<AgreementModel2> agreements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAgreements();
  }

  Future<void> loadAgreements() async {
    try {
      final data = await fetchAgreements();
      setState(() {
        agreements = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading agreements: $e");
    }
  }

  Future<void> _refreshAgreements() async {
    try {
      setState(() => isLoading = true);
      await fetchAgreements();
    } catch (e) {
      print("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }


  Future<List<AgreementModel2>> fetchAgreements() async {
    final url = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreement_data_for_admin.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      // 🔹 Reverse the mapped list
      return data
          .map((e) => AgreementModel2.fromJson(e))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load agreements');
    }
  }

  List<Color> _getCardColors(String? type, bool isDark) {
    if (type != null && type.toLowerCase() == "police verification") {
      return isDark
          ? [Colors.blue.shade900, Colors.black]
          : [ Colors.blue.shade400,Colors.grey.shade400,];
    }

    // Default green theme
    return isDark
        ? [Colors.green.shade900, Colors.black]
        : [Colors.grey.shade500, Colors.green.shade400];
  }

  Widget _buildAgreementCard(AgreementModel2 agreement, {required int displayIndex}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final status = agreement.status?.toLowerCase() ?? '';
    final bool isRejected = status == "rejected";
    final bool isUpdated = status == "fields updated";

    final bool isPolice = agreement.Type == "Police Verification";

    final Color glowColor = isRejected
        ? Colors.redAccent
        : isUpdated
        ? (isPolice ? Colors.blueAccent : Colors.greenAccent)
        : (isPolice ? Colors.blue : Colors.green);


    final size = MediaQuery.of(context).size;
    final double textScale = size.width < 360
        ? 0.85
        : size.width < 420
        ? 0.95
        : 1.0;

    final baseTextColor = isDark ? Colors.white : Colors.white;
    final subTextColor = isDark ? Colors.white70 : Colors.black;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: _getCardColors(agreement.Type, isDark),
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: glowColor.withOpacity(0.25),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: glowColor.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 0.6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(size.width * 0.045),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔘 Bottom Buttons Row
              LayoutBuilder(
                builder: (context, constraints) {
                  final bool isSmall = constraints.maxWidth < 340;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.8), // circle background
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "$displayIndex",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(width: 6,),
                      // 🔴 Type Label
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.03,
                            vertical: size.height * 0.012,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: isDark
                                ? Colors.grey.shade100
                                : Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: glowColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              agreement.Type.toUpperCase(),
                              style: TextStyle(
                                color: isDark
                                    ? Colors.black
                                    : Colors.grey.shade100,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.5 * textScale,
                                letterSpacing: 0.7,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmall ? 8 : 14),

                      // 🟢 View Details Button
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.grey.shade100
                                : Colors.black,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 6,
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.03,
                              vertical: size.height * 0.012,
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AdminAgreementDetails(
                                    agreementId: agreement.id),
                              ),
                            );
                          },
                          icon: Icon(Icons.visibility_rounded,
                              size: 18 * textScale, color: Colors.green),
                          label: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              "View Details",
                              style: TextStyle(
                                color: isDark
                                    ? Colors.black
                                    : Colors.grey.shade100,
                                fontWeight: FontWeight.w600,
                                fontSize: 13 * textScale,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: size.height * 0.008),

              // 🔷 Top Row (Owner & Tenant)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      "🧑 Owner: ${agreement.ownerName}",
                      style: TextStyle(
                        color: baseTextColor,
                        fontSize: 14.5 * textScale,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Flexible(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "🏠 Tenant: ${agreement.tenantName}",
                        style: TextStyle(
                          color: baseTextColor,
                          fontSize: 14.5 * textScale,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.015),

              // 📍 Address
              Row(
                children: [
                  Icon(Icons.location_on_rounded, color: subTextColor, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      agreement.rentedAddress,
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 13.2 * textScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.008),

              // ⏰ Shifting Date
              Row(
                children: [
                  Icon(Icons.schedule_rounded, color: subTextColor, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    "Shifting Date: ${_formatDate(agreement.shiftingDate.toString().split(' ')[0])}",
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13.2 * textScale,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Spacer(),

                  Text(
                    "by: ${agreement.fieldwarkarname.toString().split(' ')[0]}",
                    style: TextStyle(
                      color: subTextColor,
                      fontSize: 13.2 * textScale,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.018),

              // 🟢 Status Section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.035,
                  vertical: size.height * 0.012,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                    colors: [
                      glowColor.withOpacity(isDark ? 0.15 : 0.08),
                      glowColor.withOpacity(isDark ? 0.05 : 0.09),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isRejected
                          ? Icons.cancel_rounded
                          : isUpdated
                          ? Icons.auto_fix_high
                          : Icons.verified_rounded,
                      color: glowColor,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "${agreement.status ?? 'Pending'} • ${agreement.messages ?? ''}",
                        style: TextStyle(
                          color: isDark
                              ? Colors.grey.shade100
                              : Colors.white70,
                          fontSize: 13.5 * textScale,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                          shadows: [
                            Shadow(
                              color: glowColor.withOpacity(0.4),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              ),
              SizedBox(height: size.height * 0.008),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "cost: ₹${agreement.agreement_price}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    "Filled On ${_formatDate(agreement.currentDate)}",
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),


            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(dynamic rawDate) {
    try {
      String actualDate =
      rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return "--";
      final date = DateTime.parse(actualDate.split(' ')[0]);
      return "${_twoDigits(date.day)} ${_monthName(date.month)} ${date.year}";
    } catch (_) {
      return "--";
    }
  }
  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : agreements.isEmpty
          ? const Center(child: Text("No agreements found"))
          : ListView.builder(
        itemCount: agreements.length,

        itemBuilder: (context, index) {
          int displayIndex = agreements.length - index;
          return _buildAgreementCard(agreements[index],displayIndex: displayIndex,);
        },
      ),
    );
  }
}
