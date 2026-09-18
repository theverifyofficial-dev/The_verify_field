/// Calendar model classes shared between the Admin and Field-Worker calendar
/// code.
///
/// ## Why this file exists
/// `Calender/CalenderForFieldWorker.dart` used to declare these classes
/// itself, and `Calender/CalenderForAdmin.dart` imported that whole 5,000+
/// line screen file just to reach 7 of its model classes (everything else in
/// that file — the admin's own `AgreementTask`, `FutureProperty`,
/// `WebsiteVisit`, etc. — was already independently redeclared inside
/// `CalenderForAdmin.dart` itself; Dart's "a local declaration always wins
/// over an imported one with the same name" rule is what let both files'
/// same-named classes coexist without a compile error).
///
/// Now that the field worker's own calendar SCREEN has been replaced by the
/// merged `Target_And_Tasks/target_and_tasks_home.dart`, the screen half of
/// `CalenderForFieldWorker.dart` was deleted — but these 7 classes are still
/// load-bearing for the Admin calendar, so they were extracted here first.
/// Field names below are copied byte-for-byte from the deleted file; nothing
/// about their JSON parsing changed.
library shared_calendar_models;

class NextCallingItem {
  final String nextCallingDate;
  final String? reason;

  NextCallingItem({
    required this.nextCallingDate,
    this.reason,
  });

  factory NextCallingItem.fromJson(Map<String, dynamic> json) {
    return NextCallingItem(
      nextCallingDate: json['next_calling_date'] ?? '',
      reason: json['reason'],
    );
  }
}

class CallingBuildingData {
  final String image;
  final String address;

  CallingBuildingData({
    required this.image,
    required this.address,
  });

  factory CallingBuildingData.fromJson(Map<String, dynamic> json) {
    return CallingBuildingData(
      image: json['images'] ?? '',
      address: json['property_address_for_fieldworkar'] ?? '',
    );
  }
}

class TenantDemandResponse {
  final String status;
  final List<TenantDemand> data;

  TenantDemandResponse({
    required this.status,
    required this.data,
  });

  factory TenantDemandResponse.fromJson(Map<String, dynamic> json) {
    return TenantDemandResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => TenantDemand.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TenantDemand {
  final int id;
  final String name;
  final String number;
  final String buyRent;
  final String reference;
  final String price;
  final String message;
  final String bhk;
  final String location;
  final String status;
  final String date;
  final String time;
  final String fieldWorkerName;

  TenantDemand({
    required this.id,
    required this.name,
    required this.number,
    required this.buyRent,
    required this.reference,
    required this.price,
    required this.message,
    required this.bhk,
    required this.location,
    required this.status,
    required this.date,
    required this.time,
    required this.fieldWorkerName,
  });

  factory TenantDemand.fromJson(Map<String, dynamic> json) {
    return TenantDemand(
      id: json['id'] ?? 0,
      name: json['Tname'] ?? '',
      number: json['Tnumber'] ?? '',
      buyRent: json['Buy_rent'] ?? '',
      reference: json['Reference'] ?? '',
      price: json['Price'] ?? '',
      message: json['Message'] ?? '',
      bhk: json['Bhk'] ?? '',
      location: json['Location'] ?? '',
      status: json['Status'] ?? '',
      date: json['Date'] ?? '',
      time: json['Time'] ?? '',
      fieldWorkerName: json['assigned_fieldworker_name'] ?? 'Unknown',
    );
  }
}

class UpcomingFlatResponse {
  final String status;
  final List<UpcomingFlat> data;

  UpcomingFlatResponse({required this.status, required this.data});

  factory UpcomingFlatResponse.fromJson(Map<String, dynamic> json) {
    return UpcomingFlatResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => UpcomingFlat.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class UpcomingFlat {
  final int propertyId;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String bhk;
  final String showPrice;
  final String floor;
  final String totalFloor;
  final String furnishedUnfurnished;
  final String parking;
  final String careTakerName;
  final String careTakerNumber;
  final String fieldWarkarName;
  final String field_workar_number;
  final String availableDate;
  final String demoLiveUnlive;
  final String subId;

  UpcomingFlat({
    required this.propertyId,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.bhk,
    required this.showPrice,
    required this.floor,
    required this.totalFloor,
    required this.furnishedUnfurnished,
    required this.parking,
    required this.careTakerName,
    required this.fieldWarkarName,
    required this.careTakerNumber,
    required this.availableDate,
    required this.field_workar_number,
    required this.demoLiveUnlive,
    required this.subId,
  });

  factory UpcomingFlat.fromJson(Map<String, dynamic> json) {
    return UpcomingFlat(
      propertyId: (json['P_id'] as num?)?.toInt() ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      parking: json['parking'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      fieldWarkarName: json['field_warkar_name'] ?? '',
      field_workar_number: json['field_workar_number'].toString(),
      careTakerNumber: json['care_taker_number'] ?? '',
      availableDate: json['dates_for_right_avaiable'] ?? '',
      demoLiveUnlive: json['demo_live_unlive'] ?? '',
      subId: json['subid'].toString(),
    );
  }
}

class LiveFlat {
  final int propertyId;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeOfProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squareFit;
  final String maintenance;
  final String parking;
  final String ageOfProperty;
  final String fieldworkarAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDates;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishedUnfurnished;
  final String fieldWarkarName;
  final String field_workar_number;
  final String liveUnlive;
  final String fieldWorkarNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String careTakerName;
  final String careTakerNumber;
  final int subId;
  final String demoLiveUnlive;

  LiveFlat({
    required this.propertyId,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeOfProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squareFit,
    required this.maintenance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldworkarAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.currentDates,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishedUnfurnished,
    required this.fieldWarkarName,
    required this.field_workar_number,
    required this.liveUnlive,
    required this.fieldWorkarNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subId,
    required this.demoLiveUnlive,
  });

  factory LiveFlat.fromJson(Map<String, dynamic> json) {
    return LiveFlat(
      propertyId: (json['P_id'] as num?)?.toInt() ?? 0,
      subId: (json['subid'] as num?)?.toInt() ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeOfProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squareFit: json['squarefit'] ?? '',
      maintenance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldworkarAddress: json['fieldworkar_address'] ?? '',
      field_workar_number: json['field_workar_number'].toString(),
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDates: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      fieldWarkarName: json['field_warkar_name'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      fieldWorkarNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerCurrentLocation: json['field_worker_current_location'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      demoLiveUnlive: json['demo_live_unlive'] ?? '',
    );
  }
}
