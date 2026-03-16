import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ===================== MODEL =====================
class CommercialPropertyData {
  final int? id;
  final String? listing_type;
  final String? property_type;
  final String? location_;
  final String? current_location;
  final String? build_up_area;
  final String? carpet_area;
  final String? price;
  final String? total_floor;
  final String? parking_faciltiy;   // ✅ purani spelling same
  final String? avaible_date;       // ✅ purani spelling same (available nahi)
  final String? dimmensions_;       // ✅ purani spelling same (dimensions nahi)
  final String? height_;
  final String? width_;
  final String? Description;        // ✅ capital D — purana same tha
  final String? field_workar_name;  // ✅ purani spelling same (worker nahi)
  final String? field_workar_number;
  final String? image_;
  final List<String> images;
  final List<String> amenites_;     // ✅ purani spelling same (amenities nahi)
  final String? latitude;
  final String? longitude;

  CommercialPropertyData({
    this.id,
    this.listing_type,
    this.property_type,
    this.location_,
    this.current_location,
    this.build_up_area,
    this.carpet_area,
    this.price,
    this.total_floor,
    this.parking_faciltiy,
    this.avaible_date,
    this.dimmensions_,
    this.height_,
    this.width_,
    this.Description,
    this.field_workar_name,
    this.field_workar_number,
    this.image_,
    this.images = const [],
    this.amenites_ = const [],
    this.latitude,
    this.longitude,
  });

  factory CommercialPropertyData.fromJson(Map<String, dynamic> json) {
    // ===================== IMAGE FIX =====================
    // Purani model mein baseUrl + image_ tha
    // API se sirf filename aata hai, baseUrl add karna padta hai
    const baseUrl =
        "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/";

    String? parseImage(dynamic val) {
      if (val == null) return null;
      final str = val.toString().trim();
      if (str.isEmpty) return null;
      // Agar already full URL hai toh as-is return karo
      if (str.startsWith("http")) return str;
      // Warna baseUrl add karo
      return baseUrl + str;
    }

    List<String> parseImages(dynamic val) {
      if (val == null) return [];
      if (val is List) {
        return val
            .map((e) {
          final str = e.toString().trim();
          if (str.isEmpty) return null;
          if (str.startsWith("http")) return str;
          return baseUrl + str;
        })
            .whereType<String>()
            .toList();
      }
      if (val is String && val.trim().isNotEmpty) {
        final str = val.trim();
        if (str.startsWith("http")) return [str];
        return [baseUrl + str];
      }
      return [];
    }

    List<String> parseAmenities(dynamic val) {
      if (val == null) return [];
      if (val is List) return val.map((e) => e.toString().trim()).toList();
      if (val is String && val.trim().isNotEmpty) {
        return val
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      }
      return [];
    }

    return CommercialPropertyData(
      id: int.tryParse(json['id']?.toString() ?? ''),
      listing_type:        json['listing_type']?.toString(),
      property_type:       json['property_type']?.toString(),
      location_:           json['location_']?.toString(),
      current_location:    json['current_location']?.toString(),
      build_up_area:       json['build_up_area']?.toString(),
      carpet_area:         json['carpet_area']?.toString(),
      price:               json['price']?.toString(),
      total_floor:         json['total_floor']?.toString(),
      parking_faciltiy:    json['parking_faciltiy']?.toString(),
      avaible_date:        json['avaible_date']?.toString(),
      dimmensions_:        json['dimmensions_']?.toString(),
      height_:             json['height_']?.toString(),
      width_:              json['width_']?.toString(),
      Description:         json['Description']?.toString(),
      field_workar_name:   json['field_workar_name']?.toString(),
      field_workar_number: json['field_workar_number']?.toString(),

      // ✅ IMAGE FIX — baseUrl add hoga agar sirf filename aaya
      image_:    parseImage(json['image_']),

      images:    parseImages(json['images']),
      amenites_: parseAmenities(json['amenites_']),
      latitude:  json['latitude']?.toString(),
      longitude: json['longitude']?.toString(),
    );
  }

  // ✅ toMap() — edit form ke liye zaroori tha purani model mein
  Map<String, dynamic> toMap() {
    return {
      "id":                  id,
      "listing_type":        listing_type,
      "property_type":       property_type,
      "parking_faciltiy":    parking_faciltiy,
      "total_floor":         total_floor,
      "location_":           location_,
      "current_location":    current_location,
      "avaible_date":        avaible_date,
      "build_up_area":       build_up_area,
      "carpet_area":         carpet_area,
      "dimmensions_":        dimmensions_,
      "height_":             height_,
      "width_":              width_,
      "price":               price,
      "Description":         Description,
      "longitude":           longitude,
      "latitude":            latitude,
      "field_workar_name":   field_workar_name,
      "field_workar_number": field_workar_number,
      "amenites_":           amenites_.join(","),
    };
  }

