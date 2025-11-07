import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';

// ------------------ MODEL ------------------
class PlotPropertyData {
  final String plotSize;
  final String plotPrice;
  final String fieldAddress;
  final String mainAddress;
  final String plotFrontSize;
  final String plotSideSize;
  final String roadSize;
  final String plotOpen;
  final String ageOfProperty;
  final String waterConnection;
  final String electricPrice;
  final String plotStatus;
  final String propertyChain;
  final String currentLocation;
  final String longitude;
  final String latitude;
  final String fieldworkarName;
  final String fieldworkarNumber;
  final String propertyRent;
  final XFile? singleImage;
  final List<XFile> selectedImages;

  PlotPropertyData({
    required this.plotSize,
    required this.plotPrice,
    required this.fieldAddress,
    required this.mainAddress,
    required this.plotFrontSize,
    required this.plotSideSize,
    required this.roadSize,
    required this.plotOpen,
    required this.ageOfProperty,
    required this.waterConnection,
    required this.electricPrice,
    required this.plotStatus,
    required this.propertyChain,
    required this.currentLocation,
    required this.longitude,
    required this.latitude,
    required this.fieldworkarName,
    required this.fieldworkarNumber,
    required this.propertyRent,
    this.singleImage,
    required this.selectedImages,
  });

  Map<String, dynamic> toJson() {
    return {
      'plot_size': plotSize,
      'plot_price': plotPrice,
      'field_address': fieldAddress,
      'main_address': mainAddress,
      'plot_front_size': plotFrontSize,
      'plot_side_size': plotSideSize,
      'road_size': roadSize,
      'plot_open': plotOpen,
      'age_of_property': ageOfProperty,
      'water_connection': waterConnection,
      'electric_price': electricPrice,
      'plot_status': plotStatus,
      'property_chain': propertyChain,
      'current_location': currentLocation,
      'longitude': longitude,
      'latitude': latitude,
      'fieldworkar_name': fieldworkarName,
      'fieldworkar_number': fieldworkarNumber,
      'property_rent': propertyRent,
      'single_image_path': singleImage?.path,
      'selected_images_paths': selectedImages.map((img) => img.path).toList(),
    };
  }

  factory PlotPropertyData.fromJson(Map<String, dynamic> json) {
    const String baseImageUrl = 'https://verifyserve.social/Second%20PHP%20FILE/main_realestate/';

    String? singlePath;
    if (json['single_image_path'] != null) {
      singlePath = json['single_image_path'];
    } else if (json['single_image'] != null) {
      singlePath = baseImageUrl + json['single_image'];
    }

    List<XFile> selectedImgs = [];
    if (json['selected_images_paths'] != null) {
      final paths = (json['selected_images_paths'] as List).cast<dynamic>();
      selectedImgs = paths.map((p) => XFile(p as String)).toList();
    }

    return PlotPropertyData(
      plotSize: (json['plot_size'] ?? '').toString(),
      plotPrice: (json['plot_price'] ?? '').toString(),
      fieldAddress: (json['field_address'] ?? '').toString(),
      mainAddress: (json['main_address'] ?? '').toString(),
      plotFrontSize: (json['plot_front_size'] ?? '').toString(),
      plotSideSize: (json['plot_side_size'] ?? '').toString(),
      roadSize: (json['road_size'] ?? '').toString(),
      plotOpen: (json['plot_open'] ?? '').toString(),
      ageOfProperty: (json['age_of_property'] ?? '').toString(),
      waterConnection: (json['water_connection'] ?? '').toString(),
      electricPrice: (json['electric_price'] ?? '').toString(),
      plotStatus: (json['plot_status'] ?? '').toString(),
      propertyChain: (json['property_chain'] ?? '').toString(),
      currentLocation: (json['current_location'] ?? '').toString(),
      longitude: (json['longitude'] ?? '').toString(),
      latitude: (json['latitude'] ?? '').toString(),
      fieldworkarName: (json['fieldworkar_name'] ?? '').toString(),
      fieldworkarNumber: (json['fieldworkar_number'] ?? '').toString(),
      propertyRent: (json['property_rent'] ?? '').toString(),
      singleImage: singlePath != null ? XFile(singlePath) : null,
      selectedImages: selectedImgs,
    );
  }
}

