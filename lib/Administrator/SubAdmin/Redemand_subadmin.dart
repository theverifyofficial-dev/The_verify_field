import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;

class RedemandSubadmin extends StatefulWidget {
  final String redemandId;
  const RedemandSubadmin({super.key, required this.redemandId});

  @override
  State<RedemandSubadmin> createState() => _RedemandDetailPageState();
}

class _RedemandDetailPageState extends State<RedemandSubadmin> {
  Map<String, dynamic>? _redemand;
  bool _isLoading = true;
  bool _assigning = false;

  String? _selectedName;

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
  }

  // ---------------------- FETCH DETAILS ---------------------- //
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
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error: $e")));
      }
      setState(() => _isLoading = false);
    }
  }

  // ---------------------- ASSIGN TO FIELDWORKER (API A) ---------------------- //
  Future<void> _assignDemand() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select Name")));
      return;
    }

    setState(() => _assigning = true);

    try {
      final body = jsonEncode({
        "demand_id": widget.redemandId,
        "fieldworker_name": _selectedName,
        "fieldworker_role": "FieldWorkar",
        "fieldworker_location": _redemand?["Location"] ?? ""
      });

      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_fieldworkar.php"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final jsonRes = jsonDecode(response.body);
      print(response.body);

      if (response.statusCode == 200) {
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(jsonRes["message"] ?? "Assigned successfully"),
        ));

        await _fetchRedemandDetails();
      } else {
        throw Exception(jsonRes["message"] ?? "Assignment failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _assigning = false);
    }
  }

  // ---------------------- DATE FORMATTER ---------------------- //
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
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ),
        ],
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
                    items: _nameList
                        .map((n) => DropdownMenuItem(value: n, child: Text(n)))
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
                            child: Text(_redemand?["Location"] ?? "--",
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          _buildMainCard(isDark, accent),
          const SizedBox(height: 20),

          // ✔ SubAdmin can assign ONLY when status == assign to subadmin
          if (status == "assign to subadmin")
            _buildAssignButton(accent, isDark),

          // ✔ Show FW summary after assigning
          if (status == "assigned to fieldworker")
            _buildFwSummary(),

          if (status == "progressing" || status == "disclosed")

            _buildProgressDetailsCard(_redemand!, isDark, accent),

          // ✔ Show disclosed summary same as admin
          if (status == "disclosed")
            _buildDisclosed(isDark, accent),
        ],
      ),
    );
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
              Text(_redemand?["Tnumber"] ?? "-",
                  style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 14)),
              Text("Created: ${formatApiDate(_redemand?["created_date"])}",
                  style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 13)),
            ]),
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

  Widget _buildFwSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: Colors.green.withOpacity(0.1),
          border: Border.all(color: Colors.green.withOpacity(0.4))),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: Colors.green, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Successfully Assigned",
                    style: TextStyle(
                        color: Colors.green.shade700,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                Text(
                    "Assigned to: ${_redemand!["assigned_fieldworker_name"] ?? "--"}",
                    style: TextStyle(
                        color: Colors.green.shade600,
                        fontSize: 13)),
                Text(_redemand!["assigned_fieldworker_role"] ?? "--",
                    style: TextStyle(
                        color: Colors.green.shade600, fontSize: 13)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        _redemand!["assigned_fieldworker_location"] ?? "--",
                        style: TextStyle(
                            color: Colors.green.shade600, fontSize: 13)),
                    Text(
                        "Assign: ${formatApiDate(_redemand!["fieldworker_assigned_at"] ?? "")}",
                        style: TextStyle(
                            color: Colors.grey.shade500, fontSize: 13))
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
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
}
