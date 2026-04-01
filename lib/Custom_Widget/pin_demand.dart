import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/demand_model.dart';
import '../Custom_Widget/Demand_card.dart';
import '../Demand_2/Demand_detail.dart';
import '../Demand_2/redemand_detailpage.dart';
import '../ui_decoration_tools/app_images.dart';
import '../utilities/bug_founder_fuction.dart';
import 'Demand_pin_button.dart';

class PinDemand extends StatefulWidget {
  const PinDemand({super.key});
  @override
  State<PinDemand> createState() => _PinDemandState();
}

class _PinDemandState extends State<PinDemand> {

  List<TenantDemandModel> _parentDemands = [];
  List<TenantDemandModel> _crossRedemands = [];
  List<TenantDemandModel> _filteredParent = [];
  List<TenantDemandModel> _filteredCross = [];


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
      final FName = prefs.getString('name') ?? "";

      print(FName);

      if (FName.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User info missing. Please login again.")),
        );
        return;
      }

      final encodedName = Uri.encodeQueryComponent(FName);

      final url = Uri.parse("https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/wishlist_show_api_for_tenant_demand.php?user_names=$encodedName");
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

          final pinnedOnly = parents.where((e) => e.isPinned).toList();

          setState(() {
            _parentDemands = pinnedOnly;
            _filteredParent = pinnedOnly;
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
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/show_wishlist_for_redemand.php?user_names=$encodedName",
      );

      final redemandRes = await http.get(redemandUrl);

      if (redemandRes.statusCode == 200) {
        final decodedRed = jsonDecode(redemandRes.body);

        if (decodedRed["status"] == true) {
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
        _filteredCross = _crossRedemands.where((d) => _matchDemand(d, q)).toList();
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
    ].any((field) =>
        field.toString().toLowerCase().contains(q));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black, // ✅ KEEP BLACK
        title: Image.asset(AppImages.verify, height: 70),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            PhosphorIcons.caret_left_bold,
            color: Colors.white,
            size: 28,
          ),
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
                            _sectionTitle("Pinned ReDemands"),
                            ..._filteredCross.map((d) {
                              return _buildRedemandCard(d, true);
                            }),

                            const SizedBox(height: 20),
                          ],

                          if (_filteredParent.isNotEmpty) ...[
                            _sectionTitle("Pinned Demands"),
                            ..._filteredParent.map((d) {
                              return DemandCard(
                                d: d,
                                isField: true,
                                type: "Demand", // 👈 here
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
                                PinList: PinListButton(
                                  pId: d.id,
                                  type: "Demand", // 👈 here
                                  initialState: d.isPinned,
                                  onRemoved: () {
                                    setState(() {
                                      _parentDemands.removeWhere((x) => x.id == d.id);
                                      _filteredParent.removeWhere((x) => x.id == d.id);
                                    });
                                  },
                                ),
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
          type: "Redemand",
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

          PinList: PinListButton(
            pId: d.id,
            type: "Redemand", // 👈 here
            initialState: d.isPinned,
            onRemoved: () {
              setState(() {
                _crossRedemands.removeWhere((x) => x.id == d.id);
                _filteredCross.removeWhere((x) => x.id == d.id);
              });
            },
          ),

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
