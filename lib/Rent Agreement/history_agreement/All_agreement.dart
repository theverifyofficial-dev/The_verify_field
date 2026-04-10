import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Administrator/Administator_Agreement/Admin_All_agreement_model.dart';
import '../../Administrator/Administator_Agreement/Sub/All_data.dart';
import '../All_detailpage.dart';

// ─── Section Theme Colors ────────────────────────────────────────────────────
const _kAccent = Color(0xFF7C3AED);
const _kSuccess = Color(0xFF22C55E);
const _kDanger = Color(0xFFEF4444);
const _kWarning = Color(0xFFF97316);

class AllAgreement extends StatefulWidget {
  const AllAgreement({super.key});

  @override
  State<AllAgreement> createState() => _AllAgreementState();
}

class _AllAgreementState extends State<AllAgreement> {
  List<AdminAllAgreementModel> agreements = [];
  List<AdminAllAgreementModel> filteredAgreements = [];
  bool isLoading = true;
  String? mobileNumber;
  final TextEditingController searchController = TextEditingController();

  FieldWorkerPayment? monthlyPaymentSummary;
  bool isMonthFiltered = false;

  FieldWorkerPayment? myPayment;
  bool isPaymentLoading = false;

  final ScrollController _scrollController = ScrollController();
  double _savedScrollOffset = 0.0;
  String? _activeFilterMonth;

