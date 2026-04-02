import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Custom_Widget/Demand_card.dart';
import '../../Demand_2/Demand_detail.dart';
import '../../Demand_2/redemand_detailpage.dart';
import '../../model/demand_model.dart';
import '../../utilities/bug_founder_fuction.dart';

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
  Timer? _debounce;
  bool _showRedemands = false; // 👈 default collapsed

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
    _loadDemands();
    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _loadDemands() async {
    setState(() => _isLoading = true);

    try {
      final response = await http.get(
        Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/display_accept_demand.php",
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // ✅ validate backend response
        if (decoded["status"] == true) {
          final List data = decoded["data"];

          final list = data
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();
          // .reversed
          // .toList();

          setState(() {
            _allDemands = list;
            _filteredDemands = list;
          });
        } else {
          // backend responded but with unexpected structure
          // await BugLogger.log(
          //   apiLink:
          //   "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand_for_admin.php",
          //   error: response.body,
          //   statusCode: response.statusCode,
          // );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No demand data found")),
            );
          }
        }
      } else {
        await BugLogger.log(
          apiLink:
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand_for_admin.php",
          error: response.body,
          statusCode: response.statusCode,
        );
      }

      final redemandUrl = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php",
      );

      final redemandRes = await http.get(redemandUrl);

      if (redemandRes.statusCode == 200) {
        final decodedRed = jsonDecode(redemandRes.body);

        if (decodedRed["success"] == true) {
          final redList = (decodedRed["data"] as List)
              .map((e) => TenantDemandModel.fromJson(e))
              .toList()
              .reversed
              .toList();
          setState(() {
            _crossRedemands = redList;
            _filteredCross = redList;
          });
        }
      }

    } catch (e) {
      await BugLogger.log(
        apiLink:
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand_for_admin.php",
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
                                    "All ReDemands (${_filteredCross.length})",
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
