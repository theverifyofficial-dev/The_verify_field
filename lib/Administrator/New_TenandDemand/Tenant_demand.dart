import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import '../../constant.dart';
import '../../model/demand_model.dart';
import 'Add_demand.dart';
import 'Admin_demand_detail.dart';

class TenantDemand extends StatefulWidget {
  const TenantDemand({super.key});
  @override
  State<TenantDemand> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<TenantDemand> {
  List<TenantDemandModel> _allDemands = [];
  List<TenantDemandModel> _filteredDemands = [];
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
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand.php"));
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        final list =
        data.map((e) => TenantDemandModel.fromJson(e)).toList().reversed.toList();
        setState(() {
          _allDemands = list;
          _filteredDemands = list;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $e")),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 250), () {
      final q = _searchController.text.toLowerCase().trim();

      setState(() {
        _filteredDemands = _allDemands.where((d) {
          // extract date safely
          final rawDate = d.createdDate;
          final formattedDate = formatApiDate(rawDate).toLowerCase();

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
            formattedDate, // allow searching "13 nov 2025"
          ].any((field) =>
              field.toString().toLowerCase().contains(q)
          );
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:
      isDark ? const Color(0xFF090B11) : const Color(0xFFF4F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.black,
        surfaceTintColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 70),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(PhosphorIcons.caret_left_bold, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
            MaterialPageRoute(builder: (_) => const CustomerDemandFormPage()),
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
              const SizedBox(height: 100),
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
                          setState(() =>
                          _filteredDemands = _allDemands);
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
                child: _filteredDemands.isEmpty
                    ? Center(
                  child: Text(
                    "No demands found",
                    style: TextStyle(
                      color: isDark
                          ? Colors.white70
                          : Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: _loadDemands,
                  color: theme.colorScheme.primary,
                  child: ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredDemands.length,
                    itemBuilder: (_, i) {
                      final d = _filteredDemands[i];
                      final isUrgent = d.mark == "1";
                      final baseColor = isDark
                          ? const Color(0xFF1C1F27)
                          : Colors.white;

                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AdminDemandDetail(demandId: d.id.toString()),
                                ),
                              ).then((_) => _loadDemands());
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
                                      Text(
                                        d.buyRent,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: isUrgent
                                              ? Colors.redAccent
                                              : theme.colorScheme.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start, children: [
                                      Text("${d.location} • ${d.bhk} BHK",
                                          style: TextStyle( color: isDark ? Colors.white70 : Colors.black54, fontSize: 14)),
                                    const SizedBox(height: 2),
                                    Text("₹ ${d.price}", style: TextStyle( color: isDark ? Colors.white60 : Colors.black54, fontSize: 14)),
                                    if (d.reference.isNotEmpty)
                                      Padding( padding: const EdgeInsets.only(top: 3), child:
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text( "Ref: ${d.reference}", style: TextStyle( color: isDark ? Colors.white38 : Colors.black45, fontSize: 13), ),

                                    Text(
                                      formatApiDate(d.createdDate),
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                    )

                                  ],
                                ),),
                                  ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
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
