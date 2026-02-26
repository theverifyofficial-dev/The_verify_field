import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:url_launcher/url_launcher.dart';
import 'New_Update/Edit_commercial.dart';
import 'New_Update/Edit_commercial_images.dart';

class CommercialPropertyData {
  final int id;
  final String? listing_type;
  final String? property_type;
  final String? parking_faciltiy;
  final String? total_floor;
  final String location_;
  final String current_location;
  final String avaible_date;
  final String build_up_area;
  final String carpet_area;
  final String dimmensions_;
  final String height_;
  final String width_;
  final String price;
  final String Description;
  final String longitude;
  final String latitude;
  final String field_workar_name;
  final String field_workar_number;
  final List<String> amenites_;
  final String? image_;
  final List<String> images;

  CommercialPropertyData({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.listing_type,
    this.property_type,
    this.parking_faciltiy,
    this.total_floor,
    required this.location_,
    required this.current_location,
    required this.avaible_date,
    required this.build_up_area,
    required this.carpet_area,
    required this.dimmensions_,
    required this.height_,
    required this.width_,
    required this.price,
    required this.Description,
    required this.field_workar_name,
    required this.field_workar_number,
    required this.amenites_,
    this.image_,
    required this.images,
  });

  factory CommercialPropertyData.fromJson(Map<String, dynamic> json) {
    const baseUrl =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/";

    return CommercialPropertyData(
      id: json['id'],
      listing_type: json['listing_type'],
      property_type: json['property_type'],
      parking_faciltiy: json['parking_faciltiy'],
      total_floor: json['total_floor'],
      location_: json['location_'] ?? '',
      current_location: json['current_location'] ?? '',
      avaible_date: json['avaible_date'] ?? '',
      build_up_area: json['build_up_area'] ?? '',
      carpet_area: json['carpet_area'] ?? '',
      dimmensions_: json['dimmensions_'] ?? '',
      height_: json['height_'] ?? '',
      width_: json['width_'] ?? '',
      price: json['price'] ?? '',
      Description: json['Description'] ?? '',
      longitude: json['longitude'] ?? '',
      latitude: json['latitude'] ?? '',
      field_workar_name: json['field_workar_name'] ?? '',
      field_workar_number: json['field_workar_number'] ?? '',

      amenites_: json['amenites_'] == null
          ? []
          : json['amenites_'].toString().split(','),

      /// 🔥 SINGLE IMAGE FIX
      image_: json['image_'] != null && json['image_']
          .toString()
          .isNotEmpty
          ? (json['image_'].toString().startsWith("http")
          ? json['image_']
          : baseUrl + json['image_'])
          : null,
      images: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "listing_type": listing_type,
      "property_type": property_type,
      "parking_faciltiy": parking_faciltiy,
      "total_floor": total_floor,
      "location_": location_,
      "current_location": current_location,
      "avaible_date": avaible_date,
      "build_up_area": build_up_area,
      "carpet_area": carpet_area,
      "dimmensions_": dimmensions_,
      "height_": height_,
      "width_": width_,
      "price": price,
      "Description": Description,
      "longitude": longitude,
      "latitude": latitude,
      "field_workar_name": field_workar_name,
      "field_workar_number": field_workar_number,
      "amenites_": amenites_.join(","),
    };
  }

  /// copyWith to update multiple images later
  CommercialPropertyData copyWith({List<String>? images}) {
    return CommercialPropertyData(
      id: id,
      listing_type: listing_type,
      property_type: property_type,
      parking_faciltiy: parking_faciltiy,
      total_floor: total_floor,
      location_: location_,
      current_location: current_location,
      avaible_date: avaible_date,
      build_up_area: build_up_area,
      carpet_area: carpet_area,
      dimmensions_: dimmensions_,
      height_: height_,
      width_: width_,
      price: price,
      Description: Description,
      longitude: longitude,
      latitude: latitude,
      field_workar_name: field_workar_name,
      field_workar_number: field_workar_number,
      amenites_: amenites_,
      image_: image_,
      images: images ?? this.images,
    );
  }
}


class CommercialUnderProperty extends StatefulWidget {
  final CommercialPropertyData property;

  CommercialUnderProperty({required this.property});

  @override
  _CommercialUnderPropertyState createState() =>
      _CommercialUnderPropertyState();
}
class _CommercialUnderPropertyState extends State<CommercialUnderProperty> {
  List<String> images = [];

