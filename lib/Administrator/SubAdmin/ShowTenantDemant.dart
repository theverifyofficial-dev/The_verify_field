import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/SubAdmin/sub_demand_details.dart';
import '../../model/demand_model.dart';
import '../../utilities/bug_founder_fuction.dart';
import 'Redemand_subadmin.dart';

class ShowTenantDemandPage extends StatefulWidget {
  const ShowTenantDemandPage({super.key});
  @override
  State<ShowTenantDemandPage> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<ShowTenantDemandPage> {


  List<TenantDemandModel> _parentDemands = [];
  List<TenantDemandModel> _redemands = [];

  List<TenantDemandModel> _filteredParent = [];
  List<TenantDemandModel> _filteredRedemands = [];

  List<RedemandTransferModel> _crossRedemands = [];
  List<RedemandTransferModel> _filteredCrossRedemands = [];

  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;


  @override
  void initState() {
    super.initState();
    _loadDemands();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadDemands() async {
    setState(() => _isLoading = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final subadminName = prefs.getString('name') ?? "";
      final subadminLocation = prefs.getString('location') ?? "";
      print(subadminName);
      print(subadminLocation);

      if (subadminName.isEmpty || subadminLocation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info missing. Please login again.")),
        );
        return;
      }

      final encodedName = Uri.encodeQueryComponent(subadminName);
      final encodedLoc = Uri.encodeQueryComponent(subadminLocation);

      String link = "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_subadmin_page.php?assigned_subadmin_name=$encodedName";

      final url = Uri.parse(link);
      print(link);
      final response = await http.get(url);
      print(response.body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true && decoded["data"] is List) {
          final List data = decoded["data"];

          final parents = data
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();

          // final crossRedemands = await _loadCrossRedemand();
          final transferRedemand = await _loadTransferRedemand();


          setState(() {
            _parentDemands = parents;
            // _redemands = crossRedemands;
            _crossRedemands = transferRedemand;

            _filteredParent = parents;
            // _filteredRedemands = crossRedemands;
            _filteredCrossRedemands = transferRedemand;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No demand data found")),
            );
            // await BugLogger.log(
            //   apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_subadmin_status_api.php?Status=assign%20to%20subadmin&assigned_subadmin_name=$encodedName",
            //   error: response.body.toString(),
            //   statusCode: response.statusCode ?? 0,
            // );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("HTTP Error: ${response.statusCode}")),
          );
          await BugLogger.log(
            apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_subadmin_status_api.php?Status=assign%20to%20subadmin&assigned_subadmin_name=$encodedName",
            error: response.body.toString(),
            statusCode: response.statusCode ?? 0,
          );
        }
      }

    } catch (e) {
      if (mounted) {
        print("Error fetching data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $e")),
        );
        await BugLogger.log(
          apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_subadmin_status_api.php?Status=assign%20to%20subadmin&assigned_subadmin_name=encodedName",
          error: e.toString(),
          statusCode: 500,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Future<List<TenantDemandModel>> _loadCrossRedemand() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final name = prefs.getString('name') ?? "";
  //     final location = prefs.getString('location') ?? "";
  //
  //     if (name.isEmpty || location.isEmpty) return [];
  //
  //     final encodedName = Uri.encodeQueryComponent(name);
  //     final encodedLoc = Uri.encodeQueryComponent(location);
  //
  //     final url =
  //         "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/"
  //         "show_redemand_based_on_sub_id_and_name_location.php"
  //         "?assigned_subadmin_location=$encodedLoc"
  //         "&assigned_subadmin_name=$encodedName";
  //
  //     print(url);
  //
  //
  //     final res = await http.get(Uri.parse(url));
  //
  //     if (res.statusCode == 200) {
  //       final decoded = jsonDecode(res.body);
  //
  //       if (decoded["status"] == true && decoded["data"] is List) {
  //         return (decoded["data"] as List)
  //             .map((e) => TenantDemandModel.fromJson(e))
  //             .toList();
  //       }
  //     }
  //   } catch (e) {
  //     await BugLogger.log(
  //       apiLink:
  //       "show_redemand_based_on_sub_id_and_name_location.php",
  //       error: e.toString(),
  //       statusCode: 500,
  //     );
  //   }
  //
  //   return [];
  // }

  Future<List<RedemandTransferModel>> _loadTransferRedemand() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name') ?? "";
      final location = prefs.getString('location') ?? "";

      if (name.isEmpty || location.isEmpty) return [];

      final encodedName = Uri.encodeQueryComponent(name);
      final encodedLoc = Uri.encodeQueryComponent(location);

      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/"
          "share_show_api_for_redemand.php"
          "?assigned_subadmin_location=$encodedLoc"
          "&assigned_subadmin_name=$encodedName";

      print("transfer link: $url");


      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        if (decoded["success"] == true && decoded["data"] is List) {
          return (decoded["data"] as List)
              .map((e) => RedemandTransferModel.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      await BugLogger.log(
        apiLink:
        "share_show_api_for_redemand.php",
        error: e.toString(),
        statusCode: 500,
      );
    }

    return [];
  }


  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 250), () {
      final q = _searchController.text.toLowerCase().trim();

      setState(() {
        _filteredParent = _parentDemands.where((d) {
          return _matchDemand(d, q);
        }).toList();

        _filteredRedemands = _redemands.where((d) {
          return _matchDemand(d, q);
        }).toList();
        _filteredCrossRedemands = _crossRedemands.where((d) {
          return [
            d.assignedSubadminName,
            d.assignedSubadminLocation,
            d.mainAssignedName,
            d.mainAssignedLocation,
            d.price,
            d.redemandStatus,
          ].any((f) => f.toLowerCase().contains(q));
        }).toList();
      });
    });
  }

  bool _matchDemand(TenantDemandModel d, String q) {
    final date = formatApiDate(d.createdDate).toLowerCase();

    return [
      d.tname,
      d.tnumber,
      d.buyRent,
      d.reference,
      d.price,
      d.message,
      d.bhk,
      d.location,
      d.status,
      d.result,
      date,
    ].any((f) => f.toString().toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:
      isDark ? const Color(0xFF090B11) : const Color(0xFFF4F6FA),

      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Stack(
        children: [
          // background glow gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [
                    const Color(0xFF0E1018),
                    const Color(0xFF11131D),
                    const Color(0xFF0A0B11),
                  ]
                      : [
                    Colors.white,
                    const Color(0xFFE9ECF3),
                    const Color(0xFFDDE2ED),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),

          Column(
            children: [
              const SizedBox(height: 10),
              // floating search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Colors.white.withOpacity(0.85),
                    boxShadow: [
                      BoxShadow(
                        color: isDark
                            ? Colors.black.withOpacity(0.3)
                            : Colors.grey.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.1),
                      width: 0.6,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: "Search Here",
                      hintStyle: TextStyle(
                        color: isDark
                            ? Colors.white.withOpacity(0.4)
                            : Colors.black54,
                        fontSize: 15,
                      ),
                      prefixIcon: Icon(Icons.search,
                          color: isDark
                              ? Colors.white70
                              : Colors.black54),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                        icon: Icon(Icons.close_rounded,
                            color: isDark
                                ? Colors.white54
                                : Colors.black54),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _filteredParent = _parentDemands;
                            _filteredRedemands = _redemands;
                          });
                        },
                      )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 14),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Expanded(
                child: (_filteredParent.isEmpty && _filteredRedemands.isEmpty)
                    ? Center(
                  child: Text(
                    "No demands found",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: _loadDemands,
                  color: theme.colorScheme.primary,
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [

                      // =================== PARENT DEMANDS ===================
                      if (_filteredParent.isNotEmpty) ...[
                        _sectionTitle("Demands"),
                        ..._filteredParent.map((d) =>
                            _buildDemandTile(d, isDark),
                        ),
                      ],

                      // if (_filteredRedemands.isNotEmpty) ...[
                      //   const SizedBox(height: 24),
                      //   _sectionTitle("Cross ReDemands"),
                      //   ..._filteredRedemands.map((d) =>
                      //       _buildRedemandTile(d, isDark),
                      //   ),
                      //]

                        if (_filteredCrossRedemands.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _sectionTitle("Transferred ReDemands"),
                            ..._filteredCrossRedemands.map(
                            (d) => buildTransferredDemandTile(
                            d,
                            isDark,
                            context,
                            onTap: () {
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (_) => RedemandSubadmin(
                            redemandId: d.redemandId.toString(),
                            demandId: d.demandId.toString(),
                            ),
                            ),
                            ).then((_) => _loadTransferRedemand());
                            },
                            ),
                            ),
                        ],
                      ],
                  ),
                ),
              )

            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  Widget _buildDemandTile(TenantDemandModel d, bool isDark) {
    return _buildCommonTile(
      d,
      isDark,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SubDemandDetails(
              demandId: d.id.toString(),
            ),
          ),
        ).then((_) => _loadDemands());
      },
    );
  }

  Widget _buildRedemandTile(TenantDemandModel d, bool isDark) {
    return _buildCommonTile(
      d,
      isDark,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RedemandSubadmin(
              redemandId: d.id.toString(),
              demandId: d.subid.toString(),
            ),
          ),
        ).then((_) => _loadDemands());
      },
    );
  }


  Widget buildTransferredDemandTile(
      RedemandTransferModel d,
      bool isDark,
      BuildContext context, {
        required VoidCallback onTap,
      }) {
    final bool isUrgent = d.mark == "1";
    final baseColor = isDark ? const Color(0xFF1C1F27) : Colors.white;

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap,
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

              // ---------- AVATAR ----------
              leading: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: isUrgent
                        ? [Colors.redAccent, Colors.redAccent.shade700]
                        : [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isUrgent
                          ? Colors.redAccent.withOpacity(0.3)
                          : Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Center(
                  child: Text(
                    d.tname.isNotEmpty ? d.tname[0].toUpperCase() : "?",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),

              // ---------- TITLE ----------
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
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.45),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      d.buyRent.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5,
                      ),
                    ),
                  ),
                ],
              ),

              // ---------- SUBTITLE ----------
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${d.assignedSubadminLocation} • ${d.bhk}",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "₹ ${d.price}",
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),

                    // 🔁 TRANSFER CONTEXT (small, subtle)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        "Transferred from ${d.mainAssignedLocation}",
                        style: TextStyle(
                          fontSize: 12.5,
                          color:
                          isDark ? Colors.orangeAccent : Colors.orange[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // ---------- STATUS RIBBON ----------
        _buildRibbon(
          "TRANSFER",
          Colors.deepPurple.shade500,
          Colors.deepPurple.shade700,
        ),
      ],
    );
  }



  Widget _buildCommonTile(
      TenantDemandModel d,
      bool isDark, {
        required VoidCallback onTap,
      }) {
    final isUrgent = d.mark == "1";
    final baseColor = isDark ? const Color(0xFF1C1F27) : Colors.white;

    return Stack(
      children: [
        GestureDetector(
          onTap: onTap, // ✅ single source of truth
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
                        ? [Colors.redAccent, Colors.redAccent.shade700]
                        : [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isUrgent
                          ? Colors.redAccent.withOpacity(0.3)
                          : Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.25),
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
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isUrgent
                          ? Colors.redAccent.withOpacity(0.8)
                          : Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.45),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      d.buyRent.toUpperCase(),
                      style: const TextStyle(
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
                    Text(
                      "${d.location} • ${d.bhk}",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      "₹ ${d.price}",
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    if (d.reference.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Ref: ${d.reference}",
                              style: TextStyle(
                                color:
                                isDark ? Colors.white38 : Colors.black45,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              formatApiDate(d.createdDate),
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // 🎯 STATUS RIBBONS (UNCHANGED)
        if (d.status.toLowerCase() == "assign to subadmin")
          _buildRibbon("NEW", Colors.green.shade500, Colors.green.shade700),

        if (d.status.toLowerCase() == "redemand")
          _buildRibbon("REDEMAND", Colors.green.shade500, Colors.green.shade700),

        if (d.status.toLowerCase() == "disclosed")
          _buildRibbon("DISCLOSED", Colors.red.shade500, Colors.red.shade700),

        if (d.status.toLowerCase() == "assigned to fieldworker")
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



  String formatApiDate(String apiDate) {
    if (apiDate.isEmpty) return "";

    try {
      final dt = DateTime.parse(apiDate);
      return "${dt.day} ${_month(dt.month)} ${dt.year}";
    } catch (_) {
      return apiDate;
    }
  }

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }

}
