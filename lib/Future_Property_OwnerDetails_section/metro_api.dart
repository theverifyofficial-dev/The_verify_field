import 'package:dio/dio.dart';

class MetroAPI {
  static const base =
      "https://verifyserve.social/Second%20PHP%20FILE/Metro_name/new_metro_name_api.php";

  static const city = "all";
  static const stationLimit = 20;
  static const nearLimit = 200;
  static const radiusM = 1500;

  final dio = Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: 20),
      receiveTimeout: Duration(seconds: 30),
      sendTimeout: Duration(seconds: 20),
      validateStatus: (_) => true, // prevent 404 crash
    ),
  );

  /* ----------------------------------------------------------
     Normalize station/locality list
   ---------------------------------------------------------- */
  List<Map<String, dynamic>> _normalize(dynamic data) {
    try {
      if (data == null) return [];
      if (data is List) return List<Map<String, dynamic>>.from(data);

      if (data is Map && data["items"] is List) {
        return List<Map<String, dynamic>>.from(data["items"]);
      }
    } catch (e) {


      print("❌ Normalize error: $e");
    }
    return [];
  }

  /* ----------------------------------------------------------
     Fetch Metro Stations (autocomplete)
   ---------------------------------------------------------- */
  Future<List<Map<String, dynamic>>> fetchStations(String q) async {
    print("\n🔎 FETCH STATIONS → '$q'");

    final r = await dio.get(base, queryParameters: {
      "q": q,
      "city": city,
      "limit": stationLimit,
    });

    print("Station API → ${r.statusCode}");

    final items = _normalize(r.data);

    print("📌 Station count: ${items.length}");

    return items;
  }

  /* ----------------------------------------------------------
     Fetch Nearby Localities
   ---------------------------------------------------------- */
  Future<List<Map<String, dynamic>>> fetchNearby(String stationName) async {
    print("\n============================");
    print("📍 FETCH NEARBY → '$stationName'");
    print("============================");

    final r = await dio.get(base, queryParameters: {
      "station": stationName, // EXACT NAME selected by user
      "city": city,
      "radius_m": radiusM,
      "limit": nearLimit,
    });

    print("Nearby API → ${r.statusCode}");

    final items = _normalize(r.data);

    print("📍 Nearby count: ${items.length}");

    return items;
  }
}
