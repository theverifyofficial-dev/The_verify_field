import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';

class AdminDemandDetail extends StatefulWidget {
  final String demandId;
  const AdminDemandDetail({super.key, required this.demandId});

  @override
  State<AdminDemandDetail> createState() => _DemandDetailPageState();
}

class _DemandDetailPageState extends State<AdminDemandDetail> {
  Map<String, dynamic>? _demand;
  bool _isLoading = true;
  bool _assigning = false;
  bool _assignToAll = false;
  String? _selectedOffice;

  final List<String> _officeList = [
    "Sultanpur Office",
    "Chhattarpur Office",
    "Gurugram Office",
    "Faridabad Office"
  ];

  Future<void> _fetchDemandDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonRes = jsonDecode(response.body);

        if (jsonRes["success"] == true &&
            jsonRes["data"] != null &&
            jsonRes["data"] is List &&
            jsonRes["data"].isNotEmpty) {
          final Map<String, dynamic> demandData =
          jsonRes["data"][0] as Map<String, dynamic>;

          setState(() {
            _demand = demandData;
            _isLoading = false;
          });
        } else {
          setState(() {
            _demand = null;
            _isLoading = false;
          });
        }
      } else {
        throw Exception("HTTP ${response.statusCode}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error fetching details: $e")));
      }
      setState(() => _isLoading = false);
    }
  }

  Future<void> _assignDemand() async {
    if (!_assignToAll && _selectedOffice == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an office")),
      );
      return;
    }

    setState(() => _assigning = true);
    try {
      final body = jsonEncode({
        "id": widget.demandId,
        "assign_all": _assignToAll ? true : false,
        "assigned_office": _selectedOffice ?? "",
      });

      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/assign_demand.php"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final result = jsonDecode(response.body);
      if (result["success"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(result["message"] ?? "Demand assigned successfully"),
        ));
        Navigator.pop(context);
      } else {
        throw Exception(result["message"] ?? "Assignment failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _assigning = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchDemandDetails();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final bool isUrgent = _demand?["mark"] == "1";
    final Color accent =
    isUrgent ? Colors.redAccent : theme.colorScheme.primary;
    final Gradient mainGradient = LinearGradient(
      colors: isUrgent
          ? [Colors.redAccent, Colors.redAccent.shade700]
          : [
        theme.colorScheme.primary,
        theme.colorScheme.primary
            .withOpacity(0.8)
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

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
          style: TextStyle(
              color: accent, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(color: accent),
      )
          : _demand == null
          ? const Center(child: Text("No data found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // 🟡 Tenant Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 55,
                        width: 55,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: mainGradient,
                          boxShadow: [
                            BoxShadow(
                              color: accent.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            _demand!["Tname"][0].toUpperCase(),
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              _demand!["Tname"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              _demand!["Tnumber"],
                              style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      if (isUrgent)
                        Container(
                          width: 10,
                          height: 10,
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent
                                    .withOpacity(0.7),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(color: Colors.grey.withOpacity(0.3)),
                  _infoRow("Buy / Rent", _demand!["Buy_rent"]),
                  _infoRow("Location", _demand!["Location"]),
                  _infoRow("Price Range", _demand!["Price"]),
                  _infoRow("BHK Range", _demand!["Bhk"]),
                  _infoRow("Reference", _demand!["Reference"]),
                  _infoRow("Status", _demand!["Status"]),
                  _infoRow("Message", _demand!["Message"]),
                  const SizedBox(height: 8),
                  Text(
                    "Created: ${_demand!["created_date"] ?? '-'}",
                    style: TextStyle(
                        color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // 🔧 Assign Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.15),
                    blurRadius: 25,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Assign Demand",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDark
                            ? Colors.white
                            : Colors.black,
                      )),
                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Assign to all offices",
                          style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black87)),
                      Switch(
                        value: _assignToAll,
                        activeColor: Colors.black,
                        activeTrackColor: accent,
                        onChanged: (v) {
                          setState(() {
                            _assignToAll = v;
                            if (v) _selectedOffice = null;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (!_assignToAll)
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Select Office",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                      ),
                      value: _selectedOffice,
                      onChanged: (v) =>
                          setState(() => _selectedOffice = v),
                      items: _officeList
                          .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e),
                      ))
                          .toList(),
                    ),

                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed:
                      _assigning ? null : _assignDemand,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(12)),
                        elevation: 5,
                      ),
                      child: _assigning
                          ? const CircularProgressIndicator(
                          color: Colors.black)
                          : Text(
                        "Assign Now",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
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
              value.isEmpty ? "-" : value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
