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
      print("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> fetchAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          'https://verifyserve.social/WebService4.asmx/show_agreement_data'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          setState(() {
            agreements = decoded
                .map((e) => AgreementModel.fromJson(e))
                .toList()
                .reversed
                .toList();
            filteredAgreements = agreements; // Initially, show all
            isLoading = false;
          });
        } else {
          throw Exception('Invalid data format');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => isLoading = false);
    }
  }

  _launchURL(String pdf_url) async {
    final Uri url = Uri.parse(pdf_url);
    if (!await launchUrl(url)) {
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
                  return Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey[850]  // Dark mode card color
                        : Colors.white,      // Light mode card color
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3, // subtle shadow
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).brightness == Brightness.dark
                            ? Colors.green
                            : Colors.blue,
                        radius: 15,
                        child: Text(
                          '${filteredAgreements.length - index}', // Reverse numbering
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
                      subtitle: Text(
                        "Tenant: ${item.tenantName}\n"
                            "Rent: ₹${item.monthlyRent}\n"
                            "Shifting Date: ${_formatDate(item.shiftingDate)}\n"
                            "Agreement ID: ${item.id}",
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.grey[800],
                        ),
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

  String getFullImageUrl(String path) {
    path = path.replaceFirst(RegExp(r'^/?uploads/'), '');
    return 'https://theverify.in/uploads/$path';
  }

  String _formatDate(String rawDate) {
    final timestamp = int.parse(rawDate.replaceAll(RegExp(r'[^0-9]'), ''));
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');
}

