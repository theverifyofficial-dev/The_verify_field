import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/String_ID_model.dart';
import 'Accepted_details.dart';

class AdminAccepted extends StatefulWidget {
  const AdminAccepted({super.key});

  @override
  State<AdminAccepted> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AdminAccepted> {
  List<StringIdModel> agreements = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAgreements();
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
          'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_all_data_accept_agreement.php'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          setState(() {
            agreements = decoded
                .map((e) => StringIdModel.fromJson(e))
                .toList()
                .reversed
                .toList();
            isLoading = false;
          });
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  _launchURL(String pdfUrl) async {
    final Uri url = Uri.parse(pdfUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  String _formatDate(String rawDate) {
    try {
      if (rawDate.isEmpty) return "N/A";
      final date = DateTime.parse(rawDate);
      return "${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}";
    } catch (e) {
      return rawDate;
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final glowColor = isDark ? Colors.greenAccent : Colors.green.shade600;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
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
                margin: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.green.shade700, Colors.black]
                        : [Colors.green.shade400,Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: glowColor.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🟩 Owner - Tenant Row
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item.ownerName,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.grey.shade100
                                    : Colors.black,
                                fontSize: 16),
                          ),
                          Text(
                            item.tenantName,
                            style: TextStyle(
                                color: isDark
                                    ? Colors.grey.shade100
                                    : Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Divider(
                        color: isDark
                            ? Colors.grey.shade100
                            : Colors.black,
                        thickness: 0.6,
                      ),
                      const SizedBox(height: 6),

                      // 🏠 Rent, Date, Type
                      _infoRow("Rent", "₹${item.monthlyRent}",isDark
                          ? Colors.grey.shade100
                          : Colors.black,),
                      _infoRow(
                          "Date", _formatDate(item.shiftingDate),isDark
                          ? Colors.grey.shade100
                          : Colors.black,),
                      _infoRow("Type", item.Type,isDark
                          ? Colors.grey.shade100
                          : Colors.black,),

                      const SizedBox(height: 10),

                      // 🔗 Actions Row (Equal spacing)
                      Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDark
                                    ? Colors.grey.shade100
                                    : Colors.black,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10),
                              ),
                              icon: const Icon(Icons.open_in_new,
                                  size: 18, color: Colors.green),
                              label: Text("View Details",
                                  style:
                                  TextStyle(color: isDark
                                      ? Colors.black
                                      : Colors.white,)),
                              onPressed: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AcceptedDetails(
                                        agreementId: item.id),
                                  ),
                                );
                                _refreshAgreements();
                              },
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value,Color color) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style:  TextStyle(color: color, fontSize: 13)),
          Text(value,
              style:
               TextStyle(color: color,fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
