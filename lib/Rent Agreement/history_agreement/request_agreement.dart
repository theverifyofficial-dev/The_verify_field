import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Rent%20Agreement/Forms/Renewal_form.dart';

import '../../model/agrement_model.dart';
import '../Forms/Agreement_Form.dart';
import '../Forms/External_Form.dart';
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
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ Error fetching agreements: $e");
      setState(() => isLoading = false);
    }
  }

  Widget _buildAgreementCard(AgreementData agreement) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final status = agreement.status?.toLowerCase() ?? '';
    final bool isRejected = status == "rejected";
    final bool isUpdated = status == "fields updated";

    final Color glowColor = isRejected
        ? Colors.redAccent
        : isUpdated
        ? Colors.greenAccent
        : Colors.blueAccent;

    final size = MediaQuery.of(context).size;
    final double textScale = size.width < 360
        ? 0.85
        : size.width < 420
        ? 0.95
        : 1.0;

    final baseTextColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;

    final Color primaryGlow = Colors.blueAccent;
    final Color secondaryGlow = Colors.purpleAccent.shade100;



    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: size.height * 0.012,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: isDark
              ? [
            primaryGlow.withOpacity(0.07),
            secondaryGlow.withOpacity(0.05),
            Colors.black.withOpacity(0.25),
          ]
              : [
            Colors.white,
            secondaryGlow.withOpacity(0.05),
            primaryGlow.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        border: Border.all(
          color: isDark
              ? glowColor.withOpacity(0.4)
              : glowColor.withOpacity(0.2),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.3),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(isDark ? 0.05 : 0.2),
            blurRadius: 4,
            spreadRadius: -2,
            offset: const Offset(-1, -1),
          ),
        ],

      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                LayoutBuilder(
                  builder: (context, constraints) {
                    return constraints.maxWidth < 330
                        ? Wrap(
                      runSpacing: 6,
                      spacing: 12,
                      children: [
                        _neonText("Owner: ${agreement.ownerName}",
                            glowColor, textScale, baseTextColor),
                        _neonText("Tenant: ${agreement.tenantName}",
                            glowColor, textScale, baseTextColor),
                      ],
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: _neonText(
                              "Owner: ${agreement.ownerName}",
                              glowColor,
                              textScale,
                              baseTextColor),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: _neonText(
                                "Tenant: ${agreement.tenantName}",
                                glowColor,
                                textScale,
                                baseTextColor),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: size.height * 0.012),

                // PROPERTY INFO
                Row(
                  children: [
                    Icon(Icons.location_on_rounded,
                        color: subTextColor, size: 18),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        agreement.rentedAddress,
                        style: TextStyle(
                          color: subTextColor,
                          fontSize: 13.5 * textScale,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.006),

                Row(
                  children: [
                    Icon(Icons.schedule_rounded,
                        color: subTextColor, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      "Shifting: ${agreement.shiftingDate.toLocal().toString().split(' ')[0]}",
                      style: TextStyle(
                        color: subTextColor,
                        fontSize: 13.5 * textScale,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.016),

                // STATUS BAR
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.03,
                    vertical: size.height * 0.012,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            color: glowColor,
                            fontSize: 13.5 * textScale,
                            fontWeight: FontWeight.w600,
                            shadows: [
                              Shadow(
                                color: glowColor.withOpacity(0.4),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.016),

                // ACTION BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.03,
                          vertical: size.height * 0.008,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.red.withOpacity(0.7),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(0.3),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            agreement.Type.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12 * textScale,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Flexible(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.withOpacity(0.7),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 6,
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.04,
                            vertical: size.height * 0.012,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AgreementDetailPage(
                                agreementId: agreement.id,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.visibility,
                            size: 18 * textScale, color: Colors.white),
                        label: Text(
                          "View Details",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13 * textScale,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _neonText(
      String text, Color glowColor, double textScale, Color baseColor) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 13 * textScale,
          fontWeight: FontWeight.bold,
          color: baseColor,
          shadows: [
            Shadow(color: glowColor.withOpacity(0.5), blurRadius: 8),
            Shadow(color: glowColor.withOpacity(0.2), blurRadius: 16),
          ],
        ),
        overflow: TextOverflow.ellipsis,
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
