import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

// ------------------ DATA MODEL ------------------
class CommercialPropertyData {
  final String? listingType;
  final String? propertyType;
  final String? parkingType;
  final String? warehouseType;
  final String? rentMeterType;
  final String? totalFloors;
  final String? lockInPeriod;
  final String location;
  final String availableFrom;
  final String builtupArea;
  final String carpetArea;
  final String sellingHeight;
  final String sellingWidth;
  final String rentPrice;
  final String security;
  final String rentIncome;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final List<String> amenities;
  final String? currentAddress;
  final double? latitude;
  final double? longitude;
  final XFile? singleImage;
  final List<XFile> selectedImages;

  CommercialPropertyData({
    this.listingType,
    this.propertyType,
    this.parkingType,
    this.warehouseType,
    this.rentMeterType,
    this.totalFloors,
    this.lockInPeriod,
    required this.location,
    required this.availableFrom,
    required this.builtupArea,
    required this.carpetArea,
    required this.sellingHeight,
    required this.sellingWidth,
    required this.rentPrice,
    required this.security,
    required this.rentIncome,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.amenities,
    this.currentAddress,
    this.latitude,
    this.longitude,
    this.singleImage,
    required this.selectedImages,
  });

  CommercialPropertyData copyWith({
    String? rentPrice,
    XFile? singleImage,
    List<XFile>? selectedImages,
  }) {
    return CommercialPropertyData(
      listingType: listingType,
      propertyType: propertyType,
      parkingType: parkingType,
      warehouseType: warehouseType,
      rentMeterType: rentMeterType,
      totalFloors: totalFloors,
      lockInPeriod: lockInPeriod,
      location: location,
      availableFrom: availableFrom,
      builtupArea: builtupArea,
      carpetArea: carpetArea,
      sellingHeight: sellingHeight,
      sellingWidth: sellingWidth,
      rentPrice: rentPrice ?? this.rentPrice,
      security: security,
      rentIncome: rentIncome,
      fieldWorkerName: fieldWorkerName,
      fieldWorkerNumber: fieldWorkerNumber,
      amenities: amenities,
      currentAddress: currentAddress,
      latitude: latitude,
      longitude: longitude,
      singleImage: singleImage ?? this.singleImage,
      selectedImages: selectedImages ?? this.selectedImages,
    );
  }

  Map<String, dynamic> toJson() => {
    'listingType': listingType,
    'propertyType': propertyType,
    'parkingType': parkingType,
    'warehouseType': warehouseType,
    'rentMeterType': rentMeterType,
    'totalFloors': totalFloors,
    'lockInPeriod': lockInPeriod,
    'location': location,
    'availableFrom': availableFrom,
    'builtupArea': builtupArea,
    'carpetArea': carpetArea,
    'sellingHeight': sellingHeight,
    'sellingWidth': sellingWidth,
    'rentPrice': rentPrice,
    'security': security,
    'rentIncome': rentIncome,
    'fieldWorkerName': fieldWorkerName,
    'fieldWorkerNumber': fieldWorkerNumber,
    'amenities': amenities,
    'currentAddress': currentAddress,
    'latitude': latitude,
    'longitude': longitude,
    'singleImagePath': singleImage?.path,
    'selectedImagesPaths': selectedImages.map((img) => img.path).toList(),
  };

  factory CommercialPropertyData.fromJson(Map<String, dynamic> json) {
    return CommercialPropertyData(
      listingType: json['listingType'],
      propertyType: json['propertyType'],
      parkingType: json['parkingType'],
      warehouseType: json['warehouseType'],
      rentMeterType: json['rentMeterType'],
      totalFloors: json['totalFloors'],
      lockInPeriod: json['lockInPeriod'],
      location: json['location'] ?? '',
      availableFrom: json['availableFrom'] ?? '',
      builtupArea: json['builtupArea'] ?? '',
      carpetArea: json['carpetArea'] ?? '',
      sellingHeight: json['sellingHeight'] ?? '',
      sellingWidth: json['sellingWidth'] ?? '',
      rentPrice: json['rentPrice'] ?? '',
      security: json['security'] ?? '',
      rentIncome: json['rentIncome'] ?? '',
      fieldWorkerName: json['fieldWorkerName'] ?? '',
      fieldWorkerNumber: json['fieldWorkerNumber'] ?? '',
      amenities: List<String>.from(json['amenities'] ?? []),
      currentAddress: json['currentAddress'],
      latitude: json['latitude'] is num ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] is num ? (json['longitude'] as num).toDouble() : null,
      singleImage: json['singleImagePath'] != null ? XFile(json['singleImagePath']) : null,
      selectedImages: (json['selectedImagesPaths'] as List<dynamic>?)
          ?.map((p) => XFile(p.toString()))
          .toList() ??
          [],
    );
  }
}