// ------------------ SERVICE ------------------
class PropertyService {
  static const String _host = 'verifyserve.social';
  static const String _path =
      'Second PHP FILE/main_realestate/plot_form_show_api_for_feildworkar.php';

  static Future<List<PlotPropertyData>> fetchPlotsForFieldworker(
      String fieldworkarNumber) async {
    final clean = fieldworkarNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (clean.isEmpty) {
      throw Exception('Fieldworker number is empty');
    }

    // Safe URI: spaces in "Second PHP FILE" will be %20 encoded automatically
    final uri = Uri.https(
      _host,
      _path,
      {'fieldworkar_number': clean}, // <-- correct param name
    );

    late http.Response resp;
    try {
      resp = await http
          .get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Cache-Control': 'no-cache',
        },
      )
          .timeout(const Duration(seconds: 20));
    } on SocketException {
      throw Exception('No internet connection');
    } on TimeoutException {
      throw Exception('Request timed out');
    } on HttpException catch (e) {
      throw Exception('HTTP exception: $e');
    }

    if (resp.statusCode != 200) {
      final body = resp.body;
      final preview = body.substring(0, body.length < 400 ? body.length : 400);
      throw Exception('Server error ${resp.statusCode}. URL: $uri\n$preview');
    }

    Map<String, dynamic> jsonResponse;
    try {
      jsonResponse = json.decode(resp.body.trim()) as Map<String, dynamic>;
    } catch (e) {
      final body = resp.body;
      final preview = body.substring(0, body.length < 400 ? body.length : 400);
      throw Exception('Invalid JSON from server. URL: $uri\nError: $e\nBody (first 400): $preview');
    }

    if (jsonResponse['success'] != true) {
      final msg = (jsonResponse['message'] ?? 'Unknown server message').toString();
      throw Exception('API success=false. Message: $msg');
    }

    final data = jsonResponse['data'];
    if (data is! List) {
      throw Exception('API returned unexpected shape for "data".');
    }

    return data
        .map<PlotPropertyData>(
            (e) => PlotPropertyData.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}



// ------------------ DISPLAY PAGE ------------------
class PlotPropertyDisplayPage extends StatefulWidget {
  final PlotPropertyData? propertyData;
  final String? fieldworkarNumber;

  const PlotPropertyDisplayPage({Key? key, this.propertyData, this.fieldworkarNumber}) : super(key: key);

  @override
  State<PlotPropertyDisplayPage> createState() => _PlotPropertyDisplayPageState();
}

