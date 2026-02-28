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

  Catid({
    required this.id,
    required this.images,
    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.typeOfProperty,
    required this.selectBhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.propertyNameAddress,
    required this.buildingInformationFacilities,
    required this.propertyAddressForFieldworker,
    required this.ownerVehicleNumber,
    required this.yourAddress,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.currentDate,
    required this.longitude,
    required this.latitude,
    required this.roadSize,
    required this.metroDistance,
    required this.metroName,
    required this.mainMarketDistance,
    required this.ageOfProperty,
    required this.lift,
    required this.parking,
    required this.totalFloor,
    required this.residenceCommercial,
    required this.facility,
  });

  factory Catid.FromJson(Map<String, dynamic> json) {
    return Catid(
      id: json['id'] ?? 0,
      images: json['images'],
      ownerName: json['ownername'],
      ownerNumber: json['ownernumber'],
      caretakerName: json['caretakername'],
      caretakerNumber: json['caretakernumber'],
      place: json['place'],
      buyRent: json['buy_rent'],
      typeOfProperty: json['typeofproperty'],
      selectBhk: json['select_bhk'],
      floorNumber: json['floor_number'],
      squareFeet: json['sqyare_feet'],
      propertyNameAddress: json['propertyname_address'],
      buildingInformationFacilities: json['building_information_facilitys'],
      propertyAddressForFieldworker: json['property_address_for_fieldworkar'],
      ownerVehicleNumber: json['owner_vehical_number'],
      yourAddress: json['your_address'],
      fieldWorkerName: json['fieldworkarname'],
      fieldWorkerNumber: json['fieldworkarnumber'],
      currentDate: json['current_date_'],
      longitude: json['longitude'],
      latitude: json['latitude'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      metroName: json['metro_name'],
      mainMarketDistance: json['main_market_distance'],
      ageOfProperty: json['age_of_property'],
      lift: json['lift'],
      parking: json['parking'],
      totalFloor: json['total_floor'],
      residenceCommercial: json['Residence_commercial'],
      facility: json['facility'],
    );
  }
}

class FuturePropertyController extends ChangeNotifier {
  final String fieldWorkerNumber;

  FuturePropertyController(this.fieldWorkerNumber);

  bool isStatusLoading = false;

  int totalFlats = 0;
  int liveFlats = 0;
  int bookFlats = 0;

  List<Catid> _all = [];
  List<Catid> _filtered = [];
  Map<int, Map<String, dynamic>> _statuses = {};

  bool _loading = true;
  String selectedLabel = '';

  List<Catid> get properties => _filtered;
  Map<int, Map<String, dynamic>> get statuses => _statuses;
  bool get isLoading => _loading;

  int get count => _filtered.length;

  Future<void> initialize() async {
    await refresh();
  }

  Future<void> refresh() async {
    _loading = true;
    notifyListeners();

    await _fetchProperties();

    _filtered = List.from(_all);

    _loading = false;
    isStatusLoading = true;   // ← MOVE HERE
    notifyListeners(); // show buildings immediately

    // Background loading (do NOT await)
    _fetchStatusesParallel();
    _fetchFlatsSummary();

  }

