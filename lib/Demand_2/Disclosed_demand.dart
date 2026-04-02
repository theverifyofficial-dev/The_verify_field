import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Demand_2/redemand_detailpage.dart';
import '../../model/demand_model.dart';
import '../Custom_Widget/Demand_card.dart';
import '../Custom_Widget/pin_demand.dart';
import '../utilities/bug_founder_fuction.dart';
import 'Demand_detail.dart';

class DisclosedDemand extends StatefulWidget {
  const DisclosedDemand({super.key});
  @override
  State<DisclosedDemand> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<DisclosedDemand> {

  List<TenantDemandModel> _allDemands = [];
  List<TenantDemandModel> _filteredDemands = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  bool _showRedemands = false; // 👈 default collapsed
  int _page = 1;
  final int _limit = 20;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  bool _isSearching = false;
  String _lastQuery = "";
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _redemands = [];
  List<Map<String, dynamic>> _filteredRedemands = [];

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
      final name = prefs.getString('name') ?? "";

      final encodedName = Uri.encodeQueryComponent(name);

      final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/"
            "Tenant_demand/show_api_for_new_tenant_demand_for_fieldworkar_and_status.php"
            "?Status=disclosed"
            "&assigned_fieldworker_name=$encodedName"
            "&page=$_page"
            "&limit=$_limit",
      );

      final response = await http.get(url);

      print("📡 Fetching from : $url");


      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true && decoded["data"] is List) {
          final List data = decoded["data"];

          final newList = data
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();

          if (newList.length < _limit) {
            _hasMore = false;
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


      final redemandUrl = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/"
            "Tenant_demand/display_redemand_show_feildwakrname_and_status.php"
            "?Status=disclosed"
            "&assigned_fieldworker_name=$encodedName"
            "&page=1"
            "&limit=20",
      );

      final redRes = await http.get(redemandUrl);

      if (redRes.statusCode == 200) {
        final decoded = jsonDecode(redRes.body);

        if (decoded["success"] == true) {
          final List data = decoded["data"];

          setState(() {
            _redemands = List<Map<String, dynamic>>.from(data);
            _filteredRedemands = _redemands;
          });
        }
      }
    } catch (e) {
      await BugLogger.log(
        apiLink: "show_api_for_new_tenant_demand_for_fieldworkar_and_status.php",
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

  Future<void> _searchDemands({
    required String query,
    bool reset = false,
  })
  async {
    if (_isFetchingMore) return;

    if (reset) {
      _page = 1;
      _hasMore = true;
      _filteredDemands.clear();
    }

    setState(() => _isFetchingMore = true);

    try {
      final prefs = await SharedPreferences.getInstance();
      final name = Uri.encodeQueryComponent(prefs.getString('name') ?? "");
      final q = Uri.encodeQueryComponent(query);

      final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/"
            "Tenant_demand/search_api_for_fieldworkar.php"
            "?q=$q"
            "&assigned_fieldworker_name=$name"
            "&page=$_page"
            "&limit=$_limit",
      );


      final res = await http.get(url);
      final decoded = jsonDecode(res.body);

      if (decoded["status"] == true) {
        final List list = decoded["data"];
        final newItems =
        list.map((e) => TenantDemandModel.fromJson(e)).toList();

        if (newItems.length < _limit) _hasMore = false;

        _page++;

        setState(() => _filteredDemands.addAll(newItems));
      } else {
        _hasMore = false;
      }
    } finally {
      if (mounted) {
        setState(() => _isFetchingMore = false);
      }
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      final q = _searchController.text.trim();

      _filteredRedemands = _redemands.where((d) {
        return [
          d["id"],
          d["Tname"],
          d["Tnumber"],
          d["Location"],
          d["Bhk"],
          d["Buy_rent"],
          d["final_reason"],
          d["Price"],
          d["Date"],
        ].any((field) =>
            field.toString().toLowerCase().contains(q));
      }).toList();

      if (q.isEmpty) {
        _isSearching = false;
        _loadDemands(reset: true);
        return;
      }

      _isSearching = true;
      _lastQuery = q;
      _searchDemands(query: q, reset: true);
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !_isFetchingMore &&
        _hasMore) {

      if (_isSearching) {
        _searchDemands(query: _lastQuery);
      } else {
        _loadDemands();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF8FAFC),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.red,))
          : Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 10),
              // floating search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  style: TextStyle(color: Colors.grey.shade700),
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search demands...",
                    hintStyle: TextStyle(color: Colors.grey.shade700),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.grey.shade700,
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _isSearching = false;
                          _loadDemands(reset: true);
                        });
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),


              Expanded(
                child: _filteredDemands.isEmpty
                    ? Center(
                  child: Text(
                    "No demands found",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
                    : RefreshIndicator(
                  onRefresh: _loadDemands,
                  color: theme.colorScheme.primary,
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [

                      /// 🔴 REDEMAND SECTION
                      if (_filteredRedemands.isNotEmpty) ...[
                        GestureDetector(
                          onTap: () {
                            setState(() => _showRedemands = !_showRedemands);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    "Closed ReDemands",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.4,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                Icon(
                                  _showRedemands
                                      ? Icons.keyboard_arrow_up
                                      : Icons.keyboard_arrow_down,
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_showRedemands)
                        ..._filteredRedemands.map((d) {
                          return _buildRedemandCard(d);
                        }),

                        const SizedBox(height: 20),
                      ],

                      _sectionTitle("Closed Demands"),

                      /// ⚪ NORMAL DEMANDS
                      ..._filteredDemands.map((d) {
                        return DemandCard(
                          d: d,
                          isField: true, // only for fieldworker
                          type: "demand", // 👈 here
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DemandDetail(
                                  demandId: d.id.toString(),
                                  isReadOnly: true,
                                ),
                              ),
                            ).then((_) => _loadDemands());
                          },
                        );
                      }),

                      if (_hasMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  )
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.4,
                color: Colors.grey
            ),
          ),

          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PinDemand(),
                ),
              );
            },
            icon: const Icon(Icons.bookmark_outlined, size: 14),
            label: const Text("Pinned"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              elevation: 1, // subtle
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              minimumSize: Size.zero, // 🔥 removes default big size
              tapTargetSize: MaterialTapTargetSize.shrinkWrap, // 🔥 compact
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRedemandCard(Map d) {
    final model = TenantDemandModel.fromJson(
      Map<String, dynamic>.from(d),
    );
    return Stack(
      children: [

        DemandCard(
          isField: true, // only for fieldworker
          d: model,
          type: "redemand",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReDemandDetailPage(
                  RedemandId: d["id"].toString(),
                  isReadOnly: true,
                ),
              ),
            ).then((_) => _loadDemands());
          },
        ),

        /// 🔴 REDEMAND BADGE
        Positioned(
          bottom: 30,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              "ReDemand",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        // /// 🔥 FINAL REASON (EXTRA OVERLAY)
        // if (d["final_reason"] != null &&
        //     d["final_reason"].toString().isNotEmpty)
        //   Positioned(
        //     left: 16,
        //     right: 16,
        //     bottom: 8,
        //     child: Container(
        //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        //       decoration: BoxDecoration(
        //         color: Colors.red.withOpacity(0.08),
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //       child: Text(
        //         d["final_reason"],
        //         style: const TextStyle(
        //           fontSize: 12,
        //           color: Colors.redAccent,
        //           fontWeight: FontWeight.w600,
        //         ),
        //         maxLines: 1,
        //         overflow: TextOverflow.ellipsis,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}