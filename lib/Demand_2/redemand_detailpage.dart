import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Demand_2/redemand_form.dart';

import '../utilities/bug_founder_fuction.dart';

class field_RedemandDetailPage extends StatefulWidget {
  final String redemandId;
  final bool fromNotification;
  const field_RedemandDetailPage({
    super.key,
    required this.redemandId,
    this.fromNotification = false,
  });

  @override
  State<field_RedemandDetailPage> createState() => _RedemandDetailPageState();
}

class _RedemandDetailPageState extends State<field_RedemandDetailPage> {
  Map<String, dynamic>? _redemand;
  bool _isLoading = true;

  String? _finalReason;
  bool _isSubmittingFinal = false;
  bool _isDisclosing = false;

  final TextEditingController _otherReasonCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchRedemandDetails();
  }

  // ---------------- FETCH REDEMAND DETAILS ----------------
  Future<void> _fetchRedemandDetails() async {
    try {
      final res = await http.get(Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}",
      ));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body["success"] == true &&
            body["data"] is List &&
            body["data"].isNotEmpty) {
          setState(() {
            _redemand = body["data"][0];
            _isLoading = false;
          });
        } else {
          _isLoading = false;
        }
      }
      else{
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}",
          error: res.body.toString(),
          statusCode: res.statusCode ?? 0,
        );
      }
    } catch (e) {
      _isLoading = false;
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}",
        error: e.toString(),
        statusCode: 500,
      );

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  Future<List<dynamic>> _fetchLogs(String id) async {
    try {
      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_redemand.php?subid=$id";

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body["success"] == true && body["data"] is List) {
          return body["data"];
        }
      }
      else{
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_redemand.php?subid=$id",
          error: res.body.toString(),
          statusCode: res.statusCode ?? 0,
        );
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_redemand.php?subid=$id",
        error: e.toString(),
        statusCode: 500,
      );
    }
    return [];
  }


  // ---------------- DATE FORMAT ----------------
  String formatApiDate(dynamic raw) {
    if (raw == null) return "-";
    try {
      final str = raw is String ? raw : raw["date"];
      final dt = DateTime.parse(str);
      return "${dt.day.toString().padLeft(2, '0')} "
          "${_month(dt.month)} ${dt.year}";
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

  String normalizeWhatsAppNumber(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'\D'), '');

    // If already has country code (starts with 91 and length > 10)
    if (cleaned.length > 10 && cleaned.startsWith('91')) {
      return cleaned;
    }

    // Default to India
    if (cleaned.length == 10) {
      return '91$cleaned';
    }

    return cleaned; // fallback
  }


  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = (_redemand?["mark"]?.toString() ?? "0") == "1";
    final Color accent =
    isUrgent ? Colors.redAccent : theme.colorScheme.primary;

    final bool isDisclosed =
        _redemand?["Status"]?.toString().toLowerCase() == "disclosed";

    final status = _redemand?["Status"]?.toLowerCase();

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F5F0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon:
          const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Redemand Details",
          style: TextStyle(
            color: accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _redemand == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            _buildMainCard(isDark, accent),
            const SizedBox(height: 24),

            if (status == "progressing" || status == "disclosed")

              _buildProgressDetailsCard(_redemand!, isDark, accent),

            if (status == "progressing")
              _buildCompletionSection(isDark, accent),

            if (isDisclosed)
              _buildFinalSummarySection(isDark, accent),

            const SizedBox(height: 24),

            // ADD MORE DETAILS (REDEMAND)

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDisclosed
                      ? Colors.grey.shade200   // 🔒 disabled look
                      : accent,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isDisclosed
                    ? null // 🔒 FULLY DISABLED
                    : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RedemandForm(demand: _redemand!),
                    ),
                  ).then((_) => _fetchRedemandDetails());
                },
                child: Text(
                  isDisclosed
                      ? "Redemand Closed"
                      : "Add More Details",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.phone_in_talk_rounded, color: Colors.white),
                label: const Text(
                  "Contact Customer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _openContactSheet(context, accent, isDark),
              ),
            ),

          ],
        ),
      ),
    );
  }

  void _openContactSheet(BuildContext context, Color accent, bool isDark) async {
    final number = _redemand?["Tnumber"] ?? "";
    final name = _redemand?["Tname"] ?? "";
    final id = _redemand?["id"].toString() ?? "";

    List<dynamic> logs = await _fetchLogs(id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            Future<void> refreshLogs() async {
              final updated = await _fetchLogs(id);
              setSheetState(() => logs = updated);
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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

                  Row(
                    children: [
                      Expanded(
                        child: _contactButton(
                          label: "Call",
                          color: Colors.blue,
                          icon: Icons.call,
                          onTap: () async {
                            await _logContact(
                              message: "Try to Call ${maskPhone(number)}",
                              id: id,
                            );
                            await refreshLogs();
                            await launchUrl(Uri.parse("tel:$number"));
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
                            await _logContact(
                              message:
                              "Try to message on WhatsApp ${maskPhone(number)}",
                              id: id,
                            );
                            await refreshLogs();

                            final phone = normalizeWhatsAppNumber(number);

                            final text = Uri.encodeComponent(
                                "Hello $name, I’m contacting regarding your request.");
                            await launchUrl(
                              Uri.parse("https://wa.me/$phone?text=$text"),
                              mode: LaunchMode.externalApplication,
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  Row(
                    children: [
                      Icon(Icons.history, color: accent),
                      const SizedBox(width: 8),
                      const Text(
                        "Contact Logs",
                        style:
                        TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    height: 250,
                    child: logs.isEmpty
                        ? const Center(child: Text("No activity logs"))
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
                        final by = log['who_calling'] ?? "";

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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text(
                                        "$date • $time",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        "by $by",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isDark
                                              ? Colors.white54
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _logContact({
    required String message,
    required String id,
  })
  async {
    final now = DateTime.now();
    final date = "${now.year}-${now.month}-${now.day}";
    final time = "${now.hour}:${now.minute}";

    const apiUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/add_redemand_call_optiom.php";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('name');
      await http.post(
        Uri.parse(apiUrl),
        body: {
          "message": message,
          "date": date,
          "time": time,
          "subid": id,
          "who_calling":storedName,
        },
      );
    } catch (e) {
      await BugLogger.log(
        apiLink: apiUrl,
        error: e.toString(),
        statusCode: 500,
      );
    }
  }


  String maskPhone(String? phone) {
    if (phone == null || phone.length < 3) return "Hidden";
    return "XXXXXXX${phone.substring(phone.length - 3)}";
  }

  Widget _contactButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }


  // ---------------- MAIN CARD ----------------
  Widget _buildMainCard(bool isDark, Color accent) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
            children: [
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
                    _redemand?["Tname"]?.substring(0, 1).toUpperCase() ?? "?",
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
                      Text(_redemand?["Tname"] ?? "Unknown",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black)),
                      const SizedBox(height: 3),
                      Text(maskPhone(_redemand?["Tnumber"]),
                          style:
                          TextStyle(color: Colors.grey.shade500, fontSize: 14)),

                      Text(
                        "Created: ${formatApiDate(_redemand!["created_date"])}",
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                      ),
                      Text('ReDemand ID: ${_redemand?["id"].toString()}' ?? "0",
                          style: TextStyle(
                              color: isDark
                                  ? Colors.white38
                                  : Colors.black45,
                              fontSize: 13)),

                    ]),
              ),
              if (_redemand?["mark"] == "1") ...[
                Spacer(),
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
              ]
            ]
        ),
        const SizedBox(height: 14),
        Divider(color: Colors.grey.withOpacity(0.3)),
        _infoRow("Type", _redemand?["Buy_rent"]),
        _infoRow("Location", _redemand?["Location"]),
        _infoRow("Price", _redemand?["Price"]),
        _infoRow("BHK", _redemand?["Bhk"]),
        _infoRow("Status", _redemand?["Status"]),
        _infoRow("Message", _redemand?["Message"]),
      ]),
    );
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              (value?.isNotEmpty ?? false) ? value! : "-",
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildCompletionSection(bool isDark, Color accent) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Completion Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),


          const SizedBox(height: 18),

          // Final Reason
          Text("Final Reason",
              style: theme.textTheme.titleSmall!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _showFinalReasonSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: theme.colorScheme.surfaceVariant.withOpacity(0.15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _finalReason ?? "Select Reason",
                    style: TextStyle(
                      color: _finalReason == null
                          ? Colors.grey
                          : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 22, color: theme.iconTheme.color),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),
          TextField(
            controller: _otherReasonCtrl,
            decoration: InputDecoration(
              labelText: "Enter Reason Details",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
            onChanged: (_) => setState(() {}),
          ),

          const SizedBox(height: 15),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (_isDisclosing || _isSubmittingFinal)
                  ? null
                  : _showDiscloseConfirmDialog,
              child: _isDisclosing
                  ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                  : const Text(
                "Disclose Redemand",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDiscloseConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text("Confirm Action"),
          content: const Text(
            "Are you sure you want to disclose this redemand? "
                "This action cannot be undone.",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                Navigator.pop(ctx);
                _submitFinalUpdate();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }


  void _showFinalReasonSheet() {
    final reasons = [
      "Completed Successfully",
      "Wrong Contact Number",
      "Not Reachable",
      "No Respond",
      "Property Not Found",
      "Customer Cancelled",
      "Mismatch Requirements",
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          const Text(
            "Select Final Reason",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
          ),
          const Divider(),

          ...reasons.map((e) {
            return ListTile(
              title: Text(e),
              onTap: () {
                Navigator.pop(ctx);

                setState(() {
                  _finalReason = e;
                });
              },
            );
          }),
        ],
      ),
    );
  }

  Future<void> _submitFinalUpdate() async {


    if (_finalReason == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please select final reason"),
        ),
      );
      return;
    }

    final now = DateTime.now();


    final String finishingDateTime =
        "${now.year}-"
        "${now.month.toString().padLeft(2, '0')}-"
        "${now.day.toString().padLeft(2, '0')} "
        "${now.hour.toString().padLeft(2, '0')}:"
        "${now.minute.toString().padLeft(2, '0')}:"
        "${now.second.toString().padLeft(2, '0')}";

    final String finalReasonToSend =
        (_finalReason ?? "") +
            (_otherReasonCtrl.text.trim().isEmpty
                ? ""
                : " - ${_otherReasonCtrl.text.trim()}");

    setState(() => _isSubmittingFinal = true);

    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_redemand.php"),
        body: {
          "id": _redemand!["id"].toString(),
          "finishing_date": finishingDateTime,
          "final_reason": finalReasonToSend,
        },
      );

      print('final redemand submission: ${response.body}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Final Update Submitted"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Error: $e"),
        ),
      );
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_redemand.php",
        error: e.toString(),
        statusCode: 500,
      );
    }

    setState(() => _isSubmittingFinal = false);
  }

  String _fmt(dynamic v) {
    if (v == null) return "—";
    if (v.toString().trim().isEmpty) return "—";
    return v.toString();
  }

  String _fmtDate(dynamic v) {
    if (v == null) return "—";

    try {
      if (v is String && v.contains('-')) {
        final d = DateTime.parse(v);
        return DateFormat('dd MMM yyyy').format(d);
      }

      if (v is Map && v['date'] != null) {
        final d = DateTime.parse(v['date']);
        return DateFormat('dd MMM yyyy').format(d);
      }
    } catch (_) {}

    return v.toString();
  }

  String _fmtFurnishedItems(dynamic raw) {
    if (raw == null || raw.toString().trim().isEmpty) return "—";

    try {
      final Map<String, dynamic> items =
      raw is String ? jsonDecode(raw) : Map<String, dynamic>.from(raw);

      if (items.isEmpty) return "—";

      return items.entries
          .map((e) => "${e.key} (${e.value})")
          .join(", ");
    } catch (_) {
      return "—";
    }
  }


  String _fmtFamily(Map<String, dynamic> data) {
    final structure = data['family_structur'];
    final members = data['family_member'];
    final count = data['count_of_person'];

    if (structure == null && members == null) return "—";

    return [
      if (structure != null) structure,
      if (members != null) "$members members",
      if (count != null) "($count)"
    ].join(' • ');
  }

  Widget _buildProgressDetailsCard(
      Map<String, dynamic> data,
      bool isDark,
      Color accent,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.18),
            blurRadius: 16,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Work Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          const SizedBox(height: 16),

          _infoRow("Parking", _fmt(data["parking"])),
          _infoRow("Lift", _fmt(data["lift"])),
          _infoRow("Furnished", _fmt(data["furnished_unfurnished"])),

          if (data["furnished_unfurnished"] == "Fully Furnished" ||
              data["furnished_unfurnished"] == "Semi Furnished")
            _infoRow(
              "Items",
              _fmtFurnishedItems(data["furnished_item"]),
            ),

          _infoRow(
            "Family",
            _fmtFamily(data),
          ),

          _infoRow("Religion", _fmt(data["religion"])),

          _infoRow(
            "Visiting Date",
            _fmtDate(data["visiting_dates"]),
          ),

          _infoRow("Vehicle Type", _fmt(data["vichle_type"])),

          if (_fmt(data["vichle_no"]) != "—")
            _infoRow("Vehicle No", _fmt(data["vichle_no"])),

          _infoRow(
            "Floor",
            _fmt(data["floor"])!.replaceAll(',', ', '),
          ),

          _infoRow(
            "Shifting Date",
            _fmtDate(data["shifting_date"]),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSummarySection(bool isDark, Color accent) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Disclosing Details",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: accent,
            ),
          ),
          const SizedBox(height: 16),

          // Finishing Date
          Text(
            "Finishing Date",
            style: theme.textTheme.titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surfaceVariant.withOpacity(0.12),
            ),
            child: Text(
              _redemand?["finishing_date"] ?? "-",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Final Reason
          Text(
            "Final Reason",
            style: theme.textTheme.titleSmall!
                .copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: theme.colorScheme.surfaceVariant.withOpacity(0.12),
            ),
            child: Text(
              _redemand?["final_reason"] ?? "-",
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black87,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }



}
