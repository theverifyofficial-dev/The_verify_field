import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

import '../../Future_Property_OwnerDetails_section/Future_property_details.dart';

/// Network Map (admin): read-only view of every building across the field
/// workers the signed-in admin/supervisor has access to, as markers on a
/// Google Map. Mirrors the access-control and per-field-worker fetch
/// pattern already used by Administater_Future_Property.dart (there is no
/// single "all buildings" admin endpoint — buildings are fetched one
/// field worker at a time and merged).
///
/// Scope note: same as the field-worker Network Map — core map screen
/// only, no invented "Mapping Status" tiers or boundary polygons. Marker
/// colour here only reflects whether a building has any flats on record
/// at all (this list has no per-building live/unlive counts without an
/// extra fetch per building, which this round deliberately skips to keep
/// the map screen lightweight): blue = has flats, grey = none yet.
class _AdminCatid {
  final int id;
  final String? images;
  final String? place;
  final String? propertyNameAddress;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? longitude;
  final String? latitude;
  final int totalFlats;

  _AdminCatid({
    required this.id,
    this.images,
    this.place,
    this.propertyNameAddress,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.longitude,
    this.latitude,
    required this.totalFlats,
  });

  factory _AdminCatid.fromJson(Map<String, dynamic> json) {
    return _AdminCatid(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      images: json['images']?.toString(),
      place: json['place']?.toString(),
      propertyNameAddress: json['propertyname_address']?.toString(),
      fieldWorkerName: json['fieldworkarname']?.toString(),
      fieldWorkerNumber: json['fieldworkarnumber']?.toString(),
      longitude: json['longitude']?.toString(),
      latitude: json['latitude']?.toString(),
      totalFlats: int.tryParse(json['total_flats']?.toString() ?? '0') ?? 0,
    );
  }
}

class AdminFutureNetworkMapPage extends StatefulWidget {
  const AdminFutureNetworkMapPage({super.key});

  @override
  State<AdminFutureNetworkMapPage> createState() =>
      _AdminFutureNetworkMapPageState();
}

