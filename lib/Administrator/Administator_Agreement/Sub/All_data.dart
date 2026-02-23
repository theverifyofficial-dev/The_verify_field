import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/Agreement_model.dart';
import 'All_data_details_page.dart';

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
      remainingAmount:
      int.tryParse(json['remaining_amount'].toString()) ?? 0,
    );
  }
}

class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AllData> {

  List<AgreementModel> agreements = [];
  List<AgreementModel> filteredAgreements = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  late Future<List<FieldWorkerPayment>> _paymentsFuture;
  FieldWorkerPayment? monthlyPaymentSummary;

  @override
  void initState() {
    super.initState();
    fetchAgreements();
    _paymentsFuture = fetchAllFieldWorkersPayments();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

   List<Map<String, String>> fieldWorkers = [
    {"number": "9711775300", "name": "Sumit"},
    {"number": "9711275300", "name": "Ravi Kumar"},
    {"number": "9971172204", "name": "Faizan Khan"},
    {"number": "9675383184", "name": "Abhay"},
    {"number": "8130209217", "name": "Manish"},
  ];

  Future<FieldWorkerPayment> fetchPaymentForWorker({
    required String number,
    required String name,
  })
  async {
    final res = await http.get(
      Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/payment_count_new_api.php?fieldworker=$number',
      ),
    );

    final data = jsonDecode(res.body);

    if (data['status'] != true) {
      throw Exception("Failed for $number");
    }

    return FieldWorkerPayment.fromJson(
      data,
      name: name,
    );
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

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredAgreements = agreements.where((a) {
        return a.ownerName.toLowerCase().contains(query) ||
            a.tenantName.toLowerCase().contains(query) ||
            a.id.toString().contains(query);
      }).toList();
    });
  }

  Future<void> _refreshAgreements() async {
    try {
      setState(() => isLoading = true);
      await fetchAgreements();
      monthlyPaymentSummary = null;

    } catch (e) {
      debugPrint("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> fetchAgreements() async {
    try {
      final response = await http.get(
        Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/show_main_agreement_data.php'),
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        // The response might be wrapped with {status, message, data}
        if (decoded is Map && decoded.containsKey('data')) {
          final List dataList = decoded['data'];

          setState(() {
            agreements = dataList.map((e) => AgreementModel.fromJson(e)).toList().reversed.toList();
            filteredAgreements = agreements;
            isLoading = false;
          });
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      debugPrint('❌ Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  List<Color> _getCardColors(String? type, bool isDark) {
    if (type == "Police Verification") {
      return isDark
          ? [Colors.blue.shade900, Colors.black]
          : [Colors.black, Colors.blue.shade400];
    }

    // Default colors
    return isDark
        ? [Colors.green.shade700, Colors.black]
        : [Colors.black, Colors.green.shade400];
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.green.shade700, Colors.black]
                        : [Colors.green.shade400, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Final Agreements",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[850] : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon:
                          Icon(Icons.search, color: Colors.green.shade700),
                          hintText: "Search by Owner, Tenant, or ID...",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),



            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child:
    Container(
    margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 6),
    padding: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
    gradient: LinearGradient(
    colors: Theme.of(context).brightness == Brightness.dark
    ? [Colors.deepPurple.shade800, Colors.black]
        : [Colors.deepPurple.shade300, Colors.white],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
    BoxShadow(
    color: Colors.green.withOpacity(0.25),
    blurRadius: 8,
    offset: const Offset(0, 4),
    ),
    ],
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // 🔹 Section Title
    Padding(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
    child: Text(
    "Field Worker Pending Payments",
    style: TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: Theme.of(context).brightness == Brightness.dark
    ? Colors.white
        : Colors.green.shade900,
    ),
    ),
    ),

    const SizedBox(height: 6),

    // 🔹 Compact Horizontal List
    SizedBox(
    height: 120,
    child: monthlyPaymentSummary != null
        ? _buildMonthlySummaryCard(monthlyPaymentSummary!)
        : FutureBuilder<List<FieldWorkerPayment>>(
    future: _paymentsFuture,
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return const Center(
    child: CircularProgressIndicator(strokeWidth: 2),
    );
    }

    if (snapshot.hasError) {
    return Center(
    child: Text(
    "Failed to load payments",
    style: TextStyle(
    color: Theme.of(context).colorScheme.error,
    ),
    ),
    );
    }

    final data = snapshot.data!;
    final isDark =
    Theme.of(context).brightness == Brightness.dark;

    return ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    itemCount: data.length,
    separatorBuilder: (_, __) => const SizedBox(width: 8),
    itemBuilder: (context, index) {
    final fw = data[index];

    return Container(
    width: 210,
    padding: const EdgeInsets.symmetric(
    horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
    color: isDark
    ? Colors.black.withOpacity(0.4)
        : Colors.white.withOpacity(0.9),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
    color: isDark
    ? Colors.white12
        : Colors.grey.shade300,
    ),
    ),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    // 👤 Name + Number
    Row(
    mainAxisAlignment:
    MainAxisAlignment.spaceBetween,
    children: [
    Expanded(
    child: Text(
    fw.name,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
    fontSize: 13.5,
    fontWeight: FontWeight.w600,
    color: Theme.of(context)
        .colorScheme
        .onSurface,
    ),
    ),
    ),
    const SizedBox(width: 6),
    Text(
    fw.number,
    style: TextStyle(
    fontSize: 11,
    color: Theme.of(context)
        .colorScheme
        .onSurface
        .withOpacity(0.6),
    ),
    ),
    ],
    ),



    const Spacer(),

    // 📊 Bottom details
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Total ₹${fw.totalAmount}",
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
          ),

          const SizedBox(height: 2),

          // ✅ PAID
          Text(
            "Paid ₹${fw.paidAmount}",
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.greenAccent,
            ),
          ),

          const SizedBox(height: 2),

          // ❗ REMAINING (MOST IMPORTANT)
          Text(
            "Remaining ₹${fw.remainingAmount}",
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
        ],
      )
    ],
    ),
    );
    },
    );
    },
    ),
    ),
    ],
    ),
    ),
              ),
            ),

            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Agreements: ${filteredAgreements.length}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isDark
                            ? Colors.green.shade200
                            : Colors.green.shade800,
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () => _openMonthFilterSheet(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Filter",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )


                  ],
                ),
              ),
            ),




            // 📋 List of agreements
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final item = filteredAgreements[index];
                  final renewalDate = _getRenewalDate(item.shiftingDate);
                  final bool isPolice =
                      item.agreementType == "Police Verification";

                  final bool paymentDone = item.payment.toString() == "1";
                  final bool officeReceived =
                      item.recieved.toString() == "1";

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: _getCardColors(item.agreementType, isDark),

                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 0.6,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(18),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllDataDetailsPage(
                              agreementId: item.id.toString(),
                            ),
                          ),
                        );
                        _refreshAgreements();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🧾 Header Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 15,
                                      backgroundColor: _getRenewalDateColor(renewalDate),
                                      child: Text(
                                        '${filteredAgreements.length - index}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Text(
                                      item.agreementType?.isNotEmpty == true
                                          ? item.agreementType!
                                          : "General Agreement",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "ID: ${item.id}",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // 👥 Owner & Tenant Info
                            _InfoRow(title: "Owner", value: item.ownerName),
                            _InfoRow(title: "Tenant", value: item.tenantName),
                            if (!isPolice) ...[
                              _InfoRow(title: "Rent", value: "₹${item.monthlyRent}"),
                            _InfoRow(title: "Shifting Date", value: _formatDate(item.shiftingDate)),
                            _InfoRow(
                              title: "Renewal Date",
                              value: renewalDate != null ? _formatDateTime(renewalDate) : '--',
                              valueColor: _getRenewalDateColor(renewalDate),
                            ),
                            ],

                            const Divider(height: 20, color: Colors.white30),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _statusTick(
                                  label: "Payment",
                                  sublabel: paymentDone ? "Paid" : "Pending",
                                  done: paymentDone,
                                  activeColor: Colors.lightBlueAccent,
                                ),
                                _statusTick(
                                  label: "Office",
                                  sublabel: officeReceived ? "Delivered" : "Not Delivered",
                                  done: officeReceived,
                                  activeColor: Colors.greenAccent,
                                ),
                              ],
                            ),

                            const SizedBox(height: 10),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "By ${item.fieldWorkerName}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                if (!isPolice)
                                Text(
                                  "Floor: ${item.floor}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (!officeReceived)
                                  ElevatedButton(
                                      onPressed: () => _confirmAndUpdateOfficeReceived(
                                        context: context,
                                        agreementId: item.id.toString(),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: const Text(
                                        "Mark Office Received",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),

                                Text(
                                  "cost: ₹${item.agreement_price}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                                Text(
                                  "Filled On ${_formatDate(item.currentDate)}",
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 12,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 4),

                            // ⚠ Missing field indicators
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                if (item.policeVerificationPdf.isEmpty ||
                                    item.policeVerificationPdf == 'null')
                                  _MissingBadge(label: "Police Verification Missing"),
                                if (!isPolice)
                                  if (item.notaryImg.isEmpty || item.notaryImg == 'null')
                                  _MissingBadge(label: "Notary Image Missing"),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: filteredAgreements.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmAndUpdateOfficeReceived({
    required BuildContext context,
    required String agreementId,
  })
  async {
    bool isSubmitting = false;

    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // 🚫 force decision
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              title: Row(
                children: const [
                  Icon(Icons.apartment_rounded, color: Colors.green),
                  SizedBox(width: 8),
                  Text("Confirm Office Received",style: TextStyle(fontSize: 16),),
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
                    backgroundColor: Colors.green,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
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
                    style: TextStyle(fontWeight: FontWeight.bold),
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
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/update_payment_field.php",
        ),
        body: {
          "id": agreementId,
          "office_received": "1",
          "office_received_at": DateTime.now().toIso8601String(),
        },
      );

      final decoded = jsonDecode(response.body);

      if (decoded["status"] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.verified_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text("Office successfully marked as received"),
              ],
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        _refreshAgreements(); // 🔄 refresh list
      } else {
        throw decoded["message"];
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Update failed: $e"),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Widget _buildMonthlySummaryCard(FieldWorkerPayment summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.black.withOpacity(0.5)
            : Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white12 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Payment Summary",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text("Total ₹${summary.totalAmount}"),
          Text(
            "Paid ₹${summary.paidAmount}",
            style: const TextStyle(color: Colors.green),
          ),
          Text(
            "Remaining ₹${summary.remainingAmount}",
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchAgreementsByMonth({
    required String month,
    String? fieldWorker, // nullable
  })
  async {
    final Map<String, String> queryParams = {
      "month": month,
    };

    print(month);
    // ✅ ONLY pass fw if specific fieldworker selected
    if (fieldWorker != null && fieldWorker.isNotEmpty) {
      queryParams["fw"] = fieldWorker;
    }

    final uri = Uri.parse(
      'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/month_wise_agreement.php',
    ).replace(queryParameters: queryParams);

    debugPrint("📡 Month Filter API: $uri");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      if (decoded['success'] == true && decoded['data'] is List) {
        final summary = decoded['month_payment_summary'];

        setState(() {
          agreements = decoded['data']
              .map<AgreementModel>((e) => AgreementModel.fromJson(e))
              .toList();
          filteredAgreements = agreements;

          monthlyPaymentSummary = FieldWorkerPayment(
            number: "",
            name: "Monthly Summary",
            totalAmount:
            int.tryParse(summary['total_amount'].toString()) ?? 0,
            paidAmount:
            int.tryParse(summary['paid_amount'].toString()) ?? 0,
            remainingAmount:
            int.tryParse(summary['remaining_amount'].toString()) ?? 0,
          );
        });
      } else {
        debugPrint("⚠️ No data for selected filter");
        setState(() {
          agreements = [];
          filteredAgreements = [];
          monthlyPaymentSummary = null;

        });
      }
    } else {
      debugPrint("❌ API failed: ${response.body}");
    }
  }

  void _openMonthFilterSheet(BuildContext context) {
    int selectedYear = DateTime.now().year;
    int selectedMonth = DateTime.now().month;
    String selectedFW = "all";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Filter Agreements",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 📅 Month Dropdown
                  DropdownButtonFormField<int>(
                    value: selectedMonth,
                    decoration: const InputDecoration(labelText: "Month"),
                    items: List.generate(12, (i) {
                      return DropdownMenuItem(
                        value: i + 1,
                        child: Text(_monthName(i + 1)),
                      );
                    }),
                    onChanged: (val) =>
                        setSheetState(() => selectedMonth = val!),
                  ),

                  const SizedBox(height: 12),

                  // 📆 Year Dropdown
                  DropdownButtonFormField<int>(
                    value: selectedYear,
                    decoration: const InputDecoration(labelText: "Year"),
                    items: List.generate(5, (i) {
                      final year = DateTime.now().year - 2 + i;
                      return DropdownMenuItem(
                        value: year,
                        child: Text(year.toString()),
                      );
                    }),
                    onChanged: (val) =>
                        setSheetState(() => selectedYear = val!),
                  ),

                  const SizedBox(height: 12),

                  // 👤 Fieldworker Dropdown
                  DropdownButtonFormField<String>(
                    value: selectedFW,
                    decoration:
                    const InputDecoration(labelText: "Field Worker"),
                    items: [
                      const DropdownMenuItem(
                        value: "all",
                        child: Text("All Field Workers"),
                      ),
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

                  // ✅ APPLY BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final monthStr =
                            "$selectedYear-${selectedMonth.toString().padLeft(2, '0')}";

                        Navigator.pop(context);

                        fetchAgreementsByMonth(
                          month: monthStr,
                          fieldWorker: selectedFW == "all" ? null : selectedFW,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Apply Filter",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
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


  // ✅ Converts DateTime to "dd MMM yyyy"
  String _formatDate(DateTime? date) {
    if (date == null) return "--";
    return "${_twoDigits(date.day)} ${_monthName(date.month)} ${date.year}";
  }

  // ✅ Calculates Renewal Date = shiftingDate + 10 months
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

  String _formatDateTime(DateTime date) =>
      "${_twoDigits(date.day)} ${_monthName(date.month)} ${date.year}";

  Color _getRenewalDateColor(DateTime? renewalDate) {
    if (renewalDate == null) return Colors.black;
    final now = DateTime.now();
    final difference = renewalDate.difference(now).inDays;

    if (difference < 0) return Colors.red; // expired
    if (difference <= 30) return Colors.orange; // expiring soon
    return Colors.green; // safe
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[month - 1];
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}

// 🔹 Info Row (Key-Value Style)
Widget _InfoRow({required String title, required String value, Color? valueColor}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "$title:",
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.white,
            ),
          ),
        ),
      ],
    ),
  );
}

class _MissingBadge extends StatelessWidget {
  final String label;
  const _MissingBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.redAccent, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

}

Widget _statusTick({
  required String label,
  required String sublabel,
  required bool done,
  required Color activeColor,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        Icons.verified_rounded,
        size: 16,
        color: done
            ? activeColor
            : Colors.white.withOpacity(0.25),
      ),
      const SizedBox(width: 4),
      Text(
        "${label}: ${sublabel}",
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: done ? Colors.white : Colors.white60,
        ),
      ),
    ],
  );
}





