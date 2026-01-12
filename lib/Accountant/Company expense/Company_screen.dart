import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../constant.dart';
import '../../property_preview.dart';
import '../../utilities/bug_founder_fuction.dart';
import 'Add_expenses.dart';
import 'expenses_details.dart';


class Expense {
  final String expenseID;
  final String date;
  final String description;
  final String amount;
  final String paymentMode;
  final String? paidTo;
  final String paymentSnapshot;
  final String category;
  final String month;
  final String year;


  Expense({
    required this.expenseID,
    required this.date,
    required this.description,
    required this.amount,
    required this.paymentMode,
    this.paidTo,
    required this.category,
    required this.month,
    required this.year,
    required this.paymentSnapshot,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      expenseID: json['ExpenseID'].toString(),
      date: json['Dates'].toString(),
      description: json['Descriptions'].toString(),
      amount: json['Amount'].toString(),
      paymentMode: json['PaymentMode'].toString(),
      paidTo: json['PaidTo']?.toString(),
      category: json['Category'].toString(),
      month: json['months'].toString(),
      year: json['years'].toString(),

      paymentSnapshot: json['payment_snapshot'].toString(),
    );
  }
}

class CompanyScreen extends StatefulWidget {
  const CompanyScreen({super.key});

  @override
  State<CompanyScreen> createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<CompanyScreen> {
  late Future<List<Expense>> _expenseFuture;

  @override
  void initState() {
    super.initState();
    _expenseFuture = _fetchExpenses();
  }

  Future<List<Expense>> _fetchExpenses() async {
    final url = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Expanse/display_paymenti_information.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => Expense.fromJson(e)).toList().reversed.toList();
    } else {
      // 🔴 LOG BACKEND FAILURE
      await BugLogger.log(
        apiLink: 'https://verifyserve.social/Second%20PHP%20FILE/Expanse/display_paymenti_information.php',
        error: response.body.toString(),
        statusCode: response.statusCode ?? 0,
      );
      throw Exception('Failed to load expenses');
    }
  }

  Widget _buildExpenseCard(Expense expense) {
    Color categoryColor;

    switch (expense.category.toLowerCase()) {
      case 'rent':
        categoryColor = Colors.orange.shade400;
        break;
      case 'utilities':
        categoryColor = Colors.blue.shade400;
        break;
      case 'travel':
        categoryColor = Colors.green.shade400;
        break;
      case 'office supplies':
        categoryColor = Colors.purple.shade400;
        break;
      default:
        categoryColor = Colors.grey.shade400;
    }

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shadowColor: Colors.black45,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (expense.paymentSnapshot.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PropertyPreview(
                          ImageUrl:
                          "https://verifyserve.social/Second%20PHP%20FILE/Expanse/${expense.paymentSnapshot}",
                        ),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl:
                    'https://verifyserve.social/Second%20PHP%20FILE/Expanse/${expense.paymentSnapshot}',
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, widget) =>
                    const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                    const Icon(Icons.error, size: 50, color: Colors.red),
                  ),
                ),
              ),
            const SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    expense.description,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4, horizontal: 8),
                  decoration: BoxDecoration(
                    color: categoryColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "₹${expense.amount}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),
            Text("Paid To: ${expense.paidTo ?? 'N/A'}",
                style: TextStyle(fontSize: 13, color: Colors.grey)),
            Text("Mode: ${expense.paymentMode} Payment",
                style: TextStyle(fontSize: 13, color: Colors.grey)),

            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(
                    expense.category,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: categoryColor,
                ),
                Text(
                  DateFormat('dd MMM yyyy')
                      .format(DateTime.parse(expense.date)),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Expense>>(
        future: _expenseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses found.'));
          }

          final expenses = snapshot.data!;
          final totalAmount = expenses.fold<double>(
              0, (sum, item) => sum + (double.tryParse(item.amount) ?? 0));

          return Column(
            children: [
              // Total Amount Card
              Card(
                margin: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.black87,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total Monthly Expense",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      Text(
                        "₹$totalAmount",
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              // Expense List
              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    return _buildExpenseCard(expenses[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddExpenses()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


