import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import '../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Field_Workers/field_worker_directory.dart';
import 'field_worker_marker_colors.dart';

/// Network Map (admin) — its own standalone section, not part of Future
/// Property. Loads every building once, then lets the admin filter by
/// field worker (a chip row, "All" plus the live roster from
/// FieldWorkerDirectory — fieldworkar_list.php — the same shared roster
/// every other admin screen now uses, rather than names scraped out of
/// this screen's own building data). Same data source as the
/// field-worker version (lib/Network_Map/Network_Map_Page.dart), just
/// opening the read-only admin building-detail page instead, and
/// unfiltered by default.
///
/// Data source: Building_location.php returns {status, count, data:[{id,
/// longitude, latitude, fieldworkarname}]}. IMPORTANT: on this endpoint
/// the "longitude"/"latitude" keys are swapped on SOME rows and correct
/// on others -- not a blanket swap (confirmed against the live data: of
/// the ~414 rows a global "always swapped" assumption used to skip,
/// ~377 actually had the fields the right way round already). Each row
/// is checked both ways below and whichever reading actually lands in
/// India is kept; a row where neither reading does (typically a
/// placeholder where longitude == latitude, i.e. no real location was
/// ever captured) is skipped as genuinely bad data.
class _BuildingLocation {
  final int id;
  final double lat;
  final double lng;
  final String name;
  _BuildingLocation({
    required this.id,
    required this.lat,
    required this.lng,
    required this.name,
  });
}

class AdminNetworkMapPage extends StatefulWidget {
  const AdminNetworkMapPage({super.key});

  @override
  State<AdminNetworkMapPage> createState() => _AdminNetworkMapPageState();
}

class _AdminNetworkMapPageState extends State<AdminNetworkMapPage> {
  static const String _locationsUrl =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Field%20Application/Building_location.php";

  bool _loading = true;
  String? _error;
  List<_BuildingLocation> _allLocations = [];
  int _skipped = 0;

  /// "All" or one of the field worker names from FieldWorkerDirectory.
  String _selectedWorker = 'All';
  List<String> _workerNames = [];

  GoogleMapController? _mapController;
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  bool _locationGranted = false;
  MapType _mapType = MapType.satellite;

  // The building currently "selected" via a pin tap or a search-result
  // tap -- drives the bottom action card (Navigate / Details) so a
  // navigation shortcut is available straight from the map itself, not
  // only from the search-results list. Cleared by tapping empty map
  // space or the card's own close button.
  _BuildingLocation? _selectedLocation;

  void _toggleMapType() {
    setState(() {
      _mapType = _mapType == MapType.satellite ? MapType.normal : MapType.satellite;
    });
  }

  // Sultanpur metro station (Yellow Line), Mehrauli-Gurgaon Road --
  // 28°29'57"N 77°09'41"E per Wikipedia -- used as the real center of
  // the working area (previous version of this screen had the camera
  // centered ~4-5km off from the actual station).
  static const CameraPosition _sultanpurCamera = CameraPosition(
    target: LatLng(28.499167, 77.161389),
    zoom: 13.5,
  );

