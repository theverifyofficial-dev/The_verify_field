import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Custom_Widget/Custom_backbutton.dart';
import '../model/Visitng_model.dart';

Color _hexColor(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

class FieldVisitHistoryPage extends StatefulWidget {
  const FieldVisitHistoryPage({super.key});

  @override
  State<FieldVisitHistoryPage> createState() =>
      _FieldVisitHistoryPageState();
}

class _FieldVisitHistoryPageState extends State<FieldVisitHistoryPage> {
  static const String _baseUrl =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/book_shedual/show_property_visit_by_fieldworkar_name.php";

  bool loading = true;
  bool isAdmin = false;
  String workerName = "";

  List<FieldWorkerVisitModel> visits = [];
  String selectedStatus = "All";
  String searchQuery = "";

  final searchController = TextEditingController();

  final List<String> statusFilters = [
    "All",
    "Booked",
    "Confirmed",
    "Completed",
    "Cancelled",
  ];

  @override
  void initState() {
    super.initState();
    loadVisits();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> loadVisits() async {
    setState(() {
      loading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();

      final role = prefs.getString("post") ?? "";
      final name = prefs.getString("name") ?? "";

      isAdmin = role == "Administrator" || role == "Sub Administrator";
      workerName = name;

      final uri = isAdmin
          ? Uri.parse(_baseUrl)
          : Uri.parse(
        "$_baseUrl?feild_workar_name=${Uri.encodeComponent(name)}",
      );

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json["success"] == true) {
          final data = (json["data"] as List)
              .map((e) => FieldWorkerVisitModel.fromJson(e))
              .toList();

          data.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          visits = data;
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      loading = false;
    });
  }

  List<FieldWorkerVisitModel> get _filteredVisits {
    return visits.where((v) {
      final matchesStatus = selectedStatus == "All" ||
          v.visitingStatus.toLowerCase() == selectedStatus.toLowerCase();

      final query = searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          v.preferredLocation.toLowerCase().contains(query) ||
          v.propertyId.toString().contains(query) ||
          v.fieldWorkerName.toLowerCase().contains(query);

      return matchesStatus && matchesSearch;
    }).toList();
  }

  String formatDate(DateTime value) {
    return DateFormat("dd MMM yyyy").format(value);
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case "booked":
        return const Color(0xFF2563EB);
      case "confirmed":
        return const Color(0xFF16A34A);
      case "completed":
        return const Color(0xFF0F766E);
      case "cancelled":
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFFF59E0B);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredVisits;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;

    final Color scaffoldBackground =
    isDark ? const Color(0xFF0F172A) : const Color(0xFFF3F4F6);

    final double totalRevenue = visits.fold<double>(
      0,
          (sum, v) => sum + (double.tryParse(v.total) ?? 0),
    );

    final int confirmedCount = visits
        .where((v) => v.visitingStatus.toLowerCase() == "confirmed")
        .length;

    return Scaffold(
      backgroundColor: scaffoldBackground,
      body: RefreshIndicator(
        color: Colors.blueAccent,
        backgroundColor: theme.scaffoldBackgroundColor,
        displacement: 80,
        onRefresh: loadVisits,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _premiumHeader(
                isDark: isDark,
                screenWidth: screenWidth,
                totalVisits: visits.length,
                confirmedCount: confirmedCount,
                totalRevenue: totalRevenue,
              ),
            ),
            SliverToBoxAdapter(child: _searchAndFilterBar(isDark)),
            if (loading)
              const SliverFillRemaining(
                hasScrollBody: false,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (visits.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _emptyWidget(isDark),
              )
            else if (filtered.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _noResultsWidget(isDark),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) {
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 400),
                          child: SlideAnimation(
                            verticalOffset: 40,
                            child: FadeInAnimation(
                              child: _visitCard(filtered[index], isDark),
                            ),
                          ),
                        );
                      },
                      childCount: filtered.length,
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _premiumHeader({
    required bool isDark,
    required double screenWidth,
    required int totalVisits,
    required int confirmedCount,
    required double totalRevenue,
  }) {
    final primaryGradient = LinearGradient(
      colors: [Colors.purple.shade700, Colors.indigo.shade800, Colors.blue.shade900],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final revenueText = NumberFormat.currency(
      locale: 'en_IN',
      symbol: '₹',
      decimalDigits: 0,
    ).format(totalRevenue);

    return Container(
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.05,
            screenWidth * 0.03,
            screenWidth * 0.05,
            22,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const SquareBackButton(),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isAdmin ? "All Property Visits" : "My Assigned Visits",
                          style: const TextStyle(
                            fontFamily: "PoppinsMedium",
                            color: Colors.white,
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isAdmin
                              ? "Overview of every booked visit"
                              : "Visits assigned to you",
                          style: TextStyle(
                            fontFamily: "PoppinsMedium",
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    _headerStat(
                      icon: Icons.event_available_rounded,
                      label: "Total Visits",
                      value: totalVisits.toString(),
                    ),
                    _headerStatDivider(),
                    _headerStat(
                      icon: Icons.verified_rounded,
                      label: "Confirmed",
                      value: confirmedCount.toString(),
                    ),
                    _headerStatDivider(),
                    _headerStat(
                      icon: Icons.account_balance_wallet_rounded,
                      label: "Revenue",
                      value: revenueText,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerStatDivider() {
    return Container(
      width: 1,
      height: 34,
      color: Colors.white.withOpacity(0.15),
    );
  }

  Widget _headerStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: "PoppinsMedium",
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: "PoppinsMedium",
              color: Colors.white.withOpacity(0.75),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchAndFilterBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      color: Colors.transparent,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: searchController,
              onChanged: (v) => setState(() => searchQuery = v),
              style: TextStyle(color: isDark ? Colors.white : Colors.black87),
              decoration: InputDecoration(
                hintText: isAdmin
                    ? "Search by location, property ID or worker"
                    : "Search by location or property ID",
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                  fontSize: 13.5,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white70 : Colors.grey.shade600,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: statusFilters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final status = statusFilters[index];
                final selected = status == selectedStatus;

                return ChoiceChip(
                  label: Text(status),
                  selected: selected,
                  onSelected: (_) => setState(() => selectedStatus = status),
                  selectedColor: _hexColor("#001234"),
                  backgroundColor:
                  isDark ? Colors.grey.shade900 : _hexColor("#EEF5FF"),
                  labelStyle: TextStyle(
                    fontFamily: "PoppinsMedium",
                    color: selected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black87),
                    fontWeight: FontWeight.w600,
                    fontSize: 12.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyWidget(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.event_busy, size: 90, color: Colors.grey.shade400),
        const SizedBox(height: 20),
        Text(
          "No Visits Found",
          style: TextStyle(
            fontFamily: "PoppinsMedium",
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            isAdmin
                ? "No property visits have been booked yet."
                : "You don't have any assigned visits yet.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white60 : Colors.grey.shade700,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _noResultsWidget(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.search_off, size: 70, color: Colors.grey.shade400),
        const SizedBox(height: 16),
        Text(
          "No visits match your filter",
          style: TextStyle(
            fontFamily: "PoppinsMedium",
            color: isDark ? Colors.white60 : Colors.grey.shade700,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _visitCard(FieldWorkerVisitModel visit, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () => showVisitBottomSheet(visit),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(22),
                topRight: Radius.circular(22),
              ),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF153A73), Color(0xFF0B1F46)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white24),
                          ),
                          child: const Icon(
                            Icons.home_work_rounded,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Property ID: ${visit.propertyId}",
                                style: const TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                visit.preferredLocation,
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor(visit.visitingStatus),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            visit.visitingStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    right: -18,
                    bottom: -18,
                    child: Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _row(Icons.calendar_today, "Visit Date",
                      formatDate(visit.visitDate), isDark),
                  const SizedBox(height: 10),
                  _row(Icons.schedule, "Time", visit.visitTime, isDark),
                  if (isAdmin) ...[
                    const SizedBox(height: 10),
                    _row(Icons.badge, "Field Worker", visit.fieldWorkerName,
                        isDark),
                  ],
                  Divider(
                    height: 24,
                    color: isDark ? Colors.grey.shade800 : null,
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: statusColor(visit.paymentStatus)
                              .withOpacity(.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.credit_card_rounded,
                              color: statusColor(visit.paymentStatus),
                              size: 14,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              visit.paymentStatus,
                              style: TextStyle(
                                color: statusColor(visit.paymentStatus),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Text(
                        "₹ ${visit.total}",
                        style: const TextStyle(
                          fontFamily: "PoppinsMedium",
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(IconData icon, String title, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, color: isDark ? Colors.blueAccent.shade100 : _hexColor("#001234"), size: 17),
        const SizedBox(width: 8),
        SizedBox(
          width: 95,
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13.5,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.5,
              color: isDark ? Colors.white60 : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  List<MapEntry<String, String>> _parseRequirements(String raw) {
    const labels = [
      "BHK",
      "Property Type",
      "Location",
      "Floor",
      "Buy/Rent",
      "Lift Required",
      "Parking Required",
      "Notes",
    ];

    final Map<String, String> result = {};

    for (int i = 0; i < labels.length; i++) {
      final label = labels[i];
      final startIndex = raw.indexOf("$label: ");
      if (startIndex == -1) continue;

      final valueStart = startIndex + label.length + 2;

      int valueEnd = raw.length;
      for (int j = i + 1; j < labels.length; j++) {
        final nextIndex = raw.indexOf("${labels[j]}: ", valueStart);
        if (nextIndex != -1) {
          valueEnd = nextIndex - 2;
          break;
        }
      }

      final value = raw.substring(valueStart, valueEnd).trim();
      if (value.isNotEmpty) {
        result[label] = value;
      }
    }

    return result.entries.toList();
  }

  void showVisitBottomSheet(FieldWorkerVisitModel visit) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return FractionallySizedBox(
          heightFactor: 0.9,
          child: Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF10182B) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 5,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Colors.purple.shade400, Colors.indigo.shade700],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.home_work,
                            size: 36,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Property ID: ${visit.propertyId}",
                                style: TextStyle(
                                  fontFamily: "PoppinsMedium",
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Booking #${visit.id}",
                                style: TextStyle(
                                  color: isDark ? Colors.white54 : Colors.grey.shade700,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor(visit.visitingStatus),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Text(
                            visit.visitingStatus,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),

                    if (isAdmin) ...[
                      _sectionCard(
                        title: "Field Worker",
                        icon: Icons.badge,
                        isDark: isDark,
                        rows: [
                          MapEntry("Assigned To", visit.fieldWorkerName),
                        ],
                      ),
                      const SizedBox(height: 16),
                    ],

                    _sectionCard(
                      title: "Visit Details",
                      icon: Icons.event_note,
                      isDark: isDark,
                      rows: [
                        MapEntry("Preferred Location", visit.preferredLocation),
                        MapEntry("Visit Date", formatDate(visit.visitDate)),
                        MapEntry("Visit Time", visit.visitTime),
                        MapEntry("Budget", "₹ ${visit.budget}"),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      title: "Family & Shifting Details",
                      icon: Icons.family_restroom,
                      isDark: isDark,
                      accent: Colors.purple,
                      rows: [
                        MapEntry("Family Structure", visit.familyStructure),
                        MapEntry("Family Members", visit.familyMember),
                        MapEntry("Religion", visit.religion),
                        MapEntry(
                          "Shifting Date",
                          visit.shiftingDate.isNotEmpty
                              ? formatDate(DateTime.tryParse(visit.shiftingDate) ??
                              DateTime.now())
                              : "-",
                        ),
                        if (visit.vichleNo.trim().isNotEmpty)
                          MapEntry("Vehicle No", visit.vichleNo),
                      ],
                    ),

                    const SizedBox(height: 16),

                    _sectionCard(
                      title: "Payment",
                      icon: Icons.payments,
                      isDark: isDark,
                      accent: Colors.green,
                      rows: [
                        MapEntry("Visit Fee", "₹ ${visit.visitFee}"),
                        MapEntry("GST", "₹ ${visit.gst}"),
                        MapEntry("Gateway Charges", "₹ ${visit.gatewayFee}"),
                        MapEntry("Total Paid", "₹ ${visit.total}"),
                        MapEntry("Payment Status", visit.paymentStatus),
                      ],
                    ),

                    if (visit.requirements.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Builder(
                        builder: (_) {
                          final parsed = _parseRequirements(visit.requirements);

                          return Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? Colors.orange.withOpacity(0.08)
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.notes, color: Colors.orange),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Property Requirements",
                                      style: TextStyle(
                                        fontFamily: "PoppinsMedium",
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: isDark ? Colors.white : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                if (parsed.isEmpty)
                                  Text(
                                    visit.requirements,
                                    style: TextStyle(
                                      height: 1.5,
                                      color: isDark ? Colors.white70 : Colors.black87,
                                    ),
                                  )
                                else
                                  ...parsed.map(
                                        (e) => Padding(
                                      padding:
                                      const EdgeInsets.only(bottom: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 130,
                                            child: Text(
                                              e.key,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                color: isDark
                                                    ? Colors.white
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Text(
                                              e.value,
                                              style: TextStyle(
                                                color: isDark
                                                    ? Colors.white70
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hexColor("#001234"),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Close",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _sectionCard({
    required String title,
    required IconData icon,
    required bool isDark,
    required List<MapEntry<String, String>> rows,
    Color accent = Colors.blueAccent,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? accent.withOpacity(0.08) : accent.withOpacity(0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: isDark ? Colors.white : _hexColor("#001234"), size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontFamily: "PoppinsMedium",
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...rows.map(
                (e) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 140,
                    child: Text(
                      e.key,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      e.value.isEmpty ? "-" : e.value,
                      style: TextStyle(
                        color: isDark ? Colors.white60 : Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}