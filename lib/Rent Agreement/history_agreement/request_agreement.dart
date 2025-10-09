import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../model/agrement_model.dart';
import '../Forms/Agreement_Form.dart';
import '../Forms/External_Form.dart';
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

  void _navigateToEditForm(BuildContext context, AgreementData agreement) async {
    Widget page;

    switch (agreement.Type.toLowerCase()) {
      case "rental agreement":
        page = RentalWizardPage(agreementId: agreement.id);
        break;

      case "external rental agreement":
        page = ExternalWizardPage(agreementId: agreement.id);
        break;

      // case "lease":
      //   page = LeaseAgreementForm(agreementId: agreement.id);
      //   break;

      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unknown agreement type: ${agreement.Type}")),
        );
        return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );

    _refreshAgreements();
  }


  Future<void> _refreshAgreements() async {
    try {
      setState(() => isLoading = true);
      await _fetchRentalAgreements();
    } catch (e) {
      print("❌ Error refreshing agreements: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
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
            // ✅ Status + message info
            if (agreement.status != null) ...[
              Row(
                children: [
                  const Text(
                    "Status: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
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
                  SizedBox(width: 20,),

                   Text(
                    "Message: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Text(
                    agreement.messages!,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: agreement.status!.toLowerCase() == "fields Updated"
                          ? Colors.green
                          : Colors.red,
                    ),
                  ),
                ],
              ),

              // Show message + Edit button (only for rejected with message)
              if (agreement.status!.toLowerCase() == "rejected" &&
                  agreement.messages != null &&
                  agreement.messages!.isNotEmpty) ...[

                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    onPressed: () => _navigateToEditForm(context, agreement),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Edit", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ],


            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(agreement.Type,style: TextStyle(fontSize: 12,color: Colors.blue),),

                ElevatedButton.icon(
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
              ],
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
