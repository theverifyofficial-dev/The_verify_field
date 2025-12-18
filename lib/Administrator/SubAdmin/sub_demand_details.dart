import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;

import '../../model/demand_model.dart';
import 'Redemand_subadmin.dart';

class SubDemandDetails extends StatefulWidget {
  final String demandId;
  const SubDemandDetails({super.key, required this.demandId});

  @override
  State<SubDemandDetails> createState() => _SubDemandDetailsState();
}

class _SubDemandDetailsState extends State<SubDemandDetails> {
  Map<String, dynamic>? _demand;
  bool _isLoading = true;
  bool _assigning = false;

  String? _selectedName;
  String? _selectedLocation;
  List<TenantDemandModel> _redemands = [];
  String? _parentId;

  final List<String> _nameList = [
    "Faizan Khan",
    "Ravi Kumar",
    "Sumit",
    "avjit"
  ];

  @override
  void initState() {
    super.initState();
    _fetchDemandDetails();
  }

  // ---------------------- FETCH DEMAND DETAILS ---------------------- //

  Future<void> _fetchDemandDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}"));

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);



        if (jsonRes["success"] == true &&
            jsonRes["data"] is List &&
            (jsonRes["data"] as List).isNotEmpty) {

          final d = Map<String, dynamic>.from(jsonRes["data"][0]);

          setState(() {
            _demand = d;
            _selectedLocation = d["Location"]?.toString() ?? "";
            _isLoading = false;
            _parentId = widget.demandId;
          });
          await _fetchRedemands();
        } else {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching details: $e")),
      );
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchRedemands() async {
    if (_parentId == null) return;

    try {
      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_sub_id.php?subid=$_parentId";

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonRes = jsonDecode(response.body);

        if (jsonRes["success"] == true && jsonRes["data"] is List) {
          List data = jsonRes["data"];

          // convert to model
          final list = data
              .map<TenantDemandModel>((e) =>
              TenantDemandModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          // newest on top
          list.sort((a, b) => b.id.compareTo(a.id));

          setState(() => _redemands = list);
          return;
        }
      }
      setState(() => _redemands = []);
    } catch (e) {
      setState(() => _redemands = []);
    }
  }


  // ---------------------- DATE FORMATTER ---------------------- //

  String formatApiDate(dynamic raw) {
    if (raw == null) return "-";

    try {
      // If string (comes from list API)
      if (raw is String) {
        final dt = DateTime.parse(raw);
        return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
      }

      // If map (details API)
      if (raw is Map && raw["date"] != null) {
        final dt = DateTime.parse(raw["date"]);
        return "${dt.day.toString().padLeft(2, '0')} ${_month(dt.month)} ${dt.year}";
      }

      return "-";
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

  // ---------------------- ASSIGN FIELDWORKER ---------------------- //

  Future<void> _assignDemand() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select the Name first.")),
      );
      return;
    }

    setState(() => _assigning = true);

    try {
      final body = jsonEncode({
        "demand_id": widget.demandId,
        "fieldworker_role": "FieldWorkar",
        "fieldworker_name": _selectedName,
        "fieldworker_location": _selectedLocation
      });
      print(body);

      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/assign_fieldoworkar.php"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final result = jsonDecode(response.body);

      print('${response.body}');

      if (response.statusCode == 200) {
        if (mounted) Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(result["message"] ?? "Demand assigned successfully"),
          ),
        );

        Navigator.pop(context);
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

  // ---------------------- UI BUILD ---------------------- //

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    final bool isUrgent = _demand?["mark"]?.toString() == "1";
    final Color accent = isUrgent ? Colors.redAccent : theme.colorScheme.primary;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F5F0),

      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Demand Details",
          style: TextStyle(color: accent, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: accent))
          : _demand == null
          ? const Center(child: Text("No data found"))
          : _buildMainBody(isDark, accent),
    );
  }

  // ---------------------- MAIN UI BODY ---------------------- //

  Widget _buildMainBody(bool isDark, Color accent) {
    final status = _demand?["Status"]?.toLowerCase();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          // --- REDEMAND LIST ---
          if (_redemands.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("ReDemands (${_redemands.length})",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _fetchRedemands)
              ],
            ),
            const SizedBox(height: 6),
            ..._redemands.asMap().entries.map((e) {
              return _redemandTile(e.value, Theme.of(context), e.key == 0);
            }),
            const SizedBox(height: 14),
            const Divider(),
            const SizedBox(height: 14),
          ],

          _buildTenantCard(isDark, accent),
          const SizedBox(height: 24),

          // If already assigned to FW — show summary
          if (_demand!["Status"] == "assigned to fieldworker")
            _buildAssignedSummary(),

          // If assigned to subadmin — show assignment button
          if (_demand!["Status"] == "assign to subadmin")
            _buildAssignButton(accent, isDark),

          if (status == "progressing" || status == "disclosed")

            _buildProgressDetailsCard(_demand!, isDark, accent),

          // If disclosed — show final summary
          if (_demand!["Status"]?.toString().toLowerCase() == "disclosed")
            _buildFinalSummarySection(isDark, accent),
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

  // ---------------------- TENANT CARD ---------------------- //

  Widget _buildTenantCard(bool isDark, Color accent) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            _buildAvatar(accent),
            const SizedBox(width: 14),
            _buildTenantInfo(isDark),
            if (_demand?["mark"] == "1") _buildUrgentDot(),
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
        ],
      ),
    );
  }

  Widget _buildAvatar(Color accent) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [accent, accent.withOpacity(0.7)],
        ),
      ),
      child: Center(
        child: Text(
          _demand?["Tname"]?.substring(0, 1).toUpperCase() ?? "?",
          style: const TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildTenantInfo(bool isDark) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _demand?["Tname"] ?? "--",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          Text(
            _demand?["Tnumber"] ?? "--",
            style: TextStyle(color: Colors.grey.shade500),
          ),
          Text(
            "Created: ${formatApiDate(_demand?["created_date"])}",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildUrgentDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withOpacity(0.8),
            blurRadius: 10,
            spreadRadius: 1,
          )
        ],
      ),
    );
  }


  Widget _infoRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              )),
          Flexible(
            child: Text(
              value?.toString().isNotEmpty == true ? value! : "-",
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- ASSIGNED SUMMARY (FW) ---------------------- //

  Widget _buildAssignedSummary() {
    return Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.green.withOpacity(0.10),
        border: Border.all(color: Colors.green.withOpacity(0.4)),
      ),
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
                  "Assigned to: ${_demand?["assigned_fieldworker_name"] ?? "--"}",
                  style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                Text(
                  "${_demand?["assigned_fieldworker_role"] ?? "--"}",
                  style: TextStyle(
                      color: Colors.green.shade600,
                      fontSize: 13,
                      fontWeight: FontWeight.w500),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${_demand?["assigned_fieldworker_location"] ?? "--"}",
                      style: TextStyle(
                          color: Colors.green.shade600,
                          fontSize: 13,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      "Assign: ${formatApiDate(_demand?["fieldworker_assigned_at"])}",
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  // ---------------------- ASSIGN BUTTON ---------------------- //

  Widget _buildAssignButton(Color accent, bool isDark) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _openAssignBottomSheet(accent, isDark),
        style: ElevatedButton.styleFrom(
          backgroundColor: accent,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          elevation: 6,
        ),
        child: const Text(
          "Assign Demand",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17),
        ),
      ),
    );
  }

  // ---------------------- ASSIGN BOTTOM SHEET ---------------------- //

  void _openAssignBottomSheet(Color accent, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 0.85,
          minChildSize: 0.35,
          expand: false,
          builder: (_, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111217) : Colors.white,
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(26)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.4),
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  const SizedBox(height: 18),

                  Text("Assign To Fieldworker",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accent)),

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
                        .map((name) =>
                        DropdownMenuItem(value: name, child: Text(name)))
                        .toList(),
                  ),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: accent.withOpacity(0.15)),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: accent),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            _selectedLocation ?? "--",
                            style: TextStyle(
                                color: isDark ? Colors.white70 : Colors.black87,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Assign Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _assigning ? null : _assignDemand,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: accent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _assigning
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2.3,
                                    color: Colors.black)),
                            SizedBox(width: 12),
                            Text("Assigning...",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                            : const Text(
                          "Assign Now",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
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

  // ---------------------- FINAL SUMMARY (DISCLOSED) ---------------------- //

  Widget _buildFinalSummarySection(bool isDark, Color accent) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: accent.withOpacity(0.25),
            blurRadius: 18,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Disclosing Details",
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
          const SizedBox(height: 14),

          Text("Finishing Date",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _summaryBox(_demand?["finishing_date"], isDark, theme),

          const SizedBox(height: 18),

          Text("Final Reason",
              style: theme.textTheme.titleMedium!
                  .copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          _summaryBox(_demand?["final_reason"], isDark, theme),
        ],
      ),
    );
  }

  Widget _summaryBox(String? text, bool isDark, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: theme.colorScheme.surfaceVariant.withOpacity(0.12),
      ),
      child: Text(
        text ?? "-",
        style: TextStyle(
          fontSize: 15,
          color: isDark ? Colors.white70 : Colors.black87,
        ),
      ),
    );
  }

  Widget _redemandTile(TenantDemandModel d, ThemeData theme, bool isFirst) {
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = d.mark == "1";

    return
      GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RedemandSubadmin(redemandId: d.id.toString()),
          ),
        ).then((_) {
          _fetchRedemands();
          _fetchDemandDetails();
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: isUrgent
              ? Colors.redAccent.withOpacity(0.25)
              : theme.colorScheme.primary.withOpacity(0.25),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.primary,
                child: Text(
                  d.tname[0].toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  d.tname,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : Colors.black),
                ),
              ),
              // STATUS BADGE
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  d.status.toUpperCase(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ]),
            const SizedBox(height: 8),
            Text("${d.location} • ${d.bhk} BHK",
                style: TextStyle(
                    color: isDark ? Colors.white70 : Colors.black54)),
            Text("₹ ${d.price}",
                style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.black54)),
            Text("Ref: ${d.reference}",
                style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black45)),
            Align(
                alignment: Alignment.centerRight,
                child: Text(formatApiDate(d.createdDate),
                    style: TextStyle(color: Colors.grey.shade500)))
          ],
        ),
      ),
    );
  }

}
