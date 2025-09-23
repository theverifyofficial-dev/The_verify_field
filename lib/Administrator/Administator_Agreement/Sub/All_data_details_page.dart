import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../Custom_Widget/Custom_backbutton.dart';
import '../../imagepreviewscreen.dart';

class AllDataDetailsPage extends StatefulWidget {
  final String agreementId;
  const AllDataDetailsPage({super.key, required this.agreementId});

  @override
  State<AllDataDetailsPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AllDataDetailsPage> {
  Map<String, dynamic>? agreement;
  bool isLoading = true;
  File? pdfFile;

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
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/detail_page_main_agreement.php?id=${widget
              .agreementId}"));

      print(widget.agreementId);

      // Print raw response body
      print("API Response: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);

        // Print decoded JSON
        print("Decoded JSON: $decoded");

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
      } else {
        print("Error: Status code ${response.statusCode}");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  Widget _glassContainer({required Widget child, EdgeInsets? padding}) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;

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
    final value = v.toString().trim();

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
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget
  _kvImage(String k, dynamic url) {
    if (url == null) return const SizedBox.shrink();
    final imageUrl = url.toString().trim();
    if (imageUrl.isEmpty) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ImagePreviewScreen(imageUrl: 'https://theverify.in/$imageUrl'),
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
                  "https://theverify.in/$imageUrl",
                  height: 150,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(), // Hide if image fails to load
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

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [

                  _buildCard(
                    title: "Agreement Details",
                    children: [
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
                    ],
                  ),

                  Column(
                      children: [
                        _buildCard(
                          title: "Owner Details",
                          children: [
                            _kv("Owner Name", agreement?["owner_name"]),
                            _kv("Relation", "${agreement?["owner_relation"] ??
                                ""} ${agreement?["relation_person_name_owner"] ??
                                ""}"),
                            _kv("Address",
                                agreement?["parmanent_addresss_owner"]),
                            _kv("Mobile", agreement?["owner_mobile_no"]),
                            _kv("Aadhar", agreement?["owner_addhar_no"]),
                            Row(
                              children: [
                                _docImage(agreement?["owner_aadhar_front"]),
                                _docImage(agreement?["owner_aadhar_back"]),
                              ],
                            )
                          ],
                        ),

                      ]
                  ),

                  Column(
                      children: [
                        _buildCard(
                          title: "Tenant Details",
                          children: [
                            _kv("Tenant Name", agreement?["tenant_name"]),
                            _kv("Relation", "${agreement?["tenant_relation"] ??
                                ""} ${agreement?["relation_person_name_tenant"] ??
                                ""}"),
                            _kv("Address",
                                agreement?["permanent_address_tenant"]),
                            _kv("Mobile", agreement?["tenant_mobile_no"]),
                            _kv("Aadhar", agreement?["tenant_addhar_no"]),

                            Row(
                              children: [
                                _docImage(agreement?["tenant_aadhar_front"]),
                                _docImage(agreement?["tenant_aadhar_back"]),
                              ],
                            ),
                            SizedBox(height: 10,),
                            Container(
                              margin: EdgeInsets.only(top: 10.0),
                              child: Row(
                                children: [
                                  _docImage(agreement?["tenant_image"]),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]
                  ),

                ],
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                ElevatedButton(
                  onPressed: () =>
                      _launchURL(
                          'https://theverify.in/${agreement?["police_verification_pdf"]}'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow,
                      foregroundColor: Colors.black),
                  child: const Text('View P. Verification '),
                ),

                ElevatedButton(
                  onPressed: () =>
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ImagePreviewScreen(
                                  imageUrl: 'https://theverify.in/${agreement?["notry_img"]}'),
                        ),
                      ),

                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.black),
                  child: const Text('View Notary'),
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _launchURL(
                      'https://theverify.in/${agreement?["agreement_pdf"]}'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, foregroundColor: Colors.black),
                  child: const Text('View Agreement PDF'),
                ),
              ],
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 20),
      child: _sectionCard(title: title, children: children),
    );
  }

  Widget _docImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ImagePreviewScreen(
              imageUrl:
              'https://theverify.in/$imageUrl',
            ),
          ),
        );
      },
      child: Container(
        width: 120,
        height: 120,
        margin: const EdgeInsets.only(right: 12),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            "https://theverify.in/$imageUrl",
            width: 160,   // force same as container
            height: 120,  // force same as container
            fit: BoxFit.cover, // ensures full fill
            errorBuilder: (context, error, stackTrace) =>
            const SizedBox.shrink(), // Hide if image fails to load
          ),
        ),
      ),
    );
  }


  _launchURL(String pdf_url) async {
    final Uri url = Uri.parse(pdf_url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
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
