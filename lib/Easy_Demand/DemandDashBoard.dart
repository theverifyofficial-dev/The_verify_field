import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../AppLogger.dart';
// TODO: adjust this import to wherever DemandColors / demandStatusColor live
// import 'demand_home_card.dart';

/// ---------------------------------------------------------------------
/// Status config — same color language as customerDemand2CompactCard
/// ---------------------------------------------------------------------

class DemandTabColors {
  static const newDemand = Color(0xFF3B82F6); // Blue
  static const accepted  = Color(0xFF10B981); // Green
  static const postponed = Color(0xFFF59E0B); // Amber
  static const paid      = Color(0xFF8B5CF6); // Purple
  static const dead      = Color(0xFFEF4444); // Red
}

class DemandTab {
  final String label;
  final String status; // value sent to the API
  final Color color;
  final IconData icon;

  const DemandTab({
    required this.label,
    required this.status,
    required this.color,
    required this.icon,
  });
}

const List<DemandTab> demandTabs = [
  DemandTab(label: "New", status: "new", color: DemandTabColors.newDemand, icon: Icons.fiber_new_rounded),
  DemandTab(label: "Accept", status: "accept", color: DemandTabColors.accepted, icon: Icons.check_circle_rounded),
  DemandTab(label: "Postponed", status: "postponed", color: DemandTabColors.postponed, icon: Icons.schedule_rounded),
  DemandTab(label: "Paid", status: "paid", color: DemandTabColors.paid, icon: Icons.payments_rounded),
  DemandTab(label: "Dead", status: "dead", color: DemandTabColors.dead, icon: Icons.block_rounded),
];

/// ---------------------------------------------------------------------
/// API — generic status-filtered fetch (mirrors fetchTodayDemands)
/// ---------------------------------------------------------------------

Future<List<Map<String, dynamic>>> fetchDemandsByStatus(
    String fieldworkerName, String status) async {
  try {
    // TODO: confirm the real endpoint name with your backend — this assumes
    // a sibling script to show_data_base_on_current_date_for_fieldworkar.php
    final url =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/"
        "show_data_base_on_status_for_fieldworkar.php"
        "?fieldworker_name=${Uri.encodeQueryComponent(fieldworkerName)}"
        "&status=${Uri.encodeQueryComponent(status)}";

    AppLogger.api("📥 Fetching '$status' demands for $fieldworkerName");
    AppLogger.api("🌐 URL: $url");

    final res = await Dio().get(url);

    if (res.statusCode == 200 &&
        res.data is Map &&
        res.data["status"] == true &&
        res.data["data"] is List) {
      return List<Map<String, dynamic>>.from(
        res.data["data"].map((e) => Map<String, dynamic>.from(e)),
      );
    }
    return [];
  } catch (e) {
    AppLogger.api("❌ fetchDemandsByStatus($status) error: $e");
    return [];
  }
}

/// ---------------------------------------------------------------------
/// Dashboard — list of bubble cards, same nav pattern as AgreementDashboard,
/// visually themed off the customer demand card
/// ---------------------------------------------------------------------

class CustomerDemandDashboard extends StatefulWidget {
  final String fieldworkerName;

  const CustomerDemandDashboard({super.key, required this.fieldworkerName});

  @override
  State<CustomerDemandDashboard> createState() => _CustomerDemandDashboardState();
}

class _CustomerDemandDashboardState extends State<CustomerDemandDashboard> {
  bool loadingCounts = true;
  Map<String, int> counts = {};

  @override
  void initState() {
    super.initState();
    _loadCounts();
  }

