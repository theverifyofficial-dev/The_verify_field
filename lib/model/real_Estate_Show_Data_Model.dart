class RealEstateModel {
  final String status;
  final List<Property> properties;

  RealEstateModel({
    required this.status,
    required this.properties,
  });

  factory RealEstateModel.fromJson(Map<String, dynamic> json) {
    return RealEstateModel(
      status: json['status'] ?? '',
      properties: (json['data'] as List<dynamic>)
          .map((item) => Property.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'data': properties.map((p) => p.toJson()).toList(),
  };
}

class Property {
  final int id;
  final String photo;
  final String location;
  final String propertyNumber;
  final String buyOrRent;
  final String type;
  final String bhk;
  final String price;
  final String lastPrice;
  final String askingPrice;
  final String floor;
  final String totalFloors;
  final String balcony;
  final String area;
  final String maintenance;
  final String parking;
  final String buildingInfo;
  final String propertyAge;
  final String address;
  final String roadSize;
  final String metroDistance;
  final String highwayDistance;
  final String marketDistance;
  final String meter;
  final String ownerName;
  final String ownerNumber;
  final String currentDate;
  final String availableDate;
  final String kitchen;
  final String bathroom;
  final String lift;
  final String guard;
  final String cctv;
  final String guestParking;
  final String terrace;
  final String furnishing;
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String longitude;
  final String latitude;
  final String category;

  Property({
    this.id = 0,
    this.photo = '',
    this.location = '',
    this.propertyNumber = '',
    this.buyOrRent = '',
    this.type = '',
    this.bhk = '',
    this.price = '',
    this.lastPrice = '',
    this.askingPrice = '',
    this.floor = '',
    this.totalFloors = '',
    this.balcony = '',
    this.area = '',
    this.maintenance = '',
    this.parking = '',
    this.buildingInfo = '',
    this.propertyAge = '',
    this.address = '',
    this.roadSize = '',
    this.metroDistance = '',
    this.highwayDistance = '',
    this.marketDistance = '',
    this.meter = '',
    this.ownerName = '',
    this.ownerNumber = '',
    this.currentDate = '',
    this.availableDate = '',
    this.kitchen = '',
    this.bathroom = '',
    this.lift = '',
    this.guard = '',
    this.cctv = '',
    this.guestParking = '',
    this.terrace = '',
    this.furnishing = '',
    this.fieldWorkerName = '',
    this.fieldWorkerNumber = '',
    this.longitude = '',
    this.latitude = '',
    this.category = '',
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: int.tryParse(json['P_id'].toString()) ?? 0,
      photo: "https://verifyserve.social/PHP_Files/Main_Realestate/"+json['property_photo'] ?? '',
      location: json['locations'] ?? '',
      propertyNumber: json['property_number'] ?? '',
      buyOrRent: json['Buy_Rent'] ?? '',
      category: json['Residence_Commercial'] ?? '',
      type: json['Typeofproperty'] ?? '',
      bhk: json['Bhk_space'] ?? '',
      price: json['Price'] ?? '',
      lastPrice: json['Last_Price'] ?? '',
      askingPrice: json['asking_price'] ?? '',
      floor: json['Floor_'] ?? '',
      totalFloors: json['Total_floor'] ?? '',
      balcony: json['Balcony'] ?? '',
      area: json['squarefit'] ?? '',
      maintenance: json['maintance'] ?? '',
      parking: json['parking'] ?? '',
      buildingInfo: json['building_information'] ?? '',
      propertyAge: json['age_of_property'] ?? '',
      address: json['field_address'] ?? '',
      roadSize: json['Road_Size'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      highwayDistance: json['highway_distance'] ?? '',
      marketDistance: json['main_market_distance'] ?? '',
      meter: json['meter'] ?? '',
      ownerName: json['owner_name'] ?? '',
      ownerNumber: json['owner_number'] ?? '',
      currentDate: json['current_dates'] ?? '',
      availableDate: json['available_date'] ?? '',
      kitchen: json['kitchen'] ?? '',
      bathroom: json['bathroom'] ?? '',
      lift: json['lift'] ?? '',
      guard: json['security_guard'] ?? '',
      cctv: json['cctv_cemera'] ?? '',
      guestParking: json['guest_parking'] ?? '',
      terrace: json['Tarrice_garden'] ?? '',
      furnishing: json['furnished_unfurnished'] ?? '',
      fieldWorkerName: json['field_warkar_name'] ?? '',
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      longitude: json['Longitude'] ?? '',
      latitude: json['Latitude'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'P_id': id,
      'property_photo': photo,
      'locations': location,
      'property_number': propertyNumber,
      'Buy_Rent': buyOrRent,
      'Residence_Commercial': category,
      'Typeofproperty': type,
      'Bhk_space': bhk,
      'Price': price,
      'Last_Price': lastPrice,
      'asking_price': askingPrice,
      'Floor_': floor,
      'Total_floor': totalFloors,
      'Balcony': balcony,
      'squarefit': area,
      'maintance': maintenance,
      'parking': parking,
      'building_information': buildingInfo,
      'age_of_property': propertyAge,
      'field_address': address,
      'Road_Size': roadSize,
      'metro_distance': metroDistance,
      'highway_distance': highwayDistance,
      'main_market_distance': marketDistance,
      'meter': meter,
      'owner_name': ownerName,
      'owner_number': ownerNumber,
      'current_dates': currentDate,
      'available_date': availableDate,
      'kitchen': kitchen,
      'bathroom': bathroom,
      'lift': lift,
      'security_guard': guard,
      'cctv_cemera': cctv,
      'guest_parking': guestParking,
      'Tarrice_garden': terrace,
      'furnished_unfurnished': furnishing,
      'field_warkar_name': fieldWorkerName,
      'field_workar_number': fieldWorkerNumber,
      'Longitude': longitude,
      'Latitude': latitude,
    };
  }
}