  // ✅ copyWith() — purani model mein tha
  CommercialPropertyData copyWith({
    String? image_,
    List<String>? images,
  }) {
    return CommercialPropertyData(
      id:                  id,
      listing_type:        listing_type,
      property_type:       property_type,
      parking_faciltiy:    parking_faciltiy,
      total_floor:         total_floor,
      location_:           location_,
      current_location:    current_location,
      avaible_date:        avaible_date,
      build_up_area:       build_up_area,
      carpet_area:         carpet_area,
      dimmensions_:        dimmensions_,
      height_:             height_,
      width_:              width_,
      price:               price,
      Description:         Description,
      longitude:           longitude,
      latitude:            latitude,
      field_workar_name:   field_workar_name,
      field_workar_number: field_workar_number,
      amenites_:           amenites_,
      image_:              image_ ?? this.image_,
      images:              images ?? this.images,
    );
  }
}

// ===================== CONTROLLER =====================
class CommercialPropertyController extends ChangeNotifier {
  final String fieldWorkerNumber;

  CommercialPropertyController(this.fieldWorkerNumber);

  // --- Pagination State ---
  int currentPage = 1;
  final int limit = 10;
  bool hasMore = true;
  bool isPaginationLoading = false;

  // --- Data ---
  List<CommercialPropertyData> _all = [];
  List<CommercialPropertyData> _filtered = [];
  bool _loading = true;

  // --- Filter ---
  String selectedLabel = "All";
  String currentFilter = "all";

  // --- Summary ---
  int totalRecords = 0;

  // --- Getters ---
  List<CommercialPropertyData> get properties => _filtered;
  bool get isLoading => _loading;
  int get count => _filtered.length;

  // ===================== INIT =====================
  Future<void> initialize() async {
    await refresh();
  }

  // ===================== REFRESH =====================
  Future<void> refresh() async {
    selectedLabel = "All";
    currentFilter = "all";
    _loading = true;
    notifyListeners();

    currentPage = 1;
    hasMore = true;
    _all.clear();
    _filtered.clear();
    totalRecords = 0;

    await _fetchProperties();

    _loading = false;
    notifyListeners();
  }

  // ===================== LOAD MORE =====================
  Future<void> loadMore() async {
    await _fetchProperties(isLoadMore: true);
  }

  // ===================== FETCH =====================
  Future<void> _fetchProperties({bool isLoadMore = false}) async {
    if (isPaginationLoading || !hasMore) return;

    isPaginationLoading = true;
    notifyListeners();

    debugPrint("Commercial Loading Page: $currentPage | Filter: $currentFilter");

    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/commercial_pagination.php"
          "?field_workar_number=$fieldWorkerNumber"
          "&filter=$currentFilter"
          "&page=$currentPage"
          "&limit=$limit",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body["pagination"] != null) {
          totalRecords = body["pagination"]["total_records"] ?? 0;
          debugPrint("Commercial Total Records: $totalRecords");
        }

        if (body["data"] != null) {
          List data = body["data"];

          if (data.isEmpty) {
            hasMore = false;
          } else {
            final newItems =
            data.map((e) => CommercialPropertyData.fromJson(e)).toList();
            _all.addAll(newItems);
            _filtered = List.from(_all);
            currentPage++;
          }
        } else {
          hasMore = false;
        }
      }
    } catch (e) {
      debugPrint("Commercial fetch error: $e");
    }

    isPaginationLoading = false;
    notifyListeners();
  }

  // ===================== APPLY FILTER =====================
  Future<void> applyFilter(String label) async {
    selectedLabel = label;

    currentPage = 1;
    hasMore = true;
    _all.clear();
    _filtered.clear();
    totalRecords = 0;

    switch (label) {
      case "Rent":           currentFilter = "rent";      break;
      case "Sell":           currentFilter = "sell";      break;
      case "Office":         currentFilter = "office";    break;
      case "Retail shop":    currentFilter = "retail";    break;
      case "Warehouse":      currentFilter = "warehouse"; break;
      case "Missing Fields": currentFilter = "missing";   break;
      default:               currentFilter = "all";
    }

    debugPrint("Commercial Filter: $currentFilter");

    _loading = true;
    notifyListeners();

    await _fetchProperties();

    _loading = false;
    notifyListeners();
  }

  // ===================== SEARCH =====================
  Future<void> searchBuilding(String query) async {
    if (query.trim().isEmpty) {
      await refresh();
      return;
    }

    try {
      _loading = true;
      notifyListeners();

      final url = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/main_realestate/search_commercial_property.php"
              "?field_workar_number=$fieldWorkerNumber"
              "&search=$query");

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body["status"] == "success") {
          List data = body["data"];
          _all      = data.map((e) => CommercialPropertyData.fromJson(e)).toList();
          _filtered = List.from(_all);
        } else {
          _all.clear();
          _filtered.clear();
        }
      }
    } catch (e) {
      debugPrint("Commercial search error: $e");
      _all.clear();
      _filtered.clear();
    }

    _loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}