  Future<void> _fetchFlatsSummary() async {
    try {
      final totalUrl = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_under_building?field_workar_number=$fieldWorkerNumber',
      );

      final liveUrl = Uri.parse(
        'https://verifyserve.social/WebService4.asmx/GetTotalFlats_Live_under_building?field_workar_number=$fieldWorkerNumber',
      );

      final totalResponse = await http.get(totalUrl);
      final liveResponse = await http.get(liveUrl);

      if (totalResponse.statusCode == 200) {
        final data = jsonDecode(totalResponse.body);
        totalFlats = data.isNotEmpty ? data[0]['subid'] ?? 0 : 0;
      }

      if (liveResponse.statusCode == 200) {
        final data = jsonDecode(liveResponse.body);

        int live = 0;
        int book = 0;

        for (var item in data) {
          if (item['live_unlive'] == "Live") {
            live = item['subid'] ?? 0;
          } else if (item['live_unlive'] == "Book") {
            book = item['subid'] ?? 0;
          }
        }

        liveFlats = live;
        bookFlats = book;

        notifyListeners();
      }
    } catch (_) {
      totalFlats = 0;
      liveFlats = 0;
      bookFlats = 0;
    }
  }

  Future<void> _fetchProperties() async {
    final url = Uri.parse(
      "https://verifyserve.social/WebService4.asmx/display_future_property_by_field_workar_number?fieldworkarnumber=$fieldWorkerNumber",
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      data.sort((a, b) => b['id'].compareTo(a['id']));
      _all = data.map((e) => Catid.FromJson(e)).toList();
    }
  }

  Future<void> _fetchStatusesParallel() async {

    _statuses.clear();

    final futures = _all.map((p) async {
      final status = await _fetchStatus(p.id);
      return MapEntry(p.id, status);
    }).toList();

    final results = await Future.wait(futures);

    for (final entry in results) {
      _statuses[entry.key] = entry.value;
    }
    isStatusLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> _fetchStatus(int subid) async {
    try {
      final response1 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/check_live_flat_in_main_realesate?subid=$subid&live_unlive=Flat"));

      final response2 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/count_api_for_avability_for_building?subid=$subid"));

      final response3 = await http.get(Uri.parse(
          "https://verifyserve.social/WebService4.asmx/live_unlive_flat_under_building?subid=$subid"));

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

      return {
        "liveCount": liveCount,
        "totalFlats": totalFlats,
      };
    } catch (_) {
      return {
        "liveCount": 0,
        "totalFlats": 0,
      };
    }
  }

  void search(String query) {
    if (query.trim().isEmpty) {
      _filtered = List.from(_all);
    } else {
      final lowerQuery = query.toLowerCase();

      _filtered = _all.where((item) {
        return
          item.id.toString().contains(lowerQuery) ||

              (item.propertyNameAddress ?? '')
                  .toLowerCase()
                  .contains(lowerQuery) ||

              (item.ownerName ?? '')
                  .toLowerCase()
                  .contains(lowerQuery) ||

              (item.ownerNumber ?? '')
                  .toLowerCase()
                  .contains(lowerQuery) ||

              (item.caretakerName ?? '')
                  .toLowerCase()
                  .contains(lowerQuery) ||

              (item.caretakerNumber ?? '')
                  .toLowerCase()
                  .contains(lowerQuery) ||

              (item.place ?? '')
                  .toLowerCase()
                  .contains(lowerQuery) ||

              (item.buyRent ?? '')
                  .toLowerCase()
                  .contains(lowerQuery) ||

              (item.residenceCommercial ?? '')
                  .toLowerCase()
                  .contains(lowerQuery);
      }).toList();
    }

    notifyListeners();
  }

  void applyFilter(String label) {
    selectedLabel = label;

    bool isEmpty(String? value) =>
        value == null || value.trim().isEmpty;

    if (label == "Rent" || label == "Buy") {
      _filtered = _all.where((item) {
        return (item.buyRent ?? '').toLowerCase() ==
            label.toLowerCase();
      }).toList();
    }

    else if (label == "Commercial") {
      _filtered = _all.where((item) {
        return (item.residenceCommercial ?? '')
            .toLowerCase() ==
            'commercial';
      }).toList();
    }

    else if (label == "Live") {
      _filtered = _all.where((p) {
        final s = _statuses[p.id];
        return (s?["liveCount"] ?? 0) > 0;
      }).toList();
    }

    else if (label == "Unlive") {
      _filtered = _all.where((p) {
        final s = _statuses[p.id];
        return (s?["liveCount"] ?? 0) == 0;
      }).toList();
    }

    else if (label == "Empty Building") {
      _filtered = _all.where((p) {
        final s = _statuses[p.id];
        return (s?["totalFlats"] ?? 0) == 0;
      }).toList();
    }

    else if (label == "Missing Field") {
      _filtered = _all.where((property) {

        final Map<String, String?> fields = {
          "Images": property.images,
          "Owner Name": property.ownerName,
          "Owner Number": property.ownerNumber,
          "Caretaker Name": property.caretakerName,
          "Caretaker Number": property.caretakerNumber,
          "Place": property.place,
          "Buy/Rent": property.buyRent,
          "Property Address": property.propertyNameAddress,
          "Field Worker Name": property.fieldWorkerName,
          "Field Worker Number": property.fieldWorkerNumber,
          "Longitude": property.longitude,
          "Latitude": property.latitude,
          "Road Size": property.roadSize,
          "Age of Property": property.ageOfProperty,
          "Lift": property.lift,
          "Parking": property.parking,
          "Total Floor": property.totalFloor,
          "Residence/Commercial": property.residenceCommercial,
        };

        return fields.values.any((value) => isEmpty(value));
      }).toList();
    }

    else {
      _filtered = List.from(_all);
    }

    notifyListeners();
  }
}