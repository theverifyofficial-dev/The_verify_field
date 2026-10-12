import 'dart:convert';
import 'package:http/http.dart' as http;

/// One field worker, as returned by `fieldworkar_list.php`.
///
/// `id` is the backend's own numeric id for the worker (not currently used
/// by any of the APIs this roster feeds — those all key by name or
/// number — but kept around since the source API returns it).
class FieldWorker {
  final int id;
  final String name;
  final String number;

  const FieldWorker({
    required this.id,
    required this.name,
    required this.number,
  });

  factory FieldWorker.fromJson(Map<String, dynamic> json) {
    return FieldWorker(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      name: (json['FName'] ?? '').toString().trim(),
      number: (json['FNumber'] ?? '').toString().trim(),
    );
  }

  /// Convenience for screens still built around the old
  /// `List<Map<String, String>>` roster shape (some used key "number",
  /// others "id" — both are included here so either old lookup style
  /// keeps working while a screen is being migrated over).
  Map<String, String> toMap() => {
        "name": name,
        "number": number,
        "id": number,
      };

  @override
  String toString() => 'FieldWorker(id: $id, name: $name, number: $number)';
}

/// Single source of truth for the field-worker roster across the whole
/// app. This REPLACES every hardcoded `fieldWorkers` / `allUsers` /
/// `_allAgents` / `_quickFilters` list that used to be copy-pasted (and
/// drifting out of sync — some had wrong numbers, some were missing
/// workers entirely) across individual screens. Those lists are gone now;
/// every screen that needs the roster reads it from here instead, so
/// adding or removing a field worker on the backend shows up everywhere
/// automatically without another app release.
///
/// Source: `GET fieldworkar_list.php` → `{status, count, data:[{id, FName,
/// FNumber}]}`.
///
/// Usage: call `FieldWorkerDirectory.instance.load()` once (e.g. in
/// `initState`, `await`ed) and then read `.workers` / `.names` / lookups —
/// later `load()` calls on any screen return the already-cached list
/// instantly instead of re-fetching. Use `refresh()` to force a fresh
/// fetch (e.g. on pull-to-refresh).
class FieldWorkerDirectory {
  FieldWorkerDirectory._();

  static final FieldWorkerDirectory instance = FieldWorkerDirectory._();

  static const String _url =
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/Field%20Application/fieldworkar_list.php";

  List<FieldWorker> _workers = [];
  bool _loaded = false;
  Future<List<FieldWorker>>? _inFlight;

  /// The last successfully-fetched roster. Empty until `load()` /
  /// `refresh()` has completed at least once.
  List<FieldWorker> get workers => _workers;

  /// Just the names, in the order the API returned them — handy for
  /// quick-filter chips, dropdown items, etc.
  List<String> get names => _workers.map((w) => w.name).toList();

  /// Old-shape roster (`List<Map<String, String>>`, key "name"/"number"),
  /// for screens migrated to read from here but that still pass the list
  /// straight into code built around that shape.
  List<Map<String, String>> get asMaps =>
      _workers.map((w) => w.toMap()).toList();

  FieldWorker? byNumber(String number) {
    for (final w in _workers) {
      if (w.number == number) return w;
    }
    return null;
  }

  FieldWorker? byName(String name) {
    for (final w in _workers) {
      if (w.name == name) return w;
    }
    return null;
  }

  /// Loads the roster if it hasn't been loaded yet in this app session;
  /// returns the cached list instantly on every later call. This is what
  /// almost every screen should call.
  Future<List<FieldWorker>> load() async {
    if (_loaded) return _workers;
    return refresh();
  }

  /// Always hits the API and replaces the cached roster. On failure (no
  /// network, bad response, etc.) the previous cached list is kept as-is
  /// — a transient blip shouldn't blank out a screen that already loaded
  /// the roster once.
  Future<List<FieldWorker>> refresh() async {
    if (_inFlight != null) return _inFlight!;
    final future = _fetchNow();
    _inFlight = future;
    try {
      return await future;
    } finally {
      _inFlight = null;
    }
  }

  Future<List<FieldWorker>> _fetchNow() async {
    try {
      final response =
          await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 15));
      if (response.statusCode != 200) return _workers;

      final decoded = jsonDecode(response.body);
      final List data =
          (decoded is Map && decoded['data'] is List) ? decoded['data'] : [];

      final parsed = data
          .whereType<Map>()
          .map((e) => FieldWorker.fromJson(e.cast<String, dynamic>()))
          .where((w) => w.name.isNotEmpty && w.number.isNotEmpty)
          .toList();

      if (parsed.isNotEmpty) {
        _workers = parsed;
        _loaded = true;
      }
      return _workers;
    } catch (_) {
      return _workers;
    }
  }
}
