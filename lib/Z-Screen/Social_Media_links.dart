import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../Custom_Widget/constant.dart';

class LinksPage extends StatelessWidget {
  const LinksPage({super.key});

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("Could not launch $url");
    }
  }

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
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Share $title links",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 16),
                ...links.map((link) {
                  return ListTile(
                    leading: const Icon(Icons.share, color: Colors.green),
                    title: Text(link["title"]!),
                    onTap: () async {
                      final url = link["url"]!;
                      final isMap = url.contains("google.com/maps");

                      final message = isMap
                          ? "📍 Here's our office location:\n${link["title"]}\n$url"
                          : "🏠 Check this property on Verify:\n${link["title"]}\n$url";

                      await Share.share(message, subject: "Verify Real Estate");
                    },
                  );
                }).toList(),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  label: const Text("Close"),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    backgroundColor: Colors.greenAccent.shade400,
                    foregroundColor: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLinkButton(BuildContext context, String title, dynamic urlOrList, Color baseColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Choose gradient based on base color family
    final gradient = _getGradient(baseColor);

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
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: baseColor.withOpacity(isDark ? 0.3 : 0.25),
              blurRadius: 10,
              offset: const Offset(0, 6),
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
                Shadow(color: Colors.black38, offset: Offset(1, 1), blurRadius: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  LinearGradient _getGradient(Color baseColor) {
    if (baseColor == Colors.green) {
      return const LinearGradient(colors: [Color(0xFF56ab2f), Color(0xFFA8E063)]);
    } else if (baseColor == Colors.yellow) {
      return const LinearGradient(colors: [Color(0xFFFFD200), Color(0xFFFFA751)]);
    } else if (baseColor == Colors.red) {
      return const LinearGradient(colors: [Color(0xFFf85032), Color(0xFFe73827)]);
    } else if (baseColor == Colors.blue) {
      return const LinearGradient(colors: [Color(0xFF00c6ff), Color(0xFF0072ff)]);
    } else if (baseColor == Colors.purple) {
      return const LinearGradient(colors: [Color(0xFF7F00FF), Color(0xFFE100FF)]);
    } else if (baseColor == Colors.tealAccent.shade700) {
      return const LinearGradient(colors: [Color(0xFF00b09b), Color(0xFF96c93d)]);
    } else {
      return LinearGradient(colors: [baseColor.withOpacity(0.9), baseColor.withOpacity(0.7)]);
    }
  }

  Widget _buildOfficeSection(BuildContext context) {
    const officeUrl =
        "https://www.google.com/maps/place/Verify+Real+estate+%26+Services/@28.494956,77.080037,12z/data=!4m6!3m5!1s0x6739f683b6b7f27f:0xf19a885eba1345b2!8m2!3d28.4949808!4d77.1624384!16s%2Fg%2F11mcn7n43x?entry=ttu";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(AppImages.realEstate,), // 🖼️ your office background image
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "💼 Our Office",
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Visit us at Sultanpur — tap below to open or share location.",
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await _launchUrl(officeUrl);
                },
                icon: const Icon(Icons.location_on_outlined),
                label: const Text("Open Location"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () async {
                  final message =
                      "📍 Here's our office location:\nVerify Real Estate & Services\n$officeUrl";
                  await Share.share(message, subject: "Verify Office Location");
                },
                icon: const Icon(Icons.share),
                label: const Text("Share"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ],
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
        "title": "🏷️ Buy",
        "url": [
          {"title": "1RK for Buy", "url": "https://theverify.in/1RK_flat_for_buy.html"},
          {"title": "1BHK for Buy", "url": "https://theverify.in/1BHK_flat_for_buy.html"},
          {"title": "2BHK for Buy", "url": "https://theverify.in/2BHK_flat_for_buy.html"},
          {"title": "3BHK for Buy", "url": "https://theverify.in/3BHK_flat_for_buy.html"},
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
        "url": "https://www.instagram.com/verify_realestate_/",
        "color": Colors.purple,
      },
      {
        "title": "📘 Facebook",
        "url":
        "https://www.facebook.com/people/Verify-Realestate-and-Services/61573465167534/",
        "color": Colors.blue,
      },
      {
        "title": "🐦 Twitter / X",
        "url": "https://x.com/swavenrealty",
        "color": Colors.grey,
      },
      {
        "title": "💼 LinkedIn",
        "url": "https://linkedin.com/in/",
        "color": Colors.tealAccent.shade700,
      },
    ];

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade100,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Image.asset(AppImages.verify, height: 75),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.only(left: 6),
            child: Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: 28),
          ),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            "Connecting You Everywhere 🌐",
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 13),
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
                  link["url"],
                  link["color"] as Color,
                );
              },
            ),
          ),

          _buildOfficeSection(context),

        ],
      ),
    );
  }
}
