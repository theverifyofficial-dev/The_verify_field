import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class PropertyDetailPage extends StatelessWidget {
  final dynamic data;
  const PropertyDetailPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness== Brightness.dark;

    final bg = isDark ? const Color(0xFF0A0A0A) :  Colors.white;
    final surface = isDark ? const Color(0xFF171717) : Colors.white;
    final chipBg = isDark ? const Color(0xFF262626) : Colors.grey.shade100;
    final text = isDark ? Colors.white : Colors.black;
    final subText = isDark ? Colors.grey.shade400 : Colors.grey.shade700;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          Column(
            children: [
              /// ================= IMAGE HEADER =================
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/${data['property_photo']}",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                  ),

                  /// Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration:  BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Theme.of(context).brightness==Brightness.dark?
                            Colors.black45:Colors.white],
                        ),
                      ),
                    ),
                  ),

                  /// Back Button ONLY
                  Positioned(
                    top: 40,
                    left: 16,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(50),
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 42,
                        width: 42,
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness==Brightness.dark?
                          Colors.black45:Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child:
                         Icon(Icons.arrow_back, color: Theme.of(context).brightness==Brightness.dark?
                        Colors.white:Colors.black),
                      ),
                    ),
                  ),
                ],
              ),

              /// ================= CONTENT =================
              Expanded(
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.fromLTRB(16, 20, 16, 140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Title + Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${data['Bhk']} • ${data['Typeofproperty']}",
                                style: TextStyle(
                                  fontFamily: "PoppinsBold",
                                  fontSize: 22,
                                  color: text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      size: 14, color: Colors.grey),
                                  const SizedBox(width: 4),
                                  Text(
                                    data['locations'],
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      color: subText,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _rupee(data['Rent']),
                                style: const TextStyle(
                                  fontFamily: "PoppinsBold",
                                  fontSize: 22,
                                  color: Colors.green,
                                ),
                              ),
                              Text(
                                "Per Month",
                                style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontSize: 11,
                                  letterSpacing: 1,
                                  color: subText,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Property Chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chip("Floor", data['Floor_'], chipBg, text),
                          _chip("Total Floor", data['Total_floor'], chipBg, text),
                          _chip("Area", "${data['squarefit']} sqft", chipBg, text),
                          _chip("Parking", data['parking'], chipBg, text),
                          _chip("Furnishing", data['furnished_unfurnished'], chipBg, text),
                          _chip("Age", data['age_of_property'], chipBg, text),
                        ],
                      ),

                      _divider(isDark),

                      /// Contact
                      _section("Contact Details", text),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: isDark
                                  ? Colors.white10
                                  : Colors.grey.shade200),
                        ),
                        child: Column(
                          children: [
                            _kv("Owner", data['owner_name'], text, subText),
                            _kv("Contact", data['owner_number'], text, subText),
                            _divider(isDark),
                            _kv("Caretaker", data['care_taker_name'], text, subText),
                            _kv("Caretaker Num", data['care_taker_number'], text, subText),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Facilities
                      _section("Key Facilities", text),
                      Text(
                        data['Facility'] ?? "—",
                        style: TextStyle(
                          fontFamily: "Poppins",
                          color: subText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// ================= BOTTOM BAR =================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:
              const EdgeInsets.fromLTRB(16, 16, 16, 24),
              decoration: BoxDecoration(
                color: surface.withOpacity(0.95),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.white10
                        : Colors.grey.shade200,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => _call(data['owner_number']),
                      icon:  Icon(Icons.call,color: Colors.white),
                      label:  Text(
                        "Call Owner",
                        style: TextStyle(fontFamily: "PoppinsBold",
                        color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: text,
                        side: BorderSide(color: subText),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () => _open(data['video_link']),
                      icon: const Icon(Icons.play_circle),
                      label: const Text(
                        "Video",
                        style: TextStyle(fontFamily: "PoppinsBold"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= HELPERS =================

  String _rupee(dynamic v) =>
      "₹${NumberFormat('#,##,###', 'en_IN').format(int.tryParse(v.toString()) ?? 0)}";

  Widget _chip(String label, String value, Color bg, Color text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        "$label: $value",
        style: TextStyle(
          fontFamily: "PoppinsMedium",
          fontSize: 12,
          color: text,
        ),
      ),
    );
  }

  Widget _section(String t, Color c) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Text(
      t,
      style: TextStyle(
        fontFamily: "PoppinsBold",
        fontSize: 18,
        color: c,
      ),
    ),
  );

  Widget _kv(String k, String v, Color t, Color s) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(k,
            style: TextStyle(
                fontFamily: "Poppins",
                color: s,
                fontSize: 12)),
        Text(v,
            style: TextStyle(
                fontFamily: "PoppinsMedium",
                color: t)),
      ],
    ),
  );

  Widget _divider(bool dark) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 24),
    child: Container(
      height: 1,
      color: dark ? Colors.white10 : Colors.grey.shade200,
    ),
  );

  void _call(String? n) async {
    if (n == null || n.isEmpty) return;
    final uri = Uri.parse("tel:$n");
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  void _open(String? u) async {
    if (u == null || u.isEmpty) return;
    final uri = Uri.parse(u);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
