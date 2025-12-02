import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MetaAdsDetailPage extends StatefulWidget {
  final String subId;

  const MetaAdsDetailPage({super.key, required this.subId});

  @override
  State<MetaAdsDetailPage> createState() => _MetaAdsDetailPageState();
}

class _MetaAdsDetailPageState extends State<MetaAdsDetailPage> {
  late Future<Map<String, dynamic>?> _futureAds;

  @override
  void initState() {
    super.initState();
    _futureAds = fetchMetaAds(widget.subId);
  }

  Future<Map<String, dynamic>?> fetchMetaAds(String subId) async {
    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_api_meta_ads.php?subid=$subId",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      if (decoded["success"] == true &&
          decoded["data"] is List &&
          decoded["data"].isNotEmpty) {
        return decoded["data"][0];
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Meta Ads Details"),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: FutureBuilder<Map<String, dynamic>?>(
        future: _futureAds,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text(
                "No Meta Ads Found",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            );
          }

          final ads = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _sectionHeader("Meta Ads Overview"),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _factChip(Icons.ads_click, "Platform: ${ads["platform"]}", Colors.blueAccent, isDark),
                    _factChip(Icons.money, "Cost: ₹${ads["cost"]}", Colors.greenAccent, isDark),
                    _factChip(Icons.timelapse, ads["duration"], Colors.purpleAccent, isDark),
                  ],
                ),

                const SizedBox(height: 20),
                _sectionHeader("Performance Metrics"),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _factChip(Icons.visibility, "Views: ${ads["views"]}", Colors.orange, isDark),
                    _factChip(Icons.person_add, "Leads: ${ads["leeds"]}", Colors.teal, isDark),
                    _factChip(Icons.stacked_line_chart, "Impressions: ${ads["impression"]}", Colors.indigo, isDark),
                    _factChip(Icons.touch_app, "Clicks: ${ads["clicks"]}", Colors.redAccent, isDark),
                  ],
                ),

                const SizedBox(height: 20),
                _sectionHeader("Location Targeting"),

                _infoTile("Area Targeted", ads["area"], Colors.blueGrey),

                const SizedBox(height: 20),
                _sectionHeader("Schedule"),

                _infoTile("Start", "${ads["start_date"]} | ${ads["start_time"]}", Colors.green),
                _infoTile("End", "${ads["end_date"]} | ${ads["end_time"]}", Colors.deepOrange),

                const SizedBox(height: 20),
                // _sectionHeader("Status"),

                // _infoTile("Current Status", ads["status"], Colors.purple),
              ],
            ),
          );
        },
      ),
    );
  }

  // ------------------------- UI Components -------------------------

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontFamily: "PoppinsBold",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _factChip(IconData icon, String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoTile(String title, String value, Color color) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.timer, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
