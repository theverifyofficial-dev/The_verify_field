import 'dart:convert';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:verify_feild_worker/Demand_2/redemand_form.dart';
import '../utilities/bug_founder_fuction.dart';
import 'Demand_detail.dart';

class ReDemandDetailPage extends StatefulWidget {
  final String RedemandId;
  final bool fromNotification;
  final bool isReadOnly; // 🔥 NEW
  const ReDemandDetailPage({
    super.key, required
    this.RedemandId,
    this.fromNotification = false,
    this.isReadOnly = false,
  });

  @override
  State<ReDemandDetailPage> createState() => ReDemandDetailPageState();
}

class ReDemandDetailPageState extends State<ReDemandDetailPage> {

  static const _textPrimary = Color(0xFF111827);   // strong black
  static const _textSecondary = Color(0xFF374151); // dark grey
  static const _borderColor = Color(0xFFE5E7EB);   // visible border
  static const _cardBg = Colors.white;

  Map<String, dynamic>? _demand;
  bool _isLoading = true;
  static const borderColor = Color(0xFFE5E7EB);
  String? _finalReason;
  bool _isSubmittingFinal = false;
  final TextEditingController _otherReasonCtrl = TextEditingController();
  bool _isDisclosing = false;

  @override
  void initState() {
    super.initState();
    _fetchReDemandDetails();
  }

  Future<void> _fetchReDemandDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/display_redemand_based_on_id.php?id=${widget.RedemandId}"));

