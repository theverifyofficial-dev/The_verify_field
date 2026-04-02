import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Custom_Widget/Demand_card.dart';
import '../../Demand_2/Demand_detail.dart';
import '../../model/demand_model.dart';
import '../../utilities/bug_founder_fuction.dart';

class ShowTenantDemandPage extends StatefulWidget {
  const ShowTenantDemandPage({super.key});
  @override
  State<ShowTenantDemandPage> createState() => _TenantDemandState();
}

class _TenantDemandState extends State<ShowTenantDemandPage> {


  List<TenantDemandModel> _parentDemands = [];
  List<TenantDemandModel> _redemands = [];

  List<TenantDemandModel> _filteredParent = [];
  List<TenantDemandModel> _filteredRedemands = [];

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
      final prefs = await SharedPreferences.getInstance();
      final subadminName = prefs.getString('name') ?? "";
      final subadminLocation = prefs.getString('location') ?? "";
      print(subadminName);
      print(subadminLocation);

      if (subadminName.isEmpty || subadminLocation.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info missing. Please login again.")),
        );
        return;
      }

      final encodedName = Uri.encodeQueryComponent(subadminName);
      final encodedLoc = Uri.encodeQueryComponent(subadminLocation);

      String link = "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_tenant_demand.php?Status=new";

      final url = Uri.parse(link);
      print(link);
      final response = await http.get(url);
      print(response.body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["success"] == true) {
          final List data = decoded["data"];

          final parents = data
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();



          setState(() {
            _parentDemands = parents;

            _filteredParent = parents;
          });
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("No demand data found")),
            );
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("HTTP Error: ${response.statusCode}")),
          );
          await BugLogger.log(
            apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_api_for_subadmin_status_api.php?Status=assign%20to%20subadmin&assigned_subadmin_name=$encodedName",
            error: response.body.toString(),
            statusCode: response.statusCode ?? 0,
          );
        }
      }

    } catch (e) {
      if (mounted) {
        print("Error fetching data: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching data: $e")),
        );
        await BugLogger.log(
          apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_api_for_subadmin_status_api.php?Status=assign%20to%20subadmin&assigned_subadmin_name=encodedName",
          error: e.toString(),
          statusCode: 500,
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
        _filteredParent = _parentDemands.where((d) {
          return _matchDemand(d, q);
        }).toList();

        _filteredRedemands = _redemands.where((d) {
          return _matchDemand(d, q);
        }).toList();
      });
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
    ].any((f) => f.toString().toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

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
                child: (_filteredParent.isEmpty && _filteredRedemands.isEmpty)
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

                      // =================== PARENT DEMANDS ===================
                      if (_filteredParent.isNotEmpty) ...[
                        _sectionTitle("New Demands"),
                        ..._filteredParent.map((d) =>
                            DemandCard(
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
                            )
                        ),
                      ],
                    ],
                  ),
                ),
              )

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
