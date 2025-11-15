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

  Future<void> _callAndLog(String number, String id, String message) async {
    await _logContact(message: message, id: id);
    final uri = Uri.parse("tel:$number");
    await launchUrl(uri);
  }

  Future<void> _whatsappAndLog(
      String number, String id, String message, String name) async {

    await _logContact(message: message, id: id);

    final phone = number.replaceAll(" ", "");
    final text = Uri.encodeComponent("Hello $name, I’m contacting regarding your request.");
    final url = Uri.parse("https://wa.me/$phone?text=$text");

    await launchUrl(url, mode: LaunchMode.externalApplication);
  }

  Future<void> _logContact({
    required String message,
    required String id,
  }) async {
    final now = DateTime.now();
    final date = "${now.year}-${now.month}-${now.day}";
    final time = "${now.hour}:${now.minute}";

    const apiUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/calling_option_for_fieldworkar.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"message": message, "date": date, "time": time, "subid": id},
      );

      debugPrint("Log saved: ${response.body}");
    } catch (e) {
      debugPrint("Error logging contact: $e");
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
      floatingActionButton: GestureDetector(
        onTap: () => _openContactSheet(context, accent, isDark),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                accent,
                accent.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: accent.withOpacity(0.4),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.phone_in_talk_rounded,
            color: Colors.black,
            size: 28,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,


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
                  backgroundColor: theme.colorScheme.primary,
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

  Future<List<dynamic>> _fetchLogs(String id) async {
    try {
      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_calling_option_in_tenant_demand.php?subid=$id";

      print("📡 Fetching Logs: $url");

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body["success"] == true && body["data"] is List) {
          print("📥 Logs fetched: ${body["data"].length}");
          return body["data"];
        }
      }
    } catch (e) {
      print("❌ Error fetching logs: $e");
    }
    return [];
  }


  void _openContactSheet(BuildContext context, Color accent, bool isDark) async {
    final number = _demand?["Tnumber"] ?? "";
    final name = _demand?["Tname"] ?? "";
    final id = _demand?["id"].toString() ?? "";

    // FIRST LOAD LOGS
    List<dynamic> logs = [];
    await _fetchLogs(id).then((list) => logs = list);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            // function to reload logs live inside bottomsheet
            Future<void> refreshLogs() async {
              print("🔄 Refreshing Logs...");
              final updated = await _fetchLogs(id);
              setSheetState(() {
                logs = updated;
              });
              print("✅ Logs Updated: ${logs.length}");
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // drag handle
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    "Contact Customer",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // CONTACT BUTTONS
                  Row(
                    children: [
                      Expanded(
                        child: _contactButton(
                          label: "Call",
                          color: Colors.blue,
                          icon: Icons.call,
                          onTap: () async {
                            print("☎ CALL tapped");

                            await _logContact(
                                message: "Try to Call $number", id: id);

                            print("📌 Log Inserted → Calling...");
                            await refreshLogs();

                            final uri = Uri.parse("tel:$number");
                            await launchUrl(uri);
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _contactButton(
                          label: "WhatsApp",
                          color: Colors.green,
                          icon: Icons.chat,
                          onTap: () async {
                            print("💬 WhatsApp tapped");

                            await _logContact(
                                message: "Try to message on WhatsApp $number",
                                id: id);

                            print("📌 Log Inserted → Opening WhatsApp...");
                            await refreshLogs();

                            final phone = number.replaceAll(" ", "");
                            final txt = Uri.encodeComponent(
                                "Hello $name, I’m contacting regarding your request.");
                            final url =
                            Uri.parse("https://wa.me/$phone?text=$txt");

                            await launchUrl(url,
                                mode: LaunchMode.externalApplication);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // LOG HEADER
                  Row(
                    children: [
                      Icon(Icons.history, color: accent, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Contact Logs",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // LOG LIST
                  SizedBox(
                    height: 250,
                    child: logs.isEmpty
                        ? Center(
                      child: Text(
                        "No activity logs found.",
                        style: TextStyle(
                          fontSize: 15,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    )
                        : ListView.separated(
                      itemCount: logs.length,
                      separatorBuilder: (_, __) => Divider(
                          color: isDark
                              ? Colors.white12
                              : Colors.black12),
                      itemBuilder: (context, i) {
                        final log = logs[i];
                        final msg = log['message'] ?? "";
                        final date = log['date'] ?? "";
                        final time = log['time'] ?? "";

                        final isCall =
                        msg.toLowerCase().contains("call");
                        final isWhatsapp =
                        msg.toLowerCase().contains("whatsapp");

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isCall
                                    ? Colors.blue.withOpacity(0.15)
                                    : isWhatsapp
                                    ? Colors.green.withOpacity(0.15)
                                    : Colors.grey.withOpacity(0.15),
                              ),
                              child: Icon(
                                isCall
                                    ? Icons.call
                                    : isWhatsapp
                                    ? Icons.chat
                                    : Icons.info_outline,
                                color: isCall
                                    ? Colors.blue
                                    : isWhatsapp
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg,
                                    style: TextStyle(
                                      color: isDark
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "$date • $time",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        );
      },
    );
  }





  Widget _contactButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: onTap,
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
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
