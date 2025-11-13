import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';

class AdminDemandDetail extends StatefulWidget {
  final String demandId;
  const AdminDemandDetail({super.key, required this.demandId});

  @override
  State<AdminDemandDetail> createState() => _AdminDemandDetailState();
}

class _AdminDemandDetailState extends State<AdminDemandDetail> {
  Map<String, dynamic>? _demand;
  bool _isLoading = true;
  bool _assigning = false;
  String? _selectedOffice;
  String? _selectedName;

  final List<String> _officeList = ["Sultanpur"];
  final List<String> _nameList = ["Saurabh Yadav"];

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

  Future<void> _assignDemand() async {
    if (_selectedOffice == null || _selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select both Name and Office")),
      );
      return;
    }

    setState(() => _assigning = true);

    try {
      final body = jsonEncode({
        "demand_id": widget.demandId,
        "subadmin_role": "Sub Administrator",
        "subadmin_name": _selectedName,
        "subadmin_location": _selectedOffice,
      });

      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/assign_subadmin.php"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final result = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) Navigator.pop(context);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Text(result["message"] ?? "Demand assigned successfully"),
            ),
          );
        }

        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) Navigator.pop(context); // ⬅ Close detail page
      } else {
        throw Exception(result["message"] ?? "Assignment failed");
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      if (mounted) setState(() => _assigning = false);
    }
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
            if (_demand!["Status"] == "assign to subadmin") ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.green.withOpacity(0.10),
                  border: Border.all(color: Colors.green.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.verified_rounded, color: Colors.green, size: 26),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Successfully Assigned",
                            style: TextStyle(
                                color: Colors.green.shade700,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Assigned to: ${_demand!["assigned_subadmin_name"] ?? "--"}",
                            style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            "${_demand!["subadmin_role"] ?? "--"}",
                            style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),Text(
                            "${_demand!["subadmin_location"] ?? "--"}",
                            style: TextStyle(
                                color: Colors.green.shade600,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
                if (_demand!["Status"] == "New") ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _openAssignBottomSheet(accent, isDark),
                style: ElevatedButton.styleFrom(
                  backgroundColor: accent.withOpacity(0.85),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  elevation: 6,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  "Assign Demand",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ),
            ),
    ],
          ],
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
                boxShadow: [
                  BoxShadow(
                    color: accent.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  )
                ],
              ),
              child: Column(
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

                  Text(
                    "Assign Demand",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: accent,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 🔥 FUTURE FEATURE (commented)
                  /*
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Assign to All Offices",
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontWeight: FontWeight.w600)),
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
                const SizedBox(height: 10),
                */

                  // 🔰 Select Name
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Name",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    value: _selectedName,
                    onChanged: (v) => setState(() => _selectedName = v),
                    items: _nameList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),

                  const SizedBox(height: 16),

                  // 🔰 Select Location
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Office",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                    ),
                    value: _selectedOffice,
                    onChanged: (v) => setState(() => _selectedOffice = v),
                    items: _officeList
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                  ),

                  const Spacer(),

                  // 🔥 Assign Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _assigning ? null : _assignDemand,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: _assigning ? 2 : 5,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _assigning
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: Colors.black,
                                strokeWidth: 2.3,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              "Assigning...",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                            : Text(
                          "Assign Now",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
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

}
