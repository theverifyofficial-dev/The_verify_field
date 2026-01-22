import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;

import '../../utilities/bug_founder_fuction.dart';
import 'Add_demand.dart';


class RedemandDetailPage extends StatefulWidget {
  final String redemandId;
  final String subid;
  final bool fromNotification;
  const RedemandDetailPage({super.key, required this.redemandId,required this.subid, this.fromNotification = false,
  });

  @override
  State<RedemandDetailPage> createState() => _RedemandDetailPageState();
}

class _RedemandDetailPageState extends State<RedemandDetailPage> {
  Map<String, dynamic>? _redemand;
  bool _isLoading = true;
  bool _assigning = false;
  String? _selectedName;
  String? _selectedOffice;
  final List<String> _nameList = [
    "Faizan Khan",
    "Ravi Kumar",
    "Sumit",
    "avjit",
    "Abhay",
    "Manish",
  ];


  @override
  void initState() {
    super.initState();
    _fetchRedemandDetails();
  }


  String _resolveLocationByName(String name) {
    const Map<String, String> nameLocationMap = {
      // Sultanpur team
      "faizan khan": "Sultanpur",
      "ravi kumar": "Sultanpur",
      "sumit": "Sultanpur",
      "avjit": "Sultanpur",

      // Rajpur Khurd team
      "abhay": "Rajpur Khurd",
      "manish": "Rajpur Khurd",
    };

    return nameLocationMap[name.toLowerCase()] ?? "Unknown";
  }
  Future<void> _fetchRedemandDetails() async {
    print(" redemand id from detail page : ${widget.redemandId}");
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
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=",
          error: response.body.toString(),
          statusCode: response.statusCode ?? 0,
        );
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error fetching details: $e")));
      }
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?id=",
        error: e.toString(),
        statusCode: 500,
      );
      setState(() => _isLoading = false);
    }
  }

  // Future<void> _assignDemand() async { // for subadmin
  //   if (_selectedName == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select Name")));
  //     return;
  //   }
  //   if (_selectedOffice == null) {
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Select Office")));
  //     return;
  //   }
  //
  //   setState(() => _assigning = true);
  //   try {
  //     final body = jsonEncode({
  //       "demand_id": widget.subid,
  //       "subadmin_role": "Sub Administrator",
  //       "subadmin_name": _selectedName,
  //       "subadmin_location": _selectedOffice
  //     });
  //
  //     print(widget.subid);
  //
  //     final response = await http.post(
  //       Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_subadmin.php'),
  //       headers: {"Content-Type": "application/json"},
  //       body: body,
  //     );
  //
  //     print(response.body);
  //
  //     final result = jsonDecode(response.body);
  //
  //     if (response.statusCode == 200) {
  //       if (mounted) {
  //         Navigator.pop(context); // ✅ CLOSE BOTTOM SHEET
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text(result["message"] ?? "Assigned successfully"),
  //           ),
  //         );
  //       }
  //
  //       await _fetchRedemandDetails(); // refresh UI after closing
  //     }
  //     else {
  //       await BugLogger.log(
  //         apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_subadmin.php",
  //         error: response.body.toString(),
  //         statusCode: response.statusCode ?? 0,
  //       );
  //       throw Exception(result["message"] ?? "Assignment failed");
  //     }
  //   } catch (e) {
  //     if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
  //     await BugLogger.log(
  //       apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_subadmin.php",
  //       error: e.toString(),
  //       statusCode: 500,
  //     );
  //   } finally {
  //     if (mounted) setState(() => _assigning = false);
  //   }
  // }

  Future<void> _assignDemand() async {
    if (_selectedName == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Select Name")));
      return;
    }

    setState(() => _assigning = true);

    try {
      final body = jsonEncode({
        "demand_id": widget.subid,
        "fieldworker_name": _selectedName,
        "fieldworker_role": "FieldWorkar",
        "fieldworker_location": _selectedOffice ?? ""
      });

      final response = await http.post(
        Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/redemand_assign_to_fieldworkar.php"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      final jsonRes = jsonDecode(response.body);
      print(response.body);
      print(widget.subid);

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
        Flexible(child: Text((value?.isNotEmpty ?? false) ? value! : "-", textAlign: TextAlign.right, style: const TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w500))),
      ]),
    );
  }

  // void _openAssignBottomSheet(Color accent, bool isDark) {
  //   showModalBottomSheet(
  //       context: context,
  //       isScrollControlled: true,
  //       backgroundColor: Colors.transparent,
  //       builder: (ctx) {
  //         return StatefulBuilder(
  //           builder: (context, setModalState) {
  //             return DraggableScrollableSheet(
  //               initialChildSize: 0.55,
  //               minChildSize: 0.35,
  //               maxChildSize: 0.9,
  //               expand: false,
  //               builder: (_, controller) {
  //                 return Container(
  //                   padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
  //                   decoration: BoxDecoration(
  //                     color: isDark ? const Color(0xFF111217) : Colors.white,
  //                     borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
  //                     boxShadow: [
  //                       BoxShadow(
  //                         color: accent.withOpacity(0.2),
  //                         blurRadius: 10,
  //                         offset: const Offset(0, 0),
  //                       )
  //                     ],
  //                   ),
  //                   child: Column(
  //                     children: [
  //                       Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey.withOpacity(0.4), borderRadius: BorderRadius.circular(10))),
  //                       const SizedBox(height: 18),
  //                       Text("Assign Demand", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: accent)),
  //                       const SizedBox(height: 20),
  //
  //                       DropdownButtonFormField<String>(
  //                         decoration: InputDecoration(
  //                           labelText: "Select Name",
  //                           border: OutlineInputBorder(
  //                               borderRadius: BorderRadius.circular(12)),
  //                           contentPadding: const EdgeInsets.symmetric(
  //                               horizontal: 12, vertical: 10),
  //                         ),
  //                         value: _selectedName,
  //                         onChanged: (v) {
  //                           setModalState(() {
  //                             _selectedName = v;
  //                             _selectedOffice =
  //                             v == null ? null : _resolveLocationByName(v);
  //                           });
  //                         },
  //                         items: _nameList
  //                             .map(
  //                               (e) => DropdownMenuItem(
  //                             value: e,
  //                             child: Text(e),
  //                           ),
  //                         )
  //                             .toList(),
  //                       ),
  //
  //                       const SizedBox(height: 16),
  //
  //                       // --- AUTO LOCATION DISPLAY ---
  //                       if (_selectedOffice != null)
  //                         Container(
  //                           width: double.infinity,
  //                           padding: const EdgeInsets.all(14),
  //                           decoration: BoxDecoration(
  //                             borderRadius: BorderRadius.circular(12),
  //                             color: accent.withOpacity(0.12),
  //                           ),
  //                           child: Row(
  //                             children: [
  //                               Icon(Icons.location_on, color: accent),
  //                               const SizedBox(width: 10),
  //                               Text(
  //                                 _selectedOffice!,
  //                                 style: TextStyle(
  //                                   fontWeight: FontWeight.w600,
  //                                   color: isDark
  //                                       ? Colors.white70
  //                                       : Colors.black87,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //
  //                       const Spacer(),
  //
  //                       SizedBox(
  //                         width: double.infinity,
  //                         height: 48,
  //                         child: ElevatedButton(
  //                           onPressed: _assigning ? null : _assignDemand,
  //                           style: ElevatedButton.styleFrom(
  //                             backgroundColor: accent,
  //                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //                             elevation: _assigning ? 2 : 5,
  //                           ),
  //                           child: AnimatedSwitcher(
  //                             duration: const Duration(milliseconds: 250),
  //                             child: _assigning
  //                                 ? Row(
  //                               mainAxisAlignment: MainAxisAlignment.center,
  //                               children: [
  //                                 SizedBox(height: 22, width: 22, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2.3)),
  //                                 const SizedBox(width: 12),
  //                                 Text("Assigning...", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
  //                               ],
  //                             )
  //                                 : Text("Assign Now", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
  //                           ),
  //                         ),
  //                       ),
  //                       const SizedBox(height: 14),
  //                     ],
  //                   ),
  //                 );
  //               },
  //             );
  //           },
  //         );
  //       }
  //   );
  // }

  void _openAssignSheet(Color accent, bool isDark) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        String? selectedName;
        String? selectedOffice;
        bool assigning = false;

        return StatefulBuilder(
          builder: (context, setSheetState) {
            final bool canAssign = selectedName != null && !assigning;

            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.55,
              maxChildSize: 0.85,
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
                        "Assign Demand",
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// NAME DROPDOWN
                      DropdownButtonFormField<String>(
                        value: selectedName,
                        decoration: InputDecoration(
                          labelText: "Select Name",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        items: _nameList
                            .map(
                              (name) => DropdownMenuItem(
                            value: name,
                            child: Text(name),
                          ),
                        )
                            .toList(),
                        onChanged: (v) {
                          setSheetState(() {
                            selectedName = v;
                            selectedOffice =
                            v == null ? null : _resolveLocationByName(v);
                          });
                        },
                      ),

                      const SizedBox(height: 16),

                      /// AUTO LOCATION (READ-ONLY)
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: selectedOffice == null
                            ? const SizedBox.shrink()
                            : Container(
                          key: ValueKey(selectedOffice),
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: accent.withOpacity(0.12),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.location_on, color: accent),
                              const SizedBox(width: 10),
                              Text(
                                selectedOffice!,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? Colors.white70
                                      : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const Spacer(),

                      /// ASSIGN BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: canAssign
                              ? () async {
                            setSheetState(() => assigning = true);

                            _selectedName = selectedName;
                            _selectedOffice = selectedOffice;

                            await _assignDemand();

                            if (context.mounted) {
                              Navigator.pop(context);
                            }
                          }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                            canAssign ? accent : Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: assigning
                              ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.3,
                              color: Colors.black,
                            ),
                          )
                              : const Text(
                            "Assign Demand",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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
    final hasSubadminAssigned =
        _redemand?["assigned_subadmin_name"] != null;
    final hasFieldworkerAssigned =
        _redemand?["assigned_fieldworker_name"] != null;
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
                    Text("Created: ${formatApiDate(_redemand?["created_date"])}", style: TextStyle(color: Colors.grey.shade500, fontSize: 13)),
                    Text('ReDemand ID: ${_redemand?["id"].toString()}' ?? "0",
                        style: TextStyle(
                            color: isDark
                                ? Colors.white38
                                : Colors.black45,
                            fontSize: 13)),
                  ]),

                  Spacer(),

                  IconButton(
                    icon: const Icon(Icons.edit_rounded),
                    tooltip: "Edit",
                    onPressed: () =>
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) =>  CustomerDemandFormPage(mode: DemandEditMode.updateRedemand, redemandId: widget.redemandId,)),
                    ).then((_) => _fetchRedemandDetails()),

                  ),

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
                ],
                  ),
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

            if (status == "new") ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _openAssignSheet(accent, isDark),
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



            if (hasSubadminAssigned) ...[
              const SizedBox(height: 16),
              _buildAssignmentCard(
                title: "Assigned to Sub Admin",
                name: _redemand!["assigned_subadmin_name"],
                role: _redemand!["assigned_subadmin_role"],
                location: _redemand!["assigned_subadmin_location"],
                date: _redemand!["subadmin_assigned_at"],
                accent: Colors.green,
                isDark: isDark,
              ),
            ],

            const Divider(thickness: 1),


            if (hasFieldworkerAssigned) ...[
              _buildAssignmentCard(
                title: "Assigned to Fieldworker",
                name: _redemand!["assigned_fieldworker_name"],
                role: _redemand!["assigned_fieldworker_role"],
                location: _redemand!["assigned_fieldworker_location"],
                date: _redemand!["fieldworker_assigned_at"],
                accent: Colors.blue,
                isDark: isDark,
              ),
            ],

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
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: _contactButton(
                  //         label: "Call",
                  //         color: Colors.blue,
                  //         icon: Icons.call,
                  //         onTap: () async {
                  //           print("☎ CALL tapped");
                  //
                  //           await _logContact(
                  //               message: "Try to Call ${maskPhone(number)}", id: id);
                  //
                  //           print("📌 Log Inserted → Calling...");
                  //           await refreshLogs();
                  //
                  //           final uri = Uri.parse("tel:$number");
                  //           await launchUrl(uri);
                  //         },
                  //       ),
                  //     ),
                  //     const SizedBox(width: 10),
                  //     Expanded(
                  //       child: _contactButton(
                  //         label: "WhatsApp",
                  //         color: Colors.green,
                  //         icon: Icons.chat,
                  //         onTap: () async {
                  //           print("💬 WhatsApp tapped");
                  //
                  //           await _logContact(
                  //               message: "Try to message on WhatsApp ${maskPhone(number)}",
                  //               id: id);
                  //
                  //           print("📌 Log Inserted → Opening WhatsApp...");
                  //           await refreshLogs();
                  //
                  //           final phone = number.replaceAll(" ", "");
                  //           final txt = Uri.encodeComponent(
                  //               "Hello $name, I’m contacting regarding your request.");
                  //           final url =
                  //           Uri.parse("https://wa.me/$phone?text=$txt");
                  //
                  //           await launchUrl(url,
                  //               mode: LaunchMode.externalApplication);
                  //         },
                  //       ),
                  //     ),
                  //   ],
                  // ),

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
      // margin: const EdgeInsets.only(bottom: 1),
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

}