class CommercialImage {
  final String path;
  final String? url;

  CommercialImage({required this.path, this.url});
}

// ------------------ CONTROLLER ------------------
class CommercialUnderPropertyController extends GetxController {
  final String id;
  final String subid;
  final CommercialPropertyData initialData;

  CommercialUnderPropertyController({required this.id, required this.subid, required this.initialData});

  var isMainLoading = false.obs;
  var isUpcomingLoading = false.obs;
  var property = Rxn<CommercialPropertyData>();
  var estateStatus = 'Book'.obs;
  var upcomingStatus = 'Book'.obs;
  var isDataLoading = true.obs;

  // simplified: plain Future, not Rx<Future<...>>
  late Future<List<CommercialImage>> sliderFuture;

  @override
  void onInit() {
    super.onInit();
    property.value = initialData;
    // start fetching
    fetchAllData();
  }

  Future<void> fetchPropertyData() async {
    try {
      print('DEBUG: Fetching property for id: $id. Initial rent: "${initialData.rentPrice}"');
      final response = await http
          .get(Uri.parse('https://verifyserve.social/Second%20PHP%20FILE/main_realestate/get_commercial_property.php?id=$id'))
          .timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final propertyMap = data['property'] as Map<String, dynamic>? ?? {};
        property.value = CommercialPropertyData.fromJson(propertyMap);
        print('DEBUG: Fetched rent: "${property.value?.rentPrice}"');

        // Fix singleImage if not set
        if (property.value!.singleImage == null) {
          String? imagePath = propertyMap['image_'] as String?;
          if (imagePath != null && imagePath.isNotEmpty) {
            String fullUrl;
            if (imagePath.startsWith('http')) {
              fullUrl = imagePath;
            } else {
              fullUrl = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/' + imagePath.replaceAll(r'\/', '/');
            }
            final updated = property.value!.copyWith(singleImage: XFile(fullUrl));
            property.value = updated;
            print('DEBUG: Set singleImage from API: $fullUrl');
          }
        }
      } else {
        property.value = initialData;
        print('DEBUG: Fetch failed (${response.statusCode}), using initial data');
      }
    } on TimeoutException catch (e) {
      print('DEBUG: Fetch timeout: $e, using initial');
      property.value = initialData;
    } catch (e) {
      print('DEBUG: Fetch error: $e, using initial');
      property.value = initialData;
    }

