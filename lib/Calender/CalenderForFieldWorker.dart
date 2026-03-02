import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Administrator/Admin_future _property/Future_Property_Details.dart';
import '../Demand_2/Demand_detail.dart';
import '../Future_Property_OwnerDetails_section/Future_Property.dart';
import '../Future_Property_OwnerDetails_section/Future_property_details.dart';
import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';
import '../Future_Property_OwnerDetails_section/Owner_Call/All_contact.dart';
import '../Home_Screen_click/View_All_Details.dart';
import '../Rent Agreement/All_detailpage.dart';
import '../Rent Agreement/details_agreement.dart';
import '../Rent Agreement/history_tab.dart';
import '../Upcoming/Upcoming_details.dart';

class BuildingNextCall {
  final String? nextCallingDate;
  final String? reason;

  BuildingNextCall({
    required this.nextCallingDate,
    required this.reason,
  });

  }

CalendarAddFlatResponse calendarAddFlatResponseFromJson(String str) =>
    CalendarAddFlatResponse.fromJson(json.decode(str));

class CalendarAddFlatResponse {
  final String status;
  final List<CalendarAddFlat> data;

  CalendarAddFlatResponse({
    required this.status,
    required this.data,
  });

  factory CalendarAddFlatResponse.fromJson(Map<String, dynamic> json) {
    return CalendarAddFlatResponse(
      status: json['status'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CalendarAddFlat.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class CalendarAddFlat {
  final int propertyId;
  final String propertyPhoto;
  final String locations;
  final String flatNumber;
  final String buyRent;
  final String residenceCommercial;
  final String apartmentName;
  final String bhk;
  final String showPrice;
  final String floor;
  final String liveUnlive;
  final String careTakerName;
  final String careTakerNumber;
  final String datesForRightAvailable;
  final String subId;
  final String field_warkar_name;
  final String field_workar_number;
  CalendarAddFlat({
    required this.propertyId,
    required this.datesForRightAvailable,
    required this.propertyPhoto,
    required this.locations,
    required this.flatNumber,
    required this.buyRent,
    required this.residenceCommercial,
    required this.apartmentName,
    required this.bhk,
    required this.showPrice,
    required this.floor,
    required this.liveUnlive,
    required this.careTakerName,
    required this.careTakerNumber,
    required this.subId,
    required this.field_warkar_name,
    required this.field_workar_number,
  });

  factory CalendarAddFlat.fromJson(Map<String, dynamic> json) {
    return CalendarAddFlat(
      propertyId: int.tryParse(json['P_id'].toString()) ?? 0,
      propertyPhoto: json['property_photo'] ?? '',
      locations: json['locations'] ?? '',
      flatNumber: json['Flat_number'] ?? '',
      buyRent: json['Buy_Rent'] ?? '',
      residenceCommercial: json['Residence_Commercial'] ?? '',
      apartmentName: json['Apartment_name'] ?? '',
      bhk: json['Bhk'] ?? '',
      showPrice: json['show_Price'] ?? '',
      floor: json['Floor_'] ?? '',
      liveUnlive: json['live_unlive'] ?? '',
      careTakerName: json['care_taker_name'] ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      datesForRightAvailable: json['dates_for_right_avaiable'] ?? '',
      subId: json['subid'] ?? '',
      field_warkar_name:
      json['field_warkar_name']?.toString() ?? '',
      field_workar_number:
      json['field_workar_number']?.toString() ?? '',
    );
  }
}

/// -------- AGREEMENT MODEL --------
class AgreementTaskResponse {
  final String status;
  final List<AgreementTask> data;

  AgreementTaskResponse({required this.status, required this.data});

  factory AgreementTaskResponse.fromJson(Map<String, dynamic> json) {
    return AgreementTaskResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AgreementTask.fromJson(e))
          .toList() ??
          [],
    );
  }

  static AgreementTaskResponse fromRawJson(String str) =>
      AgreementTaskResponse.fromJson(json.decode(str));
}

class AgreementTask {
  final int id;
  final String ownerName;
  final String tenantName;
  final String rentedAddress;
  final String monthlyRent;
  final String bhk;
  final String floor;
  final String agreementType;
  final String status;
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  AgreementTask({
    required this.id,
    required this.ownerName,
    required this.fieldWorkerNumber,
    required this.fieldWorkerName,
    required this.tenantName,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.bhk,
    required this.floor,
    required this.agreementType,
    required this.status,
  });

  factory AgreementTask.fromJson(Map<String, dynamic> json) {
    return AgreementTask(
      // FIELD WORKER
      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',
      id: json['id'] ?? 0,
      ownerName: json['owner_name'] ?? '',
      tenantName: json['tenant_name'] ?? '',
      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      agreementType: json['agreement_type'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
/// -------- ADD FLAT IN FUTURE PROPERTY MODEL --------
class AddFlatResponse {
  final String status;
  final List<AddFlat> data;

  AddFlatResponse({required this.status, required this.data});

  factory AddFlatResponse.fromJson(Map<String, dynamic> json) {
    return AddFlatResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AddFlat.fromJson(e))
          .toList() ??
          [],
    );
  }

  static AddFlatResponse fromRawJson(String str) =>
      AddFlatResponse.fromJson(json.decode(str));
}

class AddFlat {
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
  final String subId;
  final String demoLiveUnlive;

  AddFlat({
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

  factory AddFlat.fromJson(Map<String, dynamic> json) {
    return AddFlat(
      propertyId: json['P_id'] ?? 0,
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
      subId: json['subid'] ?? '',
      demoLiveUnlive: json['demo_live_unlive'] ?? '',
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
      field_workar_number: json['field_workar_number'].toString() ?? '',
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
/// -------- BUILDING MODEL (UPDATED FOR NEW API) --------
class FuturePropertyResponse {
  final bool status;   // ✅ BOOLEAN
  final List<FutureProperty> data;

  FuturePropertyResponse({
    required this.status,
    required this.data,
  });

  factory FuturePropertyResponse.fromJson(Map<String, dynamic> json) {
    return FuturePropertyResponse(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => FutureProperty.fromJson(e))
          .toList() ??
          [],
    );
  }

  static FuturePropertyResponse fromRawJson(String str) =>
      FuturePropertyResponse.fromJson(json.decode(str));
}

LivePropertyResponse LivePropertyResponseFromJson(String str) =>
    LivePropertyResponse.fromJson(json.decode(str));

class LivePropertyResponse {
  final String status;
  final List<LiveFlat> data;

  LivePropertyResponse({required this.status, required this.data});

  factory LivePropertyResponse.fromJson(Map<String, dynamic> json) {
    return LivePropertyResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => LiveFlat.fromJson(e))
          .toList() ??
          [],
    );
  }

  static LivePropertyResponse fromRawJson(String str) =>
      LivePropertyResponse.fromJson(json.decode(str));
}

class FutureProperty {
  final int id;
  final String caretakerName;
  final String caretakerNumber;
  final String place;
  final String buyRent;
  final String propertyName;
  final String propertyAddress;
  final String metroName;
  final String metroDistance;
  final String totalFloor;
  final String facility;
  final String residenceType;
  final String? image;
  final String date;
  // Field Worker
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  FutureProperty({
    required this.id,
    required this.caretakerName,
    required this.caretakerNumber,
    required this.place,
    required this.buyRent,
    required this.propertyName,
    required this.propertyAddress,
    required this.metroName,
    required this.metroDistance,
    required this.totalFloor,
    required this.facility,
    required this.residenceType,
    required this.fieldWorkerNumber,
    required this.fieldWorkerName,
    this.image,
    required this.date,

  });

  factory FutureProperty.fromJson(Map<String, dynamic> json) {
    return FutureProperty(
      id: json['id'] ?? 0,
      caretakerName: json['caretakername'] ?? '',
      caretakerNumber: json['caretakernumber'] ?? '',
      place: json['place'] ?? '',
      buyRent: json['buy_rent'] ?? '',
      propertyName: json['propertyname_address'] ?? '',
      propertyAddress: json['property_address_for_fieldworkar'] ?? '',
      metroName: json['metro_name'] ?? '',
      metroDistance: json['metro_distance'] ?? '',
      totalFloor: json['total_floor'] ?? '',
      facility: json['facility'] ?? '',
      residenceType: json['Residence_commercial'] ?? '',
      image: json['images'],
      date: json['current_date_'] ?? json['date'] ?? '',
      fieldWorkerName: json['fieldworkarname'] ?? '',
      fieldWorkerNumber: json['fieldworkarnumber'] ?? '',
    );
  }
}

/// -------- WEBSITE VISIT MODEL --------
class WebsiteVisitResponse {
  final String status;
  final List<WebsiteVisit> data;

  WebsiteVisitResponse({required this.status, required this.data});

  factory WebsiteVisitResponse.fromJson(Map<String, dynamic> json) {
    return WebsiteVisitResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => WebsiteVisit.fromJson(e))
          .toList() ??
          [],
    );
  }

  static WebsiteVisitResponse fromRawJson(String str) =>
      WebsiteVisitResponse.fromJson(json.decode(str));
}

class WebsiteVisit {
  final int id;
  final String name;
  final String email;
  final String contactNo;
  final String message;

  final String date;
  final String time;
  final int subid;

  // NEW FIELDS
  final String fieldWorkerName;
  final String fieldWorkerNumber;
  final String? bhk;

  WebsiteVisit({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNo,
    required this.message,
    required this.date,
    required this.time,
    required this.subid,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    this.bhk,
  });

  factory WebsiteVisit.fromJson(Map<String, dynamic> json) {
    return WebsiteVisit(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      contactNo: json['contact_no'] ?? '',
      message: json['message'] ?? '',

      date: json['dates'] ?? '',
      time: json['times'] ?? '',
      subid: (json['subid'] as num?)?.toInt() ?? 0,

      // NEW KEYS FROM API
      fieldWorkerNumber: json['field_workar_number'] ?? '',
      fieldWorkerName: json['field_workar_name'] ?? '',
      bhk: json['bhk'],
    );
  }
}

PendingAgreementResponse pendingAgreementResponseFromJson(String str) =>
    PendingAgreementResponse.fromJson(json.decode(str));

class PendingAgreementResponse {
  final String status;
  final List<PendingAgreement> data;

  PendingAgreementResponse({
    required this.status,
    required this.data,
  });

  factory PendingAgreementResponse.fromJson(Map<String, dynamic> json) {
    return PendingAgreementResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PendingAgreement.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class PendingAgreement {
  final int id;
  final String ownerName;
  final String ownerRelation;
  final String ownerRelationPerson;
  final String ownerPermanentAddress;
  final String ownerMobile;
  final String ownerAadhar;

  final String tenantName;
  final String tenantRelation;
  final String tenantRelationPerson;
  final String tenantPermanentAddress;
  final String tenantMobile;
  final String tenantAadhar;

  final String rentedAddress;
  final String monthlyRent;
  final String security;
  final String meter;
  final DateTime? shiftingDate;
  final String maintenance;

  final String? ownerAadharFront;
  final String? ownerAadharBack;
  final String? tenantAadharFront;
  final String? tenantAadharBack;
  final String? tenantImage;

  final String installmentSecurityAmount;
  final DateTime? currentDate;

  final String fieldWorkerName;
  final String fieldWorkerNumber;

  final String propertyId;
  final String parking;
  final String status;
  final String? messages;

  final String bhk;
  final String floor;
  final String agreementType;

  final String? companyName;
  final String? gstNo;
  final String? panNo;
  final String? panPhoto;
  final String? sqft;
  final String? gstPhoto;
  final String? furniture;

  final String agreementPrice;
  final String notaryPrice;
  final bool isPolice;

  PendingAgreement({
    required this.id,
    required this.ownerName,
    required this.ownerRelation,
    required this.ownerRelationPerson,
    required this.ownerPermanentAddress,
    required this.ownerMobile,
    required this.ownerAadhar,
    required this.tenantName,
    required this.tenantRelation,
    required this.tenantRelationPerson,
    required this.tenantPermanentAddress,
    required this.tenantMobile,
    required this.tenantAadhar,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.security,
    required this.meter,
    required this.shiftingDate,
    required this.maintenance,
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    required this.tenantImage,
    required this.installmentSecurityAmount,
    required this.currentDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.propertyId,
    required this.parking,
    required this.status,
    required this.messages,
    required this.bhk,
    required this.floor,
    required this.agreementType,
    required this.companyName,
    required this.gstNo,
    required this.panNo,
    required this.panPhoto,
    required this.sqft,
    required this.gstPhoto,
    required this.furniture,
    required this.agreementPrice,
    required this.notaryPrice,
    required this.isPolice,
  });

  factory PendingAgreement.fromJson(Map<String, dynamic> json) {
    return PendingAgreement(
      id: json['id'] ?? 0,
      ownerName: json['owner_name'] ?? '',
      ownerRelation: json['owner_relation'] ?? '',
      ownerRelationPerson: json['relation_person_name_owner'] ?? '',
      ownerPermanentAddress: json['parmanent_addresss_owner'] ?? '',
      ownerMobile: json['owner_mobile_no'] ?? '',
      ownerAadhar: json['owner_addhar_no'] ?? '',

      tenantName: json['tenant_name'] ?? '',
      tenantRelation: json['tenant_relation'] ?? '',
      tenantRelationPerson: json['relation_person_name_tenant'] ?? '',
      tenantPermanentAddress: json['permanent_address_tenant'] ?? '',
      tenantMobile: json['tenant_mobile_no'] ?? '',
      tenantAadhar: json['tenant_addhar_no'] ?? '',

      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      security: json['securitys'] ?? '',
      meter: json['meter'] ?? '',
      maintenance: json['maintaince'] ?? '',

      ownerAadharFront: json['owner_aadhar_front'],
      ownerAadharBack: json['owner_aadhar_back'],
      tenantAadharFront: json['tenant_aadhar_front'],
      tenantAadharBack: json['tenant_aadhar_back'],
      tenantImage: json['tenant_image'],

      installmentSecurityAmount: json['installment_security_amount'] ?? '',
      shiftingDate: json['shifting_date'] is Map
          ? DateTime.tryParse(json['shifting_date']['date'] ?? '')
          : DateTime.tryParse(json['shifting_date'] ?? ''),

      currentDate: json['current_dates'] is Map
          ? DateTime.tryParse(json['current_dates']['date'] ?? '')
          : DateTime.tryParse(json['current_dates'] ?? ''),


      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',

      propertyId: json['property_id'] ?? '',
      parking: json['parking'] ?? '',
      status: json['status'] ?? '',
      messages: json['messages'],

      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      agreementType: json['agreement_type'] ?? '',

      companyName: json['company_name'],
      gstNo: json['gst_no'],
      panNo: json['pan_no'],
      panPhoto: json['pan_photo'],
      sqft: json['Sqft'],
      gstPhoto: json['gst_photo'],
      furniture: json['furniture'],

      agreementPrice: json['agreement_price'] ?? '',
      notaryPrice: json['notary_price'] ?? '',
      isPolice: json['is_Police'] == "true",
    );
  }
}

AcceptedAgreementResponse acceptedAgreementResponseFromJson(String str) =>
    AcceptedAgreementResponse.fromJson(json.decode(str));

class AcceptedAgreementResponse {
  final String status;
  final List<AcceptedAgreement> data;

  AcceptedAgreementResponse({
    required this.status,
    required this.data,
  });

  factory AcceptedAgreementResponse.fromJson(Map<String, dynamic> json) {
    return AcceptedAgreementResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => AcceptedAgreement.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class AcceptedAgreement {
  final int id;
  final String ownerName;
  final String ownerRelation;
  final String ownerRelationPerson;
  final String ownerPermanentAddress;
  final String ownerMobile;
  final String ownerAadhar;

  final String tenantName;
  final String tenantRelation;
  final String tenantRelationPerson;
  final String tenantPermanentAddress;
  final String tenantMobile;
  final String tenantAadhar;

  final String rentedAddress;
  final String monthlyRent;
  final String security;
  final String meter;
  final DateTime? shiftingDate;
  final String maintenance;

  final String? ownerAadharFront;
  final String? ownerAadharBack;
  final String? tenantAadharFront;
  final String? tenantAadharBack;
  final String? tenantImage;

  final String installmentSecurityAmount;
  final DateTime? currentDate;

  final String fieldWorkerName;
  final String fieldWorkerNumber;

  final String propertyId;
  final String parking;
  final String status;
  final String? messages;

  final String bhk;
  final String floor;
  final String agreementType;

  final String? companyName;
  final String? gstNo;
  final String? panNo;
  final String? panPhoto;
  final String? sqft;
  final String? gstPhoto;
  final String? furniture;

  final String agreementPrice;
  final String notaryPrice;
  final bool isPolice;

  AcceptedAgreement({
    required this.id,
    required this.ownerName,
    required this.ownerRelation,
    required this.ownerRelationPerson,
    required this.ownerPermanentAddress,
    required this.ownerMobile,
    required this.ownerAadhar,
    required this.tenantName,
    required this.tenantRelation,
    required this.tenantRelationPerson,
    required this.tenantPermanentAddress,
    required this.tenantMobile,
    required this.tenantAadhar,
    required this.rentedAddress,
    required this.monthlyRent,
    required this.security,
    required this.meter,
    required this.shiftingDate,
    required this.maintenance,
    required this.ownerAadharFront,
    required this.ownerAadharBack,
    required this.tenantAadharFront,
    required this.tenantAadharBack,
    required this.tenantImage,
    required this.installmentSecurityAmount,
    required this.currentDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
    required this.propertyId,
    required this.parking,
    required this.status,
    required this.messages,
    required this.bhk,
    required this.floor,
    required this.agreementType,
    required this.companyName,
    required this.gstNo,
    required this.panNo,
    required this.panPhoto,
    required this.sqft,
    required this.gstPhoto,
    required this.furniture,
    required this.agreementPrice,
    required this.notaryPrice,
    required this.isPolice,
  });

  factory AcceptedAgreement.fromJson(Map<String, dynamic> json) {
    return AcceptedAgreement(
      id: json['id'] ?? 0,
      ownerName: json['owner_name'] ?? '',
      ownerRelation: json['owner_relation'] ?? '',
      ownerRelationPerson:
      json['relation_person_name_owner'] ?? '',
      ownerPermanentAddress:
      json['parmanent_addresss_owner'] ?? '',
      ownerMobile: json['owner_mobile_no'] ?? '',
      ownerAadhar: json['owner_addhar_no'] ?? '',

      tenantName: json['tenant_name'] ?? '',
      tenantRelation: json['tenant_relation'] ?? '',
      tenantRelationPerson:
      json['relation_person_name_tenant'] ?? '',
      tenantPermanentAddress:
      json['permanent_address_tenant'] ?? '',
      tenantMobile: json['tenant_mobile_no'] ?? '',
      tenantAadhar: json['tenant_addhar_no'] ?? '',

      rentedAddress: json['rented_address'] ?? '',
      monthlyRent: json['monthly_rent'] ?? '',
      security: json['securitys'] ?? '',
      meter: json['meter'] ?? '',
      maintenance: json['maintaince'] ?? '',

      ownerAadharFront: json['owner_aadhar_front'],
      ownerAadharBack: json['owner_aadhar_back'],
      tenantAadharFront: json['tenant_aadhar_front'],
      tenantAadharBack: json['tenant_aadhar_back'],
      tenantImage: json['tenant_image'],

      installmentSecurityAmount:
      json['installment_security_amount'] ?? '',
      shiftingDate: json['shifting_date'] is Map
          ? DateTime.tryParse(json['shifting_date']['date'] ?? '')
          : DateTime.tryParse(json['shifting_date'] ?? ''),

      currentDate: json['current_dates'] is Map
          ? DateTime.tryParse(json['current_dates']['date'] ?? '')
          : DateTime.tryParse(json['current_dates'] ?? ''),


      fieldWorkerName: json['Fieldwarkarname'] ?? '',
      fieldWorkerNumber: json['Fieldwarkarnumber'] ?? '',

      propertyId: json['property_id'] ?? '',
      parking: json['parking'] ?? '',
      status: json['status'] ?? '',
      messages: json['messages'],

      bhk: json['Bhk'] ?? '',
      floor: json['floor'] ?? '',
      agreementType: json['agreement_type'] ?? '',

      companyName: json['company_name'],
      gstNo: json['gst_no'],
      panNo: json['pan_no'],
      panPhoto: json['pan_photo'],
      sqft: json['Sqft'],
      gstPhoto: json['gst_photo'],
      furniture: json['furniture'],

      agreementPrice: json['agreement_price'] ?? '',
      notaryPrice: json['notary_price'] ?? '',
      isPolice: json['is_Police'] == "true",
    );
  }
}
TenantDemandResponse tenantDemandResponseFromJson(String str) =>
    TenantDemandResponse.fromJson(json.decode(str));

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
      fieldWorkerName: json['assigned_fieldworker_name'] ?? '',
    );
  }
}
class BookedTenantVisit {
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
  final String result;
  final String date;
  final String time;
  final String assignedFieldWorkerName;
  final String assignedSubAdminName;
  final String parking;
  final String lift;
  final String furnishedUnfurnished;
  final String familyStructure;
  final String familyMember;
  final String religion;
  final String visitingDate;
  final String shiftingDate;
  final String floor;
  final String countOfPerson;
  final String vehicleType;

  BookedTenantVisit({
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
    required this.result,
    required this.date,
    required this.time,
    required this.assignedFieldWorkerName,
    required this.assignedSubAdminName,
    required this.parking,
    required this.lift,
    required this.furnishedUnfurnished,
    required this.familyStructure,
    required this.familyMember,
    required this.religion,
    required this.visitingDate,
    required this.shiftingDate,
    required this.floor,
    required this.countOfPerson,
    required this.vehicleType,
  });

  factory BookedTenantVisit.fromJson(Map<String, dynamic> json) {
    return BookedTenantVisit(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['Tname'] ?? '',
      number: json['Tnumber'] ?? '',
      buyRent: json['Buy_rent'] ?? '',
      reference: json['Reference'] ?? '',
      price: json['Price'] ?? '',
      message: json['Message'] ?? '',
      bhk: json['Bhk'] ?? '',
      location: json['Location'] ?? '',
      status: json['Status'] ?? '',
      result: json['Result'] ?? '',
      date: json['Date'] ?? '',
      time: json['Time'] ?? '',
      assignedFieldWorkerName: json['assigned_fieldworker_name'] ?? '',
      assignedSubAdminName: json['assigned_subadmin_name'] ?? '',
      parking: json['parking'] ?? '',
      lift: json['lift'] ?? '',
      furnishedUnfurnished: json['furnished_unfurnished'] ?? '',
      familyStructure: json['family_structur'] ?? '',
      familyMember: json['family_member'] ?? '',
      religion: json['religion'] ?? '',
      visitingDate: json['visiting_dates'] ?? '',
      shiftingDate: json['shifting_date'] ?? '',
      floor: json['floor'] ?? '',
      countOfPerson: json['count_of_person'] ?? '',
      vehicleType: json['vichle_type'] ?? '',
    );
  }
}
class BookedTenantVisitResponse {
  final String status;
  final List<BookedTenantVisit> data;

  BookedTenantVisitResponse({
    required this.status,
    required this.data,
  });

  factory BookedTenantVisitResponse.fromJson(Map<String, dynamic> json) {
    return BookedTenantVisitResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BookedTenantVisit.fromJson(e))
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
      field_workar_number: json['field_workar_number'].toString() ?? '',
      careTakerNumber: json['care_taker_number'] ?? '',
      availableDate: json['dates_for_right_avaiable'] ?? '',
      demoLiveUnlive: json['demo_live_unlive'] ?? '',
      subId: json['subid'].toString(),
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
class CallingReminder {
  final int id;
  final String message;
  final String date;
  final String time;
  final String subId;
  final String building_id;
  final String reason;
  final String nextCallingDate;
  final String fieldWorkerName;
  final String fieldWorkerNumber;

  CallingReminder({
    required this.id,
    required this.message,
    required this.date,
    required this.time,
    required this.building_id,
    required this.reason,
    required this.subId,
    required this.nextCallingDate,
    required this.fieldWorkerName,
    required this.fieldWorkerNumber,
  });

  factory CallingReminder.fromJson(Map<String, dynamic> json) {
    return CallingReminder(
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
      date: json['date']?['date'] ?? '',
      time: json['time'] ?? '',
      reason: json['reason'] ?? '',
      subId: json['subid'] ?? '',
      building_id: json['building_id'] ?? '',
      nextCallingDate: json['next_calling_date'] ?? '',
      fieldWorkerName: json['fieldworkar_name'] ?? '',
      fieldWorkerNumber: json['fieldworkar_number'] ?? '',
    );
  }
}

class CallingReminderResponse {
  final String status;
  final List<CallingReminder> data;

  CallingReminderResponse({required this.status, required this.data});

  factory CallingReminderResponse.fromJson(Map<String, dynamic> json) {
    return CallingReminderResponse(
      status: json['status'] ?? 'error',
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CallingReminder.fromJson(e))
          .toList() ??
          [],
    );
  }
}

class NextCallingDateResponse {
  final bool status;
  final List<NextCallingItem> data;

  NextCallingDateResponse({
    required this.status,
    required this.data,
  });

  factory NextCallingDateResponse.fromJson(Map<String, dynamic> json) {
    return NextCallingDateResponse(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NextCallingItem.fromJson(e))
          .toList() ??
          [],
    );
  }
}

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

/// -------- MAIN PAGE --------
class CalendarTaskPage extends StatefulWidget {
  const CalendarTaskPage({super.key});

  @override
  State<CalendarTaskPage> createState() => _CalendarTaskPageState();
}

class _CalendarTaskPageState extends State<CalendarTaskPage> {
  Map<String, NextCallingItem?> _nextCallingCache = {};
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = false;
  List<AgreementTask> _agreements = [];
  List<FutureProperty> _futureProperties = [];
  List<LiveFlat> _liveProperties = [];
  List<AddFlat> _addFlats = [];
  List<TenantDemand> _tenantDemands = [];
  List<BookedTenantVisit> _bookedTenantVisits = [];
  List<UpcomingFlat> _upcomingFlats = [];
  List<CallingReminder> _callingReminders = [];

  // month/year state & lists
  final List<int> _years = List.generate(10, (i) => 2022 + i);
  final List<String> _months = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];
  late int _selectedYear;
  late int _selectedMonth;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  String _calendarView = "Week";
  List<PendingAgreement> _pendingAgreements = [];
  List<AcceptedAgreement> _acceptedAgreements = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedYear = _focusedDay.year;
    _selectedMonth = _focusedDay.month;

    _initUserAndFetch();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadUserName();
    });
  }
  Future<NextCallingItem?> fetchLatestCallingDate(String buildingId) async {
    final url =
        "https://verifyserve.social/Second%20PHP%20FILE/main_realestate/show_next_calling_date_in_building.php?subid=$buildingId";

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);

