import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:verify_feild_worker/Administrator/New_TenandDemand/redemand_detailpage.dart';
import '../../model/demand_model.dart';


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
  String? _parentId;

  final List<String> _nameList = ["Saurabh Yadav"];

  List<TenantDemandModel> _redemands = [];

  @override
  void initState() {
    super.initState();
    _fetchDemandDetails();
  }

  Future<void> _fetchDemandDetails() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/details_page_for_tenat_demand.php?id=${widget.demandId}"));

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonRes = jsonDecode(response.body);
        if (jsonRes["success"] == true &&
            jsonRes["data"] is List &&
            (jsonRes["data"] as List).isNotEmpty) {
          setState(() {
            _demand = Map<String, dynamic>.from(jsonRes["data"][0]);
            _selectedOffice = _demand?["Location"];
            _isLoading = false;
            _parentId = widget.demandId;
          });
          await _fetchRedemands(); // load children after parent loaded
        } else {
          setState(() {
            _isLoading = false;
          });
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

  /// Fetch redemands for this parent demand.
  /// API: show_redemand_base_on_sub_id.php?subid=<parentId>
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
          // Map to model
          final list = data
              .map<TenantDemandModel>(
                  (e) => TenantDemandModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          // Sort descending: newest first (as you requested).
          list.sort((a, b) => b.id.compareTo(a.id));

          setState(() {
            _redemands = list;
          });
        } else {
          setState(() {
            _redemands = [];
          });
        }
      } else {
        setState(() {
          _redemands = [];
        });
      }
    } catch (e) {
      setState(() {
        _redemands = [];
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Error loading re-demands: $e")));
      }
    }
  }

  String formatApiDate(dynamic raw) {
    if (raw == null) return "";

    try {
      // Case 1 → detail API (Map {date: ...})
      if (raw is Map && raw['date'] != null) {
        final dt = DateTime.parse(raw['date']);
        return "${dt.day} ${_month(dt.month)} ${dt.year}";
      }

      // Case 2 → list API (plain String)
      if (raw is String && raw.isNotEmpty) {
        final dt = DateTime.parse(raw);
        return "${dt.day} ${_month(dt.month)} ${dt.year}";
      }

      return raw.toString();
    } catch (_) {
      return raw.toString();
    }
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }

  Future<void> _assignDemand() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Select Name")),
      );
      return;
    }

    setState(() => _assigning = true);

    try {
      final body = jsonEncode({
        "demand_id": widget.demandId,
        "subadmin_role": "Sub Administrator",
        "subadmin_name": _selectedName,
        "subadmin_location": _selectedOffice
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

        if (mounted) {
          // refresh both parent and child list
          await _fetchDemandDetails();
        }
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

  Widget _buildTenantCard(bool isDark, Color accent, Map<String, dynamic> data) {
    final bool isUrgent = (data["mark"]?.toString() ?? "0") == "1";
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
                (data["Tname"]?.toString().isNotEmpty ?? false)
                    ? data["Tname"].toString()[0].toUpperCase()
                    : "?",
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
                  Text(data["Tname"] ?? "Unknown",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black)),
                  const SizedBox(height: 3),
                  Text(data["Tnumber"] ?? "-",
                      style:
                      TextStyle(color: Colors.grey.shade500, fontSize: 14)),

                  Text(
                    "Created: ${formatApiDate(data["created_date"] is String ? data["created_date"] : (data["created_date"]?["date"] ?? ""))}",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  )

                ]),
          ),
          if (isUrgent)
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
        _infoRow("Buy / Rent", data["Buy_rent"]?.toString() ?? ""),
        _infoRow("Location", data["Location"]?.toString() ?? ""),
        _infoRow("Price Range", data["Price"]?.toString() ?? ""),
        _infoRow("BHK Range", data["Bhk"]?.toString() ?? ""),
        _infoRow("Reference", data["Reference"]?.toString() ?? ""),
        _infoRow("Status", data["Status"]?.toString() ?? ""),
        _infoRow("Message", data["Message"]?.toString() ?? ""),
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
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ),
      ]),
    );
  }

  Widget _redemandListTile(TenantDemandModel d, ThemeData theme, bool isFirst) {
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = d.mark == "1";
    final Color baseColor = isUrgent ? Colors.redAccent : theme.colorScheme.primary;

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
        if (d.status.toLowerCase() == "assigned to fieldworker")
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
                      Colors.green.shade500,
                      Colors.green.shade700,
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
                  "ASSIGNED   ",
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
        if (d.status.toLowerCase() == "assign to subadmin")
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
                      Colors.green.shade500,
                      Colors.green.shade700,
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
                  "ASSIGNED   ",
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
                builder: (_) => RedemandDetailPage(redemandId: d.id.toString()),
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
                    Text("${d.location} • ${d.bhk} BHK",
                        style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text("₹ ${d.price}",
                        style: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54,
                            fontSize: 14)),
                    if (d.reference.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Ref: ${d.reference}",
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
        if (d.status.toLowerCase() == "disclosed")
          _buildRibbon("DISCLOSED", Colors.red.shade500, Colors.red.shade700),

        if (d.status.toLowerCase() == "assigned to fieldworker" ||
            d.status.toLowerCase() == "assign to subadmin")
          _buildRibbon("ASSIGNED", Colors.green.shade500, Colors.green.shade700),
      ],
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
                  Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(10))),
                  const SizedBox(height: 18),
                  Text("Assign Demand", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
                  const SizedBox(height: 20),

                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: "Select Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    value: _selectedName,
                    onChanged: (v) => setState(() => _selectedName = v),
                    items: _nameList.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: accent.withOpacity(0.15),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on, color: accent, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _demand?["Location"] ?? "--",
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.black87,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
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
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: _assigning ? 2 : 5,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        child: _assigning
                            ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.3)),
                            const SizedBox(width: 12),
                            Text("Assigning...", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          ],
                        )
                            : Text("Assign Now", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
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

  Widget _buildFinalSummarySection(bool isDark, Color accent) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark ? Colors.white.withOpacity(0.06) : Colors.white,
        boxShadow: [
          BoxShadow(color: accent.withOpacity(0.2), blurRadius: 18, offset: const Offset(0, 5))
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text("Disclosing Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
        const SizedBox(height: 16),
        Text("Finishing Date", style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: theme.colorScheme.surfaceVariant.withOpacity(0.12)), child: Text(_demand?["finishing_date"] ?? "-", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15))),
        const SizedBox(height: 18),
        Text("Final Reason", style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(width: double.infinity, padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: theme.colorScheme.surfaceVariant.withOpacity(0.12)), child: Text(_demand?["final_reason"] ?? "-", style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 15))),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isUrgent = _demand?["mark"]?.toString() == "1";
    final Color accent = isUrgent ? Colors.redAccent : theme.colorScheme.primary;
    final baseColor = accent;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0C10) : const Color(0xFFF7F5F0),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text("Demand Details", style: TextStyle(color: accent, fontWeight: FontWeight.bold, fontSize: 18)),
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
            // --- Redemand list header + tiles (newest first) ---
            if (_redemands.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("ReDemands (${_redemands.length})", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  // optional: refresh button
                  IconButton(
                    icon: const Icon(Icons.refresh, size: 20),
                    onPressed: _fetchRedemands,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              ..._redemands.asMap().entries.map((entry) {
                int index = entry.key;
                TenantDemandModel d = entry.value;

                return _redemandListTile(d, theme, index == 0);
              }).toList(),
              const SizedBox(height: 12),
              const Divider(thickness: 1),
              const SizedBox(height: 12),
            ],

            // --- Parent demand at bottom (unchanged card) ---
            _buildTenantCard(isDark, accent, _demand!),

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
                child: Row(children: [
                  Icon(Icons.verified_rounded, color: Colors.green, size: 26),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Successfully Assigned", style: TextStyle(color: Colors.green.shade700, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("Assigned to: ${_demand!["assigned_subadmin_name"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Text("${_demand!["assigned_subadmin_role"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("${_demand!["assigned_subadmin_location"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                      Text("Assign: ${formatApiDate(_demand!["subadmin_assigned_at"] ?? "")}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13))
                    ]),
                  ]))
                ]),
              ),
            ],

            if (_demand!["Status"] == "assigned to fieldworker") ...[
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.green.withOpacity(0.10),
                  border: Border.all(color: Colors.green.withOpacity(0.4)),
                ),
                child: Row(children: [
                  Icon(Icons.verified_rounded, color: Colors.green, size: 26),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text("Successfully Assigned", style: TextStyle(color: Colors.green.shade700, fontSize: 15, fontWeight: FontWeight.bold)),
                    Text("Assigned to: ${_demand!["assigned_fieldworker_name"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Text("${_demand!["assigned_fieldworker_role"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      Text("${_demand!["assigned_fieldworker_location"] ?? "--"}", style: TextStyle(color: Colors.green.shade600, fontSize: 13, fontWeight: FontWeight.w500)),
                      Text("Assign: ${formatApiDate(_demand!["fieldworker_assigned_at"] ?? "")}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13))
                    ]),
                  ]))
                ]),
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
                  child: Text("Assign Demand", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 17)),
                ),
              ),
            ],

            if (_demand?["Status"]?.toString().toLowerCase() == "disclosed")
              _buildFinalSummarySection(isDark, accent),

          ],
        ),
      ),
    );
  }
}
