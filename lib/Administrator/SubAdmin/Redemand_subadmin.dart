import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Demand_2/redemand_form.dart';
import '../../utilities/bug_founder_fuction.dart';

class RedemandSubadmin extends StatefulWidget {
  final String redemandId;
  final String demandId;
  final bool fromNotification;
  const RedemandSubadmin({
    super.key,
    required this.redemandId,
    required this.demandId,
    this.fromNotification = false,
  });

  @override
  State<RedemandSubadmin> createState() => _RedemandDetailPageState();
}

class _RedemandDetailPageState extends State<RedemandSubadmin> {
  Map<String, dynamic>? _redemand;
  bool _isLoading = true;
  bool _assigning = false;
  int? _myUserId;
  String? _selectedName;
  String? _finalReason;
  bool _isSubmittingFinal = false;
  final TextEditingController _otherReasonCtrl = TextEditingController();
  bool _isDisclosing = false;
  String? _myName;




  final List<String> _nameList2 = [
    "Manish",
    "Abhay",
  ];



  final List<String> _nameList = [
    "Faizan Khan",
    "Ravi Kumar",
    "Sumit",
    "avjit"
  ];

  @override
  void initState() {
    super.initState();
    _fetchRedemandDetails();
    _loadUser();
  }



  Future<void> _loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _myName = prefs.getString("name");
      _myUserId = prefs.getInt("id");
    });
  }



  Future<void> _fetchRedemandDetails() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}"));

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);

        if (jsonRes["success"] == true &&
            jsonRes["data"] is List &&
            jsonRes["data"].isNotEmpty) {
          setState(() {
            _redemand = Map<String, dynamic>.from(jsonRes["data"][0]);
            _isLoading = false;
          });
        } else {
          await BugLogger.log(
            apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}",
            error: response.body.toString(),
            statusCode: response.statusCode ?? 0,
          );

          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}",
          error: e.toString(),
          statusCode: 500,
        );

        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _assignDemand() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select Name")));
      return;
    }

    setState(() => _assigning = true);

    try {
      final body = jsonEncode({
        "demand_id": widget.demandId,
        "fieldworker_name": _selectedName,
        "fieldworker_role": "FieldWorkar",
        "fieldworker_location": _redemand?["assigned_subadmin_location"] ?? ""
      });

      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_fieldworkar.php"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final jsonRes = jsonDecode(response.body);
      print(response.body);
      print(widget.demandId);

      if (response.statusCode == 200) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(jsonRes["message"] ?? "Assigned successfully"),
        ));

        await _fetchRedemandDetails();
      } else {
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_fieldworkar.php",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
        throw Exception(jsonRes["message"] ?? "Assignment failed");

      }
    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_fieldworkar.php",
        error: e.toString(),
        statusCode: 500,
      );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _assigning = false);
    }
  }

  Future<void> _transferReDemand({
    required String newOffice,
    required String newSubAdmin,
  })
  async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final myUserId = prefs.getInt("id");

      print("🆔 Demand ID: ${_redemand!["id"]}");
      print("👤 UserID: $myUserId");
      print("🏢 New Office: $newOffice");
      print("🧑 SubAdmin: $newSubAdmin");

      final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/share_redemand_to_subadmin.php",
      );

      /// ✅ FORM DATA (x-www-form-urlencoded)
      final response = await http.post(
        uri,
        body: {
          "id": _redemand!["id"].toString(),
          "assigned_subadmin_name": newSubAdmin,
          "assigned_subadmin_location": newOffice,
        },
      );

      print("📡 RESPONSE BODY: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200 && result["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Demand transferred successfully"),
          ),
        );


        Navigator.pop(context);



        // await _fetchRedemandDetails(); // refresh UI
      } else {
        throw Exception(result["message"] ?? "Transfer failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Transfer failed: $e"),
        ),
      );

      await BugLogger.log(
        apiLink:
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/share_redemand_to_subadmin.php",
        error: e.toString(),
        statusCode: 500,
      );
    }
  }


  String formatApiDate(dynamic raw) {
    if (raw == null) return "-";
    try {
      final str = raw is String ? raw : raw["date"];
      final dt = DateTime.parse(str);
      return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
    } catch (_) {
      return "-";
    }
  }

  String _month(int m) {
    const list = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return list[m];
  }

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
          Flexible(
            child: Text(
              (value?.isNotEmpty ?? false) ? value! : "-",
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  List<String> get _activeNameList {
    final loc = _redemand?["assigned_subadmin_location"]
        ?.toString()
        .toLowerCase() ?? "";

    final prefsName = _getMyName(); // logged-in subadmin name

    final baseList = loc.contains("sultanpur")
        ? _nameList
        : _nameList2;

    if (!baseList.contains(prefsName)) {
      return [prefsName, ...baseList];
    }
    return baseList;
  }

  String _getMyName() {
    return (_myUserId != null)
        ? (SharedPreferences.getInstance()
        .then((p) => p.getString("name")) as String)
        : "";
  }



  Widget _buildProgressDetailsCard(
      Map<String, dynamic> data,
      bool isDark,
      Color accent,
      ) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
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

          _infoRow("Parking", data["parking"]),
          _infoRow("Lift", data["lift"]),
          _infoRow("Furnished", data["furnished_unfurnished"]),
          _infoRow("Family Structure", data["family_structur"]),
          _infoRow("Family Members", data["family_member"]),
          _infoRow("Religion", data["religion"]),
          _infoRow("Visiting Date", data["visiting_dates"]),
          _infoRow("Vehicle Type", data["vichle_type"]),
          _infoRow("Vehicle No", data["vichle_no"]),
          _infoRow("Floor", data["floor"]),
          _infoRow("Shifting Date", data["shifting_date"]),
        ],
      ),
    );
  }

  // ---------------------- ASSIGN BOTTOM SHEET ---------------------- //
  void _openAssignSheet(Color accent, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey, borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 20),

                  Text("Assign Demand",
                      style: TextStyle(
                          color: accent, fontWeight: FontWeight.bold, fontSize: 18)),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    value: _selectedName,
                    onChanged: (v) => setState(() => _selectedName = v),
                    items: _activeNameList
                        .map(
                          (name) => DropdownMenuItem(
                        value: name,
                        child: Text(name),
                      ),
                    )
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        color: accent.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: accent),
                        const SizedBox(width: 10),
                        Expanded(
                            child: Text(_redemand?["assigned_subadmin_location"] ?? "--",
                                style: TextStyle(
                                    color: isDark ? Colors.white70 : Colors.black,
                                    fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _assigning ? null : _assignDemand,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: accent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: _assigning
                          ? const CircularProgressIndicator(color: Colors.black)
                          : const Text("Assign Demand",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),

                  const SizedBox(height: 10),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ---------------------- UI ---------------------- //
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool isUrgent = (_redemand?["mark"]?.toString() ?? "0") == "1";
    final accent = isUrgent ? Colors.redAccent : theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F5F0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("ReDemand Details",
            style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _redemand == null
          ? const Center(child: Text("No data found"))
          : _buildPage(isDark, accent),
    );
  }

  Widget _buildPage(bool isDark, Color accent) {
    final status = _redemand?["Status"]?.toLowerCase();

    final String? assignedFW = _redemand?["assigned_fieldworker_name"];

    final bool hasFieldworkerAssigned = assignedFW != null && assignedFW.isNotEmpty;
    final String myName = _myName ?? "";


    final bool isAssignedToMe =
        hasFieldworkerAssigned &&
            assignedFW!.toLowerCase() == myName.toLowerCase();


    final bool isDisclosed = status == "disclosed" || status == "redemand" ;


    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          _buildMainCard(isDark, accent),
          const SizedBox(height: 20),

          SizedBox(height: 10,),

          if (status == "progressing" || status == "disclosed")

            _buildProgressDetailsCard(_redemand!, isDark, accent),


          if (isAssignedToMe && status == "progressing")
            _buildCompletionSection(isDark, accent),


          // ✔ Show disclosed summary same as admin
          if (status == "disclosed")
            _buildDisclosed(isDark, accent),


          if (hasFieldworkerAssigned) ...[
            const SizedBox(height: 20),
            _buildAssignmentCard(
              title: "Assigned to Fieldworker",
              name: _redemand!["assigned_fieldworker_name"],
              role: _redemand!["assigned_fieldworker_role"],
              location: _redemand!["assigned_fieldworker_location"],
              date: _redemand!["fieldworker_assigned_at"],
              accent: Colors.green,
              isDark: isDark,
            ),
          ],


          // ✔ SubAdmin can assign ON LY when status == assign to subadmin
          if (status == "assign to subadmin")
            _buildAssignButton(accent, isDark),


          if (status == "assign to subadmin")
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.swap_horiz, color: Colors.white),
                label: const Text(
                  "Transfer to Another Office",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () => _openTransferBottomSheet(isDark),
              ),
            ),



          if (isAssignedToMe && status == "assigned to fieldworker" || status == "progressing")
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

          const SizedBox(height: 15),
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
                "Contact History",
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
    );
  }

  Widget _buildAssignmentCard({
    required String title,
    required String? name,
    required String? role,
    required String? location,
    required dynamic date,
    required Color accent,
    required bool isDark,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: accent.withOpacity(0.10),
        border: Border.all(color: accent.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.verified_rounded, color: accent, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: accent,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(name ?? "--",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87)),
                Text(role ?? "--",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(location ?? "--",
                        style:
                        TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    Text(
                      "Assigned: ${formatApiDate(date)}",
                      style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
      else{
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_calling_option_in_tenant_demand.php?subid=$id",
          error: res.body.toString(),
          statusCode: res.statusCode ?? 0,
        );
      }
    } catch (e) {
      print("❌ Error fetching logs: $e");
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_calling_option_in_tenant_demand.php?subid=$id",
        error: e.toString(),
        statusCode: 500,
      );
    }
    return [];
  }

  void _openContactSheet(BuildContext context, Color accent, bool isDark) async {
    final number = _redemand?["Tnumber"] ?? "";
    final name = _redemand?["Tname"] ?? "";
    final id = _redemand?["id"].toString() ?? "";

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
                    "Customer History",
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
                                message: "Try to Call ${maskPhone(number)}", id: id);

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
                                message: "Try to message on WhatsApp ${maskPhone(number)}",
                                id: id);

                            print("📌 Log Inserted → Opening WhatsApp...");
                            await refreshLogs();

                            final phone = normalizeWhatsAppNumber(number);
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


  Future<void> _logContact({
    required String message,
    required String id,
  })
  async {
    final now = DateTime.now();
    final date = "${now.year}-${now.month}-${now.day}";
    final time = "${now.hour}:${now.minute}";

    const apiUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/calling_option_for_fieldworkar.php";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('name');
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"message": message, "date": date, "time": time, "subid": id,"who_calling":storedName,},
      );

      debugPrint("Log saved: ${response.body}");
    } catch (e) {
      await BugLogger.log(
        apiLink: apiUrl,
        error: e.toString(),
        statusCode: 500,
      );
      debugPrint("Error logging contact: $e");
    }
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

  String maskPhone(String? phone) {
    if (phone == null || phone.length < 3) return "Hidden";
    return "XXXXXXX${phone.substring(phone.length - 3)}";
  }

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
                offset: const Offset(0, 5))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [accent, accent.withOpacity(0.7)])),
              child: Center(
                child: Text(
                  _redemand!["Tname"][0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_redemand?["Tname"] ?? "--",
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black)),
              Text(maskPhone(_redemand?["Tnumber"]),
                  style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 14)),
              Text("Created: ${formatApiDate(_redemand?["created_date"])}",
                  style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 13)),

              Text('ReDemand ID: ${_redemand?["id"].toString()}' ?? "0",
                  style: TextStyle(
                      color: isDark
                          ? Colors.white38
                          : Colors.black45,
                      fontSize: 13)),
            ]),
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
          ]),
          const SizedBox(height: 16),
          Divider(color: Colors.grey.withOpacity(0.3)),
          _infoRow("Type", _redemand?["Buy_rent"]),
          _infoRow("Location", _redemand?["Location"]),
          _infoRow("Price Range", _redemand?["Price"]),
          _infoRow("BHK Range", _redemand?["Bhk"]),
          _infoRow("Reference", _redemand?["Reference"]),
          _infoRow("Status", _redemand?["Status"]),
          _infoRow("Message", _redemand?["Message"]),
        ],
      ),
    );
  }

  Widget _buildAssignButton(Color accent, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _openAssignSheet(accent, isDark),
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          elevation: 6,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: const Text(
          "Assign Demand",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
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



  Widget _buildDisclosed(bool isDark, Color accent) {
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
                offset: const Offset(0, 5))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Disclosing Details",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
          const SizedBox(height: 16),
          _infoRow("Finishing Date", _redemand?["finishing_date"]),
          const SizedBox(height: 10),
          _infoRow("Final Reason", _redemand?["final_reason"]),
        ],
      ),
    );
  }

  void _openTransferBottomSheet(bool isDark) {
    final theme = Theme.of(context);
    String? selectedOffice;
    String? selectedSubAdmin;

    // Map office → subadmin
    final Map<String, String> officeMap = {
      "Sultanpur": "Saurabh yadav",
      "Rajpur Khurd": "Shivani Joshi",
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 45,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    "Transfer Demand",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  /// OFFICE SELECTION
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Office Location",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    items: officeMap.keys
                        .where((o) =>
                    o != _redemand?["assigned_subadmin_location"])
                        .map(
                          (office) => DropdownMenuItem(
                        value: office,
                        child: Text(office),
                      ),
                    )
                        .toList(),
                    onChanged: (v) {
                      setSheetState(() {
                        selectedOffice = v;
                        selectedSubAdmin = v == null ? null : officeMap[v];
                      });
                    },
                  ),

                  const SizedBox(height: 14),

                  /// AUTO SUBADMIN DISPLAY
                  if (selectedSubAdmin != null)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: theme.colorScheme.primary.withOpacity(0.12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.person, color: theme.colorScheme.primary),
                          const SizedBox(width: 10),
                          Text(
                            selectedSubAdmin!,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 22),

                  /// CONFIRM BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: selectedOffice == null
                          ? null
                          : () async {
                        Navigator.pop(context);
                        await _transferReDemand(
                          newOffice: selectedOffice!,
                          newSubAdmin: selectedSubAdmin!,
                        );
                      },
                      child: const Text(
                        "Confirm Transfer",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
  }

}