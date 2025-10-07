import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/Agreement_model.dart';
import 'All_data_details_page.dart';

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

  @override
  void initState() {
    super.initState();
    fetchAgreements();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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

  _launchURL(String pdfUrl) async {
    final Uri url = Uri.parse(pdfUrl.startsWith("http")
        ? pdfUrl
        : "https://verifyserve.social/$pdfUrl");

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            // 🔍 Search bar
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search agreements...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[800]
                      : Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // 🧾 Total count
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

            // 📋 List of agreements
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
                        backgroundColor:
                        _getRenewalDateColor(renewalDate),
                        radius: 15,
                        child: Text(
                          '${filteredAgreements.length - index}',
                          style: TextStyle(
                            color: Theme.of(context).brightness ==
                                Brightness.dark
                                ? Colors.black
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        "Owner: ${item.ownerName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text("Tenant: ${item.tenantName}"),
                          Text("Rent: ₹${item.monthlyRent}"),
                          Text(
                              "Shifting Date: ${_formatDate(item.shiftingDate)}"),
                          Text(
                            "Renewal Date: ${renewalDate != null ? _formatDateTime(renewalDate) : '--'}",
                            style: TextStyle(
                              color:
                              _getRenewalDateColor(renewalDate),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text("Type: ${item.agreementType}"),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Agreement ID: ${item.id}"),

                              Text("By ${item.fieldWorkerName}",style: TextStyle(fontStyle: FontStyle.italic,fontSize: 12),),
                            ],
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
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
        shiftingDate.month + 10,
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
