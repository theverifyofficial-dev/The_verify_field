import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Demand_2/redemand_detailpage.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';

import '../model/demand_model.dart';
import '../utilities/bug_founder_fuction.dart';
import 'demand_Form.dart';

class DemandDetail extends StatefulWidget {
  final String demandId;
  final bool fromNotification;
  const DemandDetail({
    super.key, required
    this.demandId,
    this.fromNotification = false,});

  @override
  State<DemandDetail> createState() => _AdminDemandDetailState();
}

class _AdminDemandDetailState extends State<DemandDetail> {
  Map<String, dynamic>? _demand;
  bool _isLoading = true;
  String? _finalReason;
  bool _isSubmittingFinal = false;
  final TextEditingController _otherReasonCtrl = TextEditingController();
  bool _isDisclosing = false;
  List<Map<String, dynamic>> _redemands = [];
  bool _isRedemandLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDemandDetails();
    _fetchRedemands();

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
          await BugLogger.log(
            apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
          error: response.body.toString(),
            statusCode: response.statusCode ?? 0,
          );
          setState(() {
            _isLoading = false;
          });
        }
      }
      else{
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
        error: e.toString(),
        statusCode: 500,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching details: $e")));
      }
      setState(() => _isLoading = false);
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}",
        error: e.toString(),
        statusCode: 500,
      );
    }
  }

  Future<void> _fetchRedemands() async {
    try {


      final prefs = await SharedPreferences.getInstance();
      final FieldName = prefs.getString('name') ?? "";
      final FieldLocation = prefs.getString('location') ?? "";
      print(FieldName);
      print(FieldLocation);

      if (FieldName.isEmpty || FieldLocation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info missing. Please login again.")),
        );
        return;
      }
      final encodedName = Uri.encodeQueryComponent(FieldName);
      final encodedLoc = Uri.encodeQueryComponent(FieldLocation);

      String url = "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_based_on_subid_fieldworkar_name_and_location.php?subid=${widget.demandId}&assigned_fieldworker_name=$encodedName&assigned_fieldworker_location=$encodedLoc";

      print(url);
      final res = await http.get(Uri.parse(url,));

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);
        if (json["success"] == true && json["data"] is List) {
          final List list = json["data"];

          // newest first
          list.sort((a, b) =>
              DateTime.parse(b["created_date"]["date"])
                  .compareTo(DateTime.parse(a["created_date"]["date"])));

          setState(() {
            _redemands = List<Map<String, dynamic>>.from(list);
            _isRedemandLoading = false;
          });
        } else {
          await BugLogger.log(
            apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_sub_id.php?subid=${widget.demandId}",
          error: res.body.toString(),
          statusCode: res.statusCode ?? 0,
          );
          _isRedemandLoading = false;
        }
      }
      else{
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_based_on_subid_fieldworkar_name_and_location.php?subid=${widget.demandId}&assigned_fieldworker_name=$encodedName&assigned_fieldworker_location=$encodedLoc",
          error: res.body.toString(),
          statusCode: res.statusCode ?? 0,
        );
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_sub_id.php?subid=${widget.demandId}",
        error: e.toString(),
        statusCode: 500,
      );
      _isRedemandLoading = false;
      if (mounted) {
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_based_on_subid_fieldworkar_name_and_location.php?subid=${widget.demandId}&assigned_fieldworker_name=encodedName&assigned_fieldworker_location=encodedLoc",
          error: e.toString(),
          statusCode: 500,
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load redemands")),
        );
      }
    }
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
      print("sending name: $storedName");
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


  Widget _fieldWorkerNotice(bool isDark) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.orange.withOpacity(isDark ? 0.15 : 0.12),
        border: Border.all(
          color: Colors.orange.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.engineering_rounded,
            color: Colors.orange.shade700,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Field Worker Added Demand",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "This demand was added directly by a field worker.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.orangeAccent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = _demand?["mark"] == "1";
    final Color accent =
    isUrgent ? Colors.redAccent : theme.colorScheme.primary;
    final status = _demand?["Status"]?.toLowerCase();

    bool _isAddedByFieldWorker(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == "true";
      return false;
    }
    final bool addedByField =
    _isAddedByFieldWorker(_demand?["by_field"]);

    final bool isDisclosed = _demand?["Status"]?.toString().toLowerCase() == "disclosed" || _demand?["Status"]?.toString().toLowerCase() == "redemand" ;

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


      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _demand == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            if (_redemands.isNotEmpty) ...[
              const SizedBox(height: 22),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Redemands",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: accent,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              _isRedemandLoading
                  ? const CircularProgressIndicator()
                  : Column(
                children: List.generate(_redemands.length, (index) {
                  final bool isLatest = index == 0;

                  final TenantDemandModel d =
                  TenantDemandModel.fromJson(_redemands[index]);

                  return _redemandListTile(
                    d,
                    theme,
                    isLatest,
                  );
                }),


              ),
            ],

            if (addedByField) _fieldWorkerNotice(isDark),

            if (status == "redemand")
              infoBanner(
                icon: Icons.repeat,
                color: Colors.blue,
                title: "Demand Reopened",
                message:
                "A new redemand was added after the parent demand was disclosed. "
                    "Work is active again.",
              ),


            Divider(),
            _buildTenantCard(isDark, accent),
            const SizedBox(height: 24),

            if (status == "progressing" || status == "disclosed" || status == "redemand")
              _buildProgressDetailsCard(_demand!, isDark, accent),

            if (status == "progressing")
              _buildCompletionSection(isDark, accent),

            if (status == "disclosed" || status == "redemand")
              _buildFinalSummarySection(isDark, accent),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDisclosed
                      ? Colors.grey.shade300   // 🔒 disabled state
                      : theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isDisclosed
                    ? null // 🔒 fully disabled
                    : () {
                  if (_demand == null) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TenantDemandUpdatePage(demand: _demand!),
                    ),
                  ).then((_) => _fetchDemandDetails());
                },
                child: Text(
                  isDisclosed  ? "Demand Closed" : "Add More Details",
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            if (status != "disclosed" && status != "redemand")

              SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.dangerous, color: Colors.white),
                label: const Text(
                  "Return to Sub Administrator",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                onPressed: () => _showReturnConfirmDialog(),
              ),
            ),

            const SizedBox(height: 24),

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

  Widget infoBanner({
    required IconData icon,
    required Color color,
    required String title,
    required String message,
    bool isDark = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: color.withOpacity(isDark ? 0.15 : 0.12),
        border: Border.all(
          color: color.withOpacity(0.45),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 26,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$message ",
                        style: TextStyle(
                          fontSize: 13,
                          color: isDark
                              ? color.withOpacity(0.9)
                              : color.withOpacity(0.85),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: Icon(
                          Icons.sentiment_satisfied_alt,
                          size: 16,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
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
              _demand?["finishing_date"] ?? "-",
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
              _demand?["final_reason"] ?? "-",
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

  Widget _buildRibbon(String text, Color c1, Color c2) {
    return Positioned(
      top: 12,
      left: -30,
      child: Transform.rotate(
        angle: -0.785398,
        child: Container(
          width: 140,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [c1, c2]),
            boxShadow: [
              BoxShadow(
                color: c1.withOpacity(0.4),
                blurRadius: 6,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            "$text   ",
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              fontSize: 11.5,
            ),
          ),
        ),
      ),
    );
  }


  Widget _redemandListTile(
      TenantDemandModel d,
      ThemeData theme,
      bool isFirst,
      ) {
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = d.mark == "1";
    final Color baseColor =
    isUrgent ? Colors.redAccent : theme.colorScheme.primary;

    return Stack(
      children: [

        if (d.status.toLowerCase() == "disclosed")
          Positioned(
            top: 12,
            left: -30,
            child: Transform.rotate(
              angle: -0.785398, // -45 degrees in radians
              child: Container(
                width: 140,
                padding: const EdgeInsets.symmetric(vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.red.shade500,
                      Colors.red.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.4),
                      blurRadius: 6,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  "DISCLOSED   ",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.2,
                    fontSize: 11.5,
                  ),
                ),
              ),
            ),
          ),

        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => field_RedemandDetailPage(redemandId: d.id.toString()),
              ),
            ).then((_) {
              _fetchRedemands();
              _fetchDemandDetails();
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              color: baseColor.withOpacity(isDark ? 0.35 : 0.85),
              boxShadow: [
                BoxShadow(
                  color: isUrgent
                      ? Colors.redAccent.withOpacity(0.25)
                      : Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isUrgent
                    ? Colors.redAccent.withOpacity(0.6)
                    : Colors.white.withOpacity(0.05),
                width: 1.2,
              ),
            ),
            child: ListTile(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              leading: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isUrgent
                        ? [
                      Colors.redAccent,
                      Colors.redAccent.shade700,
                    ]
                        : [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isUrgent
                          ? Colors.redAccent.withOpacity(0.3)
                          : theme.colorScheme.primary.withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    d.tname.isNotEmpty ? d.tname[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      d.tname,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // 🔥 NEWEST BADGE HERE
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? Colors.redAccent.withOpacity(0.8)
                          : theme.colorScheme.primary.withOpacity(0.45),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(d.buyRent.toUpperCase(),
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${d.location} • ${d.bhk} ",
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text("₹ ${d.price}",
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontSize: 14)),
                    if (d.id.toString().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("ReDemand ID: ${d.id}",
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.white38
                                        : Colors.black45,
                                    fontSize: 13)),
                            Text(
                              formatApiDate(d.createdDate),
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            )

                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ----- Existing ribbons -------
        if (d.status.toLowerCase() == "assigned to fieldworker")
          _buildRibbon("NEW", Colors.green.shade500, Colors.green.shade700),
        if (d.status.toLowerCase() == "disclosed")
          _buildRibbon("DISCLOSED", Colors.red.shade500, Colors.red.shade700),
        if (d.status.toLowerCase() == "progressing")
          _buildRibbon("Progressing", Colors.green.shade500, Colors.green.shade700),

      ],
    );
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
                "Disclose Demand",
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
            "Are you sure you want to disclose this demand? "
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
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php"),
        body: {
          "id": _demand!["id"].toString(),
          "finishing_date": finishingDateTime,
          "final_reason": finalReasonToSend,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Final Update Submitted"),
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php",
        error: e.toString(),
        statusCode: 500,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Error: $e"),
        ),
      );
    }

    setState(() => _isSubmittingFinal = false);
  }

  void _showReturnConfirmDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          title: const Text("Confirm Action"),
          content: const Text(
            "Are you sure you want to Return this demand to Sub Administrator? "
                "\nThis action cannot be undone.",
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
                _returnDemand();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _returnDemand() async {
    try {
      print("Returning Demand ID: ${_demand!["id"]}");

      final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/fieldworkar_return_demand_to_subadmin.php",
      );

      /// ✅ FORM DATA (x-www-form-urlencoded)
      final response = await http.post(
        uri,
        body: {
          "id": _demand!["id"].toString(),
        },
      );

      print("📡 RESPONSE BODY: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text("Demand Returned successfully"),
          ),
        );

        Navigator.pop(context);

      } else {
        throw Exception(result["message"] ?? "Returning failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Returning failed: $e"),
        ),
      );

      await BugLogger.log(
        apiLink:
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/fieldworkar_return_demand_to_subadmin.php",
        error: e.toString(),
        statusCode: 500,
      );
    }
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
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_calling_option_in_tenant_demand.php?subid=$id",
        error: e.toString(),
        statusCode: 500,
      );
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
              print("✅ Logs Update  d: ${logs.length}");
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

  String maskPhone(String? phone) {
    if (phone == null || phone.length < 3) return "Hidden";
    return "XXXXXXX${phone.substring(phone.length - 3)}";
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
                  Text(maskPhone(_demand?["Tnumber"]),
                      style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 14)),

                  Text(
                    "Created: ${formatApiDate(_demand!["created_date"])}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                  Text('Demand ID: ${_demand?["id"].toString()}' ?? "0",
                      style: TextStyle(
                          color: isDark
                              ? Colors.white38
                              : Colors.black45,
                          fontSize: 13)),



                ]),
          ),
          if (_demand?["mark"] == "1") ...[
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
        const SizedBox(height: 12),
        Divider(color: Colors.grey.withOpacity(0.3)),

        _infoRow("Buy / Rent", _demand?["Buy_rent"]),
        _infoRow("Location", _demand?["Location"]),
        _infoRow("Price Range", _demand?["Price"]),
        _infoRow("BHK Range", _demand?["Bhk"]),
        // _infoRow("Reference", _demand?["Reference"]),
        _infoRow("Status", _demand?["Status"]),
        _infoRow("Message", _demand?["Message"]),
      ]),
    );
  }


  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13.5,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13.5),
            ),
          ),
        ],
      ),
    );
  }

}
