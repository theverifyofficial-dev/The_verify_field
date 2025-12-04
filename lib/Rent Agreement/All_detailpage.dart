import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../../../Custom_Widget/Custom_backbutton.dart';
import '../Administrator/imagepreviewscreen.dart';

class AllDetailpage extends StatefulWidget {
  final String agreementId;
  const AllDetailpage({super.key, required this.agreementId});

  @override
  State<AllDetailpage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AllDetailpage> {
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
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/detail_page_main_agreement.php?id=${widget.agreementId}"));

      print(widget.agreementId);

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
          fetchPropertyCard();
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

  Widget _furnitureList(dynamic furnitureData) {
    if (furnitureData == null || furnitureData.toString().trim().isEmpty) {
      return const SizedBox.shrink();
    }

    Map<String, dynamic> furnitureMap = {};
    try {
      if (furnitureData is String) {
        furnitureMap = Map<String, dynamic>.from(json.decode(furnitureData));
      } else if (furnitureData is Map<String, dynamic>) {
        furnitureMap = furnitureData;
      }
    } catch (e) {
      debugPrint("⚠️ Furniture parse error: $e");
    }

    if (furnitureMap.isEmpty) return const SizedBox.shrink();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Furnished Items:',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87)
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: furnitureMap.entries.map((e) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade700, width: 1),
                ),
                child: Text(
                  "${e.key} (${e.value})",
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
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


  @override
  Widget build(BuildContext context) {
    final bool isPolice = agreement?["agreement_type"] == "Police Verification";

    return Scaffold(
      appBar: AppBar(
        title: Text('${agreement?["agreement_type"] ?? ""} Details'),
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

            if (propertyCard != null) propertyCard!,

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  if (!isPolice)
                    _buildCard(
                      title: "Agreement Details",
                      children: [
                        _kv("BHK", agreement?["Bhk"] ?? ""),
                        _kv("Floor", agreement?["floor"] ?? ""),
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
                        _furnitureList(agreement!['furniture']),
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

            if (isPolice)
              _sectionCard(
                title: "Property Address",
                children: [
                  _kv("Rented Address", agreement?["rented_address"]),
                ],
              ),

            _sectionCard(title: "Field Worker", children: [
              _kv("Name", agreement!["Fieldwarkarname"]),
              _kv("Number", agreement!["Fieldwarkarnumber"]),
            ]),

            SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final pdf = agreement?["police_verification_pdf"];
                    if (pdf != null && pdf.toString().isNotEmpty) {
                      _launchURL(
                        'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$pdf',
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No Police Verification PDF found")),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (agreement?["police_verification_pdf"] == null ||
                        agreement!["police_verification_pdf"].toString().isEmpty)
                        ? Colors.grey
                        : Colors.yellow,
                    foregroundColor: Colors.black,
                  ),
                  child: Text(
                    'View P. Verification',
                  ),
                ),

                // 🔹 Notary Button
                if (!isPolice)
                  ElevatedButton(
                    onPressed: () {
                      final notary = agreement?["notry_img"];
                      if (notary != null && notary.toString().isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ImagePreviewScreen(
                              imageUrl:
                              'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$notary',
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No Notary Image found")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (agreement?["notry_img"] == null ||
                          agreement!["notry_img"].toString().isEmpty)
                          ? Colors.grey
                          : Colors.red,
                      foregroundColor: Colors.black,
                    ),
                    child: Text('View Notary',),
                  ),
              ],
            ),


            const SizedBox(height: 12),

            if (!isPolice)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        _launchURL(
                            'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/${agreement?["agreement_pdf"]}'),
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
              'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$imageUrl',
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
            "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$imageUrl",
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


  Widget? propertyCard;


  Future<void> fetchPropertyCard() async {
    final propertyId = agreement?["property_id"];
    if (propertyId == null || propertyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Property ID not found")),
      );
      return;
    }

    try {
      final response = await http.post(
        Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_api_base_on_flat_id.php"),
        body: {"P_id": propertyId},
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['status'] == "success") {
          final data = json['data'];

          setState(() {
            propertyCard = _propertyCard(data);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(json['message'] ?? "Property not found")),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch property details")),
      );
    }
  }

  Widget _propertyCard(Map<String, dynamic> data) {
    final String imageUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: Colors.black.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.grey[200],
                  alignment: Alignment.center,
                  child: const Text("No Image",
                      style: TextStyle(color: Colors.black54)),
                );
              },
            ),
          ),

          // Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // BHK + Floor
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "₹${data['show_Price'] ?? "--"}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),

                    Text(
                      data['Bhk'] ?? "",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      data['Floor_'] ?? "--",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Price + Meter
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Text(
                      "Name: ${data['field_warkar_name'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),

                    Text(
                      "Location: ${data['locations'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),

                  ],
                ),
                const SizedBox(height: 10),

                // // Availability
                // Text(
                //   "Available from: ${data['available_date']?.toString().split('T')[0] ?? "--"}",
                //   style: const TextStyle(
                //     fontSize: 15,
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
                // const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Meter: ${data['meter'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[100],
                      ),
                    ),

                    Text(
                      "Parking: ${data['parking'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Maintenance
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Maintenance: ${data['maintance'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[100],
                      ),
                    ),

                    Text(
                      "Flat ID: ${agreement?["property_id"] ?? "--"}",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[100],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
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
