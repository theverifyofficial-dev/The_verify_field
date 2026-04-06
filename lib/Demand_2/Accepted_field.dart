import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verify_feild_worker/Demand_2/Add_demand_field.dart';
import 'package:verify_feild_worker/Demand_2/redemand_detailpage.dart';
import '../../model/demand_model.dart';
import '../Custom_Widget/Demand_card.dart';
import '../Custom_Widget/pin_demand.dart';
import '../utilities/bug_founder_fuction.dart';
import 'Demand_detail.dart';

class AcceptedField extends StatefulWidget {
  const AcceptedField({super.key});
  @override
  State<AcceptedField> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<AcceptedField> {

  List<TenantDemandModel> _parentDemands = [];
  List<TenantDemandModel> _crossRedemands = [];

  List<TenantDemandModel> _filteredParent = [];
  List<TenantDemandModel> _filteredCross = [];

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
      final prefs = await SharedPreferences.getInstance();
      final FName = prefs.getString('name') ?? "";

      if (FName.isEmpty) return;

      final encodedName = Uri.encodeQueryComponent(FName);

      final url = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/display_accept_demand.php"
            "?assigned_fieldworker_name=$encodedName"
            "&page=$_page"
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
              _parentDemands = newData;
            } else {
              _parentDemands.addAll(newData);
            }

            _filteredParent = _parentDemands;

            // 🔥 if less data comes → no more pages
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
      d.id,
      date,
    ].any((field) =>
        field.toString().toLowerCase().contains(q));
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
            MaterialPageRoute(builder: (_) => const AddDemandField(mode: DemandEditMode.add,)),
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
                            _filteredParent = _parentDemands;
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



                Expanded(
                    child:  ((_parentDemands.isEmpty && !_isLoading))
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
                      child:
                      ListView(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [



                          if (_filteredCross.isNotEmpty) ...[
                            Row(
                              children: [
                                // 🔹 ReDemands (Primary Action Button Style)
                                Expanded(
                                  child: Material(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(12),
                                      onTap: () {
                                        setState(() => _showRedemands = !_showRedemands);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: Colors.grey.shade200),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.04),
                                              blurRadius: 6,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            // 🔥 icon makes it feel like action button
                                            Icon(Icons.list_alt, color: Colors.black54, size: 18),

                                            const SizedBox(width: 10),

                                            const Expanded(
                                              child: Text(
                                                "ReDemands",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),

                                            AnimatedRotation(
                                              turns: _showRedemands ? 0.5 : 0,
                                              duration: const Duration(milliseconds: 200),
                                              child: const Icon(Icons.keyboard_arrow_down, color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                // 🔹 Pinned (Secondary)
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
                                    backgroundColor: Colors.amber,
                                    foregroundColor: Colors.black,
                                    elevation: 1,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    textStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            if (_showRedemands)
                            ..._filteredCross.map((d) {
                              return _buildRedemandCard(d, true);
                            }),
                            if (_showRedemands && _isFetchingMoreRed)
                              const Padding(
                                padding: EdgeInsets.all(12),
                                child: Center(child: CircularProgressIndicator()),
                              ),

                            const SizedBox(height: 20),
                          ],

                          _sectionTitle("Your Demands"),
                          if (_filteredParent.isNotEmpty) ...[
                            ..._filteredParent.map((d) {
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
                                      ),
                                    ),
                                  ).then((_) => _loadDemands());
                                },
                              );
                            }),                          ],

                          if (_isFetchingMore)
                            const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            ),

                        ],
                      ),
                    )            ),
              ]
          ),

        ],
      ),
    );
  }

  Widget _buildRedemandCard(TenantDemandModel d, isRedemand) {
    return Stack(
      children: [
        DemandCard(
          d: d,
          isField: true, // only for fieldworker
          type: "redemand",
          onTap: () {
            if (isRedemand == true) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReDemandDetailPage(
                    RedemandId: d.id.toString(),
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DemandDetail(
                    demandId: d.id.toString(),
                    isReadOnly: true,
                  ),
                ),
              );
            }
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
                color: Colors.black
            ),
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
