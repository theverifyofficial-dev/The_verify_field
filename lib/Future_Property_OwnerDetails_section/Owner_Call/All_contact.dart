import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/scheduler.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';


class AllContact extends StatefulWidget {
  final String buildingId;
  final String ownerName;
  final String ownerNumber;

  const AllContact({
    super.key,
    required this.buildingId,
    required this.ownerName,
    required this.ownerNumber,
  });

  @override
  State<AllContact> createState() => _AllContactState();
}

class _AllContactState extends State<AllContact> with WidgetsBindingObserver {

  List<dynamic> flats = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchFlats();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Trigger full rebuild to refresh reminder cards & data
      setState(() {});
      fetchFlats();
    }
  }

  Future<void> _showLogsBottomSheet(BuildContext context, String flatId) async {
    final apiUrl =
        "https://verifyserve.social/Second%20PHP%20FIE/Lmain_realestate/show_api_for_calling_api_in_buidling.php?subid=$flatId";

    List<dynamic> logs = [];

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["success"] == true) {
          logs = jsonData["data"];
        }
      }
    }
    catch (e) {

      await BugLogger.log(
          apiLink: apiUrl,
          error: e.toString(),
          statusCode: 500,
      );
      debugPrint("Error fetching logs: $e");
    }

    if (!context.mounted) return;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0D0D0D) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Drag handle
                Center(
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Activity Logs",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close,
                          color: isDark ? Colors.white70 : Colors.black54),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(height: 20),

                // Logs
                Expanded(
                  child: logs.isEmpty
                      ? Center(
                    child: Text(
                      "No activity logs available.",
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                  )
                      : ListView.separated(
                    itemCount: logs.length,
                    separatorBuilder: (_, __) => Divider(
                      height: 20,
                      color:
                      isDark ? Colors.white10 : Colors.grey.shade300,
                    ),
                    itemBuilder: (context, index) {
                      final log = logs[index];
                      final isCall =
                      log['message'].toString().toLowerCase().contains('call');
                      final isWhatsApp =
                      log['message'].toString().toLowerCase().contains('whatsapp');

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Icon based on type
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isCall
                                  ? Colors.green.withOpacity(0.15)
                                  : isWhatsApp
                                  ? Colors.teal.withOpacity(0.15)
                                  : Colors.blue.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isCall
                                  ? Icons.call
                                  : isWhatsApp
                                  ? Icons.chat
                                  : Icons.info_outline,
                              color: isCall
                                  ? Colors.green
                                  : isWhatsApp
                                  ? Colors.teal
                                  : Colors.blue,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Message + Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log['message'] ?? 'Unknown Activity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Icon(Icons.calendar_today,
                                        size: 14,
                                        color: isDark
                                            ? Colors.white38
                                            : Colors.grey.shade600),
                                    const SizedBox(width: 4),
                                    Text(
                                      "${log['date']}  •  ${log['time']}",
                                      style: TextStyle(
                                        color: isDark
                                            ? Colors.white54
                                            : Colors.grey.shade600,
                                        fontSize: 13,
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
          ),
        );
      },
    );
  }

  Future<void> fetchFlats() async {
    setState(() => isLoading = true);
    final apiUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_data_calling_both_of_flat.php?subid=${widget.buildingId}";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["success"] == true) {
          setState(() {
            flats = jsonData["data"];
          });
        }
      }
    } catch (e) {
      await BugLogger.log(
          apiLink: apiUrl,
          error: e.toString(),
          statusCode: 500,
      );
      debugPrint("Error fetching flats: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logContact({
    required String message,
    required String id,
  }) async {
    final now = DateTime.now();
    final date =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
    final time =
        "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}";

    const apiUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/calling_for_future_property.php";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"message": message, "date": date, "time": time, "subid": id},
      );
      debugPrint("Log response: ${response.body}");
    } catch (e) {
      await BugLogger.log(
        apiLink: apiUrl,
        error: e.toString(),
        statusCode: 500,
      );
      debugPrint("Error logging contact: $e");
    }
  }

  Future<DateTime?> _fetchLatestLogDate(String id) async {
    final apiUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_api_for_calling_api_in_buidling.php?subid=$id";

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData["success"] == true && jsonData["data"] != null && jsonData["data"].isNotEmpty) {
          // Convert each log entry into DateTime and pick the newest
          DateTime? newest;
          for (final e in jsonData["data"]) {
            try {
              final dateStr = (e['date'] ?? '').toString(); // expected "YYYY-MM-DD"
              final timeStr = (e['time'] ?? '').toString(); // expected "HH:MM" or "HH:MM:SS"
              if (dateStr.isEmpty) continue;

              // Parse date parts
              final dateParts = dateStr.split('-');
              if (dateParts.length < 3) continue;
              final y = int.tryParse(dateParts[0]) ?? 0;
              final m = int.tryParse(dateParts[1]) ?? 1;
              final d = int.tryParse(dateParts[2]) ?? 1;

              // Parse time parts
              int hh = 0, mm = 0, ss = 0;
              if (timeStr.isNotEmpty) {
                final tParts = timeStr.split(':');
                if (tParts.isNotEmpty) hh = int.tryParse(tParts[0]) ?? 0;
                if (tParts.length > 1) mm = int.tryParse(tParts[1]) ?? 0;
                if (tParts.length > 2) ss = int.tryParse(tParts[2]) ?? 0;
              }

              final dt = DateTime(y, m, d, hh, mm, ss);
              if (newest == null || dt.isAfter(newest)) newest = dt;
            } catch (_) {
              // skip malformed entry
            }
          }
          return newest;
        }
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: apiUrl,
        error: e.toString(),
        statusCode:500,
      );
      debugPrint("Error fetching latest log date: $e");
    }
    return null;
  }

  String _formatDate(DateTime dt) {
    final dd = dt.day.toString().padLeft(2, '0');
    final mm = dt.month.toString().padLeft(2, '0');
    final yyyy = dt.year.toString();
    return "$dd-$mm-$yyyy";
  }

  String _generateNextContactMessage(DateTime? latest) {
    if (latest == null) return "❌ Never contacted this owner.";

    final nextContact = latest.add(const Duration(days: 30));
    final now = DateTime.now();
    final diffDays = nextContact.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (diffDays > 0) {
      return "Next contact on ${_formatDate(nextContact)} (in $diffDays days)";
    } else if (diffDays == 0) {
      return "Contact today (${_formatDate(nextContact)})";
    } else {
      final overdue = -diffDays;
      return "⚠️ Overdue by $overdue day${overdue > 1 ? 's' : ''} — should have contacted on ${_formatDate(nextContact)}";
    }
  }

  Widget _reminderCard({
    required bool isDark,
    required String id,
  }) {
    return FutureBuilder<DateTime?>(
      future: _fetchLatestLogDate(id),
      builder: (context, snapshot) {
        String msg;
        if (snapshot.connectionState == ConnectionState.waiting) {
          msg = "🔄 Checking last contact...";
        } else if (snapshot.hasError) {
          msg = "⚠️ Error fetching last contact.";
        } else {
          final latest = snapshot.data;
          msg = _generateNextContactMessage(latest);
        }

        Color bg = isDark ? Colors.white10 : Colors.grey.shade50;
        Color iconColor = isDark ? Colors.amberAccent : Colors.deepPurple;

        return Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.deepPurple.withOpacity(0.06), Colors.white12.withOpacity(0.02)]
                  : [Colors.purple.shade50, Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 0.8,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notifications_active_rounded, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  msg,
                  style: TextStyle(
                    fontSize: 14.5,
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        title: const Text("Contacts"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? Colors.white10 : Colors.black,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : flats.isEmpty
          ? Center(
        child: Text(
          "No Data Found.",
          style: TextStyle(
            fontSize: 18,
            color: isDark ? Colors.white70 : Colors.black54,
            fontWeight: FontWeight.w500,
          ),
        ),
      )
          : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // 🌇 Building Header Card
          _glassCard(
            isDark,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.apartment_rounded,
                        color:
                        isDark ? Colors.tealAccent : Colors.black87,
                        size: 22),
                    const SizedBox(width: 8),
                    Text(
                      "Building Overview",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color:
                        isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 20, thickness: 0.5),
                _infoRow("Building ID", widget.buildingId, isDark),
                const SizedBox(height: 12),
                Text(
                  "Owner Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: isDark
                        ? Colors.white70
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),
                _infoRow("Name", widget.ownerName, isDark),
                const SizedBox(height: 6),
                _contactButtons(
                  isDark: isDark,
                  number: widget.ownerNumber,
                  id: widget.buildingId,
                  onLog: _logContact,
                ),
                const SizedBox(height: 12),

                _reminderCard(isDark: isDark, id: widget.buildingId),

                const SizedBox(height: 12),
                _viewLogsCard(
                  isDark: isDark,
                  title: "View Logs",
                  onTap: () => _showLogsBottomSheet(
                      context, widget.buildingId),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Text(
            "Available Flats",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color:
              isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 12),

          // 🏠 Flat Cards
          ...flats.map((flat) {
            return _glassCard(
              isDark,
              margin: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.home_rounded,
                          color: isDark
                              ? Colors.blueAccent
                              : Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "Flat ${flat['Flat_number']} • ${flat['Floor_']}",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? Colors.white
                                : Colors.black87,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: flat['Buy_Rent']
                              .toString()
                              .toLowerCase()
                              .contains('rent')
                              ? Colors.orange.withOpacity(0.30)
                              : Colors.green.withOpacity(0.30),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          flat['Buy_Rent'],
                          style: TextStyle(
                            color: flat['Buy_Rent']
                                .toString()
                                .toLowerCase()
                                .contains('rent')
                                ? Colors.orangeAccent
                                : Colors.greenAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 20, thickness: 0.5),
                  _infoRow("Flat ID", flat['P_id'].toString(), isDark),
                  _infoRow("Price", "₹${flat['show_Price']}", isDark),
                  const SizedBox(height: 10),
                  Text(
                    "Owner Details",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color:
                      isDark ? Colors.white70 : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _infoRow(
                      "Name", flat['owner_name'] ?? "N/A", isDark),
                  const SizedBox(height: 6),
                  _contactButtons(
                    isDark: isDark,
                    number: flat['owner_number'] ?? "",
                    id: flat['P_id'].toString(),
                    onLog: _logContact,
                  ),
                  const SizedBox(height: 12),

                  _reminderCard(isDark: isDark, id: flat['P_id'].toString()),

                  const SizedBox(height: 12),
                  _viewLogsCard(
                    isDark: isDark,
                    title: "View Logs",
                    onTap: () => _showLogsBottomSheet(
                        context, flat['P_id'].toString()),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _glassCard(bool isDark, {required Widget child, EdgeInsetsGeometry? margin}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [Colors.white10.withOpacity(0.08), Colors.white12.withOpacity(0.15)]
                  : [Colors.white, Colors.grey.shade100],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isDark ? Colors.white12 : Colors.black12,
              width: 0.8,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? Colors.white10
                    : Colors.grey.withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  Widget _viewLogsCard({
    required bool isDark,
    required String title,
    required VoidCallback onTap,
  }) {return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.blueAccent.withOpacity(0.15), Colors.white12]
                : [Colors.blue.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: isDark ? Colors.white24 : Colors.black12,
            width: 0.8,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long_rounded,
                    color: isDark ? Colors.tealAccent : Colors.blueAccent),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: Colors.grey),
          ],
        ),
      ),
    );}

  Widget _infoRow(String title, String value, bool isDark) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$title: ",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade800,
              fontSize: 15,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _contactButtons({
    required bool isDark,
    required String number,
    required String id,
    required Function({required String message, required String id}) onLog,
  }) {return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.withOpacity(0.5),
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.call),
            label: const Text("Call"),
            onPressed: () async {
              await onLog(message: "Call made to $number", id: id);
              final Uri uri = Uri.parse("tel:$number");
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.5),
              foregroundColor: Colors.black,
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            icon: const Icon(Icons.chat_outlined),
            label: const Text("WhatsApp"),
            onPressed: () async {
              final phone = number.replaceAll(' ', '');
              final msg = Uri.encodeComponent("Hello!");
              final url = Uri.parse("https://wa.me/$phone?text=$msg");
              await onLog(
                  message: "WhatsApp message sent to $phone", id: id);
              if (await canLaunchUrl(url)) {
                await launchUrl(url,
                    mode: LaunchMode.externalApplication);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("WhatsApp not installed or invalid number"),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
