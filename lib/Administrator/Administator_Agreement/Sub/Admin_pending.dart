import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/acceptAgreement.dart';
import '../Admin_Agreement_details.dart';

class AdminPending extends StatefulWidget {
  const AdminPending({super.key});

  @override
  State<AdminPending> createState() => _AdminPendingState();
}

class _AdminPendingState extends State<AdminPending> {
  List<AgreementModel2> agreements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadAgreements();
  }

  Future<void> loadAgreements() async {
    try {
      final data = await fetchAgreements();
      setState(() {
        agreements = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint("Error loading agreements: $e");
    }
  }

  Future<List<AgreementModel2>> fetchAgreements() async {
    final url = Uri.parse(
        'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreement_data_for_admin.php');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => AgreementModel2.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load agreements');
    }
  }

  Widget _buildAgreementCard(AgreementModel2 agreement) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner & Tenant Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Owner: ${agreement.ownerName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Tenant: ${agreement.tenantName}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Address
            Text(
              "Property Address: ${agreement.rentedAddress}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("💰 Rent: ₹${agreement.monthlyRent}",
                    style: const TextStyle(fontSize: 14)),
                Text("🔐 Security: ₹${agreement.securitys}",
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 6),

            Text(
              "Shifting Date: ${agreement.shiftingDate.toString().split('T')[0]}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),

            Text("🛠 Maintenance: ${agreement.maintaince}",
                style: const TextStyle(fontSize: 14)),

            const SizedBox(height: 6),

            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => AdminAgreementDetails(
                        agreementId: agreement.id,
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.visibility,
                    size: 18, color: Colors.white),
                label: const Text("View Details",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : agreements.isEmpty
          ? const Center(child: Text("No agreements found"))
          : ListView.builder(
        itemCount: agreements.length,
        itemBuilder: (context, index) {
          return _buildAgreementCard(agreements[index]);
        },
      ),
    );
  }
}
