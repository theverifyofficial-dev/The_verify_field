import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:verify_feild_worker/utilities/bug_founder_fuction.dart';
import '../constant.dart';
import '../property_preview.dart';
import 'package:shimmer/shimmer.dart';

class UpcomingPropertyImage {
  final int id;
  final String imagePath;
  final int subId;

  UpcomingPropertyImage({
    required this.id,
    required this.imagePath,
    required this.subId,
  });

  factory UpcomingPropertyImage.fromJson(Map<String, dynamic> json) {
    return UpcomingPropertyImage(
      id: int.tryParse(json['M_id'].toString()) ?? 0,
      imagePath: json['M_images'] ?? "",
      subId: int.tryParse(json['subid'].toString()) ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'M_id': id,
      'M_images': imagePath,
      'subid': subId,
    };
  }
}

class AdminUpcomingDetails extends StatefulWidget {
  final int id;
  const AdminUpcomingDetails({super.key, required this.id});

  @override
  State<AdminUpcomingDetails> createState() => _UpcomingDetailsPageState();
}

class _UpcomingDetailsPageState extends State<AdminUpcomingDetails> {
  Map<String, dynamic>? propertyData;
  bool isLoading = true;
  Future<List<UpcomingPropertyImage>>? _galleryFuture;

  @override
  void initState() {
    super.initState();
    fetchPropertyDetails();
    _galleryFuture = fetchUpcomingPropertyImages(widget.id);
  }

  Future<void> fetchPropertyDetails() async {
    final url = Uri.parse(
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_details_page.php?P_id=${widget.id}");

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded["status"] == "success" && decoded["data"].isNotEmpty) {
        setState(() {
          propertyData = decoded["data"][0];
          isLoading = false;
        });
      }
    } else {
      await BugLogger.log(
          apiLink: url.toString(),
          error: response.body.toString(),
          statusCode: response.statusCode,
      );
      throw Exception("Failed to load data");
    }
  }

  Future<List<UpcomingPropertyImage>> fetchUpcomingPropertyImages(int id) async {
    final url =
        'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_show_mumlitiple_image_api.php?subid=$id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);

      if (decoded['status'] == 'success' && decoded['data'] != null) {
        final List<dynamic> imagesList = decoded['data'];
        return imagesList
            .map((item) => UpcomingPropertyImage.fromJson(item))
            .toList();
      } else {
        throw Exception("Invalid response structure: missing 'data' key");
      }
    } else if (response.statusCode == 404) {
      return [];
    } else {
      await BugLogger.log(
          apiLink: url,
          error: response.body.toString(),
          statusCode: response.statusCode,
      );
      throw Exception('Server error with status code: ${response.statusCode}');
    }
  }

  Widget infoRow(BuildContext context, String label, String? value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value?.isNotEmpty == true ? value! : "N/A",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget sectionCard(BuildContext context, String title, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(top: 18),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.grey.shade900
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              )),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }


  Widget _buildImageShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: 6, // number of shimmer placeholders
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = propertyData!;
    final imageUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data['property_photo']}";

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        surfaceTintColor: Colors.black,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Row(
            children: [
              SizedBox(width: 3),
              Icon(
                PhosphorIcons.caret_left_bold,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),

            // Image Gallery
            FutureBuilder<List<UpcomingPropertyImage>>(
              future: _galleryFuture,
              builder: (context, gallerySnapshot) {
                if (gallerySnapshot.connectionState == ConnectionState.waiting) {
                  return _buildImageShimmer();
                } else if (gallerySnapshot.hasError) {
                  return const Center(child: Text("Error loading gallery"));
                } else if (!gallerySnapshot.hasData ||
                    gallerySnapshot.data!.isEmpty) {
                  return const Center(child: Text("No images available"));
                } else {
                  final images = gallerySnapshot.data!;
                  final isDarkMode =
                      Theme.of(context).brightness == Brightness.dark;

                  return SizedBox(
                    height: 100,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final image = images[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PropertyPreview(
                                  ImageUrl:
                                  "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${image.imagePath}",
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              imageUrl:
                              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${image.imagePath}",
                              width: 120,
                              height: 100,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                width: 120,
                                height: 100,
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                child:
                                const Center(child: CircularProgressIndicator()),
                              ),
                              errorWidget: (context, url, error) => Container(
                                width: 120,
                                height: 100,
                                color: isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.grey[200],
                                child: Icon(
                                  Icons.broken_image,
                                  color: isDarkMode
                                      ? Colors.white
                                      : Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 12),

            Text(
              "${data['Bhk']} • ${data['Typeofproperty'] ?? 'Property'}",
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            Text(
              data['locations'] ?? "",
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            sectionCard(context, "Pricing", [
              infoRow(context, "Show Price", data['show_Price']),
              infoRow(context, "Asking Price", data['asking_price']),
              infoRow(context, "Last Price", data['Last_Price']),
            ]),

            sectionCard(context, "Property Information", [
              infoRow(context, "Flat Number", data['Flat_number']),
              infoRow(context, "Total Floor", data['Total_floor']),
              infoRow(context, "Balcony", data['Balcony']),
              infoRow(context, "Square Feet", data['squarefit']),
              infoRow(context, "Maintenance", data['maintance']),
              infoRow(context, "Parking", data['parking']),
              infoRow(context, "Age of Property", data['age_of_property']),
              infoRow(context, "Metro Distance", data['metro_distance']),
              infoRow(context, "Metro Distance", data['highway_distance']),
              infoRow(context, "Main Market Distance",
                  data['main_market_distance']),
              infoRow(context, "Facility", data['Facility']),
            ]),

            sectionCard(context, "Owner Details", [
              infoRow(context, "Owner Name", data['owner_name']),
              infoRow(context, "Owner Number", data['owner_number']),
              infoRow(context, "Care Taker Name", data['care_taker_name']),
              infoRow(context, "Care Taker Number", data['care_taker_number']),
            ]),

            sectionCard(context, "Field Worker", [
              infoRow(context, "Name", data['field_warkar_name']),
              infoRow(context, "Number", data['field_workar_number']),
              infoRow(context, "Address", data['fieldworkar_address']),
              infoRow(context, "Current Location",
                  data['field_worker_current_location']),
            ]),
          ],
        ),
      ),
    );
  }
}