class _AdminFutureNetworkMapPageState
    extends State<AdminFutureNetworkMapPage> {
  static const String _baseUrl =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/";

  // Same hardcoded roster Administater_Future_Property.dart uses — there is
  // no backend "list my field workers" endpoint today.
  final List<Map<String, String>> _fieldWorkers = const [
    {"name": "Faizan Khan", "id": "9971172204"},
    {"name": "Yash", "id": "9211335993"},
    {"name": "Shivam", "id": "9711775300"},
    {"name": "Aakash", "id": "9211335994"},
    {"name": "Ravi Kumar", "id": "9711275300"},
  ];

  bool _loading = true;
  String? _error;
  String _location = '';
  String _post = '';

  List<_AdminCatid> _all = [];
  int _withoutLocation = 0;

  GoogleMapController? _mapController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  _AdminCatid? _selected;

  static const CameraPosition _fallbackCamera = CameraPosition(
    target: LatLng(28.5001, 77.2012),
    zoom: 13,
  );

  bool _locationGranted = false;

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _load();
  }

  Future<void> _checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final granted = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      if (mounted) setState(() => _locationGranted = granted);
    } catch (_) {
      // No location permission available; the map still works, just
      // without the "my location" blue dot/button.
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<Map<String, String>> get _allowedWorkers {
    final loc = _location.toLowerCase();
    final isAdmin = _post.toLowerCase() == "administrator";
    if (isAdmin) return _fieldWorkers;
    if (loc.contains("sultanpur")) {
      return _fieldWorkers
          .where((fw) =>
              fw['name']!.toLowerCase().contains("ravi") ||
              fw['name']!.toLowerCase().contains("faizan") ||
              fw['name']!.toLowerCase().contains("yash"))
          .toList();
    }
    if (loc.contains("rajpur") ||
        loc.contains("chhattarpur") ||
        loc.contains("chattar")) {
      return _fieldWorkers
          .where((fw) => fw['name']!.toLowerCase().contains("yash"))
          .toList();
    }
    return [];
  }

  Future<List<_AdminCatid>> _fetchForWorker(String number) async {
    final url = Uri.parse(
      "https://verifyrealestateandservices.in/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=$number",
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final List listData = decoded is List
            ? decoded
            : (decoded['data'] ?? decoded['Table'] ?? []);
        return listData.map((e) => _AdminCatid.fromJson(e)).toList();
      }
    } catch (_) {
      // One field worker failing to load should not block the others.
    }
    return [];
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      _location = prefs.getString('location') ?? '';
      _post = prefs.getString('post') ?? '';

      final workers = _allowedWorkers;
      final results = await Future.wait(
        workers.map((fw) => _fetchForWorker(fw['id']!)),
      );

      final merged = <_AdminCatid>[];
      for (final list in results) {
        merged.addAll(list);
      }

      int withoutLoc = 0;
      for (final p in merged) {
        if (_latLngOf(p) == null) withoutLoc++;
      }

      if (!mounted) return;
      setState(() {
        _all = merged;
        _withoutLocation = withoutLoc;
        _loading = false;
      });

      WidgetsBinding.instance.addPostFrameCallback((_) => _fitToMarkers());
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load buildings. Check your connection and try again.';
        _loading = false;
      });
    }
  }

  LatLng? _latLngOf(_AdminCatid p) {
    final lat = double.tryParse(p.latitude ?? '');
    final lng = double.tryParse(p.longitude ?? '');
    if (lat == null || lng == null) return null;
    if (lat == 0 && lng == 0) return null;
    return LatLng(lat, lng);
  }

  List<_AdminCatid> get _withLocation =>
      _all.where((p) => _latLngOf(p) != null).toList();

  List<_AdminCatid> get _searchResults {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _withLocation.where((p) {
      final name = (p.propertyNameAddress ?? '').toLowerCase();
      final place = (p.place ?? '').toLowerCase();
      final fw = (p.fieldWorkerName ?? '').toLowerCase();
      final id = p.id.toString();
      return name.contains(q) ||
          place.contains(q) ||
          fw.contains(q) ||
          id.contains(q);
    }).take(20).toList();
  }

  double _markerHue(_AdminCatid p) {
    return p.totalFlats > 0
        ? BitmapDescriptor.hueAzure
        : BitmapDescriptor.hueViolet;
  }

  Color _statusColor(_AdminCatid p) {
    return p.totalFlats > 0 ? Colors.blue : Colors.deepPurple;
  }

  Set<Marker> get _markers {
    return _withLocation.map((p) {
      final pos = _latLngOf(p)!;
      return Marker(
        markerId: MarkerId(p.id.toString()),
        position: pos,
        icon: BitmapDescriptor.defaultMarkerWithHue(_markerHue(p)),
        onTap: () => setState(() => _selected = p),
      );
    }).toSet();
  }

  Future<void> _fitToMarkers() async {
    final pts = _withLocation.map((p) => _latLngOf(p)!).toList();
    if (pts.isEmpty || _mapController == null) return;
    if (pts.length == 1) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(pts.first, 15));
      return;
    }
    double minLat = pts.first.latitude, maxLat = pts.first.latitude;
    double minLng = pts.first.longitude, maxLng = pts.first.longitude;
    for (final pt in pts) {
      minLat = pt.latitude < minLat ? pt.latitude : minLat;
      maxLat = pt.latitude > maxLat ? pt.latitude : maxLat;
      minLng = pt.longitude < minLng ? pt.longitude : minLng;
      maxLng = pt.longitude > maxLng ? pt.longitude : maxLng;
    }
    try {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(minLat, minLng),
            northeast: LatLng(maxLat, maxLng),
          ),
          60,
        ),
      );
    } catch (_) {
      // Degenerate bounds; keep the default camera.
    }
  }

  void _goTo(_AdminCatid p) {
    final pos = _latLngOf(p);
    setState(() {
      _selected = p;
      _query = '';
      _searchCtrl.clear();
    });
    FocusScope.of(context).unfocus();
    if (pos != null && _mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLngZoom(pos, 17));
    }
  }

  Future<void> _openInMapsApp(_AdminCatid p) async {
    final pos = _latLngOf(p);
    if (pos == null) return;
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${pos.latitude},${pos.longitude}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: const Text('Network Map'),
        actions: [
          IconButton(
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
            onPressed: _loading ? null : _load,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
              : (_allowedWorkers.isEmpty
                  ? _buildNoAccess()
                  : Stack(
                      children: [
                        GoogleMap(
                          initialCameraPosition: _fallbackCamera,
                          myLocationEnabled: _locationGranted,
                          myLocationButtonEnabled: _locationGranted,
                          zoomControlsEnabled: false,
                          markers: _markers,
                          onMapCreated: (c) {
                            _mapController = c;
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) => _fitToMarkers());
                          },
                          onTap: (_) => setState(() => _selected = null),
                        ),
                        _buildTopBar(),
                        if (_selected != null) _buildInfoCard(_selected!),
                      ],
                    )),
    );
  }

  Widget _buildNoAccess() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.warning, size: 48, color: Colors.orange),
            const SizedBox(height: 16),
            const Text(
              'No access to any field worker data.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Location: $_location\nPost: $_post\n\nContact Administrator.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black87),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _load, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 12,
      left: 12,
      right: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(12),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search by Building ID, Address or Field Worker',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => setState(() {
                          _query = '';
                          _searchCtrl.clear();
                        }),
                      ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          if (_query.trim().isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 6),
              constraints: const BoxConstraints(maxHeight: 260),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 6)
                ],
              ),
              child: _searchResults.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No matching buildings with a location set.'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final p = _searchResults[i];
                        return ListTile(
                          dense: true,
                          leading:
                              Icon(Icons.location_on, color: _statusColor(p)),
                          title: Text(p.propertyNameAddress ?? 'Building ${p.id}'),
                          subtitle: Text(
                              '${p.place ?? ''}${p.fieldWorkerName != null ? ' · ${p.fieldWorkerName}' : ''}'),
                          onTap: () => _goTo(p),
                        );
                      },
                    ),
            ),
          if (_withoutLocation > 0 && _query.trim().isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$_withoutLocation building${_withoutLocation == 1 ? '' : 's'} '
                'have no location saved, so ${_withoutLocation == 1 ? 'it is' : 'they are'} not shown on the map.',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(_AdminCatid p) {
    final imageUrl =
        (p.images != null && p.images!.isNotEmpty) ? _baseUrl + p.images! : '';

    return Positioned(
      left: 12,
      right: 12,
      bottom: 12,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: imageUrl.isEmpty
                        ? Container(
                            width: 56,
                            height: 56,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.apartment, color: Colors.grey),
                          )
                        : CachedNetworkImage(
                            imageUrl: imageUrl,
                            width: 56,
                            height: 56,
                            fit: BoxFit.cover,
                            errorWidget: (_, __, ___) => Container(
                              width: 56,
                              height: 56,
                              color: Colors.grey.shade200,
                              child:
                                  const Icon(Icons.apartment, color: Colors.grey),
                            ),
                          ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p.propertyNameAddress ?? 'Building ${p.id}',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.black),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if ((p.place ?? '').isNotEmpty)
                          Text(
                            p.place!,
                            style:
                                const TextStyle(color: Colors.black54, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if ((p.fieldWorkerName ?? '').isNotEmpty)
                          Text(
                            'Field worker: ${p.fieldWorkerName}',
                            style:
                                const TextStyle(color: Colors.black45, fontSize: 11),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _selected = null),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openInMapsApp(p),
                      icon: const Icon(Icons.directions),
                      label: const Text('Navigate'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => Future_Property_details(
                              idd: p.id.toString(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      label: const Text('View Details',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
