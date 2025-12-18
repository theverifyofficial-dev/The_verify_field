import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;

class RedemandDetailPage extends StatefulWidget {
  final String redemandId;
  const RedemandDetailPage({super.key, required this.redemandId});

  @override
  State<RedemandDetailPage> createState() => _RedemandDetailPageState();
}

class _RedemandDetailPageState extends State<RedemandDetailPage> {
  Map<String, dynamic>? _redemand;
  bool _isLoading = true;
  bool _assigning = false;
  String? _selectedName;
  final List<String> _nameList = ["Saurabh Yadav"];

  @override
  void initState() {
    super.initState();
    _fetchRedemandDetails();
  }

  Future<void> _fetchRedemandDetails() async {
    setState(() => _isLoading = true);
    try {
      // NOTE: details API uses id = redemand id
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=${widget.redemandId}"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonRes = jsonDecode(response.body);
        if (jsonRes["success"] == true &&
            jsonRes["data"] is List &&
            (jsonRes["data"] as List).isNotEmpty) {
          setState(() {
            _redemand = Map<String, dynamic>.from(jsonRes["data"][0]);
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching details: $e")));
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _assignDemand() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select Name")));
      return;
    }

    setState(() => _assigning = true);
    try {
      final body = jsonEncode({
        "demand_id": widget.redemandId,
        "subadmin_role": "Sub Administrator",
        "subadmin_name": _selectedName,
        "subadmin_location": _redemand?["Location"] ?? ""
      });

      final response = await http.post(
        Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_subadmin.php'),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context); // ✅ CLOSE BOTTOM SHEET

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(result["message"] ?? "Assigned successfully"),
            ),
          );
        }

        await _fetchRedemandDetails(); // refresh UI after closing
      }
      else {
        throw Exception(result["message"] ?? "Assignment failed");
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _assigning = false);
    }
  }

  String formatApiDate(dynamic raw) {
    if (raw == null) return "-";
    try {
      final dateStr = raw is String ? raw : (raw["date"] ?? "");
      final dt = DateTime.parse(dateStr);
      return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
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

  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500)),
        Flexible(child: Text((value?.isNotEmpty ?? false) ? value! : "-", textAlign: TextAlign.right, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500))),
      ]),
    );
  }

  void _openAssignBottomSheet(Color accent, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
                boxShadow: [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 18),
                  Text("Assign Demand", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: "Select Name", border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                    value: _selectedName,
                    onChanged: (v) => setState(() => _selectedName = v),
                    items: _nameList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: accent.withOpacity(0.15)),
                    child: Row(children: [Icon(Icons.location_on, color: accent, size: 22), const SizedBox(width: 12), Expanded(child: Text(_redemand?["Location"] ?? "--", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15, fontWeight: FontWeight.w600)))]),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _assigning ? null : _assignDemand,
                      style: ElevatedButton.styleFrom(backgroundColor: accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _assigning ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.3)), const SizedBox(width: 12), Text("Assigning...", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))]) : Text("Assign Now", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = (_redemand?["mark"]?.toString() ?? "0") == "1";
    final Color accent = isUrgent ? Colors.redAccent : theme.colorScheme.primary;
    final status = _redemand?["Status"]?.toLowerCase();
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F5F0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("ReDemand Details", style: TextStyle(color: Colors.white)),
        leading: IconButton(icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white), onPressed: () => Navigator.pop(context)),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _redemand == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // redemand card — same as parent card UI & logic
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: isDark ? Colors.white.withOpacity(0.05) : Colors.white, boxShadow: [BoxShadow(color: accent.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 5))]),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Container(
                    height: 55,
                    width: 55,
                    decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [accent, accent.withOpacity(0.7)])),
                    child: Center(child: Text((_redemand?["Tname"]?.toString().isNotEmpty ?? false) ? _redemand!["Tname"].toString()[0].toUpperCase() : "?", style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18))),
                  ),
                  const SizedBox(width: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_redemand?["Tname"] ?? "Unknown", style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
                    Text(_redemand?["Tnumber"] ?? "-", style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
                    Text("Created: ${formatApiDate(_redemand?["created_date"])}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13))
                  ]),
                ]),
                const SizedBox(height: 16),
                Divider(color: Colors.grey.withOpacity(0.3)),
                _infoRow("Type", _redemand?["Buy_rent"]?.toString()),
                _infoRow("Location", _redemand?["Location"]?.toString()),
                _infoRow("Price Range", _redemand?["Price"]?.toString()),
                _infoRow("BHK Range", _redemand?["Bhk"]?.toString()),
                _infoRow("Reference", _redemand?["Reference"]?.toString()),
                _infoRow("Status", _redemand?["Status"]?.toString()),
                _infoRow("Message", _redemand?["Message"]?.toString()),
              ]),
            ),

            const SizedBox(height: 18),

            // Assigned / Disclosed ribbons and sections same as AdminDemandDetail
            if (status == "assign to subadmin") ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.green.withOpacity(0.10), border: Border.all(color: Colors.green.withOpacity(0.4))),
                child: Row(children: [
                  Icon(Icons.verified_rounded, color: Colors.green, size: 26),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Successfully Assigned", style: TextStyle(color: Colors.green.shade700, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("Assigned to: ${_redemand!["assigned_subadmin_name"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Text("${_redemand!["assigned_subadmin_role"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("${_redemand!["assigned_subadmin_location"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                      Text("Assign: ${formatApiDate(_redemand!["subadmin_assigned_at"] ?? "")}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13))
                    ]),
                  ]))
                ]),
              ),
            ],

            if (status == "assigned to fieldworker") ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), color: Colors.green.withOpacity(0.10), border: Border.all(color: Colors.green.withOpacity(0.4))),
                child: Row(children: [
                  Icon(Icons.verified_rounded, color: Colors.green, size: 26),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Successfully Assigned", style: TextStyle(color: Colors.green.shade700, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("Assigned to: ${_redemand!["assigned_fieldworker_name"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Text("${_redemand!["assigned_fieldworker_role"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("${_redemand!["assigned_fieldworker_location"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                      Text("Assign: ${formatApiDate(_redemand!["fieldworker_assigned_at"] ?? "")}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13))
                    ]),
                  ]))
                ]),
              ),
            ],

            if (status == "New") ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _openAssignBottomSheet(accent, isDark),
                  style: ElevatedButton.styleFrom(backgroundColor: accent.withOpacity(0.85), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 6, padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: Text("Assign Demand", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ),
            ],

            if (status == "progressing" || status == "disclosed")

              _buildProgressDetailsCard(_redemand!, isDark, accent),

            if (status == "disclosed")
              Container(
                padding: const EdgeInsets.all(18),
                margin: const EdgeInsets.only(top: 20),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), color: isDark ? Colors.white.withOpacity(0.06) : Colors.white, boxShadow: [BoxShadow(color: accent.withOpacity(0.2), blurRadius: 18, offset: const Offset(0, 5))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("Disclosing Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
                  const SizedBox(height: 16),
                  Text("Finishing Date", style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: theme.colorScheme.surfaceVariant.withOpacity(0.12)), child: Text(_redemand?["finishing_date"] ?? "-", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15))),
                  const SizedBox(height: 18),
                  Text("Final Reason", style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: theme.colorScheme.surfaceVariant.withOpacity(0.12)), child: Text(_redemand?["final_reason"] ?? "-", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15))),
                ]),
              ),
          ],
        ),
      ),
    );
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
}