class _PlotPropertyDisplayPageState extends State<PlotPropertyDisplayPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _mainImageIndex = 0;
  bool _isFavorite = false;
  bool _isLoading = false;
  String? _error;

  PlotPropertyData? _currentData;
  List<PlotPropertyData> _allPlots = [];
  String? _fieldworkarNumber;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
    _fadeAnimation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();

    _loadUserNumber().then((_) {
      if (widget.propertyData == null && _fieldworkarNumber != null && _fieldworkarNumber!.isNotEmpty) {
        _loadData();
      } else {
        _currentData = widget.propertyData;
        if (mounted) setState(() {});
      }
    });
  }

  Future<void> _loadUserNumber() async {
    final prefs = await SharedPreferences.getInstance();
    final number = prefs.getString('number') ?? '';
    setState(() {
      _fieldworkarNumber = widget.fieldworkarNumber ?? number;
    });
  }

  Future<void> _loadData() async {
    if (_fieldworkarNumber == null || _fieldworkarNumber!.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'No fieldworkar number available';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _allPlots = await PropertyService.fetchPlotsForFieldworker(_fieldworkarNumber!);
      if (_allPlots.isNotEmpty) {
        _currentData = _allPlots.first;
      } else {
        _error = 'No plots found for your number';
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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

  List<XFile> get _allImages {
    final imgs = <XFile>[];
    if (_currentData?.singleImage != null) imgs.add(_currentData!.singleImage!);
    imgs.addAll(_currentData?.selectedImages ?? []);
    return imgs;
  }

  Widget _imageWidget(XFile? file, {BoxFit fit = BoxFit.cover}) {
    if (file == null) {
      return Container(color: Colors.grey[200], child: const Icon(Icons.landscape, size: 50, color: Colors.grey));
    }
    final p = file.path;
    if (p.startsWith('http')) {
      return CachedNetworkImage(imageUrl: p, fit: fit, placeholder: (_, __) => const Center(child: CircularProgressIndicator()), errorWidget: (_, __, ___) => Container(color: Colors.grey[200]));
    }
    return Image.file(File(p), fit: fit, errorBuilder: (_, __, ___) => Container(color: Colors.grey[200]));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null || _currentData == null) {
      return Scaffold(
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error ?? 'No data available', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Retry Fetch')),
          ]),
        ),
      );
    }

    final images = _allImages;
    if (_mainImageIndex >= images.length && images.isNotEmpty) _mainImageIndex = 0;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              expandedHeight: 380,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(fit: StackFit.expand, children: [
                  if (images.isNotEmpty) _imageWidget(images[_mainImageIndex]) else Container(color: Colors.grey[200], child: const Icon(Icons.landscape, size: 80, color: Colors.grey)),
                  Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.center, colors: [Colors.black.withOpacity(0.8), Colors.transparent]))),
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16,
                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                      _circleIcon(Icons.arrow_back, onTap: () => Navigator.of(context).maybePop()),
                      Row(children: [
                        _circleIcon(_isFavorite ? Icons.favorite : Icons.favorite_border, onTap: () => setState(() => _isFavorite = !_isFavorite)),
                        const SizedBox(width: 8),
                        _circleIcon(Icons.refresh, onTap: _loadData),
                        const SizedBox(width: 8),
                        _circleIcon(Icons.more_vert, onTap: () {}),
                      ])
                    ]),
                  ),
                  Positioned(
                    left: 20, right: 20, bottom: 24,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                        Text('₹${_currentData!.plotPrice}', style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, shadows: [Shadow(color: Colors.black54, blurRadius: 8)])),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF2A4B8D), Color(0xFF6C5CE7)]), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))]),
                          child: const Text('PLOT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, letterSpacing: 1)),
                        ),
                      ]),
                      const SizedBox(height: 8),
                      Text(_currentData!.mainAddress, style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 16, fontWeight: FontWeight.w600, shadows: const [Shadow(color: Colors.black54, blurRadius: 8)]), maxLines: 2, overflow: TextOverflow.ellipsis),
                    ]),
                  ),
                ]),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(children: [
                const SizedBox(height: 12),
                SizedBox(
                  height: 92,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: images.isEmpty ? 1 : images.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final isAvailable = images.isNotEmpty && index < images.length;
                      final file = isAvailable ? images[index] : null;
                      final selected = index == _mainImageIndex;
                      return GestureDetector(
                        onTap: isAvailable ? () => setState(() => _mainImageIndex = index) : null,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          width: selected ? 120 : 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: selected ? const Color(0xFF2A4B8D) : Colors.grey.shade200, width: selected ? 2 : 1),
                            boxShadow: [if (selected) const BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 4))],
                          ),
                          child: ClipRRect(borderRadius: BorderRadius.circular(10), child: isAvailable ? _imageWidget(file) : Container(color: Colors.grey[200], child: const Icon(Icons.landscape, size: 30, color: Colors.grey))),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Row(children: [
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Plot Price', style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w600)),
                            const SizedBox(height: 6),
                            Text('₹${_currentData!.plotPrice}', style: const TextStyle(color: Color(0xFF2A4B8D), fontSize: 20, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 8),
                            Text('Size: ${_currentData!.plotSize} gaj', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                          ]),
                        ),
                      ]),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ]),
            ),

            _sectionSliver(
              title: 'Plot Details',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Wrap(spacing: 12, runSpacing: 12, children: [
                  _miniInfoTile(Icons.aspect_ratio, 'Plot Size', '${_currentData!.plotSize} gaj'),
                  _miniInfoTile(Icons.width_wide, 'Front Size', '${_currentData!.plotFrontSize} ft'),
                  _miniInfoTile(Icons.height, 'Side Size', '${_currentData!.plotSideSize} ft'),
                  _miniInfoTile(Icons.aod, 'Road Size', '${_currentData!.roadSize} ft'),
                ]),
                const SizedBox(height: 12),
                Text('${_currentData!.plotOpen} open plot located in ${_currentData!.mainAddress}.', style: TextStyle(color: Colors.grey[700])),
              ]),
            ),

            _sectionSliver(
              title: 'Property Information',
              child: GridView.count(
                crossAxisCount: 2, shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 2.5,
                children: [
                  _smallStat('Age', _currentData!.ageOfProperty),
                  _smallStat('Water', _currentData!.waterConnection),
                  _smallStat('Electric', _currentData!.electricPrice),
                  _smallStat('Status', _currentData!.plotStatus),
                ],
              ),
            ),

            _sectionSliver(
              title: 'Location Details',
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                _detailItem('Field Address', _currentData!.fieldAddress),
                const SizedBox(height: 8),
                _detailItem('Current Location', _currentData!.currentLocation),
                const SizedBox(height: 8),
                if (_currentData!.latitude.isNotEmpty && _currentData!.longitude.isNotEmpty)
                  _detailItem('Coordinates', '${_currentData!.latitude}, ${_currentData!.longitude}'),
              ]),
            ),

            _sectionSliver(
              title: 'Fieldworker',
              child: Row(children: [
                CircleAvatar(
                  radius: 32, backgroundColor: const Color(0xFF2A4B8D),
                  child: Text(_currentData!.fieldworkarName.isNotEmpty ? _currentData!.fieldworkarName[0].toUpperCase() : 'A', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(_currentData!.fieldworkarName, style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Text(_currentData!.fieldworkarNumber),
                    const SizedBox(height: 8),
                    const Row(children: [Icon(Icons.verified, color: Colors.green, size: 16), SizedBox(width: 6), Text('Verified', style: TextStyle(color: Colors.green))]),
                  ]),
                ),
                ElevatedButton(onPressed: () => _makePhoneCall(_currentData!.fieldworkarNumber), child: const Text('Contact')),
              ]),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, -6))]),
        child: Row(children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _makePhoneCall(_currentData!.fieldworkarNumber),
              icon: const Icon(Icons.phone), label: const Text('Call Agent'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2A4B8D), padding: const EdgeInsets.symmetric(vertical: 14)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _openWhatsApp(_currentData!.fieldworkarNumber),
              icon: const Icon(Icons.chat), label: const Text('WhatsApp'),
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14), side: const BorderSide(color: Colors.green)),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40, height: 40,
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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          child,
        ]),
      ),
    );
  }

  Widget _miniInfoTile(IconData icon, String label, String value) {
    return Container(
      width: 160, padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFF2A4B8D).withOpacity(0.08), shape: BoxShape.circle), child: Icon(icon, size: 16, color: const Color(0xFF2A4B8D))),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ]),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _smallStat(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)]),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: TextStyle(color: Colors.grey[700])),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ]),
    );
  }

  Widget _detailItem(String title, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[700])),
      const SizedBox(height: 4),
      Text(value.isNotEmpty ? value : 'Not specified', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    ]);
  }
}
