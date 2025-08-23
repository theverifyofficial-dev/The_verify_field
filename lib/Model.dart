class Model {
  int? pVRId;
  String? realstateImage;
  String? propertyNumber;
  String? address;
  String? place;
  String? city;
  String? price;
  String? maintenance;
  String? buyRent;
  String? residenceCommercial;
  String? floor;
  String? flat;
  String? date;
  String? lookingProperty;
  String? typeofproperty;
  String? bhkSquarefit;
  String? furnished;
  String? details;
  String? ownername;
  String? ownerNumber;
  String? fieldworkarname;
  String? fieldworkarnumber;
  String? buildingInformation;
  String? parking;
  String? lift;
  String? securityGuard;
  String? govermentMeter;
  String? cCTV;
  String? powerbackup;
  String? watertank;
  String? rooftop;
  String? balcony;
  String? kitchen;
  String? baathroom;
  String? wifi;
  String? waterfilter;
  String? gasMeter;
  String? waterGeyser;
  String? longtitude;
  String? latitude;

  Model(
      {this.pVRId,
        this.realstateImage,
        this.propertyNumber,
        this.address,
        this.place,
        this.city,
        this.price,
        this.maintenance,
        this.buyRent,
        this.residenceCommercial,
        this.floor,
        this.flat,
        this.date,
        this.lookingProperty,
        this.typeofproperty,
        this.bhkSquarefit,
        this.furnished,
        this.details,
        this.ownername,
        this.ownerNumber,
        this.fieldworkarname,
        this.fieldworkarnumber,
        this.buildingInformation,
        this.parking,
        this.lift,
        this.securityGuard,
        this.govermentMeter,
        this.cCTV,
        this.powerbackup,
        this.watertank,
        this.rooftop,
        this.balcony,
        this.kitchen,
        this.baathroom,
        this.wifi,
        this.waterfilter,
        this.gasMeter,
        this.waterGeyser,
        this.longtitude,
        this.latitude});

  Model.fromJson(Map<String, dynamic> json) {
    pVRId = json['PVR_id'];
    realstateImage = json['Realstate_image'];
    propertyNumber = json['Property_Number'];
    address = json['Address_'];
    place = json['Place_'];
    city = json['City'];
    price = json['Price'];
    maintenance = json['maintenance'];
    buyRent = json['Buy_Rent'];
    residenceCommercial = json['Residence_Commercial'];
    floor = json['floor_'];
    flat = json['flat_'];
    date = json['date_'];
    lookingProperty = json['Looking_Property_'];
    typeofproperty = json['Typeofproperty'];
    bhkSquarefit = json['Bhk_Squarefit'];
    furnished = json['Furnished'];
    details = json['Details'];
    ownername = json['Ownername'];
    ownerNumber = json['Owner_number'];
    fieldworkarname = json['fieldworkarname'];
    fieldworkarnumber = json['fieldworkarnumber'];
    buildingInformation = json['Building_information'];
    parking = json['Parking'];
    lift = json['Lift'];
    securityGuard = json['Security_guard'];
    govermentMeter = json['Goverment_meter'];
    cCTV = json['CCTV'];
    powerbackup = json['Powerbackup'];
    watertank = json['Watertank'];
    rooftop = json['Rooftop'];
    balcony = json['balcony'];
    kitchen = json['kitchen'];
    baathroom = json['Baathroom'];
    wifi = json['Wifi'];
    waterfilter = json['Waterfilter'];
    gasMeter = json['Gas_meter'];
    waterGeyser = json['Water_geyser'];
    longtitude = json['Longtitude'];
    latitude = json['Latitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['PVR_id'] = this.pVRId;
    data['Realstate_image'] = this.realstateImage;
    data['Property_Number'] = this.propertyNumber;
    data['Address_'] = this.address;
    data['Place_'] = this.place;
    data['City'] = this.city;
    data['Price'] = this.price;
    data['maintenance'] = this.maintenance;
    data['Buy_Rent'] = this.buyRent;
    data['Residence_Commercial'] = this.residenceCommercial;
    data['floor_'] = this.floor;
    data['flat_'] = this.flat;
    data['date_'] = this.date;
    data['Looking_Property_'] = this.lookingProperty;
    data['Typeofproperty'] = this.typeofproperty;
    data['Bhk_Squarefit'] = this.bhkSquarefit;
    data['Furnished'] = this.furnished;
    data['Details'] = this.details;
    data['Ownername'] = this.ownername;
    data['Owner_number'] = this.ownerNumber;
    data['fieldworkarname'] = this.fieldworkarname;
    data['fieldworkarnumber'] = this.fieldworkarnumber;
    data['Building_information'] = this.buildingInformation;
    data['Parking'] = this.parking;
    data['Lift'] = this.lift;
    data['Security_guard'] = this.securityGuard;
    data['Goverment_meter'] = this.govermentMeter;
    data['CCTV'] = this.cCTV;
    data['Powerbackup'] = this.powerbackup;
    data['Watertank'] = this.watertank;
    data['Rooftop'] = this.rooftop;
    data['balcony'] = this.balcony;
    data['kitchen'] = this.kitchen;
    data['Baathroom'] = this.baathroom;
    data['Wifi'] = this.wifi;
    data['Waterfilter'] = this.waterfilter;
    data['Gas_meter'] = this.gasMeter;
    data['Water_geyser'] = this.waterGeyser;
    data['Longtitude'] = this.longtitude;
    data['Latitude'] = this.latitude;
    return data;
  }
}
