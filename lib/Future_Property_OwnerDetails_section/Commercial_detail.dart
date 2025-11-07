// Commercial_detail.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

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

  // JSON serialization method
  Map<String, dynamic> toJson() {
    return {
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
  }

  // JSON deserialization method
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
      latitude: json['latitude'],
      longitude: json['longitude'],
      singleImage: json['singleImagePath'] != null
          ? XFile(json['singleImagePath'])
          : null,
      selectedImages: (json['selectedImagesPaths'] as List<dynamic>?)
          ?.map((path) => XFile(path.toString()))
          .toList() ?? [],
    );
  }
}

class CommercialPropertyDisplayPage extends StatefulWidget {
  final CommercialPropertyData propertyData;

  const CommercialPropertyDisplayPage({Key? key, required this.propertyData}) : super(key: key);

  @override
  State<CommercialPropertyDisplayPage> createState() => _CommercialPropertyDisplayPageState();
}

class _CommercialPropertyDisplayPageState extends State<CommercialPropertyDisplayPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  int _mainImageIndex = 0;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 360));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) await launchUrl(launchUri);
  }

  Future<void> _openWhatsApp(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;
    final sanitized = phoneNumber.replaceAll(RegExp(r'[^0-9]'), '');
    final Uri wa = Uri.parse('https://wa.me/$sanitized');
    if (await canLaunchUrl(wa)) await launchUrl(wa);
  }

  List<XFile> get allImages {
    final imgs = <XFile>[];
    if (widget.propertyData.singleImage != null) imgs.add(widget.propertyData.singleImage!);
    imgs.addAll(widget.propertyData.selectedImages);
    return imgs;
  }

  Widget _imageWidget(XFile? file, {BoxFit fit = BoxFit.cover}) {
    if (file == null) return Container(
      color: Colors.grey[200],
      child: Icon(Icons.business_center, size: 50, color: Colors.grey[400]),
    );
    final path = file.path;
    if (path.startsWith('http')) return Image.network(path, fit: fit);
    return Image.file(File(path), fit: fit);
  }

  @override
  Widget build(BuildContext context) {
    final images = allImages;
    if (_mainImageIndex >= images.length && images.isNotEmpty) _mainImageIndex = 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              expandedHeight: 380,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (images.isNotEmpty)
                      _imageWidget(images[_mainImageIndex])
                    else
                      Container(
                        color: Colors.grey[200],
                        child: Icon(Icons.business_center, size: 80, color: Colors.grey[400]),
                      ),

                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.center,
                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        ),
                      ),
                    ),

                    Positioned(
                      top: MediaQuery.of(context).padding.top + 8,
                      left: 16,
                      right: 16,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _circleIcon(Icons.arrow_back, onTap: () => Navigator.of(context).maybePop()),
                          Row(children: [
                            _circleIcon(_isFavorite ? Icons.favorite : Icons.favorite_border, onTap: () => setState(() => _isFavorite = !_isFavorite)),
                            SizedBox(width: 8),
                            _circleIcon(Icons.more_vert, onTap: () {}),
                          ])
                        ],
                      ),
                    ),

                    Positioned(
                      left: 20,
                      right: 20,
                      bottom: 24,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.propertyData.rentPrice.isNotEmpty ? '₹${widget.propertyData.rentPrice}' : 'Contact',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  shadows: [Shadow(color: Colors.black54, blurRadius: 8)],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [Color(0xFF2A4B8D), Color(0xFF6C5CE7)]),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                                ),
                                child: Text(
                                  (widget.propertyData.listingType ?? 'SALE').toUpperCase(),
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.propertyData.location,
                            style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 16, fontWeight: FontWeight.w600, shadows: [Shadow(color: Colors.black54, blurRadius: 8)]),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(children: [
                SizedBox(height: 12),
                Container(
                  height: 92,
                  child: ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: images.isEmpty ? 1 : images.length,
                    separatorBuilder: (_, __) => SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isAvailable = images.isNotEmpty && index < images.length;
                      final file = isAvailable ? images[index] : null;
                      final selected = index == _mainImageIndex;
                      return GestureDetector(
                        onTap: isAvailable ? () => setState(() => _mainImageIndex = index) : null,
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 180),
                          width: selected ? 120 : 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: selected ? Color(0xFF2A4B8D) : Colors.grey.shade200, width: selected ? 2 : 1),
                            boxShadow: [if (selected) BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: Offset(0, 4))],
                          ),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: isAvailable ? _imageWidget(file) : Container(
                                color: Colors.grey[200],
                                child: Icon(Icons.business_center, size: 30, color: Colors.grey[400]),
                              )
                          ),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(height: 14),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(widget.propertyData.listingType == 'Rent' ? 'Monthly Rent' : 'Sale Price',
                                style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                            SizedBox(height: 6),
                            Text(
                                widget.propertyData.listingType == 'Rent' ? '₹${widget.propertyData.rentPrice}/month' : (widget.propertyData.rentPrice.isNotEmpty ? '₹${widget.propertyData.rentPrice}' : 'Contact for Price'),
                                style: TextStyle(color: Color(0xFF2A4B8D), fontSize: 20, fontWeight: FontWeight.w900)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),

                SizedBox(height: 12),
              ]),
            ),

            _sectionSliver(
              title: 'Overview',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _miniInfoTile(Icons.calendar_today, 'Available', widget.propertyData.availableFrom),
                  _miniInfoTile(Icons.layers, 'Floors', widget.propertyData.totalFloors ?? 'Not specified'),
                  _miniInfoTile(Icons.local_parking, 'Parking', widget.propertyData.parkingType ?? 'Available'),
                  _miniInfoTile(Icons.aspect_ratio, 'Built-up Area', '${widget.propertyData.builtupArea} sq ft'),
                ]),
                SizedBox(height: 12),
                Text('${widget.propertyData.propertyType ?? 'Commercial Property'} located in ${widget.propertyData.location}.',
                    style: TextStyle(color: Colors.grey[700]))
              ]),
            ),

            _sectionSliver(
              title: 'Property Details',
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 2.5,
                children: [
                  _smallStat('Built-up', '${widget.propertyData.builtupArea} sq ft'),
                  _smallStat('Carpet', '${widget.propertyData.carpetArea} sq ft'),
                  _smallStat('Height', '${widget.propertyData.sellingHeight} ft'),
                  _smallStat('Width', '${widget.propertyData.sellingWidth} ft'),
                ],
              ),
            ),

            _sectionSliver(
              title: 'Amenities',
              child: widget.propertyData.amenities.isNotEmpty
                  ? Wrap(spacing: 8, runSpacing: 8, children: widget.propertyData.amenities.map((a) => Chip(label: Text(a))).toList())
                  : Text('No amenities specified', style: TextStyle(color: Colors.grey[700])),
            ),

            _sectionSliver(
              title: 'Fieldworker',
              child: Row(children: [
                CircleAvatar(radius: 32, backgroundColor: Color(0xFF2A4B8D), child: Text(widget.propertyData.fieldWorkerName.isNotEmpty ? widget.propertyData.fieldWorkerName[0].toUpperCase() : 'A', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800))),
                SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.propertyData.fieldWorkerName, style: TextStyle(fontWeight: FontWeight.w800)), SizedBox(height: 6), Text(widget.propertyData.fieldWorkerNumber), SizedBox(height: 8), Row(children: [Icon(Icons.verified, color: Colors.green, size: 16), SizedBox(width: 6), Text('Verified', style: TextStyle(color: Colors.green))])])),
                ElevatedButton(onPressed: () => _makePhoneCall(widget.propertyData.fieldWorkerNumber), child: Text('Contact')),
              ]),
            ),

            SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: Offset(0, -6))]),
        child: Row(children: [
          Expanded(child: ElevatedButton.icon(onPressed: () => _makePhoneCall(widget.propertyData.fieldWorkerNumber), icon: Icon(Icons.phone), label: Text('Call Agent'), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2A4B8D), padding: EdgeInsets.symmetric(vertical: 14)))),
          SizedBox(width: 12),
          Expanded(child: OutlinedButton.icon(onPressed: () => _openWhatsApp(widget.propertyData.fieldWorkerNumber), icon: Icon(Icons.chat), label: Text('WhatsApp'), style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14), side: BorderSide(color: Colors.green)))),
        ]),
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.95), shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }

  SliverToBoxAdapter _sectionSliver({required String title, required Widget child}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          SizedBox(height: 8),
          child,
        ]),
      ),
    );
  }

  Widget _miniInfoTile(IconData icon, String label, String value) {
    return Container(
      width: 160,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10)]),
      child:
      Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Color(0xFF2A4B8D).withOpacity(0.08),
                          shape: BoxShape.circle),
                      child:
                      Icon(icon, size: 16, color: Color(0xFF2A4B8D))),
                  SizedBox(width: 8),
                  Text(
                      label,
                      style: TextStyle(fontSize: 12,
                          color: Colors.grey[700]))]),
            SizedBox(height: 8),
            Text(
                value, style: TextStyle(
                fontWeight: FontWeight.w800)),
          ]),
    );
  }

  Widget _smallStat(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [BoxShadow(color:
          Colors.black.withOpacity(0.03),
              blurRadius: 8)]),
      child:
      Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                title,
                style: TextStyle(
                    color: Colors.grey[700])),
            Text(value,
                style: TextStyle(
                    fontWeight: FontWeight.w800))]),
    );
  }
}