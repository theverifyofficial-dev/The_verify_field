import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'demand_Form.dart';

class DemandDetail extends StatefulWidget {
  final String demandId;
  const DemandDetail({super.key, required this.demandId});

  @override
  State<DemandDetail> createState() => _AdminDemandDetailState();
}

class _AdminDemandDetailState extends State<DemandDetail> {
  Map<String, dynamic>? _demand;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDemandDetails();
  }

  Future<void> _fetchDemandDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonRes = jsonDecode(response.body);
        if (jsonRes["success"] == true &&
            jsonRes["data"] is List &&
            (jsonRes["data"] as List).isNotEmpty) {
          setState(() {
            _demand = jsonRes["data"][0];
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching details: $e")));
      }
      setState(() => _isLoading = false);
    }
  }

  String formatApiDate(dynamic raw) {
    if (raw == null) return "-";

    try {
      final dateStr = raw["date"]; // "2025-11-13 00:00:00.000000"
      final dt = DateTime.parse(dateStr);

      return "${dt.day.toString().padLeft(2, '0')} "
          "${_month(dt.month)} "
          "${dt.year}";
    } catch (_) {
      return "-";
    }
  }

  String _month(int m) {
    const names = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return names[m];
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = _demand?["mark"] == "1";
    final Color accent =
    isUrgent ? Colors.redAccent : theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F5F0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Demand Details",
          style:
          TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: accent,
        icon: Icon(Icons.phone, color: Colors.black),
        label: Text("Contact", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        onPressed: () => _openContactSheet(context, accent, isDark),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _demand == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildTenantCard(isDark, accent),
            const SizedBox(height: 24),


            const SizedBox(height: 24),

            // OPEN FORM / ADD MORE DETAILS
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent.withOpacity(0.85),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const DemandForm()),
                  );
                },
                child: Text(
                  "Add More Details",
                  style: TextStyle(
                      color: isDark ? Colors.black : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openContactSheet(BuildContext context, Color accent, bool isDark) {
    final number = _demand?["Tnumber"] ?? "";
    final name   = _demand?["Tname"] ?? "Customer";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF111217) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 18),

              Text("Contact Customer",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accent)
              ),

              const SizedBox(height: 22),

              // CALL BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.call, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _callCustomer(number);
                  },
                  label: Text(
                    "Call $number",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // WHATSAPP BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.chat, color: Colors.white),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    _whatsappCustomer(number, name);
                  },
                  label: const Text(
                    "Message on WhatsApp",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void _callCustomer(String number) async {
    final uri = Uri.parse("tel:$number");
    await launchUrl(uri);
  }

  void _whatsappCustomer(String number, String name) async {
    final text = Uri.encodeComponent("Hello $name, I am contacting you regarding your demand on Verify.");
    final uri  = Uri.parse("https://wa.me/$number?text=$text");
    await launchUrl(uri);
  }


  Widget _buildTenantCard(bool isDark, Color accent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 22,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            height: 55,
            width: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [accent, accent.withOpacity(0.7)],
              ),
              boxShadow: [
                BoxShadow(
                    color: accent.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4))
              ],
            ),
            child: Center(
              child: Text(
                _demand?["Tname"]?.substring(0, 1).toUpperCase() ?? "?",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_demand?["Tname"] ?? "Unknown",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 3),
                  Text(_demand?["Tnumber"] ?? "-",
                      style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 14)),

                  Text(
                    "Created: ${formatApiDate(_demand!["created_date"])}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  )

                ]),
          ),
          if (_demand?["mark"] == "1")
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.redAccent.withOpacity(0.8),
                      blurRadius: 10,
                      spreadRadius: 1)
                ],
              ),
            ),
        ]),
        const SizedBox(height: 12),
        Divider(color: Colors.grey.withOpacity(0.3)),
        _infoRow("Buy / Rent", _demand?["Buy_rent"]),
        _infoRow("Location", _demand?["Location"]),
        _infoRow("Price Range", _demand?["Price"]),
        _infoRow("BHK Range", _demand?["Bhk"]),
        _infoRow("Reference", _demand?["Reference"]),
        _infoRow("Status", _demand?["Status"]),
        _infoRow("Message", _demand?["Message"]),
      ]),
    );
  }


  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: const TextStyle(
                color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
        Flexible(
          child: Text(
            (value?.isNotEmpty ?? false) ? value! : "-",
            textAlign: TextAlign.right,
            style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ]),
    );
  }

}
