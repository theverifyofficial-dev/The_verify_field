import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PropertyDetailPage extends StatelessWidget {
  final dynamic data;

  const PropertyDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(data['Apartment_name'] ?? "Property Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔹 Property Image
            Image.network(
              "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data['property_photo']}",
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 240,
                color: Colors.grey.shade300,
                child: const Icon(Icons.image_not_supported, size: 50),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 🔹 Title + Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${data['Bhk']} • ${data['Typeofproperty']}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹${data['Rent']}",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Text(
                    data['locations'],
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 16),

                  // 🔹 Property Info Grid
                  _infoGrid(context),

                  const SizedBox(height: 16),

                  // 🔹 Owner / Caretaker
                  _sectionTitle("Contact"),
                  _keyValue("Owner", data['owner_name']),
                  _keyValue("Owner Number", data['owner_number']),
                  _keyValue("Caretaker", data['care_taker_name']),
                  _keyValue("Caretaker Number", data['care_taker_number']),

                  const SizedBox(height: 16),

                  // 🔹 Facilities
                  _sectionTitle("Facilities"),
                  Text(data['Facility'] ?? "—"),

                  const SizedBox(height: 24),

                  // 🔹 Actions
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final number = data['owner_number'];

                            if (number == null || number.toString().isEmpty || number == "null") {
                              _showSnack(context, "Owner contact number not available");
                              return;
                            }

                            _callNumber(number);
                          },                          icon: const Icon(Icons.call),
                          label: const Text("Call Owner"),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            final video = data['video_link'];

                            if (video == null || video.toString().isEmpty || video == "null") {
                              _showSnack(context, "Property video not available");
                              return;
                            }

                            _openVideo(video);
                          },
                          icon: const Icon(Icons.play_circle_outline),
                          label: const Text("Video"),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HELPERS =================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _keyValue(String key, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(key, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
          Expanded(
            flex: 5,
            child: Text(value ?? "—"),
          ),
        ],
      ),
    );
  }

  Widget _infoGrid(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _infoChip("Floor", data['Floor_']),
        _infoChip("Total Floor", data['Total_floor']),
        _infoChip("Area", "${data['squarefit']} sqft"),
        _infoChip("Parking", data['parking']),
        _infoChip("Furnishing", data['furnished_unfurnished']),
        _infoChip("Age", data['age_of_property']),
      ],
    );
  }

  Widget _infoChip(String label, String? value) {
    return Chip(
      label: Text("$label: ${value ?? '—'}"),
    );
  }

  void _callNumber(String? number) async {
    if (number == null) return;
    final uri = Uri.parse("tel:$number");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }


  void _openVideo(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
