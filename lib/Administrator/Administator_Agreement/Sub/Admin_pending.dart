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

      // 🔹 Reverse the mapped list
      return data
          .map((e) => AgreementModel2.fromJson(e))
          .toList()
          .reversed
          .toList();
    } else {
      throw Exception('Failed to load agreements');
    }
  }


  Widget _buildAgreementCard(AgreementModel2 agreement) {
    final screenWidth = MediaQuery.of(context).size.width;

    double scale(double size) => size * (screenWidth / 375).clamp(0.85, 1.2);

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(scale(14)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner & Tenant Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Owner: ${agreement.ownerName}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: scale(16),
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
                      fontSize: scale(16),
                    ),
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),

            SizedBox(height: scale(8)),

            Text(
              "Property Address: ${agreement.rentedAddress}",
              style: TextStyle(fontSize: scale(14)),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            SizedBox(height: scale(6)),

            if (agreement.status != null)
              Row(
                children: [
                  Text(
                    "Status: ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: scale(14),
                    ),
                  ),
                  Text(
                    agreement.status!,
                    style: TextStyle(
                      fontSize: scale(14),
                      color: agreement.status!.toLowerCase() == 'rejected'
                          ? Colors.red
                          : Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (agreement.messages != null) ...[
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
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Close"),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Icon(Icons.info_outline, color: Colors.blue),
                    ),
                  ],
                  SizedBox(width: scale(100)),
                  Flexible(
                    child: Text(
                      "By ${agreement.fieldwarkarname}",
                      style: TextStyle(fontSize: scale(14)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

            SizedBox(height: scale(12)),

            Align(
              alignment:
              screenWidth < 400 ? Alignment.center : Alignment.centerRight,
              child: SizedBox(
                width: screenWidth < 400 ? double.infinity : null,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: scale(12),
                      horizontal: scale(16),
                    ),
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
                  icon:
                  Icon(Icons.visibility, size: scale(18), color: Colors.white),
                  label: Text(
                    "View Details",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: scale(14),
                    ),
                  ),
                ),
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
