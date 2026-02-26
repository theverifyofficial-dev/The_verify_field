import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../Custom_Widget/property_preview.dart';
import 'InsuranceShowListPage.dart';
import 'UpdateInsuranceForm Screen.dart';

class InsuranceDetailScreen extends StatefulWidget {
  final int insuranceId;

  const InsuranceDetailScreen({
    super.key,
    required this.insuranceId,
  });

  @override
  State<InsuranceDetailScreen> createState() =>
      _InsuranceDetailScreenState();
}

class _InsuranceDetailScreenState extends State<InsuranceDetailScreen> {
  bool isLoading = true;
  InsuranceModel? insurance;

  @override
  void initState() {
    super.initState();
    fetchDetails();
    fetchMultipleImages();
  }
  String insuranceBaseUrl =
      "https://verifyserve.social/PHP_Files/"
      "insurance_insert_api/insurance_details/";

  List<String> multipleImages = [];

  Future<void> fetchMultipleImages() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/PHP_Files/"
              "insurance_insert_api/insurance_details/"
              "show_insurance_multiple_image.php?subid=${widget.insuranceId}"));

      final decoded = jsonDecode(response.body);
      // print(response.body);
      if (decoded['success'] == true) {
        final List data = decoded['data'];

        multipleImages =
            data.map((e) => insuranceBaseUrl + e['car_images']).toList();
      }
    } catch (e) {
      debugPrint("Multiple Image Error: $e");
    }

    if (mounted) setState(() {});
  }

  Future<void> fetchDetails() async {
    try {
      final response = await http.get(Uri.parse(
          "https://verifyserve.social/PHP_Files/"
              "insurance_insert_api/insurance_details/"
              "show_api_for_details_page.php?id=${widget.insuranceId}"));

      final decoded = jsonDecode(response.body);

      if (decoded['status'] == "success") {
        insurance = InsuranceModel.fromJson(decoded['data'][0]);
      }
    } catch (e) {
      debugPrint("Detail Error: $e");
    }

    if (mounted) setState(() => isLoading = false);
  }

  Future<void> _refreshPage() async {
    setState(() {
      isLoading = true;
    });

    await Future.wait([
      fetchDetails(),
      fetchMultipleImages(),
    ]);

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (insurance == null) {
      return const Scaffold(
        body: Center(child: Text("No Data Found")),
      );
    }

    final item = insurance!;

    return Scaffold(
      backgroundColor:
      isDark ? const Color(0xFF020617) : Colors.grey.shade100,

      body: RefreshIndicator(
        onRefresh: _refreshPage,
        child: CustomScrollView(
          slivers: [

            /// ✅ HERO HEADER
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              automaticallyImplyLeading: false,
              backgroundColor: Colors.black,

              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [

                    /// IMAGE
                    item.carPhotoUrl != null
                        ? Image.network(
                      item.carPhotoUrl!,
                      fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.image),)

                        : Container(
                      color: Colors.black,
                      child: const Icon(
                        Icons.directions_car_rounded,
                        size: 90,
                        color: Colors.white24,
                      ),
                    ),

                    /// GRADIENT OVERLAY
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),

                    /// TOP BUTTONS
                    Positioned(
                      top: 50,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          _circleButton(Icons.arrow_back_ios_new, () {
                            Navigator.pop(context);
                          }),

                          _circleButton(Icons.more_horiz_rounded, () async {

                            final refreshed = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => UpdateInsuranceFormScreen(
                                  item: item,
                                ),
                              ),
                            );

                            if (refreshed == true) {
                              _refreshPage();
                            }

                          }),
                        ],
                      ),
                    ),

                    /// TITLE
                    Positioned(
                      bottom: 30,
                      left: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            item.name ?? "",
                            style: const TextStyle(
                              fontSize: 26,
                              fontFamily: "PoppinsBold",
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            item.vehicleNumber ?? "",
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: "PoppinsMedium",
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ✅ CONTENT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// ✅ FLOATING RENEWAL CARD
                    // Transform.translate(
                    //   offset: const Offset(0, -40),
                    //   child: _renewalGlassCard(item),
                    // ),
                    const SizedBox(height: 8),

                    /// ✅ CUSTOMER CARD
                    /// ✅ CUSTOMER CARD
                    _premiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Customer Profile"),
                          const SizedBox(height: 12),

                          _infoRow("Name", item.name),
                          _infoRow("Phone", item.number),
                          _infoRow("Email", item.emailId),

                          const SizedBox(height: 10),

                          _infoRow("Claim Status", item.claim),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    /// ✅ VEHICLE CARD
                    _premiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Vehicle Details"),
                          const SizedBox(height: 12),

                          _infoRow("Vehicle No", item.vehicleNumber),
                          _infoRow("Type", item.vehicleType),

                          const SizedBox(height: 10),

                          _infoRow("Expiry Date", _formatDate(item.expiryDate)),
                          _infoRow("Pollution", item.pollutionYesNo),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    _premiumCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _sectionTitle("Nominee Details"),
                          const SizedBox(height: 12),

                          _infoRow("Nominee Name", item.nomineeName),
                          _infoRow("Relation", item.nomineeRelation),
                          _infoRow("Age", item.nomineeAge),
                        ],
                      ),
                    ),




                    /// ✅ DOCUMENTS
                    _sectionTitle("Documents"),
                    const SizedBox(height: 10),

                    _documentsGrid(item),
                    if (multipleImages.isNotEmpty) ...[
                      const SizedBox(height: 16),

                      _sectionTitle("Car Gallery"),

                      const SizedBox(height: 10),

                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: multipleImages.length,
                          itemBuilder: (context, index) {

                            final imageUrl = multipleImages[index];

                            return GestureDetector(

                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PropertyPreview(
                                      ImageUrl: imageUrl,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.only(right: 12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.network(
                                    imageUrl,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,

                                    loadingBuilder: (_, child, progress) {
                                      if (progress == null) return child;

                                      return const SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: Center(
                                          child: SizedBox(
                                            height: 18,
                                            width: 18,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          ),
                                        ),
                                      );
                                    },

                                    errorBuilder: (_, __, ___) =>
                                    const Icon(Icons.broken_image, color: Colors.red),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  String _formatDate(String? date) {
    if (date == null || date.isEmpty) return "-";

    try {
      final parsed = DateFormat("dd-MM-yyyy").parse(date);
      return DateFormat("dd MMM yyyy").format(parsed);
    } catch (e) {
      return date; // fallback
    }
  }
  /// ✅ RENEWAL CARD
  Widget _renewalGlassCard(InsuranceModel item) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF4F46E5),
            Color(0xFF3B82F6),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.35),
            blurRadius: 18,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Row(
        children: [

          const Icon(Icons.event_available, color: Colors.white),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Upcoming Renewal",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),

                Text(
                  item.nextRenewDate ?? "No Renewal Date",
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: "PoppinsBold",
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.2),
            ),
            child: const Text(
              "ACTIVE",
              style: TextStyle(
                fontSize: 11,
                fontFamily: "PoppinsBold",
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _premiumCard({required Widget child}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: isDark ? Colors.white10 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: child,
    );
  }
  Widget _infoRow(String label, String? value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [

          Text(
            "$label : ",
            style: TextStyle(
              fontSize: 12,
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white54 : Colors.grey,
            ),
          ),

          Expanded(
            child: Text(
              value == null || value.isEmpty ? "-" : value,
              style: TextStyle(
                fontSize: 13,
                fontFamily: "PoppinsMedium",
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          )
        ],
      ),
    );
  }
  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.black.withOpacity(0.35),
          border: Border.all(color: Colors.white24),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
  /// ✅ SECTION TITLE
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontFamily: "PoppinsBold",
        ),
      ),
    );
  }

  /// ✅ DOCUMENT GRID
  Widget _documentsGrid(InsuranceModel item) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        _docCard("Aadhaar Front", item.aadharFrontUrl),
        _docCard("Aadhaar Back", item.aadharBackUrl),
        _docCard("RC Front", item.rcFrontUrl),
        _docCard("RC Back", item.rcBackUrl),
        _docCard("Old Policy", item.oldPolicyUrl),
        _docCard("Pollution Certificate", item.pollutionPhotoUrl),
      ],
    );
  }
  
  Widget _docCard(String title, String? imageUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => PropertyPreview(
              ImageUrl: "${imageUrl}",
            ),
          ),
        );
      },

      child: Container(
        width: 110,
        height: 110,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white10,
        ),
        child: Column(
          children: [
            Expanded(
              child: imageUrl != null
                  ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,

                  /// ✅ SMALL LOADER
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;

                    return const Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 4,
                          color: Colors.blue,
                        ),
                      ),
                    );
                  },

                  /// ✅ ERROR STATE
                  errorBuilder: (_, __, ___) =>
                      Icon(Icons.image_rounded, color:Theme.of(context).brightness==Brightness.dark?Colors.white:Colors.grey,size: 20,
                      ),
                ),

              )
                  : const Icon(Icons.insert_drive_file, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontFamily: "PoppinsMedium",
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }}