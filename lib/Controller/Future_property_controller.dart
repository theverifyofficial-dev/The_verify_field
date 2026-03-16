import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Catid {
  final int id;
  final String? images;
  final String? ownerName;
  final String? ownerNumber;
  final String? caretakerName;
  final String? caretakerNumber;
  final String? place;
  final String? buyRent;
  final String? typeOfProperty;
  final String? selectBhk;
  final String? floorNumber;
  final String? squareFeet;
  final String? propertyNameAddress;
  final String? buildingInformationFacilities;
  final String? propertyAddressForFieldworker;
  final String? ownerVehicleNumber;
  final String? yourAddress;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? currentDate;
  final String? longitude;
  final String? latitude;
  final String? roadSize;
  final String? metroDistance;
  final String? metroName;
  final String? mainMarketDistance;
  final String? ageOfProperty;
  final String? lift;
  final String? parking;
  final String? totalFloor;
  final String? residenceCommercial;
  final String? facility;
  final String totalFlats;
  final String liveFlats;
  final String unliveFlats;

  Catid({
    required this.id,
    required this.totalFlats,
    required this.liveFlats,
    required this.unliveFlats,
    this.images,
    this.ownerName,
    this.ownerNumber,
    this.caretakerName,
    this.caretakerNumber,
    this.place,
    this.buyRent,
    this.typeOfProperty,
    this.selectBhk,
    this.floorNumber,
    this.squareFeet,
    this.propertyNameAddress,
    this.buildingInformationFacilities,
    this.propertyAddressForFieldworker,
    this.ownerVehicleNumber,
    this.yourAddress,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.currentDate,
    this.longitude,
    this.latitude,
    this.roadSize,
    this.metroDistance,
    this.metroName,
    this.mainMarketDistance,
    this.ageOfProperty,
    this.lift,
    this.parking,
    this.totalFloor,
    this.residenceCommercial,
    this.facility,
  });

  factory Catid.fromJson(Map<String, dynamic> json) {
    return Catid(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      images: json['images']?.toString(),
      totalFlats: json['total_flats']?.toString() ?? '0',
      liveFlats: json['live_flats']?.toString() ?? '0',
      unliveFlats: json['unlive_flats']?.toString() ?? '0',
      ownerName: json['ownername']?.toString(),
      ownerNumber: json['ownernumber']?.toString(),
      caretakerName: json['caretakername']?.toString(),
      caretakerNumber: json['caretakernumber']?.toString(),
      place: json['place']?.toString(),
      buyRent: json['buy_rent']?.toString(),
      typeOfProperty: json['typeofproperty']?.toString(),
      selectBhk: json['select_bhk']?.toString(),
      floorNumber: json['floor_number']?.toString(),
      squareFeet: json['sqyare_feet']?.toString(),
      propertyNameAddress: json['propertyname_address']?.toString(),
      buildingInformationFacilities:
      json['building_information_facilitys']?.toString(),
      propertyAddressForFieldworker:
      json['property_address_for_fieldworkar']?.toString(),
      ownerVehicleNumber: json['owner_vehical_number']?.toString(),
      yourAddress: json['your_address']?.toString(),
      fieldWorkerName: json['fieldworkarname']?.toString(),
      fieldWorkerNumber: json['fieldworkarnumber']?.toString(),
      currentDate: json['current_date_']?.toString(),
      longitude: json['longitude']?.toString(),
      latitude: json['latitude']?.toString(),
      roadSize: json['Road_Size']?.toString(),
      metroDistance: json['metro_distance']?.toString(),
      metroName: json['metro_name']?.toString(),
      mainMarketDistance: json['main_market_distance']?.toString(),
      ageOfProperty: json['age_of_property']?.toString(),
      lift: json['lift']?.toString(),
      parking: json['parking']?.toString(),
      totalFloor: json['total_floor']?.toString(),
      residenceCommercial: json['Residence_commercial']?.toString(),
      facility: json['facility']?.toString(),
    );
  }
}

class FuturePropertyController extends ChangeNotifier {
  final String fieldWorkerNumber;

  FuturePropertyController(this.fieldWorkerNumber);

  int currentPage = 1;
  final int limit = 10;
  bool hasMore = true;
  bool isPaginationLoading = false;

  bool isStatusLoading = false;

  int totalFlats = 0;
  int liveFlats = 0;
  int bookFlats = 0;

  List<Catid> _all = [];
  List<Catid> _filtered = [];
  Map<int, Map<String, dynamic>> _statuses = {};

  bool _loading = true;

  List<Catid> get properties => _filtered;
  Map<int, Map<String, dynamic>> get statuses => _statuses;
  bool get isLoading => _loading;
  int get count => _filtered.length;
  int totalRecords = 0;
  Future<void> initialize() async {
    await refresh();
  }

  String selectedLabel = "All";
  Future<void> refresh() async {
    selectedLabel = "All";
    _loading = true;
    notifyListeners();

    currentPage = 1;
    hasMore = true;
    _all.clear();
    _filtered.clear();

    await _fetchProperties();

    _loading = false;
    notifyListeners();

    _fetchFlatsSummary();
  }

  Future<void> loadMore() async {
    await _fetchProperties(isLoadMore: true);
  }

  Future<void> _fetchProperties({bool isLoadMore = false}) async {

    if (isPaginationLoading || !hasMore) return;

    isPaginationLoading = true;
    notifyListeners();

    print("Loading Page: $currentPage | Filter: $currentFilter");

    final url = Uri.parse(
      "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/future_property_pagination.php"
          "?fieldworkarnumber=$fieldWorkerNumber"
          "&filter=$currentFilter"
          "&page=$currentPage"
          "&limit=$limit",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {

      final body = jsonDecode(response.body);

      if (body["pagination"] != null) {
        totalRecords =
            body["pagination"]["total_records"] ?? 0;

        print("Total Records Updated: $totalRecords");
      }

      if (body["data"] != null) {

        List data = body["data"];

        if (data.isEmpty) {
          hasMore = false;
        } else {

          final newItems =
          data.map((e) => Catid.fromJson(e)).toList();

          _all.addAll(newItems);
          _filtered = List.from(_all);

          currentPage++;
        }
      }
    }

    isPaginationLoading = false;
    notifyListeners();
  }
// Controller mein add karo
  void updateSingleProperty(int id) async {
    final index = _all.indexWhere((p) => p.id == id);
    if (index == -1) return;

    final url = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/future_property_pagination.php"
          "?fieldworkarnumber=$fieldWorkerNumber&filter=all&page=1&limit=1&id=$id",
    );
    // ya jo bhi single property fetch API ho
    notifyListeners();
  }

  Future<Map<String, dynamic>> _fetchStatus(int subid) async {
    try {
      final response2 = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/WebService4.asmx/count_api_for_avability_for_building?subid=$subid"));

      final response3 = await http.get(Uri.parse(
          "https://verifyrealestateandservices.in/WebService4.asmx/live_unlive_flat_under_building?subid=$subid"));

      int liveCount = 0;
      int totalFlats = 0;

      if (response2.statusCode == 200) {
        final body = jsonDecode(response2.body);
        if (body is List && body.isNotEmpty) {
          totalFlats = (body[0]['logg'] as num?)?.toInt() ?? 0;
        }
      }

      if (response3.statusCode == 200) {
        final body3 = jsonDecode(response3.body);
        if (body3 is List && body3.isNotEmpty) {
          for (var item in body3) {
            if (item['live_unlive'] == 'Live') {
              liveCount = (item['logs'] as num?)?.toInt() ?? 0;
              break;
            }
          }
        }
      }

      return {"liveCount": liveCount, "totalFlats": totalFlats};
    } catch (_) {
      return {"liveCount": 0, "totalFlats": 0};
    }
  }

  Future<void> _fetchFlatsSummary() async {
    try {
      final totalUrl = Uri.parse(
        'https://verifyrealestateandservices.in/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=$fieldWorkerNumber',
      );

      final liveUrl = Uri.parse(
        'https://verifyrealestateandservices.in/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=$fieldWorkerNumber',
      );

      final totalResponse = await http.get(totalUrl);
      final liveResponse = await http.get(liveUrl);

      if (totalResponse.statusCode == 200) {
        final data = jsonDecode(totalResponse.body);
        totalFlats = data.isNotEmpty ? data[0]['subid'] ?? 0 : 0;
      }

      if (liveResponse.statusCode == 200) {
        final data = jsonDecode(liveResponse.body);
        for (var item in data) {
          if (item['live_unlive'] == "Live") {
            liveFlats = item['subid'] ?? 0;
          } else if (item['live_unlive'] == "Book") {
            bookFlats = item['subid'] ?? 0;
          }
        }
        notifyListeners();
      }
    } catch (_) {
      totalFlats = 0;
      liveFlats = 0;
      bookFlats = 0;
    }
  }
  String currentFilter = "all";

  // 🔥 COMPLETE FILTER SYSTEM
  Future<void> applyFilter(String label) async {

    selectedLabel = label;

    currentPage = 1;
    hasMore = true;
    _all.clear();
    _filtered.clear();
    totalRecords = 0;

    switch (label) {
      case "Buy":
        currentFilter = "buy";
        break;

      case "Rent":
        currentFilter = "rent";
        break;

      case "Commercial":
        currentFilter = "commercial";
        break;

      case "Missing Field":      // 🔥 ADD THIS
        currentFilter = "missing";
        break;

      case "Live":
        currentFilter = "live";
        break;

      case "Unlive":
        currentFilter = "unlive";
        break;

      case "Empty Building":
        currentFilter = "empty";
        break;

      default:
        currentFilter = "all";
    }

    print("Filter Sent To API: $currentFilter");

    await _fetchProperties();

    notifyListeners();
  }

  bool isSearchLoading = false;
  bool isSearching = false;
  String searchQuery = "";
  Future<void> searchBuilding(String query) async {

    print("Searching: $query");

    if (query.trim().isEmpty) {
      await refresh();
      return;
    }

    try {
      _loading = true;
      notifyListeners();

      final url = Uri.parse(
          "https://verifyrealestateandservices.in/Second%20PHP%20FILE/new_future_property_api_with_multile_images_store/search_in_future_builing.php"
              "?fieldworkarnumber=$fieldWorkerNumber"
              "&search=$query"
      );

      print("URL: $url");

      final response = await http.get(url);

      print("Status: ${response.statusCode}");
      print("Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        if (body["status"] == "success") {
          List data = body["data"];

          print("Result count: ${data.length}");

          _all = data.map((e) => Catid.fromJson(e)).toList();
          _filtered = List.from(_all);
        } else {
          print("No success status");
          _all.clear();
          _filtered.clear();
        }
      }

    } catch (e) {
      print("ERROR: $e");
      _all.clear();
      _filtered.clear();
    }

    _loading = false;
    notifyListeners();
  }
}