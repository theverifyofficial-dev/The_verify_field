import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pdfx/pdfx.dart';
import '../../../Custom_Widget/Custom_backbutton.dart';
import '../../imagepreviewscreen.dart';
import 'PDF.dart';

class AcceptedDetails extends StatefulWidget {

  final String agreementId;
  const AcceptedDetails({super.key, required this.agreementId});

  @override
  State<AcceptedDetails> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AcceptedDetails> {
  Map<String, dynamic>? agreement;
  bool isLoading = true;
  File? pdfFile;
  bool pdfGenerated = false;


  @override
  void initState() {
    super.initState();
    _fetchAgreementDetail();
  }

  String? _formatDate(dynamic shiftingDate) {
    if (shiftingDate == null) return "";
    if (shiftingDate is Map && shiftingDate["date"] != null) {
      try {
        return DateTime.parse(shiftingDate["date"])
            .toLocal()
            .toString()
            .split(" ")[0];
      } catch (e) {
        return shiftingDate["date"].toString();
      }
    }
    if (shiftingDate is String && shiftingDate.isNotEmpty) {
      return shiftingDate;
    }
    return "";
  }

  Future<void> _fetchAgreementDetail() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/details_api_for_accect_agreement.php?id=${widget.agreementId}"));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        if (decoded["success"] == true &&
            decoded["data"] != null &&
            decoded["data"].isNotEmpty) {
          setState(() {
            agreement = Map<String, dynamic>.from(decoded["data"][0]);
            isLoading = false;
          });
        } else {
          setState(() => isLoading = false);
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
            ? Colors.grey[900]!.withOpacity(0.85)
            : Colors.white,
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
    // filter out empty children
    final visibleChildren = children.where((c) => c is! SizedBox).toList();
    if (visibleChildren.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _glassContainer(
            child: Column(children: visibleChildren),
            padding: const EdgeInsets.all(14),
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, dynamic v) {
    if (v == null) return const SizedBox.shrink();
    final value = v.toString().trim();
    if (value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 140,
              child: Text('$k:',
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _kvImage(String k, dynamic url) {
    if (url == null) return const SizedBox.shrink();
    final imageUrl = url.toString().trim();
    if (imageUrl.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImagePreviewScreen(imageUrl: 'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$imageUrl'),
          ),
        );
      },
      child: Padding(
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
                  "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$imageUrl",
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleGeneratePdf() async {
    if (agreement == null) return;

    File file;

    if (pdfFile == null) {
      // Generate only if not already done
      file = await generateAgreementPdf(agreement!);
      setState(() {
        pdfFile = file;
        pdfGenerated = true;
      });
    } else {
      file = pdfFile!;
    }

    // Open PDF in new screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text("Agreement PDF")),
          body: PdfViewPinch(
            controller: PdfControllerPinch(
              document: PdfDocument.openFile(file.path),
            ),
          ),
        ),
      ),
    );
  }


  Future<void> _handleDone() async {
    try {
      final response = await http.post(
        Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/final_accept_api.php"),
        body: {
          "id": widget.agreementId,
          "status": "accepted", // adjust field name as your backend expects
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Agreement marked as done ✅")),
        );
        Navigator.pop(context); // go back after success
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update. Try again.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    print(agreement?["owner_aadhar_back"]);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agreement Details'),
        leading: const SquareBackButton(),
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
            // 🔹 Owner Section
            _sectionCard(title: "Owner Details", children: [
              _kv("Owner Name", agreement?["owner_name"]),
              _kv(
                  "Relation",
                  "${agreement?["owner_relation"] ?? ""} ${agreement?["relation_person_name_owner"] ?? ""}"),
              _kv("Address", agreement?["parmanent_addresss_owner"]),
              _kv("Mobile", agreement?["owner_mobile_no"]),
              _kv("Aadhar", agreement?["owner_addhar_no"]),
            ]),

            // 🔹 Tenant Section
            _sectionCard(title: "Tenant Details", children: [
              _kv("Tenant Name", agreement?["tenant_name"]),
              _kv(
                  "Relation",
                  "${agreement?["tenant_relation"] ?? ""} ${agreement?["relation_person_name_tenant"] ?? ""}"),
              _kv("Address", agreement?["permanent_address_tenant"]),
              _kv("Mobile", agreement?["tenant_mobile_no"]),
              _kv("Aadhar", agreement?["tenant_addhar_no"]),
            ]),

            // 🔹 Agreement Info
            _sectionCard(title: "Agreement Details", children: [
              _kv("Rented Address", agreement?["rented_address"]),
              _kv("Monthly Rent", agreement?["monthly_rent"] != null
                  ? "₹${agreement?["monthly_rent"]}"
                  : ""),
              _kv("Security", agreement?["securitys"] != null
                  ? "₹${agreement?["securitys"]}"
                  : ""),
              _kv("Installment Security",
                  agreement?["installment_security_amount"] != null
                      ? "₹${agreement?["installment_security_amount"]}"
                      : ""),
              _kv("Meter", agreement?["meter"]),
              _kv("Custom Unit", agreement?["custom_meter_unit"]),
              _kv("Maintenance", agreement?["maintaince"]),
              _kv("Parking", agreement?["parking"]),
              _kv("Shifting Date",
                  _formatDate(agreement?["shifting_date"]) ?? ""),
            ]),

            // 🔹 Fieldworker
            _sectionCard(title: "Field Worker", children: [
              _kv("Name", agreement?["Fieldwarkarname"]),
              _kv("Number", agreement?["Fieldwarkarnumber"]),
            ]),

            // 🔹 Documents
            _sectionCard(title: "Documents", children: [
              _kvImage(
                  "Owner Aadhaar Front", agreement?["owner_aadhar_front"]),
              _kvImage(
                  "Owner Aadhaar Back", agreement?["owner_aadhar_back"]),
              _kvImage("Tenant Aadhaar Front",
                  agreement?["tenant_aadhar_front"]),
              _kvImage("Tenant Aadhaar Back",
                  agreement?["tenant_aadhar_back"]),
              _kvImage("Tenant Photo", agreement?["tenant_image"]),
            ]),


            const SizedBox(height: 30),

            const SizedBox(height: 20),

            // 🔹 Preview PDF Button (full width, big button)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: double.infinity, // make it full width
              child: ElevatedButton.icon(
                onPressed: (){
                  //_handleGeneratePdf
                },
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text(
                  "Preview PDF",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16), // increase height
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: pdfGenerated ? _handleDone : null, // disabled if not generated
                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: pdfGenerated ? Colors.green : Colors.grey,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
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