        if (jsonData["status"] == true &&
            jsonData["data"] != null &&
            jsonData["data"].isNotEmpty) {

          // 🔥 find FIRST valid date
          for (var item in jsonData["data"]) {

            final date = item["next_calling_date"];
            final reason = item["reason"];

            if (date != null &&
                date.toString().isNotEmpty &&
                date.toString().toLowerCase() != "null") {

              return NextCallingItem(
                nextCallingDate: date.toString(),
                reason: (reason == null ||
                    reason.toString().toLowerCase() == "null")
                    ? ""
                    : reason.toString(),
              );
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Fetch latest calling error: $e");
    }

    return null;
  }


  Future<void> _initUserAndFetch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');

    setState(() {
      userName = storedName;
      userNumber = storedNumber;
    });

    if (userNumber != null && userNumber!.isNotEmpty) {
      _fetchOverviewBuildingDetail();
      await _fetchData(_focusedDay);
    } else {
      debugPrint("⚠️ userNumber not found in SharedPreferences");
    }
  }

  String? userName;
  String? userNumber;
  Future<void> loadUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final storedName = prefs.getString('name');
    final storedNumber = prefs.getString('number');

    if (mounted) {
      setState(() {
        userName = storedName;
        userNumber = storedNumber;
      });
    }
  }
  Future<List<CalendarAddFlat>> fetchCalendarAddFlats({
    required String date,
    required String fieldWorkerNumber,
  }) async {
    final url =
        "https://verifyserve.social/Second%20PHP%20FILE/Calender/"
        "task_for_add_flat_in_future_property.php"
        "?current_dates=$date&field_workar_number=$fieldWorkerNumber";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200 && response.body.isNotEmpty) {
      final parsed = calendarAddFlatResponseFromJson(response.body);
      return parsed.data;
    } else {
      return [];
    }
  }
  List<CalendarAddFlat> _calendarAddFlats = [];
  int totalBuildings = 0;
  int buildingsWithFlat = 0;
  int emptyBuildings = 0;

  final Map<String, int> yearlyTargets = {
    "Building": 250,
  };
  Future<void> _fetchOverviewBuildingDetail() async {
    final uri = Uri.parse(
      "https://verifyserve.social/Second%20PHP%20FILE/Target_New_2026/building_over_view.php?fieldworkarnumber=$userNumber",
    );

    final res = await http.get(uri);
    print(res);
    if (res.statusCode != 200 || res.body.isEmpty) return;

    final decoded = jsonDecode(res.body);
    final data = decoded["data"] ?? {};

    if (!mounted) return;

    setState(() {
      totalBuildings =
          int.tryParse(data["total_building"].toString()) ?? 0;

      buildingsWithFlat =
          int.tryParse(data["building_with_flat"].toString()) ?? 0;

      emptyBuildings =
          int.tryParse(data["building_without_flat"].toString()) ?? 0;
    });
  }
  void _openBuildingCalculator() {
    final int target = yearlyTargets["Building"]!;
    final int done = buildingsWithFlat;   // 🔥 IMPORTANT FIX

    final int remaining = (target - done).clamp(0, target);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,   // ✅ IMPORTANT
      backgroundColor: Colors.transparent,
      builder: (_) {
        final isDark = Theme.of(context).brightness == Brightness.dark;

        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          minChildSize: 0.40,
          maxChildSize: 0.90,
          builder: (context, controller) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF111827) : Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(26),
                ),
              ),

              /// ✅ SCROLL FIX
              child: ListView(
                controller: controller,
                children: [

                  /// HEADER
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(.12),
                        ),
                        child: const Icon(
                          Icons.calculate_outlined,
                          color: Colors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Text(
                        "Building Target Intelligence",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "PoppinsBold",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return const FrontPage_FutureProperty();
                      }));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        color: isDark
                            ? Colors.white.withOpacity(.04)
                            : Colors.grey.shade100,
                      ),
                      child: Row(
                        children: [
                          Expanded(child: _miniStat("Total", totalBuildings)),
                          Expanded(child: _miniStat("Without Flats", emptyBuildings)),
                          Expanded(child: _miniStat("With Flats", buildingsWithFlat)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 13),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      gradient: LinearGradient(
                        colors: isDark
                            ? [
                          const Color(0xFF1E3A8A), // deep blue
                          const Color(0xFF2563EB),
                        ]
                            : [
                          const Color(0xFF3B82F6),
                          const Color(0xFF135BEC),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [

                        /// ICON BADGE
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(.18),
                          ),
                          child: const Icon(
                            Icons.flag_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),

                        const SizedBox(width: 12),

                        /// TEXT
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "YEARLY TARGET",
                                style: TextStyle(
                                  fontSize: 10,
                                  letterSpacing: 1.2,
                                  color: Colors.white70,
                                  fontFamily: "PoppinsBold",
                                ),
                              ),

                              const SizedBox(height: 2),

                              Text(
                                "$target Buildings",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: "PoppinsBold",
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// OPTIONAL KPI STYLE
                        Text(
                          "🎯",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withOpacity(.9),
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 13),
                  _calcTile("Per Week", remaining, 52, done, target),
                  _calcTile("Per Month", remaining, 12, done, target),
                  _calcTile("3 Month Pace", remaining, 4, done, target),
                  _calcTile("6 Month Pace", remaining, 2, done, target),
                  _calcTile("8 Month Pace", remaining, 1.5, done, target),
                  _calcTile("10 Month Pace", remaining, 1.2, done, target),

                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }
  Widget _miniStat(String label, int value) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [

        /// VALUE (Primary Focus)
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 18,
            fontFamily: "PoppinsBold",
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),

        const SizedBox(height: 4),

        /// LABEL (Secondary)
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontFamily: "PoppinsMedium",
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _calcTile(
      String label,
      int remaining,
      double divisor,
      int done,
      int target,
      ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final double raw = remaining / divisor;
    final int required = raw.ceil();

    final Color accent = const Color(0xFF3B82F6);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark
            ? Colors.white.withOpacity(.05)
            : Colors.grey.shade100,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// 🔝 HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "PoppinsBold",
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              Text(
                "$required Buildings",
                style:  TextStyle(
                  fontSize: 13,
                  fontFamily: "PoppinsBold",
                  color: accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),



          /// ✅ SIMPLE INSTRUCTION
          Text(
            "Complete $required buildings every $label to reach your target.",
            style: TextStyle(
              fontSize: 11.5,
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),

          const SizedBox(height: 8),

          /// ✅ REMAINING
          Text(
            "Remaining: $remaining Buildings",
            style: TextStyle(
              fontSize: 11,
              fontFamily: "PoppinsMedium",
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
  Future<void> loadAddFlats(DateTime date) async {
    final formatted =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    _calendarAddFlats = await fetchCalendarAddFlats(
      date: formatted,
      fieldWorkerNumber: userNumber ?? '',
    );

    setState(() {});
  }


  String _monthName(int m) => _months[m - 1];
  List<WebsiteVisit> _websiteVisits = [];

  Future<void> _fetchData(DateTime date) async {
    setState(() => _isLoading = true);

    final formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    try {
      await loadAddFlats(date);

      final responses = await Future.wait([
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_agreement_on_date.php?current_dates=$formattedDate&Fieldwarkarnumber=${userNumber}")),
       http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_building.php?current_date_=$formattedDate&fieldworkarnumber=${userNumber}")),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/task_for_website_visit.php?dates=$formattedDate&field_workar_number=${userNumber}")),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/pending_agreement_task.php?current_dates=$formattedDate&Fieldwarkarnumber=$userNumber")),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/accept_agreement_task.php"
                "?current_dates=$formattedDate&Fieldwarkarnumber=$userNumber"
        )),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/"
                "tenant_demand_for_field_task.php"
                "?fieldworker_assigned_at=$formattedDate"
                "&assigned_fieldworker_name=${userName ?? ''}"
        )),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/live_property_task_for_fieldworkar.php?field_workar_number=$userNumber&date_for_target=$formattedDate")),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/"
                "book_visit_in_tenant_demand_for_fields.php"
                "?visiting_dates=$formattedDate"
                "&assigned_fieldworker_name=${Uri.encodeComponent(userName ?? '')}"
        )),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/"
                "upcoming_flat_for_fieldworkar.php"
                "?dates_for_right_avaiable=$formattedDate"
                "&field_workar_number=$userNumber"
        )),
        http.get(Uri.parse(
            "https://verifyserve.social/Second%20PHP%20FILE/Calender/"
                "building_calling_reminder.php"
                "?next_calling_date=$formattedDate"
                "&fieldworkar_number=$userNumber"
        )),


      ]);
      print(userName);
      print(userNumber);
      print(formattedDate);
      AgreementTaskResponse? a;
      FuturePropertyResponse? f;
      WebsiteVisitResponse? w;
      PendingAgreementResponse? p;
      AcceptedAgreementResponse? aa;
      TenantDemandResponse? td;
      LivePropertyResponse? l;

      // ✅ Handle Agreement API safely
      if (responses[0].statusCode == 200 && responses[0].body.isNotEmpty) {
        try {
          a = AgreementTaskResponse.fromRawJson(responses[0].body);
        } catch (e) {
          debugPrint("Agreement API parse error: $e");
          a = AgreementTaskResponse(status: "error", data: []);
        }
      } else {
        debugPrint("Agreement API failed (${responses[0].statusCode})");
        a = AgreementTaskResponse(status: "error", data: []);
      }

      if (responses[1].statusCode == 200 && responses[1].body.isNotEmpty) {
        try {
          f = FuturePropertyResponse.fromRawJson(responses[1].body);

          debugPrint("🟢 BUILDING STATUS: ${f.status}");
          debugPrint("🟢 BUILDING COUNT: ${f.data.length}");

        } catch (e) {
          debugPrint("❌ FutureProperty parse error: $e");
          f = FuturePropertyResponse(status: false, data: []);
        }
      } else {
        debugPrint("❌ FutureProperty API failed (${responses[1].statusCode})");
        f = FuturePropertyResponse(status: false, data: []);
      }

      // ✅ Handle Website Visit API safely
      if (responses[2].statusCode == 200 && responses[2].body.isNotEmpty) {
        try {
          w = WebsiteVisitResponse.fromRawJson(responses[2].body);
        } catch (e) {
          debugPrint("WebsiteVisit parse error: $e");
          w = WebsiteVisitResponse(status: "error", data: []);
        }
      }
      else {
        debugPrint("WebsiteVisit API failed (${responses[2].statusCode})");
        w = WebsiteVisitResponse(status: "error", data: []);
      }
      if (responses[3].statusCode == 200 && responses[3].body.isNotEmpty) {
        try {
          p = pendingAgreementResponseFromJson(responses[3].body);
        } catch (e) {
          debugPrint("Pending Agreement parse error: $e");
          p = PendingAgreementResponse(status: "error", data: []);
        }
      }
      else {
        debugPrint("Pending Agreement API failed (${responses[3].statusCode})");
        p = PendingAgreementResponse(status: "error", data: []);
      }
      if (responses[4].statusCode == 200 && responses[4].body.isNotEmpty) {
        try {
          aa = acceptedAgreementResponseFromJson(responses[4].body);
        } catch (e) {
          debugPrint("Accepted Agreement parse error: $e");
          aa = AcceptedAgreementResponse(status: "error", data: []);
        }
      }

      if (responses[5].statusCode == 200 && responses[5].body.isNotEmpty) {
        try {
          td = tenantDemandResponseFromJson(responses[5].body);
        } catch (e) {
          debugPrint("Tenant Demand parse error: $e");
          td = TenantDemandResponse(status: "error", data: []);
        }
      }
      if (responses[6].statusCode == 200) {
        debugPrint("🟢 LIVE API RAW BODY:");
        debugPrint(responses[6].body);

        try {
          final decoded = jsonDecode(responses[6].body);
          debugPrint("🟢 LIVE API STATUS: ${decoded['status']}");
          debugPrint("🟢 LIVE API DATA TYPE: ${decoded['data'].runtimeType}");
          debugPrint("🟢 LIVE API DATA LENGTH: ${(decoded['data'] as List).length}");

          l = LivePropertyResponse.fromJson(decoded);

          debugPrint("🟢 PARSED LIVE COUNT: ${l.data.length}");
        } catch (e, s) {
          // debugPrint("❌ LIVE PARSE ERROR: $e");
          // debugPrint(s.toString());
          l = LivePropertyResponse(status: "error", data: []);
        }
      } else {
        debugPrint("❌ LIVE API FAILED: ${responses[6].statusCode}");
        l = LivePropertyResponse(status: "error", data: []);
      }

      BookedTenantVisitResponse? bv;

      if (responses[7].statusCode == 200 && responses[7].body.isNotEmpty) {
        try {
          final decoded = jsonDecode(responses[7].body);

          debugPrint("🟢 BOOKED VISIT RAW:");
          debugPrint(responses[7].body);

          if (decoded['status'] == 'success') {
            bv = BookedTenantVisitResponse.fromJson(decoded);
          } else {
            bv = BookedTenantVisitResponse(status: "error", data: []);
          }
        } catch (e) {
          debugPrint("Booked Visit parse error: $e");
          bv = BookedTenantVisitResponse(status: "error", data: []);
        }
      } else {
        bv = BookedTenantVisitResponse(status: "error", data: []);
      }
      UpcomingFlatResponse? uf;

      if (responses[8].statusCode == 200 && responses[8].body.isNotEmpty) {
        try {
          final decoded = jsonDecode(responses[8].body);
          if (decoded['status'] == 'success') {
            uf = UpcomingFlatResponse.fromJson(decoded);
          } else {
            uf = UpcomingFlatResponse(status: "error", data: []);
          }
        } catch (e) {
          debugPrint("Upcoming Flat parse error: $e");
          uf = UpcomingFlatResponse(status: "error", data: []);
        }
      } else {
        uf = UpcomingFlatResponse(status: "error", data: []);
      }
      CallingReminderResponse? cr;

      if (responses[9].statusCode == 200 && responses[9].body.isNotEmpty) {
        try {
          final decoded = jsonDecode(responses[9].body);
          print(responses[9].body);

          print("Calling Reminder Count: ${cr?.data.length}");

          if (decoded['status'] == 'success') {
            cr = CallingReminderResponse.fromJson(decoded);
          } else {
            cr = CallingReminderResponse(status: 'error', data: []);
          }
        } catch (e) {
          debugPrint("Calling Reminder parse error: $e");
          cr = CallingReminderResponse(status: 'error', data: []);
        }
      } else {
        cr = CallingReminderResponse(status: 'error', data: []);
      }

      if (!mounted) return;

      setState(() {
        _agreements = a?.data ?? [];
        _pendingAgreements = p?.data ?? [];
        _tenantDemands = td?.data ?? [];
        _acceptedAgreements = aa?.data ?? [];
        _futureProperties = f?.data ?? [];
        _liveProperties = l?.data ?? [];
        _websiteVisits = w?.data ?? [];
        _bookedTenantVisits = bv?.data ?? [];
        _upcomingFlats = uf?.data ?? [];
        _callingReminders = cr?.data ?? [];
        _isLoading = false;
      });

      await _fetchAllNextCallingDates();

      if (_agreements.isEmpty && _futureProperties.isEmpty && _websiteVisits.isEmpty) {

      }
    } catch (e) {
      debugPrint("❌ Exception fetching data: $e");
      if (!mounted) return;
      setState(() {
        _agreements = [];
        _futureProperties = [];
        _pendingAgreements = [];
        _tenantDemands=[];
        _acceptedAgreements=[];
        _websiteVisits = [];
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error loading data. Please try again."),
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> _fetchAllNextCallingDates() async {
    _nextCallingCache.clear();

    for (var building in _futureProperties) {

      final id = building.id.toString();
      final data = await fetchLatestCallingDate(id);

      print("BUILDING ID: $id");
      print("FETCHED DATA: ${data?.nextCallingDate} | ${data?.reason}");

      _nextCallingCache[id] = data;
    }

    setState(() {});
  }

  Future<void> _showMonthYearPicker(BuildContext context) async {
    int tempYear = _selectedYear;
    int tempMonth = _selectedMonth;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final accent = isDark ? Colors.indigoAccent : Colors.indigo;

    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent, // glassy
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return StatefulBuilder(builder: (context, setModalState) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: bgColor.withOpacity(0.95),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            height: 340,
            child: Column(
              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                      color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                ),
                Text("Select Month & Year",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                const SizedBox(height: 12),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoPicker(
                          scrollController:
                          FixedExtentScrollController(initialItem: tempMonth - 1),
                          itemExtent: 40,
                          looping: true,
                          onSelectedItemChanged: (index) =>
                              setModalState(() => tempMonth = index + 1),
                          children: List.generate(
                            _months.length,
                                (index) => Center(
                              child: Text(_months[index],
                                  style: TextStyle(
                                      color: textColor, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                          scrollController:
                          FixedExtentScrollController(initialItem: _years.indexOf(tempYear)),
                          itemExtent: 40,
                          onSelectedItemChanged: (index) =>
                              setModalState(() => tempYear = _years[index]),
                          children: _years
                              .map((y) => Center(
                            child: Text(y.toString(),
                                style: TextStyle(
                                    color: textColor, fontWeight: FontWeight.w600)),
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _selectedMonth = tempMonth;
                      _selectedYear = tempYear;
                      _focusedDay = DateTime(tempYear, tempMonth, 1);
                      _selectedDay = _focusedDay;
                    });
                    _fetchData(_focusedDay);
                  },
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text("Apply",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: accent,
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 8),
              ],
            ),
          );
        });
      },
    );
  }

  Color _getLiveUnliveColor(String status) {
    switch (status.toLowerCase()) {
      case 'book':
        return Colors.orange;
      case 'live':
        return Colors.green;
      case 'unlive':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  String formatReminderDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd-MMM-yyyy').format(parsed);
    } catch (e) {
      return date;
    }
  }

  Widget _buildCallingReminderCard(CallingReminder r, bool isDark) {
    final String reason = r.reason ?? "";

    final bool isCompleted =
        reason.isNotEmpty;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Future_Property_details(
              idd: r.building_id,

            ),
          ),
        );
      },
      child:  Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient:  LinearGradient(

            colors: isCompleted
                ? [
              const Color(0xFF1B8E3E),   // deep green
              const Color(0xFF4CAF50),   // light green
            ]
                : const [
              Color(0xFFF02626),
              Color(0xFFFF9E0B),
            ],

          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 MESSAGE
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Follow up with the client \nfor the building inquiry.",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color:Colors.white ,
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Building ID: ${r.building_id}",
                    style: TextStyle(
                      fontSize: 11,
                      fontFamily: "PoppinsBold",
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.indigoAccent : Colors.indigo,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 🔹 NEXT CALL DATE
            Text(
              "Next Call Date: ${formatReminderDate(r.nextCallingDate)}",
              style: TextStyle(
                fontFamily: "PoppinsBold",
                fontSize: 12,
                color: Colors.white ,
              ),
            ),

            /// 🔹 REASON (if exists)
            if (reason != null &&
                reason.isNotEmpty &&
                reason.toLowerCase() != "null") ...[
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "Reason: $reason",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 6),

            /// 🔹 FIELD WORKER
            Text(
              "FW: ${r.fieldWorkerName} • ${r.fieldWorkerNumber}",
              style: TextStyle(
                  fontSize: 12,
                  fontFamily: "PoppinsBold",
                  color: Colors.white
              ),
            ),


          ],
        ),
      ),
    );
  }

  Widget _buildAcceptedAgreementCard(AcceptedAgreement t, bool isDark) {
    final Color statusColor = Colors.green;

    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const HistoryTab(defaultTabIndex: 1),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors:[
              Color(0xFFE41B41),
              Color(0xFF1BE4BE),

            ]),
            color: isDark ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ✅ HEADER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.agreementType,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color:  Colors.white ,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Accepted",
                      style: TextStyle(
                        color: statusColor,
                        fontFamily: "PoppinsBold",
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// 👤 OWNER → TENANT
              Text(
                "${t.ownerName}  →  ${t.tenantName}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white ,
                ),
              ),

              const SizedBox(height: 8),

              /// 💰 MINI CHIPS
              Row(
                children: [
                  _miniChip(
                    icon: PhosphorIcons.currency_inr,
                    text: "₹${t.monthlyRent}",
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _miniChip(
                    icon: PhosphorIcons.buildings,
                    text: t.bhk,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _miniChip(
                    icon: PhosphorIcons.star_fill,
                    text: "${t.floor}",
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${ t.fieldWorkerName} • ${t.fieldWorkerNumber}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  Widget _buildTenantDemandCard(TenantDemand t, bool isDark) {
    return  InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  DemandDetail(demandId: t.id.toString()),
            ),
          );
        },
        child:Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Color(0xffD42BA5),
              Color(0xffCBC634),
            ]),
            color: isDark ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔶 HEADER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      t.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color:  Colors.white ,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "Demand",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 11,
                        fontFamily: "PoppinsBold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// 📞 CONTACT + 📍 LOCATION
              Text(
                "${t.number}  •  ${t.location}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              /// 💰 CHIPS
              Row(
                children: [
                  _miniChip(
                    icon: PhosphorIcons.buildings,
                    text: t.bhk,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _miniChip(
                    icon: PhosphorIcons.currency_inr,
                    text: formatIndianCurrency(t.price),
                    isDark: isDark,
                  ),
                ],
              ),

              if (t.message.isNotEmpty) ...[
                const SizedBox(height: 8),

                /// 📝 MESSAGE
                Text(
                  t.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  String formatIndianCurrency(String value) {
    try {
      // Handle ranges like "987500-20000000"
      if (value.contains('-')) {
        final parts = value.split('-');
        final start = NumberFormat.currency(
          locale: 'en_IN',
          symbol: '₹',
          decimalDigits: 0,
        ).format(double.parse(parts[0]));

        final end = NumberFormat.currency(
          locale: 'en_IN',
          symbol: '₹',
          decimalDigits: 0,
        ).format(double.parse(parts[1]));

        return "$start – $end";
      }

      final number = double.parse(value);
      return NumberFormat.currency(
        locale: 'en_IN',
        symbol: '₹',
        decimalDigits: 0,
      ).format(number);
    } catch (e) {
      return value; // fallback if parsing fails
    }
  }

  Widget _responsiveCard({
    required Widget child,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        if (width >= 900) {
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: child,
            ),
          );
        }

        // Normal phone
        if (width >= 600) {
          return Center(
            child: SizedBox(width: 520, child: child),
          );
        }

        // Small phone
        return child;
      },
    );
  }

  Widget _buildBookedTenantVisitCard(BookedTenantVisit v, bool isDark) {
    final statusColor =
    v.status.toLowerCase() == 'progressing' ? Colors.orange : Colors.green;

    return _responsiveCard(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)
          => DemandDetail(demandId: v.id.toString(),),
          ));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [
                  const Color(0xFF10B981),
                  const Color(0xFF047857)
                ]
            ),

            color: isDark ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 HEADER
              Row(
                children: [
                  Expanded(
                    child: Text(
                      v.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "PoppinsBold",
                        fontWeight: FontWeight.bold,
                        color:  Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      v.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontFamily: "PoppinsBold",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              /// 📞 NUMBER + 📍 LOCATION
              Text(
                "${v.number}  •  ${v.location}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: "PoppinsBold",
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 8),

              /// 🏠 BHK + 💰 PRICE
              Row(
                children: [
                  _miniChip(
                    icon: PhosphorIcons.bed,
                    text: v.bhk,
                    isDark: isDark,
                  ),
                  const SizedBox(width: 6),
                  _miniChip(
                    icon: PhosphorIcons.currency_inr,
                    text: v.price,
                    isDark: isDark,
                  ),
                ],
              ),

              const SizedBox(height: 8),

              /// 🕒 VISIT DATE & TIME
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Reference: ${v.reference}",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "PoppinsBold",
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      v.time,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.indigo,
                      ),
                    ),
                  ),
                ],
              ),

              /// 📝 MESSAGE (optional)
              if (v.message.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  v.message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    fontFamily: "PoppinsBold",
                    color: Colors.white ,
                  ),
                ),
              ],

              const SizedBox(height: 6),

              /// 👤 ASSIGNED FIELD WORKER
              Text(
                "FW: ${v.assignedFieldWorkerName} ",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "PoppinsBold",
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Enhanced Agreement Card with better design
  Widget _buildAgreementCard(AgreementTask t, bool isDark) {
    final Color statusColor = _getStatusColor(t.status);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AllDetailpage(agreementId: t.id.toString()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [

                const Color(0xFFDC2626),
                const Color(0xFFEF4444),
              ]
          ),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.agreementType,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: "PoppinsBold",
                      color: Colors.white,
                    ),
                  ),
                ),

              ],
            ),

            const SizedBox(height: 6),

            /// 👤 OWNER → TENANT
            Text(
              "${t.ownerName}  →  ${t.tenantName}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white ,
              ),
            ),

            const SizedBox(height: 8),

            /// 💰 CHIPS
            Row(
              children: [
                _miniChip(
                  icon: PhosphorIcons.currency_inr,
                  text: "₹${t.monthlyRent}",
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.buildings,
                  text: t.bhk,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.star_fill,
                  text: "${t.floor}",
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Text(
                    "${ t.fieldWorkerName} • ${t.fieldWorkerNumber}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingAgreementCard(PendingAgreement t, bool isDark) {
    final Color statusColor = Colors.orange;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AgreementDetailPage(
              agreementId: t.id.toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffA75875),
            Color(0xff58A78A),
          ]),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔶 HEADER ROW
            Row(
              children: [
                Expanded(
                  child: Text(
                    t.agreementType,
                    style: TextStyle(
                      fontSize: 14,
                      fontFamily: "PoppinsBold",
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      color: statusColor,
                      fontFamily: "PoppinsBold",
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 👤 OWNER → TENANT (INLINE)
            Text(
              "${t.ownerName}  →  ${t.tenantName}",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 8),

            /// 💰 CHIPS ROW
            Row(
              children: [
                _miniChip(
                  icon: PhosphorIcons.currency_inr,
                  text: "₹${t.monthlyRent}",
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.buildings,
                  text: t.bhk,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.star_fill,
                  text: "${t.floor}",
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Expanded(
                  child: Text(
                    "${ t.fieldWorkerName} • ${t.fieldWorkerNumber}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniChip({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: isDark ? Colors.white60 : Colors.grey.shade600,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuturePropertyCard(FutureProperty f, bool isDark) {
    final apiData = _nextCallingCache[f.id.toString()];
    final nextDate = apiData?.nextCallingDate;
    final String reason = apiData?.reason ?? "";

    final bool isCompleted =
        reason.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => Future_Property_details(
              idd: f.id.toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isCompleted
                ? [
              const Color(0xFF1B8E3E),   // deep green
              const Color(0xFF4CAF50),   // light green
            ]
                : const [
              Color(0xFFF02626),
              Color(0xFFFF9E0B),
            ],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// 🔹 TITLE + BUY/RENT
            Row(
              children: [
                const Icon(
                  PhosphorIcons.buildings,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    f.propertyAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f.buyRent,
                    style: const TextStyle(
                      fontFamily: "poppinsBold",
                      color: Colors.blue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 📍 LOCATION
            Text(
              "${f.place}  •  ${f.residenceType}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// 🚆 METRO + FLOORS
            Row(
              children: [
                if (f.metroName.isNotEmpty)
                  _miniChip(
                    icon: PhosphorIcons.train,
                    text: "${f.metroName} ${f.metroDistance}",
                    isDark: isDark,
                  ),
                if (f.metroName.isNotEmpty) const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.star_fill,
                  text: "${f.totalFloor}",
                  isDark: isDark,
                ),
              ],
            ),

            /// ✅ NEXT CALL SECTION (Only if valid)
            if (nextDate != null &&
                nextDate.isNotEmpty &&
                nextDate.toLowerCase() != "null") ...[

              const SizedBox(height: 8),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Next Call: ${formatDate(nextDate)}",
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              /// 🔹 REASON (if exists)
              if (reason != null &&
                  reason.isNotEmpty &&
                  reason.toLowerCase() != "null") ...[
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.info_outline,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          "Reason: $reason",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],

            /// 🏢 FIELDWORKER
            if (f.fieldWorkerName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                "${f.fieldWorkerName} • ${f.fieldWorkerNumber}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingFlatCard(UpcomingFlat f, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => UpcomingDetailsPage(
              id: f.propertyId,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFF06B6D4),
            const Color(0xFFDC2626),
          ]),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            Row(
              children: [
                Expanded(
                  child: Text(
                    f.bhk,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    "Upcoming",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontFamily: "PoppinsBold",

                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            Text(
              "Flat ${f.flatNumber} • ${f.locations}",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "PoppinsBold",
                fontWeight: FontWeight.w600,
                color: Colors.white ,
              ),
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                _miniChip(
                  icon: PhosphorIcons.currency_inr,
                  text: "₹${f.showPrice}",
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.car,
                  text: f.parking,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.star_fill,
                  text: f.floor,
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "Available on: ${f.availableDate}",
              style: TextStyle(
                fontSize: 12,
                fontFamily: "PoppinsBold",
                color:  Colors.white,
              ),
            ),

            if (f.fieldWarkarName.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                "${f.fieldWarkarName} • ${f.field_workar_number}",
                style: TextStyle(
                  fontSize: 12,
                  fontFamily: "PoppinsBold",
                  color: Colors.white ,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLivePropertyCard(LiveFlat f, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                View_Details(
                  id: f.propertyId,
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffFA8205),
            Color(0xff057DFA),
          ]),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 TITLE + BUY/RENT
            Row(
              children: [
                Icon(
                  PhosphorIcons.buildings,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    f.bhk,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f.buyRent,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                      fontFamily: "PoppinsBold",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 📍 LOCATION + TYPE
            Text(
              "Flat ${f.flatNumber}  •  ${f.locations}  • ${f.residenceCommercial}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// 🚆 METRO + FLOORS (CHIPS)
            Row(
              children: [
                if (f.metroDistance.isNotEmpty)
                  _miniChip(
                    icon: PhosphorIcons.train,
                    text: "${f.metroDistance} ${f.highwayDistance}",
                    isDark: isDark,
                  ),
                if (f.totalFloor.isNotEmpty) const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.star_fill,
                  text: "${f.totalFloor}",
                  isDark: isDark,
                ),
              ],
            ),


            /// 👤 FieldWorkar (OPTIONAL)
            if (f.fieldWarkarName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "${f.fieldWarkarName} • ${f.field_workar_number}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  String formatTimeRange12h(String timeRange) {
    try {
      final parts = timeRange.split('-');
      if (parts.length != 2) return timeRange;

      String formatSingle(String time) {
        final t = time.split(':');
        int hour = int.parse(t[0]);
        String minute = t[1];

        final isPM = hour >= 12;
        final hour12 = hour % 12 == 0 ? 12 : hour % 12;

        return "$hour12:$minute ${isPM ? 'PM' : 'AM'}";
      }

      return "${formatSingle(parts[0])} - ${formatSingle(parts[1])}";
    } catch (e) {
      return timeRange; // fallback
    }
  }
  Widget _buildWebsiteVisitCard(WebsiteVisit w, bool isDark) {
    return GestureDetector(
      onTap: () async {
        final Uri url = Uri.parse("https://theverify.in/details.html?id=${w.subid}");
        if (await canLaunchUrl(url)) {
          await launchUrl(url, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Could not open link."),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child:  Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xff50AFAE),
            Color(0xf978C53A),
          ]),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    w.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  formatTimeRange12h(w.time),
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),

              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(
                  PhosphorIcons.phone_call,
                  size: 16,
                  color: Colors.white70,
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: Text(
                    w.contactNo,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: () async {
                    final Uri callUri = Uri(
                      scheme: 'tel',
                      path: w.contactNo,
                    );

                    if (await canLaunchUrl(callUri)) {
                      await launchUrl(callUri);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Could not open dialer"),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      CupertinoIcons.phone_circle_fill,
                      size: 25,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            /// 👤 FieldWorkar (OPTIONAL)
            if (w.fieldWorkerName.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                "${w.fieldWorkerName} • ${w.fieldWorkerNumber}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'active':
        return Colors.blue;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
  String formatDate(String date) {
    try {
      final parsed = DateTime.parse(date);
      return DateFormat('dd MMM yyyy').format(parsed);
    } catch (e) {
      return date; // fallback if API date is invalid
    }
  }
  Widget _buildCalendarAddFlatCard(CalendarAddFlat f, bool isDark) {
    final statusColor = _getLiveUnliveColor(f.liveUnlive);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => underflat_futureproperty(
              id: f.propertyId.toString(),
              Subid: f.subId,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xffAFAF50),
            Color(0xff5050AF),
          ]),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🏠 DATE + STATUS
            Row(
              children: [
                Icon(
                  PhosphorIcons.house_line,
                  size: 16,
                  color: Colors.white,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    f.bhk,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color:Colors.white ,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f.liveUnlive,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontFamily: "PoppinsBold",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 📍 FLAT + LOCATION
            Text(
              "Flat ${f.flatNumber}  •  ${f.locations}  • ${f.residenceCommercial}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color:  Colors.white,
              ),
            ),

            const SizedBox(height: 8),

            /// 💰 PRICE + TYPE (CHIPS)
            Row(
              children: [
                _miniChip(
                  icon: PhosphorIcons.currency_inr,
                  text: "₹${f.showPrice}",
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.briefcase,
                  text: f.buyRent,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),

                _miniChip(
                  icon: PhosphorIcons.star_fill,
                  text: f.floor,
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 👤 CARETAKER (OPTIONAL)
            if (f.field_warkar_name.isNotEmpty) ...[
              Text(
                "${f.field_warkar_name} • ${f.field_workar_number}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,fontWeight: FontWeight.w700,
                  color: Colors.white ,
                ),
              ),
            ],

          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String text, bool isDark, int count) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: isDark ? Colors.indigo.shade800 : Colors.indigo.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              count.toString(),
              style: TextStyle(
                color: isDark ? Colors.white : Colors.indigo,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        children: [
          Icon(
            Icons.task_outlined,
            size: 80,
            color: isDark ? Colors.grey.shade600 : Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            "No tasks found for this date",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Select another date to view tasks",
            style: TextStyle(
              color: isDark ? Colors.white54 : Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0F0F10) : const Color(0xFFF4F5FA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        centerTitle: true,

        // 🔹 TITLE: Month + Year (tap to open picker)
        title: GestureDetector(
          onTap: () => _showMonthYearPicker(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${_monthName(_selectedMonth)} $_selectedYear",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 22),
            ],
          ),
        ),

        // 🔹 SUBTITLE (Selected Day)
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(28),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Text(
              _selectedDay != null
                  ? "Selected: ${_selectedDay!.day} ${_monthName(_selectedMonth).substring(0, 3)}"
                  : "",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white60 : Colors.grey.shade600,
              ),
            ),
          ),
        ),

        // 🔹 ACTIONS
        actions: [
          // Refresh
          IconButton(
            tooltip: "Refresh",
            icon: const Icon(PhosphorIcons.arrow_clockwise),
            onPressed: () => _fetchData(_selectedDay ?? _focusedDay),
          ),

          // Calendar View Switch
          PopupMenuButton<String>(
            tooltip: "Calendar View",
            onSelected: (value) {
              setState(() {
                _calendarView = value;
                _calendarFormat =
                value == "Month" ? CalendarFormat.month : CalendarFormat.week;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: "Month", child: Text("Month View")),
              PopupMenuItem(value: "Week", child: Text("Week View")),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Text(
                    _calendarView,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
       body:  RefreshIndicator(
        onRefresh: () async =>
            _fetchData(_selectedDay ?? _focusedDay),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20),
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade900 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child:TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2023),
                    lastDay: DateTime(2030),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    headerVisible: false,
                    daysOfWeekVisible: _calendarFormat == CalendarFormat.month,
                    rowHeight: _calendarFormat == CalendarFormat.week ? 80 : 48,

                    // 🔹 HEADER (Sun / Sat text)
                    daysOfWeekStyle: const DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                      weekendStyle: TextStyle(
                        color: Colors.red, // Sun & Sat header
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),

                    // 🔹 DATES COLOR LOGIC
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        // 🔴 Sunday date
                        if (day.weekday == DateTime.sunday) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        // ⚪ Saturday date
                        if (day.weekday == DateTime.saturday) {
                          return Center(
                            child: Text(
                              '${day.day}',
                              style:  TextStyle(
                                color:isDark? Colors.white:Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }

                        return null; // normal weekdays
                      },

                      todayBuilder: (context, day, focusedDay) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },

                      selectedBuilder: (context, day, focusedDay) {
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.indigo,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              '${day.day}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    onDaySelected: (selected, focused) {
                      setState(() {
                        _selectedDay = selected;
                        _focusedDay = focused;
                      });
                      _fetchData(selected);
                    },

                    onPageChanged: (focused) {
                      setState(() {
                        _focusedDay = focused;
                        _selectedMonth = focused.month;
                        _selectedYear = focused.year;
                      });
                    },
                  )

              ),
            ),
            // _buildOverviewCard(isDark),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(
                  child: CircularProgressIndicator(color: Colors.indigo),
                ),
              ),

            /// 🔹 WEBSITE VISITS
            if (_websiteVisits.isNotEmpty)
              _sectionTitle(
                  "Website Visit Requests", isDark, _websiteVisits.length),
            ..._websiteVisits.map(
                  (e) => _buildWebsiteVisitCard(e, isDark),
            ),

            /// 🔹 TENANT DEMANDS
            if (_tenantDemands.isNotEmpty)
              _sectionTitle(
                  "Tenant Demands", isDark, _tenantDemands.length),
            ..._tenantDemands.map(
                  (e) => _buildTenantDemandCard(e, isDark),
            ),

            /// 🔹 BOOKED TENANT VISITS
            if (_bookedTenantVisits.isNotEmpty)
              _sectionTitle(
                "Booked Tenant Visits",
                isDark,
                _bookedTenantVisits.length,
              ),
            ..._bookedTenantVisits.map(
                  (e) => _buildBookedTenantVisitCard(e, isDark),
            ),

            /// 🔹 AGREEMENTS
            if (_agreements.isNotEmpty)
              _sectionTitle("Agreements", isDark, _agreements.length),
            ..._agreements.map(
                  (e) => _buildAgreementCard(e, isDark),
            ),

            /// 🔹 PENDING
            if (_pendingAgreements.isNotEmpty)
              _sectionTitle(
                  "Pending Agreements", isDark, _pendingAgreements.length),
            ..._pendingAgreements.map(
                  (e) => _buildPendingAgreementCard(e, isDark),
            ),

            /// 🔹 ACCEPTED
            if (_acceptedAgreements.isNotEmpty)
              _sectionTitle(
                  "Accepted Agreements", isDark, _acceptedAgreements.length),
            ..._acceptedAgreements.map(
                  (e) => _buildAcceptedAgreementCard(e, isDark),
            ),

            /// 🔹 CALLING REMINDERS
            if (_callingReminders.isNotEmpty)
              _sectionTitle(
                "Building Call Reminders",
                isDark,
                _callingReminders.length,
              ),
            ..._callingReminders.map(
                  (e) => _buildCallingReminderCard(e, isDark),
            ),

            /// 🔹 FUTURE PROPERTIES
            if (_futureProperties.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children:[
                  _sectionTitle(
                    "New Building", isDark, _futureProperties.length),
                  GestureDetector(
                    onTap: _openBuildingCalculator,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark ? Colors.white24 : Colors.grey.shade300,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Suggestion",
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: "PoppinsMedium",
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white : Colors.indigo,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Icon(
                            Icons.lightbulb_outline,
                            size: 16,
                            color: Colors.amber,
                          ),
                        ],
                      ),
                    ),
                  )
             ] ),
            ..._futureProperties.map(
                  (e) => _buildFuturePropertyCard(e, isDark),
            ),

            /// 🔹 UPCOMING FLATS
            if (_upcomingFlats.isNotEmpty)
              _sectionTitle(
                "Upcoming Flats",
                isDark,
                _upcomingFlats.length,
              ),
            ..._upcomingFlats.map(
                  (e) => _buildUpcomingFlatCard(e, isDark),
            ),

            /// 🔹 Live PROPERTIES
            if (_liveProperties.isNotEmpty)
              _sectionTitle(
                  "Live Properties", isDark, _liveProperties.length),
            ..._liveProperties.map(
                  (e) => _buildLivePropertyCard(e, isDark),
            ),


            /// 🔹 ADD FLATS
            if (_calendarAddFlats.isNotEmpty)
              _sectionTitle(
                  "Add Flats", isDark, _calendarAddFlats.length),
            ..._calendarAddFlats.map(
                  (e) => _buildCalendarAddFlatCard(e, isDark),
            ),



            if (!_isLoading &&
                _agreements.isEmpty &&
                _futureProperties.isEmpty &&
                _acceptedAgreements.isEmpty &&
                _pendingAgreements.isEmpty &&
                _bookedTenantVisits.isEmpty &&
                _futureProperties.isEmpty &&
                _addFlats.isEmpty &&
                _callingReminders.isEmpty &&
                _websiteVisits.isEmpty)
              _emptyState(isDark),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

}