    update();
  }

  Future<List<CommercialImage>> fetchCarouselData() async {
    List<CommercialImage> images = [];
    print('DEBUG: fetchCarouselData called. subid: $subid');
    if (subid.isNotEmpty) {
      try {
        final response = await http.get(Uri.parse(
            'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/display_commercial_multiple_image.php?sub_id=$subid'))
            .timeout(const Duration(seconds: 30));
        print('DEBUG: Remote status: ${response.statusCode}');
        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body)['data'] ?? [];
          const String baseUrl = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/';
          images = data.map((item) {
            String imgStr = item['img'] ?? '';
            // Handle escaped backslashes
            imgStr = imgStr.replaceAll(r'\/', '/');
            // Construct full URL
            String fullUrl = baseUrl + imgStr;
            return CommercialImage(path: imgStr, url: fullUrl);
          }).toList();
          print('DEBUG: Remote images: ${images.length}');
        }
      } catch (e) {
        print('DEBUG: Remote error: $e');
      }
    }
    // No local images added - handle single separately
    if (images.isEmpty) print('WARNING: No multiple images from API');
    return images;
  }

  List<XFile> _getLocalImages() {
    final imgs = <XFile>[];
    if (property.value?.singleImage != null) imgs.add(property.value!.singleImage!);
    imgs.addAll(property.value?.selectedImages ?? []);
    return imgs;
  }

  Future<void> fetchAllData() async {
    isDataLoading.value = true;
    try {
      // fetch property and then load images
      await fetchPropertyData();
      await loadImages();
    } finally {
      isDataLoading.value = false;
      update();
    }
  }

  Future<void> loadImages() async {
    // assign the future directly (no Rx)
    sliderFuture = fetchCarouselData();
  }

  Future<void> refreshData() async {
    await fetchAllData();
  }

  Future<void> pickTestImage() async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final updated = property.value!.copyWith(singleImage: image);
        property.value = updated;
        await loadImages();
        update();
        Get.snackbar('Success', 'Image added: ${image.name}');
        print('DEBUG: Test image added: ${image.path}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Pick failed: $e');
    }
  }

  Future<void> handleMenuItemClick(String value, BuildContext context) async {
    if (value == 'Reload Data') {
      await refreshData();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data reloaded!')));
    } else if (value == 'Add Images') {
      await pickTestImage();
    } else if (value == 'Edit Property') {
      // Handle edit
    }
  }

  Future<void> openWhatsApp(String number, BuildContext context) async {
    try {
      String cleanNumber = number.replaceAll(RegExp(r'[^0-9]'), '');
      if (!cleanNumber.startsWith('91')) cleanNumber = '91$cleanNumber';

      final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$cleanNumber");
      final Uri whatsappWebUri = Uri.parse("https://wa.me/$cleanNumber");

      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(whatsappWebUri)) {
        await launchUrl(whatsappWebUri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('WhatsApp not installed')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('WhatsApp error: $e')));
    }
  }

  void showCallConfirmationDialog(String role, String name, String number, BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call $role', style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        content: Text('Do you really want to call ${name.isNotEmpty ? name : role}?',
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: isDarkMode ? Colors.grey[800] : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: <Widget>[
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

  String maskPhoneNumber(String number) {
    if (number.length < 10) return number;
    String firstPart = number.substring(0, 3);
    String lastPart = number.substring(number.length - 4);
    return '$firstPart****$lastPart';
  }

  Widget buildInfoRow(IconData icon, Color iconColor, String title, String value, BuildContext context) {
    if (value.isEmpty || value == "null" || value == "0") return const SizedBox.shrink();

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    final Color cardColor = Colors.white;
    final Color borderColor = isDarkMode ? Colors.grey.shade700.withOpacity(0.2) : Colors.grey.shade200;
    final Color titleColor = isDarkMode ? Colors.black87 : Colors.grey.shade700;
    final Color valueColor = isDarkMode ? Colors.black87 : Colors.black87;
    final Color iconBg = iconColor.withOpacity(0.10);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: borderColor),
        boxShadow: isDarkMode ? [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))] : null,
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
            child: Icon(icon, size: isSmallScreen ? 16.0 : 18.0, color: iconColor),
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
                    fontWeight: FontWeight.w500,
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

  Widget buildContactCard(String role, String name, String number, {Color? bgColor, required BuildContext context}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    Color cardColor = bgColor ?? Colors.blue;
    String maskedNumber = maskPhoneNumber(number);

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
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
                    role == "OWNER" ? Icons.person
                        : role == "CARETAKER" ? Icons.support_agent
                        : role == "FIELD WORKER" ? Icons.engineering
                        : role == "TENANT" ? Icons.people
                        : Icons.business_center,
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
                onTap: () => showCallConfirmationDialog(role, name, number, context),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
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
                            fontSize: isSmallScreen ? 13.0 : 14.0,
                            fontWeight: FontWeight.w500,
                            color: cardColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => openWhatsApp(number, context),
                            child: Icon(PhosphorIcons.whatsapp_logo_bold, color: cardColor, size: isSmallScreen ? 20.0 : 24.0),
                          ),
                          SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                          Icon(Icons.call, color: cardColor, size: isSmallScreen ? 20.0 : 24.0),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
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

  Widget buildSimpleInfoCard(String title, String value, IconData icon, Color cardColor, {VoidCallback? onTap, required BuildContext context}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Widget card = Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
        child: Row(
          children: [
            Container(
              width: isSmallScreen ? 32.0 : 36.0,
              height: isSmallScreen ? 32.0 : 36.0,
              decoration: BoxDecoration(
                color: cardColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
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
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 10.0 : 11.0,
                      fontWeight: FontWeight.w600,
                      color: cardColor,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 1.0 : 2.0),
                  Text(
                    value,
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
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: card);
    }
    return card;
  }

  Widget _buildAdaptiveRows(List<Widget> cards, BuildContext context, double verticalPadding) {
    return LayoutBuilder(builder: (context, constraints) {
      final available = constraints.maxWidth;
      final spacing = MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0;
      final runSpacing = verticalPadding;
      final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
      final itemWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

      return Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: cards.map((card) {
          final width = cards.length == 1 ? available : itemWidth;
          return SizedBox(width: width, child: card);
        }).toList(),
      );
    });
  }

  List<Widget> getBuildingFacilityRows(CommercialPropertyData prop, BuildContext context) {
    List<Widget> rows = [];
    final amenitiesText = prop.amenities.join(', ');
    if (amenitiesText.isNotEmpty) {
      rows.add(buildInfoRow(Icons.local_hospital, Colors.amber, "Building Facility", amenitiesText, context));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final double verticalPadding = isSmallScreen ? 2.0 : 4.0;

    List<Widget> row1Cards = [];
    if ((prop.parkingType ?? '').isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard("Parking", prop.parkingType!, Icons.local_parking, Colors.purple, context: context));
    }
    if ((prop.totalFloors ?? '').isNotEmpty) {
      row1Cards.add(buildSimpleInfoCard("Total Floors", prop.totalFloors!, Icons.layers, Colors.red, context: context));
    }
    if (row1Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row1Cards, context, verticalPadding),
      ));
    }

    List<Widget> row2Cards = [];
    if ((prop.lockInPeriod ?? '').isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard("Lock-in Period", prop.lockInPeriod!, Icons.lock, Colors.blue, context: context));
    }
    if ((prop.rentMeterType ?? '').isNotEmpty) {
      row2Cards.add(buildSimpleInfoCard("Rent Meter", prop.rentMeterType!, Icons.calculate, Colors.orange, context: context));
    }
    if (row2Cards.isNotEmpty) {
      rows.add(Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding),
        child: _buildAdaptiveRows(row2Cards, context, verticalPadding),
      ));
    }

    return rows;
  }

  Widget buildFieldworkerInfoCard(CommercialPropertyData prop, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final String name = prop.fieldWorkerName;
    final String number = prop.fieldWorkerNumber;
    final String address = prop.currentAddress ?? '';
    if (name.isEmpty && number.isEmpty && address.isEmpty) return const SizedBox.shrink();

    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardColor = Colors.blue;

    return Container(
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 2.0 : 4.0),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cardColor.withOpacity(0.3)),
      ),
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
                  Icons.engineering,
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
                      "FIELD WORKER",
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
              onTap: () => showCallConfirmationDialog("FIELD WORKER", name, number, context),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: isSmallScreen ? 6.0 : 8.0),
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
                        maskPhoneNumber(number),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13.0 : 14.0,
                          fontWeight: FontWeight.w500,
                          color: cardColor,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => openWhatsApp(number, context),
                          child: Icon(PhosphorIcons.whatsapp_logo_bold, color: Colors.green, size: isSmallScreen ? 20.0 : 24.0),
                        ),
                        SizedBox(width: isSmallScreen ? 12.0 : 16.0),
                        Icon(Icons.call, color: cardColor, size: isSmallScreen ? 20.0 : 24.0),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          if (address.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: isSmallScreen ? 6.0 : 8.0),
              child: buildSimpleInfoCard("Fieldworker Address", address, Icons.location_on, Colors.lime, context: context),
            ),
        ],
      ),
    );
  }

  Widget buildResponsiveInfoGrid(List<Widget> infoRows, BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        if (screenWidth > 350) {
          final half = (infoRows.length / 2).ceil();
          final leftColumn = infoRows.sublist(0, half);
          final rightColumn = infoRows.length > half ? infoRows.sublist(half) : <Widget>[];
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: leftColumn)),
              SizedBox(width: MediaQuery.of(context).size.width < 360 ? 8.0 : 12.0),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: rightColumn)),
            ],
          );
        } else {
          return Column(crossAxisAlignment: CrossAxisAlignment.start, children: infoRows);
        }
      },
    );
  }

  List<Widget> getPropertyDetailsRows(CommercialPropertyData prop, BuildContext context) {
    List<Widget> rows = [];
    if ((prop.currentAddress ?? '').isNotEmpty) rows.add(buildInfoRow(Icons.location_on, Colors.pink, "Current Address", prop.currentAddress!, context));
    if ((prop.propertyType ?? '').isNotEmpty) rows.add(buildInfoRow(Icons.category, Colors.deepOrange, "Type of Property", prop.propertyType!, context));
    if ((prop.availableFrom).isNotEmpty) rows.add(buildInfoRow(Icons.calendar_today, Colors.blue, "Available From", prop.availableFrom, context));
    if ((prop.warehouseType ?? '').isNotEmpty) rows.add(buildInfoRow(Icons.warehouse, Colors.green, "Warehouse Type", prop.warehouseType!, context));
    if ((prop.rentMeterType ?? '').isNotEmpty) rows.add(buildInfoRow(Icons.calculate, Colors.orange, "Rent Meter", prop.rentMeterType!, context));
    if ((prop.security).isNotEmpty) rows.add(buildInfoRow(Icons.security, Colors.red, "Security", prop.security, context));
    if ((prop.rentIncome).isNotEmpty) rows.add(buildInfoRow(Icons.account_balance_wallet, Colors.purple, "Rent Income", prop.rentIncome, context));
    if ((prop.builtupArea).isNotEmpty) rows.add(buildInfoRow(Icons.aspect_ratio, Colors.teal, "Built-up Area", "${prop.builtupArea} sq ft", context));
    if ((prop.carpetArea).isNotEmpty) rows.add(buildInfoRow(Icons.aspect_ratio, Colors.teal, "Carpet Area", "${prop.carpetArea} sq ft", context));
    if ((prop.sellingHeight).isNotEmpty) rows.add(buildInfoRow(Icons.height, Colors.indigo, "Selling Height", prop.sellingHeight, context));
    if ((prop.sellingWidth).isNotEmpty) rows.add(buildInfoRow(Icons.width_full, Colors.indigo, "Selling Width", prop.sellingWidth, context));

    return rows;
  }

  List<Widget> getAdditionalInfoRows(CommercialPropertyData prop, BuildContext context) {
    List<Widget> rows = [];
    print('DEBUG: getAdditionalInfoRows rent: "${prop.rentPrice}"');

    List<Widget> priceWidgets = [];
    final rentText = prop.rentPrice.isNotEmpty && prop.rentPrice != 'null' && prop.rentPrice != '0' ? prop.rentPrice : 'N/A';
    priceWidgets.add(Expanded(
      child: buildSimpleInfoCard("Rent Price", rentText, Icons.currency_rupee, Colors.green, context: context),
    ));

    final secText = prop.security.isNotEmpty && prop.security != 'null' && prop.security != '0' ? prop.security : 'N/A';
    priceWidgets.add(SizedBox(width: MediaQuery.of(context).size.width < 360 ? 6.0 : 8.0));
    priceWidgets.add(Expanded(
      child: buildSimpleInfoCard("Security", secText, Icons.lock, Colors.pink, context: context),
    ));

    rows.add(Padding(
      padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.width < 360 ? 2.0 : 4.0),
      child: Row(children: priceWidgets),
    ));

    rows.add(buildFieldworkerInfoCard(prop, context));
    return rows;
  }

  Widget buildChip(IconData icon, String text, Color color, BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 6.0 : 8.0, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isSmallScreen ? 14.0 : 16.0, color: color),
          SizedBox(width: 4),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                fontSize: isSmallScreen ? 9.0 : 10.0,
                fontWeight: FontWeight.w500,
                color: color,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> handleMainButtonAction(BuildContext context) async {
    isMainLoading.value = true;
    try {
      final url = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/move_to_main_realestae.php");

      if (estateStatus.value == "Book") {
        final updateBody = {"action": "update", "P_id": id};
        final updateResponse = await http.post(url, body: updateBody).timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": id};
        final moveResponse = await http.post(url, body: copyBody).timeout(const Duration(seconds: 30));

        if (updateResponse.statusCode == 200 && moveResponse.statusCode == 200) {
          final now = DateTime.now();
          final formattedNow = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

          final editDateBody = {
            "action": "edit_date",
            "source_id": id,
            "date_for_target": formattedNow,
          };
          await http.post(url, body: editDateBody).timeout(const Duration(seconds: 30));

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Property moved to Live successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.green),
          );
          estateStatus.value = "Live";
        }
      } else if (estateStatus.value == "Live") {
        final reupdateBody = {"action": "reupdate", "P_id": id};
        await http.post(url, body: reupdateBody).timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "source_id": id};
        final deleteResponse = await http.post(url, body: deleteBody).timeout(const Duration(seconds: 30));

        if (deleteResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Property UnLived successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
          );
          estateStatus.value = "Book";
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      isMainLoading.value = false;
    }
  }

  Future<void> handleUpcomingButtonAction(BuildContext context) async {
    isUpcomingLoading.value = true;
    try {
      final upcomingUrl = Uri.parse("https://verifyserve.social/Second%20PHP%20FILE/main_realestate/upcoming_flat_move_to_realestate.php");
      if (upcomingStatus.value == "Book") {
        final updateBody = {"action": "update", "P_id": id};
        final updateResponse = await http.post(upcomingUrl, body: updateBody).timeout(const Duration(seconds: 30));

        final copyBody = {"action": "copy", "P_id": id};
        final moveResponse = await http.post(upcomingUrl, body: copyBody).timeout(const Duration(seconds: 30));

        if (updateResponse.statusCode == 200 && moveResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Moved to Upcoming successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange),
          );
          upcomingStatus.value = "Live";
        }
      } else if (upcomingStatus.value == "Live") {
        final reupdateBody = {"action": "reupdate", "P_id": id};
        await http.post(upcomingUrl, body: reupdateBody).timeout(const Duration(seconds: 30));

        final deleteBody = {"action": "delete", "subid": subid};
        final deleteResponse = await http.post(upcomingUrl, body: deleteBody).timeout(const Duration(seconds: 30));

        if (deleteResponse.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Removed from Upcoming successfully!", style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
          );
          upcomingStatus.value = "Book";
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
    } finally {
      isUpcomingLoading.value = false;
    }
  }
}

