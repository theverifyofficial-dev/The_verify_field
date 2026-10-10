import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import '../Controller/Future_property_controller.dart' show Catid;
import 'Add_futureProperty.dart';
import 'Future_property_details.dart';

/// Network Map (field worker): shows every building this field worker has
/// added, as a marker on a Google Map, using the lat/long already captured
/// when the building was added (see Add_futureProperty.dart).
///
/// Scope note: this is the "core map screen" only — no "Mapping Status"
/// tiers (Discovered/Partially/Fully Mapped) or boundary polygons, since
/// no backend field or data source for those exists yet. Marker colour is
/// a straightforward proxy built from real data instead: green = has at
/// least one Live flat, orange = has flats but none Live, grey = no flats
/// added yet. Buildings with no/blank lat-long are skipped on the map but
/// counted in a small banner so nothing looks silently missing.
class FutureNetworkMapPage extends StatefulWidget {
  const FutureNetworkMapPage({super.key});

  @override
  State<FutureNetworkMapPage> createState() => _FutureNetworkMapPageState();
}

class _FutureNetworkMapPageState extends State<FutureNetworkMapPage> {
  static const String _baseUrl =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/";

  String _number = '';
  bool _loading = true;
  String? _error;

  List<Catid> _all = [];
  int _withoutLocation = 0;

  GoogleMapController? _mapController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  Catid? _selected;

  // Sultanpur, South Delhi — current working area (per the reference
  // design); falls back to this only until real markers load.
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

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _number = prefs.getString('number') ?? '';

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final url = Uri.parse(
        "${_baseUrl}future_property_pagination.php"
        "?fieldworkarnumber=$_number&filter=all&page=1&limit=2000",
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body["data"] ?? [];
        final items = data.map((e) => Catid.fromJson(e)).toList();

        int withoutLoc = 0;
        for (final p in items) {
          if (_latLngOf(p) == null) withoutLoc++;
        }

        if (!mounted) return;
        setState(() {
          _all = items;
          _withoutLocation = withoutLoc;
          _loading = false;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) => _fitToMarkers());
      } else {
        if (!mounted) return;
        setState(() {
          _error = 'Could not load buildings (status ${response.statusCode}).';
          _loading = false;
        });
      }
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load buildings. Check your connection and try again.';
        _loading = false;
      });
    }
  }

  LatLng? _latLngOf(Catid p) {
    final lat = double.tryParse(p.latitude ?? '');
    final lng = double.tryParse(p.longitude ?? '');
    if (lat == null || lng == null) return null;
    if (lat == 0 && lng == 0) return null;
    return LatLng(lat, lng);
  }

  List<Catid> get _withLocation =>
      _all.where((p) => _latLngOf(p) != null).toList();

  List<Catid> get _searchResults {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return [];
    return _withLocation.where((p) {
      final name = (p.propertyNameAddress ?? '').toLowerCase();
      final place = (p.place ?? '').toLowerCase();
      final id = p.id.toString();
      return name.contains(q) || place.contains(q) || id.contains(q);
    }).take(20).toList();
  }

  Color _statusColor(Catid p) {
    final live = int.tryParse(p.liveFlats) ?? 0;
    final total = int.tryParse(p.totalFlats) ?? 0;
    if (live > 0) return Colors.green;
    if (total > 0) return Colors.orange;
    return Colors.blueGrey;
  }

  double _markerHue(Catid p) {
    final live = int.tryParse(p.liveFlats) ?? 0;
    final total = int.tryParse(p.totalFlats) ?? 0;
    if (live > 0) return BitmapDescriptor.hueGreen;
    if (total > 0) return BitmapDescriptor.hueOrange;
    return BitmapDescriptor.hueAzure;
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
      // Degenerate bounds (e.g. all points identical) can throw on some
      // devices; the fallback/initial camera stays put, which is fine.
    }
  }

  void _goTo(Catid p) {
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

  Future<void> _openInMapsApp(Catid p) async {
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Add_FutureProperty()),
          );
          if (mounted) _load();
        },
        icon: const Icon(Icons.add_business),
        label: const Text('Add Property'),
        backgroundColor: Colors.black,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildError()
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
                hintText: 'Search by Building ID or Address',
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
                          subtitle: Text(p.place ?? ''),
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

  Widget _buildInfoCard(Catid p) {
    final imageUrl =
        (p.images != null && p.images!.isNotEmpty) ? _baseUrl + p.images! : '';
    final totalFlats = int.tryParse(p.totalFlats) ?? 0;
    final liveFlats = int.tryParse(p.liveFlats) ?? 0;
    final unliveFlats = int.tryParse(p.unliveFlats) ?? 0;

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
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20),
                    onPressed: () => setState(() => _selected = null),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _statChip('$totalFlats Total Units'),
                    const SizedBox(width: 8),
                    _statChip('$liveFlats Live'),
                    const SizedBox(width: 8),
                    _statChip('$unliveFlats Unlive'),
                  ],
                ),
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
                            builder: (_) =>
                                Future_Property_details(idd: p.id.toString()),
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

  Widget _statChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
    );
  }
}
