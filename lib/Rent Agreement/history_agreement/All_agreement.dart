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
  bool isLoading = true;
  String? mobileNumber;
  List<AdminAllAgreementModel> filteredAgreements = [];
  TextEditingController searchController = TextEditingController();

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
      print("❌ Error refreshing agreements: $e");
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
          } else {
            throw Exception('Data is not a list');
          }
        } else {
          throw Exception('Invalid response format');
        }
      } else {
        throw Exception('Failed to load data');
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
      String actualDate = rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return null;

      final shiftingDate = DateTime.parse(actualDate.split(' ')[0]);
      final renewalDate = DateTime(
        shiftingDate.year,
        shiftingDate.month + 10,
        shiftingDate.day,
      );
      return renewalDate;
    } catch (e) {
      debugPrint("❌ Renewal date parse error: $e");
      return null;
    }
  }

  Color _getRenewalDateColor(DateTime? renewalDate) {
    if (renewalDate == null) return Colors.black;
    final now = DateTime.now();
    final difference = renewalDate.difference(now).inDays;

    if (difference < 0) return Colors.red; // expired
    if (difference <= 30) return Colors.orange; // expiring within 30 days
    return Colors.green; // safe
  }

  String _formatDate(dynamic rawDate) {
    try {
      String actualDate = rawDate is Map ? rawDate['date'] ?? '' : rawDate.toString();
      if (actualDate.isEmpty) return "--";

      final date = DateTime.parse(actualDate.split(' ')[0]);
      return "${_twoDigits(date.day)} ${_monthName(date.month)} ${date.year}";
    } catch (e) {
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
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search agreements...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white60
                        : Colors.grey[600],
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white70
                        : Colors.grey[700],
                  ),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
              ),
            ),

            // Agreement count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Total Agreements: ${filteredAgreements.length}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // List of agreements
            Expanded(
              child: filteredAgreements.isEmpty
                  ? const Center(child: Text("No agreements found"))
                  : ListView.builder(
                itemCount: filteredAgreements.length,
                padding: const EdgeInsets.all(10),
                itemBuilder: (context, index) {
                  final item = filteredAgreements[index];
                  final renewalDate = _getRenewalDate(item.shiftingDate);

                  return Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]
                        : Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: _getRenewalDateColor(renewalDate),
                        radius: 15,
                        child: Text(
                          '${filteredAgreements.length - index}',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "Owner: ${item.ownerName}",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tenant: ${item.tenantName}"),
                          Text("Rent: ₹${item.monthlyRent}"),
                          Text("Shifting Date: ${_formatDate(item.shiftingDate)}"),
                          Text(
                            "Renewal Date: ${renewalDate != null ? _formatDateTime(renewalDate) : '--'}",
                            style: TextStyle(
                              color: _getRenewalDateColor(renewalDate),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Agreement ID: ${item.id}"),
                        ],
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.grey[600],
                        size: 16,
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => AllDataDetailsPage(
                                agreementId: item.id.toString()),
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
    );
  }
}
