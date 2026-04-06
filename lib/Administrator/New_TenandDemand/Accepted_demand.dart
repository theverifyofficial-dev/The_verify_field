import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Custom_Widget/Demand_card.dart';
import '../../Demand_2/Demand_detail.dart';
import '../../Demand_2/redemand_detailpage.dart';
import '../../model/demand_model.dart';

class AcceptedDemand extends StatefulWidget {
  const AcceptedDemand({super.key});
  @override
  State<AcceptedDemand> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<AcceptedDemand> {
  List<TenantDemandModel> _allDemands = [];
  List<TenantDemandModel> _filteredDemands = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  Timer? _debounce;
  int _page = 1;
  final int _limit = 20;
  bool _isFetchingMore = false;
  bool _hasMore = true;
  bool _showRedemands = false; // 👈 default collapsed

  int _redPage = 1;
  bool _isFetchingMoreRed = false;
  bool _hasMoreRed = true;

  List<TenantDemandModel> _crossRedemands = [];
  List<TenantDemandModel> _filteredCross = [];
  String? _selectedFilter;


  final List<String> _quickFilters = [
    "Sumit",
    "Ravi Kumar",
    "Faizan Khan",
  ];

  @override
  void initState() {
    super.initState();
    _loadDemands(reset: true);
    _fetchRedemands(reset: true); // 🔥 ADD THIS

    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);

  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {

      if (!_isFetchingMore && _hasMore) {
        _loadDemands();
      }

      if (_showRedemands && !_isFetchingMoreRed && _hasMoreRed) {
        _fetchRedemands();
      }
    }
  }

  Future<void> _loadDemands({bool reset = false}) async {
    if (_isFetchingMore) return;

    if (reset) {
      _page = 1;
      _hasMore = true;
    }

    setState(() {
      if (_page == 1) {
        _isLoading = true;
      } else {
        _isFetchingMore = true;
      }
    });

    try {
      final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/display_accept_demand.php"
            "?page=$_page"
            "&limit=$_limit",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true) {
          final newData = (decoded["data"] as List)
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();

          setState(() {
            if (_page == 1) {
              _allDemands = newData;
            } else {
              _allDemands.addAll(newData);
            }

            // 🔥 SEARCH SAFE UPDATE
            if (_searchController.text.isEmpty) {
              _filteredDemands = _allDemands;
            } else {
              _onSearchChanged();
            }

            // 🔥 pagination control
            if (newData.length < _limit) {
              _hasMore = false;
            } else {
              _page++;
            }
          });

        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
        _isFetchingMore = false;
      });
    }
  }

  Future<void> _fetchRedemands({bool reset = false}) async {
    if (_isFetchingMoreRed) return;

    if (reset) {
      _redPage = 1;
      _hasMoreRed = true;
      _crossRedemands.clear();
      _filteredCross.clear();
    }

    if (!_hasMoreRed) return;

    setState(() {
      _isFetchingMoreRed = true;
    });

    try {
      final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/"
            "Tenant_demand/display_redemand_show_feildwakrname_and_status.php"
            "?Status=disclosed"
            "&page=$_redPage"
            "&limit=$_limit",
      );

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final decoded = jsonDecode(res.body);

        if (decoded["success"] == true) {
          final List data = decoded["data"];

          final newList = data
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();

          if (newList.length < _limit) {
            _hasMoreRed = false;
          }

          setState(() {
            _crossRedemands.addAll(newList);
            _filteredCross = List.from(_crossRedemands);
          });

          _redPage++;
        } else {
          _hasMoreRed = false;
        }
      }
    } catch (e) {
      print("Redemand error: $e");
    } finally {
      setState(() {
        _isFetchingMoreRed = false;
      });
    }
  }


  void _onSearchChanged() {
    if (_searchController.text.trim() != _selectedFilter) {
      _selectedFilter = null;
    }
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 250), () {
      final q = _searchController.text.toLowerCase().trim();

      setState(() {

        _filteredCross = _crossRedemands.where((d) {
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
            d.assignedFieldworkerName,
            d.id,
            formattedDate,
          ].any((field) =>
              field.toString().toLowerCase().contains(q));
        }).toList();

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
            d.assignedFieldworkerName,
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
                          _selectedFilter = null;
                          _filteredDemands = _allDemands;
                          _filteredCross = _crossRedemands;
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

              const SizedBox(height: 16),

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

              const SizedBox(height: 16),


              Expanded(
                child: _allDemands.isEmpty && !_isLoading
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
                    onRefresh: () => _loadDemands(reset: true),
                    color: theme.colorScheme.primary,
                  child: ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [

                      /// 🔴 REDEMAND SECTION
                      if (_filteredCross.isNotEmpty) ...[
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
                                    "Your Redemands (${_filteredCross.length})",
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
                          ..._filteredCross.map((d) {
                          return _buildRedemandCard(d);
                        }),

                        if (_showRedemands && _isFetchingMoreRed)
                          const Padding(
                            padding: EdgeInsets.all(12),
                            child: Center(child: CircularProgressIndicator()),
                          ),

                        const SizedBox(height: 20),
                      ],

                      /// ⚪ NORMAL DEMANDS
                      if (_filteredDemands.isNotEmpty) ...[
                        _sectionTitle("All Demands"),

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
                              ).then((_) => _loadDemands());
                            },
                          );
                        }),
                      ],

                      if (_isFetchingMore)
                        const Padding(
                          padding: EdgeInsets.all(16),
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

  String formatApiDate(String apiDate) {
    if (apiDate.isEmpty) return "";

    try {
      final dt = DateTime.parse(apiDate);
      return "${dt.day} ${_month(dt.month)} ${dt.year}";
    } catch (_) {
      return apiDate;
    }
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

  Widget _buildRedemandCard(TenantDemandModel d) {
    return Stack(
      children: [

        /// BASE CARD
        DemandCard(
          d: d,
          type: "redemand",
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ReDemandDetailPage(
                  RedemandId: d.id.toString(),
                  isReadOnly: true,
                ),
              ),
            ).then((_) => _loadDemands());
          },
        ),

        /// 🔥 BADGE
        Positioned(
          bottom: 30,
          right: 10,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFDC2626),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.red.withOpacity(0.4),
                  blurRadius: 6,
                )
              ],
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

  String _month(int m) {
    const months = [
      "Jan","Feb","Mar","Apr","May","Jun",
      "Jul","Aug","Sep","Oct","Nov","Dec"
    ];
    return months[m - 1];
  }

}
