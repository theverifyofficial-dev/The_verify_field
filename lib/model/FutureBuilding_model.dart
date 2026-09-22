import 'dart:convert';

class FuturePropertyResponse {
  final String status;
  final List<FutureProperty> data;

  FuturePropertyResponse({required this.status, required this.data});

  factory FuturePropertyResponse.fromJson(Map<String, dynamic> json) {
    return FuturePropertyResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FutureProperty.fromJson(e))
          .toList() ??
          [],
    );
  }

  static FuturePropertyResponse fromRawJson(String str) =>
      FuturePropertyResponse.fromJson(json.decode(str));
}

class FutureProperty {
  final int id;

  // Images
  final String? image;

  // Owner & Caretaker
  final String ownerName;
  final String ownerNumber;
  final String caretakerName;
  final String caretakerNumber;

  // Location & Address
  final String place;
  final String localityList;
  final String propertyNameAddress;
  final String propertyAddressForFieldworker;
  final String yourAddress;

  // Property Details
  final String buyRent;
  final String residenceType; // Residence_commercial
  final String bhk;
  final String floorNumber;
  final String squareFeet;
  final String totalFloor;
  final String ageOfProperty;
  final String parking;
  final String lift;
  final String facility;

  // Connectivity
  final String roadSize;
  final String metroName;
  final String metroDistance;
  final String mainMarketDistance;

  // Geo
  final String latitude;
  final String longitude;

  // Field Worker
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  // Date
  final String currentDate;

  FutureProperty({
    required this.id,
    this.image,

    required this.ownerName,
    required this.ownerNumber,
    required this.caretakerName,
    required this.caretakerNumber,

    required this.place,
    required this.localityList,
    required this.propertyNameAddress,
    required this.propertyAddressForFieldworker,
    required this.yourAddress,

    required this.buyRent,
    required this.residenceType,
    required this.bhk,
    required this.floorNumber,
    required this.squareFeet,
    required this.totalFloor,
    required this.ageOfProperty,
    required this.parking,
    required this.lift,
    required this.facility,

    required this.roadSize,
    required this.metroName,
    required this.metroDistance,
    required this.mainMarketDistance,

    required this.latitude,
    required this.longitude,

    required this.fieldWorkerName,
    required this.fieldWorkerNumber,

    required this.currentDate,
  });

  factory FutureProperty.fromJson(Map<String, dynamic> json) {
    return FutureProperty(
      id: (json['id'] as num?)?.toInt() ?? 0,

      image: json['images'],

      // Owner & Caretaker
      ownerName: json['ownername'] ?? '',
      ownerNumber: json['ownernumber'] ?? '',
      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: json['caretakernumber'] ?? '',

      // Location & Address
      place: json['place'] ?? '',
      localityList: json['locality_list'] ?? '',
      propertyNameAddress: json['propertyname_address'] ?? '',
      propertyAddressForFieldworker:
      json['property_address_for_fieldworkar'] ?? '',
      yourAddress: json['your_address'] ?? '',

      // Property Details
      buyRent: json['buy_rent'] ?? '',
      residenceType: json['Residence_commercial'] ?? '',
      bhk: json['select_bhk'] ?? '',
      floorNumber: json['floor_number'] ?? '',
      squareFeet: json['sqyare_feet'] ?? '',
      totalFloor: json['total_floor'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      parking: json['parking'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['facility'] ?? '',

      // Connectivity
      roadSize: json['Road_Size'] ?? '',
      metroName: json['metro_name'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',

      // Geo
      latitude: json['latitude'] ?? '',
      longitude: json['longitude'] ?? '',

      // Field Worker
      fieldWorkerName: json['fieldworkarname'] ?? '',
      fieldWorkerNumber: json['fieldworkarnumber'] ?? '',

      // Date
      currentDate: json['current_date_'] ?? '',
    );
  }
}