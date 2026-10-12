import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../Field_Workers/field_worker_directory.dart';

/// Gives each field worker a consistent marker pin color across BOTH
/// Network Map screens (field worker + admin), so the same name always
/// gets the same color no matter which screen, filter, or app session
/// you're looking at it from.
///
/// Colors are assigned by each name's position in the shared
/// `FieldWorkerDirectory` roster (not by the order pins happen to load
/// in on a given screen), so they stay stable. A name that shows up on
/// a pin but isn't in that roster (a typo, an old/removed worker, a
/// blank name) still gets a stable color via a hash fallback instead of
/// all collapsing onto one color.
class FieldWorkerMarkerColors {
  FieldWorkerMarkerColors._();

  /// Hues spread out around the color wheel for visual distinctness on
  /// a satellite/road map background. Re-used round-robin once there
  /// are more names than hues.
  static const List<double> _hues = [
    BitmapDescriptor.hueRed,
    BitmapDescriptor.hueBlue,
    BitmapDescriptor.hueGreen,
    BitmapDescriptor.hueOrange,
    BitmapDescriptor.hueViolet,
    BitmapDescriptor.hueCyan,
    BitmapDescriptor.hueMagenta,
    BitmapDescriptor.hueYellow,
    BitmapDescriptor.hueAzure,
    BitmapDescriptor.hueRose,
  ];

  /// Pins with no field worker name at all (blank `fieldworkarname`) —
  /// a dull grey-ish hue so they visually stand out as "unassigned"
  /// rather than looking like a real worker's color.
  static const double _unknownHue = 0.0;

  static final Map<String, BitmapDescriptor> _iconCache = {};

  static double _hashHue(String key) {
    final hash = key.codeUnits.fold<int>(0, (acc, c) => (acc * 31 + c) & 0x7fffffff);
    return _hues[hash % _hues.length];
  }

  /// The hue (0-360) assigned to this name.
  static double hueFor(String name) {
    final key = name.trim();
    if (key.isEmpty) return _unknownHue;

    final roster = FieldWorkerDirectory.instance.names;
    final idx = roster.indexOf(key);
    if (idx != -1) return _hues[idx % _hues.length];

    // Not (or not yet) in the live roster -- still give it a stable
    // color instead of falling back to one shared default.
    return _hashHue(key);
  }

  /// The actual marker icon for this name, cached so repeated lookups
  /// (one per pin, every rebuild) don't keep re-creating the same
  /// `BitmapDescriptor`.
  static BitmapDescriptor iconFor(String name) {
    final key = name.trim();
    return _iconCache.putIfAbsent(
      key,
      () => BitmapDescriptor.defaultMarkerWithHue(hueFor(key)),
    );
  }
}
