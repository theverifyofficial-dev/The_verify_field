import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Custom_Widget/Custom_backbutton.dart';
import '../../imagepreviewscreen.dart';
import 'PDF.dart';
import 'package:open_filex/open_filex.dart';

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

  // for display in new file
  // Future<void> _handleGeneratePdf() async {
  //   if (agreement == null) return;
  //
  //   File file;
  //
  //   if (pdfFile == null) {
  //     // Generate only if not already done
  //     file = await generateAgreementPdf(agreement!);
  //     setState(() {
  //       pdfFile = file;
  //       pdfGenerated = true;
  //     });
  //   } else {
  //     file = pdfFile!;
  //   }
  //
  //   // Open PDF in new screen
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => Scaffold(
  //         appBar: AppBar(title: const Text("Agreement PDF")),
  //         body: PdfViewPinch(
  //           controller: PdfControllerPinch(
  //             document: PdfDocument.openFile(file.path),
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Future<void> _submitAll() async {
    print("🔹 _submitAll called");

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final uri = Uri.parse("https://theverify.in/insert.php");
      final request = http.MultipartRequest("POST", uri);

      // 🔹 Fields
      final Map<String, dynamic> textFields = {
        "id" : widget.agreementId,
        "owner_name": agreement?["owner_name"] ?? "",
        "owner_relation": agreement?["owner_relation"] ?? "",
        "relation_person_name_owner": agreement?["relation_person_name_owner"] ?? "",
        "parmanent_addresss_owner": agreement?["parmanent_addresss_owner"] ?? "",
        "owner_mobile_no": agreement?["owner_mobile_no"] ?? "",
        "owner_addhar_no": agreement?["owner_addhar_no"] ?? "",
        "tenant_name": agreement?["tenant_name"] ?? "",
        "tenant_relation": agreement?["tenant_relation"] ?? "",
        "relation_person_name_tenant": agreement?["relation_person_name_tenant"] ?? "",
        "permanent_address_tenant": agreement?["permanent_address_tenant"] ?? "",
        "tenant_mobile_no": agreement?["tenant_mobile_no"] ?? "",
        "tenant_addhar_no": agreement?["tenant_addhar_no"] ?? "",
        "rented_address": agreement?["rented_address"] ?? "",
        "monthly_rent": agreement?["monthly_rent"] ?? "",
        "securitys": agreement?["securitys"] ?? "",
        "installment_security_amount": agreement?["installment_security_amount"] ?? "",
        "meter": agreement?["meter"] ?? "",
        "custom_meter_unit": agreement?["custom_meter_unit"] ?? "",
        "shifting_date": agreement?["shifting_date"] != null
            ? (agreement!["shifting_date"] is DateTime
            ? (agreement!["shifting_date"] as DateTime).toIso8601String()
            : agreement!["shifting_date"].toString())
            : "",
        "maintaince": agreement?["maintaince"] ?? "",
        "custom_maintenance_charge": agreement?["custom_maintenance_charge"] ?? "",
        "parking": agreement?["parking"] ?? "",
        "current_dates": DateTime.now().toIso8601String(),
        "Fieldwarkarname": agreement?["Fieldwarkarname"] ?? "",
        "Fieldwarkarnumber": agreement?["Fieldwarkarnumber"] ?? "",
        "property_id": agreement?["property_id"] ?? "",
      };

      // 🔹 Print all fields for debugging
      print("📌 Fields to be sent:");
      textFields.forEach((k, v) => print("   $k -> $v"));

      textFields.forEach((key, value) {
        request.fields[key] = value.toString();
      }
      );

      // 🔹 Files
      Future<void> addFileFromUrl(String key, String? relativeUrl, {String? filename}) async {
        if (relativeUrl != null && relativeUrl.isNotEmpty) {
          final fullUrl = "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$relativeUrl";
          print("📌 Fetching file for $key from $fullUrl");
          final response = await http.get(Uri.parse(fullUrl));
          if (response.statusCode == 200) {
            final tempFile = File("${Directory.systemTemp.path}/$filename");
            await tempFile.writeAsBytes(response.bodyBytes);
            request.files.add(await http.MultipartFile.fromPath(key, tempFile.path, filename: filename));
            print("✅ File attached: $key at ${tempFile.path}");
          } else {
            print("❌ Failed to fetch file for $key. Status: ${response.statusCode}");
          }
        } else {
          print("⚠️ No file URL provided for $key");
        }
      }

      await addFileFromUrl("owner_aadhar_front", agreement?["owner_aadhar_front"], filename: "owner_aadhar_front.jpg");
      await addFileFromUrl("owner_aadhar_back", agreement?["owner_aadhar_back"], filename: "owner_aadhar_back.jpg");
      await addFileFromUrl("tenant_aadhar_front", agreement?["tenant_aadhar_front"], filename: "tenant_aadhar_front.jpg");
      await addFileFromUrl("tenant_aadhar_back", agreement?["tenant_aadhar_back"], filename: "tenant_aadhar_back.jpg");
      await addFileFromUrl("tenant_image", agreement?["tenant_image"], filename: "tenant_image.jpg");

      if (pdfFile != null) {
        print("📌 Attaching PDF at ${pdfFile!.path}");
        request.files.add(await http.MultipartFile.fromPath(
          "agreement_pdf",
          pdfFile!.path,
          // contentType: MediaType("application", "pdf"),
          filename: "agreement.pdf",
        ));
      } else {
        print("⚠️ No PDF file found, skipping agreement_pdf");
      }


      // 🔹 Send request
      print("📌 Sending request to API...");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 Server responded with status: ${response.statusCode}");
      print("📄 Response body: ${response.body}");

      if (response.statusCode == 200 && response.body.toLowerCase().contains("success")) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submitted successfully! ✅")),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Submit failed (${response.statusCode})")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      print("🔥 Exception during submit: $e");
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> _handleGeneratePdf() async {
    if (agreement == null) return;

    File file;

    if (pdfFile == null) {
      file = await generateAgreementPdf(agreement!);
      setState(() {
        pdfFile = file;
        pdfGenerated = true;
      });
    } else {
      file = pdfFile!;
    }
    setState(() {
      pdfFile = file;
      pdfGenerated = true;
    });
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
            // 🔹 First Horizontal Row (Owner / Tenant / Agreement / Field Worker)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [

                  _buildCard(
                    title: "Agreement Details",
                    children: [
                      _kv("Rented Address", agreement?["rented_address"]),
                      _kv("Monthly Rent", agreement?["monthly_rent"] != null ? "₹${agreement?["monthly_rent"]}" : ""),
                      _kv("Security", agreement?["securitys"] != null ? "₹${agreement?["securitys"]}" : ""),
                      _kv("Installment Security", agreement?["installment_security_amount"] != null ? "₹${agreement?["installment_security_amount"]}" : ""),
                      _kv("Meter", agreement?["meter"]),
                      _kv("Custom Unit", agreement?["custom_meter_unit"]),
                      _kv("Maintenance", agreement?["maintaince"]),
                      _kv("Parking", agreement?["parking"]),
                      _kv("Shifting Date", _formatDate(agreement?["shifting_date"]) ?? ""),
                    ],
                  ),

                  Column(
                    children: [
                      _buildCard(
                        title: "Owner Details",
                        children: [
                          _kv("Owner Name", agreement?["owner_name"]),
                          _kv("Relation", "${agreement?["owner_relation"] ?? ""} ${agreement?["relation_person_name_owner"] ?? ""}"),
                          _kv("Address", agreement?["parmanent_addresss_owner"]),
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
                            _kv("Relation", "${agreement?["tenant_relation"] ?? ""} ${agreement?["relation_person_name_tenant"] ?? ""}"),
                            _kv("Address", agreement?["permanent_address_tenant"]),
                            _kv("Mobile", agreement?["tenant_mobile_no"]),
                            _kv("Aadhar", agreement?["tenant_addhar_no"]),

                            Row(
                              children: [
                                _docImage(agreement?["tenant_aadhar_front"]),
                                _docImage(agreement?["tenant_aadhar_back"]),
                              ],
                            ),
                            Row(
                              children: [
                                _docImage(agreement?["tenant_image"]),
                              ],
                            ),
                          ],
                        ),
                      ]
                  ),

                ],
              ),
            ),

            _buildCard(
              title: "Field Worker",
              children: [
                _kv("Name", agreement?["Fieldwarkarname"]),
                _kv("Number", agreement?["Fieldwarkarnumber"]),
              ],
            ),

            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.upload_sharp, color: Colors.white),
                      label: const Text(
                        "P. Verification",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange, // First color
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                // Expanded(
                //   child: Container(
                //     margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                //     child: ElevatedButton.icon(
                //       onPressed: () {
                //         // TODO: Handle Action 2
                //       },
                //       icon: const Icon(Icons.edit, color: Colors.white),
                //       label: const Text(
                //         "Edit",
                //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                //       ),
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: Colors.blue, // Second color
                //         padding: const EdgeInsets.symmetric(vertical: 14),
                //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //       ),
                //     ),
                //   ),
                // ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Handle Action 3
                      },
                      icon: const Icon(Icons.upload_sharp, color: Colors.white),
                      label: const Text(
                        "Notary",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red, // Third color
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

            if (pdfFile != null)
              _glassContainer(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                  title: Text(pdfFile!.path.split('/').last),
                  subtitle: const Text("Tap to open in browser"),
                  onTap: () async {
                    final uri = Uri.file(pdfFile!.path);
                    // inside onTap
                    if (pdfFile != null) {
                      await OpenFilex.open(pdfFile!.path);
                    }
                    else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Could not open PDF")),
                      );
                    }
                  },
                ),
              ),



            const SizedBox(height: 20),

            // 🔹 Preview PDF Button (full width, big button)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: double.infinity, // make it full width
              child: ElevatedButton.icon(
                onPressed: (){
                  _handleGeneratePdf();
                },
                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                label: const Text(
                  "Generate Agreement",
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
                onPressed: pdfGenerated ? _submitAll : null, // disabled if not generated
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

  Widget _docLabel(String text) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _docImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return Container(
        width: 160,
        height: 120,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
      );
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
            errorBuilder: (context, error, stackTrace) => Container(
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.red, size: 40),
            ),
          ),
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