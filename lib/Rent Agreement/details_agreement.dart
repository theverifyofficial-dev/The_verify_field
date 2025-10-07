import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Custom_Widget/Custom_backbutton.dart';

class AgreementDetailPage extends StatefulWidget {
  final String agreementId;
  const AgreementDetailPage({super.key, required this.agreementId});

  @override
  State<AgreementDetailPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AgreementDetailPage> {
  Map<String, dynamic>? agreement;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAgreementDetail();
  }

  Future<void> _fetchAgreementDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/agreemet_details_page.php?id=${widget.agreementId}"));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        debugPrint("🔹 API Response: $decoded");  // <-- add this
        if (decoded["status"] == "success" && decoded["count"] > 0) {
          setState(() {
            agreement = decoded["data"][0];
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.grey[900]!.withOpacity(0.85) // dark mode
            : Colors.white,                       // light mode
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.grey[700]! : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: child,
    );
  }

  Widget _sectionCard({required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _glassContainer(
            child: Column(children: children),
            padding: const EdgeInsets.all(14),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    if (v.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 140,
              child: Text('$k:',
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
  Widget _kvImage(String k, String url) {
    if (url.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              '$k:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${url}",
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${agreement?["agreement_type"] ?? "Agreement"} Details'),
        leading: SquareBackButton(),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : agreement == null
          ? const Center(child: Text("No details found"))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 First three sections in a horizontal scroll
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SizedBox(width: 300, child: _sectionCard(title: "Owner Details", children: [
                    DetailRow(label: "Owner Name", value: agreement?["owner_name"] ?? ""),
                    DetailRow(
                      label: "Relation",
                      value: "${agreement?["owner_relation"] ?? ""} ${agreement?["relation_person_name_owner"] ?? ""}",
                    ),
                    DetailRow(label: "Address", value: agreement?["parmanent_addresss_owner"] ?? ""),
                    DetailRow(label: "Mobile", value: agreement?["owner_mobile_no"] ?? ""),
                    DetailRow(label: "Aadhar", value: agreement?["owner_addhar_no"] ?? ""),
                  ])),

                  const SizedBox(width: 12),

                  SizedBox(width: 300, child: _sectionCard(title: "Tenant Details", children: [
                    DetailRow(label: "Tenant Name", value: agreement?["tenant_name"] ?? ""),
                    DetailRow(
                      label: "Relation",
                      value: "${agreement?["tenant_relation"] ?? ""} ${agreement?["relation_person_name_tenant"] ?? ""}",
                    ),
                    DetailRow(label: "Address", value: agreement?["permanent_address_tenant"] ?? ""),
                    DetailRow(label: "Mobile", value: agreement?["tenant_mobile_no"] ?? ""),
                    DetailRow(label: "Aadhar", value: agreement?["tenant_addhar_no"] ?? ""),
                  ])),

                  const SizedBox(width: 12),

                  SizedBox(width: 300, child: _sectionCard(title: "Agreement Details", children: [
                    DetailRow(label: "Property", value: agreement?["property_id"] ?? ""),
                    DetailRow(label: "BHK", value: agreement?["Bhk"] ?? ""),
                    DetailRow(label: "Floor", value: agreement?["floor"] ?? ""),
                    DetailRow(label: "Rented Address", value: agreement?["rented_address"] ?? ""),
                    DetailRow(label: "Monthly Rent", value: "₹${agreement?["monthly_rent"] ?? ""}"),
                    DetailRow(label: "Security", value: "₹${agreement?["securitys"] ?? ""}"),
                    DetailRow(label: "Installment Security", value: "₹${agreement?["installment_security_amount"] ?? ""}"),
                    DetailRow(label: "Meter", value: agreement?["meter"] ?? ""),
                    DetailRow(label: "Custom Unit", value: agreement?["custom_meter_unit"] ?? ""),
                    DetailRow(label: "Maintenance", value: agreement?["maintaince"] ?? ""),
                    DetailRow(label: "Parking", value: agreement?["parking"] ?? ""),
                    DetailRow(label: "Shifting Date", value: agreement?["shifting_date"]?.toString().split("T")[0] ?? ""),
                  ])),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Remaining sections vertically
            _sectionCard(title: "Field Worker", children: [
              DetailRow(label: "Name", value: agreement?["Fieldwarkarname"] ?? ""),
              DetailRow(label: "Number", value: agreement?["Fieldwarkarnumber"] ?? ""),
            ]),

            _sectionCard(title: "Documents", children: [
              DetailRow(label: "Owner Aadhaar Front", value: agreement?["owner_aadhar_front"] ?? "", isImage: true),
              DetailRow(label: "Owner Aadhaar Back", value: agreement?["owner_aadhar_back"] ?? "", isImage: true),
              DetailRow(label: "Tenant Aadhaar Front", value: agreement?["tenant_aadhar_front"] ?? "", isImage: true),
              DetailRow(label: "Tenant Aadhaar Back", value: agreement?["tenant_aadhar_back"] ?? "", isImage: true),
              DetailRow(label: "Tenant Photo", value: agreement?["tenant_image"] ?? "", isImage: true),
            ]),

            if (agreement?["status"] != null)
              _sectionCard(
                title: "Agreement Status",
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: (agreement?["status"]?.toString().toLowerCase() == "rejected")
                          ? Colors.red
                          : (agreement?["status"]?.toString().toLowerCase() == "Resubmit")
                          ? Colors.green
                          : Colors.grey, // fallback color for other statuses
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          DetailRow(label: "Status", value: agreement?["status"] ?? ""),
                          DetailRow(label: "Reason", value: agreement?["messages"] ?? ""),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

}

class ElevatedGradientButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;
  const ElevatedGradientButton(
      {required this.text, required this.icon, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Color(0xFF4CA1FF), Color(0xFF8A5CFF)]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 16,
                offset: const Offset(0, 8))
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Text(text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isImage;

  const DetailRow({
    super.key,
    required this.label,
    required this.value,
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              "$label:",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: isImage
                ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$value",
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, color: Colors.red),
              ),
            )
                : Text(value),
          ),
        ],
      ),
    );
  }
}