  Future<void> _loadCounts() async {
    setState(() => loadingCounts = true);
    final results = await Future.wait(
      demandTabs.map((t) => fetchDemandsByStatus(widget.fieldworkerName, t.status)),
    );
    if (!mounted) return;
    setState(() {
      counts = {
        for (var i = 0; i < demandTabs.length; i++) demandTabs[i].status: results[i].length,
      };
      loadingCounts = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.blueGrey.shade50,
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: const Text(
          "Customer Demands",
          style: TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(PhosphorIconsRegular.caretLeft, color: Colors.white, size: 30),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            tooltip: "History",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DemandHistoryScreen(fieldworkerName: widget.fieldworkerName),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadCounts,
        child: ListView(
          padding: const EdgeInsets.all(14),
          children: demandTabs
              .map(
                (t) => _DemandBubble(
              tab: t,
              count: counts[t.status],
              loadingCount: loadingCounts,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DemandStatusScreen(
                      fieldworkerName: widget.fieldworkerName,
                      tab: t,
                    ),
                  ),
                );
              },
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

/// Bubble row — gradient card + colored icon badge + count pill + chevron.
/// Same tap-scale interaction as _BubbleCard, but themed off demand colors
/// instead of a flat purple circle.
class _DemandBubble extends StatefulWidget {
  final DemandTab tab;
  final int? count;
  final bool loadingCount;
  final VoidCallback onTap;

  const _DemandBubble({
    required this.tab,
    required this.count,
    required this.loadingCount,
    required this.onTap,
  });

  @override
  State<_DemandBubble> createState() => _DemandBubbleState();
}

class _DemandBubbleState extends State<_DemandBubble> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = widget.tab.color;

    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutBack,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isDark
                  ? [Colors.grey.shade900, Colors.black]
                  : [Colors.white, Colors.blueGrey.shade50],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.35 : 0.1),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(11),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [color, color.withOpacity(0.65)]),
                  boxShadow: [
                    BoxShadow(color: color.withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3)),
                  ],
                ),
                child: Icon(widget.tab.icon, size: 20, color: Colors.white),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  "${widget.tab.label} Demand${widget.tab.label == "New" ? "s" : ""}",
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
              if (widget.loadingCount)
                Container(
                  width: 28,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${widget.count ?? 0}",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color),
                  ),
                ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// Single-status list screen — pushed when a bubble is tapped
/// ---------------------------------------------------------------------

class DemandStatusScreen extends StatefulWidget {
  final String fieldworkerName;
  final DemandTab tab;

  const DemandStatusScreen({
    super.key,
    required this.fieldworkerName,
    required this.tab,
  });

  @override
  State<DemandStatusScreen> createState() => _DemandStatusScreenState();
}

class _DemandStatusScreenState extends State<DemandStatusScreen> {
  bool loading = true;
  List<Map<String, dynamic>> demands = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => loading = true);
    final data = await fetchDemandsByStatus(widget.fieldworkerName, widget.tab.status);
    if (!mounted) return;
    setState(() {
      demands = data;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.blueGrey.shade50,
      appBar: AppBar(
        centerTitle: true,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(PhosphorIconsRegular.caretLeft, color: Colors.white, size: 30),
            ],
          ),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.tab.icon, color: widget.tab.color, size: 18),
            const SizedBox(width: 8),
            Text(
              "${widget.tab.label} Demands",
              style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
      body: loading
          ? ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: List.generate(5, (_) => demandRowShimmer(isDark)),
      )
          : demands.isEmpty
          ? RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.28),
            Center(
              child: Column(
                children: [
                  Icon(Icons.inbox_rounded, size: 42, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  Text(
                    "No ${widget.tab.label.toLowerCase()} demands",
                    style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      )
          : RefreshIndicator(
        onRefresh: _load,
        child: ListView.builder(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 20),
          itemCount: demands.length,
          itemBuilder: (_, i) => demandDetailCard(demands[i], widget.tab.color, isDark),
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------
/// Shared tile + shimmer widgets
/// ---------------------------------------------------------------------

Widget demandDetailCard(Map<String, dynamic> d, Color color, bool isDark) {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: isDark
            ? [Colors.grey.shade900, Colors.black]
            : [Colors.white, Colors.blueGrey.shade50],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(isDark ? 0.35 : 0.1),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 4,
          height: 44,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                d["Tname"] ?? "-",
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on_rounded, size: 13, color: Colors.grey.shade500),
                  const SizedBox(width: 3),
                  Expanded(
                    child: Text(
                      d["Location"] ?? "-",
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            (d["status"] ?? "").toString().toUpperCase(),
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color),
          ),
        ),
      ],
    ),
  );
}

Widget demandRowShimmer(bool isDark) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
    height: 64,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(18),
      color: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
    ),
  );
}

/// ---------------------------------------------------------------------
/// History screen placeholder — wire this to your history API
/// ---------------------------------------------------------------------

class DemandHistoryScreen extends StatelessWidget {
  final String fieldworkerName;

  const DemandHistoryScreen({super.key, required this.fieldworkerName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Demand History")),
      body: const Center(
        child: Text("Hook up your history API/list here"),
      ),
    );
  }
}