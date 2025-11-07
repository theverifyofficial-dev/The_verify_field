import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Accept_model.dart';

class AcceptAgreement extends StatefulWidget {
  const AcceptAgreement({super.key,});

  @override
  State<AcceptAgreement> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AcceptAgreement> {
  List<AcceptModel> agreements = [];
  bool isLoading = true;
  String? mobileNumber;

  @override
  void initState() {
    super.initState();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString("number");
    if (mobileNumber != null && mobileNumber!.isNotEmpty) {
      await fetchAgreements();
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/show_accpet_agreement_for_fieldsworkar.php?Fieldwarkarnumber=$mobileNumber'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map &&
            decoded['success'] == true &&
            decoded['data'] is List) {
          setState(() {
            agreements = (decoded['data'] as List)
                .map((e) => AcceptModel.fromJson(e))
                .toList()
                .reversed
                .toList();
            isLoading = false;
          });
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading agreements: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.greenAccent),
        )
            : agreements.isEmpty
            ? Center(
          child: Text(
            "No agreements found",
            style: TextStyle(
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        )
            : ListView.builder(
          itemCount: agreements.length,
          padding: const EdgeInsets.all(14),
          itemBuilder: (context, index) {
            final item = agreements[index];
            return _buildAgreementCard(context, item, isDark);
          },
        ),
      ),
    );
  }

  Widget _buildAgreementCard(
      BuildContext context, AcceptModel item, bool isDark) {
    final size = MediaQuery.of(context).size;

    final Color textColor = isDark ? Colors.white : Colors.black87;
    final Color subTextColor = isDark ? Colors.white70 : Colors.black;
    final Color iconColor = isDark ? Colors.white70 : Colors.black;

    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.012),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: isDark
              ? [Colors.green.shade700, Colors.black]
              : [Colors.green.shade400,Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: Colors.greenAccent.withOpacity(0.3),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.greenAccent.withOpacity(0.25),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(size.width * 0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Owner & Tenant Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "🧑 Owner: ${item.ownerName}",
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Flexible(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "🏠 Tenant: ${item.tenantName}",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        fontSize: 14.5,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // 💰 Rent
            _infoRow(Icons.currency_rupee, "Rent: ₹${item.monthlyRent}",
                iconColor, subTextColor),

            // ⏰ Date
            _infoRow(Icons.calendar_month_rounded,
                "Shifting: ${_formatDate(item.shiftingDate)}", iconColor, subTextColor),

            // 📄 Type
            _infoRow(Icons.assignment_rounded, "Type: ${item.agreementType}",
                iconColor, subTextColor),

            const SizedBox(height: 12),

            // ✅ Approved Tag
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade100 : Colors.black,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent, width: 1),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.verified, color: Colors.green, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    "Approved by Admin",
                    style: TextStyle(
                      color: isDark ? Colors.black : Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color iconColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              style: TextStyle(color: textColor, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      if (rawDate.isEmpty) return "N/A";
      final date = DateTime.parse(rawDate);
      return "${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}";
    } catch (_) {
      return rawDate;
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}
