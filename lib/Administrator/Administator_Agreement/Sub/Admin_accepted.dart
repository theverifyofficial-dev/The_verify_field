import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../model/String_ID_model.dart';
import 'Accepted_details.dart';

class AdminAccepted extends StatefulWidget {
  const AdminAccepted({super.key});

  @override
  State<AdminAccepted> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AdminAccepted> {
  List<StringIdModel> agreements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAgreements();
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
          'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_all_data_accept_agreement.php'));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        if (decoded is List) {
          setState(() {
            agreements = decoded
                .map((e) => StringIdModel.fromJson(e))
                .toList()
                .reversed
                .toList();
            isLoading = false;
          }
          );
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
        body:  isLoading
            ? const Center(child: CircularProgressIndicator())
            : agreements.isEmpty
            ? const Center(child: Text("No agreements found"))
            :ListView.builder(
          itemCount: agreements.length,
          padding: const EdgeInsets.all(10),
          itemBuilder: (context, index) {
            final item = agreements[index];
            return Card(
              color: Colors.grey[850],
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  "Owner: ${item.ownerName}",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Tenant: ${item.tenantName}\n Rent: ₹${item.monthlyRent}\n Date: ${_formatDate(item.shiftingDate)}",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AcceptedDetails(agreementId: item.id),
                    ),
                  );

                  _refreshAgreements();

                },
              ),
            );
          },
        ),
      ),
    );
  }
  String getFullImageUrl(String path) {
    path = path.replaceFirst(RegExp(r'^/?uploads/'), '');
    return 'https://theverify.in/uploads/$path';
  }

  String _formatDate(String rawDate) {
    try {
      // Sometimes API might return null or empty
      if (rawDate.isEmpty) return "N/A";

      // Parse directly
      final date = DateTime.parse(rawDate);

      return "${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}";
    } catch (e) {
      // Fallback in case parsing fails
      return rawDate;
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');


}