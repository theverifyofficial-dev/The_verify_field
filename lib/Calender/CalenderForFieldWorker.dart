// calendar_task_page.dart
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Administrator/Admin_future _property/Admin_under_flats.dart';
import '../Administrator/Admin_future _property/Future_Property_Details.dart';
import '../Administrator/Administator_Agreement/Admin_Agreement_details.dart';

import 'dart:convert';

import '../Future_Property_OwnerDetails_section/New_Update/under_flats_infutureproperty.dart';

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

  AgreementTask({
    required this.id,
    required this.ownerName,
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
/// -------- BUILDING MODEL (UPDATED FOR NEW API) --------
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
  final String contactNo;
  final String message;
  final String date;
  final String time;
  final int subid;

  WebsiteVisit({
    required this.id,
    required this.name,
    required this.contactNo,
    required this.message,
    required this.date,
    required this.time,
    required this.subid,
  });

  factory WebsiteVisit.fromJson(Map<String, dynamic> json) {
    return WebsiteVisit(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      contactNo: json['contact_no'] ?? '',
      message: json['message'] ?? '',
      date: json['dates'] ?? '',
      time: json['times'] ?? '',
      subid: json['subid'] ?? 0,
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
      shiftingDate: json['shifting_date'] != null
          ? DateTime.tryParse(json['shifting_date'])
          : null,
      maintenance: json['maintaince'] ?? '',

      ownerAadharFront: json['owner_aadhar_front'],
      ownerAadharBack: json['owner_aadhar_back'],
      tenantAadharFront: json['tenant_aadhar_front'],
      tenantAadharBack: json['tenant_aadhar_back'],
      tenantImage: json['tenant_image'],

      installmentSecurityAmount: json['installment_security_amount'] ?? '',
      currentDate: json['current_dates'] != null
          ? DateTime.tryParse(json['current_dates'])
          : null,

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
      shiftingDate: json['shifting_date'] != null
          ? DateTime.tryParse(json['shifting_date'])
          : null,
      maintenance: json['maintaince'] ?? '',

      ownerAadharFront: json['owner_aadhar_front'],
      ownerAadharBack: json['owner_aadhar_back'],
      tenantAadharFront: json['tenant_aadhar_front'],
      tenantAadharBack: json['tenant_aadhar_back'],
      tenantImage: json['tenant_image'],

      installmentSecurityAmount:
      json['installment_security_amount'] ?? '',
      currentDate: json['current_dates'] != null
          ? DateTime.tryParse(json['current_dates'])
          : null,

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

/// -------- MAIN PAGE --------
class CalendarTaskPage extends StatefulWidget {
  const CalendarTaskPage({super.key});

  @override
  State<CalendarTaskPage> createState() => _CalendarTaskPageState();
}

class _CalendarTaskPageState extends State<CalendarTaskPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  bool _isLoading = false;
  List<AgreementTask> _agreements = [];
  List<FutureProperty> _futureProperties = [];
  List<AddFlat> _addFlats = [];
  List<TenantDemand> _tenantDemands = [];

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

    // fetch after first frame so inherited widgets are available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData(_focusedDay);
      loadUserName();
    });
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

      // ✅ Handle FutureProperty API safely
      if (responses[1].statusCode == 200 && responses[1].body.isNotEmpty) {
        try {
          f = FuturePropertyResponse.fromRawJson(responses[1].body);
        } catch (e) {
          debugPrint("FutureProperty parse error: $e");
          f = FuturePropertyResponse(status: "error", data: []);
        }
      } else {
        debugPrint("FutureProperty API failed (${responses[1].statusCode})");
        f = FuturePropertyResponse(status: "error", data: []);
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

    else {
        debugPrint("Accept API failed (${responses[4].statusCode})");
        p = PendingAgreementResponse(status: "error", data: []);
      }

      if (!mounted) return;

      setState(() {
        _agreements = a?.data ?? [];
        _pendingAgreements = p?.data ?? [];
        _tenantDemands = td?.data ?? [];
        _acceptedAgreements = aa?.data ?? [];
        _futureProperties = f?.data ?? [];
        _websiteVisits = w?.data ?? [];
        _isLoading = false;
      });

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

// Helper method for live/unlive status color
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
  Widget _buildAcceptedAgreementCard(AcceptedAgreement t, bool isDark) {
    final Color statusColor = Colors.green;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                AdminAgreementDetails(agreementId: t.id.toString()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
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
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Accepted",
                    style: TextStyle(
                      color: statusColor,
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
                color: isDark ? Colors.white70 : Colors.grey.shade800,
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
                  text: "${t.floor}F",
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 📍 ADDRESS
            Row(
              children: [
                Icon(
                  PhosphorIcons.map_pin,
                  size: 14,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    t.rentedAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      isDark ? Colors.white60 : Colors.grey.shade700,
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
  Widget _buildTenantDemandCard(TenantDemand t, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
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
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
              ),
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Demand",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
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
              color: isDark ? Colors.white70 : Colors.grey.shade800,
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
                color: isDark ? Colors.white60 : Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
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
                AdminAgreementDetails(agreementId: t.id.toString()),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
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
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    t.status,
                    style: TextStyle(
                      color: statusColor,
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
                color: isDark ? Colors.white70 : Colors.grey.shade800,
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
                  text: "${t.floor}F",
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 📍 ADDRESS
            Row(
              children: [
                Icon(
                  PhosphorIcons.map_pin,
                  size: 14,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    t.rentedAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      isDark ? Colors.white60 : Colors.grey.shade700,
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
            builder: (_) => AdminAgreementDetails(
              agreementId: t.id.toString(),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
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
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      color: statusColor,
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
                color: isDark ? Colors.white70 : Colors.grey.shade800,
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
                  text: "${t.floor}F",
                  isDark: isDark,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// 📍 ADDRESS
            Row(
              children: [
                Icon(
                  PhosphorIcons.map_pin,
                  size: 14,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    t.rentedAddress,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                      isDark ? Colors.white60 : Colors.grey.shade700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
  // Enhanced Future Property Card
  Widget _buildFuturePropertyCard(FutureProperty f, bool isDark) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                Administater_Future_Property_details(
                  buildingId: f.id.toString(),
                ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
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
                  color: Colors.blue,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    f.propertyName,
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
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f.buyRent,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 📍 LOCATION + TYPE
            Text(
              "${f.place}  •  ${f.residenceType}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade800,
              ),
            ),

            const SizedBox(height: 8),

            /// 🚆 METRO + FLOORS (CHIPS)
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
                  text: "${f.totalFloor} Floors",
                  isDark: isDark,
                ),
              ],
            ),

            /// 👤 CARETAKER (OPTIONAL)
            if (f.caretakerName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "${f.caretakerName} • ${f.caretakerNumber}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color:
                  isDark ? Colors.white60 : Colors.grey.shade700,
                ),
              ),
            ],

            /// 🏢 FACILITY (OPTIONAL)
            if (f.facility.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                f.facility,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color:
                  isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper widget for info rows
  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark ? Colors.white54 : Colors.grey.shade600,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white54 : Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value.isNotEmpty ? value : "N/A",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white70 : Colors.grey.shade800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
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
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
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
                      color: isDark ? Colors.white : Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                ),
                Text(
                  w.time,
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "Contact: ${w.contactNo}",
              style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey.shade800),
            ),
            const SizedBox(height: 4),
            Text(
              w.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  color: isDark ? Colors.white60 : Colors.grey.shade700),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date: ${w.date}",
                  style: TextStyle(
                      color: isDark ? Colors.white54 : Colors.grey.shade600,
                      fontSize: 12),
                ),
                const Icon(Icons.calendar_month, size: 16, color: Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper widget for detail chips
  Widget _buildDetailChip({
    required IconData icon,
    required String text,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
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
                  color: Colors.indigo,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    formatDate(f.datesForRightAvailable),
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
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    f.liveUnlive,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 📍 FLAT + LOCATION
            Text(
              "Flat ${f.flatNumber}  •  ${f.locations}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade800,
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
              ],
            ),

            const SizedBox(height: 8),

            /// 🧱 BHK / FLOOR / USE
            Row(
              children: [
                _miniChip(
                  icon: PhosphorIcons.cube,
                  text: f.bhk,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.star_fill,
                  text: f.floor,
                  isDark: isDark,
                ),
                const SizedBox(width: 6),
                _miniChip(
                  icon: PhosphorIcons.buildings,
                  text: f.residenceCommercial,
                  isDark: isDark,
                ),
              ],
            ),

            /// 👤 CARETAKER (OPTIONAL)
            if (f.careTakerName.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                "${f.careTakerName} • ${f.careTakerNumber}",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color:
                  isDark ? Colors.white60 : Colors.grey.shade700,
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
        centerTitle: true,
        title: GestureDetector(
          onTap: () => _showMonthYearPicker(context),
          child: Row(
            children: [
              Text(
                "${_monthName(_selectedMonth)} ${_selectedYear}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.grey.shade900,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_drop_down,
                color: isDark ? Colors.white54 : Colors.grey.shade600,
              ),
            ],
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.white,
        foregroundColor: isDark ? Colors.white : Colors.black,
        elevation: 0.5,
        actions: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0, 0.3), // slide slightly upward
                end: Offset.zero,
              ).animate(animation);
              return SlideTransition(
                position: offsetAnimation,
                child: FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              );
            },
            child: Text(
              "${_selectedDay?.day ?? _focusedDay.day}, ${_monthName(_selectedMonth).substring(0, 3)}",
              key: ValueKey("${_selectedDay?.day ?? _focusedDay.day}-${_selectedMonth}"),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ) ,
          IconButton(
            icon: const Icon(PhosphorIcons.arrow_clockwise),
            onPressed: () => _fetchData(_selectedDay ?? _focusedDay),
            tooltip: "Refresh",
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              setState(() {
                _calendarView = value;
                _calendarFormat =
                value == "Week" ? CalendarFormat.week : CalendarFormat.month;
              });
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: "Month", child: Text("Month")),
              PopupMenuItem(value: "Week", child: Text("Week")),
            ],
            child: Row(
              children: [
                Text(
                  _calendarView,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const Icon(Icons.arrow_drop_down),
                const SizedBox(width: 8),
              ],
            ),
          ),

        ],
      ),
      body: Column(
        children: [
          // Full Calendar Section
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey.shade900 : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4)
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 10),
              child: Column(
                children: [
                  // Full Month Calendar
                  TableCalendar(
                    focusedDay: _focusedDay,
                    firstDay: DateTime(2023),
                    lastDay: DateTime(2030),
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    calendarFormat: _calendarFormat,
                    headerVisible: false,
                    daysOfWeekVisible: _calendarFormat == CalendarFormat.month,
                    rowHeight: _calendarFormat == CalendarFormat.week ? 80 : 48,

                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekdayStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.grey.shade100 : Colors.grey[700],
                      ),
                      weekendStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.red.shade400,
                      ),
                    ), calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.orange.shade400,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.indigo.shade400,
                      shape: BoxShape.circle,
                    ), defaultTextStyle: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.white : Colors.grey.shade900,
                  ),
                    weekendTextStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade400,
                    ),
                  ),
                    calendarBuilders: CalendarBuilders(
                      defaultBuilder: (context, day, focusedDay) {
                        return _calendarFormat == CalendarFormat.week
                            ? _weekDayTile(day, false)
                            : null;
                      },

                      selectedBuilder: (context, day, focusedDay) {
                        return _calendarFormat == CalendarFormat.week
                            ? _weekDayTile(day, true)
                            : null;
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
                      _focusedDay = focused;
                    },
                  ),
                ],
              ),
            ),
          ),
          // Tasks List Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Colors.indigo))
                : RefreshIndicator(
              onRefresh: () async => _fetchData(_selectedDay ?? _focusedDay),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 16),
                children: [
                  if (_agreements.isNotEmpty)
                    _sectionTitle("Agreements", isDark, _agreements.length),
                  ..._agreements.map((a) => _buildAgreementCard(a, isDark)),
                  if (_pendingAgreements.isNotEmpty)
                    _sectionTitle("Pending Agreements", isDark, _pendingAgreements.length),

                  ..._pendingAgreements.map(
                        (p) => _buildPendingAgreementCard(p, isDark),
                  ),
                  if (_acceptedAgreements.isNotEmpty)
                    _sectionTitle("Accepted Agreements", isDark, _acceptedAgreements.length),

                  ..._acceptedAgreements.map(
                        (a) => _buildAcceptedAgreementCard(a, isDark),
                  ),
                  if (_tenantDemands.isNotEmpty)
                    _sectionTitle("Tenant Demands", isDark, _tenantDemands.length),

                  ..._tenantDemands.map(
                        (t) => _buildTenantDemandCard(t, isDark),
                  ),

                  if (_futureProperties.isNotEmpty)
                    _sectionTitle("Future Properties", isDark, _futureProperties.length),
                  ..._futureProperties.map((f) => _buildFuturePropertyCard(f, isDark)),

                  if (_websiteVisits.isNotEmpty)
                    _sectionTitle("Website Visit Requests", isDark,_websiteVisits.length),
                  ..._websiteVisits.map((w) => _buildWebsiteVisitCard(w, isDark)),

                  if (_calendarAddFlats.isNotEmpty)
                    _sectionTitle("Add Flats", isDark, _calendarAddFlats.length),
                  ..._calendarAddFlats.map(
                        (f) => _buildCalendarAddFlatCard(f, isDark),
                  ),

                  if (_agreements.isEmpty &&
                      _futureProperties.isEmpty &&
                      _calendarAddFlats.isEmpty &&
                      _websiteVisits.isEmpty)
                    _emptyState(isDark),




                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _weekDayTile(DateTime day, bool isSelected) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected
            ? Colors.blue
            : (isDark ? Colors.transparent : Colors.transparent),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _weekDayName(day),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.6, // 🔥 crisp text
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.grey.shade400 : Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            day.day.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isSelected
                  ? Colors.white
                  : (isDark ? Colors.white : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
  String _weekDayName(DateTime date) {
    const days = ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT'];
    return days[date.weekday % 7];
  }

}