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
  Timer? _debounce;
  bool _showRedemands = false; // 👈 default collapsed

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
      final FName = prefs.getString('name') ?? "";

      print(FName);

      if (FName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info missing. Please login again.")),
        );
        return;
      }

      final encodedName = Uri.encodeQueryComponent(FName);

      final url = Uri.parse("https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/display_accept_demand.php?assigned_fieldworker_name=$encodedName");
      final response = await http.get(url);

      print(response.body);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded["status"] == true) {
          final parents = (decoded["data"] as List)
              .map((e) => TenantDemandModel.fromJson(e))
              .toList();
              // .reversed
              // .toList();
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
      }
      else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("HTTP Error: ${response.statusCode}")),
          );
        }
      }

      final redemandUrl = Uri.parse(
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_redemand_base_on_main_id.php?assigned_fieldworker_name=$encodedName",
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
        apiLink: "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_api_for_fieldworkar_page.php?assigned_fieldworker_name=encodedName&Location=encodedLoc",
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
                      onRefresh: _loadDemands,
                      color: theme.colorScheme.primary,
                      child:
                      ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [

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
                                        "Your Redemands",
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
                            if (_showRedemands)                            ..._filteredCross.map((d) {
                              return _buildRedemandCard(d, true);
                            }),

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
