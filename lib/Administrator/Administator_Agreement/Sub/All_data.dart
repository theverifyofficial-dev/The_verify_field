import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../model/Agreement_model.dart';
import '../../imagepreviewscreen.dart';
import 'All_data_details_page.dart';
class AllData extends StatefulWidget {
  const AllData({super.key});

  @override
  State<AllData> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AllData> {
  List<AgreementModel> agreements = [];
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
                  "Tenant: ${item.tenantName}\n💰 Rent: ₹${item.monthlyRent}\n📆 Date: ${_formatDate(item.shiftingDate)}",
                  style: const TextStyle(color: Colors.white70),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),

                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllDataDetailsPage(agreementId: item.id.toString()),
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
    final timestamp = int.parse(rawDate.replaceAll(RegExp(r'[^0-9]'), ''));
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

}