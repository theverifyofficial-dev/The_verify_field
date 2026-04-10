import 'dart:async';
import 'dart:convert';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:http/http.dart' as http;
import '../../Custom_Widget/Demand_card.dart';
import '../../Demand_2/Demand_detail.dart';
import '../../Demand_2/redemand_detailpage.dart';
import '../../model/demand_model.dart';
import '../../utilities/bug_founder_fuction.dart';

class AdminDisclosedDemand extends StatefulWidget {
  const AdminDisclosedDemand({super.key});
  @override
  State<AdminDisclosedDemand> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<AdminDisclosedDemand> {

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
  String _currentQuery = "";
  bool _searchLoading = false;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> _redemands = [];
  List<Map<String, dynamic>> _filteredRedemands = [];
  String? _selectedFilter;

  final List<String> _quickFilters = [
    "Sumit",
    "Ravi Kumar",
    "Faizan Khan",
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchDemands(reset: true);
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  Future<void> _fetchDemands({bool reset = false}) async {
    final localQuery = _currentQuery;

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

      // ✅ Only show full loader when NOT searching
      if (reset && !_isSearching) {
        _isLoading = true;
      }
    });


    try {
      final Uri url = _isSearching
          ? Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/search_api_in_tenant_demand.php"
            "?q=${Uri.encodeQueryComponent(_currentQuery)}"
            "&page=$_page&limit=$_limit",
      )
          : Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand.php"
            "?Status=disclosed&page=$_page&limit=$_limit",
      );

      AppLogger.api("📡 Fetching: $url");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        final bool ok =
            decoded["success"] == true || decoded["status"] == true;

        if (ok && decoded["data"] is List) {
          final List data = decoded["data"];

          final newList = data
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();

          if (_page == 1 && newList.isEmpty) {
            _hasMore = false;
          }

          if (newList.length < _limit) _hasMore = false;

          if (_isSearching && localQuery != _currentQuery) return;

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
        apiLink: "Demand Fetch",
        error: e.toString(),
        statusCode: 500,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isFetchingMore = false;
          _searchLoading = false;

          // ✅ Only stop full loader if not searching
          if (!_isSearching) {
            _isLoading = false;
          }
        });

      }
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300 &&
        !_isFetchingMore &&
        _hasMore) {
      _fetchDemands();
    }
  }

  void _onSearchChanged() {

    if (_searchController.text.trim() != _selectedFilter) {
      _selectedFilter = null;
    }

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
          d["assigned_fieldworker_name"],
          d["final_reason"],
          d["Price"],
          d["Date"],
        ].any((field) =>
            field.toString().toLowerCase().contains(q));
      }).toList();

      if (q.isEmpty) {
        _isSearching = false;
        _currentQuery = "";
        _fetchDemands(reset: true);
        return;
      }
      setState(() {
        _isSearching = true;
        _searchLoading = true;
        _currentQuery = q;
      });
      _fetchDemands(reset: true);
    });
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
                    hintStyle: TextStyle(color: Colors.grey.shade700),
                    prefixIcon: const Icon(Icons.search),
                    prefixIconColor: Colors.grey.shade700,
                    hintText: "Search demands...",
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedFilter = null;
                          _filteredDemands = _allDemands;
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
                      color: Colors.green.shade600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickFilters.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final name = _quickFilters[i];
                    final isSelected = _selectedFilter == name;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedFilter = name;

                          /// 🔥 auto fill search
                          _searchController.text = name;
                        });

                        _onSearchChanged(); // trigger filtering
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2563EB) // 🔵 blue selected
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? const Color(0xFF2563EB)
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),


              if (_searchLoading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: LinearProgressIndicator(minHeight: 2),
                ),

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
                  onRefresh: () => _fetchDemands(reset: true),
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
                                    "Closed ReDemands (${_filteredRedemands.length})",
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
                            ).then((_) => _fetchDemands());
                          },
                        );
                      }),

                      if (_hasMore)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(child: CircularProgressIndicator(color: Colors.red,)),
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
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
            color: Colors.grey
        ),
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
            ).then((_) => _fetchDemands());
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
      ],
    );
  }
}
