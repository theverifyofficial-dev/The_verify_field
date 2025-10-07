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

  Widget _buildLinkButton(BuildContext context, String title, String url, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => _launchUrl(url),
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
            style: TextStyle(
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
        "title": "🌐 Website",
        "url": "https://theverify.in",
        "color": Colors.blue
      },
      {
        "title": "▶️ YouTube",
        "url": "https://www.youtube.com/@Verify_Real_Estate",
        "color": Colors.red
      },
      {
        "title": "📸 Instagram",
        "url": "https://www.instagram.com/verify_realestate/",
        "color": Colors.purple
      },
      {
        "title": "📘 Facebook",
        "url": "https://www.facebook.com/people/Verify-Realestate-and-Services/61573465167534/",
        "color": Colors.blue.shade800
      },
      {
        "title": "🐦 Twitter / X",
        "url": "https://x.com/swavenrealty",
        "color": Colors.grey.shade700
      },
      {
        "title": "💼 LinkedIn",
        "url": "https://linkedin.com/in/",
        "color": Colors.blue.shade700
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
                  link["url"] as String,
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
