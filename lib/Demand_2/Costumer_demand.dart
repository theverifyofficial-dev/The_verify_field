import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Demand_2/Add_demand_field.dart';
import 'package:verify_feild_worker/Demand_2/redemand_detailpage.dart';
import '../../model/demand_model.dart';
import '../utilities/bug_founder_fuction.dart';
import 'Demand_detail.dart';

class CostumerDemand extends StatefulWidget {
  const CostumerDemand({super.key});
  @override
  State<CostumerDemand> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<CostumerDemand> {

  List<TenantDemandModel> _parentDemands = [];
  List<TenantDemandModel> _crossRedemands = [];

  List<TenantDemandModel> _filteredParent = [];
  List<TenantDemandModel> _filteredCross = [];

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
      final FName = prefs.getString('name') ?? "";
      final FLocation = prefs.getString('location') ?? "";
      print(FName);
      print(FLocation);

      if (FName.isEmpty || FLocation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info missing. Please login again.")),
        );
        return;
      }

      // Encode name & location for URL safety
      final encodedName = Uri.encodeQueryComponent(FName);
      final encodedLoc = Uri.encodeQueryComponent(FLocation);

      final url = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_fieldworkar_page.php?assigned_fieldworker_name=$encodedName&assigned_fieldworker_location=$encodedLoc");
      final response = await http.get(url);

       final crossRedemands = await _loadCrossRedemand();


      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == "success") {
          final parents = (decoded["data"] as List)
              .map((e) => TenantDemandModel.fromJson(e))
              .toList()
              .reversed
              .toList();
          setState(() {
            _parentDemands = parents;
            _crossRedemands = crossRedemands;

            _filteredParent = parents;
            _filteredCross = crossRedemands;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No demand data found")),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("HTTP Error: ${response.statusCode}")),
          );
        }
      }

    } catch (e) {
      await BugLogger.log(
        apiLink: "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_fieldworkar_page.php?assigned_fieldworker_name=encodedName&Location=encodedLoc",
        error: e.toString(),
        statusCode: 500,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<List<TenantDemandModel>> _loadCrossRedemand() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name') ?? "";
      final location = prefs.getString('location') ?? "";

      if (name.isEmpty || location.isEmpty) return [];

      final encodedName = Uri.encodeQueryComponent(name);
      final encodedLoc = Uri.encodeQueryComponent(location);

      final url =
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/"
          "share_demand_one_field_two_fieldwoarkar.php"
          "?assigned_fieldworker_location=$encodedLoc"
          "&assigned_fieldworker_name=$encodedName";

      print(url);


      final res = await http.get(Uri.parse(url));

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        if (decoded["success"] == true && decoded["data"] is List) {
          return (decoded["data"] as List)
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      await BugLogger.log(
        apiLink:
        "show_redemand_based_on_sub_id_and_name_location.php",
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
        _filteredParent = _parentDemands.where((d) => _matchDemand(d, q)).toList();
        _filteredCross = _crossRedemands.where((d) => _matchDemand(d, q)).toList(); });
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
    ].any((field) =>
        field.toString().toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:
      isDark ? const Color(0xFF090B11) : const Color(0xFFF4F6FA),

      floatingActionButton: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary.withOpacity(0.9),
              theme.colorScheme.primaryContainer.withOpacity(0.9)
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.4),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton.extended(
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text(
            "Add Demand",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
              letterSpacing: 0.3,
            ),
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddDemandField()),
          ).then((_) => _loadDemands()),
        ),
      ),


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
                            _filteredCross = _crossRedemands;
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
                child:  (_filteredParent.isEmpty)
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
                child:
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [

                    if (_filteredParent.isNotEmpty) ...[
                      _sectionTitle("Demands"),
                      ..._filteredParent.map((d) => _buildDemandTile(d, isDark)),
                    ],

                    if (_filteredCross.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      _sectionTitle("Cross ReDemands"),
                      ..._filteredCross.map((d) => _buildCrossRedemandTile(d, isDark)),
                    ],
                  ],
                ),
              )            ),
              ]
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
            builder: (_) => DemandDetail(
              demandId: d.id.toString(),
            ),
          ),
        ).then((_) => _loadDemands());
      },
    );
  }

  Widget _buildCrossRedemandTile(TenantDemandModel d, bool isDark) {
    return _buildCommonTile(
      d,
      isDark,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => field_RedemandDetailPage(
              redemandId: d.r_id.toString(),
              // demandId: d.subid.toString(),
            ),
          ),
        ).then((_) => _loadDemands());
      },
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
        if (d.status.toLowerCase() == "redemand")
          _buildRibbon("REDEMAND", Colors.green.shade500, Colors.green.shade700),

        if (d.status.toLowerCase() == "disclosed")
          _buildRibbon("DISCLOSED", Colors.red.shade500, Colors.red.shade700),

        if (d.status.toLowerCase() == "assigned to fieldworker")
          _buildRibbon("NEW", Colors.green.shade500, Colors.green.shade700),
        if (d.re_status.toLowerCase() == "redemand")
          _buildRibbon("REDEMAND", Colors.green.shade500, Colors.green.shade700),

        if (d.re_status.toLowerCase() == "disclosed")
          _buildRibbon("DISCLOSED", Colors.red.shade500, Colors.red.shade700),

        if (d.re_status.toLowerCase() == "assigned to fieldworker")
          _buildRibbon("NEW", Colors.green.shade500, Colors.green.shade700),
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
