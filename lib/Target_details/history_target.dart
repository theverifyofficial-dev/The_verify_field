  import 'dart:convert';
  import 'package:flutter/material.dart';
  import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
  import 'package:shared_preferences/shared_preferences.dart';
  import 'history_detailpage.dart';

  class TargetHistoryScreen extends StatefulWidget {
    final String? number; // admin passes this, field worker = null

    const TargetHistoryScreen({super.key, this.number});
    @override
    State<TargetHistoryScreen> createState() => _TargetHistoryScreenState();
  }

  class _TargetHistoryScreenState extends State<TargetHistoryScreen> {
    late Future<List<dynamic>> historyFuture;

    final List<String> months = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December",
    ];

    String? selectedMonth;

    @override
    void initState() {
      super.initState();
      historyFuture = fetchTargetHistory();
      final now = DateTime.now();
      selectedMonth = months[now.month - 1];

      historyFuture = fetchTargetHistory();
    }

    Widget monthSelector() {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () async {
            final selected = await showModalBottomSheet<String>(
              context: context,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => ListView(
                children: months.map((m) {
                  return ListTile(
                    title: Text(m),
                    trailing: selectedMonth == m
                        ? const Icon(Icons.check, color: Colors.deepPurple)
                        : null,
                    onTap: () => Navigator.pop(context, m),
                  );
                }).toList(),
              ),
            );

            if (selected != null) {
              setState(() => selectedMonth = selected);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(

                  color: Theme.of(context).brightness==Brightness.dark?Colors.grey.shade800:Colors.grey.shade300
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedMonth ?? "Select Month",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.expand_more, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }
    Widget periodHeader(dynamic item) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Text(
          formatPeriod(item['period_start'], item['period_end']),
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness==Brightness.dark?Colors.grey:Colors.grey.shade600,

            fontWeight: FontWeight.w700,
            letterSpacing: 1,

          ),
        ),
      );
    }


    Future<String?> getFieldWorkerNumber() async {
      // 1️⃣ Admin navigation wins
      if (widget.number != null && widget.number!.isNotEmpty) {
        return widget.number;
      }

      // 2️⃣ Field worker fallback
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('number');
    }

    Future<List<dynamic>> fetchTargetHistory() async {
      final number = await getFieldWorkerNumber();
      if (number == null) throw Exception("Field worker number missing");

      final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/monthly_history_for_book_flat.php?field_workar_number=$number",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['status'] == true) {
          return body['data'];
        }
      }

      return [];
    }

    List<dynamic> filterByMonth(List<dynamic> data) {
      if (selectedMonth == null) return data;

      return data.where((item) {
        DateTime start =
        DateTime.parse(item['period_start']['date']);
        return months[start.month - 1] == selectedMonth;
      }).toList();
    }
    Widget targetSummaryCard(dynamic item) {
      return Container(
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: Theme.of(context).brightness==Brightness.dark?Colors.grey.shade800:Colors.grey.shade200
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              "Target Count",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: Theme.of(context).brightness==Brightness.dark?Colors.grey:Colors.grey.shade600

              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _count("Total", item['total_booked'], Colors.blue),
                _count("Rent", item['rent_count'], Colors.green),
                _count("Buy", item['buy_count'], Colors.orange),
              ],
            ),
          ],
        ),
      );
    }

    Widget _count(String label, int value, Color color) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$value",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Theme.of(context).brightness==Brightness.dark?Colors.grey:Colors.grey.shade600

            ),
          ),
        ],
      );
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          surfaceTintColor: Theme.of(context).brightness==Brightness.dark ? Colors.black: Colors.white,
            backgroundColor: Theme.of(context).brightness==Brightness.dark ? Colors.black: Colors.white,
            title: Text("Target History",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness==Brightness.dark ? Colors.white : Colors.black87,
            fontSize: 24,
            letterSpacing: 1,

          ),
        )),
        body:
        Column(
          children: [
            monthSelector(),

            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: historyFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No bookings found"));
                  }

                  final filteredData = filterByMonth(snapshot.data!);

                  if (filteredData.isEmpty) {
                    return Center(
                      child: Text(
                        "No data for $selectedMonth",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }

                  return ListView(
                    children: [
                      periodHeader(filteredData.first,),
                      targetSummaryCard(filteredData.first),
                      const SizedBox(height: 8),
                      ...filteredData.map(
                            (item) => propertyCard(item, context),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      );
    }
  }


  String formatPeriod(Map periodStart, Map periodEnd) {
    DateTime start = DateTime.parse(periodStart['date']);
    DateTime end = DateTime.parse(periodEnd['date']);

    return "${start.day} ${_month(start.month)} – ${end.day} ${_month(end.month)}";
  }

  String _month(int m) {
    const months = [
      "", "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[m];
  }
  final indianCurrency = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  Widget targetSummaryCard(dynamic item, BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Target Count',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _countTile("Total", item['total_booked'], Colors.blue),
                _countTile("Rent", item['rent_count'], Colors.green),
                _countTile("Buy", item['buy_count'], Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _countTile(String label, int count, Color color) {
    return Column(
      children: [
        Text(
          "$count",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }


  Widget propertyCard(dynamic item, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailPage(data: item),
          ),
        );
      },
      child: Container(
        margin:  EdgeInsets.fromLTRB(16, 0, 16, 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color:
          Theme.of(context).brightness==Brightness.dark?Colors.grey.shade900:
          Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// IMAGE + PRICE
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item['property_photo']}",
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 220,
                      color: Colors.grey.shade300,
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:Text(
                      indianCurrency.format(int.parse(item['Rent'].toString())),
                      style: const TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),

                  ),
                ),
              ],
            ),

            /// DETAILS
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item['Bhk'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color:Theme.of(context).brightness==Brightness.dark? Colors.white10:Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child:  Text(
                          item['Buy_Rent'],
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "PoppinsMedium",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item['locations'],
                    style:  TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).brightness==Brightness.dark?Colors.grey:Colors.grey.shade600
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${item['Typeofproperty']} • ${item['Floor_']}",
                    style:  TextStyle(
                      fontSize: 12,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w700,
                        color: Theme.of(context).brightness==Brightness.dark?Colors.grey:Colors.grey.shade600
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

