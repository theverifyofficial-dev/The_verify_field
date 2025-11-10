class NewDemandModel {
  final int? pId;
  final int? subId;
  final String? propertyPhoto;
  final String? locations;
  final String? flatNumber;
  final String? buyRent;
  final String? apartmentAddress;
  final String? typeOfProperty;
  final String? bhk;
  final String? showPrice;
  final String? lastPrice;
  final String? askingPrice;
  final String? floor;
  final String? totalFloor;
  final String? balcony;
  final String? squarefit;
  final String? maintance;
  final String? parking;
  final String? ageOfProperty;
  final String? fieldWorkerAddress;
  final String? roadSize;
  final String? metroDistance;
  final String? highwayDistance;
  final String? mainMarketDistance;
  final String? meter;
  final String? ownerName;
  final String? ownerNumber;
  final String? currentDates;
  final String? availableDate;
  final String? kitchen;
  final String? bathroom;
  final String? lift;
  final String? facility;
  final String? furnishedUnfurnished;
  final String? fieldWorkerName;
  final String? fieldWorkerNumber;
  final String? registryAndGpa;
  final String? loan;
  final String? longitude;
  final String? latitude;
  final String? fieldWorkerCurrentLocation;
  final String? careTakerName;
  final String? careTakerNumber;
  final String? video;

  NewDemandModel({
    this.pId,
    this.subId,
    this.propertyPhoto,
    this.locations,
    this.flatNumber,
    this.buyRent,
    this.apartmentAddress,
    this.typeOfProperty,
    this.bhk,
    this.showPrice,
    this.lastPrice,
    this.askingPrice,
    this.floor,
    this.totalFloor,
    this.balcony,
    this.squarefit,
    this.maintance,
    this.parking,
    this.ageOfProperty,
    this.fieldWorkerAddress,
    this.roadSize,
    this.metroDistance,
    this.highwayDistance,
    this.mainMarketDistance,
    this.meter,
    this.ownerName,
    this.ownerNumber,
    this.currentDates,
    this.availableDate,
    this.kitchen,
    this.bathroom,
    this.lift,
    this.facility,
    this.furnishedUnfurnished,
    this.fieldWorkerName,
    this.fieldWorkerNumber,
    this.registryAndGpa,
    this.loan,
    this.longitude,
    this.latitude,
    this.fieldWorkerCurrentLocation,
    this.careTakerName,
    this.careTakerNumber,
    this.video,
  });

  factory NewDemandModel.fromJson(Map<String, dynamic> json) {
    return NewDemandModel(
      pId: json['P_id'],
      subId: json['subid'],
      propertyPhoto: json['property_photo'],
      locations: json['locations'],
      flatNumber: json['Flat_number'],
      buyRent: json['Buy_Rent'],
      apartmentAddress: json['Apartment_Address'],
      typeOfProperty: json['Typeofproperty'],
      bhk: json['Bhk'],
      showPrice: json['show_Price'],
      lastPrice: json['Last_Price'],
      askingPrice: json['asking_price'],
      floor: json['Floor_'],
      totalFloor: json['Total_floor'],
      balcony: json['Balcony'],
      squarefit: json['squarefit'],
      maintance: json['maintance'],
      parking: json['parking'],
      ageOfProperty: json['age_of_property'],
      fieldWorkerAddress: json['fieldworkar_address'],
      roadSize: json['Road_Size'],
      metroDistance: json['metro_distance'],
      highwayDistance: json['highway_distance'],
      mainMarketDistance: json['main_market_distance'],
      meter: json['meter'],
      ownerName: json['owner_name'],
      ownerNumber: json['owner_number'],
      currentDates: json['current_dates'],
      availableDate: json['available_date'],
      kitchen: json['kitchen'],
      bathroom: json['bathroom'],
      lift: json['lift'],
      facility: json['Facility'],
      furnishedUnfurnished: json['furnished_unfurnished'],
      fieldWorkerName: json['field_warkar_name'],
      fieldWorkerNumber: json['field_workar_number'],
      registryAndGpa: json['registry_and_gpa'],
      loan: json['loan'],
      longitude: json['Longitude'],
      latitude: json['Latitude'],
      fieldWorkerCurrentLocation: json['field_worker_current_location'],
      careTakerName: json['care_taker_name'],
      careTakerNumber: json['care_taker_number'],
      video: json['video_link'],
    );
  }
}
