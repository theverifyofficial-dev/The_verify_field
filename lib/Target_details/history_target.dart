import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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

  Widget periodHeader(dynamic item, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
      child: Text(
        formatPeriod(item['period_start'], item['period_end']),
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Target History")),
      body:
      Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              value: selectedMonth,
              hint: const Text("Select Month"),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                isDense: true,
              ),
              items: months.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Text(m),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMonth = value;
                });
              },
            ),
          ),

          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: historyFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No bookings found"));
                }

                final filteredData = filterByMonth(snapshot.data!);

                if (filteredData.isEmpty) {
                  return const Center(child: Text("No data for selected month"));
                }

                return ListView(
                  children: [
                    // PERIOD SHOWN ONCE
                    periodHeader(filteredData.first, context),

                    // TARGET SUMMARY (ONCE)
                    targetSummaryCard(filteredData.first, context),

                    const SizedBox(height: 8),

                    // PROPERTY CARDS
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
  final theme = Theme.of(context);

  return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PropertyDetailPage(data: item),
          ),
        );      },
      child:
      Card(
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    elevation: 2,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Image.network(
            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${item['property_photo']}",
            height: 170,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 170,
              color: Colors.grey.shade300,
              child: const Icon(Icons.image_not_supported),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item['Bhk'],
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "₹${item['Rent']}",
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                ],
              ),

              const SizedBox(height: 6),
              Text(item['locations'], style: theme.textTheme.bodySmall),

              const SizedBox(height: 6),
              Text(
                "${item['Typeofproperty']} • ${item['Floor_']}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ));
}

