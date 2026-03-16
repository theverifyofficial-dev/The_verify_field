import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Controller/Commercial_controller.dart';

class Administater_CommercialUnderProperty extends StatefulWidget {
  final CommercialPropertyData property;

  Administater_CommercialUnderProperty({required this.property});

  @override
  Administater_CommercialUnderPropertyState createState() =>
      Administater_CommercialUnderPropertyState();
}
class Administater_CommercialUnderPropertyState extends State<Administater_CommercialUnderProperty> {
  List<String> images = [];
  late CommercialPropertyData property;
  bool isExpandedDesc = false;

  @override
  void initState() {
    super.initState();
    property = widget.property;
    // id null check ke saath call karo
    if (property.id != null) {
      fetchMultipleImages(property.id!);
    }
  }

  Future<void> fetchMultipleImages(int id) async {
    final url =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_commercial_multiple_image.php?sub_id=$id&t=${DateTime.now().millisecondsSinceEpoch}";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      if (data['success'] == true && data['data'] != null) {
        List imgs = data['data'];
        const baseUrl =
            "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/";

        List<String> imageUrls = [];
        for (var item in imgs) {
          if (item['img'] != null && item['img'].toString().isNotEmpty) {
            imageUrls.add(baseUrl + item['img']);
          }
        }

        if (mounted) {
          setState(() {
            images = List<String>.from(imageUrls);
          });
        }
      }
    }
  }

  Future<void> _refreshProperty() async {
    if (property.id == null) return;
    try {
      var uri = Uri.parse(
          "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/get_single_commercial.php?id=${property.id}&t=${DateTime.now().millisecondsSinceEpoch}");

      var response = await http.get(uri);

      if (response.statusCode == 200) {
        var res = jsonDecode(response.body);

        if (res["status"] == "success") {
          final updated = CommercialPropertyData.fromJson(res["data"]);

          setState(() {
            property = updated;
            images = [];
          });

          if (updated.id != null) {
            await fetchMultipleImages(updated.id!);
          }
        }
      }
    } catch (e) {
      _showSnack("$e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  // ===================== HELPERS =====================

  String formatPrice(String? price) {
    if (price == null || price.isEmpty) return "Price N/A";
    final p = double.tryParse(price) ?? 0;
    if (p >= 10000000) return "₹ ${(p / 10000000).toStringAsFixed(2)} Cr";
    if (p >= 100000) return "₹ ${(p / 100000).toStringAsFixed(2)} L";
    return "₹ $price";
  }

  Future<void> openMap() async {
    final lat = double.tryParse(property.latitude ?? '');
    final lng = double.tryParse(property.longitude ?? '');

    if (lat == null || lng == null) {
      _showSnack("Invalid location");
      return;
    }

    final Uri mapUrl =
    Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

    if (!await launchUrl(mapUrl, mode: LaunchMode.externalApplication)) {
      _showSnack("Could not open map");
    }
  }

  Future<void> openWhatsapp() async {
    final phone = property.field_workar_number ?? '';
    if (phone.isEmpty) return;
    await launchUrl(Uri.parse("https://wa.me/$phone"));
  }

  String maskPhoneNumber(String? number) {
    if (number == null || number.length < 10) return number ?? '';
    return "${number.substring(0, 3)}****${number.substring(number.length - 4)}";
  }

  void openGallery(List<String> allImages, int index) {
    if (allImages.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: PhotoViewGallery.builder(
            itemCount: allImages.length,
            pageController: PageController(initialPage: index),
            builder: (context, i) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(allImages[i]),
              );
            },
          ),
        ),
      ),
    );
  }

  // ===================== BUILD =====================

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final p = property;

    // Build all images list
    final allImages = [
      if (p.image_ != null && p.image_!.isNotEmpty) p.image_!,
      ...images,
    ];

    // ===================== INFO ROW WIDGET =====================
    Widget buildInfoRow(
        IconData icon, Color iconColor, String title, String? value) {
      final v = value ?? '';
      if (v.isEmpty || v == "null" || v == "0") return const SizedBox.shrink();

      return Container(
        margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
        padding: EdgeInsets.symmetric(
            horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.10),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon,
                  size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
            ),
            SizedBox(width: isSmallScreen ? 6.0 : 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: isSmallScreen ? 10.0 : 11.0,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700)),
                  SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                  Text(v,
                      style: TextStyle(
                          fontSize: isSmallScreen ? 11.0 : 12.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87),
                      softWrap: true),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // ===================== TWO COLUMN INFO =====================
    Widget buildTwoColumnInfo(List<Widget> rows) {
      final half = (rows.length / 2).ceil();
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Column(children: rows.sublist(0, half))),
            const SizedBox(width: 10),
            Expanded(
                child: Column(
                    children: rows.length > half
                        ? rows.sublist(half)
                        : [])),
          ],
        ),
      );
    }

    // ===================== CONTACT CARD =====================
    void showCallConfirmationDialog(
        String role, String? name, String? number) {
      if (number == null || number.isEmpty) return;
      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Call $role',
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black)),
          content: Text(
              'Do you really want to call ${(name ?? '').isNotEmpty ? name : role}?',
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black)),
          backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
                await FlutterPhoneDirectCaller.callNumber(number);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }

    Widget buildContactCard(String role, String? name, String? number,
        {Color? bgColor}) {
      Color cardColor = bgColor ?? Colors.blue;
      String maskedNumber = maskPhoneNumber(number);

      return Container(
        margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: cardColor.withOpacity(0.3)),
        ),
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: isSmallScreen ? 32.0 : 36.0,
                    height: isSmallScreen ? 32.0 : 36.0,
                    decoration: BoxDecoration(
                        color: cardColor, shape: BoxShape.circle),
                    child: Icon(Icons.engineering,
                        color: Colors.white,
                        size: isSmallScreen ? 16.0 : 18.0),
                  ),
                  SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(role,
                            style: TextStyle(
                                fontSize: isSmallScreen ? 10.0 : 11.0,
                                fontWeight: FontWeight.w600,
                                color: cardColor)),
                        SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                        Text(
                          (name ?? '').isNotEmpty ? name! : "Not Available",
                          style: TextStyle(
                              fontSize: isSmallScreen ? 13.0 : 14.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 6.0 : 8.0),
              if ((number ?? '').isNotEmpty)
                GestureDetector(
                  onTap: () =>
                      showCallConfirmationDialog(role, name, number),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: isSmallScreen ? 6.0 : 8.0),
                    decoration: BoxDecoration(
                      color: cardColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                      border:
                      Border.all(color: cardColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(maskedNumber,
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: openWhatsapp,
                              child: Icon(PhosphorIcons.whatsapp_logo_bold,
                                  color: Colors.green,
                                  size: isSmallScreen ? 20.0 : 24.0),
                            ),
                            SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                            Icon(Icons.call,
                                color: cardColor,
                                size: isSmallScreen ? 20.0 : 24.0),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              else
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: isSmallScreen ? 6.0 : 8.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text("Not Available",
                        style: TextStyle(
                            fontSize: isSmallScreen ? 11.0 : 12.0,
                            color: Colors.grey)),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    // ===================== LOCATION CARD =====================
    Widget buildLocationCard() {
      final lat = property.latitude ?? '';
      final lng = property.longitude ?? '';
      final mapUrlText = "https://maps.google.com/?q=$lat,$lng";
      final latD = double.tryParse(lat);
      final lngD = double.tryParse(lng);
      final bool hasMap =
          latD != null && lngD != null && latD != 0 && lngD != 0;

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.orange.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.location_on, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("CURRENT LOCATION",
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 3),
                  GestureDetector(
                    onTap: openMap,
                    child: Text(
                      mapUrlText,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationThickness: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.link,
                size: 16, color: hasMap ? Colors.black : Colors.grey),
          ],
        ),
      );
    }

    // ===================== DESCRIPTION CARD =====================
    Widget buildDescriptionCard() {
      final desc = p.Description ?? '';
      if (desc.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.description, color: Colors.blue),
              const SizedBox(width: 8),
              Text("DESCRIPTION",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ]),
            const SizedBox(height: 10),
            Text(desc,
                maxLines: isExpandedDesc ? null : 2,
                overflow: isExpandedDesc
                    ? TextOverflow.visible
                    : TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.black87)),
            if (desc.length > 80)
              GestureDetector(
                onTap: () =>
                    setState(() => isExpandedDesc = !isExpandedDesc),
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    isExpandedDesc ? "Read less" : "Read more",
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    // ===================== AMENITIES CARD =====================
    Widget buildAmenitiesCard() {
      final amenities = p.amenites_;
      if (amenities.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.check_circle, color: Colors.green),
              const SizedBox(width: 8),
              Text("AMENITIES",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ]),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: amenities
                  .map((e) => Chip(
                label: Text(e.trim(),
                    style: TextStyle(
                        color:
                        isDarkMode ? Colors.white : Colors.black87)),
                backgroundColor: Colors.green.withOpacity(0.1),
                side:
                BorderSide(color: Colors.green.withOpacity(0.3)),
              ))
                  .toList(),
            ),
          ],
        ),
      );
    }

    // ===================== CONTACT SECTION =====================
    Widget buildContactSection() {
      return Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F5F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blue.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Icon(Icons.contact_phone, color: Colors.blue),
              const SizedBox(width: 8),
              Text("CONTACT",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
            ]),
            const SizedBox(height: 10),
            buildContactCard(
              "FIELD WORKER",
              p.field_workar_name,
              p.field_workar_number,
              bgColor: Colors.blue,
            ),
          ],
        ),
      );
    }

    // ===================== INFO ROWS =====================
    final infoRows = [
      buildInfoRow(Icons.business, Colors.green, "Property Type",
          p.property_type),
      buildInfoRow(
          Icons.square_foot, Colors.teal, "Build Area", p.build_up_area),
      buildInfoRow(
          Icons.crop_square, Colors.indigo, "Carpet Area", p.carpet_area),
      buildInfoRow(
          Icons.straighten, Colors.brown, "Dimensions", p.dimmensions_),
      buildInfoRow(Icons.height, Colors.red, "Height", p.height_),
      buildInfoRow(Icons.width_full, Colors.deepPurple, "Width", p.width_),
      buildInfoRow(
          Icons.local_parking, Colors.pink, "Parking", p.parking_faciltiy),
      buildInfoRow(Icons.layers, Colors.green, "Floor", p.total_floor),
    ];

    // ===================== MAIN SCAFFOLD =====================
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProperty,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HEADER IMAGE =====
                  Stack(
                    children: [
                      // No image placeholder
                      if (p.image_ == null || p.image_!.isEmpty)
                        Container(
                          height: 260,
                          width: double.infinity,
                          color: Colors.grey.shade300,
                          child: const Icon(Icons.storefront,
                              size: 80, color: Colors.grey),
                        )
                      else
                        GestureDetector(
                          onTap: () => openGallery(allImages, 0),
                          child: CachedNetworkImage(
                            imageUrl:
                            "${p.image_}?v=${DateTime.now().millisecondsSinceEpoch}",
                            height: 260,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              height: 260,
                              color: Colors.grey,
                              child:
                              const Icon(Icons.image_not_supported),
                            ),
                          ),
                        ),

                      // Back Button
                      Positioned(
                        top: MediaQuery.of(context).padding.top + 8,
                        left: 10,
                        child: CircleAvatar(
                          radius: isSmallScreen ? 20 : 22,
                          backgroundColor:
                          Colors.black.withOpacity(0.6),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(Icons.arrow_back,
                                color: Colors.white,
                                size: isSmallScreen ? 22 : 24),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),

                      // Listing Badge
                      if ((p.listing_type ?? '').isNotEmpty)
                        Positioned(
                          bottom: 10,
                          right: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(p.listing_type!,
                                style: const TextStyle(
                                    color: Colors.white)),
                          ),
                        ),
                    ],
                  ),

                  // ===== PRICE + LOCATION =====
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(formatPrice(p.price),
                            style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(
                          p.location_ ??
                              p.current_location ??
                              'No location',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  // ===== MULTIPLE IMAGE GALLERY =====
                  if (images.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text("No Additional Images",
                          style: TextStyle(color: Colors.grey)),
                    )
                  else
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: images.length,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: () => openGallery(
                                allImages,
                                i + (p.image_ != null ? 1 : 0)),
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: CachedNetworkImage(
                                imageUrl:
                                "${images[i]}?v=${DateTime.now().millisecondsSinceEpoch}",
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                  const SizedBox(height: 10),

                  // ===== INFO ROWS =====
                  buildTwoColumnInfo(infoRows),

                  // ===== DESCRIPTION =====
                  buildDescriptionCard(),

                  // ===== AMENITIES =====
                  buildAmenitiesCard(),

                  // ===== LOCATION =====
                  buildLocationCard(),

                  // ===== CONTACT =====
                  buildContactSection(),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}