import 'dart:async';
import 'dart:convert';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:http/http.dart' as http;
import '../../Custom_Widget/Demand_card.dart';
import '../../Demand_2/Demand_detail.dart';
import '../../model/demand_model.dart';
import '../../utilities/bug_founder_fuction.dart';
import 'Add_demand.dart';

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
  int _page = 1;
  final int _limit = 10;

  bool _isFetchingMore = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadDemands();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        if (_hasMore && !_isFetchingMore) {
          _loadDemands();
        }
      }
    });
  }

  Future<void> _loadDemands({bool isRefresh = false}) async {
    if (_isFetchingMore) return;

    if (isRefresh) {
      _page = 1;
      _hasMore = true;
    }

    setState(() {
      if (_page == 1) _isLoading = true;
      _isFetchingMore = true;
    });

    try {
      final url = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand.php"
              "?Status=new&page=$_page&limit=$_limit"
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          final newData = (decoded["data"] as List)
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();

          setState(() {
            if (_page == 1) {
              _allDemands = newData;
            } else {
              _allDemands.addAll(newData);
            }

            _filteredDemands = _allDemands;

            // 🔥 pagination end check
            if (newData.length < _limit) {
              _hasMore = false;
            } else {
              _page++;
            }
          });
        }
      }
    } catch (e) {
      print(e);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isFetchingMore = false;
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
            d.id,
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
          backgroundColor: const Color(0xFFDC2626),
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
            MaterialPageRoute(builder: (_) => const CustomerDemandFormPage(mode: DemandEditMode.add,)),
          ).then((_) => _loadDemands()),
        ),
      ),
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

              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Loaded: ${_allDemands.length}",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                  ],
                ),
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
                  onRefresh: () => _loadDemands(isRefresh: true),
                  color: theme.colorScheme.primary,
                  child: ListView.builder(
                    controller: _scrollController,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredDemands.length + (_isFetchingMore ? 1 : 0),
                    itemBuilder: (_, i) {
                      // 🔥 LAST ITEM = LOADER
                      if (i == _filteredDemands.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final d = _filteredDemands[i];

                      return DemandCard(
                        d: d,
                        type: "demand",
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