  @override
  void initState() {
    super.initState();
    _loadMobileNumber();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredAgreements = query.isEmpty
          ? agreements
          : agreements.where((item) {
        return item.ownerName.toLowerCase().contains(query) ||
            item.tenantName.toLowerCase().contains(query) ||
            item.id.toString().contains(query);
      }).toList();
    });
  }

  Future<void> _loadMobileNumber() async {
    final prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString("number");
    if (mobileNumber != null && mobileNumber!.isNotEmpty) {
      await fetchMyPayment();
      await fetchAgreements();
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchMyPayment() async {
    if (mobileNumber == null || mobileNumber!.isEmpty) return;
    try {
      setState(() => isPaymentLoading = true);
      final res = await http.get(Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/payment_count_new_api.php?fieldworker=$mobileNumber'));
      final data = jsonDecode(res.body);
      if (data['status'] == true) {
        myPayment = FieldWorkerPayment.fromJson(data, name: "You");
      }
    } catch (e) {
      debugPrint("❌ Payment fetch error: $e");
    } finally {
      setState(() => isPaymentLoading = false);
    }
  }

  Future<void> _silentRefresh() async {
    try {
      if (_activeFilterMonth != null) {
        await fetchAgreementsByMonth(month: _activeFilterMonth!);
        return;
      }
      final url = Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/show_agreement_by_fieldworkar.php?Fieldwarkarnumber=$mobileNumber');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map &&
            decoded['success'] == true &&
            decoded['data'] is List) {
          final freshList = (decoded['data'] as List)
              .map((e) => AdminAllAgreementModel.fromJson(e))
              .toList()
              .reversed
              .toList();
          if (!mounted) return;
          setState(() {
            agreements = freshList;
            final query = searchController.text.toLowerCase();
            filteredAgreements = query.isEmpty
                ? agreements
                : agreements.where((a) {
              return a.ownerName.toLowerCase().contains(query) ||
                  a.tenantName.toLowerCase().contains(query) ||
                  a.id.toString().contains(query);
            }).toList();
          });
        }
      }
    } catch (e) {
      debugPrint("❌ Silent refresh error: $e");
    }
  }

  Future<void> _refreshAgreements() async {
    try {
      _activeFilterMonth = null;
      monthlyPaymentSummary = null;
      isMonthFiltered = false;
      await fetchMyPayment();
      setState(() => isLoading = true);
      await fetchAgreements();
    } catch (e) {
      debugPrint("❌ Error refreshing: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> fetchAgreements() async {
    try {
      final url = Uri.parse(
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/show_agreement_by_fieldworkar.php?Fieldwarkarnumber=$mobileNumber');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded['success'] == true) {
          final data = decoded['data'];
          if (data is List) {
            setState(() {
              agreements = data
                  .map((e) => AdminAllAgreementModel.fromJson(e))
                  .toList()
                  .reversed
                  .toList();
              filteredAgreements = agreements;
              isLoading = false;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchAgreementsByMonth({required String month}) async {
    _activeFilterMonth = month;
    final url = Uri.parse(
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/month_wise_agreement.php?month=$month&fw=$mobileNumber');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded is Map && decoded['data'] is List) {
        final summary = decoded['month_payment_summary'];
        setState(() {
          agreements = decoded['data']
              .map<AdminAllAgreementModel>(
                  (e) => AdminAllAgreementModel.fromJson(e))
              .toList();
          filteredAgreements = agreements;
          monthlyPaymentSummary = FieldWorkerPayment(
            number: mobileNumber ?? "",
            name: "You",
            totalAmount:
            int.tryParse(summary['total_amount'].toString()) ?? 0,
            paidAmount: int.tryParse(summary['paid_amount'].toString()) ?? 0,
            remainingAmount:
            int.tryParse(summary['remaining_amount'].toString()) ?? 0,
          );
          isMonthFiltered = true;
        });
      }
    }
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  DateTime? _getRenewalDate(dynamic rawDate) {
    try {
      String actualDate =
      rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return null;
      final shiftingDate = DateTime.parse(actualDate.split(' ')[0]);
      return DateTime(
          shiftingDate.year, shiftingDate.month + 11, shiftingDate.day);
    } catch (e) {
      return null;
    }
  }

  String _formatDate(dynamic rawDate) {
    try {
      String actualDate =
      rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return "--";
      final date = DateTime.parse(actualDate.split(' ')[0]);
      return "${_twoDigits(date.day)} ${_monthName(date.month)} ${date.year}";
    } catch (_) {
      return "--";
    }
  }

  String _formatDateTime(DateTime date) {
    return "${_twoDigits(date.day)} ${_monthName(date.month)} ${date.year}";
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  Color _renewalColor(DateTime? renewalDate) {
    if (renewalDate == null) return Colors.grey;
    final diff = renewalDate.difference(DateTime.now()).inDays;
    if (diff < 0) return _kDanger;
    if (diff <= 30) return _kWarning;
    return Colors.red;
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF12121A) : const Color(0xFFF4F4F8);
    final screenWidth = MediaQuery.of(context).size.width;
    final paymentData = isMonthFiltered ? monthlyPaymentSummary : myPayment;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bg,
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: _kAccent),
        )
            : RefreshIndicator(
          onRefresh: _refreshAgreements,
          color: _kAccent,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── SEARCH BAR ────────────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: 10,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E1E2C)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: searchController,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        hintText: "Search by Owner, Tenant, or ID...",
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                ),
              ),

              // ── MY PAYMENT SUMMARY ────────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: 4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "MY PENDING PAYMENTS",
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: isDark
                              ? Colors.grey.shade400
                              : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      isPaymentLoading
                          ? const SizedBox(
                        height: 100,
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: _kAccent,
                          ),
                        ),
                      )
                          : paymentData != null
                          ? _buildPaymentCard(
                          paymentData, isDark, isMonthFiltered)
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ),

              // ── TOTAL COUNT + FILTER ──────────────────────────────
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'TOTAL AGREEMENTS:  ',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.6,
                                color: isDark
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                            ),
                            TextSpan(
                              text: '${filteredAgreements.length}  ',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: isDark
                                    ? Colors.purple
                                    : Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openMonthFilterSheet(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _kAccent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── AGREEMENT CARDS ───────────────────────────────────
              filteredAgreements.isEmpty
                  ? SliverFillRemaining(
                child: _buildEmptyState(isDark),
              )
                  : SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = filteredAgreements[index];
                    final renewal =
                    _getRenewalDate(item.shiftingDate);
                    final isPolice = item.agreementType ==
                        "Police Verification";
                    final paymentDone =
                        item.payment.toString() == "1";
                    final officeReceived =
                        item.recieved.toString() == "1";
                    return GestureDetector(
                      onTap: () async {
                        _savedScrollOffset =
                            _scrollController.offset;
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllDetailpage(
                                agreementId: item.id.toString()),
                          ),
                        );
                        await _silentRefresh();
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) {
                          if (_scrollController.hasClients) {
                            _scrollController
                                .jumpTo(_savedScrollOffset);
                          }
                        });
                      },
                      child: _AgreementCard(
                        item: item,
                        index: index,
                        total: filteredAgreements.length,
                        isDark: isDark,
                        renewalDate: renewal,
                        isPolice: isPolice,
                        paymentDone: paymentDone,
                        officeReceived: officeReceived,
                        formatDate: _formatDate,
                        formatDateTime: _formatDateTime,
                        renewalColor: _renewalColor,
                      ),
                    );
                  },
                  childCount: filteredAgreements.length,
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ── Payment Card (same style as _FieldWorkerCard / _buildMonthlySummaryCard) ──
  Widget _buildPaymentCard(
      FieldWorkerPayment data, bool isDark, bool isMonthly) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isMonthly ? "Monthly Payment Summary" : "Your Payment Summary",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _PaymentRow(
            label: "Total",
            amount: "₹${data.totalAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: isDark ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: 4),
          _PaymentRow(
            label: "Paid",
            amount: "₹${data.paidAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: _kSuccess,
          ),
          const SizedBox(height: 4),
          _PaymentRow(
            label: "Remaining",
            amount: "₹${data.remainingAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: _kDanger,
          ),
        ],
      ),
    );
  }

  // ── Empty State ────────────────────────────────────────────────────────────
  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.folder_off_rounded,
              size: 56,
              color: isDark ? Colors.grey[700] : Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            "No agreements found",
            style: TextStyle(
                fontSize: 15,
                color: isDark ? Colors.grey[500] : Colors.grey[600],
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  // ── Month Filter Sheet ─────────────────────────────────────────────────────
  void _openMonthFilterSheet(BuildContext context) {
    int selectedYear = DateTime.now().year;
    int selectedMonth = DateTime.now().month;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Filter Agreements",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<int>(
                    value: selectedMonth,
                    decoration: InputDecoration(
                      labelText: "Month",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                          value: i + 1, child: Text(_monthName(i + 1)));
                    }),
                    onChanged: (val) =>
                        setSheetState(() => selectedMonth = val!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<int>(
                    value: selectedYear,
                    decoration: InputDecoration(
                      labelText: "Year",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: List.generate(5, (i) {
                      final year = DateTime.now().year - 2 + i;
                      return DropdownMenuItem(
                          value: year, child: Text(year.toString()));
                    }),
                    onChanged: (val) =>
                        setSheetState(() => selectedYear = val!),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final monthStr =
                            "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
                        Navigator.pop(context);
                        fetchAgreementsByMonth(month: monthStr);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AGREEMENT CARD — exact same structure as AllData's _AgreementCard
// ─────────────────────────────────────────────────────────────────────────────
class _AgreementCard extends StatelessWidget {
  final AdminAllAgreementModel item;
  final int index;
  final int total;
  final bool isDark;
  final DateTime? renewalDate;
  final bool isPolice;
  final bool paymentDone;
  final bool officeReceived;
  final String Function(dynamic) formatDate;
  final String Function(DateTime) formatDateTime;
  final Color Function(DateTime?) renewalColor;

  const _AgreementCard({
    required this.item,
    required this.index,
    required this.total,
    required this.isDark,
    required this.renewalDate,
    required this.isPolice,
    required this.paymentDone,
    required this.officeReceived,
    required this.formatDate,
    required this.formatDateTime,
    required this.renewalColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Same inverted card color as AllData
    final cardBg =
    isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1E1E2C);

    // Same type-based color & icon logic as AllData
    String type = item.agreementType?.toLowerCase() ?? "";
    Color bgColor;
    IconData iconData;

    if (type.contains("police")) {
      bgColor = isDark ? Colors.blue : Colors.red;
      iconData = Icons.local_police_rounded;
    } else if (type.contains("external") || type.contains("commercial")) {
      bgColor = Colors.purple;
      iconData = Icons.description_rounded;
    } else {
      bgColor = const Color(0xFF7C3AED);
      iconData = Icons.article_rounded;
    }

    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 6,
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ─────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(iconData,
                                  size: 14, color: Colors.white),
                              const SizedBox(width: 5),
                              Flexible(
                                child: Text(
                                  (item.agreementType?.isNotEmpty == true
                                      ? item.agreementType!
                                      : "GENERAL AGREEMENT")
                                      .toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // ID badge — same as AllData
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.yellow : Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "ID: ${item.id}",
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.black : Colors.white70,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Owner & Tenant ──────────────────────────────────────────────
            _CardDetailRow(
                label: "Owner:",
                value: item.ownerName,
                isDark: isDark),
            _CardDetailRow(
                label: "Tenant:",
                value: item.tenantName,
                isDark: isDark),

            // ── Rent / Shifting / Renewal ───────────────────────────────────
            if (!isPolice) ...[
              _CardDetailRow(
                label: "Rent:",
                value: "₹${item.monthlyRent}",
                isDark: isDark,
                valueColor: const Color(0xFF22C55E),
              ),
              _CardDetailRow(
                label: "Shifting Date:",
                value: formatDate(item.shiftingDate),
                isDark: isDark,
              ),
              _CardDetailRow(
                label: "Renewal Date:",
                value: renewalDate != null
                    ? formatDateTime(renewalDate!)
                    : '--',
                isDark: isDark,
                valueColor: renewalColor(renewalDate),
              ),
            ],

            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
            ),
            const SizedBox(height: 12),

            // ── Payment & Office Status ─────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: _StatusTick(
                    label: "Payment",
                    sublabel: paymentDone ? "Paid" : "Pending",
                    done: paymentDone,
                    activeColor: Colors.lightBlueAccent,
                    isDark: isDark,
                  ),
                ),
                Flexible(
                  child: _StatusTick(
                    label: "Office",
                    sublabel:
                    officeReceived ? "Delivered" : "Not Delivered",
                    done: officeReceived,
                    activeColor: Colors.lightBlueAccent,
                    isDark: isDark,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Divider(
              height: 1,
              color: isDark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
            ),
            const SizedBox(height: 12),

            // ── Cost + Date ─────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "On ${formatDate(item.current_date)}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: isDark ? Colors.black : Colors.white60,
                    ),
                  ),
                ),
                Text(
                  "Cost: ₹${item.agreement_price ?? '--'}",
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 12,
                    color: isDark ? Colors.black : Colors.white60,
                  ),
                ),
              ],
            ),

            if (!isPolice) ...[
              const SizedBox(height: 4),
              Text(
                "Floor: ${item.floor ?? '--'}",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.black87 : Colors.white,
                ),
              ),
            ],

            const SizedBox(height: 10),

            // ── View Details ────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  "View Details",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF7C3AED),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: Color(0xFF7C3AED),
                ),
              ],
            ),

            // ── Missing Badges ──────────────────────────────────────────────
            if ((item.withPolice == "true" &&
                (item.policeVerificationPdf.isEmpty ||
                    item.policeVerificationPdf == 'null')) ||
                (!isPolice &&
                    (item.notaryImg.isEmpty ||
                        item.notaryImg == 'null'))) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  if (item.withPolice == "true" &&
                      (item.policeVerificationPdf.isEmpty ||
                          item.policeVerificationPdf == 'null'))
                    const _MissingBadge(
                        label: "Police Verification Missing"),
                  if (!isPolice &&
                      (item.notaryImg.isEmpty ||
                          item.notaryImg == 'null'))
                    const _MissingBadge(label: "Notary Image Missing"),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Card Detail Row ───────────────────────────────────────────────────────────