      AppLogger.api("Redemand ID: ${widget.RedemandId}");

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
      else{
        await BugLogger.log(
          apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.RedemandId}",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching details: $e")));
      }
      setState(() => _isLoading = false);
      await BugLogger.log(
        apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/display_redemand_based_on_id.php?id=${widget.RedemandId}",
        error: e.toString(),
        statusCode: 500,
      );
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
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/add_redemand_call_optiom.php";

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final storedName = prefs.getString('name');
      AppLogger.api("sending name: $storedName");
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {"message": message, "date": date, "time": time, "subid": id,"who_calling":storedName,},
      );

      AppLogger.api("Log saved: ${response.body}");
    } catch (e) {
      await BugLogger.log(
        apiLink: apiUrl,
        error: e.toString(),
        statusCode: 500,
      );
      AppLogger.api("Error logging contact: $e");
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
    isUrgent ? Colors.redAccent : Colors.black87;
    final status = _demand?["Status"]?.toLowerCase();

    bool _isAddedByFieldWorker(dynamic value) {
      if (value == null) return false;
      if (value is bool) return value;
      if (value is String) return value.toLowerCase() == "true";
      return false;
    }
    final bool addedByField =
    _isAddedByFieldWorker(_demand?["by_field"]);
    AppLogger.api(_demand?["Status"]);
    final bool isDisclosed = _demand?["Status"]?.toString().toLowerCase() == "disclosed" || _demand?["Status"]?.toString().toLowerCase() == "redemand" ;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ReDemand Details",
          style:
          TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),


      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _demand == null
          ? const Center(child: Text("No data found",style: TextStyle(color: Colors.grey),))
          : Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
              child: Column(
                children: [
                  if (addedByField) _fieldWorkerNotice(isDark),

                  _buildTenantCard(isDark, accent),

                  if (status == "assigned to fieldworker" || status == "progressing" || status == "disclosed")
                    _buildProgressDetailsCard(_demand!, isDark, accent),

                  if (status == "progressing")
                    if (!widget.isReadOnly)
                      _buildCompletionSection(isDark, accent),


                  if (status == "disclosed")
                    _buildFinalSummarySection(isDark, accent),


                  if (widget.isReadOnly)
                    _buildHandlerInfoCard(), // 🔥 ADD THIS


                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.history, color: Colors.white),
                      label: const Text(
                        "View Original Demand",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                        onPressed: () {
                          final mainId = _demand?["subid"];

                          if (mainId == null || mainId.toString().trim().isEmpty) {
                            Fluttertoast.showToast(
                              msg: "Missing mainID",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.black87,
                              textColor: Colors.white,
                              fontSize: 14,
                            );
                            return;
                          }

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DemandDetail(
                                demandId: mainId.toString(),
                                isReadOnly: true,
                              ),
                            ),
                          );
                        }
                        ),
                  ),

                  const SizedBox(height: 10),


                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () =>
                          _openContactSheet(context, Colors.red, false),

                      icon: const Icon(Icons.call, color: Colors.white),
                      label: const Text("Contact",
                          style: TextStyle(color: Colors.white)),

                    ),
                  ),

                ],
              ),
            ),
          ]
      ),


      bottomNavigationBar: widget.isReadOnly ? null : _bottomActions(isDisclosed),

    );
  }

  Widget _buildHandlerInfoCard() {
    final d = _demand!;

    final name = d["assigned_fieldworker_name"];
    final location = d["assigned_fieldworker_location"];
    final assignedBy = d["admin_name"];

    // ❌ if nothing → don't show
    if (name == null && location == null) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 TITLE
          const Text(
            "Handled By",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 12),

          /// 🔥 NAME
          _handlerRow(Icons.person, "Fieldworker", name),

          /// 🔥 NUMBER
          _handlerRow(Icons.call, "Location", location),

          /// 🔥 ADMIN (optional)
          if (assignedBy != null)
            _handlerRow(Icons.admin_panel_settings, "Assigned By", assignedBy),
        ],
      ),
    );
  }

  Widget _handlerRow(IconData icon, String label, dynamic value) {
    if (value == null || value.toString().isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFDC2626)),
          const SizedBox(width: 10),

          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),

          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomActions(bool isDisclosed) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [

          /// ADD DETAILS
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isDisclosed
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        RedemandForm(demand: _demand!),
                  ),
                ).then((_) => _fetchReDemandDetails());
              },
              child: Text(
                isDisclosed ? "Closed" : "Add Details",
                style:  TextStyle(color: isDisclosed
                    ? Colors.black54
                    : Colors.white
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          /// NOT INTERESTED
          Expanded(
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,

                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.block, color: Colors.white),
              label:  Text("Not Interested",
                  style: TextStyle(color:  isDisclosed
                      ? Colors.black54
                      : Colors.white)),
              onPressed: isDisclosed ? null : _openNotInterestedSheet,
            ),
          ),


        ],
      ),
    );
  }

  void _openNotInterestedSheet() {
    final TextEditingController reasonCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // 🔥 important
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white, // ✅ pure light theme
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 DRAG HANDLE (pro touch)
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              /// 🔥 TITLE
              const Text(
                "Not Interested",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827), // strong black
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Tell us why you are rejecting this Redemand",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 14),

              /// 🔥 INPUT FIELD
              TextField(
                controller: reasonCtrl,
                maxLines: 3,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Enter reason...",
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFF9FAFB),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// 🔥 SUBMIT BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // 🔥 premium look
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.pop(ctx);

                    _finalReason = "Not Interested";
                    _otherReasonCtrl.text = reasonCtrl.text;

                    await _submitFinalUpdate();
                  },
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFinalSummarySection(bool isDark, Color accent) {

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 HEADER WITH ICON
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(Icons.verified, color: accent, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                "Disclosing Details",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          /// 🔥 FINISHING DATE
          _summaryItem(
            title: "Finishing Date",
            value: _formatDate(_demand?["finishing_date"]),
          ),

          const SizedBox(height: 14),

          /// 🔥 FINAL REASON
          _summaryItem(
            title: "Final Reason",
            value: _demand?["final_reason"] ?? "-",
            highlight: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryItem({
    required String title,
    required String value,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: highlight
            ? const Color(0xFFDC2626).withOpacity(0.05)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? const Color(0xFFDC2626).withOpacity(0.3)
              : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: highlight
                  ? const Color(0xFFDC2626)
                  : const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.isEmpty) return "-";

    try {
      final d = DateTime.parse(raw);
      return DateFormat("dd MMM yyyy").format(d);
    } catch (_) {
      return raw;
    }
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

  bool _isEmpty(dynamic value) {
    if (value == null) return true;
    final v = value.toString().trim().toLowerCase();
    return v.isEmpty || v == "null" || v == "--";
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
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        border: Border.all(color: _borderColor),
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

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.6,
            children: [

              /// BASIC
              _infoTile("Parking", data["parking"]),
              _infoTile("Lift", data["lift"]),
              _infoTile("Furnished", data["furnished_unfurnished"]),

              /// FAMILY
              _infoTile("Family Type", data["family_structur"]),
              _infoTile("Members", data["family_member"]),
              _infoTile("Persons", data["count_of_person"]),

              /// PROPERTY
              _infoTile("Floor", data["floor"]),
              _infoTile("Religion", data["religion"]),

              /// VEHICLE
              _infoTile("Vehicle Type", data["vichle_type"]),
              _infoTile("Vehicle No", data["vichle_no"]),

              /// DATES
              _infoTile("Visit Date", data["visiting_dates"]),
              _infoTile("Shift Date", data["shifting_date"]),

              /// TYPE
              _infoTile("Type", data["Buy_rent"]),
            ],
          ),

          if (data["furnished_item"] != null &&
              data["furnished_item"].toString().isNotEmpty &&
              data["furnished_item"] != "--")
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Furniture",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _formatFurniture(data["furnished_item"]),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            ),

        ],
      ),
    );
  }

  String _formatFurniture(String? raw) {
    if (raw == null || raw.isEmpty || raw == "--") return "-";

    try {
      final decoded = jsonDecode(raw);

      if (decoded is Map) {
        return decoded.entries
            .map((e) => "${e.key} (${e.value})")
            .join(", ");
      }
    } catch (_) {}

    return raw;
  }

  Widget _infoTile(String label, dynamic value) {
    final isEmpty = _isEmpty(value);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),

        /// 🔴 RED BORDER IF EMPTY
        border: Border.all(
          color: isEmpty ? Colors.red : Colors.grey.shade300,
          width: isEmpty ? 1.2 : 1,
        ),

        /// 🔴 LIGHT RED BACKGROUND (subtle)
        color: isEmpty ? Colors.red.withOpacity(0.05) : Colors.white,
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isEmpty ? Colors.red : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            _fmt(value),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isEmpty ? Colors.red.shade700 : Colors.black87,
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
        color: _cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _borderColor), // ✅ ADD THIS
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
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
              color: Colors.black87,
            ),
          ),


          const SizedBox(height: 18),

          // Final Reason
          Text("Final Reason",
              style: theme.textTheme.titleSmall!
                  .copyWith(fontWeight: FontWeight.w600,color: Colors.black87)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _showFinalReasonSheet(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _borderColor),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _finalReason ?? "Select Reason",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                  Icon(Icons.keyboard_arrow_down,
                      size: 22, color: Colors.black87),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),
          TextField(
            style: TextStyle(color: Colors.black87),
            controller: _otherReasonCtrl,
            decoration: InputDecoration(
              labelText: "Enter Reason Details",
              labelStyle: TextStyle(color: Colors.black87),
              // 🔥 BORDER
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: borderColor, width: 1.5),
              ),
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
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: (_isDisclosing || _isSubmittingFinal)
                  ? null
                  : _showDiscloseConfirmDialog,
              child: _isDisclosing
                  ? const CircularProgressIndicator(color: Colors.black, strokeWidth: 2)
                  : const Text(
                "Disclose ReDemand",
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
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔥 ICON (STRONG VISUAL SIGNAL)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 14),

                /// 🔥 TITLE
                const Text(
                  "Confirm Disclosure",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 8),

                /// 🔥 MESSAGE
                const Text(
                  "This will permanently mark the Redemand as completed.\nYou cannot undo this action.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 18),

                /// 🔥 ACTION BUTTONS
                Row(
                  children: [

                    /// CANCEL
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: const BorderSide(color: Color(0xFFE5E7EB)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),

                    const SizedBox(width: 10),

                    /// CONFIRM
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFDC2626),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          _submitFinalUpdate();
                        },
                        child: const Text(
                          "Confirm",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// 🔥 HANDLE
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

              /// 🔥 TITLE
              const Text(
                "Select Final Reason",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF111827),
                ),
              ),

              const SizedBox(height: 14),

              /// 🔥 GRID STYLE OPTIONS (PRO LOOK)
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: reasons.map((e) {
                  final isSelected = _finalReason == e;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _finalReason = e);
                      Navigator.pop(ctx);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFDC2626).withOpacity(0.1)
                            : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFDC2626)
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Text(
                        e,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFFDC2626)
                              : const Color(0xFF111827),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
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
        (_finalReason ?? "Not Interested") +
            (_otherReasonCtrl.text.trim().isEmpty
                ? ""
                : " - ${_otherReasonCtrl.text.trim()}");

    setState(() => _isSubmittingFinal = true);

    try {
      final response = await http.post(
        Uri.parse(
            "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/update_api_redemand.php"),
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
        apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/update_api_tenant_demand.php",
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

  Future<List<dynamic>> _fetchLogs(String id) async {
    try {
      final url =
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_api_for_redemand.php?subid=$id";

      AppLogger.api("📡 Fetching Logs: $url");

      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body["success"] == true && body["data"] is List) {
          AppLogger.api("📥 Logs fetched: ${body["data"].length}");
          return body["data"];
        }
      }
      else{
        await BugLogger.log(
          apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_api_for_redemand.php?subid=$id",
          error: res.body.toString(),
          statusCode: res.statusCode ?? 0,
        );
      }
    } catch (e) {
      AppLogger.api("❌ Error fetching logs: $e");
      await BugLogger.log(
        apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_api_for_redemand.php?subid=$id",
        error: e.toString(),
        statusCode: 500,
      );
    }
    return [];
  }

  void _openContactSheet(BuildContext context, Color accent, bool isDark) async {
    final number = _demand?["Tnumber"] ?? "";
    final name = _demand?["Tname"] ?? "";
    final BuyRent = _demand?["Buy_rent"] ?? "";
    final location = _demand?["Location"] ?? "Sultanpur";
    final Bhk = _demand?["Bhk"] ?? "";
    final id = _demand?["id"].toString() ?? "";
    final nextWord = Bhk.contains('commercial') ? 'Space' : 'Flat';

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
              AppLogger.api("🔄 Refreshing Logs...");
              final updated = await _fetchLogs(id);
              setSheetState(() {
                logs = updated;
              });
              AppLogger.api("✅ Logs Update  d: ${logs.length}");
            }

            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _cardBg,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _borderColor), // ✅ ADD THIS
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                  )
                ],
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
                  if (!widget.isReadOnly)
                    Row(
                      children: [
                        Expanded(
                          child: _contactButton(
                            label: "Call",
                            color: Colors.blue,
                            icon: Icons.call,
                            onTap: () async {
                              AppLogger.api("☎ CALL tapped");

                              await _logContact(
                                  message: "Try to Call ${maskPhone(number)}", id: id);

                              AppLogger.api("📌 Log Inserted → Calling...");
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
                              AppLogger.api("💬 WhatsApp tapped");

                              await _logContact(
                                  message: "Try to message on WhatsApp ${maskPhone(number)}",
                                  id: id);

                              AppLogger.api("📌 Log Inserted → Opening WhatsApp...");
                              await refreshLogs();

                              final phone = normalizeWhatsAppNumber(number);
                              final txt = Uri.encodeComponent(
                                  "Hello $name, Looking for a ${Bhk} $nextWord for $BuyRent in $location? "
                                      "Feel free to contact us for further details.\n\nRegards,\nVerify Properties");
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

                  Row(
                    children: [
                      Icon(Icons.history, color: accent, size: 22),
                      const SizedBox(width: 8),
                      Text(
                        "Contact Logs History",
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
    return
      SizedBox(
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
    final d = _demand!;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 TOP ROW (ID + URGENT + EDIT)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "#DM-${d["id"]}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  if (d["mark"] == "1") ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "URGENT",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ],
              ),

            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 NAME + PRICE (MAIN FOCUS)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  d["Tname"] ?? "Unknown",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: _textPrimary,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Text(
                _formatPrice(d["Price"]),
                style: const TextStyle(
                  color: Colors.green,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 CHIPS (COMPACT)
          Wrap(
            spacing: 6,
            children: [
              _chip(d["Buy_rent"]),
              _chip(d["Bhk"]),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 LOCATION
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  d["Location"] ?? "-",
                  style: const TextStyle(fontSize: 13,color: Colors.grey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 🔥 DATE
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                formatApiDate(d["created_date"]),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 6),

          if (d["Message"] != null &&
              d["Message"].toString().trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.message, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      d["Message"].toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF374151),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: Color(0xFF334155),
        ),
      ),
    );
  }

  String _formatPrice(String? raw) {
    if (raw == null || raw.isEmpty) return "—";

    try {
      final parts = raw.split("-");
      if (parts.length != 2) return raw;

      String format(int n) {
        if (n >= 10000000) return "₹${(n / 10000000).toStringAsFixed(1)}Cr";
        if (n >= 100000) return "₹${(n / 100000).toStringAsFixed(0)}L";
        if (n >= 1000) return "₹${(n / 1000).toStringAsFixed(0)}k";
        return "₹$n";
      }

      final start = int.tryParse(parts[0]) ?? 0;
      final end = int.tryParse(parts[1]) ?? 0;

      return "${format(start)} – ${format(end)}";
    } catch (_) {
      return raw;
    }
  }


}
