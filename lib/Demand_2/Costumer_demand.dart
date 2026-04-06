import 'dart:async';
import 'dart:convert';
import '../../AppLogger.dart';
import '../../AppLogger.dart';
import 'package:flutter/material.dart';import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/demand_model.dart';
import '../utilities/bug_founder_fuction.dart';
import 'Add_demand_field.dart';

class CostumerDemand extends StatefulWidget {
  const CostumerDemand({super.key});
  @override
  State<CostumerDemand> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<CostumerDemand> {

  List<TenantDemandModel> _parentDemands = [];
  List<TenantDemandModel> _filteredParent = [];

  int _page = 1;
  final int _limit = 10;

  bool _isFetchingMore = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();

  Set<int> _accepting = {};

  bool _isLoading = true;


  @override
  void initState() {
    super.initState();
    _loadDemands();
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
              _parentDemands = newData;
            } else {
              _parentDemands.addAll(newData);
            }

            _filteredParent = _parentDemands;

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
  Future<void> _acceptDemand(int demandId) async {
    setState(() {
      _parentDemands.removeWhere((d) => d.id == demandId);
      _filteredParent.removeWhere((d) => d.id == demandId);
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('name') ?? "";
      final location = prefs.getString('location') ?? "";

      final url = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/accept_demand_by_fields.php");

      final res = await http.post(url, body: {
        "id": demandId.toString(),
        "assigned_subadmin_name": "Saurabh yadav",
        "assigned_subadmin_location": "Sultanpur",
        "assigned_fieldworker_name": name,
        "assigned_fieldworker_location": location,
      });

      final data = jsonDecode(res.body);

      AppLogger.api(data);

      if (data["success"] != true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Error")),
        );
      }

    } catch (e) {
      // print(e);
    }
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Loaded: ${_parentDemands.length}",
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
                child:  (_filteredParent.isEmpty)
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
                child:
                ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [

                    if (_filteredParent.isNotEmpty) ...[
                      _sectionTitle("New Demands"),
              ..._filteredParent.asMap().entries.map((entry) {
              final index = entry.key;
              final d = entry.value;

              return KeyedSubtree(
              key: ValueKey(d.id),
              child: demandCard(d: d, onAccept: () { _acceptDemand(d.id); }),
              );
              }
              ),
                    ],
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

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.4,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget demandCard({
    required TenantDemandModel d,
    required VoidCallback onAccept,
    bool isAccepting = false,
  }) {
    final isUrgent = d.mark == "1";
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔥 TOP ROW (ID + URGENT + PRICE)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Row(
                children: [
                  Text(
                    "ID${d.id}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (isUrgent) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "URGENT",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ]
                ],
              ),

              Text(
                formatPriceRange(d.price),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🔥 NAME
          Text(
            d.tname,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),

          const SizedBox(height: 10),

          if (d.buyRent.isNotEmpty || d.bhk.isNotEmpty) ...[

            Row(
              children: [
                if (d.buyRent.isNotEmpty) _chip(d.buyRent),

                if (d.buyRent.isNotEmpty && d.bhk.isNotEmpty)
                  const SizedBox(width: 8),

                if (d.bhk.isNotEmpty) _chip2(d.bhk),
              ],
            ),

            const SizedBox(height: 12),
          ],

          /// 🔥 LOCATION
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.black),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  d.location,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// 🔥 DATE + TIME
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.black),
              const SizedBox(width: 6),
              Text(
                formatApiDate(d.createdDate),
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// 🔥 BUTTON
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton(
              onPressed: isAccepting ? null : onAccept,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 4,
                shadowColor: Colors.red.withOpacity(0.4),
              ),
              child: isAccepting
                  ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : const Text(
                "Accept Request",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  color: Colors.white
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String formatPrice(num value) {
    if (value >= 10000000) {
      return "₹${(value / 10000000).toStringAsFixed(1)}Cr";
    } else if (value >= 100000) {
      return "₹${(value / 100000).toStringAsFixed(1)}L";
    } else if (value >= 1000) {
      return "₹${(value / 1000).toStringAsFixed(0)}k";
    } else {
      return "₹${value.toInt()}";
    }
  }

  String formatPriceRange(dynamic price) {
    // 🔥 HANDLE NULL / EMPTY
    if (price == null || price.toString().trim().isEmpty) {
      return "₹ --";
    }

    try {
      final str = price.toString();

      // 🔥 HANDLE RANGE
      if (str.contains("-")) {
        final parts = str.split("-");

        if (parts.length != 2) return "₹ --";

        final start = double.tryParse(parts[0].trim());
        final end = double.tryParse(parts[1].trim());

        if (start == null || end == null) return "₹ --";

        return "${formatPrice(start)} – ${formatPrice(end)}";
      }

      // 🔥 HANDLE SINGLE VALUE
      final single = double.tryParse(str);
      if (single != null) {
        return formatPrice(single);
      }

      return "₹ --";
    } catch (e) {
      return "₹ --"; // 💣 NEVER CRASH UI
    }
  }

  Widget _chip(String text) {
    final isRent = text.toLowerCase() == "rent";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isRent ? const Color(0xFF7C3AED) : Colors.orange, // purple / cyan
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white, // 🔥 better contrast
        ),
      ),
    );
  }

  Widget _chip2(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color:
        const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color:
          Color(0xFF334155),
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
