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
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand.php?Status=new",
        ),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // ✅ validate backend response
        if (decoded["success"] == true) {
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
                  child: ListView.builder(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filteredDemands.length,
                    itemBuilder: (_, i) {
                      final d = _filteredDemands[i];

                      return DemandCard(
                        d: d,
                        type: "demand", // 👈 here
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DemandDetail(
                                demandId: d.id.toString(),
                                isReadOnly: true, // 🔥 THIS IS THE KEY
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
