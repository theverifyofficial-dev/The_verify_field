import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constant.dart';

class LinksPage extends StatelessWidget {
  const LinksPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

  // 🆕 Function to show multiple link options in a bottom sheet
  void _showMultipleLinks(BuildContext context, String title, List<Map<String, String>> links) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Share $title links on WhatsApp",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ...links.map((link) {
                return ListTile(
                  leading: const Icon(Icons.share, color: Colors.green),
                  title: Text(link["title"]!),
                  onTap: () async {
                    final message =
                        "Check this property on Verify 🏠\n${link["title"]}: ${link["url"]}";
                    final encodedMessage = Uri.encodeComponent(message);
                    final whatsappUrl = "https://wa.me/?text=$encodedMessage";

                    final Uri uri = Uri.parse(whatsappUrl);
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri, mode: LaunchMode.externalApplication);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("WhatsApp not installed or cannot open link."),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text("Close"),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLinkButton(BuildContext context, String title, dynamic urlOrList, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        if (urlOrList is String) {
          _launchUrl(urlOrList);
        } else if (urlOrList is List<Map<String, String>>) {
          _showMultipleLinks(context, title, urlOrList);
        }
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [color.withOpacity(0.85), color.withOpacity(0.6)]
                : [color.withOpacity(0.9), color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(isDark ? 0.3 : 0.2),
              blurRadius: 8,
              offset: const Offset(2, 4),
            )
          ],
        ),
        child: Center(
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              shadows: [
                Shadow(
                  color: Colors.black26,
                  offset: Offset(1, 1),
                  blurRadius: 2,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final links = [
      {
        "title": "🏠 Rent",
        "url": [
          {"title": "1RK for Rent", "url": "https://theverify.in/1RK_flat_for_Rent.html"},
          {"title": "1BHK for Rent", "url": "https://theverify.in/1BHK_flat_for_Rent.html"},
          {"title": "2BHK for Rent", "url": "https://theverify.in/2BHK_flat_for_Rent.html"},
          {"title": "3BHK for Rent", "url": "https://theverify.in/3BHK_flat_for_Rent.html"},
        ],
        "color": Colors.green,
      },
      {
        "title": "🏷️ Sell",
        "url": [
          {"title": "1RK for Sell", "url": "https://theverify.in/1RK_flat_for_buy.html"},
          {"title": "1BHK for Sell", "url": "https://theverify.in/1BHK_flat_for_buy.html"},
          {"title": "2BHK for Sell", "url": "https://theverify.in/2BHK_flat_for_buy.html"},
          {"title": "3BHK for Sell", "url": "https://theverify.in/3BHK_flat_for_buy.html"},
        ],
        "color": Colors.yellow,
      },
      {
        "title": "🌐 Website",
        "url": "https://theverify.in",
        "color": Colors.blue,
      },
      {
        "title": "▶️ YouTube",
        "url": "https://www.youtube.com/@Verify_Real_Estate",
        "color": Colors.red,
      },
      {
        "title": "📸 Instagram",
        "url": "https://www.instagram.com/verify_realestate/",
        "color": Colors.purple,
      },
      {
        "title": "📘 Facebook",
        "url":
        "https://www.facebook.com/people/Verify-Realestate-and-Services/61573465167534/",
        "color": Colors.blue.shade800,
      },
      {
        "title": "🐦 Twitter / X",
        "url": "https://x.com/swavenrealty",
        "color": Colors.grey.shade700,
      },
      {
        "title": "💼 LinkedIn",
        "url": "https://linkedin.com/in/",
        "color": Colors.blue.shade700,
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        title: Text(
          "Our Links",
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset(AppImages.verify, height: 75),
          const SizedBox(height: 4),
          Text(
            "Connecting You Everywhere 🌐",
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: links.length,
              itemBuilder: (context, index) {
                final link = links[index];
                return _buildLinkButton(
                  context,
                  link["title"] as String,
                  link["url"], // can be String or List<Map>
                  link["color"] as Color,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
