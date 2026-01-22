import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../Administrator/Administator_Agreement/Admin_All_agreement_model.dart';
import '../../Administrator/Administator_Agreement/Sub/All_data.dart';
import '../All_detailpage.dart';

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

  FieldWorkerPayment? myPayment;
  bool isPaymentLoading = false;

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
      await fetchMyPayment();   // 👈 ONE TIME
      await fetchAgreements();
    } else {
      setState(() => isLoading = false);
    }
  }


  Future<void> fetchMyPayment() async {
    if (mobileNumber == null || mobileNumber!.isEmpty) return;

    try {
      setState(() => isPaymentLoading = true);

      final res = await http.get(
        Uri.parse(
          'https://verifyserve.social/Second%20PHP%20FILE/Tenant_demand/payment_count.php?fieldworker=$mobileNumber',
        ),
      );

      final data = jsonDecode(res.body);

      if (data['status'] == true) {
        myPayment = FieldWorkerPayment(
          number: data['fieldworker'],
          name: "You",
          pendingAgreements:
          int.parse(data['total_pending_agreements'].toString()),
          pendingAmount:
          int.parse(data['total_pending_amount'].toString()),
        );
      }
    } catch (e) {
      debugPrint("❌ Payment fetch error: $e");
    } finally {
      setState(() => isPaymentLoading = false);
    }
  }



  Future<void> _refreshAgreements() async {
    try {
      setState(() => isLoading = true);
      await fetchAgreements();
    } catch (e) {
      debugPrint("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> fetchAgreements() async {
    try {
      final url = Uri.parse(
          'https://verifyserve.social/Second%20PHP%20FILE/main_application/show_agreement_by_fieldworkar.php?Fieldwarkarnumber=$mobileNumber');
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

  // 🔹 CARD COLOR LOGIC (Police Verification)
  List<Color> _getCardColors(String? type, bool isDark) {
    if (type == "Police Verification") {
      return isDark
          ? [Colors.blue.shade900, Colors.black]
          : [Colors.black, Colors.blue.shade400];
    }
    return isDark
        ? [Colors.green.shade700, Colors.black]
        : [Colors.black, Colors.green.shade400];
  }

  DateTime? _getRenewalDate(dynamic rawDate) {
    try {
      String actualDate =
      rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return null;
      final shiftingDate = DateTime.parse(actualDate.split(' ')[0]);
      return DateTime(shiftingDate.year, shiftingDate.month + 11, shiftingDate.day);
    } catch (e) {
      return null;
    }
  }

  Color _getRenewalDateColor(DateTime? renewalDate) {
    if (renewalDate == null) return Colors.grey;
    final now = DateTime.now();
    final difference = renewalDate.difference(now).inDays;
    if (difference < 0) return Colors.redAccent;
    if (difference <= 30) return Colors.amberAccent.shade700;
    return Colors.greenAccent.shade400;
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : const Color(0xFFF8F6F2),
        body: RefreshIndicator(
          onRefresh: _refreshAgreements,
          child: isLoading
              ? const Center(child: CircularProgressIndicator(color: Colors.green))
              : Column(
            children: [

              // 🔷 Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.green.shade700, Colors.black]
                        : [ Colors.green.shade400, Colors.white ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Agreements",
                      style: const TextStyle(
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
                          prefixIcon: Icon(Icons.search, color: Colors.green.shade700),
                          hintText: "Search by Owner, Tenant, or ID...",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        ),
                        style: TextStyle(color: isDark ? Colors.white : Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              // Total Count
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Agreements: ${filteredAgreements.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark ? Colors.green.shade200 : Colors.green.shade800,
                    ),
                  ),
                ),
              ),

              if (isPaymentLoading)
                const Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (myPayment != null)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.black.withOpacity(0.4)
                            : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white12
                              : Colors.grey.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                        myPayment!.pendingAgreements > 0
                        ? "Your Pending Payment"
                            : "All Payments Clear",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Pending: ${myPayment!.pendingAgreements}",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.65),
                                ),
                              ),
                              Text(
                                "₹${myPayment!.pendingAmount}",
                                style:  TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: myPayment!.pendingAmount == 0
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),


              // 📌 List
              Expanded(
                child: filteredAgreements.isEmpty
                    ? Center(
                  child: Text(
                    "No agreements found",
                    style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  ),
                )
                    : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredAgreements.length,
                  itemBuilder: (context, index) {

                    final item = filteredAgreements[index];
                    final renewal = _getRenewalDate(item.shiftingDate);
                    final isPolice = item.agreementType == "Police Verification";

                    final bool paymentDone = item.payment.toString() == "1";
                    final bool officeReceived = item.recieved.toString() == "1";
                    final withPolice= item.withPolice.toString() == "true";


                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        gradient: LinearGradient(
                          colors: _getCardColors(item.agreementType, isDark),
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllDetailpage(
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

                              // Header
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 15,
                                        backgroundColor: _getRenewalDateColor(renewal),
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
                                        item.agreementType ?? "Agreement",
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
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),

                              // Owner & Tenant
                              _InfoRow(title: "Owner", value: item.ownerName),
                              _InfoRow(title: "Tenant", value: item.tenantName),

                              if (!isPolice) ...[
                                _InfoRow(title: "Rent", value: "₹${item.monthlyRent}"),
                                _InfoRow(title: "Shifting Date", value: _formatDate(item.shiftingDate)),
                                _InfoRow(
                                  title: "Renewal Date",
                                  value: renewal != null ? _formatDateTime(renewal) : "--",
                                  valueColor: _getRenewalDateColor(renewal),
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
                              // Floor (hide for police)
                              if (!isPolice)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [

                                    Text(
                                      "Floor: ${item.floor}",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),

                              const SizedBox(height: 10),

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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 🔹 Info Row Widget
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
            color: Colors.white70,
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