  late CommercialPropertyData property;
  bool isExpandedDesc = false;


  final String  baseUrl =
      "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/commercial_mulitple_image/";


  @override
  void initState() {
    super.initState();
    property = widget.property;   // ⭐ local state copy
    fetchMultipleImages(widget.property.id);
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

        setState(() {
          images = List<String>.from(imageUrls);
        });
      }
    }
  }

  Future<void> _refreshProperty() async {
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

          await fetchMultipleImages(updated.id);

          setState(() {});
        }
      }
    } catch (e) {
      _showSnack("$e");
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }


  String formatPrice(String price) {
    final p = double.tryParse(price) ?? 0;
    if (p >= 10000000) return "₹ ${(p / 10000000).toStringAsFixed(2)} Cr";
    if (p >= 100000) return "₹ ${(p / 100000).toStringAsFixed(2)} L";
    return "₹ $price";
  }

  openMap() async {
    final lat = property.latitude;
    final lng = property.longitude;
    final url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
    await launchUrl(Uri.parse(url));
  }

  openWhatsapp() async {
    final phone = property.field_workar_number;
    await launchUrl(Uri.parse("https://wa.me/$phone"));
  }

  String maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String first = number.substring(0, 3);
    String last = number.substring(number.length - 4);
    return "$first****$last";
  }
  
  /// ⭐ FIXED FULLSCREEN GALLERY
  openGallery(List<String> allImages, int index) {
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
                imageProvider: NetworkImage(allImages[i]), // ⭐ fix
              );
            },
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final bool isDarkMode =
        Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDarkMode ? Colors.black : Colors.white;
    final cardColor = isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;
    final horizontalPadding =
    isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding =
    isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight =
        screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight =
        screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale =
    isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);

    final p = property;

    final allImages = [
      if (p.image_ != null && p.image_!.isNotEmpty) p.image_!,
      ...images,
    ];
    Widget buildResponsiveInfoGrid(
        List<Widget> infoRows) {
      return LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          if (screenWidth > 350) {
            final half = (infoRows.length / 2).ceil();
            final leftColumn = infoRows.sublist(0, half);
            final rightColumn =
            infoRows.length > half ? infoRows.sublist(half) : <Widget>[];
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: leftColumn,
                  ),
                ),
                SizedBox(
                    width:
                    MediaQuery.of(context).size.width < 360
                        ? 8.0
                        : 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: rightColumn,
                  ),
                ),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: infoRows,
            );
          }
        },
      );
    }

    Widget buildInfoRow(IconData icon, Color iconColor, String title,
        String value) {
      if (value.isEmpty || value == "null" || value == "0") {
        return const SizedBox.shrink();
      }

      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;

      final Color cardColor = Colors.white;
      final Color borderColor =
      isDarkMode ? Colors.grey.shade700.withOpacity(0.2) : Colors.grey.shade200;
      final Color titleColor =
      isDarkMode ? Colors.black87 : Colors.grey.shade700;
      final Color valueColor = isDarkMode ? Colors.black87 : Colors.black87;
      final Color iconBg = iconColor.withOpacity(0.10);

      return Container(
        margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
        padding: EdgeInsets.symmetric(
            horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor),
          boxShadow: isDarkMode
              ? [const BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))]
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 4.0 : 6.0),
              decoration: BoxDecoration(
                color: iconBg,
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
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 11.0,
                      fontWeight: FontWeight.w600,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 11.0 : 12.0,
                      fontWeight: FontWeight.w500,
                      color: valueColor,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    void showCallConfirmationDialog(
        String role, String name, String number) {
      bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

      showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Call $role',
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black)),
          content: Text(
              'Do you really want to call ${name.isNotEmpty ? name : role}?',
              style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black)),
          backgroundColor:
          isDarkMode ? Colors.grey[800] : Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No',
                  style: TextStyle(color: Colors.grey)),
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

    Widget buildContactCard(String role, String name, String number,
        {Color? bgColor}) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isSmallScreen = screenWidth < 360;
      final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
                      color: cardColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      role == "OWNER"
                          ? Icons.person
                          : role == "CARETAKER"
                          ? Icons.support_agent
                          : role == "FIELD WORKER"
                          ? Icons.engineering
                          : role == "TENANT"
                          ? Icons.people
                          : Icons.person,
                      color: Colors.white,
                      size: isSmallScreen ? 16.0 : 18.0,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 6.0 : 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          role,
                          style: TextStyle(
                            fontSize: isSmallScreen ? 10.0 : 11.0,
                            fontWeight: FontWeight.w600,
                            color: cardColor,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                        Text(
                          name.isNotEmpty ? name : "Not Available",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 13.0 : 14.0,
                            fontWeight: FontWeight.w500,
                            color: isDarkMode ? Colors.black : Colors.black87,
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 6.0 : 8.0),
              if (number.isNotEmpty)
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
                      border: Border.all(color: cardColor.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            maskedNumber,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18.0 : 18.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () => openWhatsapp(),
                              child: Icon(PhosphorIcons.whatsapp_logo_bold,
                                  color: Colors.green,
                                  size: isSmallScreen ? 20.0 : 24.0),
                            ),
                            SizedBox(
                                width: isSmallScreen ? 12.0 : 16.0),
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
                    child: Text(
                      "Not Available",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 11.0 : 12.0,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    Future<void> openMap() async {
      final lat = double.tryParse(property.latitude);
      final lng = double.tryParse(property.longitude);

      if (lat == null || lng == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid location")),
        );
        return;
      }

      final Uri mapUrl =
      Uri.parse("https://www.google.com/maps/search/?api=1&query=$lat,$lng");

      if (!await launchUrl(
        mapUrl,
        mode: LaunchMode.externalApplication,
      )) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Could not open map")),
        );
      }
    }

    Widget buildLocationCard(String currentLocation) {
      final mapUrlText =
          "https://maps.google.com/?q=${p.latitude},${p.longitude}";

      final lat = double.tryParse(p.latitude);
      final lng = double.tryParse(p.longitude);
      final bool hasMap = lat != null && lng != null && lat != 0 && lng != 0;

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
              offset: const Offset(0, 2),
            )
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
                  Text(
                    "CURRENT LOCATION",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // /// ⭐ LOCATION NAME
                  // Text(currentLocation,
                  //     style: const TextStyle(color: Colors.black87)),

                  const SizedBox(height: 3),

                  /// ⭐ URL LINK
                  GestureDetector(
                    onTap: openMap,
                    child: Text(
                      mapUrlText,
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.black,
                        decorationThickness: 2, // ⭐ better underline
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.link,
              size: 16,
              color: hasMap ? Colors.black : Colors.grey,
            )
          ],
        ),
      );
    }


    Widget buildDescriptionCard(String desc) {
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
            Row(
              children: [
                const Icon(Icons.description, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "DESCRIPTION",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// ⭐ DESCRIPTION TEXT
            Text(
              desc,
              maxLines: isExpandedDesc ? null : 2, // ⭐ IMPORTANT
              overflow: isExpandedDesc
                  ? TextOverflow.visible
                  : TextOverflow.ellipsis, // ⭐ IMPORTANT
              style: const TextStyle(color: Colors.black87),
            ),

            /// ⭐ READ MORE BUTTON
            if (desc.length > 80)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isExpandedDesc = !isExpandedDesc;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(
                    isExpandedDesc ? "Read less" : "Read more",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    }

    Widget buildAmenitiesCard(List<String> amenities) {
      if (amenities.isEmpty) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, // ⭐ ALWAYS WHITE
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  "AMENITIES",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // ⭐ FIX
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// ⭐ CHIPS
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: amenities
                  .map(
                    (e) => Chip(
                  label: Text(
                    e.trim(),
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),// ⭐ FIX
                  ),
                  backgroundColor: Colors.green.withOpacity(0.1), // ⭐ FIX
                  side: BorderSide(color: Colors.green.withOpacity(0.3)),
                ),
              )
                  .toList(),
            ),
          ],
        ),
      );
    }

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
            Row(
              children: [
                const Icon(Icons.contact_phone, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  "CONTACT",
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87, // ⭐ FIX
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            buildContactCard(
              "FIELD WORKER",
              property.field_workar_name,
              property.field_workar_number,
              bgColor: Colors.blue,
            ),
          ],
        ),
      );
    }

    Widget buildTwoColumnInfo(List<Widget> rows)  {
      final half = (rows.length / 2).ceil();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Column(children: rows.sublist(0, half))),
            const SizedBox(width: 10),
            Expanded(child: Column(children: rows.sublist(half))),
          ],
        ),
      );
    }

    final infoRows = [
      buildInfoRow(Icons.business, Colors.green, "Property Type", p.property_type ?? "-"),
      buildInfoRow(Icons.square_foot, Colors.teal, "Build Area", p.build_up_area),
      buildInfoRow(Icons.crop_square, Colors.indigo, "Carpet Area", p.carpet_area),
      buildInfoRow(Icons.straighten, Colors.brown, "Dimensions", p.dimmensions_),
      buildInfoRow(Icons.height, Colors.red, "Height", p.height_),
      buildInfoRow(Icons.width_full, Colors.deepPurple, "Width", p.width_),
      buildInfoRow(Icons.local_parking, Colors.pink, "Parking", p.parking_faciltiy ?? "-"),
      buildInfoRow(Icons.layers, Colors.green, "Floor", p.total_floor ?? "-"),
    ];

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshProperty,
        child:CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
            SliverToBoxAdapter(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ⭐ HEADER IMAGE WITH BUTTONS
              Stack(
                children: [
                  if (p.image_ != null && p.image_!.isNotEmpty)
                    GestureDetector(
                      onTap: () => openGallery([p.image_!], 0), // ⭐ FIX
                      child: CachedNetworkImage(
                        imageUrl: "${p.image_}?v=${DateTime.now().millisecondsSinceEpoch}",
                        height: 260,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorWidget: (_, __, ___) {
                          print("BROKEN HEADER IMAGE => ${p.image_}");
                          return Container(
                            height: 260,
                            color: Colors.grey,
                            child: Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                  /// back button
                  Positioned(
                    top: 40,
                    left: 10,
                    child: CircleAvatar(
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),

                  /// popup menu
                  Positioned(
                    top: MediaQuery.of(context).padding.top + (isSmallScreen ? 4.0 : 8.0),
                    right: horizontalPadding,
                    child: CircleAvatar(
                      radius: isSmallScreen ? 20 : 22,
                      backgroundColor: Colors.black.withOpacity(0.6),
                      child:
                      PopupMenuButton<String>(
                        splashRadius: 22,
                        offset: const Offset(0, 45),
                        onSelected: (value) async {
                          if (value == 'Edit Commercial') {
                            if (p != null) {

                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCommercialForm(
                                    propertyId: p.id,
                                    propertyData: p,
                                  ),
                                ),
                              );

                              if (result == true) {
                                await _refreshProperty();
                              }
                            }
                          }

                          if (value == 'Add Commercial Images') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditCommercialImage(
                                  sub_id: p.id.toString(),
                                ),
                              ),
                            ).then((value) async {
                              if (value == true) {
                                await _refreshProperty();
                              }
                            });
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(
                            value: 'Edit Commercial',
                            child: Text('Edit Commercial'),
                          ),
                          PopupMenuItem(
                            value: 'Add Commercial Images',
                            child: Text('Add Commercial Images'),
                          ),
                        ],
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                          size: isSmallScreen ? 22 : 26,
                        ),
                      ),

                    ),
                  ),

                  /// listing badge
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        p.listing_type ?? "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              /// ⭐ PRICE + LOCATION
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatPrice(p.price),
                        style:
                        TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(p.location_, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

              /// ⭐ MULTIPLE IMAGE GALLERY
              if (images.isEmpty)
              Text("No Images Found")
                  else
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: images.length,
                    itemBuilder: (context, i) {
                      return GestureDetector(
                        onTap: () => openGallery(allImages, i + (p.image_ != null ? 1 : 0)),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: CachedNetworkImage(
                            imageUrl: "${images[i]}?v=${DateTime.now().millisecondsSinceEpoch}",
                            width: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10),

              /// ⭐ 2 COLUMN INFO
              buildTwoColumnInfo(infoRows),

              /// ⭐ DESCRIPTION
              buildDescriptionCard(p.Description),

              /// ⭐ AMENITIES
              buildAmenitiesCard(p.amenites_),

              ///LOCATION
              buildLocationCard(p.current_location),

              /// ⭐ CONTACT
              buildContactSection(),
            ],
          ),
        ),
      ]),
      ),
    );
  }


  Widget info(String t, String v) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$t : ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(v)),
        ],
      ),
    );
  }
}
