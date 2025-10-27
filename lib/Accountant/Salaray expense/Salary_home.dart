import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'Add_salary.dart';

class SalaryExpense {
  final String EmployeeName;
  final String Designation;
  final String BasicPay;
  final String paymentMode;
  final String Allowances;
  final String SalarySlip;
  final String PaymentDate;
  final String month;
  final String year;
  final String NetPay;
  final String? Deduction;

  SalaryExpense({
    required this.EmployeeName,
    required this.Designation,
    required this.BasicPay,
    required this.paymentMode,
    required this.Allowances,
    required this.PaymentDate,
    required this.month,
    required this.year,
    required this.SalarySlip,
    required this.NetPay,
    this.Deduction,
  });

  factory SalaryExpense.fromJson(Map<String, dynamic> json) {
    return SalaryExpense(
      EmployeeName: json['EmployeeName'].toString(),
      Designation: json['Designation'].toString(),
      BasicPay: json['BasicPay'].toString(),
      paymentMode: json['PaymentMode'].toString(),
      Allowances: json['Allowances'].toString(),
      PaymentDate: json['PaymentDate'].toString(),
      month: json['months'].toString(),
      year: json['years'].toString(),
      SalarySlip: json['SalarySlip'].toString(),
      NetPay: json['NetPay'].toString(),
      Deduction: json['Deduction']?.toString(),
    );
  }
}

class SalaryHome extends StatefulWidget {
  const SalaryHome({super.key});

  @override
  State<SalaryHome> createState() => _SalaryHomeState();
}

class _SalaryHomeState extends State<SalaryHome> {
  late Future<List<SalaryExpense>> _expenseFuture;

  @override
  void initState() {
    super.initState();
    _expenseFuture = _fetchExpenses();
  }

  Future<List<SalaryExpense>> _fetchExpenses() async {
    final url = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/Expanse/display_salary_expanse.php');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => SalaryExpense.fromJson(e)).toList().reversed.toList();
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  final NumberFormat currencyFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  String? _safeFormattedDate(String dateString) {
    try {
      final date = DateTime.tryParse(dateString);
      if (date == null) return null;
      return DateFormat('dd MMM yyyy').format(date);
    } catch (_) {
      return null;
    }
  }

  Widget _buildExpenseCard(SalaryExpense expense) {
    final double base = double.tryParse(expense.BasicPay) ?? 0;
    final double allow = double.tryParse(expense.Allowances) ?? 0;
    final double deduct = double.tryParse(expense.Deduction ?? "0") ?? 0;
    final double net = double.tryParse(expense.NetPay) ?? 0;

    final accent = Theme.of(context).colorScheme.primary;
    final formatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

    // ✅ Safely formatted date or null if invalid
    final formattedDate = _safeFormattedDate(expense.PaymentDate);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (expense.SalarySlip.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl:
                "https://verifyserve.social/Second%20PHP%20FILE/Expanse/${expense.SalarySlip}",
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(color: Colors.blueAccent)),
                errorWidget: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 60, color: Colors.grey),
              ),
            ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: accent.withOpacity(0.1),
                            child: const Icon(Icons.person, color: Colors.blueAccent),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  expense.EmployeeName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  expense.Designation,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        formatter.format(net),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                // Salary breakdown
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _salaryBlock("Basic", formatter.format(base), Icons.work_outline),
                      _salaryBlock("Allowance", formatter.format(allow), Icons.card_giftcard),
                      _salaryBlock("Deduction", formatter.format(deduct),
                          Icons.remove_circle_outline, Colors.redAccent),
                    ],
                  ),
                ),

                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined,
                            color: Colors.blueAccent, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          expense.paymentMode.toUpperCase(),
                          style: TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 13,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),

                    // ✅ only show date if valid
                    if (formattedDate != null)
                      Text(
                        formattedDate,
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _salaryBlock(String label, String amount, IconData icon,
      [Color color = Colors.black87]) {
    return Column(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(height: 4),
        Text(label,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.2)),
        const SizedBox(height: 2),
        Text(
          amount,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _salaryBreakdownItem(String label, double amount, {Color? color}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.w500)),
        Text(
          currencyFormatter.format(amount),
          style: TextStyle(
            color: color ?? Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder<List<SalaryExpense>>(
        future: _expenseFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.blueAccent));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No salary records found.'));
          }

          final expenses = snapshot.data!;
          final totalAmount = expenses.fold<double>(
              0, (sum, item) => sum + (double.tryParse(item.NetPay) ?? 0));
          return Column(
            children: [
              Card(
                margin:
                const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                color: Colors.black87,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Total Monthly Expense",
                          style:
                          TextStyle(color: Colors.white70, fontSize: 16)),
                      Text(
                        currencyFormatter.format(totalAmount),
                        style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    final expense = expenses[index];
                    final formattedDate = _safeFormattedDate(expense.PaymentDate);
                    if (formattedDate == null) return const SizedBox.shrink();
                    return _buildExpenseCard(expenses[index]);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddSalary()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
