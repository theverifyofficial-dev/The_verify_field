import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Rent%20Agreement/Forms/Commercial_Form.dart';
import 'package:verify_feild_worker/Rent%20Agreement/Forms/Renewal_form.dart';
import 'package:verify_feild_worker/Rent%20Agreement/Forms/Verification_form.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';

import '../../model/agrement_model.dart';
import '../Forms/Agreement_Form.dart';
import '../Forms/External_Form.dart';
import '../Forms/Furnished_form.dart';
import '../details_agreement.dart';

class RequestAgreementsPage extends StatefulWidget {
  const RequestAgreementsPage({super.key});

  @override
  State<RequestAgreementsPage> createState() => _RequestAgreementsPageState();
}

class _RequestAgreementsPageState extends State<RequestAgreementsPage> {
  String? mobileNumber;
  List<AgreementData> agreements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString("number");
    if (mobileNumber != null) {
      _fetchRentalAgreements();
    }
  }

  void _navigateToEditForm(BuildContext context, AgreementData agreement) async {
    Widget page;

    switch (agreement.Type.toLowerCase()) {
      case "rental agreement":
        page = RentalWizardPage(agreementId: agreement.id);
        break;

      case "external rental agreement":
        page = ExternalWizardPage(agreementId: agreement.id);
        break;

      case "renewal agreement":
        page = RenewalForm(agreementId: agreement.id);
        break;
      case "commercial agreement":
        page = CommercialWizardPage(agreementId: agreement.id);
        break;
      case "furnished agreement":
        page = FurnishedForm(agreementId: agreement.id);
        break;

      case "police verification":
        page = VerificationWizardPage(agreementId: agreement.id);
        break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown agreement type: ${agreement.Type}")),
        );
        return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    _refreshAgreements();
  }


  Future<void> _refreshAgreements() async {
    try {
      setState(() => isLoading = true);
      await _fetchRentalAgreements();
    } catch (e) {
      print("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _fetchRentalAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_preview_agreemet.php?Fieldwarkarnumber=$mobileNumber"));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded["status"] == "success") {
          final model = AgreementResponse.fromJson(decoded);
          setState(() {
            //agreements = model.data;
            agreements = model.data.reversed.toList();
            isLoading = false;
          }
          );
        } else {
          setState(() => isLoading = false);
        }
      } else {
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_preview_agreemet.php?Fieldwarkarnumber=$mobileNumber",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
        setState(() => isLoading = false);
      }
    } catch (e) {
      await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_preview_agreemet.php?Fieldwarkarnumber=$mobileNumber",
          error: e.toString(),
          statusCode: 500,
      );
      print("❌ Error fetching agreements: $e");
      setState(() => isLoading = false);
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

  Widget _buildAgreementCard(AgreementData agreement) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final status = agreement.status?.toLowerCase() ?? '';
    final bool isRejected = status == "rejected";
    final bool isUpdated = status == "fields updated";

    final bool isPolice = agreement.Type.toLowerCase() == "police verification";

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
    final subTextColor = isDark ? Colors.white70 : Colors.white;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      child: Stack(
        children: [
          Container(
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
                // 🔷 Top Row (Owner & Tenant)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "👤 Owner: ${agreement.ownerName}",
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
                      "Shifting Date: ${agreement.shiftingDate != null
                          ? agreement.shiftingDate!.toLocal().toString().split(' ')[0]
                          : "Not Provided"}",
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 13.2 * textScale,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.018),


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
                        glowColor.withOpacity(isDark ? 0.05 : 0.03),
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
                          "${agreement.status ?? 'Pending'} | Reason : ${agreement.messages ?? 'On Hold'}",
                          style: TextStyle(
                            color: Colors.white,
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

                if (isRejected) ...[
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isDark ? Colors.red.shade700 : Colors.red.shade500,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 6,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => _navigateToEditForm(context, agreement),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text(
                        "Edit & Resubmit",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: size.height * 0.018),

                // 🔘 Bottom Buttons Row
                LayoutBuilder(
                  builder: (context, constraints) {
                    final bool isSmall = constraints.maxWidth < 340;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                  builder: (_) => AgreementDetailPage(
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
              ],
            ),
          ),
        ),
          if (isRejected)
            Positioned(
              top: 12,
              left: -30,
              child: Transform.rotate(
                angle: -0.785398, // -45 degrees in radians
                child: Container(
                  width: 140,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.redAccent.shade400,
                        Colors.red.shade700,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    "REJECTED   ",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              ),
            ),
    ]
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : agreements.isEmpty
          ? const Center(
        child: Text(
          "No agreements found",
          style: TextStyle(color: Colors.white70),
        ),
      )
          : RefreshIndicator(
        onRefresh: _refreshAgreements,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: size.height * 0.02),
          itemCount: agreements.length,
          itemBuilder: (context, index) =>
              _buildAgreementCard(agreements[index]),
        ),
      ),
    );
  }

}
