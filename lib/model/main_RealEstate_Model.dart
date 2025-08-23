import 'package:flutter/cupertino.dart';

class PropertyModel {
  PropertyModel({
    this.locations,
    this.propertyNumber,
    this.buyRent,
    this.residenceCommercial,
    this.typeOfProperty,
    this.bhkSpace,
    this.price,
    this.lastPrice,
    this.askingPrice,
    this.floor,
    this.totalFloor,
    this.balcony,
    this.squareFeet,
    this.maintenance,
    this.parking,
    this.buildingInformation,
    this.ageOfProperty,
    this.fieldAddress,
    this.roadSize,
    this.metroDistance,
    this.highwayDistance,
    this.mainMarketDistance,
    this.meter,
    this.ownerName,
    this.ownerNumber,
    this.currentDate,
    this.availableDate,
    this.kitchen,
    this.bathroom,
    this.lift,
    this.securityGuard,
    this.cctvCamera,
    this.guestParking,
    this.terraceGarden,
    this.furnishedUnfurnished,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.longitude,
    this.latitude,
    this.propertyPhoto,
  });

  String? locations;
  String? propertyNumber;
  String? buyRent;
  String? residenceCommercial;
  String? typeOfProperty;
  String? bhkSpace;
  String? price;
  String? lastPrice;
  String? askingPrice;
  String? floor;
  String? totalFloor;
  String? balcony;
  String? squareFeet;
  String? maintenance;
  String? parking;
  String? buildingInformation;
  String? ageOfProperty;
  String? fieldAddress;
  String? roadSize;
  String? metroDistance;
  String? highwayDistance;
  String? mainMarketDistance;
  String? meter;
  String? ownerName;
  String? ownerNumber;
  String? currentDate;
  String? availableDate;
  String? kitchen;
  String? bathroom;
  String? lift;
  String? securityGuard;
  String? cctvCamera;
  String? guestParking;
  String? terraceGarden;
  String? furnishedUnfurnished;
  String? fieldWorkerName;
  String? fieldWorkerNumber;
  String? longitude;
  String? latitude;
  String? propertyPhoto;

  factory PropertyModel.fromJson(Map<String, dynamic> json) {
    return PropertyModel(
      locations: json['locations'] as String?,
      propertyNumber: json['property_number'] as String?,
      buyRent: json['Buy_Rent'] as String?,
      residenceCommercial: json['Residence_Commercial'] as String?,
      typeOfProperty: json['Typeofproperty'] as String?,
      bhkSpace: json['Bhk_space'] as String?,
      price: json['Price'] as String?,
      lastPrice: json['Last_Price'] as String?,
      askingPrice: json['asking_price'] as String?,
      floor: json['Floor_'] as String?,
      totalFloor: json['Total_floor'] as String?,
      balcony: json['Balcony'] as String?,
      squareFeet: json['squarefit'] as String?,
      maintenance: json['maintance'] as String?,
      parking: json['parking'] as String?,
      buildingInformation: json['building_information'] as String?,
      ageOfProperty: json['age_of_property'] as String?,
      fieldAddress: json['field_address'] as String?,
      roadSize: json['Road_Size'] as String?,
      metroDistance: json['metro_distance'] as String?,
      highwayDistance: json['highway_distance'] as String?,
      mainMarketDistance: json['main_market_distance'] as String?,
      meter: json['meter'] as String?,
      ownerName: json['owner_name'] as String?,
      ownerNumber: json['owner_number'] as String?,
      currentDate: json['current_dates'] as String?,
      availableDate: json['available_date'] as String?,
      kitchen: json['kitchen'] as String?,
      bathroom: json['bathroom'] as String?,
      lift: json['lift'] as String?,
      securityGuard: json['security_guard'] as String?,
      cctvCamera: json['cctv_camera'] as String?,
      guestParking: json['guest_parking'] as String?,
      terraceGarden: json['terrace_garden'] as String?,
      furnishedUnfurnished: json['furnished_unfurnished'] as String?,
      fieldWorkerName: json['field_worker_name'] as String?,
      fieldWorkerNumber: json['field_worker_number'] as String?,
      longitude: json['longitude'] as String?,
      latitude: json['latitude'] as String?,
      propertyPhoto: json['property_photo'] != null
          ? "https://theverify.in/photo/" + json['property_photo']
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locations': locations,
      'property_number': propertyNumber,
      'Buy_Rent': buyRent,
      'Residence_Commercial': residenceCommercial,
      'Typeofproperty': typeOfProperty,
      'Bhk_space': bhkSpace,
      'Price': price,
      'Last_Price': lastPrice,
      'asking_price': askingPrice,
      'Floor_': floor,
      'Total_floor': totalFloor,
      'Balcony': balcony,
      'squarefit': squareFeet,
      'maintance': maintenance,
      'parking': parking,
      'building_information': buildingInformation,
      'age_of_property': ageOfProperty,
      'field_address': fieldAddress,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'highway_distance': highwayDistance,
      'main_market_distance': mainMarketDistance,
      'meter': meter,
      'owner_name': ownerName,
      'owner_number': ownerNumber,
      'current_dates': currentDate,
      'available_date': availableDate,
      'kitchen': kitchen,
      'bathroom': bathroom,
      'lift': lift,
      'security_guard': securityGuard,
      'cctv_camera': cctvCamera,
      'guest_parking': guestParking,
      'terrace_garden': terraceGarden,
      'furnished_unfurnished': furnishedUnfurnished,
      'field_worker_name': fieldWorkerName,
      'field_worker_number': fieldWorkerNumber,
      'longitude': longitude,
      'latitude': latitude,
      'property_photo': "https://theverify.in/photo/abouts%20us.jpg",
    };
  }

  void logNullOrEmptyFields() {
    final Map<String, dynamic> fields = toJson();

    fields.forEach((key, value) {
      if (value == null || (value is String && value.trim().isEmpty)) {
        debugPrint('Field "$key" is null or empty.');
      }
    });
  }
}
