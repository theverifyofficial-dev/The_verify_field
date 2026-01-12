import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as img;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../../Custom_Widget/Custom_backbutton.dart';
import '../../imagepreviewscreen.dart';
import 'PDF.dart';
import 'package:open_filex/open_filex.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';

import 'furnished pdf.dart';
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:typed_data';
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
  File? policeVerificationFile;
  File? notaryImageFile;



  @override
  void initState() {
    super.initState();
    _fetchAgreementDetail();
  }


  MediaType _mediaTypeFromPath(String path) {
    final mime = lookupMimeType(path) ?? 'application/octet-stream';
    final parts = mime.split('/');
    return MediaType(parts.first, parts.length > 1 ? parts.last : 'octet-stream');
  }

  bool isCompressing = false;
  String compressedSizeText = "";

  Future<File> compressImageTo150KB(File file) async {
    try {
      int originalKB = file.lengthSync() ~/ 1024;
      debugPrint("📸 BEFORE Compress: $originalKB KB");

      Uint8List bytes = await file.readAsBytes();

      img.Image? image = img.decodeImage(bytes);
      if (image == null) {
        debugPrint("❌ Could not decode image");
        return file;
      }

      int quality = 90;
      int width = image.width;

      File compressed = file;

      while (true) {
        // 🔥 Correct resize function
        img.Image resized = img.copyResize(image, width: width);

        // 🔥 Correct JPG encoder
        List<int> jpgBytes = img.encodeJpg(resized, quality: quality);

        // Write file
        File temp = File("${file.path}_${DateTime.now().millisecondsSinceEpoch}.jpg");
        await temp.writeAsBytes(jpgBytes);

        int sizeKB = temp.lengthSync() ~/ 1024;
        debugPrint("🔄 Width=$width | Quality=$quality | Size=$sizeKB KB");

        if (sizeKB <= 150) {
          compressed = temp;
          break;
        }

        quality -= 10;
        width = (width * 0.85).toInt();

        if (quality < 10 || width < 300) {
          compressed = temp;
          break;
        }
      }

      debugPrint("📦 AFTER Compress: ${compressed.lengthSync() ~/ 1024} KB");
      return compressed;

    } catch (e) {
      debugPrint("❌ Compress Error: $e");
      return file;
    }
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


  Future<void> _fetchAgreementDetail() async {
    print(widget.agreementId);
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
          fetchPropertyCard();
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
    // if (v == null) return const SizedBox.shrink();
    final value = v.toString().trim();
    // if (value.isEmpty) return const SizedBox.shrink();

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


  Future<void> _submitAll() async {
    if (agreement == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final uri = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/insert.php",
      );

      final request = http.MultipartRequest('POST', uri);
      request.headers['Accept'] = 'application/json';

      final bool isPolice = agreement?["agreement_type"] == "Police Verification";

      // ----------------------
      // BASIC FIELDS
      // ----------------------
      final fields = <String, String>{
        "accept_delete_id": widget.agreementId,
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
        "Bhk": agreement?["Bhk"] ?? "",
        "floor": agreement?["floor"] ?? "",
        "rented_address": agreement?["rented_address"] ?? "",
        "monthly_rent": agreement?["monthly_rent"] ?? "",
        "securitys": agreement?["securitys"] ?? "",
        "installment_security_amount": agreement?["installment_security_amount"] ?? "",
        "meter": agreement?["meter"] ?? "",
        "custom_meter_unit": agreement?["custom_meter_unit"] ?? "",
        "shifting_date": agreement?["shifting_date"]?.toString() ?? "",
        "maintaince": agreement?["maintaince"] ?? "",
        "custom_maintenance_charge": agreement?["custom_maintenance_charge"] ?? "",
        "parking": agreement?["parking"] ?? "",
        "current_dates": DateTime.now().toIso8601String(),
        "Fieldwarkarname": agreement?["Fieldwarkarname"] ?? "",
        "Fieldwarkarnumber": agreement?["Fieldwarkarnumber"] ?? "",
        "property_id": agreement?["property_id"] ?? "",
        "agreement_type": agreement?["agreement_type"] ?? "",
        "furniture": agreement?["furniture"] ?? "",
        "agreement_price": agreement?["agreement_price"] ?? "",
        "notary_price": agreement?["notary_price"] ?? "",

      };

      fields.forEach((k, v) {
        if (v.trim().isNotEmpty) request.fields[k] = v.trim();
      });

      // ----------------------
      // FILE ATTACH FUNCTION
      // ----------------------
      Future<void> attachFile(String key, File? file) async {
        if (file == null) return;
        final mime = lookupMimeType(file.path) ?? "application/octet-stream";
        final parts = mime.split("/");
        request.files.add(await http.MultipartFile.fromPath(
          key,
          file.path,
          contentType: MediaType(parts[0], parts[1]),
        ));
      }

      // ----------------------
      // DOWNLOAD OLD DB IMAGES
      // ----------------------
      Future<File?> downloadIfNeeded(String? imgPath, String name) async {
        if (imgPath == null || imgPath.isEmpty) return null;

        final url =
            "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$imgPath";

        final response = await http.get(Uri.parse(url));
        if (response.statusCode != 200) return null;

        final dir = Directory.systemTemp;
        final file = File("${dir.path}/$name");
        return file.writeAsBytes(response.bodyBytes);
      }

      // ----------------------
      // REQUIRED DB IMAGES
      // ----------------------
      final ownerFront = await downloadIfNeeded(
          agreement?["owner_aadhar_front"], "owner_front.jpg");
      final ownerBack = await downloadIfNeeded(
          agreement?["owner_aadhar_back"], "owner_back.jpg");
      final tenantFront = await downloadIfNeeded(
          agreement?["tenant_aadhar_front"], "tenant_front.jpg");
      final tenantBack = await downloadIfNeeded(
          agreement?["tenant_aadhar_back"], "tenant_back.jpg");
      final tenantImg = await downloadIfNeeded(
          agreement?["tenant_image"], "tenant_img.jpg");

      // ----------------------
      // POLICE VERIFICATION MODE
      // ----------------------
      if (isPolice) {
        if (policeVerificationFile == null) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Upload Police Verification PDF")),
          );
          return;
        }

        // Only upload police verification PDF
        await attachFile("police_verification_pdf", policeVerificationFile);

        // Still upload Aadhar & tenant images from DB
        await attachFile("owner_aadhar_front", ownerFront);
        await attachFile("owner_aadhar_back", ownerBack);
        await attachFile("tenant_aadhar_front", tenantFront);
        await attachFile("tenant_aadhar_back", tenantBack);
        await attachFile("tenant_image", tenantImg);

      } else {
        // ----------------------
        // NORMAL AGREEMENT
        // ----------------------
        await attachFile("police_verification_pdf", policeVerificationFile);
        await attachFile("notry_img", notaryImageFile);
        await attachFile("agreement_pdf", pdfFile);

        // Attach DB images
        await attachFile("owner_aadhar_front", ownerFront);
        await attachFile("owner_aadhar_back", ownerBack);
        await attachFile("tenant_aadhar_front", tenantFront);
        await attachFile("tenant_aadhar_back", tenantBack);
        await attachFile("tenant_image", tenantImg);
      }

      // ----------------------
      // SEND REQUEST
      // ----------------------
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Submitted successfully!")),
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
    } finally {
      Navigator.pop(context);
    }
  }

  Future<void> _handleGeneratePdf() async {
    if (agreement == null) return;

    File file;

    final String type = (agreement!['agreement_type'] ?? '').toString().trim();

    setState(() => isLoading = true);

    try {
      // 🔹 Pick PDF generator based on type
      if (type == "Furnished Agreement") {
        file = await generateFurnishedAgreementPdf(agreement!);
      } else {
        file = await generateAgreementPdf(agreement!);
      }

      setState(() {
        pdfFile = file;
        pdfGenerated = true;
      });
    } catch (e) {
      debugPrint("PDF Generation Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate PDF: $e'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isPolice = agreement?["agreement_type"] == "Police Verification";
    return Scaffold(
      appBar: AppBar(
        title: Text('${agreement?["agreement_type"] ?? "Agreement"} Details'),
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
            // 🔹 First Horizontal Row (Owner / Tenant / Agreement / Field Worker)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  if (agreement!["agreement_type"] != "Police Verification")

                    _buildCard(
                    title: "Agreement Details",
                    children: [
                      _kv("BHK", agreement?["Bhk"] ?? ""),
                      _kv( "Floor", agreement?["Floor_"] ?? ""),
                      _kv("Rented Address", agreement?["rented_address"]),
                      _kv("Monthly Rent", agreement?["monthly_rent"] != null ? "₹${agreement?["monthly_rent"]}" : ""),
                      _kv("Security", agreement?["securitys"] != null ? "₹${agreement?["securitys"]}" : ""),
                      _kv("Installment Security", agreement?["installment_security_amount"] != null ? "₹${agreement?["installment_security_amount"]}" : ""),
                      _kv("Meter", agreement?["meter"]),
                      _kv("Custom Unit", agreement?["custom_meter_unit"]),
                      _kv("Maintenance", agreement?["maintaince"]),
                      _kv("Parking", agreement?["parking"]),
                      _kv("Shifting Date", _formatDate(agreement?["shifting_date"]) ?? ""),
                      _kv("Agreement Price", agreement?["agreement_price"] ?? 'Not Added'),
                      _kv("Notary Amount", agreement?["notary_price"] ?? 'Not Added'),
                      _furnitureList(agreement!['furniture']), // 👈 this line auto handles your furniture data

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

            if (agreement!["agreement_type"] == "Police Verification")
              _sectionCard(title: "Property Residential Address ", children: [
                _kv("Property Address", agreement!["rented_address"]),
              ]),

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
                  // Police Verification upload
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          final result = await FilePicker.platform.pickFiles(type: FileType.any);
                          if (result != null && result.files.single.path != null) {
                            setState(() {
                              policeVerificationFile = File(result.files.single.path!);
                            });
                          }
                        },
                        icon: const Icon(Icons.upload_sharp, color: Colors.white),
                        label: const Text(
                          "P. Verification",
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),

                  if (!isPolice)
                  // Notary upload
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                            ),
                            builder: (context) {
                              return SizedBox(
                                height: 140,
                                child: Column(
                                  children: [
                                    const SizedBox(height: 10),
                                    const Text("Select Image",
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                                    const SizedBox(height: 10),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        TextButton.icon(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final picked = await ImagePicker().pickImage(
                                              source: ImageSource.camera,
                                              imageQuality: 90,
                                            );
                                            if (picked != null) {
                                              File f = File(picked.path);
                                              f = await compressImageTo150KB(f);
                                              setState(() => notaryImageFile = f);
                                            }
                                          },
                                          icon: const Icon(Icons.camera_alt, size: 28),
                                          label: const Text("Camera"),
                                        ),
                                        TextButton.icon(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            final picked = await ImagePicker().pickImage(
                                              source: ImageSource.gallery,
                                              imageQuality: 90,
                                            );
                                            if (picked != null) {
                                              File f = File(picked.path);
                                              f = await compressImageTo150KB(f);
                                              setState(() => notaryImageFile = f);
                                            }
                                          },
                                          icon: const Icon(Icons.photo, size: 28),
                                          label: const Text("Gallery"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.upload_sharp, color: Colors.white),
                        label: const Text("Notary",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 30),
            if (policeVerificationFile != null)
              _glassContainer(
                child: ListTile(
                  leading: const Icon(Icons.picture_as_pdf, color: Colors.orange),
                  title: Text(policeVerificationFile!.path.split('/').last),
                  subtitle: const Text("Police Verification File"),
                  onTap: () async {
                    await OpenFilex.open(policeVerificationFile!.path);
                  },
                ),
              ),
            const SizedBox(height: 20),



// Notary Image Preview
            if (!isPolice && notaryImageFile != null)
              _glassContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        notaryImageFile!,
                        height: 160,
                        width: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 8),if (isCompressing)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircularProgressIndicator(),
                        ),
                      ),

                    if (!isCompressing && compressedSizeText.isNotEmpty)
                      Center(
                        child: Text(
                          compressedSizeText,
                          style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.green),
                        ),
                      ),


                    const Text("Notary Image",
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
              ),

            const SizedBox(height: 20),

            if (!isPolice && pdfFile != null)
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

            if (!isPolice)
              GenerateAgreementButton(onGenerate: _handleGeneratePdf),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              width: double.infinity,
              child: ElevatedButton.icon(

                onPressed: isPolice ? _submitAll : (pdfGenerated ? _submitAll : null),

                icon: const Icon(Icons.check, color: Colors.white),
                label: const Text(
                  "Done",
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isPolice ? Colors.green : (pdfGenerated ? Colors.green : Colors.grey),
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


  Widget? propertyCard;


  Future<void> fetchPropertyCard() async {
    final propertyId = agreement?["property_id"];
    if (propertyId == null || propertyId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter Property ID first")),
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final String imageUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data['property_photo'] ?? ''}";

    Color textPrimary = isDark ? Colors.white : Colors.black87;
    Color textSecondary = isDark ? Colors.grey[400]! : Colors.grey[700]!;
    Color cardColor = isDark ? Colors.grey[900]! : Colors.white;
    Color shadowColor = isDark ? Colors.black.withOpacity(0.3) : Colors.grey.withOpacity(0.2);

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 8,
      margin: const EdgeInsets.only(bottom: 20),
      shadowColor: shadowColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🖼️ Property Image
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
                  color: isDark ? Colors.grey[800] : Colors.grey[200],
                  alignment: Alignment.center,
                  child: Text(
                    "No Image",
                    style: TextStyle(color: textSecondary),
                  ),
                );
              },
            ),
          ),

          // 📋 Property Details
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 💰 Price + BHK + Floor
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "₹${data['show_Price'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.greenAccent.shade200 : Colors.green,
                      ),
                    ),
                    Text(
                      data['Bhk'] ?? "",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textPrimary,
                      ),
                    ),
                    Text(
                      data['Floor_'] ?? "--",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 🧑 Name + 📍 Location
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Name: ${data['field_warkar_name'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      "Location: ${data['locations'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // ⚡ Meter + 🚗 Parking
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Meter: ${data['meter'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      "Parking: ${data['parking'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 15,
                        color: textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // 🛠️ Maintenance + ID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Maintenance: ${data['maintance'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 15,
                        color: textSecondary,
                      ),
                    ),
                    Text(
                      "ID: ${data['property_id'] ?? "--"}",
                      style: TextStyle(
                        fontSize: 15,
                        color: textSecondary,
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

class GenerateAgreementButton extends StatefulWidget {
  final Future<void> Function() onGenerate;

  const GenerateAgreementButton({super.key, required this.onGenerate});

  @override
  State<GenerateAgreementButton> createState() => _GenerateAgreementButtonState();
}

class _GenerateAgreementButtonState extends State<GenerateAgreementButton> {
  bool _isLoading = false;
  int _countdown = 0;
  Timer? _timer;

  Future<void> _startCountdown() async {
    setState(() {
      _isLoading = true;
      _countdown = 5; // seconds (you can change this)
    });

    // Start countdown
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 0) {
        timer.cancel();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });

    // Execute your function
    await widget.onGenerate();

    // Stop loader after done
    _timer?.cancel();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : _startCountdown,
        icon: _isLoading
            ? const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 2,
          ),
        )
            : const Icon(Icons.picture_as_pdf, color: Colors.white),
        label: Text(
          _isLoading
              ? 'Generating ($_countdown s)...'
              : 'Generate Agreement',
          style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}