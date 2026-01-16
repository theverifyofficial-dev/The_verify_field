import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Administrator/SubAdmin/sub_demand_details.dart';
import '../../Custom_Widget/constant.dart';
import '../../model/demand_model.dart';
import '../../utilities/bug_founder_fuction.dart';

class SubadminDisclose extends StatefulWidget {
  const SubadminDisclose({super.key});
  @override
  State<SubadminDisclose> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<SubadminDisclose> {
  List<TenantDemandModel> _allDemands = [];
  List<TenantDemandModel> _filteredDemands = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  int _page = 1;
  final int _limit = 20;
  bool _isFetchingMore = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();


  @override
  void initState() {
    super.initState();
    _loadDemands();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);

  }

  Future<void> _loadDemands({bool reset = false}) async {

    if (_isFetchingMore) return;

    if (reset) {
      _page = 1;
      _hasMore = true;
      _allDemands.clear();
      _filteredDemands.clear();
    }

    if (!_hasMore) return;

    setState(() {
      _isFetchingMore = true;
      if (reset) _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final subadminName = prefs.getString('name') ?? "";
      final encodedName = Uri.encodeQueryComponent(subadminName);


      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/show_api_for_subadmin_status_api.php?Status=disclosed&assigned_subadmin_name=$encodedName&page=$_page&limit=$_limit",
      );

      print("📡 Fetching page $_page");
      print("📡 Fetching from : $url");

      final response = await http.get(url);
      print("Response: ${response.body}");



      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          final List data = decoded["data"];

          final newList = data
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();

          if (newList.length < _limit) {
            _hasMore = false; // 🚫 no more pages
          }

          _page++;

          setState(() {
            _allDemands.addAll(newList);
            _filteredDemands = List.from(_allDemands);
          });
        } else {
          _hasMore = false;
        }
      } else {
        _hasMore = false;
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: "show_tenant_demand.php",
        error: e.toString(),
        statusCode: 500,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
          _isLoading = false;
        });
      }
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

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !_isFetchingMore &&
        _hasMore &&
        _searchController.text.isEmpty) {
      _loadDemands();
    }
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

              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Loaded Demands: ${_filteredDemands.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark
                          ? Colors.green.shade200
                          : Colors.green.shade800,
                    ),
                  ),
                ),
              ),

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
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredDemands.length + (_hasMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == _filteredDemands.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final d = _filteredDemands[i];
                      final int indexNumber = i + 1; // 🔥 global index
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
                                  builder: (_) => SubDemandDetails(demandId: d.id.toString()),
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
                                            formatApiDate(d.Date),
                                            style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                                          )

                                        ],
                                      ),
                                      ),


                                    if (d.result.toString().isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.red.shade700),
                                          ),
                                          child: Text(
                                            "⚠ Conclusion: ${d.result}",
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.red.shade700,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                            maxLines: 4,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),

                                    if (d.result.toString().isEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8.0),
                                        child: Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade200,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.red.shade700),
                                          ),
                                          child: Text(
                                            "⚠ Conclusion is not Added",
                                            textAlign: TextAlign.center,
                                            style: theme.textTheme.bodySmall?.copyWith(
                                              color: Colors.red.shade700,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
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

                          Positioned(
                            bottom: 20,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.black.withOpacity(0.55)
                                    : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                "$indexNumber",
                                style: TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white70 : Colors.black87,
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
