import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../model/agrement_model.dart';
import '../Agreement_Form.dart';
import '../details_agreement.dart';

class RequestAgreementsPage extends StatefulWidget {
  const RequestAgreementsPage({super.key});

  @override
  State<RequestAgreementsPage> createState() => _RequestAgreementsPageState();
}

class _RequestAgreementsPageState extends State<RequestAgreementsPage> {
  String? mobileNumber;
  List<AgreementData> agreements = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMobileNumber();
  }

  Future<void> _loadMobileNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    mobileNumber = prefs.getString("number");
    if (mobileNumber != null) {
      _fetchRentalAgreements();
    }
  }

  Future<void> _fetchRentalAgreements() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/display_preview_agreemet.php?Fieldwarkarnumber=$mobileNumber"));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        if (decoded["status"] == "success") {
          final model = AgreementResponse.fromJson(decoded);
          setState(() {
            //agreements = model.data;
            agreements = model.data.reversed.toList();
            isLoading = false;
          }
          );
        } else {
          setState(() => isLoading = false);
        }
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("❌ Error fetching agreements: $e");
      setState(() => isLoading = false);
    }
  }
  Widget _buildAgreementCard(AgreementData agreement) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Owner: ${agreement.ownerName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "Tenant: ${agreement.tenantName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
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

            // Shifting date
            Text(
              "Shifting Date: ${agreement.shiftingDate.toLocal().toString().split(' ')[0]}",
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 6),

            // ✅ Status + message info
            if (agreement.status != null)
              Row(
                children: [
                  Text(
                    "Status: ",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    agreement.status!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: agreement.status!.toLowerCase() == "rejected"
                          ? Colors.red
                          : Colors.green,
                    ),
                  ),
                  if (agreement.messages != null &&
                      agreement.messages!.isNotEmpty) ...[
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Message"),
                            content: Text(agreement.messages!),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => RentalWizardPage(
                                        agreementId: agreement.id,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text("Edit"),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"),
                              )
                            ],
                          ),
                        );
                      },
                      child:
                      const Icon(Icons.message_rounded, color: Colors.blue),
                    ),
                  ],
                ],
              ),

            const SizedBox(height: 10),

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
                      builder: (_) => AgreementDetailPage(
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