class _CardDetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isDark;
  final Color? valueColor;

  const _CardDetailRow({
    required this.label,
    required this.value,
    required this.isDark,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: isDark ? Colors.black : Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: valueColor ??
                    (isDark ? Colors.black : Colors.white70),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Status Tick ───────────────────────────────────────────────────────────────
class _StatusTick extends StatelessWidget {
  final String label;
  final String sublabel;
  final bool done;
  final Color activeColor;
  final bool isDark;

  const _StatusTick({
    required this.label,
    required this.sublabel,
    required this.done,
    required this.activeColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? Colors.black87 : Colors.white;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.verified_rounded,
          size: 16,
          color: done ? activeColor : textColor.withOpacity(0.25),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            "$label: $sublabel",
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: done ? textColor : textColor.withOpacity(0.5),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Payment Row Helper ────────────────────────────────────────────────────────
class _PaymentRow extends StatelessWidget {
  final String label;
  final String amount;
  final Color labelColor;
  final Color valueColor;

  const _PaymentRow({
    required this.label,
    required this.amount,
    required this.labelColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: labelColor,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            amount,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: valueColor,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Missing Badge ─────────────────────────────────────────────────────────────
class _MissingBadge extends StatelessWidget {
  final String label;
  const _MissingBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: const Color(0xFFEF4444).withOpacity(0.4), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded,
              color: Color(0xFFEF4444), size: 14),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFFEF4444),
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}