import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Rent%20Agreement/Forms/Commercial_Form.dart';
import 'package:verify_feild_worker/Rent%20Agreement/Forms/Renewal_form.dart';
import 'package:verify_feild_worker/Rent%20Agreement/Forms/Verification_form.dart';

import '../../model/agrement_model.dart';
import '../Dashboard_screen.dart';
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

  Future<RewardStatus> fetchRewardStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString("number");

    if (number == null || number.isEmpty) {
      return RewardStatus(totalAgreements: 0, isDiscounted: false);
    }

    final res = await http.get(
      Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Target_New_2026/count_api_for_all_agreement_with_reword.php"
            "?Fieldwarkarnumber=$number",
      ),
    );

    final data = jsonDecode(res.body);

    if (data["status"] == true) {
      final total = int.tryParse(data["total_agreement"].toString()) ?? 0;
      return RewardStatus(
        totalAgreements: total,
        isDiscounted: total > 20,
      );
    }

    return RewardStatus(totalAgreements: 0, isDiscounted: false);
  }

  void _navigateToEditForm(BuildContext context, AgreementData agreement) async {
    Widget page;
    final reward = await fetchRewardStatus();

    switch (agreement.Type.toLowerCase()) {
      case "rental agreement":
        page = RentalWizardPage(agreementId: agreement.id, rewardStatus: reward);
        break;
      case "external rental agreement":
        page = ExternalWizardPage(agreementId: agreement.id, rewardStatus: reward);
        break;
      case "renewal agreement":
        page = RenewalForm(agreementId: agreement.id, rewardStatus: reward);
        break;
      case "commercial agreement":
        page = CommercialWizardPage(agreementId: agreement.id, rewardStatus: reward);
        break;
      case "furnished agreement":
        page = FurnishedForm(agreementId: agreement.id, rewardStatus: reward);
        break;
      case "police verification":
        page = VerificationWizardPage(agreementId: agreement.id, rewardStatus: reward);
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown agreement type: ${agreement.Type}")),
        );
        return;
    }

    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    _refreshAgreements();
  }

  Future<void> _refreshAgreements() async {
    try {
      setState(() => isLoading = true);
      await _fetchRentalAgreements();
    } catch (e) {
      debugPrint("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _fetchRentalAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/display_preview_agreemet.php?Fieldwarkarnumber=$mobileNumber"));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded["status"] == "success") {
          final model = AgreementResponse.fromJson(decoded);
          setState(() {
            agreements = model.data.reversed.toList();
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      debugPrint("❌ Error fetching agreements: $e");
      setState(() => isLoading = false);
    }
  }

  // ── Status color logic — same as AdminPending ──────────────────────────────
  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s == "rejected") return Colors.red;
    if (s == "fields updated") return Colors.blue;
    if (s == "awaiting signature") return Colors.pink;
    return Colors.green;
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

  // ── Card — exact same structure as AdminPending._buildAgreementCard ─────────
  Widget _buildAgreementCard(AgreementData agreement) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = agreement.status?.toLowerCase() ?? '';
    final bool isRejected = status == "rejected";
    final statusColor = _statusColor(status);

    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? Colors.white : Colors.grey.shade900,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── TOP ROW (ID badge + View Details button) ────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:  // ── TITLE (Agreement Type) ───────────────────────────────────
                    Text(
                      agreement.Type,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              AgreementDetailPage(agreementId: agreement.id),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF7C3AED), Color(0xFFEC4899)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.touch_app, color: Colors.white, size: 16),
                          SizedBox(width: 6),
                          Text(
                            "VIEW DETAILS",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              // ── OWNER + TENANT ───────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Owner: ${agreement.ownerName}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "Tenant: ${agreement.tenantName}",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // ── ADDRESS ──────────────────────────────────────────────────
              Text(
                "📍${agreement.rentedAddress}",
                style: TextStyle(
                  color: isDark ? Colors.black87 : Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // ── DATE ROW ─────────────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shifting: ${_formatDate(agreement.shiftingDate?.toString().split(' ')[0] ?? '')}",
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ── STATUS MESSAGE BOX ───────────────────────────────────────

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? Colors.black87 : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 18, color: statusColor),
                    const SizedBox(width: 6),
                      Expanded(
                      child: Text(
                      "${agreement.status ?? 'Pending'} | Reason : ${agreement.messages ?? 'On Hold'}",
                      style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.5 ,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2,
                      shadows: [
                      // Shadow(
                      // color: Colors.black87,
                      // blurRadius: 6,
                      // ),
                  ],
                ),
              ),
    ),
              ],
            ),
              ),

              // ── EDIT & RESUBMIT (only if rejected) ──────────────────────
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
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
        child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
      )
          : agreements.isEmpty
          ? const Center(child: Text("No agreements found"))
          : RefreshIndicator(
        onRefresh: _refreshAgreements,
        child: ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: agreements.length,
          itemBuilder: (context, index) =>
              _buildAgreementCard(agreements[index]),
        ),
      ),
    );
  }
}