// ------------------ VIEW ------------------
class CommercialUnderProperty extends GetView<CommercialUnderPropertyController> {
  final String id;
  final String subid;
  final CommercialPropertyData propertyData;

  const CommercialUnderProperty({
    super.key,
    required this.id,
    required this.subid,
    required this.propertyData,
  });

  @override
  Widget build(BuildContext context) {
    // Ensure controller is put only once per route
    if (!Get.isRegistered<CommercialUnderPropertyController>()) {
      Get.put(CommercialUnderPropertyController(id: id, subid: subid, initialData: propertyData));
    }
    final controller = Get.find<CommercialUnderPropertyController>();

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;
    final isTablet = screenWidth > 600;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final horizontalPadding = isSmallScreen ? 8.0 : (isTablet ? 24.0 : 12.0);
    final verticalPadding = isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0);
    final imageHeight = screenHeight * (isTablet ? 0.35 : 0.3);
    final carouselHeight = screenHeight * (isTablet ? 0.3 : 0.25);
    final chipSpacing = isSmallScreen ? 4.0 : 6.0;
    final fontScale = isSmallScreen ? 0.9 : (isTablet ? 1.1 : 1.0);

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      body: Obx(() {
        if (controller.isDataLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final currentProp = controller.property.value ?? propertyData;
        print('DEBUG: Build - Rent from currentProp: "${currentProp.rentPrice}"');
        return RefreshIndicator(
          onRefresh: controller.refreshData,
          child: FutureBuilder<List<CommercialImage>>(
            future: controller.sliderFuture,
            builder: (context, snapshot) {
              final images = snapshot.data ?? [];
              final hasMultiple = images.isNotEmpty;
              final hasSingle = currentProp.singleImage != null;
              if (snapshot.hasError) {
                print('DEBUG: FutureBuilder error: ${snapshot.error}');
              }
              print('DEBUG: FutureBuilder images: ${images.length}, hasSingle: $hasSingle');

              final bool noImages = !hasSingle && !hasMultiple;

              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        if (noImages)
                          Container(
                            height: imageHeight,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image_not_supported, size: 50 * fontScale, color: Colors.grey),
                                  Text("No Images", style: TextStyle(fontSize: 16 * fontScale, color: Colors.grey)),
                                  ElevatedButton(
                                    onPressed: controller.pickTestImage,
                                    child: const Text('Add Image'),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (hasSingle) {
                                    _previewSingle(currentProp.singleImage!, context);
                                  } else {
                                    _previewImage(images[0], context);
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                                  child: hasSingle
                                      ? _buildFromXFile(currentProp.singleImage!, imageHeight, double.infinity)
                                      : _buildImage(images[0], imageHeight, double.infinity),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).padding.top + (isSmallScreen ? 4.0 : 8.0),
                                left: horizontalPadding,
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(PhosphorIcons.caret_left_bold, color: Colors.white, size: isSmallScreen ? 24.0 : 28.0),
                                ),
                              ),
                              Positioned(
                                top: MediaQuery.of(context).padding.top + (isSmallScreen ? 4.0 : 8.0),
                                right: horizontalPadding,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) => controller.handleMenuItemClick(value, context),
                                  itemBuilder: (_) => ['Reload Data', 'Add Images', 'Edit Property']
                                      .map((c) => PopupMenuItem(value: c, child: Text(c)))
                                      .toList(),
                                  icon: Icon(Icons.more_vert, color: Colors.white, size: isSmallScreen ? 24.0 : 28.0),
                                ),
                              ),
                              Positioned(
                                bottom: isSmallScreen ? 8.0 : 16.0,
                                right: horizontalPadding,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                  decoration: BoxDecoration(color: Colors.green.withOpacity(0.7), borderRadius: BorderRadius.circular(16)),
                                  child: Text(
                                    currentProp.listingType ?? 'Rent',
                                    style: TextStyle(fontSize: (isSmallScreen ? 16.0 : 18.0) * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        SizedBox(height: verticalPadding * 2),
                        // ... rest of the UI remains the same
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                  decoration: BoxDecoration(color: Colors.purple.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: Text(
                                      currentProp.rentPrice.isNotEmpty && currentProp.rentPrice != 'null' && currentProp.rentPrice != '0'
                                          ? currentProp.rentPrice
                                          : 'Rent: N/A',
                                      style: TextStyle(fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                              if (currentProp.security.isNotEmpty && currentProp.security != 'null' && currentProp.security != '0')
                                ...[
                                  SizedBox(width: horizontalPadding),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
                                      decoration: BoxDecoration(color: Colors.purple.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
                                      child: Center(
                                        child: Text(
                                          "${currentProp.security} Security",
                                          style: TextStyle(fontSize: (isSmallScreen ? 14.0 : 16.0) * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding * 1.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentProp.location,
                                style: TextStyle(
                                  fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                  fontWeight: FontWeight.w600,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                              SizedBox(height: verticalPadding * 1.2),
                              LayoutBuilder(builder: (context, constraints) {
                                final available = constraints.maxWidth;
                                final spacing = chipSpacing * 1.5;
                                final int itemsPerRow = available >= 800 ? 4 : available >= 520 ? 3 : 2;
                                final chipWidth = (available - spacing * (itemsPerRow - 1)) / itemsPerRow;

                                final chipsData = [
                                  {'icon': Icons.business_center, 'text': currentProp.propertyType ?? '', 'color': Colors.blue},
                                  {'icon': Icons.aspect_ratio, 'text': '${currentProp.builtupArea} sq ft', 'color': Colors.green},
                                  {'icon': Icons.warehouse, 'text': currentProp.warehouseType ?? '', 'color': Colors.purple},
                                  {'icon': Icons.layers, 'text': currentProp.totalFloors ?? '', 'color': Colors.amber},
                                ].where((e) => (e['text'] as String).isNotEmpty).toList();

                                return Wrap(
                                  spacing: spacing,
                                  runSpacing: verticalPadding * 1.2,
                                  children: chipsData.map((e) {
                                    return SizedBox(
                                      width: chipWidth,
                                      child: controller.buildChip(
                                        e['icon'] as IconData,
                                        e['text'] as String,
                                        e['color'] as Color,
                                        context,
                                      ),
                                    );
                                  }).toList(),
                                );
                              }),
                              SizedBox(height: verticalPadding * 2),
                            ],
                          ),
                        ),
                        // Carousel for multiple images
                        if (hasMultiple)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                            child: Builder(
                              builder: (context) {
                                List<CommercialImage> carouselList = images;
                                if (!hasSingle && images.length > 1) {
                                  carouselList = images.sublist(1);
                                }
                                if (carouselList.isNotEmpty) {
                                  return CarouselSlider(
                                    options: CarouselOptions(
                                      height: carouselHeight,
                                      autoPlay: true,
                                      viewportFraction: isSmallScreen ? 0.85 : 0.8,
                                    ),
                                    items: carouselList.map((img) => GestureDetector(
                                      onTap: () => _previewImage(img, context),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: _buildImage(img, carouselHeight, double.infinity),
                                      ),
                                    )).toList(),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                        // Rest of the sections...
                        Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Property Details",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              controller.buildResponsiveInfoGrid(controller.getPropertyDetailsRows(currentProp, context), context),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.local_hospital, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Building Facility",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              if (controller.getBuildingFacilityRows(currentProp, context).isNotEmpty)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: controller.getBuildingFacilityRows(currentProp, context),
                                ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.contact_page, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Contact Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding * 2),
                              controller.buildContactCard("FIELD WORKER", currentProp.fieldWorkerName, currentProp.fieldWorkerNumber, bgColor: Colors.green, context: context),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: horizontalPadding / 2),
                                child: Row(
                                  children: [
                                    Icon(Icons.info_outline, color: Colors.blue, size: (isSmallScreen ? 16.0 : 18.0) * fontScale),
                                    SizedBox(width: horizontalPadding),
                                    Text(
                                      "Additional Information",
                                      style: TextStyle(
                                        fontSize: (isSmallScreen ? 15.0 : 16.0) * fontScale,
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: verticalPadding),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: controller.getAdditionalInfoRows(currentProp, context),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.15),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add contact logic
        },
        icon: Icon(Icons.person_add, color: Colors.white, size: 20 * fontScale),
        label: Text("Add Contact", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14 * fontScale)),
        backgroundColor: Colors.blue,
        elevation: 4,
      ),
      bottomNavigationBar: Obx(() => Container(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[900] : Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 6, offset: const Offset(0, -2)),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isMainLoading.value
                      ? Colors.grey
                      : (controller.estateStatus.value == "Live" ? Colors.grey : Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  elevation: 2,
                ),
                onPressed: controller.isMainLoading.value || controller.estateStatus.value.isEmpty
                    ? null
                    : () => controller.handleMainButtonAction(context),
                child: controller.isMainLoading.value
                    ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                  controller.estateStatus.value == "Live" ? "Rent out / Book" : "Move to Live",
                  style: TextStyle(fontSize: (isSmallScreen ? 11.0 : 13.0) * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(width: horizontalPadding),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: controller.isUpcomingLoading.value
                      ? Colors.grey
                      : (controller.upcomingStatus.value == "Live" ? Colors.grey : Colors.orange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(vertical: verticalPadding * 2),
                  elevation: 2,
                ),
                onPressed: controller.isUpcomingLoading.value || controller.upcomingStatus.value.isEmpty
                    ? null
                    : () => controller.handleUpcomingButtonAction(context),
                child: controller.isUpcomingLoading.value
                    ? SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(
                  controller.upcomingStatus.value == "Live" ? "Remove" : "Move to Upcoming",
                  style: TextStyle(fontSize: (isSmallScreen ? 11.0 : 13.0) * fontScale, fontWeight: FontWeight.bold, color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildFromXFile(XFile file, double height, double width) {
    if (file.path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: file.path,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (c, u) => Center(child: CircularProgressIndicator()),
        errorWidget: (c, u, e) => Container(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(height: 6),
              Flexible(child: Text(u ?? 'No URL', textAlign: TextAlign.center, style: TextStyle(fontSize: 10))),
            ],
          ),
        ),
      );
    } else {
      return Image.file(
        File(file.path),
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(color: Colors.grey[300], child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, color: Colors.red), Text('Error: $e')])),
      );
    }
  }

  Widget _buildImage(CommercialImage img, double height, double width) {
    if (img.url != null) {
      return CachedNetworkImage(
        imageUrl: img.url!,
        height: height,
        width: width,
        fit: BoxFit.cover,
        placeholder: (c, u) => Center(child: CircularProgressIndicator()),
        errorWidget: (c, u, e) => Container(
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error, color: Colors.red),
              SizedBox(height: 6),
              Flexible(child: Text(u ?? 'No URL', textAlign: TextAlign.center, style: TextStyle(fontSize: 10))),
            ],
          ),
        ),
      );
    } else {
      return Image.file(
        File(img.path),
        height: height,
        width: width,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => Container(color: Colors.grey[300], child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.error, color: Colors.red), Text('Error: $e')])),
      );
    }
  }

  void _previewImage(CommercialImage img, BuildContext context) {
    String previewUrl;
    if (img.url != null) {
      previewUrl = img.url!;
    } else if (img.path.startsWith('http')) {
      previewUrl = img.path;
    } else {
      previewUrl = 'file://${img.path}';
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyPreview(ImageUrl: previewUrl)));
  }

  void _previewSingle(XFile file, BuildContext context) {
    String previewUrl = file.path.startsWith('http') ? file.path : 'file://${file.path}';
    Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyPreview(ImageUrl: previewUrl)));
  }
}

class PropertyPreview extends StatelessWidget {
  final String ImageUrl;
  const PropertyPreview({super.key, required this.ImageUrl});

  @override
  Widget build(BuildContext context) {
    if (ImageUrl.startsWith('http')) {
      return Scaffold(appBar: AppBar(title: const Text('Preview')), body: CachedNetworkImage(imageUrl: ImageUrl, fit: BoxFit.contain));
    } else {
      return Scaffold(
        appBar: AppBar(title: const Text('Preview')),
        body: Image.file(File(ImageUrl.replaceFirst('file://', '')), fit: BoxFit.contain, errorBuilder: (c, e, s) => Center(child: Text('Load error: $e'))),
      );
    }
  }
}