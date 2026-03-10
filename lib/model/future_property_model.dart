class PropertyModel {
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

  // 🔥 NEW FIELDS
  final String? localityList;
  final String? isDeleted;
  final int totalFlats;
  final int liveFlats;
  final int unliveFlats;

  PropertyModel({
    required this.id,
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
    this.localityList,
    this.isDeleted,
    required this.totalFlats,
    required this.liveFlats,
    required this.unliveFlats,
  });

  factory PropertyModel.FromJson(Map<String, dynamic> json) {
    return PropertyModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,

      images: json['images']?.toString(),
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

      // 🔥 NEW
      localityList: json['locality_list']?.toString(),
      isDeleted: json['is_deleted']?.toString(),

      totalFlats:
      int.tryParse(json['total_flats']?.toString() ?? '0') ?? 0,
      liveFlats:
      int.tryParse(json['live_flats']?.toString() ?? '0') ?? 0,
      unliveFlats:
      int.tryParse(json['unlive_flats']?.toString() ?? '0') ?? 0,
    );
  }
}

class PropertyModel2 {
  final int id;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String apartmentAddress;
  final String typeofProperty;
  final String bhk;
  final String showPrice;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloor;
  final String balcony;
  final String squarefit;
  final String maintenance;
  final String parking;
  final String ageOfProperty;
  final String fieldWorkerAddress;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String mainMarketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String facility;
  final String furnishing;
  final String fieldWorkerName;
  final String liveUnlive;
  final String fieldWorkerNumber;
  final String registryAndGpa;
  final String loan;
  final String longitude;
  final String latitude;
  final String videoLink;
  final String fieldWorkerCurrentLocation;
  final String caretakerName;
  final String caretakerNumber;
  final int subid;

  PropertyModel2({
    required this.id,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.apartmentAddress,
    required this.typeofProperty,
    required this.bhk,
    required this.showPrice,
    required this.lastPrice,
    required this.askingPrice,
    required this.floor,
    required this.totalFloor,
    required this.balcony,
    required this.squarefit,
    required this.maintenance,
    required this.parking,
    required this.ageOfProperty,
    required this.fieldWorkerAddress,
    required this.roadSize,
    required this.metroDistance,
    required this.highwayDistance,
    required this.mainMarketDistance,
    required this.meter,
    required this.ownerName,
    required this.ownerNumber,
    required this.currentDate,
    required this.availableDate,
    required this.kitchen,
    required this.bathroom,
    required this.lift,
    required this.facility,
    required this.furnishing,
    required this.fieldWorkerName,
    required this.liveUnlive,
    required this.fieldWorkerNumber,
    required this.registryAndGpa,
    required this.loan,
    required this.longitude,
    required this.latitude,
    required this.videoLink,
    required this.fieldWorkerCurrentLocation,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.subid,
  });

  factory PropertyModel2.fromJson(Map<String, dynamic> json) {
    return PropertyModel2(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      apartmentAddress: json['Apartment_Address'] ?? '',
      typeofProperty: json['Typeofproperty'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloor: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      squarefit: json['squarefit'] ?? '',
      maintenance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      ageOfProperty: json['age_of_property'] ?? '',
      fieldWorkerAddress: json['fieldworkar_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      mainMarketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDate: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      facility: json['Facility'] ?? '',
      furnishing: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      registryAndGpa: json['registry_and_gpa'] ?? '',
      loan: json['loan'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
      videoLink: json['video_link'] ?? '',
      fieldWorkerCurrentLocation: json['field_worker_current_location'] ?? '',
      caretakerName: json['care_taker_name'] ?? '',
      caretakerNumber: json['care_taker_number'] ?? '',
      subid: int.tryParse(json['subid'].toString()) ?? 0,
    );
  }
}

