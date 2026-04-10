import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/Accept_model.dart';

class AcceptAgreement extends StatefulWidget {
  const AcceptAgreement({super.key});

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

  Future<void> _refreshAgreements() async {
    try {
      setState(() => isLoading = true);
      await fetchAgreements();
    } catch (e) {
      debugPrint("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> fetchAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/show_accpet_agreement_for_fieldsworkar.php?Fieldwarkarnumber=$mobileNumber'));

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
        )
            : agreements.isEmpty
            ? const Center(child: Text("No agreements found"))
            : RefreshIndicator(
          onRefresh: _refreshAgreements,
          child: ListView.builder(
            itemCount: agreements.length,
            padding: const EdgeInsets.all(12),
            itemBuilder: (context, index) {
              final item = agreements[index];
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white
                      : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Top Row (Date + Type) ──────────────────
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(item.shiftingDate),
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.grey.shade900
                                : Colors.white,
                          ),
                        ),
                        Text(
                          item.agreementType,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: isDark
                                ? Colors.grey.shade900
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Divider(
                      height: 1,
                      color:
                      isDark ? Colors.black : Colors.white,
                    ),

                    const SizedBox(height: 10),

                    // ── Owner & Tenant ─────────────────────────
                    _CardDetailRow(
                        label: "Owner:",
                        value: item.ownerName,
                        isDark: isDark),
                    _CardDetailRow(
                        label: "Tenant:",
                        value: item.tenantName,
                        isDark: isDark),

                    const SizedBox(height: 8),

                    // ── Rent ───────────────────────────────────
                    _newInfoFull(
                        "RENT", item.monthlyRent, isDark),

                    const SizedBox(height: 16),

                Container(
                  alignment: Alignment.center,
                  height: 50,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFEC4899),
                        Color(0xFF7C3AED),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.greenAccent, width: 1),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, color: Colors.blue, size: 20),
                      const SizedBox(width: 6),
                      Text(
                        "Approved by Admin",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _newInfoFull(String title, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            color: isDark ? Colors.grey.shade900 : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

// ── Card Detail Row ───────────────────────────────────────────────────────────
class _CardDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;

  const _CardDetailRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              letterSpacing: 2,
              fontSize: 14,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.black : Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                letterSpacing: 2,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: valueColor ??
                    (isDark ? Colors.deepPurple : Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}