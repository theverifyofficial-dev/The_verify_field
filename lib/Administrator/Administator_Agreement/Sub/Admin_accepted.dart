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
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/display_all_data_accept_agreement.php'));

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
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final glowColor = isDark ? Colors.greenAccent : Colors.green.shade600;

    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF7C3AED)))
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
                  color: isDark ? Colors.white: Colors.grey.shade900 ,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// 🔹 Top Row (Owner + Status Badge)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${_formatDate(item.shiftingDate)}",
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.grey.shade900 : Colors.white,
                          ),
                        ),
                    /// 🔹 Tenant Name
                    // Row(
                    //   children: [
                    //     const Icon(Icons.verified, size: 16, color: Colors
                    //         .green),
                    //     const SizedBox(width: 6),
                        Text(
                          "${item.Type}",
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: isDark ? Colors.grey.shade900 : Colors
                                .white,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    Divider(
                      height: 1,
                      color: isDark ? Colors.black : Colors.white,
                    ),

                    const SizedBox(height: 10),


                    _CardDetailRow(label: "Owner:", value: item.ownerName, isDark: isDark),
                    _CardDetailRow(label: "Tenant:", value: item.tenantName, isDark: isDark),


                    const SizedBox(height: 8),

                    _newInfoFull("RENT", item.monthlyRent, isDark),

                    const SizedBox(height: 16),

                    /// 🔹 Button
                    SizedBox(
                      width: double.infinity,
                      child:
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [Color(0xFF7C3AED), Color(0xFFEC4899)]
                                : [Color(0xFF7C3AED), Color(0xFFEC4899)],
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, // IMPORTANT
                            shadowColor: Colors.transparent,     // IMPORTANT
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    AcceptedDetails(agreementId: item.id),
                              ),
                            );
                            _refreshAgreements();
                          },
                          child: const Text(
                            "View Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    ),


                    const SizedBox(height: 8),

                    /// 🔹 Fieldworker Name
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "By: ${item.fieldwarkarname.toString().split(' ')[0]}",
                        style: TextStyle(
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                          color: isDark ? Colors.grey.shade900 : Colors.white,
                        ),
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
            style:  TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.grey.shade900 : Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        Text(
          value,
          style: TextStyle(
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
                color:
                valueColor ?? (isDark ? Colors.deepPurple : Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}