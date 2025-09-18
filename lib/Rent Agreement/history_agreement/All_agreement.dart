import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Administrator/Administator_Agreement/Admin_All_agreement_model.dart';
import '../all_agre_details.dart';
class AllAgreement extends StatefulWidget {
  const AllAgreement({super.key});

  @override
  State<AllAgreement> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AllAgreement> {
  List<AdminAllAgreementModel> agreements = [];
  bool isLoading = true;
  String? mobileNumber;

  @override
  void initState() {
    super.initState();
    fetchAgreements();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString("number");
    if (mobileNumber != null) {
      fetchAgreements();
    }
  }

  Future<void> fetchAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          'https://verifyserve.social/Second%20PHP%20FILE/main_application/show_agreement_by_fieldworkar.php?Fieldwarkarnumber=$mobileNumber'));

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
        backgroundColor: Colors.black,
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.white))
            : ListView.builder(
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
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AllAgreDetails(agreementId: item.id.toString()),
                    ),
                  );
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
      final date = DateTime.parse(rawDate); // ✅ works with "2025-09-17 00:00:00.000000"
      return "${_twoDigits(date.day)}-${_twoDigits(date.month)}-${date.year}";
    } catch (e) {
      return rawDate; // fallback in case parsing fails
    }
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');


}