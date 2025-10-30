import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Administrator/Administator_Agreement/Admin_All_agreement_model.dart';
import '../../Administrator/Administator_Agreement/Sub/All_data_details_page.dart';

class AllAgreement extends StatefulWidget {
  const AllAgreement({super.key});

  @override
  State<AllAgreement> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AllAgreement> {
  List<AdminAllAgreementModel> agreements = [];
  List<AdminAllAgreementModel> filteredAgreements = [];
  bool isLoading = true;
  String? mobileNumber;
  final TextEditingController searchController = TextEditingController();

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
      await fetchAgreements();
    } else {
      setState(() => isLoading = false);
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

  _launchURL(String pdfUrl) async {
    final Uri url = Uri.parse(pdfUrl);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  DateTime? _getRenewalDate(dynamic rawDate) {
    try {
      String actualDate =
      rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return null;

      final shiftingDate = DateTime.parse(actualDate.split(' ')[0]);
      return DateTime(
          shiftingDate.year, shiftingDate.month + 10, shiftingDate.day);
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
              // 🔶 Header Section
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [Colors.green.shade700, Colors.black]
                        : [Colors.black, Colors.green.shade400],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Agreements",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[850]
                            : Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search,
                              color: Colors.green.shade700),
                          hintText: "Search by Owner, Tenant, or ID...",
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: isDark
                                ? Colors.white54
                                : Colors.grey[700],
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 14),
                        ),
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 🧾 Count Info
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Total Agreements: ${filteredAgreements.length}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isDark
                          ? Colors.green.shade200
                          : Colors.green.shade800,
                    ),
                  ),
                ),
              ),

              // 📜 List Section
              Expanded(
                child: filteredAgreements.isEmpty
                    ? Center(
                  child: Text(
                    "No agreements found",
                    style: TextStyle(
                      color: isDark
                          ? Colors.white54
                          : Colors.grey[700],
                    ),
                  ),
                )
                    : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(12),
                  itemCount: filteredAgreements.length,
                  itemBuilder: (context, index) {
                    final item = filteredAgreements[index];
                    final renewalDate =
                    _getRenewalDate(item.shiftingDate);
                    final color =
                    _getRenewalDateColor(renewalDate);

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey[900]
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.green.shade700
                              .withOpacity(0.4),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green
                                .withOpacity(0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                        const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        leading: CircleAvatar(
                          backgroundColor: color,
                          radius: 18,
                          child: Text(
                            '${filteredAgreements.length - index}',
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        title: Text(
                          item.ownerName,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: isDark
                                ? Colors.green
                                : Colors.black87,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text("Tenant: ${item.tenantName}"),
                              Text("Rent: ₹${item.monthlyRent}"),
                              Text(
                                  "Shifted: ${_formatDate(item.shiftingDate)}"),
                              Text(
                                "Renewal: ${renewalDate != null ? _formatDateTime(renewalDate) : '--'}",
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text("ID: ${item.id}"),
                            ],
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: isDark
                              ? Colors.green
                              : Colors.grey[700],
                          size: 18,
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AllDataDetailsPage(
                                  agreementId:
                                  item.id.toString()),
                            ),
                          );
                          _refreshAgreements();
                        },
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
