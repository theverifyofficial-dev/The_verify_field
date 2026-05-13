import 'dart:async';
import 'dart:convert';
import '../../../AppLogger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/Agreement_model.dart';
import 'All_data_details_page.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MODEL
// ─────────────────────────────────────────────────────────────────────────────
class FieldWorkerPayment {
  final String number;
  final String name;
  final int totalAmount;
  final int paidAmount;
  final int remainingAmount;

  FieldWorkerPayment({
    required this.number,
    required this.name,
    required this.totalAmount,
    required this.paidAmount,
    required this.remainingAmount,
  });

  factory FieldWorkerPayment.fromJson(
      Map<String, dynamic> json, {
        required String name,
      }) {
    return FieldWorkerPayment(
      number: json['fieldworker'] ?? '',
      name: name,
      totalAmount: int.tryParse(json['total_amount'].toString()) ?? 0,
      paidAmount: int.tryParse(json['paid_amount'].toString()) ?? 0,
      remainingAmount: int.tryParse(json['remaining_amount'].toString()) ?? 0,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AllData> {
  // ── Filter / Search State ──────────────────────────────────────────────────
  String? _activeFilterMonth;
  String? _activeFilterWorker;
  String _searchQuery = '';
  Timer? _debounce;

  // ── Data State ─────────────────────────────────────────────────────────────
  List<AgreementModel> agreements = [];
  List<AgreementModel> filteredAgreements = [];
  bool isLoading = true;
  int totalRecords = 0;
  int? _lastOpenedId;
  double _savedScrollOffset = 0;
  final Map<int, GlobalKey> _itemKeys = {};

  // ── Pagination ─────────────────────────────────────────────────────────────
  final int _limit = 20;
  int page = 1;
  bool hasMore = true;
  bool isFetchingMore = false;

  // ── Controllers ────────────────────────────────────────────────────────────
  final TextEditingController searchController = TextEditingController();
  late ScrollController _scrollController;
  late Future<List<FieldWorkerPayment>> _paymentsFuture;
  FieldWorkerPayment? monthlyPaymentSummary;

  // ── Field Workers List ─────────────────────────────────────────────────────
  final List<Map<String, String>> fieldWorkers = [
    {"number": "9711775300", "name": "Sumit"},
    {"number": "9711275300", "name": "Ravi Kumar"},
    {"number": "9971172204", "name": "Faizan Khan"},
  ];


  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _paymentsFuture = fetchAllFieldWorkersPayments();
    fetchAgreements();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          !isFetchingMore &&
          hasMore) {
        fetchAgreements(isInitial: false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // API — FIELD WORKER PAYMENTS
  // ─────────────────────────────────────────────────────────────────────────
  Future<FieldWorkerPayment> fetchPaymentForWorker({
    required String number,
    required String name,
  }) async {
    final res = await http.get(
      Uri.parse(
        'https://verifyrealestateandservices.in/Second%20PHP%20FILE/Tenant_demand/payment_count_new_api.php?fieldworker=$number',
      ),
    );
    final data = jsonDecode(res.body);
    if (data['status'] != true) throw Exception("Failed for $number");
    return FieldWorkerPayment.fromJson(data, name: name);
  }

  Future<List<FieldWorkerPayment>> fetchAllFieldWorkersPayments() async {
    return Future.wait(
      fieldWorkers.map(
            (fw) => fetchPaymentForWorker(
          number: fw['number']!,
          name: fw['name']!,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SEARCH — local filter
  // ─────────────────────────────────────────────────────────────────────────
  void _onSearchChanged() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredAgreements = agreements.where((a) {
        return a.ownerName.toLowerCase().contains(query) ||
            a.tenantName.toLowerCase().contains(query) ||
            a.id.toString().contains(query);
      }).toList();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SILENT REFRESH — preserves scroll & filter
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _silentRefresh() async {
    try {
      if (_activeFilterMonth != null) {
        await fetchAgreementsByMonth(
          month: _activeFilterMonth!,
          fieldWorker: _activeFilterWorker,
        );
        return;
      }

      final url =
          'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/show_main_agreement_data.php?page=1&limit=${agreements.length}';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map && decoded.containsKey('data')) {
          final freshList = (decoded['data'] as List)
              .map((e) => AgreementModel.fromJson(e))
              .toList()
              .reversed
              .toList();

          if (!mounted) return;

          setState(() {
            final freshMap = {for (var item in freshList) item.id: item};

            agreements = agreements.map((oldItem) {
              return freshMap[oldItem.id] ?? oldItem;
            }).toList();

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
        _itemKeys.removeWhere(
                (key, _) => !agreements.any((a) => a.id == key));
      }
    } catch (e) {
      AppLogger.api("❌ Silent refresh error: $e");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // PULL-TO-REFRESH — resets everything
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _refreshAgreements() async {
    try {
      _activeFilterMonth = null;
      _activeFilterWorker = null;
      monthlyPaymentSummary = null;
      await fetchAgreements(isInitial: true);
    } catch (e) {
      debugPrint("❌ Error refreshing agreements: $e");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FETCH AGREEMENTS — paginated
  // ─────────────────────────────────────────────────────────────────────
  Future<void> fetchAgreements({bool isInitial = true}) async {
    if (isFetchingMore) return;
    isFetchingMore = true;

    if (isInitial) {
      page = 1;
      hasMore = true;
      agreements.clear();
      filteredAgreements.clear();
      if (_scrollController.hasClients) _scrollController.jumpTo(0);
      setState(() => isLoading = true);
    }

    try {
      final url = _searchQuery.isEmpty
          ? 'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/show_main_agreement_data.php?page=$page&limit=$_limit'
          : 'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/search_api_for_final_table_for_admin.php?search=$_searchQuery&page=$page&limit=$_limit';

      AppLogger.api("📡 Fetching: $url");
      final response = await http.get(Uri.parse(url));
      AppLogger.api("RESPONSE: ${response.body}");

      final decoded = jsonDecode(response.body);

      if (decoded['data'] is List) {
        final List newData = decoded['data'];
        final newList = newData.map((e) => AgreementModel.fromJson(e)).toList();
        final totalPages = decoded['total_pages'] ?? 1;
        totalRecords = decoded['total_records'] ?? 0;

        setState(() {
          agreements.addAll(newList);
          filteredAgreements = agreements;
          page++;
          hasMore = page <= totalPages;
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      AppLogger.api("❌ Fetch/Pagination error: $e");
      setState(() => isLoading = false);
    }

    isFetchingMore = false;
  }

  // ─────────────────────────────────────────────────────────────────────────
  // FETCH BY MONTH FILTER
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> fetchAgreementsByMonth({
    required String month,
    String? fieldWorker,
  })
   async {
    _activeFilterMonth = month;
    _activeFilterWorker = fieldWorker;

    final Map<String, String> queryParams = {"month": month};
    if (fieldWorker != null && fieldWorker.isNotEmpty) {
      queryParams["fw"] = fieldWorker;
    }

    final uri = Uri.parse(
      'https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/month_wise_agreement.php',
    ).replace(queryParameters: queryParams);

    AppLogger.api("📡 Month Filter API: $uri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true && decoded['data'] is List) {
        final summary = decoded['month_payment_summary'];
        setState(() {
          agreements = (decoded['data'] as List)
              .map<AgreementModel>((e) => AgreementModel.fromJson(e))
              .toList();
          filteredAgreements = agreements;
          monthlyPaymentSummary = FieldWorkerPayment(
            number: '',
            name: 'Monthly Summary',
            totalAmount:
            int.tryParse(summary['total_amount'].toString()) ?? 0,
            paidAmount:
            int.tryParse(summary['paid_amount'].toString()) ?? 0,
            remainingAmount:
            int.tryParse(summary['remaining_amount'].toString()) ?? 0,
          );
        });
      } else {
        AppLogger.api("⚠️ No data for selected filter");
        setState(() {
          agreements = [];
          filteredAgreements = [];
          monthlyPaymentSummary = null;
        });
      }
    } else {
      AppLogger.api("❌ API failed: ${response.body}");
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MARK OFFICE RECEIVED
  // ─────────────────────────────────────────────────────────────────────────
  Future<void> _confirmAndUpdateOfficeReceived({
    required BuildContext context,
    required String agreementId,
  }) async {
    bool isSubmitting = false;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: const Row(
                children: [
                  Icon(Icons.apartment_rounded, color: Color(0xFF7C3AED)),
                  SizedBox(width: 8),
                  Text("Confirm Office Received",
                      style: TextStyle(fontSize: 16)),
                ],
              ),
              content: const Text(
                "This will mark the agreement as officially received to the office.\n\n"
                    "⚠️ This action cannot be undone.",
                style: TextStyle(height: 1.4),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.pop(dialogContext, false),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: isSubmitting
                      ? null
                      : () async {
                    setDialogState(() => isSubmitting = true);
                    Navigator.pop(dialogContext, true);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text(
                    "Confirm",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white70),
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    try {
      final response = await http.post(
        Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_application/agreement/update_payment_field.php",
        ),
        body: {
          "id": agreementId,
          "office_received": "1",
          "office_received_at": DateTime.now().toIso8601String(),
        },
      );

      final decoded = jsonDecode(response.body);

      if (decoded["status"] == true) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.verified_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text("Office successfully marked as received"),
              ],
            ),
            backgroundColor: Color(0xFF7C3AED),
            behavior: SnackBarBehavior.floating,
          ),
        );
        _silentRefresh();
      } else {
        throw decoded["message"];
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Update failed: $e"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SCROLL TO LAST OPENED
  // ─────────────────────────────────────────────────────────────────────────
  void _scrollToLastOpened() {
    if (_lastOpenedId == null) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final key = _itemKeys[_lastOpenedId];
      if (key?.currentContext != null) {
        Scrollable.ensureVisible(
          key!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.3,
        );
      }
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MONTH FILTER BOTTOM SHEET
  // ─────────────────────────────────────────────────────────────────────────
  void _openMonthFilterSheet(BuildContext context) {
    int selectedYear = DateTime.now().year;
    int selectedMonth = DateTime.now().month;
    String selectedFW = "all";

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
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedFW,
                    decoration: InputDecoration(
                      labelText: "Field Worker",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: [
                      const DropdownMenuItem(
                          value: "all",
                          child: Text("All Field Workers")),
                      ...fieldWorkers.map(
                            (fw) => DropdownMenuItem(
                          value: fw["number"],
                          child: Text(fw["name"]!),
                        ),
                      ),
                    ],
                    onChanged: (val) =>
                        setSheetState(() => selectedFW = val!),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final monthStr =
                            "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";
                        Navigator.pop(context);
                        fetchAgreementsByMonth(
                          month: monthStr,
                          fieldWorker:
                          selectedFW == "all" ? null : selectedFW,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        padding:
                        const EdgeInsets.symmetric(vertical: 14),
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

  // ─────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────────────────
  DateTime? _getRenewalDate(DateTime? shiftingDate) {
    if (shiftingDate == null) return null;
    try {
      return DateTime(
        shiftingDate.year,
        shiftingDate.month + 11,
        shiftingDate.day,
      );
    } catch (_) {
      return null;
    }
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF12121A) : const Color(0xFFF4F4F8);
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: bg,
        body: isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF7C3AED)),
        )
            : RefreshIndicator(
          onRefresh: _refreshAgreements,
          color: const Color(0xFF7C3AED),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // ── SEARCH BAR ───────────────────────────────────────
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
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search,
                              color: Colors.green),
                          onPressed: () {
                            final query =
                            searchController.text.trim();
                            if (_searchQuery == query) return;
                            _searchQuery = query;
                            fetchAgreements(isInitial: true);
                          },
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

              // ── FIELD WORKER PENDING PAYMENTS ────────────────────
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
                        "FIELD WORKER PENDING PAYMENTS",
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
                      monthlyPaymentSummary != null
                          ? _buildMonthlySummaryCard(
                          monthlyPaymentSummary!)
                          : FutureBuilder<List<FieldWorkerPayment>>(
                        future: _paymentsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              height: 100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Color(0xFF7C3AED),
                                ),
                              ),
                            );
                          }
                          if (snapshot.hasError) {
                            return SizedBox(
                              height: 60,
                              child: Center(
                                child: Text(
                                  "Failed to load payments",
                                  style: TextStyle(
                                    color: Colors.red.shade400,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            );
                          }
                          final data = snapshot.data!;
                          return SizedBox(
                            height: 140,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: data.map((fw) {
                                  return Padding(
                                    padding:
                                    const EdgeInsets.only(
                                        right: 10),
                                    child: _FieldWorkerCard(
                                      fw: fw,
                                      isDark: isDark,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),

              // ── TOTAL COUNT + FILTER ─────────────────────────────
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
                              text:
                              '${_searchQuery.isNotEmpty ? filteredAgreements.length : totalRecords}',
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
                        onTap: () =>
                            _openMonthFilterSheet(context),
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED),
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

              // ── EMPTY STATE ──────────────────────────────────────
              if (!isLoading && filteredAgreements.isEmpty)
                const SliverFillRemaining(
                  child: Center(
                    child: Text(
                      "No results found",
                      style: TextStyle(
                          fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),

              // ── AGREEMENT CARDS ──────────────────────────────────
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    // Loading indicator at the end
                    if (index >= filteredAgreements.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Center(
                            child: CircularProgressIndicator()),
                      );
                    }

                    final item = filteredAgreements[index];
                    final renewalDate =
                    _getRenewalDate(item.shiftingDate);
                    final bool isPolice =
                        item.agreementType == "Police Verification";
                    final bool paymentDone =
                        item.payment.toString() == "1";
                    final bool officeReceived =
                        item.recieved.toString() == "1";



                    return GestureDetector(
                      key: _itemKeys.putIfAbsent(
                          item.id, () => GlobalKey()),
                      onTap: () async {
                        _savedScrollOffset =
                            _scrollController.offset;
                        _lastOpenedId = item.id;

                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllDataDetailsPage(
                              agreementId: item.id.toString(),
                            ),
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

                        _scrollToLastOpened();
                      },
                      child: _AgreementCard(
                        item: item,
                        index: index,
                        total: filteredAgreements.length,
                        isDark: isDark,
                        renewalDate: renewalDate,
                        isPolice: isPolice,
                        paymentDone: paymentDone,
                        officeReceived: officeReceived,
                        onMarkOfficeReceived: () =>
                            _confirmAndUpdateOfficeReceived(
                              context: context,
                              agreementId: item.id.toString(),
                            ),
                      ),

                    );
                  },
                  childCount: filteredAgreements.length +
                      (hasMore ? 1 : 0),
                ),
              ),

              const SliverToBoxAdapter(
                  child: SizedBox(height: 24)),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MONTHLY SUMMARY CARD
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildMonthlySummaryCard(FieldWorkerPayment summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
            "Monthly Payment Summary",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          _PaymentRow(
            label: "Total",
            amount: "₹${summary.totalAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: isDark ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: 4),
          _PaymentRow(
            label: "Paid",
            amount: "₹${summary.paidAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: const Color(0xFF22C55E),
          ),
          const SizedBox(height: 4),
          _PaymentRow(
            label: "Remaining",
            amount: "₹${summary.remainingAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// FIELD WORKER CARD
// ─────────────────────────────────────────────────────────────────────────────
class _FieldWorkerCard extends StatelessWidget {
  final FieldWorkerPayment fw;
  final bool isDark;
  const _FieldWorkerCard({required this.fw, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2C) : Colors.white,
        borderRadius: BorderRadius.circular(18),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor:
                const Color(0xFF7C3AED).withOpacity(0.12),
                child: Text(
                  fw.name.isNotEmpty ? fw.name[0].toUpperCase() : "?",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  fw.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Divider(
            height: 1,
            color: isDark ? Colors.white12 : Colors.grey.shade200,
          ),
          const SizedBox(height: 8),
          _PaymentRow(
            label: "Total",
            amount: "₹${fw.totalAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: isDark ? Colors.white : Colors.black87,
          ),
          const SizedBox(height: 5),
          _PaymentRow(
            label: "Paid",
            amount: "₹${fw.paidAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: const Color(0xFF22C55E),
          ),
          const SizedBox(height: 5),
          _PaymentRow(
            label: "Remaining",
            amount: "₹${fw.remainingAmount}",
            labelColor: isDark ? Colors.white60 : Colors.black45,
            valueColor: const Color(0xFFEF4444),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT ROW
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// AGREEMENT CARD
// ─────────────────────────────────────────────────────────────────────────────
class _AgreementCard extends StatelessWidget {
  final AgreementModel item;
  final int index;
  final int total;
  final bool isDark;
  final DateTime? renewalDate;
  final bool isPolice;
  final bool paymentDone;
  final bool officeReceived;
  final VoidCallback onMarkOfficeReceived;

  const _AgreementCard({
    required this.item,
    required this.index,
    required this.total,
    required this.isDark,
    required this.renewalDate,
    required this.isPolice,
    required this.paymentDone,
    required this.officeReceived,
    required this.onMarkOfficeReceived,
  });

  Color _renewalColor() {
    if (renewalDate == null) return Colors.grey;
    final diff = renewalDate!.difference(DateTime.now()).inDays;
    if (diff < 0) return const Color(0xFFEF4444);
    if (diff <= 30) return const Color(0xFFF97316);
    return Colors.green;
  }

  String _formatDate(DateTime? date) {
    if (date == null) return "--";
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return "${date.day.toString().padLeft(2, '0')} ${months[date.month - 1]} ${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardBg =
    isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1E1E2C);

    final String type = item.agreementType?.toLowerCase() ?? "";
    Color bgColor;
    IconData iconData;

    if (type.contains("police")) {
      bgColor = isDark ? Colors.blue : Colors.red;
      iconData = Icons.local_police_rounded;
    } else if (type.contains("external")) {
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
            // ── Header ────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
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
                        Icon(iconData, size: 14, color: Colors.white),
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
                const SizedBox(width: 8),
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
                      color:
                      isDark ? Colors.black : Colors.white70,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Owner & Tenant ────────────────────────────────────────
            _CardDetailRow(
                label: "Owner:",
                value: item.ownerName,
                isDark: isDark),
            _CardDetailRow(
                label: "Tenant:",
                value: item.tenantName,
                isDark: isDark),

            if (!isPolice) ...[
              _CardDetailRow(
                label: "Rent:",
                value: "₹${item.monthlyRent}",
                isDark: isDark,
                valueColor: const Color(0xFF22C55E),
              ),
              _CardDetailRow(
                label: "Shifting Date:",
                value: _formatDate(item.shiftingDate),
                isDark: isDark,
              ),
              _CardDetailRow(
                label: "Renewal Date:",
                value: renewalDate != null
                    ? _formatDate(renewalDate)
                    : '--',
                isDark: isDark,
                valueColor: _renewalColor(),
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

            // ── Status Row ────────────────────────────────────────────
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
                    sublabel: officeReceived
                        ? "Delivered"
                        : "Not Delivered",
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

            // ── Field Worker + Cost ───────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _MiniAvatar(
                        color: const Color(0xFF7C3AED).withOpacity(0.2),
                        icon: Icons.person_rounded,
                        iconColor: const Color(0xFF7C3AED),
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          item.fieldWorkerName ?? "Unknown",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.black
                                : Colors.white70,
                          ),
                        ),
                      ),
                    ],
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

            const SizedBox(height: 8),

            // ── Date + Floor ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    "On ${_formatDate(item.currentDate)}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color:
                      isDark ? Colors.black : Colors.white60,
                    ),
                  ),
                ),
                if (!isPolice)
                  Text(
                    "Floor: ${item.floor ?? '--'}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? Colors.black87 : Colors.white,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // ── Mark Office / View Details ────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!officeReceived)
                  GestureDetector(
                    onTap: onMarkOfficeReceived,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF7C3AED),
                            Color(0xFFEC4899)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        "Mark Office Received",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                else
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "View Details",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF7C3AED),
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: Color(0xFF7C3AED),
                      ),
                    ],
                  ),
              ],
            ),

            // ── Missing Badges ────────────────────────────────────────────────────────
            if ((item.withPolice == "true" &&
                (item.policeVerificationPdf.isEmpty ||
                    item.policeVerificationPdf == 'null')) ||
                (!isPolice &&
                    (item.notaryImg.isEmpty ||
                        item.notaryImg == 'null')) ||
                (isPolice && _getMissingPoliceFields(item).isNotEmpty)) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  // Police verification missing
                  if (item.withPolice == "true" &&
                      (item.policeVerificationPdf.isEmpty ||
                          item.policeVerificationPdf == 'null'))
                    const _MissingBadge(label: "Police Verification Missing"),

                  // Notary missing (non-police)
                  if (!isPolice &&
                      (item.notaryImg.isEmpty || item.notaryImg == 'null'))
                    const _MissingBadge(label: "Notary Image Missing"),

                  // Police Verification agreement missing fields
                  if (isPolice)
                    ..._getMissingPoliceFields(item).map((field) =>
                        _MissingBadge(label: "$field Missing")
                    ).toList(),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Check which documents are missing for Police Verification
List<String> _getMissingPoliceFields(AgreementModel item) {
  final missing = <String>[];

  // Check Owner documents
  if ((item.ownerAadharFront?.isEmpty ?? true) ||
      (item.ownerAadharFront == 'null')) {
    missing.add("Owner Aadhar Front");
  }
  if ((item.ownerAadharBack?.isEmpty ?? true) ||
      (item.ownerAadharBack == 'null')) {
    missing.add("Owner Aadhar Back");
  }

  // Check Tenant documents
  if ((item.tenantAadharFront?.isEmpty ?? true) ||
      (item.tenantAadharFront == 'null')) {
    missing.add("Tenant Aadhar Front");
  }
  if ((item.tenantAadharBack?.isEmpty ?? true) ||
      (item.tenantAadharBack == 'null')) {
    missing.add("Tenant Aadhar Back");
  }

  // Check property address
  if ((item.rentedAddress?.isEmpty ?? true)) {
    missing.add("Property Address");
  }

  // Check police verification document itself
  if ((item.policeVerificationPdf?.isEmpty ?? true) ||
      (item.policeVerificationPdf == 'null')) {
    missing.add("Police verification");
  }

  return missing;
}


// ─────────────────────────────────────────────────────────────────────────────
// CARD DETAIL ROW
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// STATUS TICK
// ─────────────────────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────────────────────
// MINI AVATAR
// ─────────────────────────────────────────────────────────────────────────────
class _MiniAvatar extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;

  const _MiniAvatar({
    required this.color,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: Icon(icon, size: 14, color: iconColor),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MISSING BADGE
// ─────────────────────────────────────────────────────────────────────────────
class _MissingBadge extends StatelessWidget {
  final String label;
  final bool isPolice;
  final bool isComplete;

  const _MissingBadge({
    required this.label,
    this.isPolice = false,
    this.isComplete = false,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    Color borderColor;
    Color iconColor;
    Color textColor;

    if (isComplete) {
      // Green for complete
      bgColor = const Color(0xFF22C55E).withOpacity(0.12);
      borderColor = const Color(0xFF22C55E).withOpacity(0.4);
      iconColor = const Color(0xFF22C55E);
      textColor = const Color(0xFF22C55E);
    } else if (isPolice) {
      // Orange for police missing
      bgColor = const Color(0xFFF97316).withOpacity(0.12);
      borderColor = const Color(0xFFF97316).withOpacity(0.4);
      iconColor = const Color(0xFFF97316);
      textColor = const Color(0xFFF97316);
    } else {
      // Red for regular missing
      bgColor = const Color(0xFFEF4444).withOpacity(0.12);
      borderColor = const Color(0xFFEF4444).withOpacity(0.4);
      iconColor = const Color(0xFFEF4444);
      textColor = const Color(0xFFEF4444);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isComplete ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
            color: iconColor,
            size: 14,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}