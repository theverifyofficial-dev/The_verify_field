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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
      child: Scaffold(
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [

            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [Colors.green.shade700, Colors.black]
                      : [Colors.green.shade400,Colors.white, ],
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

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [Colors.green.shade700, Colors.black]
                            : [Colors.black, Colors.green.shade400],
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
                            _InfoRow(title: "Rent", value: "₹${item.monthlyRent}"),
                            _InfoRow(title: "Shifting Date", value: _formatDate(item.shiftingDate)),
                            _InfoRow(
                              title: "Renewal Date",
                              value: renewalDate != null ? _formatDateTime(renewalDate) : '--',
                              valueColor: _getRenewalDateColor(renewalDate),
                            ),

                            const Divider(height: 20, color: Colors.white30),

                            // 🧩 Fieldworker and Floor
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
                                Text(
                                  "Floor: ${item.floor}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // ⚠ Missing field indicators
                            Wrap(
                              spacing: 8,
                              runSpacing: 6,
                              children: [
                                if (item.policeVerificationPdf.isEmpty ||
                                    item.policeVerificationPdf == 'null')
                                  _MissingBadge(label: "Police Verification Missing"),
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