  // A visual highlight of the current working area, centered on the
  // metro station above. NOT an official administrative boundary (no
  // real Sultanpur ward-boundary polygon is available here) -- the
  // radius is instead derived from the live Building_location.php data
  // itself: 90% of valid building coordinates fall within ~4.6km of
  // the station, with a separate, distinct cluster of buildings
  // (several field workers' entries) sitting ~18km away in what's
  // clearly a different locality, not this working area. 4.5km covers
  // the real Sultanpur cluster without stretching out to include that
  // unrelated far-away cluster.
  Set<Circle> get _areaCircles => {
    Circle(
      circleId: const CircleId('sultanpur_area'),
      center: _sultanpurCamera.target,
      radius: 4500, // meters -- see comment above for how this was derived
      strokeWidth: 2,
      strokeColor: Colors.indigo,
      fillColor: Colors.indigo.withOpacity(0.06),
    ),
  };

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _load();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
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
      // Map still works without the "my location" blue dot/button.
    }
  }

  /// Moves the camera to the device's current GPS position (asking for
  /// permission first if it isn't granted yet) -- the "current location"
  /// button on the map.
  Future<void> _goToMyLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      final granted = permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
      if (mounted) setState(() => _locationGranted = granted);
      if (!granted) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permission is off -- enable it to find your position.'),
          ),
        );
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      if (!mounted) return;
      _mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 16,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not get your current location.')),
      );
    }
  }

  /// Resets the camera back to the default Sultanpur overview -- the
  /// "auto recenter" button, for whenever a 3D tilt or a pan/zoom has
  /// wandered away from the working-area view.
  void _recenter() {
    _mapController?.animateCamera(CameraUpdate.newCameraPosition(_sultanpurCamera));
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await FieldWorkerDirectory.instance.load();
      final names = List<String>.from(FieldWorkerDirectory.instance.names);
      names.sort();
      _workerNames = names;

      final response = await http.get(Uri.parse(_locationsUrl));
      if (response.statusCode != 200) {
        setState(() {
          _error = 'Could not load building locations (status ${response.statusCode}).';
          _loading = false;
        });
        return;
      }

      final body = jsonDecode(response.body);
      final List data = (body is Map && body['data'] is List) ? body['data'] : [];

      final parsed = <_BuildingLocation>[];
      int skipped = 0;
      for (final e in data) {
        if (e is! Map) {
          skipped++;
          continue;
        }
        final id = int.tryParse(e['id']?.toString() ?? '');
        final rawLon = double.tryParse(e['longitude']?.toString() ?? '');
        final rawLat = double.tryParse(e['latitude']?.toString() ?? '');
        if (id == null || rawLon == null || rawLat == null) {
          skipped++;
          continue;
        }
        // The keys aren't swapped on every row -- see class doc comment
        // above. Try the normal reading first, then the swapped one;
        // keep whichever actually lands in India.
        double? lat;
        double? lng;
        if (_inIndia(rawLat, rawLon)) {
          lat = rawLat;
          lng = rawLon;
        } else if (_inIndia(rawLon, rawLat)) {
          lat = rawLon;
          lng = rawLat;
        }
        if (lat == null || lng == null) {
          // Neither reading lands in India -- usually a placeholder row
          // (longitude == latitude, no real location ever captured) or
          // genuinely bad test data.
          skipped++;
          continue;
        }
        final name = e['fieldworkarname']?.toString() ?? '';
        parsed.add(_BuildingLocation(id: id, lat: lat, lng: lng, name: name));
      }

      if (!mounted) return;
      setState(() {
        _allLocations = parsed;
        _skipped = skipped;
        _loading = false;
        // A worker selected before a refresh might no longer be in the
        // roster; fall back to "All" rather than showing an empty map.
        if (_selectedWorker != 'All' && !_workerNames.contains(_selectedWorker)) {
          _selectedWorker = 'All';
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Could not load building locations. Check your connection and try again.';
        _loading = false;
      });
    }
  }

  List<_BuildingLocation> get _locations {
    if (_selectedWorker == 'All') return _allLocations;
    return _allLocations.where((l) => l.name == _selectedWorker).toList();
  }

  List<_BuildingLocation> get _searchResults {
    final q = _query.trim();
    if (q.isEmpty) return [];
    return _locations.where((l) => l.id.toString().contains(q)).take(20).toList();
  }

  void _openDetails(int id) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Future_Property_details(idd: id.toString()),
      ),
    );
  }

  Future<void> _openInMapsApp(_BuildingLocation loc) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${loc.lat},${loc.lng}',
    );
    final ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open Maps.')),
      );
    }
  }

  // Sanity bounds (India) -- used to auto-detect which of the two
  // (lat, lng) readings a row is actually giving us, see _load above.
  static bool _inIndia(double lat, double lng) =>
      lat >= 6 && lat <= 38 && lng >= 68 && lng <= 98;

  Set<Marker> get _markers {
    return _locations.map((l) {
      return Marker(
        markerId: MarkerId(l.id.toString()),
        position: LatLng(l.lat, l.lng),
        // Pin color is consistent per field worker name across both
        // Network Map screens -- see FieldWorkerMarkerColors.
        icon: FieldWorkerMarkerColors.iconFor(l.name),
        // Tapping the pin itself tilts the camera in for a 3D look at
        // that building -- see _view3D below. Tapping the info window
        // bubble (title/snippet) still opens the full detail page.
        onTap: () => _view3D(l),
        // Name shows directly below the id in the marker's info window.
        infoWindow: InfoWindow(
          title: 'Building #${l.id}',
          snippet: l.name.isEmpty ? 'Tap to view details' : l.name,
          onTap: () => _openDetails(l.id),
        ),
      );
    }).toSet();
  }

  void _goTo(_BuildingLocation loc) {
    setState(() {
      _query = '';
      _searchCtrl.clear();
    });
    FocusScope.of(context).unfocus();
    // Selecting a building from search gets the same tilted 3D view as
    // tapping its pin directly, so "select a building" means the same
    // thing everywhere on this screen.
    _view3D(loc);
  }

  /// Tilts and zooms the camera right into this building so Google's
  /// own 3D building models render (the GoogleMap widget doesn't take a
  /// custom 3D model -- this is the standard way to get a 3D look out
  /// of google_maps_flutter: a close, tilted camera). 3D buildings only
  /// render over the normal/road map, not satellite imagery -- in
  /// satellite view this still tilts the camera over the satellite
  /// imagery itself (a tilted aerial look, not extruded 3D buildings).
  /// Deliberately does NOT switch map type on its own: the map should
  /// stay in whichever view (satellite or normal) the user last picked
  /// via the AppBar toggle until they change it themselves, regardless
  /// of tapping pins. Coverage depends on Google's own 3D data for the
  /// area -- most buildings in urban Delhi/NCR have it, but a given
  /// rooftop may still render flat.
  void _view3D(_BuildingLocation loc) {
    setState(() => _selectedLocation = loc);
    _mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(loc.lat, loc.lng),
          zoom: 19,
          tilt: 60,
          bearing: 30,
        ),
      ),
    );
    Future.delayed(const Duration(milliseconds: 400), () {
      _mapController?.showMarkerInfoWindow(MarkerId(loc.id.toString()));
    });
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
            tooltip: _mapType == MapType.satellite
                ? 'Switch to normal map'
                : 'Switch to satellite view',
            icon: Icon(_mapType == MapType.satellite ? Icons.map_outlined : Icons.satellite_alt),
            onPressed: _toggleMapType,
          ),
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
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: _sultanpurCamera,
                      mapType: _mapType,
                      myLocationEnabled: _locationGranted,
                      // Google's own locate button is replaced by our
                      // own "My Location" FAB below, grouped with the
                      // recenter button instead of floating alone.
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      circles: _areaCircles,
                      markers: _markers,
                      onMapCreated: (c) => _mapController = c,
                      // Tapping empty map space dismisses the selected-
                      // building action card below (tapping a marker
                      // itself doesn't reach here -- the marker's own
                      // onTap consumes that tap first).
                      onTap: (_) {
                        if (_selectedLocation != null) {
                          setState(() => _selectedLocation = null);
                        }
                      },
                    ),
                    _buildTopBar(),
                    _buildMapControls(),
                    if (_selectedLocation != null) _buildSelectedLocationCard(),
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

  Widget _buildFilterRow() {
    final options = ['All', ..._workerNames];
    return Material(
      elevation: 3,
      borderRadius: BorderRadius.circular(12),
      color: Colors.white,
      child: SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          itemCount: options.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) {
            final name = options[i];
            final selected = name == _selectedWorker;
            return ChoiceChip(
              label: Text(name),
              selected: selected,
              onSelected: (_) => setState(() {
                _selectedWorker = name;
                _query = '';
                _searchCtrl.clear();
              }),
              selectedColor: Colors.black,
              labelStyle: TextStyle(
                color: selected ? Colors.white : Colors.black87,
                fontSize: 12,
              ),
              backgroundColor: Colors.grey.shade100,
            );
          },
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
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.black),
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search by Building ID',
                hintStyle: const TextStyle(color: Colors.black54),
                prefixIcon: const Icon(Icons.search, color: Colors.black),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
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
          const SizedBox(height: 8),
          _buildFilterRow(),
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
                      child: Text('No building with that ID has a location saved.'),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      itemCount: _searchResults.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, i) {
                        final loc = _searchResults[i];
                        return ListTile(
                          dense: true,
                          leading: const Icon(Icons.location_on, color: Colors.blue),
                          title: Text('Building #${loc.id}'),
                          subtitle: loc.name.isEmpty ? null : Text(loc.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.directions),
                                tooltip: 'Navigate',
                                onPressed: () => _openInMapsApp(loc),
                              ),
                              IconButton(
                                icon: const Icon(Icons.info_outline),
                                tooltip: 'View Details',
                                onPressed: () => _openDetails(loc.id),
                              ),
                            ],
                          ),
                          onTap: () => _goTo(loc),
                        );
                      },
                    ),
            ),
          if (_query.trim().isEmpty)
            Container(
              margin: const EdgeInsets.only(top: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: Text(
                '${_locations.length} building${_locations.length == 1 ? '' : 's'} mapped'
                '${_selectedWorker != 'All' ? ' for $_selectedWorker' : ''}'
                '${_skipped > 0 ? ' · $_skipped skipped (no valid location)' : ''}',
                style: const TextStyle(fontSize: 12, color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }

  /// "My Location" + "Recenter" buttons, grouped bottom-right so they
  /// don't collide with the search bar/filter row/results up top.
  Widget _buildMapControls() {
    return Positioned(
      right: 12,
      bottom: 24,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'adminNetworkMapMyLocationFab',
            tooltip: 'My location',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: _goToMyLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 10),
          FloatingActionButton.small(
            heroTag: 'adminNetworkMapRecenterFab',
            tooltip: 'Recenter on Sultanpur',
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: _recenter,
            child: const Icon(Icons.center_focus_strong),
          ),
        ],
      ),
    );
  }


  /// Bottom action card for whichever building is currently selected
  /// (pin tap or search-result tap) -- lets the user jump straight to
  /// turn-by-turn navigation in the real Google Maps app, or to the
  /// full detail page, without having to go through the search list.
  Widget _buildSelectedLocationCard() {
    final loc = _selectedLocation;
    if (loc == null) return const SizedBox.shrink();
    return Positioned(
      left: 12,
      right: 76,
      bottom: 24,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 4, 8),
          child: Row(
            children: [
              const Icon(Icons.location_on, color: Colors.green),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Building #${loc.id}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (loc.name.isNotEmpty)
                      Text(
                        loc.name,
                        style: const TextStyle(color: Colors.black54, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.directions, color: Colors.blue),
                tooltip: 'Navigate in Google Maps',
                onPressed: () => _openInMapsApp(loc),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: Colors.black87),
                tooltip: 'View Details',
                onPressed: () => _openDetails(loc.id),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black45),
                tooltip: 'Dismiss',
                onPressed: () => setState(() => _selectedLocation = null),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
