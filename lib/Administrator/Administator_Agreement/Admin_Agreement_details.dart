import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../Custom_Widget/Custom_backbutton.dart';
import '../imagepreviewscreen.dart';
import 'Admin_dashboard.dart';

class AdminAgreementDetails extends StatefulWidget {
  final String agreementId;
  const AdminAgreementDetails({super.key, required this.agreementId});

  @override
  State<AdminAgreementDetails> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AdminAgreementDetails> {
  Map<String, dynamic>? agreement;
  bool isLoading = true;
  File? pdfFile; // store generated PDF

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
        if (decoded["status"] == "success" && decoded["count"] > 0) {
          setState(() {
            agreement = decoded["data"][0];
            isLoading = false;
          });

          fetchPropertyCard();
        }
      }
    } catch (e) {
      print("Error: $e");
      setState(() => isLoading = false);
    }
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



  Future<void> _updateAgreementStatus(String action) async {
    print("Updating agreement status: $action"); // debug
    try {
      final url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/shift_agreement.php");

      print("Sending POST request to $url with id=${widget.agreementId}");
      final response = await http.post(
        url,
        body: {
          "id": widget.agreementId,
          "action": action,
        },
      );

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("Decoded response: $decoded");

        if (decoded["success"] == true) {

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Agreement Accepted successfully"),
              duration: const Duration(seconds: 1),
            ),
          );

          // Wait 1 second, then navigate
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
                (route) => false,
          );

        }

        else {
          print("Action failed: ${decoded["message"]}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(decoded["message"] ?? "Failed to update"),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        print("Server error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server error, try again later"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Exception caught: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  Future<void> _updateAgreementStatusWithMessage(String action, String message) async {
    print("Updating agreement status with message: $action, message: $message");
    try {
      final url = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/shift_agreement.php"
      );

      print("Sending POST request to $url with id=${widget.agreementId} and message=$message");
      final response = await http.post(url, body: {
        "id": widget.agreementId,
        "action": action,
        "messages": message,
      });

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        print("Decoded response: $decoded");

        if (decoded["success"] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Agreement Rejected Successfully"),
              duration: const Duration(seconds: 1),
            ),
          );

          // Wait 1 second, then navigate
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminDashboard()),
                (route) => false,
          );
        } else {
          print("Action with message failed: ${decoded["message"]}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(decoded["message"] ?? "Failed to update"),
              duration: const Duration(seconds: 1),
            ),
          );
        }
      } else {
        print("Server error");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Server error, try again later"),
            duration: Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      print("Exception caught: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
          duration: const Duration(seconds: 1),
        ),
      );
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

  Widget _kv(String k, String? v) {
    if (v == null || v.trim().isEmpty) return const SizedBox.shrink();
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

  Widget _kvImage(String k, String? url) {
    if (url == null || url.trim().isEmpty) return const SizedBox.shrink();

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
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ImagePreviewScreen(
                      imageUrl:
                      'https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$url',
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
                    "https://verifyserve.social/Second%20PHP%20FILE/main_application/agreement/$url",
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
            )
          ),
        ],
      ),
    );
  }

  void _showRejectDialog() {
    TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Reject Agreement"),
          content: Column(
            mainAxisSize: MainAxisSize.min,

            children: [
              Text("Please enter a reason for rejection:"),
              const SizedBox(height: 12),
              TextField(
                controller: messageController,
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8), // square-ish
                  ),
                  hintText: "Enter your message",
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final message = messageController.text.trim();
                if (message.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Message cannot be empty")),
                  );
                  return;
                }

                Navigator.pop(context); // close dialog

                // Send reject action with message
                await _updateAgreementStatusWithMessage("reject", message);
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${agreement?["agreement_type"] ?? "Agreement"} Details',style: TextStyle(fontSize: 18),),
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

            if (propertyCard != null) propertyCard!,

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Owner Details
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _sectionCard(
                      title: "Owner Details",
                      children: [
                        _kv("Owner Name", agreement!["owner_name"]),
                        _kv("Relation", "${agreement!["owner_relation"]} ${agreement!["relation_person_name_owner"]}"),
                        _kv("Address", agreement!["parmanent_addresss_owner"]),
                        _kv("Mobile", agreement!["owner_mobile_no"]),
                        _kv("Aadhar", agreement!["owner_addhar_no"]),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Tenant / Director
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _sectionCard(
                      title: agreement!["agreement_type"] == "Commercial Agreement"
                          ? "Director Details"
                          : "Tenant Details",
                      children: [
                        _kv(
                          agreement!["agreement_type"] == "Commercial Agreement"
                              ? "Director Name"
                              : "Tenant Name",
                          agreement!["tenant_name"],
                        ),
                        _kv("Relation", "${agreement!["tenant_relation"]} ${agreement!["relation_person_name_tenant"]}"),
                        _kv("Address", agreement!["permanent_address_tenant"]),
                        _kv("Mobile", agreement!["tenant_mobile_no"]),
                        _kv("Aadhar", agreement!["tenant_addhar_no"]),

                        // Commercial-only fields
                        if (agreement!["agreement_type"] == "Commercial Agreement") ...[
                          const Divider(),
                          _kv("Company Name", agreement!["company_name"]),
                          _kv("GST Number", agreement!["gst_no"]),
                          _kv("PAN Number", agreement!["pan_no"]),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Agreement Details
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: _sectionCard(
                      title: "Agreement Details",
                      children: [
                        _kv("Property", agreement?["property_id"] ?? ""),
                        _kv("BHK", agreement?["Bhk"] ?? ""),
                        _kv("Floor", agreement?["floor"] ?? ""),
                        _kv("Rented Address", agreement!["rented_address"]),
                        _kv("Monthly Rent", "₹${agreement!["monthly_rent"]}"),
                        _kv("Security", "₹${agreement!["securitys"]}"),
                        _kv("Installment Security", "₹${agreement!["installment_security_amount"]}"),
                        _kv("Meter", agreement!["meter"]),
                        _kv("Custom Unit", agreement!["custom_meter_unit"] ?? ""),
                        _kv("Maintenance", agreement!["maintaince"]),
                        _kv("Parking", agreement!["parking"] ?? ""),
                        _kv("Shifting Date", agreement!["shifting_date"].toString().split("T")[0]),
                        _furnitureList(agreement!['furniture']), // 👈 this line auto handles your furniture data

                      ],
                    ),
                  ),
                ],
              ),
            ),


            // 🔹 Fieldworker
            _sectionCard(title: "Field Worker", children: [
              _kv("Name", agreement!["Fieldwarkarname"]),
              _kv("Number", agreement!["Fieldwarkarnumber"]),
            ]),

            _sectionCard(
              title: "Documents",
              children: [
                _kvImage("Owner Aadhaar Front", agreement!["owner_aadhar_front"]),
                _kvImage("Owner Aadhaar Back", agreement!["owner_aadhar_back"]),
                _kvImage("Tenant Aadhaar Front", agreement!["tenant_aadhar_front"]),
                _kvImage("Tenant Aadhaar Back", agreement!["tenant_aadhar_back"]),
                _kvImage("Tenant Photo", agreement!["tenant_image"]),

                if (agreement!["agreement_type"] == "Commercial Agreement") ...[
                  const Divider(),
                  _kvImage("GST Photo", agreement!["gst_photo"]),
                  _kvImage("PAN Photo", agreement!["pan_photo"]),
                ],
              ],
            ),

            const SizedBox(height: 30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () =>   _showRejectDialog(),

          icon: const Icon(Icons.close, color: Colors.white),
                    label: const Text("Reject", style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () => _updateAgreementStatus("Accept"),
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: const Text("Accept", style: TextStyle(color: Colors.white)),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
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
                        color: Colors.green,
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
