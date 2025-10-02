import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/String_ID_model.dart';

class AcceptAgreement extends StatefulWidget {
  const AcceptAgreement({super.key});

  @override
  State<AcceptAgreement> createState() => _AgreementDetailsState();
}

class _AgreementDetailsState extends State<AcceptAgreement> {
  List<StringIdModel> agreements = [];
  bool isLoading = true;
  String? mobileNumber;

  @override
  void initState() {
    super.initState();
    fetchAgreements();
    _loadMobileNumber();
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
        backgroundColor: Colors.black,
        body:isLoading
            ? const Center(
          child: CircularProgressIndicator(color: Colors.white),
        )
            : agreements.isEmpty
            ? const Center(
          child: Text("No agreements found",
              style: TextStyle(color: Colors.white70)),
        )
            :  ListView.builder(
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
                trailing: const Text('by Admin',)
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (_) => AllDataDetailsPage(agreementId: item.id.toString()),
                //     ),
                //   );
                // },

                // no navigation for field worker only for admin to generate pdf & upload to main agreement table.
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